typedef unsigned char   undefined;

typedef unsigned char    byte;
typedef unsigned int    uint;
typedef unsigned char    undefined1;
typedef unsigned short    undefined2;
typedef unsigned int    undefined4;
typedef unsigned long long    undefined8;
typedef unsigned short    ushort;


int DAT_00000904;
undefined4 DAT_00000904;
short DAT_00000baa;
int DAT_000039c4;
undefined DAT_66fa4e75;
undefined1 DAT_66fa4e77;
undefined DAT_66fa4e79;
int DAT_00003aca;
undefined DAT_66fa4e7b;
int DAT_00003be0;
char DAT_66fa4e77;
undefined FUN_00000196;
undefined2 DAT_00000baa;

int FUN_0000001e(int param_1)

{
  if (param_1 < 0) {
    param_1 = -param_1;
  }
  return param_1;
}



void FUN_00000038(undefined4 *param_1,undefined4 param_2)

{
  undefined4 local_8;
  
  local_8 = CONCAT22(param_2._0_2_ / param_2._2_2_,param_2._0_2_ % param_2._2_2_);
  *param_1 = local_8;
  return;
}



void FUN_00000066(undefined4 *param_1,undefined4 param_2,undefined4 param_3)

{
  undefined4 uVar1;
  undefined4 uVar2;
  int unaff_A5;
  
  uVar1 = (**(code **)(unaff_A5 + 0x5a))(param_2,param_3);
  uVar2 = (**(code **)(unaff_A5 + 0x62))(param_2,param_3);
  *param_1 = uVar1;
  param_1[1] = uVar2;
  return;
}



ushort FUN_0000009a(undefined4 param_1)

{
  int unaff_A5;
  
  return (short)*(char *)((int)(short)(ushort)param_1._1_1_ + unaff_A5 + -0x1608) & 0xd0;
}



ushort FUN_000000b6(undefined4 param_1)

{
  int unaff_A5;
  
  return (short)*(char *)((int)(short)(ushort)param_1._1_1_ + unaff_A5 + -0x1608) & 0xc0;
}



byte FUN_000000d2(undefined4 param_1)

{
  int unaff_A5;
  
  return *(byte *)((int)(short)(ushort)param_1._1_1_ + unaff_A5 + -0x1608) & 3;
}



byte FUN_000000ee(undefined4 param_1)

{
  int unaff_A5;
  
  return *(byte *)((int)(short)(ushort)param_1._1_1_ + unaff_A5 + -0x1608) & 0x10;
}



ushort FUN_0000010a(undefined4 param_1)

{
  int unaff_A5;
  
  return (short)*(char *)((int)(short)(ushort)param_1._1_1_ + unaff_A5 + -0x1608) & 0xd8;
}



ushort FUN_00000126(undefined4 param_1)

{
  int unaff_A5;
  
  return (short)*(char *)((int)(short)(ushort)param_1._1_1_ + unaff_A5 + -0x1608) & 0x80;
}



ushort FUN_00000142(undefined4 param_1)

{
  int unaff_A5;
  
  return (short)*(char *)((int)(short)(ushort)param_1._1_1_ + unaff_A5 + -0x1608) & 0xdc;
}



byte FUN_0000015e(undefined4 param_1)

{
  int unaff_A5;
  
  return *(byte *)((int)(short)(ushort)param_1._1_1_ + unaff_A5 + -0x1608) & 8;
}



byte FUN_0000017a(undefined4 param_1)

{
  int unaff_A5;
  
  return *(byte *)((int)(short)(ushort)param_1._1_1_ + unaff_A5 + -0x1608) & 6;
}



byte FUN_00000196(undefined4 param_1)

{
  int unaff_A5;
  
  return *(byte *)((int)(short)(ushort)param_1._1_1_ + unaff_A5 + -0x1608) & 0x40;
}



byte FUN_000001b2(undefined4 param_1)

{
  int unaff_A5;
  
  return *(byte *)((int)(short)(ushort)param_1._1_1_ + unaff_A5 + -0x1608) & 0x30;
}



ushort FUN_000001ce(undefined4 param_1)

{
  ushort uVar1;
  int unaff_A5;
  
  uVar1 = (ushort)param_1._1_1_;
  if (((short)*(char *)((int)(short)uVar1 + unaff_A5 + -0x1608) & 0x80U) != 0) {
    param_1._0_2_ = param_1._0_2_ ^ 0x20;
  }
  return param_1._0_2_;
}



ushort FUN_00000200(undefined4 param_1)

{
  ushort uVar1;
  int unaff_A5;
  
  uVar1 = (ushort)param_1._1_1_;
  if ((*(byte *)((int)(short)uVar1 + unaff_A5 + -0x1608) & 0x40) != 0) {
    param_1._0_2_ = param_1._0_2_ ^ 0x20;
  }
  return param_1._0_2_;
}



void FUN_00000232(undefined1 *param_1,undefined1 *param_2,int param_3)

{
  for (; param_3 != 0; param_3 = param_3 + -1) {
    *param_1 = *param_2;
    param_1 = param_1 + 1;
    param_2 = param_2 + 1;
  }
  return;
}



void FUN_0000024a(undefined1 *param_1,undefined1 *param_2,int param_3)

{
  undefined1 *puVar1;
  undefined1 *puVar2;
  
  if (param_3 != 0) {
    if (param_2 <= param_1) {
      puVar1 = param_1 + param_3;
      puVar2 = param_2 + param_3;
      do {
        puVar2 = puVar2 + -1;
        puVar1 = puVar1 + -1;
        *puVar1 = *puVar2;
        param_3 = param_3 + -1;
      } while (param_3 != 0);
      return;
    }
    do {
      *param_1 = *param_2;
      param_3 = param_3 + -1;
      param_1 = param_1 + 1;
      param_2 = param_2 + 1;
    } while (param_3 != 0);
  }
  return;
}


/*
Unable to decompile 'FUN_000002b0'
Cause: 
Low-level Error: Cannot properly adjust input varnodes
*/


char * FUN_000002c8(char *param_1,char *param_2)

{
  char cVar1;
  char *pcVar2;
  
  pcVar2 = param_1;
  do {
    cVar1 = *param_2;
    *pcVar2 = cVar1;
    pcVar2 = pcVar2 + 1;
    param_2 = param_2 + 1;
  } while (cVar1 != '\0');
  return param_1;
}



char * FUN_000002d8(char *param_1,char *param_2)

{
  char cVar1;
  char *pcVar2;
  char *pcVar3;
  
  pcVar2 = param_1;
  do {
    pcVar3 = pcVar2;
    pcVar2 = pcVar3 + 1;
  } while (*pcVar3 != '\0');
  do {
    cVar1 = *param_2;
    *pcVar3 = cVar1;
    pcVar3 = pcVar3 + 1;
    param_2 = param_2 + 1;
  } while (cVar1 != '\0');
  return param_1;
}



int FUN_000002ee(byte *param_1,byte *param_2)

{
  byte bVar1;
  int iVar2;
  
  iVar2 = 0;
  do {
    bVar1 = *param_1;
    if (bVar1 != *param_2) {
      if (bVar1 < *param_2) {
        iVar2 = -2;
      }
      return iVar2 + 1;
    }
    param_1 = param_1 + 1;
    param_2 = param_2 + 1;
  } while (bVar1 != 0);
  return 0;
}



char * FUN_0000030c(char *param_1,undefined4 param_2)

{
  char cVar1;
  
  do {
    if ((char)((uint)param_2 >> 0x10) == *param_1) {
      return param_1;
    }
    cVar1 = *param_1;
    param_1 = param_1 + 1;
  } while (cVar1 != '\0');
  return (char *)0x0;
}



int FUN_00000324(char *param_1,char *param_2)

{
  char cVar1;
  char cVar2;
  int iVar3;
  char *pcVar4;
  char *pcVar5;
  
  iVar3 = -1;
  do {
    iVar3 = iVar3 + 1;
    pcVar4 = param_1 + 1;
    cVar1 = *param_1;
    pcVar5 = param_2;
    if (cVar1 == '\0') {
      return iVar3;
    }
    while( true ) {
      cVar2 = *pcVar5;
      param_1 = pcVar4;
      if (cVar2 == '\0') break;
      pcVar5 = pcVar5 + 1;
      if (cVar2 == cVar1) {
        return iVar3;
      }
    }
  } while( true );
}



char * FUN_0000033e(char *param_1,char *param_2)

{
  char cVar1;
  char *pcVar2;
  char *pcVar3;
  
  do {
    pcVar2 = param_1;
    pcVar3 = param_2;
    if (*pcVar2 == '\0') {
      return (char *)0x0;
    }
    while( true ) {
      cVar1 = *pcVar3;
      param_1 = pcVar2 + 1;
      if (cVar1 == '\0') break;
      pcVar3 = pcVar3 + 1;
      if (cVar1 == *pcVar2) {
        return pcVar2;
      }
    }
  } while( true );
}



char * FUN_0000035a(char *param_1,undefined4 param_2)

{
  char cVar1;
  char *pcVar2;
  
  pcVar2 = (char *)0x0;
  do {
    if ((char)((uint)param_2 >> 0x10) == *param_1) {
      pcVar2 = param_1;
    }
    cVar1 = *param_1;
    param_1 = param_1 + 1;
  } while (cVar1 != '\0');
  return pcVar2;
}



int FUN_00000370(char *param_1,char *param_2)

{
  char cVar1;
  int iVar2;
  char *pcVar3;
  
  iVar2 = 0;
  do {
    pcVar3 = param_2;
    if (*param_1 == '\0') {
      return iVar2;
    }
    do {
      cVar1 = *pcVar3;
      if (cVar1 == '\0') {
        return iVar2;
      }
      pcVar3 = pcVar3 + 1;
    } while (cVar1 != *param_1);
    iVar2 = iVar2 + 1;
    param_1 = param_1 + 1;
  } while( true );
}



char * FUN_0000038c(char *param_1,char *param_2)

{
  char cVar1;
  char cVar2;
  char *pcVar3;
  char *pcVar4;
  
  pcVar4 = param_2;
  pcVar3 = param_1;
  while( true ) {
    cVar1 = *pcVar4;
    if (cVar1 == '\0') {
      return pcVar3;
    }
    cVar2 = *param_1;
    if (cVar2 == '\0') break;
    param_1 = param_1 + 1;
    pcVar4 = pcVar4 + 1;
    if (cVar2 != cVar1) {
      param_1 = pcVar3 + 1;
      pcVar4 = param_2;
      pcVar3 = param_1;
    }
  }
  return (char *)0x0;
}



char * FUN_000003aa(char *param_1,char *param_2)

{
  char cVar1;
  char *pcVar2;
  char *pcVar3;
  char *pcVar4;
  char *pcVar5;
  int unaff_A5;
  
  if (param_1 != (char *)0x0) goto LAB_000003b6;
  do {
    param_1 = *(char **)(unaff_A5 + -0x1508);
    if (param_1 == (char *)0x0) {
      return (char *)0x0;
    }
LAB_000003b6:
    *(undefined4 *)(unaff_A5 + -0x1508) = 0;
    while( true ) {
      pcVar3 = param_1;
      pcVar5 = param_2;
      if (*pcVar3 == '\0') break;
      do {
        cVar1 = *pcVar5;
        pcVar2 = pcVar3 + 1;
        if (cVar1 == '\0') {
          do {
            pcVar4 = pcVar2;
            pcVar5 = param_2;
            if (*pcVar4 == '\0') {
              return pcVar3;
            }
            while( true ) {
              cVar1 = *pcVar5;
              pcVar2 = pcVar4 + 1;
              if (cVar1 == '\0') break;
              pcVar5 = pcVar5 + 1;
              if (cVar1 == *pcVar4) {
                *(char **)(unaff_A5 + -0x1508) = pcVar4 + 1;
                *pcVar4 = '\0';
                return pcVar3;
              }
            }
          } while( true );
        }
        param_1 = pcVar3 + 1;
        pcVar5 = pcVar5 + 1;
      } while (cVar1 != *pcVar3);
    }
  } while( true );
}



void FUN_000003f6(char *param_1,char *param_2,int param_3)

{
  char cVar1;
  
  for (; param_3 != 0; param_3 = param_3 + -1) {
    cVar1 = *param_2;
    *param_1 = cVar1;
    if (cVar1 != '\0') {
      param_2 = param_2 + 1;
    }
    param_1 = param_1 + 1;
  }
  return;
}



void FUN_00000412(char *param_1,char *param_2,int param_3)

{
  char cVar1;
  char *pcVar2;
  char *pcVar3;
  
  if (param_3 != 0) {
    do {
      pcVar3 = param_1;
      param_1 = pcVar3 + 1;
    } while (*pcVar3 != '\0');
    do {
      cVar1 = *param_2;
      pcVar2 = pcVar3 + 1;
      *pcVar3 = cVar1;
      if (cVar1 == '\0') {
        return;
      }
      param_3 = param_3 + -1;
      pcVar3 = pcVar2;
      param_2 = param_2 + 1;
    } while (param_3 != 0);
    *pcVar2 = '\0';
  }
  return;
}



// WARNING: Control flow encountered bad instruction data

void FUN_0000045a(void)

