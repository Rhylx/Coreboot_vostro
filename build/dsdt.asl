DefinitionBlock(
 "dsdt.aml",
 "DSDT",
 0x02,
 "COREv4",
 "COREBOOT",
 0x20141018
)
{
Method(_WAK,1)
{
 Return(Package(){0,0})
}
Method(_PTS,1)
{
}
External (\_PR.CNOT, MethodObj)
Method (PNOT)
{
 \_PR.CNOT (0x81)
}
Method (PPCN)
{
 \_PR.CNOT (0x80)
}
Method (TNOT)
{
 \_PR.CNOT (0x82)
}
OperationRegion (APMP, SystemIO, 0xb2, 2)
Field (APMP, ByteAcc, NoLock, Preserve)
{
 APMC, 8,
 APMS, 8
}
OperationRegion (POST, SystemIO, 0x80, 1)
Field (POST, ByteAcc, Lock, Preserve)
{
 DBG0, 8
}
Method(TRAP, 1, Serialized)
{
 Store (Arg0, SMIF)
 Store (0, TRP0)
 Return (SMIF)
}
Method(_PIC, 1)
{
 Store(Arg0, PICM)
}
Method(GOS, 0)
{
 Store (2000, OSYS)
 If (CondRefOf(_OSI)) {
  If (_OSI("Windows 2001")) {
   Store (2001, OSYS)
  }
  If (_OSI("Windows 2001 SP1")) {
   Store (2001, OSYS)
  }
  If (_OSI("Windows 2001 SP2")) {
   Store (2002, OSYS)
  }
  If (_OSI("Windows 2006")) {
   Store (2006, OSYS)
  }
 }
}
Name(\PICM, 0)
Name(\DSEN, 1)
External(NVSA)
OperationRegion (GNVS, SystemMemory, NVSA, 0xf00)
Field (GNVS, ByteAcc, NoLock, Preserve)
{
 Offset (0x00),
 OSYS, 16,
 SMIF, 8,
 PRM0, 8,
 PRM1, 8,
 SCIF, 8,
 PRM2, 8,
 PRM3, 8,
 LCKF, 8,
 PRM4, 8,
 PRM5, 8,
 P80D, 32,
 LIDS, 8,
 PWRS, 8,
 Offset (0x11),
 TLVL, 8,
 FLVL, 8,
 TCRT, 8,
 TPSV, 8,
 TMAX, 8,
 F0OF, 8,
 F0ON, 8,
 F0PW, 8,
 F1OF, 8,
 F1ON, 8,
 F1PW, 8,
 F2OF, 8,
 F2ON, 8,
 F2PW, 8,
 F3OF, 8,
 F3ON, 8,
 F3PW, 8,
 F4OF, 8,
 F4ON, 8,
 F4PW, 8,
 TMPS, 8,
 Offset (0x28),
 APIC, 8,
 MPEN, 8,
 PCP0, 8,
 PCP1, 8,
 PPCM, 8,
 PCNT, 8,
 Offset (0x32),
 NATP, 8,
 S5U0, 8,
 S5U1, 8,
 S3U0, 8,
 S3U1, 8,
 S33G, 8,
 CMEM, 32,
 Offset (0x3c),
 IGDS, 8,
 TLST, 8,
 CADL, 8,
 PADL, 8,
 CSTE, 16,
 NSTE, 16,
 SSTE, 16,
 Offset (0x46),
 NDID, 8,
 DID1, 32,
 DID2, 32,
 DID3, 32,
 DID4, 32,
 DID5, 32,
 Offset (0x64),
 BLCS, 8,
 BRTL, 8,
 ODDS, 8,
 Offset (0x6e),
 ALSE, 8,
 ALAF, 8,
 LLOW, 8,
 LHIH, 8,
 Offset (0x78),
 EMAE, 8,
 EMAP, 16,
 EMAL, 16,
 Offset (0x82),
 MEFE, 8,
 Offset (0x8c),
 TPMP, 8,
 TPME, 8,
 Offset (0x96),
 GTF0, 56,
 GTF1, 56,
 GTF2, 56,
 IDEM, 8,
 IDET, 8,
 Offset (0xb2),
 XHCI, 8,
 Offset (0xb4),
 ASLB, 32,
 IBTT, 8,
 IPAT, 8,
 ITVF, 8,
 ITVM, 8,
 IPSC, 8,
 IBLC, 8,
 IBIA, 8,
 ISSC, 8,
 I409, 8,
 I509, 8,
 I609, 8,
 I709, 8,
 IDMM, 8,
 IDMS, 8,
 IF1E, 8,
 HVCO, 8,
 NXD1, 32,
 NXD2, 32,
 NXD3, 32,
 NXD4, 32,
 NXD5, 32,
 NXD6, 32,
 NXD7, 32,
 NXD8, 32,
 ISCI, 8,
 PAVP, 8,
 Offset (0xeb),
 OSCC, 8,
 NPCE, 8,
 PLFL, 8,
 BREV, 8,
 DPBM, 8,
 DPCM, 8,
 DPDM, 8,
 ALFP, 8,
 IMON, 8,
 MMIO, 8,
 TPIQ, 8,
 Offset (0x100),
VBT0, 32,
VBT1, 32,
VBT2, 32,
VBT3, 16,
VBT4, 2048,
VBT5, 512,
VBT6, 512,
VBT7, 32,
VBT8, 32,
VBT9, 32,
CHVD, 24576,
VBTA, 32,
MEHH, 256,
RMOB, 32,
RMOL, 32,
ROVP, 32,
ROVL, 32,
RWVP, 32,
RWVL, 32,
}
Method (S3UE)
{
 Store (One, \S3U0)
 Store (One, \S3U1)
}
Method (S3UD)
{
 Store (Zero, \S3U0)
 Store (Zero, \S3U1)
}
Method (S5UE)
{
 Store (One, \S5U0)
 Store (One, \S5U1)
}
Method (S5UD)
{
 Store (Zero, \S5U0)
 Store (Zero, \S5U1)
}
Method (S3GE)
{
 Store (One, \S33G)
}
Method (S3GD)
{
 Store (Zero, \S33G)
}
Method (XHCE)
{
 Store (One, \XHCI)
}
Method (XHCD)
{
 Store (Zero, \XHCI)
}
External (\_TZ.SKIN)
Method (TZUP)
{
 If (CondRefOf (\_TZ.SKIN)) {
  Notify (\_TZ.SKIN, 0x81)
 }
}
Method (F0UT, 2)
{
 Store (Arg0, \F0OF)
 Store (Arg1, \F0ON)
 TZUP ()
}
Method (F1UT, 2)
{
 Store (Arg0, \F1OF)
 Store (Arg1, \F1ON)
 TZUP ()
}
Method (F2UT, 2)
{
 Store (Arg0, \F2OF)
 Store (Arg1, \F2ON)
 TZUP ()
}
Method (F3UT, 2)
{
 Store (Arg0, \F3OF)
 Store (Arg1, \F3ON)
 TZUP ()
}
Method (F4UT, 2)
{
 Store (Arg0, \F4OF)
 Store (Arg1, \F4ON)
 TZUP ()
}
Method (TMPU, 1)
{
 Store (Arg0, \TMPS)
 TZUP ()
}
Name(\_S0, Package(){0x0,0x0,0x0,0x0})
Name(\_S3, Package(){0x5,0x0,0x0,0x0})
Name(\_S4, Package(){0x6,0x0,0x0,0x0})
Name(\_S5, Package(){0x7,0x0,0x0,0x0})
 Device (\_SB.PCI0)
 {
Name(_HID,EISAID("PNP0A08"))
Name(_CID,EISAID("PNP0A03"))
Name(_BBN, 0)
Device (MCHC)
{
 Name(_ADR, 0x00000000)
 OperationRegion(MCHP, PCI_Config, 0x00, 0x100)
 Field (MCHP, DWordAcc, NoLock, Preserve)
 {
  Offset (0x40),
  EPEN, 1,
  , 11,
  EPBR, 27,
  Offset (0x48),
  MHEN, 1,
  , 14,
  MHBR, 24,
  Offset (0x54),
  DVEN, 32,
  Offset (0x60),
  PXEN, 1,
  PXSZ, 2,
  , 23,
  PXBR, 13,
  Offset (0x68),
  DMEN, 1,
  , 11,
  DMBR, 27,
  Offset (0x70),
  MEBA, 64,
  Offset (0x80),
  , 4,
  PM0H, 2,
  , 2,
  Offset (0x81),
  PM1L, 2,
  , 2,
  PM1H, 2,
  , 2,
  Offset (0x82),
  PM2L, 2,
  , 2,
  PM2H, 2,
  , 2,
  Offset (0x83),
  PM3L, 2,
  , 2,
  PM3H, 2,
  , 2,
  Offset (0x84),
  PM4L, 2,
  , 2,
  PM4H, 2,
  , 2,
  Offset (0x85),
  PM5L, 2,
  , 2,
  PM5H, 2,
  , 2,
  Offset (0x86),
  PM6L, 2,
  , 2,
  PM6H, 2,
  , 2,
  Offset (0xa0),
  TOM, 64,
  Offset (0xbc),
  TLUD, 32,
 }
 Mutex (CTCM, 1)
 Name (CTCC, 0)
 Name (CTCN, 0)
 Name (CTCD, 1)
 Name (CTCU, 2)
 OperationRegion (MCHB, SystemMemory, \_SB.PCI0.MCHC.MHBR << 15, 0x8000)
 Field (MCHB, DWordAcc, Lock, Preserve)
 {
  Offset (0x5930),
  CTDN, 15,
  Offset (0x59a0),
  PL1V, 15,
  PL1E, 1,
  PL1C, 1,
  PL1T, 7,
  Offset (0x59a4),
  PL2V, 15,
  PL2E, 1,
  PL2C, 1,
  PL2T, 7,
  Offset (0x5f3c),
  TARN, 8,
  Offset (0x5f40),
  CTDD, 15,
  , 1,
  TARD, 8,
  Offset (0x5f48),
  CTDU, 15,
  , 1,
  TARU, 8,
  Offset (0x5f50),
  CTCS, 2,
  Offset (0x5f54),
  TARS, 8,
 }
 External (\_PR.CP00._PSS)
 Method (PSSS, 1, NotSerialized)
 {
  Store (One, Local0)
  Store (SizeOf (\_PR.CP00._PSS), Local1)
  While (LLess (Local0, Local1)) {
   ShiftRight (DeRefOf (Index (DeRefOf (Index
         (\_PR.CP00._PSS, Local0)), 4)), 8, Local2)
   If (LEqual (Local2, Arg0)) {
    Return (Subtract (Local0, 1))
   }
   Increment (Local0)
  }
  Return (0)
 }
 Method (STND, 0, Serialized)
 {
  If (Acquire (CTCM, 100)) {
   Return (0)
  }
  If (LEqual (CTCD, CTCC)) {
   Release (CTCM)
   Return (0)
  }
  Store ("Set TDP Down", Debug)
  Store (CTCD, CTCS)
  Store (TARD, TARS)
  Store (PSSS (TARD), PPCM)
  PPCN ()
  Divide (Multiply (CTDD, 125), 100, , PL2V)
  Store (CTDD, PL1V)
  Store (CTCD, CTCC)
  Release (CTCM)
  Return (1)
 }
 Method (STDN, 0, Serialized)
 {
  If (Acquire (CTCM, 100)) {
   Return (0)
  }
  If (LEqual (CTCN, CTCC)) {
   Release (CTCM)
   Return (0)
  }
  Store ("Set TDP Nominal", Debug)
  Store (CTDN, PL1V)
  Divide (Multiply (CTDN, 125), 100, , PL2V)
  Store (PSSS (TARN), PPCM)
  PPCN ()
  Store (TARN, TARS)
  Store (CTCN, CTCS)
  Store (CTCN, CTCC)
  Release (CTCM)
  Return (1)
 }
}
Name (MCRS, ResourceTemplate()
{
 WordBusNumber (ResourceProducer, MinFixed, MaxFixed, PosDecode,
   0x0000, 0x0000, 0x00ff, 0x0000, 0x0100,,, PB00)
 DWordIO (ResourceProducer, MinFixed, MaxFixed, PosDecode, EntireRange,
   0x0000, 0x0000, 0x0cf7, 0x0000, 0x0cf8,,, PI00)
 Io (Decode16, 0x0cf8, 0x0cf8, 0x0001, 0x0008)
 DWordIO (ResourceProducer, MinFixed, MaxFixed, PosDecode, EntireRange,
   0x0000, 0x0d00, 0xffff, 0x0000, 0xf300,,, PI01)
 DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed,
   Cacheable, ReadWrite,
   0x00000000, 0x000a0000, 0x000bffff, 0x00000000,
   0x00020000,,, ASEG)
 DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed,
   Cacheable, ReadWrite,
   0x00000000, 0x000c0000, 0x000c3fff, 0x00000000,
   0x00004000,,, OPR0)
 DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed,
   Cacheable, ReadWrite,
   0x00000000, 0x000c4000, 0x000c7fff, 0x00000000,
   0x00004000,,, OPR1)
 DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed,
   Cacheable, ReadWrite,
   0x00000000, 0x000c8000, 0x000cbfff, 0x00000000,
   0x00004000,,, OPR2)
 DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed,
   Cacheable, ReadWrite,
   0x00000000, 0x000cc000, 0x000cffff, 0x00000000,
   0x00004000,,, OPR3)
 DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed,
   Cacheable, ReadWrite,
   0x00000000, 0x000d0000, 0x000d3fff, 0x00000000,
   0x00004000,,, OPR4)
 DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed,
   Cacheable, ReadWrite,
   0x00000000, 0x000d4000, 0x000d7fff, 0x00000000,
   0x00004000,,, OPR5)
 DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed,
   Cacheable, ReadWrite,
   0x00000000, 0x000d8000, 0x000dbfff, 0x00000000,
   0x00004000,,, OPR6)
 DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed,
   Cacheable, ReadWrite,
   0x00000000, 0x000dc000, 0x000dffff, 0x00000000,
   0x00004000,,, OPR7)
 DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed,
   Cacheable, ReadWrite,
   0x00000000, 0x000e0000, 0x000e3fff, 0x00000000,
   0x00004000,,, ESG0)
 DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed,
   Cacheable, ReadWrite,
   0x00000000, 0x000e4000, 0x000e7fff, 0x00000000,
   0x00004000,,, ESG1)
 DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed,
   Cacheable, ReadWrite,
   0x00000000, 0x000e8000, 0x000ebfff, 0x00000000,
   0x00004000,,, ESG2)
 DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed,
   Cacheable, ReadWrite,
   0x00000000, 0x000ec000, 0x000effff, 0x00000000,
   0x00004000,,, ESG3)
 DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed,
   Cacheable, ReadWrite,
   0x00000000, 0x000f0000, 0x000fffff, 0x00000000,
   0x00010000,,, FSEG)
 DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed,
   Cacheable, ReadWrite,
   0x00000000, 0x00000000, 0x00000000, 0x00000000,
   0x00000000,,, PM01)
 DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed,
   Cacheable, ReadWrite,
   0x00000000, 0xfed40000, 0xfed44fff, 0x00000000,
   0x00005000,,, TPMR)
})
Method (_CRS, 0, Serialized)
{
 CreateDwordField(MCRS, ^PM01._MIN, PMIN)
 CreateDwordField(MCRS, ^PM01._MAX, PMAX)
 CreateDwordField(MCRS, ^PM01._LEN, PLEN)
 Store (^MCHC.TLUD, Local0)
 Store (^MCHC.MEBA, Local1)
 If (LEqual (Local0, Local1)) {
  Store (^MCHC.TOM, Local0)
 }
 Store (Local0, PMIN)
 Store (Subtract(0xf0000000, 1), PMAX)
 Add(Subtract(PMAX, PMIN), 1, PLEN)
 Return (MCRS)
}
Device (PEGP)
{
 Name (_ADR, 0x00010000)
 Method (_STA)
 {
  ShiftRight (\_SB.PCI0.MCHC.DVEN, 3, Local0)
  Return (And (Local0, 1))
 }
 Device (DEV0)
 {
  Name(_ADR, 0x00000000)
 }
}
Device (PEG1)
{
 Name (_ADR, 0x00010001)
 Method (_STA)
 {
  ShiftRight (\_SB.PCI0.MCHC.DVEN, 2, Local0)
  Return (And (Local0, 1))
 }
 Device (DEV0)
 {
  Name(_ADR, 0x00000000)
 }
}
Device (PEG2)
{
 Name (_ADR, 0x00010002)
 Method (_STA)
 {
  ShiftRight (\_SB.PCI0.MCHC.DVEN, 1, Local0)
  Return (And (Local0, 1))
 }
 Device (DEV0)
 {
  Name(_ADR, 0x00000000)
 }
}
Device (PEG6)
{
 Name (_ADR, 0x00060000)
 Method (_STA)
 {
  ShiftRight (\_SB.PCI0.MCHC.DVEN, 13, Local0)
  Return (And (Local0, 1))
 }
 Device (DEV0)
 {
  Name(_ADR, 0x00000000)
 }
}
Device (PDRC)
{
 Name (_HID, EISAID("PNP0C02"))
 Name (_UID, 1)
 Name (PDRS, ResourceTemplate() {
  Memory32Fixed(ReadWrite, 0xfed1c000, 0x00004000)
  Memory32Fixed(ReadWrite, 0, 0x00008000, MCHB)
  Memory32Fixed(ReadWrite, 0, 0x00001000, DMIB)
  Memory32Fixed(ReadWrite, 0, 0x00001000, EGPB)
  Memory32Fixed(ReadWrite, 0, 0x04000000, PCIX)
  Memory32Fixed(ReadWrite, 0xfed20000, 0x00020000)
  Memory32Fixed(ReadWrite, 0xfed40000, 0x00005000)
  Memory32Fixed(ReadWrite, 0xfed45000, 0x0004b000)
  Memory32Fixed(ReadWrite, 0x20000000, 0x00200000)
  Memory32Fixed(ReadWrite, 0x40000000, 0x00200000)
 })
 Method (_CRS, 0, Serialized)
 {
  CreateDwordField (PDRS, ^MCHB._BAS, MBR0)
  MBR0 = \_SB.PCI0.MCHC.MHBR << 15
  CreateDwordField (PDRS, ^DMIB._BAS, DBR0)
  DBR0 = \_SB.PCI0.MCHC.DMBR << 12
  CreateDwordField (PDRS, ^EGPB._BAS, EBR0)
  EBR0 = \_SB.PCI0.MCHC.EPBR << 12
  CreateDwordField (PDRS, ^PCIX._BAS, XBR0)
  XBR0 = \_SB.PCI0.MCHC.PXBR << 26
  CreateDwordField (PDRS, ^PCIX._LEN, XSZ0)
  XSZ0 = 0x10000000 << \_SB.PCI0.MCHC.PXSZ
  Return(PDRS)
 }
}
Device (GFX0)
{
 Name (_ADR, 0x00020000)
 OperationRegion (GFXC, PCI_Config, 0x00, 0x0100)
 Field (GFXC, DWordAcc, NoLock, Preserve)
 {
  Offset (0x10),
  BAR0, 64,
  Offset (0xe4),
  ASLE, 32,
  Offset (0xfc),
  ASLS, 32,
 }
 OperationRegion (GFRG, SystemMemory, And (BAR0, 0xfffffffffffffff0), 0x400000)
 Field (GFRG, DWordAcc, NoLock, Preserve)
 {
  Offset (0x48254),
  BCLV, 16,
  Offset (0xc8256),
  BCLM, 16
 }
 Device (BOX3)
 {
  Name (_ADR, 0)
  OperationRegion (OPRG, SystemMemory, ASLS, 0x2000)
  Field (OPRG, DWordAcc, NoLock, Preserve)
  {
   Offset (0x58),
   MBOX, 32,
   Offset (0x300),
   ARDY, 1,
   , 31,
   ASLC, 32,
   TCHE, 32,
   ALSI, 32,
   BCLP, 32,
   PFIT, 32,
   CBLV, 32,
  }
  Method (XBCM, 1, Serialized)
  {
   If (LEqual(ASLS, Zero))
   {
    Return (Ones)
   }
   If (LEqual(And(MBOX, 0x4), Zero))
   {
    Return (Ones)
   }
   Store (Divide (Multiply (Arg0, 255), 100), Local1)
   If (LGreater(Local1, 255)) {
    Store (255, Local1)
   }
   Store (Or (Local1, 0x80000000), BCLP)
   If (LEqual(ARDY, Zero))
   {
    Return (Ones)
   }
   Store (0x2, ASLC)
   Store (0x1, ASLE)
   Store (0x20, Local0)
   While (LGreater(Local0, Zero))
   {
    Sleep (1)
    If (LEqual (And (ASLC, 0x2), 0)) {
     And (ShiftRight (ASLC, 12), 0x3, Local1)
     If (LEqual (Local1, 0)) {
      Return (Zero)
     } Else {
      Return (Ones)
     }
    }
    Decrement (Local0)
   }
   Return (Ones)
  }
 }
 Device (LEGA)
 {
  Name (_ADR, 0)
  Method (DRCL, 2)
  {
   Return (Divide (Add (Arg0, Divide (Arg1, 2)), Arg1))
  }
  Method (XBCM, 1, NotSerialized)
  {
   Store (DRCL (Multiply (Arg0, BCLM), 100), BCLV)
  }
  Method (XBQC, 0, NotSerialized)
  {
   Store (DRCL (Multiply (BCLV, 100), BCLM), Local0)
   Store (2, Local1)
   While (LLess (Local1, Subtract (SizeOf (BRIG), 1))) {
    Store (DeRefOf (Index (BRIG, Local1)), Local2)
    Store (DeRefOf (Index (BRIG, Add (Local1, 1))), Local3)
    If (LLess (Local0, Local3)) {
     If (LOr (LLess (Local0, Local2),
       LLess (Subtract (Local0, Local2),
       Subtract (Local3, Local0)))) {
      Return (Local2)
     } Else {
      Return (Local3)
     }
    }
    Increment (Local1)
   }
   Return (Local3)
  }
 }
 Method (XBCM, 1, NotSerialized)
 {
  If (LEqual(^BOX3.XBCM (Arg0), Ones))
  {
   ^LEGA.XBCM (Arg0)
  }
 }
 Method (XBQC, 0, NotSerialized)
 {
  Return (^LEGA.XBQC ())
 }
 External(LCD0, DeviceObj)
 Name (BRCT, 0)
 Method(BRID, 1, NotSerialized)
 {
  Store (Match (BRIG, MEQ, Arg0, MTR, Zero, 2), Local0)
  If (LEqual (Local0, Ones))
  {
   Return (Subtract(SizeOf(BRIG), One))
  }
  Return (Local0)
 }
 Method (XBCL, 0, NotSerialized)
 {
  Store (1, BRCT)
  Return (BRIG)
 }
 Method (_DOS, 1)
 {
  Store (And(Arg0, 7), DSEN)
 }
 Method (DECB, 0, NotSerialized)
 {
  If (BRCT)
  {
   Notify (LCD0, 0x87)
  } Else {
   Store (BRID (XBQC ()), Local0)
   If (LNotEqual (Local0, 2))
   {
    Decrement (Local0)
   }
   XBCM (DerefOf (Index (BRIG, Local0)))
  }
 }
 Method (INCB, 0, NotSerialized)
 {
  If (BRCT)
  {
   Notify (LCD0, 0x86)
  } Else {
   Store (BRID (XBQC ()), Local0)
   If (LNotEqual (Local0, Subtract(SizeOf(BRIG), One)))
   {
    Increment (Local0)
   }
   XBCM (DerefOf (Index (BRIG, Local0)))
  }
 }
 Method(XDCS, 1)
 {
  TRAP(1)
  If (And(CSTE, ShiftLeft (1, Arg0))) {
   Return (0x1f)
  }
  Return(0x1d)
 }
 Method(XDGS, 1)
 {
  If (And(NSTE, ShiftLeft (1, Arg0))) {
   Return(1)
  }
  Return(0)
 }
 Method(XDSS, 1)
 {
  If (LEqual(And(Arg0, 0xc0000000), 0xc0000000)) {
   Store (NSTE, CSTE)
  }
 }
}
Scope (GFX0)
{
 Name (BRIG, Package (0x12)
 {
  100,
  100,
    2,
    4,
    5,
    7,
    9,
   11,
   13,
   18,
   20,
   24,
   29,
   33,
   40,
   50,
   67,
  100,
 })
}
Scope(\)
{
 OperationRegion(IO_T, SystemIO, 0x800, 0x10)
 Field(IO_T, ByteAcc, NoLock, Preserve)
 {
  Offset(0x8),
  TRP0, 8
 }
 OperationRegion(PMIO, SystemIO, 0x0500, 0x80)
 Field(PMIO, ByteAcc, NoLock, Preserve)
 {
  Offset(0x20),
  , 16,
  GS00, 1,
  GS01, 1,
  GS02, 1,
  GS03, 1,
  GS04, 1,
  GS05, 1,
  GS06, 1,
  GS07, 1,
  GS08, 1,
  GS09, 1,
  GS10, 1,
  GS11, 1,
  GS12, 1,
  GS13, 1,
  GS14, 1,
  GS15, 1,
  Offset(0x28),
  , 16,
  GE00, 1,
  GE01, 1,
  GE02, 1,
  GE03, 1,
  GE04, 1,
  GE05, 1,
  GE06, 1,
  GE07, 1,
  GE08, 1,
  GE09, 1,
  GE10, 1,
  GE11, 1,
  GE12, 1,
  GE13, 1,
  GE14, 1,
  GE15, 1,
  Offset(0x42),
  , 1,
  GPEC, 1,
 }
 OperationRegion(GPIO, SystemIO, 0x0480, 0x6c)
 Field(GPIO, ByteAcc, NoLock, Preserve)
 {
  Offset(0x00),
  GU00, 8,
  GU01, 8,
  GU02, 8,
  GU03, 8,
  Offset(0x04),
  GIO0, 8,
  GIO1, 8,
  GIO2, 8,
  GIO3, 8,
  Offset(0x0c),
  GP00, 1,
  GP01, 1,
  GP02, 1,
  GP03, 1,
  GP04, 1,
  GP05, 1,
  GP06, 1,
  GP07, 1,
  GP08, 1,
  GP09, 1,
  GP10, 1,
  GP11, 1,
  GP12, 1,
  GP13, 1,
  GP14, 1,
  GP15, 1,
  GP16, 1,
  GP17, 1,
  GP18, 1,
  GP19, 1,
  GP20, 1,
  GP21, 1,
  GP22, 1,
  GP23, 1,
  GP24, 1,
  GP25, 1,
  GP26, 1,
  GP27, 1,
  GP28, 1,
  GP29, 1,
  GP30, 1,
  GP31, 1,
  Offset(0x18),
  GB00, 8,
  GB01, 8,
  GB02, 8,
  GB03, 8,
  Offset(0x2c),
  GIV0, 8,
  GIV1, 8,
  GIV2, 8,
  GIV3, 8,
  Offset(0x30),
  GU04, 8,
  GU05, 8,
  GU06, 8,
  GU07, 8,
  Offset(0x34),
  GIO4, 8,
  GIO5, 8,
  GIO6, 8,
  GIO7, 8,
  Offset(0x38),
  GP32, 1,
  GP33, 1,
  GP34, 1,
  GP35, 1,
  GP36, 1,
  GP37, 1,
  GP38, 1,
  GP39, 1,
  GP40, 1,
  GP41, 1,
  GP42, 1,
  GP43, 1,
  GP44, 1,
  GP45, 1,
  GP46, 1,
  GP47, 1,
  GP48, 1,
  GP49, 1,
  GP50, 1,
  GP51, 1,
  GP52, 1,
  GP53, 1,
  GP54, 1,
  GP55, 1,
  GP56, 1,
  GP57, 1,
  GP58, 1,
  GP59, 1,
  GP60, 1,
  GP61, 1,
  GP62, 1,
  GP63, 1,
  Offset(0x40),
  GU08, 8,
  GU09, 4,
  Offset(0x44),
  GIO8, 8,
  GIO9, 4,
  Offset(0x48),
  GP64, 1,
  GP65, 1,
  GP66, 1,
  GP67, 1,
  GP68, 1,
  GP69, 1,
  GP70, 1,
  GP71, 1,
  GP72, 1,
  GP73, 1,
  GP74, 1,
  GP75, 1,
 }
 OperationRegion(RCRB, SystemMemory, 0xfed1c000, 0x4000)
 Field(RCRB, DWordAcc, Lock, Preserve)
 {
  Offset(0x0000),
  Offset(0x1000),
  Offset(0x3000),
  Offset(0x3404),
  HPAS, 2,
  , 5,
  HPTE, 1,
  Offset(0x3418),
  , 1,
  PCID, 1,
  SA1D, 1,
  SMBD, 1,
  HDAD, 1,
  , 8,
  EH2D, 1,
  LPBD, 1,
  EH1D, 1,
  RP1D, 1,
  RP2D, 1,
  RP3D, 1,
  RP4D, 1,
  RP5D, 1,
  RP6D, 1,
  RP7D, 1,
  RP8D, 1,
  TTRD, 1,
  SA2D, 1,
  Offset(0x3428),
  BDFD, 1,
  ME1D, 1,
  ME2D, 1,
  IDRD, 1,
  KTCT, 1,
 }
}
Device (HDEF)
{
 Name (_ADR, 0x001b0000)
 Name (_PRW, Package(){
  13,
   4
 })
}
Method (IRQM, 1, Serialized) {
 Name (IQAA, Package() {
  Package() { 0x0000ffff, 0, 0, 16 },
  Package() { 0x0000ffff, 1, 0, 17 },
  Package() { 0x0000ffff, 2, 0, 18 },
  Package() { 0x0000ffff, 3, 0, 19 } })
 Name (IQAP, Package() {
  Package() { 0x0000ffff, 0, \_SB.PCI0.LPCB.LNKA, 0 },
  Package() { 0x0000ffff, 1, \_SB.PCI0.LPCB.LNKB, 0 },
  Package() { 0x0000ffff, 2, \_SB.PCI0.LPCB.LNKC, 0 },
  Package() { 0x0000ffff, 3, \_SB.PCI0.LPCB.LNKD, 0 } })
 Name (IQBA, Package() {
  Package() { 0x0000ffff, 0, 0, 17 },
  Package() { 0x0000ffff, 1, 0, 18 },
  Package() { 0x0000ffff, 2, 0, 19 },
  Package() { 0x0000ffff, 3, 0, 16 } })
 Name (IQBP, Package() {
  Package() { 0x0000ffff, 0, \_SB.PCI0.LPCB.LNKB, 0 },
  Package() { 0x0000ffff, 1, \_SB.PCI0.LPCB.LNKC, 0 },
  Package() { 0x0000ffff, 2, \_SB.PCI0.LPCB.LNKD, 0 },
  Package() { 0x0000ffff, 3, \_SB.PCI0.LPCB.LNKA, 0 } })
 Name (IQCA, Package() {
  Package() { 0x0000ffff, 0, 0, 18 },
  Package() { 0x0000ffff, 1, 0, 19 },
  Package() { 0x0000ffff, 2, 0, 16 },
  Package() { 0x0000ffff, 3, 0, 17 } })
 Name (IQCP, Package() {
  Package() { 0x0000ffff, 0, \_SB.PCI0.LPCB.LNKC, 0 },
  Package() { 0x0000ffff, 1, \_SB.PCI0.LPCB.LNKD, 0 },
  Package() { 0x0000ffff, 2, \_SB.PCI0.LPCB.LNKA, 0 },
  Package() { 0x0000ffff, 3, \_SB.PCI0.LPCB.LNKB, 0 } })
 Name (IQDA, Package() {
  Package() { 0x0000ffff, 0, 0, 19 },
  Package() { 0x0000ffff, 1, 0, 16 },
  Package() { 0x0000ffff, 2, 0, 17 },
  Package() { 0x0000ffff, 3, 0, 18 } })
 Name (IQDP, Package() {
  Package() { 0x0000ffff, 0, \_SB.PCI0.LPCB.LNKD, 0 },
  Package() { 0x0000ffff, 1, \_SB.PCI0.LPCB.LNKA, 0 },
  Package() { 0x0000ffff, 2, \_SB.PCI0.LPCB.LNKB, 0 },
  Package() { 0x0000ffff, 3, \_SB.PCI0.LPCB.LNKC, 0 } })
 Switch (ToInteger (Arg0)) {
  Case (Package() { 1, 5 }) {
   If (PICM) {
    Return (IQAA)
   } Else {
    Return (IQAP)
   }
  }
  Case (Package() { 2, 6 }) {
   If (PICM) {
    Return (IQBA)
   } Else {
    Return (IQBP)
   }
  }
  Case (Package() { 3, 7 }) {
   If (PICM) {
    Return (IQCA)
   } Else {
    Return (IQCP)
   }
  }
  Case (Package() { 4, 8 }) {
   If (PICM) {
    Return (IQDA)
   } Else {
    Return (IQDP)
   }
  }
  Default {
   If (PICM) {
    Return (IQDA)
   } Else {
    Return (IQDP)
   }
  }
 }
}
Device (RP01)
{
 Name (_ADR, 0x001c0000)
OperationRegion (RPCS, PCI_Config, 0x00, 0xFF)
Field (RPCS, AnyAcc, NoLock, Preserve)
{
 Offset (0x4c),
 , 24,
 RPPN, 8,
 Offset (0x5A),
 , 3,
 PDC, 1,
 Offset (0xDF),
 , 6,
 HPCS, 1,
}
 Method (_PRT)
 {
  Return (IRQM (RPPN))
 }
}
Device (RP02)
{
 Name (_ADR, 0x001c0001)
OperationRegion (RPCS, PCI_Config, 0x00, 0xFF)
Field (RPCS, AnyAcc, NoLock, Preserve)
{
 Offset (0x4c),
 , 24,
 RPPN, 8,
 Offset (0x5A),
 , 3,
 PDC, 1,
 Offset (0xDF),
 , 6,
 HPCS, 1,
}
 Method (_PRT)
 {
  Return (IRQM (RPPN))
 }
}
Device (RP03)
{
 Name (_ADR, 0x001c0002)
OperationRegion (RPCS, PCI_Config, 0x00, 0xFF)
Field (RPCS, AnyAcc, NoLock, Preserve)
{
 Offset (0x4c),
 , 24,
 RPPN, 8,
 Offset (0x5A),
 , 3,
 PDC, 1,
 Offset (0xDF),
 , 6,
 HPCS, 1,
}
 Method (_PRT)
 {
  Return (IRQM (RPPN))
 }
}
Device (RP04)
{
 Name (_ADR, 0x001c0003)
OperationRegion (RPCS, PCI_Config, 0x00, 0xFF)
Field (RPCS, AnyAcc, NoLock, Preserve)
{
 Offset (0x4c),
 , 24,
 RPPN, 8,
 Offset (0x5A),
 , 3,
 PDC, 1,
 Offset (0xDF),
 , 6,
 HPCS, 1,
}
 Method (_PRT)
 {
  Return (IRQM (RPPN))
 }
}
Device (RP05)
{
 Name (_ADR, 0x001c0004)
OperationRegion (RPCS, PCI_Config, 0x00, 0xFF)
Field (RPCS, AnyAcc, NoLock, Preserve)
{
 Offset (0x4c),
 , 24,
 RPPN, 8,
 Offset (0x5A),
 , 3,
 PDC, 1,
 Offset (0xDF),
 , 6,
 HPCS, 1,
}
 Method (_PRT)
 {
  Return (IRQM (RPPN))
 }
}
Device (RP06)
{
 Name (_ADR, 0x001c0005)
OperationRegion (RPCS, PCI_Config, 0x00, 0xFF)
Field (RPCS, AnyAcc, NoLock, Preserve)
{
 Offset (0x4c),
 , 24,
 RPPN, 8,
 Offset (0x5A),
 , 3,
 PDC, 1,
 Offset (0xDF),
 , 6,
 HPCS, 1,
}
 Method (_PRT)
 {
  Return (IRQM (RPPN))
 }
}
Device (RP07)
{
 Name (_ADR, 0x001c0006)
OperationRegion (RPCS, PCI_Config, 0x00, 0xFF)
Field (RPCS, AnyAcc, NoLock, Preserve)
{
 Offset (0x4c),
 , 24,
 RPPN, 8,
 Offset (0x5A),
 , 3,
 PDC, 1,
 Offset (0xDF),
 , 6,
 HPCS, 1,
}
 Method (_PRT)
 {
  Return (IRQM (RPPN))
 }
}
Device (RP08)
{
 Name (_ADR, 0x001c0007)
OperationRegion (RPCS, PCI_Config, 0x00, 0xFF)
Field (RPCS, AnyAcc, NoLock, Preserve)
{
 Offset (0x4c),
 , 24,
 RPPN, 8,
 Offset (0x5A),
 , 3,
 PDC, 1,
 Offset (0xDF),
 , 6,
 HPCS, 1,
}
 Method (_PRT)
 {
  Return (IRQM (RPPN))
 }
}
Device (EHC1)
{
 Name(_ADR, 0x001d0000)
 Name (_PRW, Package(){ 13, 4 })
 Method(_S3D,0)
 {
  Return (2)
 }
 Method(_S4D,0)
 {
  Return (2)
 }
 Device (HUB7)
 {
  Name (_ADR, 0x00000000)
  Method (GPLD, 1, Serialized)
   {
   Name (PCKG, Package (0x01)
   {
    Buffer (0x10) {}
   })
   CreateField (DerefOf (Index (PCKG, Zero)), Zero, 0x07, REV)
   Store (0x02, REV)
   CreateField (DerefOf (Index (PCKG, Zero)), 0x40, One, VISI)
   Store (Arg0, VISI)
   Return (PCKG)
  }
  Device (PRT1) { Name (_ADR, 1) }
  Device (PRT2) { Name (_ADR, 2) }
  Device (PRT3) { Name (_ADR, 3) }
  Device (PRT4) { Name (_ADR, 4) }
  Device (PRT5) { Name (_ADR, 5) }
  Device (PRT6) { Name (_ADR, 6) }
 }
}
Device (EHC2)
{
 Name(_ADR, 0x001a0000)
 Name (_PRW, Package(){ 13, 4 })
 Method(_S3D,0)
 {
  Return (2)
 }
 Method(_S4D,0)
 {
  Return (2)
 }
 Device (HUB7)
 {
  Name (_ADR, 0x00000000)
  Method (GPLD, 1, Serialized)
   {
   Name (PCKG, Package (0x01)
   {
    Buffer (0x10) {}
   })
   CreateField (DerefOf (Index (PCKG, Zero)), Zero, 0x07, REV)
   Store (0x02, REV)
   CreateField (DerefOf (Index (PCKG, Zero)), 0x40, One, VISI)
   Store (Arg0, VISI)
   Return (PCKG)
  }
  Device (PRT1) { Name (_ADR, 1) }
  Device (PRT2) { Name (_ADR, 2) }
  Device (PRT3) { Name (_ADR, 3) }
  Device (PRT4) { Name (_ADR, 4) }
  Device (PRT5) { Name (_ADR, 5) }
  Device (PRT6) { Name (_ADR, 6) }
 }
}
Device (XHC)
{
 Name(_ADR, 0x00140000)
 OperationRegion(XDEV, PCI_Config, 0, 256)
 Field(XDEV, DWordAcc, NoLock, Preserve)
 {
  Offset(0xD0),
  X2PR, 32,
  PRM2, 32,
  SSEN, 32,
  RPM3, 32,
  XPRT, 32,
 }
 Name (_PRW, Package(){ 13, 4 })
 Method(POSC,2,Serialized)
 {
  CreateDWordField(Arg1,0,CDW1)
  If(LNotEqual(Arg0,One)) {
   Or(CDW1,0x8,CDW1)
  }
  If(LEqual(XHCI, 0)) {
   Or(CDW1,0x2,CDW1)
  }
  If(LAnd(LNot(And(CDW1,0x1)),LOr(LEqual(XHCI ,2), LEqual(XHCI ,3)))) {
   Store ("XHCI Switch", Debug)
   Store(Zero, Local0)
   And(XPRT, 0x3, Local0)
   If(LOr(LEqual(Local0, 0), LEqual(Local0, 1))) {
    Store(0xF, Local1)
   }
   ElseIf(LEqual(Local0, 2)) {
    Store(0x3, Local1)
   }
   ElseIf(LEqual(Local0, 3)) {
    Store(Zero, Local1)
   }
   And(RPM3, 0xFFFFFFF0, Local0)
   Or(Local0, Local1, RPM3)
   And(PRM2, 0xFFFFFFF0, Local0)
   Or(Local0, Local1, PRM2)
   And(SSEN, 0xFFFFFFF0, Local0)
   Or(Local0, Local1, SSEN)
   And(X2PR, 0xFFFFFFF0, Local0)
   Or(Local0, Local1, X2PR)
  }
  Return(Arg1)
 }
 Method(_S3D,0)
 {
  Return (2)
 }
 Method(_S4D,0)
 {
  Return (2)
 }
}
Device (LPCB)
{
 Name(_ADR, 0x001f0000)
 OperationRegion(LPC0, PCI_Config, 0x00, 0x100)
 Field (LPC0, AnyAcc, NoLock, Preserve)
 {
  Offset (0x40),
  PMBS, 16,
  Offset (0x60),
  PRTA, 8,
  PRTB, 8,
  PRTC, 8,
  PRTD, 8,
  Offset (0x68),
  PRTE, 8,
  PRTF, 8,
  PRTG, 8,
  PRTH, 8,
  Offset (0x80),
  IOD0, 8,
  IOD1, 8,
  Offset (0xb8),
  GR00, 2,
  GR01, 2,
  GR02, 2,
  GR03, 2,
  GR04, 2,
  GR05, 2,
  GR06, 2,
  GR07, 2,
  GR08, 2,
  GR09, 2,
  GR10, 2,
  GR11, 2,
  GR12, 2,
  GR13, 2,
  GR14, 2,
  GR15, 2,
  Offset (0xf0),
  RCEN, 1,
  , 13,
  RCBA, 18,
 }
Device (LNKA)
{
 Name (_HID, EISAID("PNP0C0F"))
 Name (_UID, 1)
 Method (_DIS, 0, Serialized)
 {
  Store (0x80, PRTA)
 }
 Name (_PRS, ResourceTemplate()
 {
  IRQ(Level, ActiveLow, Shared)
   { 3, 4, 5, 6, 7, 10, 11, 12, 14, 15 }
 })
 Method (_CRS, 0, Serialized)
 {
  Name (RTLA, ResourceTemplate()
  {
   IRQ(Level, ActiveLow, Shared) {}
  })
  CreateWordField(RTLA, 1, IRQ0)
  Store (Zero, IRQ0)
  ShiftLeft(1, And(PRTA, 0x0f), IRQ0)
  Return (RTLA)
 }
 Method (_SRS, 1, Serialized)
 {
  CreateWordField(Arg0, 1, IRQ0)
  FindSetRightBit(IRQ0, Local0)
  Decrement(Local0)
  Store(Local0, PRTA)
 }
 Method (_STA, 0, Serialized)
 {
  If(And(PRTA, 0x80)) {
   Return (0x9)
  } Else {
   Return (0xb)
  }
 }
}
Device (LNKB)
{
 Name (_HID, EISAID("PNP0C0F"))
 Name (_UID, 2)
 Method (_DIS, 0, Serialized)
 {
  Store (0x80, PRTB)
 }
 Name (_PRS, ResourceTemplate()
 {
  IRQ(Level, ActiveLow, Shared)
   { 3, 4, 5, 6, 7, 10, 11, 12, 14, 15 }
 })
 Method (_CRS, 0, Serialized)
 {
  Name (RTLB, ResourceTemplate()
  {
   IRQ(Level, ActiveLow, Shared) {}
  })
  CreateWordField(RTLB, 1, IRQ0)
  Store (Zero, IRQ0)
  ShiftLeft(1, And(PRTB, 0x0f), IRQ0)
  Return (RTLB)
 }
 Method (_SRS, 1, Serialized)
 {
  CreateWordField(Arg0, 1, IRQ0)
  FindSetRightBit(IRQ0, Local0)
  Decrement(Local0)
  Store(Local0, PRTB)
 }
 Method (_STA, 0, Serialized)
 {
  If(And(PRTB, 0x80)) {
   Return (0x9)
  } Else {
   Return (0xb)
  }
 }
}
Device (LNKC)
{
 Name (_HID, EISAID("PNP0C0F"))
 Name (_UID, 3)
 Method (_DIS, 0, Serialized)
 {
  Store (0x80, PRTC)
 }
 Name (_PRS, ResourceTemplate()
 {
  IRQ(Level, ActiveLow, Shared)
   { 3, 4, 5, 6, 7, 10, 11, 12, 14, 15 }
 })
 Method (_CRS, 0, Serialized)
 {
  Name (RTLC, ResourceTemplate()
  {
   IRQ(Level, ActiveLow, Shared) {}
  })
  CreateWordField(RTLC, 1, IRQ0)
  Store (Zero, IRQ0)
  ShiftLeft(1, And(PRTC, 0x0f), IRQ0)
  Return (RTLC)
 }
 Method (_SRS, 1, Serialized)
 {
  CreateWordField(Arg0, 1, IRQ0)
  FindSetRightBit(IRQ0, Local0)
  Decrement(Local0)
  Store(Local0, PRTC)
 }
 Method (_STA, 0, Serialized)
 {
  If(And(PRTC, 0x80)) {
   Return (0x9)
  } Else {
   Return (0xb)
  }
 }
}
Device (LNKD)
{
 Name (_HID, EISAID("PNP0C0F"))
 Name (_UID, 4)
 Method (_DIS, 0, Serialized)
 {
  Store (0x80, PRTD)
 }
 Name (_PRS, ResourceTemplate()
 {
  IRQ(Level, ActiveLow, Shared)
   { 3, 4, 5, 6, 7, 10, 11, 12, 14, 15 }
 })
 Method (_CRS, 0, Serialized)
 {
  Name (RTLD, ResourceTemplate()
  {
   IRQ(Level, ActiveLow, Shared) {}
  })
  CreateWordField(RTLD, 1, IRQ0)
  Store (Zero, IRQ0)
  ShiftLeft(1, And(PRTD, 0x0f), IRQ0)
  Return (RTLD)
 }
 Method (_SRS, 1, Serialized)
 {
  CreateWordField(Arg0, 1, IRQ0)
  FindSetRightBit(IRQ0, Local0)
  Decrement(Local0)
  Store(Local0, PRTD)
 }
 Method (_STA, 0, Serialized)
 {
  If(And(PRTD, 0x80)) {
   Return (0x9)
  } Else {
   Return (0xb)
  }
 }
}
Device (LNKE)
{
 Name (_HID, EISAID("PNP0C0F"))
 Name (_UID, 5)
 Method (_DIS, 0, Serialized)
 {
  Store (0x80, PRTE)
 }
 Name (_PRS, ResourceTemplate()
 {
  IRQ(Level, ActiveLow, Shared)
   { 3, 4, 5, 6, 7, 10, 11, 12, 14, 15 }
 })
 Method (_CRS, 0, Serialized)
 {
  Name (RTLE, ResourceTemplate()
  {
   IRQ(Level, ActiveLow, Shared) {}
  })
  CreateWordField(RTLE, 1, IRQ0)
  Store (Zero, IRQ0)
  ShiftLeft(1, And(PRTE, 0x0f), IRQ0)
  Return (RTLE)
 }
 Method (_SRS, 1, Serialized)
 {
  CreateWordField(Arg0, 1, IRQ0)
  FindSetRightBit(IRQ0, Local0)
  Decrement(Local0)
  Store(Local0, PRTE)
 }
 Method (_STA, 0, Serialized)
 {
  If(And(PRTE, 0x80)) {
   Return (0x9)
  } Else {
   Return (0xb)
  }
 }
}
Device (LNKF)
{
 Name (_HID, EISAID("PNP0C0F"))
 Name (_UID, 6)
 Method (_DIS, 0, Serialized)
 {
  Store (0x80, PRTF)
 }
 Name (_PRS, ResourceTemplate()
 {
  IRQ(Level, ActiveLow, Shared)
   { 3, 4, 5, 6, 7, 10, 11, 12, 14, 15 }
 })
 Method (_CRS, 0, Serialized)
 {
  Name (RTLF, ResourceTemplate()
  {
   IRQ(Level, ActiveLow, Shared) {}
  })
  CreateWordField(RTLF, 1, IRQ0)
  Store (Zero, IRQ0)
  ShiftLeft(1, And(PRTF, 0x0f), IRQ0)
  Return (RTLF)
 }
 Method (_SRS, 1, Serialized)
 {
  CreateWordField(Arg0, 1, IRQ0)
  FindSetRightBit(IRQ0, Local0)
  Decrement(Local0)
  Store(Local0, PRTF)
 }
 Method (_STA, 0, Serialized)
 {
  If(And(PRTF, 0x80)) {
   Return (0x9)
  } Else {
   Return (0xb)
  }
 }
}
Device (LNKG)
{
 Name (_HID, EISAID("PNP0C0F"))
 Name (_UID, 7)
 Method (_DIS, 0, Serialized)
 {
  Store (0x80, PRTG)
 }
 Name (_PRS, ResourceTemplate()
 {
  IRQ(Level, ActiveLow, Shared)
   { 3, 4, 5, 6, 7, 10, 11, 12, 14, 15 }
 })
 Method (_CRS, 0, Serialized)
 {
  Name (RTLG, ResourceTemplate()
  {
   IRQ(Level, ActiveLow, Shared) {}
  })
  CreateWordField(RTLG, 1, IRQ0)
  Store (Zero, IRQ0)
  ShiftLeft(1, And(PRTG, 0x0f), IRQ0)
  Return (RTLG)
 }
 Method (_SRS, 1, Serialized)
 {
  CreateWordField(Arg0, 1, IRQ0)
  FindSetRightBit(IRQ0, Local0)
  Decrement(Local0)
  Store(Local0, PRTG)
 }
 Method (_STA, 0, Serialized)
 {
  If(And(PRTG, 0x80)) {
   Return (0x9)
  } Else {
   Return (0xb)
  }
 }
}
Device (LNKH)
{
 Name (_HID, EISAID("PNP0C0F"))
 Name (_UID, 8)
 Method (_DIS, 0, Serialized)
 {
  Store (0x80, PRTH)
 }
 Name (_PRS, ResourceTemplate()
 {
  IRQ(Level, ActiveLow, Shared)
   { 3, 4, 5, 6, 7, 10, 11, 12, 14, 15 }
 })
 Method (_CRS, 0, Serialized)
 {
  Name (RTLH, ResourceTemplate()
  {
   IRQ(Level, ActiveLow, Shared) {}
  })
  CreateWordField(RTLH, 1, IRQ0)
  Store (Zero, IRQ0)
  ShiftLeft(1, And(PRTH, 0x0f), IRQ0)
  Return (RTLH)
 }
 Method (_SRS, 1, Serialized)
 {
  CreateWordField(Arg0, 1, IRQ0)
  FindSetRightBit(IRQ0, Local0)
  Decrement(Local0)
  Store(Local0, PRTH)
 }
 Method (_STA, 0, Serialized)
 {
  If(And(PRTH, 0x80)) {
   Return (0x9)
  } Else {
   Return (0xb)
  }
 }
}
 Device (DMAC)
 {
  Name(_HID, EISAID("PNP0200"))
  Name(_CRS, ResourceTemplate()
  {
   IO (Decode16, 0x00, 0x00, 0x01, 0x20)
   IO (Decode16, 0x81, 0x81, 0x01, 0x11)
   IO (Decode16, 0x93, 0x93, 0x01, 0x0d)
   IO (Decode16, 0xc0, 0xc0, 0x01, 0x20)
   DMA (Compatibility, NotBusMaster, Transfer8_16) { 4 }
  })
 }
 Device (FWH)
 {
  Name (_HID, EISAID("INT0800"))
  Name (_CRS, ResourceTemplate()
  {
   Memory32Fixed(ReadOnly, 0xff000000, 0x01000000)
  })
 }
 Device (HPET)
 {
  Name (_HID, EISAID("PNP0103"))
  Name (_CID, 0x010CD041)
  Name(BUF0, ResourceTemplate()
  {
   Memory32Fixed(ReadOnly, 0xfed00000, 0x400, FED0)
  })
  Method (_STA, 0)
  {
   If (HPTE) {
    If (LGreaterEqual(OSYS, 2001)) {
     Return (0xf)
    } Else {
     Return (0xb)
    }
   }
   Return (0x0)
  }
  Method (_CRS, 0, Serialized)
  {
   If (HPTE) {
    CreateDWordField(BUF0, \_SB.PCI0.LPCB.HPET.FED0._BAS, HPT0)
    If (Lequal(HPAS, 1)) {
     Add(0xfed00000, 0x1000, HPT0)
    }
    If (Lequal(HPAS, 2)) {
     Add(0xfed00000, 0x2000, HPT0)
    }
    If (Lequal(HPAS, 3)) {
     Add(0xfed00000, 0x3000, HPT0)
    }
   }
   Return (BUF0)
  }
 }
 Device(PIC)
 {
  Name(_HID,EISAID("PNP0000"))
  Name(_CRS, ResourceTemplate()
  {
   IO (Decode16, 0x20, 0x20, 0x01, 0x02)
   IO (Decode16, 0x24, 0x24, 0x01, 0x02)
   IO (Decode16, 0x28, 0x28, 0x01, 0x02)
   IO (Decode16, 0x2c, 0x2c, 0x01, 0x02)
   IO (Decode16, 0x30, 0x30, 0x01, 0x02)
   IO (Decode16, 0x34, 0x34, 0x01, 0x02)
   IO (Decode16, 0x38, 0x38, 0x01, 0x02)
   IO (Decode16, 0x3c, 0x3c, 0x01, 0x02)
   IO (Decode16, 0xa0, 0xa0, 0x01, 0x02)
   IO (Decode16, 0xa4, 0xa4, 0x01, 0x02)
   IO (Decode16, 0xa8, 0xa8, 0x01, 0x02)
   IO (Decode16, 0xac, 0xac, 0x01, 0x02)
   IO (Decode16, 0xb0, 0xb0, 0x01, 0x02)
   IO (Decode16, 0xb4, 0xb4, 0x01, 0x02)
   IO (Decode16, 0xb8, 0xb8, 0x01, 0x02)
   IO (Decode16, 0xbc, 0xbc, 0x01, 0x02)
   IO (Decode16, 0x4d0, 0x4d0, 0x01, 0x02)
   IRQNoFlags () { 2 }
  })
 }
 Device(MATH)
 {
  Name (_HID, EISAID("PNP0C04"))
  Name (_CRS, ResourceTemplate()
  {
   IO (Decode16, 0xf0, 0xf0, 0x01, 0x01)
   IRQNoFlags() { 13 }
  })
 }
 Device(LDRC)
 {
  Name (_HID, EISAID("PNP0C02"))
  Name (_UID, 2)
  Name (_CRS, ResourceTemplate()
  {
   IO (Decode16, 0x2e, 0x2e, 0x1, 0x02)
   IO (Decode16, 0x4e, 0x4e, 0x1, 0x02)
   IO (Decode16, 0x61, 0x61, 0x1, 0x01)
   IO (Decode16, 0x63, 0x63, 0x1, 0x01)
   IO (Decode16, 0x65, 0x65, 0x1, 0x01)
   IO (Decode16, 0x67, 0x67, 0x1, 0x01)
   IO (Decode16, 0x80, 0x80, 0x1, 0x01)
   IO (Decode16, 0x92, 0x92, 0x1, 0x01)
   IO (Decode16, 0xb2, 0xb2, 0x1, 0x02)
   IO (Decode16, 0x0500, 0x0500, 0x1, 0x80)
   IO (Decode16, 0x0480, 0x0480, 0x1, 0x40)
  })
 }
 Device (RTC)
 {
  Name (_HID, EISAID("PNP0B00"))
  Name (_CRS, ResourceTemplate()
  {
   IO (Decode16, 0x70, 0x70, 1, 8)
  })
 }
 Device (TIMR)
 {
  Name(_HID, EISAID("PNP0100"))
  Name(_CRS, ResourceTemplate()
  {
   IO (Decode16, 0x40, 0x40, 0x01, 0x04)
   IO (Decode16, 0x50, 0x50, 0x10, 0x04)
   IRQNoFlags() {0}
  })
 }
}
Device (SATA)
{
 Name (_ADR, 0x001f0002)
}
Device (SBUS)
{
 Name (_ADR, 0x001f0003)
}
Method (_OSC, 4)
{
 If (LEqual (Arg0, ToUUID("7c9512a9-1705-4cb4-af7d-506a2423ab71")))
 {
  Return (^XHC.POSC(Arg2, Arg3))
 }
 If (LEqual (Arg0, ToUUID("33DB4D5B-1FF7-401C-9657-7441C03DD766")))
 {
  Return (Arg3)
 }
 CreateDWordField (Arg3, 0, CDW1)
 Or (CDW1, 4, CDW1)
 Return (Arg3)
}
 }
}
