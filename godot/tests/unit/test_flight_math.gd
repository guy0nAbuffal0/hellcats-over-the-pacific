extends RefCounted

const Assertions := preload("res://godot/tests/helpers/assertions.gd")
const FlightMathScript := preload("res://hellcats/core/flight_math.gd")

func run() -> bool:
	var ok := true
	ok = _test_fun_0000e42a() and ok
	ok = _test_fun_0000e468() and ok
	ok = _test_fun_0000e570() and ok
	ok = _test_compute_local_34() and ok
	ok = _test_compute_local_46() and ok
	ok = _test_apply_movement_626_step() and ok
	ok = _test_fun_0000e4a4_and_e468_drag() and ok
	ok = _test_movement_626_reverse_clamp() and ok
	ok = _test_compute_reverse_local_48() and ok
	ok = _test_field_18e_63e() and ok
	ok = _test_ivar25_stall_step() and ok
	ok = _test_028dc_position_commit() and ok
	ok = _test_landing_touchdown_63e() and ok
	ok = _test_landing_pitch_followon() and ok
	ok = _test_fun_0000e40c() and ok
	ok = _test_fun_00013452_empty_list() and ok
	ok = _test_fun_000025a8_identity() and ok
	ok = _test_fun_0000253e() and ok
	ok = _test_fun_00002d10_null_aux() and ok
	ok = _test_fun_00001a68_route() and ok
	ok = _test_fun_00001974_fresh_small_bin() and ok
	ok = _test_fun_00001a68_freelist() and ok
	ok = _test_fun_0000199a_large_alloc() and ok
	ok = _test_fun_00004690_vtable_plus8() and ok
	ok = _test_fun_000019d0_large_coalesce() and ok
	ok = _test_fun_00000054_first_loop() and ok
	ok = _test_fun_00000054_block_b() and ok
	ok = _test_fun_00000054_block_c() and ok
	ok = _test_fun_00000054_block_d() and ok
	ok = _test_fun_00016a3a_factory() and ok
	ok = _test_fun_000115b0_factory() and ok
	ok = _test_fun_0000262e_identity() and ok
	ok = _test_fun_0000e372() and ok
	ok = _test_fun_00001f22() and ok
	ok = _test_grounded_speed_recommit() and ok
	ok = _test_grounded_field_0b_switch() and ok
	ok = _test_lab_0000f47c() and ok
	ok = _test_e792_char_epilogue() and ok
	ok = _test_e792_weapon_19d_branch() and ok
	ok = _test_fun_00012840_spawn_fields() and ok
	ok = _test_fun_00019430_spawn_fields() and ok
	ok = _test_fun_00019430_vertex_loop() and ok
	ok = _test_fun_00015bf6_helpers() and ok
	ok = _test_fun_0001a63e_copy_matrix9() and ok
	ok = _test_fun_00005116_slot_helpers() and ok
	ok = _test_contact_61a_61e_attitude() and ok
	ok = _test_e792_weapon_676_677_branch() and ok
	ok = _test_e792_bvar6_cleanup() and ok
	ok = _test_e792_flags685_bit2_tail() and ok
	return ok

func _test_fun_0000e42a() -> bool:
	var ok := true
	var cases := [
		{"input": 0x00000000, "want": -15264},
		{"input": 0x00008000, "want": -30816},
		{"input": 0x00010000, "want": 19168},
		{"input": 0x00018000, "want": -4889},
		{"input": 0x00070000, "want": 2},
		{"input": 0x00078000, "want": -32557},
		{"input": 0x00080000, "want": 2},
	]
	for c in cases:
		ok = Assertions.assert_equal(
			FlightMathScript.fun_0000e42a(c["input"]),
			c["want"],
			"FUN_0000e42a(0x%x)" % c["input"]
		) and ok
	return ok

func _test_fun_0000e468() -> bool:
	var ok := true
	var cases := [
		{"param_1": 0x100, "param_2": 1000, "want": 938},
		{"param_1": 0x300, "param_2": 1000, "want": 1000},
		{"param_1": 0x100, "param_2": -1000, "want": -938},
	]
	for c in cases:
		ok = Assertions.assert_equal(
			FlightMathScript.fun_0000e468(c["param_1"], c["param_2"]),
			c["want"],
			"FUN_0000e468(%d, %d)" % [c["param_1"], c["param_2"]]
		) and ok
	return ok

func _test_fun_0000e570() -> bool:
	var ok := true
	var cases := [
		{"field_38": 1000, "param_1": 100, "want": 1890},
		{"field_38": 25000, "param_1": 421, "want": 25000},
		{"field_38": 25000, "param_1": 511, "want": 22070},
	]
	for c in cases:
		ok = Assertions.assert_equal(
			FlightMathScript.fun_0000e570(c["field_38"], c["param_1"]),
			c["want"],
			"FUN_0000e570(%d, %d)" % [c["field_38"], c["param_1"]]
		) and ok
	return ok

func _test_compute_local_34() -> bool:
	var ok := true
	ok = Assertions.assert_equal(
		FlightMathScript.compute_local_34(60, 400, 5000, 0, 300),
		0,
		"compute_local_34 zero control"
	) and ok
	ok = Assertions.assert_equal(
		FlightMathScript.compute_local_34(60, 400, 5000, 9, 300),
		60,
		"compute_local_34 template_3c branch"
	) and ok
	ok = Assertions.assert_equal(
		FlightMathScript.compute_local_34(60, 200, 5000, 9, 300),
		16,
		"compute_local_34 local_26 branch"
	) and ok
	return ok

func _test_compute_local_46() -> bool:
	var ok := true
	## denom 0 → 0
	ok = Assertions.assert_equal(
		FlightMathScript.compute_local_46(-0xa25, 9),
		0,
		"compute_local_46 zero denom"
	) and ok
	## sVar15=100, sVar21=9 → denom=84, div=287, (287*9*0x666)>>5 = 132217
	ok = Assertions.assert_equal(
		FlightMathScript.compute_local_46(100, 9),
		132217,
		"compute_local_46 literal 0x666 factor"
	) and ok
	## Prove factor is constant 0x666, not entity field 0x666 (field often 0 → product 0).
	ok = Assertions.assert_true(
		FlightMathScript.compute_local_46(100, 9) != 0,
		"compute_local_46 non-zero with control"
	) and ok
	return ok

func _test_apply_movement_626_step() -> bool:
	var ok := true
	## iVar20=0x500 < 0xca8, tpl_36=0x600 not < iVar20 → s21=(0x1000*0x200)>>9=0x1000
	## scale=16, err=0x1000-(0x800-0x100)=0x900, prod=0x9000, delta=0x90 → 0x800+0x90=0x890
	ok = Assertions.assert_equal(
		FlightMathScript.apply_movement_626_step(0x800, 0x1000, 0x500, 0x200, 0x600, 0x100),
		0x890,
		"movement_626 low-speed branch"
	) and ok
	## iVar20 >= 0xca8 → s21=movement_662, scale=0x2a
	## err=0x200-(0-0)=0x200, prod=0x2a*0x200=0x5400, delta=0x54
	ok = Assertions.assert_equal(
		FlightMathScript.apply_movement_626_step(0, 0x200, 0xD00, 0x200, 0x100, 0),
		0x54,
		"movement_626 high-speed branch"
	) and ok
	ok = Assertions.assert_equal(
		FlightMathScript.movement_626_scale(0xCA8),
		0x2A,
		"movement_626_scale at threshold"
	) and ok
	return ok

func _test_fun_0000e4a4_and_e468_drag() -> bool:
	var ok := true
	## Overspeed: 626=0x890 > tpl_34=0x200 → field_19e=0xC, value=0 (span clamps to 0).
	var over: Dictionary = FlightMathScript.fun_0000e4a4(0x890, 0, 0, 0, 0x400, 0, 0, 0x200)
	ok = Assertions.assert_equal(int(over.get("value", -1)), 0, "e4a4 overspeed value") and ok
	ok = Assertions.assert_equal(int(over.get("field_19e", -1)), 0x0C, "e4a4 overspeed sets 0xC") and ok
	## e468(-0x100, e42a(0)) = -12402; linear drag with iVar19=0 → 0
	ok = Assertions.assert_equal(
		FlightMathScript.apply_e468_linear_drag(0x500, 0, 0x100, -12402, 1),
		0,
		"e468 linear drag zero thrust index"
	) and ok
	## Low-speed e4a4: 626=0x100 < 0x200 → value=0x1000; drag → -422 (DIVS toward zero, not floor).
	var low: Dictionary = FlightMathScript.fun_0000e4a4(0x100, 0, 0, 0, 0x400, 0, 0, 0x200)
	ok = Assertions.assert_equal(int(low.get("value", -1)), 0x1000, "e4a4 low-speed value") and ok
	ok = Assertions.assert_equal(
		FlightMathScript.apply_e468_linear_drag(0x500, 0x1000, 0x100, -12402, 1),
		-422,
		"e468 linear drag (asm 0xEDF8 divisor)"
	) and ok
	ok = Assertions.assert_equal(
		FlightMathScript.fun_0000e468(-0x100, -15264),
		-12402,
		"e468 fixture matches drag divisor"
	) and ok
	## Quadratic raw (asm 0xEE50) then 0x636 thrust with sVar12=1.
	ok = Assertions.assert_equal(
		FlightMathScript.apply_e468_quadratic_drag_raw(0x500, 0x1000, 0x100, 0x50, -12402),
		-10561,
		"e468 quadratic drag raw"
	) and ok
	var thrust: Dictionary = FlightMathScript.apply_thrust_636_step(
		0, 0x500 << 2, 0x500, -10561, -15264, 1, 0x10, 0, 0
	)
	ok = Assertions.assert_equal(int(thrust.get("quad_term", 1)), -8, "thrust quad_term") and ok
	ok = Assertions.assert_equal(int(thrust.get("thrust_term", 1)), 0, "thrust term idle") and ok
	ok = Assertions.assert_equal(int(thrust.get("movement_636", 1)), 0, "636 remainder") and ok
	ok = Assertions.assert_equal(
		int(thrust.get("movement_62a", 0)),
		(0x500 << 2) + 8,
		"iVar25 -= total/sVar12 (negative total adds)"
	) and ok
	return ok

func _test_movement_626_reverse_clamp() -> bool:
	var ok := true
	## Hard cap: tpl_42 < 626 → 626 = tpl_42; iVar20 >= tpl_48 skips blend.
	ok = Assertions.assert_equal(
		FlightMathScript.apply_movement_626_reverse_clamp(0x500, 0x900, 0x200, 0x100, 0x800),
		0x200,
		"626 reverse hard clamp"
	) and ok
	## Blend band: no hard clamp, interpolate between tpl_42 and current.
	## (0x180-0x200)*(0x400-0x200)/(0x800-0x200) = -0x10000/0x600 → -42; 0x200-42=0x1D6
	ok = Assertions.assert_equal(
		FlightMathScript.apply_movement_626_reverse_clamp(0x180, 0x400, 0x200, 0x200, 0x800),
		0x1D6,
		"626 reverse blend clamp"
	) and ok
	## Below tpl_46 → force tpl_42
	ok = Assertions.assert_equal(
		FlightMathScript.apply_movement_626_reverse_clamp(0x300, 0x100, 0x200, 0x200, 0x800),
		0x200,
		"626 reverse below tpl_46"
	) and ok
	return ok

func _test_compute_reverse_local_48() -> bool:
	var ok := true
	ok = Assertions.assert_equal(
		FlightMathScript.compute_reverse_local_48(0x8000, 0x4000, 0x200),
		0x40,
		"reverse local_48 high-half path"
	) and ok
	## (iVar19>>1) >= 0x10000 → local_48 = movement_666 >> 2
	ok = Assertions.assert_equal(
		FlightMathScript.compute_reverse_local_48(0x10000, 0x8000, 0x200),
		0x80,
		"reverse local_48 overflow path"
	) and ok
	return ok

func _test_field_18e_63e() -> bool:
	var ok := true
	var d: Dictionary = FlightMathScript.compute_63e_thrust_delta(
		0x100, 0x2D, 0, 0, 0, 0x200, 0x10, 0x20, 0x04
	)
	ok = Assertions.assert_equal(int(d.get("thrust_delta", -1)), 0x10, "63e reverse uses tpl_2e") and ok
	d = FlightMathScript.compute_63e_thrust_delta(
		0x300, 0x2D, 0, 0, 0, 0x200, 0x10, 0x20, 0x04
	)
	ok = Assertions.assert_equal(int(d.get("thrust_delta", -1)), 0x20, "63e reverse uses tpl_30") and ok
	d = FlightMathScript.compute_63e_thrust_delta(
		0x100, 0, 0, 0x10, 0, 0, 0, 0, 0x10
	)
	ok = Assertions.assert_equal(int(d.get("thrust_delta", -1)), 0x18, "63e non-reverse status 0x10") and ok
	ok = Assertions.assert_true(bool(d.get("set_dat_0001b850", false)), "63e non-reverse sets b850 flag") and ok
	var u: Dictionary = FlightMathScript.apply_field_18e_update(0, 0x10, 0)
	ok = Assertions.assert_equal(int(u.get("field_18e", -1)), 0x5B0, "field_18e low update") and ok
	ok = Assertions.assert_equal(int(u.get("movement_62a_delta", -1)), 0, "18e 62a delta low") and ok
	## 0x100*(0x5b+422)=0x20100 → store low12 of short form; delta = 0x20100>>12 = 0x20
	u = FlightMathScript.apply_field_18e_update(0, 0x100, -422)
	ok = Assertions.assert_equal(int(u.get("field_18e", -1)), 0x100, "field_18e with drag ivar10") and ok
	ok = Assertions.assert_equal(int(u.get("movement_62a_delta", -1)), 0x20, "18e 62a delta high") and ok
	return ok

func _test_ivar25_stall_step() -> bool:
	var ok := true
	## field_190==1 subtracts 0xb6; local_34<<2/sVar12 added; result <1 → stall.
	var s: Dictionary = FlightMathScript.apply_ivar25_stall_step(0x50, 1, 0, 1, true, true, 1)
	ok = Assertions.assert_equal(int(s.get("movement_62a", -1)), 0, "stall zeros iVar25") and ok
	ok = Assertions.assert_equal(int(s.get("field_190", -1)), 2, "stall sets field_190=2") and ok
	ok = Assertions.assert_true(bool(s.get("stalled", false)), "stall flag") and ok
	ok = Assertions.assert_true(bool(s.get("set_dat_0001b868", false)), "stall sets b868 for player") and ok
	## Healthy: local_34 contributes positive speed.
	s = FlightMathScript.apply_ivar25_stall_step(100, 0, 50, 2, true, false, 0)
	## (50<<2)/2 + 100 = 100 + 100 = 200
	ok = Assertions.assert_equal(int(s.get("movement_62a", -1)), 200, "local_34 adds into iVar25") and ok
	ok = Assertions.assert_true(not bool(s.get("stalled", true)), "no stall when healthy") and ok
	return ok

func _test_028dc_position_commit() -> bool:
	var ok := true
	var id: Array = FlightMathScript.identity_matrix_9()
	var r: Dictionary = FlightMathScript.fun_000028dc_one(0, 0x400, 0x800, id)
	ok = Assertions.assert_equal(int(r.get("local_e", -1)), 0, "028dc identity local_e") and ok
	ok = Assertions.assert_equal(int(r.get("local_a", -1)), 0x400, "028dc identity local_a") and ok
	ok = Assertions.assert_equal(int(r.get("local_6", -1)), 0x800, "028dc identity local_6") and ok
	## ivar10=0x400, ivar25=0x800, field_18c=0x40 → param_1[3]=(0x400+0x40)>>6=0x11
	var c: Dictionary = FlightMathScript.apply_position_commit_after_028dc(0x400, 0x800, 0x40, id)
	ok = Assertions.assert_equal(int(c.get("field_18c", 0)), 0xFFA5, "field_18c reset 0xffa5") and ok
	ok = Assertions.assert_equal(int(c.get("param_1_2", -1)), 0, "param_1[2] >>6") and ok
	ok = Assertions.assert_equal(int(c.get("param_1_3", -1)), 0x11, "param_1[3] >>6") and ok
	ok = Assertions.assert_equal(int(c.get("param_1_4", -1)), 0x20, "param_1[4] >>6") and ok
	return ok

func _test_landing_touchdown_63e() -> bool:
	var ok := true
	## surface=1000, iVar23=950 → need pvc < -50; result pvc=-50, 63e=1
	var land: Dictionary = FlightMathScript.apply_landing_touchdown_63e(0, -60, 1000, 950)
	ok = Assertions.assert_true(bool(land.get("applied", false)), "landing applied") and ok
	ok = Assertions.assert_equal(int(land.get("field_63e", -1)), 1, "landing sets 63e") and ok
	ok = Assertions.assert_equal(int(land.get("position_velocity_c", 1)), -50, "landing pvc") and ok
	land = FlightMathScript.apply_landing_touchdown_63e(0, 0, 1000, 950)
	ok = Assertions.assert_true(not bool(land.get("applied", true)), "no landing when pvc too high") and ok
	var air: Dictionary = FlightMathScript.apply_airborne_clear_63e(1, 100, 1000, 950, 0x1000)
	ok = Assertions.assert_true(bool(air.get("applied", false)), "airborne clear applied") and ok
	ok = Assertions.assert_equal(int(air.get("field_63e", -1)), 0, "airborne clears 63e") and ok
	ok = Assertions.assert_equal(int(air.get("status_1a1", -1)), 0, "airborne clears status 0x1000") and ok
	return ok

