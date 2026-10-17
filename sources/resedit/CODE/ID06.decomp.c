typedef unsigned char   undefined;

typedef unsigned char    bool;
typedef unsigned int    uint;
typedef unsigned short    undefined2;
typedef unsigned int    undefined4;
typedef unsigned char    byte;


uint DAT_000003ae;
uint DAT_000003ba;
int *DAT_000003be;
int *DAT_000003c2;
int *DAT_000003c6;
int *DAT_000003d2;
int *DAT_0000039e;
int DAT_000003a2;
int DAT_000003a6;
int DAT_000003aa;
uint DAT_000003b2;
uint DAT_000003b6;
uint *DAT_000003ca;
int *DAT_000003ce;
int DAT_00000904;

/*
 * Original: FUN_00000004; source: ID06.c:26.
 * Recovered name: init_pattern_tables [STRONG INFERENCE] (iteration 158).
 * Exported C complete. Fills the 0xc00-byte table at *(long A5-0x1eda):
 *   bytes 0x000..0x3ff: 32 left masks (0, 0x80000000, 0xc0000000, ... each
 *     written to 8 consecutive longs) - partial-word masks indexed by the span
 *     renderer with (x >> 6) & 0x3e0;
 *   bytes 0x400..0xbff: 64 patterns x 8 rows from the 8-byte patterns at
 *     A5-0x1ed6, each byte replicated into a long;
 * and the 256-word map at *(long A5-0x1ede): map[i] = ((i >> 4) * -4 + 0x3f)
 *   * 0x20 + 0x400 (16 grey levels -> pattern offsets). Returns 1.
 */
undefined4 init_pattern_tables /* Original: FUN_00000004 */ (void)

{
  undefined1 uVar1;
  undefined2 uVar2;
  uint uVar3;
  short sVar4;
  short sVar5;
  uint *puVar6;
  int unaff_A5;
  
  puVar6 = *(uint **)(unaff_A5 + -0x1eda);
  uVar3 = 0;
  for (sVar5 = 0; sVar5 < 0x20; sVar5 = sVar5 + 1) {
    for (sVar4 = 0; sVar4 < 8; sVar4 = sVar4 + 1) {
      *puVar6 = uVar3;
      puVar6 = puVar6 + 1;
    }
    uVar3 = uVar3 >> 1 | 0x80000000;
  }
  for (sVar5 = 0; sVar5 < 0x40; sVar5 = sVar5 + 1) {
    for (sVar4 = 0; sVar4 < 8; sVar4 = sVar4 + 1) {
      uVar1 = *(undefined1 *)(unaff_A5 + -0x1ed6 + (int)(short)(sVar4 + sVar5 * 8));
      uVar2 = CONCAT11(uVar1,uVar1);
      *puVar6 = CONCAT22(uVar2,uVar2);
      puVar6 = puVar6 + 1;
    }
  }
  for (sVar5 = 0; sVar5 < 0x100; sVar5 = sVar5 + 1) {
    *(short *)(*(int *)(unaff_A5 + -0x1ede) + sVar5 * 2) = ((sVar5 >> 4) * -4 + 0x3f) * 0x20 + 0x400
    ;
  }
  return 1;
}



/*
 * Original: FUN_000000b0; source: ID06.c:63.
 * Recovered name: alloc_pattern_tables [STRONG INFERENCE] (iteration 158).
 * Exported C complete: allocates (once) A5-0x1eda = alloc_aligned_clear(0xc00)
 * and A5-0x1ede = alloc_aligned_clear(0x200); returns init_pattern_tables()
 * or 0 on failure. Called first by init_raster_target.
 */
undefined4 alloc_pattern_tables /* Original: FUN_000000b0 */ (void)

{
  uint uVar1;
  undefined4 uVar2;
  int unaff_A5;
  
  if (*(int *)(unaff_A5 + -0x1eda) == 0) {
    uVar1 = alloc_aligned_clear(0xc00);
    *(uint *)(unaff_A5 + -0x1eda) = uVar1;
    if (uVar1 == 0) {
      return 0;
    }
  }
  if (*(int *)(unaff_A5 + -0x1ede) == 0) {
    uVar1 = alloc_aligned_clear(0x200);
    *(uint *)(unaff_A5 + -0x1ede) = uVar1;
    if (uVar1 == 0) {
      return 0;
    }
  }
  uVar2 = init_pattern_tables();
  return uVar2;
}



/*
 * Original: FUN_000000f4; source: ID06.c:90.
 * Recovered name: get_pattern_table [STRONG INFERENCE] (iteration 158).
 * Exported C complete: ensures A5-0x1eda is allocated and returns it (stored
 * as raster target +0xc by init_raster_target).
 */
undefined4 get_pattern_table /* Original: FUN_000000f4 */ (void)

{
  uint uVar1;
  int unaff_A5;
  
  if (*(int *)(unaff_A5 + -0x1eda) == 0) {
    uVar1 = alloc_aligned_clear(0xc00);
    *(uint *)(unaff_A5 + -0x1eda) = uVar1;
    if (uVar1 == 0) {
      return 0;
    }
  }
  return *(undefined4 *)(unaff_A5 + -0x1eda);
}



/*
 * Original: FUN_00000116; source: ID06.c:108.
 * Recovered name: rgb_to_bw_pattern [STRONG INFERENCE] (iteration 157).
 * Exported C complete. Words r = param_1 high, g = param_1 low, b = param_2
 * high (16-bit components; only their high bytes are used).
 * luma = ((r>>8)*0x13 + (g>>8)*0x26 + (b>>8)*7) >> 6  (19/38/7 out of 64:
 * the usual 0.30/0.59/0.11 weights); returns A5-0x1ed6 + (0x3f - (luma>>2)) * 8,
 * i.e. an 8-byte pattern chosen by inverse brightness (64 levels) for 1-bit
 * output [STRONG INFERENCE].
 */
int rgb_to_bw_pattern /* Original: FUN_00000116 */ (undefined4 param_1,undefined4 param_2)

{
  int unaff_A5;
  
  return (int)(short)((0x3f - ((short)((ushort)((param_2._0_2_ >> 8) * 7 +
                                               (param_1._2_2_ >> 8) * 0x26 +
                                               (param_1._0_2_ >> 8) * 0x13) >> 6) >> 2)) * 8) +
         unaff_A5 + -0x1ed6;
}



/*
 * Original: FUN_0000017c; source: ID06.c:121.
 * Recovered name: lookup_colour_map [STRONG INFERENCE] (iteration 157).
 * Exported C complete: i = min(word param, 0xff); returns word table
 * (*(long A5-0x1ede))[i] (low word of result; high word is pointer residue).
 * Used by init_row_table_fields for row table +8.
 */
