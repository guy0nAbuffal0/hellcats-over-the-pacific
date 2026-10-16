extends RefCounted

## Validates FUN_000044e8-aligned pass order and param_2 pattern in SimCore (deterministic).

const Assertions := preload("res://godot/tests/helpers/assertions.gd")
const SimCoreScript := preload("res://hellcats/core/sim_core.gd")
const EntityStateScript := preload("res://hellcats/core/entity_state.gd")
const EntityTemplateScript := preload("res://hellcats/core/entity_template.gd")
const FlightMathScript := preload("res://hellcats/core/flight_math.gd")

func run() -> bool:
	var ok := true
	ok = _test_pass_order_and_param2() and ok
	ok = _test_fun_0000435a_on_tick_044a4() and ok
	ok = _test_phase_gate_skips_arrays() and ok

	ok = _test_multi_tick_stable_order() and ok
	ok = _test_trace_includes_tick_order() and ok
	ok = _test_rng_draws_and_param2_entity_counts() and ok
	ok = _test_fun_00006fb8_reset() and ok
	ok = _test_fun_00005df8_slot_clear() and ok
	ok = _test_fun_0000528a_branches() and ok
	ok = _test_fun_0000e792_contact_early_out() and ok
	ok = _test_fun_0000e792_local_46_literal_0666() and ok
	ok = _test_fun_0000e792_e42a_from_world_1c() and ok
	ok = _test_fun_0000e792_movement_626_step() and ok
	ok = _test_fun_0000e792_e4a4_linear_drag() and ok
	ok = _test_fun_0000e792_626_reverse_clamp() and ok
	ok = _test_fun_0000e792_reverse_local_48() and ok
	ok = _test_fun_0000e792_field_18e_63e() and ok
	ok = _test_fun_0000e792_stall_ivar25() and ok
	ok = _test_fun_0000e792_position_commit() and ok
	ok = _test_fun_0000e792_landing_63e() and ok
	ok = _test_fun_0000e792_landing_hard_crash() and ok
	ok = _test_fun_0000e792_landing_13452() and ok
	ok = _test_fun_0000e792_landing_gentle_b856() and ok
	ok = _test_fun_0000e792_airborne_speed_recommit() and ok
	ok = _test_fun_0000e792_grounded_speed_recommit() and ok
	ok = _test_fun_0000e792_grounded_field_0b_switch() and ok
	ok = _test_fun_0000e792_lab_0000f47c() and ok
	ok = _test_fun_0000e792_char_epilogue() and ok
	ok = _test_fun_0000e792_weapon_19d_branch() and ok
	ok = _test_fun_00012840_spawn_fixture() and ok
	ok = _test_fun_00005116_pool_scan() and ok
	ok = _test_fun_00016a3a_via_046da() and ok
	ok = _test_fun_000115b0_via_046da() and ok
	ok = _test_fun_00000054_publish_all() and ok
	ok = _test_fun_000016e2_calls_00054() and ok
	ok = _test_fun_00004e6e_kind3() and ok
	ok = _test_fun_00012840_via_05116_pool() and ok
	ok = _test_fun_00019430_via_05116_pool() and ok
	ok = _test_fun_00015d20_via_15bf6() and ok
	ok = _test_fun_0000e792_weapon_676_677_branch() and ok
	ok = _test_fun_0000e792_bvar6_cleanup() and ok
	ok = _test_fun_0000e792_flags685_bit2_tail() and ok
	ok = _test_simcore_uses_overlay_rng() and ok
	return ok

func _test_pass_order_and_param2() -> bool:
	var sim := SimCoreScript.new(0xABCDEF)
	sim.mission_phase_a8 = 1
	sim.mission_flag_ac = 1
	for _i in 4:
		sim.entity_array_1.append(EntityStateScript.new())
		sim.entity_array_2.append(EntityStateScript.new())
		sim.entity_array_3.append(EntityStateScript.new())
		sim.entity_array_4.append(EntityStateScript.new())
	sim.tick()
	var order: Dictionary = sim.get_last_tick_order()
	var passes: Array = order.get("passes", [])
	var ok := Assertions.assert_true(passes.size() == 4, "tick_order: four passes")
	ok = Assertions.assert_true(int(passes[0].get("pass_id", -1)) == 1, "pass 1 id (PASS_DAT_0001D4A4)") and ok
	ok = Assertions.assert_true(int(passes[0].get("param_2", -99)) == 0, "pass 1 param_2 == 0") and ok
	ok = Assertions.assert_true(int(passes[1].get("param_2", -99)) == 0, "pass 2 param_2 == 0") and ok
	ok = Assertions.assert_true(int(passes[2].get("param_2", -99)) == 1, "pass 3 param_2 == 1") and ok
	ok = Assertions.assert_true(int(passes[3].get("param_2", -99)) == 1, "pass 4 param_2 == 1") and ok
	ok = Assertions.assert_true(bool(order.get("arrays_ran", false)), "arrays_ran") and ok
	return ok

## [RECONSTRUCTED] FUN_000044a4 → 0435a + type-5 flags (5079–5091).
func _test_fun_0000435a_on_tick_044a4() -> bool:
	var sim := SimCoreScript.new(0x435A)
	const WORLD := 0xA000
	const ENT := 0xB000
	const TYPEP := 0xB100
	sim.mission_phase_a8 = 1
	sim.mission_flag_ac = 1
	sim.mission_short_b0 = 0
	sim.spawn_0435a_scale_src = 0x1000
	sim.mem_u32[WORLD + 0] = 2
	sim.mem_u32[WORLD + 0x0C] = 0
	sim.mem_u32[WORLD + 4] = 0
	sim.mem_u32[WORLD + 8] = ENT
	sim.mem_u32[ENT + 4] = TYPEP
	sim.mem_u32[TYPEP] = 5
	var e := EntityStateScript.new()
	e.world_obj_ptr = WORLD
	sim.entity_array_1.append(e)
	sim.tick()
	var ok := Assertions.assert_equal(sim._fun_0000435a_calls_this_tick, 1, "0435a×1")
	ok = Assertions.assert_true(bool(sim.last_0435a.get("gate", {}).get("enter", false)), "enter") and ok
	ok = Assertions.assert_equal(int(sim.last_0435a.get("param_2", -1)), 0, "p2=0") and ok
	ok = Assertions.assert_equal(int(sim.mem_u32.get(WORLD + 0x0C, -1)), 0x800, "+0xc half") and ok
	ok = Assertions.assert_true(bool(sim.last_044a4.get("type5", {}).get("applied", false)), "type5") and ok
	ok = Assertions.assert_equal(int(sim.mem_u32.get(WORLD + 4, -1)) & 0x40, 0x40, "flags|0x40") and ok
	sim.mission_short_b0 = 1
	sim.tick()
	ok = Assertions.assert_equal(int(sim.mem_u32.get(WORLD + 4, -1)) & 0x40, 0, "flags cleared") and ok
	sim.entity_array_1.clear()
	sim.entity_array_3.append(e)
	sim.mem_u32[WORLD + 0x0C] = 0
	sim.tick()
	ok = Assertions.assert_equal(int(sim.last_0435a.get("param_2", -1)), 1, "p2=1") and ok
	ok = Assertions.assert_equal(int(sim.mem_u32.get(WORLD + 0x0C, -1)), 0x800, "+0xc again") and ok
	return ok

func _test_phase_gate_skips_arrays() -> bool:
	var sim := SimCoreScript.new(0x1111)
	sim.mission_phase_a8 = 0
	sim.mission_flag_ac = 1
	sim.tick()
	var order: Dictionary = sim.get_last_tick_order()
	var ok := Assertions.assert_true(not bool(order.get("arrays_ran", true)), "phase gate: arrays not run")
	ok = Assertions.assert_true((order.get("passes", []) as Array).is_empty(), "phase gate: no passes") and ok
	return ok

func _test_multi_tick_stable_order() -> bool:
	var sim := SimCoreScript.new(0x2222)
	sim.mission_phase_a8 = 3
	sim.mission_flag_ac = 1
	sim.entity_array_2.append(EntityStateScript.new())
	for _t in 10:
		sim.tick()
		var p: Array = sim.get_last_tick_order().get("passes", []) as Array
		if p.size() != 4:
			print("FAIL multi_tick: expected 4 passes got %d" % p.size())
			return false
		if int(p[2].get("param_2", -1)) != 1:
			print("FAIL multi_tick: pass 3 param_2")
			return false
	print("PASS multi_tick stable order")
	return true

func _test_trace_includes_tick_order() -> bool:
	var sim := SimCoreScript.new(0x3333)
	sim.mission_phase_a8 = 2
	sim.mission_flag_ac = 1
	sim.trace_enabled = true
	sim.entity_array_2.append(EntityStateScript.new())
	sim.tick()
	var rec: Variant = sim.get_last_trace_record()
	var ok := Assertions.assert_true(rec is Dictionary, "trace record exists")
	if not ok:
		return false
	var nested: Variant = (rec as Dictionary).get("tick_order", {})
	ok = Assertions.assert_true(nested is Dictionary and (nested as Dictionary).has("passes"), "trace has tick_order.passes") and ok
	return ok

func _test_rng_draws_and_param2_entity_counts() -> bool:
	var sim := SimCoreScript.new(0x4444)
	sim.mission_phase_a8 = 1
	sim.mission_flag_ac = 1
	var e := EntityStateScript.new()
	e.set_u8_field("flags_685", 0x04)
	sim.entity_array_1.append(e)
	sim.tick()
	var order: Dictionary = sim.get_last_tick_order()
	var draws: int = int(order.get("rng_draws_this_tick", -1))
	var ok := Assertions.assert_true(draws >= 1, "rng_draws_this_tick when flags_685&4")
	var counts: Dictionary = order.get("param_2_entity_updates", {}) as Dictionary
	var n0: int = int(counts.get(0, -1))
	var n1: int = int(counts.get(1, -1))
	ok = Assertions.assert_true(n0 >= 1, "param_2 count for passes 1-2") and ok
	ok = Assertions.assert_true(n1 == 0, "param_2 count 1 only after arrays 3-4") and ok
	sim.entity_array_4.append(EntityStateScript.new())
	sim.tick()
	order = sim.get_last_tick_order()
	counts = order.get("param_2_entity_updates", {}) as Dictionary
	n1 = int(counts.get(1, -1))
	ok = Assertions.assert_true(n1 >= 1, "param_2 count for pass 4") and ok
	return ok

## [RECONSTRUCTED] FUN_00006fb8 after four passes; skipped when phase gate fails.
func _test_fun_00006fb8_reset() -> bool:
	var sim := SimCoreScript.new(0x5555)
	sim.dat_0001d710 = 7
	sim.dat_0001d714 = 7
	sim.dat_0001d718 = 7
	sim.dat_0001d71c = 7
	sim.dat_0001d720 = 7
	sim.dat_0001d724 = 7
	sim.mission_phase_a8 = 0
	sim.mission_flag_ac = 1
	sim.tick()
	var order: Dictionary = sim.get_last_tick_order()
	var ok := Assertions.assert_true(not bool(order.get("fun_00006fb8_ran", true)), "06fb8 skipped when phase gate closed")
	ok = Assertions.assert_true(sim.dat_0001d710 == 7, "06fb8 does not mutate when skipped") and ok
	sim.mission_phase_a8 = 1
	sim.tick()
	order = sim.get_last_tick_order()
	ok = Assertions.assert_true(bool(order.get("fun_00006fb8_ran", false)), "06fb8 runs after arrays") and ok
	var expected: int = SimCoreScript.FUN_00006FB8_RESET_VALUE
	ok = Assertions.assert_true(sim.dat_0001d710 == expected, "DAT_0001d710 reset") and ok
	ok = Assertions.assert_true(sim.dat_0001d714 == expected, "DAT_0001d714 reset") and ok
	ok = Assertions.assert_true(sim.dat_0001d718 == expected, "DAT_0001d718 reset") and ok
	ok = Assertions.assert_true(sim.dat_0001d71c == expected, "DAT_0001d71c reset") and ok
	ok = Assertions.assert_true(sim.dat_0001d720 == expected, "DAT_0001d720 reset") and ok
	ok = Assertions.assert_true(sim.dat_0001d724 == expected, "DAT_0001d724 reset") and ok
	var globals: Dictionary = order.get("fun_00006fb8_globals", {}) as Dictionary
	ok = Assertions.assert_true(int(globals.get("DAT_0001d724", -1)) == expected, "tick_order snapshot DAT_0001d724") and ok
	return ok

## [RECONSTRUCTED] FUN_00005df8 clears seven DAT_0001bc64 slots after FUN_0000528a.
func _test_fun_00005df8_slot_clear() -> bool:
	var sim := SimCoreScript.new(0x6666)
	sim.mission_flag_ac = 1
	sim.mission_phase_a8 = 1
	sim.dat_0001bc64[0] = EntityStateScript.new()
	sim.dat_0001bc64[3] = EntityStateScript.new()
	sim.tick()
	var order: Dictionary = sim.get_last_tick_order()
	var ok := Assertions.assert_true(not bool(order.get("fun_00005df8_ran", true)), "05df8 skipped when flag_ac != 0")
	ok = Assertions.assert_true(sim.dat_0001bc64[0] != null, "slots untouched when 05df8 skipped") and ok
	sim.mission_flag_ac = 0
	sim.mission_phase_a8 = 0
	sim.tick()
	order = sim.get_last_tick_order()
	ok = Assertions.assert_true(bool(order.get("fun_00005df8_ran", false)), "05df8 runs when flag_ac == 0") and ok
	ok = Assertions.assert_true(int(order.get("fun_00005df8_cleared", -1)) == 2, "05df8 cleared two slots") and ok
	ok = Assertions.assert_true(int(order.get("fun_0000528a_calls", -1)) == 2, "0528a called per non-null slot") and ok
	ok = Assertions.assert_true(sim.dat_0001bc64[0] == null, "slot 0 cleared") and ok
	ok = Assertions.assert_true(sim.dat_0001bc64[3] == null, "slot 3 cleared") and ok
	for i in range(7):
		ok = Assertions.assert_true(sim.dat_0001bc64[i] == null, "all seven slots null after 05df8") and ok
	return ok

## [RECONSTRUCTED] FUN_0000528a branches (Pacific Conflict.c:5784–5798).
func _test_fun_0000528a_branches() -> bool:
	var sim := SimCoreScript.new(0x7777)
	sim.dat_0001b838 = 0xABCD
	sim.dat_0001d6fc = 0x1111
	sim.dat_0001b88e = 0
	sim.dat_0001b88c = 10

	var skipped := EntityStateScript.new()
	skipped.set_u8_field("flags_07", 0x02)
	sim._call_0528a(skipped)
	var ok := Assertions.assert_true(sim.last_0528a_path == "skip_flag7", "0528a skip when flags_07&2")
	ok = Assertions.assert_true(sim._fun_000051ec_calls_this_tick == 0, "051ec not called on skip") and ok

	var non_type2 := EntityStateScript.new()
	non_type2.set_u8_field("field_00", 0x01)
	non_type2.set_field("field_04", 0)
	sim._call_0528a(non_type2)
	ok = Assertions.assert_true(sim.last_0528a_path == "call_051ec", "0528a -> 051ec when type != 2") and ok
	ok = Assertions.assert_true(non_type2.get_field("pos_18") == 1000000000, "051ec sets pos_18") and ok
	ok = Assertions.assert_true((non_type2.get_field("field_04") & 0x02) != 0, "051ec ors field_04 with 2") and ok
	ok = Assertions.assert_true(non_type2.get_field("field_3c") == 0, "051ec clears field_3c") and ok

	var type2_alt := EntityStateScript.new()
	type2_alt.set_u8_field("field_00", 0x02)
	type2_alt.set_field("field_24", 0)  # != dat_0001d6fc
	type2_alt.set_field("field_04", 0)
	sim._call_0528a(type2_alt)
	ok = Assertions.assert_true(sim.last_0528a_path == "type02_alt", "0528a type02 alt branch") and ok
	ok = Assertions.assert_true((type2_alt.get_field("field_04") & 0x42) == 0x42, "type02 ors field_04 with 0x42") and ok
	ok = Assertions.assert_true(type2_alt.get_field("field_3c") == 0xABCD, "type02 writes DAT_0001b838 to field_3c") and ok

	## Indirect writes from FUN_000051ec (Pacific Conflict.c:5760, 5775–5777).
	var table_base := 0x5000
	sim.dat_0001d6fc = 0x4000
	sim.mem_u32[sim.dat_0001d6fc + 0x30] = table_base
	sim.mem_u32[table_base + 0x14 + 3 * 0x18] = 0xEE
	var indirect := EntityStateScript.new()
	indirect.set_u8_field("field_00", 0x01)
	indirect.set_u8_field("field_01", 1)
	indirect.set_u8_field("field_02", 3)
	indirect.set_field("entity_data_ptr", 0x9000)
	sim.mem_u32[0x9000] = 0x55
	sim._call_051ec(indirect)
	ok = Assertions.assert_true(
		int(sim.mem_u32.get(table_base + 0x14 + 3 * 0x18, -1)) == 0,
		"051ec clears table slot at +0x14+field_02*0x18"
	) and ok
	ok = Assertions.assert_true(int(sim.mem_u32.get(0x9000, -1)) == 0, "051ec **(entity+8)=0") and ok
	return ok