func _test_fun_0000e40c() -> bool:
	var ok := true
	ok = Assertions.assert_equal(FlightMathScript.fun_0000e40c(0), 0, "e40c(0)") and ok
	ok = Assertions.assert_equal(FlightMathScript.fun_0000e40c(0x2000), 0x2000, "e40c at +0x2000") and ok
	ok = Assertions.assert_equal(FlightMathScript.fun_0000e40c(0x2001), 0x2001 - 0x4000, "e40c fold +") and ok
	ok = Assertions.assert_equal(FlightMathScript.fun_0000e40c(-0x2001), -0x2001 + 0x4000, "e40c fold -") and ok
	return ok

func _test_fun_00013452_empty_list() -> bool:
	var ok := true
	## count==0 → first decrement hits -1 → return bda8+0x16
	var r: int = FlightMathScript.fun_00013452(0x11, 0x22, 0x33, 0, 0x70)
	ok = Assertions.assert_equal(r, 0x70, "13452 empty-list returns bda8+0x16") and ok
	r = FlightMathScript.fun_00013346(1, 2, 3, 0, 0x10)
	ok = Assertions.assert_equal(r, 0x10, "13346 empty-list") and ok
	return ok

## [RECONSTRUCTED] FUN_0000262e / 021e0 identity and X-axis twin of 025a8.
func _test_fun_0000262e_identity() -> bool:
	var ok := true
	var sc: Dictionary = {"c3": 0x1000, "s3": 0}
	var m: Array = FlightMathScript.fun_000021e0(sc)
	ok = Assertions.assert_equal(int(m[0]), 0x1000, "021e0[0]") and ok
	ok = Assertions.assert_equal(int(m[4]), 0x1000, "021e0[4]") and ok
	ok = Assertions.assert_equal(int(m[8]), 0x1000, "021e0[8]") and ok
	ok = Assertions.assert_equal(int(m[5]), 0, "021e0[5]") and ok
	m = FlightMathScript.fun_0000262e(0, 0, 0, 0)
	ok = Assertions.assert_equal(int(m[0]), 0x1000, "0262e[0] identity") and ok
	ok = Assertions.assert_equal(int(m[4]), 0x1000, "0262e[4] identity") and ok
	ok = Assertions.assert_equal(int(m[8]), 0x1000, "0262e[8] identity") and ok
	## Nonzero yaw (p1→c3/s3): 0262e differs from 025a8 (021e0 vs 021a0).
	var a8: Array = FlightMathScript.fun_000025a8(0x400, 0, 0, 0)
	var e2: Array = FlightMathScript.fun_0000262e(0x400, 0, 0, 0)
	ok = Assertions.assert_true(int(a8[0]) != int(e2[0]) or int(a8[4]) != int(e2[4]), "0262e≠025a8") and ok
	return ok

## [RECONSTRUCTED] FUN_0000199a + 01a68 large take/split (2043–2059 / 2163–2191).
func _test_fun_0000199a_large_alloc() -> bool:
	var ok := true
	var st: Dictionary = {"heap_cursor": 0, "heap_base": 0x4000}
	var a: Dictionary = FlightMathScript.apply_01a68_alloc(0x40, st)
	ok = Assertions.assert_true(bool(a.get("ok", false)), "large ok") and ok
	ok = Assertions.assert_true(bool(a.get("from_0199a", false)), "via 0199a") and ok
	ok = Assertions.assert_equal(int(a.get("large_words", -1)), 9, "9 words") and ok
	ok = Assertions.assert_equal(int(a.get("header_byte", -1)), 0xFF, "tag ff") and ok
	ok = Assertions.assert_equal(int(a.get("payload_ptr", -1)), 0x4008, "pay+8") and ok
	ok = Assertions.assert_equal(int(st.get("heap_cursor", -1)), 72, "9<<3") and ok
	var p1: int = int(a.get("payload_ptr", 0))
	## free then realloc → reuse without bump
	var fr: Dictionary = FlightMathScript.apply_019d0_free_large(p1, st)
	ok = Assertions.assert_true(bool(fr.get("ok", false)), "large free") and ok
	var b: Dictionary = FlightMathScript.apply_01a68_alloc(0x40, st)
	ok = Assertions.assert_true(not bool(b.get("from_0199a", true)), "reuse") and ok
	ok = Assertions.assert_equal(int(b.get("payload_ptr", -1)), p1, "same pay") and ok
	ok = Assertions.assert_equal(int(st.get("heap_cursor", -1)), 72, "no bump") and ok
	## split: grow 20 words, alloc 9 → remain 11
	st = {"heap_cursor": 0, "heap_base": 0x5000}
	FlightMathScript.apply_0199a_fresh_large(20, st)
	var c: Dictionary = FlightMathScript.apply_01a68_large_alloc(0x40, st)
	ok = Assertions.assert_true(bool(c.get("split", false)), "split") and ok
	ok = Assertions.assert_equal(int(c.get("large_words", -1)), 9, "took 9") and ok
	ok = Assertions.assert_equal(
		int((st["large_free"] as Array)[0]["words"]), 11, "remain 11"
	) and ok
	## dispatch: small still works via apply_01a68_alloc
	var s: Dictionary = FlightMathScript.apply_01a68_alloc(10, st)
	ok = Assertions.assert_true(bool(s.get("use_small_bins", true)) or int(s.get("size_class", -1)) == 4, "small") and ok
	return ok

## [RECONSTRUCTED] FUN_000019d0 large adjacent coalesce (2101–2112).
func _test_fun_000019d0_large_coalesce() -> bool:
	var ok := true
	var st: Dictionary = {"heap_cursor": 0, "heap_base": 0x6000}
	## two adjacent 9-word larges (0x40 → 9 words each)
	var a: Dictionary = FlightMathScript.apply_01a68_alloc(0x40, st)
	var b: Dictionary = FlightMathScript.apply_01a68_alloc(0x40, st)
	var p1: int = int(a.get("payload_ptr", 0))
	var p2: int = int(b.get("payload_ptr", 0))
	ok = Assertions.assert_equal(p2, p1 + 9 * 8, "adjacent pay") and ok
	## free higher then lower → forward absorb into one 18-word free
	FlightMathScript.apply_019d0_free_large(p2, st)
	var fr: Dictionary = FlightMathScript.apply_019d0_free_large(p1, st)
	ok = Assertions.assert_true(bool(fr.get("coalesce", false)), "coalesced") and ok
	ok = Assertions.assert_true(bool(fr.get("coalesced_forward", false)), "forward") and ok
	ok = Assertions.assert_equal(int(fr.get("words", -1)), 18, "18 words") and ok
	ok = Assertions.assert_equal((st["large_free"] as Array).size(), 1, "1 free") and ok
	## 0x80 → 17 words; fits in merged 18 without 0199a (split remain 1)
	var c: Dictionary = FlightMathScript.apply_01a68_alloc(0x80, st)
	ok = Assertions.assert_true(not bool(c.get("from_0199a", true)), "reuse merged") and ok
	ok = Assertions.assert_equal(int(c.get("large_words", -1)), 17, "took 17") and ok
	ok = Assertions.assert_true(bool(c.get("split", false)), "split") and ok
	## backward merge: free low then high
	st = {"heap_cursor": 0, "heap_base": 0x7000}
	a = FlightMathScript.apply_01a68_alloc(0x40, st)
	b = FlightMathScript.apply_01a68_alloc(0x40, st)
	p1 = int(a.get("payload_ptr", 0))
	p2 = int(b.get("payload_ptr", 0))
	FlightMathScript.apply_019d0_free_large(p1, st)
	fr = FlightMathScript.apply_019d0_free_large(p2, st)
	ok = Assertions.assert_true(bool(fr.get("coalesced_backward", false)), "backward") and ok
	ok = Assertions.assert_equal(int(fr.get("words", -1)), 18, "back 18") and ok
	## factory slot write helper
	var sf: Dictionary = FlightMathScript.apply_1b524_set_factory(0x1000, 0x16A1A)
	ok = Assertions.assert_equal(int(sf.get("factory_offset", -1)), 6, "+6") and ok
	ok = Assertions.assert_equal(int(sf.get("factory_addr", -1)), 0x16A1A, "addr") and ok
	return ok

## [RECONSTRUCTED] FUN_00000054 Block A: 4×0x4A → DAT_0001b524[key] (Capstone 0x58–0xA0).
func _test_fun_00000054_first_loop() -> bool:
	var ok := true
	var recs: Array = FlightMathScript.load_00054_template_records_4a()
	ok = Assertions.assert_equal(recs.size(), 4, "4 records") and ok
	ok = Assertions.assert_equal(int((recs[0] as Dictionary).get("key", -1)), 0x5858, "key0") and ok
	ok = Assertions.assert_equal(int((recs[1] as Dictionary).get("key", -1)), 0x0999, "key1") and ok
	var st: Dictionary = {"heap_cursor": 0, "heap_base": 0x8000}
	var table: Dictionary = {}
	var loop: Dictionary = FlightMathScript.apply_00054_first_loop(st, table)
	ok = Assertions.assert_true(bool(loop.get("ok", false)), "loop ok") and ok
	ok = Assertions.assert_equal(int(loop.get("record_count", -1)), 4, "4 steps") and ok
	ok = Assertions.assert_equal(table.size(), 2, "2 live keys") and ok
	ok = Assertions.assert_true(table.has(0x5858), "has 5858") and ok
	ok = Assertions.assert_true(table.has(0x0999), "has 0999") and ok
	## last 0x0999 overwrite wins
	var steps: Array = loop.get("steps", []) as Array
	var last_alloc: Dictionary = (steps[3] as Dictionary).get("alloc", {}) as Dictionary
	var first_alloc: Dictionary = (steps[0] as Dictionary).get("alloc", {}) as Dictionary
	var last_ptr: int = int(last_alloc.get("payload_ptr", -1))
	var first_ptr: int = int(first_alloc.get("payload_ptr", -1))
	ok = Assertions.assert_equal(int(table[0x0999]), last_ptr, "0999 last") and ok
	ok = Assertions.assert_equal(int(table[0x5858]), first_ptr, "5858 first") and ok
	ok = Assertions.assert_true(first_ptr != last_ptr, "distinct payloads") and ok
	## publish helper sign-extend
	var t2: Dictionary = {}
	var pub: Dictionary = FlightMathScript.apply_00054_publish_slot(t2, 0xF000, 0xABCD)
	ok = Assertions.assert_equal(int(pub.get("key_signed", 0)), -4096, "s16 key") and ok
	ok = Assertions.assert_equal(int(t2[-4096]), 0xABCD, "neg slot") and ok
	return ok

## [RECONSTRUCTED] FUN_00000054 Block B: 16 fixed slots → DAT_0001b538…1b574.
func _test_fun_00000054_block_b() -> bool:
	var ok := true
	var recs: Array = FlightMathScript.load_00054_block_b_records()
	ok = Assertions.assert_equal(recs.size(), 16, "16 records") and ok
	var sizes: Array = []
	for r in recs:
		sizes.append(int((r as Dictionary).get("size", 0)))
	ok = Assertions.assert_true(sizes.count(0x20) == 1, "one 0x20") and ok
	ok = Assertions.assert_true(sizes.count(0x1A) == 15, "fifteen 0x1A") and ok
	var st: Dictionary = {"heap_cursor": 0, "heap_base": 0xB000}
	var slots: Dictionary = {}
	var loop: Dictionary = FlightMathScript.apply_00054_block_b(st, slots)
	ok = Assertions.assert_true(bool(loop.get("ok", false)), "block b ok") and ok
	ok = Assertions.assert_equal(slots.size(), 16, "16 slots") and ok
	ok = Assertions.assert_true(slots.has(0x1B540), "has 1b540") and ok
	ok = Assertions.assert_equal(int(loop.get("dat_0001b540", -1)), int(slots[0x1B540]), "1b540 ptr") and ok
	ok = Assertions.assert_true(int(slots[0x1B540]) != 0, "1b540 nonzero") and ok
	ok = Assertions.assert_true(slots.has(0x1B554), "has 0x20 slot") and ok
	return ok

## [RECONSTRUCTED] FUN_00000054 Block C: 5×0x1C keyed → DAT_0001b524 (ROM keys all 0).
func _test_fun_00000054_block_c() -> bool:
	var ok := true
	var recs: Array = FlightMathScript.load_00054_block_c_records()
	ok = Assertions.assert_equal(recs.size(), 5, "5 records") and ok
	for r in recs:
		ok = Assertions.assert_equal(int((r as Dictionary).get("key", -1)), 0, "key0") and ok
	var st: Dictionary = {"heap_cursor": 0, "heap_base": 0xC000}
	var table: Dictionary = {}
	var loop: Dictionary = FlightMathScript.apply_00054_block_c(st, table)
	ok = Assertions.assert_true(bool(loop.get("ok", false)), "block c ok") and ok
	ok = Assertions.assert_equal(int(loop.get("record_count", -1)), 5, "5 steps") and ok
	ok = Assertions.assert_equal(table.size(), 1, "1 live key") and ok
	ok = Assertions.assert_true(table.has(0), "has key 0") and ok
	var steps: Array = loop.get("steps", []) as Array
	var last_ptr: int = int((steps[4] as Dictionary).get("alloc", {}).get("payload_ptr", -1))
	ok = Assertions.assert_equal(int(table[0]), last_ptr, "last wins") and ok
	return ok

## [RECONSTRUCTED] FUN_00000054 Block D: 5×0x1A → DAT_0001b58c…1b59c.
func _test_fun_00000054_block_d() -> bool:
	var ok := true
	var recs: Array = FlightMathScript.load_00054_block_d_records()
	ok = Assertions.assert_equal(recs.size(), 5, "5 records") and ok
	ok = Assertions.assert_equal(int((recs[0] as Dictionary).get("slot_abs", -1)), 0x1B58C, "1b58c") and ok
	ok = Assertions.assert_equal(int((recs[4] as Dictionary).get("slot_abs", -1)), 0x1B59C, "1b59c") and ok
	var st: Dictionary = {"heap_cursor": 0, "heap_base": 0xD000}
	var slots: Dictionary = {}
	var loop: Dictionary = FlightMathScript.apply_00054_block_d(st, slots)
	ok = Assertions.assert_true(bool(loop.get("ok", false)), "block d ok") and ok
	ok = Assertions.assert_equal(slots.size(), 5, "5 slots") and ok
	ok = Assertions.assert_true(slots.has(0x1B58C) and slots.has(0x1B59C), "ends") and ok
	ok = Assertions.assert_equal(int(loop.get("dat_0001b58c", -1)), int(slots[0x1B58C]), "58c ptr") and ok
	ok = Assertions.assert_true(int(slots[0x1B58C]) != int(slots[0x1B59C]), "distinct") and ok
	return ok

## [RECONSTRUCTED] FUN_00016a3a factory (+0x20 fixup from install imm 0x16a1a).
func _test_fun_00016a3a_factory() -> bool:
	var ok := true
	var fix: Dictionary = FlightMathScript.apply_1b524_factory_entry_addr(0x16A1A)
	ok = Assertions.assert_true(bool(fix.get("adjusted", false)), "16a1a adjust") and ok
	ok = Assertions.assert_equal(int(fix.get("entry", -1)), 0x16A3A, "→16a3a") and ok
	ok = Assertions.assert_equal(int(fix.get("delta", -1)), 0x20, "+0x20") and ok
	fix = FlightMathScript.apply_1b524_factory_entry_addr(0x11590)
	ok = Assertions.assert_equal(int(fix.get("entry", -1)), 0x115B0, "→115b0") and ok
	var st: Dictionary = {"heap_cursor": 0, "heap_base": 0x9000}
	var table: Dictionary = {}
	FlightMathScript.apply_00054_first_loop(st, table)
	var tpl: int = int(table[0x5858])
	var sf: Dictionary = FlightMathScript.apply_1b524_set_factory(tpl, 0x16A1A)
	ok = Assertions.assert_equal(int(sf.get("factory_addr", -1)), 0x16A1A, "slot imm") and ok
	var fac: Dictionary = FlightMathScript.apply_16a3a_factory(0xBEE0, 0x0001, 0x5858, table, 0xA000)
	ok = Assertions.assert_true(bool(fac.get("ok", false)), "factory ok") and ok
	ok = Assertions.assert_equal(int(fac.get("alloc_size", -1)), 0x58, "0x58") and ok
	ok = Assertions.assert_equal(int(fac.get("handle_u32_00", -1)), 0xBEE0, "*h=obj") and ok
	ok = Assertions.assert_equal(int(fac.get("handle_u32_04", -1)), tpl, "h+4=tpl") and ok
	ok = Assertions.assert_equal(int(fac.get("obj_flags_04", -1)), 0x12001, "|=0x12000") and ok
	ok = Assertions.assert_equal(int(fac.get("obj_u16_34", -1)), 0, "+34 clr") and ok
	ok = Assertions.assert_equal(int(fac.get("factory_entry", -1)), 0x16A3A, "entry") and ok
	return ok

