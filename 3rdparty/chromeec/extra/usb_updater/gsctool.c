/*
 * Copyright 2015 The Chromium OS Authors. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

#include <asm/byteorder.h>
#include <ctype.h>
#include <endian.h>
#include <errno.h>
#include <fcntl.h>
#include <getopt.h>
#include <libusb.h>
#include <openssl/sha.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <termios.h>
#include <unistd.h>

#include "config.h"

#include "ccd_config.h"
#include "compile_time_macros.h"
#include "generated_version.h"
#include "gsctool.h"
#include "misc_util.h"
#include "signed_header.h"
#include "tpm_vendor_cmds.h"
#include "upgrade_fw.h"
#include "usb_descriptor.h"
#include "verify_ro.h"

#ifdef DEBUG
#define debug printf
#else
#define debug(fmt, args...)
#endif

/*
 * This file contains the source code of a Linux application used to update
 * CR50 device firmware.
 *
 * The CR50 firmware image consists of multiple sections, of interest to this
 * app are the RO and RW code sections, two of each. When firmware update
 * session is established, the CR50 device reports locations of backup RW and RO
 * sections (those not used by the device at the time of transfer).
 *
 * Based on this information this app carves out the appropriate sections form
 * the full CR50 firmware binary image and sends them to the device for
 * programming into flash. Once the new sections are programmed and the device
 * is restarted, the new RO and RW are used if they pass verification and are
 * logically newer than the existing sections.
 *
 * There are two ways to communicate with the CR50 device: USB and /dev/tpm0
 * (when this app is running on a chromebook with the CR50 device). Originally
 * different protocols were used to communicate over different channels,
 * starting with version 3 the same protocol is used.
 *
 * This app provides backwards compatibility to ensure that earlier CR50
 * devices still can be updated.
 *
 *
 * The host (either a local AP or a workstation) is the master of the firmware
 * update protocol, it sends data to the cr50 device, which proceeses it and
 * responds.
 *
 * The encapsultation format is different between the /dev/tpm0 and USB cases:
 *
 *   4 bytes      4 bytes         4 bytes               variable size
 * +-----------+--------------+---------------+----------~~--------------+
 * + total size| block digest |  dest address |           data           |
 * +-----------+--------------+---------------+----------~~--------------+
 *  \           \                                                       /
 *   \           \                                                     /
 *    \           +----- FW update PDU sent over /dev/tpm0 -----------+
 *     \                                                             /
 *      +--------- USB frame, requires total size field ------------+
 *
 * The update protocol data unints (PDUs) are passed over /dev/tpm0, the
 * encapsulation includes integritiy verification and destination address of
 * the data (more of this later). /dev/tpm0 transactions pretty much do not
 * have size limits, whereas the USB data is sent in chunks of the size
 * determined when the USB connestion is set up. This is why USB requires an
 * additional encapsulation into frames to communicate the PDU size to the
 * client side so that the PDU can be reassembled before passing to the
 * programming function.
 *
 * In general, the protocol consists of two phases: connection establishment
 * and actual image transfer.
 *
 * The very first PDU of the transfer session is used to establish the
 * connection. The first PDU does not have any data, and the dest. address
 * field is set to zero. Receiving such a PDU signals the programming function
 * that the host intends to transfer a new image.
 *
 * The response to the first PDU varies depending on the protocol version.
 *
 * Note that protocol versions before 5 are described here for completeness,
 * but are not supported any more by this utility.
 *
 * Version 1 is used over /dev/tpm0. The response is either 4 or 1 bytes in
 * size. The 4 byte response is the *base address* of the backup RW section,
 * no support for RO updates. The one byte response is an error indication,
 * possibly reporting flash erase failure, command format error, etc.
 *
 * Version 2 is used over USB. The response is 8 bytes in size. The first four
 * bytes are either the *base address* of the backup RW section (still no RO
 * updates), or an error code, the same as in Version 1. The second 4 bytes
 * are the protocol version number (set to 2).
 *
 * All versions above 2 behave the same over /dev/tpm0 and USB.
 *
 * Version 3 response is 16 bytes in size. The first 4 bytes are the error code
 * the second 4 bytes are the protocol version (set to 3) and then 4 byte
 * *offset* of the RO section followed by the 4 byte *offset* of the RW section.
 *
 * Version 4 response in addition to version 3 provides header revision fields
 * for active RO and RW images running on the target.
 *
 * Once the connection is established, the image to be programmed into flash
 * is transferred to the CR50 in 1K PDUs. In versions 1 and 2 the address in
 * the header is the absolute address to place the block to, in version 3 and
 * later it is the offset into the flash.
 *
 * Protocol version 5 includes RO and RW key ID information into the first PDU
 * response. The key ID could be used to tell between prod and dev signing
 * modes, among other things.
 *
 * Protocol version 6 does not change the format of the first PDU response,
 * but it indicates the target's ablitiy to channel TPM vendor commands
 * through USB connection.
 *
 * When channeling TPM vendor commands the USB frame looks as follows:
 *
 *   4 bytes      4 bytes         4 bytes       2 bytes      variable size
 * +-----------+--------------+---------------+-----------+------~~~-------+
 * + total size| block digest |    EXT_CMD    | Vend. sub.|      data      |
 * +-----------+--------------+---------------+-----------+------~~~-------+
 *
 * Where 'Vend. sub' is the vendor subcommand, and data field is subcommand
 * dependent. The target tells between update PDUs and encapsulated vendor
 * subcommands by looking at the EXT_CMD value - it is set to 0xbaccd00a and
 * as such is guaranteed not to be a valid update PDU destination address.
 *
 * The vendor command response size is not fixed, it is subcommand dependent.
 *
 * The CR50 device responds to each update PDU with a confirmation which is 4
 * bytes in size in protocol version 2, and 1 byte in size in all other
 * versions. Zero value means success, non zero value is the error code
 * reported by CR50.
 *
 * Again, vendor command responses are subcommand specific.
 */

/* Look for Cr50 FW update interface */
#define VID USB_VID_GOOGLE
#define PID CONFIG_USB_PID
#define SUBCLASS USB_SUBCLASS_GOOGLE_CR50
#define PROTOCOL USB_PROTOCOL_GOOGLE_CR50_NON_HC_FW_UPDATE

/*
 * Need to create an entire TPM PDU when upgrading over /dev/tpm0 and need to
 * have space to prepare the entire PDU.
 */
struct upgrade_pkt {
	__be16	tag;
	__be32	length;
	__be32	ordinal;
	__be16	subcmd;
	union {
		/*
		 * Upgrade PDUs as opposed to all other vendor and extension
		 * commands include two additional fields in the header.
		 */
		struct {
			__be32	digest;
			__be32	address;
			char data[0];
		} upgrade;
		struct {
			char data[0];
		} command;
	};
} __packed;


/*
 * This by far exceeds the largest vendor command response size we ever
 * expect.
 */
#define MAX_BUF_SIZE	500

static int verbose_mode;
static uint32_t protocol_version;
static char *progname;
static char *short_opts = "abcd:fhIikO:oPprstUuVv";
static const struct option long_opts[] = {
	/* name    hasarg *flag val */
	{"any",		0,   NULL, 'a'},
	{"binvers",	0,   NULL, 'b'},
	{"board_id",    2,   NULL, 'i'},
	{"ccd_info",    0,   NULL, 'I'},
	{"ccd_lock",    0,   NULL, 'k'},
	{"ccd_open",    0,   NULL, 'o'},
	{"ccd_unlock",  0,   NULL, 'U'},
	{"corrupt",	0,   NULL, 'c'},
	{"device",	1,   NULL, 'd'},
	{"fwver",	0,   NULL, 'f'},
	{"help",	0,   NULL, 'h'},
	{"openbox_rma", 1,   NULL, 'O'},
	{"password",	0,   NULL, 'P'},
	{"post_reset",	0,   NULL, 'p'},
	{"rma_auth",	2,   NULL, 'r'},
	{"systemdev",	0,   NULL, 's'},
	{"trunks_send",	0,   NULL, 't'},
	{"verbose",	0,   NULL, 'V'},
	{"version",	0,   NULL, 'v'},
	{"upstart",	0,   NULL, 'u'},
	{},
};



/* Helpers to convert between binary and hex ascii and back. */
static char to_hexascii(uint8_t c)
{
	if (c <= 9)
		return '0' + c;
	return 'a' + c - 10;
}