## [RECONSTRUCTED] FUN_0000e792 contact early-out (Pacific Conflict.c:14083–14104).
func _test_fun_0000e792_contact_early_out() -> bool:
	var sim := SimCoreScript.new(0x8888)
	sim.mission_phase_a8 = 1
	sim.mission_flag_ac = 1
	const WORLD_OBJ := 0x7000
	sim.mem_u32[WORLD_OBJ + 0x1c] = 100

	var below := EntityStateScript.new()
	below.set_u16_field("status_1a1", 0x08)
	below.set_field("pos_2e", 10)
	below.world_obj_ptr = WORLD_OBJ
	below.set_u8_field("flags_685", 0x04)
	below.set_u8_field("movement_669", 1)
	below.set_s16_field("movement_61e", 0)
	below.set_s16_field("movement_61a", 0)
	below.set_s16_field("field_24", 0)
	below.set_u16_field("pos_20", 0)
	sim.entity_array_1.append(below)
	sim.tick()
	var ok := Assertions.assert_true(
		_as_s32(below.get_field("position_velocity_c")) == -0x16,
		"contact below surface sets pvc to -0x16"
	)
	ok = Assertions.assert_true(below.get_u8_field("movement_669") == 0, "contact clears movement_669") and ok
	ok = Assertions.assert_equal(
		int(sim.get_last_tick_order().get("rng_draws_this_tick", -1)), 2,
		"contact early-out: two 11544 draws (skips flags_685 slice)"
	) and ok
	var m61e: int = below.get_s16_field("movement_61e")
	ok = Assertions.assert_true(m61e >= 0 and m61e <= 0x7F, "61e = rng&0x7f") and ok
	ok = Assertions.assert_equal(below.get_s16_field("field_24") & 0x3FFF, m61e & 0x3FFF, "24←61e") and ok
	var m61a: int = below.get_s16_field("movement_61a")
	ok = Assertions.assert_true(m61a <= 0 and m61a >= -0x7F, "61a = -(rng&0x7f)") and ok
	ok = Assertions.assert_equal(below.get_u16_field("pos_20") & 0x3FFF, m61a & 0x3FFF, "20←61a") and ok

	var player := EntityStateScript.new()
	player.set_u16_field("status_1a1", 0x08)
	player.set_field("pos_2e", 200)
	player.world_obj_ptr = WORLD_OBJ
	player.set_u8_field("field_0b", 0x10)
	var tmpl = EntityTemplateScript.new()
	tmpl.set_s16_field("field_40", 0)
	player.external_template = tmpl
	sim.entity_array_1.clear()
	sim.entity_array_2.append(player)
	sim.dat_0001b850 = 0
	sim.tick()
	ok = Assertions.assert_true((player.get_u16_field("status_1a1") & 0x1000) != 0, "contact ORs status 0x1000") and ok
	ok = Assertions.assert_true(sim.dat_0001b850 == 1, "player contact sets DAT_0001b850") and ok
	ok = Assertions.assert_true(
		_as_s32(player.get_field("position_velocity_c")) == 100,
		"contact pvc = pos_2e+adj - *(world+0x1c) (200+0-100)"
	) and ok
	return ok

func _as_s32(value: int) -> int:
	var v: int = value & 0xFFFFFFFF
	return v - 0x1_0000_0000 if v >= 0x8000_0000 else v

## [RECONSTRUCTED] local_46 uses literal 0x666 (Pacific Conflict.c:14183), not movement_666.
func _test_fun_0000e792_local_46_literal_0666() -> bool:
	var sim := SimCoreScript.new(0x4242)
	sim.mission_phase_a8 = 1
	sim.mission_flag_ac = 1
	const WORLD_OBJ := 0x7100
	sim.mem_u32[WORLD_OBJ + 0x1c] = 0
	var player := EntityStateScript.new()
	var tmpl = EntityTemplateScript.new()
	tmpl.set_field("field_38", 1000)
	tmpl.set_s16_field("field_1e", 0x7FFF)
	player.external_template = tmpl
	player.world_obj_ptr = WORLD_OBJ
	## Gate on: flags_685 without 0x40, status clear of 0x300, weapon count non-zero.
	player.set_u8_field("flags_685", 0)
	player.set_u16_field("status_1a1", 0)
	player.set_s8_field("weapon_count_67d", 1)
	player.set_s8_field("field_19a", 9)
	player.set_s16_field("movement_666", 0)
	player.set_field("pos_1c", 0x00070000)
	player.set_field("pos_2e", 0)
	player.set_field("movement_62a", 0)
	player.set_field("movement_66e", 0)
	player.set_u8_field("movement_669", 1)
	sim.entity_array_2.append(player)
	sim.tick()
	var moved: int = _as_s32(player.get_field("movement_66e"))
	var ok := Assertions.assert_true(
		moved != 0,
		"local_46 path moves 66e even when movement_666 field is 0 (literal 0x666)"
	)
	return ok

## [RECONSTRUCTED] e42a reads *(world+0x1c); e468 stashed separately (asm 0xE9BE–0xE9EA).
func _test_fun_0000e792_e42a_from_world_1c() -> bool:
	var sim := SimCoreScript.new(0x5151)
	sim.mission_phase_a8 = 1
	sim.mission_flag_ac = 1
	const WORLD_OBJ := 0x7200
	## World surface 0 → e42a(0); entity pos_1c would be a different e42a input if wrongly used.
	sim.mem_u32[WORLD_OBJ + 0x1c] = 0
	var player := EntityStateScript.new()
	var tmpl = EntityTemplateScript.new()
	tmpl.set_field("field_38", 1000)
	tmpl.set_s16_field("field_1e", 0x7FFF)
	player.external_template = tmpl
	player.world_obj_ptr = WORLD_OBJ
	player.set_u8_field("flags_685", 0)
	player.set_u16_field("status_1a1", 0)
	player.set_s8_field("weapon_count_67d", 1)
	player.set_s8_field("field_19a", 9)
	player.set_field("pos_1c", 0x00010000)
	player.set_field("pos_2e", 0x100)
	player.set_field("movement_62a", 0)
	player.set_field("movement_66e", 0)
	player.set_u8_field("movement_669", 1)
	sim.entity_array_2.append(player)
	sim.tick()
	var ok := Assertions.assert_equal(sim.last_e42a_input_u32, 0, "e42a input is world+0x1c not pos_1c")
	## e468(0 - 0x100, e42a(0)) with e42a(0)=-15264 → param_1 < 0x200 adjusts
	var expect_e468: int = FlightMathScript.fun_0000e468(-0x100, -15264)
	ok = Assertions.assert_equal(sim.last_e468_out, expect_e468, "e468(surface-pos_2e, e42a) stashed") and ok
	ok = Assertions.assert_true(
		_as_s32(player.get_field("movement_66e")) != 0,
		"local_46 still uses raw e42a (world 0), not discarded when pos_1c differs"
	) and ok
	return ok

## [RECONSTRUCTED] 0x626 reverse clamps before e4a4 (14305–14319).
func _test_fun_0000e792_626_reverse_clamp() -> bool:
	var sim := SimCoreScript.new(0x6261)
	sim.mission_phase_a8 = 1
	sim.mission_flag_ac = 1
	var e := EntityStateScript.new()
	var tmpl = EntityTemplateScript.new()
	tmpl.set_s16_field("field_34", 0x200)
	tmpl.set_s16_field("field_36", 0x600)
	tmpl.set_s16_field("field_42", 0x200)
	tmpl.set_s16_field("field_46", 0x100)
	tmpl.set_s16_field("field_48", 0x800)
	e.external_template = tmpl
	e.set_u8_field("field_63e", 1)
	e.set_s8_field("direction_char_679", 0x2D)  # '-'
	## 626 step: leave high; clamp should cut to 0x200 before e4a4.
	e.set_s16_field("movement_626", 0x500)
	e.set_s16_field("movement_662", 0x500)
	e.set_field("movement_62a", 0x900 << 2)
	e.set_s8_field("weapon_count_67d", 1)
	sim.entity_array_1.append(e)
	sim.tick()
	## After clamp 626=0x200; e4a4 low-speed with tpl_34=0x200, tpl_28=0 → value=0.
	var ok := Assertions.assert_equal(e.get_s16_field("movement_626"), 0x200, "SimCore reverse-clamps 626")
	ok = Assertions.assert_equal(e.get_s16_field("movement_63a"), 0, "e4a4 sees clamped 626") and ok
	## Gate off: no clamp
	var e2 := EntityStateScript.new()
	e2.external_template = tmpl
	e2.set_u8_field("field_63e", 0)
	e2.set_s8_field("direction_char_679", 0x2D)
	e2.set_s16_field("movement_626", 0x500)
	e2.set_s16_field("movement_662", 0x500)
	e2.set_field("movement_62a", 0x900 << 2)
	e2.set_s8_field("weapon_count_67d", 1)
	sim.entity_array_1.clear()
	sim.entity_array_1.append(e2)
	sim.tick()
	ok = Assertions.assert_true(
		e2.get_s16_field("movement_626") != 0x200,
		"no reverse clamp when field_63e clear"
	) and ok
	return ok

## [RECONSTRUCTED] reverse local_48 + DAT_0001b858 + attitude_22 (14321–14342).
func _test_fun_0000e792_reverse_local_48() -> bool:
	var sim := SimCoreScript.new(0x4848)
	sim.mission_phase_a8 = 1
	sim.mission_flag_ac = 1
	sim.dat_0001b858 = 1
	const WORLD_OBJ := 0x7400
	sim.mem_u32[WORLD_OBJ + 0x1c] = 0
	var player := EntityStateScript.new()
	var tmpl = EntityTemplateScript.new()
	tmpl.set_field("field_38", 1000)
	tmpl.set_s16_field("field_1e", 0x7FFF)
	tmpl.set_s16_field("field_34", 0x200)
	tmpl.set_s16_field("field_36", 0x600)
	tmpl.set_s16_field("field_42", 0x700)
	tmpl.set_s16_field("field_48", 0x100)
	player.external_template = tmpl
	player.world_obj_ptr = WORLD_OBJ
	player.set_u8_field("field_63e", 1)
	player.set_s8_field("direction_char_679", 0x2D)
	player.set_u8_field("flags_685", 0)
	player.set_u16_field("status_1a1", 0)
	player.set_s8_field("weapon_count_67d", 1)
	player.set_s8_field("field_19a", 9)
	player.set_s16_field("movement_666", 0x200)
	player.set_u16_field("attitude_22", 0x10)
	## Keep grounded so 01f22 airborne path does not overwrite attitude_22.
	player.set_field("pos_2e", 50000)
	player.set_field("movement_62a", 0x100 << 2)
	player.set_s16_field("movement_626", 0x100)
	player.set_s16_field("movement_662", 0x100)
	player.set_u8_field("movement_669", 1)
	sim.entity_array_2.append(player)
	sim.tick()
	var ok := Assertions.assert_equal(sim.dat_0001b858, 0, "designated reverse clears DAT_0001b858")
	ok = Assertions.assert_true(sim.last_reverse_local_48 != 0 or sim.last_local_46 != 0 or sim.last_local_42 != 0, "reverse locals populated") and ok
	var expect_48: int = FlightMathScript.compute_reverse_local_48(
		sim.last_local_46, sim.last_local_42, 0x200
	)
	ok = Assertions.assert_equal(sim.last_reverse_local_48, expect_48, "SimCore last_reverse_local_48") and ok
	ok = Assertions.assert_equal(player.get_u8_field("field_63e"), 1, "stays grounded") and ok
	ok = Assertions.assert_equal(
		player.get_u16_field("attitude_22"),
		((expect_48 & 0x3FFF) + 0x10) & 0x3FFF,
		"attitude_22 updated from local_48"
	) and ok
	return ok

## [RECONSTRUCTED] post-thrust 0x63e → field_18e (14384–14421).
func _test_fun_0000e792_field_18e_63e() -> bool:
	var sim := SimCoreScript.new(0x18E0)
	sim.mission_phase_a8 = 1
	sim.mission_flag_ac = 1
	const WORLD_OBJ := 0x7500
	sim.mem_u32[WORLD_OBJ + 0x1c] = 0
	var e := EntityStateScript.new()
	var tmpl = EntityTemplateScript.new()
	tmpl.set_s16_field("field_34", 0x200)
	tmpl.set_s16_field("field_36", 0x600)
	tmpl.set_s16_field("field_46", 0x200)
	tmpl.set_s16_field("field_2e", 0x10)
	tmpl.set_s16_field("field_30", 0x20)
	tmpl.set_s16_field("field_22", 0)
	tmpl.set_s16_field("field_24", 0)
	e.external_template = tmpl
	e.world_obj_ptr = WORLD_OBJ
	e.set_u8_field("field_63e", 1)
	e.set_s8_field("direction_char_679", 0x2D)
	e.set_s16_field("movement_626", 0x100)
	e.set_s16_field("movement_662", 0x100)
	e.set_field("movement_62a", 0x100 << 2)
	e.set_s8_field("weapon_count_67d", 1)
	e.set_u16_field("field_18e", 0)
	sim.entity_array_1.append(e)
	sim.tick()
	var ok := Assertions.assert_equal(sim.last_63e_thrust_delta, 0x10, "SimCore 63e thrust_delta")
	ok = Assertions.assert_equal(e.get_u16_field("field_18e"), 0x5B0, "SimCore writes field_18e") and ok
	return ok

## [RECONSTRUCTED] stall when iVar25<1 (14422–14433).
func _test_fun_0000e792_stall_ivar25() -> bool:
	var sim := SimCoreScript.new(0x1900)
	sim.mission_phase_a8 = 1
	sim.mission_flag_ac = 1
	sim.dat_0001b868 = 1
	const WORLD_OBJ := 0x7600
	sim.mem_u32[WORLD_OBJ + 0x1c] = 0
	var player := EntityStateScript.new()
	var tmpl = EntityTemplateScript.new()
	tmpl.set_s16_field("field_34", 0x200)
	tmpl.set_s16_field("field_36", 0x600)
	tmpl.set_field("field_38", 0)
	tmpl.set_s16_field("field_22", 0)
	tmpl.set_s16_field("field_24", 0)
	player.external_template = tmpl
	player.world_obj_ptr = WORLD_OBJ
	## Low speed + field_190==1 penalty → stall.
	player.set_s16_field("movement_626", 0)
	player.set_s16_field("movement_662", 0)
	player.set_field("movement_62a", 0x40)
	player.set_u8_field("field_190", 1)
	player.set_s8_field("weapon_count_67d", 1)
	sim.entity_array_2.append(player)
	sim.tick()
	var ok := Assertions.assert_true(sim.last_stalled_this_tick, "SimCore stalled this tick")
	## Stall sets field_190=2 then airborne path clears it (14492–14494).
	ok = Assertions.assert_equal(player.get_u8_field("field_190"), 0, "field_190 cleared after stall-2") and ok
	ok = Assertions.assert_true(sim.last_airborne_speed_recommit, "airborne e372 after stall") and ok
	ok = Assertions.assert_equal(sim.dat_0001b868, 2, "DAT_0001b868 → 2 on player stall") and ok
	return ok

## [RECONSTRUCTED] 028dc + >>6 position commit with identity matrix stub (14441–14445).
func _test_fun_0000e792_position_commit() -> bool:
	var sim := SimCoreScript.new(0x28DC)
	sim.mission_phase_a8 = 1
	sim.mission_flag_ac = 1
	const WORLD_OBJ := 0x7700
	sim.mem_u32[WORLD_OBJ + 0x1c] = 0
	var e := EntityStateScript.new()
	var tmpl = EntityTemplateScript.new()
	tmpl.set_s16_field("field_34", 0x200)
	tmpl.set_s16_field("field_36", 0x600)
	tmpl.set_s16_field("field_22", 0)
	tmpl.set_s16_field("field_24", 0)
	e.external_template = tmpl
	e.world_obj_ptr = WORLD_OBJ
	e.set_s16_field("movement_626", 0x100)
	e.set_s16_field("movement_662", 0x100)
	e.set_field("movement_62a", 0x800 << 2)
	e.set_s8_field("weapon_count_67d", 1)
	e.set_s16_field("field_18c", 0)
	sim.entity_array_1.append(e)
	sim.tick()
	var ok := Assertions.assert_equal(e.get_s16_field("field_18c"), -91, "SimCore resets field_18c to 0xffa5")
	ok = Assertions.assert_true(sim.last_pos_commit.has("param_1_3"), "SimCore last_pos_commit populated") and ok
	ok = Assertions.assert_equal(
		e.get_field("ptr_10"),
		int(sim.last_pos_commit.get("param_1_4", -1)),
		"param_1[4] written to ptr_10"
	) and ok
	return ok

