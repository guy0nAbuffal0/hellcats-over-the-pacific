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



/* Original: FUN_0000077e; source: ID03.c. Recovered name: draw_vector_glyph_string_centred [STRONG INFERENCE] (iteration 206).
 * Decoded from ID03.bin bytes at file 0x77e.
 * C args: +8 char *text, +0xc short scale, +0xe short x, +0x10 short y (design units). First pass: for each character found in the six-entry glyph table A5-0x20b0 (pointer per glyph; glyph byte 0 = character, byte 1 = width), x -= (width + 1) * scale / 2 - centres the string. Second pass: for each character, MoveTo / LineTo strokes ($A893 / $A891) from the glyph point list, scaled with scale_design_4800_pen_centred (0xa6) [PROVEN control flow; glyph data is A5 initial data, not read]. Caller: draw_direction_indicator (0x2bd6) - probably the compass letters [HYPOTHESIS]. Ghidra truncated the drawing loop.
 */
// WARNING: Control flow encountered bad instruction data

void draw_vector_glyph_string_centred /* Original: FUN_0000077e */ (char *param_1,undefined4 param_2,undefined4 param_3)

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



/* Original: FUN_0000146a; source: ID03.c. Recovered name: composite_instrument_bitmap [PROVEN] (iteration 206).
 * Decoded from ID03.bin bytes at file 0x146a.
 * C args: +8 GrafPtr src (the instrument port), +0xc short size, +0xe short (0 from the caller), +0x10 short x, +0x12 short y. Computes the destination rect from scale_design_4800(size) and design_x_to_screen / design_y_to_screen (JT $3ca / $382). Depth 1 (A5-0x137a == 1): rect = src portRect offset to the destination (OffsetRect $A8A8), CopyBits(src bits, panel port A5-0x1496 bits, &src portRect, &rect, mode 3 = srcBic, NULL) ($A8EC). Otherwise antialias_downsample_bw_3x(src, rect ..., colour A5-0x1fa6) into the panel. Caller: finish_instrument_supersample (0x1860).
 */
// WARNING: Control flow encountered bad instruction data

void composite_instrument_bitmap /* Original: FUN_0000146a */ (undefined4 param_1,undefined4 param_2)

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



/* Original: FUN_00001844; source: ID03.c. Recovered name: finish_instrument_supersample [PROVEN] (iteration 206).
 * Decoded from ID03.bin bytes at file 0x1844.
 * C args: +8 GrafPtr port, +0xc short size, +0xe short x, +0x10 short y. SetPort(panel port A5-0x1496) ($A873); composite_instrument_bitmap(port, size, 0, x, y); dispose_offscreen_bw_port(port) (0x33c). Ends the begin_instrument_supersample sequence. Callers: draw_airspeed_indicator (0x1b3c), draw_climb_indicator (0x1fe2), draw_tachometer (0x22f2), draw_manifold_pressure_gauge (0x25f4).
 */
// WARNING: Control flow encountered bad instruction data

void finish_instrument_supersample /* Original: FUN_00001844 */ (void)

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

/*
 * Original: FUN_00001b48; source: ID03.c:394.
 * Recovered name: draw_airspeed_indicator [STRONG INFERENCE] (iteration 169).
 * Instrument type 1 of draw_instrument. Label strings loaded from the
 * STR# 129 pointer table (A5-0xf46 + 4*slot): slot 66 "AIR" + 67 "SPEED" [PROVEN from
 * the resource dump, 0-based files, slot n = file n-1]. Gauge identity from
 * the label [STRONG INFERENCE]; drawing internals not yet annotated.
 */
void draw_airspeed_indicator /* Original: FUN_00001b48 */ (undefined4 param_1,undefined2 param_2,undefined4 param_3)

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

/*
 * Original: FUN_00001fee; source: ID03.c:427.
 * Recovered name: draw_climb_indicator [STRONG INFERENCE] (iteration 169).
 * Instrument type 3 of draw_instrument. Label strings loaded from the
 * STR# 129 pointer table (A5-0xf46 + 4*slot): slot 68 "CLIMB" [PROVEN from
 * the resource dump, 0-based files, slot n = file n-1]. Gauge identity from
 * the label [STRONG INFERENCE]; drawing internals not yet annotated.
 */
void draw_climb_indicator /* Original: FUN_00001fee */ (undefined4 param_1,undefined2 param_2,undefined4 param_3)

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

