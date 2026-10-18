typedef unsigned char   undefined;

typedef unsigned int    uint;
typedef unsigned long long    ulonglong;
typedef unsigned int    undefined4;
typedef unsigned long long    undefined8;
typedef unsigned char    byte;



/* Original: FUN_00000110; source: ID01.c. Recovered name: rt_udiv32 [PROVEN].
 * Decoded from ID01.bin bytes at file 0x110.
 * Stack-argument entry (dividend at 4(A7), divisor at 8(A7) on entry; the code shuffles the return address so the caller sees D1 preserved) that saves D2-D3/D7 and calls rt_udivmod32_core (0x1c2); returns the unsigned quotient in D0 [PROVEN, bytes 0x110..0x12e].
 */
undefined4 rt_udiv32 /* Original: FUN_00000110 */ (void)

{
  undefined4 in_D1;
  undefined4 uStack00000004;
  
  uStack00000004 = in_D1;
  rt_udivmod32_core();
  return uStack00000004;
}



/* Original: FUN_00000130; source: ID01.c. Recovered name: rt_umod32 [PROVEN].
 * Decoded from ID01.bin bytes at file 0x130.
 * Stack-argument entry (dividend at 4(A7), divisor at 8(A7) on entry; the code shuffles the return address so the caller sees D1 preserved) that saves D2-D3/D7 and calls rt_udivmod32_core (0x1c2); returns the unsigned remainder (MOVE.L D1,D0) in D0 [PROVEN, bytes 0x130..0x150].
 */
undefined8 rt_umod32 /* Original: FUN_00000130 */ (void)

{
  undefined4 in_D1;
  ulonglong uVar1;
  undefined4 uStack00000004;
  
  uStack00000004 = in_D1;
  uVar1 = rt_udivmod32_core();
  return CONCAT44((int)uVar1,uStack00000004);
}



/* Original: FUN_00000152; source: ID01.c. Recovered name: rt_sdiv32 [PROVEN].
 * Decoded from ID01.bin bytes at file 0x152.
 * Stack-argument entry (dividend at 4(A7), divisor at 8(A7) on entry; the code shuffles the return address so the caller sees D1 preserved) that saves D2-D3/D7 and calls rt_sdivmod32_core (0x194); returns the signed quotient in D0 [PROVEN, bytes 0x152..0x170]. Reached through JT $5a (used by ID02 ansi_ldiv).
 */
void rt_sdiv32 /* Original: FUN_00000152 */ (void)

{
  rt_sdivmod32_core();
  return;
}



/* Original: FUN_00000172; source: ID01.c. Recovered name: rt_smod32 [PROVEN].
 * Decoded from ID01.bin bytes at file 0x172.
 * Stack-argument entry (dividend at 4(A7), divisor at 8(A7) on entry; the code shuffles the return address so the caller sees D1 preserved) that saves D2-D3/D7 and calls rt_sdivmod32_core (0x194); returns the signed remainder in D0 [PROVEN, bytes 0x172..0x192]. Reached through JT $62 (used by ID02 ansi_ldiv).
 */
undefined8 rt_smod32 /* Original: FUN_00000172 */ (void)

{
  undefined4 in_D1;
  uint uVar1;
  undefined4 uStack00000004;
  
  uStack00000004 = in_D1;
  uVar1 = rt_sdivmod32_core();
  return CONCAT44(uVar1,uStack00000004);
}



/* Original: FUN_00000194; source: ID01.c. Recovered name: rt_sdivmod32_core [PROVEN].
 * Decoded from ID01.bin bytes at file 0x194.
 * Register interface D0 = dividend, D1 = divisor. Makes both operands positive (NEG.L), calls rt_udivmod32_core and fixes the signs so the quotient truncates toward zero and the remainder takes the sign of the dividend (C semantics) [PROVEN, bytes 0x194..0x1c0].
 */
uint rt_sdivmod32_core /* Original: FUN_00000194 */ (void)