## [RECONSTRUCTED] field_63e==0 touchdown after position commit (14446–14449).
func _test_fun_0000e792_landing_63e() -> bool:
	var sim := SimCoreScript.new(0x63E0)
	sim.mission_phase_a8 = 1
	sim.mission_flag_ac = 1
	const WORLD_OBJ := 0x7800
	sim.mem_u32[WORLD_OBJ + 0x1c] = 1000
	var e := EntityStateScript.new()
	var tmpl = EntityTemplateScript.new()
	tmpl.set_s16_field("field_34", 0x200)
	tmpl.set_s16_field("field_36", 0x600)
	tmpl.set_s16_field("field_40", 50)
	tmpl.set_s16_field("field_22", 0)
	tmpl.set_s16_field("field_24", 0)
	e.external_template = tmpl
	e.world_obj_ptr = WORLD_OBJ
	e.set_u8_field("field_63e", 0)
	e.set_s8_field("direction_char_679", 0x2D)  # adj = field_40 = 50 → iVar23=950
	e.set_field("pos_2e", 900)
	e.set_s16_field("movement_626", 0)
	e.set_s16_field("movement_662", 0)
	e.set_field("movement_62a", 0x100 << 2)
	e.set_s8_field("weapon_count_67d", 1)
	## Identity 028dc: param_1[3] = field_18c >> 6 = -60
	e.set_s16_field("field_18c", -3840)
	sim.entity_array_1.append(e)
	sim.tick()
	var ok := Assertions.assert_true(sim.last_63e_landing_applied, "SimCore landing applied")
	ok = Assertions.assert_equal(e.get_u8_field("field_63e"), 1, "landing sets field_63e") and ok
	ok = Assertions.assert_equal(
		_as_s32(e.get_field("position_velocity_c")),
		-50,
		"landing pvc = iVar23 - surface"
	) and ok
	return ok

## [RECONSTRUCTED] airborne e372 → movement_62a; clear field_190==2 (14486–14495, 14613).
func _test_fun_0000e792_airborne_speed_recommit() -> bool:
	var sim := SimCoreScript.new(0xE372)
	sim.mission_phase_a8 = 1
	sim.mission_flag_ac = 1
	const WORLD_OBJ := 0x7B00
	sim.mem_u32[WORLD_OBJ + 0x1c] = 1000
	var e := EntityStateScript.new()
	var tmpl = EntityTemplateScript.new()
	tmpl.set_s16_field("field_34", 0x200)
	tmpl.set_s16_field("field_36", 0x600)
	tmpl.set_s16_field("field_40", 0)
	tmpl.set_s16_field("field_22", 0)
	tmpl.set_s16_field("field_24", 0)
	e.external_template = tmpl
	e.world_obj_ptr = WORLD_OBJ
	e.set_u8_field("field_63e", 0)
	e.set_field("pos_2e", 5000)
	e.set_u8_field("field_190", 2)
	e.set_s16_field("movement_626", 0)
	e.set_s16_field("movement_662", 0)
	e.set_s16_field("movement_666", 0)
	e.set_field("movement_62a", 0x100 << 2)
	e.set_s8_field("weapon_count_67d", 1)
	e.set_s16_field("field_18c", 0)
	sim.entity_array_1.append(e)
	sim.tick()
	var ok := Assertions.assert_true(sim.last_airborne_speed_recommit, "airborne recommit ran")
	ok = Assertions.assert_true(not sim.last_63e_landing_applied, "no landing") and ok
	ok = Assertions.assert_equal(e.get_u8_field("field_190"), 0, "stall-2 cleared") and ok
	var le: int = int(sim.last_pos_commit.get("local_e", 0))
	var la: int = int(sim.last_pos_commit.get("local_a", 0))
	var l6: int = int(sim.last_pos_commit.get("local_6", 0))
	var expect: int = FlightMathScript.fun_0000e372(le * le + la * la + l6 * l6)
	ok = Assertions.assert_equal(_as_s32(e.get_field("movement_62a")), expect, "62a = e372(speed_sq)") and ok
	return ok

## [RECONSTRUCTED] grounded e372(e²+z²) + pvc reset (14497–14603).
func _test_fun_0000e792_grounded_speed_recommit() -> bool:
	var sim := SimCoreScript.new(0x63E3)
	sim.mission_phase_a8 = 1
	sim.mission_flag_ac = 1
	const WORLD_OBJ := 0x7C00
	sim.mem_u32[WORLD_OBJ + 0x1c] = 1000
	var e := EntityStateScript.new()
	var tmpl = EntityTemplateScript.new()
	tmpl.set_s16_field("field_34", 0x200)
	tmpl.set_s16_field("field_36", 0x600)
	tmpl.set_s16_field("field_40", 50)
	tmpl.set_s16_field("field_22", 0)
	tmpl.set_s16_field("field_24", 0)
	e.external_template = tmpl
	e.world_obj_ptr = WORLD_OBJ
	e.set_u8_field("field_63e", 1)
	e.set_u8_field("field_63f", 1)
	e.set_u8_field("field_190", 0)
	e.set_field("pos_2e", 50000)
	e.set_s16_field("movement_626", 0)
	e.set_s16_field("movement_662", 0)
	e.set_field("movement_62a", 0x100 << 2)
	e.set_s8_field("weapon_count_67d", 1)
	e.set_s16_field("field_18c", 0)
	sim.entity_array_1.append(e)
	sim.tick()
	var ok := Assertions.assert_true(sim.last_grounded_speed_recommit, "grounded recommit")
	ok = Assertions.assert_true(not sim.last_airborne_speed_recommit, "not airborne path") and ok
	ok = Assertions.assert_equal(e.get_u8_field("field_190"), 1, "prestall field_190") and ok
	var le: int = int(sim.last_pos_commit.get("local_e", 0))
	var l6: int = int(sim.last_pos_commit.get("local_6", 0))
	var expect: int = FlightMathScript.fun_0000e372(le * le + l6 * l6)
	ok = Assertions.assert_equal(_as_s32(e.get_field("movement_62a")), expect, "62a = e372(e²+z²)") and ok
	## field_40=50 with direction!='-' → half toward zero = 25; iVar23=50025
	ok = Assertions.assert_equal(_as_s32(e.get_field("position_velocity_c")), 50025 - 1000, "pvc = iVar23-surface") and ok
	return ok

## [RECONSTRUCTED] grounded field_0b='P' → clear b856 + bVar6 blocks prestall (14585–14593).
func _test_fun_0000e792_grounded_field_0b_switch() -> bool:
	var sim := SimCoreScript.new(0x63E4)
	sim.mission_phase_a8 = 1
	sim.mission_flag_ac = 1
	sim.dat_0001b856 = 1
	const WORLD_OBJ := 0x7C10
	sim.mem_u32[WORLD_OBJ + 0x1c] = 1000
	var e := EntityStateScript.new()
	var tmpl = EntityTemplateScript.new()
	tmpl.set_s16_field("field_34", 0x200)
	tmpl.set_s16_field("field_36", 0x600)
	tmpl.set_s16_field("field_40", 0)
	tmpl.set_s16_field("field_22", 0)
	tmpl.set_s16_field("field_24", 0)
	e.external_template = tmpl
	e.world_obj_ptr = WORLD_OBJ
	e.set_u8_field("field_63e", 1)
	e.set_u8_field("field_63f", 1)
	e.set_u8_field("field_190", 0)
	e.set_u8_field("field_0b", 0x50)  # 'P'
	e.set_s8_field("direction_char_679", 0)  # abs!=0x2d → bVar6
	e.set_field("pos_2e", 50000)
	e.set_s16_field("movement_626", 0)
	e.set_s16_field("movement_662", 0)
	e.set_field("movement_62a", 0x100 << 2)
	e.set_s8_field("weapon_count_67d", 1)
	e.set_s16_field("field_18c", 0)
	sim.entity_array_2.append(e)
	sim.tick()
	var ok := Assertions.assert_true(sim.last_grounded_speed_recommit, "grounded recommit")
	ok = Assertions.assert_true(sim.last_grounded_b_var6, "P sets bVar6") and ok
	ok = Assertions.assert_equal(e.get_u8_field("field_190"), 0, "bVar6 blocks prestall") and ok
	ok = Assertions.assert_equal(sim.dat_0001b856, 0, "P clears player b856") and ok
	ok = Assertions.assert_true(not sim.last_grounded_field_0b_early_return, "P not early") and ok
	## 0x10 + 679!=0 → status|0x1400 early; 62a unchanged
	var e2 := EntityStateScript.new()
	e2.external_template = tmpl
	e2.world_obj_ptr = WORLD_OBJ
	e2.set_u8_field("field_63e", 1)
	e2.set_u8_field("field_0b", 0x10)
	e2.set_s8_field("direction_char_679", 1)
	e2.set_field("pos_2e", 50000)
	e2.set_u16_field("status_1a1", 0)
	e2.set_s16_field("movement_626", 0)
	e2.set_s16_field("movement_662", 0)
	e2.set_field("movement_62a", 0x55AA)
	e2.set_s8_field("weapon_count_67d", 1)
	e2.set_s16_field("field_18c", 0)
	sim.entity_array_1.clear()
	sim.entity_array_2.clear()
	sim.entity_array_1.append(e2)
	sim.tick()
	ok = Assertions.assert_true(sim.last_grounded_field_0b_early_return, "0x10 early return") and ok
	ok = Assertions.assert_equal(e2.get_u16_field("status_1a1") & 0x1400, 0x1400, "status|0x1400") and ok
	ok = Assertions.assert_equal(_as_s32(e2.get_field("movement_62a")), 0x55AA, "early skips 62a write") and ok
	## '@' + player + b856 → DAT_0001b854=1 (14537–14540)
	var e3 := EntityStateScript.new()
	e3.external_template = tmpl
	e3.world_obj_ptr = WORLD_OBJ
	e3.set_u8_field("field_63e", 1)
	e3.set_u8_field("field_0b", 0x40)  # '@'
	e3.set_s8_field("direction_char_679", 0x2D)
	e3.set_field("pos_2e", 50000)
	e3.set_s16_field("movement_626", 0)
	e3.set_s16_field("movement_662", 0)
	e3.set_field("movement_62a", 0x100 << 2)
	e3.set_s8_field("weapon_count_67d", 1)
	e3.set_s16_field("field_18c", 0)
	sim.dat_0001b856 = 1
	sim.dat_0001b854 = 0
	sim.entity_array_1.clear()
	sim.entity_array_2.clear()
	sim.entity_array_2.append(e3)
	sim.tick()
	ok = Assertions.assert_equal(sim.dat_0001b854, 1, "@ sets b854") and ok
	ok = Assertions.assert_equal(sim.dat_0001b856, 0, "@ clears b856") and ok
	## 0x10 soft writes uVar13 from FUN_00011564 (14559–14569)
	var e4 := EntityStateScript.new()
	e4.external_template = tmpl
	e4.world_obj_ptr = WORLD_OBJ
	e4.set_u8_field("field_63e", 1)
	e4.set_u8_field("field_0b", 0x10)
	e4.set_s8_field("direction_char_679", 0)
	e4.set_field("pos_2e", 50000)
	e4.set_u16_field("status_1a1", 0)
	e4.set_s16_field("movement_626", 0)
	e4.set_s16_field("movement_662", 0)
	e4.set_field("movement_62a", 0x100 << 2)
	e4.set_s8_field("weapon_count_67d", 1)
	e4.set_s16_field("field_18c", 0)
	sim.last_landing_u_var13 = 0
	sim.entity_array_1.clear()
	sim.entity_array_2.clear()
	sim.entity_array_1.append(e4)
	sim.tick()
	ok = Assertions.assert_true(not sim.last_grounded_field_0b_early_return, "0x10 soft no early") and ok
	ok = Assertions.assert_equal(e4.get_u16_field("status_1a1") & 0x1000, 0x1000, "soft|0x1000") and ok
	## Counter resets each tick; soft 0x10 path must draw at least once.
	ok = Assertions.assert_true(sim._rng_draws_this_tick >= 1, "soft consumes 11564") and ok
	return ok

## [RECONSTRUCTED] LAB_0000f47c clears 63f, blends field_24, player ring (14606–14629).
func _test_fun_0000e792_lab_0000f47c() -> bool:
	var sim := SimCoreScript.new(0xF47C)
	sim.mission_phase_a8 = 1
	sim.mission_flag_ac = 1
	const WORLD_OBJ := 0x7C20
	sim.mem_u32[WORLD_OBJ + 0x1c] = 1000
	var e := EntityStateScript.new()
	var tmpl = EntityTemplateScript.new()
	tmpl.set_s16_field("field_34", 0x200)
	tmpl.set_s16_field("field_36", 0x600)
	tmpl.set_s16_field("field_40", 0)
	tmpl.set_s16_field("field_22", 0)
	tmpl.set_s16_field("field_24", 0)
	e.external_template = tmpl
	e.world_obj_ptr = WORLD_OBJ
	e.set_u8_field("field_63e", 1)
	e.set_u8_field("field_63f", 1)
	e.set_u8_field("field_190", 0)
	e.set_u8_field("field_0b", 0)
	e.set_s8_field("direction_char_679", 0x2D)
	e.set_field("pos_2e", 50000)
	e.set_u16_field("pos_20", 0x55)
	e.set_u16_field("attitude_22", 0x100)
	e.set_s16_field("field_24", 0)
	e.set_s16_field("movement_626", 0)
	e.set_s16_field("movement_662", 0)
	e.set_field("movement_62a", 0x1CE)
	e.set_s8_field("weapon_count_67d", 1)
	e.set_s16_field("field_18c", 0)
	## Seed yaw inputs so compute_landing_u_var13 → 0x20 (666=0, field_24=0x20).
	e.set_s16_field("movement_666", 0)
	e.set_s16_field("field_24", 0x20)
	sim.entity_array_2.append(e)
	sim.tick()
	var ok := Assertions.assert_true(sim.last_f47c_applied, "f47c applied")
	ok = Assertions.assert_equal(e.get_u8_field("field_63f"), 0, "clears 63f") and ok
	## grounded: local_2a==att22 → delta 0 → field_24 = uVar13 from this tick
	ok = Assertions.assert_equal(e.get_s16_field("field_24"), sim.last_landing_u_var13 & 0x3FFF, "yaw=uVar13") and ok
	ok = Assertions.assert_equal(sim.last_landing_u_var13 & 0x3FFF, 0x20, "uVar13 seeded") and ok
	ok = Assertions.assert_equal(e.get_u16_field("pos_20"), sim.last_grounded_local_28, "pos_20 from local_28") and ok
	ok = Assertions.assert_equal(sim.dat_0001bc84, 1, "player ring index") and ok
	ok = Assertions.assert_true(sim.last_f47c_ring_value != 0 or _as_s32(e.get_field("movement_62a")) == 0, "ring from speed") and ok
	## 0x10 early return skips f47c
	var e2 := EntityStateScript.new()
	e2.external_template = tmpl
	e2.world_obj_ptr = WORLD_OBJ
	e2.set_u8_field("field_63e", 1)
	e2.set_u8_field("field_63f", 1)
	e2.set_u8_field("field_0b", 0x10)
	e2.set_s8_field("direction_char_679", 1)
	e2.set_field("pos_2e", 50000)
	e2.set_u16_field("status_1a1", 0)
	e2.set_s16_field("movement_626", 0)
	e2.set_s16_field("movement_662", 0)
	e2.set_field("movement_62a", 0x55AA)
	e2.set_s8_field("weapon_count_67d", 1)
	e2.set_s16_field("field_18c", 0)
	sim.entity_array_1.clear()
	sim.entity_array_2.clear()
	sim.entity_array_1.append(e2)
	sim.tick()
	ok = Assertions.assert_true(sim.last_grounded_field_0b_early_return, "early skips f47c gate") and ok
	ok = Assertions.assert_true(not sim.last_f47c_applied, "f47c not applied on early") and ok
	ok = Assertions.assert_equal(e2.get_u8_field("field_63f"), 1, "63f uncleared on early") and ok
	return ok