## [RECONSTRUCTED] FUN_000115b0 factory (+0x20 fixup from install imm 0x11590).
func _test_fun_000115b0_factory() -> bool:
	var ok := true
	var fix: Dictionary = FlightMathScript.apply_1b524_factory_entry_addr(0x11590)
	ok = Assertions.assert_equal(int(fix.get("entry", -1)), 0x115B0, "→115b0") and ok
	const SLOT_1B540 := 0x55AA1234
	var fac: Dictionary = FlightMathScript.apply_115b0_factory(0xBEE1, 0x0002, SLOT_1B540, 0xB000)
	ok = Assertions.assert_true(bool(fac.get("ok", false)), "ok") and ok
	ok = Assertions.assert_equal(int(fac.get("alloc_size", -1)), 0xA2, "0xa2") and ok
	ok = Assertions.assert_equal(int(fac.get("handle_u32_00", -1)), 0xBEE1, "*h=obj") and ok
	ok = Assertions.assert_equal(int(fac.get("handle_u32_04", -1)), SLOT_1B540, "h+4=1b540") and ok
	ok = Assertions.assert_equal(int(fac.get("obj_flags_04", -1)), 0x112002, "|=0x112000") and ok
	ok = Assertions.assert_equal(int(fac.get("factory_entry", -1)), 0x115B0, "entry") and ok
	ok = Assertions.assert_equal(int(fac.get("stored_install_imm", -1)), 0x11590, "imm") and ok
	## resolve: tpl+6 wins over fallback
	var table: Dictionary = {0x5858: 0x1000}
	var r: Dictionary = FlightMathScript.apply_1b524_resolve_factory(table, 0x5858, 0x16A1A, 0x11590)
	ok = Assertions.assert_equal(str(r.get("source", "")), "tpl+6", "tpl prefer") and ok
	ok = Assertions.assert_equal(int(r.get("entry", -1)), 0x16A3A, "→16a3a") and ok
	r = FlightMathScript.apply_1b524_resolve_factory(table, 0x5858, 0, 0x11590)
	ok = Assertions.assert_equal(str(r.get("source", "")), "fallback", "fb") and ok
	ok = Assertions.assert_equal(int(r.get("entry", -1)), 0x115B0, "→115b0") and ok
	var tk: Dictionary = FlightMathScript.apply_1b524_type_key(0x5858, -1)
	ok = Assertions.assert_equal(str(tk.get("source", "")), "desc[1]", "desc key") and ok
	ok = Assertions.assert_equal(int(tk.get("type_key", -1)), 0x5858, "5858") and ok
	tk = FlightMathScript.apply_1b524_type_key(1, 0x0999)
	ok = Assertions.assert_equal(str(tk.get("source", "")), "override", "ovr") and ok
	ok = Assertions.assert_equal(int(tk.get("type_key", -1)), 0x0999, "0999") and ok
	var pr: Dictionary = FlightMathScript.apply_016e2_publish_root(0xABC0, 0x100)
	ok = Assertions.assert_equal(int(pr.get("dat_0001d6fc", -1)), 0xABC0, "1d6fc") and ok
	ok = Assertions.assert_true(bool(pr.get("ok", false)), "root ok") and ok
	pr = FlightMathScript.apply_016e2_publish_root(0, 0x100)
	ok = Assertions.assert_true(not bool(pr.get("ok", true)), "null root") and ok
	ok = Assertions.assert_equal(FlightMathScript.apply_016e2_child_table_bytes(2), 0x30, "2*18") and ok
	ok = Assertions.assert_equal(FlightMathScript.apply_016e2_child_src_base(0x1000), 0x101A, "src") and ok
	ok = Assertions.assert_equal(
		FlightMathScript.apply_016e2_relocate_child_name(0x10, 0x200), 0x210, "reloc"
	) and ok
	var ch: Dictionary = FlightMathScript.apply_016e2_copy_child_record(
		[1, 2, 3, 4, 5, 0x99]
	)
	ok = Assertions.assert_equal(int(ch.get("field_14", -1)), 0x99, "f14") and ok
	ok = Assertions.assert_equal((ch.get("words", []) as Array).size(), 6, "6 words") and ok
	var lk: Dictionary = FlightMathScript.apply_016e2_link_child(0x1000, 3)
	ok = Assertions.assert_equal(int(lk.get("field_24", -1)), 0x1000, "link24") and ok
	ok = Assertions.assert_equal(int(lk.get("field_01", -1)), 3, "link1") and ok
	ok = Assertions.assert_equal(int(lk.get("field_02", -1)), 3, "link2") and ok
	var bd: Dictionary = FlightMathScript.apply_016e2_publish_bdb4(0xBDB4)
	ok = Assertions.assert_equal(int(bd.get("dat_0001bdb4", -1)), 0xBDB4, "bdb4") and ok
	ok = Assertions.assert_equal(
		FlightMathScript.apply_016e2_child_slot_obj(0x1000, 1), 0x1000 + 0x2C, "slot1"
	) and ok
	var sel: Dictionary = FlightMathScript.apply_016e2_bdac_select(0, 0x1000)
	ok = Assertions.assert_equal(int(sel.get("child_index", -1)), 2, "bdac idx2") and ok
	ok = Assertions.assert_true(bool(sel.get("call_04e6e", false)), "04e6e") and ok
	sel = FlightMathScript.apply_016e2_bdac_select(2, 0x1000)
	ok = Assertions.assert_equal(int(sel.get("child_index", -1)), 3, "bdac idx3") and ok
	ok = Assertions.assert_true(bool(sel.get("call_04e4e", false)), "04e4e m2") and ok
	var g: Dictionary = FlightMathScript.apply_04e06_gate(0)
	ok = Assertions.assert_true(bool(g.get("run_body", false)), "04e06 run") and ok
	g = FlightMathScript.apply_04e06_gate(2)
	ok = Assertions.assert_true(bool(g.get("skip", false)), "04e06 skip") and ok
	var dp: Dictionary = FlightMathScript.apply_04e06_desc_ptr(0x1000, 1, 0x2000, 0x30)
	ok = Assertions.assert_equal(int(dp.get("slot_addr", -1)), 0x1000 + 0x2E + 0x18, "slot") and ok
	ok = Assertions.assert_equal(int(dp.get("desc_ptr", -1)), 0x2030, "desc") and ok
	var cp: Dictionary = FlightMathScript.apply_04e06_field_copies(0xA, 0xB, 0xC, 0xD)
	ok = Assertions.assert_equal(int(cp.get("field_18", -1)), 0xA, "f18") and ok
	ok = Assertions.assert_equal(int(cp.get("field_14", -1)), 0xD, "f14") and ok
	var tl: Dictionary = FlightMathScript.apply_04e4e_tail(0xEE)
	ok = Assertions.assert_equal(int(tl.get("field_14", -1)), 0xEE, "tail14") and ok
	var b8: Dictionary = FlightMathScript.apply_016e2_publish_bda8(0xBDAC, 0xBDA80048)
	ok = Assertions.assert_equal(int(b8.get("dat_0001bda8", -1)), 0xBDA80048, "bda8") and ok
	var b4: Dictionary = FlightMathScript.apply_016e2_publish_bda4(0x1000, 0xBDA4)
	ok = Assertions.assert_equal(int(b4.get("dat_0001bda4", -1)), 0xBDA4, "bda4") and ok
	ok = Assertions.assert_equal(int(b4.get("slot_addr", -1)), 0x1000 + 0x74, "slot4") and ok
	var win: Dictionary = FlightMathScript.apply_016e2_bc28_window(2, 0x1000)
	ok = Assertions.assert_equal(int(win.get("dat_0001b88e", -1)), 1, "b88e") and ok
	ok = Assertions.assert_equal(int(win.get("dat_0001b88c", -1)), 3, "b88c") and ok
	ok = Assertions.assert_equal(int(win.get("bc28_slot", -1)), 0x1000 + 0x2C, "bc28slot") and ok
	return ok

## [RECONSTRUCTED] FUN_00004690 / 046da vtable +8 (5202–5208 / 5237–5248).
func _test_fun_00004690_vtable_plus8() -> bool:
	var ok := true
	var z: Dictionary = FlightMathScript.apply_04690_vtable_plus8(0, 0xC0DE)
	ok = Assertions.assert_true(not bool(z.get("install", true)), "type0 skip") and ok
	var a: Dictionary = FlightMathScript.apply_04690_vtable_plus8(1, 0xC0DE)
	ok = Assertions.assert_true(bool(a.get("install", false)), "type1 install") and ok
	ok = Assertions.assert_equal(int(a.get("field_08", -1)), 0xC0DE, "+8") and ok
	ok = Assertions.assert_true(bool(a.get("clear_handle", false)), "clear *h") and ok
	a = FlightMathScript.apply_04690_vtable_plus8(2, 0)
	ok = Assertions.assert_true(bool(a.get("install", false)), "null h install") and ok
	ok = Assertions.assert_true(not bool(a.get("clear_handle", true)), "no clear") and ok
	var d: Dictionary = FlightMathScript.apply_046da_factory_plus8(1, 0xF00D, 0xA, 0xB, 0xC, 0x11)
	ok = Assertions.assert_true(bool(d.get("write_aux", false)), "aux") and ok
	ok = Assertions.assert_equal(int(d.get("aux_20", -1)), 0xA, "+20") and ok
	ok = Assertions.assert_equal(int(d.get("aux_22", -1)), 0xB, "+22") and ok
	ok = Assertions.assert_equal(int(d.get("aux_24", -1)), 0xC, "+24") and ok
	ok = Assertions.assert_equal(int(d.get("factory_arg3", -1)), 0x11, "arg3") and ok
	return ok

## [RECONSTRUCTED] FUN_00001a68 freelist pop + 019d0 small push (2157–2160 / 2117–2121).
func _test_fun_00001a68_freelist() -> bool:
	var ok := true
	var st: Dictionary = {"heap_cursor": 0, "heap_base": 0x3000}
	var a: Dictionary = FlightMathScript.apply_01a68_small_alloc(10, st)
	ok = Assertions.assert_true(not bool(a.get("from_freelist", true)), "1st fresh") and ok
	var p1: int = int(a.get("payload_ptr", 0))
	var b: Dictionary = FlightMathScript.apply_01a68_small_alloc(10, st)
	ok = Assertions.assert_true(not bool(b.get("from_freelist", true)), "2nd fresh") and ok
	var p2: int = int(b.get("payload_ptr", 0))
	ok = Assertions.assert_true(p2 != p1, "distinct") and ok
	var fr: Dictionary = FlightMathScript.apply_019d0_free_small(p1, st)
	ok = Assertions.assert_true(bool(fr.get("ok", false)), "free ok") and ok
	ok = Assertions.assert_equal(int(fr.get("size_class", -1)), 4, "free bin4") and ok
	var c: Dictionary = FlightMathScript.apply_01a68_small_alloc(10, st)
	ok = Assertions.assert_true(bool(c.get("from_freelist", false)), "reuse") and ok
	ok = Assertions.assert_equal(int(c.get("payload_ptr", -1)), p1, "got p1") and ok
	ok = Assertions.assert_equal(int(st.get("heap_cursor", -1)), 32, "no new bump") and ok
	## LIFO: free p2 then p1 → next alloc is p1
	FlightMathScript.apply_019d0_free_small(p2, st)
	FlightMathScript.apply_019d0_free_small(p1, st)
	var d: Dictionary = FlightMathScript.apply_01a68_small_alloc(10, st)
	ok = Assertions.assert_equal(int(d.get("payload_ptr", -1)), p1, "LIFO top") and ok
	return ok

## [RECONSTRUCTED] FUN_00001974 / 01958 fresh small-bin bump (2025–2039 / 2013–2021).
func _test_fun_00001974_fresh_small_bin() -> bool:
	var ok := true
	var st: Dictionary = {"heap_cursor": 0, "heap_base": 0x1000}
	var a: Dictionary = FlightMathScript.apply_01974_fresh_small_bin(4, st)
	ok = Assertions.assert_equal(int(a.get("grow_bytes", -1)), 16, "bin4 grow") and ok
	ok = Assertions.assert_equal(int(a.get("payload_capacity", -1)), 12, "bin4 cap") and ok
	ok = Assertions.assert_equal(int(a.get("header_byte", -1)), 4, "hdr") and ok
	ok = Assertions.assert_equal(int(a.get("header_offset", -1)), 0x1000, "block") and ok
	ok = Assertions.assert_equal(int(a.get("payload_ptr", -1)), 0x1004, "pay") and ok
	var b: Dictionary = FlightMathScript.apply_01974_fresh_small_bin(4, st)
	ok = Assertions.assert_equal(int(b.get("header_offset", -1)), 0x1010, "2nd bump") and ok
	ok = Assertions.assert_equal(int(st.get("heap_cursor", -1)), 32, "cursor 32") and ok
	st = {"heap_cursor": 0, "heap_base": 0x2000}
	var f: Dictionary = FlightMathScript.apply_01a68_fresh_small_from_request(10, st)
	ok = Assertions.assert_true(bool(f.get("ok", false)), "req10 ok") and ok
	ok = Assertions.assert_equal(int(f.get("size_class", -1)), 4, "req10 bin") and ok
	ok = Assertions.assert_equal(int(f.get("payload_ptr", -1)), 0x2004, "req10 pay") and ok
	f = FlightMathScript.apply_01a68_fresh_small_from_request(0x18, st)
	ok = Assertions.assert_equal(int(f.get("grow_bytes", -1)), 32, "18 grow32") and ok
	ok = Assertions.assert_equal(int(f.get("payload_capacity", -1)), 28, "18 cap28") and ok
	f = FlightMathScript.apply_01a68_fresh_small_from_request(0x40, st)
	ok = Assertions.assert_true(bool(f.get("deferred_large", false)), "40 large") and ok
	return ok

## [RECONSTRUCTED] FUN_00001a68 size-class routing (2148–2164) — no freelist.
func _test_fun_00001a68_route() -> bool:
	var ok := true
	ok = Assertions.assert_equal(
		FlightMathScript.apply_01a68_round_bytes(10), 16, "round 10→16"
	) and ok
	var r: Dictionary = FlightMathScript.apply_01a68_route(10)
	ok = Assertions.assert_true(bool(r.get("use_small_bins", false)), "10 small") and ok
	ok = Assertions.assert_equal(int(r.get("small_bin", -1)), 4, "10 bin4") and ok
	ok = Assertions.assert_equal(int(r.get("payload_capacity", -1)), 12, "10 cap12") and ok
	r = FlightMathScript.apply_01a68_route(0x18)
	ok = Assertions.assert_true(bool(r.get("use_small_bins", false)), "18 small") and ok
	ok = Assertions.assert_equal(int(r.get("small_bin", -1)), 5, "18 bin5") and ok
	ok = Assertions.assert_equal(int(r.get("payload_capacity", -1)), 28, "18 cap28") and ok
	r = FlightMathScript.apply_01a68_route(0x40)
	ok = Assertions.assert_true(not bool(r.get("use_small_bins", true)), "40 large") and ok
	ok = Assertions.assert_equal(int(r.get("large_words", -1)), 9, "40 words9") and ok
	r = FlightMathScript.apply_01a68_route(0x52)
	ok = Assertions.assert_equal(int(r.get("large_words", -1)), 12, "52 words12") and ok
	var idx: int = FlightMathScript.apply_04808_index_alloc_bytes(5)
	r = FlightMathScript.apply_01a68_route(idx)
	ok = Assertions.assert_equal(idx, 10, "5<<1") and ok
	ok = Assertions.assert_equal(int(r.get("small_bin", -1)), 4, "idx bin") and ok
	var pool: int = FlightMathScript.apply_04e6e_kind2_alloc_bytes(2, 3)
	r = FlightMathScript.apply_01a68_route(pool)
	ok = Assertions.assert_equal(pool, 60, "2+3)*0xC") and ok
	ok = Assertions.assert_equal(int(r.get("large_words", -1)), 9, "60 words9") and ok
	ok = Assertions.assert_equal(
		FlightMathScript.apply_01b38_zero_bytes(FlightMathScript.apply_01a68_route(10)),
		12, "01b38 small"
	) and ok
	ok = Assertions.assert_equal(
		FlightMathScript.apply_01b38_zero_bytes(FlightMathScript.apply_01a68_route(0x40)),
		64, "01b38 large"
	) and ok
	return ok

