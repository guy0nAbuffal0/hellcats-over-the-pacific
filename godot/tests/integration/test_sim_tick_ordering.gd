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
	ok = _test_fun_00012840_via_05116_pool() and ok
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
	sim.entity_array_1.append(below)
	sim.tick()
	var ok := Assertions.assert_true(
		_as_s32(below.get_field("position_velocity_c")) == -0x16,
		"contact below surface sets pvc to -0x16"
	)
	ok = Assertions.assert_true(below.get_u8_field("movement_669") == 0, "contact clears movement_669") and ok
	ok = Assertions.assert_true(
		int(sim.get_last_tick_order().get("rng_draws_this_tick", -1)) == 0,
		"contact early-out skips flags_685 RNG slice"
	) and ok

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
	sim.fun_00001d56_scale = 0x1000
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
	sim.mem_u32[D6FC + 0x30] = TABLE
	sim.mem_u32[TABLE + 0x14] = 0x1111  # slot0 occupied
	sim.mem_u32[TABLE + 0x18 + 0x14] = 0  # slot1 free
	sim.spawn_05116_world_obj = WORLD
	sim.spawn_05116_world_field_44 = 1
	sim.spawn_05116_entity_handle = 0xC0DE
	var r: int = sim._call_fun_00005116(0x26280, 10, 20, 30, 0xA, 0xB, 0xC, 0xD)
	var ok := Assertions.assert_equal(r, WORLD, "returns world obj")
	ok = Assertions.assert_equal(sim.last_05116_slot_index, 1, "used free slot1") and ok
	var slot1: int = TABLE + 0x18
	ok = Assertions.assert_equal(int(sim.mem_u32.get(slot1 + 0, -1)), 0xD, "p8") and ok
	ok = Assertions.assert_equal(int(sim.mem_u32.get(slot1 + 2, -1)), 0xA, "p5") and ok
	ok = Assertions.assert_equal(int(sim.mem_u32.get(slot1 + 8, -1)), 10, "x") and ok
	ok = Assertions.assert_equal(int(sim.mem_u32.get(slot1 + 0x14, -1)), WORLD, "046da mock") and ok
	ok = Assertions.assert_equal(int(sim.mem_u32.get(WORLD + 8, -1)), 0xC0DE, "world+8") and ok
	## full pool → grow deferred → 0
	sim.mem_u32[TABLE + 0x14] = 1
	sim.mem_u32[TABLE + 0x18 + 0x14] = 2
	r = sim._call_fun_00005116(0, 0, 0, 0, 0, 0, 0, 0)
	ok = Assertions.assert_equal(r, 0, "full → 0") and ok
	ok = Assertions.assert_true(sim.last_05116_need_grow, "need grow") and ok
	## +0x44==0 → fail + clear slot
	sim.mem_u32[TABLE + 0x14] = 0
	sim.spawn_05116_world_field_44 = 0
	r = sim._call_fun_00005116(0, 1, 2, 3, 0, 0, 0, 0)
	ok = Assertions.assert_equal(r, 0, "44==0 fail") and ok
	ok = Assertions.assert_true(sim.last_05116_need_051ec, "need 051ec") and ok
	ok = Assertions.assert_equal(int(sim.mem_u32.get(TABLE + 0x14, -1)), 0, "slot cleared") and ok
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