undefined4 lookup_colour_map /* Original: FUN_0000017c */ (undefined4 param_1)

{
  undefined2 *puVar1;
  int unaff_A5;
  
  if (0xff < param_1._0_2_) {
    param_1._0_2_ = 0xff;
  }
  puVar1 = (undefined2 *)(*(int *)(unaff_A5 + -0x1ede) + param_1._0_2_ * 2);
  return CONCAT22((short)((uint)puVar1 >> 0x10),*puVar1);
}



/*
 * Original: FUN_000001a2; source: ID06.c:136.
 * Recovered name: reverse_lookup_colour_map [STRONG INFERENCE] (iteration 157).
 * Exported C complete: first i in 0..255 with table[i] == word param, else 0.
 * Inverse of lookup_colour_map.
 */
undefined4 reverse_lookup_colour_map /* Original: FUN_000001a2 */ (undefined4 param_1)

{
  short *psVar1;
  short sVar2;
  int unaff_A5;
  
  sVar2 = 0;
  while( true ) {
    if (0xff < sVar2) {
      return 0;
    }
    psVar1 = (short *)(*(int *)(unaff_A5 + -0x1ede) + sVar2 * 2);
    if (param_1._0_2_ == *psVar1) break;
    sVar2 = sVar2 + 1;
  }
  return CONCAT22((short)((uint)psVar1 >> 0x10),sVar2);
}



// WARNING: Type propagation algorithm not settling

/*
 * Original: FUN_000001dc; source: ID06.c:159.
 * Recovered name: alloc_aligned_clear [STRONG INFERENCE] (iteration 157).
 * Exported C complete. If FreeMem (JT $212) < 500000, MaxMem (JT $21a) to
 * compact; p = NewPtrClear(size + 12) (JT $232); returns 0 on failure, else
 * a = (p + 12) & ~3 with *(a-4) = size and *(a-8) = p (header for free_aligned).
 * 4-byte-aligned zeroed allocation [STRONG INFERENCE]. Ghidra's piVar3 stack
 * modelling is an artifact.
 */
uint alloc_aligned_clear /* Original: FUN_000001dc */ (int param_1)

{
  int iVar1;
  uint uVar2;
  int unaff_A5;
  int *piVar3;
  int local_14 [4];
  
  local_14[1] = 0;
  local_14[0] = 0;
  (**(code **)(unaff_A5 + 0x212))();
  piVar3 = local_14 + 1;
  if (local_14[0] < 500000) {
    local_14[0] = 0;
    (**(code **)(unaff_A5 + 0x21a))(local_14 + 1);
    piVar3 = local_14;
  }
  piVar3[0xffffffff] = 0;
  piVar3[0xfffffffe] = param_1 + 0xc;
  piVar3[0xfffffffd] = 0x20e;
  (**(code **)(unaff_A5 + 0x232))();
  iVar1 = piVar3[0xfffffffe];
  if (iVar1 == 0) {
    uVar2 = 0;
  }
  else {
    uVar2 = iVar1 + 0xcU & 0xfffffffc;
    *(int *)(uVar2 - 4) = param_1;
    *(int *)(uVar2 - 8) = iVar1;
  }
  return uVar2;
}



/*
 * Original: FUN_0000024c; source: ID06.c:195.
 * Recovered name: free_aligned [STRONG INFERENCE] (iteration 157).
 * Exported C complete: if p != 0, DisposPtr(*(p - 8)) (JT $23a); returns p != 0.
 * Frees a block from alloc_aligned_clear.
 */
bool free_aligned /* Original: FUN_0000024c */ (int param_1)

{
  int unaff_A5;
  
  if (param_1 != 0) {
    (**(code **)(unaff_A5 + 0x23a))(*(undefined4 *)(param_1 + -8));
  }
  return param_1 != 0;
}



/*
 * Original: FUN_0000026c; source: ID06.c:208.
 * Recovered name: init_row_table_fields [STRONG INFERENCE] (iteration 154).
 * Overlay service slot (not in service table).
 * Exported C complete. Row table +0 = JT A5+0x192 (renderer callback);
 * +8 = FUN_0000017c(...); +0xa = 11 (fixed-point shift); +0xc = target +4 -
 * width * target +6 / 8 (row stride remainder); row entry +8 = target +0xc +
 * (row % 8) * 4 (8-row repeating table: dither pattern [HYPOTHESIS]);
 * +0xe = rows; +0x10 = +0x14 = 0. Returns 1. Caller: alloc_row_table.
 */
undefined4 init_row_table_fields /* Original: FUN_0000026c */ (undefined4 param_1)

{
  undefined4 uVar1;
  undefined4 unaff_D7;
  short sVar2;
  int unaff_A5;
  
  **(int **)(unaff_A5 + -0x1cd2) = unaff_A5 + 0x192;
  uVar1 = lookup_colour_map(CONCAT22(param_1._0_2_,(short)((uint)unaff_D7 >> 0x10)));
  *(short *)(*(int *)(unaff_A5 + -0x1cd2) + 8) = (short)uVar1;
  *(undefined2 *)(*(int *)(unaff_A5 + -0x1cd2) + 10) = 0xb;
  *(short *)(*(int *)(unaff_A5 + -0x1cd2) + 0xc) =
       *(short *)(*(int *)(unaff_A5 + -0x1cce) + 4) -
       (short)(*(short *)(*(int *)(unaff_A5 + -0x1cce) + 8) *
              *(short *)(*(int *)(unaff_A5 + -0x1cce) + 6)) / 8;
  for (sVar2 = 0; sVar2 < param_1._2_2_; sVar2 = sVar2 + 1) {
    *(int *)(*(int *)(*(int *)(unaff_A5 + -0x1cd2) + 4) + sVar2 * 0xc + 8) =
         *(int *)(*(int *)(unaff_A5 + -0x1cce) + 0xc) + (sVar2 % 8) * 4;
  }
  *(short *)(*(int *)(unaff_A5 + -0x1cd2) + 0xe) = param_1._2_2_;
  *(undefined4 *)(*(int *)(unaff_A5 + -0x1cd2) + 0x10) = 0;
  *(undefined4 *)(*(int *)(unaff_A5 + -0x1cd2) + 0x14) = 0;
  return 1;
}



