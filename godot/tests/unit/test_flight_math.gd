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
	ok = _test_fun_0000e372() and ok
	ok = _test_fun_00001f22() and ok
	ok = _test_grounded_speed_recommit() and ok
	ok = _test_grounded_field_0b_switch() and ok
	ok = _test_lab_0000f47c() and ok
	ok = _test_e792_char_epilogue() and ok
	ok = _test_e792_weapon_19d_branch() and ok
	ok = _test_fun_00012840_spawn_fields() and ok
	ok = _test_fun_00005116_slot_helpers() and ok
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
	## local_2a - attitude_22 = 0x100; e40c keeps it; scale 0x1000 → add 0x100
	var ep: Dictionary = FlightMathScript.apply_lab_0000f47c(
		0x111, 0x200, 0x100, 0x10, 100, 0x1000, false, 0, 0, 0
	)
	ok = Assertions.assert_true(bool(ep.get("clear_field_63f", false)), "clears 63f") and ok
	ok = Assertions.assert_equal(int(ep.get("pos_20", -1)), 0x111, "pos_20=local_28") and ok
	ok = Assertions.assert_equal(int(ep.get("attitude_22", -1)), 0x200, "att22=local_2a") and ok
	ok = Assertions.assert_equal(int(ep.get("field_24", -1)), (0x10 + 0x100) & 0x3FFF, "yaw blend") and ok
	ok = Assertions.assert_equal(int(ep.get("movement_62a", -1)), 100, "62a=speed") and ok
	ok = Assertions.assert_true(not bool(ep.get("wrote_ring", true)), "non-player no ring") and ok
	## player ring: speed 0xE7, scale 0x1000 → (0xE7*0x2000)/0x1ce = 0x1000
	ep = FlightMathScript.apply_lab_0000f47c(
		0, 0, 0, 0, 0xE7, 0x1000, true, 0, 0, 0
	)
	ok = Assertions.assert_true(bool(ep.get("wrote_ring", false)), "player ring") and ok
	ok = Assertions.assert_equal(int(ep.get("ring_value", -1)), 0x1000, "ring = 0x1000") and ok
	ok = Assertions.assert_equal(int(ep.get("dat_0001bc84", -1)), 1, "bc84 advances") and ok
	ok = Assertions.assert_equal(int(ep.get("dat_0001bc80", -1)), 0x1000, "bc80 += ring") and ok
	## clamp +0x1d80 (0x1CE*0x2000/0x1ce = 0x2000 > 0x1d80)
	ep = FlightMathScript.apply_lab_0000f47c(
		0, 0, 0, 0, 0x1CE, 0x1000, true, 0, 0, 0
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

## [RECONSTRUCTED] FUN_00005116 free-slot / fill / world gate (5705–5745).
func _test_fun_00005116_slot_helpers() -> bool:
	var ok := true
	ok = Assertions.assert_equal(
		FlightMathScript.find_05116_free_slot_index([1, 0, 3]), 1, "first free"
	) and ok
	ok = Assertions.assert_equal(
		FlightMathScript.find_05116_free_slot_index([1, 2]), 2, "full → grow idx"
	) and ok
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
