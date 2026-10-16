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

void FUN_00000048(undefined2 *param_1)

{
  undefined1 *puVar1;
  short sVar2;
  undefined2 *puVar3;
  char *pcVar4;
  undefined1 *puVar5;
  code *UNRECOVERED_JUMPTABLE;
  undefined2 uStack0000000a;
  
  sVar2 = 7;
  puVar3 = param_1;
  do {
    *puVar3 = 0;
    sVar2 = sVar2 + -1;
    puVar3 = puVar3 + 1;
  } while (sVar2 != -1);
  *param_1 = 1;
  param_1[1] = 0xfffe;
  if (DAT_216e0017 != -1) {
    if (DAT_216e0016 < '\x01') {
      param_1[1] = 0xffff;
      if ((-1 < (short)DAT_0000028e) && (param_1[1] = 1, (short)_DAT_00000b22 < 0)) {
        param_1[1] = 2;
      }
    }
    else {
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
  param_1[2] = 0;
  if ((-1 < (short)DAT_0000028e) && ((_DAT_00000b22 & 0x1000) != 0)) {
    *(undefined1 *)(param_1 + 4) = 1;
  }
  if (DAT_0000028e < 0x4000) {
    *(undefined1 *)((int)param_1 + 9) = 1;
  }
  pcVar4 = &DAT_00000059;
  sVar2 = 4;
  do {
    pcVar4 = pcVar4 + -1;
    if (DAT_0000021e == *pcVar4) break;
    sVar2 = sVar2 + -1;
  } while (sVar2 != -1);
  param_1[5] = sVar2 + 1;
  if ((-1 < DAT_00000291) && ((DAT_000001fb & 0xf) == 1)) {
    *(undefined1 *)((int)param_1 + 0xd) = *(undefined1 *)(DAT_000002dc + 7);
  }
  param_1[7] = DAT_00000210;
  if (-1 < _DAT_000003f6) {
    param_1[7] = 0;
    sVar2 = 0x3c;
    puVar1 = (undefined1 *)register0x0000003c;
    do {
      puVar5 = puVar1;
      *(undefined2 *)(puVar5 + -2) = 0;
      sVar2 = sVar2 + -1;
      puVar1 = puVar5 + -2;
    } while (sVar2 != -1);
    *(undefined2 *)(puVar5 + 0x16) = _DAT_00000a58;
                    // WARNING: Bad instruction - Truncating control flow here
    halt_baddata();
  }
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