## [RECONSTRUCTED] FUN_00002d10 null-aux: always 0253e→02ada→01c5c (vs 02bd8 angle gate).
func _test_fun_00002d10_null_aux() -> bool:
	var ok := true
	## Zero angles: still rotates (identity) then translates — differs from 02bd8 skip.
	var n: Dictionary = FlightMathScript.apply_02d10_null_aux_node(
		10, 20, 30, 5, 0, -1, 0, 0, 0
	)
	ok = Assertions.assert_true(bool(n.get("applied_0253e", false)), "always 0253e") and ok
	ok = Assertions.assert_equal(int(n.get("x", -1)), 15, "id+dx") and ok
	ok = Assertions.assert_equal(int(n.get("z", -1)), 29, "id+dz") and ok
	## Ry90 then +1 on x: (10,0,0)→(0,0,10) then +dx → (1,0,10)
	n = FlightMathScript.apply_02d10_null_aux_node(10, 0, 0, 1, 0, 0, 0, 0x1000, 0)
	ok = Assertions.assert_equal(int(n.get("x", -1)), 1, "Ry90+dx x") and ok
	ok = Assertions.assert_equal(int(n.get("z", -1)), 10, "Ry90+dx z") and ok
	var w: Dictionary = FlightMathScript.apply_02d10_null_aux_walk(
		0, 0, 0, [{"dx": 1, "dy": 2, "dz": 3}, {"dx": 10, "dy": 0, "dz": 0}]
	)
	ok = Assertions.assert_equal(int(w.get("steps", -1)), 2, "2 steps") and ok
	ok = Assertions.assert_equal(int(w.get("x", -1)), 11, "walk x") and ok
	var c: Dictionary = FlightMathScript.apply_02bd8_null_aux_commit(
		int(w.get("x", 0)), int(w.get("y", 0)), int(w.get("z", 0)), 0, 0, 1
	)
	ok = Assertions.assert_true(bool(c.get("commit", false)), "02d10 commit") and ok
	ok = Assertions.assert_equal(int(c.get("field_18", -1)), 11, "commit x") and ok
	## Contrast: 02bd8 with zero angles does 01c5c only (no 0253e flag)
	var b: Dictionary = FlightMathScript.apply_02bd8_null_aux_node(
		10, 20, 30, 5, 0, -1, 0, 0, 0
	)
	ok = Assertions.assert_true(not bool(b.get("applied_0253e", false)), "02bd8 no 0253e") and ok
	return ok

## [RECONSTRUCTED] FUN_0000253e = 0202a(a,b,c,0)→024f8; ≡ 025a8(0,a,b,c).
func _test_fun_0000253e() -> bool:
	var ok := true
	var m: Array = FlightMathScript.fun_0000253e(0, 0, 0)
	ok = Assertions.assert_equal(int(m[0]), 0x1000, "0253e id[0]") and ok
	ok = Assertions.assert_equal(int(m[4]), 0x1000, "0253e id[4]") and ok
	ok = Assertions.assert_equal(int(m[8]), 0x1000, "0253e id[8]") and ok
	ok = Assertions.assert_equal(int(m[1]), 0, "0253e id[1]") and ok
	## Ry 90°: (0, 0x1000, 0)
	m = FlightMathScript.fun_0000253e(0, 0x1000, 0)
	ok = Assertions.assert_equal(int(m[0]), 0, "Ry90[0]") and ok
	ok = Assertions.assert_equal(int(m[2]), 0x1000, "Ry90[2]") and ok
	ok = Assertions.assert_equal(int(m[6]), -0x1000, "Ry90[6]") and ok
	ok = Assertions.assert_equal(int(m[4]), 0x1000, "Ry90[4]") and ok
	## ≡ 025a8(0, a, b, c)
	var a: int = 0x80
	var b: int = 0x100
	var c: int = 0x40
	m = FlightMathScript.fun_0000253e(a, b, c)
	var a8: Array = FlightMathScript.fun_000025a8(0, a, b, c)
	for i in range(9):
		ok = Assertions.assert_equal(int(m[i]), int(a8[i]), "0253e≡025a8[%d]" % i) and ok
	return ok

func _test_fun_000025a8_identity() -> bool:
	var ok := true
	var id: Array = FlightMathScript.identity_matrix_9()
	var m: Array = FlightMathScript.fun_00001d02(id, id)
	for i in range(9):
		ok = Assertions.assert_equal(int(m[i]), int(id[i]), "01d02 identity*%d" % i) and ok
	## Force table load; dump must be present.
	FlightMathScript._ensure_trig_tables()
	ok = Assertions.assert_true(FlightMathScript._trig_tables_from_dump, "trig tables from overlay dump") and ok
	ok = Assertions.assert_equal(int(FlightMathScript._trig_sin_table[0]), 0, "dump sin[0]") and ok
	ok = Assertions.assert_equal(int(FlightMathScript._trig_sin_table[64]), 0x1000, "dump sin[64]") and ok
	ok = Assertions.assert_equal(int(FlightMathScript._trig_cos_table[0]), 0x1000, "dump cos[0]") and ok
	ok = Assertions.assert_equal(int(FlightMathScript._trig_cos_table[128]), -0x1000, "dump cos[128]") and ok
	## All-zero angles → identity
	m = FlightMathScript.fun_000025a8(0, 0, 0, 0)
	ok = Assertions.assert_equal(int(m[0]), 0x1000, "025a8[0] identity") and ok
	ok = Assertions.assert_equal(int(m[4]), 0x1000, "025a8[4] identity") and ok
	ok = Assertions.assert_equal(int(m[8]), 0x1000, "025a8[8] identity") and ok
	ok = Assertions.assert_equal(int(m[1]), 0, "025a8[1] zero") and ok
	ok = Assertions.assert_equal(FlightMathScript.fun_00001dd8(0), 0x1000, "cos(0)") and ok
	ok = Assertions.assert_equal(FlightMathScript.fun_00001d76(0), 0, "sin(0)") and ok
	## Quarter-turn index: angle 0x1000 → >>6 = 64
	ok = Assertions.assert_equal(FlightMathScript.fun_00001d76(0x1000), 0x1000, "sin(90deg)") and ok
	ok = Assertions.assert_equal(FlightMathScript.fun_00001dd8(0x1000), 0, "cos(90deg)") and ok
	return ok

func _test_fun_0000e372() -> bool:
	var ok := true
	ok = Assertions.assert_equal(FlightMathScript.fun_0000e372(0), 0, "e372(0)") and ok
	ok = Assertions.assert_equal(FlightMathScript.fun_0000e372(1), 1, "e372(1)") and ok
	ok = Assertions.assert_equal(FlightMathScript.fun_0000e372(100), 10, "e372(100)") and ok
	ok = Assertions.assert_equal(FlightMathScript.fun_0000e372(99), 9, "e372(99) floor") and ok
	ok = Assertions.assert_equal(FlightMathScript.fun_0000e372(0x4000000), 0x2000, "e372(2^26)") and ok
	var rec: Dictionary = FlightMathScript.apply_airborne_speed_recommit(30, 40, 0, 2)
	ok = Assertions.assert_equal(int(rec.get("movement_62a", -1)), 50, "3-4-5 speed") and ok
	ok = Assertions.assert_true(bool(rec.get("clear_field_190", false)), "clear stall-2") and ok
	return ok

func _test_fun_00001f22() -> bool:
	var ok := true
	FlightMathScript._ensure_trig_tables()
	FlightMathScript._ensure_af6c_table()
	ok = Assertions.assert_true(FlightMathScript._trig_af6c_from_dump, "af6c dump loaded") and ok
	## acos(0x1000) → ~0; acos(0) → ~0x1000
	ok = Assertions.assert_equal(FlightMathScript.fun_00001e3a(0x1000), 0, "01e3a(1.0)") and ok
	ok = Assertions.assert_equal(FlightMathScript.fun_00001e3a(0), 0x1000, "01e3a(0)") and ok
	## Pure +X: |z|<|e| still writes local_2a via (z<<12)/|e| path → 0x3000 when e>0.
	var att: Dictionary = FlightMathScript.fun_00001f22(100, 0, 0, 100, 10000, 0, 0)
	ok = Assertions.assert_true(bool(att.get("wrote_local_28", false)), "wrote pitch/local_28") and ok
	ok = Assertions.assert_true(bool(att.get("wrote_local_2a", false)), "wrote local_2a for |z|<|e|") and ok
	ok = Assertions.assert_equal(int(att.get("local_2a", -1)), 0x3000, "local_2a=+X") and ok
	## e=0, z=100 → |z|>=|e|, 01ebc path
	att = FlightMathScript.fun_00001f22(0, 0, 100, 100, 10000, 0, 0)
	ok = Assertions.assert_true(bool(att.get("wrote_local_2a", false)), "wrote local_2a for +Z") and ok
	return ok

func _test_grounded_speed_recommit() -> bool:
	var ok := true
	## 3-4-5 without vertical: e=30,z=40 → speed 50; pvc = 1000-200
	var g: Dictionary = FlightMathScript.apply_grounded_speed_recommit(
		30, 40, 0, 100, 1000, 200, 1, 0
	)
	ok = Assertions.assert_equal(int(g.get("movement_62a", -1)), 50, "grounded 3-4-5") and ok
	ok = Assertions.assert_equal(int(g.get("position_velocity_c", 0)), 800, "grounded pvc") and ok
	ok = Assertions.assert_true(not bool(g.get("need_13452", true)), "no 13452 when pos_2e!=0") and ok
	ok = Assertions.assert_true(bool(g.get("set_field_190_prestall", false)), "63f sets prestall") and ok
	g = FlightMathScript.apply_grounded_speed_recommit(0, 0, 0x2001, 0, 0, 0, 0, 0)
	ok = Assertions.assert_true(bool(g.get("need_13452", false)), "13452 when pos_2e==0") and ok
	ok = Assertions.assert_equal(int(g.get("local_28", -1)), 0, "clamp local_28>0x2000") and ok
	return ok

## [RECONSTRUCTED] grounded field_0b switch (14507–14596).
func _test_grounded_field_0b_switch() -> bool:
	var ok := true
	## ' ' with status&8==0 → bVar6 → suppresses prestall
	var g: Dictionary = FlightMathScript.apply_grounded_speed_recommit(
		0, 0, 0, 100, 0, 0, 1, 0, 0x20, 0, 0, 0, false, 0
	)
	ok = Assertions.assert_true(bool(g.get("b_var6", false)), "space sets bVar6") and ok
	ok = Assertions.assert_true(not bool(g.get("set_field_190_prestall", true)), "bVar6 blocks prestall") and ok
	## 'P' + player + b856 → clear flag; abs(679)!=0x2d → bVar6
	g = FlightMathScript.apply_grounded_speed_recommit(
		0, 0, 0, 100, 0, 0, 1, 0, 0x50, 0, 0x00, 0, true, 1
	)
	ok = Assertions.assert_true(bool(g.get("clear_dat_0001b856", false)), "P clears b856") and ok
	ok = Assertions.assert_true(bool(g.get("clear_u_var13", false)), "P clears uVar13") and ok
	ok = Assertions.assert_true(bool(g.get("b_var6", false)), "P bVar6 when 679!='-'") and ok
	## 0x10 + nonzero 679 → status|0x1400 + early return (skips prestall)
	g = FlightMathScript.apply_grounded_speed_recommit(
		0, 0, 0, 100, 0, 0, 1, 0, 0x10, 0, 1, 0, false, 0
	)
	ok = Assertions.assert_true(bool(g.get("early_return", false)), "0x10 early return") and ok
	ok = Assertions.assert_equal(int(g.get("status_1a1", 0)) & 0x1400, 0x1400, "0x10|0x1400") and ok
	ok = Assertions.assert_true(not bool(g.get("set_field_190_prestall", true)), "early skips prestall") and ok
	## 0x10 soft: draw 0x3f, uVar13_in=0, speed>=0x10e0 → no scale → 0x1f
	## e=0x10e0,z=0 → speed=0x10e0; iVar25=0x438; not < 0x438
	g = FlightMathScript.apply_grounded_speed_recommit(
		0x10E0, 0, 0, 100, 0, 0, 0, 0, 0x10, 0, 0, 0, true, 1, 0, [0x3F]
	)
	ok = Assertions.assert_true(not bool(g.get("early_return", true)), "0x10 soft no early") and ok
	ok = Assertions.assert_equal(int(g.get("status_1a1", 0)) & 0x1000, 0x1000, "0x10|0x1000") and ok
	ok = Assertions.assert_true(bool(g.get("clear_dat_0001b856", false)), "0x10 soft clears b856") and ok
	ok = Assertions.assert_equal(int(g.get("u_var13", -1)), 0x1F, "0x10 soft uVar13") and ok
	ok = Assertions.assert_equal(int(g.get("rng_draws_used", 0)), 1, "0x10 soft uses 11564") and ok
	## '@' + player + b856 → b854 + clear b856; 11544-callsite draws → 18c/uVar13
	g = FlightMathScript.apply_grounded_speed_recommit(
		0x10E0, 0, 0, 100, 0, 0, 0, 0, 0x40, 0, 0x2D, 0, true, 1, 0, [0x55, 0x60]
	)
	ok = Assertions.assert_true(bool(g.get("set_dat_0001b854", false)), "@ sets b854") and ok
	ok = Assertions.assert_true(bool(g.get("clear_dat_0001b856", false)), "@ clears b856") and ok
	ok = Assertions.assert_true(not bool(g.get("b_var6", true)), "@ '-' no bVar6") and ok
	ok = Assertions.assert_true(bool(g.get("wrote_field_18c", false)), "@ writes 18c") and ok
	ok = Assertions.assert_equal(int(g.get("field_18c_delta", -1)), 0x55 & 0x7F, "18c delta") and ok
	## uVar13 = (0x60&0x7f)-0x40 = 0x20; speed>>2=0x438 → no scale
	ok = Assertions.assert_equal(int(g.get("u_var13", -1)), 0x20, "@ uVar13") and ok
	return ok

## [RECONSTRUCTED] LAB_0000f47c yaw blend + player ring (14606–14629).
func _test_lab_0000f47c() -> bool:
	var ok := true
	## 01d56-callsite ≡ sin(local_28); local_28=0x1000 → scale≈0x1000
	ok = Assertions.assert_equal(
		FlightMathScript.fun_00001d56_callsite(0x1000),
		FlightMathScript.fun_00001d76(0x1000),
		"01d56≡01d76"
	) and ok
	var scale: int = FlightMathScript.fun_00001d56_callsite(0x1000)
	## local_2a - attitude_22 = 0x100; e40c keeps it; *scale>>12
	var ep: Dictionary = FlightMathScript.apply_lab_0000f47c(
		0x1000, 0x200, 0x100, 0x10, 100, false, 0, 0, 0
	)
	var expect_24: int = (0x10 + ((0x100 * scale) >> 12)) & 0x3FFF
	ok = Assertions.assert_true(bool(ep.get("clear_field_63f", false)), "clears 63f") and ok
	ok = Assertions.assert_equal(int(ep.get("pos_20", -1)), 0x1000, "pos_20=local_28") and ok
	ok = Assertions.assert_equal(int(ep.get("attitude_22", -1)), 0x200, "att22=local_2a") and ok
	ok = Assertions.assert_equal(int(ep.get("field_24", -1)), expect_24, "yaw blend") and ok
	ok = Assertions.assert_equal(int(ep.get("scale_01d56", -1)), scale, "scale=sin") and ok
	ok = Assertions.assert_equal(int(ep.get("movement_62a", -1)), 100, "62a=speed") and ok
	ok = Assertions.assert_true(not bool(ep.get("wrote_ring", true)), "non-player no ring") and ok
	## player ring: speed 0xE7, sin(0x1000)≈0x1000 → (0xE7*0x2000)/0x1ce = 0x1000
	ep = FlightMathScript.apply_lab_0000f47c(
		0x1000, 0, 0, 0, 0xE7, true, 0, 0, 0
	)
	ok = Assertions.assert_true(bool(ep.get("wrote_ring", false)), "player ring") and ok
	ok = Assertions.assert_equal(int(ep.get("ring_value", -1)), 0x1000, "ring = 0x1000") and ok
	ok = Assertions.assert_equal(int(ep.get("dat_0001bc84", -1)), 1, "bc84 advances") and ok
	ok = Assertions.assert_equal(int(ep.get("dat_0001bc80", -1)), 0x1000, "bc80 += ring") and ok
	## clamp +0x1d80
	ep = FlightMathScript.apply_lab_0000f47c(
		0x1000, 0, 0, 0, 0x1CE, true, 0, 0, 0
	)
	ok = Assertions.assert_equal(int(ep.get("ring_value", -1)), 0x1D80, "ring clamp hi") and ok
	return ok