static int from_hexascii(char c)
{
	/* convert to lower case. */
	c = tolower(c);

	if (c < '0' || c > 'f' || ((c > '9') && (c < 'a')))
		return -1; /* Not an ascii character. */

	if (c <= '9')
		return c - '0';

	return c - 'a' + 10;
}

/* Functions to communicate with the TPM over the trunks_send --raw channel. */

/* File handle to share between write and read sides. */
static FILE *tpm_output;
static int ts_write(const void *out, size_t len)
{
	const char *cmd_head = "PATH=\"${PATH}:/usr/sbin\" trunks_send --raw ";
	size_t head_size = strlen(cmd_head);
	char full_command[head_size + 2 * len + 1];
	size_t i;

	strcpy(full_command, cmd_head);
	/*
	 * Need to convert binary input into hex ascii output to pass to the
	 * trunks_send command.
	 */
	for (i = 0; i < len; i++) {
		uint8_t c = ((const uint8_t *)out)[i];

		full_command[head_size + 2 * i] = to_hexascii(c >> 4);
		full_command[head_size + 2 * i + 1] = to_hexascii(c & 0xf);
	}

	/* Make it a proper zero terminated string. */
	full_command[sizeof(full_command) - 1] = 0;
	debug("cmd: %s\n", full_command);
	tpm_output = popen(full_command, "r");
	if (tpm_output)
		return len;

	fprintf(stderr, "Error: failed to launch trunks_send --raw\n");
	return -1;
}

static int ts_read(void *buf, size_t max_rx_size)
{
	int i;
	int pclose_rv;
	int rv;
	char response[max_rx_size * 2];

	if (!tpm_output) {
		fprintf(stderr, "Error: attempt to read empty output\n");
		return -1;
	}

	rv = fread(response, 1, sizeof(response), tpm_output);
	if (rv > 0)
		rv -= 1; /* Discard the \n character added by trunks_send. */

	debug("response of size %d, max rx size %zd: %s\n",
	      rv, max_rx_size, response);

	pclose_rv = pclose(tpm_output);
	if (pclose_rv < 0) {
		fprintf(stderr,
			"Error: pclose failed: error %d (%s)\n",
			errno, strerror(errno));
		return -1;
	}

	tpm_output = NULL;

	if (rv & 1) {
		fprintf(stderr,
			"Error: trunks_send returned odd number of bytes: %s\n",
		response);
		return -1;
	}

	for (i = 0; i < rv/2; i++) {
		uint8_t byte;
		char c;
		int nibble;

		c = response[2 * i];
		nibble = from_hexascii(c);
		if (nibble < 0) {
			fprintf(stderr,	"Error: "
				"trunks_send returned non hex character %c\n",
				c);
			return -1;
		}
		byte = nibble << 4;

		c = response[2 * i + 1];
		nibble = from_hexascii(c);
		if (nibble < 0) {
			fprintf(stderr,	"Error: "
				"trunks_send returned non hex character %c\n",
				c);
			return -1;
		}
		byte |= nibble;

		((uint8_t *)buf)[i] = byte;
	}

	return rv/2;
}

/*
 * Prepare and transfer a block to either to /dev/tpm0 or through trunks_send
 * --raw, get a reply.
 */
static int tpm_send_pkt(struct transfer_descriptor *td, unsigned int digest,
			unsigned int addr, const void *data, int size,
			void *response, size_t *response_size,
			uint16_t subcmd)
{
	/* Used by transfer to /dev/tpm0 */
	static uint8_t outbuf[MAX_BUF_SIZE];
	struct upgrade_pkt *out = (struct upgrade_pkt *)outbuf;
	int len, done;
	int response_offset = offsetof(struct upgrade_pkt, command.data);
	void *payload;
	size_t header_size;
	uint32_t rv;
	const size_t rx_size = sizeof(outbuf);

	debug("%s: sending to %#x %d bytes\n", __func__, addr, size);

	out->tag = htobe16(0x8001);
	out->subcmd = htobe16(subcmd);

	if (subcmd <= LAST_EXTENSION_COMMAND)
		out->ordinal = htobe32(CONFIG_EXTENSION_COMMAND);
	else
		out->ordinal = htobe32(TPM_CC_VENDOR_BIT_MASK);

	if (subcmd == EXTENSION_FW_UPGRADE) {
		/* FW Upgrade PDU header includes a couple of extra fields. */
		out->upgrade.digest = digest;
		out->upgrade.address = htobe32(addr);
		header_size = offsetof(struct upgrade_pkt, upgrade.data);
	} else {
		header_size = offsetof(struct upgrade_pkt, command.data);
	}

	payload = outbuf + header_size;
	len = size + header_size;

	out->length = htobe32(len);
	memcpy(payload, data, size);
#ifdef DEBUG
	{
		int i;

		debug("Writing %d bytes to TPM at %x\n", len, addr);
		for (i = 0; i < 20; i++)
			debug("%2.2x ", outbuf[i]);
		debug("\n");
	}
#endif
	switch (td->ep_type) {
	case dev_xfer:
		done = write(td->tpm_fd, out, len);
		break;
	case ts_xfer:
		done = ts_write(out, len);
		break;
	default:
		fprintf(stderr, "Error: %s:%d: unknown transfer type %d\n",
			__func__, __LINE__, td->ep_type);
		return -1;
	}

	if (done < 0) {
		perror("Could not write to TPM");
		return -1;
	} else if (done != len) {
		fprintf(stderr, "Error: Wrote %d bytes, expected to write %d\n",
			done, len);
		return -1;
	}

	switch (td->ep_type) {
	case dev_xfer: {
		int read_count;

		len = 0;
		do {
			uint8_t *rx_buf = outbuf + len;
			size_t rx_to_go = rx_size - len;

			read_count = read(td->tpm_fd, rx_buf, rx_to_go);

			len += read_count;
		} while (read_count);
		break;
	}
	case ts_xfer:
		len = ts_read(outbuf, rx_size);
		break;
	default:
		/*
		 * This sure will never happen, type is verifed in the
		 * previous switch statement.
		 */
		len = -1;
		break;
	}

#ifdef DEBUG
	debug("Read %d bytes from TPM\n", len);
	if (len > 0) {
		int i;

		for (i = 0; i < len; i++)
			debug("%2.2x ", outbuf[i]);
		debug("\n");
	}
#endif
	len = len - response_offset;
	if (len < 0) {
		fprintf(stderr, "Problems reading from TPM, got %d bytes\n",
			len + response_offset);
		return -1;
	}

	if (response && response_size) {
		len = MIN(len, *response_size);
		memcpy(response, outbuf + response_offset, len);
		*response_size = len;
	}

	/* Return the actual return code from the TPM response header. */
	memcpy(&rv, &((struct upgrade_pkt *)outbuf)->ordinal, sizeof(rv));
	rv = be32toh(rv);

	/* Clear out vendor command return value offset.*/
	if ((rv & VENDOR_RC_ERR) == VENDOR_RC_ERR)
		rv &= ~VENDOR_RC_ERR;

	return rv;
}

/* Release USB device and return error to the OS. */
static void shut_down(struct usb_endpoint *uep)
{
	libusb_close(uep->devh);
	libusb_exit(NULL);
	exit(update_error);
}