/*
 * Original: FUN_00000318; source: ID06.c:236.
 * Recovered name: render_scanline_spans [STRONG INFERENCE] (iteration 155).
 * Renderer callback installed by init_row_table_fields (JT A5+0x192); called by
 * rasterize_and_present. Args: param_1 = (word continue_flag, word rows),
 * uint *dest, long stride (added after each row).
 * In-code state [PROVEN, bytes]: BRA.B at file 0x39c skips a 0x44-byte
 * zero-filled block 0x39e..0x3e1; Ghidra's DAT_0000039e..DAT_000003d2 are
 * these PC-relative cells (self-modifying data kept across band calls). The
 * first band (continue_flag == 0) initialises them.
 * Per row [STRONG INFERENCE from the exported C]:
 *   1. insert the row bucket's new edge nodes into the active edge array
 *      (insertion sort on x, node +0);
 *   2. drop edges whose remaining-row counter (+0x22) equals the row;
 *   3. walk edges left to right: each crossing complements the owning
 *      polygon's parity word (first node +0x20) and inserts/removes the polygon
 *      in a priority-ordered open list (+0x24 key, links +0x10/+0x14 between the
 *      pool sentinels); the topmost polygon's colour (+0x1c -> +0x1e) selects a
 *      long from the row's pattern table (row entry +8), and longs are stored
 *      to dest between crossings, with mask merging (uVar7 & ~uVar3 | ...) for
 *      partial words;
 *   4. advance each edge x by its slope (+4) and re-sort.
 * Painter-style priority span fill of the polygons from add_polygon_edges.
 */
void render_scanline_spans /* Original: FUN_00000318 */ (undefined4 param_1,uint *param_2,int param_3)

{
  uint uVar1;
  int iVar2;
  uint uVar3;
  ushort uVar4;
  int iVar5;
  short sVar6;
  uint uVar7;
  short sVar8;
  uint unaff_D6;
  int *piVar9;
  int *piVar10;
  int iVar11;
  int unaff_A5;
  int *piVar12;
  int *piVar14;
  int *piVar13;
  
  piVar9 = (int *)(*(int *)(unaff_A5 + -0x1cd6) + 4);
  iVar2 = *(int *)(*(int *)(unaff_A5 + -0x1cd6) + 0x89c);
  piVar14 = *(int **)(*(int *)(unaff_A5 + -0x1cd2) + 4);
  sVar6 = param_1._2_2_ + -1;
  if (param_1._0_2_ == 0) {
    DAT_000003a2 = param_3;
    DAT_000003c6 = (int *)0x0;
    DAT_0000039e = piVar9;
    DAT_000003a6 = *(int *)(*(int *)(unaff_A5 + -0x1cd6) + 0x898);
    DAT_000003aa = iVar2;
    *piVar9 = iVar2;
    DAT_000003ba = unaff_D6;
    DAT_000003be = piVar9;
    DAT_000003c2 = piVar14;
    DAT_000003d2 = (int *)&stack0xfffffffc;
  }
  do {
    piVar14 = (int *)*DAT_000003c2;
    for (piVar9 = piVar14; piVar9 != (int *)0x0; piVar9 = (int *)piVar9[3]) {
      iVar2 = piVar9[2];
      *piVar9 = iVar2;
      DAT_000003c6 = DAT_000003be;
      do {
        piVar10 = DAT_000003c6;
        DAT_000003c6 = piVar10 + -1;
        *piVar10 = *DAT_000003c6;
      } while (iVar2 < *(int *)*DAT_000003c6);
      *piVar10 = (int)piVar9;
      DAT_000003be = DAT_000003be + 1;
    }
    iVar2 = DAT_000003c2[1];
    piVar9 = DAT_000003be;
    piVar10 = DAT_0000039e;
    piVar12 = DAT_0000039e;
    if (iVar2 != 0) {
      do {
        piVar13 = piVar12 + 1;
        piVar9 = piVar10;
        if (sVar6 != *(short *)(*piVar12 + 0x22)) {
          piVar9 = piVar10 + 1;
          *piVar10 = *piVar12;
        }
        piVar10 = piVar9;
        DAT_000003c6 = piVar9;
        piVar12 = piVar13;
      } while (piVar13 < DAT_000003be);
    }
    iVar5 = DAT_000003a6;
    piVar10 = DAT_0000039e;
    if (piVar14 != (int *)0x0 || (iVar2 != 0 || DAT_000003c6 != (int *)0x0)) {
      while (piVar10 < piVar9) {
        iVar2 = *piVar10;
        *(undefined2 *)(iVar2 + 0x1e) = *(undefined2 *)(*(int *)(iVar5 + 0x10) + 0x1c);
        iVar2 = *(int *)(iVar2 + 0x18);
        uVar4 = ~*(ushort *)(iVar2 + 0x20);
        *(ushort *)(iVar2 + 0x20) = uVar4;
        iVar11 = iVar5;
        if (uVar4 == 0) {
          iVar11 = *(int *)(iVar2 + 0x14);
          iVar2 = *(int *)(iVar2 + 0x10);
          *(int *)(iVar11 + 0x10) = iVar2;
          *(int *)(iVar2 + 0x14) = iVar11;
          piVar10 = piVar10 + 1;
        }
        else {
          do {
            iVar11 = *(int *)(iVar11 + 0x10);
          } while (*(short *)(iVar2 + 0x24) < *(short *)(iVar11 + 0x24));
          *(int *)(iVar2 + 0x10) = iVar11;
          DAT_000003d2 = *(int **)(iVar11 + 0x14);
          *(int **)(iVar2 + 0x14) = DAT_000003d2;
          *(int *)(iVar11 + 0x14) = iVar2;
          DAT_000003d2[4] = iVar2;
          piVar10 = piVar10 + 1;
        }
      }
      DAT_000003c6 = (int *)0x0;
      *piVar10 = DAT_000003aa;
    }
    piVar10 = DAT_000003c2 + 3;
    iVar2 = DAT_000003c2[2];
    DAT_000003b2 = 0;
    uVar7 = 0;
    DAT_000003b6 = 0;
    piVar14 = DAT_0000039e;
    do {
      DAT_000003ae = DAT_000003b6;
      DAT_000003ce = piVar14 + 1;
      DAT_000003ca = (uint *)*piVar14;
      uVar1 = *DAT_000003ca;
      uVar3 = *(uint *)(iVar2 + (short)((ushort)DAT_000003b2 & 0x3e0));
      sVar8 = (short)(uVar1 >> 0x10) - (short)uVar7;
      uVar7 = *(uint *)(iVar2 + *(short *)((int)DAT_000003ca + 0x1e));
      DAT_000003ba = uVar7 & ~uVar3 | uVar3 & DAT_000003ba;
      while (sVar8 = sVar8 + -1, sVar8 != -1) {
        *param_2 = DAT_000003ba;
        DAT_000003ba = uVar7;
        param_2 = param_2 + 1;
      }
      DAT_000003b6 = DAT_000003ca[1] + uVar1;
      uVar7 = uVar1 >> 0x10;
      DAT_000003b2 = uVar1 >> 6;
      *DAT_000003ca = DAT_000003b6;
      if ((int)DAT_000003b6 < (int)DAT_000003ae) {
        do {
          piVar12 = piVar14;
          DAT_000003c6 = piVar12 + -1;
          DAT_000003d2 = (int *)*DAT_000003c6;
          *piVar12 = (int)DAT_000003d2;
          piVar14 = DAT_000003c6;
        } while ((int)DAT_000003b6 < *DAT_000003d2);
        *piVar12 = (int)DAT_000003ca;
        DAT_000003b6 = DAT_000003ae;
      }
      piVar14 = DAT_000003ce;
    } while (DAT_000003ce <= piVar9);
    param_2 = (uint *)(DAT_000003a2 + (int)param_2);
    sVar6 = sVar6 + -1;
    DAT_000003be = piVar9;
    DAT_000003c2 = piVar10;
  } while (sVar6 != -1);
  return;
}