## [RECONSTRUCTED] 67b/679 char epilogue after f47c (14631–14647).
func _test_fun_0000e792_char_epilogue() -> bool:
	var sim := SimCoreScript.new(0x6791)
	sim.mission_phase_a8 = 1
	sim.mission_flag_ac = 1
	const WORLD_OBJ := 0x7C30
	sim.mem_u32[WORLD_OBJ + 0x1c] = 1000
	var e := EntityStateScript.new()
	var tmpl = EntityTemplateScript.new()
	tmpl.set_s16_field("field_34", 0x200)
	tmpl.set_s16_field("field_36", 0x600)
	tmpl.set_s16_field("field_40", 0)
	tmpl.set_s16_field("field_22", 0)
	tmpl.set_s16_field("field_24", 0)
	e.external_template = tmpl
	e.world_obj_ptr = WORLD_OBJ
	e.set_u8_field("field_63e", 1)
	e.set_u8_field("field_0b", 0)
	e.set_s8_field("field_67b", 3)
	e.set_s8_field("direction_char_679", 5)
	e.set_u8_field("field_67a", 0)
	e.set_u8_field("flags_685", 0)
	e.set_u16_field("status_1a1", 0x2000)
	e.set_field("pos_2e", 50000)
	e.set_s16_field("movement_626", 0)
	e.set_s16_field("movement_662", 0)
	e.set_field("movement_62a", 0x100 << 2)
	e.set_s8_field("weapon_count_67d", 1)
	e.set_s16_field("field_18c", 0)
	sim.entity_array_1.append(e)
	sim.tick()
	var ok := Assertions.assert_true(sim.last_f47c_applied, "f47c before chars")
	ok = Assertions.assert_true(sim.last_char_epilogue_bumped_67b, "67b bumped") and ok
	ok = Assertions.assert_true(sim.last_char_epilogue_bumped_679, "679 bumped") and ok
	ok = Assertions.assert_equal(e.get_s8_field("field_67b"), 4, "67b 3→4") and ok
	ok = Assertions.assert_equal(e.get_s8_field("direction_char_679"), 6, "679 5→6") and ok
	ok = Assertions.assert_equal(e.get_u8_field("field_67a") & 2, 2, "67a|=2") and ok
	ok = Assertions.assert_equal(e.get_u16_field("status_1a1") & 0x2000, 0, "cleared 0x2000") and ok
	## early 0x10 skips char epilogue
	var e2 := EntityStateScript.new()
	e2.external_template = tmpl
	e2.world_obj_ptr = WORLD_OBJ
	e2.set_u8_field("field_63e", 1)
	e2.set_u8_field("field_0b", 0x10)
	e2.set_s8_field("direction_char_679", 1)
	e2.set_s8_field("field_67b", 3)
	e2.set_field("pos_2e", 50000)
	e2.set_u16_field("status_1a1", 0)
	e2.set_s16_field("movement_626", 0)
	e2.set_s16_field("movement_662", 0)
	e2.set_field("movement_62a", 0x55AA)
	e2.set_s8_field("weapon_count_67d", 1)
	e2.set_s16_field("field_18c", 0)
	sim.entity_array_1.clear()
	sim.entity_array_1.append(e2)
	sim.tick()
	ok = Assertions.assert_true(not sim.last_char_epilogue_bumped_67b, "early skips 67b") and ok
	ok = Assertions.assert_equal(e2.get_s8_field("field_67b"), 3, "67b unchanged on early") and ok
	return ok

## [RECONSTRUCTED] field_19d==1 fire + stub FUN_00012840 (14648–14671).
func _test_fun_0000e792_weapon_19d_branch() -> bool:
	var sim := SimCoreScript.new(0x19D1)
	sim.mission_phase_a8 = 1
	sim.mission_flag_ac = 1
	sim.mission_short_90 = 0
	const WORLD_OBJ := 0x7C40
	sim.mem_u32[WORLD_OBJ + 0x18] = 11
	sim.mem_u32[WORLD_OBJ + 0x1c] = 1000
	sim.mem_u32[WORLD_OBJ + 0x20] = 33
	var e := EntityStateScript.new()
	var tmpl = EntityTemplateScript.new()
	tmpl.set_s16_field("field_34", 0x200)
	tmpl.set_s16_field("field_36", 0x600)
	tmpl.set_s16_field("field_40", 0)
	tmpl.set_s16_field("field_22", 0)
	tmpl.set_s16_field("field_24", 0)
	e.external_template = tmpl
	e.world_obj_ptr = WORLD_OBJ
	e.set_u8_field("field_63e", 1)
	e.set_u8_field("field_0b", 0)
	e.set_s8_field("direction_char_679", 0x2D)
	e.set_s8_field("field_19d", 1)
	e.set_s8_field("field_19f", 5)
	e.set_s16_field("field_18d", 0x100)
	e.set_field("pos_2e", 50000)
	e.set_s16_field("movement_626", 0)
	e.set_s16_field("movement_662", 0)
	e.set_field("movement_62a", 0x100 << 2)
	e.set_s8_field("weapon_count_67d", 1)
	e.set_s16_field("field_18c", 0)
	sim.entity_array_1.append(e)
	sim.tick()
	var ok := Assertions.assert_true(sim.last_weapon_19d_fired, "fired")
	ok = Assertions.assert_true(sim.last_weapon_19d_need_12840, "stub invoked") and ok
	ok = Assertions.assert_equal(e.get_s8_field("field_19d"), 2, "19d 1→2") and ok
	ok = Assertions.assert_equal(e.get_s8_field("field_19f"), 4, "19f 5→4") and ok
	ok = Assertions.assert_equal(e.get_s16_field("field_18d"), 0xF0, "18d-=0x10") and ok
	ok = Assertions.assert_equal(int(sim.last_12840_args.get("world_x", -1)), 11, "12840 world_x") and ok
	ok = Assertions.assert_equal(int(sim.last_12840_args.get("world_z", -1)), 33, "12840 world_z") and ok
	ok = Assertions.assert_equal(sim.last_12840_result, 0, "no fixture → 0") and ok
	## early 0x10 skips weapon branch
	var e2 := EntityStateScript.new()
	e2.external_template = tmpl
	e2.world_obj_ptr = WORLD_OBJ
	e2.set_u8_field("field_63e", 1)
	e2.set_u8_field("field_0b", 0x10)
	e2.set_s8_field("direction_char_679", 1)
	e2.set_s8_field("field_19d", 1)
	e2.set_s8_field("field_19f", 5)
	e2.set_field("pos_2e", 50000)
	e2.set_u16_field("status_1a1", 0)
	e2.set_s16_field("movement_626", 0)
	e2.set_s16_field("movement_662", 0)
	e2.set_field("movement_62a", 0x55AA)
	e2.set_s8_field("weapon_count_67d", 1)
	e2.set_s16_field("field_18c", 0)
	sim.entity_array_1.clear()
	sim.entity_array_1.append(e2)
	sim.tick()
	ok = Assertions.assert_true(not sim.last_weapon_19d_fired, "early skips fire") and ok
	ok = Assertions.assert_equal(e2.get_s8_field("field_19d"), 1, "19d unchanged on early") and ok
	return ok

## [RECONSTRUCTED] FUN_00012840 post-spawn writes via mock *(05116+8) (17561–17570, 14655–14658).
func _test_fun_00012840_spawn_fixture() -> bool:
	var sim := SimCoreScript.new(0x12840)
	sim.mission_phase_a8 = 1
	sim.mission_flag_ac = 1
	sim.mission_short_90 = 0
	const WORLD_OBJ := 0x7C48
	sim.mem_u32[WORLD_OBJ + 0x18] = 100
	sim.mem_u32[WORLD_OBJ + 0x1c] = 200
	sim.mem_u32[WORLD_OBJ + 0x20] = 300
	var spawn := EntityStateScript.new()
	spawn.set_u16_field("field_61c", 0x0001)
	sim.spawn_12840_entity = spawn
	sim.spawn_12840_handle = 0xBEEF
	var e := EntityStateScript.new()
	var tmpl = EntityTemplateScript.new()
	tmpl.set_s16_field("field_34", 0x200)
	tmpl.set_s16_field("field_36", 0x600)
	tmpl.set_s16_field("field_40", 0)
	tmpl.set_s16_field("field_22", 0)
	tmpl.set_s16_field("field_24", 0)
	e.external_template = tmpl
	e.world_obj_ptr = WORLD_OBJ
	e.set_u8_field("field_63e", 1)
	e.set_u8_field("field_0b", 0)
	e.set_s8_field("direction_char_679", 0x2D)
	e.set_s8_field("field_19d", 1)
	e.set_s8_field("field_19f", 3)
	e.set_s16_field("field_18d", 0x80)
	e.set_u16_field("pos_20", 0x55)
	e.set_u16_field("attitude_22", 0x66)
	e.set_s16_field("field_24", 0x77)
	e.set_field("pos_2e", 50000)
	e.set_s16_field("movement_626", 0)
	e.set_s16_field("movement_662", 0)
	e.set_field("movement_62a", 0xABCD)
	e.set_s8_field("weapon_count_67d", 1)
	e.set_s16_field("field_18c", 0)
	## entity_array_2[0] is designated player (latch path).
	sim.entity_array_2.append(e)
	sim.tick()
	var ok := Assertions.assert_equal(sim.last_12840_result, 0xBEEF, "returns mock handle")
	## speed is movement_62a at fire time (may differ from pre-tick value after e792).
	var fired_speed: int = int(sim.last_12840_args.get("speed", -1)) & 0xFFFF
	ok = Assertions.assert_equal(spawn.get_u16_field("field_610"), fired_speed, "610=speed") and ok
	ok = Assertions.assert_true(fired_speed != 0, "recorded speed nonzero") and ok
	ok = Assertions.assert_equal(spawn.get_u16_field("pos_20"), 0x55, "spawn pos_20") and ok
	ok = Assertions.assert_equal(spawn.get_u16_field("attitude_22"), 0x66, "spawn att22") and ok
	ok = Assertions.assert_equal(spawn.get_s16_field("field_24") & 0xFFFF, 0x77, "spawn field_24") and ok
	ok = Assertions.assert_equal(sim.dat_0001b880, 0xBEEF, "player b880") and ok
	ok = Assertions.assert_equal(sim.dat_0001b846, 1, "player b846") and ok
	ok = Assertions.assert_equal(spawn.get_u16_field("field_614"), 1, "short*[0x30a]=1") and ok
	return ok