static void usage(int errs)
{
	printf("\nUsage: %s [options] [<binary image>]\n"
	       "\n"
	       "This utility allows to update Cr50 RW firmware, configure\n"
	       "various aspects of Cr50 operation, analyze Cr50 binary\n"
	       "images, etc.\n"
	       "The required argument is the file name of a full RO+RW\n"
	       "binary image.\n"
	       "A typical Chromebook use would exepect -s -t options\n"
	       "included in the command line.\n"
	       "\n"
	       "Options:\n"
	       "\n"
	       "  -a,--any                 Try any interfaces to find Cr50"
	       " (-d, -s, -t are all ignored)\n"
	       "  -b,--binvers             Report versions of Cr50 image's "
				"RW and RO headers, do not update\n"
	       "  -c,--corrupt             Corrupt the inactive rw\n"
	       "  -d,--device  VID:PID     USB device (default %04x:%04x)\n"
	       "  -f,--fwver               "
	       "Report running Cr50 firmware versions\n"
	       "  -h,--help                Show this message\n"
	       "  -I,--ccd_info            Get information about CCD state\n"
	       "  -i,--board_id [ID[:FLAGS]]\n"
	       "                           Get or set Info1 board ID fields\n"
	       "                           ID could be 32 bit hex or 4 "
	       "character string.\n"
	       "  -k,--ccd_lock            Lock CCD\n"
	       "  -O,--openbox_rma <desc_file>\n"
	       "                           Verify other device's RO integrity\n"
	       "                           using information provided in "
	       "<desc file>\n"
	       "  -o,--ccd_open            Start CCD open sequence\n"
	       "  -P,--password <password>\n"
	       "                           Set or clear CCD password. Use\n"
	       "                           'clear:<cur password>' to clear it\n"
	       "  -p,--post_reset          Request post reset after transfer\n"
	       "  -r,--rma_auth [[auth_code|\"disable\"]\n"
	       "                           Request RMA challenge, process "
	       "RMA authentication code or disable RMA state\n"
	       "  -s,--systemdev           Use /dev/tpm0 (-d is ignored)\n"
	       "  -t,--trunks_send         Use `trunks_send --raw' "
	       "(-d is ignored)\n"
	       "  -U,--ccd_unlock          Start CCD unlock sequence\n"
	       "  -u,--upstart             "
			"Upstart mode (strict header checks)\n"
	       "  -V,--verbose             Enable debug messages\n"
	       "  -v,--version             Report this utility version\n"
	       "\n", progname, VID, PID);

	exit(errs ? update_error : noop);
}

/* Read file into buffer */
static uint8_t *get_file_or_die(const char *filename, size_t *len_ptr)
{
	FILE *fp;
	struct stat st;
	uint8_t *data;
	size_t len;

	fp = fopen(filename, "rb");
	if (!fp) {
		perror(filename);
		exit(update_error);
	}
	if (fstat(fileno(fp), &st)) {
		perror("stat");
		exit(update_error);
	}

	len = st.st_size;

	data = malloc(len);
	if (!data) {
		perror("malloc");
		exit(update_error);
	}

	if (1 != fread(data, st.st_size, 1, fp)) {
		perror("fread");
		exit(update_error);
	}

	fclose(fp);

	*len_ptr = len;
	return data;
}

#define USB_ERROR(m, r) \
	fprintf(stderr, "%s:%d, %s returned %d (%s)\n", __FILE__, __LINE__, \
		m, r, libusb_strerror(r))

/*
 * Actual USB transfer function, the 'allow_less' flag indicates that the
 * valid response could be shortef than allotted memory, the 'rxed_count'
 * pointer, if provided along with 'allow_less' lets the caller know how mavy
 * bytes were received.
 */
static void do_xfer(struct usb_endpoint *uep, void *outbuf, int outlen,
		    void *inbuf, int inlen, int allow_less,
		    size_t *rxed_count)
{

	int r, actual;

	/* Send data out */
	if (outbuf && outlen) {
		actual = 0;
		r = libusb_bulk_transfer(uep->devh, uep->ep_num,
					 outbuf, outlen,
					 &actual, 1000);
		if (r < 0) {
			USB_ERROR("libusb_bulk_transfer", r);
			exit(update_error);
		}
		if (actual != outlen) {
			fprintf(stderr, "%s:%d, only sent %d/%d bytes\n",
				__FILE__, __LINE__, actual, outlen);
			shut_down(uep);
		}
	}

	/* Read reply back */
	if (inbuf && inlen) {

		actual = 0;
		r = libusb_bulk_transfer(uep->devh, uep->ep_num | 0x80,
					 inbuf, inlen,
					 &actual, 1000);
		if (r < 0) {
			USB_ERROR("libusb_bulk_transfer", r);
			exit(update_error);
		}
		if ((actual != inlen) && !allow_less) {
			fprintf(stderr, "%s:%d, only received %d/%d bytes\n",
				__FILE__, __LINE__, actual, inlen);
			shut_down(uep);
		}

		if (rxed_count)
			*rxed_count = actual;
	}
}

static void xfer(struct usb_endpoint *uep, void *outbuf,
		 size_t outlen, void *inbuf, size_t inlen)
{
	do_xfer(uep, outbuf, outlen, inbuf, inlen, 0, NULL);
}

/* Return 0 on error, since it's never gonna be EP 0 */
static int find_endpoint(const struct libusb_interface_descriptor *iface,
			 struct usb_endpoint *uep)
{
	const struct libusb_endpoint_descriptor *ep;

	if (iface->bInterfaceClass == 255 &&
	    iface->bInterfaceSubClass == SUBCLASS &&
	    iface->bInterfaceProtocol == PROTOCOL &&
	    iface->bNumEndpoints) {
		ep = &iface->endpoint[0];
		uep->ep_num = ep->bEndpointAddress & 0x7f;
		uep->chunk_len = ep->wMaxPacketSize;
		return 1;
	}

	return 0;
}

/* Return -1 on error */
static int find_interface(struct usb_endpoint *uep)
{
	int iface_num = -1;
	int r, i, j;
	struct libusb_device *dev;
	struct libusb_config_descriptor *conf = 0;
	const struct libusb_interface *iface0;
	const struct libusb_interface_descriptor *iface;

	dev = libusb_get_device(uep->devh);
	r = libusb_get_active_config_descriptor(dev, &conf);
	if (r < 0) {
		USB_ERROR("libusb_get_active_config_descriptor", r);
		goto out;
	}

	for (i = 0; i < conf->bNumInterfaces; i++) {
		iface0 = &conf->interface[i];
		for (j = 0; j < iface0->num_altsetting; j++) {
			iface = &iface0->altsetting[j];
			if (find_endpoint(iface, uep)) {
				iface_num = i;
				goto out;
			}
		}
	}

out:
	libusb_free_config_descriptor(conf);
	return iface_num;
}

/* Returns true if parsed. */
static int parse_vidpid(const char *input, uint16_t *vid_ptr, uint16_t *pid_ptr)
{
	char *copy, *s, *e = 0;

	copy = strdup(input);

	s = strchr(copy, ':');
	if (!s)
		return 0;
	*s++ = '\0';

	*vid_ptr = (uint16_t) strtoul(copy, &e, 16);
	if (!*optarg || (e && *e))
		return 0;

	*pid_ptr = (uint16_t) strtoul(s, &e, 16);
	if (!*optarg || (e && *e))
		return 0;

	return 1;
}


static void usb_findit(uint16_t vid, uint16_t pid, struct usb_endpoint *uep)
{
	int iface_num, r;

	memset(uep, 0, sizeof(*uep));

	r = libusb_init(NULL);
	if (r < 0) {
		USB_ERROR("libusb_init", r);
		exit(update_error);
	}

	printf("open_device %04x:%04x\n", vid, pid);
	/* NOTE: This doesn't handle multiple matches! */
	uep->devh = libusb_open_device_with_vid_pid(NULL, vid, pid);
	if (!uep->devh) {
		fprintf(stderr, "Can't find device\n");
		exit(update_error);
	}

	iface_num = find_interface(uep);
	if (iface_num < 0) {
		fprintf(stderr, "USB FW update not supported by that device\n");
		shut_down(uep);
	}
	if (!uep->chunk_len) {
		fprintf(stderr, "wMaxPacketSize isn't valid\n");
		shut_down(uep);
	}

	printf("found interface %d endpoint %d, chunk_len %d\n",
	       iface_num, uep->ep_num, uep->chunk_len);

	libusb_set_auto_detach_kernel_driver(uep->devh, 1);
	r = libusb_claim_interface(uep->devh, iface_num);
	if (r < 0) {
		USB_ERROR("libusb_claim_interface", r);
		shut_down(uep);
	}

	printf("READY\n-------\n");
}

struct update_pdu {
	uint32_t block_size; /* Total block size, include this field's size. */
	struct upgrade_command cmd;
	/* The actual payload goes here. */
};