/*
 * Original: FUN_00000512; source: ID06.c:382.
 * Recovered name: free_row_table [STRONG INFERENCE] (iteration 153).
 * Exported C complete. Frees (free_aligned) the row-entry array (+4), the
 * buffers at +0x1c and +0x20, then the 0x24-byte row-table record at
 * long A5-0x1cd2, and clears A5-0x1cd2.
 */
void free_row_table /* Original: FUN_00000512 */ (void)

{
  int unaff_A5;
  
  if ((*(int *)(unaff_A5 + -0x1cd2) != 0) && (*(int *)(*(int *)(unaff_A5 + -0x1cd2) + 4) != 0)) {
    free_aligned(*(int *)(*(int *)(unaff_A5 + -0x1cd2) + 4));
  }
  if ((*(int *)(unaff_A5 + -0x1cd2) != 0) && (*(int *)(*(int *)(unaff_A5 + -0x1cd2) + 0x1c) != 0)) {
    free_aligned(*(int *)(*(int *)(unaff_A5 + -0x1cd2) + 0x1c));
  }
  if ((*(int *)(unaff_A5 + -0x1cd2) != 0) && (*(int *)(*(int *)(unaff_A5 + -0x1cd2) + 0x20) != 0)) {
    free_aligned(*(int *)(*(int *)(unaff_A5 + -0x1cd2) + 0x20));
  }
  if (*(int *)(unaff_A5 + -0x1cd2) != 0) {
    free_aligned(*(int *)(unaff_A5 + -0x1cd2));
  }
  *(undefined4 *)(unaff_A5 + -0x1cd2) = 0;
  return;
}



/*
 * Original: FUN_00000598; source: ID06.c:405.
 * Recovered name: alloc_row_table [STRONG INFERENCE] (iteration 153).
 * Exported C complete. Requires the target record (A5-0x1cce). n = low word of
 * param_1 (the target height when called from init_raster_target). If an
 * existing table has fewer than n entries (+0xe), it is freed; otherwise
 * reused. Allocates (alloc_aligned_clear) the 0x24-byte record -> A5-0x1cd2 and
 * n * 12 bytes of entries -> record+4, clears every entry, then returns
 * FUN_0000026c(param_1). One 12-byte entry per raster row [STRONG INFERENCE].
 */
undefined4 alloc_row_table /* Original: FUN_00000598 */ (undefined4 param_1)

{
  uint uVar1;
  undefined4 uVar2;
  short sVar3;
  int unaff_A5;
  
  if (*(int *)(unaff_A5 + -0x1cce) == 0) {
    return 0;
  }
  if ((*(int *)(unaff_A5 + -0x1cd2) != 0) &&
     (*(short *)(*(int *)(unaff_A5 + -0x1cd2) + 0xe) < param_1._2_2_)) {
    free_row_table();
  }
  if (*(int *)(unaff_A5 + -0x1cd2) == 0) {
    uVar1 = alloc_aligned_clear(0x24);
    *(uint *)(unaff_A5 + -0x1cd2) = uVar1;
    if (uVar1 == 0) {
      return 0;
    }
    uVar1 = alloc_aligned_clear(param_1._2_2_ * 0xc);
    *(uint *)(*(int *)(unaff_A5 + -0x1cd2) + 4) = uVar1;
    if (uVar1 == 0) {
      return 0;
    }
  }
  for (sVar3 = 0; sVar3 < param_1._2_2_; sVar3 = sVar3 + 1) {
    *(undefined4 *)(*(int *)(*(int *)(unaff_A5 + -0x1cd2) + 4) + sVar3 * 0xc) = 0;
    *(undefined4 *)(*(int *)(*(int *)(unaff_A5 + -0x1cd2) + 4) + sVar3 * 0xc + 4) = 0;
    *(undefined4 *)(*(int *)(*(int *)(unaff_A5 + -0x1cd2) + 4) + sVar3 * 0xc + 8) = 0;
  }
  uVar2 = init_row_table_fields(param_1);
  return uVar2;
}



/*
 * Original: FUN_00000666; source: ID06.c:443.
 * Recovered name: init_edge_pool [STRONG INFERENCE] (iteration 153).
 * Exported C complete. Requires A5-0x1cd2. Allocates once a 0x5e9c-byte block
 * -> A5-0x1cd6; head sentinel +0x898 -> block+0x8ac, tail sentinel +0x89c ->
 * block+0x5e74, linked to each other through +0x10 / +0x14; sentinel fields
 * +0x1c/+0x1e = row-table word +8, +0x22 = -10; tail +0 = target word +8 <<
 * (row-table +0x10 + row-table word +0xa); block+0 = head; free cursor
 * +0x8a0 = +0x8a4 = block+0x8d4; +0x8a8 = block+0x5b7c. Returns 1.
 * [HYPOTHESIS] Edge / span node pool for the rasterizer.
 */
undefined4 init_edge_pool /* Original: FUN_00000666 */ (void)