## [RECONSTRUCTED] FUN_00005116 free-slot scan + fill + +0x44 gate (5705–5746).
func _test_fun_00005116_pool_scan() -> bool:
	var sim := SimCoreScript.new(0x5116)
	const D6FC := 0x4000
	const TABLE := 0x6000
	const WORLD := 0x8000
	sim.dat_0001d6fc = D6FC
	sim.dat_0001d6fc_slot_count = 2
	sim.dat_0001d6fc_short_2c = 10
	sim.mem_u32[D6FC + 0x30] = TABLE
	sim.mem_u32[TABLE + 0x14] = 0x1111  # slot0 occupied
	sim.mem_u32[TABLE + 0x18 + 0x14] = 0  # slot1 free
	const DESC := 0x26280
	sim.dat_0001b838 = 0xB8380001
	sim.mem_u32[DESC] = 2  # kind 2 → 045ba size 0x52
	sim.mem_u32[DESC + 1] = 1  # template index == slot1 → bump +3
	## desc+2/+6/+10 → obj+0x18/1c/20 (03b98 camera-relative); keep near camera=0
	sim.mem_u32[DESC + 2] = 0x10
	sim.mem_u32[DESC + 6] = 0
	sim.mem_u32[DESC + 10] = 0
	sim.mem_u32[DESC + 0x1C] = 0  # → obj+0x38 becomes 1
	sim.mem_u32[DESC + 0x1A] = 2  # → obj+0x36
	sim.mem_u32[DESC + 0x1E] = 2  # → obj+0x3a ; alloc (2+2)*0xC; 04808 two polys
	const POLY := 0x9000
	sim.spawn_04808_desc_ptr = POLY
	## poly0 header; count=2 → stream advance 0x12
	sim.mem_u32[POLY + 0] = 0xCAFEBABE
	sim.mem_u32[POLY + 4] = 0x11
	sim.mem_u32[POLY + 5] = 0x22
	sim.mem_u32[POLY + 8] = 2
	sim.mem_u32[POLY + 9] = 0xF1
	sim.mem_u32[POLY + 0x0A] = 0x55667788
	## poly1 at POLY+0x12
	const POLY1 := POLY + 0x12
	sim.mem_u32[POLY1 + 0] = 0xDEADBEEF
	sim.mem_u32[POLY1 + 4] = 0x33
	sim.mem_u32[POLY1 + 8] = 1
	sim.mem_u32[POLY1 + 9] = 0xA0
	sim.mem_u32[POLY1 + 0x0A] = 0x99
	sim.spawn_04808_index_words = [[0x0100, 0x0200], [0x0300]]
	sim.spawn_05116_world_obj = WORLD
	sim.spawn_05116_world_field_44 = 1
	sim.spawn_05116_entity_handle = 0xC0DE
	## (obj+6)&2 trailer; 045ba leaves +6 alone when flags04=0
	sim.mem_u32[WORLD + 6] = 2
	sim.mission_phase_a8 = 1  # 0435a gate: 0 < phase < 6
	sim.spawn_0435a_scale_src = 0x1000
	sim.spawn_0435a_poly_srcs = [0x200, 0x400]  # stream+10 → poly +0x1c (half when scale=0)
	## mesh=0 → null-OR walk; verts=+44 nonzero → no commit of locals
	sim.spawn_02bd8_nodes = [{"dx": 0x100, "dy": 0, "dz": 0}]
	var r: int = sim._call_fun_00005116(DESC, 10, 20, 30, 0xA, 0xB, 0xC, 0xD)
	var ok := Assertions.assert_equal(r, WORLD, "returns world obj")
	ok = Assertions.assert_equal(sim.last_05116_slot_index, 1, "used free slot1") and ok
	var slot1: int = TABLE + 0x18
	ok = Assertions.assert_equal(int(sim.mem_u32.get(slot1 + 0, -1)), 0xD, "p8") and ok
	ok = Assertions.assert_equal(int(sim.mem_u32.get(slot1 + 2, -1)), 0xA, "p5") and ok
	ok = Assertions.assert_equal(int(sim.mem_u32.get(slot1 + 8, -1)), 10, "x") and ok
	ok = Assertions.assert_equal(int(sim.mem_u32.get(slot1 + 0x14, -1)), WORLD, "046da mock") and ok
	ok = Assertions.assert_equal(int(sim.mem_u32.get(WORLD + 8, -1)), 0xC0DE, "world+8") and ok
	ok = Assertions.assert_true(bool(sim.last_04690_plus8.get("install", false)), "vtable +8") and ok
	ok = Assertions.assert_equal(int(sim.mem_u32.get(0xC0DE, -1)), 0, "*handle=0") and ok
	## slot fill p5/p6/p7 → +2/+4/+6 copied to handle+0x20/22/24
	ok = Assertions.assert_equal(int(sim.mem_u32.get(0xC0DE + 0x20, -1)), 0xA, "h+20") and ok
	ok = Assertions.assert_equal(int(sim.mem_u32.get(0xC0DE + 0x22, -1)), 0xB, "h+22") and ok
	ok = Assertions.assert_equal(int(sim.mem_u32.get(0xC0DE + 0x24, -1)), 0xC, "h+24") and ok
	ok = Assertions.assert_true(bool(sim.last_045ba.get("ok", false)), "045ba ran") and ok
	ok = Assertions.assert_equal(int(sim.mem_u32.get(WORLD + 0, -1)), 2, "045ba kind") and ok
	ok = Assertions.assert_equal(int(sim.mem_u32.get(WORLD + 0x18, -1)), 0x10, "045ba +18") and ok
	ok = Assertions.assert_equal(int(sim.mem_u32.get(WORLD + 0x38, -1)), 1, "045ba 1c→1") and ok
	ok = Assertions.assert_equal(int(sim.mem_u32.get(WORLD + 0x40, -1)), 0xB8380001, "045ba +40") and ok
	ok = Assertions.assert_equal(int(sim.mem_u32.get(WORLD + 0x24, -1)), D6FC, "046da +0x24=pool") and ok
	ok = Assertions.assert_equal(int(sim.mem_u32.get(WORLD + 1, -1)), 1, "046da +1=tpl") and ok
	ok = Assertions.assert_equal(int(sim.mem_u32.get(WORLD + 2, -1)), 1, "046da +2=slot") and ok
	ok = Assertions.assert_equal(int(sim.mem_u32.get(WORLD + 3, -1)), 1, "046da +3 bumped") and ok
	ok = Assertions.assert_equal(int(sim.mem_u32.get(WORLD + 4, -1)) & 1, 1, "046da flags|1") and ok
	ok = Assertions.assert_true(bool(sim.last_046da_04e6e_gate.get("need_04e6e", false)), "04e6e gate") and ok
	ok = Assertions.assert_equal(int(sim.mem_u32.get(WORLD + 0x10, -1)), 0x10, "03b98 +10") and ok
	var heap_4c: int = int(sim.mem_u32.get(WORLD + 0x4C, -1))
	var heap_44: int = int(sim.mem_u32.get(WORLD + 0x44, -1))
	ok = Assertions.assert_true(heap_4c != 0 and heap_44 != 0, "04e6e heaps") and ok
	ok = Assertions.assert_true(bool(sim.last_04e6e_kind2.get("via_01a68", false)), "4c/44 via 01a68") and ok
	ok = Assertions.assert_true(heap_4c != heap_44, "4c≠44 heaps") and ok
	ok = Assertions.assert_true(bool(sim.last_04e6e_list.get("to_b5a4", false)), "publish b5a4") and ok
	ok = Assertions.assert_equal(sim.dat_0001b5a4_world.size(), 1, "b5a4 len") and ok
	ok = Assertions.assert_equal(int(sim.dat_0001b5a4_world[0]), WORLD, "b5a4[0]") and ok
	ok = Assertions.assert_equal(int(sim.last_04e6e_kind2.get("alloc_bytes", -1)), 4 * 0xC, "alloc (2+2)*0xC") and ok
	## 48 bytes → large path for both vertex pools
	ok = Assertions.assert_true(
		bool(sim.last_04e6e_kind2.get("alloc_4c", {}).get("from_0199a", false)), "4c large"
	) and ok
	ok = Assertions.assert_equal(int(sim.mem_u32.get(WORLD + 0x48, -1)), sim.spawn_04808_buf_ptr, "04808 +48") and ok
	ok = Assertions.assert_equal(
		int(sim.last_04808.get("field_48", -1)), sim.spawn_04808_buf_ptr, "04808 field_48"
	) and ok
	## buffer 78 bytes → large 01a68 via 0199a
	ok = Assertions.assert_true(
		bool(sim.last_04808.get("buf_alloc", {}).get("from_0199a", false)), "buf 01a68 large"
	) and ok
	ok = Assertions.assert_equal(sim.dat_0001daa2, 1, "daa2=1") and ok
	## bit1 trailer: buf = 2*0x20 + 2*6 + 1*2 (field_38=1 from 045ba)
	ok = Assertions.assert_equal(int(sim.last_04808.get("buffer_bytes", -1)), 0x40 + 12 + 2, "04808 buf") and ok
	ok = Assertions.assert_equal(int(sim.last_04808.get("loop", {}).get("filled", -1)), 2, "2 polys") and ok
	ok = Assertions.assert_true(bool(sim.last_04808.get("trailer", {}).get("enabled", false)), "trailer on") and ok
	ok = Assertions.assert_equal(
		int(sim.mem_u32.get(sim.spawn_04808_buf_ptr + 0x40, -1)), 0, "trailer[0]=0"
	) and ok
	ok = Assertions.assert_equal(int(sim.mem_u32.get(sim.spawn_04808_buf_ptr + 0x0C, -1)), 0xCAFEBABE, "poly0 +0c") and ok
	ok = Assertions.assert_equal(int(sim.mem_u32.get(sim.spawn_04808_buf_ptr + 0x14, -1)), 2, "poly0 count") and ok
	ok = Assertions.assert_equal(int(sim.mem_u32.get(sim.spawn_04808_buf_ptr + 0x16, -1)), 0xF0, "poly0 nibble") and ok
	var idx_allocs: Array = sim.last_04808.get("index_allocs", [])
	ok = Assertions.assert_equal(idx_allocs.size(), 2, "2 idx allocs") and ok
	var idx0: int = int((idx_allocs[0] as Dictionary).get("payload_ptr", -1)) if idx_allocs.size() > 0 else -1
	var idx1: int = int((idx_allocs[1] as Dictionary).get("payload_ptr", -1)) if idx_allocs.size() > 1 else -1
	ok = Assertions.assert_equal(idx0, sim.spawn_04808_index_ptr, "idx0 mirror") and ok
	ok = Assertions.assert_true(idx0 != idx1 and idx1 > 0, "distinct idx heaps") and ok
	ok = Assertions.assert_equal(
		int(sim.mem_u32.get(sim.spawn_04808_buf_ptr + 0x18, -1)), idx0, "idx0 ptr"
	) and ok
	ok = Assertions.assert_equal(int(sim.mem_u32.get(idx0 + 0, -1)), 0x0100, "idx0[0]") and ok
	ok = Assertions.assert_equal(int(sim.mem_u32.get(idx0 + 2, -1)), 0x0200, "idx0[1]") and ok
	ok = Assertions.assert_equal(int(sim.last_04808.get("index", {}).get("alloc_bytes", -1)), 4, "idx0*2") and ok
	ok = Assertions.assert_equal(
		int(sim.mem_u32.get(sim.spawn_04808_buf_ptr + 0x20 + 0x0C, -1)), 0xDEADBEEF, "poly1 +0c"
	) and ok
	ok = Assertions.assert_equal(
		int(sim.mem_u32.get(sim.spawn_04808_buf_ptr + 0x20 + 0x14, -1)), 1, "poly1 count"
	) and ok
	ok = Assertions.assert_equal(
		int(sim.mem_u32.get(sim.spawn_04808_buf_ptr + 0x20 + 0x18, -1)), idx1, "idx1 ptr"
	) and ok
	ok = Assertions.assert_equal(int(sim.mem_u32.get(idx1, -1)), 0x0300, "idx1[0]") and ok
	ok = Assertions.assert_equal(int((idx_allocs[0] as Dictionary).get("size_class", -1)), 3, "idx0 bin3") and ok
	ok = Assertions.assert_true(bool(sim.last_02bd8_gate.get("need_02bd8", false)), "02bd8 gate") and ok
	ok = Assertions.assert_equal(int(sim.last_02bd8_args.get("param_2_count", -1)), 4, "02bd8 36+3a") and ok
	ok = Assertions.assert_equal(int(sim.last_02bd8_args.get("param_4_verts", -1)), heap_44, "02bd8 +44") and ok
	## 04e6e passes non-null +44 → null-aux epilogue does not commit
	ok = Assertions.assert_true(not bool(sim.last_02bd8_commit.get("commit", true)), "no null-aux") and ok
	ok = Assertions.assert_equal(int(sim.last_02bd8_walk.get("steps", -1)), 1, "02bd8 walk") and ok
	## +18 was 0x10 from 045ba; walk adds 0x100 into locals (not committed)
	ok = Assertions.assert_equal(int(sim.last_02bd8_walk.get("x", -1)), 0x110, "walk local x") and ok
	ok = Assertions.assert_equal(int(sim.mem_u32.get(WORLD + 0x18, -1)), 0x10, "+18 unchanged") and ok
	ok = Assertions.assert_true(bool(sim.last_04e6e_followup.get("need_0435a", false)), "0435a") and ok
	ok = Assertions.assert_equal(int(sim.last_04e6e_followup.get("0435a_param_2", -1)), 0, "0435a p2") and ok
	ok = Assertions.assert_true(bool(sim.last_04e6e_followup.get("need_03da8", false)), "03da8") and ok
	ok = Assertions.assert_equal(
		int(sim.last_04e6e_followup.get("03da8_param_2", -1)),
		int(sim.mem_u32.get(WORLD + 0x10, -1)),
		"03da8=+10"
	) and ok
	## metric +10 = 0x10 from 03b98; ROM DAT_0001b190 → band 3 from +0x30=0
	ok = Assertions.assert_true(bool(sim.last_03da8.get("ok", false)), "03da8 ok") and ok
	ok = Assertions.assert_equal(int(sim.last_03da8.get("return", -1)), 1, "03da8 changed") and ok
	ok = Assertions.assert_equal(int(sim.last_03da8.get("field_30", -1)), 3, "ROM band 3") and ok
	ok = Assertions.assert_equal(
		int(sim.mem_u32.get(WORLD + 0x30, -1)), int(sim.last_03da8.get("field_30", -2)), "+30 wrote"
	) and ok
	ok = Assertions.assert_true(bool(sim.last_0435a.get("gate", {}).get("enter", false)), "0435a enter") and ok
	ok = Assertions.assert_equal(int(sim.last_0435a.get("scale_factor", -1)), 0, "scale phase-1") and ok
	ok = Assertions.assert_equal(int(sim.mem_u32.get(WORLD + 0x0C, -1)), 0x800, "+0xc half") and ok
	ok = Assertions.assert_true(bool(sim.last_0435a.get("poly_1c", {}).get("ran", false)), "1c loop") and ok
	ok = Assertions.assert_equal(
		int(sim.mem_u32.get(sim.spawn_04808_buf_ptr + 0x1C, -1)), 0x100, "poly0 +1c"
	) and ok
	ok = Assertions.assert_equal(
		int(sim.mem_u32.get(sim.spawn_04808_buf_ptr + 0x20 + 0x1C, -1)), 0x200, "poly1 +1c"
	) and ok
	## far desc x → 03b98 defer → +0x44 cleared → 05116 fails


	sim.mem_u32[TABLE + 0x18 + 0x14] = 0
	sim.mem_u32[DESC + 2] = 0x30000
	sim.dat_0001d838 = 0
	sim.spawn_05116_world_field_44 = 1
	r = sim._call_fun_00005116(DESC, 1, 2, 3, 0, 0, 0, 0)
	ok = Assertions.assert_equal(r, 0, "defer → 05116 fail") and ok
	ok = Assertions.assert_true(sim.last_046da_deferred, "deferred flag") and ok
	ok = Assertions.assert_true(sim.last_05116_need_051ec, "need 051ec on defer") and ok
	ok = Assertions.assert_equal(int(sim.mem_u32.get(WORLD + 0x10, -1)), 0x30000, "03b98 far +10") and ok
	ok = Assertions.assert_equal(int(sim.last_03b98_axes.get("a", -1)), 0x30000, "axis from pos−cam") and ok
	sim.mem_u32[DESC + 2] = 0x10
	sim.mem_u32[WORLD + 0x18] = 0
	sim.mem_u32[WORLD + 0x1C] = 0
	sim.mem_u32[WORLD + 0x20] = 0
	## full pool → 01ba8 grow-by-10 → uses first new slot
	sim.mem_u32[TABLE + 0x14] = 1
	sim.mem_u32[TABLE + 0x18 + 0x14] = 2
	sim.spawn_05116_world_obj = WORLD
	sim.spawn_05116_world_field_44 = 1
	sim.spawn_05116_entity_handle = 0xC0DE
	r = sim._call_fun_00005116(0, 5, 6, 7, 0, 0, 0, 0)
	ok = Assertions.assert_equal(r, WORLD, "full → grow success") and ok
	ok = Assertions.assert_true(sim.last_05116_need_grow, "need grow") and ok
	ok = Assertions.assert_true(sim.last_05116_grew, "grew") and ok
	ok = Assertions.assert_equal(sim.dat_0001d6fc_slot_count, 12, "count 2→12") and ok
	ok = Assertions.assert_equal(sim.last_05116_slot_index, 2, "first new slot") and ok
	var new_base: int = int(sim.mem_u32.get(D6FC + 0x30, 0))
	ok = Assertions.assert_true(new_base != TABLE, "new table base") and ok
	ok = Assertions.assert_equal(int(sim.mem_u32.get(new_base + 2 * 0x18 + 8, -1)), 5, "grew slot x") and ok
	## +0x44==0 → fail + clear slot (use free slot in grown table)
	sim.mem_u32[new_base + 3 * 0x18 + 0x14] = 0
	sim.spawn_04e6e_use_mock_ptrs = true
	sim.spawn_04e6e_ptr_4c = 0
	sim.spawn_05116_world_field_44 = 0
	r = sim._call_fun_00005116(0, 1, 2, 3, 0, 0, 0, 0)
	ok = Assertions.assert_equal(r, 0, "44==0 fail") and ok
	ok = Assertions.assert_true(sim.last_05116_need_051ec, "need 051ec") and ok
	ok = Assertions.assert_equal(int(sim.mem_u32.get(new_base + 3 * 0x18 + 0x14, -1)), 0, "slot cleared") and ok
	return ok

## [RECONSTRUCTED] 046da → FUN_00016a3a via *(1b524[type]+6)=#0x16A1A (+0x20).
func _test_fun_00016a3a_via_046da() -> bool:
	var sim := SimCoreScript.new(0x16A3A)
	const WORLD := 0xC100
	const D6FC := 0xC200
	const TABLE := 0xC300
	const DESC := 0xC400
	sim.dat_0001d6fc = D6FC
	sim.dat_0001d6fc_slot_count = 1
	sim.mem_u32[D6FC + 0x30] = TABLE
	sim.mem_u32[TABLE + 0] = 0x11
	sim.mem_u32[TABLE + 2] = 0x22
	sim.mem_u32[TABLE + 4] = 0x33
	sim.mem_u32[TABLE + 6] = 0x44
	sim.spawn_05116_world_obj = WORLD
	sim.mem_u32[WORLD + 4] = 1
	## desc[1] is the 1b524 key (04690); Block A slot 0x5858.
	sim.mem_u32[DESC + 1] = 0x5858
	## Primary: install at tpl+6 (04690 resolve); no fallback imm.
	FlightMathScript.apply_00054_first_loop(sim.heap_01a68, sim.dat_0001b524)
	var tpl: int = int(sim.dat_0001b524.get(0x5858, 0))
	sim.mem_u32[tpl + 6] = 0x16A1A
	sim.spawn_1b524_factory_imm = 0
	sim.spawn_1b524_type_key = -1
	sim.spawn_046da_03b98_axes_override = [0, 0, 0]
	sim._call_fun_000046da(DESC, 1, 0)
	var ok := Assertions.assert_true(bool(sim.last_16a3a_factory.get("ok", false)), "16a3a ok")
	ok = Assertions.assert_equal(
		str(sim.last_1b524_factory_resolve.get("type_key_info", {}).get("source", "")),
		"desc[1]",
		"key from desc"
	) and ok
	ok = Assertions.assert_equal(str(sim.last_1b524_factory_resolve.get("source", "")), "tpl+6", "from tpl+6") and ok
	ok = Assertions.assert_equal(int(sim.last_16a3a_factory.get("factory_entry", -1)), 0x16A3A, "entry") and ok
	var h: int = int(sim.mem_u32.get(WORLD + 8, -1))
	ok = Assertions.assert_true(h != 0 and h != 0xC0DE, "heap handle") and ok
	ok = Assertions.assert_equal(int(sim.mem_u32.get(h, -1)), 0, "*h cleared") and ok
	ok = Assertions.assert_equal(int(sim.mem_u32.get(h + 4, -1)), tpl, "h+4=tpl") and ok
	ok = Assertions.assert_equal(int(sim.mem_u32.get(WORLD + 4, -1)) & 0x12000, 0x12000, "|=0x12000") and ok
	ok = Assertions.assert_equal(int(sim.mem_u32.get(WORLD + 0x34, -1)), 0, "+34 clr") and ok
	ok = Assertions.assert_equal(int(sim.mem_u32.get(h + 0x20, -1)), 0x22, "aux+20") and ok
	## Fallback imm still works when tpl+6 empty
	sim.mem_u32[tpl + 6] = 0
	sim.spawn_1b524_factory_imm = 0x16A1A
	sim.mem_u32[WORLD + 4] = 1
	sim._call_fun_000046da(DESC, 1, 0)
	ok = Assertions.assert_equal(str(sim.last_1b524_factory_resolve.get("source", "")), "fallback", "fb") and ok
	ok = Assertions.assert_true(bool(sim.last_16a3a_factory.get("ok", false)), "fb ok") and ok
	return ok

