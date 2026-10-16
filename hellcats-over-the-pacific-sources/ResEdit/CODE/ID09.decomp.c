typedef unsigned char   undefined;

typedef unsigned char    byte;
typedef unsigned char    undefined1;
typedef unsigned short    undefined2;
typedef unsigned int    undefined4;


ushort DAT_0000028e;
undefined DAT_00000b22;
char DAT_0000021e;
char DAT_00000291;
byte DAT_000001fb;
int DAT_000002dc;
undefined2 DAT_00000210;
undefined DAT_000003f6;
undefined DAT_00000a58;
char DAT_216e0017;
char DAT_216e0016;
undefined DAT_00000059;

// WARNING: Control flow encountered bad instruction data
// WARNING: Removing unreachable block (ram,0x000000cc)
// WARNING: Globals starting with '_' overlap smaller symbols at the same address

/*
 * Original: FUN_00000048; source: ID09.c:26-103.
 * Recovered name: UNKNOWN (retain original identifier).
 * Status: INVESTIGATING; iterations 101-104; exported body annotated, binary discrepancies open.
 * Confidence: [PROVEN] exported-C control flow; [UNKNOWN] selector meanings.
 * Input: param_1 points to writable storage for at least eight undefined2 words
 * in the analyzed block (16 bytes under the original 16-bit word model).
 * Output: void; clears eight words, sets word 0 to 1, and classifies word 1.
 * Block dependencies: DAT_216e0017, DAT_216e0016, DAT_0000028e,
 * (short)_DAT_00000b22. No direct callee in this block; no direct caller found
 * in the ten original C exports. Runtime/indirect callers remain unknown.
 * Field-population block also reads DAT_0000021e, DAT_00000059,
 * DAT_00000291, DAT_000001fb, DAT_000002dc and DAT_00000210.
 * Later code reads _DAT_000003f6 and _DAT_00000a58; it writes additional
 * fields/stack storage and ends in unresolved control flow.
 * Unknown: record purpose, field names, global identities, plain-char signedness,
 * aliasing, overlapping-global widths, discarded block and terminal call/trap behavior.
 * Binary selector evidence: file 0x6c loads A0 from absolute address $02ae;
 * subsequent byte tests use +8/+9, not literal addresses DAT_216e0016/17.
 * Those labels match the longword at physical file 0x2ae plus 8/9, suggesting
 * erroneous constant propagation across file/runtime memory (STRONG INFERENCE).
 * Original expressions remain unchanged. See docs/ID09_SELECTOR_ANALYSIS.md
 * and docs/ID09_TERMINAL_ANALYSIS.md; whole-function semantics are unverified.
 */
void FUN_00000048(undefined2 *param_1)