static int transfer_block(struct usb_endpoint *uep, struct update_pdu *updu,
			  uint8_t *transfer_data_ptr, size_t payload_size)
{
	size_t transfer_size;
	uint32_t reply;
	int actual;
	int r;

	/* First send the header. */
	xfer(uep, updu, sizeof(*updu), NULL, 0);

	/* Now send the block, chunk by chunk. */
	for (transfer_size = 0; transfer_size < payload_size;) {
		int chunk_size;

		chunk_size = MIN(uep->chunk_len, payload_size - transfer_size);
		xfer(uep, transfer_data_ptr, chunk_size, NULL, 0);
		transfer_data_ptr += chunk_size;
		transfer_size += chunk_size;
	}

	/* Now get the reply. */
	r = libusb_bulk_transfer(uep->devh, uep->ep_num | 0x80,
				 (void *) &reply, sizeof(reply),
				 &actual, 1000);
	if (r) {
		if (r == -7) {
			fprintf(stderr, "Timeout!\n");
			return r;
		}
		USB_ERROR("libusb_bulk_transfer", r);
		shut_down(uep);
	}

	reply = *((uint8_t *)&reply);
	if (reply) {
		fprintf(stderr, "Error: status %#x\n", reply);
		exit(update_error);
	}

	return 0;
}

/**
 * Transfer an image section (typically RW or RO).
 *
 * td           - transfer descriptor to use to communicate with the target
 * data_ptr     - pointer at the section base in the image
 * section_addr - address of the section in the target memory space
 * data_len     - section size
 */
static void transfer_section(struct transfer_descriptor *td,
			     uint8_t *data_ptr,
			     uint32_t section_addr,
			     size_t data_len)
{
	/*
	 * Actually, we can skip trailing chunks of 0xff, as the entire
	 * section space must be erased before the update is attempted.
	 */
	while (data_len && (data_ptr[data_len - 1] == 0xff))
		data_len--;

	printf("sending 0x%zx bytes to %#x\n", data_len, section_addr);
	while (data_len) {
		size_t payload_size;
		SHA_CTX ctx;
		uint8_t digest[SHA_DIGEST_LENGTH];
		int max_retries;
		struct update_pdu updu;

		/* prepare the header to prepend to the block. */
		payload_size = MIN(data_len, SIGNED_TRANSFER_SIZE);
		updu.block_size = htobe32(payload_size +
					  sizeof(struct update_pdu));

		updu.cmd.block_base = htobe32(section_addr);

		/* Calculate the digest. */
		SHA1_Init(&ctx);
		SHA1_Update(&ctx, &updu.cmd.block_base,
			    sizeof(updu.cmd.block_base));
		SHA1_Update(&ctx, data_ptr, payload_size);
		SHA1_Final(digest, &ctx);

		/* Copy the first few bytes. */
		memcpy(&updu.cmd.block_digest, digest,
		       sizeof(updu.cmd.block_digest));
		if (td->ep_type == usb_xfer) {
			for (max_retries = 10; max_retries; max_retries--)
				if (!transfer_block(&td->uep, &updu,
						    data_ptr, payload_size))
					break;

			if (!max_retries) {
				fprintf(stderr,
					"Failed to transfer block, %zd to go\n",
					data_len);
				exit(update_error);
			}
		} else {
			uint8_t error_code[4];
			size_t rxed_size = sizeof(error_code);
			uint32_t block_addr;

			block_addr = section_addr;

			/*
			 * A single byte response is expected, but let's give
			 * the driver a few extra bytes to catch cases when a
			 * different amount of data is transferred (which
			 * would indicate a synchronization problem).
			 */
			if (tpm_send_pkt(td,
					 updu.cmd.block_digest,
					 block_addr,
					 data_ptr,
					 payload_size, error_code,
					 &rxed_size,
					 EXTENSION_FW_UPGRADE) < 0) {
				fprintf(stderr,
					"Failed to trasfer block, %zd to go\n",
					data_len);
				exit(update_error);
			}
			if (rxed_size != 1) {
				fprintf(stderr, "Unexpected return size %zd\n",
					rxed_size);
				exit(update_error);
			}

			if (error_code[0]) {
				fprintf(stderr, "Error %d\n", error_code[0]);
				exit(update_error);
			}
		}
		data_len -= payload_size;
		data_ptr += payload_size;
		section_addr += payload_size;
	}
}

/* Information about the target */
static struct first_response_pdu targ;

/*
 * Each RO or RW section of the new image can be in one of the following
 * states.
 */
enum upgrade_status {
	not_needed = 0,  /* Version below or equal that on the target. */
	not_possible,    /*
			  * RO is newer, but can't be transferred due to
			  * target RW shortcomings.
			  */
	needed            /*
			   * This section needs to be transferred to the
			   * target.
			   */
};

/* This array describes all four sections of the new image. */
static struct {
	const char *name;
	uint32_t    offset;
	uint32_t    size;
	enum upgrade_status  ustatus;
	struct signed_header_version shv;
	uint32_t keyid;
} sections[] = {
	{"RO_A", CONFIG_RO_MEM_OFF, CONFIG_RO_SIZE},
	{"RW_A", CONFIG_RW_MEM_OFF, CONFIG_RW_SIZE},
	{"RO_B", CHIP_RO_B_MEM_OFF, CONFIG_RO_SIZE},
	{"RW_B", CONFIG_RW_B_MEM_OFF, CONFIG_RW_SIZE}
};

/*
 * Scan the new image and retrieve versions of all four sections, two RO and
 * two RW.
 */
static void fetch_header_versions(const void *image)
{
	size_t i;

	for (i = 0; i < ARRAY_SIZE(sections); i++) {
		const struct SignedHeader *h;

		h = (const struct SignedHeader *)((uintptr_t)image +
						  sections[i].offset);
		sections[i].shv.epoch = h->epoch_;
		sections[i].shv.major = h->major_;
		sections[i].shv.minor = h->minor_;
		sections[i].keyid = h->keyid;
	}
}


/* Compare to signer headers and determine which one is newer. */
static int a_newer_than_b(struct signed_header_version *a,
			  struct signed_header_version *b)
{
	uint32_t fields[][3] = {
		{a->epoch, a->major, a->minor},
		{b->epoch, b->major, b->minor},
	};
	size_t i;

	for (i = 0; i < ARRAY_SIZE(fields[0]); i++) {
		uint32_t a_value;
		uint32_t b_value;

		a_value = fields[0][i];
		b_value = fields[1][i];

		/*
		 * Let's filter out images where the section is not
		 * initialized and the version field value is set to all ones.
		 */
		if (a_value == 0xffffffff)
			a_value = 0;

		if (b_value == 0xffffffff)
			b_value = 0;

		if (a_value != b_value)
			return a_value > b_value;
	}

	return 0;	/* All else being equal A is no newer than B. */
}
/*
 * Pick sections to transfer based on information retrieved from the target,
 * the new image, and the protocol version the target is running.
 */
static void pick_sections(struct transfer_descriptor *td)
{
	size_t i;

	for (i = 0; i < ARRAY_SIZE(sections); i++) {
		uint32_t offset = sections[i].offset;

		if ((offset == CONFIG_RW_MEM_OFF) ||
		    (offset == CONFIG_RW_B_MEM_OFF)) {

			/* Skip currently active section. */
			if (offset != td->rw_offset)
				continue;
			/*
			 * Ok, this would be the RW section to transfer to the
			 * device. Is it newer in the new image than the
			 * running RW section on the device?
			 *
			 * If not in 'upstart' mode - transfer even if
			 * versions are the same, timestamps could be
			 * different.
			 */

			if (a_newer_than_b(&sections[i].shv, &targ.shv[1]) ||
			    !td->upstart_mode)
				sections[i].ustatus = needed;
			continue;
		}

		/* Skip currently active section. */
		if (offset != td->ro_offset)
			continue;
		/*
		 * Ok, this would be the RO section to transfer to the device.
		 * Is it newer in the new image than the running RO section on
		 * the device?
		 */
		if (a_newer_than_b(&sections[i].shv, &targ.shv[0]))
			sections[i].ustatus = needed;
	}
}