## [RECONSTRUCTED] 046da → FUN_000115b0 via *(1b524[type]+6)=#0x11590 (+0x20).
func _test_fun_000115b0_via_046da() -> bool:
	var sim := SimCoreScript.new(0x115B0)
	const WORLD := 0xD100
	const D6FC := 0xD200
	const TABLE := 0xD300
	const DESC := 0xD400
	sim.dat_0001d6fc = D6FC
	sim.dat_0001d6fc_slot_count = 1
	sim.mem_u32[D6FC + 0x30] = TABLE
	sim.mem_u32[TABLE + 2] = 0x10
	sim.mem_u32[TABLE + 4] = 0x20
	sim.mem_u32[TABLE + 6] = 0x30
	sim.spawn_05116_world_obj = WORLD
	sim.mem_u32[WORLD + 4] = 3
	sim.mem_u32[DESC + 1] = 0x5858
	FlightMathScript.apply_00054_first_loop(sim.heap_01a68, sim.dat_0001b524)
	var tpl: int = int(sim.dat_0001b524.get(0x5858, 0))
	sim.mem_u32[tpl + 6] = 0x11590
	sim.spawn_1b524_factory_imm = 0
	sim.spawn_1b524_type_key = -1
	## Block B publishes DAT_0001b540 (no manual mock).
	var bb: Dictionary = sim.publish_00054_block_b()
	var ok := Assertions.assert_true(bool(bb.get("ok", false)), "block b")
	sim.spawn_046da_03b98_axes_override = [0, 0, 0]
	sim._call_fun_000046da(DESC, 1, 0)
	ok = Assertions.assert_true(bool(sim.last_115b0_factory.get("ok", false)), "115b0 ok") and ok
	ok = Assertions.assert_equal(
		str(sim.last_1b524_factory_resolve.get("type_key_info", {}).get("source", "")),
		"desc[1]",
		"key from desc"
	) and ok
	ok = Assertions.assert_equal(str(sim.last_1b524_factory_resolve.get("source", "")), "tpl+6", "from tpl+6") and ok
	ok = Assertions.assert_equal(int(sim.last_115b0_factory.get("factory_entry", -1)), 0x115B0, "entry") and ok
	ok = Assertions.assert_equal(int(sim.last_115b0_factory.get("alloc_size", -1)), 0xA2, "0xa2") and ok
	var h: int = int(sim.mem_u32.get(WORLD + 8, -1))
	ok = Assertions.assert_true(h != 0, "heap handle") and ok
	ok = Assertions.assert_equal(int(sim.mem_u32.get(h, -1)), 0, "*h cleared") and ok
	ok = Assertions.assert_equal(int(sim.mem_u32.get(h + 4, -1)), sim.dat_0001b540, "h+4=1b540") and ok
	ok = Assertions.assert_true(sim.dat_0001b540 != 0, "1b540 live") and ok
	ok = Assertions.assert_equal(int(sim.mem_u32.get(WORLD + 4, -1)) & 0x112000, 0x112000, "|=0x112000") and ok
	return ok

## [RECONSTRUCTED] FUN_00000054 full overlay publish (Blocks A–D).
func _test_fun_00000054_publish_all() -> bool:
	var sim := SimCoreScript.new(0x54)
	var all: Dictionary = sim.publish_00054_all()
	var ok := Assertions.assert_true(bool(all.get("ok", false)), "all ok")
	ok = Assertions.assert_true(sim.overlay_00054_published, "flag") and ok
	ok = Assertions.assert_true(sim.dat_0001b524.has(0x5858), "A 5858") and ok
	ok = Assertions.assert_true(sim.dat_0001b524.has(0), "C key0") and ok
	ok = Assertions.assert_true(sim.dat_0001b540 != 0, "B 1b540") and ok
	ok = Assertions.assert_true(sim.dat_00054_fixed_slots.has(0x1B58C), "D 1b58c") and ok
	ok = Assertions.assert_true(sim.dat_00054_fixed_slots.has(0x1B59C), "D 1b59c") and ok
	ok = Assertions.assert_equal(
		int(sim.mem_u32.get(0x1B58C, -1)), int(sim.dat_00054_fixed_slots[0x1B58C]), "mem mirror"
	) and ok
	return ok

## [RECONSTRUCTED] FUN_000016e2 → $54, 04690→1d6fc, child×0x18 alloc/copy/relocate.
## [RECONSTRUCTED] FUN_00004e6e kind-3: d4a4 + table + 046da front (Capstone @0x5072–0x5106).
func _test_fun_00004e6e_kind3() -> bool:
	var sim := SimCoreScript.new(0x4E6E)
	const B5A0 := 0xD100
	const DESC := 0xD200
	const OBJ := 0xD300
	const EMBED := 0xD400
	const CD0 := 0xD500
	const CHILD := 0xD600
	sim.dat_0001b5a0 = B5A0
	sim.mem_u32[B5A0 + 0x8C] = DESC
	sim.mem_u32[OBJ] = 3  # kind 3
	sim.mem_u32[OBJ + 0x28] = EMBED
	sim.mem_u32[OBJ + 0x2C] = 2  # idx0 < 2 → OR flag1
	sim.mem_u32[OBJ + 0x2E] = 1
	sim.mem_u32[EMBED + 0x1A + 0] = 0xA0
	sim.mem_u32[EMBED + 0x1A + 0x14] = CD0 - DESC
	sim.mem_u32[CD0] = 2  # kind-2 child desc
	sim.mem_u32[CD0 + 1] = 1
	sim.spawn_046da_child_objs = [CHILD]
	var r: Dictionary = sim._call_fun_00004e6e(OBJ)
	var ok := Assertions.assert_true(bool(r.get("ok", false)), "k3 ok")
	ok = Assertions.assert_equal(int(r.get("kind", -1)), 3, "kind3") and ok
	ok = Assertions.assert_equal(sim.dat_0001d4a4_world.size(), 1, "d4a4×1") and ok
	ok = Assertions.assert_equal(sim.dat_0001c1e0_count, 1, "c1e0") and ok
	var table: int = int(sim.mem_u32.get(OBJ + 0x30, -1))
	ok = Assertions.assert_equal(int(sim.mem_u32.get(table + 0x14, -1)), CHILD, "tbl obj") and ok
	ok = Assertions.assert_equal(int(sim.mem_u32.get(CHILD + 0x24, -1)), OBJ, "parent") and ok
	ok = Assertions.assert_equal(int(sim.mem_u32.get(CHILD + 1, -1)), 0, "+1") and ok
	ok = Assertions.assert_equal(int(sim.mem_u32.get(CHILD + 3, -1)), 1, "bump03") and ok
	ok = Assertions.assert_equal(int(sim.mem_u32.get(CHILD + 4, -1)) & 1, 1, "flag1") and ok
	ok = Assertions.assert_true(not bool(r.get("deferred_046da_loop", true)), "loop done") and ok
	ok = Assertions.assert_equal(sim.last_046da_kind3_calls.size(), 1, "046da×1") and ok
	var one: Dictionary = sim.last_046da_kind3_calls[0]
	ok = Assertions.assert_true(bool(one.get("02bd8_commit", {}).get("commit", false)), "02bd8") and ok
	ok = Assertions.assert_true(not bool(one.get("deferred_0435a", true)), "0435a done") and ok
	ok = Assertions.assert_equal(int(one.get("0435a", {}).get("param_2", -1)), 1, "0435a p2=1") and ok
	ok = Assertions.assert_true(not bool(r.get("deferred_0435a", true)), "k3 0435a") and ok
	ok = Assertions.assert_true(one.has("03b98"), "03b98") and ok
	ok = Assertions.assert_true(bool(one.get("distance_gate", {}).get("need_04e6e", false)), "near") and ok
	ok = Assertions.assert_true(one.has("nested_04e6e"), "nested 04e6e") and ok
	ok = Assertions.assert_equal(int(sim.mem_u32.get(CHILD + 0x10, -1)), int(one.get("03b98", {}).get("field_10", -2)), "+10") and ok
	## Phase open: 0435a writes +0xc from scale_src before the distance gate.
	sim = SimCoreScript.new(0x4E6E)
	sim.dat_0001b5a0 = B5A0
	sim.mem_u32[B5A0 + 0x8C] = DESC
	sim.mem_u32[OBJ] = 3
	sim.mem_u32[OBJ + 0x28] = EMBED
	sim.mem_u32[OBJ + 0x2C] = 2
	sim.mem_u32[OBJ + 0x2E] = 1
	sim.mem_u32[EMBED + 0x1A + 0] = 0xA0
	sim.mem_u32[EMBED + 0x1A + 0x14] = CD0 - DESC
	sim.mem_u32[CD0] = 2
	sim.mem_u32[CD0 + 1] = 1
	sim.spawn_046da_child_objs = [CHILD]
	sim.mission_phase_a8 = 2
	sim.spawn_0435a_scale_src = 0x2000
	sim.mem_u32[CHILD + 0x0C] = 0
	sim.mem_u32[CHILD + 7] = 0
	r = sim._call_fun_00004e6e(OBJ)
	ok = Assertions.assert_true(bool(r.get("ok", false)), "k3b ok") and ok
	ok = Assertions.assert_equal(int(sim.mem_u32.get(CHILD + 0x0C, -1)), 0x2000, "+0xc scaled") and ok
	var one_b: Dictionary = sim.last_046da_kind3_calls[0] if sim.last_046da_kind3_calls.size() > 0 else {}
	ok = Assertions.assert_equal(int(one_b.get("0435a", {}).get("param_2", -1)), 1, "046da p2") and ok
	ok = Assertions.assert_true(bool(one_b.get("0435a", {}).get("gate", {}).get("enter", false)), "0435a enter") and ok
	return ok


func _test_fun_000016e2_calls_00054() -> bool:
	var sim := SimCoreScript.new(0x16E2)
	const B5A0 := 0xE100
	const DESC := 0xE200
	const ROOT := 0xE300
	const HANDLE := 0xE400
	const EMBED := 0xE500  # *(root+0x28); children at EMBED+0x1A
	const CD0 := 0xE600
	const CD1 := 0xE700
	const CD2 := 0xEA00
	const CD3 := 0xEC00
	const CD4 := 0xEE00
	const OBJ0 := 0xE800
	const OBJ1 := 0xE900
	const OBJ2 := 0xEB00
	const OBJ3 := 0xED00
	const OBJ4 := 0xEF00
	const BDA8_VAL := 0xBDA80048
	sim.dat_0001b5a0 = B5A0
	sim.mem_u32[B5A0 + 0x8C] = DESC
	sim.mem_u32[B5A0 + 0x90] = 0  # → bdac = child[2] + 04e6e
	sim.mem_u32[DESC + 0] = 2  # 045ba kind
	sim.mem_u32[DESC + 1] = 1  # nonzero → plus8
	sim.spawn_04690_obj = ROOT
	sim.spawn_05116_entity_handle = HANDLE
	sim.spawn_04690_child_objs = [OBJ0, OBJ1, OBJ2, OBJ3, OBJ4]
	sim.mem_u32[ROOT + 0x28] = EMBED
	sim.mem_u32[ROOT + 0x2C] = 2  # window center → bc28=child[1..3]
	sim.mem_u32[ROOT + 0x2E] = 5
	sim.dat_0001b734 = 99  # must clear
	for cd in [CD0, CD1, CD2, CD3, CD4]:
		sim.mem_u32[cd + 0] = 2
		sim.mem_u32[cd + 1] = 1
	## embedded records; +0x14 raw offsets → CDx after +DESC
	sim.mem_u32[EMBED + 0x1A + 0] = 0xA0
	sim.mem_u32[EMBED + 0x1A + 0x14] = CD0 - DESC
	sim.mem_u32[EMBED + 0x1A + 0x18 + 0] = 0xB0
	sim.mem_u32[EMBED + 0x1A + 0x18 + 0x14] = CD1 - DESC
	sim.mem_u32[EMBED + 0x1A + 0x30 + 0] = 0xC0
	sim.mem_u32[EMBED + 0x1A + 0x30 + 0x14] = CD2 - DESC
	sim.mem_u32[EMBED + 0x1A + 0x48 + 0] = 0xD0
	sim.mem_u32[EMBED + 0x1A + 0x48 + 0x14] = CD3 - DESC
	sim.mem_u32[EMBED + 0x1A + 0x60 + 0] = 0xE0
	sim.mem_u32[EMBED + 0x1A + 0x60 + 0x14] = CD4 - DESC
	sim.mem_u32[OBJ2 + 0x48] = BDA8_VAL
	## 01c04 on bda4=OBJ4: counts via 045ba; 04e6e kind2 allocs +44/+4c (mock fixtures)
	const SRC44 := 0xF100
	const DST4C := 0xF200
	sim.mem_u32[CD4 + 0x1A] = 1
	sim.mem_u32[CD4 + 0x1E] = 1
	sim.spawn_04e6e_use_mock_ptrs = true
	sim.spawn_04e6e_ptr_4c = DST4C
	sim.spawn_05116_world_field_44 = SRC44
	sim.mem_u32[SRC44 + 0] = 0xAAA10001
	sim.mem_u32[SRC44 + 4] = 0xAAA10002
	sim.mem_u32[SRC44 + 8] = 0xAAA10003
	sim.mem_u32[SRC44 + 0xC] = 0xAAA20001
	sim.mem_u32[SRC44 + 0x10] = 0xAAA20002
	sim.mem_u32[SRC44 + 0x14] = 0xAAA20003
	## desc payloads for 04e06 copies (child0 → CD0)
	sim.mem_u32[CD0 + 2] = 0x1111
	sim.mem_u32[CD0 + 6] = 0x2222
	sim.mem_u32[CD0 + 0xA] = 0x3333
	sim.mem_u32[CD0 + 0x12] = 0x4444
	sim.mem_u32[CD1 + 2] = 0x5555
	sim.mem_u32[CD1 + 6] = 0x6666
	sim.mem_u32[CD1 + 0xA] = 0x7777
	sim.mem_u32[CD1 + 0x12] = 0x8888
	var ok := Assertions.assert_true(not sim.overlay_00054_published, "pre clear")
	var r: Dictionary = sim.init_mission_object_tables()
	ok = Assertions.assert_true(bool(r.get("ok", false)), "016e2 ok") and ok
	ok = Assertions.assert_equal(sim.dat_0001d6fc, ROOT, "1d6fc=root") and ok
	ok = Assertions.assert_equal(sim.dat_0001bdb4, OBJ0, "bdb4") and ok
	ok = Assertions.assert_equal(sim.dat_0001bdb0, OBJ1, "bdb0") and ok
	ok = Assertions.assert_equal(sim.dat_0001bdac, OBJ2, "bdac") and ok
	ok = Assertions.assert_equal(sim.dat_0001bda8, BDA8_VAL, "bda8") and ok
	ok = Assertions.assert_equal(sim.dat_0001bda4, OBJ4, "bda4") and ok
	ok = Assertions.assert_equal(sim.dat_0001b734, 0, "b734 clr") and ok
	ok = Assertions.assert_equal(sim.dat_0001bc28, OBJ1, "bc28") and ok
	ok = Assertions.assert_equal(sim.dat_0001bc34, OBJ2, "bc34") and ok
	ok = Assertions.assert_equal(sim.dat_0001bc38, OBJ3, "bc38") and ok
	## 04e06 body via 04e4e: OBJ0/OBJ1 got desc field copies + 02bd8
	ok = Assertions.assert_equal(int(sim.mem_u32.get(OBJ0 + 0x18, -1)), 0x1111, "o0+18") and ok
	ok = Assertions.assert_equal(int(sim.mem_u32.get(OBJ0 + 0x14, -1)), 0x4444, "o0+14") and ok
	ok = Assertions.assert_equal(int(sim.mem_u32.get(OBJ1 + 0x18, -1)), 0x5555, "o1+18") and ok
	ok = Assertions.assert_equal(int(sim.mem_u32.get(OBJ1 + 0x14, -1)), 0x8888, "o1+14") and ok
	ok = Assertions.assert_true(bool(sim.last_04e4e_calls[0].get("called_02bd8", false)), "02bd8") and ok
	ok = Assertions.assert_equal(sim.last_01be4_calls.size(), 2, "01be4×2") and ok
	ok = Assertions.assert_true(
		bool(sim.last_01be4_calls[0].get("is_01ba8_mid_entry", false)), "01be4 mid"
	) and ok
	ok = Assertions.assert_true(
		bool(sim.last_01be4_calls[0].get("deferred_abi", false)), "01be4 abi defer"
	) and ok
	ok = Assertions.assert_equal(sim.last_04e6e_calls.size(), 2, "04e6e×2") and ok
	ok = Assertions.assert_equal(int(sim.last_04e6e_calls[0].get("kind", -1)), 2, "04e6e k2") and ok
	ok = Assertions.assert_true(bool(sim.last_04e6e_calls[0].get("ok", false)), "04e6e0 ok") and ok
	ok = Assertions.assert_equal(sim.dat_0001b5a4_world.size(), 2, "b5a4×2") and ok
	ok = Assertions.assert_equal(sim.dat_0001b734, 0, "b734 cleared after") and ok
	ok = Assertions.assert_equal(int(sim.mem_u32.get(OBJ4 + 0x44, -1)), SRC44, "o4+44") and ok
	ok = Assertions.assert_equal(int(sim.mem_u32.get(OBJ4 + 0x4C, -1)), DST4C, "o4+4c") and ok
	ok = Assertions.assert_equal(sim.last_01c04_calls.size(), 1, "01c04×1") and ok
	ok = Assertions.assert_equal(int(sim.last_01c04_calls[0].get("copied_words", -1)), 6, "01c04×6") and ok
	ok = Assertions.assert_equal(int(sim.mem_u32.get(DST4C + 0, -1)), 0xAAA10001, "v0x") and ok
	ok = Assertions.assert_equal(int(sim.mem_u32.get(DST4C + 0x14, -1)), 0xAAA20003, "v1z") and ok
	ok = Assertions.assert_true(not bool(sim.last_016e2.get("deferred_bda_bc28", true)), "tail done") and ok
	return ok