{
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



undefined4 * FUN_000004c6(void)

{
  undefined4 *puVar1;
  int unaff_A5;
  undefined4 **ppuVar2;
  undefined4 *local_c;
  undefined4 local_8;
  
  local_8 = 0;
  local_c = (undefined4 *)0x0;
  (**(code **)(unaff_A5 + 0x212))();
  ppuVar2 = (undefined4 **)&local_8;
  puVar1 = local_c;
  if ((int)local_c < 500000) {
    local_c = (undefined4 *)0x0;
    puVar1 = &local_8;
    (**(code **)(unaff_A5 + 0x21a))();
    ppuVar2 = &local_c;
  }
  if (*(short *)(unaff_A5 + -0x12ee) != 0) {
    *(undefined4 *)((int)ppuVar2 + -4) = 0;
    *(undefined4 *)((int)ppuVar2 + -8) = 0x4f6;
    puVar1 = (undefined4 *)init_sound_system(*(int *)((int)ppuVar2 + -4));
  }
  return puVar1;
}



// WARNING: Control flow encountered bad instruction data

void FUN_000004fc(void)

{
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



void FUN_00000930(undefined4 param_1,undefined4 param_2)

{
  int unaff_A5;
  
  (**(code **)(unaff_A5 + -0x1082))();
  (**(code **)(unaff_A5 + -0x107e))();
  (**(code **)(unaff_A5 + -0x107a))(param_1,param_2);
  (**(code **)(unaff_A5 + -0x1076))();
  return;
}



// WARNING: Control flow encountered bad instruction data

void FUN_00000a42(undefined4 param_1)

{
  *(undefined4 *)(*(int *)(DAT_00000904 + -0x160c) + 0x50) = param_1;
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



// WARNING: Control flow encountered bad instruction data

void FUN_00000a86(void)

{
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



// WARNING: Control flow encountered bad instruction data

void FUN_00000ad0(void)

{
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



// WARNING: Control flow encountered bad instruction data

/*
 * Original: FUN_00000c68; source: ID02.c:674.
 * Recovered name: apply_pending_color_entries_a5safe [STRONG INFERENCE] (iteration 145).
 * Status: RENAMED; Ghidra truncated at $AA3F. Bytes file 0xc68..0xca4 [PROVEN]:
 * CurrentA5 thunk; ct = long A5-0x14b2 (colour table allocated by
 * initialize_application); SetEntries(-1, ct->ctSize (+6) - 1, &ct->ctTable
 * (+8)) $AA3F; ct->ctSize = 0. Default value of overlay service slot A5-0x1122
 * (JT $33a); build_palette_index_map swaps in clear_ctab_size_callback (which
 * only clears ctSize, discarding the entries) when palette indices collide.
 * [STRONG INFERENCE] The overlay accumulates RGB entries in the table and
 * calls the slot to apply them. Trap name per Inside Macintosh.
 */
void apply_pending_color_entries_a5safe /* Original: FUN_00000c68 */ (void)

{
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



// WARNING: Control flow encountered bad instruction data

void FUN_00000ca6(void)

{
  int unaff_A5;
  
  (**(code **)(unaff_A5 + 0x232))(0x6c,0);
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



// WARNING: Control flow encountered bad instruction data

/*
 * Original: FUN_00000d24; source: ID02.c:697-704.
 * Recovered name: close_and_dispose_port [STRONG INFERENCE] (iteration 133).
 * Status: RENAMED; Ghidra truncated at A-line $A87D. Bytes file 0xd24..0xd38
 * [PROVEN]: arg GrafPtr port [8(A6)]; ClosePort(port) $A87D;
 * JT $23a(port) = ID09 file 0x218 DisposPtr glue ($A01F). Ghidra lost the arg.
 * Callers: rebuild_all_palette_index_maps (port = long A5-0x103a, then cleared);
 * ID03 file 0x3828 via JT $392.
 * [STRONG INFERENCE] A5-0x103a is a pointer-allocated GrafPort; the following
 * routine FUN_00000d3a (re)creates it when A5-0x103a == 0 (offscreen bitmap
 * with rowBytes = ((width * depth + 15) >> 4) * 2) - to be confirmed next.
 */
void close_and_dispose_port /* Original: FUN_00000d24 */ (void)

{
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



// WARNING: Control flow encountered bad instruction data

/*
 * Original: FUN_00000d3a; source: ID02.c:708-741.
 * Recovered name: blit_offscreen_frame_to_window [STRONG INFERENCE] (iteration 134).
 * Status: RENAMED. Exported C kept; Ghidra truncated the tail at $A862.
 * Args: param_1 = pixel base address, param_2 = destination top, param_3 =
 * row count, param_4 = mode (long). A5 is reloaded from CurrentA5 ($0904)
 * (Ghidra: DAT_00000904), so it is callable from overlay/foreign context.
 * First call (A5-0x103a == 0): srcRect A5-0x14f2 = (0, 0, A5-0x1370, A5-0x1372)
 * [top, left, bottom, right], dstRect A5-0x14ea = srcRect; rowBytes =
 * ((A5-0x1372 * A5-0x137a + 15) >> 4) * 2 | 0x8000 (PixMap flag; bytes
 * 0xd6e..0xd7e, the 0x8000 OR is not shown by Ghidra); port =
 * FUN_00000ca6(rowBytes, base, bounds) -> A5-0x103a.
 * Each call: (**port->portPixMap).baseAddr = param_1; src.bottom = height;
 * dst.top = top; dst.bottom = top + height; dst.left/right = src.left/right;
 * mode 2 -> dst.left/right -= word A5-0x137e; mode 3 -> += A5-0x137e.
 * Tail [PROVEN bytes 0xe0a..0xe3c]: ForeColor(33 blackColor) $A862;
 * BackColor(30 whiteColor) $A863; CopyBits(&off->portBits (+2),
 * &thePort->portBits (+2), &src, &dst, 0 srcCopy, nil) $A8EC.
 * Callers / references [PROVEN bytes]: JT A5+0x322; ID06 file 0xf18 JSR;
 * ID02 file 0x1b6a LEA $322(A5) (address taken - likely handed to the
 * overlay as a callback [HYPOTHESIS]).
 */
void blit_offscreen_frame_to_window /* Original: FUN_00000d3a */ (undefined4 param_1,short param_2,short param_3,int param_4)

{
  int iVar1;
  undefined4 uVar2;
  
  iVar1 = DAT_00000904;
  if (*(int *)(DAT_00000904 + -0x103a) == 0) {
    *(undefined2 *)(DAT_00000904 + -0x14f0) = 0;
    *(undefined2 *)(iVar1 + -0x14f2) = 0;
    *(undefined2 *)(iVar1 + -0x14ec) = *(undefined2 *)(iVar1 + -0x1372);
    *(undefined2 *)(iVar1 + -0x14ee) = *(undefined2 *)(iVar1 + -0x1370);
    *(undefined4 *)(iVar1 + -0x14ea) = *(undefined4 *)(iVar1 + -0x14f2);
    *(undefined4 *)(iVar1 + -0x14e6) = *(undefined4 *)(iVar1 + -0x14ee);
    uVar2 = FUN_00000ca6();
    *(undefined4 *)(iVar1 + -0x103a) = uVar2;
  }
  *(undefined4 *)**(undefined4 **)(*(int *)(iVar1 + -0x103a) + 2) = param_1;
  *(short *)(iVar1 + -0x14ee) = param_3;
  *(short *)(iVar1 + -0x14ea) = param_2;
  *(short *)(iVar1 + -0x14e6) = param_3 + param_2;
  *(undefined2 *)(iVar1 + -0x14e8) = *(undefined2 *)(iVar1 + -0x14f0);
  *(undefined2 *)(iVar1 + -0x14e4) = *(undefined2 *)(iVar1 + -0x14ec);
  if (param_4 == 2) {
    *(short *)(iVar1 + -0x14e8) = *(short *)(iVar1 + -0x14e8) - *(short *)(iVar1 + -0x137e);
    *(short *)(iVar1 + -0x14e4) = *(short *)(iVar1 + -0x14e4) - *(short *)(iVar1 + -0x137e);
  }
  else if (param_4 == 3) {
    *(short *)(iVar1 + -0x14e8) = *(short *)(iVar1 + -0x137e) + *(short *)(iVar1 + -0x14e8);
    *(short *)(iVar1 + -0x14e4) = *(short *)(iVar1 + -0x137e) + *(short *)(iVar1 + -0x14e4);
  }
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



// WARNING: Control flow encountered bad instruction data

void FUN_00000e3e(int param_1,undefined4 param_2)

{
  *(undefined4 *)**(undefined4 **)(param_1 + 2) = param_2;
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



// WARNING: Control flow encountered bad instruction data

void FUN_00000e9e(void)

{
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



// WARNING: Control flow encountered bad instruction data

void FUN_00000f52(void)

{
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



// WARNING: Control flow encountered bad instruction data

void FUN_00000f74(void)

{
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



// WARNING: Control flow encountered bad instruction data

void FUN_00000fa0(undefined4 param_1,undefined2 param_2)

{
  undefined4 unaff_D2;
  
  FUN_000015cc(CONCAT22(param_2,(short)((uint)unaff_D2 >> 0x10)));
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



// WARNING: Control flow encountered bad instruction data

void FUN_00000fd2(void)

{
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



// WARNING: Control flow encountered bad instruction data

void FUN_000010ce(void)

{
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



// WARNING: Control flow encountered bad instruction data

void FUN_000011ec(void)

{
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



// WARNING: Control flow encountered bad instruction data

void FUN_00001308(void)

{
  int in_stack_00000014;
  
  if (in_stack_00000014 != 0) {
                    // WARNING: Bad instruction - Truncating control flow here
    halt_baddata();
  }
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



void FUN_000014e6(void)

{
  (**(code **)(DAT_00000904 + 0x2e2))(DAT_00000904 + -0x1000);
  return;
}



int FUN_0000150a(void)

{
  int iVar1;
  int unaff_A5;
  
  if (*(short *)(unaff_A5 + -0x137a) == 1) {
    iVar1 = (**(code **)(unaff_A5 + 0x1ca))();
  }
  else {
    iVar1 = unaff_A5 + -0x1624;
  }
  return iVar1;
}



// WARNING: Control flow encountered bad instruction data

void FUN_000015cc(undefined4 param_1)

{
  int unaff_A5;
  
  if (*(short *)(unaff_A5 + -0x137a) == 1) {
    *(short *)(unaff_A5 + -0x13ba) = param_1._0_2_;
    (**(code **)(unaff_A5 + 0x1ca))();
                    // WARNING: Bad instruction - Truncating control flow here
    halt_baddata();
  }
  *(int *)(*(int *)(unaff_A5 + -0x160c) + 0x50) = (int)param_1._0_2_;
  return;
}



void FUN_00001632(undefined4 param_1)

{
  int unaff_A5;
  
  if (*(short *)(unaff_A5 + -0x137a) == 1) {
    *(short *)(unaff_A5 + -0x13b8) = param_1._0_2_;
  }
  else {
    *(int *)(*(int *)(unaff_A5 + -0x160c) + 0x54) = (int)param_1._0_2_;
  }
  return;
}



int FUN_00001656(undefined4 param_1)

{
  int unaff_A5;
  
  return (*(int *)(unaff_A5 + -0x149e) * (int)param_1._0_2_) / 0x12c0 +
         (int)(*(short *)(unaff_A5 + -0x1372) / 2);
}



int FUN_00001680(undefined4 param_1)

{
  int unaff_A5;
  
  return (*(int *)(unaff_A5 + -0x149e) * (int)param_1._0_2_) / 0x12c0 +
         (int)(*(short *)(unaff_A5 + -0x1370) / 2);
}



// WARNING: Control flow encountered bad instruction data

void FUN_000016aa(void)

{
  int iVar1;
  int unaff_A5;
  undefined2 in_stack_fffffffa;
  
  if (*(short *)(unaff_A5 + -0x137a) == 1) {
    iVar1 = FUN_00001656(CONCAT22(0xf380,in_stack_fffffffa));
    FUN_00001680(CONCAT22(0x960,(short)iVar1));
                    // WARNING: Bad instruction - Truncating control flow here
    halt_baddata();
  }
  iVar1 = FUN_00001656(CONCAT22(0xf380,in_stack_fffffffa));
  FUN_00001680(CONCAT22(0x960,(short)iVar1));
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



// WARNING: Control flow encountered bad instruction data

/*
 * Original: FUN_00001876; source: ID02.c:964.
 * Recovered name: blit_image_clipped_to_region [STRONG INFERENCE] (iteration 145).
 * Status: RENAMED; Ghidra truncated at $A89B. Bytes 0x1876..0x195a [PROVEN]:
 *   PenSize(1,1); r = NewRgn(); OpenRgn(); FUN_000016aa() (draws the clip
 *   shape); CloseRgn(r); saved = NewRgn(); GetClip(saved); SetClip(r);
 *   if (!(HGetState(h = long A5-0x12b0) & 0x80)) { HLock(h); locked = 1 }
 *     (JT $2d2 = ID09 0x3b0 $A069; JT $272 HLock);
 *   ForeColor(black) / BackColor(white);
 *   (**port->portPixMap).baseAddr = *h, .rowBytes = record[A5-0x13ae].+0xa
 *     (port = long A5-0x1496; records 0x160 bytes at *(long A5-0x13b2));
 *   CopyBits(&port->portBits, &thePort->portBits, &port->portRect,
 *            &port->portRect, srcCopy, nil) $A8EC;
 *   if (locked) HUnlock(h); SetClip(saved); DisposeRgn(saved); DisposeRgn(r).
 * [HYPOTHESIS] Draws a stored picture (e.g. cockpit panel) through a shaped
 * clip; image/record meanings UNKNOWN. Caller: blit_image_clipped_to_region_a5safe.
 */
void blit_image_clipped_to_region /* Original: FUN_00001876 */ (void)

{
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



/*
 * Original: FUN_0000195c; source: ID02.c:973.
 * Recovered name: blit_image_clipped_to_region_a5safe [STRONG INFERENCE] (iteration 145).
 * CurrentA5 thunk (bytes 0x195c..0x197a) calling blit_image_clipped_to_region.
 * Overlay service slot A5-0x111a (JT $3aa).
 */
void blit_image_clipped_to_region_a5safe /* Original: FUN_0000195c */ (void)

{
  blit_image_clipped_to_region(); /* Original: FUN_00001876 */
  return;
}



// WARNING: Control flow encountered bad instruction data

/*
 * Original: FUN_0000197c; source: ID02.c:984.
 * Recovered name: run_segment3_entry_and_unload_a5safe [STRONG INFERENCE] (iteration 145).
 * Bytes 0x197c..0x19a0 [PROVEN]: CurrentA5 thunk; JSR $17a(A5) (segment 3 file
 * 0x5cc4, routine UNKNOWN); UnloadSeg(JT $18a = segment 3 entry) $A9F1.
 * Overlay service slot A5-0x111e (JT $372).
 */
void run_segment3_entry_and_unload_a5safe /* Original: FUN_0000197c */ (void)

{
  (**(code **)(DAT_00000904 + 0x17a))();
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



/*
 * Original: FUN_000019a2; source: ID02.c:994-1008.
 * Recovered name: new_handle_clear_or_die_a5safe [STRONG INFERENCE] (iteration 137).
 * Bytes file 0x19a2..0x19e0 [PROVEN]: CurrentA5 thunk; h = NewHandleClear(size
 * long [8(A6)]) via JT $252 (ID09 0x242, $A322); if (MemError() (JT $29a,
 * word $0220) != 0) fatal_memory_error_exit(); returns h (long in D0).
 * Ghidra errors: return type/value (it returns param_1, bytes return h) and the
 * MemError result (sVar2 always 0). Expressions kept. Service slot A5-0x10c2.
 */
undefined2 new_handle_clear_or_die_a5safe /* Original: FUN_000019a2 */ (undefined2 param_1)

{
  int iVar1;
  short sVar2;
  
  iVar1 = DAT_00000904;
  (**(code **)(DAT_00000904 + 0x252))(param_1,0);
  sVar2 = 0;
  (**(code **)(iVar1 + 0x29a))();
  if (sVar2 != 0) {
    fatal_memory_error_exit(); /* Original: FUN_000019e2 */
  }
  return param_1;
}



// WARNING: Control flow encountered bad instruction data

/*
 * Original: FUN_000019e2; source: ID02.c:1014-1031.
 * Recovered name: fatal_memory_error_exit [STRONG INFERENCE] (iteration 137).
 * Bytes file 0x19e2..0x1a02 [PROVEN] (no LINK; uses the caller's A5, which
 * every caller has already set from CurrentA5):
 *   if (A5-0x1006 overlay image) DisposPtr(A5-0x1006) (JT $23a, ID09 0x218);
 *   shutdown_sound();  show_caution_alert_with_number(str129 slot 93 = long A5-0xdd2, 0);
 *   ExitToShell ($A9F4).
 * A5-0xdd2 = A5-0xf46 + 93*4, i.e. string 93 of STR# 129 loaded by ID07
 * load_str129_string_table [PROVEN arithmetic]; presumably the out-of-memory
 * message shown by FUN_00001d48 [HYPOTHESIS]. Ghidra's register0x0000003c
 * stack modelling is an artifact (kept verbatim).
 * Callers: new_handle_clear_or_die_a5safe, realloc_and_clear_handle_a5safe.
 */
void fatal_memory_error_exit /* Original: FUN_000019e2 */ (void)

{
  int unaff_A5;
  undefined4 local_4;
  
  if (*(int *)(unaff_A5 + -0x1006) != 0) {
    local_4 = *(undefined4 *)(unaff_A5 + -0x1006);
    register0x0000003c = (BADSPACEBASE *)&local_4;
    (**(code **)(unaff_A5 + 0x23a))();
  }
  *(undefined4 *)((int)register0x0000003c + -4) = 0x19f4;
  shutdown_sound(); /* Original: FUN_00004318 */
  *(undefined2 *)((int)register0x0000003c + -2) = 0;
  *(undefined4 *)((int)register0x0000003c + -6) = *(undefined4 *)(unaff_A5 + -0xdd2);
  *(undefined4 *)((int)register0x0000003c + -10) = 0x19fe;
  show_caution_alert_with_number(*(int *)((int)register0x0000003c + -6),*(undefined4 *)((int)register0x0000003c + -2))
  ;
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



/*
 * Original: FUN_00001a04; source: ID02.c:1038-1043.
 * Recovered name: dispose_handle_a5safe [STRONG INFERENCE] (iteration 136).
 * CurrentA5 thunk: saves A5/D2, A5 = ($0904), JSR $25a(A5) = ID09 file 0x24e
 * ($A023 DisposHandle glue) with the handle argument, restores A5/D2. Ghidra shows the
 * call through DAT_00000904 + JT offset. Overlay service slot A5-0x10be.
 */
void dispose_handle_a5safe /* Original: FUN_00001a04 */ (undefined4 param_1)

{
  (**(code **)(DAT_00000904 + 0x25a))(param_1);
  return;
}



/*
 * Original: FUN_00001a28; source: ID02.c:1047-1066.
 * Recovered name: realloc_and_clear_handle_a5safe [STRONG INFERENCE] (iteration 136).
 * Bytes file 0x1a28..0x1a82 [PROVEN]; CurrentA5 thunk. Args: Handle h [8],
 * long size [$c].
 *   ReallocHandle(h, size) (JT $26a = ID09 0x264, $A027);
 *   if (MemError() (JT $29a = ID09 0x29e: word $0220 MemErr) != 0)
 *       fatal_memory_error_exit() (FUN_000019e2);
 *   HLock(h) (JT $272); FUN_000002b0(*h, 0, size) (BSR 0x2b0; Ghidra could not
 *   decompile it - memset-like [HYPOTHESIS]); HUnlock(h) (JT $27a).
 * Ghidra error: it did not model the MemError result, so sVar3 is always 0 and
 * the FUN_000019e2 branch looks dead in the exported C. Expression kept.
 * Overlay service slot A5-0x10ba (JT $40a).
 */
void realloc_and_clear_handle_a5safe /* Original: FUN_00001a28 */ (undefined4 *param_1,undefined4 param_2)

{
  int iVar1;
  short sVar3;
  undefined4 *puVar2;
  
  iVar1 = DAT_00000904;
  (**(code **)(DAT_00000904 + 0x26a))(param_2,param_1);
  sVar3 = 0;
  (**(code **)(iVar1 + 0x29a))();
  if (sVar3 != 0) {
    fatal_memory_error_exit(); /* Original: FUN_000019e2 */
  }
  puVar2 = param_1;
  (**(code **)(iVar1 + 0x272))((short)param_1);
  FUN_000002b0((short)*param_1,(short)((uint)param_2 >> 0x10),(short)((uint)puVar2 >> 0x10));
  (**(code **)(iVar1 + 0x27a))((short)param_1);
  return;
}



/*
 * Original: FUN_00001a84; source: ID02.c:1070-1075.
 * Recovered name: hlock_a5safe [STRONG INFERENCE] (iteration 136).
 * CurrentA5 thunk: saves A5/D2, A5 = ($0904), JSR $272(A5) = ID09 file 0x270
 * ($A029 HLock glue) with the handle argument, restores A5/D2. Ghidra shows the
 * call through DAT_00000904 + JT offset. Overlay service slot A5-0x10b6.
 */
void hlock_a5safe /* Original: FUN_00001a84 */ (undefined4 param_1)

{
  (**(code **)(DAT_00000904 + 0x272))(param_1);
  return;
}



/*
 * Original: FUN_00001aa8; source: ID02.c:1079-1084.
 * Recovered name: hunlock_a5safe [STRONG INFERENCE] (iteration 136).
 * CurrentA5 thunk: saves A5/D2, A5 = ($0904), JSR $27a(A5) = ID09 file 0x27a
 * ($A02A HUnlock glue) with the handle argument, restores A5/D2. Ghidra shows the
 * call through DAT_00000904 + JT offset. Overlay service slot A5-0x10b2.
 */
void hunlock_a5safe /* Original: FUN_00001aa8 */ (undefined4 param_1)

{
  (**(code **)(DAT_00000904 + 0x27a))(param_1);
  return;
}



/*
 * Original: FUN_00001acc; source: ID02.c:1088-1093.
 * Recovered name: hpurge_a5safe [STRONG INFERENCE] (iteration 136).
 * CurrentA5 thunk: saves A5/D2, A5 = ($0904), JSR $282(A5) = ID09 file 0x284
 * ($A049 HPurge glue) with the handle argument, restores A5/D2. Ghidra shows the
 * call through DAT_00000904 + JT offset. Overlay service slot A5-0x10ae.
 */
void hpurge_a5safe /* Original: FUN_00001acc */ (undefined4 param_1)

{
  (**(code **)(DAT_00000904 + 0x282))(param_1);
  return;
}



/*
 * Original: FUN_00001af0; source: ID02.c:1097-1102.
 * Recovered name: hnopurge_a5safe [STRONG INFERENCE] (iteration 136).
 * CurrentA5 thunk: saves A5/D2, A5 = ($0904), JSR $28a(A5) = ID09 file 0x28e
 * ($A04A HNoPurge glue) with the handle argument, restores A5/D2. Ghidra shows the
 * call through DAT_00000904 + JT offset. Overlay service slot A5-0x10aa.
 */
void hnopurge_a5safe /* Original: FUN_00001af0 */ (undefined4 param_1)

{
  (**(code **)(DAT_00000904 + 0x28a))(param_1);
  return;
}



/*
 * Original: FUN_00001b14; source: ID02.c:1106-1111.
 * Recovered name: freemem_a5safe [STRONG INFERENCE] (iteration 135).
 * Bytes file 0x1b14..0x1b3e [PROVEN]: saves A5/D2, A5 = CurrentA5 ($0904),
 * result = JT $212() = ID09 file 0x1b2 FreeMem glue ($A01C), restores, returns
 * the FreeMem long in D0. Ghidra's "return 0" is a decompiler error (it lost
 * the D0 value); expression kept unchanged, as required. Exported to the
 * overlay as service-table slot A5-0x10a6 (JT $38a), see below.
 *
 * Unexported routine at file 0x1b42..0x1c88 (main's BSR 0x1b42):
 * proposed name install_overlay_service_table [STRONG INFERENCE].
 * Stores JT entry addresses (LEA d16(A5)) into an A5 table, then allocates
 * the large overlay work buffer:
 *   A5-0x1122..-0x10a6 (32 slots, step 4; -0x10e6/-0x10e2 not written) and
 *   A5-0x1310..-0x1304 (4 slots -> segment 6 routines);
 *   full slot list with targets in docs/OVERLAY_SERVICE_TABLE.md.
 *   if (FreeMem() > 0x100000) A5-0x1040 = NewPtrClear(0x4e390 = 320400)
 *   else                      A5-0x1040 = NewPtrClear(0x35cf0 = 220400)
 *   (JT $232 = ID09 0x20c NewPtrClear glue). No NULL check.
 * The callback slots A5-0x1092 / -0x104e / -0x1096 / -0x109e / -0x10a2 used by
 * ID02 lie outside this table: they are presumably filled by the overlay
 * itself (overlay -> app direction) [STRONG INFERENCE].
 */
undefined4 freemem_a5safe /* Original: FUN_00001b14 */ (void)

{
  (**(code **)(DAT_00000904 + 0x212))();
  return 0;
}



/*
 * Original: FUN_00001c8a; source: ID02.c:1115-1150.
 * Recovered name: format_int_decimal_pstring [STRONG INFERENCE] (iteration 138).
 * Exported C [complete]: writes |n| in decimal backwards from buf+10, prefixes
 * '-' for negative n, stores the length byte, returns the Pascal string start.
 * INT_MIN negation overflow preserved as exported. Caller:
 * show_caution_alert_with_number.
 */
char * format_int_decimal_pstring /* Original: FUN_00001c8a */ (int param_1,char *param_2)

{
  char *pcVar1;
  bool bVar2;
  char *local_e;
  char *local_a;
  
  bVar2 = param_1 < 0;
  if (bVar2) {
    param_1 = -param_1;
  }
  pcVar1 = param_2 + 10;
  do {
    local_a = pcVar1;
    pcVar1 = local_a + -1;
    *pcVar1 = (char)(param_1 % 10) + '0';
    param_1 = param_1 / 10;
  } while (param_1 != 0);
  if (bVar2) {
    local_a[-2] = '-';
    pcVar1 = local_a + -2;
  }
  local_a = pcVar1;
  param_1._3_1_ = (char)((int)param_2 - (int)local_a) + '\n';
  local_a[-1] = (char)param_1;
  local_e = param_2;
  param_1 = ((int)param_2 - (int)local_a) + 0xb;
  local_a = local_a + -1;
  while (param_1 != 0) {
    *local_e = *local_a;
    param_1 = param_1 + -1;
    local_e = local_e + 1;
    local_a = local_a + 1;
  }
  return param_2;
}



// WARNING: Control flow encountered bad instruction data

/*
 * Original: FUN_00001d48; source: ID02.c:1157-1174.
 * Recovered name: show_caution_alert_with_number [STRONG INFERENCE] (iteration 138).
 * Bytes file 0x1d48..0x1dd2 [PROVEN]; JT $4ba (used by ID08 error paths).
 * Args: char *msg [8(A6)] (C string, may be 0), word num [$c(A6)].
 *   c2pstr(msg) (JT $302, ID09 0x416);
 *   if (num == 0) ParamText(msg, A5-0xd0a, A5-0xd0c, A5-0xd0e) $A98B
 *   else { s = format_int_decimal_pstring(num, buf);
 *          if (msg) ParamText(msg, s, A5-0xd06, A5-0xd08)
 *          else     ParamText(msg, s, A5-0xd02, A5-0xd04) }
 *     (the A5 words appear to be empty Pascal strings [HYPOTHESIS]);
 *   FUN_0000442e(0x102) [likely centres ALRT 258, cf. ID05 0x06];
 *   CautionAlert(258, nil) $A988; p2cstr(msg) (JT $2fa).
 * Callers: fatal_memory_error_exit (STR# 129[93], 0); ID02.c:1542; ID08 via JT $4ba.
 */
void show_caution_alert_with_number /* Original: FUN_00001d48 */ (int param_1,undefined4 param_2)

{
  int unaff_A5;
  char acStack_e [10];
  
  (**(code **)(unaff_A5 + 0x302))(param_1);
  if (param_2._0_2_ == 0) {
                    // WARNING: Bad instruction - Truncating control flow here
    halt_baddata();
  }
  format_int_decimal_pstring((int)param_2._0_2_,acStack_e);
  if (param_1 != 0) {
                    // WARNING: Bad instruction - Truncating control flow here
    halt_baddata();
  }
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



// WARNING: Control flow encountered bad instruction data

void FUN_00001dd4(void)

{
  int unaff_A5;
  
  if (*(short *)(unaff_A5 + -0xd12) == 0) {
                    // WARNING: Bad instruction - Truncating control flow here
    halt_baddata();
  }
  return;
}



// WARNING: Control flow encountered bad instruction data

void FUN_00001e32(void)

{
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



void FUN_00001e68(void)

{
  int unaff_A5;
  undefined1 *puVar1;
  int *piVar2;
  int local_a;
  short local_6;
  
  piVar2 = &local_a;
  for (local_6 = 0; local_6 < 0x14; local_6 = local_6 + 1) {
    puVar1 = (undefined1 *)piVar2;
    if (*(int *)(local_6 * 4 + unaff_A5 + -0xd62) != 0) {
      *(undefined4 *)((int)piVar2 + -4) = 0;
      *(int *)((int)piVar2 + -8) = *(int *)(local_6 * 4 + unaff_A5 + -0xd62) + -0x14;
      *(undefined4 *)((int)piVar2 + -0xc) = 0x1ea0;
      (**(code **)(unaff_A5 + 0x262))();
      puVar1 = (undefined1 *)((int)piVar2 + -4);
      local_a = *(int *)((int)piVar2 + -8);
      if (local_a != 0) {
        *(int *)((int)piVar2 + -8) = local_a;
        *(undefined4 *)((int)piVar2 + -0xc) = 0x1eb4;
        (**(code **)(unaff_A5 + 0x282))();
        puVar1 = (undefined1 *)((int)piVar2 + -0xc);
        *(int *)((int)piVar2 + -0xc) = local_a;
        *(undefined4 *)((int)piVar2 + -0x10) = 0x1ebc;
        (**(code **)(unaff_A5 + 0x27a))();
      }
      *(undefined4 *)(local_6 * 4 + unaff_A5 + -0xd62) = 0;
    }
    piVar2 = (int *)puVar1;
  }
  return;
}



// WARNING: Control flow encountered bad instruction data

void FUN_00001edc(void)

{
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



void FUN_00001f8e(void)

{
  ushort uVar1;
  short sVar2;
  int unaff_A5;
  undefined4 local_a;
  ushort local_6;
  
  local_a = 0;
  *(int *)(unaff_A5 + -0x112a) = unaff_A5 + -0xd62;
  FUN_00001e68();
  local_6 = 0;
  (**(code **)(unaff_A5 + 0x21a))((short)&local_a,0);
  uVar1 = 0;
  (**(code **)(unaff_A5 + 0x212))();
  if (uVar1 < 0x2e401) {
    uVar1 = FUN_00001edc();
    local_6 = uVar1 | local_6;
  }
  else {
    uVar1 = FUN_00001edc();
    local_6 = uVar1 | local_6;
  }
  uVar1 = FUN_00001edc();
  local_6 = uVar1 | local_6;
  uVar1 = FUN_00001edc();
  local_6 = uVar1 | local_6;
  uVar1 = FUN_00001edc();
  local_6 = uVar1 | local_6;
  uVar1 = FUN_00001edc();
  local_6 = uVar1 | local_6;
  uVar1 = FUN_00001edc();
  local_6 = uVar1 | local_6;
  uVar1 = FUN_00001edc();
  local_6 = uVar1 | local_6;
  uVar1 = FUN_00001edc();
  local_6 = uVar1 | local_6;
  uVar1 = FUN_00001edc();
  local_6 = uVar1 | local_6;
  uVar1 = FUN_00001edc();
  local_6 = uVar1 | local_6;
  sVar2 = FUN_00001edc();
  if (sVar2 != 0) {
    local_6 = local_6 | 1;
    uVar1 = FUN_00001edc();
    local_6 = uVar1 | local_6;
  }
  if (local_6 != 0) {
    FUN_00001dd4();
  }
  return;
}



void FUN_000020be(void)

{
  int unaff_A5;
  undefined1 *puVar1;
  int **ppiVar2;
  int *apiStack_12 [3];
  short local_6;
  
  ppiVar2 = apiStack_12 + 2;
  for (local_6 = 0; local_6 < 0x14; local_6 = local_6 + 1) {
    puVar1 = (undefined1 *)ppiVar2;
    if (*(int *)(local_6 * 4 + unaff_A5 + -0xd62) != 0) {
      puVar1 = (undefined1 *)((int)ppiVar2 + -4);
      *(undefined4 *)((int)ppiVar2 + -4) = *(undefined4 *)(local_6 * 4 + unaff_A5 + -0xd62);
      *(undefined4 *)((int)ppiVar2 + -8) = 0x20ee;
      (**(code **)(unaff_A5 + 0x272))();
      apiStack_12[2] = *(int **)(local_6 * 4 + unaff_A5 + -0xd62);
      *(int *)(local_6 * 4 + unaff_A5 + -0xd62) = *apiStack_12[2] + 0x14;
    }
    ppiVar2 = (int **)puVar1;
  }
  return;
}



// WARNING: Control flow encountered bad instruction data

void FUN_0000212a(void)

{
  int unaff_A5;
  undefined2 uVar1;
  
  FUN_000002b0((short)*(undefined4 *)(unaff_A5 + -0x101e) +
               (short)*(undefined4 *)(unaff_A5 + -0x1022) +
               (short)*(undefined4 *)(unaff_A5 + -0x1006));
  uVar1 = (undefined2)((uint)*(undefined4 *)(unaff_A5 + -0x1040) >> 0x10);
  (**(code **)(unaff_A5 + 0x242))((short)*(undefined4 *)(unaff_A5 + -0x1040),0);
  FUN_000002b0((short)*(undefined4 *)(unaff_A5 + -0x1040),uVar1);
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



// WARNING: Control flow encountered bad instruction data

void FUN_00002192(void)

{
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



// WARNING: Control flow encountered bad instruction data

void FUN_00002334(void)

{
  int unaff_A5;
  
  (**(code **)(unaff_A5 + 0x3a))();
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



// WARNING: Control flow encountered bad instruction data

void FUN_000027e4(void)

{
  int iVar1;
  undefined4 uVar2;
  undefined4 uVar3;
  int *piVar4;
  short sVar5;
  undefined2 uVar6;
  undefined4 unaff_A2;
  int unaff_A5;
  undefined1 uVar7;
  ushort uVar8;
  undefined2 local_10;
  undefined2 uStack_e;
  undefined2 local_c;
  undefined2 uStack_a;
  undefined2 local_6;
  
  uVar8 = (ushort)((uint)unaff_A2 >> 0x10);
  FUN_00002192();
  sVar5 = *(short *)(**(int **)(**(int **)(unaff_A5 + -0x1036) + 0x16) + 0x20);
  if (((sVar5 != 1) && (sVar5 != 4)) && (sVar5 != 8)) {
    if ((*(int *)(unaff_A5 + -0x14ca) != 0) &&
       (*(char *)(*(int *)(unaff_A5 + -0x14ca) + 0x6e) != '\0')) {
      *(undefined2 *)(unaff_A5 + -0xd10) = 1;
                    // WARNING: Bad instruction - Truncating control flow here
      halt_baddata();
    }
    show_caution_alert_with_number(*(int *)(unaff_A5 + -0xd76),(uint)uVar8);
    FUN_00002192();
    *(short *)(unaff_A5 + -0x137a) = sVar5;
    sVar5 = *(short *)(**(int **)(**(int **)(unaff_A5 + -0x1036) + 0x16) + 0x20);
    if ((sVar5 != 1) && ((sVar5 != 4 && (sVar5 != 8)))) {
      *(undefined2 *)(unaff_A5 + -0x102e) = 0;
      goto LAB_000028a2;
    }
  }
  if ((*(short *)(unaff_A5 + -0xd10) != 0) &&
     ((*(int *)(unaff_A5 + -0x14ca) != 0 && (*(short *)(unaff_A5 + -0x12f8) != 0)))) {
                    // WARNING: Bad instruction - Truncating control flow here
    halt_baddata();
  }
  *(undefined2 *)(unaff_A5 + -0xd10) = 0;
  *(undefined2 *)(unaff_A5 + -0x102e) = 1;
LAB_000028a2:
  if (*(short *)(unaff_A5 + -0x102e) != 0) {
    *(undefined2 *)(unaff_A5 + -0x13ae) = 0xffff;
    *(undefined4 *)(unaff_A5 + -0x1386) =
         *(undefined4 *)**(undefined4 **)(**(int **)(unaff_A5 + -0x1036) + 0x16);
    *(undefined2 *)(unaff_A5 + -0x137a) =
         *(undefined2 *)(**(int **)(**(int **)(unaff_A5 + -0x1036) + 0x16) + 0x20);
    iVar1 = **(int **)(**(int **)(unaff_A5 + -0x1036) + 0x16);
    uVar2 = *(undefined4 *)(iVar1 + 6);
    uVar3 = *(undefined4 *)(iVar1 + 10);
    local_c = (short)((uint)uVar3 >> 0x10);
    local_10 = (short)((uint)uVar2 >> 0x10);
    *(short *)(unaff_A5 + -0x137c) = local_c - local_10;
    uStack_a = (short)uVar3;
    uStack_e = (short)uVar2;
    *(short *)(unaff_A5 + -0x137e) = uStack_a - uStack_e;
    *(ushort *)(unaff_A5 + -0x1378) =
         *(ushort *)(**(int **)(**(int **)(unaff_A5 + -0x1036) + 0x16) + 4) & 0x1fff;
    *(undefined2 *)(unaff_A5 + -0x12d4) = *(undefined2 *)(**(int **)(unaff_A5 + -0x13ac) + 0x1c);
  }
  uVar7 = 0;
  (**(code **)(unaff_A5 + 0x2da))();
  *(undefined1 *)(unaff_A5 + -0x1000) = uVar7;
  if ((*(char *)(unaff_A5 + -0x1000) == '\0') &&
     ((*(byte *)(**(int **)(unaff_A5 + -0x1036) + 0x14) & 1) != 0)) {
    uVar6 = 1;
  }
  else {
    uVar6 = 0;
  }
  *(undefined2 *)(unaff_A5 + -0x1312) = uVar6;
  *(undefined1 *)(unaff_A5 + -0x1000) = 1;
  sVar5 = DAT_00000baa;
  for (local_6 = 1; local_6 < 4; local_6 = local_6 + 1) {
    if (*(int *)(local_6 * 0x16 + unaff_A5 + -0x136e) != 0) {
      piVar4 = (int *)(local_6 * 0x16 + unaff_A5 + -0x1364);
      *piVar4 = (int)*(short *)(local_6 * 0x16 + unaff_A5 + -0x1360) * (int)sVar5 + *piVar4;
    }
  }
  *(short *)(unaff_A5 + -0x137c) = *(short *)(unaff_A5 + -0x137c) - sVar5;
  *(undefined2 *)(unaff_A5 + -0x1028) = 0;
  FUN_00002334();
  return;
}



// WARNING: Control flow encountered bad instruction data

void FUN_000029f2(void)

{
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



/*
 * Original: FUN_00002a44; source: ID02.c:1487-1546.
 * Recovered name: apply_settings_to_live_options [STRONG INFERENCE] (iteration 116).
 * Status: RENAMED. Exported C is complete (no truncation); kept verbatim.
 * Input: none; reads S = *(HEL1 127 handle A5-0x13ac). Output: void.
 * Effect: copies settings words from S into a live options block in the A5
 * world; for some fields, a change triggers a callback through a function
 * pointer, gated by long A5-0x1006 != 0 [UNKNOWN: probably "overlay/game
 * context loaded"]; any triggered callback forces a redraw (FUN_00004db0).
 * Callers [PROVEN, bytes; BSR/JSR d16(PC) scan of ID02.bin]: file 0x6ce,
 * 0x6f6, 0x716, 0x218a, 0x2a20, 0x39a0 (do_menu_command epilogue). None appear
 * in the exported C (all inside truncated or mis-decoded bodies).
 *
 * Settings word -> live word (menu source from do_menu_command):
 *   S+0x02 -> A5-0x12ee   (menu 4 item 1 toggle)
 *   S+0x04 -> A5-0x12ec   (menu 4 item 2 toggle)
 *   S+0x06 -> A5-0x12e8   (menu 4 item 5 toggle)
 *   S+0x08 -> A5-0x12e6   (menu 4 item 6 toggle)        change -> (A5-0x1092)()
 *   S+0x0a -> A5-0x12e4;  S+0x0c -> A5-0x12ea and A5-0x103c
 *   S+0x10 -> A5-0x12e0   (menu 5 items 1..5 radio)     change -> (A5-0x1092)()
 *   S+0x12 -> A5-0x12de   (menu 5 item 7)  only if word A5-0x137a == 8,
 *                         change -> (A5-0x1096)(); else forced 0
 *   S+0x14 -> A5-0x12dc   (menu 5 item 9)               change -> (A5-0x1092)()
 *   S+0x16 -> A5-0x12da   (menu 5 item 8)               change -> (A5-0x104e)()
 *   S+0x18 -> A5-0x12d8   (menu 5 item 10)              change -> (A5-0x1092)()
 *   S+0x1a -> A5-0x12d6   (menu 5 item 11) only if A5-0x137a == 8, else 0
 *   S+0x1c -> A5-0x12d4;  S+0x22 -> A5-0x12d2;  S+0x24 -> A5-0x12d0
 * [HYPOTHESIS] A5-0x137a == 8 may be a screen depth (8-bit colour) gate.
 * Iteration 117 [PROVEN, bytes]: gate A5-0x1006 is the relocated overlay image
 * base, written only by ID08 load_overlay_from_resource (file 0xd4 MOVE.L A0,
 * then 4-byte alignment at 0xf0/0xfe; cleared at 0x226). A d16(A5) byte scan of
 * ID01-ID09 finds only reads (MOVEA.L) of A5-0x1092/-0x104e/-0x1096 (ID02 file
 * 0x2a3a, 0x2aec, 0x2b1a, 0x2b50, 0x3694, 0x4d1a); no direct writer. They are
 * therefore filled indirectly (overlay code or block copy) [STRONG INFERENCE];
 * the callbacks run overlay-side code only when the overlay is loaded.
 * Note: S+0x0e (menu 4 items 8-10) is not copied here; FUN_000035bc handles it.
 * Order of reads/writes is preserved exactly as exported.
 */
void apply_settings_to_live_options /* Original: FUN_00002a44 */ (void)

{
  undefined2 uVar1;
  short sVar2;
  short sVar3;
  short sVar4;
  short sVar5;
  bool bVar6;
  int unaff_A5;
  
  bVar6 = false;
  *(undefined2 *)(unaff_A5 + -0x12ee) = *(undefined2 *)(**(int **)(unaff_A5 + -0x13ac) + 2);
  *(undefined2 *)(unaff_A5 + -0x12ec) = *(undefined2 *)(**(int **)(unaff_A5 + -0x13ac) + 4);
  uVar1 = *(undefined2 *)(**(int **)(unaff_A5 + -0x13ac) + 0xc);
  *(undefined2 *)(unaff_A5 + -0x12ea) = uVar1;
  *(undefined2 *)(unaff_A5 + -0x103c) = uVar1;
  sVar2 = *(short *)(unaff_A5 + -0x12e0);
  sVar3 = *(short *)(unaff_A5 + -0x12d8);
  sVar4 = *(short *)(unaff_A5 + -0x12e6);
  sVar5 = *(short *)(unaff_A5 + -0x12dc);
  *(undefined2 *)(unaff_A5 + -0x12e0) = *(undefined2 *)(**(int **)(unaff_A5 + -0x13ac) + 0x10);
  *(undefined2 *)(unaff_A5 + -0x12d8) = *(undefined2 *)(**(int **)(unaff_A5 + -0x13ac) + 0x18);
  *(undefined2 *)(unaff_A5 + -0x12e6) = *(undefined2 *)(**(int **)(unaff_A5 + -0x13ac) + 8);
  *(undefined2 *)(unaff_A5 + -0x12dc) = *(undefined2 *)(**(int **)(unaff_A5 + -0x13ac) + 0x14);
  if (((((*(short *)(unaff_A5 + -0x12e0) != sVar2) || (*(short *)(unaff_A5 + -0x12d8) != sVar3)) ||
       (*(short *)(unaff_A5 + -0x12e6) != sVar4)) || (*(short *)(unaff_A5 + -0x12dc) != sVar5)) &&
     (*(int *)(unaff_A5 + -0x1006) != 0)) {
    (**(code **)(unaff_A5 + -0x1092))();
    bVar6 = true;
  }
  sVar2 = *(short *)(unaff_A5 + -0x12da);
  *(undefined2 *)(unaff_A5 + -0x12da) = *(undefined2 *)(**(int **)(unaff_A5 + -0x13ac) + 0x16);
  if ((sVar2 != *(short *)(unaff_A5 + -0x12da)) && (*(int *)(unaff_A5 + -0x1006) != 0)) {
    (**(code **)(unaff_A5 + -0x104e))();
    bVar6 = true;
  }
  if (*(short *)(unaff_A5 + -0x137a) == 8) {
    sVar2 = *(short *)(unaff_A5 + -0x12de);
    *(undefined2 *)(unaff_A5 + -0x12de) = *(undefined2 *)(**(int **)(unaff_A5 + -0x13ac) + 0x12);
    if ((*(short *)(unaff_A5 + -0x12de) != sVar2) && (*(int *)(unaff_A5 + -0x1006) != 0)) {
      (**(code **)(unaff_A5 + -0x1096))();
      bVar6 = true;
    }
    *(undefined2 *)(unaff_A5 + -0x12d6) = *(undefined2 *)(**(int **)(unaff_A5 + -0x13ac) + 0x1a);
  }
  else {
    *(undefined2 *)(unaff_A5 + -0x12de) = 0;
    *(undefined2 *)(unaff_A5 + -0x12d6) = 0;
  }
  *(undefined2 *)(unaff_A5 + -0x12d2) = *(undefined2 *)(**(int **)(unaff_A5 + -0x13ac) + 0x22);
  *(undefined2 *)(unaff_A5 + -0x12d0) = *(undefined2 *)(**(int **)(unaff_A5 + -0x13ac) + 0x24);
  *(undefined2 *)(unaff_A5 + -0x12e8) = *(undefined2 *)(**(int **)(unaff_A5 + -0x13ac) + 6);
  *(undefined2 *)(unaff_A5 + -0x12d4) = *(undefined2 *)(**(int **)(unaff_A5 + -0x13ac) + 0x1c);
  *(undefined2 *)(unaff_A5 + -0x12e4) = *(undefined2 *)(**(int **)(unaff_A5 + -0x13ac) + 10);
  if (bVar6) {
    redraw_main_window(); /* Original: FUN_00004db0 */
  }
  return;
}



// WARNING: Control flow encountered bad instruction data

/*
 * Original: FUN_00002bbc; source: ID02.c:1552-1564.
 * Recovered name: initialize_application [STRONG INFERENCE] (iteration 111).
 * Status: RENAMED. Ghidra decoded only the first two calls and stopped at the
 * A-line word $A994 (file 0x2bdc). Exported C retained; the remainder below is
 * described from ID02.bin file 0x2bbc..0x2d9e and NOT reconstructed as C.
 * JT targets resolved through ID00.bin (seg off + 4-byte CODE header = file).
 * Trap names are Inside Macintosh assignments [STRONG INFERENCE];
 * byte sequences and control flow are [PROVEN, bytes].
 *
 *   JSR $222(A5)      seg9 file 0x1cc: MaxApplZone glue ($A063, manual path if ROM85<0)
 *   2x JSR $292(A5)   seg9 file 0x298: MoreMasters ($A036)  [the loop below]
 *   $A994 CurResFile -> word A5-0x1002 (application resource file refnum)
 *   PEA -$160c(A5); $A86E InitGraf; $A8FE InitFonts
 *   JSR $202(A5)(-1, 0) seg9 0x192: FlushEvents ($A032)
 *   $A912 InitWindows; $A930 InitMenus; $A9CC TEInit; $A97B InitDialogs(nil);
 *   $A850 InitCursor; JSR $1fa(A5)(-1) seg9 0x18a: SetEventMask (word -> $144)
 *   JSR $592(A5)      ID07 init_string_pointer_groups; PEA $58a(A5); $A9F1
 *                     UnloadSeg -> segment 7 is init-only
 *   JSR $f2(A5)       seg4 file 0x3d42, D0.W == 0 -> $A9F4 ExitToShell [UNKNOWN check]
 *   JSR $1f2(A5)(1, &env) seg9 file 0x20 = SysEnvirons dispatcher (ID09
 *                     sysenvirons_glue_fallback); env at -$1e(A6)
 *   A5-0x1388 byte <- env.hasColorQD (-$15(A6) = env+9)
 *   A5-0x1387 byte <- (env.processor == 1 || == 2)  [68000/68010 flag, HYPOTHESIS]
 *   if hasColorQD: BSR file 0x2192; p = JSR $232(A5)(0x6d8) seg9 0x20c
 *                  NewPtrClear ($A31E) -> A5-0x14b2 and A5-0x1316;
 *                  *(long*)p = $AA28 result; *(word*)(p+4) = 0x8000
 *                  [HYPOTHESIS: colour table, ctSeed/ctFlags; $AA28 unconfirmed]
 *   GetResource('MENU', 2) == nil -> SysBeep(20); BSR 0x2e36; BSR 0x2eaa
 *   h = GetResource('HEL1', 0x7f) -> A5-0x13ac; if nil:
 *       NewHandleClear(0x12a) (JT $252, seg9 0x242, $A322); AddResource(h,
 *       'HEL1', 0x7f, name A5-0xc90); (*h)+0x10=2, +0x0e=1, +0x24=2, +0x26=1;
 *       BSR 0x2ee4 copies string A5-0xc78 -> (*h)+0x2a; ChangedResource; WriteResource
 *     else LoadResource(h)
 *   h = GetResource('HEL1', 0x80) -> A5-0x13a8; if nil: NewHandleClear(0x500),
 *       AddResource(h,'HEL1',0x80, name A5-0xc66), ChangedResource, WriteResource
 *     else LoadResource(h)   [0x500 = 20 x 0x40 records, read by ID04.c:711]
 *   BSR file 0x27e4; SetPort ($A873) (port A5-0x14ca); UNLK; RTS
 *
 * Callers: main (FUN_0000309a, ID02.c:1658), which first sets word A5-0x13ae = -1.
 * [UNKNOWN] Semantics of seg4 check, HEL1 record fields, local helpers
 * 0x2192 / 0x27e4 / 0x2e36 / 0x2eaa.
 */
void initialize_application /* Original: FUN_00002bbc */ (void)

{
  int unaff_A5;
  undefined2 local_6;

  (**(code **)(unaff_A5 + 0x222))(); /* MaxApplZone glue (seg9 file 0x1cc) */
  for (local_6 = 0; local_6 < 2; local_6 = local_6 + 1) {
    (**(code **)(unaff_A5 + 0x292))(); /* MoreMasters glue (seg9 file 0x298) */
  }
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



// WARNING: Control flow encountered bad instruction data

void FUN_00002db8(void)

{
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



// WARNING: Control flow encountered bad instruction data

void FUN_00002e36(void)

{
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



void FUN_00002ee4(char *param_1,char *param_2)

{
  char cVar1;
  short sVar2;
  
  cVar1 = *param_1;
  *param_2 = cVar1;
  sVar2 = (short)cVar1;
  while( true ) {
    param_1 = param_1 + 1;
    param_2 = param_2 + 1;
    sVar2 = sVar2 + -1;
    if (sVar2 < 0) break;
    *param_2 = *param_1;
  }
  return;
}



// WARNING: Control flow encountered bad instruction data

/*
 * Original: FUN_00002f1e; source: ID02.c:1613-1618.
 * Recovered name: handle_mouse_down [STRONG INFERENCE] (iteration 127).
 * Status: RENAMED; Ghidra truncated at $A92C. Bytes file 0x2f1e..0x2f9e [PROVEN].
 * Arg: EventRecord *evt [8(A6)]. Caller: poll_and_dispatch_event (mouseDown).
 *   part = FindWindow(evt->where (+0xa), &win) $A92C;
 *   switch (part) [ID01 switch helper, table 0x2f40, 1..6, default return]:
 *     1 inMenuBar   -> do_menu_command(MenuSelect(evt->where) $A93D)
 *     2 inSysWindow -> SystemClick(evt, win) $A9B3
 *     3 inContent, 4 inDrag, 5 inGrow -> no action (window is not draggable here)
 *     6 inGoAway    -> if (win == main_window A5-0x14ca &&
 *                         TrackGoAway(main_window, evt->where) $A91E)
 *                        HideWindow(main_window) $A916
 * Part codes / traps: Inside Macintosh [STRONG INFERENCE].
 */
void handle_mouse_down /* Original: FUN_00002f1e */ (void)

{
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



// WARNING: Control flow encountered bad instruction data

/*
 * Original: FUN_00002fa0; source: ID02.c:1624-1634.
 * Recovered name: handle_activate_event [STRONG INFERENCE] (iteration 127).
 * Status: RENAMED. Exported C kept; its inner body was truncated at $A928.
 * Arg: EventRecord passed by value at 8(A6)..$17(A6). Ghidra's split:
 * param_1 (8 bytes) = what, message, high word of when (param_1._2_4_ =
 * message); param_2 = low word of when + where.v; param_3 = modifiers ($16(A6)).
 * Bytes file 0x2fa0..0x2fd2 [PROVEN]:
 *   if (word A5-0x14c6 && (evt.modifiers & 3) == 3 && evt.message == main_window
 *       && main_window != 0)
 *     InvalRect(&main_window->portRect)  (PEA $10(A0); $A928)
 * Bits 0/1 of modifiers = activeFlag / changeFlag [STRONG INFERENCE, Inside
 * Macintosh]; i.e. on activation of the main window, force a full redraw.
 * Caller: poll_and_dispatch_event (activateEvt).
 */
void handle_activate_event /* Original: FUN_00002fa0 */ (undefined8 param_1,undefined4 param_2,ushort param_3)

{
  int unaff_A5;
  
  if ((((*(short *)(unaff_A5 + -0x14c6) != 0) && ((param_3 & 3) == 3)) &&
      (param_1._2_4_ == *(int *)(unaff_A5 + -0x14ca))) && (*(int *)(unaff_A5 + -0x14ca) != 0)) {
                    // WARNING: Bad instruction - Truncating control flow here
    halt_baddata();
  }
  return;
}



// WARNING: Control flow encountered bad instruction data

/*
 * Original: FUN_00002fd4; source: ID02.c:1641-1646.
 * Recovered name: poll_and_dispatch_event [STRONG INFERENCE] (iteration 113).
 * Status: RENAMED. Exported body is Ghidra's truncation at the first A-line
 * word ($A938, file 0x2fda). halt_baddata() retained; real body described
 * from ID02.bin file 0x2fd4..0x3098 [PROVEN, bytes] and NOT reconstructed.
 * Caller: main (FUN_0000309a) in an infinite loop (BSR at file 0x30f0).
 * Locals: EventRecord evt at -$12(A6) (what -$12, message -$10, when -$c,
 * where -$8, modifiers -$4); word got_event at -$2(A6).
 *
 *   HiliteMenu(0) ($A938); SystemTask ($A9B4)
 *   BSR 0x3174 (FUN_00003174); JSR $172(A5) -> seg4 file 0x432 [UNKNOWN]
 *   got_event = GetNextEvent(-1 /everyEvent/, &evt) ($A970), then
 *       word 0x49C0 = EXTB.L D0 (68020+ only; Capstone 68000 mode rejects it)
 *   BSR 0x29f2 (FUN_000029f2); if (!got_event) return
 *   switch (evt.what) via JSR $3a(A5) (ID01 switch helper; table at 0x300e:
 *   lo=1, hi=8, default -> return):
 *     1 mouseDown  -> BSR 0x2f1e (handle_mouse_down)(&evt)
 *     3 keyDown, 5 autoKey -> if (evt.modifiers & 0x100 /cmdKey/):
 *          BSR 0x36a2 (do_menu_command)(MenuKey((char)(evt.message & 0xff)))  ($A93E)
 *     6 updateEvt  -> BSR 0x29f2; if (word A5-0x14c6 && evt.message == A5-0x14ca):
 *          BeginUpdate(A5-0x14ca) ($A922); BSR 0x4db0 (redraw_main_window);
 *          EndUpdate ($A923)
 *     8 activateEvt -> BSR 0x2fa0 (handle_activate_event)(evt by value, 16 bytes)
 *     2 mouseUp, 4 keyUp, 7 diskEvt -> ignored
 * Event codes/masks and trap names are Inside Macintosh [STRONG INFERENCE].
 * [STRONG INFERENCE] A5-0x14ca is the main window (also SetPort target in
 * initialize_application); A5-0x14c6 gates its redraw. Non-command keys are
 * not handled here (likely polled elsewhere during gameplay) [HYPOTHESIS].
 */
void poll_and_dispatch_event /* Original: FUN_00002fd4 */ (void)

{
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



// WARNING: Control flow encountered bad instruction data

/*
 * Original: FUN_0000309a; source: ID02.c:1650-1660.
 * Recovered name: main [STRONG INFERENCE] (iteration 112).
 * Status: RENAMED. Ghidra stopped at UnloadSeg ($A9F1, file 0x30b0); the
 * remainder is described from ID02.bin file 0x309a..0x30f8 [PROVEN, bytes].
 *
 * Entry evidence [PROVEN, bytes]: ID01.bin (JT entry 0 target) holds the long
 * 0x000004b2 at file 0x4; file 0x24 MOVE.L $4(PC),D1; 0x28 JSR (A5,D1.W)
 * -> JT A5+0x4b2 = seg 2 off 0x3096 = this function; then JSR via $6c(A5)
 * and $A9F4 ExitToShell. This is the runtime start calling the program main.
 *
 *   long local_a = 0 (-6(A6)); word A5-0x13ae = -1   [exported C below]
 *   initialize_application()                         [exported C below]
 *   UnloadSeg(JT $a2  = seg 4 entry)
 *   JSR $21a(A5)(&local_a): seg9 file 0x1bc = MaxMem glue ($A11D): result
 *        discarded, grow size stored to local_a [heap compaction]
 *   BSR file 0x1b42  install_overlay_service_table (unexported; see
 *                    freemem_a5safe header) - fills A5 service table, allocates A5-0x1040
 *   word A5-0x14c4 = 1
 *   ok = JSR $1e2(A5) -> seg 8 file 0x6 = ID08 load_overlay_from_resource
 *   UnloadSeg(JT $1ea = seg 8 entry); UnloadSeg(JT $56a = seg 5 entry)
 *   BSR file 0x30fa (FUN_000030fa)                   [UNKNOWN]
 *   if (ok && word A5-0x102e != 0) BSR file 0x35e4   [UNKNOWN]
 *   for (;;) BSR file 0x2fd4 (poll_and_dispatch_event, FUN_00002fd4) [never returns]
 *   (UNLK/RTS at 0x30f6 unreachable)
 * Name chosen for the role (C runtime entry -> main); original symbol unknown.
 */
void main /* Original: FUN_0000309a */ (void)

{
  int unaff_A5;

  *(undefined2 *)(unaff_A5 + -0x13ae) = 0xffff;
  initialize_application(); /* Original: FUN_00002bbc */
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



// WARNING: Control flow encountered bad instruction data

void FUN_000030fa(void)

{
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



// WARNING: Control flow encountered bad instruction data

void FUN_00003174(void)

{
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



// WARNING: Control flow encountered bad instruction data

void FUN_00003590(undefined4 param_1,short param_2)

{
  if (param_2 != 0) {
                    // WARNING: Bad instruction - Truncating control flow here
    halt_baddata();
  }
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



void FUN_000035bc(undefined4 param_1)

{
  int unaff_A5;
  
  if (*(short *)(**(int **)(unaff_A5 + -0x13ac) + 0xe) != param_1._0_2_) {
    *(short *)(**(int **)(unaff_A5 + -0x13ac) + 0xe) = param_1._0_2_;
    FUN_000027e4();
  }
  return;
}



// WARNING: Control flow encountered bad instruction data

void FUN_000035e4(void)

{
  short sVar1;
  int unaff_A5;
  undefined2 local_6;
  
  sVar1 = (**(code **)(unaff_A5 + 0x132))();
  if (sVar1 != 0) {
    sVar1 = (**(code **)(unaff_A5 + 0x82))();
    if (sVar1 != 0) {
      (**(code **)(unaff_A5 + -0x109a))((int)*(short *)(unaff_A5 + -0x12f8));
      if (*(short *)(unaff_A5 + -0x14c6) != 0) {
                    // WARNING: Bad instruction - Truncating control flow here
        halt_baddata();
      }
      *(undefined2 *)(unaff_A5 + -0x12f0) = 0;
      for (local_6 = 0; local_6 < 0xc; local_6 = local_6 + 1) {
        *(undefined2 *)(local_6 * 2 + unaff_A5 + -0x13a2) = 0;
        *(undefined2 *)(local_6 * 2 + unaff_A5 + -0x12ce) = 0;
      }
      *(undefined2 *)(unaff_A5 + -0x12b4) = 0;
      *(undefined2 *)(unaff_A5 + -0x12b6) = 0;
      *(undefined2 *)(unaff_A5 + -0x12b2) = 0;
      *(undefined2 *)(unaff_A5 + -0x14c4) = 0;
      *(undefined2 *)(unaff_A5 + -0x14c2) = 0;
      *(undefined2 *)(unaff_A5 + -0x14c0) = 0;
      if ((((*(short *)(unaff_A5 + -0x102e) != 0) && (*(int *)(unaff_A5 + -0x1006) != 0)) &&
          (*(short *)(unaff_A5 + -0x137a) == 1)) && (*(short *)(unaff_A5 + -0x14c6) != 0)) {
        (**(code **)(unaff_A5 + -0x1096))();
      }
      FUN_000004fc();
    }
  }
  return;
}



// WARNING: Control flow encountered bad instruction data

/*
 * Original: FUN_000036a2; source: ID02.c:1759-1764.
 * Recovered name: do_menu_command [STRONG INFERENCE] (iteration 114).
 * Status: RENAMED; body annotation complete (iterations 114-115;
 * all five menus described). halt_baddata() retained;
 * real body from ID02.bin file 0x36a2..0x39a6 [PROVEN, bytes], not rebuilt.
 * Input: long menuResult at 8(A6) (from MenuKey in poll_and_dispatch_event;
 * presumably also MenuSelect via the mouseDown path).
 *   menu = HiWord(menuResult) ($A86A) -> -2(A6); item = LoWord ($A86B) -> -4(A6)
 * Switch tables are ID01 runtime-helper format (lo, hi, default, offsets
 * relative to their own word); parsed programmatically, targets in file coords.
 *
 * switch (menu) [table 0x36ca, 1..5, default -> exit 0x39a0]:
 *  1 (Apple, 0x36da): item 1 -> JSR $162(A5) [UNKNOWN, likely About box];
 *       other -> GetPort(&save) $A874; GetItem(A5-0xc4e, item, name) $A946;
 *       OpenDeskAcc(name) $A9B6; SetPort(save) $A873       [desk accessories]
 *  2 (0x371a) item switch [table 0x3722, 1..13]:
 *       1 -> JSR $1da(A5) (seg8 file 0x39c); UnloadSeg seg 8, seg 5 [HYPOTHESIS: start flight]
 *       2 -> BSR 0x2da0: if word A5-0x138a: ChangedResource+WriteResource(HEL1 127), clear flag
 *       3, 10, 12 -> no action (separator lines) [HYPOTHESIS]
 *       4 -> BSR 0x35e4 (also called conditionally by main)
 *       5 -> D0 = (JSR $da(A5)(A5-0xd6a, 3) == 3) [seg4 file 0x31aa; result unused here]
 *       6 -> JSR $10a(A5) (seg4 file 0x3976)
 *       7 -> BSR 0x4fc;  8 -> word A5-0x12f0 = 1; BSR 0x4fc
 *       9 -> if (JSR $13a(A5) (seg4 file 0x516) == 2):
 *              word A5-0x12f8 = 0; HideWindow(main_window A5-0x14ca) $A916;
 *              word A5-0x14c6 = 0 (disables update redraw)
 *       11 -> JSR $102(A5) (seg4 file 0x137a)
 *       13 -> BSR 0x2eaa [STRONG INFERENCE: quit; same helper as the fatal
 *             path in initialize_application]
 *  3 (Edit, 0x37ce): if (!SystemEdit(item - 1)) ($A9C2) SysBeep(5) ($A9C8)
 *  Let S = *(HEL1 127 handle A5-0x13ac) (settings record, 0x12a bytes) and
 *  DIRTY = word A5-0x138a = 1 (consumed by menu 2 item 2 save helper 0x2da0).
 *  4 (0x37ec) item switch [table 0x37f4, 1..10]  (iteration 115):
 *       1 -> BCHG #0, S+3;  DIRTY      2 -> BCHG #0, S+5;  DIRTY
 *       4 -> BCHG #0, byte A5-0x102f (not persisted, no DIRTY)
 *       5 -> BCHG #0, S+7;  DIRTY      6 -> BCHG #0, S+9;  DIRTY
 *       8 -> FUN_000035bc(1); DIRTY    9 -> FUN_000035bc(3); DIRTY
 *      10 -> FUN_000035bc(2); DIRTY    3, 7 -> no action (separators) [HYPOTHESIS]
 *       FUN_000035bc(v) [ID02.c C]: if word S+0xe != v, store v, BSR 0x27e4
 *       (also called at end of initialize_application) [UNKNOWN: re-layout?]
 *  5 (0x38ac) item switch [table 0x38b4, 1..11]:
 *       1..5 -> word S+0x10 = item (1..5); DIRTY   [radio group; default 2]
 *       6 -> no action (separator) [HYPOTHESIS]
 *       7 -> BCHG #0, S+0x13   8 -> S+0x17   9 -> S+0x15   10 -> S+0x19
 *      11 -> S+0x1b; each DIRTY
 *  Epilogue (every path, file 0x39a0): BSR 0x2a44 (apply_settings_to_live_options,
 *  FUN_00002a44; iteration 116: copies S words into live A5 options), UNLK, RTS.
 *  BCHG on odd byte S+2n+1 flips bit 0 of big-endian word S+2n.
 *  Defaults when HEL1 127 is created (initialize_application): S+0x0e=1,
 *  S+0x10=2, S+0x24=2, S+0x26=1. Bit-0 toggles imply on/off options
 *  [STRONG INFERENCE]; which game option each byte controls is UNKNOWN.
 *  Note: Capstone mis-aligns at 0x38cc; case 1 entry 0x38d0 decodes as
 *  MOVEA.L -$13ac(A5),A0; MOVEA.L (A0),A0; MOVEQ #1,D0; MOVE.W D0,$10(A0).
 * Trap names: Inside Macintosh [STRONG INFERENCE]. Menu titles UNKNOWN until
 * MENU resources are examined.
 */
void do_menu_command /* Original: FUN_000036a2 */ (void)

{
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



/*
 * Original: FUN_000039a8; source: ID02.c:1768.
 * Recovered name: vbl_sound_handler_ch0_unrolled [STRONG INFERENCE] (iteration 141).
 * Exported C kept verbatim (Ghidra cannot model the register-chaining tail).
 * Interrupt-hook pattern [PROVEN, bytes]: CLR.L -(A7) reserves a return slot;
 * MOVEM saves D0-D7/A0-A6; A5 is taken from a long stored inside the code
 * (PC-relative, +0x1c from entry). If that cache is 0 (first call, made by
 * init_sound_system with the application A5) it stores CurrentA5 ($0904) there
 * and returns - priming only. Otherwise it writes the saved previous vector
 * (long A5-0xc36) into the reserved slot, does its work, restores registers
 * and RTS-chains to the previous handler.
 * Installed into low-memory $0196 = Lvl1DT[1], the VIA CA1 vertical-blanking
 * level-1 interrupt vector [STRONG INFERENCE: Lvl1DT at $0192 per Inside
 * Macintosh; consistent with per-VBL refill of the 370-sample sound buffer].
 * Self-modifying code: the in-code A5 cache is written at run time.
 * JT A5+0x41a; selected by init_sound_system(param == 0).
 * Body: channel 0 node (head long A5-0x7d0): d0 cursor, d1 fraction, a0 buffer,
 * d4 end; step d2:d3 = A5-0xc32 / A5-0xc2e (32.32 fixed point via ADD/ADDX);
 * writes samples MOVE.B (A0,D0.L) into every other byte from SoundBase ($0266)
 * + 4, loop unrolled x8; end-of-buffer handling compares with A5-0xc2a.
 */
undefined8 vbl_sound_handler_ch0_unrolled /* Original: FUN_000039a8 */ (void)

{
  int iVar1;
  uint uVar2;
  uint uVar3;
  uint uVar4;
  undefined4 in_D0;
  int iVar5;
  int iVar6;
  undefined4 in_D1;
  uint uVar7;
  int iVar8;
  short sVar9;
  int iVar10;
  int *piVar11;
  undefined1 *puVar12;
  bool bVar13;
  
  iVar5 = DAT_000039c4;
  if (DAT_000039c4 != 0) {
    piVar11 = *(int **)(DAT_000039c4 + -2000);
    iVar6 = *piVar11;
    uVar7 = piVar11[1];
    iVar10 = piVar11[2];
    iVar8 = piVar11[4];
    iVar1 = *(int *)(DAT_000039c4 + -0xc32);
    uVar2 = *(uint *)(DAT_000039c4 + -0xc2e);
    puVar12 = &DAT_66fa4e79;
    if (*(int *)(DAT_000039c4 + -0xc2a) < iVar8 - iVar6) {
      sVar9 = 0x5b;
      do {
        *puVar12 = *(undefined1 *)(iVar10 + iVar6);
        iVar5 = iVar1 + iVar6 + (uint)CARRY4(uVar2,uVar7);
        puVar12[2] = *(undefined1 *)(iVar10 + iVar5);
        uVar3 = uVar2 + uVar2 + uVar7;
        iVar5 = iVar1 + iVar5 + (uint)CARRY4(uVar2,uVar2 + uVar7);
        puVar12[4] = *(undefined1 *)(iVar10 + iVar5);
        uVar4 = uVar2 + uVar3;
        iVar5 = iVar1 + iVar5 + (uint)CARRY4(uVar2,uVar3);
        puVar12[6] = *(undefined1 *)(iVar10 + iVar5);
        puVar12 = puVar12 + 8;
        uVar7 = uVar2 + uVar4;
        iVar6 = iVar1 + iVar5 + (uint)CARRY4(uVar2,uVar4);
        sVar9 = sVar9 + -1;
      } while (sVar9 != -1);
      DAT_66fa4e75 = *(undefined1 *)(iVar10 + iVar6);
      uVar3 = uVar2 + uVar7;
      iVar5 = iVar1 + iVar6 + (uint)CARRY4(uVar2,uVar7);
      DAT_66fa4e77 = *(undefined1 *)(iVar10 + iVar5);
      uVar7 = uVar2 + uVar3;
      iVar6 = iVar1 + iVar5 + (uint)CARRY4(uVar2,uVar3);
    }
    else {
      sVar9 = 0x16f;
      do {
        if (iVar8 <= iVar6) {
          piVar11 = (int *)piVar11[6];
          iVar10 = piVar11[2];
          iVar6 = piVar11[3];
          uVar7 = 0;
          iVar8 = piVar11[4];
          *(int **)(iVar5 + -2000) = piVar11;
        }
        *puVar12 = *(undefined1 *)(iVar10 + iVar6);
        puVar12 = puVar12 + 2;
        bVar13 = CARRY4(uVar2,uVar7);
        uVar7 = uVar2 + uVar7;
        iVar6 = iVar1 + iVar6 + (uint)bVar13;
        sVar9 = sVar9 + -1;
      } while (sVar9 != -1);
      puVar12 = &DAT_66fa4e75;
      sVar9 = 1;
      do {
        if (iVar8 <= iVar6) {
          piVar11 = (int *)piVar11[6];
          iVar10 = piVar11[2];
          iVar6 = piVar11[3];
          uVar7 = 0;
          iVar8 = piVar11[4];
          *(int **)(iVar5 + -2000) = piVar11;
        }
        *puVar12 = *(undefined1 *)(iVar10 + iVar6);
        puVar12 = puVar12 + 2;
        bVar13 = CARRY4(uVar2,uVar7);
        uVar7 = uVar2 + uVar7;
        iVar6 = iVar1 + iVar6 + (uint)bVar13;
        sVar9 = sVar9 + -1;
      } while (sVar9 != -1);
    }
    *piVar11 = iVar6;
    piVar11[1] = uVar7;
    return CONCAT44(in_D0,in_D1);
  }
  DAT_000039c4 = DAT_00000904;
  return CONCAT44(in_D0,in_D1);
}



/*
 * Original: FUN_00003aae; source: ID02.c:1868.
 * Recovered name: vbl_sound_handler_ch0_variant [STRONG INFERENCE] (iteration 141).
 * Exported C kept verbatim (Ghidra cannot model the register-chaining tail).
 * Interrupt-hook pattern [PROVEN, bytes]: CLR.L -(A7) reserves a return slot;
 * MOVEM saves D0-D7/A0-A6; A5 is taken from a long stored inside the code
 * (PC-relative, +0x1c from entry). If that cache is 0 (first call, made by
 * init_sound_system with the application A5) it stores CurrentA5 ($0904) there
 * and returns - priming only. Otherwise it writes the saved previous vector
 * (long A5-0xc36) into the reserved slot, does its work, restores registers
 * and RTS-chains to the previous handler.
 * Installed into low-memory $0196 = Lvl1DT[1], the VIA CA1 vertical-blanking
 * level-1 interrupt vector [STRONG INFERENCE: Lvl1DT at $0192 per Inside
 * Macintosh; consistent with per-VBL refill of the 370-sample sound buffer].
 * Self-modifying code: the in-code A5 cache is written at run time.
 * JT A5+0x412; selected by init_sound_system(param != 0).
 * Body: same channel-0 resampling as vbl_sound_handler_ch0_unrolled with a
 * shorter (x2) inner loop [exact difference not yet analysed].
 */
undefined8 vbl_sound_handler_ch0_variant /* Original: FUN_00003aae */ (void)

{
  int iVar1;
  uint uVar2;
  int iVar3;
  undefined4 in_D0;
  int iVar4;
  undefined4 in_D1;
  uint uVar5;
  int iVar6;
  short sVar7;
  uint *puVar8;
  uint *puVar9;
  int iVar10;
  int *piVar11;
  undefined1 *puVar12;
  undefined1 *puVar13;
  bool bVar14;
  
  iVar3 = DAT_00003aca;
  if (DAT_00003aca != 0) {
    piVar11 = *(int **)(DAT_00003aca + -2000);
    iVar4 = *piVar11;
    uVar5 = piVar11[1];
    iVar10 = piVar11[2];
    iVar6 = piVar11[4];
    puVar12 = &DAT_66fa4e79;
    iVar1 = *(int *)(DAT_00003aca + -0xc32);
    uVar2 = *(uint *)(DAT_00003aca + -0xc2e);
    if (*(int *)(DAT_00003aca + -0xc2a) < iVar6 - iVar4) {
      sVar7 = 0x5b;
      puVar8 = (uint *)(iVar4 + iVar10);
      iVar4 = iVar4 + 0x172;
      if (((uint)puVar8 & 1) == 0) {
        do {
          puVar9 = puVar8;
          uVar5 = *puVar9;
          *puVar12 = (char)(uVar5 >> 0x18);
          puVar12[2] = (char)(uVar5 >> 0x10);
          puVar12[4] = (char)(uVar5 >> 8);
          puVar12[6] = (char)uVar5;
          puVar12 = puVar12 + 8;
          sVar7 = sVar7 + -1;
          puVar8 = puVar9 + 1;
        } while (sVar7 != -1);
        DAT_66fa4e75 = *(undefined1 *)(puVar9 + 1);
        DAT_66fa4e77 = *(undefined1 *)((int)puVar9 + 5);
      }
      else {
        DAT_66fa4e79 = *(undefined1 *)puVar8;
        sVar7 = 0x5a;
        puVar8 = (uint *)((int)puVar8 + 1);
        puVar12 = &DAT_66fa4e7b;
        do {
          puVar13 = puVar12;
          puVar9 = puVar8;
          uVar5 = *puVar9;
          *puVar13 = (char)(uVar5 >> 0x18);
          puVar13[2] = (char)(uVar5 >> 0x10);
          puVar13[4] = (char)(uVar5 >> 8);
          puVar13[6] = (char)uVar5;
          sVar7 = sVar7 + -1;
          puVar8 = puVar9 + 1;
          puVar12 = puVar13 + 8;
        } while (sVar7 != -1);
        puVar13[8] = *(undefined1 *)(puVar9 + 1);
        puVar13[10] = *(undefined1 *)((int)puVar9 + 5);
        puVar13[0xc] = *(undefined1 *)((int)puVar9 + 6);
        DAT_66fa4e75 = *(undefined1 *)((int)puVar9 + 7);
        DAT_66fa4e77 = *(undefined1 *)(puVar9 + 2);
      }
    }
    else {
      sVar7 = 0x16f;
      do {
        if (iVar6 <= iVar4) {
          piVar11 = (int *)piVar11[6];
          iVar10 = piVar11[2];
          iVar4 = piVar11[3];
          uVar5 = 0;
          iVar6 = piVar11[4];
          *(int **)(iVar3 + -2000) = piVar11;
        }
        *puVar12 = *(undefined1 *)(iVar10 + iVar4);
        puVar12 = puVar12 + 2;
        bVar14 = CARRY4(uVar2,uVar5);
        uVar5 = uVar2 + uVar5;
        iVar4 = iVar1 + iVar4 + (uint)bVar14;
        sVar7 = sVar7 + -1;
      } while (sVar7 != -1);
      puVar12 = &DAT_66fa4e75;
      sVar7 = 1;
      do {
        if (iVar6 <= iVar4) {
          piVar11 = (int *)piVar11[6];
          iVar10 = piVar11[2];
          iVar4 = piVar11[3];
          uVar5 = 0;
          iVar6 = piVar11[4];
          *(int **)(iVar3 + -2000) = piVar11;
        }
        *puVar12 = *(undefined1 *)(iVar10 + iVar4);
        puVar12 = puVar12 + 2;
        bVar14 = CARRY4(uVar2,uVar5);
        uVar5 = uVar2 + uVar5;
        iVar4 = iVar1 + iVar4 + (uint)bVar14;
        sVar7 = sVar7 + -1;
      } while (sVar7 != -1);
    }
    *piVar11 = iVar4;
    piVar11[1] = uVar5;
    return CONCAT44(in_D0,in_D1);
  }
  DAT_00003aca = DAT_00000904;
  return CONCAT44(in_D0,in_D1);
}



// WARNING: Globals starting with '_' overlap smaller symbols at the same address

/*
 * Original: FUN_00003bc4; source: ID02.c:1990.
 * Recovered name: vbl_sound_handler_two_channel [STRONG INFERENCE] (iteration 141).
 * Exported C kept verbatim (Ghidra cannot model the register-chaining tail).
 * Interrupt-hook pattern [PROVEN, bytes]: CLR.L -(A7) reserves a return slot;
 * MOVEM saves D0-D7/A0-A6; A5 is taken from a long stored inside the code
 * (PC-relative, +0x1c from entry). If that cache is 0 (first call, made by
 * init_sound_system with the application A5) it stores CurrentA5 ($0904) there
 * and returns - priming only. Otherwise it writes the saved previous vector
 * (long A5-0xc36) into the reserved slot, does its work, restores registers
 * and RTS-chains to the previous handler.
 * Installed into low-memory $0196 = Lvl1DT[1], the VIA CA1 vertical-blanking
 * level-1 interrupt vector [STRONG INFERENCE: Lvl1DT at $0192 per Inside
 * Macintosh; consistent with per-VBL refill of the 370-sample sound buffer].
 * Self-modifying code: the in-code A5 cache is written at run time.
 * JT A5+0x422 (A5-0x35c); installed by select_two_channel_sound_handler(1).
 * Body: mixes channel 1 (record A5-0x598 = A5-0x7d0 + 0x238; a1 buffer) with
 * channel 0 (a0) into SoundBase; also writes $0196 itself (likely restores
 * the single-channel handler when channel 1 ends) [HYPOTHESIS].
 */
undefined8 vbl_sound_handler_two_channel /* Original: FUN_00003bc4 */ (void)

{
  int iVar1;
  uint uVar2;
  uint uVar3;
  int iVar4;
  undefined4 in_D0;
  int iVar5;
  int iVar6;
  undefined4 in_D1;
  uint uVar7;
  short sVar8;
  int iVar9;
  char *pcVar10;
  char *pcVar11;
  char *pcVar12;
  int *piVar13;
  int iVar14;
  int *piVar15;
  char *pcVar16;
  bool bVar17;
  
  iVar4 = DAT_00003be0;
  if (DAT_00003be0 != 0) {
    piVar13 = *(int **)(DAT_00003be0 + -0x598);
    pcVar10 = (char *)(*piVar13 + piVar13[2]);
    iVar14 = *piVar13 + 0x172;
    piVar15 = *(int **)(DAT_00003be0 + -2000);
    iVar6 = *piVar15;
    uVar7 = piVar15[1];
    iVar9 = piVar15[2];
    iVar5 = piVar15[4];
    iVar1 = *(int *)(DAT_00003be0 + -0xc32);
    uVar2 = *(uint *)(DAT_00003be0 + -0xc2e);
    pcVar16 = &DAT_66fa4e79;
    if (*(int *)(DAT_00003be0 + -0xc2a) < iVar5 - iVar6) {
      sVar8 = 0xb7;
      do {
        pcVar11 = pcVar10;
        uVar3 = uVar2 + uVar7;
        iVar5 = iVar1 + iVar6 + (uint)CARRY4(uVar2,uVar7);
        *pcVar16 = *pcVar11 + *(char *)(iVar9 + iVar6) + -0x80;
        uVar7 = uVar2 + uVar3;
        iVar6 = iVar1 + iVar5 + (uint)CARRY4(uVar2,uVar3);
        pcVar16[2] = pcVar11[1] + *(char *)(iVar9 + iVar5) + -0x80;
        pcVar16 = pcVar16 + 4;
        sVar8 = sVar8 + -1;
        pcVar10 = pcVar11 + 2;
      } while (sVar8 != -1);
      uVar3 = uVar2 + uVar7;
      iVar5 = iVar1 + iVar6 + (uint)CARRY4(uVar2,uVar7);
      DAT_66fa4e75 = pcVar11[2] + *(char *)(iVar9 + iVar6) + -0x80;
      uVar7 = uVar2 + uVar3;
      iVar6 = iVar1 + iVar5 + (uint)CARRY4(uVar2,uVar3);
      DAT_66fa4e77 = pcVar11[3] + *(char *)(iVar9 + iVar5) + -0x80;
    }
    else {
      sVar8 = 0x16f;
      do {
        if (iVar5 <= iVar6) {
          piVar15 = (int *)piVar15[6];
          iVar9 = piVar15[2];
          iVar6 = piVar15[3];
          uVar7 = 0;
          iVar5 = piVar15[4];
          *(int **)(iVar4 + -2000) = piVar15;
        }
        pcVar11 = (char *)(iVar9 + iVar6);
        bVar17 = CARRY4(uVar2,uVar7);
        uVar7 = uVar2 + uVar7;
        iVar6 = iVar1 + iVar6 + (uint)bVar17;
        pcVar12 = pcVar10 + 1;
        *pcVar16 = *pcVar10 + *pcVar11 + -0x80;
        pcVar16 = pcVar16 + 2;
        sVar8 = sVar8 + -1;
        pcVar10 = pcVar12;
      } while (sVar8 != -1);
      pcVar10 = &DAT_66fa4e75;
      sVar8 = 1;
      do {
        if (iVar5 <= iVar6) {
          piVar15 = (int *)piVar15[6];
          iVar9 = piVar15[2];
          iVar6 = piVar15[3];
          uVar7 = 0;
          iVar5 = piVar15[4];
          *(int **)(iVar4 + -2000) = piVar15;
        }
        pcVar16 = (char *)(iVar9 + iVar6);
        bVar17 = CARRY4(uVar2,uVar7);
        uVar7 = uVar2 + uVar7;
        iVar6 = iVar1 + iVar6 + (uint)bVar17;
        *pcVar10 = *pcVar12 + *pcVar16 + -0x80;
        pcVar10 = pcVar10 + 2;
        sVar8 = sVar8 + -1;
        pcVar12 = pcVar12 + 1;
      } while (sVar8 != -1);
    }
    *piVar15 = iVar6;
    piVar15[1] = uVar7;
    if (piVar13[4] <= iVar14) {
      piVar13 = (int *)piVar13[6];
      iVar14 = piVar13[3];
      *(int **)(iVar4 + -0x598) = piVar13;
      if (iVar4 + -0xc26 == piVar13[2]) {
        _FUN_00000196 = *(undefined4 *)(iVar4 + -0x360);
      }
    }
    *piVar13 = iVar14;
    return CONCAT44(in_D0,in_D1);
  }
  DAT_00003be0 = DAT_00000904;
  return CONCAT44(in_D0,in_D1);
}



/*
 * Original: FUN_00003d36; source: ID02.c:2108.
 * Recovered name: clear_sound_buffer_to_silence [STRONG INFERENCE] (iteration 139).
 * Bytes file 0x3d36..0x3d4e [PROVEN]: MOVEA.L $0266.w,A0 (low-memory SoundBase,
 * Inside Macintosh); 370 iterations (DBRA from 0x171) of MOVE.B #$80,(A0);
 * ADDQ.L #2,A0 - writes the unsigned-8-bit midpoint into the high byte of
 * each word of the 370-word hardware sound buffer.
 * Ghidra error: it replaced the runtime pointer load with the constant
 * &DAT_66fa4e75 (bytes from the file, cf. ID09 selector artifact). Exported
 * expression kept unchanged.
 * Callers: shutdown_sound, FUN_00003dd0.
 */
void clear_sound_buffer_to_silence /* Original: FUN_00003d36 */ (void)

{
  short sVar1;
  undefined1 *puVar2;
  
  puVar2 = &DAT_66fa4e75;
  sVar1 = 0x171;
  do {
    *puVar2 = 0x80;
    puVar2 = puVar2 + 2;
    sVar1 = sVar1 + -1;
  } while (sVar1 != -1);
  return;
}



/*
 * Original: FUN_00003d50; source: ID02.c:2124-2148.
 * Recovered name: alloc_sound_buffer_node [STRONG INFERENCE] (iteration 140).
 * Exported C complete; bytes 0x3d50..0x3db6 agree [PROVEN].
 * Args: ch, buffer ptr, start, end (longs), word repeat/link flag.
 * Pops a node from channel ch's free list (record A5-0x7d0 + ch*0x238, +4 =
 * free head; node +0x14 = next) and fills it: +0 = start (cursor), +4 = 0,
 * +8 = buffer, +0xc = start, +0x10 = end, +0x18 = flag ? node->next : node
 * (flag 0 makes the node loop on itself) [field roles STRONG INFERENCE].
 * No empty-list check. Returns the node.
 * Callers: init_sound_system (2x), silence_sound_channel, and further ID02 sites
 * (14 call sites renamed in total).
 */
undefined4 *
alloc_sound_buffer_node /* Original: FUN_00003d50 */ (int param_1,undefined4 param_2,undefined4 param_3,undefined4 param_4,undefined4 param_5
            )

{
  undefined4 *puVar1;
  undefined4 *puVar2;
  int unaff_A5;
  
  puVar1 = *(undefined4 **)(param_1 * 0x238 + unaff_A5 + -0x7cc);
  *(undefined4 *)(param_1 * 0x238 + unaff_A5 + -0x7cc) = puVar1[5];
  *puVar1 = param_3;
  puVar1[1] = 0;
  puVar1[2] = param_2;
  puVar1[3] = param_3;
  puVar1[4] = param_4;
  puVar2 = puVar1;
  if (param_5._0_2_ != 0) {
    puVar2 = (undefined4 *)puVar1[5];
  }
  puVar1[6] = puVar2;
  return puVar1;
}



// WARNING: Globals starting with '_' overlap smaller symbols at the same address

/*
 * Original: FUN_00003db8; source: ID02.c:2154-2163.
 * Recovered name: select_two_channel_sound_handler [STRONG INFERENCE] (iteration 141).
 * If param == 1: low-memory $0196 (Lvl1DT[1] VBL vector) = A5-0x35c
 * (vbl_sound_handler_two_channel). Otherwise no change. Bytes 0x3db8..0x3dce
 * match the C.
 */
void select_two_channel_sound_handler /* Original: FUN_00003db8 */ (int param_1)

{
  int unaff_A5;
  
  if (param_1 == 1) {
    _FUN_00000196 = *(undefined4 *)(unaff_A5 + -0x35c);
  }
  return;
}



// WARNING: Control flow encountered bad instruction data
// WARNING: Globals starting with '_' overlap smaller symbols at the same address

/*
 * Original: FUN_00003dd0; source: ID02.c:2170-2230.
 * Recovered name: init_sound_system [STRONG INFERENCE] (iteration 140).
 * Exported C kept (truncated at the end); bytes 0x3dd0.. [PROVEN].
 *   if (sound active A5-0xc38) shutdown_sound();
 *   for ch in 0..1: record = A5-0x7d0 + ch*0x238; head (+0), free (+4) and
 *     tail (+0x230) = record+8; 20 nodes of 0x1c bytes from +8, linked via +0x14;
 *   A5-0xc26[0x456] = 0x80 (1110 bytes = 3 x 370 silent samples);
 *   clear_sound_buffer_to_silence();
 *   A5-0xc32 = 1, A5-0xc2e = 0, A5-0xc2a = 0x172 (370);
 *   alloc_sound_buffer_node(0 and 1, A5-0xc26, 0, 0x172, 0)  (looping silence);
 *   A5-0x360 = param ? JT A5+0x412 : JT A5+0x41a;  A5-0x35c = JT A5+0x422;
 *   first time (word A5-0x352 == 0): set it, FUN_00003aae, FUN_000039a8,
 *     FUN_00003bc4;
 *   A5-0xc36 = low-memory long $0196 (saved; restored by shutdown_sound);
 *   $0196 = A5-0x360 (install the selected routine; $0196 = Lvl1DT[1], VBL
 *   level-1 interrupt vector, identified iteration 141);
 *   A5-0x356 = 0; ... (rest truncated by Ghidra).
 * Caller: ID02.c:606 (via a computed stack argument).
 */
void init_sound_system /* Original: FUN_00003dd0 */ (int param_1)

{
  undefined4 unaff_D5;
  short sVar1;
  int iVar2;
  int iVar3;
  undefined1 *puVar4;
  int unaff_A5;
  ushort uVar5;
  
  uVar5 = (ushort)((uint)unaff_D5 >> 0x10);
  if (*(short *)(unaff_A5 + -0xc38) != 0) {
    shutdown_sound(); /* Original: FUN_00004318 */
  }
  for (iVar2 = 0; iVar2 < 2; iVar2 = iVar2 + 1) {
    iVar3 = iVar2 * 0x238 + unaff_A5 + -0x7c8;
    *(int *)(iVar2 * 0x238 + unaff_A5 + -0x5a0) = iVar3;
    *(int *)(iVar2 * 0x238 + unaff_A5 + -0x7cc) = iVar3;
    *(int *)(iVar2 * 0x238 + unaff_A5 + -2000) = iVar3;
    for (sVar1 = 0; sVar1 < 0x13; sVar1 = sVar1 + 1) {
      *(int *)(sVar1 * 0x1c + iVar2 * 0x238 + unaff_A5 + -0x7b4) =
           (short)(sVar1 + 1) * 0x1c + iVar2 * 0x238 + unaff_A5 + -0x7c8;
    }
  }
  puVar4 = (undefined1 *)(unaff_A5 + -0xc26);
  sVar1 = 0x456;
  while (0 < sVar1) {
    *puVar4 = 0x80;
    puVar4 = puVar4 + 1;
    sVar1 = sVar1 + -1;
  }
  clear_sound_buffer_to_silence(); /* Original: FUN_00003d36 */
  *(undefined4 *)(unaff_A5 + -0xc32) = 1;
  *(undefined4 *)(unaff_A5 + -0xc2e) = 0;
  *(undefined4 *)(unaff_A5 + -0xc2a) = 0x172;
  alloc_sound_buffer_node(0,unaff_A5 + -0xc26,0,0x172,(uint)uVar5);
  alloc_sound_buffer_node(1,unaff_A5 + -0xc26,0,0x172,(uint)uVar5);
  if (param_1 == 0) {
    iVar2 = unaff_A5 + 0x41a;
  }
  else {
    iVar2 = unaff_A5 + 0x412;
  }
  *(int *)(unaff_A5 + -0x360) = iVar2;
  *(int *)(unaff_A5 + -0x35c) = unaff_A5 + 0x422;
  if (*(short *)(unaff_A5 + -0x352) == 0) {
    *(undefined2 *)(unaff_A5 + -0x352) = 1;
    vbl_sound_handler_ch0_variant();
    vbl_sound_handler_ch0_unrolled();
    vbl_sound_handler_two_channel();
  }
  *(undefined4 *)(unaff_A5 + -0xc36) = _FUN_00000196;
  _FUN_00000196 = *(undefined4 *)(unaff_A5 + -0x360);
  *(undefined4 *)(unaff_A5 + -0x356) = 0;
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



/*
 * Original: FUN_00003f54; source: ID02.c:2231-2260.
 * Recovered name: play_sample_on_channel [STRONG INFERENCE] (iteration 142).
 * Exported C complete. Args: ch, sample buffer, start, end, loop_start,
 * loop_end (longs). CurrentA5 routine (DAT_00000904). Overlay service slot
 * A5-0x10de (JT $442).
 * Returns 0 if sound inactive (A5-0xc38 == 0) or ch outside 0..1. Otherwise:
 *   loop_start < loop_end: nodes [start, loop_start) -> [loop_start, loop_end)
 *     (flag 0: repeats itself) -> [loop_end, end);
 *   else: [start, end) -> looping silence (A5-0xc26, 0, 0x172);
 *   select_two_channel_sound_handler(ch); channel ch head (A5-0x7d0 +
 *   ch*0x238) = first node; returns 1.
 * Ghidra's CONCAT22(1, ...) is the word flag 1 pushed for linked nodes.
 * Note the third (tail) node is only reached if the loop node is later
 * re-linked [HYPOTHESIS: sustain loop with release tail].
 */
undefined4
play_sample_on_channel /* Original: FUN_00003f54 */ (int param_1,undefined4 param_2,undefined4 param_3,undefined4 param_4,uint param_5,
            uint param_6)

{
  int iVar1;
  undefined4 uVar2;
  undefined4 unaff_D2;
  ushort uVar3;
  undefined4 local_8;
  
  iVar1 = DAT_00000904;
  uVar3 = (ushort)((uint)unaff_D2 >> 0x10);
  if (((*(short *)(DAT_00000904 + -0xc38) == 0) || (param_1 < 0)) || (1 < param_1)) {
    uVar2 = 0;
  }
  else {
    if (param_5 < param_6) {
      local_8 = alloc_sound_buffer_node(param_1,param_2,param_3,param_5,CONCAT22(1,uVar3));
      alloc_sound_buffer_node(param_1,param_2,param_5,param_6,(uint)uVar3);
      alloc_sound_buffer_node(param_1,param_2,param_6,param_4,CONCAT22(1,uVar3));
    }
    else {
      local_8 = alloc_sound_buffer_node(param_1,param_2,param_3,param_4,CONCAT22(1,uVar3));
      alloc_sound_buffer_node(param_1,iVar1 + -0xc26,0,0x172,(uint)uVar3);
    }
    select_two_channel_sound_handler(param_1);
    *(undefined4 **)(param_1 * 0x238 + iVar1 + -2000) = local_8;
    uVar2 = 1;
  }
  return uVar2;
}



/*
 * Original: FUN_00004050; source: ID02.c:2266-2296.
 * Recovered name: enqueue_sample_on_channel [STRONG INFERENCE mechanics /
 * HYPOTHESIS purpose] (iteration 143).
 * Exported C complete; identical to play_sample_on_channel except that it does
 * NOT store the first node into the channel head (A5-0x7d0 + ch*0x238). Nodes
 * are allocated in free-list order with continuation = next free node, so the
 * new chain is only reached if the currently playing chain continues into the
 * free-list head [HYPOTHESIS; not verified against handler end-of-buffer code].
 * Returns 0 if sound inactive or ch outside 0..1, else 1 (after
 * select_two_channel_sound_handler(ch)). Overlay service slot A5-0x10da (JT $42a).
 */
undefined4
enqueue_sample_on_channel /* Original: FUN_00004050 */ (int param_1,undefined4 param_2,undefined4 param_3,undefined4 param_4,uint param_5,
            uint param_6)

{
  int iVar1;
  undefined4 uVar2;
  undefined4 unaff_D2;
  ushort uVar3;
  
  iVar1 = DAT_00000904;
  uVar3 = (ushort)((uint)unaff_D2 >> 0x10);
  if (((*(short *)(DAT_00000904 + -0xc38) == 0) || (param_1 < 0)) || (1 < param_1)) {
    uVar2 = 0;
  }
  else {
    if (param_5 < param_6) {
      alloc_sound_buffer_node(param_1,param_2,param_3,param_5,CONCAT22(1,uVar3));
      alloc_sound_buffer_node(param_1,param_2,param_5,param_6,(uint)uVar3);
      alloc_sound_buffer_node(param_1,param_2,param_6,param_4,CONCAT22(1,uVar3));
    }
    else {
      alloc_sound_buffer_node(param_1,param_2,param_3,param_4,CONCAT22(1,uVar3));
      alloc_sound_buffer_node(param_1,iVar1 + -0xc26,0,0x172,(uint)uVar3);
    }
    select_two_channel_sound_handler(param_1);
    uVar2 = 1;
  }
  return uVar2;
}



/*
 * Original: FUN_0000412e; source: ID02.c:2299-2317.
 * Recovered name: set_sound_playback_rate [STRONG INFERENCE] (iteration 144).
 * Overlay service slot A5-0x10d6 (JT $452).
 * Exported C complete. CurrentA5 routine; no effect while sound inactive.
 * param_1 = rate, 16.16 fixed point, clamped to [0x8000, 0x30000] (0.5x..3.0x).
 *   A5-0xc2a = rate * 370 >> 16   samples consumed per VBL refill
 *   A5-0xc2e = rate << 16         fractional step (low 16 bits of rate)
 *   A5-0xc32 = rate >> 16         integer step
 * These are the 32.32 step and length read by the VBL handlers. Unsigned
 * arithmetic; rate * 0x172 cannot overflow for the clamped range.
 */
void set_sound_playback_rate /* Original: FUN_0000412e */ (uint param_1)

{
  int iVar1;
  
  iVar1 = DAT_00000904;
  if (*(short *)(DAT_00000904 + -0xc38) != 0) {
    if (param_1 < 0x8000) {
      param_1 = 0x8000;
    }
    else if (0x30000 < param_1) {
      param_1 = 0x30000;
    }
    *(uint *)(DAT_00000904 + -0xc2a) = param_1 * 0x172 >> 0x10;
    *(uint *)(iVar1 + -0xc2e) = param_1 << 0x10;
    *(uint *)(iVar1 + -0xc32) = param_1 >> 0x10;
  }
  return;
}



/*
 * Original: FUN_000041a6; source: ID02.c:2321-2340.
 * Recovered name: release_channel_loop [STRONG INFERENCE] (iteration 144).
 * Overlay service slot A5-0x10ce (JT $44a).
 * Exported C complete. For ch 0..1 while sound active:
 *   n = alloc_sound_buffer_node(ch, silence A5-0xc26, 0, 0x172, 0) (self-looping
 *   silence); free head (+4) = n->next; for each node from the channel head
 *   (+0) along +0x14 until n: continuation (+0x18) = next (+0x14).
 * Breaks any self-looping (sustain) node so playback proceeds through the
 * remaining nodes into the new silence node [STRONG INFERENCE]. Resolves the
 * sustain-release question in docs/SOUND_SYSTEM.md. Ghidra's unaff_A3 is the
 * pushed word 0 (artifact).
 */
void release_channel_loop /* Original: FUN_000041a6 */ (int param_1)

{
  int iVar1;
  undefined4 *puVar2;
  uint unaff_A3;
  undefined4 *puVar3;
  
  iVar1 = DAT_00000904;
  if (((*(short *)(DAT_00000904 + -0xc38) != 0) && (-1 < param_1)) && (param_1 < 2)) {
    puVar2 = alloc_sound_buffer_node(param_1,DAT_00000904 + -0xc26,0,0x172,unaff_A3 >> 0x10);
    *(undefined4 *)(param_1 * 0x238 + iVar1 + -0x7cc) = puVar2[5];
    for (puVar3 = *(undefined4 **)(param_1 * 0x238 + iVar1 + -2000); puVar3 != puVar2;
        puVar3 = (undefined4 *)puVar3[5]) {
      puVar3[6] = puVar3[5];
    }
  }
  return;
}



/*
 * Original: FUN_00004242; source: ID02.c:2343.
 * Recovered name: silence_sound_channel [STRONG INFERENCE] (iteration 139).
 * Bytes file 0x4242..0x42ae match the C [PROVEN]: CurrentA5 thunk; if (sound
 * active word A5-0xc38 && 0 <= ch < 2) channel_record[ch] (0x238 bytes each at
 * A5-0x7d0) +0 = FUN_00003d50(ch, A5-0xc26, 0, 0x172, 0) - queues a 370-sample
 * buffer from A5-0xc26 (silence [HYPOTHESIS]). Ghidra's unaff_A4 argument is
 * the word 0 pushed by CLR.W (artifact). shutdown_sound also passes ch = 2,
 * which the bounds check ignores. Service slot A5-0x10ca (JT $432).
 */
void silence_sound_channel /* Original: FUN_00004242 */ (int param_1)

{
  int iVar1;
  undefined4 *puVar2;
  uint unaff_A4;
  
  iVar1 = DAT_00000904;
  if (((*(short *)(DAT_00000904 + -0xc38) != 0) && (-1 < param_1)) && (param_1 < 2)) {
    puVar2 = alloc_sound_buffer_node(param_1,DAT_00000904 + -0xc26,0,0x172,unaff_A4 >> 0x10);
    *(undefined4 **)(param_1 * 0x238 + iVar1 + -2000) = puVar2;
  }
  return;
}



/*
 * Original: FUN_000042b0; source: ID02.c:2360-2374.
 * Recovered name: is_channel_playing [STRONG INFERENCE] (iteration 144).
 * Overlay service slot A5-0x10d2 (JT $43a).
 * Exported C complete. Returns 0 if sound inactive or ch outside 0..1;
 * else (word) current node's buffer (+8) != silence buffer A5-0xc26. The upper
 * word in Ghidra's CONCAT22 is register residue, not meaningful.
 */
undefined4 is_channel_playing /* Original: FUN_000042b0 */ (int param_1)

{
  undefined4 uVar1;
  
  if (((*(short *)(DAT_00000904 + -0xc38) == 0) || (param_1 < 0)) || (1 < param_1)) {
    uVar1 = 0;
  }
  else {
    uVar1 = CONCAT22((short)((uint)(param_1 * 0x238) >> 0x10),
                     (short)(DAT_00000904 + -0xc26 !=
                            *(int *)(*(int *)(param_1 * 0x238 + DAT_00000904 + -2000) + 8)));
  }
  return uVar1;
}



// WARNING: Control flow encountered bad instruction data
// WARNING: Globals starting with '_' overlap smaller symbols at the same address

/*
 * Original: FUN_00004318; source: ID02.c:2381-2394.
 * Recovered name: shutdown_sound [STRONG INFERENCE] (iteration 138).
 * Bytes file 0x4318..0x435c [PROVEN]: if (word A5-0xc38 sound active) {
 *   silence_sound_channel(0/1/2) (FUN_00004242) [service slot -0x10ca;
 *   per-channel stop, HYPOTHESIS]; long low-memory $0196 = A5-0xc36 (restore
 *   a saved value; Ghidra: _FUN_00000196); clear_sound_buffer_to_silence() (FUN_00003d36);
 *   SndDisposeChannel(A5-0x356, true) ($A801; result discarded); A5-0xc38 = 0 }.
 * Callers: fatal_memory_error_exit, ID02.c:2537. Low-memory $0196 = Lvl1DT[1]
 * (VBL interrupt vector) restored to the pre-game handler.
 */
void shutdown_sound /* Original: FUN_00004318 */ (void)

{
  int unaff_A5;
  
  if (*(short *)(unaff_A5 + -0xc38) != 0) {
    silence_sound_channel( /* Original: FUN_00004242 */ 0);
    silence_sound_channel( /* Original: FUN_00004242 */ 1);
    silence_sound_channel( /* Original: FUN_00004242 */ 2);
    _FUN_00000196 = *(undefined4 *)(unaff_A5 + -0xc36);
    clear_sound_buffer_to_silence(); /* Original: FUN_00003d36 */
                    // WARNING: Bad instruction - Truncating control flow here
    halt_baddata();
  }
  return;
}



// WARNING: Control flow encountered bad instruction data

void FUN_0000435e(int param_1)

{
  int unaff_A5;
  
  if ((short)((*(short *)(unaff_A5 + -0x167c) - *(short *)(unaff_A5 + -0x1680)) - DAT_00000baa) <
      (short)(*(short *)(param_1 + 0x14) - *(short *)(param_1 + 0x10))) {
                    // WARNING: Bad instruction - Truncating control flow here
    halt_baddata();
  }
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



// WARNING: Control flow encountered bad instruction data

void FUN_0000442e(void)

{
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



// WARNING: Control flow encountered bad instruction data

void FUN_00004582(void)

{
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



// WARNING: Control flow encountered bad instruction data

void FUN_00004610(void)

{
  int unaff_A5;
  
  if (*(int *)(unaff_A5 + -0x14ca) != 0) {
                    // WARNING: Bad instruction - Truncating control flow here
    halt_baddata();
  }
  return;
}



// WARNING: Control flow encountered bad instruction data

void FUN_0000462c(void)

{
  int unaff_A5;
  
  if (*(short *)(unaff_A5 + -0x137a) != *(short *)(unaff_A5 + -0x2cc)) {
    *(undefined2 *)(unaff_A5 + -0x2cc) = 0;
    if (*(short *)(unaff_A5 + -0x137a) == 4) {
                    // WARNING: Bad instruction - Truncating control flow here
      halt_baddata();
    }
    if (*(short *)(unaff_A5 + -0x137a) == 8) {
                    // WARNING: Bad instruction - Truncating control flow here
      halt_baddata();
    }
    if (*(short *)(unaff_A5 + -0x137a) == 1) {
      *(int *)(unaff_A5 + -0x14a6) = unaff_A5 + -800;
      *(undefined2 *)(unaff_A5 + -0x14a2) = 5;
      *(undefined2 *)(unaff_A5 + -0x2cc) = 1;
    }
  }
  return;
}



/*
 * Original: FUN_000046b4; source: ID02.c:2484-2506.
 * Recovered name: rebuild_all_palette_index_maps [STRONG INFERENCE] (iteration 131).
 * Bytes file 0x46b4..0x4736 match the C [PROVEN]: clears collision flag
 * A5-0x102a; B&W (A5-0x137a == 1) -> FUN_00004b62(); else if depth word
 * A5-0x2cc != 0: if long A5-0x103a, close_and_dispose_port(A5-0x103a) and clear it;
 * for slot 1..3 used: build_palette_index_map(slot, &start, slot.stored (+4),
 * scratch -$204(A6)). Ghidra's CONCAT22 call lost the last three arguments.
 * Called from the stub at file 0x4d24 (with 0x462c and callback A5-0x10a2).
 */
void rebuild_all_palette_index_maps /* Original: FUN_000046b4 */ (void)

{
  int unaff_A5;
  undefined1 auStack_8 [2];
  short local_6;
  
  *(undefined2 *)(unaff_A5 + -0x102a) = 0;
  if (*(short *)(unaff_A5 + -0x137a) == 1) {
    FUN_00004b62();
  }
  else if (*(short *)(unaff_A5 + -0x2cc) != 0) {
    if (*(int *)(unaff_A5 + -0x103a) != 0) {
      close_and_dispose_port(); /* Original: FUN_00000d24 */
      *(undefined4 *)(unaff_A5 + -0x103a) = 0;
    }
    for (local_6 = 1; local_6 < 4; local_6 = local_6 + 1) {
      if (*(int *)(local_6 * 0x16 + unaff_A5 + -0x136e) != 0) {
        build_palette_index_map(CONCAT22(local_6,(short)((uint)auStack_8 >> 0x10)));
      }
    }
  }
  return;
}



// WARNING: Control flow encountered bad instruction data
// WARNING: Removing unreachable block (ram,0x000047c6)
// WARNING: Removing unreachable block (ram,0x0000478a)
// WARNING: Removing unreachable block (ram,0x00004790)
// WARNING: Removing unreachable block (ram,0x0000481c)
// WARNING: Removing unreachable block (ram,0x00004822)
// WARNING: Removing unreachable block (ram,0x00004864)
// WARNING: Removing unreachable block (ram,0x0000486a)

/*
 * Original: FUN_00004738; source: ID02.c:2520-2532.
 * Recovered name: configure_palette_entries [STRONG INFERENCE] (iteration 131).
 * Bytes file 0x4738..0x4888 [PROVEN; Palette Manager traps per Inside Macintosh]:
 *   depth (word param) == 4, palette A5-0x14ae:
 *     entries 8..12: SetEntryUsage(pal, e, 2 pmTolerant, 0) $AA9E;
 *                    SetEntryColor(pal, e, &rgb A5-0x320[e-8]) $AA9C
 *     entries 0..7 : SetEntryUsage(pal, e, 0 pmCourteous, 0x1000);
 *                    SetEntryColor(pal, e, &rgb A5-0x350[e])
 *   depth == 8, palette A5-0x14aa:
 *     entries 0xd0..0xd8: tolerant, colours A5-0x302[];
 *     entries 0xc8..0xcf: tolerant, colours A5-0x350[];
 *     entries 0..0xc7   : SetEntryUsage(pal, e, 4 pmAnimated, 0)
 *   RGBColor entries are 6 bytes. Callers not yet located.
 */
void configure_palette_entries /* Original: FUN_00004738 */ (undefined4 param_1)

{
  if (param_1._0_2_ == 4) {
                    // WARNING: Bad instruction - Truncating control flow here
    halt_baddata();
  }
  if (param_1._0_2_ != 8) {
    return;
  }
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



/*
 * Original: FUN_0000488a; source: ID02.c:2536-2545.
 * Recovered name: clear_ctab_size_callback [STRONG INFERENCE] (iteration 131).
 * Bytes file 0x488a..0x48ac [PROVEN]: saves A5/D2, loads A5 from low-memory
 * CurrentA5 ($0904) - i.e. callable from a context where A5 is not the
 * application's -, clears word +6 of the record at long A5-0x14b2 (the
 * NewPtrClear colour-table block from initialize_application; +6 = ctSize
 * [HYPOTHESIS]), restores A5/D2. Installed as function pointer A5-0x1122 via
 * JT A5+0x46a by build_palette_index_map when palette indices collide.
 * Iteration 145: it is the 'discard' alternative to apply_pending_color_entries_a5safe
 * (FUN_00000c68, SetEntries) normally installed in that slot.
 */
void clear_ctab_size_callback /* Original: FUN_0000488a */ (void)

{
  *(undefined2 *)(*(int *)(DAT_00000904 + -0x14b2) + 6) = 0;
  return;
}



// WARNING: Control flow encountered bad instruction data

/*
 * Original: FUN_000048ae; source: ID02.c:2547.
 * Recovered name: build_palette_index_map [STRONG INFERENCE] (iteration 130).
 * Status: RENAMED; Ghidra truncated after the empty-slot test. Bytes file
 * 0x48ae..0x49fc [PROVEN]. Args: word slot [8], short *start [$a],
 * short *map [$e], short *inverse [$12]; returns word limit.
 *   if (!device_table[slot].handle (A5-0x136e + 0x16*slot)) return 0;
 *   front_is_main = (FrontWindow() $A924 == main_window)  [stored, unused here]
 *   saved = GetGDevice() $AA32; SetGDevice(slot handle) $AA31;
 *   clear count[256] (local -$208) and inverse[256];
 *   depth word A5-0x2cc: 4 -> limit 13, 8 -> limit 217 (0xd9); *start = 0;
 *     [other depths: limit -6(A6) uninitialised - preserved, UNKNOWN effect]
 *   for (i = 0; i < limit; i++) {
 *     PmForeColor(i) $AA97;  idx = low word of thePort->fgColor (+0x52;
 *     thePort pointer at A5-0x160c);
 *     map[i] = idx; inverse[idx] = i;
 *     if (count[idx] && depth == 8 && i < 200) word A5-0x102a = 1;  collision
 *     count[idx]++;
 *   }
 *   SetGDevice(saved);
 *   long A5-0x1122 = A5-0x102a ? A5+0x46a (JT -> ID02 file 0x488a)
 *                              : A5+0x33a (JT -> ID02 file 0xc68);
 *   return limit.
 * Interpretation [STRONG INFERENCE]: maps palette entries to actual device
 * pixel values (and back); a collision selects an alternate routine via the
 * function pointer A5-0x1122. Traps per Inside Macintosh (Palette Manager).
 * Callers: check_device_color_state_changed (2x), FUN_000046b4.
 */
undefined4 build_palette_index_map /* Original: FUN_000048ae */ (undefined4 param_1)

{
  int unaff_A5;
  
  if (*(int *)(param_1._0_2_ * 0x16 + unaff_A5 + -0x136e) == 0) {
    return 0;
  }
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



/*
 * Original: FUN_000049fe; source: ID02.c:2561-2632.
 * Recovered name: lookup_palette_index_for_rgb_level [STRONG INFERENCE] (iteration 132).
 * Status: RENAMED. Exported C kept verbatim (bytes file 0x49fe.. agree for the
 * scaling prologue). Args: three words r, g, b at 8/$a/$c(A6) (Ghidra packs
 * them as param_1 hi/lo and param_2 hi).
 * Each level is scaled: v = level << 6, 0x100 clamped to 0xff, then << 8
 * (16-bit RGB component; levels 0..4 -> 0x0000, 0x4000, 0x8000, 0xc000, 0xff00).
 * Search 1: 8 RGBColor entries at A5-0x350 (6 bytes each) -> index 0..7.
 * Search 2: table *(long A5-0x14a6), count word A5-0x14a2 -> index 8 + n.
 * Not found: -1. Result by mode word A5-0x137a: 1 or 4 -> index;
 * 8 -> index + 200 (the 0xc8+ palette entries set by configure_palette_entries);
 * other modes return the leftover register value (preserved, UNKNOWN).
 * Callers: FUN_00004b62 (9 calls; not decompiled by Ghidra, see note below it).
 */
undefined4 lookup_palette_index_for_rgb_level /* Original: FUN_000049fe */ (undefined4 param_1,undefined4 param_2)

{
  short sVar1;
  short *psVar2;
  int iVar3;
  undefined2 uVar4;
  short sVar6;
  undefined4 uVar5;
  int unaff_A5;
  undefined2 local_8;
  undefined2 local_6;
  
  sVar6 = param_1._0_2_ << 6;
  param_1._0_2_ = sVar6;
  if (sVar6 == 0x100) {
    param_1._0_2_ = 0xff;
  }
  param_1._2_2_ = param_1._2_2_ << 6;
  if (param_1._2_2_ == 0x100) {
    param_1._2_2_ = 0xff;
  }
  sVar6 = param_2._0_2_ << 6;
  if (sVar6 == 0x100) {
    sVar6 = 0xff;
  }
  uVar5 = 0xffffffff;
  local_8 = -1;
  for (local_6 = 0; local_6 < 8; local_6 = local_6 + 1) {
    sVar1 = *(short *)(local_6 * 6 + unaff_A5 + -0x350);
    uVar5 = CONCAT22((short)((uint)(local_6 * 6) >> 0x10),sVar1);
    if (((sVar1 == (short)(param_1._0_2_ << 8)) &&
        (sVar1 = *(short *)(local_6 * 6 + unaff_A5 + -0x34e),
        uVar5 = CONCAT22((short)((uint)(local_6 * 6) >> 0x10),sVar1),
        sVar1 == (short)(param_1._2_2_ << 8))) &&
       (sVar1 = *(short *)(local_6 * 6 + unaff_A5 + -0x34c),
       uVar5 = CONCAT22((short)((uint)(local_6 * 6) >> 0x10),sVar1), sVar1 == (short)(sVar6 << 8)))
    {
      local_8 = local_6;
      break;
    }
  }
  if (local_8 == -1) {
    for (local_6 = 0; uVar5 = CONCAT22((short)((uint)uVar5 >> 0x10),local_6),
        local_6 < *(short *)(unaff_A5 + -0x14a2); local_6 = local_6 + 1) {
      psVar2 = (short *)(*(int *)(unaff_A5 + -0x14a6) + local_6 * 6);
      sVar1 = *psVar2;
      uVar5 = CONCAT22((short)((uint)psVar2 >> 0x10),sVar1);
      if ((sVar1 == (short)(param_1._0_2_ << 8)) &&
         (iVar3 = *(int *)(unaff_A5 + -0x14a6) + local_6 * 6, sVar1 = *(short *)(iVar3 + 2),
         uVar5 = CONCAT22((short)((uint)iVar3 >> 0x10),sVar1), sVar1 == (short)(param_1._2_2_ << 8))
         ) {
        iVar3 = *(int *)(unaff_A5 + -0x14a6) + local_6 * 6;
        sVar1 = *(short *)(iVar3 + 4);
        uVar4 = (undefined2)((uint)iVar3 >> 0x10);
        uVar5 = CONCAT22(uVar4,sVar1);
        if (sVar1 == (short)(sVar6 << 8)) {
          local_8 = local_6 + 8;
          uVar5 = CONCAT22(uVar4,local_8);
          break;
        }
      }
    }
  }
  uVar4 = (undefined2)((uint)uVar5 >> 0x10);
  if ((*(short *)(unaff_A5 + -0x137a) == 4) || (*(short *)(unaff_A5 + -0x137a) == 1)) {
    uVar5 = CONCAT22(uVar4,local_8);
  }
  else if (*(short *)(unaff_A5 + -0x137a) == 8) {
    uVar5 = CONCAT22(uVar4,local_8 + 200);
  }
  return uVar5;
}


/*
 * FUN_00004b62 (iteration 132): proposed name init_standard_colour_indices
 * [STRONG INFERENCE]. Not decompiled by Ghidra, not in the inventory; no C
 * body. Bytes file 0x4b62..0x4c16 [PROVEN]: nine calls
 * lookup_palette_index_for_rgb_level(l, l, l) storing the word result:
 *   (3,3,3) -> A5-0x11ae   (0,0,0) -> A5-0x11ac   (0,0,0) -> A5-0x118c
 *   (3,3,3) -> A5-0x1188   (2,2,2) -> A5-0x118a   (3,3,3) -> A5-0x117c
 *   (0,0,0) -> A5-0x117e   (3,3,3) -> A5-0x11fa   (1,1,1) -> A5-0x11f8
 * i.e. grey levels 0xc000 / black / 0x8000 / 0x4000 resolved to palette indices
 * for UI drawing. Callers: rebuild_all_palette_index_maps and
 * check_device_color_state_changed (B&W / mode-1 path).
 */
/*
Unable to decompile 'FUN_00004b62'
Cause: 
Low-level Error: Symbol $$undef00000003 extends beyond the end of the address space
*/


/*
 * Original: FUN_00004c18; source: ID02.c:2643-2688.
 * Recovered name: check_device_color_state_changed [STRONG INFERENCE on
 * structure / HYPOTHESIS on purpose] (iteration 129).
 * Exported C is complete and matches bytes file 0x4c18..0x4d22 [PROVEN].
 * - Clears word A5-0x102a and local "changed" flag (local_e).
 * - If word A5-0x137a == 1: FUN_00004b62() only (likely 1-bit / B&W path).
 * - Else for slot i = 1..3 of the 0x16-byte table at A5-0x136e (+0 long
 *   = device handle, +4 long = stored word array):
 *     if slot used: count = build_palette_index_map(i, &start, fresh, scratch);
 *       compare fresh[start..count) with stored[]; on first difference mark
 *       changed; then if i == 1 call JT $182 (seg 3 file 0x6c1c)
 *       (A5-0x1354, fresh), and build_palette_index_map(i, &start, stored, scratch)
 *       refreshes the stored copy.
 * - If anything changed and the overlay is loaded (A5-0x1006): call the
 *   overlay callback A5-0x1096 (same slot as in apply_settings_to_live_options).
 * build_palette_index_map (FUN_000048ae; see its header): returns 0 for an empty slot; otherwise
 * FrontWindow == main_window flag, saves GetGDevice ($AA32), SetGDevice
 * ($AA31) to the slot handle, clears two 256-word buffers, picks start
 * index 0x0d / 0xd9 when word A5-0x2cc == 4 / 8 [rest not yet decoded].
 * [HYPOTHESIS] Detects palette / colour-table changes on up to three
 * screens (e.g. after a desk accessory) and lets the overlay re-sync colours.
 * Caller: redraw_main_window (BSR at file 0x4df0).
 */
void check_device_color_state_changed /* Original: FUN_00004c18 */ (void)

{
  undefined4 uVar1;
  int unaff_A5;
  short asStack_20e [256];
  short local_e;
  short local_c;
  short local_a;
  short local_8;
  short local_6;
  
  local_e = 0;
  *(undefined2 *)(unaff_A5 + -0x102a) = 0;
  if (*(short *)(unaff_A5 + -0x137a) == 1) {
    FUN_00004b62();
  }
  else {
    for (local_6 = 1; local_6 < 4; local_6 = local_6 + 1) {
      if (*(int *)(local_6 * 0x16 + unaff_A5 + -0x136e) != 0) {
        uVar1 = build_palette_index_map(CONCAT22(local_6,(short)((uint)&local_8 >> 0x10)));
        local_a = (short)uVar1;
        local_c = 0;
        for (; local_8 < (short)uVar1; local_8 = local_8 + 1) {
          if (asStack_20e[local_8] !=
              *(short *)(*(int *)(local_6 * 0x16 + unaff_A5 + -0x136a) + local_8 * 2)) {
            local_e = 1;
            local_c = 1;
            break;
          }
        }
        if (local_c != 0) {
          if (local_6 == 1) {
            (**(code **)(unaff_A5 + 0x182))(*(undefined4 *)(unaff_A5 + -0x1354),asStack_20e);
          }
          build_palette_index_map(CONCAT22(local_6,(short)((uint)&local_8 >> 0x10)));
        }
      }
    }
    if ((local_e != 0) && (*(int *)(unaff_A5 + -0x1006) != 0)) {
      (**(code **)(unaff_A5 + -0x1096))();
    }
  }
  return;
}



// WARNING: Control flow encountered bad instruction data

void FUN_00004d34(void)

{
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



// WARNING: Control flow encountered bad instruction data

void FUN_00004d6a(int param_1)

{
  int unaff_A5;
  
  if ((*(short *)(unaff_A5 + -0x14c6) != 0) &&
     (*(int *)(param_1 + 2) == *(int *)(unaff_A5 + -0x14ca))) {
                    // WARNING: Bad instruction - Truncating control flow here
    halt_baddata();
  }
  return;
}



// WARNING: Control flow encountered bad instruction data

/*
 * Original: FUN_00004db0; source: ID02.c:2721-2736 (last function of ID02;
 * segment ends at file 0x4e1a).
 * Recovered name: redraw_main_window [STRONG INFERENCE] (iteration 128).
 * Status: RENAMED. Exported C kept; Ghidra truncated after the -0x12ea fix-up
 * at A-line $A852. Bytes file 0x4db0..0x4e18 [PROVEN]:
 *   tmp = (word A5-0x12d4 && word A5-0x1032) -> -4(A6)  [stored, never read;
 *         Ghidra correctly dropped it as dead]
 *   if (A5-0x14c6 redraw enabled && A5-0x1006 overlay loaded && word A5-0x12f8) {
 *     if (live option A5-0x12ea == 0) { A5-0x103c = 0; A5-0x12ea = 1; }
 *     HideCursor $A852;
 *     BSR 0x4c18 (check_device_color_state_changed, FUN_00004c18);
 *     UnloadSeg(JT $18a = segment 3 entry) $A9F1;
 *     (*(code **)(A5-0x109e))();      overlay-side callback [UNKNOWN target]
 *     BSR 0x4d96 [not a Ghidra function]; FUN_00000930(0, 1) (BSR 0x930);
 *     BSR 0xa26 [not a Ghidra function]; ShowCursor $A853;
 *   }
 * Callers: poll_and_dispatch_event (updateEvt, between Begin/EndUpdate),
 * apply_settings_to_live_options (after an option-change callback).
 * [HYPOTHESIS] Renders the game view into the main window through the overlay.
 */
void redraw_main_window /* Original: FUN_00004db0 */ (void)

{
  int unaff_A5;
  
  if (((*(short *)(unaff_A5 + -0x14c6) != 0) && (*(int *)(unaff_A5 + -0x1006) != 0)) &&
     (*(short *)(unaff_A5 + -0x12f8) != 0)) {
    if (*(short *)(unaff_A5 + -0x12ea) == 0) {
      *(undefined2 *)(unaff_A5 + -0x103c) = *(undefined2 *)(unaff_A5 + -0x12ea);
      *(undefined2 *)(unaff_A5 + -0x12ea) = 1;
    }
                    // WARNING: Bad instruction - Truncating control flow here
    halt_baddata();
  }
  return;
}