static void setup_connection(struct transfer_descriptor *td)
{
	size_t rxed_size;
	size_t i;
	uint32_t error_code;

	/*
	 * Need to be backwards compatible, communicate with targets running
	 * different protocol versions.
	 */
	union {
		struct first_response_pdu rpdu;
		uint32_t legacy_resp;
	} start_resp;

	/* Send start request. */
	printf("start\n");

	if (td->ep_type == usb_xfer) {
		struct update_pdu updu;

		memset(&updu, 0, sizeof(updu));
		updu.block_size = htobe32(sizeof(updu));
		do_xfer(&td->uep, &updu, sizeof(updu), &start_resp,
			sizeof(start_resp), 1, &rxed_size);
	} else {
		rxed_size = sizeof(start_resp);
		if (tpm_send_pkt(td, 0, 0, NULL, 0,
				 &start_resp, &rxed_size,
				 EXTENSION_FW_UPGRADE) < 0) {
			fprintf(stderr, "Failed to start transfer\n");
			exit(update_error);
		}
	}

	/* We got something. Check for errors in response */
	if (rxed_size < 8) {
		fprintf(stderr, "Unexpected response size %zd: ", rxed_size);
		for (i = 0; i < rxed_size; i++)
			fprintf(stderr, " %02x", ((uint8_t *)&start_resp)[i]);
		fprintf(stderr, "\n");
		exit(update_error);
	}

	protocol_version = be32toh(start_resp.rpdu.protocol_version);
	if (protocol_version < 5) {
		fprintf(stderr, "Unsupported protocol version %d\n",
			protocol_version);
		exit(update_error);
	}

	printf("target running protocol version %d\n", protocol_version);

	error_code = be32toh(start_resp.rpdu.return_value);

	if (error_code) {
		fprintf(stderr, "Target reporting error %d\n", error_code);
		if (td->ep_type == usb_xfer)
			shut_down(&td->uep);
		exit(update_error);
	}

	td->rw_offset = be32toh(start_resp.rpdu.backup_rw_offset);
	td->ro_offset = be32toh(start_resp.rpdu.backup_ro_offset);

	/* Running header versions. */
	for (i = 0; i < ARRAY_SIZE(targ.shv); i++) {
		targ.shv[i].minor = be32toh(start_resp.rpdu.shv[i].minor);
		targ.shv[i].major = be32toh(start_resp.rpdu.shv[i].major);
		targ.shv[i].epoch = be32toh(start_resp.rpdu.shv[i].epoch);
	}

	for (i = 0; i < ARRAY_SIZE(targ.keyid); i++)
		targ.keyid[i] = be32toh(start_resp.rpdu.keyid[i]);

	printf("keyids: RO 0x%08x, RW 0x%08x\n", targ.keyid[0], targ.keyid[1]);
	printf("offsets: backup RO at %#x, backup RW at %#x\n",
	       td->ro_offset, td->rw_offset);

	pick_sections(td);
}

/*
 * Channel TPM extension/vendor command over USB. The payload of the USB frame
 * in this case consists of the 2 byte subcommand code concatenated with the
 * command body. The caller needs to indicate if a response is expected, and
 * if it is - of what maximum size.
 */
static int ext_cmd_over_usb(struct usb_endpoint *uep, uint16_t subcommand,
			    const void *cmd_body, size_t body_size,
			    void *resp, size_t *resp_size)
{
	struct update_frame_header *ufh;
	uint16_t *frame_ptr;
	size_t usb_msg_size;
	SHA_CTX ctx;
	uint8_t digest[SHA_DIGEST_LENGTH];

	usb_msg_size = sizeof(struct update_frame_header) +
		sizeof(subcommand) + body_size;

	ufh = malloc(usb_msg_size);
	if (!ufh) {
		fprintf(stderr, "%s: failed to allocate %zd bytes\n",
			__func__, usb_msg_size);
		return -1;
	}

	ufh->block_size = htobe32(usb_msg_size);
	ufh->cmd.block_base = htobe32(CONFIG_EXTENSION_COMMAND);
	frame_ptr = (uint16_t *)(ufh + 1);
	*frame_ptr = htobe16(subcommand);

	if (body_size)
		memcpy(frame_ptr + 1, cmd_body, body_size);

	/* Calculate the digest. */
	SHA1_Init(&ctx);
	SHA1_Update(&ctx, &ufh->cmd.block_base,
		    usb_msg_size -
		    offsetof(struct update_frame_header, cmd.block_base));
	SHA1_Final(digest, &ctx);
	memcpy(&ufh->cmd.block_digest, digest, sizeof(ufh->cmd.block_digest));

	do_xfer(uep, ufh, usb_msg_size, resp,
		resp_size ? *resp_size : 0, 1, resp_size);

	free(ufh);
	return 0;
}

/*
 * Indicate to the target that update image transfer has been completed. Upon
 * receiveing of this message the target state machine transitions into the
 * 'rx_idle' state. The host may send an extension command to reset the target
 * after this.
 */
static void send_done(struct usb_endpoint *uep)
{
	uint32_t out;

	/* Send stop request, ignoring reply. */
	out = htobe32(UPGRADE_DONE);
	xfer(uep, &out, sizeof(out), &out, 1);
}

/* Returns number of successfully transmitted image sections. */
static int transfer_image(struct transfer_descriptor *td,
			       uint8_t *data, size_t data_len)
{
	size_t i;
	int num_txed_sections = 0;

	for (i = 0; i < ARRAY_SIZE(sections); i++)
		if (sections[i].ustatus == needed) {
			transfer_section(td,
					 data + sections[i].offset,
					 sections[i].offset,
					 sections[i].size);
			num_txed_sections++;
		}

	if (!num_txed_sections)
		printf("nothing to do\n");
	else
		printf("-------\nupdate complete\n");
	return num_txed_sections;
}

uint32_t send_vendor_command(struct transfer_descriptor *td,
			     uint16_t subcommand,
			     const void *command_body,
			     size_t command_body_size,
			     void *response,
			     size_t *response_size)
{
	int32_t rv;

	if (td->ep_type == usb_xfer) {
		/*
		 * When communicating over USB the response is always supposed
		 * to have the result code in the first byte of the response,
		 * to be stripped from the actual response body by this
		 * function.
		 */
		uint8_t temp_response[MAX_BUF_SIZE];
		size_t max_response_size;

		if (!response_size) {
			max_response_size = 1;
		} else if (*response_size < (sizeof(temp_response))) {
			max_response_size = *response_size + 1;
		} else {
			fprintf(stderr,
				"Error: Expected response too large (%zd)\n",
				*response_size);
			/* Should happen only when debugging. */
			exit(update_error);
		}

		ext_cmd_over_usb(&td->uep, subcommand,
				 command_body, command_body_size,
				 temp_response, &max_response_size);
		if (!max_response_size) {
			/*
			 * we must be talking to an older Cr50 firmware, which
			 * does not return the result code in the first byte
			 * on success, nothing to do.
			 */
			if (response_size)
				*response_size = 0;
			rv = 0;
		} else {
			rv = temp_response[0];
			if (response_size) {
				*response_size = max_response_size - 1;
				memcpy(response,
				       temp_response + 1, *response_size);
			}
		}
	} else {

		rv = tpm_send_pkt(td, 0, 0,
				  command_body, command_body_size,
				  response, response_size, subcommand);

		if (rv == -1) {
			fprintf(stderr,
				"Error: Failed to send vendor command %d\n",
				subcommand);
			exit(update_error);
		}
	}

	return rv; /* This will be converted into uint32_t */
}

/*
 * Corrupt the header of the inactive rw image to make sure the system can't
 * rollback
 */
static void invalidate_inactive_rw(struct transfer_descriptor *td)
{
	/* Corrupt the rw image that is not running. */
	uint32_t rv;

	rv = send_vendor_command(td, VENDOR_CC_INVALIDATE_INACTIVE_RW,
				 NULL, 0, NULL, NULL);
	if (!rv) {
		printf("Inactive header invalidated\n");
		return;
	}

	fprintf(stderr, "*%s: Error %#x\n", __func__, rv);
	exit(update_error);
}

static struct signed_header_version ver19 = {
	.epoch = 0,
	.major = 0,
	.minor = 19,
};