{
  undefined1 *puVar1;
  short sVar2;
  undefined2 *puVar3;
  char *pcVar4;
  undefined1 *puVar5;
  code *UNRECOVERED_JUMPTABLE;
  undefined2 uStack0000000a;
  
  /* Eight stores: counter values 7..0, stopping only after decrement to -1. */
  sVar2 = 7;
  puVar3 = param_1;
  do {
    *puVar3 = 0;
    sVar2 = sVar2 + -1;
    puVar3 = puVar3 + 1;
  } while (sVar2 != -1);
  *param_1 = 1;
  /* Word 1 remains 0xfffe when the outer selector compares equal to -1.
   * Keep plain-char tests as exported: do not assume signed-char portability. */
  param_1[1] = 0xfffe;
  /* Binary file 0x76: CMPI.B #$ff,$9(A0), after MOVEA.L $02ae.w,A0.
   * File 0x7e tests signed byte +8. The labels below are retained artifacts;
   * do not interpret them as independently established runtime globals. */
  if (DAT_216e0017 != -1) {
    if (DAT_216e0016 < '\x01') {
      param_1[1] = 0xffff;
      /* The comma assignment is observable: a nonnegative signed word at
       * DAT_0000028e changes word 1 to 1 even when the second test is false;
       * a negative _DAT_00000b22 signed word then changes it again to 2. */
      if ((-1 < (short)DAT_0000028e) && (param_1[1] = 1, (short)_DAT_00000b22 < 0)) {
        param_1[1] = 2;
      }
    }
    else {
      /* For stable, non-aliasing selector reads: 1 -> 4, 2 -> 3, >= 3 -> 0.
       * These are raw result codes; hardware/runtime categories remain unknown. */
      param_1[1] = 0;
      if (DAT_216e0016 < '\x03') {
        if (DAT_216e0016 == '\x02') {
          param_1[1] = 3;
        }
        else {
          param_1[1] = 4;
        }
      }
    }
  }
  /* Preserve this second write even though the initial clear reached word 2. */
  param_1[2] = 0;
  /* Binary file 0xc4..0xd4 contains a path absent from this C export:
   * compare signed byte at $012f to 2; if <= 2, load it into D0.B, add 1
   * to D0.W, and store D0.B at output +7. Ghidra's unreachable-block warning
   * names 0xcc. This discrepancy is documented, not silently reconstructed. */
  /* Set output byte +8 only when the signed word test and bit 12 both pass.
   * This is a byte store into word 4, not a word assignment; preserve width. */
  if ((-1 < (short)DAT_0000028e) && ((_DAT_00000b22 & 0x1000) != 0)) {
    *(undefined1 *)(param_1 + 4) = 1;
  }
  /* Separate comparison of the unsigned word value sets byte +9. On the intended big-endian
   * layout, +8/+9 are the high/low bytes of word 4; do not merge these stores. */
  if (DAT_0000028e < 0x4000) {
    *(undefined1 *)((int)param_1 + 9) = 1;
  }
  /* Scan the five bytes preceding this symbol, starting at symbol - 1.
   * First match in reverse order wins: offsets -1..-5 yield codes 5..1.
   * No match yields 0. The scalar declaration is a Ghidra artifact: no C
   * array bounds or valid object provenance are established by this export. */
  pcVar4 = &DAT_00000059;
  sVar2 = 4;
  do {
    pcVar4 = pcVar4 + -1;
    if (DAT_0000021e == *pcVar4) break;
    sVar2 = sVar2 + -1;
  } while (sVar2 != -1);
  param_1[5] = sVar2 + 1;
  /* With the exported char comparison satisfied and low nibble == 1,
   * copy source byte +7 to output byte +0x0d. Pointer validity and the
   * meaning of this source record remain unknown; retain both gates. */
  if ((-1 < DAT_00000291) && ((DAT_000001fb & 0xf) == 1)) {
    *(undefined1 *)((int)param_1 + 0xd) = *(undefined1 *)(DAT_000002dc + 7);
  }
  /* Copy the word to output +0x0e; the following branch can overwrite it.
   * Failed byte-store gates above perform no write (initial clear normally
   * supplies zero). Keep reads/stores ordered: non-aliasing is not proven. */
  param_1[7] = DAT_00000210;
  /* Original ID09.c:84-96. A unique binary-pattern match independently locates
   * TST.W $3f6 / BLT and CLR.W $e(a1) at file offsets 0x134..0x13c.
   * Retain the inferred C type/test; the binary establishes a signed WORD test. */
  if (-1 < _DAT_000003f6) {
    param_1[7] = 0;
    /* 61 iterations (0x3c down through 0), not 60: 122 bytes cleared.
     * Binary file 0x13e..0x148: MOVE.W #$3c,D1; CLR.W -(A7); DBRA;
     * MOVEA.L A7,A0. register0x0000003c is a Ghidra register artifact,
     * not a proven memory address 0x3c. Preserve its exported expression. */
    sVar2 = 0x3c;
    puVar1 = (undefined1 *)register0x0000003c;
    do {
      puVar5 = puVar1;
      *(undefined2 *)(puVar5 + -2) = 0;
      sVar2 = sVar2 + -1;
      puVar1 = puVar5 + -2;
    } while (sVar2 != -1);
    /* At loop exit puVar5 = initial pointer - 120, puVar1 = initial - 122.
     * Thus this write is final pointer + 24, matching binary file 0x14a:
     * MOVE.W $a58.w,$18(A0). Pointer arithmetic is retained, not normalized. */
    *(undefined2 *)(puVar5 + 0x16) = _DAT_00000a58;
    /* Binary continues: MOVEQ #8, A-line word $A260, conditional branches,
     * another A-line word $A207 and $A260, then stack restoration. This
     * truncation is a decompiler artifact, not evidence of a runtime halt.
     * No replacement is made: trap contracts and complete ABI are unresolved. */
                    // WARNING: Bad instruction - Truncating control flow here
    halt_baddata();
  }
  /* Binary file 0x17a adds 0x7a to A7 after the allocated-stack path.
   * The negative-word branch bypasses that allocation/restoration to 0x17e.
   * File 0x17e..0x188 copies A1 to A0, pops A1, advances A7 by 6, writes
   * #$ea84 at (A7), then JMP (A1). Keep Ghidra's indirect-call form below;
   * neither a C callback nor a switch/jumptable is proven by those bytes. */
  uStack0000000a = 0xea84;
                    // WARNING: Could not recover jumptable at 0x00000188. Too many branches
                    // WARNING: Treating indirect jump as call
  (*UNRECOVERED_JUMPTABLE)();
  return;
}



// WARNING: Control flow encountered bad instruction data

void FUN_000002a6(void)

{
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



// WARNING: Control flow encountered bad instruction data

void FUN_000003c2(void)

{
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



/*
 * Original: FUN_00000432; source: ID09.c:129-143.
 * Recovered name: length_prefixed_bytes_to_c_string_in_place
 * Confidence: [STRONG INFERENCE] string convention; [PROVEN] C byte transform.
 * Input: writable buffer of at least buffer[0] + 1 bytes; first byte is count.
 * Output: original buffer pointer; count payload bytes shifted left one byte,
 * followed by a zero byte. Embedded zero bytes are copied, not skipped.
 * Side effects: writes only buffer[0..initial_count]; no global accesses.
 * Known callers: none found in the ten original C exports.
 * Known callees: none.
 * Evidence: ID09.c:132-141 zero-extends the byte count, copies forward from
 * cursor[1], then writes zero; :142 returns the original pointer.
 * Local mapping: param_1 -> buffer; uVar1 -> remaining_count;
 * pbVar2 -> write_cursor.
 * Unknown: actual callers, encoding and binary address mapping/ABI. No binary
 * verification claimed; retain Ghidra's ushort decrement and 0xffff sentinel.
 */
byte * length_prefixed_bytes_to_c_string_in_place(byte *buffer)

{
  ushort remaining_count;
  byte *write_cursor;
  
  remaining_count = (ushort)*buffer;
  write_cursor = buffer;
  /* Pre-decrement wraps a zero count to 0xffff: zero-length copies nothing. */
  while (remaining_count = remaining_count - 1, remaining_count != 0xffff) {
    /* Forward copy preserves the unread byte despite overlapping ranges. */
    *write_cursor = write_cursor[1];
    write_cursor = write_cursor + 1;
  }
  *write_cursor = 0;
  return buffer;
}