## [RECONSTRUCTED] 67b/679 char epilogue (14631–14647).
func _test_e792_char_epilogue() -> bool:
	var ok := true
	## 67b in (0,0x0f) increments; 0 and 0x0f do not
	var ch: Dictionary = FlightMathScript.apply_e792_char_epilogue(5, 0, 0, 0, 0)
	ok = Assertions.assert_equal(int(ch.get("field_67b", -1)), 6, "67b++ in range") and ok
	ch = FlightMathScript.apply_e792_char_epilogue(0, 0, 0, 0, 0)
	ok = Assertions.assert_equal(int(ch.get("field_67b", -1)), 0, "67b 0 stays") and ok
	ch = FlightMathScript.apply_e792_char_epilogue(0x0F, 0, 0, 0, 0)
	ok = Assertions.assert_equal(int(ch.get("field_67b", -1)), 0x0F, "67b 0x0f stays") and ok
	ch = FlightMathScript.apply_e792_char_epilogue(-3, 0, 0, 0, 0)
	ok = Assertions.assert_equal(FlightMathScript._to_s8(int(ch.get("field_67b", 0))), -2, "67b neg++") and ok
	## 679 in 1..0x2c, flag clear → ++, 67a|=2, clear status 0x2000
	ch = FlightMathScript.apply_e792_char_epilogue(0, 5, 0, 0, 0x2000)
	ok = Assertions.assert_equal(int(ch.get("direction_char_679", -1)), 6, "679++ mid") and ok
	ok = Assertions.assert_equal(int(ch.get("field_67a", -1)) & 2, 2, "67a|=2") and ok
	ok = Assertions.assert_equal(int(ch.get("status_1a1", -1)) & 0x2000, 0, "clear 0x2000") and ok
	## 679 negative (outer true) → ++, 67a|=2, OR 0x2000
	ch = FlightMathScript.apply_e792_char_epilogue(0, -4, 0, 0, 0)
	ok = Assertions.assert_equal(FlightMathScript._to_s8(int(ch.get("direction_char_679", 0))), -3, "679 neg++") and ok
	ok = Assertions.assert_equal(int(ch.get("status_1a1", 0)) & 0x2000, 0x2000, "OR 0x2000") and ok
	## 679=='-' (0x2d > ',') → outer true, non-neg → no bump
	ch = FlightMathScript.apply_e792_char_epilogue(0, 0x2D, 0, 0, 0)
	ok = Assertions.assert_equal(int(ch.get("direction_char_679", -1)), 0x2D, "'-' stays") and ok
	ok = Assertions.assert_true(not bool(ch.get("bumped_679", true)), "'-' no bump") and ok
	## flag 0x20 blocks mid-range else-branch
	ch = FlightMathScript.apply_e792_char_epilogue(0, 5, 0, 0x20, 0)
	ok = Assertions.assert_equal(int(ch.get("direction_char_679", -1)), 5, "flag blocks 679++") and ok
	return ok

## [RECONSTRUCTED] field_19d/19f weapon phase (14648–14671).
func _test_e792_weapon_19d_branch() -> bool:
	var ok := true
	## inactive when either zero
	var br: Dictionary = FlightMathScript.apply_e792_weapon_19d_branch(0, 5, 0x100, 0)
	ok = Assertions.assert_true(not bool(br.get("fired", true)), "19d=0 no fire") and ok
	ok = Assertions.assert_equal(int(br.get("field_19d", -1)), 0, "19d stays 0") and ok
	br = FlightMathScript.apply_e792_weapon_19d_branch(1, 0, 0x100, 0)
	ok = Assertions.assert_true(not bool(br.get("fired", true)), "19f=0 no fire") and ok
	## fire at 19d==1: need_12840, 19f--, 18d-=0x10, 19d→2
	br = FlightMathScript.apply_e792_weapon_19d_branch(1, 5, 0x100, 0)
	ok = Assertions.assert_true(bool(br.get("need_12840", false)), "need 12840") and ok
	ok = Assertions.assert_true(bool(br.get("fired", false)), "fired") and ok
	ok = Assertions.assert_equal(int(br.get("field_19f", -1)), 4, "19f 5→4") and ok
	ok = Assertions.assert_equal(int(br.get("field_18d", -1)), 0xF0, "18d-=0x10") and ok
	ok = Assertions.assert_equal(int(br.get("field_19d", -1)), 2, "19d 1→2") and ok
	## mission_short_90==2 skips 18d adjust
	br = FlightMathScript.apply_e792_weapon_19d_branch(1, 3, 0x100, 2)
	ok = Assertions.assert_equal(int(br.get("field_18d", -1)), 0x100, "90==2 no 18d") and ok
	## 19d==2 advances without fire
	br = FlightMathScript.apply_e792_weapon_19d_branch(2, 3, 0, 0)
	ok = Assertions.assert_true(not bool(br.get("fired", true)), "phase2 no fire") and ok
	ok = Assertions.assert_equal(int(br.get("field_19d", -1)), 3, "19d 2→3") and ok
	ok = Assertions.assert_equal(int(br.get("field_19f", -1)), 3, "19f unchanged") and ok
	## wrap: pre-increment 4 → 0
	br = FlightMathScript.apply_e792_weapon_19d_branch(4, 1, 0, 0)
	ok = Assertions.assert_equal(int(br.get("field_19d", -1)), 0, "19d 4→0") and ok
	return ok

## [RECONSTRUCTED] FUN_00012840 post-spawn field writes (17561–17570).
func _test_fun_00012840_spawn_fields() -> bool:
	var ok := true
	var wr: Dictionary = FlightMathScript.apply_fun_00012840_spawn_fields(
		0x1234, 0, 0x111, 0x222, 0x333, 0x0001
	)
	ok = Assertions.assert_equal(int(wr.get("field_610", -1)), 0x1234, "610=speed") and ok
	ok = Assertions.assert_equal(int(wr.get("field_61c", -1)), 0x0001, "61c unchanged") and ok
	ok = Assertions.assert_equal(int(wr.get("pos_20", -1)), 0x111, "pos_20") and ok
	ok = Assertions.assert_equal(int(wr.get("attitude_22", -1)), 0x222, "att22") and ok
	ok = Assertions.assert_equal(int(wr.get("field_24", -1)), 0x333, "field_24") and ok
	ok = Assertions.assert_true(not bool(wr.get("ored_61c_40", true)), "param2=0 no OR") and ok
	wr = FlightMathScript.apply_fun_00012840_spawn_fields(0x10, 1, 0, 0, 0, 0x0001)
	ok = Assertions.assert_true(bool(wr.get("ored_61c_40", false)), "param2 ORs") and ok
	ok = Assertions.assert_equal(int(wr.get("field_61c", -1)), 0x0041, "61c|0x40") and ok
	return ok

## [RECONSTRUCTED] FUN_00019430 post-spawn field writes (23092–23112).
func _test_fun_00019430_spawn_fields() -> bool:
	var ok := true
	var wr: Dictionary = FlightMathScript.apply_fun_00019430_spawn_fields(
		0x1234, 0x11, 0x22, 0x33, 0xABCD1234
	)
	ok = Assertions.assert_equal(int(wr.get("field_610", -1)), 0xABCD1234, "610=b838") and ok
	ok = Assertions.assert_equal(int(wr.get("field_614", -1)), 0x1234, "614=speed") and ok
	ok = Assertions.assert_equal(int(wr.get("pos_20", -1)), 0x11, "pos_20") and ok
	ok = Assertions.assert_equal(int(wr.get("attitude_22", -1)), 0x22, "att22") and ok
	ok = Assertions.assert_equal(int(wr.get("field_24", -1)), 0x33, "field_24") and ok
	ok = Assertions.assert_equal(int(wr.get("field_618", -1)), 7, "618=7") and ok
	ok = Assertions.assert_equal(int(wr.get("field_61c", -1)), 0x62, "61c=0x62") and ok
	return ok

## [RECONSTRUCTED] FUN_00019430 0xd vertex >>3 / scale (23098–23110).
func _test_fun_00019430_vertex_loop() -> bool:
	var ok := true
	var verts: Array = []
	for i in range(0xD):
		verts.append({"x": 0x40 + i, "y": 0x80 + i, "z": 0x100 + i})
	var vl: Dictionary = FlightMathScript.apply_fun_00019430_vertex_loop(verts)
	ok = Assertions.assert_equal(int(vl.get("count", -1)), 0xD, "13 verts") and ok
	var s0: Dictionary = (vl.get("verts_shifted", []) as Array)[0] as Dictionary
	ok = Assertions.assert_equal(int(s0.get("x", -1)), 0x40 >> 3, "x>>3") and ok
	ok = Assertions.assert_equal(int(s0.get("y", -1)), 0x80 >> 3, "y>>3") and ok
	ok = Assertions.assert_equal(int(s0.get("z", -1)), 0x100 >> 3, "z>>3") and ok
	ok = Assertions.assert_equal(
		int((vl.get("entity_622", []) as Array)[0]), (0x40 >> 3) * 0x1C6, "622*0x1c6"
	) and ok
	ok = Assertions.assert_equal(
		int((vl.get("entity_656", []) as Array)[0]), (0x80 >> 3) * 0x1C6, "656*0x1c6"
	) and ok
	ok = Assertions.assert_equal(
		int((vl.get("entity_68a", []) as Array)[0]), (0x100 >> 3) * 0x255, "68a*0x255"
	) and ok
	## negative arithmetic >>3
	vl = FlightMathScript.apply_fun_00019430_vertex_loop([{"x": -16, "y": 0, "z": 0}])
	ok = Assertions.assert_equal(
		int(((vl.get("verts_shifted", []) as Array)[0] as Dictionary).get("x", 1)), -2, "neg>>3"
	) and ok
	return ok

## [RECONSTRUCTED] FUN_00015bf6 locals + post-spawn writes (20098–20125).
func _test_fun_00015bf6_helpers() -> bool:
	var ok := true
	## speed 0x100 → local_6 = (0x10)+0x2015 = 0x2025; draws 0x20 → no net change on e/a
	var loc: Dictionary = FlightMathScript.apply_15bf6_local_perturb(0x100, [0x20, 0x20, 0x20])
	ok = Assertions.assert_equal(int(loc.get("local_e", -1)), 0, "e unchanged") and ok
	ok = Assertions.assert_equal(int(loc.get("local_a", -1)), 0, "a unchanged") and ok
	ok = Assertions.assert_equal(int(loc.get("local_6", -1)), 0x2025, "6 base") and ok
	ok = Assertions.assert_equal(int(loc.get("spawn_z_delta", -1)), 0x2025 >> 2, "z>>2") and ok
	ok = Assertions.assert_true(not bool(loc.get("applied_028dc", true)), "no matrix → no 028dc") and ok
	## identity 028dc before RNG: (0,0,z) stays on Z
	loc = FlightMathScript.apply_15bf6_local_perturb(
		0x100, [0x20, 0x20, 0x20], FlightMathScript.identity_matrix_9()
	)
	ok = Assertions.assert_true(bool(loc.get("applied_028dc", false)), "028dc applied") and ok
	ok = Assertions.assert_equal(int(loc.get("local_e", -1)), 0, "id e") and ok
	ok = Assertions.assert_equal(int(loc.get("local_a", -1)), 0, "id a") and ok
	ok = Assertions.assert_equal(int(loc.get("local_6", -1)), 0x2025, "id 6") and ok
	## draw 0x3f → +0x1f; draw 0 → -0x20
	loc = FlightMathScript.apply_15bf6_local_perturb(0, [0x3F, 0x00, 0x20])
	ok = Assertions.assert_equal(int(loc.get("local_e", -1)), 0x1F, "e +0x1f") and ok
	ok = Assertions.assert_equal(int(loc.get("local_a", -1)), -0x20, "a -0x20") and ok
	var wr: Dictionary = FlightMathScript.apply_fun_00015bf6_spawn_fields(0x10, 0x20, 0x40, 1)
	ok = Assertions.assert_equal(int(wr.get("state_32", -1)), 0x20 << 4, "32=a<<4") and ok
	ok = Assertions.assert_equal(int(wr.get("entity_data_ptr", -1)), 0x10 >> 2, "+8") and ok
	ok = Assertions.assert_equal(int(wr.get("position_velocity_c", -1)), 0x20 >> 2, "+c") and ok
	ok = Assertions.assert_equal(int(wr.get("ptr_10", -1)), 0x40 >> 2, "+10") and ok
	ok = Assertions.assert_equal(int(wr.get("field_38", -1)), 0, "38=0") and ok
	ok = Assertions.assert_equal(int(wr.get("count_3a", -1)), 2, "3a=2 when p2") and ok
	wr = FlightMathScript.apply_fun_00015bf6_spawn_fields(0, 0, 0, 0)
	ok = Assertions.assert_equal(int(wr.get("count_3a", -1)), 1, "3a=1 when p2=0") and ok
	return ok

## [RECONSTRUCTED] FUN_0001a63e 9×s16 forward copy (nbytes 0x12; 20126).
func _test_fun_0001a63e_copy_matrix9() -> bool:
	var ok := true
	var src: Array = [1, 2, 3, 4, 5, 6, 7, 8, 9]
	var dst: Array = FlightMathScript.fun_0001a63e_copy_matrix9(src)
	for i in range(9):
		ok = Assertions.assert_equal(int(dst[i]), i + 1, "1a63e[%d]" % i) and ok
	## s16 truncation
	dst = FlightMathScript.fun_0001a63e_copy_matrix9([0x10001, -1])
	ok = Assertions.assert_equal(int(dst[0]), 1, "trunc low16") and ok
	ok = Assertions.assert_equal(int(dst[1]), -1, "s16 -1") and ok
	dst = FlightMathScript.fun_0001a63e_copy_matrix9(FlightMathScript.identity_matrix_9())
	ok = Assertions.assert_equal(int(dst[0]), 0x1000, "id[0]") and ok
	ok = Assertions.assert_equal(int(dst[4]), 0x1000, "id[4]") and ok
	ok = Assertions.assert_equal(int(dst[8]), 0x1000, "id[8]") and ok
	return ok

## [RECONSTRUCTED] Contact 61a/61e → pos_20 / field_24 (14095–14101; Capstone @0xE864).
func _test_contact_61a_61e_attitude() -> bool:
	var ok := true
	var r: Dictionary = FlightMathScript.apply_contact_61a_61e_attitude(
		0x83, 0x05, 100, 200, 0x100, 0x200
	)
	## 61e += 0x83&0x7f (=3) → 103; field_24 = (0x100+103)&0x3fff
	ok = Assertions.assert_equal(int(r.get("movement_61e", -1)), 103, "61e+=rng") and ok
	ok = Assertions.assert_equal(int(r.get("field_24", -1)), 0x167, "24+=61e") and ok
	## 61a -= 5 → 195; pos_20 = (0x200+195)&0x3fff
	ok = Assertions.assert_equal(int(r.get("movement_61a", -1)), 195, "61a-=rng") and ok
	ok = Assertions.assert_equal(int(r.get("pos_20", -1)), 0x2C3, "20+=61a") and ok
	r = FlightMathScript.apply_contact_61a_61e_attitude(0, 0x7F, 0, 0x10, 0x3FFE, 0x3FFE)
	ok = Assertions.assert_equal(int(r.get("movement_61a", -1)) & 0xFFFF, 0xFF91, "61a wrap s16") and ok
	ok = Assertions.assert_equal(int(r.get("field_24", -1)), 0x3FFE, "24 mask") and ok
	return ok