static void generate_reset_request(struct transfer_descriptor *td)
{
	size_t response_size;
	uint8_t response;
	uint16_t subcommand;
	uint8_t command_body[2]; /* Max command body size. */
	size_t command_body_size;
	uint32_t background_update_supported;
	const char *reset_type;
	int rv;

	if (protocol_version < 6) {
		if (td->ep_type == usb_xfer) {
			/*
			 * Send a second stop request, which should reboot
			 * without replying.
			 */
			send_done(&td->uep);
		}
		/* Nothing we can do over /dev/tpm0 running versions below 6. */
		return;
	}

	/* RW version 0.0.19 and above has support for background updates. */
	background_update_supported = !a_newer_than_b(&ver19, &targ.shv[1]);

	/*
	 * If this is an upstart request and there is support for background
	 * updates, don't post a request now. The target should handle it on
	 * the next reboot.
	 */
	if (td->upstart_mode && background_update_supported)
		return;

	/*
	 * If the user explicitly wants it or a reset is needed because h1
	 * does not support background updates, request post reset instead of
	 * immediate reset. In this case next time the target reboots, the h1
	 * will reboot as well, and will consider running the uploaded code.
	 *
	 * In case target RW version is 19 or above, to reset the target the
	 * host is supposed to send the command to enable the uploaded image
	 * disabled by default.
	 *
	 * Otherwise the immediate reset command would suffice.
	 */
	/* Most common case. */
	command_body_size = 0;
	response_size = 1;
	if (td->post_reset || td->upstart_mode) {
		subcommand = EXTENSION_POST_RESET;
		reset_type = "posted";
	} else if (background_update_supported) {
		subcommand = VENDOR_CC_TURN_UPDATE_ON;
		command_body_size = sizeof(command_body);
		command_body[0] = 0;
		command_body[1] = 100;  /* Reset in 100 ms. */
		reset_type = "requested";
	} else {
		response_size = 0;
		subcommand = VENDOR_CC_IMMEDIATE_RESET;
		reset_type = "triggered";
	}

	rv = send_vendor_command(td, subcommand, command_body,
				 command_body_size, &response, &response_size);

	if (rv) {
		fprintf(stderr, "*%s: Error %#x\n", __func__, rv);
		exit(update_error);
	}
	printf("reboot %s\n", reset_type);
}

static int show_headers_versions(const void *image)
{
	const struct {
		const char *name;
		uint32_t    offset;
	} sections[] = {
		{"RO_A", CONFIG_RO_MEM_OFF},
		{"RW_A", CONFIG_RW_MEM_OFF},
		{"RO_B", CHIP_RO_B_MEM_OFF},
		{"RW_B", CONFIG_RW_B_MEM_OFF}
	};
	size_t i;

	for (i = 0; i < ARRAY_SIZE(sections); i++) {
		const struct SignedHeader *h;
		size_t j;
		uint32_t bid;
		uint32_t bid_mask;
		uint32_t bid_flags;

		h = (const struct SignedHeader *)((uintptr_t)image +
						  sections[i].offset);
		printf("%s%s:%d.%d.%d", i ? " " : "", sections[i].name,
		       h->epoch_, h->major_, h->minor_);

		if (sections[i].name[1] != 'W')
			continue;

		/*
		 * For read/write sections print the board ID fields'
		 * contents, which are stored XORed with a padding value.
		 */
		bid = h->board_id_type ^ SIGNED_HEADER_PADDING;
		bid_mask = h->board_id_type_mask ^ SIGNED_HEADER_PADDING;
		bid_flags = h->board_id_flags ^ SIGNED_HEADER_PADDING;

		/* Beginning of a board ID section of the string. */
		printf("[");

		/*
		 * If board ID is an ASCII string (as it ought to be), print
		 * it as 4 symbols, otherwise print it as an 8 digit hex.
		 */
		for (j = 0; j < sizeof(bid); j++)
			if (!isalnum(((const char *)&bid)[j]))
				break;

		if (j == sizeof(bid)) {
			/* Convert it for proper string representation. */
			bid = be32toh(bid);
			printf("%.4s", (const char *)&bid);
		} else {
			printf("%08x", bid);
		}

		/* Print the rest of the board ID fields. */
		printf(":%08x:%08x]", bid_mask, bid_flags);
	}
	printf("\n");

	return 0;
}

/*
 * The default flag value will allow to run images built for any hardware
 * generation of a particular board ID.
 */
#define DEFAULT_BOARD_ID_FLAG 0xff00
static int parse_bid(const char *opt,
		     struct board_id *bid,
		     enum board_id_action *bid_action)
{
	char *e;
	const char *param2;
	size_t param1_length;

	if (!opt) {
		*bid_action = bid_get;
		return 1;
	}

	/* Set it here to make bailing out easier later. */
	bid->flags = DEFAULT_BOARD_ID_FLAG;

	*bid_action = bid_set;  /* Ignored by caller on errors. */

	/*
	 * Pointer to the optional second component of the command line
	 * parameter, when present - separated by a colon.
	 */
	param2 = strchr(opt, ':');
	if (param2) {
		param1_length = param2 - opt;
		param2++;
		if (!*param2)
			return 0; /* Empty second parameter. */
	} else {
		param1_length = strlen(opt);
	}

	if (!param1_length)
		return 0; /* Colon is the first character of the string? */

	if (param1_length <= 4) {
		unsigned i;

		/* Input must be a symbolic board name. */
		bid->type = 0;
		for (i = 0; i < param1_length; i++)
			bid->type = (bid->type << 8) | opt[i];
	} else {
		bid->type = (uint32_t)strtoul(opt, &e, 0);
		if ((param2 && (*e != ':')) || (!param2 && *e))
			return 0;
	}

	if (param2) {
		bid->flags = (uint32_t)strtoul(param2, &e, 0);
		if (*e)
			return 0;
	}

	return 1;
}

static uint32_t common_process_password(struct transfer_descriptor *td,
					enum ccd_vendor_subcommands subcmd)
{
	size_t response_size;
	uint8_t response;
	uint32_t rv;
	char *password = NULL;
	char *password_copy = NULL;
	size_t copy_len = 0;
	size_t len = 0;
	struct termios oldattr, newattr;

	/* Suppress command line echo while password is being entered. */
	tcgetattr(STDIN_FILENO, &oldattr);
	newattr = oldattr;
	newattr.c_lflag &= ~ECHO;
	newattr.c_lflag |= (ICANON | ECHONL);
	tcsetattr(STDIN_FILENO, TCSANOW, &newattr);

	/* With command line echo suppressed request password entry twice. */
	printf("Enter password:");
	len = getline(&password, &len, stdin);
	printf("Re-enter password:");
	getline(&password_copy, &copy_len, stdin);

	/* Restore command line echo. */
	tcsetattr(STDIN_FILENO, TCSANOW, &oldattr);

	/* Empty password will still have the newline. */
	if ((len <= 1) || !password_copy) {
		if (password)
			free(password);
		if (password_copy)
			free(password_copy);
		fprintf(stderr, "Error reading password\n");
		exit(update_error);
	}

	/* Compare the two inputs. */
	if (strcmp(password, password_copy)) {
		fprintf(stderr, "Entered passwords don't match\n");
		free(password);
		free(password_copy);
		exit(update_error);
	}

	/*
	 * Ok, we have a password, let's move it in the buffer to overwrite
	 * the newline and free a byte to prepend the subcommand code.
	 */
	memmove(password + 1, password, len  - 1);
	password[0] = subcmd;
	response_size = sizeof(response);
	rv = send_vendor_command(td, VENDOR_CC_CCD,
				 password, len,
				 &response, &response_size);
	free(password);
	free(password_copy);

	if ((rv != VENDOR_RC_SUCCESS) && (rv != VENDOR_RC_IN_PROGRESS))
		fprintf(stderr, "Error sending password: rv %d, response %d\n",
			rv, response_size ? response : 0);

	return rv;
}

static void process_password(struct transfer_descriptor *td)
{
	if (common_process_password(td, CCDV_PASSWORD) == VENDOR_RC_SUCCESS)
		return;

	exit(update_error);
}

void poll_for_pp(struct transfer_descriptor *td,
		 uint16_t command,
		 uint8_t poll_type)
{
	uint8_t response;
	uint8_t prev_response;
	size_t response_size;
	int rv;

	prev_response = ~0; /* Guaranteed invalid value. */

	while (1) {
		response_size = sizeof(response);
		rv = send_vendor_command(td, command,
					 &poll_type, sizeof(poll_type),
					 &response, &response_size);

		if (((rv != VENDOR_RC_SUCCESS) && (rv != VENDOR_RC_IN_PROGRESS))
		    || (response_size != 1)) {
			fprintf(stderr, "Error: rv %d, response %d\n",
				rv, response_size ? response : 0);
			exit(update_error);
		}

		if (response == CCD_PP_DONE) {
			printf("PP Done!\n");
			return;
		}

		if (response == CCD_PP_CLOSED) {
			fprintf(stderr,
				"Error: Physical presence check timeout!\n");
			exit(update_error);
		}


		if (response == CCD_PP_AWAITING_PRESS) {
			printf("Press PP button now!\n");
		} else if (response == CCD_PP_BETWEEN_PRESSES) {
			if (prev_response != response)
				printf("Another press will be required!\n");
		} else {
			fprintf(stderr, "Error: unknown poll result %d\n",
				response);
			exit(update_error);
		}
		prev_response = response;

		usleep(500 * 1000); /* Poll every half a second. */
	}

}