## [RECONSTRUCTED] FUN_00012840 → FUN_00005116 pool then *(world+8) writes (17551–17571).
func _test_fun_00012840_via_05116_pool() -> bool:
	var sim := SimCoreScript.new(0x12841)
	sim.mission_phase_a8 = 1
	sim.mission_flag_ac = 1
	sim.mission_short_90 = 0
	const SHOOTER_WORLD := 0x7C60
	const D6FC := 0x4100
	const TABLE := 0x6100
	const SPAWN_WORLD := 0x8100
	sim.dat_0001d6fc = D6FC
	sim.dat_0001d6fc_slot_count = 1
	sim.mem_u32[D6FC + 0x30] = TABLE
	sim.mem_u32[TABLE + 0x14] = 0
	sim.dat_00026280 = 0x26280
	sim.mem_u32[0x26280 + 1] = 1  # desc[1]≠0 → vtable +8 factory
	sim.spawn_05116_world_obj = SPAWN_WORLD
	sim.spawn_04e6e_use_mock_ptrs = true
	sim.spawn_04e6e_ptr_4c = 0x4C00
	sim.spawn_05116_world_field_44 = 1
	sim.spawn_05116_entity_handle = 0xF00D
	sim.mem_u32[SHOOTER_WORLD + 0x18] = 11
	sim.mem_u32[SHOOTER_WORLD + 0x1c] = 22
	sim.mem_u32[SHOOTER_WORLD + 0x20] = 33
	var spawn := EntityStateScript.new()
	spawn.set_u16_field("field_61c", 0)
	sim.spawn_12840_entity = spawn
	var e := EntityStateScript.new()
	var tmpl = EntityTemplateScript.new()
	tmpl.set_s16_field("field_34", 0x200)
	tmpl.set_s16_field("field_36", 0x600)
	tmpl.set_s16_field("field_40", 0)
	tmpl.set_s16_field("field_22", 0)
	tmpl.set_s16_field("field_24", 0)
	e.external_template = tmpl
	e.world_obj_ptr = SHOOTER_WORLD
	e.set_u8_field("field_63e", 1)
	e.set_u8_field("field_0b", 0)
	e.set_s8_field("direction_char_679", 0x2D)
	e.set_s8_field("field_19d", 1)
	e.set_s8_field("field_19f", 2)
	e.set_s16_field("field_18d", 0x40)
	e.set_u16_field("pos_20", 0x12)
	e.set_u16_field("attitude_22", 0x34)
	e.set_s16_field("field_24", 0x56)
	e.set_field("pos_2e", 50000)
	e.set_s16_field("movement_626", 0)
	e.set_s16_field("movement_662", 0)
	e.set_field("movement_62a", 0x100 << 2)
	e.set_s8_field("weapon_count_67d", 1)
	e.set_s16_field("field_18c", 0)
	sim.entity_array_2.append(e)
	sim.tick()
	var ok := Assertions.assert_equal(sim.last_12840_result, 0xF00D, "entity from world+8")
	ok = Assertions.assert_equal(sim.last_05116_result, SPAWN_WORLD, "05116 ran") and ok
	ok = Assertions.assert_equal(sim.last_05116_slot_index, 0, "slot0") and ok
	ok = Assertions.assert_equal(int(sim.mem_u32.get(TABLE + 8, -1)), 11, "pool x") and ok
	ok = Assertions.assert_equal(int(sim.mem_u32.get(TABLE + 0xC, -1)), 22, "pool y") and ok
	ok = Assertions.assert_equal(int(sim.mem_u32.get(TABLE + 0x10, -1)), 33, "pool z") and ok
	ok = Assertions.assert_equal(spawn.get_u16_field("pos_20"), 0x12, "wrote pos_20") and ok
	ok = Assertions.assert_equal(sim.dat_0001b880, 0xF00D, "player b880") and ok
	ok = Assertions.assert_equal(spawn.get_u16_field("field_614"), 1, "614 latch") and ok
	return ok

## [RECONSTRUCTED] FUN_00019430 → 05116 → fields → 0xd vertex loop (23077–23114).
func _test_fun_00019430_via_05116_pool() -> bool:
	var sim := SimCoreScript.new(0x19430)
	sim.mission_phase_a8 = 1
	sim.mission_flag_ac = 1
	sim.dat_0001b838 = 0x55AA00FF
	const SHOOTER_WORLD := 0x7C70
	const D6FC := 0x4200
	const TABLE := 0x6200
	const SPAWN_WORLD := 0x8200
	const VERT_BASE := 0x9000
	sim.dat_0001d6fc = D6FC
	sim.dat_0001d6fc_slot_count = 1
	sim.mem_u32[D6FC + 0x30] = TABLE
	sim.mem_u32[TABLE + 0x14] = 0
	sim.dat_00026780 = 0x26780
	sim.mem_u32[0x26780 + 1] = 1  # desc[1]≠0 → vtable +8
	sim.spawn_05116_world_obj = SPAWN_WORLD
	## world+0x44 is vertex table ptr (also nonzero success gate) — fixture, not heap.
	sim.spawn_04e6e_use_mock_ptrs = true
	sim.spawn_04e6e_ptr_4c = 0x4C00
	sim.spawn_05116_world_field_44 = VERT_BASE
	sim.spawn_05116_entity_handle = 0x1943
	for i in range(0xD):
		sim.mem_u32[VERT_BASE + i * 0xC + 0] = 0x40
		sim.mem_u32[VERT_BASE + i * 0xC + 4] = 0x80
		sim.mem_u32[VERT_BASE + i * 0xC + 8] = 0x100
	sim.mem_u32[SHOOTER_WORLD + 0x18] = 1
	sim.mem_u32[SHOOTER_WORLD + 0x1c] = 2
	sim.mem_u32[SHOOTER_WORLD + 0x20] = 3
	var spawn := EntityStateScript.new()
	sim.spawn_19430_entity = spawn
	var e := EntityStateScript.new()
	var tmpl = EntityTemplateScript.new()
	tmpl.set_s16_field("field_34", 0x200)
	tmpl.set_s16_field("field_36", 0x600)
	tmpl.set_s16_field("field_40", 0)
	tmpl.set_s16_field("field_22", 0)
	tmpl.set_s16_field("field_24", 0)
	e.external_template = tmpl
	e.world_obj_ptr = SHOOTER_WORLD
	e.set_u8_field("field_63e", 1)
	e.set_u8_field("field_0b", 0)
	e.set_s8_field("direction_char_679", 0x2D)
	e.set_s8_field("field_677", 1)
	e.set_u8_field("flags_685", 0)
	e.set_u16_field("pos_20", 0x10)
	e.set_u16_field("attitude_22", 0x20)
	e.set_s16_field("field_24", 0x30)
	e.set_field("pos_2e", 50000)
	e.set_s16_field("movement_626", 0)
	e.set_s16_field("movement_662", 0)
	e.set_field("movement_62a", 0x2222)
	e.set_s8_field("weapon_count_67d", 1)
	e.set_s16_field("field_18c", 0)
	sim.entity_array_2.append(e)
	sim.tick()
	var ok := Assertions.assert_equal(sim.last_19430_result, 0x1943, "entity handle")
	ok = Assertions.assert_equal(sim.last_05116_result, SPAWN_WORLD, "05116 via 26780") and ok
	ok = Assertions.assert_equal(int(spawn.get_field("field_610")), 0x55AA00FF, "610=b838") and ok
	var fired_speed: int = int(sim.last_19430_args.get("speed", -1)) & 0xFFFF
	ok = Assertions.assert_equal(spawn.get_u16_field("field_614"), fired_speed, "614=speed") and ok
	ok = Assertions.assert_equal(spawn.get_u16_field("pos_20"), 0x10, "pos_20") and ok
	ok = Assertions.assert_equal(int(spawn.get_field("field_618")), 7, "618=7") and ok
	ok = Assertions.assert_equal(spawn.get_u16_field("field_61c"), 0x62, "61c=0x62") and ok
	ok = Assertions.assert_equal(int(sim.mem_u32.get(VERT_BASE + 0, -1)), 0x40 >> 3, "vert x>>3") and ok
	ok = Assertions.assert_equal(int(spawn.vertex_scale_622[0]), (0x40 >> 3) * 0x1C6, "622 scale") and ok
	ok = Assertions.assert_equal(int(spawn.vertex_scale_656[0]), (0x80 >> 3) * 0x1C6, "656 scale") and ok
	ok = Assertions.assert_equal(int(spawn.vertex_scale_68a[0]), (0x100 >> 3) * 0x255, "68a scale") and ok
	ok = Assertions.assert_equal(spawn.vertex_scale_622.size(), 0xD, "13 scaled") and ok
	ok = Assertions.assert_equal(sim.dat_0001b87c, 0x1943, "player b87c") and ok
	ok = Assertions.assert_equal(e.get_s8_field("field_677"), 2, "677←2") and ok
	return ok

## [RECONSTRUCTED] FUN_00015d20 → 15bf6 locals/writes (20133–20141, 20088–20125).
func _test_fun_00015d20_via_15bf6() -> bool:
	var sim := SimCoreScript.new(0x15D20)
	sim.mission_phase_a8 = 1
	sim.mission_flag_ac = 1
	sim.rng.reset_linear_fixture()
	const WORLD_OBJ := 0x7C80
	sim.mem_u32[WORLD_OBJ + 0x18] = 100
	sim.mem_u32[WORLD_OBJ + 0x1c] = 200
	sim.mem_u32[WORLD_OBJ + 0x20] = 300
	var spawn := EntityStateScript.new()
	sim.spawn_15bf6_entity = spawn
	sim.spawn_15bf6_handle = 0x15D2
	var e := EntityStateScript.new()
	var tmpl = EntityTemplateScript.new()
	tmpl.set_s16_field("field_34", 0x200)
	tmpl.set_s16_field("field_36", 0x600)
	tmpl.set_s16_field("field_40", 0)
	tmpl.set_s16_field("field_22", 0)
	tmpl.set_s16_field("field_24", 0)
	tmpl.set_s16_field("field_44", 0)
	e.external_template = tmpl
	e.world_obj_ptr = WORLD_OBJ
	e.set_u8_field("field_63e", 1)
	e.set_u8_field("field_0b", 0)
	e.set_s8_field("direction_char_679", 0x2D)
	e.set_s8_field("field_676", 1)
	e.set_s16_field("field_682", 4)
	e.set_u8_field("flags_685", 0)
	e.set_field("pos_2e", 50000)
	e.set_s16_field("movement_626", 0)
	e.set_s16_field("movement_662", 0)
	e.set_field("movement_62a", 0x100 << 2)
	e.set_s8_field("weapon_count_67d", 1)
	e.set_s16_field("field_18c", 0)
	sim.entity_array_2.append(e)
	sim.tick()
	var ok := Assertions.assert_equal(sim.last_15d20_result, 0x15D2, "15d20 handle")
	ok = Assertions.assert_true(sim.last_weapon_676_fired, "676 fired") and ok
	ok = Assertions.assert_equal(spawn.get_u16_field("count_3a"), 2, "3a=2 (param2=1)") and ok
	ok = Assertions.assert_equal(spawn.get_u16_field("field_38"), 0, "38 cleared") and ok
	ok = Assertions.assert_equal(spawn.get_u16_field("field_36"), 1, "player [0x1b]=1") and ok
	ok = Assertions.assert_true(sim.last_15bf6_locals.has("local_6"), "locals recorded") and ok
	ok = Assertions.assert_true(bool(sim.last_15bf6_locals.get("applied_028dc", false)), "0262e→028dc") and ok
	ok = Assertions.assert_equal(spawn.attitude_matrix_40.size(), 9, "1a63e matrix size") and ok
	## Zero angles → identity matrix copied to +0x40.
	ok = Assertions.assert_equal(int(spawn.attitude_matrix_40[0]), 0x1000, "1a63e[0]") and ok
	ok = Assertions.assert_equal(int(spawn.attitude_matrix_40[4]), 0x1000, "1a63e[4]") and ok
	ok = Assertions.assert_equal(int(sim.last_15d20_args.get("param_2", -1)), 1, "param_2=1") and ok
	return ok

## [RECONSTRUCTED] field_676/677 fire gates + stubs (14673–14719).
func _test_fun_0000e792_weapon_676_677_branch() -> bool:
	var sim := SimCoreScript.new(0x6761)
	sim.mission_phase_a8 = 1
	sim.mission_flag_ac = 1
	const WORLD_OBJ := 0x7C50
	sim.mem_u32[WORLD_OBJ + 0x18] = 7
	sim.mem_u32[WORLD_OBJ + 0x1c] = 1000
	sim.mem_u32[WORLD_OBJ + 0x20] = 9
	var e := EntityStateScript.new()
	var tmpl = EntityTemplateScript.new()
	tmpl.set_s16_field("field_34", 0x200)
	tmpl.set_s16_field("field_36", 0x600)
	tmpl.set_s16_field("field_40", 0)
	tmpl.set_s16_field("field_22", 0)
	tmpl.set_s16_field("field_24", 0)
	tmpl.set_s16_field("field_44", 0x10)
	e.external_template = tmpl
	e.world_obj_ptr = WORLD_OBJ
	e.set_u8_field("field_63e", 1)
	e.set_u8_field("field_0b", 0)
	e.set_s8_field("direction_char_679", 0x2D)
	e.set_s8_field("field_676", 1)
	e.set_s16_field("field_682", 6)
	e.set_u8_field("flags_685", 0)
	e.set_field("pos_2e", 50000)
	e.set_s16_field("movement_626", 0x50)
	e.set_s16_field("movement_662", 0)
	e.set_field("movement_62a", 0x100 << 2)
	e.set_s8_field("weapon_count_67d", 1)
	e.set_s16_field("field_18c", 0)
	sim.entity_array_1.append(e)
	sim.tick()
	var ok := Assertions.assert_true(sim.last_weapon_676_fired, "676 fired")
	ok = Assertions.assert_true(sim.last_weapon_676_need_15d20, "15d20 stub") and ok
	ok = Assertions.assert_equal(e.get_s8_field("field_676"), 2, "676 1→2") and ok
	ok = Assertions.assert_equal(e.get_s16_field("field_682"), 4, "682 6→4") and ok
	## yaw_arg uses post-626-step movement_626 (often rewritten before fire)
	var expect_yaw: int = (e.get_s16_field("movement_626") - 0x10) & 0x3FFF
	ok = Assertions.assert_equal(int(sim.last_15d20_args.get("yaw_arg", -1)), expect_yaw, "yaw=626-44") and ok
	ok = Assertions.assert_equal(int(sim.last_15d20_args.get("param_2", -1)), 1, "15d20 param_2=1") and ok
	## player 677==1 → b874 / d858=9 / status|1
	var e2 := EntityStateScript.new()
	e2.external_template = tmpl
	e2.world_obj_ptr = WORLD_OBJ
	e2.set_u8_field("field_63e", 1)
	e2.set_u8_field("field_0b", 0)
	e2.set_s8_field("direction_char_679", 0x2D)
	e2.set_s8_field("field_677", 1)
	e2.set_u8_field("flags_685", 0)
	e2.set_u16_field("status_1a1", 0)
	e2.set_s8_field("weapon_count_67d", 1)
	e2.set_field("pos_2e", 50000)
	e2.set_s16_field("movement_626", 0)
	e2.set_s16_field("movement_662", 0)
	e2.set_field("movement_62a", 0x100 << 2)
	e2.set_s16_field("field_18c", 0)
	sim.entity_array_1.clear()
	sim.entity_array_2.clear()
	sim.entity_array_2.append(e2)
	sim.tick()
	ok = Assertions.assert_true(sim.last_weapon_677_fired, "677 fired") and ok
	ok = Assertions.assert_equal(e2.get_s8_field("field_677"), 2, "677←2") and ok
	ok = Assertions.assert_equal(e2.get_u16_field("status_1a1") & 1, 1, "status|1") and ok
	ok = Assertions.assert_equal(sim.dat_0001b874, 1, "player b874") and ok
	ok = Assertions.assert_equal(sim.dat_0001d858, 9, "d858=9") and ok
	ok = Assertions.assert_equal(sim.dat_0001b87a, 1, "b87a") and ok
	return ok