## [RECONSTRUCTED] FUN_00005116 free-slot / fill / world gate / 01ba8 grow (5705–5745).
func _test_fun_00005116_slot_helpers() -> bool:
	var ok := true
	ok = Assertions.assert_equal(
		FlightMathScript.find_05116_free_slot_index([1, 0, 3]), 1, "first free"
	) and ok
	ok = Assertions.assert_equal(
		FlightMathScript.find_05116_free_slot_index([1, 2]), 2, "full → grow idx"
	) and ok
	ok = Assertions.assert_equal(
		FlightMathScript.grow_05116_request_bytes(2), (2 + 10) * 0x18, "grow bytes"
	) and ok
	var grow: Dictionary = FlightMathScript.apply_01ba8_05116_grow(2)
	ok = Assertions.assert_equal(int(grow.get("new_count", -1)), 12, "2→12") and ok
	ok = Assertions.assert_equal(int(grow.get("first_new_index", -1)), 2, "first new") and ok
	## 01ba8 capacity / 01be4 mid-entry tail
	var cap: Dictionary = FlightMathScript.apply_01ba8_capacity(0xFF, 5)
	ok = Assertions.assert_equal(int(cap.get("capacity", -1)), 32, "large cap") and ok
	cap = FlightMathScript.apply_01ba8_capacity(6, 0)
	ok = Assertions.assert_equal(int(cap.get("capacity", -1)), 60, "small 2^6-4") and ok
	var ng: Dictionary = FlightMathScript.apply_01ba8_need_grow(32, 40)
	ok = Assertions.assert_true(bool(ng.get("need_grow", false)), "need grow") and ok
	ng = FlightMathScript.apply_01ba8_need_grow(64, 40)
	ok = Assertions.assert_true(bool(ng.get("return_old", false)), "keep old") and ok
	ok = Assertions.assert_equal(
		FlightMathScript.apply_04958_01ba8_request(3), 6, "04958 req<<1"
	) and ok
	var rp: Dictionary = FlightMathScript.apply_01ba8_realloc_plan(6, 0, 40)
	ok = Assertions.assert_true(bool(rp.get("keep_old", false)), "cap60≥40 keep") and ok
	rp = FlightMathScript.apply_01ba8_realloc_plan(0xFF, 5, 40)
	ok = Assertions.assert_true(bool(rp.get("need_grow", false)), "cap32<40 grow") and ok
	ok = Assertions.assert_equal(int(rp.get("copy_nbytes", -1)), 32, "copy old cap") and ok
	var tail: Dictionary = FlightMathScript.apply_01be4_tail(0x1000, 0x2000, 0x20)
	ok = Assertions.assert_true(bool(tail.get("is_01ba8_mid_entry", false)), "mid") and ok
	ok = Assertions.assert_equal(int(tail.get("result_ptr", -1)), 0x2000, "ret new") and ok
	var mv: Dictionary = FlightMathScript.fun_0001a63e_copy_bytes([0, 0], [0xAABBCCDD, 0x11223344], 8)
	ok = Assertions.assert_equal(int(mv.get("words", [0])[0]), 0xAABBCCDD, "mv0") and ok
	var c04: Dictionary = FlightMathScript.apply_01c04_plan(2, 1, 0x4400, 0x4C00)
	ok = Assertions.assert_equal(int(c04.get("count", -1)), 3, "01c04 cnt") and ok
	ok = Assertions.assert_equal(int(c04.get("nbytes", -1)), 0x24, "01c04 bytes") and ok
	c04 = FlightMathScript.apply_01c04_plan(0, 0, 0x4400, 0x4C00)
	ok = Assertions.assert_true(bool(c04.get("skip", false)), "01c04 skip") and ok
	var fill: Dictionary = FlightMathScript.apply_05116_slot_fill(
		0x10, 0x20, 0x30, 0xA, 0xB, 0xC, 0xD
	)
	ok = Assertions.assert_equal(int(fill.get("slot_u16_0", -1)), 0xD, "u16_0=p8") and ok
	ok = Assertions.assert_equal(int(fill.get("slot_u16_2", -1)), 0xA, "u16_2=p5") and ok
	ok = Assertions.assert_equal(int(fill.get("slot_u16_4", -1)), 0xB, "u16_4=p6") and ok
	ok = Assertions.assert_equal(int(fill.get("slot_u16_6", -1)), 0xC, "u16_6=p7") and ok
	ok = Assertions.assert_equal(int(fill.get("slot_x", -1)), 0x10, "x") and ok
	ok = Assertions.assert_equal(int(fill.get("slot_y", -1)), 0x20, "y") and ok
	ok = Assertions.assert_equal(int(fill.get("slot_z", -1)), 0x30, "z") and ok
	var g: Dictionary = FlightMathScript.apply_05116_world_gate(0x1000, 1)
	ok = Assertions.assert_true(bool(g.get("success", false)), "gate ok") and ok
	g = FlightMathScript.apply_05116_world_gate(0x1000, 0)
	ok = Assertions.assert_true(bool(g.get("need_051ec", false)), "need 051ec") and ok
	ok = Assertions.assert_equal(int(g.get("world_obj", -1)), 0, "fail clears") and ok
	## 046da identity stores
	var idn: Dictionary = FlightMathScript.apply_046da_identity_stores(0x4000, 3, 3, 10, 0, 0)
	ok = Assertions.assert_equal(int(idn.get("field_24", -1)), 0x4000, "24=pool") and ok
	ok = Assertions.assert_equal(int(idn.get("field_01", -1)), 3, "01=tpl") and ok
	ok = Assertions.assert_equal(int(idn.get("field_02", -1)), 3, "02=slot") and ok
	ok = Assertions.assert_true(bool(idn.get("bumped_03", false)), "slot==tpl +3") and ok
	ok = Assertions.assert_equal(int(idn.get("field_03", -1)), 1, "03→1") and ok
	ok = Assertions.assert_true(bool(idn.get("ored_flag1", false)), "tpl<2c |1") and ok
	idn = FlightMathScript.apply_046da_identity_stores(0x4000, 5, 2, 3, 0, 0)
	ok = Assertions.assert_true(not bool(idn.get("bumped_03", true)), "slot!=tpl") and ok
	ok = Assertions.assert_true(not bool(idn.get("ored_flag1", true)), "tpl>=2c") and ok
	## 045ba kind 2 / 3 field copy
	var d2: Dictionary = {
		0: 2, 2: 0x1111, 6: 0x2222, 10: 0x3333, 0x0E: 0x4444, 0x12: 0x5555,
		0x16: 0x66, 0x18: 0x77, 0x1A: 0x88, 0x1C: 0, 0x1E: 0x99, 0x20: 0xAA,
	}
	var a2: Dictionary = FlightMathScript.apply_045ba_from_desc(d2, 0xB838)
	ok = Assertions.assert_true(bool(a2.get("ok", false)), "kind2 ok") and ok
	ok = Assertions.assert_equal(int(a2.get("size", -1)), 0x52, "kind2 size") and ok
	ok = Assertions.assert_equal(int((a2.get("u8", {}) as Dictionary).get(0, -1)), 2, "kind2 +0") and ok
	ok = Assertions.assert_equal(int((a2.get("u32", {}) as Dictionary).get(0x18, -1)), 0x1111, "k2 +18") and ok
	ok = Assertions.assert_equal(int((a2.get("u16", {}) as Dictionary).get(0x38, -1)), 1, "1c==0→1") and ok
	ok = Assertions.assert_equal(int((a2.get("u32", {}) as Dictionary).get(0x40, -1)), 0xB838, "+40=b838") and ok
	var d3: Dictionary = {
		0: 3, 2: 1, 6: 2, 10: 3, 0x0E: 4, 0x12: 5, 0x16: 6, 0x18: 7, "desc_ptr": 0xD000,
	}
	var a3: Dictionary = FlightMathScript.apply_045ba_from_desc(d3, 0)
	ok = Assertions.assert_true(bool(a3.get("ok", false)), "kind3 ok") and ok
	ok = Assertions.assert_equal(int(a3.get("size", -1)), 0x34, "kind3 size") and ok
	ok = Assertions.assert_equal(int((a3.get("u32", {}) as Dictionary).get(0x28, -1)), 0xD000, "k3 desc*") and ok
	ok = Assertions.assert_true(not bool(FlightMathScript.apply_045ba_from_desc({0: 1}, 0).get("ok", true)), "kind1 fail") and ok
	## 03b98 camera abs axes + combine + 046da → 04e6e gate
	var ax98: Dictionary = FlightMathScript.apply_03b98_camera_abs_axes(
		100, -20, 5, 90, 0, 5
	)
	ok = Assertions.assert_equal(int(ax98.get("a", -1)), 10, "abs dx") and ok
	ok = Assertions.assert_equal(int(ax98.get("b", -1)), 20, "abs dy") and ok
	ok = Assertions.assert_equal(int(ax98.get("c", -1)), 0, "abs dz") and ok
	var m98: Dictionary = FlightMathScript.apply_fun_00003b98(10, 1, 5)
	ok = Assertions.assert_equal(int(m98.get("metric", -1)), 11, "03b98 10,1,5→11") and ok
	ok = Assertions.assert_equal(int(m98.get("field_10", -1)), 11, "03b98 field_10") and ok
	m98 = FlightMathScript.apply_fun_00003b98(0, 0, 0)
	ok = Assertions.assert_equal(int(m98.get("metric", -1)), 0, "03b98 zeros") and ok
	m98 = FlightMathScript.apply_fun_00003b98(0x30000, 0, 0)
	ok = Assertions.assert_equal(int(m98.get("metric", -1)), 0x30000, "03b98 one-axis") and ok
	var g44: Dictionary = FlightMathScript.apply_046da_04e6e_distance_gate(0, 0)
	ok = Assertions.assert_true(bool(g44.get("need_04e6e", false)), "near → 04e6e") and ok
	g44 = FlightMathScript.apply_046da_04e6e_distance_gate(0x30000, 0)
	ok = Assertions.assert_true(bool(g44.get("deferred", false)), "far → defer") and ok
	var v44: Dictionary = FlightMathScript.apply_04e6e_kind2_vertex_ptrs(0x4C00, 0x4400, 2, 3)
	ok = Assertions.assert_equal(int(v44.get("field_4c", -1)), 0x4C00, "+4c") and ok
	ok = Assertions.assert_equal(int(v44.get("field_44", -1)), 0x4400, "+44") and ok
	ok = Assertions.assert_equal(int(v44.get("alloc_bytes", -1)), 5 * 0xC, "alloc (36+3a)*0xC") and ok
	ok = Assertions.assert_equal(
		FlightMathScript.apply_04e6e_kind2_alloc_bytes(1, 1), 0x18, "alloc 1+1"
	) and ok
	var ls: Dictionary = FlightMathScript.apply_04e6e_kind2_list_select(0)
	ok = Assertions.assert_true(bool(ls.get("to_b5a4", false)), "bit0 clear → b5a4") and ok
	ls = FlightMathScript.apply_04e6e_kind2_list_select(1)
	ok = Assertions.assert_true(bool(ls.get("to_d4a4", false)), "bit0 set → d4a4") and ok
	var k3: Dictionary = FlightMathScript.apply_04e6e_kind3_plan(2)
	ok = Assertions.assert_true(bool(k3.get("to_d4a4", false)), "k3 d4a4") and ok
	ok = Assertions.assert_equal(int(k3.get("count", -1)), 2, "k3 cnt") and ok
	ok = Assertions.assert_equal(int(k3.get("table_bytes", -1)), 0x30, "k3 bytes") and ok
	var dp: Dictionary = FlightMathScript.apply_046da_desc_ptr(0x1000, 1, 0x2000, 0x30)
	ok = Assertions.assert_equal(int(dp.get("slot_addr", -1)), 0x1000 + 0x18 + 0x2E, "046da slot") and ok
	ok = Assertions.assert_equal(int(dp.get("desc_ptr", -1)), 0x2030, "046da desc") and ok
	var lk: Dictionary = FlightMathScript.apply_046da_parent_child_links(0xD300, 0, 0, 2, 0, 0)
	ok = Assertions.assert_equal(int(lk.get("field_24", -1)), 0xD300, "link parent") and ok
	ok = Assertions.assert_true(bool(lk.get("bumped_03", false)), "bump03") and ok
	ok = Assertions.assert_true(bool(lk.get("ored_flag1", false)), "or1") and ok
	## 04808 buffer size + one poly record
	ok = Assertions.assert_equal(
		FlightMathScript.apply_04808_buffer_bytes(2, 0, 0), 0x40, "3a*0x20"
	) and ok
	ok = Assertions.assert_equal(
		FlightMathScript.apply_04808_buffer_bytes(2, 3, 2), 0x40 + 12 + 6, "bit1 extra"
	) and ok
	var pr: Dictionary = FlightMathScript.apply_04808_poly_record({
		0: 0xAABBCCDD, 4: 1, 5: 2, 6: 3, 7: 4, 8: 5, 9: 0xAB, 0x0A: 0x11223344,
	})
	ok = Assertions.assert_equal(int(pr.get("rec_u32_0c", -1)), 0xAABBCCDD, "rec +0c") and ok
	ok = Assertions.assert_equal(int(pr.get("rec_u16_14", -1)), 5, "count") and ok
	ok = Assertions.assert_equal(int(pr.get("rec_u8_16", -1)), 0xA0, "nibble hi") and ok
	ok = Assertions.assert_equal(int(pr.get("rec_u8_17", -1)), 0x0B, "nibble lo") and ok
	ok = Assertions.assert_equal(int(pr.get("rec_u32_1c", -1)), 0x11223344, "rec +1c") and ok
	ok = Assertions.assert_equal(
		FlightMathScript.apply_04808_index_alloc_bytes(5), 10, "count<<1"
	) and ok
	var ix: Dictionary = FlightMathScript.apply_04808_index_words([0x1111, 0x2222, 0x3333], 3)
	ok = Assertions.assert_equal(int(ix.get("alloc_bytes", -1)), 6, "idx bytes") and ok
	ok = Assertions.assert_equal(int(ix.get("stream_advance", -1)), 0x0E + 6, "stream+") and ok
	var iw: Array = ix.get("words", [])
	ok = Assertions.assert_equal(iw.size(), 3, "3 words") and ok
	ok = Assertions.assert_equal(int(iw[1]), 0x2222, "word1") and ok
	ok = Assertions.assert_equal(
		FlightMathScript.apply_04808_stream_advance(2), 0x12, "0x0E+4"
	) and ok
	var loop48: Dictionary = FlightMathScript.apply_04808_poly_loop([
		{"desc": {0: 0xAAAA, 8: 1, 9: 0x10, 0x0A: 1}, "words": [0x1]},
		{"desc": {0: 0xBBBB, 8: 2, 9: 0x20, 0x0A: 2}, "words": [0x2, 0x3]},
	], 2)
	ok = Assertions.assert_equal(int(loop48.get("filled", -1)), 2, "2 polys") and ok
	ok = Assertions.assert_equal(int(loop48.get("stream_end", -1)), 0x10 + 0x12, "stream end") and ok
	var rec1: Dictionary = (loop48.get("records", []) as Array)[1]
	ok = Assertions.assert_equal(int(rec1.get("rec_base", -1)), 0x20, "stride 0x20") and ok
	ok = Assertions.assert_equal(int((rec1.get("record", {}) as Dictionary).get("rec_u32_0c", -1)), 0xBBBB, "poly1") and ok
	var tr48: Dictionary = FlightMathScript.apply_04808_bit1_trailer(2, 3, 2)
	ok = Assertions.assert_true(bool(tr48.get("enabled", false)), "bit1 on") and ok
	ok = Assertions.assert_equal(int(tr48.get("trailer_offset", -1)), 0x40, "after 2*0x20") and ok
	ok = Assertions.assert_equal(int(tr48.get("word_count", -1)), 3, "38 words") and ok
	ok = Assertions.assert_equal(int((tr48.get("words", []) as Array)[2]), 2, "word=i") and ok
	tr48 = FlightMathScript.apply_04808_bit1_trailer(2, 3, 0)
	ok = Assertions.assert_true(not bool(tr48.get("enabled", true)), "bit1 off") and ok
	## 04e6e → post-04808 path / 02bd8 flag gate
	var gate28: Dictionary = FlightMathScript.apply_04e6e_02bd8_gate(0, 0, 0)
	ok = Assertions.assert_true(bool(gate28.get("need_02bd8", false)), "all clear → 02bd8") and ok
	var p48: Dictionary = FlightMathScript.apply_04e6e_post_04808_path(0x10, 0, 0)
	ok = Assertions.assert_equal(str(p48.get("path", "")), "01c5c", "+5→01c5c") and ok
	ok = Assertions.assert_true(bool(p48.get("need_03ea0", false)), "01c5c→03ea0") and ok
	p48 = FlightMathScript.apply_04e6e_post_04808_path(0, 0, 0x10)
	ok = Assertions.assert_equal(str(p48.get("path", "")), "15762", "+7→15762") and ok
	p48 = FlightMathScript.apply_04e6e_post_04808_path(0, 0x10, 0x10)
	ok = Assertions.assert_equal(str(p48.get("path", "")), "04958", "+6 wins") and ok
	## 04e6e → 04958 args / entry rel / post follow-up
	var a58: Dictionary = FlightMathScript.apply_04e6e_04958_args()
	ok = Assertions.assert_equal(int(a58.get("param_2", -1)), 0xB4E1, "04958 p2") and ok
	ok = Assertions.assert_equal(int(a58.get("param_4", -1)), 0x7FE4, "04958 p4") and ok
	var r58: Dictionary = FlightMathScript.apply_04958_entry_rel(
		[10, 20, 30, 40, 50, 60], 1, 1
	)
	ok = Assertions.assert_true(bool(r58.get("applied", false)), "04958 rel") and ok
	ok = Assertions.assert_equal(int((r58.get("local_1be4", []) as Array)[0]), 30, "1be4 x") and ok
	var fu58: Dictionary = FlightMathScript.apply_04e6e_post_04958_followup(1)
	ok = Assertions.assert_equal(str(fu58.get("path", "")), "04916", "0e==1→04916") and ok
	fu58 = FlightMathScript.apply_04e6e_post_04958_followup(0)
	ok = Assertions.assert_equal(str(fu58.get("path", "")), "03ea0", "0e!=1→03ea0") and ok
	var p16: Dictionary = FlightMathScript.apply_fun_00004916(2, 0x1234, 0x80)
	ok = Assertions.assert_equal(int(p16.get("count", -1)), 2, "04916 count") and ok
	ok = Assertions.assert_equal(int((p16.get("slots", []) as Array)[0].get("field_4", -1)), 0x1234, "04916 word") and ok
	## 03c68 abs-delta metric + 04958 poly pairs / thinning
	ok = Assertions.assert_equal(
		FlightMathScript.fun_00003c68(0, 0, 0, 4, 0, 0), 4, "03c68 |dx|"
	) and ok
	ok = Assertions.assert_equal(
		FlightMathScript.fun_00003c68(0, 0, 0, 4, 4, 4), 6, "03c68 4+((4+4)>>2)"
	) and ok
	var pxz: Dictionary = FlightMathScript.apply_04958_project_xz(110, 330, 10, 30, 0)
	ok = Assertions.assert_equal(int(pxz.get("x", -1)), 100, "proj x") and ok
	ok = Assertions.assert_equal(int(pxz.get("z", -1)), 300, "proj z") and ok
	var pp: Dictionary = FlightMathScript.apply_04958_poly_pairs_simple(
		[101, 202, 303], [0], 100, 300, 0
	)
	ok = Assertions.assert_true(bool(pp.get("ok", false)), "pairs ok") and ok
	ok = Assertions.assert_true(bool(pp.get("cull", false)), "cull <3") and ok
	ok = Assertions.assert_equal(int((pp.get("pairs", []) as Array)[0].get("x", -1)), 1, "pair x") and ok
	## Large edge vs camera at origin → cam/denom (100/3) <= edge acc (100) → accept.
	pp = FlightMathScript.apply_04958_poly_pairs(
		[0, 0, 0, 100, 0, 0], [0, 1], 0, 0, 0, 0, 0, 0
	)
	ok = Assertions.assert_equal(int(pp.get("pair_count", -1)), 2, "thin accept both") and ok
	## Tiny edge vs distant camera on Z → cam/denom (1000/3) > edge (1) → skip.
	pp = FlightMathScript.apply_04958_poly_pairs(
		[0, 0, 0, 1, 0, 0], [0, 1], 0, 0, 0, 0, 1000, 0
	)
	ok = Assertions.assert_equal(int(pp.get("pair_count", -1)), 1, "thin skip") and ok
	## FUN_0000b190 x-plane clip (keep x >= plane)
	var clip: Dictionary = FlightMathScript.fun_0000b190(
		[{"x": 0, "z": 0}, {"x": 10, "z": 0}, {"x": 10, "z": 10}], 5
	)
	ok = Assertions.assert_equal(int(clip.get("count", -1)), 4, "b190 cross→4") and ok
	clip = FlightMathScript.fun_0000b190(
		[{"x": 10, "z": 0}, {"x": 20, "z": 0}, {"x": 15, "z": 10}], 5
	)
	ok = Assertions.assert_equal(int(clip.get("count", -1)), 3, "b190 all in") and ok
	var cb: Dictionary = FlightMathScript.apply_04958_clip_b190(
		{"pair_count": 2, "pairs": [{"x": 0, "z": 0}, {"x": 1, "z": 1}], "cull": true},
		0x7FE4
	)
	ok = Assertions.assert_true(not bool(cb.get("applied_b190", true)), "<3 no b190") and ok
	cb = FlightMathScript.apply_04958_clip_b190(
		{
			"pair_count": 3,
			"pairs": [{"x": 0, "z": 0}, {"x": 10, "z": 0}, {"x": 5, "z": 10}],
			"cull": false,
		},
		0x7FE4
	)
	ok = Assertions.assert_true(bool(cb.get("applied_b190", false)), "b190 on") and ok
	ok = Assertions.assert_true(bool(cb.get("deferred_b242", false)), "b242 defer") and ok
	## FUN_0000b242 max-x clip (keep x <= plane)
	clip = FlightMathScript.fun_0000b242(
		[{"x": 0, "z": 0}, {"x": 10, "z": 0}, {"x": 10, "z": 10}], 5
	)
	ok = Assertions.assert_equal(int(clip.get("count", -1)), 3, "b242 cross→3") and ok
	clip = FlightMathScript.fun_0000b242(
		[{"x": 0, "z": 0}, {"x": 4, "z": 0}, {"x": 2, "z": 4}], 5
	)
	ok = Assertions.assert_equal(int(clip.get("count", -1)), 3, "b242 all in") and ok
	var cb2: Dictionary = FlightMathScript.apply_04958_clip_b242(cb, 0x7FE4)
	ok = Assertions.assert_true(bool(cb2.get("applied_b242", false)), "b242 on") and ok
	ok = Assertions.assert_true(bool(cb2.get("deferred_b2f4", false)), "b2f4 defer") and ok
	ok = Assertions.assert_true(not bool(cb2.get("cull", true)), "b242 keep") and ok
	## FUN_0000b2f4 min-z clip (keep z >= plane)
	clip = FlightMathScript.fun_0000b2f4(
		[{"x": 0, "z": 0}, {"x": 10, "z": 0}, {"x": 5, "z": 10}], 5
	)
	ok = Assertions.assert_equal(int(clip.get("count", -1)), 3, "b2f4 cross→3") and ok
	clip = FlightMathScript.fun_0000b2f4(
		[{"x": 0, "z": 6}, {"x": 10, "z": 6}, {"x": 5, "z": 10}], 5
	)
	ok = Assertions.assert_equal(int(clip.get("count", -1)), 3, "b2f4 all in") and ok
	var cb3: Dictionary = FlightMathScript.apply_04958_clip_b2f4(cb2, 0x7FE4)
	ok = Assertions.assert_true(bool(cb3.get("applied_b2f4", false)), "b2f4 on") and ok
	ok = Assertions.assert_true(bool(cb3.get("deferred_b3aa", false)), "b3aa defer") and ok
	ok = Assertions.assert_true(not bool(cb3.get("cull", true)), "b2f4 keep") and ok
	## FUN_0000b3aa max-z clip (keep z <= plane)
	clip = FlightMathScript.fun_0000b3aa(
		[{"x": 0, "z": 0}, {"x": 10, "z": 0}, {"x": 5, "z": 10}], 5
	)
	ok = Assertions.assert_equal(int(clip.get("count", -1)), 4, "b3aa cross→4") and ok
	clip = FlightMathScript.fun_0000b3aa(
		[{"x": 0, "z": 0}, {"x": 10, "z": 0}, {"x": 5, "z": 4}], 5
	)
	ok = Assertions.assert_equal(int(clip.get("count", -1)), 3, "b3aa all in") and ok
	var cb4: Dictionary = FlightMathScript.apply_04958_clip_b3aa(cb3, 0x7FE4)
	ok = Assertions.assert_true(bool(cb4.get("applied_b3aa", false)), "b3aa on") and ok
	ok = Assertions.assert_true(bool(cb4.get("write_count_14", false)), "count→+14") and ok
	ok = Assertions.assert_true(not bool(cb4.get("cull", true)), "b3aa keep") and ok
	## 04e6e → 15762 args (5669–5682)
	var a62: Dictionary = FlightMathScript.apply_04e6e_15762_args(0, 0x17, 1, 2, 3, 4)
	ok = Assertions.assert_true(bool(a62.get("zeroed", false)), "null handle→0") and ok
	a62 = FlightMathScript.apply_04e6e_15762_args(0x1000, 0x10, 1, 2, 3, 4)
	ok = Assertions.assert_true(bool(a62.get("zeroed", false)), "key<15→0") and ok
	a62 = FlightMathScript.apply_04e6e_15762_args(0x1000, 0x17, 0x10, 0x20, 0x30, 0x40)
	ok = Assertions.assert_true(not bool(a62.get("zeroed", true)), "key in range") and ok
	ok = Assertions.assert_equal(int(a62.get("param_2", -1)), 0x10, "p2=+34") and ok
	ok = Assertions.assert_equal(int(a62.get("param_5", -1)), 0x40, "p5=+40") and ok
	var e62: Dictionary = FlightMathScript.apply_15762_entry_plan(0x2000, 1, 1, 0, 0, 0, 0)
	ok = Assertions.assert_equal(int(e62.get("count_1a_1e", -1)), 2, "1a+1e") and ok
	ok = Assertions.assert_equal(int(e62.get("poly_stream", -1)), 0x2000 + 0x22 + 0x18, "stream") and ok
	ok = Assertions.assert_true(bool(e62.get("applied_0253e", false)), "0253e") and ok
	ok = Assertions.assert_true(not bool(e62.get("applied_02976", true)), "no src→no 02976") and ok
	## 02976 identity: (x*0x1000+0x800)>>12 ≈ x
	var mat76: Array = FlightMathScript.fun_0000253e(0, 0, 0)
	var t76: Dictionary = FlightMathScript.fun_00002976(1, [0x100, 0x200, 0x300], mat76)
	ok = Assertions.assert_equal(int((t76.get("xyz", []) as Array)[0]), 0x100, "02976 id x") and ok
	ok = Assertions.assert_equal(int((t76.get("xyz", []) as Array)[1]), 0x200, "02976 id y") and ok
	ok = Assertions.assert_equal(int((t76.get("xyz", []) as Array)[2]), 0x300, "02976 id z") and ok
	e62 = FlightMathScript.apply_15762_entry_plan(0x2000, 1, 0, 0, 0, 0, 0, [10, 20, 30])
	ok = Assertions.assert_true(bool(e62.get("applied_02976", false)), "02976 with src") and ok
	ok = Assertions.assert_equal(int((e62.get("local_1e94", []) as Array)[0]), 10, "1e94 x") and ok
	## 15762 local_3324 rel + bias_1a
	var r3324: Dictionary = FlightMathScript.apply_15762_local_3324_rel(
		[10, 20, 30, 40, 50, 60], 1, 1
	)
	ok = Assertions.assert_true(bool(r3324.get("applied", false)), "3324 on") and ok
	ok = Assertions.assert_equal(int((r3324.get("xyz", []) as Array)[0]), 30, "3324 x") and ok
	ok = Assertions.assert_equal(int((r3324.get("xyz", []) as Array)[1]), 30, "3324 y") and ok
	var b1a: Dictionary = FlightMathScript.apply_15762_bias_1a_low16(
		[0x51, 0x62, 0x73, 0x81, 0x92, 0xA3], 1, 0, 0, 0x44, 0
	)
	ok = Assertions.assert_true(bool(b1a.get("applied", false)), "bias on") and ok
	ok = Assertions.assert_equal(int((b1a.get("xyz", []) as Array)[1]), 0x1E, "bias y") and ok
	ok = Assertions.assert_equal(int((b1a.get("xyz", []) as Array)[3]), 0x81, "v1 kept") and ok
	gate28 = FlightMathScript.apply_04e6e_02bd8_gate(0x10, 0, 0)
	ok = Assertions.assert_true(not bool(gate28.get("need_02bd8", true)), "bit4 +5 blocks") and ok
	gate28 = FlightMathScript.apply_04e6e_02bd8_gate(0, 0x10, 0)
	ok = Assertions.assert_true(not bool(gate28.get("need_02bd8", true)), "bit4 +6 blocks") and ok
	gate28 = FlightMathScript.apply_04e6e_02bd8_gate(0, 0, 0x10)
	ok = Assertions.assert_true(not bool(gate28.get("need_02bd8", true)), "bit4 +7 blocks") and ok
	var args28: Dictionary = FlightMathScript.apply_04e6e_02bd8_args(0x100, 2, 3, 0x2000, 0x4400)
	ok = Assertions.assert_equal(int(args28.get("param_2_count", -1)), 5, "36+3a") and ok
	ok = Assertions.assert_equal(int(args28.get("param_4_verts", -1)), 0x4400, "verts +44") and ok
	## 02bd8 null-aux commit
	var c28: Dictionary = FlightMathScript.apply_02bd8_null_aux_commit(10, 20, 30, 0, 0, 0)
	ok = Assertions.assert_true(bool(c28.get("commit", false)), "both null → commit") and ok
	ok = Assertions.assert_true(bool(c28.get("locals_unchanged", false)), "empty chain") and ok
	ok = Assertions.assert_equal(int(c28.get("field_18", -1)), 10, "commit +18") and ok
	c28 = FlightMathScript.apply_02bd8_null_aux_commit(10, 20, 30, 0, 1, 0)
	ok = Assertions.assert_true(not bool(c28.get("commit", true)), "verts set → no commit") and ok
	c28 = FlightMathScript.apply_02bd8_null_aux_commit(10, 20, 30, 1, 0, 0)
	ok = Assertions.assert_true(not bool(c28.get("commit", true)), "mesh set → no commit") and ok
	var fu48: Dictionary = FlightMathScript.apply_04e6e_post_02bd8_followup(0x8000, 0x11)
	ok = Assertions.assert_true(bool(fu48.get("need_0435a", false)), "0435a") and ok
	ok = Assertions.assert_equal(int(fu48.get("0435a_param_2", -1)), 0, "0435a arg2=0") and ok
	ok = Assertions.assert_true(bool(fu48.get("need_03da8", false)), "03da8") and ok
	ok = Assertions.assert_equal(int(fu48.get("03da8_param_2", -1)), 0x11, "03da8=+10") and ok
	## FUN_00003da8 band index
	var tab: Array = [0, 10, 50, 100, 500, 1000]
	var d8: Dictionary = FlightMathScript.apply_fun_00003da8(3, 75, tab)
	## ROM DAT_0001b190: field_30=0, param_2=0x10 → band 3
	var rom: Array = FlightMathScript.load_dat_0001b190_table()
	ok = Assertions.assert_equal(rom.size(), 40, "b190 count") and ok
	ok = Assertions.assert_equal(int(rom[3]), 2048, "b190[3]") and ok
	ok = Assertions.assert_equal(int(rom[39]), 100000000, "b190[39]") and ok
	var rom8: Dictionary = FlightMathScript.apply_fun_00003da8(0, 0x10, rom)
	ok = Assertions.assert_equal(int(rom8.get("return", -1)), 1, "ROM change") and ok
	ok = Assertions.assert_equal(int(rom8.get("field_30", -1)), 3, "ROM →3") and ok
	ok = Assertions.assert_equal(int(d8.get("return", -1)), 0, "in-band no-op") and ok
	ok = Assertions.assert_equal(int(d8.get("field_30", -1)), 3, "stay 3") and ok
	d8 = FlightMathScript.apply_fun_00003da8(3, 5, tab)
	ok = Assertions.assert_equal(int(d8.get("return", -1)), 1, "walk down") and ok
	ok = Assertions.assert_equal(int(d8.get("field_30", -1)), 1, "→1") and ok
	d8 = FlightMathScript.apply_fun_00003da8(3, 200, tab)
	ok = Assertions.assert_equal(int(d8.get("return", -1)), 1, "walk up") and ok
	ok = Assertions.assert_equal(int(d8.get("field_30", -1)), 4, "→4") and ok
	## FUN_000044a4 type-5 flags
	var t5: Dictionary = FlightMathScript.apply_044a4_type5_flags(0, 0x100, 5, 0)
	ok = Assertions.assert_true(bool(t5.get("applied", false)), "type5 apply") and ok
	ok = Assertions.assert_equal(int(t5.get("flags_04", -1)) & 0x40, 0x40, "|=0x40") and ok
	t5 = FlightMathScript.apply_044a4_type5_flags(0x40, 0x100, 5, 1)
	ok = Assertions.assert_equal(int(t5.get("flags_04", -1)) & 0x40, 0, "&=~0x40") and ok
	t5 = FlightMathScript.apply_044a4_type5_flags(0, 0x100, 4, 0)
	ok = Assertions.assert_true(not bool(t5.get("applied", true)), "type!=5") and ok
	t5 = FlightMathScript.apply_044a4_type5_flags(0, 0, 5, 0)
	ok = Assertions.assert_true(not bool(t5.get("applied", true)), "no entity") and ok
	## FUN_0000435a template addr (5020–5022)
	var t35: Dictionary = FlightMathScript.apply_0435a_template_addr(0x2000, 0x1000, 1, 0x30)
	ok = Assertions.assert_true(bool(t35.get("ok", false)), "tpl ok") and ok
	ok = Assertions.assert_equal(int(t35.get("slot_addr", -1)), 0x1000 + 0x2E + 0x18, "tpl slot") and ok
	ok = Assertions.assert_equal(int(t35.get("template_ptr", -1)), 0x2030, "tpl ptr") and ok
	t35 = FlightMathScript.apply_0435a_template_addr(0, 0x1000, 0, 0)
	ok = Assertions.assert_true(not bool(t35.get("ok", true)), "tpl needs base") and ok
	## FUN_00004e6e → 04808 desc addr (5644–5647)
	var d48: Dictionary = FlightMathScript.apply_04e6e_04808_desc_addr(0x1000, 2, 2)
	ok = Assertions.assert_equal(int(d48.get("offset", -1)), 0x22 + 4 * 0xC, "04808 off") and ok
	ok = Assertions.assert_equal(int(d48.get("desc_ptr", -1)), 0x1000 + 0x22 + 0x30, "04808 desc") and ok
	## FUN_0000435a poly stream base / advance (5049 / 5069)
	var sb35: Dictionary = FlightMathScript.apply_0435a_poly_stream_base(0x1000, 2, 1)
	ok = Assertions.assert_equal(int(sb35.get("offset", -1)), 0x22 + 2 * 0xC + 0xC, "stream off") and ok
	ok = Assertions.assert_equal(int(sb35.get("stream_base", -1)), 0x1000 + 0x22 + 0x24, "stream base") and ok
	ok = Assertions.assert_equal(
		FlightMathScript.apply_0435a_poly_stream_advance(0x2000, 2), 0x2000 + 0x0E + 4, "adv"
	) and ok
	## FUN_0000435a gate / +0xc
	var g35: Dictionary = FlightMathScript.apply_0435a_gate(0, 1)
	ok = Assertions.assert_true(bool(g35.get("enter", false)), "phase1 enter") and ok
	g35 = FlightMathScript.apply_0435a_gate(2, 1)
	ok = Assertions.assert_true(not bool(g35.get("enter", true)), "bit1 +7 blocks") and ok
	g35 = FlightMathScript.apply_0435a_gate(0, 0)
	ok = Assertions.assert_true(not bool(g35.get("enter", true)), "phase0 blocks") and ok
	ok = Assertions.assert_equal(FlightMathScript.apply_0435a_scale_factor(0, 3), 2, "phase-1") and ok
	ok = Assertions.assert_equal(FlightMathScript.apply_0435a_scale_factor(2, 3), 1, "bit1 +5 →1") and ok
	var c35: Dictionary = FlightMathScript.apply_0435a_field_0c(0, 0x1000, 0, 2, 0)
	ok = Assertions.assert_equal(int(c35.get("field_0c", -1)), 0x800, "half") and ok
	c35 = FlightMathScript.apply_0435a_field_0c(0, 100, 3, 2, 0)
	ok = Assertions.assert_equal(int(c35.get("field_0c", -1)), 300, "*scale") and ok
	c35 = FlightMathScript.apply_0435a_field_0c(0, 0x500000, 1, 2, 0)
	ok = Assertions.assert_true(bool(c35.get("clamped", false)), "clamp") and ok
	ok = Assertions.assert_equal(int(c35.get("field_0c", -1)), 0x42B209, "clamp val") and ok
	c35 = FlightMathScript.apply_0435a_field_0c(1000000000, 100, 1, 2, 0)
	ok = Assertions.assert_true(not bool(c35.get("wrote", true)), "sentinel skip") and ok
	ok = Assertions.assert_equal(
		FlightMathScript.apply_0435a_poly_1c_value(100, 0, false), 50, "1c half"
	) and ok
	ok = Assertions.assert_equal(
		FlightMathScript.apply_0435a_poly_1c_value(100, 3, false), 300, "1c *scale"
	) and ok
	ok = Assertions.assert_equal(
		FlightMathScript.apply_0435a_poly_1c_value(100, 0, true), 500, "1c player*5"
	) and ok
	var p1c: Dictionary = FlightMathScript.apply_0435a_poly_1c_loop([0x200, 0x400], 2, 0, false, 0, 2)
	ok = Assertions.assert_true(bool(p1c.get("ran", false)), "1c loop") and ok
	ok = Assertions.assert_equal(int((p1c.get("values", []) as Array)[0]), 0x100, "poly0") and ok
	ok = Assertions.assert_equal(int((p1c.get("values", []) as Array)[1]), 0x200, "poly1") and ok
	p1c = FlightMathScript.apply_0435a_poly_1c_loop([1], 1, 0, false, 1, 2)
	ok = Assertions.assert_true(not bool(p1c.get("ran", true)), "param_2!=0 skip") and ok
	## FUN_00001c5c + 02bd8 null-aux node/walk
	var c1c: Dictionary = FlightMathScript.apply_fun_00001c5c(1, [10, 20, 30], 1, 2, 3)
	ok = Assertions.assert_equal(int((c1c.get("xyz", []) as Array)[0]), 11, "1c5c x") and ok
	ok = Assertions.assert_equal(int((c1c.get("xyz", []) as Array)[2]), 33, "1c5c z") and ok
	ok = Assertions.assert_true(
		not FlightMathScript.apply_02bd8_node_need_rotate(0, 0, 0), "no rot"
	) and ok
	ok = Assertions.assert_true(
		FlightMathScript.apply_02bd8_node_need_rotate(1, 0, 0), "need rot"
	) and ok
	var n28: Dictionary = FlightMathScript.apply_02bd8_null_aux_node(10, 20, 30, 5, 0, -1)
	ok = Assertions.assert_true(bool(n28.get("ok", false)), "node ok") and ok
	ok = Assertions.assert_equal(int(n28.get("x", -1)), 15, "node x") and ok
	ok = Assertions.assert_equal(int(n28.get("z", -1)), 29, "node z") and ok
	var slot_n: Dictionary = FlightMathScript.apply_02bd8_chain_slot_node(
		0, 0, 0, 1, 2, 3
	)
	ok = Assertions.assert_equal(int(slot_n.get("dx", -1)), 1, "slot dx") and ok
	ok = Assertions.assert_equal(int(slot_n.get("s2", -1)), 0, "slot s2") and ok
	var w28: Dictionary = FlightMathScript.apply_02bd8_null_aux_walk(
		0, 0, 0, [{"dx": 1, "dy": 2, "dz": 3}, {"dx": 10, "dy": 0, "dz": 0}]
	)
	ok = Assertions.assert_equal(int(w28.get("steps", -1)), 2, "2 steps") and ok
	ok = Assertions.assert_equal(int(w28.get("x", -1)), 11, "walk x") and ok
	ok = Assertions.assert_equal(int(w28.get("y", -1)), 2, "walk y") and ok
	## rotate without fixture matrix9 → 0253e(s2,s4,s6) then 02ada
	var n_rot: Dictionary = FlightMathScript.apply_02bd8_null_aux_node(
		10, 0, 0, 0, 0, 0, 0, 0, 0
	)
	## s2=s4=s6=0 → no rotate
	ok = Assertions.assert_true(bool(n_rot.get("ok", false)), "no-rot ok") and ok
	n_rot = FlightMathScript.apply_02bd8_null_aux_node(10, 0, 0, 0, 0, 0, 0, 0x1000, 0)
	ok = Assertions.assert_true(bool(n_rot.get("applied_0253e", false)), "0253e built") and ok
	ok = Assertions.assert_true(bool(n_rot.get("applied_02ada", false)), "02ada") and ok
	ok = Assertions.assert_equal(int(n_rot.get("z", -1)), 10, "Ry90 x→+z") and ok
	ok = Assertions.assert_equal(int(n_rot.get("x", -1)), 0, "Ry90 x→0") and ok
	w28 = FlightMathScript.apply_02bd8_null_aux_walk(
		0, 0, 0, [{"dx": 1, "dy": 0, "dz": 0, "s2": 1}]
	)
	ok = Assertions.assert_true(not bool(w28.get("blocked_rotate", true)), "rot ok") and ok
	ok = Assertions.assert_equal(int(w28.get("steps", -1)), 1, "rot 1 step") and ok
	## FUN_00002ada (no +0x800)
	var id9: Array = [0x1000, 0, 0, 0, 0x1000, 0, 0, 0, 0x1000]
	var a28: Dictionary = FlightMathScript.fun_00002ada(1, [100, 200, 300], id9)
	ok = Assertions.assert_equal(int((a28.get("xyz", []) as Array)[0]), 100, "id x") and ok
	ok = Assertions.assert_equal(int((a28.get("xyz", []) as Array)[2]), 300, "id z") and ok
	var sc9: Array = [0x2000, 0, 0, 0, 0x2000, 0, 0, 0, 0x2000]
	a28 = FlightMathScript.fun_00002ada(1, [100, 200, 300], sc9)
	ok = Assertions.assert_equal(int((a28.get("xyz", []) as Array)[0]), 200, "×2 x") and ok
	ok = Assertions.assert_equal(int((a28.get("xyz", []) as Array)[1]), 400, "×2 y") and ok
	w28 = FlightMathScript.apply_02bd8_null_aux_walk(
		10, 0, 0, [{"s2": 1, "matrix9": sc9}]
	)
	ok = Assertions.assert_equal(int(w28.get("steps", -1)), 1, "02ada step") and ok
	ok = Assertions.assert_equal(int(w28.get("x", -1)), 20, "02ada×2") and ok
	## both-aux + field_34 shift
	var sh28: Dictionary = FlightMathScript.apply_02bd8_shifted_deltas(1, 2, 3, 4)
	ok = Assertions.assert_equal(int(sh28.get("dx", -1)), 16, "1<<4") and ok
	ok = Assertions.assert_equal(int(sh28.get("dy", -1)), 32, "2<<4") and ok
	var b28: Dictionary = FlightMathScript.apply_02bd8_both_aux_walk(
		1, [10, 20, 30], [{"dx": 1, "dy": 0, "dz": 0}], 3
	)
	ok = Assertions.assert_equal(int(b28.get("steps", -1)), 1, "both 1 step") and ok
	ok = Assertions.assert_equal(int((b28.get("xyz", []) as Array)[0]), 10 + 8, "10+(1<<3)") and ok
	b28 = FlightMathScript.apply_02bd8_both_aux_walk(
		2, [1, 2, 3, 4, 5, 6], [{"dx": 1, "dy": 1, "dz": 1}], 0
	)
	ok = Assertions.assert_equal(int(b28.get("count", -1)), 2, "count 2") and ok
	ok = Assertions.assert_equal(int((b28.get("xyz", []) as Array)[3]), 5, "v1 x") and ok
	return ok

