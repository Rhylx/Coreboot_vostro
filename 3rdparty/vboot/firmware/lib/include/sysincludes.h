/* Copyright (c) 2010 The Chromium OS Authors. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

/* System includes for vboot reference library.  This is the ONLY
 * place in firmware/ where system headers may be included via
 * #include <...>, so that there's only one place that needs to be
 * fixed up for platforms which don't have all the system includes.
 *
 * Files in firmware/stub may still include system headers, because
 * they're local implementations and will be ported to each system
 * anyway. */

#ifndef VBOOT_REFERENCE_SYSINCLUDES_H_
#define VBOOT_REFERENCE_SYSINCLUDES_H_

#include <ctype.h>
#include <inttypes.h>  /* For PRIu64 */
#include <stddef.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

#if defined(HAVE_ENDIAN_H) && defined(HAVE_LITTLE_ENDIAN)
#include <byteswap.h>
#include <memory.h>
#endif

#endif  /* VBOOT_REFERENCE_SYSINCLUDES_H_ */