static void print_ccd_info(void *response, size_t response_size)
{
	struct ccd_info_response ccd_info;
	size_t i;
	const struct ccd_capability_info cap_info[] = CAP_INFO_DATA;
	const char *state_names[] = CCD_STATE_NAMES;
	const char *cap_state_names[] = CCD_CAP_STATE_NAMES;
	uint32_t caps_bitmap = 0;

	if (response_size != sizeof(ccd_info)) {
		fprintf(stderr, "Unexpected CCD info response size %zd\n",
			response_size);
		exit(update_error);
	}

	memcpy(&ccd_info, response, sizeof(ccd_info));

	/* Convert it back to host endian format. */
	ccd_info.ccd_flags = be32toh(ccd_info.ccd_flags);
	for (i = 0; i < ARRAY_SIZE(ccd_info.ccd_caps_current); i++) {
		ccd_info.ccd_caps_current[i] =
			be32toh(ccd_info.ccd_caps_current[i]);
		ccd_info.ccd_caps_defaults[i] =
			be32toh(ccd_info.ccd_caps_defaults[i]);
	}

	/* Now report CCD state on the console. */
	printf("State: %s\n", ccd_info.ccd_state > ARRAY_SIZE(state_names) ?
	       "Error" : state_names[ccd_info.ccd_state]);
	printf("Password: %s\n", ccd_info.ccd_has_password ? "Set" : "None");
	printf("Flags: %#06x\n", ccd_info.ccd_flags);
	printf("Capabilities, current and default:\n");
	for (i = 0; i < CCD_CAP_COUNT; i++) {
		int is_enabled;
		int index;
		int shift;
		int cap_current;
		int cap_default;

		index = i / (32/2);
		shift = (i % (32/2)) * 2;

		cap_current = (ccd_info.ccd_caps_current[index] >> shift) & 3;
		cap_default = (ccd_info.ccd_caps_defaults[index] >> shift) & 3;

		if (ccd_info.ccd_force_disabled) {
			is_enabled = 0;
		} else {
			switch (cap_current) {
			case CCD_CAP_STATE_ALWAYS:
				is_enabled = 1;
				break;
			case CCD_CAP_STATE_UNLESS_LOCKED:
				is_enabled = (ccd_info.ccd_state !=
					      CCD_STATE_LOCKED);
				break;
			default:
				is_enabled = (ccd_info.ccd_state ==
					      CCD_STATE_OPENED);
				break;
			}
		}

		printf("  %-15s %c %s",
		       cap_info[i].name,
		       is_enabled ? 'Y' : '-',
		       cap_state_names[cap_current]);

		if (cap_current != cap_default)
			printf("  (%s)", cap_state_names[cap_default]);

		printf("\n");

		if (is_enabled)
			caps_bitmap |= (1 << i);
	}
	printf("CCD caps bitmap: %#x\n", caps_bitmap);
}

static void process_ccd_state(struct transfer_descriptor *td, int ccd_unlock,
			      int ccd_open, int ccd_lock, int ccd_info)
{
	uint8_t payload;
	 /* Max possible response size is when ccd_info is requested. */
	uint8_t response[sizeof(struct ccd_info_response)];
	size_t response_size;
	int rv;

	if (ccd_unlock)
		payload = CCDV_UNLOCK;
	else if (ccd_open)
		payload = CCDV_OPEN;
	else if (ccd_lock)
		payload = CCDV_LOCK;
	else
		payload = CCDV_GET_INFO;

	response_size = sizeof(response);
	rv = send_vendor_command(td, VENDOR_CC_CCD,
				 &payload, sizeof(payload),
				 &response, &response_size);

	/*
	 * If password is required - try sending the same subcommand
	 * accompanied by user password.
	 */
	if (rv == VENDOR_RC_PASSWORD_REQUIRED)
		rv = common_process_password(td, payload);

	if (rv == VENDOR_RC_SUCCESS) {
		if (ccd_info)
			print_ccd_info(response, response_size);
		return;
	}

	if (rv != VENDOR_RC_IN_PROGRESS) {
		fprintf(stderr, "Error: rv %d, response %d\n",
			rv, response_size ? response[0] : 0);
		exit(update_error);
	}

	/*
	 * Physical presence process started, poll for the state the user
	 * asked for. Only two subcommands would return 'IN_PROGRESS'.
	 */
	if (ccd_unlock)
		poll_for_pp(td, VENDOR_CC_CCD, CCDV_PP_POLL_UNLOCK);
	else
		poll_for_pp(td, VENDOR_CC_CCD, CCDV_PP_POLL_OPEN);
}

void process_bid(struct transfer_descriptor *td,
		 enum board_id_action bid_action,
		 struct board_id *bid)
{
	size_t response_size;

	if (bid_action == bid_get) {

		response_size = sizeof(*bid);
		send_vendor_command(td, VENDOR_CC_GET_BOARD_ID,
				    bid, sizeof(*bid),
				    bid, &response_size);

		if (response_size == sizeof(*bid)) {
			printf("Board ID space: %08x:%08x:%08x\n",
			       be32toh(bid->type), be32toh(bid->type_inv),
			       be32toh(bid->flags));
			return;
		}
		fprintf(stderr, "Error reading board ID: response size %zd,"
			" first byte %#02x\n", response_size,
			response_size ? *(uint8_t *)&bid : -1);
		exit(update_error);
	}

	if (bid_action == bid_set) {
		/* Sending just two fields: type and flags. */
		uint32_t command_body[2];
		uint8_t response;

		command_body[0] = htobe32(bid->type);
		command_body[1] = htobe32(bid->flags);

		response_size = sizeof(command_body);
		send_vendor_command(td, VENDOR_CC_SET_BOARD_ID,
				    command_body, sizeof(command_body),
				    command_body, &response_size);

		/*
		 * Speculative assignment: the response is expected to be one
		 * byte in size and be placed in the first byte of the buffer.
		 */
		response = *((uint8_t *)command_body);

		if (response_size == 1) {
			if (!response)
				return; /* Success! */

			fprintf(stderr, "Error %d while setting board id\n",
				response);
		} else {
			fprintf(stderr, "Unexpected response size %zd"
				" while setting board id\n",
				response_size);
		}
		exit(update_error);
	}
}

/*
 * Retrieve the RMA authentication challenge from the Cr50, print out the
 * challenge on the console, then prompt the user for the authentication code,
 * and send the code back to Cr50. The Cr50 would report if the code matched
 * its expectations or not.
 */
static void process_rma(struct transfer_descriptor *td, const char *authcode)
{
	char rma_response[81];
	size_t response_size = sizeof(rma_response);
	size_t i;
	size_t auth_size = 0;

	if (!authcode) {
		send_vendor_command(td, VENDOR_CC_RMA_CHALLENGE_RESPONSE,
				    NULL, 0, rma_response, &response_size);

		if (response_size == 1) {
			fprintf(stderr, "error %d\n", rma_response[0]);
			if (td->ep_type == usb_xfer)
				shut_down(&td->uep);
			exit(update_error);
		}

		printf("Challenge:");
		for (i = 0; i < response_size; i++) {
			if (!(i % 5)) {
				if (!(i % 40))
					printf("\n");
				printf(" ");
			}
			printf("%c", rma_response[i]);
		}
		printf("\n");
		return;
	}

	if (!strcmp(authcode, "disable")) {
		printf("Disabling RMA mode\n");
		send_vendor_command(td, VENDOR_CC_DISABLE_RMA, NULL, 0,
				    rma_response, &response_size);
		if (response_size) {
			fprintf(stderr, "Failed disabling RMA, error %d\n",
				rma_response[0]);
			exit(update_error);
		}
		return;
	}

	printf("Processing response...");
	auth_size = strlen(authcode);
	response_size = sizeof(rma_response);

	send_vendor_command(td, VENDOR_CC_RMA_CHALLENGE_RESPONSE,
			    authcode, auth_size,
			    rma_response, &response_size);

	if (response_size == 1) {
		fprintf(stderr, "\nrma unlock failed, code %d\n",
			*rma_response);
		if (td->ep_type == usb_xfer)
			shut_down(&td->uep);
		exit(update_error);
	}
	printf("RMA unlock succeeded.\n");
}