## [RECONSTRUCTED] field_676 / 677 weapon phases (14673–14719).
func _test_e792_weapon_676_677_branch() -> bool:
	var ok := true
	## 676==1, 682>1, flag clear → fire, 682-=2, 676→2
	var br: Dictionary = FlightMathScript.apply_e792_weapon_676_branch(1, 5, 0, 0x100)
	ok = Assertions.assert_true(bool(br.get("need_15d20", false)), "676 need 15d20") and ok
	ok = Assertions.assert_equal(int(br.get("field_682", -1)), 3, "682 5→3") and ok
	ok = Assertions.assert_equal(int(br.get("field_676", -1)), 2, "676 1→2") and ok
	ok = Assertions.assert_equal(int(br.get("local_28_stack", -1)), 0x140, "local_28=pos+0x40") and ok
	## flag 0x10 blocks fire but still advances 676
	br = FlightMathScript.apply_e792_weapon_676_branch(1, 5, 0x10, 0)
	ok = Assertions.assert_true(not bool(br.get("fired", true)), "flag blocks 676") and ok
	ok = Assertions.assert_equal(int(br.get("field_676", -1)), 2, "676 still advances") and ok
	ok = Assertions.assert_equal(int(br.get("field_682", -1)), 5, "682 unchanged") and ok
	## wrap 2→0
	br = FlightMathScript.apply_e792_weapon_676_branch(2, 5, 0, 0)
	ok = Assertions.assert_equal(int(br.get("field_676", -1)), 0, "676 2→0") and ok
	## 677==1 fire → status|1, 677←2, player flags
	br = FlightMathScript.apply_e792_weapon_677_branch(1, 0, 0, true, 1, 0)
	ok = Assertions.assert_true(bool(br.get("need_19430", false)), "677 need 19430") and ok
	ok = Assertions.assert_equal(int(br.get("field_677", -1)), 2, "677←2") and ok
	ok = Assertions.assert_equal(int(br.get("status_1a1", 0)) & 1, 1, "status|1") and ok
	ok = Assertions.assert_true(bool(br.get("set_dat_0001b874", false)), "player b874") and ok
	ok = Assertions.assert_true(bool(br.get("set_dat_0001b87a", false)), "b87a when ammo") and ok
	## flags&1 blocks
	br = FlightMathScript.apply_e792_weapon_677_branch(1, 1, 0, true, 1, 0)
	ok = Assertions.assert_true(not bool(br.get("fired", true)), "flag1 blocks 677") and ok
	return ok