{
  undefined4 uVar1;
  uint uVar2;
  int unaff_A5;
  
  if (*(int *)(unaff_A5 + -0x1cd2) == 0) {
    uVar1 = 0;
  }
  else {
    if (*(int *)(unaff_A5 + -0x1cd6) == 0) {
      uVar2 = alloc_aligned_clear(0x5e9c);
      *(uint *)(unaff_A5 + -0x1cd6) = uVar2;
      if (uVar2 == 0) {
        return 0;
      }
    }
    *(int *)(*(int *)(unaff_A5 + -0x1cd6) + 0x898) = *(int *)(unaff_A5 + -0x1cd6) + 0x8ac;
    *(int *)(*(int *)(unaff_A5 + -0x1cd6) + 0x89c) = *(int *)(unaff_A5 + -0x1cd6) + 0x5e74;
    *(undefined4 *)(*(int *)(*(int *)(unaff_A5 + -0x1cd6) + 0x898) + 0x10) =
         *(undefined4 *)(*(int *)(unaff_A5 + -0x1cd6) + 0x89c);
    *(undefined4 *)(*(int *)(*(int *)(unaff_A5 + -0x1cd6) + 0x89c) + 0x14) =
         *(undefined4 *)(*(int *)(unaff_A5 + -0x1cd6) + 0x898);
    **(undefined4 **)(*(int *)(unaff_A5 + -0x1cd6) + 0x898) = 0;
    *(undefined2 *)(*(int *)(*(int *)(unaff_A5 + -0x1cd6) + 0x898) + 0x1c) =
         *(undefined2 *)(*(int *)(unaff_A5 + -0x1cd2) + 8);
    *(undefined2 *)(*(int *)(*(int *)(unaff_A5 + -0x1cd6) + 0x898) + 0x1e) =
         *(undefined2 *)(*(int *)(unaff_A5 + -0x1cd2) + 8);
    *(undefined2 *)(*(int *)(*(int *)(unaff_A5 + -0x1cd6) + 0x898) + 0x22) = 0xfff6;
    **(int **)(*(int *)(unaff_A5 + -0x1cd6) + 0x89c) =
         (int)*(short *)(*(int *)(unaff_A5 + -0x1cce) + 8) <<
         (*(int *)(*(int *)(unaff_A5 + -0x1cd2) + 0x10) +
          (int)*(short *)(*(int *)(unaff_A5 + -0x1cd2) + 10) & 0x3fU);
    *(undefined2 *)(*(int *)(*(int *)(unaff_A5 + -0x1cd6) + 0x89c) + 0x1c) =
         *(undefined2 *)(*(int *)(unaff_A5 + -0x1cd2) + 8);
    *(undefined2 *)(*(int *)(*(int *)(unaff_A5 + -0x1cd6) + 0x89c) + 0x1e) =
         *(undefined2 *)(*(int *)(unaff_A5 + -0x1cd2) + 8);
    *(undefined2 *)(*(int *)(*(int *)(unaff_A5 + -0x1cd6) + 0x89c) + 0x22) = 0xfff6;
    **(undefined4 **)(unaff_A5 + -0x1cd6) = *(undefined4 *)(*(int *)(unaff_A5 + -0x1cd6) + 0x898);
    *(int *)(*(int *)(unaff_A5 + -0x1cd6) + 0x8a0) = *(int *)(unaff_A5 + -0x1cd6) + 0x8d4;
    *(undefined4 *)(*(int *)(unaff_A5 + -0x1cd6) + 0x8a4) =
         *(undefined4 *)(*(int *)(unaff_A5 + -0x1cd6) + 0x8a0);
    *(int *)(*(int *)(unaff_A5 + -0x1cd6) + 0x8a8) = *(int *)(unaff_A5 + -0x1cd6) + 0x5b7c;
    uVar1 = 1;
  }
  return uVar1;
}



/*
 * Original: FUN_000007b0; source: ID06.c:494.
 * Recovered name: init_raster_target [STRONG INFERENCE] (iteration 153).
 * Exported C complete. If FUN_000000b0() != 0: allocate (once) the 16-byte
 * target record -> A5-0x1cce: +0 = param_1 (pixel base), +4 = param_2 high
 * word, +6 = 1, +8 = param_3 high word (width), +0xa = param_3 low word
 * (height), +0xc = FUN_000000f4(); alloc_row_table(param_2 low, height);
 * init_edge_pool(); A5-0x1cca = width >> 1, A5-0x1cc8 = height >> 1 (centre).
 * Returns 1 on success, 0 on any failure.
 */
undefined4 init_raster_target /* Original: FUN_000007b0 */ (undefined4 param_1,undefined4 param_2,undefined4 param_3)

{
  undefined4 uVar1;
  uint uVar2;
  int unaff_A5;
  
  uVar1 = alloc_pattern_tables();
  if ((short)uVar1 == 0) {
    uVar1 = 0;
  }
  else {
    if (*(int *)(unaff_A5 + -0x1cce) == 0) {
      uVar2 = alloc_aligned_clear(0x10);
      *(uint *)(unaff_A5 + -0x1cce) = uVar2;
      if (uVar2 == 0) {
        return 0;
      }
    }
    **(undefined4 **)(unaff_A5 + -0x1cce) = param_1;
    *(undefined2 *)(*(int *)(unaff_A5 + -0x1cce) + 4) = param_2._0_2_;
    *(undefined2 *)(*(int *)(unaff_A5 + -0x1cce) + 6) = 1;
    *(short *)(*(int *)(unaff_A5 + -0x1cce) + 8) = param_3._0_2_;
    *(short *)(*(int *)(unaff_A5 + -0x1cce) + 10) = param_3._2_2_;
    uVar1 = get_pattern_table();
    *(undefined4 *)(*(int *)(unaff_A5 + -0x1cce) + 0xc) = uVar1;
    uVar1 = alloc_row_table(CONCAT22(param_2._2_2_,param_3._2_2_));
    if ((short)uVar1 == 0) {
      uVar1 = 0;
    }
    else {
      uVar1 = init_edge_pool();
      if ((short)uVar1 == 0) {
        uVar1 = 0;
      }
      else {
        *(short *)(unaff_A5 + -0x1cca) = param_3._0_2_ >> 1;
        *(short *)(unaff_A5 + -0x1cc8) = param_3._2_2_ >> 1;
        uVar1 = 1;
      }
    }
  }
  return uVar1;
}



/*
 * Original: FUN_0000087a; source: ID06.c:541.
 * Recovered name: set_raster_target_base [STRONG INFERENCE] (iteration 153).
 * Exported C complete: if target record exists, its +0 (pixel base) =
 * param_1. Used to retarget rendering to another buffer [STRONG INFERENCE].
 */
void set_raster_target_base /* Original: FUN_0000087a */ (undefined4 param_1)

{
  int unaff_A5;
  
  if (*(int *)(unaff_A5 + -0x1cce) != 0) {
    **(undefined4 **)(unaff_A5 + -0x1cce) = param_1;
  }
  return;
}



/*
 * Original: FUN_000008a2; source: ID06.c:554.
 * Recovered name: set_active_row_count [STRONG INFERENCE] (iteration 154).
 * Overlay service slot A5-0x1304 (JT $1a2).
 * Exported C complete; CurrentA5 routine. If target and row table exist,
 * n = param_1 clamped to [1, target height (+0xa)] (out-of-range -> height);
 * row table +0xe = n (rows processed). A5-0x1cc6 = row table +0xe.
 */
void set_active_row_count /* Original: FUN_000008a2 */ (int param_1)

