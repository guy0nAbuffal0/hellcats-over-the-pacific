typedef unsigned char   undefined;

typedef unsigned int    uint;
typedef unsigned char    undefined1;
typedef unsigned short    undefined2;
typedef unsigned int    undefined4;
typedef unsigned short    ushort;
typedef unsigned char    byte;



// WARNING: Control flow encountered bad instruction data

/*
 * Original: FUN_00000006; source: ID05.c:12-19.
 * Recovered name: center_template_rect_on_screen [STRONG INFERENCE] (iteration 124).
 * Status: RENAMED. Ghidra truncated at $A9A0 (file 0x14); body from ID05.bin
 * file 0x06..0xc6 [PROVEN, bytes], not rebuilt as C. Args: long type [8(A6)],
 * word id [$c(A6)]; no JT entry, callers not yet found.
 *   h = GetResource(type, id); if (!h) return;  r = (Rect *)*h  (top 0, left 2,
 *   bottom 4, right 6)
 *   newLeft = (screenRight(A5-0x167a) - (r.right - r.left)) / 2  (DIVS.W, signed)
 *   r.right += newLeft - r.left;  r.left = newLeft
 *   mbar = JT $20a() (ID09 file 0x19c: word $0baa = MBarHeight)
 *   newTop = (screenBottom(A5-0x167c) - mbar - (r.bottom - r.top)) / 3
 *   r.bottom += (newTop - r.top) + mbar;  r.top = mbar + newTop
 * Rect fields per Inside Macintosh; DLOG/ALRT/WIND template use is
 * [HYPOTHESIS]. GetMBarHeight is called three times (re-read each time).
 */
void center_template_rect_on_screen /* Original: FUN_00000006 */ (void)