## [RECONSTRUCTED] bVar6 cleanup epilogue (14736–14748).
func _test_e792_bvar6_cleanup() -> bool:
	var ok := true
	var cu: Dictionary = FlightMathScript.apply_e792_bvar6_cleanup(false, 0xFFFF, 0x20)
	ok = Assertions.assert_true(not bool(cu.get("applied", true)), "no bVar6 skip") and ok
	## status bit0 clear → 1a2=0; status=(s&0x8000)|0x900
	cu = FlightMathScript.apply_e792_bvar6_cleanup(true, 0x8002, 0x20)
	ok = Assertions.assert_true(bool(cu.get("applied", false)), "applied") and ok
	ok = Assertions.assert_equal(int(cu.get("status_1a2", -1)), 0, "1a2 cleared") and ok
	ok = Assertions.assert_equal(int(cu.get("status_1a1", -1)), 0x8900, "status mask|0x900") and ok
	ok = Assertions.assert_equal(int(cu.get("state_32", -1)), 0xE772, "state_32") and ok
	ok = Assertions.assert_true(bool(cu.get("clear_61a_61e", false)), "clear 61a/61e") and ok
	## status bit0 set, 1a2>0x16 → clamp
	cu = FlightMathScript.apply_e792_bvar6_cleanup(true, 0x0001, 0x20)
	ok = Assertions.assert_equal(int(cu.get("status_1a2", -1)), 0x16, "1a2 clamp") and ok
	ok = Assertions.assert_equal(int(cu.get("status_1a1", -1)), 0x900, "status 0x900") and ok
	return ok

## [RECONSTRUCTED] flags_685&2 ammo tail (14721–14734).
func _test_e792_flags685_bit2_tail() -> bool:
	var ok := true
	var br: Dictionary = FlightMathScript.apply_e792_flags685_bit2_tail(0, 3, 4, [])
	ok = Assertions.assert_true(not bool(br.get("active", true)), "no flag skip") and ok
	## first draw &0x3f != 0 → no ammo change
	br = FlightMathScript.apply_e792_flags685_bit2_tail(2, 3, 4, [0x01])
	ok = Assertions.assert_true(bool(br.get("active", false)), "flag active") and ok
	ok = Assertions.assert_equal(int(br.get("weapon_count_67d", -1)), 3, "67d unchanged") and ok
	ok = Assertions.assert_equal(int(br.get("weapon_count_67e", -1)), 4, "67e unchanged") and ok
	## first &0x3f==0, second odd, 67d!=0 → 67d--
	br = FlightMathScript.apply_e792_flags685_bit2_tail(2, 3, 4, [0x40, 0x03])
	ok = Assertions.assert_true(bool(br.get("decremented_67d", false)), "67d--") and ok
	ok = Assertions.assert_equal(int(br.get("weapon_count_67d", -1)), 2, "67d 3→2") and ok
	## first &0x3f==0, second even → 67e--
	br = FlightMathScript.apply_e792_flags685_bit2_tail(2, 3, 4, [0x80, 0x02])
	ok = Assertions.assert_true(bool(br.get("decremented_67e", false)), "67e--") and ok
	ok = Assertions.assert_equal(int(br.get("weapon_count_67e", -1)), 3, "67e 4→3") and ok
	return ok

func _test_landing_pitch_followon() -> bool:
	var ok := true
	## -23*0x10 = -368 < -0x168 → hard crash
	var f: Dictionary = FlightMathScript.apply_landing_pitch_followon(-23, 100, 0, true)
	ok = Assertions.assert_true(bool(f.get("hard_crash", false)), "hard crash") and ok
	ok = Assertions.assert_true((int(f.get("status_1a1", 0)) & 0x400) != 0, "status|0x400") and ok
	ok = Assertions.assert_true(bool(f.get("early_return", false)), "early return") and ok
	ok = Assertions.assert_true(not bool(f.get("clear_field_18e", true)), "no 18e clear on hard") and ok
	ok = Assertions.assert_true(not bool(f.get("need_13452", true)), "no 13452 when pos_2e!=0") and ok
	ok = Assertions.assert_true(not bool(f.get("set_dat_0001b856", true)), "no b856 on hard") and ok
	f = FlightMathScript.apply_landing_pitch_followon(-23, 0, 0, true)
	ok = Assertions.assert_true(bool(f.get("need_13452", false)), "need 13452 when pos_2e==0") and ok
	## -14*0x10 = -224 < -0xd8 → rough, clears 18e, no b856
	f = FlightMathScript.apply_landing_pitch_followon(-14, 0, 0, true)
	ok = Assertions.assert_true(bool(f.get("rough", false)), "rough landing") and ok
	ok = Assertions.assert_true(bool(f.get("clear_field_18e", false)), "rough clears 18e") and ok
	ok = Assertions.assert_true(bool(f.get("set_dat_0001b868", false)), "player b868") and ok
	ok = Assertions.assert_true(not bool(f.get("set_dat_0001b856", true)), "rough no b856") and ok
	## gentle pitch + neutral attitudes → player b856
	f = FlightMathScript.apply_landing_pitch_followon(0, 0, 0, true, 0, 0)
	ok = Assertions.assert_true(not bool(f.get("rough", true)), "gentle not rough") and ok
	ok = Assertions.assert_true(bool(f.get("set_dat_0001b856", false)), "gentle player b856") and ok
	## e40c(uVar13) abs > 0x200 → rough (0x201 folds to itself, abs=0x201)
	f = FlightMathScript.apply_landing_pitch_followon(0, 0, 0, true, 0x201, 0)
	ok = Assertions.assert_true(bool(f.get("rough", false)), "uVar13 gate rough") and ok
	ok = Assertions.assert_true(not bool(f.get("set_dat_0001b856", true)), "uVar13 rough no b856") and ok
	## e40c(local_28) < -0x100 → rough
	f = FlightMathScript.apply_landing_pitch_followon(0, 0, 0, true, 0, -0x101)
	ok = Assertions.assert_true(bool(f.get("rough", false)), "local_28 gate rough") and ok
	f = FlightMathScript.apply_landing_pitch_followon(0, 0, 0, false, 0, 0)
	ok = Assertions.assert_true(not bool(f.get("set_dat_0001b868", true)), "non-player no b868") and ok
	ok = Assertions.assert_true(not bool(f.get("set_dat_0001b856", true)), "non-player no b856") and ok
	return ok
