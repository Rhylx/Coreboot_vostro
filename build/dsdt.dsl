/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20191018 (64-bit version)
 * Copyright (c) 2000 - 2019 Intel Corporation
 * 
 * Disassembling to symbolic ASL+ operators
 *
 * Disassembly of build/dsdt.aml, Mon Jan 13 11:37:08 2020
 *
 * Original Table Header:
 *     Signature        "DSDT"
 *     Length           0x00002647 (9799)
 *     Revision         0x02
 *     Checksum         0xF4
 *     OEM ID           "COREv4"
 *     OEM Table ID     "COREBOOT"
 *     OEM Revision     0x20141018 (538185752)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20191018 (538513432)
 */
DefinitionBlock ("", "DSDT", 2, "COREv4", "COREBOOT", 0x20141018)
{
    External (_PR_.CNOT, MethodObj)    // 1 Arguments
    External (_PR_.CP00._PSS, UnknownObj)
    External (_SB_.PCI0.GFX0.LCD0, DeviceObj)
    External (_TZ_.SKIN, UnknownObj)
    External (NVSA, UnknownObj)

    Method (_WAK, 1, NotSerialized)  // _WAK: Wake
    {
        Return (Package (0x02)
        {
            Zero, 
            Zero
        })
    }

    Method (_PTS, 1, NotSerialized)  // _PTS: Prepare To Sleep
    {
    }

    Method (PNOT, 0, NotSerialized)
    {
        \_PR.CNOT (0x81)
    }

    Method (PPCN, 0, NotSerialized)
    {
        \_PR.CNOT (0x80)
    }

    Method (TNOT, 0, NotSerialized)
    {
        \_PR.CNOT (0x82)
    }

    OperationRegion (APMP, SystemIO, 0xB2, 0x02)
    Field (APMP, ByteAcc, NoLock, Preserve)
    {
        APMC,   8, 
        APMS,   8
    }

    OperationRegion (POST, SystemIO, 0x80, One)
    Field (POST, ByteAcc, Lock, Preserve)
    {
        DBG0,   8
    }

    Method (TRAP, 1, Serialized)
    {
        SMIF = Arg0
        TRP0 = Zero
        Return (SMIF) /* \SMIF */
    }

    Method (_PIC, 1, NotSerialized)  // _PIC: Interrupt Model
    {
        PICM = Arg0
    }

    Method (GOS, 0, NotSerialized)
    {
        OSYS = 0x07D0
        If (CondRefOf (_OSI))
        {
            If (_OSI ("Windows 2001"))
            {
                OSYS = 0x07D1
            }

            If (_OSI ("Windows 2001 SP1"))
            {
                OSYS = 0x07D1
            }

            If (_OSI ("Windows 2001 SP2"))
            {
                OSYS = 0x07D2
            }

            If (_OSI ("Windows 2006"))
            {
                OSYS = 0x07D6
            }
        }
    }

    Name (PICM, Zero)
    Name (DSEN, One)
    OperationRegion (GNVS, SystemMemory, NVSA, 0x0F00)
    Field (GNVS, ByteAcc, NoLock, Preserve)
    {
        OSYS,   16, 
        SMIF,   8, 
        PRM0,   8, 
        PRM1,   8, 
        SCIF,   8, 
        PRM2,   8, 
        PRM3,   8, 
        LCKF,   8, 
        PRM4,   8, 
        PRM5,   8, 
        P80D,   32, 
        LIDS,   8, 
        PWRS,   8, 
        TLVL,   8, 
        FLVL,   8, 
        TCRT,   8, 
        TPSV,   8, 
        TMAX,   8, 
        F0OF,   8, 
        F0ON,   8, 
        F0PW,   8, 
        F1OF,   8, 
        F1ON,   8, 
        F1PW,   8, 
        F2OF,   8, 
        F2ON,   8, 
        F2PW,   8, 
        F3OF,   8, 
        F3ON,   8, 
        F3PW,   8, 
        F4OF,   8, 
        F4ON,   8, 
        F4PW,   8, 
        TMPS,   8, 
        Offset (0x28), 
        APIC,   8, 
        MPEN,   8, 
        PCP0,   8, 
        PCP1,   8, 
        PPCM,   8, 
        PCNT,   8, 
        Offset (0x32), 
        NATP,   8, 
        S5U0,   8, 
        S5U1,   8, 
        S3U0,   8, 
        S3U1,   8, 
        S33G,   8, 
        CMEM,   32, 
        IGDS,   8, 
        TLST,   8, 
        CADL,   8, 
        PADL,   8, 
        CSTE,   16, 
        NSTE,   16, 
        SSTE,   16, 
        NDID,   8, 
        DID1,   32, 
        DID2,   32, 
        DID3,   32, 
        DID4,   32, 
        DID5,   32, 
        Offset (0x64), 
        BLCS,   8, 
        BRTL,   8, 
        ODDS,   8, 
        Offset (0x6E), 
        ALSE,   8, 
        ALAF,   8, 
        LLOW,   8, 
        LHIH,   8, 
        Offset (0x78), 
        EMAE,   8, 
        EMAP,   16, 
        EMAL,   16, 
        Offset (0x82), 
        MEFE,   8, 
        Offset (0x8C), 
        TPMP,   8, 
        TPME,   8, 
        Offset (0x96), 
        GTF0,   56, 
        GTF1,   56, 
        GTF2,   56, 
        IDEM,   8, 
        IDET,   8, 
        Offset (0xB2), 
        XHCI,   8, 
        Offset (0xB4), 
        ASLB,   32, 
        IBTT,   8, 
        IPAT,   8, 
        ITVF,   8, 
        ITVM,   8, 
        IPSC,   8, 
        IBLC,   8, 
        IBIA,   8, 
        ISSC,   8, 
        I409,   8, 
        I509,   8, 
        I609,   8, 
        I709,   8, 
        IDMM,   8, 
        IDMS,   8, 
        IF1E,   8, 
        HVCO,   8, 
        NXD1,   32, 
        NXD2,   32, 
        NXD3,   32, 
        NXD4,   32, 
        NXD5,   32, 
        NXD6,   32, 
        NXD7,   32, 
        NXD8,   32, 
        ISCI,   8, 
        PAVP,   8, 
        Offset (0xEB), 
        OSCC,   8, 
        NPCE,   8, 
        PLFL,   8, 
        BREV,   8, 
        DPBM,   8, 
        DPCM,   8, 
        DPDM,   8, 
        ALFP,   8, 
        IMON,   8, 
        MMIO,   8, 
        TPIQ,   8, 
        Offset (0x100), 
        VBT0,   32, 
        VBT1,   32, 
        VBT2,   32, 
        VBT3,   16, 
        VBT4,   2048, 
        VBT5,   512, 
        VBT6,   512, 
        VBT7,   32, 
        VBT8,   32, 
        VBT9,   32, 
        CHVD,   24576, 
        VBTA,   32, 
        MEHH,   256, 
        RMOB,   32, 
        RMOL,   32, 
        ROVP,   32, 
        ROVL,   32, 
        RWVP,   32, 
        RWVL,   32
    }

    Method (S3UE, 0, NotSerialized)
    {
        S3U0 = One
        S3U1 = One
    }

    Method (S3UD, 0, NotSerialized)
    {
        S3U0 = Zero
        S3U1 = Zero
    }

    Method (S5UE, 0, NotSerialized)
    {
        S5U0 = One
        S5U1 = One
    }

    Method (S5UD, 0, NotSerialized)
    {
        S5U0 = Zero
        S5U1 = Zero
    }

    Method (S3GE, 0, NotSerialized)
    {
        S33G = One
    }

    Method (S3GD, 0, NotSerialized)
    {
        S33G = Zero
    }

    Method (XHCE, 0, NotSerialized)
    {
        XHCI = One
    }

    Method (XHCD, 0, NotSerialized)
    {
        XHCI = Zero
    }

    Method (TZUP, 0, NotSerialized)
    {
        If (CondRefOf (\_TZ.SKIN))
        {
            Notify (\_TZ.SKIN, 0x81) // Information Change
        }
    }

    Method (F0UT, 2, NotSerialized)
    {
        F0OF = Arg0
        F0ON = Arg1
        TZUP ()
    }

    Method (F1UT, 2, NotSerialized)
    {
        F1OF = Arg0
        F1ON = Arg1
        TZUP ()
    }

    Method (F2UT, 2, NotSerialized)
    {
        F2OF = Arg0
        F2ON = Arg1
        TZUP ()
    }

    Method (F3UT, 2, NotSerialized)
    {
        F3OF = Arg0
        F3ON = Arg1
        TZUP ()
    }

    Method (F4UT, 2, NotSerialized)
    {
        F4OF = Arg0
        F4ON = Arg1
        TZUP ()
    }

    Method (TMPU, 1, NotSerialized)
    {
        TMPS = Arg0
        TZUP ()
    }

    Name (_S0, Package (0x04)  // _S0_: S0 System State
    {
        Zero, 
        Zero, 
        Zero, 
        Zero
    })
    Name (_S3, Package (0x04)  // _S3_: S3 System State
    {
        0x05, 
        Zero, 
        Zero, 
        Zero
    })
    Name (_S4, Package (0x04)  // _S4_: S4 System State
    {
        0x06, 
        Zero, 
        Zero, 
        Zero
    })
    Name (_S5, Package (0x04)  // _S5_: S5 System State
    {
        0x07, 
        Zero, 
        Zero, 
        Zero
    })
    Device (_SB.PCI0)
    {
        Name (_HID, EisaId ("PNP0A08") /* PCI Express Bus */)  // _HID: Hardware ID
        Name (_CID, EisaId ("PNP0A03") /* PCI Bus */)  // _CID: Compatible ID
        Name (_BBN, Zero)  // _BBN: BIOS Bus Number
        Device (MCHC)
        {
            Name (_ADR, Zero)  // _ADR: Address
            OperationRegion (MCHP, PCI_Config, Zero, 0x0100)
            Field (MCHP, DWordAcc, NoLock, Preserve)
            {
                Offset (0x40), 
                EPEN,   1, 
                    ,   11, 
                EPBR,   27, 
                Offset (0x48), 
                MHEN,   1, 
                    ,   14, 
                MHBR,   24, 
                Offset (0x54), 
                DVEN,   32, 
                Offset (0x60), 
                PXEN,   1, 
                PXSZ,   2, 
                    ,   23, 
                PXBR,   13, 
                Offset (0x68), 
                DMEN,   1, 
                    ,   11, 
                DMBR,   27, 
                Offset (0x70), 
                MEBA,   64, 
                Offset (0x80), 
                    ,   4, 
                PM0H,   2, 
                Offset (0x81), 
                PM1L,   2, 
                    ,   2, 
                PM1H,   2, 
                Offset (0x82), 
                PM2L,   2, 
                    ,   2, 
                PM2H,   2, 
                Offset (0x83), 
                PM3L,   2, 
                    ,   2, 
                PM3H,   2, 
                Offset (0x84), 
                PM4L,   2, 
                    ,   2, 
                PM4H,   2, 
                Offset (0x85), 
                PM5L,   2, 
                    ,   2, 
                PM5H,   2, 
                Offset (0x86), 
                PM6L,   2, 
                    ,   2, 
                PM6H,   2, 
                Offset (0x87), 
                Offset (0xA0), 
                TOM,    64, 
                Offset (0xBC), 
                TLUD,   32
            }

            Mutex (CTCM, 0x01)
            Name (CTCC, Zero)
            Name (CTCN, Zero)
            Name (CTCD, One)
            Name (CTCU, 0x02)
            OperationRegion (MCHB, SystemMemory, (MHBR << 0x0F), 0x8000)
            Field (MCHB, DWordAcc, Lock, Preserve)
            {
                Offset (0x5930), 
                CTDN,   15, 
                Offset (0x59A0), 
                PL1V,   15, 
                PL1E,   1, 
                PL1C,   1, 
                PL1T,   7, 
                Offset (0x59A4), 
                PL2V,   15, 
                PL2E,   1, 
                PL2C,   1, 
                PL2T,   7, 
                Offset (0x5F3C), 
                TARN,   8, 
                Offset (0x5F40), 
                CTDD,   15, 
                Offset (0x5F42), 
                TARD,   8, 
                Offset (0x5F48), 
                CTDU,   15, 
                Offset (0x5F4A), 
                TARU,   8, 
                Offset (0x5F50), 
                CTCS,   2, 
                Offset (0x5F54), 
                TARS,   8
            }

            Method (PSSS, 1, NotSerialized)
            {
                Local0 = One
                Local1 = SizeOf (\_PR.CP00._PSS)
                While ((Local0 < Local1))
                {
                    Local2 = (DerefOf (DerefOf (\_PR.CP00._PSS [Local0]) [0x04]) >> 0x08)
                    If ((Local2 == Arg0))
                    {
                        Return ((Local0 - One))
                    }

                    Local0++
                }

                Return (Zero)
            }

            Method (STND, 0, Serialized)
            {
                If (Acquire (CTCM, 0x0064))
                {
                    Return (Zero)
                }

                If ((CTCD == CTCC))
                {
                    Release (CTCM)
                    Return (Zero)
                }

                Debug = "Set TDP Down"
                CTCS = CTCD /* \_SB_.PCI0.MCHC.CTCD */
                TARS = TARD /* \_SB_.PCI0.MCHC.TARD */
                PPCM = PSSS (TARD)
                PPCN ()
                PL2V = ((CTDD * 0x7D) / 0x64)
                PL1V = CTDD /* \_SB_.PCI0.MCHC.CTDD */
                CTCC = CTCD /* \_SB_.PCI0.MCHC.CTCD */
                Release (CTCM)
                Return (One)
            }

            Method (STDN, 0, Serialized)
            {
                If (Acquire (CTCM, 0x0064))
                {
                    Return (Zero)
                }

                If ((CTCN == CTCC))
                {
                    Release (CTCM)
                    Return (Zero)
                }

                Debug = "Set TDP Nominal"
                PL1V = CTDN /* \_SB_.PCI0.MCHC.CTDN */
                PL2V = ((CTDN * 0x7D) / 0x64)
                PPCM = PSSS (TARN)
                PPCN ()
                TARS = TARN /* \_SB_.PCI0.MCHC.TARN */
                CTCS = CTCN /* \_SB_.PCI0.MCHC.CTCN */
                CTCC = CTCN /* \_SB_.PCI0.MCHC.CTCN */
                Release (CTCM)
                Return (One)
            }
        }

        Name (MCRS, ResourceTemplate ()
        {
            WordBusNumber (ResourceProducer, MinFixed, MaxFixed, PosDecode,
                0x0000,             // Granularity
                0x0000,             // Range Minimum
                0x00FF,             // Range Maximum
                0x0000,             // Translation Offset
                0x0100,             // Length
                ,, )
            DWordIO (ResourceProducer, MinFixed, MaxFixed, PosDecode, EntireRange,
                0x00000000,         // Granularity
                0x00000000,         // Range Minimum
                0x00000CF7,         // Range Maximum
                0x00000000,         // Translation Offset
                0x00000CF8,         // Length
                ,, , TypeStatic, DenseTranslation)
            IO (Decode16,
                0x0CF8,             // Range Minimum
                0x0CF8,             // Range Maximum
                0x01,               // Alignment
                0x08,               // Length
                )
            DWordIO (ResourceProducer, MinFixed, MaxFixed, PosDecode, EntireRange,
                0x00000000,         // Granularity
                0x00000D00,         // Range Minimum
                0x0000FFFF,         // Range Maximum
                0x00000000,         // Translation Offset
                0x0000F300,         // Length
                ,, , TypeStatic, DenseTranslation)
            DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                0x00000000,         // Granularity
                0x000A0000,         // Range Minimum
                0x000BFFFF,         // Range Maximum
                0x00000000,         // Translation Offset
                0x00020000,         // Length
                ,, , AddressRangeMemory, TypeStatic)
            DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                0x00000000,         // Granularity
                0x000C0000,         // Range Minimum
                0x000C3FFF,         // Range Maximum
                0x00000000,         // Translation Offset
                0x00004000,         // Length
                ,, , AddressRangeMemory, TypeStatic)
            DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                0x00000000,         // Granularity
                0x000C4000,         // Range Minimum
                0x000C7FFF,         // Range Maximum
                0x00000000,         // Translation Offset
                0x00004000,         // Length
                ,, , AddressRangeMemory, TypeStatic)
            DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                0x00000000,         // Granularity
                0x000C8000,         // Range Minimum
                0x000CBFFF,         // Range Maximum
                0x00000000,         // Translation Offset
                0x00004000,         // Length
                ,, , AddressRangeMemory, TypeStatic)
            DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                0x00000000,         // Granularity
                0x000CC000,         // Range Minimum
                0x000CFFFF,         // Range Maximum
                0x00000000,         // Translation Offset
                0x00004000,         // Length
                ,, , AddressRangeMemory, TypeStatic)
            DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                0x00000000,         // Granularity
                0x000D0000,         // Range Minimum
                0x000D3FFF,         // Range Maximum
                0x00000000,         // Translation Offset
                0x00004000,         // Length
                ,, , AddressRangeMemory, TypeStatic)
            DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                0x00000000,         // Granularity
                0x000D4000,         // Range Minimum
                0x000D7FFF,         // Range Maximum
                0x00000000,         // Translation Offset
                0x00004000,         // Length
                ,, , AddressRangeMemory, TypeStatic)
            DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                0x00000000,         // Granularity
                0x000D8000,         // Range Minimum
                0x000DBFFF,         // Range Maximum
                0x00000000,         // Translation Offset
                0x00004000,         // Length
                ,, , AddressRangeMemory, TypeStatic)
            DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                0x00000000,         // Granularity
                0x000DC000,         // Range Minimum
                0x000DFFFF,         // Range Maximum
                0x00000000,         // Translation Offset
                0x00004000,         // Length
                ,, , AddressRangeMemory, TypeStatic)
            DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                0x00000000,         // Granularity
                0x000E0000,         // Range Minimum
                0x000E3FFF,         // Range Maximum
                0x00000000,         // Translation Offset
                0x00004000,         // Length
                ,, , AddressRangeMemory, TypeStatic)
            DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                0x00000000,         // Granularity
                0x000E4000,         // Range Minimum
                0x000E7FFF,         // Range Maximum
                0x00000000,         // Translation Offset
                0x00004000,         // Length
                ,, , AddressRangeMemory, TypeStatic)
            DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                0x00000000,         // Granularity
                0x000E8000,         // Range Minimum
                0x000EBFFF,         // Range Maximum
                0x00000000,         // Translation Offset
                0x00004000,         // Length
                ,, , AddressRangeMemory, TypeStatic)
            DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                0x00000000,         // Granularity
                0x000EC000,         // Range Minimum
                0x000EFFFF,         // Range Maximum
                0x00000000,         // Translation Offset
                0x00004000,         // Length
                ,, , AddressRangeMemory, TypeStatic)
            DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                0x00000000,         // Granularity
                0x000F0000,         // Range Minimum
                0x000FFFFF,         // Range Maximum
                0x00000000,         // Translation Offset
                0x00010000,         // Length
                ,, , AddressRangeMemory, TypeStatic)
            DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                0x00000000,         // Granularity
                0x00000000,         // Range Minimum
                0x00000000,         // Range Maximum
                0x00000000,         // Translation Offset
                0x00000000,         // Length
                ,, _Y00, AddressRangeMemory, TypeStatic)
            DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                0x00000000,         // Granularity
                0xFED40000,         // Range Minimum
                0xFED44FFF,         // Range Maximum
                0x00000000,         // Translation Offset
                0x00005000,         // Length
                ,, , AddressRangeMemory, TypeStatic)
        })
        Method (_CRS, 0, Serialized)  // _CRS: Current Resource Settings
        {
            CreateDWordField (MCRS, \_SB.PCI0._Y00._MIN, PMIN)  // _MIN: Minimum Base Address
            CreateDWordField (MCRS, \_SB.PCI0._Y00._MAX, PMAX)  // _MAX: Maximum Base Address
            CreateDWordField (MCRS, \_SB.PCI0._Y00._LEN, PLEN)  // _LEN: Length
            Local0 = ^MCHC.TLUD /* \_SB_.PCI0.MCHC.TLUD */
            Local1 = ^MCHC.MEBA /* \_SB_.PCI0.MCHC.MEBA */
            If ((Local0 == Local1))
            {
                Local0 = ^MCHC.TOM /* \_SB_.PCI0.MCHC.TOM_ */
            }

            PMIN = Local0
            PMAX = 0xEFFFFFFF
            PLEN = ((PMAX - PMIN) + One)
            Return (MCRS) /* \_SB_.PCI0.MCRS */
        }

        Device (PEGP)
        {
            Name (_ADR, 0x00010000)  // _ADR: Address
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Local0 = (^^MCHC.DVEN >> 0x03)
                Return ((Local0 & One))
            }

            Device (DEV0)
            {
                Name (_ADR, Zero)  // _ADR: Address
            }
        }

        Device (PEG1)
        {
            Name (_ADR, 0x00010001)  // _ADR: Address
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Local0 = (^^MCHC.DVEN >> 0x02)
                Return ((Local0 & One))
            }

            Device (DEV0)
            {
                Name (_ADR, Zero)  // _ADR: Address
            }
        }

        Device (PEG2)
        {
            Name (_ADR, 0x00010002)  // _ADR: Address
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Local0 = (^^MCHC.DVEN >> One)
                Return ((Local0 & One))
            }

            Device (DEV0)
            {
                Name (_ADR, Zero)  // _ADR: Address
            }
        }

        Device (PEG6)
        {
            Name (_ADR, 0x00060000)  // _ADR: Address
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Local0 = (^^MCHC.DVEN >> 0x0D)
                Return ((Local0 & One))
            }

            Device (DEV0)
            {
                Name (_ADR, Zero)  // _ADR: Address
            }
        }

        Device (PDRC)
        {
            Name (_HID, EisaId ("PNP0C02") /* PNP Motherboard Resources */)  // _HID: Hardware ID
            Name (_UID, One)  // _UID: Unique ID
            Name (PDRS, ResourceTemplate ()
            {
                Memory32Fixed (ReadWrite,
                    0xFED1C000,         // Address Base
                    0x00004000,         // Address Length
                    )
                Memory32Fixed (ReadWrite,
                    0x00000000,         // Address Base
                    0x00008000,         // Address Length
                    _Y01)
                Memory32Fixed (ReadWrite,
                    0x00000000,         // Address Base
                    0x00001000,         // Address Length
                    _Y02)
                Memory32Fixed (ReadWrite,
                    0x00000000,         // Address Base
                    0x00001000,         // Address Length
                    _Y03)
                Memory32Fixed (ReadWrite,
                    0x00000000,         // Address Base
                    0x04000000,         // Address Length
                    _Y04)
                Memory32Fixed (ReadWrite,
                    0xFED20000,         // Address Base
                    0x00020000,         // Address Length
                    )
                Memory32Fixed (ReadWrite,
                    0xFED40000,         // Address Base
                    0x00005000,         // Address Length
                    )
                Memory32Fixed (ReadWrite,
                    0xFED45000,         // Address Base
                    0x0004B000,         // Address Length
                    )
                Memory32Fixed (ReadWrite,
                    0x20000000,         // Address Base
                    0x00200000,         // Address Length
                    )
                Memory32Fixed (ReadWrite,
                    0x40000000,         // Address Base
                    0x00200000,         // Address Length
                    )
            })
            Method (_CRS, 0, Serialized)  // _CRS: Current Resource Settings
            {
                CreateDWordField (PDRS, \_SB.PCI0.PDRC._Y01._BAS, MBR0)  // _BAS: Base Address
                MBR0 = (^^MCHC.MHBR << 0x0F)
                CreateDWordField (PDRS, \_SB.PCI0.PDRC._Y02._BAS, DBR0)  // _BAS: Base Address
                DBR0 = (^^MCHC.DMBR << 0x0C)
                CreateDWordField (PDRS, \_SB.PCI0.PDRC._Y03._BAS, EBR0)  // _BAS: Base Address
                EBR0 = (^^MCHC.EPBR << 0x0C)
                CreateDWordField (PDRS, \_SB.PCI0.PDRC._Y04._BAS, XBR0)  // _BAS: Base Address
                XBR0 = (^^MCHC.PXBR << 0x1A)
                CreateDWordField (PDRS, \_SB.PCI0.PDRC._Y04._LEN, XSZ0)  // _LEN: Length
                XSZ0 = (0x10000000 << ^^MCHC.PXSZ) /* \_SB_.PCI0.MCHC.PXSZ */
                Return (PDRS) /* \_SB_.PCI0.PDRC.PDRS */
            }
        }

        Device (GFX0)
        {
            Name (_ADR, 0x00020000)  // _ADR: Address
            OperationRegion (GFXC, PCI_Config, Zero, 0x0100)
            Field (GFXC, DWordAcc, NoLock, Preserve)
            {
                Offset (0x10), 
                BAR0,   64, 
                Offset (0xE4), 
                ASLE,   32, 
                Offset (0xFC), 
                ASLS,   32
            }

            OperationRegion (GFRG, SystemMemory, (BAR0 & 0xFFFFFFFFFFFFFFF0), 0x00400000)
            Field (GFRG, DWordAcc, NoLock, Preserve)
            {
                Offset (0x48254), 
                BCLV,   16, 
                Offset (0xC8256), 
                BCLM,   16
            }

            Device (BOX3)
            {
                Name (_ADR, Zero)  // _ADR: Address
                OperationRegion (OPRG, SystemMemory, ASLS, 0x2000)
                Field (OPRG, DWordAcc, NoLock, Preserve)
                {
                    Offset (0x58), 
                    MBOX,   32, 
                    Offset (0x300), 
                    ARDY,   1, 
                    Offset (0x304), 
                    ASLC,   32, 
                    TCHE,   32, 
                    ALSI,   32, 
                    BCLP,   32, 
                    PFIT,   32, 
                    CBLV,   32
                }

                Method (XBCM, 1, Serialized)
                {
                    If ((ASLS == Zero))
                    {
                        Return (Ones)
                    }

                    If (((MBOX & 0x04) == Zero))
                    {
                        Return (Ones)
                    }

                    Local1 = ((Arg0 * 0xFF) / 0x64)
                    If ((Local1 > 0xFF))
                    {
                        Local1 = 0xFF
                    }

                    BCLP = (Local1 | 0x80000000)
                    If ((ARDY == Zero))
                    {
                        Return (Ones)
                    }

                    ASLC = 0x02
                    ASLE = One
                    Local0 = 0x20
                    While ((Local0 > Zero))
                    {
                        Sleep (One)
                        If (((ASLC & 0x02) == Zero))
                        {
                            Local1 = ((ASLC >> 0x0C) & 0x03)
                            If ((Local1 == Zero))
                            {
                                Return (Zero)
                            }
                            Else
                            {
                                Return (Ones)
                            }
                        }

                        Local0--
                    }

                    Return (Ones)
                }
            }

            Device (LEGA)
            {
                Name (_ADR, Zero)  // _ADR: Address
                Method (DRCL, 2, NotSerialized)
                {
                    Return (((Arg0 + (Arg1 / 0x02)) / Arg1))
                }

                Method (XBCM, 1, NotSerialized)
                {
                    BCLV = DRCL ((Arg0 * BCLM), 0x64)
                }

                Method (XBQC, 0, NotSerialized)
                {
                    Local0 = DRCL ((BCLV * 0x64), BCLM)
                    Local1 = 0x02
                    While ((Local1 < (SizeOf (BRIG) - One)))
                    {
                        Local2 = DerefOf (BRIG [Local1])
                        Local3 = DerefOf (BRIG [(Local1 + One)])
                        If ((Local0 < Local3))
                        {
                            If (((Local0 < Local2) || ((Local0 - Local2) < (Local3 - 
                                Local0))))
                            {
                                Return (Local2)
                            }
                            Else
                            {
                                Return (Local3)
                            }
                        }

                        Local1++
                    }

                    Return (Local3)
                }
            }

            Method (XBCM, 1, NotSerialized)
            {
                If ((^BOX3.XBCM (Arg0) == Ones))
                {
                    ^LEGA.XBCM (Arg0)
                }
            }

            Method (XBQC, 0, NotSerialized)
            {
                Return (^LEGA.XBQC ())
            }

            Name (BRCT, Zero)
            Method (BRID, 1, NotSerialized)
            {
                Local0 = Match (BRIG, MEQ, Arg0, MTR, Zero, 0x02)
                If ((Local0 == Ones))
                {
                    Return ((SizeOf (BRIG) - One))
                }

                Return (Local0)
            }

            Method (XBCL, 0, NotSerialized)
            {
                BRCT = One
                Return (BRIG) /* \_SB_.PCI0.GFX0.BRIG */
            }

            Method (_DOS, 1, NotSerialized)  // _DOS: Disable Output Switching
            {
                DSEN = (Arg0 & 0x07)
            }

            Method (DECB, 0, NotSerialized)
            {
                If (BRCT)
                {
                    Notify (LCD0, 0x87) // Device-Specific
                }
                Else
                {
                    Local0 = BRID (XBQC ())
                    If ((Local0 != 0x02))
                    {
                        Local0--
                    }

                    XBCM (DerefOf (BRIG [Local0]))
                }
            }

            Method (INCB, 0, NotSerialized)
            {
                If (BRCT)
                {
                    Notify (LCD0, 0x86) // Device-Specific
                }
                Else
                {
                    Local0 = BRID (XBQC ())
                    If ((Local0 != (SizeOf (BRIG) - One)))
                    {
                        Local0++
                    }

                    XBCM (DerefOf (BRIG [Local0]))
                }
            }

            Method (XDCS, 1, NotSerialized)
            {
                TRAP (One)
                If ((CSTE & (One << Arg0)))
                {
                    Return (0x1F)
                }

                Return (0x1D)
            }

            Method (XDGS, 1, NotSerialized)
            {
                If ((NSTE & (One << Arg0)))
                {
                    Return (One)
                }

                Return (Zero)
            }

            Method (XDSS, 1, NotSerialized)
            {
                If (((Arg0 & 0xC0000000) == 0xC0000000))
                {
                    CSTE = NSTE /* \NSTE */
                }
            }
        }

        Scope (GFX0)
        {
            Name (BRIG, Package (0x12)
            {
                0x64, 
                0x64, 
                0x02, 
                0x04, 
                0x05, 
                0x07, 
                0x09, 
                0x0B, 
                0x0D, 
                0x12, 
                0x14, 
                0x18, 
                0x1D, 
                0x21, 
                0x28, 
                0x32, 
                0x43, 
                0x64
            })
        }

        Scope (\)
        {
            OperationRegion (IO_T, SystemIO, 0x0800, 0x10)
            Field (IO_T, ByteAcc, NoLock, Preserve)
            {
                Offset (0x08), 
                TRP0,   8
            }

            OperationRegion (PMIO, SystemIO, 0x0500, 0x80)
            Field (PMIO, ByteAcc, NoLock, Preserve)
            {
                Offset (0x20), 
                Offset (0x22), 
                GS00,   1, 
                GS01,   1, 
                GS02,   1, 
                GS03,   1, 
                GS04,   1, 
                GS05,   1, 
                GS06,   1, 
                GS07,   1, 
                GS08,   1, 
                GS09,   1, 
                GS10,   1, 
                GS11,   1, 
                GS12,   1, 
                GS13,   1, 
                GS14,   1, 
                GS15,   1, 
                Offset (0x28), 
                Offset (0x2A), 
                GE00,   1, 
                GE01,   1, 
                GE02,   1, 
                GE03,   1, 
                GE04,   1, 
                GE05,   1, 
                GE06,   1, 
                GE07,   1, 
                GE08,   1, 
                GE09,   1, 
                GE10,   1, 
                GE11,   1, 
                GE12,   1, 
                GE13,   1, 
                GE14,   1, 
                GE15,   1, 
                Offset (0x42), 
                    ,   1, 
                GPEC,   1
            }

            OperationRegion (GPIO, SystemIO, 0x0480, 0x6C)
            Field (GPIO, ByteAcc, NoLock, Preserve)
            {
                GU00,   8, 
                GU01,   8, 
                GU02,   8, 
                GU03,   8, 
                GIO0,   8, 
                GIO1,   8, 
                GIO2,   8, 
                GIO3,   8, 
                Offset (0x0C), 
                GP00,   1, 
                GP01,   1, 
                GP02,   1, 
                GP03,   1, 
                GP04,   1, 
                GP05,   1, 
                GP06,   1, 
                GP07,   1, 
                GP08,   1, 
                GP09,   1, 
                GP10,   1, 
                GP11,   1, 
                GP12,   1, 
                GP13,   1, 
                GP14,   1, 
                GP15,   1, 
                GP16,   1, 
                GP17,   1, 
                GP18,   1, 
                GP19,   1, 
                GP20,   1, 
                GP21,   1, 
                GP22,   1, 
                GP23,   1, 
                GP24,   1, 
                GP25,   1, 
                GP26,   1, 
                GP27,   1, 
                GP28,   1, 
                GP29,   1, 
                GP30,   1, 
                GP31,   1, 
                Offset (0x18), 
                GB00,   8, 
                GB01,   8, 
                GB02,   8, 
                GB03,   8, 
                Offset (0x2C), 
                GIV0,   8, 
                GIV1,   8, 
                GIV2,   8, 
                GIV3,   8, 
                GU04,   8, 
                GU05,   8, 
                GU06,   8, 
                GU07,   8, 
                GIO4,   8, 
                GIO5,   8, 
                GIO6,   8, 
                GIO7,   8, 
                GP32,   1, 
                GP33,   1, 
                GP34,   1, 
                GP35,   1, 
                GP36,   1, 
                GP37,   1, 
                GP38,   1, 
                GP39,   1, 
                GP40,   1, 
                GP41,   1, 
                GP42,   1, 
                GP43,   1, 
                GP44,   1, 
                GP45,   1, 
                GP46,   1, 
                GP47,   1, 
                GP48,   1, 
                GP49,   1, 
                GP50,   1, 
                GP51,   1, 
                GP52,   1, 
                GP53,   1, 
                GP54,   1, 
                GP55,   1, 
                GP56,   1, 
                GP57,   1, 
                GP58,   1, 
                GP59,   1, 
                GP60,   1, 
                GP61,   1, 
                GP62,   1, 
                GP63,   1, 
                Offset (0x40), 
                GU08,   8, 
                GU09,   4, 
                Offset (0x44), 
                GIO8,   8, 
                GIO9,   4, 
                Offset (0x48), 
                GP64,   1, 
                GP65,   1, 
                GP66,   1, 
                GP67,   1, 
                GP68,   1, 
                GP69,   1, 
                GP70,   1, 
                GP71,   1, 
                GP72,   1, 
                GP73,   1, 
                GP74,   1, 
                GP75,   1
            }

            OperationRegion (RCRB, SystemMemory, 0xFED1C000, 0x4000)
            Field (RCRB, DWordAcc, Lock, Preserve)
            {
                Offset (0x1000), 
                Offset (0x3000), 
                Offset (0x3404), 
                HPAS,   2, 
                    ,   5, 
                HPTE,   1, 
                Offset (0x3418), 
                    ,   1, 
                PCID,   1, 
                SA1D,   1, 
                SMBD,   1, 
                HDAD,   1, 
                    ,   8, 
                EH2D,   1, 
                LPBD,   1, 
                EH1D,   1, 
                RP1D,   1, 
                RP2D,   1, 
                RP3D,   1, 
                RP4D,   1, 
                RP5D,   1, 
                RP6D,   1, 
                RP7D,   1, 
                RP8D,   1, 
                TTRD,   1, 
                SA2D,   1, 
                Offset (0x3428), 
                BDFD,   1, 
                ME1D,   1, 
                ME2D,   1, 
                IDRD,   1, 
                KTCT,   1
            }
        }

        Device (HDEF)
        {
            Name (_ADR, 0x001B0000)  // _ADR: Address
            Name (_PRW, Package (0x02)  // _PRW: Power Resources for Wake
            {
                0x0D, 
                0x04
            })
        }

        Method (IRQM, 1, Serialized)
        {
            Name (IQAA, Package (0x04)
            {
                Package (0x04)
                {
                    0xFFFF, 
                    Zero, 
                    Zero, 
                    0x10
                }, 

                Package (0x04)
                {
                    0xFFFF, 
                    One, 
                    Zero, 
                    0x11
                }, 

                Package (0x04)
                {
                    0xFFFF, 
                    0x02, 
                    Zero, 
                    0x12
                }, 

                Package (0x04)
                {
                    0xFFFF, 
                    0x03, 
                    Zero, 
                    0x13
                }
            })
            Name (IQAP, Package (0x04)
            {
                Package (0x04)
                {
                    0xFFFF, 
                    Zero, 
                    ^LPCB.LNKA, 
                    Zero
                }, 

                Package (0x04)
                {
                    0xFFFF, 
                    One, 
                    ^LPCB.LNKB, 
                    Zero
                }, 

                Package (0x04)
                {
                    0xFFFF, 
                    0x02, 
                    ^LPCB.LNKC, 
                    Zero
                }, 

                Package (0x04)
                {
                    0xFFFF, 
                    0x03, 
                    ^LPCB.LNKD, 
                    Zero
                }
            })
            Name (IQBA, Package (0x04)
            {
                Package (0x04)
                {
                    0xFFFF, 
                    Zero, 
                    Zero, 
                    0x11
                }, 

                Package (0x04)
                {
                    0xFFFF, 
                    One, 
                    Zero, 
                    0x12
                }, 

                Package (0x04)
                {
                    0xFFFF, 
                    0x02, 
                    Zero, 
                    0x13
                }, 

                Package (0x04)
                {
                    0xFFFF, 
                    0x03, 
                    Zero, 
                    0x10
                }
            })
            Name (IQBP, Package (0x04)
            {
                Package (0x04)
                {
                    0xFFFF, 
                    Zero, 
                    ^LPCB.LNKB, 
                    Zero
                }, 

                Package (0x04)
                {
                    0xFFFF, 
                    One, 
                    ^LPCB.LNKC, 
                    Zero
                }, 

                Package (0x04)
                {
                    0xFFFF, 
                    0x02, 
                    ^LPCB.LNKD, 
                    Zero
                }, 

                Package (0x04)
                {
                    0xFFFF, 
                    0x03, 
                    ^LPCB.LNKA, 
                    Zero
                }
            })
            Name (IQCA, Package (0x04)
            {
                Package (0x04)
                {
                    0xFFFF, 
                    Zero, 
                    Zero, 
                    0x12
                }, 

                Package (0x04)
                {
                    0xFFFF, 
                    One, 
                    Zero, 
                    0x13
                }, 

                Package (0x04)
                {
                    0xFFFF, 
                    0x02, 
                    Zero, 
                    0x10
                }, 

                Package (0x04)
                {
                    0xFFFF, 
                    0x03, 
                    Zero, 
                    0x11
                }
            })
            Name (IQCP, Package (0x04)
            {
                Package (0x04)
                {
                    0xFFFF, 
                    Zero, 
                    ^LPCB.LNKC, 
                    Zero
                }, 

                Package (0x04)
                {
                    0xFFFF, 
                    One, 
                    ^LPCB.LNKD, 
                    Zero
                }, 

                Package (0x04)
                {
                    0xFFFF, 
                    0x02, 
                    ^LPCB.LNKA, 
                    Zero
                }, 

                Package (0x04)
                {
                    0xFFFF, 
                    0x03, 
                    ^LPCB.LNKB, 
                    Zero
                }
            })
            Name (IQDA, Package (0x04)
            {
                Package (0x04)
                {
                    0xFFFF, 
                    Zero, 
                    Zero, 
                    0x13
                }, 

                Package (0x04)
                {
                    0xFFFF, 
                    One, 
                    Zero, 
                    0x10
                }, 

                Package (0x04)
                {
                    0xFFFF, 
                    0x02, 
                    Zero, 
                    0x11
                }, 

                Package (0x04)
                {
                    0xFFFF, 
                    0x03, 
                    Zero, 
                    0x12
                }
            })
            Name (IQDP, Package (0x04)
            {
                Package (0x04)
                {
                    0xFFFF, 
                    Zero, 
                    ^LPCB.LNKD, 
                    Zero
                }, 

                Package (0x04)
                {
                    0xFFFF, 
                    One, 
                    ^LPCB.LNKA, 
                    Zero
                }, 

                Package (0x04)
                {
                    0xFFFF, 
                    0x02, 
                    ^LPCB.LNKB, 
                    Zero
                }, 

                Package (0x04)
                {
                    0xFFFF, 
                    0x03, 
                    ^LPCB.LNKC, 
                    Zero
                }
            })
            Switch (ToInteger (Arg0))
            {
                Case (Package (0x02)
                    {
                        One, 
                        0x05
                    }

)
                {
                    If (PICM)
                    {
                        Return (IQAA) /* \_SB_.PCI0.IRQM.IQAA */
                    }
                    Else
                    {
                        Return (IQAP) /* \_SB_.PCI0.IRQM.IQAP */
                    }
                }
                Case (Package (0x02)
                    {
                        0x02, 
                        0x06
                    }

)
                {
                    If (PICM)
                    {
                        Return (IQBA) /* \_SB_.PCI0.IRQM.IQBA */
                    }
                    Else
                    {
                        Return (IQBP) /* \_SB_.PCI0.IRQM.IQBP */
                    }
                }
                Case (Package (0x02)
                    {
                        0x03, 
                        0x07
                    }

)
                {
                    If (PICM)
                    {
                        Return (IQCA) /* \_SB_.PCI0.IRQM.IQCA */
                    }
                    Else
                    {
                        Return (IQCP) /* \_SB_.PCI0.IRQM.IQCP */
                    }
                }
                Case (Package (0x02)
                    {
                        0x04, 
                        0x08
                    }

)
                {
                    If (PICM)
                    {
                        Return (IQDA) /* \_SB_.PCI0.IRQM.IQDA */
                    }
                    Else
                    {
                        Return (IQDP) /* \_SB_.PCI0.IRQM.IQDP */
                    }
                }
                Default
                {
                    If (PICM)
                    {
                        Return (IQDA) /* \_SB_.PCI0.IRQM.IQDA */
                    }
                    Else
                    {
                        Return (IQDP) /* \_SB_.PCI0.IRQM.IQDP */
                    }
                }

            }
        }

        Device (RP01)
        {
            Name (_ADR, 0x001C0000)  // _ADR: Address
            OperationRegion (RPCS, PCI_Config, Zero, 0xFF)
            Field (RPCS, AnyAcc, NoLock, Preserve)
            {
                Offset (0x4C), 
                Offset (0x4F), 
                RPPN,   8, 
                Offset (0x5A), 
                    ,   3, 
                PDC,    1, 
                Offset (0xDF), 
                    ,   6, 
                HPCS,   1
            }

            Method (_PRT, 0, NotSerialized)  // _PRT: PCI Routing Table
            {
                Return (IRQM (RPPN))
            }
        }

        Device (RP02)
        {
            Name (_ADR, 0x001C0001)  // _ADR: Address
            OperationRegion (RPCS, PCI_Config, Zero, 0xFF)
            Field (RPCS, AnyAcc, NoLock, Preserve)
            {
                Offset (0x4C), 
                Offset (0x4F), 
                RPPN,   8, 
                Offset (0x5A), 
                    ,   3, 
                PDC,    1, 
                Offset (0xDF), 
                    ,   6, 
                HPCS,   1
            }

            Method (_PRT, 0, NotSerialized)  // _PRT: PCI Routing Table
            {
                Return (IRQM (RPPN))
            }
        }

        Device (RP03)
        {
            Name (_ADR, 0x001C0002)  // _ADR: Address
            OperationRegion (RPCS, PCI_Config, Zero, 0xFF)
            Field (RPCS, AnyAcc, NoLock, Preserve)
            {
                Offset (0x4C), 
                Offset (0x4F), 
                RPPN,   8, 
                Offset (0x5A), 
                    ,   3, 
                PDC,    1, 
                Offset (0xDF), 
                    ,   6, 
                HPCS,   1
            }

            Method (_PRT, 0, NotSerialized)  // _PRT: PCI Routing Table
            {
                Return (IRQM (RPPN))
            }
        }

        Device (RP04)
        {
            Name (_ADR, 0x001C0003)  // _ADR: Address
            OperationRegion (RPCS, PCI_Config, Zero, 0xFF)
            Field (RPCS, AnyAcc, NoLock, Preserve)
            {
                Offset (0x4C), 
                Offset (0x4F), 
                RPPN,   8, 
                Offset (0x5A), 
                    ,   3, 
                PDC,    1, 
                Offset (0xDF), 
                    ,   6, 
                HPCS,   1
            }

            Method (_PRT, 0, NotSerialized)  // _PRT: PCI Routing Table
            {
                Return (IRQM (RPPN))
            }
        }

        Device (RP05)
        {
            Name (_ADR, 0x001C0004)  // _ADR: Address
            OperationRegion (RPCS, PCI_Config, Zero, 0xFF)
            Field (RPCS, AnyAcc, NoLock, Preserve)
            {
                Offset (0x4C), 
                Offset (0x4F), 
                RPPN,   8, 
                Offset (0x5A), 
                    ,   3, 
                PDC,    1, 
                Offset (0xDF), 
                    ,   6, 
                HPCS,   1
            }

            Method (_PRT, 0, NotSerialized)  // _PRT: PCI Routing Table
            {
                Return (IRQM (RPPN))
            }
        }

        Device (RP06)
        {
            Name (_ADR, 0x001C0005)  // _ADR: Address
            OperationRegion (RPCS, PCI_Config, Zero, 0xFF)
            Field (RPCS, AnyAcc, NoLock, Preserve)
            {
                Offset (0x4C), 
                Offset (0x4F), 
                RPPN,   8, 
                Offset (0x5A), 
                    ,   3, 
                PDC,    1, 
                Offset (0xDF), 
                    ,   6, 
                HPCS,   1
            }

            Method (_PRT, 0, NotSerialized)  // _PRT: PCI Routing Table
            {
                Return (IRQM (RPPN))
            }
        }

        Device (RP07)
        {
            Name (_ADR, 0x001C0006)  // _ADR: Address
            OperationRegion (RPCS, PCI_Config, Zero, 0xFF)
            Field (RPCS, AnyAcc, NoLock, Preserve)
            {
                Offset (0x4C), 
                Offset (0x4F), 
                RPPN,   8, 
                Offset (0x5A), 
                    ,   3, 
                PDC,    1, 
                Offset (0xDF), 
                    ,   6, 
                HPCS,   1
            }

            Method (_PRT, 0, NotSerialized)  // _PRT: PCI Routing Table
            {
                Return (IRQM (RPPN))
            }
        }

        Device (RP08)
        {
            Name (_ADR, 0x001C0007)  // _ADR: Address
            OperationRegion (RPCS, PCI_Config, Zero, 0xFF)
            Field (RPCS, AnyAcc, NoLock, Preserve)
            {
                Offset (0x4C), 
                Offset (0x4F), 
                RPPN,   8, 
                Offset (0x5A), 
                    ,   3, 
                PDC,    1, 
                Offset (0xDF), 
                    ,   6, 
                HPCS,   1
            }

            Method (_PRT, 0, NotSerialized)  // _PRT: PCI Routing Table
            {
                Return (IRQM (RPPN))
            }
        }

        Device (EHC1)
        {
            Name (_ADR, 0x001D0000)  // _ADR: Address
            Name (_PRW, Package (0x02)  // _PRW: Power Resources for Wake
            {
                0x0D, 
                0x04
            })
            Method (_S3D, 0, NotSerialized)  // _S3D: S3 Device State
            {
                Return (0x02)
            }

            Method (_S4D, 0, NotSerialized)  // _S4D: S4 Device State
            {
                Return (0x02)
            }

            Device (HUB7)
            {
                Name (_ADR, Zero)  // _ADR: Address
                Method (GPLD, 1, Serialized)
                {
                    Name (PCKG, Package (0x01)
                    {
                        Buffer (0x10){}
                    })
                    CreateField (DerefOf (PCKG [Zero]), Zero, 0x07, REV)
                    REV = 0x02
                    CreateField (DerefOf (PCKG [Zero]), 0x40, One, VISI)
                    VISI = Arg0
                    Return (PCKG) /* \_SB_.PCI0.EHC1.HUB7.GPLD.PCKG */
                }

                Device (PRT1)
                {
                    Name (_ADR, One)  // _ADR: Address
                }

                Device (PRT2)
                {
                    Name (_ADR, 0x02)  // _ADR: Address
                }

                Device (PRT3)
                {
                    Name (_ADR, 0x03)  // _ADR: Address
                }

                Device (PRT4)
                {
                    Name (_ADR, 0x04)  // _ADR: Address
                }

                Device (PRT5)
                {
                    Name (_ADR, 0x05)  // _ADR: Address
                }

                Device (PRT6)
                {
                    Name (_ADR, 0x06)  // _ADR: Address
                }
            }
        }

        Device (EHC2)
        {
            Name (_ADR, 0x001A0000)  // _ADR: Address
            Name (_PRW, Package (0x02)  // _PRW: Power Resources for Wake
            {
                0x0D, 
                0x04
            })
            Method (_S3D, 0, NotSerialized)  // _S3D: S3 Device State
            {
                Return (0x02)
            }

            Method (_S4D, 0, NotSerialized)  // _S4D: S4 Device State
            {
                Return (0x02)
            }

            Device (HUB7)
            {
                Name (_ADR, Zero)  // _ADR: Address
                Method (GPLD, 1, Serialized)
                {
                    Name (PCKG, Package (0x01)
                    {
                        Buffer (0x10){}
                    })
                    CreateField (DerefOf (PCKG [Zero]), Zero, 0x07, REV)
                    REV = 0x02
                    CreateField (DerefOf (PCKG [Zero]), 0x40, One, VISI)
                    VISI = Arg0
                    Return (PCKG) /* \_SB_.PCI0.EHC2.HUB7.GPLD.PCKG */
                }

                Device (PRT1)
                {
                    Name (_ADR, One)  // _ADR: Address
                }

                Device (PRT2)
                {
                    Name (_ADR, 0x02)  // _ADR: Address
                }

                Device (PRT3)
                {
                    Name (_ADR, 0x03)  // _ADR: Address
                }

                Device (PRT4)
                {
                    Name (_ADR, 0x04)  // _ADR: Address
                }

                Device (PRT5)
                {
                    Name (_ADR, 0x05)  // _ADR: Address
                }

                Device (PRT6)
                {
                    Name (_ADR, 0x06)  // _ADR: Address
                }
            }
        }

        Device (XHC)
        {
            Name (_ADR, 0x00140000)  // _ADR: Address
            OperationRegion (XDEV, PCI_Config, Zero, 0x0100)
            Field (XDEV, DWordAcc, NoLock, Preserve)
            {
                Offset (0xD0), 
                X2PR,   32, 
                PRM2,   32, 
                SSEN,   32, 
                RPM3,   32, 
                XPRT,   32
            }

            Name (_PRW, Package (0x02)  // _PRW: Power Resources for Wake
            {
                0x0D, 
                0x04
            })
            Method (POSC, 2, Serialized)
            {
                CreateDWordField (Arg1, Zero, CDW1)
                If ((Arg0 != One))
                {
                    CDW1 |= 0x08
                }

                If ((XHCI == Zero))
                {
                    CDW1 |= 0x02
                }

                If ((!(CDW1 & One) && ((XHCI == 0x02) || (
                    XHCI == 0x03))))
                {
                    Debug = "XHCI Switch"
                    Local0 = Zero
                    Local0 = (XPRT & 0x03)
                    If (((Local0 == Zero) || (Local0 == One)))
                    {
                        Local1 = 0x0F
                    }
                    ElseIf ((Local0 == 0x02))
                    {
                        Local1 = 0x03
                    }
                    ElseIf ((Local0 == 0x03))
                    {
                        Local1 = Zero
                    }

                    Local0 = (RPM3 & 0xFFFFFFF0)
                    RPM3 = (Local0 | Local1)
                    Local0 = (PRM2 & 0xFFFFFFF0)
                    PRM2 = (Local0 | Local1)
                    Local0 = (SSEN & 0xFFFFFFF0)
                    SSEN = (Local0 | Local1)
                    Local0 = (X2PR & 0xFFFFFFF0)
                    X2PR = (Local0 | Local1)
                }

                Return (Arg1)
            }

            Method (_S3D, 0, NotSerialized)  // _S3D: S3 Device State
            {
                Return (0x02)
            }

            Method (_S4D, 0, NotSerialized)  // _S4D: S4 Device State
            {
                Return (0x02)
            }
        }

        Device (LPCB)
        {
            Name (_ADR, 0x001F0000)  // _ADR: Address
            OperationRegion (LPC0, PCI_Config, Zero, 0x0100)
            Field (LPC0, AnyAcc, NoLock, Preserve)
            {
                Offset (0x40), 
                PMBS,   16, 
                Offset (0x60), 
                PRTA,   8, 
                PRTB,   8, 
                PRTC,   8, 
                PRTD,   8, 
                Offset (0x68), 
                PRTE,   8, 
                PRTF,   8, 
                PRTG,   8, 
                PRTH,   8, 
                Offset (0x80), 
                IOD0,   8, 
                IOD1,   8, 
                Offset (0xB8), 
                GR00,   2, 
                GR01,   2, 
                GR02,   2, 
                GR03,   2, 
                GR04,   2, 
                GR05,   2, 
                GR06,   2, 
                GR07,   2, 
                GR08,   2, 
                GR09,   2, 
                GR10,   2, 
                GR11,   2, 
                GR12,   2, 
                GR13,   2, 
                GR14,   2, 
                GR15,   2, 
                Offset (0xF0), 
                RCEN,   1, 
                    ,   13, 
                RCBA,   18
            }

            Device (LNKA)
            {
                Name (_HID, EisaId ("PNP0C0F") /* PCI Interrupt Link Device */)  // _HID: Hardware ID
                Name (_UID, One)  // _UID: Unique ID
                Method (_DIS, 0, Serialized)  // _DIS: Disable Device
                {
                    PRTA = 0x80
                }

                Name (_PRS, ResourceTemplate ()  // _PRS: Possible Resource Settings
                {
                    IRQ (Level, ActiveLow, Shared, )
                        {3,4,5,6,7,10,11,12,14,15}
                })
                Method (_CRS, 0, Serialized)  // _CRS: Current Resource Settings
                {
                    Name (RTLA, ResourceTemplate ()
                    {
                        IRQ (Level, ActiveLow, Shared, )
                            {}
                    })
                    CreateWordField (RTLA, One, IRQ0)
                    IRQ0 = Zero
                    IRQ0 = (One << (PRTA & 0x0F))
                    Return (RTLA) /* \_SB_.PCI0.LPCB.LNKA._CRS.RTLA */
                }

                Method (_SRS, 1, Serialized)  // _SRS: Set Resource Settings
                {
                    CreateWordField (Arg0, One, IRQ0)
                    FindSetRightBit (IRQ0, Local0)
                    Local0--
                    PRTA = Local0
                }

                Method (_STA, 0, Serialized)  // _STA: Status
                {
                    If ((PRTA & 0x80))
                    {
                        Return (0x09)
                    }
                    Else
                    {
                        Return (0x0B)
                    }
                }
            }

            Device (LNKB)
            {
                Name (_HID, EisaId ("PNP0C0F") /* PCI Interrupt Link Device */)  // _HID: Hardware ID
                Name (_UID, 0x02)  // _UID: Unique ID
                Method (_DIS, 0, Serialized)  // _DIS: Disable Device
                {
                    PRTB = 0x80
                }

                Name (_PRS, ResourceTemplate ()  // _PRS: Possible Resource Settings
                {
                    IRQ (Level, ActiveLow, Shared, )
                        {3,4,5,6,7,10,11,12,14,15}
                })
                Method (_CRS, 0, Serialized)  // _CRS: Current Resource Settings
                {
                    Name (RTLB, ResourceTemplate ()
                    {
                        IRQ (Level, ActiveLow, Shared, )
                            {}
                    })
                    CreateWordField (RTLB, One, IRQ0)
                    IRQ0 = Zero
                    IRQ0 = (One << (PRTB & 0x0F))
                    Return (RTLB) /* \_SB_.PCI0.LPCB.LNKB._CRS.RTLB */
                }

                Method (_SRS, 1, Serialized)  // _SRS: Set Resource Settings
                {
                    CreateWordField (Arg0, One, IRQ0)
                    FindSetRightBit (IRQ0, Local0)
                    Local0--
                    PRTB = Local0
                }

                Method (_STA, 0, Serialized)  // _STA: Status
                {
                    If ((PRTB & 0x80))
                    {
                        Return (0x09)
                    }
                    Else
                    {
                        Return (0x0B)
                    }
                }
            }

            Device (LNKC)
            {
                Name (_HID, EisaId ("PNP0C0F") /* PCI Interrupt Link Device */)  // _HID: Hardware ID
                Name (_UID, 0x03)  // _UID: Unique ID
                Method (_DIS, 0, Serialized)  // _DIS: Disable Device
                {
                    PRTC = 0x80
                }

                Name (_PRS, ResourceTemplate ()  // _PRS: Possible Resource Settings
                {
                    IRQ (Level, ActiveLow, Shared, )
                        {3,4,5,6,7,10,11,12,14,15}
                })
                Method (_CRS, 0, Serialized)  // _CRS: Current Resource Settings
                {
                    Name (RTLC, ResourceTemplate ()
                    {
                        IRQ (Level, ActiveLow, Shared, )
                            {}
                    })
                    CreateWordField (RTLC, One, IRQ0)
                    IRQ0 = Zero
                    IRQ0 = (One << (PRTC & 0x0F))
                    Return (RTLC) /* \_SB_.PCI0.LPCB.LNKC._CRS.RTLC */
                }

                Method (_SRS, 1, Serialized)  // _SRS: Set Resource Settings
                {
                    CreateWordField (Arg0, One, IRQ0)
                    FindSetRightBit (IRQ0, Local0)
                    Local0--
                    PRTC = Local0
                }

                Method (_STA, 0, Serialized)  // _STA: Status
                {
                    If ((PRTC & 0x80))
                    {
                        Return (0x09)
                    }
                    Else
                    {
                        Return (0x0B)
                    }
                }
            }

            Device (LNKD)
            {
                Name (_HID, EisaId ("PNP0C0F") /* PCI Interrupt Link Device */)  // _HID: Hardware ID
                Name (_UID, 0x04)  // _UID: Unique ID
                Method (_DIS, 0, Serialized)  // _DIS: Disable Device
                {
                    PRTD = 0x80
                }

                Name (_PRS, ResourceTemplate ()  // _PRS: Possible Resource Settings
                {
                    IRQ (Level, ActiveLow, Shared, )
                        {3,4,5,6,7,10,11,12,14,15}
                })
                Method (_CRS, 0, Serialized)  // _CRS: Current Resource Settings
                {
                    Name (RTLD, ResourceTemplate ()
                    {
                        IRQ (Level, ActiveLow, Shared, )
                            {}
                    })
                    CreateWordField (RTLD, One, IRQ0)
                    IRQ0 = Zero
                    IRQ0 = (One << (PRTD & 0x0F))
                    Return (RTLD) /* \_SB_.PCI0.LPCB.LNKD._CRS.RTLD */
                }

                Method (_SRS, 1, Serialized)  // _SRS: Set Resource Settings
                {
                    CreateWordField (Arg0, One, IRQ0)
                    FindSetRightBit (IRQ0, Local0)
                    Local0--
                    PRTD = Local0
                }

                Method (_STA, 0, Serialized)  // _STA: Status
                {
                    If ((PRTD & 0x80))
                    {
                        Return (0x09)
                    }
                    Else
                    {
                        Return (0x0B)
                    }
                }
            }

            Device (LNKE)
            {
                Name (_HID, EisaId ("PNP0C0F") /* PCI Interrupt Link Device */)  // _HID: Hardware ID
                Name (_UID, 0x05)  // _UID: Unique ID
                Method (_DIS, 0, Serialized)  // _DIS: Disable Device
                {
                    PRTE = 0x80
                }

                Name (_PRS, ResourceTemplate ()  // _PRS: Possible Resource Settings
                {
                    IRQ (Level, ActiveLow, Shared, )
                        {3,4,5,6,7,10,11,12,14,15}
                })
                Method (_CRS, 0, Serialized)  // _CRS: Current Resource Settings
                {
                    Name (RTLE, ResourceTemplate ()
                    {
                        IRQ (Level, ActiveLow, Shared, )
                            {}
                    })
                    CreateWordField (RTLE, One, IRQ0)
                    IRQ0 = Zero
                    IRQ0 = (One << (PRTE & 0x0F))
                    Return (RTLE) /* \_SB_.PCI0.LPCB.LNKE._CRS.RTLE */
                }

                Method (_SRS, 1, Serialized)  // _SRS: Set Resource Settings
                {
                    CreateWordField (Arg0, One, IRQ0)
                    FindSetRightBit (IRQ0, Local0)
                    Local0--
                    PRTE = Local0
                }

                Method (_STA, 0, Serialized)  // _STA: Status
                {
                    If ((PRTE & 0x80))
                    {
                        Return (0x09)
                    }
                    Else
                    {
                        Return (0x0B)
                    }
                }
            }

            Device (LNKF)
            {
                Name (_HID, EisaId ("PNP0C0F") /* PCI Interrupt Link Device */)  // _HID: Hardware ID
                Name (_UID, 0x06)  // _UID: Unique ID
                Method (_DIS, 0, Serialized)  // _DIS: Disable Device
                {
                    PRTF = 0x80
                }

                Name (_PRS, ResourceTemplate ()  // _PRS: Possible Resource Settings
                {
                    IRQ (Level, ActiveLow, Shared, )
                        {3,4,5,6,7,10,11,12,14,15}
                })
                Method (_CRS, 0, Serialized)  // _CRS: Current Resource Settings
                {
                    Name (RTLF, ResourceTemplate ()
                    {
                        IRQ (Level, ActiveLow, Shared, )
                            {}
                    })
                    CreateWordField (RTLF, One, IRQ0)
                    IRQ0 = Zero
                    IRQ0 = (One << (PRTF & 0x0F))
                    Return (RTLF) /* \_SB_.PCI0.LPCB.LNKF._CRS.RTLF */
                }

                Method (_SRS, 1, Serialized)  // _SRS: Set Resource Settings
                {
                    CreateWordField (Arg0, One, IRQ0)
                    FindSetRightBit (IRQ0, Local0)
                    Local0--
                    PRTF = Local0
                }

                Method (_STA, 0, Serialized)  // _STA: Status
                {
                    If ((PRTF & 0x80))
                    {
                        Return (0x09)
                    }
                    Else
                    {
                        Return (0x0B)
                    }
                }
            }

            Device (LNKG)
            {
                Name (_HID, EisaId ("PNP0C0F") /* PCI Interrupt Link Device */)  // _HID: Hardware ID
                Name (_UID, 0x07)  // _UID: Unique ID
                Method (_DIS, 0, Serialized)  // _DIS: Disable Device
                {
                    PRTG = 0x80
                }

                Name (_PRS, ResourceTemplate ()  // _PRS: Possible Resource Settings
                {
                    IRQ (Level, ActiveLow, Shared, )
                        {3,4,5,6,7,10,11,12,14,15}
                })
                Method (_CRS, 0, Serialized)  // _CRS: Current Resource Settings
                {
                    Name (RTLG, ResourceTemplate ()
                    {
                        IRQ (Level, ActiveLow, Shared, )
                            {}
                    })
                    CreateWordField (RTLG, One, IRQ0)
                    IRQ0 = Zero
                    IRQ0 = (One << (PRTG & 0x0F))
                    Return (RTLG) /* \_SB_.PCI0.LPCB.LNKG._CRS.RTLG */
                }

                Method (_SRS, 1, Serialized)  // _SRS: Set Resource Settings
                {
                    CreateWordField (Arg0, One, IRQ0)
                    FindSetRightBit (IRQ0, Local0)
                    Local0--
                    PRTG = Local0
                }

                Method (_STA, 0, Serialized)  // _STA: Status
                {
                    If ((PRTG & 0x80))
                    {
                        Return (0x09)
                    }
                    Else
                    {
                        Return (0x0B)
                    }
                }
            }

            Device (LNKH)
            {
                Name (_HID, EisaId ("PNP0C0F") /* PCI Interrupt Link Device */)  // _HID: Hardware ID
                Name (_UID, 0x08)  // _UID: Unique ID
                Method (_DIS, 0, Serialized)  // _DIS: Disable Device
                {
                    PRTH = 0x80
                }

                Name (_PRS, ResourceTemplate ()  // _PRS: Possible Resource Settings
                {
                    IRQ (Level, ActiveLow, Shared, )
                        {3,4,5,6,7,10,11,12,14,15}
                })
                Method (_CRS, 0, Serialized)  // _CRS: Current Resource Settings
                {
                    Name (RTLH, ResourceTemplate ()
                    {
                        IRQ (Level, ActiveLow, Shared, )
                            {}
                    })
                    CreateWordField (RTLH, One, IRQ0)
                    IRQ0 = Zero
                    IRQ0 = (One << (PRTH & 0x0F))
                    Return (RTLH) /* \_SB_.PCI0.LPCB.LNKH._CRS.RTLH */
                }

                Method (_SRS, 1, Serialized)  // _SRS: Set Resource Settings
                {
                    CreateWordField (Arg0, One, IRQ0)
                    FindSetRightBit (IRQ0, Local0)
                    Local0--
                    PRTH = Local0
                }

                Method (_STA, 0, Serialized)  // _STA: Status
                {
                    If ((PRTH & 0x80))
                    {
                        Return (0x09)
                    }
                    Else
                    {
                        Return (0x0B)
                    }
                }
            }

            Device (DMAC)
            {
                Name (_HID, EisaId ("PNP0200") /* PC-class DMA Controller */)  // _HID: Hardware ID
                Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
                {
                    IO (Decode16,
                        0x0000,             // Range Minimum
                        0x0000,             // Range Maximum
                        0x01,               // Alignment
                        0x20,               // Length
                        )
                    IO (Decode16,
                        0x0081,             // Range Minimum
                        0x0081,             // Range Maximum
                        0x01,               // Alignment
                        0x11,               // Length
                        )
                    IO (Decode16,
                        0x0093,             // Range Minimum
                        0x0093,             // Range Maximum
                        0x01,               // Alignment
                        0x0D,               // Length
                        )
                    IO (Decode16,
                        0x00C0,             // Range Minimum
                        0x00C0,             // Range Maximum
                        0x01,               // Alignment
                        0x20,               // Length
                        )
                    DMA (Compatibility, NotBusMaster, Transfer8_16, )
                        {4}
                })
            }

            Device (FWH)
            {
                Name (_HID, EisaId ("INT0800") /* Intel 82802 Firmware Hub Device */)  // _HID: Hardware ID
                Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
                {
                    Memory32Fixed (ReadOnly,
                        0xFF000000,         // Address Base
                        0x01000000,         // Address Length
                        )
                })
            }

            Device (HPET)
            {
                Name (_HID, EisaId ("PNP0103") /* HPET System Timer */)  // _HID: Hardware ID
                Name (_CID, EisaId ("PNP0C01") /* System Board */)  // _CID: Compatible ID
                Name (BUF0, ResourceTemplate ()
                {
                    Memory32Fixed (ReadOnly,
                        0xFED00000,         // Address Base
                        0x00000400,         // Address Length
                        _Y05)
                })
                Method (_STA, 0, NotSerialized)  // _STA: Status
                {
                    If (HPTE)
                    {
                        If ((OSYS >= 0x07D1))
                        {
                            Return (0x0F)
                        }
                        Else
                        {
                            Return (0x0B)
                        }
                    }

                    Return (Zero)
                }

                Method (_CRS, 0, Serialized)  // _CRS: Current Resource Settings
                {
                    If (HPTE)
                    {
                        CreateDWordField (BUF0, \_SB.PCI0.LPCB.HPET._Y05._BAS, HPT0)  // _BAS: Base Address
                        If ((HPAS == One))
                        {
                            HPT0 = 0xFED01000
                        }

                        If ((HPAS == 0x02))
                        {
                            HPT0 = 0xFED02000
                        }

                        If ((HPAS == 0x03))
                        {
                            HPT0 = 0xFED03000
                        }
                    }

                    Return (BUF0) /* \_SB_.PCI0.LPCB.HPET.BUF0 */
                }
            }

            Device (PIC)
            {
                Name (_HID, EisaId ("PNP0000") /* 8259-compatible Programmable Interrupt Controller */)  // _HID: Hardware ID
                Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
                {
                    IO (Decode16,
                        0x0020,             // Range Minimum
                        0x0020,             // Range Maximum
                        0x01,               // Alignment
                        0x02,               // Length
                        )
                    IO (Decode16,
                        0x0024,             // Range Minimum
                        0x0024,             // Range Maximum
                        0x01,               // Alignment
                        0x02,               // Length
                        )
                    IO (Decode16,
                        0x0028,             // Range Minimum
                        0x0028,             // Range Maximum
                        0x01,               // Alignment
                        0x02,               // Length
                        )
                    IO (Decode16,
                        0x002C,             // Range Minimum
                        0x002C,             // Range Maximum
                        0x01,               // Alignment
                        0x02,               // Length
                        )
                    IO (Decode16,
                        0x0030,             // Range Minimum
                        0x0030,             // Range Maximum
                        0x01,               // Alignment
                        0x02,               // Length
                        )
                    IO (Decode16,
                        0x0034,             // Range Minimum
                        0x0034,             // Range Maximum
                        0x01,               // Alignment
                        0x02,               // Length
                        )
                    IO (Decode16,
                        0x0038,             // Range Minimum
                        0x0038,             // Range Maximum
                        0x01,               // Alignment
                        0x02,               // Length
                        )
                    IO (Decode16,
                        0x003C,             // Range Minimum
                        0x003C,             // Range Maximum
                        0x01,               // Alignment
                        0x02,               // Length
                        )
                    IO (Decode16,
                        0x00A0,             // Range Minimum
                        0x00A0,             // Range Maximum
                        0x01,               // Alignment
                        0x02,               // Length
                        )
                    IO (Decode16,
                        0x00A4,             // Range Minimum
                        0x00A4,             // Range Maximum
                        0x01,               // Alignment
                        0x02,               // Length
                        )
                    IO (Decode16,
                        0x00A8,             // Range Minimum
                        0x00A8,             // Range Maximum
                        0x01,               // Alignment
                        0x02,               // Length
                        )
                    IO (Decode16,
                        0x00AC,             // Range Minimum
                        0x00AC,             // Range Maximum
                        0x01,               // Alignment
                        0x02,               // Length
                        )
                    IO (Decode16,
                        0x00B0,             // Range Minimum
                        0x00B0,             // Range Maximum
                        0x01,               // Alignment
                        0x02,               // Length
                        )
                    IO (Decode16,
                        0x00B4,             // Range Minimum
                        0x00B4,             // Range Maximum
                        0x01,               // Alignment
                        0x02,               // Length
                        )
                    IO (Decode16,
                        0x00B8,             // Range Minimum
                        0x00B8,             // Range Maximum
                        0x01,               // Alignment
                        0x02,               // Length
                        )
                    IO (Decode16,
                        0x00BC,             // Range Minimum
                        0x00BC,             // Range Maximum
                        0x01,               // Alignment
                        0x02,               // Length
                        )
                    IO (Decode16,
                        0x04D0,             // Range Minimum
                        0x04D0,             // Range Maximum
                        0x01,               // Alignment
                        0x02,               // Length
                        )
                    IRQNoFlags ()
                        {2}
                })
            }

            Device (MATH)
            {
                Name (_HID, EisaId ("PNP0C04") /* x87-compatible Floating Point Processing Unit */)  // _HID: Hardware ID
                Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
                {
                    IO (Decode16,
                        0x00F0,             // Range Minimum
                        0x00F0,             // Range Maximum
                        0x01,               // Alignment
                        0x01,               // Length
                        )
                    IRQNoFlags ()
                        {13}
                })
            }

            Device (LDRC)
            {
                Name (_HID, EisaId ("PNP0C02") /* PNP Motherboard Resources */)  // _HID: Hardware ID
                Name (_UID, 0x02)  // _UID: Unique ID
                Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
                {
                    IO (Decode16,
                        0x002E,             // Range Minimum
                        0x002E,             // Range Maximum
                        0x01,               // Alignment
                        0x02,               // Length
                        )
                    IO (Decode16,
                        0x004E,             // Range Minimum
                        0x004E,             // Range Maximum
                        0x01,               // Alignment
                        0x02,               // Length
                        )
                    IO (Decode16,
                        0x0061,             // Range Minimum
                        0x0061,             // Range Maximum
                        0x01,               // Alignment
                        0x01,               // Length
                        )
                    IO (Decode16,
                        0x0063,             // Range Minimum
                        0x0063,             // Range Maximum
                        0x01,               // Alignment
                        0x01,               // Length
                        )
                    IO (Decode16,
                        0x0065,             // Range Minimum
                        0x0065,             // Range Maximum
                        0x01,               // Alignment
                        0x01,               // Length
                        )
                    IO (Decode16,
                        0x0067,             // Range Minimum
                        0x0067,             // Range Maximum
                        0x01,               // Alignment
                        0x01,               // Length
                        )
                    IO (Decode16,
                        0x0080,             // Range Minimum
                        0x0080,             // Range Maximum
                        0x01,               // Alignment
                        0x01,               // Length
                        )
                    IO (Decode16,
                        0x0092,             // Range Minimum
                        0x0092,             // Range Maximum
                        0x01,               // Alignment
                        0x01,               // Length
                        )
                    IO (Decode16,
                        0x00B2,             // Range Minimum
                        0x00B2,             // Range Maximum
                        0x01,               // Alignment
                        0x02,               // Length
                        )
                    IO (Decode16,
                        0x0500,             // Range Minimum
                        0x0500,             // Range Maximum
                        0x01,               // Alignment
                        0x80,               // Length
                        )
                    IO (Decode16,
                        0x0480,             // Range Minimum
                        0x0480,             // Range Maximum
                        0x01,               // Alignment
                        0x40,               // Length
                        )
                })
            }

            Device (RTC)
            {
                Name (_HID, EisaId ("PNP0B00") /* AT Real-Time Clock */)  // _HID: Hardware ID
                Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
                {
                    IO (Decode16,
                        0x0070,             // Range Minimum
                        0x0070,             // Range Maximum
                        0x01,               // Alignment
                        0x08,               // Length
                        )
                })
            }

            Device (TIMR)
            {
                Name (_HID, EisaId ("PNP0100") /* PC-class System Timer */)  // _HID: Hardware ID
                Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
                {
                    IO (Decode16,
                        0x0040,             // Range Minimum
                        0x0040,             // Range Maximum
                        0x01,               // Alignment
                        0x04,               // Length
                        )
                    IO (Decode16,
                        0x0050,             // Range Minimum
                        0x0050,             // Range Maximum
                        0x10,               // Alignment
                        0x04,               // Length
                        )
                    IRQNoFlags ()
                        {0}
                })
            }
        }

        Device (SATA)
        {
            Name (_ADR, 0x001F0002)  // _ADR: Address
        }

        Device (SBUS)
        {
            Name (_ADR, 0x001F0003)  // _ADR: Address
        }

        Method (_OSC, 4, NotSerialized)  // _OSC: Operating System Capabilities
        {
            If ((Arg0 == ToUUID ("7c9512a9-1705-4cb4-af7d-506a2423ab71")))
            {
                Return (^XHC.POSC (Arg2, Arg3))
            }

            If ((Arg0 == ToUUID ("33db4d5b-1ff7-401c-9657-7441c03dd766") /* PCI Host Bridge Device */))
            {
                Return (Arg3)
            }

            CreateDWordField (Arg3, Zero, CDW1)
            CDW1 |= 0x04
            Return (Arg3)
        }
    }
}

