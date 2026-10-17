typedef unsigned char   undefined;

typedef unsigned short    undefined2;
typedef unsigned int    undefined4;
typedef unsigned char    byte;



// WARNING: Control flow encountered bad instruction data

/*
 * Original: FUN_00000006; source: ID07.c:9-16.
 * Recovered name: load_str129_string_table [STRONG INFERENCE] (iteration 109).
 * Status: RENAMED. Ghidra stopped at the inline switch table after the JSR at
 * file 0xd6 (bytes 0xda..0xe5 are data, not code). halt_baddata() is retained;
 * the real body below is described from bytes, NOT reconstructed as C.
 * Coordinates: ID07.bin file offsets; CODE header is 4 bytes, so jump-table
 * segment offsets map to file offset + 4 (checked for seg 9 / seg 1 targets).
 *
 * Binary file 0x06..0x18e [PROVEN, bytes; Capstone 68000 BE]:
 *   h = GetResource('STR#', 0x81)      CLR.L -(A7); PEA #'STR#'; MOVE.W #$81; $A9A0
 *   JSR $272(A5)(h)                    JT -> seg 9 file 0x270 = HLock glue ($A029)
 *   p = *h + 2                          skip STR# count word (count not read)
 *   for i = 1 .. 0x78 (CMPI.W #$79 / BLT):
 *     len = (unsigned) p[0]; next = p + len + 1
 *     if p[1] == '\\' && p[2] == 'p':   explicit Pascal-string marker
 *       JSR $4fa(A5)(p+1, p+3, len-2)  JT -> seg 2 FUN_0000024a (overlap-safe
 *       len -= 2; is_c = 0             memmove(dst, src, n)), drops "\p"
 *     else is_c = 1
 *     escape pass, j (read) = k (write) = 1, while j <= len (signed word):
 *       c = p[j]; if c == '\\': switch p[j+1] via JSR $3a(A5) (seg 1 file
 *       0xbe: table lo=0x72, hi=0x74, default/off words relative to themselves)
 *         'r' -> c = 0x0d, j++    't' -> c = 0x09, j++
 *         's' and out-of-range -> default: c = '\\' kept, next char not consumed
 *       p[k++] = c; j++
 *     len = k - 1
 *     if is_c: memmove(p, p+1, len); p[len] = 0      -> C string at p
 *     else:    p[0] = low byte of len                 -> Pascal string at p
 *     ((long *)(A5 - 0xf46))[i] = p; p = next        slot 0 is never written
 *
 * [STRONG INFERENCE] $A9A0 = _GetResource (Inside Macintosh Resource Manager).
 * Side effects: resource stays loaded and locked; strings are rewritten in
 * place inside the resource handle; A5-0xf46 table gets 120 pointers.
 * [UNKNOWN] Whether the resource always holds >= 120 strings (no bounds check),
 * NULL-handle behaviour (no test before HLock / dereference).
 * Caller: FUN_00000190 (ID07.c:26), sole call site in the exports.
 */
void load_str129_string_table /* Original: FUN_00000006 */ (void)

{
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



/*
 * Original: FUN_00000190; source: ID07.c:20-44.
 * Recovered name: init_string_pointer_groups [STRONG INFERENCE] (iteration 110).
 * Status: RENAMED. Exported C matches binary file 0x190..0x268 [PROVEN, bytes]:
 * JSR $6(PC) then four LEA d16(A5) copy loops of longwords.
 * Input: none (A5 world). Output: void.
 * Effect: loads STR# 129 (load_str129_string_table) and copies pointers from
 * the 120-slot table at A5-0xf46 into four smaller A5 pointer arrays:
 *   A5-0x221e[0..20]  <- slots   2..22  (21 entries)
 *   A5-0x0ffe[0..5]   <- slots  94..99  (6)
 *   A5-0x0fae[0..5]   <- slots 100..105 (6)
 *   A5-0x0f86[0..9]   <- slots 106..115 (10)
 * Slots 1, 23..93 and 116..120 are not copied here.
 * Caller [PROVEN, bytes]: ID02.bin file 0x2c0a JSR $592(A5) inside the
 * truncated FUN_00002bbc; CODE 0 entry A5+0x592 = seg 7 off 0x18c (= file 0x190).
 * Readers [PROVEN, bytes; meaning UNKNOWN]: ID04.bin 0x22e2 reads A5-0x221e[0];
 * ID04.c:711 indexes A5-0x0ffe by a record word at +0x22 and passes the
 * string to JT routines $2fa/$52a/$512; ID04 LEAs of -0xfae and -0xf86 at
 * file 0x131a, 0x1cba, 0x1d14, 0x2aac.
 * [UNKNOWN] Semantic category of each group (names, messages, menus...).
 * Note: loop 1 tests local_6 < 0x15; the binary uses CMPI.W #$14 / BLE,
 * which is equivalent for the signed word counter.
 */
void init_string_pointer_groups /* Original: FUN_00000190 */ (void)

{
  int unaff_A5;
  undefined2 local_6;

  load_str129_string_table(); /* Original: FUN_00000006; binary JSR $6(PC) at file 0x194 */
  for (local_6 = 0; local_6 < 0x15; local_6 = local_6 + 1) {
    *(undefined4 *)(local_6 * 4 + unaff_A5 + -0x221e) =
         *(undefined4 *)((short)(local_6 + 2) * 4 + unaff_A5 + -0xf46);
  }
  for (local_6 = 0; local_6 < 6; local_6 = local_6 + 1) {
    *(undefined4 *)(local_6 * 4 + unaff_A5 + -0xffe) =
         *(undefined4 *)((short)(local_6 + 0x5e) * 4 + unaff_A5 + -0xf46);
  }
  for (local_6 = 0; local_6 < 6; local_6 = local_6 + 1) {
    *(undefined4 *)(local_6 * 4 + unaff_A5 + -0xfae) =
         *(undefined4 *)((short)(local_6 + 100) * 4 + unaff_A5 + -0xf46);
  }
  for (local_6 = 0; local_6 < 10; local_6 = local_6 + 1) {
    *(undefined4 *)(local_6 * 4 + unaff_A5 + -0xf86) =
         *(undefined4 *)((short)(local_6 + 0x6a) * 4 + unaff_A5 + -0xf46);
  }
  return;
}