static void report_version(void)
{
	/* Get version from the generated file, ignore the underscore prefix. */
	const char *v = VERSION + 1;

	printf("Version: %s, built on %s by %s\n", v, DATE, BUILDER);
	exit(0);
}

int main(int argc, char *argv[])
{
	struct transfer_descriptor td;
	int errorcnt;
	uint8_t *data = 0;
	size_t data_len = 0;
	uint16_t vid = VID, pid = PID;
	int i;
	size_t j;
	int transferred_sections = 0;
	int binary_vers = 0;
	int show_fw_ver = 0;
	int rma = 0;
	const char *rma_auth_code;
	int corrupt_inactive_rw = 0;
	struct board_id bid;
	enum board_id_action bid_action;
	int password = 0;
	int ccd_open = 0;
	int ccd_unlock = 0;
	int ccd_lock = 0;
	int ccd_info = 0;
	int try_all_transfer = 0;
	const char *exclusive_opt_error =
		"Options -a, -s and -t are mutually exclusive\n";
	const char *openbox_desc_file = NULL;

	progname = strrchr(argv[0], '/');
	if (progname)
		progname++;
	else
		progname = argv[0];

	/* Usb transfer - default mode. */
	memset(&td, 0, sizeof(td));
	td.ep_type = usb_xfer;

	bid_action = bid_none;
	errorcnt = 0;
	opterr = 0;				/* quiet, you */
	while ((i = getopt_long(argc, argv, short_opts, long_opts, 0)) != -1) {
		switch (i) {
		case 'a':
			if (td.ep_type) {
				errorcnt++;
				fprintf(stderr, "%s", exclusive_opt_error);
				break;
			}
			try_all_transfer = 1;
			/* Try dev_xfer first. */
			td.ep_type = dev_xfer;
			break;
		case 'b':
			binary_vers = 1;
			break;
		case 'd':
			if (!parse_vidpid(optarg, &vid, &pid)) {
				fprintf(stderr,
					"Invalid device argument: \"%s\"\n",
					optarg);
				errorcnt++;
			}
			break;
		case 'c':
			corrupt_inactive_rw = 1;
			break;
		case 'f':
			show_fw_ver = 1;
			break;
		case 'h':
			usage(errorcnt);
			break;
		case 'I':
			ccd_info = 1;
			break;
		case 'i':
			if (!optarg && argv[optind] && argv[optind][0] != '-')
				/* optional argument present. */
				optarg = argv[optind++];

			if (!parse_bid(optarg, &bid, &bid_action)) {
				fprintf(stderr,
					"Invalid board id argument: \"%s\"\n",
					optarg);
				errorcnt++;
			}
			break;
		case 'k':
			ccd_lock = 1;
			break;
		case 'O':
			openbox_desc_file = optarg;
			break;
		case 'o':
			ccd_open = 1;
			break;
		case 'p':
			td.post_reset = 1;
			break;
		case 'P':
			password = 1;
			break;
		case 'r':
			rma = 1;

			if (!optarg && argv[optind] && argv[optind][0] != '-')
				/* optional argument present. */
				optarg = argv[optind++];

			rma_auth_code = optarg;
			break;
		case 's':
			if (td.ep_type || try_all_transfer) {
				errorcnt++;
				fprintf(stderr, "%s", exclusive_opt_error);
				break;
			}
			td.ep_type = dev_xfer;
			break;
		case 't':
			if (td.ep_type || try_all_transfer) {
				errorcnt++;
				fprintf(stderr, "%s", exclusive_opt_error);
				break;
			}
			td.ep_type = ts_xfer;
			break;
		case 'U':
			ccd_unlock = 1;
			break;
		case 'u':
			td.upstart_mode = 1;
			break;
		case 'V':
			verbose_mode = 1;
			break;
		case 'v':
			report_version();  /* This will call exit(). */
			break;
		case 0:				/* auto-handled option */
			break;
		case '?':
			if (optopt)
				fprintf(stderr, "Unrecognized option: -%c\n",
					optopt);
			else
				fprintf(stderr, "Unrecognized option: %s\n",
					argv[optind - 1]);
			errorcnt++;
			break;
		case ':':
			fprintf(stderr, "Missing argument to %s\n",
				argv[optind - 1]);
			errorcnt++;
			break;
		default:
			fprintf(stderr, "Internal error at %s:%d\n",
				__FILE__, __LINE__);
			exit(update_error);
		}
	}

	if (errorcnt)
		usage(errorcnt);

	if ((bid_action == bid_none) &&
	    !ccd_info &&
	    !ccd_lock &&
	    !ccd_open &&
	    !ccd_unlock &&
	    !corrupt_inactive_rw &&
	    !password &&
	    !rma &&
	    !show_fw_ver &&
	    !openbox_desc_file) {
		if (optind >= argc) {
			fprintf(stderr,
				"\nERROR: Missing required <binary image>\n\n");
			usage(1);
		}

		data = get_file_or_die(argv[optind], &data_len);
		printf("read %zd(%#zx) bytes from %s\n",
		       data_len, data_len, argv[optind]);
		if (data_len != CONFIG_FLASH_SIZE) {
			fprintf(stderr, "Image file is not %d bytes\n",
				CONFIG_FLASH_SIZE);
			exit(update_error);
		}

		fetch_header_versions(data);

		if (binary_vers)
			exit(show_headers_versions(data));
	} else {
		if (optind < argc)
			printf("Ignoring binary image %s\n", argv[optind]);
	}

	if (((bid_action != bid_none) + !!rma + !!password +
	     !!ccd_open + !!ccd_unlock + !!ccd_lock + !!ccd_info +
	     !!openbox_desc_file) > 2) {
		fprintf(stderr, "ERROR: "
			"options -I -i, -k, -O, -o, -P, -r, and -u "
			"are mutually exclusive\n");
		exit(update_error);
	}

	if (td.ep_type == usb_xfer) {
		usb_findit(vid, pid, &td.uep);
	} else if (td.ep_type == dev_xfer) {
		td.tpm_fd = open("/dev/tpm0", O_RDWR);
		if (td.tpm_fd < 0) {
			if (!try_all_transfer) {
				perror("Could not open TPM");
				exit(update_error);
			}
			td.ep_type = ts_xfer;
		}
	}

	if (openbox_desc_file)
		return verify_ro(&td, openbox_desc_file);

	if (ccd_unlock || ccd_open || ccd_lock || ccd_info)
		process_ccd_state(&td, ccd_unlock, ccd_open,
				  ccd_lock, ccd_info);

	if (password)
		process_password(&td);

	if (bid_action != bid_none)
		process_bid(&td, bid_action, &bid);

	if (rma)
		process_rma(&td, rma_auth_code);

	if (corrupt_inactive_rw)
		invalidate_inactive_rw(&td);

	if (data || show_fw_ver) {

		setup_connection(&td);

		if (data) {
			transferred_sections = transfer_image(&td,
							      data, data_len);
			free(data);
		}

		/*
		 * Move USB updater sate machine to idle state so that vendor
		 * commands can be processed later, if any.
		 */
		if (td.ep_type == usb_xfer)
			send_done(&td.uep);

		if (transferred_sections)
			generate_reset_request(&td);

		if (show_fw_ver) {
			printf("Current versions:\n");
			printf("RO %d.%d.%d\n", targ.shv[0].epoch,
			       targ.shv[0].major,
			       targ.shv[0].minor);
			printf("RW %d.%d.%d\n", targ.shv[1].epoch,
			       targ.shv[1].major,
			       targ.shv[1].minor);
		}
	}

	if (td.ep_type == usb_xfer) {
		libusb_close(td.uep.devh);
		libusb_exit(NULL);
	}

	if (!transferred_sections)
		return noop;
	/*
	 * We should indicate if RO update was not done because of the
	 * insufficient RW version.
	 */
	for (j = 0; j < ARRAY_SIZE(sections); j++)
		if (sections[j].ustatus == not_possible) {
			/* This will allow scripting repeat attempts. */
			printf("Failed to update RO, run the command again\n");
			return rw_updated;
		}

	printf("image updated\n");
	return all_updated;
}