{
  int iVar1;
  
  iVar1 = DAT_00000904;
  if ((*(int *)(DAT_00000904 + -0x1cce) != 0) && (*(int *)(DAT_00000904 + -0x1cd2) != 0)) {
    if ((*(short *)(*(int *)(DAT_00000904 + -0x1cce) + 10) < param_1) || (param_1 < 1)) {
      param_1 = (int)*(short *)(*(int *)(DAT_00000904 + -0x1cce) + 10);
    }
    *(undefined2 *)(*(int *)(DAT_00000904 + -0x1cd2) + 0xe) = param_1._2_2_;
  }
  *(undefined2 *)(iVar1 + -0x1cc6) = *(undefined2 *)(*(int *)(iVar1 + -0x1cd2) + 0xe);
  return;
}



/*
 * Original: FUN_00000916; source: ID06.c:572.
 * Recovered name: get_raster_target_size [STRONG INFERENCE] (iteration 158).
 * Exported C complete: if the target exists, *param_1 = width (+8),
 * *param_2 = height (+0xa); returns whether it exists.
 */
bool get_raster_target_size /* Original: FUN_00000916 */ (undefined2 *param_1,undefined2 *param_2)

{
  int unaff_A5;
  bool bVar1;
  
  bVar1 = *(int *)(unaff_A5 + -0x1cce) != 0;
  if (bVar1) {
    *param_1 = *(undefined2 *)(*(int *)(unaff_A5 + -0x1cce) + 8);
    *param_2 = *(undefined2 *)(*(int *)(unaff_A5 + -0x1cce) + 10);
  }
  return bVar1;
}



/*
 * Original: FUN_00000942; source: ID06.c:588.
 * Recovered name: realloc_row_table [STRONG INFERENCE] (iteration 158).
 * Exported C complete: alloc_row_table((word param, current active rows))
 * then init_edge_pool(); returns 0 on failure. Rebuilds the row table and node
 * pool [STRONG INFERENCE: param word is passed as row-table word +8 source].
 */
undefined4 realloc_row_table /* Original: FUN_00000942 */ (undefined4 param_1)

{
  undefined4 uVar1;
  int unaff_A5;
  
  uVar1 = alloc_row_table(CONCAT22(param_1._0_2_,*(undefined2 *)(*(int *)(unaff_A5 + -0x1cd2) + 0xe)));
  if ((short)uVar1 == 0) {
    uVar1 = 0;
  }
  else {
    uVar1 = init_edge_pool();
    if ((short)uVar1 == 0) {
      uVar1 = 0;
    }
  }
  return uVar1;
}



/*
 * Original: FUN_0000096e; source: ID06.c:609.
 * Recovered name: reset_edge_table [STRONG INFERENCE] (iteration 154).
 * Overlay service slot A5-0x1310 (JT $1ba).
 * Exported C complete; CurrentA5 routine. Clears the first two longs of each
 * active row entry (bucket head, end flag), resets the node-pool cursor
 * (+0x8a4 = +0x8a0), toggles row table +0x14 between 0 and 1, A5-0x1cc6 = 0.
 * Per-frame reset of the edge table [STRONG INFERENCE].
 */
void reset_edge_table /* Original: FUN_0000096e */ (void)

{
  int iVar1;
  short sVar2;
  undefined4 *puVar3;
  
  iVar1 = DAT_00000904;
  puVar3 = *(undefined4 **)(*(int *)(DAT_00000904 + -0x1cd2) + 4);
  sVar2 = *(short *)(*(int *)(DAT_00000904 + -0x1cd2) + 0xe) + -1;
  do {
    *puVar3 = 0;
    puVar3[1] = 0;
    puVar3 = puVar3 + 3;
    sVar2 = sVar2 + -1;
  } while (sVar2 != -1);
  *(undefined4 *)(*(int *)(iVar1 + -0x1cd6) + 0x8a4) =
       *(undefined4 *)(*(int *)(iVar1 + -0x1cd6) + 0x8a0);
  *(int *)(*(int *)(iVar1 + -0x1cd2) + 0x14) =
       (int)(short)(*(int *)(*(int *)(iVar1 + -0x1cd2) + 0x14) == 0);
  *(undefined2 *)(iVar1 + -0x1cc6) = 0;
  return;
}



/*
 * Original: FUN_000009d8; source: ID06.c:635.
 * Recovered name: add_polygon_edges [STRONG INFERENCE] (iteration 154).
 * Overlay service slot A5-0x130c (JT $1c2).
 * Exported C complete; CurrentA5 routine. Args: n points, attribute words a/b
 * (stored at node +0x1c / +0x24), int *pts = n pairs {x, y} relative to the
 * centre (A5-0x1cca / A5-0x1cc8).
 * Rejects the polygon if all x lie outside [0, width). For each edge (from the
 * previous point), orders by y, clips to rows [0, active rows) and x [0, width)
 * with 64-bit products / divides, computes slope (1 << rowtable+0xa) * dx / dy
 * << rowtable+0x12, and allocates 0x28-byte nodes from the pool (cursor
 * +0x8a4, limit +0x8a8): +4 slope, +8 x << shift, +0xc next in row bucket,
 * +0x18 polygon's first node, +0x22 remaining rows; pushes the node on the
 * bucket of its start row (row entry +0) and sets the end row's flag (+4).
 * Returns true if any node was added. Scanline polygon edge-table insertion
 * [STRONG INFERENCE].
 */
bool add_polygon_edges /* Original: FUN_000009d8 */ (int param_1,undefined2 param_2,undefined2 param_3,int *param_4)