/*
 * Original: FUN_000022fe; source: ID03.c:458.
 * Recovered name: draw_tachometer [STRONG INFERENCE] (iteration 169).
 * Instrument type 5 of draw_instrument. Label strings loaded from the
 * STR# 129 pointer table (A5-0xf46 + 4*slot): slot 69 "RPM" [PROVEN from
 * the resource dump, 0-based files, slot n = file n-1]. Gauge identity from
 * the label [STRONG INFERENCE]; drawing internals not yet annotated.
 */
void draw_tachometer /* Original: FUN_000022fe */ (undefined4 param_1,undefined2 param_2,undefined4 param_3)

{
  undefined4 auStack_38 [13];
  
  begin_instrument_supersample((undefined2 *)&param_1,(short *)((int)&param_1 + 2),(short *)&stack0x00000008,
               CONCAT22(param_2,param_3._0_2_),auStack_38);
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



// WARNING: Control flow encountered bad instruction data

/*
 * Original: FUN_00002600; source: ID03.c:473.
 * Recovered name: draw_manifold_pressure_gauge [STRONG INFERENCE] (iteration 169).
 * Instrument type 4 of draw_instrument. Label strings loaded from the
 * STR# 129 pointer table (A5-0xf46 + 4*slot): slot 70 "Manifold" + 71 "Pressure" [PROVEN from
 * the resource dump, 0-based files, slot n = file n-1]. Gauge identity from
 * the label [STRONG INFERENCE]; drawing internals not yet annotated.
 */
void draw_manifold_pressure_gauge /* Original: FUN_00002600 */ (undefined4 param_1,undefined2 param_2,undefined4 param_3)

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

/*
 * Original: FUN_00002950; source: ID03.c:504.
 * Recovered name: draw_direction_indicator [STRONG INFERENCE] (iteration 169).
 * Instrument type 6 of draw_instrument. Label strings loaded from the
 * STR# 129 pointer table (A5-0xf46 + 4*slot): slot 72 "DIRECTION" [PROVEN from
 * the resource dump, 0-based files, slot n = file n-1]. Gauge identity from
 * the label [STRONG INFERENCE]; drawing internals not yet annotated.
 */
void draw_direction_indicator /* Original: FUN_00002950 */ (undefined4 param_1,undefined2 param_2,undefined4 param_3)

{
  undefined4 auStack_38 [13];
  
  begin_instrument_supersample((undefined2 *)&param_1,(short *)((int)&param_1 + 2),(short *)&stack0x00000008,
               CONCAT22(param_2,param_3._0_2_),auStack_38);
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



// WARNING: Control flow encountered bad instruction data

/*
 * Original: FUN_00002d1c; source: ID03.c:519.
 * Recovered name: draw_turn_and_bank_indicator [STRONG INFERENCE] (iteration 169).
 * Instrument type 2 of draw_instrument. Label strings loaded from the
 * STR# 129 pointer table (A5-0xf46 + 4*slot): slot 73 "TURN" + 74 "BANK" [PROVEN from
 * the resource dump, 0-based files, slot n = file n-1]. Gauge identity from
 * the label [STRONG INFERENCE]; drawing internals not yet annotated.
 */
void draw_turn_and_bank_indicator /* Original: FUN_00002d1c */ (undefined4 param_1,undefined2 param_2,undefined4 param_3)

{
  undefined4 auStack_38 [13];
  
  begin_instrument_supersample((undefined2 *)&param_1,(short *)((int)&param_1 + 2),(short *)&stack0x00000008,
               CONCAT22(param_2,param_3._0_2_),auStack_38);
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



/* Original: FUN_000032b8; source: ID03.c. Recovered name: draw_gyro_instrument [STRONG INFERENCE] (iteration 202).
 * Decoded from ID03.bin bytes at file 0x32b8.
 * Instrument type 8 of draw_instrument (called with $a, $c, $e, $10, $12 and 1). Uses the handles A5-0x11dc and A5-0x11d4 (HLock / HUnlock through ID09 JT $26a / $272 / $27a), which ID03 0x5ba6..0x5bea saves with AddResource (HEL2, id base A5-0x13ae + 400 / 500) under the names STR# 129 slot 81 "GyroInstrument" and slot 82 "GyroFlags" [PROVEN]. Draws scale lines with design_x_to_screen / design_y_to_screen (JT $3ca / $382) and scale_design_4800, renders into a black-and-white port (new_offscreen_bw_port 0x2a8, SetOrigin), uses ID02 JT $402 (file 0xca6), PaintRect and CopyBits ($A8EC), then antialias_downsample_bw_3x (0xa3c) and dispose_offscreen_bw_port (0x33c) [PROVEN calls]. Which gyro instrument this is (and what the flags image shows) is not yet decoded [HYPOTHESIS name]. Ghidra truncated the body.
 */
// WARNING: Control flow encountered bad instruction data

void draw_gyro_instrument /* Original: FUN_000032b8 */ (void)

{
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



/* Original: FUN_00003832; source: ID03.c. Recovered name: make_inset_face_oval_region [STRONG INFERENCE] (iteration 202).
 * Decoded from ID03.bin bytes at file 0x3832.
 * C args: +8 Rect *r (out), +0xc short size, +0xe short y, +0x10 short x (design units). PenSize(1, 1); r = screen square from design_x_to_screen(x - size/2) + 1, design_y_to_screen(y - size/2) + 1, side scale_design_4800(size) - 2; InsetRect(r, scale(50), scale(50)); rgn = NewRgn ($A8D8); OpenRgn ($A8DA); FrameOval(r) ($A8B7); CloseRgn(rgn) ($A8DB); returns rgn [PROVEN, bytes 0x3832..0x38fa]: the oval of the instrument face inside the bezel. Caller: draw_artificial_horizon (0x3996).
 */
// WARNING: Control flow encountered bad instruction data

void make_inset_face_oval_region /* Original: FUN_00003832 */ (void)

{
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



/* Original: FUN_000038fc; source: ID03.c. Recovered name: draw_artificial_horizon [STRONG INFERENCE] (iteration 202).
 * Decoded from ID03.bin bytes at file 0x38fc.
 * Instrument type 9 of draw_instrument. Builds an oval region of the face (NewRgn / OpenRgn / FrameOval / CloseRgn) and a second one with make_inset_face_oval_region, combines them with DiffRgn ($A8E6), saves the clip (GetClip $A87A) and clips to the face (SetClip $A879); computes a rotated line with sine / cosine values through function pointers (jsr (A0); MULU.L then ASR.L #12, 4.12 fixed point) and draws it with MoveTo / LineTo, plus an 8-step loop of marks; restores the clip; uses the handle A5-0x11f6, which ID03 0x5b82 saves with AddResource under STR# 129 slot 80 "HorizonInstrument" [PROVEN], and PtInRgn ($A8E8) tests. Interpreted as the artificial horizon (bank-rotated horizon line in a round face) [STRONG INFERENCE from the resource name and the rotation]. Ghidra truncated the body.
 */
// WARNING: Control flow encountered bad instruction data

void draw_artificial_horizon /* Original: FUN_000038fc */ (void)

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
 *     0 -> draw_altimeter (FUN_00001876)
 *     1 -> draw_airspeed_indicator (FUN_00001b48)
 *     2 -> draw_turn_and_bank_indicator (FUN_00002d1c)
 *     3 -> draw_climb_indicator (FUN_00001fee)
 *     4 -> draw_manifold_pressure_gauge (FUN_00002600)
 *     5 -> draw_tachometer (FUN_000022fe)
 *     6 -> draw_direction_indicator (FUN_00002950)
 *     7 -> (none)         8 -> FUN_000032b8(..., 1)
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



/* Original: FUN_00003f24; source: ID03.c. Recovered name: draw_bevelled_frame [STRONG INFERENCE] (iteration 207).
 * Decoded from ID03.bin bytes at file 0x3f24.
 * C args: eight shorts at +8..+0x16 = outer top, left, bottom, right, then inner top, left, bottom, right (screen coordinates; caller draw_numbered_bevel_box passes outer = rect, inner = rect inset by the bevel). Draws four quadrilateral polygons between the outer and inner rectangles (OpenPoly $A8CB, MoveTo / LineTo, ClosePoly $A8CC; FillPoly $A8CA with the pattern from JT $3e2 (ID02 0x150a), or PaintPoly $A8C7 for the last side), each in its own grey from lookup_palette_index_for_rgb_level levels 1 / 0 / 2 set with set_draw_color_index / set_back_color_index; KillPoly ($A8CD) after each [PROVEN traps]. The side shading gives a raised / sunken 3-D bevel [STRONG INFERENCE]. Callers: draw_numbered_bevel_box (0x41de), FUN_00004304 (0x465e).
 */
// WARNING: Control flow encountered bad instruction data

void draw_bevelled_frame /* Original: FUN_00003f24 */ (void)

{
  int unaff_A5;
  
  (**(code **)(unaff_A5 + 0x45a))(1);
  (**(code **)(unaff_A5 + 0x36a))();
  (**(code **)(unaff_A5 + 0x45a))(0);
  (**(code **)(unaff_A5 + 0x3a2))();
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



/* Original: FUN_00004110; source: ID03.c. Recovered name: draw_numbered_bevel_box [PROVEN] (iteration 207).
 * Decoded from ID03.bin bytes at file 0x4110.
 * C args: +8 Rect *r (in / out), +0xc short number. bevel = design_x_to_screen(20) - design_x_to_screen(0); inner = r inset by bevel; PaintRect(inner) in colour level 0 (black); draw_bevelled_frame(r, inner); *r = inner; colour level 4 at depth 1, else 3; pen = max(1, 10 * A5-0x149e / 480) and a size from scale_design_480_min10(12) (0x56) / 10; draw_vector_number(number, pen ..., centre of the rect converted back to design units: c * 4800 / A5-0x149e). Draws a black box with a bevelled border and a vector-font number in it. Callers: FUN_00004304 (0x46b6, 0x4718, 0x477a; rects A5-0x11c6, -0x11be, -0x11b6).
 */
// WARNING: Control flow encountered bad instruction data

void draw_numbered_bevel_box /* Original: FUN_00004110 */ (void)

{
  int unaff_A5;
  
  (**(code **)(unaff_A5 + 0x3ca))();
  (**(code **)(unaff_A5 + 0x3ca))();
  (**(code **)(unaff_A5 + 0x45a))(0);
  (**(code **)(unaff_A5 + 0x36a))();
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



/* Original: FUN_00004304; source: ID03.c. Recovered name: draw_panel_section_with_numbered_boxes [STRONG INFERENCE mechanics] (iteration 210).
 * Decoded from ID03.bin bytes at file 0x4304.
 * No arguments. Caller: the panel redraw path of prepare_instrument_panel (0x67fa, after A5-0x2114 = 40). PaintRect of the design rect (-400, 750)-(400, 1560) in colour level 0, then (depth 1 or 4: level 0, else level (0, 1, 0)) InsetRect(2, 2) and PaintRect again; the inset rect -> A5-0x11aa; design point (-10, 1150) -> A5-0x11a0 / -0x119e; A5-0x11c8 = depth A5-0x137a; then two 26-step line loops (MoveTo / LineTo, design coordinates through JT $3ca / $382; counters compared with 0x19 and 0x1a) and draw_bevelled_frame around the area; finally three draw_numbered_bevel_box boxes stacked at design x 490..610, y 720..840, 900..1020, 1080..1200 (SetRect $A8A7) with the numbers 1, 3 and 15, their inner rects stored at A5-0x11c6, -0x11be, -0x11b6 [PROVEN, bytes 0x4304..0x478e]. What this panel section shows (and the meaning of 1 / 3 / 15) is not yet known [UNKNOWN]; the name only describes what is drawn.
 */
// WARNING: Control flow encountered bad instruction data

void draw_panel_section_with_numbered_boxes /* Original: FUN_00004304 */ (void)

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



/* Original: FUN_00004790; source: ID03.c. Recovered name: draw_percent_scale_gauge [STRONG INFERENCE] (iteration 208).
 * Decoded from ID03.bin bytes at file 0x4790.
 * Caller: the panel redraw path of prepare_instrument_panel (0x681e) with design arguments (0x14a, 0x258, 7, scale_design_480_min10(10), 0x794, 0x898). Converts its box to screen coordinates (design_x_to_screen / design_y_to_screen, scale_design_4800), PaintRect in colour level 0 and FrameRect ($A8A1) in level 3 (depth 1) or 2; draws ten tick marks (loop i = 0..9, MoveTo / LineTo, y step = height / 9); then into a 3x black-and-white port (new_offscreen_bw_port 0x2a8, SetOrigin(-2, -2)) draws the vector-font numbers 100 and 0 at the top and bottom of the scale (draw_vector_number 0x912), composites it with antialias_downsample_bw_3x (0xa3c) into the panel port A5-0x1496 and disposes the port (0x33c); stores its geometry in the record at A5-0x1186 [PROVEN calls and constants]. A vertical 0-100 percentage scale; which control it shows (throttle?) is open [HYPOTHESIS].
 */
// WARNING: Control flow encountered bad instruction data

void draw_percent_scale_gauge /* Original: FUN_00004790 */ (void)

{
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



/* Original: FUN_00004b32; source: ID03.c. Recovered name: draw_split_display_box [STRONG INFERENCE] (iteration 209).
 * Decoded from ID03.bin bytes at file 0x4b32.
 * Caller: the panel redraw path of prepare_instrument_panel (0x6846) with design arguments (0x17c, 0x17c, 7, scale_design_480_min10(10), 0x474, -0x2a8). PenSize(1, 1); converts the box to screen coordinates (design_x_to_screen / design_y_to_screen, scale_design_4800); PaintRect in colour level 0; FrameRect ($A8A1) in level 2; InsetRect(3, 3); then splits the inset rect at its horizontal centre into a left half stored at A5-0x119c and a right half stored at A5-0x1194 (8-byte Rects) [PROVEN, bytes 0x4b32..0x4c40]. A5-0x119c is the rect that ID02 draw_notched_frame_pair_a5safe (overlay service slot -0x10ea) draws into, and A5-0x1194 is read by ID02 0x1206 / 0x1222 - so this lays out a two-part indicator box on the panel whose contents the overlay draws; which indicator is open [UNKNOWN].
 */
// WARNING: Control flow encountered bad instruction data

void draw_split_display_box /* Original: FUN_00004b32 */ (void)

{
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



// WARNING: Control flow encountered bad instruction data
// WARNING: Removing unreachable block (ram,0x00004cee)
// WARNING: Removing unreachable block (ram,0x00004e00)

/*
 * Original: FUN_00004c42; source: ID03.c:673.
 * Recovered name: draw_flaps_indicator [STRONG INFERENCE] (iteration 171).
 * Not part of the draw_instrument type switch. Loads label slot 75 "FLAPS"
 * from the STR# 129 pointer table [PROVEN, bytes + resource dump] and draws
 * a bezel via draw_ring_with_status_indicators (BSR at file 0x4c58).
 * Gauge identity from the label [STRONG INFERENCE]; internals not annotated.
 */
void draw_flaps_indicator /* Original: FUN_00004c42 */ (undefined4 param_1,undefined4 param_2,undefined4 param_3)

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

/*
 * Original: FUN_00004ecc; source: ID03.c:691.
 * Recovered name: draw_ammo_counter [STRONG INFERENCE] (iteration 171).
 * Not part of the draw_instrument type switch. Loads label slot 76 "AMMO"
 * from the STR# 129 pointer table [PROVEN, bytes + resource dump] and draws
 * a bezel via draw_ring_with_status_indicators (BSR at file 0x4ee2).
 * Gauge identity from the label [STRONG INFERENCE]; internals not annotated.
 */
void draw_ammo_counter /* Original: FUN_00004ecc */ (undefined4 param_1,undefined4 param_2,undefined4 param_3)

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

/* Original: FUN_00005158; source: ID03.c. Recovered name: draw_arc_scale_ticks [STRONG INFERENCE] (iteration 212).
 * Decoded from ID03.bin bytes at file 0x5158.
 * C args (words): +8, +0xa length, +0xc size, +0xe x, +0x10 y, +0x12 side flag. Loop over tick i: angle a = (i * 0x1555 / 12 - 0xaab) & 0x3fff in 1/0x4000 turns (10-degree steps starting at -60 degrees); every fourth tick is a major tick (PenSize(size / 10, size / 10), length 4 * len), the others minor (PenSize(2 * size / 30, ...), length 2 * len); the end points come from the cosine / sine pointers A5-0x2118 / A5-0x211c (4.12) with the side flag selecting the mirrored arc, scaled with scale_design_4800_pen_centred (0xa6) and drawn with MoveTo / LineTo [PROVEN, bytes 0x5158..0x532c]. Callers: the unexported gauge at 0x532e (0x53b0 with flag 1, 0x53e8 with flag 0) - a gauge with a left and a right arc scale.
 * The following bytes 0x532e..0x54fc (not exported by Ghidra) are that gauge, called by the panel redraw path at 0x69c6: bezel (draw_ring_with_status_indicators flags 0x0f), begin_instrument_supersample, the two arcs above, a 24-point label (set_scaled_text_style, DrawString), positions stored at A5-0x1162..-0x1158, finish_instrument_supersample. Its label string and identity are not decoded yet [UNKNOWN].
 */
void draw_arc_scale_ticks /* Original: FUN_00005158 */ (void)

{
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



// WARNING: Control flow encountered bad instruction data

/*
 * Original: FUN_0000532e; source: ID03.c:720.
 * Recovered name: draw_fuel_gauge [STRONG INFERENCE] (iteration 171).
 * Not part of the draw_instrument type switch. Loads label slot 77 "Fuel"
 * from the STR# 129 pointer table [PROVEN, bytes + resource dump] and draws
 * a bezel via draw_ring_with_status_indicators (BSR at file 0x5346).
 * Gauge identity from the label [STRONG INFERENCE]; internals not annotated.
 */
void draw_fuel_gauge /* Original: FUN_0000532e */ (undefined4 param_1,undefined4 param_2,undefined4 param_3)

{
  undefined4 auStack_36 [12];
  
  FUN_00000514(CONCAT22(param_1._0_2_,param_2._0_2_));
  begin_instrument_supersample((undefined2 *)&param_1,(short *)((int)&param_1 + 2),(short *)&param_2,
               CONCAT22(param_2._2_2_,param_3._0_2_),auStack_36);
  draw_arc_scale_ticks();
  draw_arc_scale_ticks();
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



/* Original: FUN_000054fe; source: ID03.c. Recovered name: draw_landing_gear_indicator [STRONG INFERENCE] (iteration 211).
 * Decoded from ID03.bin bytes at file 0x54fe.
 * C args: +8 short size, +0xa short x, +0xc short y, +0xe, +0x10 (caller: the panel redraw path at 0x697e with 0x258, 7, scale_design_480_min10(10), 0x7a8, -0xb2c). draw_ring_with_status_indicators(size, flags 0x0f) (0x514); begin_instrument_supersample; PenSize; stroke drawing from the point table A5-0x1f80 (MoveTo / LineTo with scale_design_4800_pen_centred); TextFont(1), set_scaled_text_style(24) (0x6), GetFontInfo, StringWidth and DrawString of the label held at local -0x1a, loaded from A5-0xe0e = STR# 129 slot 78 "GEAR" (0x5628) [PROVEN]; then stores three screen points and radii at A5-0x1174 / -0x1172, -0x116e / -0x116c, -0x1168 / -0x1166 with radius scale_design_4800(75) in -0x1170, -0x116a, -0x1164 - three indicator lamps, presumably one per landing-gear leg, lit later by the overlay [STRONG INFERENCE]; finish_instrument_supersample (0x1844).
 */
// WARNING: Control flow encountered bad instruction data

void draw_landing_gear_indicator /* Original: FUN_000054fe */ (undefined4 param_1,undefined4 param_2,undefined4 param_3)

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

/* Original: FUN_00005718; source: ID03.c. Recovered name: dial_point_at_angle [STRONG INFERENCE] (iteration 211).
 * Decoded from ID03.bin bytes at file 0x5718.
 * C args: +8 Rect *dial, +0xc short angle in degrees, +0xe short radial offset, +0x10 short *x (out), +0x12 short *y (out). r = half the dial width; step = +5 or -5 by the sign of the offset; returns at once when offset + step == 0. a = (angle - 90) * 0x4000 / 360, normalised into 0..0x4000 (0x4000 = one turn); x = centre x + (A5-0x2118)(a) * r >> 12, y = centre y + (A5-0x211c)(a) * r >> 12 (4.12 fixed point) [PROVEN, Ghidra C]. With 0 degrees at the top (a = 270 degrees), A5-0x2118 behaves as cosine and A5-0x211c as sine [STRONG INFERENCE]; both are copied from A5-0x1062 / A5-0x1066 by prepare_instrument_panel. The truncated tail draws a radial tick (MoveTo / LineTo at 0x5836 / 0x5842). Callers: 0x6468, 0x6532, 0x674c, 0x67c6 (panel redraw path).
 */
void dial_point_at_angle /* Original: FUN_00005718 */ (short *param_1,undefined4 param_2,short *param_3,short *param_4)

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



/* Original: FUN_00005860; source: ID03.c. Recovered name: compute_panel_screen_addresses [STRONG INFERENCE] (iteration 205).
 * Decoded from ID03.bin bytes at file 0x5860.
 * No arguments (complete Ghidra C below). Converts fixed design coordinates with design_y_to_screen (JT $382) and design_x_to_screen (JT $3ca, rounded down to even) into a rectangle and four column / row values (A5-0x1150..-0x113e), then four screen byte addresses A5-0x113c / -0x1138 / -0x1134 / -0x1130 = base A5-0x1382 + y * rowBytes A5-0x1378 + x / (8 / depth), with depth = A5-0x137a [PROVEN arithmetic: 8 / depth = pixels per byte, so A5-0x137a is the pixel depth 1 / 4 / 8 - it is also compared with 4 in remap_cached_panel_colours]. Which panel areas these addresses delimit is not yet known [UNKNOWN]. Caller: prepare_instrument_panel (0x5d46; only BSR found in ID03).
 */
void compute_panel_screen_addresses /* Original: FUN_00005860 */ (void)

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



/* Original: FUN_00005ab6; source: ID03.c. Recovered name: store_panel_bitmaps_as_resources [PROVEN] (iteration 203).
 * Decoded from ID03.bin bytes at file 0x5ab6.
 * No arguments. With panel configuration c = A5-0x13ae: SetResLoad(false) ($A99B); for ids 200, 300, 400, 500 + c: GetResource(HEL2, id) ($A9A0) and RmveResource ($A9AD) of any old copy; SetResLoad(true); UpdateResFile(A5-0x1002) ($A999); then AddResource ($A9AB) of the handles A5-0x12b0, -0x11f6, -0x11dc, -0x11d4 as HEL2 200 / 300 / 400 / 500 + c with the names STR# 129 slots 79 "Bitmap", 80 "HorizonInstrument", 81 "GyroInstrument", 82 "GyroFlags", adding each ResError ($A9AF) to a local count. If any failed: cache entry flag +0xc = 0 (cache = HEL2 127 "Bitmap Cache" at A5-0x13b2, 0x160 bytes per configuration) and A5-0x14a0 = 1, which makes the ID04 routine at 0x432 show STR# 129 slot 1 "Unable to store instrument panel to disk"; otherwise flag +0xc = 1. Finally ChangedResource(cache) ($A9AA) and UpdateResFile. Caller: ID03 0x6ba4.
 * Related (inside the Ghidra range of FUN_00005860, not exported): file 0x59f4..0x5ab4 releases the same four handles - ReleaseResource ($A9A3) when the cache entry of configuration A5-0x211e is flagged as stored, else DisposHandle (ID09 JT $25a) - and clears them [PROVEN, bytes]; callers 0x5ed2, 0x61d6.
 */
// WARNING: Control flow encountered bad instruction data

void store_panel_bitmaps_as_resources /* Original: FUN_00005ab6 */ (void)

{
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



/* Original: FUN_00005c36; source: ID03.c. Recovered name: open_cport_on_buffer [PROVEN] (iteration 204).
 * Decoded from ID03.bin bytes at file 0x5c36.
 * C args: +8 CGrafPort *port (0x6c bytes), +0xc short rowBytes, +0xe Ptr baseAddr, +0x12 Rect bounds (by value). Clears the 0x6c bytes (JT $4f2, ID02 0x2b0), OpenCPort(port) ($AA00), restores thePort; sets the port PixMap (handle at +2): rowBytes (+4), baseAddr (+0), bounds (+6) = bounds; portRect (+0x10) = bounds; RectRgn(visRgn +0x18, &bounds) ($A8DF); returns port. Caller: prepare_instrument_panel (0x5da8, port A5-0x1492 -> A5-0x1496).
 */
// WARNING: Control flow encountered bad instruction data

void open_cport_on_buffer /* Original: FUN_00005c36 */ (undefined4 param_1)

{
  int unaff_A5;
  
  (**(code **)(unaff_A5 + 0x4f2))(param_1);
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



/* Original: FUN_00005cb6; source: ID03.c. Recovered name: close_port_glue [PROVEN] (iteration 204).
 * Decoded from ID03.bin bytes at file 0x5cb6.
 * ClosePort(port +8) ($A87D). Callers: prepare_instrument_panel (0x5d72 for A5-0x11cc, 0x5d92 for A5-0x1496).
 */
// WARNING: Control flow encountered bad instruction data

void close_port_glue /* Original: FUN_00005cb6 */ (void)

{
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



/* Original: FUN_00005cc4; source: ID03.c. Recovered name: prepare_instrument_panel [STRONG INFERENCE] (iteration 204).
 * Decoded from ID03.bin bytes at file 0x5cc4.
 * Reached through JT $17a (CODE 0 entry -> ID03 0x5cc4). Partly decoded [PROVEN, bytes 0x5cc4..0x5f20]: saves CurResFile ($A994) and UseResFile(A5-0x1002) ($A998); panel scale A5-0x149e = A5-0x149a = (w / 2 + w) / 2 for the half view width w = A5-0x1372 (the factor used by scale_design_4800); copies A5-0x1066 / -0x1062 to A5-0x211c / -0x2118; cache = GetResource(HEL2, 127) -> A5-0x13b2, or NewHandleClear(0x580) added as HEL2 127 "Bitmap Cache" (STR# 129 slot 83) - 4 entries of 0x160 bytes; calls FUN_00005860; closes the old ports A5-0x11cc / A5-0x1496 (close_port_glue) and disposes the region A5-0x13b6 ($A8D9); opens A5-0x1492 with open_cport_on_buffer; then searches the 4 cache entries for one whose +0 / +2 / +4 / +6 / +8 equal A5-0x137a (1-bit mode), A5-0x137e, A5-0x137c, A5-0x1372, A5-0x1370 (view size) and that is the current configuration A5-0x13ae or flagged stored (+0xc); for a stored entry it copies its ten 16-byte instrument records (+0x12) to A5-0x12a2 and 20 bytes (+0xb2) to A5-0x1202, releases the current bitmaps (0x59f4) and loads HEL2 300 + entry ... as A5-0x11f6 and the others. So rendered panels are reused from disk when the display configuration matches [STRONG INFERENCE]; the rest of the function (redraw path) is not yet decoded.
 */
// WARNING: Control flow encountered bad instruction data

void prepare_instrument_panel /* Original: FUN_00005cc4 */ (void)

{
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



/* Original: FUN_00006c1c; source: ID03.c. Recovered name: remap_cached_panel_colours [STRONG INFERENCE] (iteration 205).
 * Decoded from ID03.bin bytes at file 0x6c1c.
 * Reached through JT $182 (CODE 0 entry -> ID03 0x6c1c). Returns at once unless the current configuration A5-0x13ae has a cache entry (A5-0x13b2) whose key (+0 depth, +2, +4, +6 / +8 view size) matches the display. In 1-bit mode calls JT $482 (ID02 0x4b62, the standard colour index set-up). Otherwise builds a 256-word translation table on the stack, keyed by the entry word +0xa & 0x1fff and a switch on the depth (JT $2a), walks the pixels of the panel bitmaps (A5-0x12b0, port A5-0x1496, A5-0x11dc with mask A5-0x11de and sizes A5-0x11e2 / -0x11e4) replacing bytes through the table, and refreshes many palette-index globals (A5-0x11fa, -0x11f8, -0x11ae, -0x11ac, -0x11a2, -0x118c, -0x118a, -0x1188, -0x117e, -0x117c, -0x112c, -0x12a4) with lookup_palette_index_for_rgb_level (JT $45a); at depth 4 some are OR-combined with themselves shifted (0x70a0 / 0x7184) [PROVEN calls]. So a panel loaded from the cache is re-coloured for the current palette [STRONG INFERENCE]. Exact table semantics not decoded.
 */
// WARNING: Control flow encountered bad instruction data

void remap_cached_panel_colours /* Original: FUN_00006c1c */ (void)

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



/* Original: FUN_000071a2; source: ID03.c. Recovered name: remap_panel_colours_identity [STRONG INFERENCE] (iteration 212).
 * Decoded from ID03.bin bytes at file 0x71a2.
 * Builds an identity table of 256 words on the stack (t[i] = i) and calls remap_cached_panel_colours(t, A5-0x1354) (0x6c1c). Note for remap_cached_panel_colours: its first argument is this 256-entry index table and its second is A5-0x1354 [PROVEN, bytes 0x71a2..0x71d2]. Callers: 0x60e2 and 0x6ba8 (prepare_instrument_panel).
 */
void remap_panel_colours_identity /* Original: FUN_000071a2 */ (void)

{
  short sVar1;
  short local_204 [256];
  
  for (sVar1 = 0; sVar1 < 0x100; sVar1 = sVar1 + 1) {
    local_204[sVar1] = sVar1;
  }
  remap_cached_panel_colours();
  return;
}