{
  int iVar1;
  uint in_D0;
  uint uVar2;
  undefined2 uVar3;
  uint in_D1;
  uint uVar4;
  uint uVar5;
  uint uVar6;
  ulonglong uVar7;
  
  if ((int)in_D0 < 0) {
    if (-1 < (int)in_D1) {
      uVar7 = rt_udivmod32_core();
      return -(int)uVar7;
    }
    uVar7 = rt_udivmod32_core();
    return -(int)uVar7;
  }
  if ((int)in_D1 < 0) {
    uVar7 = rt_udivmod32_core();
    return (uint)uVar7;
  }
  if (in_D0 < in_D1) {
    return in_D0;
  }
  uVar3 = (undefined2)(in_D1 >> 0x10);
  if (0xffff < in_D0) {
    uVar2 = in_D0;
    uVar4 = in_D1;
    if (0xffff < in_D1) {
      do {
        uVar2 = uVar2 >> 1;
        uVar4 = uVar4 >> 1;
      } while (0xffff < uVar4);
      for (uVar2 = uVar2 / (uVar4 & 0xffff) & 0xffff;
          (uVar5 = (in_D1 & 0xffff) * uVar2, uVar4 = (in_D1 >> 0x10) * uVar2,
          uVar6 = uVar4 * 0x10000 | uVar4 >> 0x10, uVar4 = uVar6 + uVar5, CARRY4(uVar6,uVar5) ||
          (iVar1 = uVar4 - in_D0, in_D0 <= uVar4 && iVar1 != 0));
          uVar2 = (uint)(ushort)((short)uVar2 - 1)) {
      }
      return -iVar1;
    }
    return CONCAT22(uVar3,(short)(((in_D0 >> 0x10) % (in_D1 & 0xffff) << 0x10 | in_D0 & 0xffff) %
                                 (in_D1 & 0xffff)));
  }
  return CONCAT22(uVar3,(short)(in_D0 % (in_D1 & 0xffff)));
}



/* Original: FUN_000001c2; source: ID01.c. Recovered name: rt_udivmod32_core [PROVEN].
 * Decoded from ID01.bin bytes at file 0x1c2.
 * Register interface D0 = dividend, D1 = divisor (unsigned 32-bit); returns D0 = quotient, D1 = remainder. Fast paths: dividend < divisor (quotient 0); dividend <= 0xffff (one DIVU.W); divisor <= 0xffff (two chained DIVU.W); otherwise normalises both by shifting right until the divisor fits 16 bits, estimates the quotient with DIVU.W and corrects it downward by multiplying back (MULU.W) until the product no longer exceeds the dividend [PROVEN, bytes 0x1c2..0x22a+]. A pre-68020 style routine (the 68020 DIVU.L is not used).\n * Other ID01 code not exported by Ghidra (bytes 0x00..0x10e): 0x00 / 0x04 hold 0x0a and 0x4b2 (header words; 0x4b2 is the entry JT offset used by ID02 main [PROVEN]); 0x08..0x32 start-up: clears $0A4A, A6 = 0, JSR 0x34, then a call through JT $4b2 / the first jump-table slot and ExitToShell ($A9F4); 0x34..0x94 initialises the A5 world: GetResource(ZERO, 0) and GetResource(DATA, 0) ($A9A0), expands DATA into the globals below CurrentA5 (word runs, zero runs from ZERO), releases both, then GetResource(DREL, 0) and adds A5 to every relocation offset it lists (A5-relative pointer fix-ups); 0x96 / 0xaa / 0xbe are the switch helpers reached through JT $2a (word values: count, then (offset, value) pairs and a default), JT $32 (long values) and JT $3a (dense: lo, hi, default, offsets) - the formats decoded; 0xda is a 32 x 32 -> 32 multiply built from three MULU.W. These explain the inline tables Ghidra decoded as ori.b / btst instructions throughout ID02..ID04.
 */
ulonglong rt_udivmod32_core /* Original: FUN_000001c2 */ (void)

{
  int iVar1;
  uint in_D0;
  undefined2 uVar2;
  uint in_D1;
  uint uVar3;
  uint uVar4;
  uint uVar5;
  uint uVar6;
  
  if (in_D0 < in_D1) {
    return (ulonglong)in_D0;
  }
  uVar2 = (undefined2)(in_D1 >> 0x10);
  if (0xffff < in_D0) {
    uVar5 = in_D0;
    uVar3 = in_D1;
    if (0xffff < in_D1) {
      do {
        uVar5 = uVar5 >> 1;
        uVar3 = uVar3 >> 1;
      } while (0xffff < uVar3);
      for (uVar5 = uVar5 / (uVar3 & 0xffff) & 0xffff;
          (uVar4 = (in_D1 & 0xffff) * uVar5, uVar3 = (in_D1 >> 0x10) * uVar5,
          uVar6 = uVar3 * 0x10000 | uVar3 >> 0x10, uVar3 = uVar6 + uVar4, CARRY4(uVar6,uVar4) ||
          (iVar1 = uVar3 - in_D0, in_D0 <= uVar3 && iVar1 != 0));
          uVar5 = (uint)(ushort)((short)uVar5 - 1)) {
      }
      return CONCAT44(uVar5,-iVar1);
    }
    uVar5 = (in_D0 >> 0x10) % (in_D1 & 0xffff) << 0x10 | in_D0 & 0xffff;
    return CONCAT44(CONCAT22((short)((in_D0 >> 0x10) / (in_D1 & 0xffff)),
                             (short)(uVar5 / (in_D1 & 0xffff))),
                    CONCAT22(uVar2,(short)(uVar5 % (in_D1 & 0xffff))));
  }
  return CONCAT44(in_D0 / (in_D1 & 0xffff),CONCAT22(uVar2,(short)(in_D0 % (in_D1 & 0xffff)))) &
         0xffffffffffff;
}