## [RECONSTRUCTED] grounded field_0b bVar6 → cleanup epilogue (14736–14748).
func _test_fun_0000e792_bvar6_cleanup() -> bool:
	var sim := SimCoreScript.new(0xB6C6)
	sim.mission_phase_a8 = 1
	sim.mission_flag_ac = 1
	const WORLD_OBJ := 0x7C60
	sim.mem_u32[WORLD_OBJ + 0x1c] = 1000
	var e := EntityStateScript.new()
	var tmpl = EntityTemplateScript.new()
	tmpl.set_s16_field("field_34", 0x200)
	tmpl.set_s16_field("field_36", 0x600)
	tmpl.set_s16_field("field_40", 0)
	tmpl.set_s16_field("field_22", 0)
	tmpl.set_s16_field("field_24", 0)
	e.external_template = tmpl
	e.world_obj_ptr = WORLD_OBJ
	e.set_u8_field("field_63e", 1)
	e.set_u8_field("field_0b", 0x20)  # ' ' → bVar6 when status&8==0
	e.set_u16_field("status_1a1", 0x0002)
	e.set_s16_field("status_1a2", 0x20)
	e.set_s16_field("movement_61a", 0x55)
	e.set_s16_field("movement_61e", 0x66)
	e.set_field("state_32", 0)
	e.set_s8_field("direction_char_679", 0x2D)
	e.set_field("pos_2e", 50000)
	e.set_s16_field("movement_626", 0)
	e.set_s16_field("movement_662", 0)
	e.set_field("movement_62a", 0x100 << 2)
	e.set_s8_field("weapon_count_67d", 1)
	e.set_s16_field("field_18c", 0)
	sim.entity_array_1.append(e)
	sim.tick()
	var ok := Assertions.assert_true(sim.e792_b_var6, "bVar6 from space")
	ok = Assertions.assert_true(sim.last_bvar6_cleanup_applied, "cleanup applied") and ok
	ok = Assertions.assert_equal(e.get_u16_field("status_1a1"), 0x900, "status→0x900") and ok
	ok = Assertions.assert_equal(e.get_s16_field("status_1a2"), 0, "1a2 cleared") and ok
	ok = Assertions.assert_equal(e.get_field("state_32"), 0xE772, "state_32") and ok
	ok = Assertions.assert_equal(e.get_s16_field("movement_61a"), 0, "61a cleared") and ok
	ok = Assertions.assert_equal(e.get_s16_field("movement_61e"), 0, "61e cleared") and ok
	return ok

## [INFERRED] flags_685&2 via 11544-callsite ≡ 11564 (14721–14734).
func _test_fun_0000e792_flags685_bit2_tail() -> bool:
	var sim := SimCoreScript.new(0x6852)
	sim.mission_phase_a8 = 1
	sim.mission_flag_ac = 1
	## Force deterministic draws: linear fixture after warm-up bypass
	sim.rng.reset_linear_fixture()
	const WORLD_OBJ := 0x7C70
	sim.mem_u32[WORLD_OBJ + 0x1c] = 1000
	var e := EntityStateScript.new()
	var tmpl = EntityTemplateScript.new()
	tmpl.set_s16_field("field_34", 0x200)
	tmpl.set_s16_field("field_36", 0x600)
	tmpl.set_s16_field("field_40", 0)
	tmpl.set_s16_field("field_22", 0)
	tmpl.set_s16_field("field_24", 0)
	e.external_template = tmpl
	e.world_obj_ptr = WORLD_OBJ
	e.set_u8_field("field_63e", 1)
	e.set_u8_field("field_0b", 0)
	e.set_s8_field("direction_char_679", 0x2D)
	e.set_u8_field("flags_685", 2)
	e.set_s8_field("weapon_count_67d", 3)
	e.set_s8_field("weapon_count_67e", 4)
	e.set_field("pos_2e", 50000)
	e.set_s16_field("movement_626", 0)
	e.set_s16_field("movement_662", 0)
	e.set_field("movement_62a", 0x100 << 2)
	e.set_s16_field("field_18c", 0)
	sim.entity_array_1.append(e)
	sim.tick()
	var ok := Assertions.assert_true(sim.last_flags685_bit2_active, "bit2 active")
	ok = Assertions.assert_true(sim._rng_draws_this_tick >= 1, "consumed callsite draw") and ok
	## Exact 67d/67e branch covered in unit tests with injected draws.
	ok = Assertions.assert_true(
		e.get_s8_field("weapon_count_67d") <= 3 and e.get_s8_field("weapon_count_67e") <= 4,
		"ammo not increased"
	) and ok
	return ok

## [RECONSTRUCTED] gentle landing → player DAT_0001b856=1 (14464–14471).
func _test_fun_0000e792_landing_gentle_b856() -> bool:
	var sim := SimCoreScript.new(0x63E2)
	sim.mission_phase_a8 = 1
	sim.mission_flag_ac = 1
	const WORLD_OBJ := 0x7900
	sim.mem_u32[WORLD_OBJ + 0x1c] = 1000
	var e := EntityStateScript.new()
	var tmpl = EntityTemplateScript.new()
	tmpl.set_s16_field("field_34", 0x200)
	tmpl.set_s16_field("field_36", 0x600)
	tmpl.set_s16_field("field_40", 50)
	tmpl.set_s16_field("field_22", 0)
	tmpl.set_s16_field("field_24", 0)
	e.external_template = tmpl
	e.world_obj_ptr = WORLD_OBJ
	e.set_u8_field("field_63e", 0)
	e.set_s8_field("direction_char_679", 0x2D)
	e.set_field("pos_2e", 900)
	e.set_s16_field("attitude_0e", 0)
	e.set_u16_field("pos_20", 0)
	e.set_s16_field("field_24", 0)
	e.set_u16_field("status_1a1", 0)
	e.set_u16_field("field_18e", 0x55)
	e.set_s16_field("movement_626", 0)
	e.set_s16_field("movement_662", 0)
	e.set_s16_field("movement_666", 0)
	e.set_field("movement_62a", 0x100 << 2)
	e.set_s8_field("weapon_count_67d", 1)
	e.set_s16_field("field_18c", -3840)
	## tick() sets designated_player_entity from entity_array_2[0].
	sim.entity_array_2.append(e)
	sim.tick()
	var ok := Assertions.assert_true(sim.last_63e_landing_applied, "gentle landing applied")
	ok = Assertions.assert_true(not sim.last_landing_rough, "not rough") and ok
	ok = Assertions.assert_equal(sim.dat_0001b856, 1, "player DAT_0001b856") and ok
	ok = Assertions.assert_equal(sim.dat_0001b868, 1, "player DAT_0001b868") and ok
	ok = Assertions.assert_equal(e.get_u16_field("field_18e"), 0, "18e cleared") and ok
	return ok

## [RECONSTRUCTED] hard-crash pos_2e==0 → FUN_00013452 → field_0b (14456–14458).
func _test_fun_0000e792_landing_13452() -> bool:
	var sim := SimCoreScript.new(0x13452)
	sim.mission_phase_a8 = 1
	sim.mission_flag_ac = 1
	const WORLD_OBJ := 0x7A00
	## Surface 100: with field_40=50, iVar23=50 → same pvc<-50 gate as other landing fixtures
	## after position commit overwrites pvc (commit runs before 63e).
	sim.mem_u32[WORLD_OBJ + 0x18] = 0x1111
	sim.mem_u32[WORLD_OBJ + 0x1c] = 100
	sim.mem_u32[WORLD_OBJ + 0x20] = 0x3333
	sim.dat_0001c1e0_count = 0
	sim.dat_0001bda8_plus_16 = 0x70
	var e := EntityStateScript.new()
	var tmpl = EntityTemplateScript.new()
	tmpl.set_s16_field("field_34", 0x200)
	tmpl.set_s16_field("field_36", 0x600)
	tmpl.set_s16_field("field_40", 50)
	tmpl.set_s16_field("field_22", 0)
	tmpl.set_s16_field("field_24", 0)
	e.external_template = tmpl
	e.world_obj_ptr = WORLD_OBJ
	e.set_u8_field("field_63e", 0)
	e.set_s8_field("direction_char_679", 0x2D)
	e.set_field("pos_2e", 0)
	e.set_s16_field("attitude_0e", -23)
	e.set_u16_field("status_1a1", 0)
	e.set_u8_field("field_0b", 0)
	e.set_s16_field("movement_626", 0)
	e.set_s16_field("movement_662", 0)
	e.set_field("movement_62a", 0x100 << 2)
	e.set_s8_field("weapon_count_67d", 1)
	e.set_s16_field("field_18c", -3840)
	sim.entity_array_1.append(e)
	sim.tick()
	var ok := Assertions.assert_true(sim.last_landing_hard_crash, "hard crash")
	ok = Assertions.assert_true(sim.last_landing_need_13452, "need 13452") and ok
	ok = Assertions.assert_equal(int(sim.last_13452_args.get("x_18", -1)), 0x1111, "13452 x from world+0x18") and ok
	ok = Assertions.assert_equal(int(sim.last_13452_args.get("y_1c", -1)), 100, "13452 y from world+0x1c") and ok
	ok = Assertions.assert_equal(int(sim.last_13452_args.get("z_20", -1)), 0x3333, "13452 z from world+0x20") and ok
	ok = Assertions.assert_equal(sim.last_13452_result, 0x70, "13346 empty-list result") and ok
	ok = Assertions.assert_equal(e.get_u8_field("field_0b"), 0x70, "field_0b from 13452") and ok
	return ok

## [RECONSTRUCTED] hard-landing pitch → status|0x400 (14450–14454).
func _test_fun_0000e792_landing_hard_crash() -> bool:
	var sim := SimCoreScript.new(0x63E1)
	sim.mission_phase_a8 = 1
	sim.mission_flag_ac = 1
	const WORLD_OBJ := 0x7900
	sim.mem_u32[WORLD_OBJ + 0x1c] = 1000
	var e := EntityStateScript.new()
	var tmpl = EntityTemplateScript.new()
	tmpl.set_s16_field("field_34", 0x200)
	tmpl.set_s16_field("field_36", 0x600)
	tmpl.set_s16_field("field_40", 50)
	tmpl.set_s16_field("field_22", 0)
	tmpl.set_s16_field("field_24", 0)
	e.external_template = tmpl
	e.world_obj_ptr = WORLD_OBJ
	e.set_u8_field("field_63e", 0)
	e.set_s8_field("direction_char_679", 0x2D)
	e.set_field("pos_2e", 900)
	e.set_s16_field("attitude_0e", -23)
	e.set_u16_field("status_1a1", 0)
	e.set_u16_field("field_18e", 0x1234)
	e.set_s16_field("movement_626", 0)
	e.set_s16_field("movement_662", 0)
	e.set_field("movement_62a", 0x100 << 2)
	e.set_s8_field("weapon_count_67d", 1)
	e.set_s16_field("field_18c", -3840)
	sim.entity_array_1.append(e)
	sim.tick()
	var ok := Assertions.assert_true(sim.last_63e_landing_applied, "hard landing still touches down")
	ok = Assertions.assert_true(sim.last_landing_hard_crash, "hard crash flagged") and ok
	ok = Assertions.assert_true((e.get_u16_field("status_1a1") & 0x400) != 0, "status|0x400") and ok
	ok = Assertions.assert_true(sim.last_landing_early_return, "early return") and ok
	ok = Assertions.assert_equal(e.get_u16_field("field_18e"), 0x1234, "18e not cleared on hard crash") and ok
	return ok

## [RECONSTRUCTED] e4a4 + e468 linear drag in SimCore (14344–14361).
func _test_fun_0000e792_e4a4_linear_drag() -> bool:
	var sim := SimCoreScript.new(0xEDF8)
	sim.mission_phase_a8 = 1
	sim.mission_flag_ac = 1
	const WORLD_OBJ := 0x7300
	sim.mem_u32[WORLD_OBJ + 0x1c] = 0
	var e := EntityStateScript.new()
	var tmpl = EntityTemplateScript.new()
	tmpl.set_s16_field("field_34", 0x200)
	tmpl.set_s16_field("field_36", 0x600)
	tmpl.set_s16_field("field_28", 0x400)
	tmpl.set_s16_field("field_22", 0x100)
	tmpl.set_s16_field("field_24", 0x50)
	tmpl.set_s16_field("field_20", 0x10)
	e.external_template = tmpl
	e.world_obj_ptr = WORLD_OBJ
	e.set_field("pos_2e", 0x100)
	## 626 step leaves 0x100 unchanged: s21=(0x100*0x200)>>9=0x100, err=0.
	e.set_s16_field("movement_626", 0x100)
	e.set_s16_field("movement_662", 0x100)
	e.set_field("movement_62a", 0x500 << 2)
	e.set_s8_field("weapon_count_67d", 1)
	e.set_s16_field("movement_63a", 0)
	e.set_s16_field("movement_636", 0)
	e.set_u8_field("field_19e", 0)
	sim.entity_array_1.append(e)
	sim.tick()
	var ok := Assertions.assert_equal(sim.last_drag_e468, -12402, "SimCore drag e468 divisor")
	ok = Assertions.assert_equal(e.get_s16_field("movement_63a"), 0x1000, "SimCore writes movement_63a from e4a4") and ok
	ok = Assertions.assert_equal(e.get_u8_field("field_19e"), 0, "no overspeed countdown") and ok
	ok = Assertions.assert_equal(sim.last_drag_ivar10, -422, "SimCore last_drag_ivar10") and ok
	ok = Assertions.assert_equal(sim.last_drag_quadratic_raw, -10561, "SimCore quadratic e468 raw") and ok
	ok = Assertions.assert_equal(sim.last_thrust_quad_term, -8, "SimCore thrust quad_term") and ok
	ok = Assertions.assert_equal(e.get_s16_field("movement_636"), 0, "SimCore writes movement_636") and ok
	## End-of-tick 62a is airborne e372 recommit (14486–14613), not the pre-commit thrust value.
	ok = Assertions.assert_true(sim.last_airborne_speed_recommit, "airborne e372 recommit") and ok
	var le: int = int(sim.last_pos_commit.get("local_e", 0))
	var la: int = int(sim.last_pos_commit.get("local_a", 0))
	var l6: int = int(sim.last_pos_commit.get("local_6", 0))
	ok = Assertions.assert_equal(
		_as_s32(e.get_field("movement_62a")),
		FlightMathScript.fun_0000e372(le * le + la * la + l6 * l6),
		"movement_62a = e372 after commit"
	) and ok
	return ok

## [RECONSTRUCTED] movement_626 update for any entity past contact early-out (14248–14304).
func _test_fun_0000e792_movement_626_step() -> bool:
	var sim := SimCoreScript.new(0x6260)
	sim.mission_phase_a8 = 1
	sim.mission_flag_ac = 1
	var e := EntityStateScript.new()
	var tmpl = EntityTemplateScript.new()
	tmpl.set_s16_field("field_34", 0x200)
	tmpl.set_s16_field("field_36", 0x600)
	tmpl.set_s16_field("field_44", 0x100)
	e.external_template = tmpl
	e.set_s16_field("movement_662", 0x1000)
	e.set_s16_field("movement_626", 0x800)
	e.set_field("movement_62a", 0x500 << 2)
	sim.entity_array_1.append(e)
	sim.tick()
	return Assertions.assert_equal(
		e.get_s16_field("movement_626"),
		0x890,
		"SimCore applies movement_626 step (not designated-only)"
	)

func _test_simcore_uses_overlay_rng() -> bool:
	var sim := SimCoreScript.new(0)
	var state: Variant = sim.rng.get_state()
	var ok := Assertions.assert_true(state is Dictionary, "SimCore.rng get_state is overlay dict")
	ok = Assertions.assert_true(
		String((state as Dictionary).get("kind", "")) == "FUN_00011564",
		"SimCore.rng is FUN_00011564 overlay"
	) and ok
	ok = Assertions.assert_true(sim.rng_id05 != null, "ID05 Rng68k retained on rng_id05") and ok
	var e := EntityStateScript.new()
	e.set_u8_field("flags_685", 0x04)
	sim.mission_phase_a8 = 1
	sim.mission_flag_ac = 1
	sim.entity_array_1.append(e)
	var before: int = int((sim.rng.get_state() as Dictionary).get("cursor_index", -1))
	sim.tick()
	var after: int = int((sim.rng.get_state() as Dictionary).get("cursor_index", -1))
	ok = Assertions.assert_true(after != before, "overlay cursor advances on flags_685 draw") and ok
	return ok