{
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



// WARNING: Control flow encountered bad instruction data

/*
 * Original: FUN_000000c8; source: ID05.c:23-45.
 * Recovered name: get_machine_screen_fingerprint [STRONG INFERENCE] (iteration 124).
 * Status: RENAMED. Exported C kept; its colour branch is truncated (halt_baddata).
 * Bytes file 0xc8..0x15e [PROVEN]:
 *   SysEnvirons(1, &env) via JT $1f2 (ID09 dispatcher, sysenvirons_glue_fallback);
 *   *param_1 = env.machineType;
 *   if (env.hasColorQD) {                 [branch Ghidra truncated]
 *     gd = $AA32 (GetGDevice); pm = **(*gd)->gdPMap (+0x16);
 *     *param_2 = pm.bounds.right (+0xc); *param_3 = pm.bounds.bottom (+0xa);
 *     *param_4 = pm.pixelSize (+0x20);
 *   } else {
 *     *param_2 = screenBits.bounds.right - left (A5-0x167a - A5-0x167e);
 *     *param_3 = bottom - top (A5-0x167c - A5-0x1680); *param_4 = 1;
 *   }
 *   *param_5 = 0;
 * Ghidra's local_12 / local_b are env+2 / env+9 (its offsets are relative to
 * the entry stack pointer). Caller [PROVEN]: ID05 file 0x3e4 (code-string
 * builder), whose five words go to pack_fields_to_code_buf68: machine type,
 * width/128, height/128, depth/4, 0 -> a machine-dependent code [STRONG INFERENCE].
 */
void get_machine_screen_fingerprint /* Original: FUN_000000c8 */ (undefined2 *param_1,short *param_2,short *param_3,undefined2 *param_4,
                 undefined2 *param_5)

{
  int unaff_A5;
  undefined1 auStack_14 [2];
  undefined2 local_12;
  char local_b;
  
  (**(code **)(unaff_A5 + 0x1f2))((short)auStack_14,0);
  *param_1 = local_12;
  if (local_b != '\0') {
                    // WARNING: Bad instruction - Truncating control flow here
    halt_baddata();
  }
  *param_2 = *(short *)(unaff_A5 + -0x167a) - *(short *)(unaff_A5 + -0x167e);
  *param_3 = *(short *)(unaff_A5 + -0x167c) - *(short *)(unaff_A5 + -0x1680);
  *param_4 = 1;
  *param_5 = 0;
  return;
}



// WARNING: Control flow encountered bad instruction data

/*
 * Original: FUN_00000160; source: ID05.c:51-58.
 * Recovered name: read_DATA128_pair [STRONG INFERENCE] (iteration 123).
 * Reads/writes two longs at the start of resource 'DATA' 128 (0x80).
 * Bytes [PROVEN]: h = GetResource('DATA', 0x80) ($A9A0); if (h) { JT $28a(h)
 * (ID09 file 0x28e, $A04A HNoPurge); *a = 0; *b = 0; then *a = (*h)[0], *b = (*h)[1]; JT $282(h) (ID09 0x284, $A049
 * HPurge); ReleaseResource(h) ($A9A3) }. Ghidra stopped at $A9A0.
 * Caller [PROVEN]: ID08 file 0x26c via JT $582 (overlay load sequence; the pair
 * then feeds encode_code28_to_buf54 / record_code_index_equals).
 * [HYPOTHESIS] Persistent protection/registration state hidden in generic
 * resource types; meaning of the two longs UNKNOWN. Exported C kept as is.
 */
void read_DATA128_pair /* Original: FUN_00000160 */ (undefined4 *param_1,undefined4 *param_2)

{
  *param_1 = 0;
  *param_2 = 0;
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



// WARNING: Control flow encountered bad instruction data

/*
 * Original: FUN_000001bc; source: ID05.c:64-69.
 * Recovered name: write_DATA128_pair [STRONG INFERENCE] (iteration 123).
 * Reads/writes two longs at the start of resource 'DATA' 128 (0x80).
 * Bytes [PROVEN]: h = GetResource('DATA', 0x80) ($A9A0); if (h) { JT $28a(h)
 * (ID09 file 0x28e, $A04A HNoPurge); (*h)[0] = arg1 [8(A6)], (*h)[1] = arg2 [$c(A6)]; ChangedResource ($A9AA);
 * WriteResource ($A9B0); JT $282(h) (ID09 0x284, $A049
 * HPurge); ReleaseResource(h) ($A9A3) }. Ghidra stopped at $A9A0.
 * Caller [PROVEN]: ID08 file 0x2c4 via JT $57a. Ghidra lost both long args.
 * [HYPOTHESIS] Persistent protection/registration state hidden in generic
 * resource types; meaning of the two longs UNKNOWN. Exported C kept as is.
 */
void write_DATA128_pair /* Original: FUN_000001bc */ (void)

{
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



// WARNING: Control flow encountered bad instruction data

/*
 * Original: FUN_00000214; source: ID05.c:75-82.
 * Recovered name: read_TEXT128_pair [STRONG INFERENCE] (iteration 123).
 * Reads/writes two longs at the start of resource 'TEXT' 128 (0x80).
 * Bytes [PROVEN]: h = GetResource('TEXT', 0x80) ($A9A0); if (h) { JT $28a(h)
 * (ID09 file 0x28e, $A04A HNoPurge); *a = 0; *b = 0; then *a = (*h)[0], *b = (*h)[1]; JT $282(h) (ID09 0x284, $A049
 * HPurge); ReleaseResource(h) ($A9A3) }. Ghidra stopped at $A9A0.
 * Callers [PROVEN]: ID05 file 0x3f4, 0x458 (code-string builder, routine B in
 * code_dialog_filter header).
 * [HYPOTHESIS] Persistent protection/registration state hidden in generic
 * resource types; meaning of the two longs UNKNOWN. Exported C kept as is.
 */
void read_TEXT128_pair /* Original: FUN_00000214 */ (undefined4 *param_1,undefined4 *param_2)

{
  *param_1 = 0;
  *param_2 = 0;
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



// WARNING: Control flow encountered bad instruction data

/*
 * Original: FUN_00000270; source: ID05.c:88-93.
 * Recovered name: write_TEXT128_pair [STRONG INFERENCE] (iteration 123).
 * Reads/writes two longs at the start of resource 'TEXT' 128 (0x80).
 * Bytes [PROVEN]: h = GetResource('TEXT', 0x80) ($A9A0); if (h) { JT $28a(h)
 * (ID09 file 0x28e, $A04A HNoPurge); (*h)[0] = arg1 [8(A6)], (*h)[1] = arg2 [$c(A6)]; ChangedResource ($A9AA);
 * WriteResource ($A9B0); JT $282(h) (ID09 0x284, $A049
 * HPurge); ReleaseResource(h) ($A9A3) }. Ghidra stopped at $A9A0.
 * Callers [PROVEN]: ID05 file 0x44a (args 0, random_28bit_value()) and 0x718.
 * Ghidra lost both long args.
 * [HYPOTHESIS] Persistent protection/registration state hidden in generic
 * resource types; meaning of the two longs UNKNOWN. Exported C kept as is.
 */
void write_TEXT128_pair /* Original: FUN_00000270 */ (void)

{
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



// WARNING: Control flow encountered bad instruction data

/*
 * Original: FUN_000002c8; source: ID05.c:99-104.
 * Recovered name: code_dialog_filter [STRONG INFERENCE] (iteration 122).
 * Status: RENAMED. Exported body is Ghidra's truncation at A-line $A873
 * (file 0x2d0). halt_baddata() retained; bodies below from ID05.bin [PROVEN, bytes].
 *
 * Routine A, file 0x2c8..0x3b8 (this Ghidra entry): Pascal-convention
 *   FUNCTION filter(dlg: DialogPtr [$10(A6)]; VAR evt: EventRecord [$c];
 *                   VAR item: INTEGER [$8]): BOOLEAN   (pops 12, result byte)
 *   SetPort(dlg) $A873;
 *   if (word A5-0x2ca++ == 0) {          redraw once after each reset
 *     GetDItem(dlg, 3, &t, &h, &r) $A98D; GetIText(h, text) $A990;
 *     GetDItem(dlg, 1, &t, &h, &r); PenSize(3,3) $A89B; InsetRect(&r,-4,-4) $A8A9;
 *     FrameRoundRect(&r, 16, 16) $A8B0;   default-button outline on item 1
 *     HiliteControl(h, text[0] == 0 ? 255 : 0) $A95D   dim OK while field empty
 *   }
 *   if (evt.what == keyDown(3) || evt.what == autoKey(5)) {
 *     A5-0x2ca = 0;
 *     c = byte evt+5 (low byte of message = charCode);
 *     if (c == 0x0d || c == 0x03) { *item = 1; return true; }   Return / Enter
 *     if (c == 0x1b)              { *item = 2; return true; }   Escape
 *   }
 *   return false;
 * Trap names / event layout: Inside Macintosh [STRONG INFERENCE].
 *
 * Routine B, file 0x3ba..0x4e2, NOT exported by Ghidra (no separate entry;
 * caller UNKNOWN) [PROVEN bytes; roles HYPOTHESIS]:
 *   args: long *a [8(A6)], char *outA [$c], long *b [$10], char *outB [$14]
 *   copy 0x102 bytes A5-0x2c8 -> local buf; get_machine_screen_fingerprint(&w1..&w5) fills 5 words;
 *   read_TEXT128_pair(a, b);  (FUN_00000214)
 *   if (*a == *b) {
 *     GetVol(buf, &vref) (JT $2ba = ID09 file 0x344, $A014);
 *     s = JT $2fa(buf) (ID09 file 0x432, p2cstr-like);
 *     if (JT $51a(s, A5-0xca) == 0)      (ID02 file 0x2ee, strcmp-like)
 *       write_TEXT128_pair(0, random_28bit_value());  (FUN_00000270)
 *   }
 *   read_TEXT128_pair(a, b);  (FUN_00000214)
 *   if (*b == *a) strcpy(outB, A5-0xd66)   (JT $52a = ID02 file 0x2c8, copy)
 *   else { strcpy(outB, pack_fields_to_code_buf68(w1..w5 as five words; w1 = -2(A6),
 *          pushed last = first C argument));
 *          strcpy(outB + 6, encode_code28_to_buf54(*b)); }
 *   strcpy(outA, encode_long_to_buf40(*a));
 * [HYPOTHESIS] Builds the 6/12-letter codes shown in the protection dialog;
 * the boot-volume name comparison gates a re-randomisation.
 */
void code_dialog_filter /* Original: FUN_000002c8 */ (void)

{
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



// WARNING: Control flow encountered bad instruction data

/*
 * Original: FUN_000004e4; source: ID05.c:110-115.
 * Recovered name: get_dialog_item_text_upper [STRONG INFERENCE] (iteration 125).
 * Status: RENAMED; Ghidra truncated at $A98D. Bytes file 0x4e4..0x55e [PROVEN]:
 *   GetDItem(dlg [8(A6)], item [$c(A6)], &t, &h, &r) $A98D; GetIText(h, A5-0x1c9) $A990;
 *   JT $2fa(A5-0x1c9) (ID09 0x432, Pascal->C in place);
 *   for each byte c: if (ctype table A5-0x1608[c] bit 7) c = JT $4e2(c)
 *     (ID02 FUN_000001ce; toupper-like [HYPOTHESIS]);
 *   return A5-0x1c9 (static buffer, overwritten on each call).
 * Callers [PROVEN]: run_protection_dialog file 0x66c, 0x688, 0x6b6.
 */
void get_dialog_item_text_upper /* Original: FUN_000004e4 */ (void)

{
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



// WARNING: Control flow encountered bad instruction data

/*
 * Original: FUN_00000560; source: ID05.c:121-126.
 * Recovered name: run_protection_dialog [STRONG INFERENCE] (iteration 125).
 * Status: RENAMED; Ghidra truncated at $A874. Bytes file 0x560..0x726 [PROVEN].
 * Args: long *a [8(A6)], long *b [$c(A6)]. Caller [PROVEN]: ID08 file 0x298 via
 * JT $572 (overlay load sequence; a/b were read by read_DATA128_pair).
 *   GetPort(&save) $A874; InitCursor $A850;
 *   code-string builder (file 0x3ba; see code_dialog_filter header)
 *     (a, outA=-$100, b, outB=-$200);
 *   if (record_code_index_equals(*a, outB + 6)) return;   already valid: no dialog
 *   FUN_000008d6(&w1, &w2, &w3)  -> random challenge from the A5-0xba table;
 *   NumToString (JT $2f2, ID09 0x404) of w1/w2/w3 into s1/s2/s3;
 *   center_template_rect_on_screen('DLOG', 1000);
 *   dlg = GetNewDialog(1000, nil, (WindowPtr)-1) $A97C; if (!dlg) ExitToShell;
 *   ShowWindow(dlg) $A915; ok = 0;
 *   do {
 *     c2pstr(outB) (JT $302, ID09 0x416); ParamText(outB, s3, s2, s1) $A98B;
 *     DrawDialog(dlg) $A981;
 *     do ModalDialog(code_dialog_filter (JT $562), &item) $A991;
 *       while (item != 1 && (item != 2 || (ExitToShell(), 1)));   item 2 quits
 *     p2cstr(outB);
 *     *a = decode_code_to_long_b(get_dialog_item_text_upper(dlg, 4));
 *     ok = matcher@0x964(w1, w2, w3, get_dialog_item_text_upper(dlg, 3));
 *     if (!ok) { ParamText(c2pstr(text of item 3), nil, nil, nil);
 *                center_template_rect_on_screen('ALRT', 1001); StopAlert(1001, nil) $A985; }
 *   } while (!ok);
 *   DisposDialog(dlg) $A983;
 *   if (record_code_index_equals(*a, outB + 6)) write_TEXT128_pair(*a, *b);
 *   SetPort(save) $A873.
 * [STRONG INFERENCE] Manual look-up copy protection: the dialog shows three
 * numbers (w1..w3, e.g. page/line/word) and expects the matching word in item 3
 * and an unlock code in item 4; success sets the 0x964 gate A5-0xc0 used by
 * restore_poisoned_overlay_bytes. Exact UI meaning of fields is HYPOTHESIS.
 */
void run_protection_dialog /* Original: FUN_00000560 */ (void)

{
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



/*
 * Original: FUN_00000728; source: ID05.c:130-137.
 * Recovered name: ansi_rand [PROVEN] (iteration 118).
 * seed (long A5-0x6c) = seed * 0x41c64e6d + 0x3039 (ANSI C reference LCG,
 * 1103515245 / 12345); returns bits 30..16 (0..32767). Binary file 0x728:
 * MULU.L #$41c64e6d (68020) / ADDI.L #$3039. 32-bit wraparound preserved.
 * Callers: poison_overlay_bytes, ID05.c:251, ID05.c:284-285.
 */
uint ansi_rand /* Original: FUN_00000728 */ (void)

{
  int unaff_A5;
  
  *(int *)(unaff_A5 + -0x6c) = *(int *)(unaff_A5 + -0x6c) * 0x41c64e6d + 0x3039;
  return (uint)(*(int *)(unaff_A5 + -0x6c) << 1) >> 0x11;
}



/*
 * Original: FUN_00000746; source: ID05.c:141-148.
 * Recovered name: ansi_srand [STRONG INFERENCE] (iteration 118).
 * Stores param_1 into the ansi_rand seed (long A5-0x6c). No callers found yet.
 */
void ansi_srand /* Original: FUN_00000746 */ (undefined4 param_1)

{
  int unaff_A5;
  
  *(undefined4 *)(unaff_A5 + -0x6c) = param_1;
  return;
}



/*
 * Original: FUN_00000754; source: ID05.c:152-168.
 * Recovered name: encode_base26_6chars [PROVEN] (iteration 120).
 * Writes 6 letters 'A'+(v % 26) right-to-left into param_1[0..5], v /= 26
 * each step, then NUL at param_1[6]. Signed arithmetic: binary file 0x76c /
 * 0x784 use 68020 DIVS.L #$1a (remainder in D1, quotient in D0), matching
 * the exported % and /. Negative v would give characters below 'A' (C
 * truncating remainder) - preserved. Return value (last quotient) is a
 * by-product with no proven use.
 * Callers [PROVEN, bytes]: ID05 file 0xb00, 0xb98, 0xbce (ID05.c:300, 332, 354)
 * writing to A5-0x68, A5-0x54, A5-0x40 respectively.
 */
int encode_base26_6chars /* Original: FUN_00000754 */ (char *param_1,int param_2)

{
  int iVar1;
  short local_a;
  
  param_1 = param_1 + 6;
  iVar1 = 0;
  for (local_a = 0; local_a < 6; local_a = local_a + 1) {
    param_1 = param_1 + -1;
    *param_1 = (char)(param_2 % 0x1a) + 'A';
    iVar1 = param_2 / 0x1a;
    param_2 = iVar1;
  }
  param_1[6] = '\0';
  return iVar1;
}



/*
 * Original: FUN_000007a8; source: ID05.c:172-187.
 * Recovered name: decode_base26_6chars [PROVEN] (iteration 120).
 * *param_2 = sum over 6 chars of acc*26 + (short)((s8)c - 'A'); inverse of
 * encode_base26_6chars for 'A'..'Z' input. Binary: MULU.L #$1a (low 32 bits
 * equal the signed product), EXTB.L, ADDI.W #$ffbf, EXT.L (file 0x7bc..0x7d8).
 * Callers [PROVEN, bytes]: ID05 file 0xb1c, 0xbb4, 0xbea (ID05.c:316, 343, 365).
 */
int decode_base26_6chars /* Original: FUN_000007a8 */ (int param_1,int *param_2)

{
  int iVar1;
  undefined2 local_a;
  undefined4 local_8;
  
  local_8 = 0;
  iVar1 = 0;
  for (local_a = 0; local_a < 6; local_a = local_a + 1) {
    iVar1 = (int)(short)(*(char *)(param_1 + local_a) + -0x41);
    local_8 = iVar1 + local_8 * 0x1a;
  }
  *param_2 = local_8;
  return iVar1;
}



/*
 * Original: FUN_000007f6; source: ID05.c:191-207.
 * Recovered name: poison_overlay_bytes [STRONG INFERENCE] (iteration 118).
 * Inputs: param_1 = base, param_2 = byte count. Output: void.
 * For up to 12 iterations (stops early if base == 0): offset = ansi_rand()
 * (16-bit, zero-extended) % param_2 (68020 DIVUL.L $c(A6),D1:D0 at file 0x80a,
 * remainder in D1); records {ptr (long), original byte} in 6-byte entries of
 * table A5-0xb4[12] (ptr at +0, byte at +4), then overwrites the byte with 0xFF.
 * Caller [PROVEN, bytes]: ID08 file 0x246 JSR $53a(A5) (CODE 0 JT seg5 off
 * 0x7f2) with (A5-0x1006 overlay base, A5-0x1022 overlay code size), directly
 * after the overlay is loaded and relocated.
 * [HYPOTHESIS] Copy-protection booby trap: the overlay stays corrupted unless
 * restore_poisoned_overlay_bytes finds its gate set. Duplicate offsets are
 * possible; reverse-order restore keeps the original byte in that case.
 */
void poison_overlay_bytes /* Original: FUN_000007f6 */ (int param_1,uint param_2)

{
  undefined1 *puVar1;
  uint uVar2;
  int unaff_A5;
  undefined2 local_6;
  
  for (local_6 = 0; (param_1 != 0 && (local_6 < 0xc)); local_6 = local_6 + 1) {
    uVar2 = ansi_rand(); /* Original: FUN_00000728 */
    puVar1 = (undefined1 *)(param_1 + (uVar2 & 0xffff) % param_2);
    *(undefined1 **)(local_6 * 6 + unaff_A5 + -0xb4) = puVar1;
    *(undefined1 *)(local_6 * 6 + unaff_A5 + -0xb0) = *puVar1;
    *puVar1 = 0xff;
  }
  return;
}



/*
 * Original: FUN_0000085e; source: ID05.c:211-232.
 * Recovered name: restore_poisoned_overlay_bytes [STRONG INFERENCE] (iteration 118).
 * If word A5-0xbc != 0 or long A5-0xc0 != 0, writes back the 12 saved bytes
 * of table A5-0xb4 in reverse order (11..0). Otherwise does nothing.
 * Caller [PROVEN, bytes]: ID08 file 0x29e JSR $55a(A5) (JT seg5 -> file 0x85e),
 * after the seg5 calls $542, $582, $552, $54a, $532 (conditional) and $572.
 * Gate writers (iteration 119): A5-0xbc via JT $532 stub file 0x8b2 after
 * record_code_index_equals; A5-0xc0 by unexported routine at file 0x964. Note: if neither gate is set, 12 overlay bytes remain 0xFF.
 */
void restore_poisoned_overlay_bytes /* Original: FUN_0000085e */ (void)

{
  short sVar1;
  bool bVar2;
  int unaff_A5;
  undefined2 local_6;
  
  if ((*(short *)(unaff_A5 + -0xbc) == 0) && (*(int *)(unaff_A5 + -0xc0) == 0)) {
    bVar2 = false;
  }
  else {
    bVar2 = true;
  }
  if (bVar2) {
    local_6 = 0xc;
    while (sVar1 = local_6 + -1, 0 < local_6) {
      **(undefined1 **)(sVar1 * 6 + unaff_A5 + -0xb4) =
           *(undefined1 *)(sVar1 * 6 + unaff_A5 + -0xb0);
      local_6 = sVar1;
    }
  }
  return;
}


/*
 * FUN_000008b8 (iteration 126): proposed name init_protection_table
 * [STRONG INFERENCE]. Not decompiled by Ghidra and not in the function
 * inventory; no C body exists to rename. Bytes file 0x8b8..0x8d4 [PROVEN]:
 *   LINK; ansi_srand(long $e(A6)) (BSR 0x746); long A5-0xba = $8(A6);
 *   word A5-0xb6 = $c(A6); UNLK; RTS.
 * Caller [PROVEN]: ID08 file 0x25c via JT $542 with (A5-0x1cc4, 0x38,
 * TickCount()) -> 56 twelve-byte challenge entries at A5-0x1cc4, RNG seeded
 * from TickCount. See docs/COPY_PROTECTION_FLOW.md.
 */

/*
Unable to decompile 'FUN_000008b8'
Cause: 
Low-level Error: Cannot properly adjust input varnodes
*/


/*
 * Original: FUN_000008d6; source: ID05.c:244-257.
 * Recovered name: pick_random_protection_challenge [STRONG INFERENCE] (iteration 125).
 * i = (ansi_rand() & 0xffff) % (unsigned word A5-0xb6); copies words +6/+8/+0xa
 * of 12-byte entry i of table *(A5-0xba) to *param_1..*param_3.
 * Caller [PROVEN]: run_protection_dialog file 0x5a6. The same entry words are
 * later checked by the 0x964 matcher.
 */
void pick_random_protection_challenge /* Original: FUN_000008d6 */ (undefined2 *param_1,undefined2 *param_2,undefined2 *param_3)

{
  uint uVar1;
  short sVar2;
  int unaff_A5;
  
  uVar1 = ansi_rand(); /* Original: FUN_00000728 */
  sVar2 = (short)((uVar1 & 0xffff) % (uint)*(ushort *)(unaff_A5 + -0xb6));
  *param_1 = *(undefined2 *)(*(int *)(unaff_A5 + -0xba) + sVar2 * 0xc + 6);
  *param_2 = *(undefined2 *)(*(int *)(unaff_A5 + -0xba) + sVar2 * 0xc + 8);
  *param_3 = *(undefined2 *)(*(int *)(unaff_A5 + -0xba) + sVar2 * 0xc + 10);
  return;
}



/*
 * Original: FUN_00000934; source: ID05.c:261-268.
 * Recovered name: record_code_index_equals [STRONG INFERENCE] (iteration 119).
 * Returns (word) 1 if (signed byte rec[4]) * 20 + (signed byte rec[5]) == n,
 * else 0; upper word of D0 carries the computed sum's high half (Ghidra
 * CONCAT22 matches bytes: EXTB.L / MULU.L #$14 / SEQ / NEG.B / EXT.W).
 * Inputs: param_1 = n (long), param_2 = rec pointer.
 * Callers [PROVEN, bytes]: ID08 file 0x282 and 0x2b2 via JT $54a (seg5 off
 * 0x930). At 0x282 a nonzero result is followed by JT $532 = file 0x8b2,
 * an unexported 2-instruction stub ADDQ.W #1,-$bc(A5); RTS, i.e. it sets
 * the restore_poisoned_overlay_bytes gate A5-0xbc.
 * [HYPOTHESIS] n/rec come from the protection/code-lookup step; the 20 factor
 * suggests a (row, column) pair on a 20-wide grid.
 *
 * Unexported routine at file 0x964..0xa60 (called by JSR $964(PC) at file
 * 0x69c) [PROVEN, bytes; not represented in the Ghidra C]:
 *   args: word a1 = 8(A6), word a2 = $a(A6), word a3 = $c(A6), char *s = $e(A6)
 *   A5-0xc0 = 0;
 *   for i in 0 .. word A5-0xb6 - 1: e = *(long A5-0xba) + 12*i
 *     (entry: long ptr +0, word len +4, words +6/+8/+0xa)
 *     compare from k = len-1 down: (s[k] + (A5-0x2c key[k] & 0x7f)) as byte
 *       == e.ptr[k]   [stored strings are obfuscated by subtracting the key]
 *     if all match && JT $522(s) (seg2 file 0x3e8, length-like) == len
 *        && a1 == e+6 && a2 == e+8 && a3 == e+0xa: A5-0xc0 += 1
 *   return word A5-0xbe
 * A5-0xc0 is the second restore gate. Semantics as a code-entry check is
 * [HYPOTHESIS]; table contents not yet located.
 */
undefined4 record_code_index_equals /* Original: FUN_00000934 */ (int param_1,int param_2)

{
  int iVar1;
  
  iVar1 = (int)*(char *)(param_2 + 5) + *(char *)(param_2 + 4) * 0x14;
  return CONCAT22((short)((uint)iVar1 >> 0x10),(short)(iVar1 == param_1));
}


/*
Unable to decompile 'FUN_00000964'
Cause: 
Low-level Error: Cannot properly adjust input varnodes
*/


/*
 * Original: FUN_00000a62; source: ID05.c:278-287.
 * Recovered name: random_28bit_value [STRONG INFERENCE] (iteration 121).
 * Returns ((ansi_rand() & 0xfff) << 16) | (ansi_rand() & 0xffff); since ansi_rand
 * yields 15 bits, the result has 27 significant bits (bit 15 always 0).
 * Caller [PROVEN, bytes]: ID05 file 0x442 (BSR).
 */
uint random_28bit_value /* Original: FUN_00000a62 */ (void)

{
  uint uVar1;
  uint uVar2;
  
  uVar1 = ansi_rand(); /* Original: FUN_00000728 */
  uVar2 = ansi_rand(); /* Original: FUN_00000728 */
  return (uVar1 & 0xfff) << 0x10 | uVar2 & 0xffff;
}



/*
 * Original: FUN_00000a90; source: ID05.c:291-306.
 * Recovered name: pack_fields_to_code_buf68 [STRONG INFERENCE] (iteration 121).
 * Packs five scaled word fields into a 28-bit value and encodes it as 6
 * letters into A5-0x68 (returned): bits 16..27 = param_1 high word; 12..15 =
 * param_1 low / 0x80; 8..11 = param_2 high / 0x80; 5..7 = param_2 low / 4;
 * 0..4 = min(param_3 high / 0x200, 0x20). Ghidra _0_2_/_2_2_ split each 4-byte
 * argument slot into words; actual prototype [UNKNOWN]. Masking/overlap of the
 * OR (e.g. 0x20 sets bit 5) preserved as exported.
 * Inverse (with rescaling): unpack_fields_from_code. Caller: ID05 file 0x498.
 */
int pack_fields_to_code_buf68 /* Original: FUN_00000a90 */ (undefined4 param_1,undefined4 param_2,undefined4 param_3)

{
  int unaff_A5;
  
  param_3._0_2_ = param_3._0_2_ / 0x200;
  if (0x20 < param_3._0_2_) {
    param_3._0_2_ = 0x20;
  }
  encode_base26_6chars( /* Original: FUN_00000754 */ (char *)(unaff_A5 + -0x68),
               ((int)param_3._0_2_ |
               (int)(short)(param_2._2_2_ / 4 << 5 |
                           param_2._0_2_ / 0x80 << 8 | param_1._2_2_ / 0x80 << 0xc) |
               (int)param_1._0_2_ << 0x10) & 0xfffffff);
  return unaff_A5 + -0x68;
}



/*
 * Original: FUN_00000b10; source: ID05.c:310-323.
 * Recovered name: unpack_fields_from_code [STRONG INFERENCE] (iteration 121).
 * Decodes a 6-letter code and splits it: *p2 = bits 16..31, *p3 = bits 12..15 << 7,
 * *p4 = bits 8..11 << 7, *p5 = bits 5..7 << 2, *p6 = bits 0..4. Mirrors
 * pack_fields_to_code_buf68 (last field not rescaled by 0x200). No caller found yet.
 */
void unpack_fields_from_code /* Original: FUN_00000b10 */ (int param_1,undefined2 *param_2,undefined2 *param_3,undefined2 *param_4,
                 undefined2 *param_5,ushort *param_6)

{
  int local_8;
  
  decode_base26_6chars( /* Original: FUN_000007a8 */ param_1,&local_8);
  *param_2 = (short)((uint)local_8 >> 0x10);
  *param_3 = (short)((local_8 >> 0xc & 0xfU) << 7);
  *param_4 = (short)((local_8 >> 8 & 0xfU) << 7);
  *param_5 = (short)((local_8 >> 5 & 7U) << 2);
  *param_6 = (ushort)local_8 & 0x1f;
  return;
}



/*
 * Original: FUN_00000b84; source: ID05.c:327-334.
 * Recovered name: encode_code28_to_buf54 [STRONG INFERENCE] (iteration 121).
 * encode_base26_6chars(A5-0x54, param_1 & 0x0fffffff); returns A5-0x54.
 * Callers [PROVEN, bytes]: ID05 file 0x4b2; ID08 file 0x276 and 0x2a6 via JT
 * $552. At ID08 0x276 the returned string is passed as `rec` to
 * record_code_index_equals(n, str): letters 5 and 6 (offsets 4, 5) are tested.
 */
int encode_code28_to_buf54 /* Original: FUN_00000b84 */ (uint param_1)

{
  int unaff_A5;
  
  encode_base26_6chars( /* Original: FUN_00000754 */ (char *)(unaff_A5 + -0x54),param_1 & 0xfffffff);
  return unaff_A5 + -0x54;
}



/*
 * Original: FUN_00000ba8; source: ID05.c:338-345.
 * Recovered name: decode_code_to_long_a [STRONG INFERENCE] (iteration 121).
 * Returns decode_base26_6chars(param_1). No caller found yet.
 */
int decode_code_to_long_a /* Original: FUN_00000ba8 */ (int param_1)

{
  int local_8;
  
  decode_base26_6chars( /* Original: FUN_000007a8 */ param_1,&local_8);
  return local_8;
}



/*
 * Original: FUN_00000bc2; source: ID05.c:349-356.
 * Recovered name: encode_long_to_buf40 [STRONG INFERENCE] (iteration 121).
 * encode_base26_6chars(A5-0x40, param_1) without masking; returns A5-0x40.
 * Caller [PROVEN, bytes]: ID05 file 0x4ce.
 */
int encode_long_to_buf40 /* Original: FUN_00000bc2 */ (int param_1)

{
  int unaff_A5;
  
  encode_base26_6chars( /* Original: FUN_00000754 */ (char *)(unaff_A5 + -0x40),param_1);
  return unaff_A5 + -0x40;
}



/*
 * Original: FUN_00000bde; source: ID05.c:360-367.
 * Recovered name: decode_code_to_long_b [STRONG INFERENCE] (iteration 121).
 * Returns decode_base26_6chars(param_1); byte-identical role to
 * decode_code_to_long_a (separate function kept). Caller [PROVEN, bytes]: ID05
 * file 0x674 (result stored through the caller's param at 8(A6)).
 */
int decode_code_to_long_b /* Original: FUN_00000bde */ (int param_1)

{
  int local_8;
  
  decode_base26_6chars( /* Original: FUN_000007a8 */ param_1,&local_8);
  return local_8;
}