{
  uint uVar1;
  ushort uVar2;
  ushort uVar3;
  longlong lVar4;
  int iVar5;
  int iVar6;
  int iVar7;
  int iVar8;
  int iVar9;
  int iVar10;
  int iVar11;
  int iVar12;
  int *piVar13;
  uint uVar14;
  bool bVar15;
  int local_10;
  int local_c;
  
  iVar5 = DAT_00000904;
  uVar2 = *(ushort *)(*(int *)(DAT_00000904 + -0x1cd2) + 10);
  uVar3 = *(ushort *)(*(int *)(DAT_00000904 + -0x1cd2) + 0x12);
  uVar1 = *(uint *)(*(int *)(DAT_00000904 + -0x1cd6) + 0x8a4);
  iVar10 = (int)*(short *)(*(int *)(DAT_00000904 + -0x1cce) + 8);
  iVar7 = 0;
  iVar11 = param_1;
  piVar13 = param_4;
  while (0 < iVar11) {
    iVar12 = *piVar13 + (int)*(short *)(DAT_00000904 + -0x1cca);
    if (iVar12 < iVar10) {
      iVar10 = iVar12;
    }
    if (iVar7 < iVar12) {
      iVar7 = iVar12;
    }
    piVar13 = piVar13 + 2;
    iVar11 = iVar11 + -1;
  }
  if ((iVar7 == 0) || (*(short *)(*(int *)(DAT_00000904 + -0x1cce) + 8) == iVar10)) {
    bVar15 = false;
  }
  else if (uVar1 < *(uint *)(*(int *)(DAT_00000904 + -0x1cd6) + 0x8a8)) {
    *(undefined2 *)(uVar1 + 0x1c) = param_2;
    *(undefined2 *)(uVar1 + 0x24) = param_3;
    iVar11 = param_4[param_1 * 2 + -2] + (int)*(short *)(iVar5 + -0x1cca);
    iVar7 = param_4[param_1 * 2 + -1] + (int)*(short *)(iVar5 + -0x1cc8);
    uVar14 = uVar1;
    while (param_1 != 0) {
      iVar12 = *param_4 + (int)*(short *)(iVar5 + -0x1cca);
      iVar10 = param_4[1] + (int)*(short *)(iVar5 + -0x1cc8);
      if (iVar10 != iVar7) {
        iVar6 = iVar7;
        iVar8 = iVar11;
        iVar9 = iVar12;
        if (iVar7 < iVar10) {
          iVar6 = iVar10;
          iVar8 = iVar12;
          iVar10 = iVar7;
          iVar9 = iVar11;
          local_10 = iVar12;
        }
        if ((0 < iVar6) && (iVar10 < *(short *)(*(int *)(iVar5 + -0x1cd2) + 0xe))) {
          iVar7 = iVar10;
          if (iVar10 < 0) {
            lVar4 = (longlong)iVar10 * (longlong)(iVar8 - iVar9);
            iVar7 = 0;
            iVar9 = iVar9 - (int)(((longlong)(int)((ulonglong)lVar4 >> 0x20) << 0x20 |
                                  (longlong)(int)lVar4) / (longlong)(iVar6 - iVar10));
          }
          do {
            iVar11 = iVar6;
            if (iVar9 < 1) {
              if (0 < iVar8) {
                lVar4 = (longlong)iVar9 * (longlong)(iVar6 - iVar7);
                iVar11 = iVar7 - (int)(((longlong)(int)((ulonglong)lVar4 >> 0x20) << 0x20 |
                                       (longlong)(int)lVar4) / (longlong)(iVar8 - iVar9));
              }
              iVar9 = 0;
              local_10 = 1;
              local_c = 0;
            }
            else if (iVar9 < *(short *)(*(int *)(iVar5 + -0x1cce) + 8)) {
              if (iVar8 < 1) {
                lVar4 = (longlong)(iVar9 + -1) * (longlong)(iVar6 - iVar7);
                local_10 = 0;
                iVar11 = iVar7 - (int)(((longlong)(int)((ulonglong)lVar4 >> 0x20) << 0x20 |
                                       (longlong)(int)lVar4) / (longlong)(iVar8 - iVar9));
              }
              else if (*(short *)(*(int *)(iVar5 + -0x1cce) + 8) <= iVar8) {
                local_10 = (int)*(short *)(*(int *)(iVar5 + -0x1cce) + 8);
                lVar4 = (longlong)(iVar9 + (1 - local_10)) * (longlong)(iVar6 - iVar7);
                iVar11 = iVar7 - (int)(((longlong)(int)((ulonglong)lVar4 >> 0x20) << 0x20 |
                                       (longlong)(int)lVar4) / (longlong)(iVar8 - iVar9));
              }
              lVar4 = (longlong)(1 << (uVar2 & 0x3f)) * (longlong)(iVar8 - iVar9);
              local_c = (int)(((longlong)(int)((ulonglong)lVar4 >> 0x20) << 0x20 |
                              (longlong)(int)lVar4) / (longlong)(iVar6 - iVar7)) << (uVar3 & 0x3f);
            }
            else {
              if (iVar8 < *(short *)(*(int *)(iVar5 + -0x1cce) + 8)) {
                lVar4 = (longlong)(*(short *)(*(int *)(iVar5 + -0x1cce) + 8) - iVar9) *
                        (longlong)(iVar6 - iVar7);
                iVar11 = (int)(((longlong)(int)((ulonglong)lVar4 >> 0x20) << 0x20 |
                               (longlong)(int)lVar4) / (longlong)(iVar8 - iVar9)) + iVar7;
              }
              iVar9 = (int)*(short *)(*(int *)(iVar5 + -0x1cce) + 8);
              local_10 = iVar9 + -1;
              local_c = 0;
            }
            *(int *)(uVar14 + 4) = local_c;
            *(uint *)(uVar14 + 0x18) = uVar1;
            *(int *)(uVar14 + 8) = iVar9 << (uVar3 + uVar2 & 0x3f);
            *(undefined4 *)(uVar14 + 0xc) =
                 *(undefined4 *)(*(int *)(*(int *)(iVar5 + -0x1cd2) + 4) + iVar7 * 0xc);
            *(uint *)(*(int *)(*(int *)(iVar5 + -0x1cd2) + 4) + iVar7 * 0xc) = uVar14;
            *(short *)(uVar14 + 0x22) =
                 (*(short *)(*(int *)(iVar5 + -0x1cd2) + 0xe) - (short)iVar11) + -1;
            if (iVar11 < *(short *)(*(int *)(iVar5 + -0x1cd2) + 0xe)) {
              *(undefined4 *)(*(int *)(*(int *)(iVar5 + -0x1cd2) + 4) + iVar11 * 0xc + 4) = 1;
            }
            uVar14 = uVar14 + 0x28;
          } while ((iVar11 < iVar6) &&
                  (iVar7 = iVar11, iVar9 = local_10,
                  iVar11 < *(short *)(*(int *)(iVar5 + -0x1cd2) + 0xe)));
        }
      }
      iVar11 = *param_4 + (int)*(short *)(iVar5 + -0x1cca);
      iVar7 = param_4[1] + (int)*(short *)(iVar5 + -0x1cc8);
      param_4 = param_4 + 2;
      param_1 = param_1 + -1;
    }
    *(uint *)(*(int *)(iVar5 + -0x1cd6) + 0x8a4) = uVar14;
    bVar15 = uVar14 != uVar1;
  }
  else {
    bVar15 = false;
  }
  return bVar15;
}



/*
 * Original: FUN_00000d02; source: ID06.c:779.
 * Recovered name: add_rect_polygon [STRONG INFERENCE] (iteration 158).
 * Exported C complete. Words: colour = param_1 high, x0 = param_1 low,
 * y0 = param_2 high, x1 = param_2 low, y1 = param_3 high. Builds points
 * (x0,y0), (x1,y0), (x1,y1), (x0,y1) and calls
 * add_polygon_edges(4, lookup_colour_map(colour), 0, pts). Ghidra's unaff_A4
 * half is register residue.
 */
