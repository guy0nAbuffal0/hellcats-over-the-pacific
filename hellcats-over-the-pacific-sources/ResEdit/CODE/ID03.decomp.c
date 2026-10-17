typedef unsigned char   undefined;

typedef unsigned short    undefined2;
typedef unsigned int    undefined4;
typedef unsigned short    ushort;
typedef unsigned char    byte;



// WARNING: Control flow encountered bad instruction data

/*
 * Original: FUN_00000006; source: ID03.c:12.
 * Recovered name: set_scaled_text_style [STRONG INFERENCE] (iteration 160).
 * Ghidra truncated at $A888. Bytes 0x06..0x54 [PROVEN]: word size at 8(A6).
 *   if (mode A5-0x137a == 1) { TextFace(0) $A888;
 *       TextSize(scale_design_4800((short)(size * 10) / 3)) $A88A }
 *   else { TextFace(1 = bold); TextSize(scale_design_4800(size * 10)) }
 * (1-bit mode uses plain text at one third of the colour-mode size, as coded.)
 */
void set_scaled_text_style /* Original: FUN_00000006 */ (void)

{
  int unaff_A5;
  
  if (*(short *)(unaff_A5 + -0x137a) == 1) {
                    // WARNING: Bad instruction - Truncating control flow here
    halt_baddata();
  }
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



/*
 * Original: FUN_00000056; source: ID03.c:27.
 * Recovered name: scale_design_480_min10 [STRONG INFERENCE] (iteration 159).
 * Exported C complete: v = (long A5-0x149e * (short)param + 5) / 480, then at
 * least 10 (when clamped, the high word of the result becomes 0). A5-0x149e is a
 * scale factor (screen-size dependent) [STRONG INFERENCE; identity UNKNOWN].
 */
undefined4 scale_design_480_min10 /* Original: FUN_00000056 */ (undefined4 param_1)

{
  int iVar1;
  int unaff_A5;
  undefined2 local_6;
  
  iVar1 = (*(int *)(unaff_A5 + -0x149e) * (int)param_1._0_2_ + 5) / 0x1e0;
  local_6 = (short)iVar1;
  if (local_6 < 10) {
    iVar1 = 0;
    local_6 = 10;
  }
  return CONCAT22((short)((uint)iVar1 >> 0x10),local_6);
}



/*
 * Original: FUN_0000008a; source: ID03.c:45.
 * Recovered name: scale_design_4800 [STRONG INFERENCE] (iteration 159).
 * Exported C complete: (long A5-0x149e * (short)param) / 4800 (signed, truncating).
 * Converts design units to screen units [STRONG INFERENCE].
 */
int scale_design_4800 /* Original: FUN_0000008a */ (undefined4 param_1)

{
  int unaff_A5;
  
  return (*(int *)(unaff_A5 + -0x149e) * (int)param_1._0_2_) / 0x12c0;
}



/*
 * Original: FUN_000000a6; source: ID03.c:55.
 * Recovered name: scale_design_4800_pen_centred [STRONG INFERENCE] (iteration 159).
 * Exported C complete: scale_design_4800(v) - thePort->pnSize.h (+0x36) / 2
 * (pen-centred coordinate). Ghidra's unaff_A6 half is register residue.
 */
short scale_design_4800_pen_centred /* Original: FUN_000000a6 */ (undefined4 param_1)

{
  int iVar1;
  int unaff_A5;
  undefined4 unaff_A6;
  
  iVar1 = scale_design_4800(CONCAT22(param_1._0_2_,(short)((uint)unaff_A6 >> 0x10)));
  return (short)iVar1 - *(short *)(*(int *)(unaff_A5 + -0x160c) + 0x36) / 2;
}



/*
 * Original: FUN_000000c8; source: ID03.c:68.
 * Recovered name: max3_int [STRONG INFERENCE] (iteration 159).
 * Exported C complete: signed maximum of three longs.
 */
int max3_int /* Original: FUN_000000c8 */ (int param_1,int param_2,int param_3)

{
  if (param_1 < param_2) {
    param_1 = param_2;
  }
  if (param_1 < param_3) {
    param_1 = param_3;
  }
  return param_1;
}



/*
 * Original: FUN_000000f4; source: ID03.c:82.
 * Recovered name: nearest_palette_index_rgb [STRONG INFERENCE] (iteration 159).
 * Exported C complete. param_1 -> RGB (3 words). JT $4da = ID02 FUN_0000001e
 * (abs). Distance = max3_int(|dr|, |dg|, |db|) (Chebyshev).
 *   best over the 8 base colours at A5-0x350 (6 bytes each);
 *   then scans the extended table *(long A5-0x14a6) (count word A5-0x14a2)
 *   and returns the FIRST entry closer than the base best (index + 8), not
 *   the global minimum - behaviour preserved as exported.
 *   Result by mode word A5-0x137a: 4 or 1 -> chosen index (local_8);
 *   8 -> chosen index + 200; any other mode -> local_6 (the scan counter:
 *   table count if no extended match, else matched index + 8). Same index
 *   space as ID02 lookup_palette_index_for_rgb_level.
 */
short nearest_palette_index_rgb /* Original: FUN_000000f4 */ (ushort *param_1)

{
  ushort uVar1;
  ushort uVar2;
  ushort uVar3;
  int iVar4;
  int iVar5;
  int iVar6;
  short sVar7;
  int unaff_A5;
  int local_c;
  short local_8;
  short local_6;
  
  uVar1 = *param_1;
  uVar2 = param_1[1];
  uVar3 = param_1[2];
  local_8 = -1;
  local_c = 0x7fffffff;
  for (local_6 = 0; local_6 < 8; local_6 = local_6 + 1) {
    iVar4 = (**(code **)(unaff_A5 + 0x4da))
                      ((uint)*(ushort *)(local_6 * 6 + unaff_A5 + -0x350) - (uint)uVar1);
    iVar5 = (**(code **)(unaff_A5 + 0x4da))
                      ((uint)*(ushort *)(local_6 * 6 + unaff_A5 + -0x34e) - (uint)uVar2);
    iVar6 = (**(code **)(unaff_A5 + 0x4da))
                      ((uint)*(ushort *)(local_6 * 6 + unaff_A5 + -0x34c) - (uint)uVar3);
    iVar4 = max3_int(iVar4,iVar5,iVar6);
    if (iVar4 < local_c) {
      local_8 = local_6;
      local_c = iVar4;
    }
  }
  local_6 = 0;
  do {
    if (*(short *)(unaff_A5 + -0x14a2) <= local_6) {
LAB_0000027e:
      sVar7 = local_8;
      if (((*(short *)(unaff_A5 + -0x137a) != 4) && (*(short *)(unaff_A5 + -0x137a) != 1)) &&
         (sVar7 = local_6, *(short *)(unaff_A5 + -0x137a) == 8)) {
        sVar7 = local_8 + 200;
      }
      return sVar7;
    }
    iVar4 = (**(code **)(unaff_A5 + 0x4da))
                      ((uint)*(ushort *)(*(int *)(unaff_A5 + -0x14a6) + local_6 * 6) - (uint)uVar1);
    iVar5 = (**(code **)(unaff_A5 + 0x4da))
                      ((uint)*(ushort *)(*(int *)(unaff_A5 + -0x14a6) + local_6 * 6 + 2) -
                       (uint)uVar2);
    iVar6 = (**(code **)(unaff_A5 + 0x4da))
                      ((uint)*(ushort *)(*(int *)(unaff_A5 + -0x14a6) + local_6 * 6 + 4) -
                       (uint)uVar3);
    iVar4 = max3_int(iVar4,iVar5,iVar6);
    if (iVar4 < local_c) {
      local_6 = local_6 + 8;
      local_8 = local_6;
      goto LAB_0000027e;
    }
    local_6 = local_6 + 1;
  } while( true );
}



// WARNING: Control flow encountered bad instruction data

/*
 * Original: FUN_000002a8; source: ID03.c:148.
 * Recovered name: new_offscreen_bw_port [STRONG INFERENCE] (iteration 160).
 * Ghidra truncated after the allocations. Bytes 0x2a8..0x33a [PROVEN].
 * Args: words width [8(A6)], height [$a(A6)]. Returns GrafPtr (D0).
 *   rowBytes = (width / 16) * 2 + 2; bits = NewPtrClear(height * rowBytes)
 *   (JT $232); port = NewPtrClear(0x6c); OpenPort(port) $A86F;
 *   BitMap bm = { bits, rowBytes, (0, 0, height, width) }; SetPortBits(&bm)
 *   $A875; port->portRect = bm.bounds; PortSize(width, height) $A876;
 *   RectRgn(port->visRgn, &bm.bounds) $A8DF.
 * 1-bit offscreen GrafPort [STRONG INFERENCE]. No NULL checks.
 * Caller: FUN_000032b8 (file 0x3496).
 */
void new_offscreen_bw_port /* Original: FUN_000002a8 */ (undefined4 param_1)

{
  int unaff_A5;
  
  (**(code **)(unaff_A5 + 0x232))
            ((int)param_1._2_2_ * (int)(short)((param_1._0_2_ / 0x10) * 2 + 2),0);
  (**(code **)(unaff_A5 + 0x232))(0x6c,0);
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



// WARNING: Control flow encountered bad instruction data

/*
 * Original: FUN_0000033c; source: ID03.c:164.
 * Recovered name: dispose_offscreen_bw_port [STRONG INFERENCE] (iteration 160).
 * Ghidra truncated. Bytes 0x33c..0x35c [PROVEN]: arg GrafPtr port;
 *   ClosePort(port) $A87D; DisposPtr(port->portBits.baseAddr (+2)) (JT $23a);
 *   DisposPtr(port). Inverse of new_offscreen_bw_port. Caller: FUN_000032b8
 *   (file 0x381e).
 */
void dispose_offscreen_bw_port /* Original: FUN_0000033c */ (void)

{
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



// WARNING: Control flow encountered bad instruction data

/*
 * Original: FUN_0000035e; source: ID03.c:175.
 * Recovered name: draw_spinning_disc_indicator [STRONG INFERENCE mechanics]
 * (iteration 163; INVESTIGATING in iteration 161). Ghidra exported no body.
 * Bytes 0x35e..0x512 [PROVEN]. Args: words cx [8(A6)], cy [$a(A6)] (design units).
 *   d = word A5-0x2114 (size); r.left = design_x_to_screen(cx - d/2);
 *   r.top = design_y_to_screen(cy - d/2); r.right = r.left + scale_design_4800(d);
 *   r.bottom = r.top + scale_design_4800(d);
 *   saved = NewRgn, GetClip(saved); ring = NewRgn;
 *   colour grey (2,2,2) via lookup_palette_index_for_rgb_level (JT $45a) +
 *   set_draw_color_index (JT $36a); PaintOval(&r) $A8B8;
 *   OpenRgn; FrameOval(&r) $A8B7; CloseRgn(ring) (ring = outline region);
 *   centre (cx', cy') = midpoint of r;
 *   if (scale_design_4800(d) >= 5):
 *     colour black (0,0,0);
 *     phase word A5-0x2112: 0 -> vertical line through centre;
 *       1 -> SetClip(ring), diagonal top-left -> bottom-right;
 *       2 -> SetClip(ring), diagonal top-right -> bottom-left;
 *       other -> horizontal line through centre;
 *     phase = (phase + 5) & 3   (advances one step per call);
 *   SetClip(saved); DisposeRgn(ring); DisposeRgn(saved).
 * A grey disc with a spoke that rotates 45 degrees per call [STRONG INFERENCE].
 * Iteration 167 [HYPOTHESIS, stronger]: a bezel screw head - draw_instrument
 * places these at the bezel corners, and the stepping phase gives each screw a
 * different slot orientation (not an animation). Callers: 5 BSRs inside
 * draw_ring_with_status_indicators (FUN_00000514; file 0x624, 0x684, 0x6e2, 0x742, 0x774).
 */
void draw_spinning_disc_indicator /* Original: FUN_0000035e */ (void)

{
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



// WARNING: Control flow encountered bad instruction data

/*
 * Original: FUN_00000514; source: ID03.c:186.
 * Recovered name: draw_ring_with_status_indicators [STRONG INFERENCE mechanics /
 * HYPOTHESIS purpose] (iteration 164). Exported C kept (truncated at $A8B8).
 * Bytes 0x514..0x77c [PROVEN]. Words: d [8], w [$a], cy [$c], cx [$e];
 * flags = long [$10] (bits tested on byte $11).
 *   r.left = design_x_to_screen(cx - d/2); r.top = design_y_to_screen(cy - d/2);
 *   r.right/bottom = + scale_design_4800(d);
 *   black (0,0,0) -> PaintOval(&r); grey (2,2,2); PenSize(w/10, w/10);
 *   FrameOval(&r);
 *   o = ((d/2) * 0xb50) >> 12   (0xb50/4096 = 0.7071 = cos 45 deg);
 *   bit 0 -> draw_spinning_disc_indicator(cx - o - 30, cy - o - 30);
 *   bit 1 -> (cx + o + 30, cy - o - 30);  bit 2 -> (cx + o + 30, cy + o + 30);
 *   bit 3 -> (cx - o - 30, cy + o + 30);  bit 4 -> (..., cy + o + 30)
 *   [bit-4 x term not traced]. Indicators sit on the diagonals outside the ring.
 * Note: Ghidra's in_stack_fffffff0 halves are pushed-word artifacts.
 */
void draw_ring_with_status_indicators /* Original: FUN_00000514 */ (undefined4 param_1)

{
  int unaff_A5;
  undefined2 in_stack_fffffff0;
  
  (**(code **)(unaff_A5 + 0x3ca))();
  (**(code **)(unaff_A5 + 0x382))();
  scale_design_4800(CONCAT22(param_1._0_2_,in_stack_fffffff0));
  scale_design_4800(CONCAT22(param_1._0_2_,in_stack_fffffff0));
  (**(code **)(unaff_A5 + 0x45a))(0);
  (**(code **)(unaff_A5 + 0x36a))();
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



// WARNING: Control flow encountered bad instruction data

void FUN_0000077e(char *param_1,undefined4 param_2,undefined4 param_3)

{
  int iVar1;
  short sVar2;
  int unaff_A5;
  undefined2 in_stack_fffffff0;
  short local_a;
  char *local_8;
  
  local_8 = param_1;
  do {
    if (local_8[1] == '\0') {
      do {
        if (*param_1 == '\0') {
          return;
        }
        for (local_a = 0; local_a < 6; local_a = local_a + 1) {
          if (**(char **)(local_a * 4 + unaff_A5 + -0x20b0) == *param_1) {
            iVar1 = *(int *)(local_a * 4 + unaff_A5 + -0x20b0);
            sVar2 = scale_design_4800_pen_centred(CONCAT22(*(char *)(iVar1 + 2) * param_2._0_2_ + param_2._2_2_,
                                          in_stack_fffffff0));
            scale_design_4800_pen_centred(CONCAT22(*(char *)(iVar1 + 3) * param_2._0_2_ + param_3._0_2_,sVar2));
                    // WARNING: Bad instruction - Truncating control flow here
            halt_baddata();
          }
        }
        param_1 = param_1 + 1;
      } while( true );
    }
    for (local_a = 0; local_a < 6; local_a = local_a + 1) {
      if (**(char **)(local_a * 4 + unaff_A5 + -0x20b0) == *local_8) {
        param_2 = CONCAT22(param_2._0_2_,
                           param_2._2_2_ -
                           (short)((*(char *)(*(int *)(local_a * 4 + unaff_A5 + -0x20b0) + 1) + 1) *
                                  param_2._0_2_) / 2);
        break;
      }
    }
    local_8 = local_8 + 1;
  } while( true );
}



// WARNING: Control flow encountered bad instruction data

/*
 * Original: FUN_00000912; source: ID03.c:253.
 * Recovered name: draw_vector_number [STRONG INFERENCE] (iteration 161).
 * Exported C kept (truncated after the first stroke). Words: value = param_1
 * high, scale = param_1 low, cx = param_2 high, y = param_2 low.
 * Splits value into up to 5 decimal digits (most significant first in
 * asStack_14[local_6..4]); returns if value had more digits than fit.
 * Each digit d selects a stroke list char *A5-0x1fde[d] of (dx, dy) byte
 * pairs; x starts at cx - (digits * 6 * scale) / 2 (centred, 6 units per
 * digit) and points are scaled by `scale`, converted with
 * scale_design_4800_pen_centred and drawn with MoveTo/LineTo [rest of the
 * loop not exported]. Vector-font number display (e.g. instruments)
 * [HYPOTHESIS for the use].
 */
void draw_vector_number /* Original: FUN_00000912 */ (undefined4 param_1,undefined4 param_2)

{
  char *pcVar1;
  short sVar2;
  undefined4 unaff_A4;
  int unaff_A5;
  short asStackY_10014 [32764];
  undefined2 uVar3;
  short asStack_14 [5];
  short local_a;
  short local_8;
  short local_6;
  
  uVar3 = (undefined2)((uint)unaff_A4 >> 0x10);
  local_6 = 5;
  do {
    local_6 = local_6 + -1;
    asStack_14[local_6] = param_1._0_2_ % 10;
    sVar2 = param_1._0_2_ / 10;
    param_1 = CONCAT22(sVar2,param_1._2_2_);
  } while (sVar2 != 0);
  if (4 < local_6) {
    return;
  }
  pcVar1 = *(char **)(asStack_14[local_6] * 4 + unaff_A5 + -0x1fde);
  local_a = param_2._2_2_;
  local_8 = *pcVar1 * param_1._2_2_ +
            (param_2._0_2_ - (short)((4 - local_6) * 6 * param_1._2_2_) / 2);
  local_6 = local_6 + 1;
  scale_design_4800_pen_centred(CONCAT22(local_8,uVar3));
  local_a = pcVar1[1] * param_1._2_2_ + local_a;
  scale_design_4800_pen_centred(CONCAT22(local_a,uVar3));
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



// WARNING: Control flow encountered bad instruction data

/*
 * Original: FUN_00000a3c; source: ID03.c:294.
 * Recovered name: antialias_downsample_bw_3x [STRONG INFERENCE]
 * (iteration 166; INVESTIGATING in iteration 165). Ghidra exported no body.
 * Bytes 0xa3c..0x1468 [PROVEN]. Args: GrafPtr src [8] (1-bit port: base +2,
 * rowBytes +6), word x0 [$c], word y0 [$e], word rows [$10], word cols [$12],
 * byte *out [$14] (optional, 0 = none).
 *   PenPat(QD black); seven source row pointers base + k*rowBytes (k = 0..6);
 *   row step = 3 * rowBytes; if (out) clear cols bytes of out;
 *   for row in 0 .. rows-2:
 *     for i in 0 .. cols-1 (source x advances by 3 per output pixel):
 *       sum = sum over a 7x7 window of source bits (mask table A5-0x1fb6[x&7],
 *             byte x>>3) times a symmetric kernel peaking at the centre
 *             (e.g. 8,21,29,21,8 / 21,54,73,54,21 / 29,73,97,73,29 ...);
 *       level = sum * 0xffff / 0x3c9   (969 = total kernel weight; MULU.L /
 *             DIVS.L) -> RGB grey at -0x2c(A6);
 *       c = nearest_palette_index_rgb(&rgb); set_draw_color_index(c) (JT $36a);
 *       MoveTo(x0 + i, y0 + row) $A893; Line(0, 0) $A892  (plot one pixel);
 *       if (out) out[i] = c;
 *     advance all row pointers by 3 * rowBytes.
 * Gaussian-weighted 3x supersampling filter: renders a 1-bit offscreen image
 * (e.g. from new_offscreen_bw_port) as anti-aliased grey palette pixels.
 * Exact x0/y0 vs h/v roles per MoveTo push order [STRONG INFERENCE].
 * Callers [PROVEN, BSR scan]: ID03 file 0x152c, 0x37fc (FUN_000032b8), 0x4b02.
 */
void antialias_downsample_bw_3x /* Original: FUN_00000a3c */ (void)

{
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



// WARNING: Control flow encountered bad instruction data

void FUN_0000146a(undefined4 param_1,undefined4 param_2)

{
  int unaff_A5;
  undefined2 in_stack_ffffffec;
  
  scale_design_4800(CONCAT22(param_2._0_2_,in_stack_ffffffec));
  scale_design_4800(CONCAT22(param_2._0_2_,in_stack_ffffffec));
  (**(code **)(unaff_A5 + 0x3ca))();
  (**(code **)(unaff_A5 + 0x382))();
  if (*(short *)(unaff_A5 + -0x137a) == 1) {
                    // WARNING: Bad instruction - Truncating control flow here
    halt_baddata();
  }
  FUN_00000a3c();
  return;
}



// WARNING: Control flow encountered bad instruction data

/*
 * Original: FUN_00001538; source: ID03.c:327.
 * Recovered name: begin_instrument_supersample [STRONG INFERENCE] (iteration 168).
 * Exported C kept (two truncated branches). Args: short *size, *x, *y, ...,
 * GrafPtr *out_port. If mode A5-0x137a == 1 (1-bit screen): creates a 1x B&W
 * port with new_offscreen_bw_port(scaled size). Otherwise multiplies x and y
 * by 3 and creates a port of 3 * scaled size + 6 for 3x supersampling
 * (consumed later by antialias_downsample_bw_3x) [STRONG INFERENCE].
 * Callers: instrument drawers (e.g. draw_altimeter).
 */
void begin_instrument_supersample /* Original: FUN_00001538 */ (undefined2 *param_1,short *param_2,short *param_3,undefined4 param_4,
                 undefined4 *param_5)

{
  int iVar1;
  undefined2 uVar3;
  undefined4 uVar2;
  short sVar4;
  int unaff_A5;
  undefined2 in_stack_ffffffec;
  
  if (*(short *)(unaff_A5 + -0x137a) == 1) {
    iVar1 = scale_design_4800(CONCAT22(*param_1,in_stack_ffffffec));
    uVar3 = (undefined2)iVar1;
    iVar1 = scale_design_4800(CONCAT22(*param_1,uVar3));
    uVar2 = new_offscreen_bw_port(CONCAT22(uVar3,(short)iVar1));
    *param_5 = uVar2;
    scale_design_4800(CONCAT22(*param_1,uVar3));
    scale_design_4800(CONCAT22(*param_1,uVar3));
    iVar1 = scale_design_4800(CONCAT22(0x14,uVar3));
    scale_design_4800(CONCAT22(0x14,(short)iVar1));
                    // WARNING: Bad instruction - Truncating control flow here
    halt_baddata();
  }
  *param_2 = *param_2 * 3;
  *param_3 = *param_3 * 3;
  iVar1 = scale_design_4800(CONCAT22(*param_1,in_stack_ffffffec));
  sVar4 = (short)iVar1 * 3;
  iVar1 = scale_design_4800(CONCAT22(*param_1,sVar4));
  uVar2 = new_offscreen_bw_port(CONCAT22(sVar4 + 6,(short)iVar1 * 3 + 6));
  *param_5 = uVar2;
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



// WARNING: Control flow encountered bad instruction data

void FUN_00001844(void)

{
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



// WARNING: Control flow encountered bad instruction data
// WARNING: Removing unreachable block (ram,0x00001910)
// WARNING: Removing unreachable block (ram,0x00001ac0)

/*
 * Original: FUN_00001876; source: ID03.c:379.
 * Recovered name: draw_altimeter [STRONG INFERENCE] (iteration 168).
 * Instrument type 0 of draw_instrument. Exported C kept (truncated). Bytes
 * 0x1876..0x1b46 [PROVEN, condensed]: begin_instrument_supersample(...);
 * tick/needle geometry through function pointer long A5-0x2118 (JSR (A0)) in
 * loops of 12 steps; a 20-iteration loop of draw_vector_number labels;
 * TextFont(1) $A887, set_scaled_text_style(20), GetFontInfo $A88B; label
 * string = long A5-0xe42 = STR# 129 slot 65 (A5-0xf46 + 65*4) -> centred with
 * StringWidth $A88C, MoveTo, DrawString $A884; finish via FUN_00001844.
 * Label text [PROVEN from resource dump]: slot 65 = "\pALTITUDE"
 * (artifacts/reverse-engineering/resources/resource_dasm_Hellcats_app,
 * file index 64; files are 0-based, game slots 1-based - calibrated with
 * slot 93 = "Out of memory.  Sorry" used by ID02 fatal_memory_error_exit).
 * Hence the altimeter gauge [STRONG INFERENCE].
 */
void draw_altimeter /* Original: FUN_00001876 */ (undefined4 param_1,undefined2 param_2,undefined4 param_3)

{
  undefined4 auStack_36 [12];
  
  begin_instrument_supersample((undefined2 *)&param_1,(short *)((int)&param_1 + 2),(short *)&stack0x00000008,
               CONCAT22(param_2,param_3._0_2_),auStack_36);
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



// WARNING: Control flow encountered bad instruction data

void FUN_00001b48(undefined4 param_1,undefined2 param_2,undefined4 param_3)

{
  undefined4 auStack_36 [12];
  short local_6;
  
  begin_instrument_supersample((undefined2 *)&param_1,(short *)((int)&param_1 + 2),(short *)&stack0x00000008,
               CONCAT22(param_2,param_3._0_2_),auStack_36);
  local_6 = 0;
  while( true ) {
    if (0x9f < local_6) {
                    // WARNING: Bad instruction - Truncating control flow here
      halt_baddata();
    }
    if (local_6 % 10 == 0) {
                    // WARNING: Bad instruction - Truncating control flow here
      halt_baddata();
    }
    if (local_6 % 5 == 0) {
                    // WARNING: Bad instruction - Truncating control flow here
      halt_baddata();
    }
    if (0x13 < local_6) break;
    local_6 = local_6 + 1;
  }
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



// WARNING: Control flow encountered bad instruction data

void FUN_00001fee(undefined4 param_1,undefined2 param_2,undefined4 param_3)

{
  undefined4 auStack_36 [12];
  short local_6;
  
  begin_instrument_supersample((undefined2 *)&param_1,(short *)((int)&param_1 + 2),(short *)&stack0x00000008,
               CONCAT22(param_2,param_3._0_2_),auStack_36);
  local_6 = 0;
  while( true ) {
    if (0x26 < local_6) {
                    // WARNING: Bad instruction - Truncating control flow here
      halt_baddata();
    }
    if (local_6 % 3 == 0) break;
    if ((local_6 < 0x12) || (0x15 < local_6)) {
                    // WARNING: Bad instruction - Truncating control flow here
      halt_baddata();
    }
    local_6 = local_6 + 1;
  }
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



// WARNING: Control flow encountered bad instruction data
// WARNING: Removing unreachable block (ram,0x000023a2)
// WARNING: Removing unreachable block (ram,0x00002578)

void FUN_000022fe(undefined4 param_1,undefined2 param_2,undefined4 param_3)

{
  undefined4 auStack_38 [13];
  
  begin_instrument_supersample((undefined2 *)&param_1,(short *)((int)&param_1 + 2),(short *)&stack0x00000008,
               CONCAT22(param_2,param_3._0_2_),auStack_38);
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



// WARNING: Control flow encountered bad instruction data

void FUN_00002600(undefined4 param_1,undefined2 param_2,undefined4 param_3)

{
  undefined4 auStack_38 [12];
  short local_6;
  
  begin_instrument_supersample((undefined2 *)&param_1,(short *)((int)&param_1 + 2),(short *)&stack0x00000008,
               CONCAT22(param_2,param_3._0_2_),auStack_38);
  local_6 = 0;
  while( true ) {
    if (0x44 < local_6) {
                    // WARNING: Bad instruction - Truncating control flow here
      halt_baddata();
    }
    if ((short)(local_6 + -3) % 5 == 0) break;
    if (2 < local_6) {
                    // WARNING: Bad instruction - Truncating control flow here
      halt_baddata();
    }
    local_6 = local_6 + 1;
  }
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



// WARNING: Control flow encountered bad instruction data
// WARNING: Removing unreachable block (ram,0x000029f4)
// WARNING: Removing unreachable block (ram,0x00002c94)

void FUN_00002950(undefined4 param_1,undefined2 param_2,undefined4 param_3)

{
  undefined4 auStack_38 [13];
  
  begin_instrument_supersample((undefined2 *)&param_1,(short *)((int)&param_1 + 2),(short *)&stack0x00000008,
               CONCAT22(param_2,param_3._0_2_),auStack_38);
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



// WARNING: Control flow encountered bad instruction data

void FUN_00002d1c(undefined4 param_1,undefined2 param_2,undefined4 param_3)

{
  undefined4 auStack_38 [13];
  
  begin_instrument_supersample((undefined2 *)&param_1,(short *)((int)&param_1 + 2),(short *)&stack0x00000008,
               CONCAT22(param_2,param_3._0_2_),auStack_38);
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



// WARNING: Control flow encountered bad instruction data

void FUN_000032b8(void)

{
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



// WARNING: Control flow encountered bad instruction data

void FUN_00003832(void)

{
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



// WARNING: Control flow encountered bad instruction data

void FUN_000038fc(void)

{
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



// WARNING: Control flow encountered bad instruction data

/*
 * Original: FUN_00003c02; source: ID03.c:567.
 * Recovered name: draw_instrument [STRONG INFERENCE] (iteration 167).
 * Ghidra mis-decoded the inline switch table after JSR $3a(A5) as code (the
 * pbVar1 |= 0x50 and |= 0x8a00c6 statements are table bytes, not behaviour);
 * exported C kept verbatim. Bytes 0x3c02..0x3dbe decoded [PROVEN]; tail after
 * 0x3dbe not listed.
 * Args: word type [8], words [$a] size, [$c], [$e], [$10], [$12] (geometry).
 *   draw_ring_with_status_indicators(size, $e, $10, $12, flags) with flags
 *     0x1b if type == 6, else 0x0f   (bezel + corner screws, see below);
 *   colour (4,4,4) via lookup_palette_index_for_rgb_level / set_draw_color_index;
 *   switch (type) [ID01 switch helper, 0..9, table parsed by script]:
 *     0 -> draw_altimeter (FUN_00001876)   1 -> FUN_00001b48   2 -> FUN_00002d1c
 *     3 -> FUN_00001fee   4 -> FUN_00002600   5 -> FUN_000022fe
 *     6 -> FUN_00002950   7 -> (none)         8 -> FUN_000032b8(..., 1)
 *     9 -> FUN_000038fc(..., 1)       (each called with $a, $c, $e, $10, $12);
 *   then fills record A5-0x12a2 + type * 16 from the geometry (via
 *   scale_design_4800) [tail not fully listed].
 * [HYPOTHESIS] Cockpit instrument panel: one drawing routine per gauge type.
 */
void draw_instrument /* Original: FUN_00003c02 */ (undefined4 param_1,undefined2 param_2)

{
  byte *pbVar1;
  ushort uVar2;
  int unaff_A2;
  int unaff_A4;
  int unaff_A5;
  
  if (param_1._0_2_ == 6) {
    FUN_00000514(CONCAT22(param_1._2_2_,param_2));
  }
  else {
    FUN_00000514(CONCAT22(param_1._2_2_,param_2));
  }
  (**(code **)(unaff_A5 + 0x45a))(4);
  (**(code **)(unaff_A5 + 0x36a))();
  uVar2 = (**(code **)(unaff_A5 + 0x3a))();
  pbVar1 = (byte *)(unaff_A2 + 0x6e + (int)(short)(uVar2 | 9));
  *pbVar1 = *pbVar1 | 0x50;
  *(uint *)(unaff_A4 + 0x124) = *(uint *)(unaff_A4 + 0x124) | 0x8a00c6;
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



// WARNING: Control flow encountered bad instruction data

void FUN_00003f24(void)

{
  int unaff_A5;
  
  (**(code **)(unaff_A5 + 0x45a))(1);
  (**(code **)(unaff_A5 + 0x36a))();
  (**(code **)(unaff_A5 + 0x45a))(0);
  (**(code **)(unaff_A5 + 0x3a2))();
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



// WARNING: Control flow encountered bad instruction data

void FUN_00004110(void)

{
  int unaff_A5;
  
  (**(code **)(unaff_A5 + 0x3ca))();
  (**(code **)(unaff_A5 + 0x3ca))();
  (**(code **)(unaff_A5 + 0x45a))(0);
  (**(code **)(unaff_A5 + 0x36a))();
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



// WARNING: Control flow encountered bad instruction data

void FUN_00004304(void)

{
  int unaff_A5;
  
  (**(code **)(unaff_A5 + 0x45a))(0);
  (**(code **)(unaff_A5 + 0x36a))();
  (**(code **)(unaff_A5 + 0x3ca))();
  (**(code **)(unaff_A5 + 0x382))();
  (**(code **)(unaff_A5 + 0x3ca))();
  (**(code **)(unaff_A5 + 0x382))();
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



// WARNING: Control flow encountered bad instruction data

void FUN_00004790(void)

{
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



// WARNING: Control flow encountered bad instruction data

void FUN_00004b32(void)

{
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



// WARNING: Control flow encountered bad instruction data
// WARNING: Removing unreachable block (ram,0x00004cee)
// WARNING: Removing unreachable block (ram,0x00004e00)

void FUN_00004c42(undefined4 param_1,undefined4 param_2,undefined4 param_3)

{
  undefined4 auStack_36 [12];
  
  FUN_00000514(CONCAT22(param_1._0_2_,param_2._0_2_));
  begin_instrument_supersample((undefined2 *)&param_1,(short *)((int)&param_1 + 2),(short *)&param_2,
               CONCAT22(param_2._2_2_,param_3._0_2_),auStack_36);
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



// WARNING: Control flow encountered bad instruction data
// WARNING: Removing unreachable block (ram,0x00004f7c)
// WARNING: Removing unreachable block (ram,0x00005092)

void FUN_00004ecc(undefined4 param_1,undefined4 param_2,undefined4 param_3)

{
  undefined4 auStack_36 [12];
  
  FUN_00000514(CONCAT22(param_1._0_2_,param_2._0_2_));
  begin_instrument_supersample((undefined2 *)&param_1,(short *)((int)&param_1 + 2),(short *)&param_2,
               CONCAT22(param_2._2_2_,param_3._0_2_),auStack_36);
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



// WARNING: Control flow encountered bad instruction data
// WARNING: Removing unreachable block (ram,0x000051c0)
// WARNING: Removing unreachable block (ram,0x0000532a)

void FUN_00005158(void)

{
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



// WARNING: Control flow encountered bad instruction data

void FUN_0000532e(undefined4 param_1,undefined4 param_2,undefined4 param_3)

{
  undefined4 auStack_36 [12];
  
  FUN_00000514(CONCAT22(param_1._0_2_,param_2._0_2_));
  begin_instrument_supersample((undefined2 *)&param_1,(short *)((int)&param_1 + 2),(short *)&param_2,
               CONCAT22(param_2._2_2_,param_3._0_2_),auStack_36);
  FUN_00005158();
  FUN_00005158();
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



// WARNING: Control flow encountered bad instruction data

void FUN_000054fe(undefined4 param_1,undefined4 param_2,undefined4 param_3)

{
  undefined4 auStack_36 [12];
  
  FUN_00000514(CONCAT22(param_1._0_2_,param_2._0_2_));
  begin_instrument_supersample((undefined2 *)&param_1,(short *)((int)&param_1 + 2),(short *)&param_2,
               CONCAT22(param_2._2_2_,param_3._0_2_),auStack_36);
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



// WARNING: Control flow encountered bad instruction data
// WARNING: Removing unreachable block (ram,0x0000583a)

void FUN_00005718(short *param_1,undefined4 param_2,short *param_3,short *param_4)

{
  short sVar1;
  short sVar2;
  short sVar3;
  short sVar4;
  short sVar7;
  int iVar5;
  int iVar6;
  int unaff_A5;
  int local_12;
  short local_e;
  
  sVar2 = param_1[3];
  sVar3 = param_1[1];
  sVar4 = param_1[2];
  sVar1 = *param_1;
  sVar7 = (short)(param_1[3] - param_1[1]) / 2;
  if (param_2._2_2_ < 0) {
    local_e = -5;
  }
  else {
    local_e = 5;
  }
  if ((short)(local_e + param_2._2_2_) == 0) {
    return;
  }
  for (local_12 = ((param_2._0_2_ + -0x5a) * 0x4000) / 0x168; local_12 < 0;
      local_12 = local_12 + 0x4000) {
  }
  for (; 0x4000 < local_12; local_12 = local_12 + -0x4000) {
  }
  iVar5 = (**(code **)(unaff_A5 + -0x2118))(local_12);
  iVar6 = (**(code **)(unaff_A5 + -0x211c))(local_12);
  *param_3 = (short)(sVar3 + sVar2) / 2 + (short)(iVar5 * sVar7 >> 0xc);
  *param_4 = (short)(sVar1 + sVar4) / 2 + (short)(iVar6 * sVar7 >> 0xc);
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



void FUN_00005860(void)

{
  short sVar1;
  short sVar2;
  short sVar3;
  undefined2 uVar4;
  short sVar5;
  short sVar6;
  short sVar7;
  int unaff_A5;
  
  sVar3 = (**(code **)(unaff_A5 + 0x382))();
  *(short *)(unaff_A5 + -0x1150) = sVar3;
  uVar4 = (**(code **)(unaff_A5 + 0x382))();
  *(undefined2 *)(unaff_A5 + -0x114e) = uVar4;
  sVar5 = (**(code **)(unaff_A5 + 0x382))();
  *(short *)(unaff_A5 + -0x114c) = sVar5 + 2;
  sVar6 = (**(code **)(unaff_A5 + 0x382))();
  *(short *)(unaff_A5 + -0x114a) = sVar6 + 2;
  sVar6 = (**(code **)(unaff_A5 + 0x3ca))();
  sVar1 = (sVar6 / 2) * 2;
  *(short *)(unaff_A5 + -0x1148) = sVar1;
  sVar6 = (**(code **)(unaff_A5 + 0x3ca))();
  sVar2 = (sVar6 / 2) * 2;
  *(short *)(unaff_A5 + -0x1146) = sVar2;
  sVar6 = (**(code **)(unaff_A5 + 0x3ca))();
  *(short *)(unaff_A5 + -0x1144) = (sVar6 / 2) * 2;
  sVar6 = (**(code **)(unaff_A5 + 0x3ca))();
  sVar6 = (sVar6 / 2) * 2 + 2;
  *(short *)(unaff_A5 + -0x1142) = sVar6;
  sVar7 = (**(code **)(unaff_A5 + 0x3ca))();
  *(short *)(unaff_A5 + -0x1140) = (sVar7 / 2) * 2 + 2;
  sVar7 = (**(code **)(unaff_A5 + 0x382))();
  *(short *)(unaff_A5 + -0x113e) = sVar7;
  *(int *)(unaff_A5 + -0x113c) =
       (int)sVar1 / (int)(short)(8 / (int)*(short *)(unaff_A5 + -0x137a)) +
       *(int *)(unaff_A5 + -0x1382) + (int)sVar3 * (int)*(short *)(unaff_A5 + -0x1378);
  *(int *)(unaff_A5 + -0x1138) =
       (int)sVar1 / (int)(short)(8 / (int)*(short *)(unaff_A5 + -0x137a)) +
       *(int *)(unaff_A5 + -0x1382) + (int)(short)(sVar5 + 2) * (int)*(short *)(unaff_A5 + -0x1378);
  *(int *)(unaff_A5 + -0x1134) =
       (int)sVar2 / (int)(short)(8 / (int)*(short *)(unaff_A5 + -0x137a)) +
       *(int *)(unaff_A5 + -0x1382) + (int)sVar7 * (int)*(short *)(unaff_A5 + -0x1378);
  *(int *)(unaff_A5 + -0x1130) =
       (int)sVar6 / (int)(short)(8 / (int)*(short *)(unaff_A5 + -0x137a)) +
       *(int *)(unaff_A5 + -0x1382) + (int)sVar7 * (int)*(short *)(unaff_A5 + -0x1378);
  return;
}



// WARNING: Control flow encountered bad instruction data

void FUN_00005ab6(void)

{
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



// WARNING: Control flow encountered bad instruction data

void FUN_00005c36(undefined4 param_1)

{
  int unaff_A5;
  
  (**(code **)(unaff_A5 + 0x4f2))(param_1);
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



// WARNING: Control flow encountered bad instruction data

void FUN_00005cb6(void)

{
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



// WARNING: Control flow encountered bad instruction data

void FUN_00005cc4(void)

{
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



// WARNING: Control flow encountered bad instruction data

void FUN_00006c1c(void)

{
  short sVar1;
  int unaff_A5;
  undefined2 local_204 [256];
  
  if ((((-1 < *(short *)(unaff_A5 + -0x13ae)) && (*(int *)(unaff_A5 + -0x13b2) != 0)) &&
      (*(short *)(**(int **)(unaff_A5 + -0x13b2) + *(short *)(unaff_A5 + -0x13ae) * 0x160) ==
       *(short *)(unaff_A5 + -0x137a))) &&
     (((*(short *)(**(int **)(unaff_A5 + -0x13b2) + *(short *)(unaff_A5 + -0x13ae) * 0x160 + 2) ==
        *(short *)(unaff_A5 + -0x137e) &&
       (*(short *)(**(int **)(unaff_A5 + -0x13b2) + *(short *)(unaff_A5 + -0x13ae) * 0x160 + 4) ==
        *(short *)(unaff_A5 + -0x137c))) &&
      ((*(short *)(**(int **)(unaff_A5 + -0x13b2) + *(short *)(unaff_A5 + -0x13ae) * 0x160 + 6) ==
        *(short *)(unaff_A5 + -0x1372) &&
       (*(short *)(**(int **)(unaff_A5 + -0x13b2) + *(short *)(unaff_A5 + -0x13ae) * 0x160 + 8) ==
        *(short *)(unaff_A5 + -0x1370))))))) {
    if (*(short *)(unaff_A5 + -0x137a) != 1) {
      for (sVar1 = 0; sVar1 < 0x100; sVar1 = sVar1 + 1) {
        local_204[sVar1] = 0;
      }
      (**(code **)(unaff_A5 + 0x2a))();
                    // WARNING: Bad instruction - Truncating control flow here
      halt_baddata();
    }
    (**(code **)(unaff_A5 + 0x482))();
  }
  return;
}



void FUN_000071a2(void)

{
  short sVar1;
  short local_204 [256];
  
  for (sVar1 = 0; sVar1 < 0x100; sVar1 = sVar1 + 1) {
    local_204[sVar1] = sVar1;
  }
  FUN_00006c1c();
  return;
}