void add_rect_polygon /* Original: FUN_00000d02 */ (undefined4 param_1,undefined4 param_2,undefined4 param_3)

{
  undefined4 uVar1;
  undefined4 unaff_A4;
  int local_34;
  int local_30;
  int local_2c;
  int local_28;
  int local_24;
  int local_20;
  int local_1c;
  int local_18;
  
  local_34 = (int)param_1._2_2_;
  local_30 = (int)param_2._0_2_;
  local_2c = (int)param_2._2_2_;
  local_28 = (int)param_2._0_2_;
  local_24 = (int)param_2._2_2_;
  local_20 = (int)param_3._0_2_;
  local_1c = (int)param_1._2_2_;
  local_18 = (int)param_3._0_2_;
  uVar1 = lookup_colour_map(CONCAT22(param_1._0_2_,(short)((uint)unaff_A4 >> 0x10)));
  add_polygon_edges(4,(short)uVar1,0,&local_34);
  return;
}



/*
 * Original: FUN_00000d84; source: ID06.c:808.
 * Recovered name: rebase_edge_rows_for_band [STRONG INFERENCE] (iteration 155).
 * Exported C complete: for every allocated node (pool +0x8a0 .. cursor +0x8a4,
 * stride 0x28): +0x22 += band_offset - active rows (row table +0xe). Called by
 * rasterize_and_present before each band.
 */
void rebase_edge_rows_for_band /* Original: FUN_00000d84 */ (undefined4 param_1)

{
  int unaff_A5;
  undefined4 local_8;
  
  for (local_8 = *(uint *)(*(int *)(unaff_A5 + -0x1cd6) + 0x8a0);
      local_8 < *(uint *)(*(int *)(unaff_A5 + -0x1cd6) + 0x8a4); local_8 = local_8 + 0x28) {
    *(short *)(local_8 + 0x22) =
         (param_1._0_2_ + *(short *)(local_8 + 0x22)) -
         *(short *)(*(int *)(unaff_A5 + -0x1cd2) + 0xe);
  }
  return;
}



/*
 * Original: FUN_00000dca; source: ID06.c:825.
 * Recovered name: restore_edge_rows_after_band [STRONG INFERENCE] (iteration 155).
 * Exported C complete: inverse of rebase_edge_rows_for_band
 * (+0x22 += active rows - band_offset) after each band.
 */
void restore_edge_rows_after_band /* Original: FUN_00000dca */ (undefined4 param_1)

{
  int unaff_A5;
  undefined4 local_8;
  
  for (local_8 = *(uint *)(*(int *)(unaff_A5 + -0x1cd6) + 0x8a0);
      local_8 < *(uint *)(*(int *)(unaff_A5 + -0x1cd6) + 0x8a4); local_8 = local_8 + 0x28) {
    *(short *)(local_8 + 0x22) =
         *(short *)(*(int *)(unaff_A5 + -0x1cd2) + 0xe) +
         (*(short *)(local_8 + 0x22) - param_1._0_2_);
  }
  return;
}



/*
 * Original: FUN_00000e10; source: ID06.c:842.
 * Recovered name: rasterize_and_present [STRONG INFERENCE] (iteration 154).
 * Overlay service slot A5-0x1308 (JT $19a).
 * Exported C complete; CurrentA5 routine. Args: dest (0 = render only),
 * band_rows, mode. Links head/tail sentinels (empty active edge list). If
 * dest == 0: (*rowtable+0)(rows, target base, rowtable+0xc). Else, per band
 * of band_rows: rebase_edge_rows_for_band; (*rowtable+0)(band, dest, row
 * stride) = render_scanline_spans; restore_edge_rows_after_band; JT $322 = ID02 blit_offscreen_frame_to_window(dest, top, rows,
 * mode). Rasterises the edge table and presents it in bands [STRONG INFERENCE].
 * The renderer callback is JT A5+0x192 (installed by init_row_table_fields).
 */
void rasterize_and_present /* Original: FUN_00000e10 */ (int param_1,int param_2,undefined2 param_3)

{
  short sVar1;
  short sVar2;
  short sVar3;
  short sVar4;
  int iVar5;
  short sVar6;
  undefined4 unaff_D2;
  undefined2 uVar7;
  undefined4 local_e;
  undefined2 local_8;
  undefined2 local_6;
  
  iVar5 = DAT_00000904;
  uVar7 = (undefined2)((uint)unaff_D2 >> 0x10);
  if (*(int *)(DAT_00000904 + -0x1cd2) != 0) {
    *(undefined4 *)(*(int *)(*(int *)(DAT_00000904 + -0x1cd6) + 0x898) + 0x10) =
         *(undefined4 *)(*(int *)(DAT_00000904 + -0x1cd6) + 0x89c);
    *(undefined4 *)(*(int *)(*(int *)(iVar5 + -0x1cd6) + 0x89c) + 0x14) =
         *(undefined4 *)(*(int *)(iVar5 + -0x1cd6) + 0x898);
    if (param_1 == 0) {
      (*(code *)**(undefined4 **)(iVar5 + -0x1cd2))
                (*(undefined2 *)(*(int *)(iVar5 + -0x1cd2) + 0xe),
                 (short)**(undefined4 **)(iVar5 + -0x1cce),
                 *(undefined2 *)(*(int *)(iVar5 + -0x1cd2) + 0xc));
    }
    else {
      sVar1 = *(short *)(iVar5 + -0x1372);
      sVar2 = *(short *)(iVar5 + -0x137a);
      sVar3 = *(short *)(iVar5 + -0x1372);
      sVar4 = *(short *)(iVar5 + -0x137a);
      local_e = (int)*(short *)(*(int *)(iVar5 + -0x1cd2) + 0xe);
      local_8 = 0;
      do {
        if (param_2 < local_e) {
          local_6 = param_2._2_2_;
        }
        else {
          local_6 = local_e._2_2_;
        }
        sVar6 = *(short *)(*(int *)(iVar5 + -0x1cd2) + 0xe) - (local_e._2_2_ - local_6);
        rebase_edge_rows_for_band(CONCAT22(sVar6,uVar7));
        (*(code *)**(undefined4 **)(iVar5 + -0x1cd2))
                  (CONCAT22(local_8,local_6),(short)param_1,
                   ((short)(sVar1 * sVar2 + 0xf) >> 4) * 2 - (short)(sVar3 * sVar4) / 8);
        local_8 = 1;
        restore_edge_rows_after_band(CONCAT22(sVar6,uVar7));
        (**(code **)(iVar5 + 0x322))
                  (param_1,*(short *)(*(int *)(iVar5 + -0x1cd2) + 0xe) - local_e,local_6,param_3);
        local_e = local_e - local_6;
      } while (local_e != 0);
    }
  }
  return;
}


