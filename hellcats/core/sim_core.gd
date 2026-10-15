class_name SimCore
extends RefCounted
## Deterministic sim tick loop; no rendering.
## [RECONSTRUCTED] Update order matches FUN_000044e8 (Pacific Conflict.c:5096–5144): four entity passes + FUN_00006fb8.

const Rng68kScript := preload("res://hellcats/core/rng.gd")
const RngOverlay11564Script := preload("res://hellcats/core/rng_overlay_11564.gd")
const EntityStateScript := preload("res://hellcats/core/entity_state.gd")
const LoaderMetadataScript := preload("res://hellcats/core/loader_metadata.gd")
const FlightMathScript := preload("res://hellcats/core/flight_math.gd")

## [RECONSTRUCTED] Pass ids align with iteration order in FUN_000044e8 (array symbols).
const PASS_DAT_0001D4A4 := 1
const PASS_DAT_0001B5A4 := 2
const PASS_DAT_0001D0E4 := 3
const PASS_DAT_0001CBE4 := 4

## Mission state (proven offsets from DAT_0001b5a0)
var mission_phase_a8: int = 0
var mission_flag_ac: int = 0
## [RECONSTRUCTED] *(DAT_0001b5a0 + 0x90) — gates field_18d recoil on fire (14661).
var mission_short_90: int = 0

## Entity arrays: order and counts match FUN_000044e8 (elements are EntityState).
var entity_array_1: Array = []  # DAT_0001d4a4, count DAT_0001c1e0
var entity_array_2: Array = []  # DAT_0001b5a4, count DAT_0001b734
var entity_array_3: Array = []  # DAT_0001d0e4, count DAT_0001c1dc
var entity_array_4: Array = []  # DAT_0001cbe4, count DAT_0001c1d8

## Loader-derived metadata table (ID00/loader chain). Proven targets only; no runtime relocation implied.
var loader_metadata: RefCounted

## [RECONSTRUCTED] Entity-update draws use FUN_00011564 (overlay table RNG).
var rng: RefCounted
## ID05 LCG kept for segment-local experiments; not used by _rng_consume().
var rng_id05: RefCounted

## Input packet for this frame (key/button events; enqueue per frame)
var input_packet: Dictionary = {}

## Per-frame trace (optional): each element is a Dictionary for that tick.
var trace_enabled: bool = false
var _trace: Array = []

## [RECONSTRUCTED] FUN_000044a4 second argument: 0 for arrays 1–2, 1 for arrays 3–4 (Pacific Conflict.c:5109–5139).
## Exposed for ordering tests and future FUN_0000435a path splits.
var last_pass_param_2: int = -1
var last_pass_id: int = -1

## Last tick ordering summary (always updated in tick()). See docs/contracts/tick_FUN_000044e8_contract.md
var last_tick_order: Dictionary = {}

## When true, last_tick_order includes player snapshots and rng_state (QA cost).
var tick_order_trace_enabled: bool = false

var _tick_count: int = 0

## [RECONSTRUCTED] Count of rng.next() calls this tick (RNG timing / parity). Reset each tick().
var _rng_draws_this_tick: int = 0

## [RECONSTRUCTED] Entities updated per FUN_000044a4 param_2 (0 vs 1) this tick. See docs/contracts/FUN_0000435a_contract.md.
var _param_2_entity_updates: Dictionary = {0: 0, 1: 0}

## Designated entity refs (DAT_0001b738 / DAT_0001b888). Only these receive 0x66e/0x672/0x66a updates (Pacific Conflict.c:14179).
var designated_player_entity: RefCounted = null
var designated_target_entity: RefCounted = null

## [RECONSTRUCTED] FUN_00006fb8 (Pacific Conflict.c:7180–7189) writes 100000000 into six globals.
## [INFERRED] Used later as large sentinels / distance bases (see uses of DAT_0001d71c / DAT_0001d724); role not fully named.
const FUN_00006FB8_RESET_VALUE: int = 100000000
var dat_0001d710: int = 0
var dat_0001d714: int = 0
var dat_0001d718: int = 0
var dat_0001d71c: int = 0
var dat_0001d720: int = 0
var dat_0001d724: int = 0

## [RECONSTRUCTED] FUN_00005df8 walks seven slots at DAT_0001bc64 (Pacific Conflict.c:6434–6447).
## Slot values are entity pointers in the original; here: EntityState or null.
var dat_0001bc64: Array = [null, null, null, null, null, null, null]
var _fun_00005df8_cleared_this_tick: int = 0
var _fun_0000528a_calls_this_tick: int = 0
var _fun_000051ec_calls_this_tick: int = 0
## Last FUN_0000528a path for tests: "", "skip_flag7", "call_051ec", "type02_alt".
var last_0528a_path: String = ""

## [RECONSTRUCTED] Globals read/written by FUN_0000528a / FUN_000051ec (Pacific Conflict.c:5751–5798).
var dat_0001d6fc: int = 0
var dat_0001b88e: int = 0
var dat_0001b88c: int = 0
var dat_0001b838: int = 0
var dat_0001b880: int = 0
var dat_00024cf0: int = 0
## [RECONSTRUCTED] Set when contact path ORs player status with 0x1000 (Pacific Conflict.c:14089–14091).
var dat_0001b850: int = 0
## [RECONSTRUCTED] Cleared for designated player on reverse-flight path (Pacific Conflict.c:14336–14338).
var dat_0001b858: int = 0
## [RECONSTRUCTED] Stall transition 1→2 when iVar25<1 for designated player (Pacific Conflict.c:14429–14431).
var dat_0001b868: int = 0
## [RECONSTRUCTED] Flat u32 address space for FUN_000051ec indirect stores (Pacific Conflict.c:5760, 5775–5777).
var mem_u32: Dictionary = {}
## [RECONSTRUCTED] Last FUN_0000e468 output from designated-player prep (asm −0x2A(A6)); not used by local_46/e570.
var last_e468_out: int = 0
## [RECONSTRUCTED] Last e42a input bits = *(world_obj+0x1c) (Pacific Conflict.c:14168 / asm 0xE9C2).
var last_e42a_input_u32: int = 0
## [RECONSTRUCTED] Last linear drag iVar10 (Pacific Conflict.c:14356–14361 / asm 0xEDF8).
var last_drag_ivar10: int = 0
## [RECONSTRUCTED] Last per-entity e468 used as drag DIVS divisor.
var last_drag_e468: int = 0
## [RECONSTRUCTED] Last quadratic e468 raw (after bias) and 0x636 thrust terms.
var last_drag_quadratic_raw: int = 0
var last_thrust_quad_term: int = 0
var last_thrust_term: int = 0
## [RECONSTRUCTED] Designated-player local_46/local_42 from smoothing; reverse local_48.
var last_local_46: int = 0
var last_local_42: int = 0
var last_reverse_local_48: int = 0
## [RECONSTRUCTED] Last 0x63e / 0x18e thrust delta and iVar25 subtract.
var last_63e_thrust_delta: int = 0
var last_18e_62a_delta: int = 0
## [RECONSTRUCTED] Last local_34 and stall application (14422–14433).
var last_local_34: int = 0
var last_stalled_this_tick: bool = false
## [RECONSTRUCTED] Last FUN_000025a8 matrix for FUN_000028dc (trig tables still [MVP APPROXIMATION]).
var attitude_matrix_9: Array = []
var last_626_local_48: int = 0
## [RECONSTRUCTED] Last position commit after 028dc (14441–14445).
var last_pos_commit: Dictionary = {}
## [RECONSTRUCTED] Last landing / airborne 63e transition (14446–14485).
var last_63e_landing_applied: bool = false
var last_63e_airborne_applied: bool = false
## [RECONSTRUCTED] Post-touchdown pitch follow-on (14450–14476).
var last_landing_hard_crash: bool = false
var last_landing_rough: bool = false
var last_landing_early_return: bool = false
var last_landing_need_13452: bool = false
var last_s_var22: int = 0
var last_landing_u_var13: int = 0
var last_landing_local_28: int = 0
var last_13452_args: Dictionary = {}
var last_13452_result: int = 0
var last_airborne_speed_sq: int = 0
var last_airborne_speed_recommit: bool = false
var last_grounded_speed_recommit: bool = false
var last_grounded_speed_sq: int = 0
var last_grounded_field_0b_early_return: bool = false
var last_grounded_b_var6: bool = false
## [RECONSTRUCTED] DAT_0001c1e0._2_2_ object-list count for FUN_00013346 (default empty).
var dat_0001c1e0_count: int = 0
## [RECONSTRUCTED] *(DAT_0001bda8 + 0x16) empty-list return byte for FUN_00013346.
var dat_0001bda8_plus_16: int = 0
## [RECONSTRUCTED] Soft-landing player flag (Pacific Conflict.c:14469–14470).
var dat_0001b856: int = 0
## [RECONSTRUCTED] Grounded '@' / player flag (Pacific Conflict.c:14533–14538).
var dat_0001b854: int = 0
## [RECONSTRUCTED] Player speed ring at LAB_0000f47c (Pacific Conflict.c:14614–14629).
var dat_0001bc8c: Array = []
var dat_0001bc80: int = 0
var dat_0001bc84: int = 0
## [UNKNOWN] FUN_00001d56 Ghidra body unusable; callers use return as s16 scale (0x1000≈1.0).
var fun_00001d56_scale: int = 0x1000
var last_f47c_applied: bool = false
var last_f47c_field_24: int = 0
var last_f47c_ring_value: int = 0
var last_char_epilogue_bumped_67b: bool = false
var last_char_epilogue_bumped_679: bool = false
var last_weapon_19d_fired: bool = false
var last_weapon_19d_need_12840: bool = false
var last_12840_args: Dictionary = {}
var last_12840_result: int = 0
## [INFERRED] Mock *(FUN_00005116+8) until allocator ported. Null → 12840 returns 0.
var spawn_12840_entity: RefCounted = null
## Fake entity handle returned when spawn_12840_entity is set (stand-in pointer).
var spawn_12840_handle: int = 0x12840
## [RECONSTRUCTED] FUN_00005116 pool: count at DAT_0001d6fc+0x2e; table at +0x30.
var dat_0001d6fc_slot_count: int = 0
## Mock 046da install: world obj written to free slot+0x14; +0x44 gate; +8 → entity handle.
var spawn_05116_world_obj: int = 0
var spawn_05116_world_field_44: int = 1
var spawn_05116_entity_handle: int = 0
var last_05116_slot_index: int = -1
var last_05116_result: int = 0
var last_05116_need_grow: bool = false
var last_05116_need_051ec: bool = false
var dat_00026280: int = 0
var last_weapon_676_fired: bool = false
var last_weapon_676_need_15d20: bool = false
var last_15d20_args: Dictionary = {}
var last_15d20_result: int = 0
var last_weapon_677_fired: bool = false
var last_weapon_677_need_19430: bool = false
var last_19430_args: Dictionary = {}
var last_19430_result: int = 0
## [RECONSTRUCTED] FUN_0000e792 bVar6 (rough landing / grounded field_0b); cleanup at 14736.
var e792_b_var6: bool = false
var last_bvar6_cleanup_applied: bool = false
var last_flags685_bit2_active: bool = false
var last_flags685_bit2_dec_67d: bool = false
var last_flags685_bit2_dec_67e: bool = false
## [DEFERRED] Player DAT_0001b846 latch from FUN_00012840 (Pacific Conflict.c:14655–14658).
## dat_0001b880 already declared above (entity_data_ptr clear path).
var dat_0001b846: int = 0
## [RECONSTRUCTED] Player weapon globals from field_677 fire (14695–14712).
var dat_0001b874: int = 0
var dat_0001b872: int = 0
var dat_0001d858: int = 0
var dat_0001b87a: int = 0
var dat_0001b87c: int = 0
var last_airborne_local_28: int = 0
var last_airborne_local_2a: int = 0
var last_grounded_local_28: int = 0

func _init(initial_rng_seed: int = 0) -> void:
	rng = RngOverlay11564Script.new(initial_rng_seed)
	rng_id05 = Rng68kScript.new()
	rng_id05.seed(initial_rng_seed)
	loader_metadata = LoaderMetadataScript.new()
	dat_0001bc64 = [null, null, null, null, null, null, null]
	dat_0001bc8c.clear()
	for _i in range(0x78):
		dat_0001bc8c.append(0)
	attitude_matrix_9 = FlightMathScript.identity_matrix_9()

## One deterministic sim tick. No delta; fixed-step.
func tick() -> void:
	_tick_count += 1
	_rng_draws_this_tick = 0
	_param_2_entity_updates = {0: 0, 1: 0}
	_fun_00005df8_cleared_this_tick = 0
	_fun_0000528a_calls_this_tick = 0
	_fun_000051ec_calls_this_tick = 0
	last_0528a_path = ""
	designated_player_entity = entity_array_2[0] if entity_array_2.size() > 0 else null
	var input_used: Dictionary = input_packet.duplicate()
	var player_before: Variant = null
	if tick_order_trace_enabled and designated_player_entity != null:
		player_before = _snapshot_entity_order(designated_player_entity)

	var fun_00005df8_ran: bool = mission_flag_ac == 0
	if fun_00005df8_ran:
		_call_05df8()

	var passes: Array = []
	var arrays_ran: bool = mission_phase_a8 > 0 and mission_phase_a8 < 6
	if arrays_ran:
		passes.append(_run_pass(PASS_DAT_0001D4A4, "DAT_0001d4a4", entity_array_1, 0))
		passes.append(_run_pass(PASS_DAT_0001B5A4, "DAT_0001b5a4", entity_array_2, 0))
		var player_after_pass_2: Variant = null
		if tick_order_trace_enabled and designated_player_entity != null:
			player_after_pass_2 = _snapshot_entity_order(designated_player_entity)
		passes.append(_run_pass(PASS_DAT_0001D0E4, "DAT_0001d0e4", entity_array_3, 1))
		passes.append(_run_pass(PASS_DAT_0001CBE4, "DAT_0001cbe4", entity_array_4, 1))
		_call_06fb8()
		last_tick_order = {
			"frame": _tick_count,
			"mission_flag_ac": mission_flag_ac,
			"mission_phase_a8": mission_phase_a8,
			"arrays_ran": true,
			"passes": passes,
			"fun_00005df8_ran": fun_00005df8_ran,
			"fun_00005df8_cleared": _fun_00005df8_cleared_this_tick,
			"fun_0000528a_calls": _fun_0000528a_calls_this_tick,
			"fun_000051ec_calls": _fun_000051ec_calls_this_tick,
			"fun_00006fb8_ran": true,
			"fun_00006fb8_globals": _snapshot_06fb8_globals(),
			"designated_player_is_array2_index0": entity_array_2.size() > 0,
			"rng_draws_this_tick": _rng_draws_this_tick,
			"param_2_entity_updates": _param_2_entity_updates.duplicate(),
		}
		if tick_order_trace_enabled:
			last_tick_order["player_snapshot_before_tick"] = player_before
			last_tick_order["player_snapshot_after_pass_2"] = player_after_pass_2
			last_tick_order["player_snapshot_after_tick"] = (
				_snapshot_entity_order(designated_player_entity)
				if designated_player_entity != null
				else null
			)
			last_tick_order["rng_state_after_tick"] = rng.get_state()
	else:
		last_tick_order = {
			"frame": _tick_count,
			"mission_flag_ac": mission_flag_ac,
			"mission_phase_a8": mission_phase_a8,
			"arrays_ran": false,
			"passes": [],
			"fun_00005df8_ran": fun_00005df8_ran,
			"fun_00005df8_cleared": _fun_00005df8_cleared_this_tick,
			"fun_0000528a_calls": _fun_0000528a_calls_this_tick,
			"fun_000051ec_calls": _fun_000051ec_calls_this_tick,
			"fun_00006fb8_ran": false,
			"fun_00006fb8_globals": _snapshot_06fb8_globals(),
			"designated_player_is_array2_index0": entity_array_2.size() > 0,
			"rng_draws_this_tick": _rng_draws_this_tick,
			"param_2_entity_updates": _param_2_entity_updates.duplicate(),
		}
		if tick_order_trace_enabled:
			last_tick_order["player_snapshot_before_tick"] = player_before
			last_tick_order["rng_state_after_tick"] = rng.get_state()

	if trace_enabled:
		_trace.append(
			{
				"frame": _tick_count,
				"input": input_used,
				"rng_state": rng.get_state(),
				"mission_phase_a8": mission_phase_a8,
				"mission_flag_ac": mission_flag_ac,
				"player": _snapshot_player(),
				"tick_order": last_tick_order.duplicate(true),
			}
		)

func get_last_tick_order() -> Dictionary:
	return last_tick_order

## [RECONSTRUCTED] FUN_00011564 draw used by FUN_0000e792 flags_685 slices (Pacific Conflict.c:14105+).
func _rng_consume() -> int:
	_rng_draws_this_tick += 1
	return int(rng.next())

## [INFERRED] Call-site FUN_00011544 ≡ one 11564 draw (see RngOverlay11564.fun_00011544_callsite).
func _rng_consume_11544_callsite() -> int:
	_rng_draws_this_tick += 1
	return int(rng.fun_00011544_callsite())

## [INFERRED] Minimal fields for ordering QA; not full entity export.
func _snapshot_entity_order(entity: RefCounted) -> Dictionary:
	if entity == null:
		return {}
	return {
		"movement_66e": entity.get_field("movement_66e"),
		"movement_672": entity.get_s16_field("movement_672"),
		"movement_66a": entity.get_field("movement_66a"),
	}

func _run_pass(pass_id: int, dat_symbol: String, arr: Array, param_2: int) -> Dictionary:
	last_pass_id = pass_id
	last_pass_param_2 = param_2
	_update_entity_array(arr, param_2, pass_id)
	return {"pass_id": pass_id, "dat": dat_symbol, "param_2": param_2, "count": arr.size()}

## [RECONSTRUCTED] FUN_00005df8 when mission_flag_ac == 0 (Pacific Conflict.c:6434–6447).
func _call_05df8() -> void:
	for i in range(7):
		var slot = dat_0001bc64[i] if i < dat_0001bc64.size() else null
		if slot == null:
			continue
		_call_0528a(slot)
		dat_0001bc64[i] = null
		_fun_00005df8_cleared_this_tick += 1

## [RECONSTRUCTED] FUN_0000528a (Pacific Conflict.c:5784–5798).
func _call_0528a(entity: Variant) -> void:
	_fun_0000528a_calls_this_tick += 1
	if entity == null or not entity.has_method("get_u8_field"):
		last_0528a_path = "invalid"
		return
	if (entity.get_u8_field("flags_07") & 0x02) != 0:
		last_0528a_path = "skip_flag7"
		return
	var type_byte: int = entity.get_u8_field("field_00")
	var field_01: int = entity.get_u8_field("field_01")
	var match_d6fc: bool = (
		entity.get_field("field_24") == dat_0001d6fc
		and dat_0001b88e <= field_01
		and field_01 <= dat_0001b88c
	)
	if match_d6fc or type_byte != 0x02:
		_call_051ec(entity)
		last_0528a_path = "call_051ec"
	else:
		## type == 0x02 and match_d6fc false
		entity.set_field("field_04", entity.get_field("field_04") | 0x42)
		entity.set_field("field_3c", dat_0001b838)
		last_0528a_path = "type02_alt"

## [RECONSTRUCTED] FUN_000051ec (Pacific Conflict.c:5751–5779).
## mem_u32 models *(addr) for the proven table poke and **(entity+8)=0.
func _call_051ec(entity: Variant) -> void:
	_fun_000051ec_calls_this_tick += 1
	if entity == null or not entity.has_method("get_field"):
		return
	if entity.get_field("entity_data_ptr") == dat_0001b880:
		dat_0001b880 = 0
	var field_01: int = entity.get_u8_field("field_01")
	var field_02: int = entity.get_u8_field("field_02")
	if field_01 != field_02:
		## *( *(DAT_0001d6fc + 0x30) + 0x14 + field_02 * 0x18 ) = 0
		var table_base: int = int(mem_u32.get(dat_0001d6fc + 0x30, 0))
		if table_base != 0:
			mem_u32[table_base + 0x14 + field_02 * 0x18] = 0
		if dat_0001b88e <= field_01 and field_01 <= dat_0001b88c:
			for i in range(7):
				if i < dat_0001bc64.size() and dat_0001bc64[i] == entity:
					dat_0001bc64[i] = null
	entity.set_field("pos_18", 1000000000)
	entity.set_field("field_04", entity.get_field("field_04") | 0x02)
	entity.set_field("field_3c", 0)
	## **(undefined4 **)(param_1 + 8) = 0  → write 0 at address held in entity+8
	var p8: int = entity.get_field("entity_data_ptr")
	if p8 != 0:
		mem_u32[p8] = 0
	dat_00024cf0 += 1

## [RECONSTRUCTED] FUN_00006fb8 after all four arrays (Pacific Conflict.c:7180–7189).
func _call_06fb8() -> void:
	dat_0001d718 = FUN_00006FB8_RESET_VALUE
	dat_0001d724 = FUN_00006FB8_RESET_VALUE
	dat_0001d714 = FUN_00006FB8_RESET_VALUE
	dat_0001d720 = FUN_00006FB8_RESET_VALUE
	dat_0001d710 = FUN_00006FB8_RESET_VALUE
	dat_0001d71c = FUN_00006FB8_RESET_VALUE

func _snapshot_06fb8_globals() -> Dictionary:
	return {
		"DAT_0001d710": dat_0001d710,
		"DAT_0001d714": dat_0001d714,
		"DAT_0001d718": dat_0001d718,
		"DAT_0001d71c": dat_0001d71c,
		"DAT_0001d720": dat_0001d720,
		"DAT_0001d724": dat_0001d724,
	}

## Update one array; param_2 is 0 or 1 (FUN_000044a4 second arg).
func _update_entity_array(arr: Array, param_2: int, pass_id: int) -> void:
	for entity in arr:
		_param_2_entity_updates[param_2] = int(_param_2_entity_updates.get(param_2, 0)) + 1
		_update_single_entity(entity as RefCounted, param_2, pass_id)

## Per-entity update slices from FUN_0000e792 (not FUN_0000435a — different callers).
func _update_single_entity(entity: RefCounted, param_2: int, _pass_id: int) -> void:
	if entity == null:
		return
	## [RECONSTRUCTED] Contact branch is before flags_685 RNG and returns early (14083–14104).
	if _apply_ground_contact_early_out(entity):
		return
	_apply_randomized_control_offsets(entity)
	_apply_control_gate_accumulator(entity)
	_apply_control_threshold_decrement(entity)
	_apply_movement_smoothing(entity)
	## [RECONSTRUCTED] After 0x66e/672/66a block; applies to all entities that reach here (14248–14304).
	_apply_movement_626_step(entity)
	## [RECONSTRUCTED] Reverse-flight 0x626 clamps before e4a4 (14305–14319).
	_apply_movement_626_reverse_clamp(entity)
	## [RECONSTRUCTED] e4a4 + e468 drag + 0x636 thrust (14344–14383).
	_apply_e4a4_and_linear_drag(entity)

## [RECONSTRUCTED] FUN_0000e792 contact when (status_1a1 & 8) != 0 (Pacific Conflict.c:14083–14104).
## Surface: *(iVar1 + 0x1c) with iVar1 = *param_1 = entity.world_obj_ptr (also *DAT_0001b738+0x1c at 7354).
## [DEFERRED] FUN_00011544 RNG writes to 0x61a/0x61e (decompiler shows void / unaff_D3).
## Returns true if the original early-return path was taken.
func _apply_ground_contact_early_out(entity: RefCounted) -> bool:
	if (entity.get_u16_field("status_1a1") & 0x08) == 0:
		return false
	var surface_1c: int = _contact_surface_height_1c(entity)
	var pos_2e: int = _entity_s32(entity, "pos_2e")
	var i_var23: int = pos_2e + compute_template_field_40_adjustment(entity)
	if pos_2e < surface_1c - 0x16:
		entity.set_field("position_velocity_c", _as_u32(-0x16))
	else:
		if entity.get_u8_field("field_0b") == 0x10:
			entity.set_u16_field("status_1a1", entity.get_u16_field("status_1a1") | 0x1000)
			if entity == designated_player_entity:
				dat_0001b850 = 1
		entity.set_field("position_velocity_c", _as_u32(i_var23 - surface_1c))
	entity.set_u8_field("movement_669", 0)
	return true

## [RECONSTRUCTED] Raw u32 at *(world_obj_ptr + 0x1c) (Pacific Conflict.c:14084, 14168).
func _world_surface_u32(entity: RefCounted) -> int:
	var link: int = int(entity.world_obj_ptr)
	if link == 0:
		return 0
	return int(mem_u32.get(link + 0x1c, 0)) & 0xFFFFFFFF

## [RECONSTRUCTED] Signed view of *(world_obj_ptr + 0x1c) via mem_u32 (Pacific Conflict.c:14084, 7354).
func _contact_surface_height_1c(entity: RefCounted) -> int:
	var v: int = _world_surface_u32(entity)
	return v - 0x1_0000_0000 if v >= 0x8000_0000 else v

func _as_u32(value: int) -> int:
	return value & 0xFFFFFFFF if value >= 0 else (value + 0x1_0000_0000) & 0xFFFFFFFF

func _apply_randomized_control_offsets(entity: RefCounted) -> void:
	var flags_685: int = entity.get_u8_field("flags_685")
	if (flags_685 & 0x04) != 0:
		var movement_662: int = entity.get_s16_field("movement_662") + (_rng_consume() & 0x7F) - 0x40
		entity.set_s16_field("movement_662", _clamp_s16(movement_662, -0x200, 0x200))
	if (flags_685 & 0x08) != 0:
		var movement_666: int = entity.get_s16_field("movement_666") + (_rng_consume() & 0x7F) - 0x40
		entity.set_s16_field("movement_666", _clamp_s16(movement_666, -0x140, 0x140))
	if (entity.get_u16_field("status_1a1") & 0x0001) != 0:
		entity.set_s16_field("movement_662", 0)
		entity.set_s16_field("movement_666", -0x80)

func _clamp_s16(value: int, lower: int, upper: int) -> int:
	return mini(maxi(value, lower), upper)

func _apply_control_gate_accumulator(entity: RefCounted) -> void:
	var control_accumulator: int = entity.get_s8_field("field_19a")
	var flags_685: int = entity.get_u8_field("flags_685")
	var status_1a1: int = entity.get_u16_field("status_1a1")
	var status_1a3: int = entity.get_s16_field("status_1a3")
	var count_67d: int = entity.get_s8_field("weapon_count_67d")
	var count_67e: int = entity.get_s8_field("weapon_count_67e")
	var gate_enabled := (((flags_685 & 0x40) == 0) or status_1a3 != 0) and ((status_1a1 & 0x0300) == 0) and (count_67d != 0 or count_67e != 0)
	entity.set_u8_field("movement_669", 1 if gate_enabled else 0)
	if not gate_enabled:
		control_accumulator = 0
	elif (flags_685 & 0x80) != 0:
		control_accumulator = _half_toward_zero(control_accumulator)
	entity.set_s16_field("status_1a0", entity.get_s16_field("status_1a0") + control_accumulator)

func _half_toward_zero(value: int) -> int:
	if value < 0:
		value += 1
	return value >> 1

func _apply_control_threshold_decrement(entity: RefCounted) -> void:
	var template: RefCounted = entity.external_template
	if template == null:
		return
	var threshold: int = template.get_s16_field("field_1e")
	var accumulator: int = entity.get_s16_field("status_1a0")
	if threshold >= accumulator:
		return
	entity.set_s16_field("status_1a0", accumulator - threshold)
	var count_67d: int = entity.get_s8_field("weapon_count_67d")
	var count_67e: int = entity.get_s8_field("weapon_count_67e")
	if ((_rng_consume() & 1) == 0) or count_67d == 0:
		if count_67e != 0:
			entity.set_s8_field("weapon_count_67e", count_67e - 1)
	else:
		entity.set_s8_field("weapon_count_67d", count_67d - 1)

## Movement-smoothing block (Pacific Conflict.c:14179-14244). Only for designated player or target entity.
func _apply_movement_smoothing(entity: RefCounted) -> void:
	if entity != designated_player_entity and entity != designated_target_entity:
		return
	var template: RefCounted = entity.external_template
	if template == null:
		return
	var i_var20: int = entity.get_field("movement_62a") >> 2
	## [RECONSTRUCTED] e42a arg is *(world_obj_ptr+0x1c), not entity pos_1c (asm 0xE9C2).
	var surface_u32: int = _world_surface_u32(entity)
	last_e42a_input_u32 = surface_u32
	var e42a_out: int = FlightMathScript.fun_0000e42a(surface_u32)
	var s_var15: int = (e42a_out & 0xFFFF)
	if s_var15 >= 0x8000:
		s_var15 -= 0x1_0000
	## [RECONSTRUCTED] e468(surface−pos_2e, e42a) → separate slot; e570/local_46 keep raw e42a (asm 0xE9BE–0xE9EA).
	var surface_s32: int = _contact_surface_height_1c(entity)
	var pos_2e: int = _entity_s32(entity, "pos_2e")
	last_e468_out = FlightMathScript.fun_0000e468(surface_s32 - pos_2e, s_var15)
	var local_26: int = FlightMathScript.fun_0000e570(template.get_field("field_38"), s_var15)
	var flags_685: int = entity.get_u8_field("flags_685")
	var status_1a1: int = entity.get_u16_field("status_1a1")
	var status_1a3: int = entity.get_s16_field("status_1a3")
	var count_67d: int = entity.get_s8_field("weapon_count_67d")
	var count_67e: int = entity.get_s8_field("weapon_count_67e")
	var gate_enabled: bool = (((flags_685 & 0x40) == 0) or status_1a3 != 0) and ((status_1a1 & 0x0300) == 0) and (count_67d != 0 or count_67e != 0)
	var s_var21: int = entity.get_s8_field("field_19a") if gate_enabled else 0
	if gate_enabled and (flags_685 & 0x80) != 0:
		s_var21 = _half_toward_zero(s_var21)
	## [RECONSTRUCTED] local_46 uses literal 0x666, not field movement_666 (Pacific Conflict.c:14183).
	var denom: int = (s_var15 + 0xa25) >> 5
	var local_46: int = FlightMathScript.compute_local_46(s_var15, s_var21)
	last_local_46 = local_46
	if denom != 0:
		var current_66e: int = _entity_s32(entity, "movement_66e")
		var delta_66e: int = local_46 - current_66e
		entity.set_field("movement_66e", FlightMathScript.add_delta_smoothed_int(current_66e, delta_66e))
	var source_672: int = 0
	if entity.get_u8_field("movement_669") != 0 and (status_1a1 & 0x4300) == 0:
		source_672 = (local_26 >> 9)
		if source_672 >= 0x8000:
			source_672 -= 0x1_0000
	if (flags_685 & 0x80) != 0:
		source_672 = _half_toward_zero(source_672)
	var current_672: int = entity.get_s16_field("movement_672")
	var delta_672: int = source_672 - current_672
	entity.set_s16_field("movement_672", FlightMathScript.add_delta_smoothed_s16(current_672, delta_672))
	var local_42: int = (i_var20 << 0x11) / 0x1c20
	last_local_42 = local_42
	var adj: int = local_42 - local_46
	if adj < 0:
		adj += 1
	var target_66a: int = local_46 + (adj >> 1)
	var current_66a: int = _entity_s32(entity, "movement_66a")
	var delta_66a: int = target_66a - current_66a
	entity.set_field("movement_66a", FlightMathScript.add_delta_smoothed_int(current_66a, delta_66a))
	if (status_1a1 & 0x40) != 0 and entity.get_field("movement_66e") == 0:
		entity.set_u8_field("movement_669", 0)

## [RECONSTRUCTED] FUN_0000e792 movement_626 update (Pacific Conflict.c:14248–14304).
func _apply_movement_626_step(entity: RefCounted) -> void:
	var template: RefCounted = entity.external_template
	if template == null:
		return
	var i_var20: int = entity.get_field("movement_62a") >> 2
	## [RECONSTRUCTED] sVar22 / local_48 / uVar13 before 626 write (14283–14340).
	last_s_var22 = FlightMathScript.compute_s_var22(
		i_var20, entity.get_s16_field("movement_666")
	)
	last_626_local_48 = FlightMathScript.compute_626_local_48(
		i_var20, entity.get_s16_field("field_199")
	)
	last_landing_u_var13 = FlightMathScript.compute_landing_u_var13(
		last_s_var22, entity.get_s16_field("field_24")
	)
	var next_626: int = FlightMathScript.apply_movement_626_step(
		entity.get_s16_field("movement_626"),
		entity.get_s16_field("movement_662"),
		i_var20,
		template.get_s16_field("field_34"),
		template.get_s16_field("field_36"),
		template.get_s16_field("field_44")
	)
	entity.set_s16_field("movement_626", next_626)

## [RECONSTRUCTED] 0x626 reverse clamps + local_48 / DAT_0001b858 (14305–14342).
## local_48 uses designated local_46/local_42 from this entity's smoothing pass.
func _apply_movement_626_reverse_clamp(entity: RefCounted) -> void:
	if entity.get_u8_field("field_63e") == 0:
		return
	if entity.get_s8_field("direction_char_679") != 0x2D:  # '-'
		return
	var template: RefCounted = entity.external_template
	if template == null:
		return
	var i_var20: int = entity.get_field("movement_62a") >> 2
	entity.set_s16_field(
		"movement_626",
		FlightMathScript.apply_movement_626_reverse_clamp(
			entity.get_s16_field("movement_626"),
			i_var20,
			template.get_s16_field("field_42"),
			template.get_s16_field("field_46"),
			template.get_s16_field("field_48")
		)
	)
	## local_46/42 only valid if this entity ran designated smoothing this tick.
	if entity != designated_player_entity and entity != designated_target_entity:
		return
	last_reverse_local_48 = FlightMathScript.compute_reverse_local_48(
		last_local_46,
		last_local_42,
		entity.get_s16_field("movement_666")
	)
	if entity == designated_player_entity:
		dat_0001b858 = 0
	## [RECONSTRUCTED] local_2a = (local_48 & 0x3fff) + local_2a & 0x3fff (14341–14342).
	var local_2a: int = entity.get_u16_field("attitude_22")
	entity.set_u16_field(
		"attitude_22",
		((last_reverse_local_48 & 0x3FFF) + local_2a) & 0x3FFF
	)

## [RECONSTRUCTED] FUN_0000e4a4 + e468 drag + 0x636 + 0x63e/0x18e + stall (Pacific Conflict.c:14344–14433).
## Per-entity e468. FUN_000025a8 position integration deferred.
func _apply_e4a4_and_linear_drag(entity: RefCounted) -> void:
	var template: RefCounted = entity.external_template
	if template == null:
		return
	var surface_u32: int = _world_surface_u32(entity)
	var e42a_out: int = FlightMathScript.fun_0000e42a(surface_u32)
	var s_var15: int = e42a_out & 0xFFFF
	if s_var15 >= 0x8000:
		s_var15 -= 0x1_0000
	var surface_s32: int = _contact_surface_height_1c(entity)
	var pos_2e: int = _entity_s32(entity, "pos_2e")
	var e468: int = FlightMathScript.fun_0000e468(surface_s32 - pos_2e, s_var15)
	last_drag_e468 = e468
	## Keep designated prep stash in sync when this entity is the designated player.
	if entity == designated_player_entity:
		last_e468_out = e468
		last_e42a_input_u32 = surface_u32
	var e4a4: Dictionary = FlightMathScript.fun_0000e4a4(
		entity.get_s16_field("movement_626"),
		entity.get_s8_field("field_67b"),
		entity.get_u8_field("field_19e"),
		template.get_s16_field("field_26"),
		template.get_s16_field("field_28"),
		template.get_s16_field("field_2a"),
		template.get_s16_field("field_2c"),
		template.get_s16_field("field_34")
	)
	var i_var19: int = int(e4a4.get("value", 0))
	var field_19e: int = int(e4a4.get("field_19e", 0)) & 0xFF
	if field_19e != 0:
		var delta: int = i_var19 - entity.get_s16_field("movement_63a")
		if delta < 0:
			delta += 7
		i_var19 = (delta >> 3) + entity.get_s16_field("movement_63a")
		field_19e = (field_19e - 1) & 0xFF
	entity.set_u8_field("field_19e", field_19e)
	entity.set_s16_field("movement_63a", i_var19)
	var movement_62a: int = entity.get_field("movement_62a")
	var i_var20: int = movement_62a >> 2
	var s_var12: int = (
		entity.get_s8_field("weapon_count_67e")
		+ entity.get_s16_field("movement_634")
		+ entity.get_s8_field("weapon_count_67d")
	)
	last_drag_ivar10 = FlightMathScript.apply_e468_linear_drag(
		i_var20,
		i_var19,
		template.get_s16_field("field_22"),
		e468,
		s_var12
	)
	last_drag_quadratic_raw = FlightMathScript.apply_e468_quadratic_drag_raw(
		i_var20,
		i_var19,
		template.get_s16_field("field_22"),
		template.get_s16_field("field_24"),
		e468
	)
	var thrust: Dictionary = FlightMathScript.apply_thrust_636_step(
		entity.get_s16_field("movement_636"),
		movement_62a,
		i_var20,
		last_drag_quadratic_raw,
		s_var15,
		s_var12,
		template.get_s16_field("field_20"),
		entity.get_s8_field("direction_char_679"),
		entity.get_s8_field("field_67b")
	)
	entity.set_s16_field("movement_636", int(thrust.get("movement_636", 0)))
	var movement_62a_after: int = int(thrust.get("movement_62a", movement_62a))
	entity.set_field("movement_62a", movement_62a_after)
	last_thrust_quad_term = int(thrust.get("quad_term", 0))
	last_thrust_term = int(thrust.get("thrust_term", 0))
	## [RECONSTRUCTED] Post-thrust 0x63e → field_18e / iVar25 (14384–14421). Uses pre-thrust i_var20.
	if entity.get_u8_field("field_63e") != 0:
		var d63e: Dictionary = FlightMathScript.compute_63e_thrust_delta(
			i_var20,
			entity.get_s8_field("direction_char_679"),
			entity.get_u8_field("field_0b"),
			entity.get_u16_field("status_1a1"),
			entity.get_u8_field("field_641"),
			template.get_s16_field("field_46"),
			template.get_s16_field("field_2e"),
			template.get_s16_field("field_30"),
			template.get_s16_field("field_32")
		)
		last_63e_thrust_delta = int(d63e.get("thrust_delta", 0))
		if bool(d63e.get("set_dat_0001b850", false)) and entity == designated_player_entity:
			dat_0001b850 = 1
		var u18e: Dictionary = FlightMathScript.apply_field_18e_update(
			entity.get_u16_field("field_18e"),
			last_63e_thrust_delta,
			last_drag_ivar10
		)
		entity.set_u16_field("field_18e", int(u18e.get("field_18e", 0)))
		last_18e_62a_delta = int(u18e.get("movement_62a_delta", 0))
		movement_62a_after -= last_18e_62a_delta
		entity.set_field("movement_62a", movement_62a_after)
	## [RECONSTRUCTED] local_34 into iVar25 + stall (14422–14433). local_34 from 14172–14180.
	var flags_685: int = entity.get_u8_field("flags_685")
	var status_1a1: int = entity.get_u16_field("status_1a1")
	var status_1a3: int = entity.get_s16_field("status_1a3")
	var count_67d: int = entity.get_s8_field("weapon_count_67d")
	var count_67e: int = entity.get_s8_field("weapon_count_67e")
	var gate_enabled: bool = (((flags_685 & 0x40) == 0) or status_1a3 != 0) and ((status_1a1 & 0x0300) == 0) and (count_67d != 0 or count_67e != 0)
	var s_var21: int = entity.get_s8_field("field_19a") if gate_enabled else 0
	if gate_enabled and (flags_685 & 0x80) != 0:
		s_var21 = _half_toward_zero(s_var21)
	var local_26: int = FlightMathScript.fun_0000e570(template.get_field("field_38"), s_var15)
	last_local_34 = FlightMathScript.compute_local_34(
		template.get_s16_field("field_3c"),
		template.get_s16_field("field_3e"),
		local_26,
		s_var21,
		i_var20
	)
	## C checks entity+0x62a (pre-tick speed), not the iVar25 local.
	var had_speed: bool = movement_62a != 0
	var stall: Dictionary = FlightMathScript.apply_ivar25_stall_step(
		movement_62a_after,
		entity.get_u8_field("field_190"),
		last_local_34,
		s_var12,
		had_speed,
		entity == designated_player_entity,
		dat_0001b868
	)
	entity.set_field("movement_62a", int(stall.get("movement_62a", movement_62a_after)))
	entity.set_u8_field("field_190", int(stall.get("field_190", 0)))
	last_stalled_this_tick = bool(stall.get("stalled", false))
	if bool(stall.get("set_dat_0001b868", false)):
		dat_0001b868 = 2
	## [RECONSTRUCTED] FUN_000025a8 → FUN_000028dc + >>6 (14438–14445).
	## Trig from overlay dump (file 0x1ab8c/0x1ad8c).
	var local_48_m: int = last_626_local_48
	if entity.get_u8_field("field_63e") != 0 and entity.get_s8_field("direction_char_679") == 0x2D:
		local_48_m = last_reverse_local_48 & 0x3FFF
	attitude_matrix_9 = FlightMathScript.fun_000025a8(
		local_48_m & 0x3FFF,
		entity.get_u16_field("pos_20"),
		entity.get_u16_field("attitude_22"),
		last_landing_u_var13 & 0x3FFF
	)
	var ivar25_final: int = int(stall.get("movement_62a", movement_62a_after))
	var commit: Dictionary = FlightMathScript.apply_position_commit_after_028dc(
		last_drag_ivar10,
		ivar25_final,
		entity.get_s16_field("field_18c"),
		attitude_matrix_9
	)
	entity.set_s16_field("field_18c", int(commit.get("field_18c", 0xFFA5)))
	## param_1[2]/[3]/[4] at byte 0x08 / 0x0c / 0x10 (velocity / frame deltas).
	entity.set_field("entity_data_ptr", int(commit.get("param_1_2", 0)))
	entity.set_field("position_velocity_c", int(commit.get("param_1_3", 0)))
	entity.set_field("ptr_10", int(commit.get("param_1_4", 0)))
	last_pos_commit = commit
	## [RECONSTRUCTED] Touchdown / leave-ground on field_63e (14446–14485).
	_apply_63e_ground_transition(entity)
	## Hard-crash early return skips post-ground tails (14451–14458).
	if last_landing_early_return:
		return
	## [RECONSTRUCTED] Airborne / grounded + f47c + chars + weapons + bVar6 (14486–14748).
	## [DEFERRED] FUN_00012840/15d20/19430 bodies. flags_685&2 via 11544-callsite (14721+).
	var att22_before: int = entity.get_u16_field("attitude_22")
	## bVar6 starts false each e792; rough landing (14462) may set it before recommit.
	e792_b_var6 = last_landing_rough
	last_bvar6_cleanup_applied = false
	last_f47c_applied = false
	last_char_epilogue_bumped_67b = false
	last_char_epilogue_bumped_679 = false
	last_weapon_19d_fired = false
	last_weapon_19d_need_12840 = false
	last_weapon_676_fired = false
	last_weapon_676_need_15d20 = false
	last_weapon_677_fired = false
	last_weapon_677_need_19430 = false
	if entity.get_u8_field("field_63e") == 0:
		_apply_airborne_speed_recommit(entity)
		_apply_lab_0000f47c(
			entity,
			last_airborne_local_28,
			last_airborne_local_2a,
			att22_before,
			int(entity.get_field("movement_62a"))
		)
	else:
		_apply_grounded_speed_recommit(entity)
		if last_grounded_field_0b_early_return:
			return
		e792_b_var6 = e792_b_var6 or last_grounded_b_var6
		_apply_lab_0000f47c(
			entity,
			last_grounded_local_28,
			att22_before,
			att22_before,
			int(entity.get_field("movement_62a"))
		)
	## [RECONSTRUCTED] flags_685&2 ammo tail (14721–14734) then bVar6 cleanup (14736–14748).
	_apply_e792_flags685_bit2_tail(entity)
	_apply_e792_bvar6_cleanup(entity)

## [RECONSTRUCTED] field_63e touchdown (14446–14449), pitch follow-on (14450–14476), airborne clear (14479–14484).
func _apply_63e_ground_transition(entity: RefCounted) -> void:
	last_63e_landing_applied = false
	last_63e_airborne_applied = false
	last_landing_hard_crash = false
	last_landing_rough = false
	last_landing_early_return = false
	last_landing_need_13452 = false
	last_landing_local_28 = 0
	last_13452_args = {}
	last_13452_result = 0
	var surface_1c: int = _contact_surface_height_1c(entity)
	var i_var23: int = _entity_s32(entity, "pos_2e") + compute_template_field_40_adjustment(entity)
	var pvc: int = _entity_s32(entity, "position_velocity_c")
	if entity.get_u8_field("field_63e") == 0:
		var land: Dictionary = FlightMathScript.apply_landing_touchdown_63e(
			0, pvc, surface_1c, i_var23
		)
		if bool(land.get("applied", false)):
			entity.set_u8_field("field_63e", 1)
			entity.set_field("position_velocity_c", int(land.get("position_velocity_c", pvc)))
			last_63e_landing_applied = true
			## local_28 captured at e792 entry from *(param_1+8) → +0x20 (pos_20 / attitude).
			last_landing_local_28 = entity.get_u16_field("pos_20")
			var follow: Dictionary = FlightMathScript.apply_landing_pitch_followon(
				entity.get_s16_field("attitude_0e"),
				_entity_s32(entity, "pos_2e"),
				entity.get_u16_field("status_1a1"),
				entity == designated_player_entity,
				last_landing_u_var13,
				last_landing_local_28
			)
			entity.set_u16_field("status_1a1", int(follow.get("status_1a1", 0)))
			last_landing_hard_crash = bool(follow.get("hard_crash", false))
			last_landing_rough = bool(follow.get("rough", false))
			last_landing_early_return = bool(follow.get("early_return", false))
			last_landing_need_13452 = bool(follow.get("need_13452", false))
			if bool(follow.get("clear_field_18e", false)):
				entity.set_u16_field("field_18e", 0)
			if bool(follow.get("set_dat_0001b868", false)):
				dat_0001b868 = 1
			if bool(follow.get("set_dat_0001b856", false)):
				dat_0001b856 = 1
			## [RECONSTRUCTED] Hard-crash pos_2e==0 → FUN_00013452(iVar1) → field_0b (14456–14458).
			if last_landing_need_13452:
				_apply_fun_00013452_hard_crash(entity)
	else:
		var air: Dictionary = FlightMathScript.apply_airborne_clear_63e(
			entity.get_u8_field("field_63e"),
			pvc,
			surface_1c,
			i_var23,
			entity.get_u16_field("status_1a1")
		)
		if bool(air.get("applied", false)):
			entity.set_u8_field("field_63e", 0)
			entity.set_u16_field("status_1a1", int(air.get("status_1a1", 0)))
			last_63e_airborne_applied = true
			if entity == designated_player_entity and bool(air.get("clear_dat_0001b868", false)):
				dat_0001b868 = 0

## [RECONSTRUCTED] When field_63e!=0: e372(e²+z²), pvc, field_0b switch, optional 13452 (14497–14603).
func _apply_grounded_speed_recommit(entity: RefCounted) -> void:
	last_grounded_speed_recommit = false
	last_grounded_speed_sq = 0
	last_grounded_field_0b_early_return = false
	last_grounded_b_var6 = false
	var surface_1c: int = _contact_surface_height_1c(entity)
	var i_var23: int = _entity_s32(entity, "pos_2e") + compute_template_field_40_adjustment(entity)
	## 13452 may rewrite field_0b before the type switch (14497–14504).
	if _entity_s32(entity, "pos_2e") == 0:
		_apply_fun_00013452_hard_crash(entity)
	var is_player: bool = entity == designated_player_entity
	var field_0b: int = entity.get_u8_field("field_0b")
	var dir_679: int = entity.get_s8_field("direction_char_679")
	var mov_626: int = entity.get_s16_field("movement_626")
	## RNG draws before recommit: 0x10 soft uses 11564; '@' uses 11544-callsite×2 (+optional 11564).
	var rng_draws: Array = []
	if field_0b == 0x10:
		var e40c_626: int = FlightMathScript.fun_0000e40c(mov_626)
		if dir_679 == 0 and e40c_626 >= -0x80:
			rng_draws.append(_rng_consume())
	elif field_0b == 0x40:
		rng_draws.append(_rng_consume_11544_callsite())
		rng_draws.append(_rng_consume_11544_callsite())
		var le: int = int(last_pos_commit.get("local_e", 0))
		var l6: int = int(last_pos_commit.get("local_6", 0))
		var spd: int = _to_s16(FlightMathScript.fun_0000e372(le * le + l6 * l6))
		if is_player and (dat_0001b856 & 0xFF) == 0 and spd >= 0x2D1:
			rng_draws.append(_rng_consume())
	var rec: Dictionary = FlightMathScript.apply_grounded_speed_recommit(
		int(last_pos_commit.get("local_e", 0)),
		int(last_pos_commit.get("local_6", 0)),
		entity.get_u16_field("pos_20"),
		_entity_s32(entity, "pos_2e"),
		i_var23,
		surface_1c,
		entity.get_u8_field("field_63f"),
		entity.get_u8_field("field_190"),
		field_0b,
		entity.get_u16_field("status_1a1"),
		dir_679,
		mov_626,
		is_player,
		dat_0001b856,
		last_landing_u_var13,
		rng_draws
	)
	entity.set_field("position_velocity_c", _as_u32(int(rec.get("position_velocity_c", 0))))
	entity.set_u16_field("status_1a1", int(rec.get("status_1a1", 0)))
	last_grounded_speed_sq = int(rec.get("speed_sq", 0))
	last_grounded_b_var6 = bool(rec.get("b_var6", false))
	last_grounded_speed_recommit = true
	if bool(rec.get("wrote_u_var13", false)):
		last_landing_u_var13 = int(rec.get("u_var13", 0)) & 0x3FFF
	if bool(rec.get("wrote_field_18c", false)):
		var prev_18c: int = entity.get_s16_field("field_18c")
		entity.set_s16_field("field_18c", prev_18c + int(rec.get("field_18c_delta", 0)))
	if bool(rec.get("set_dat_0001b854", false)):
		dat_0001b854 = 1
	if bool(rec.get("clear_dat_0001b856", false)):
		dat_0001b856 = 0
	if bool(rec.get("early_return", false)):
		last_grounded_field_0b_early_return = true
		return
	## Early return from 0x10 skips 62a / local_28 / prestall / LAB_0000f47c (14557).
	entity.set_field("movement_62a", int(rec.get("movement_62a", 0)))
	last_grounded_local_28 = int(rec.get("local_28", 0))
	if bool(rec.get("set_field_190_prestall", false)):
		entity.set_u8_field("field_190", 1)

## [RECONSTRUCTED] When field_63e==0: e372(local_e²+a²+6²) → movement_62a (14486–14495).
## local_28/local_2a stashed for LAB_0000f47c writes (14608–14609).
func _apply_airborne_speed_recommit(entity: RefCounted) -> void:
	last_airborne_speed_recommit = false
	last_airborne_speed_sq = 0
	last_airborne_local_28 = entity.get_u16_field("pos_20")
	last_airborne_local_2a = entity.get_u16_field("attitude_22")
	var rec: Dictionary = FlightMathScript.apply_airborne_speed_recommit(
		int(last_pos_commit.get("local_e", 0)),
		int(last_pos_commit.get("local_a", 0)),
		int(last_pos_commit.get("local_6", 0)),
		entity.get_u8_field("field_190"),
		last_airborne_local_28,
		last_airborne_local_2a
	)
	entity.set_field("movement_62a", int(rec.get("movement_62a", 0)))
	last_airborne_speed_sq = int(rec.get("speed_sq", 0))
	last_airborne_speed_recommit = true
	if bool(rec.get("clear_field_190", false)):
		entity.set_u8_field("field_190", 0)
	## Stash 01f22 outputs; LAB_0000f47c commits pos_20 / attitude_22.
	if bool(rec.get("wrote_local_28", false)):
		last_airborne_local_28 = int(rec.get("local_28", 0))
	if bool(rec.get("wrote_local_2a", false)):
		last_airborne_local_2a = int(rec.get("local_2a", 0))

## [RECONSTRUCTED] LAB_0000f47c (14606–14629): clear 63f, commit attitudes, yaw blend, player ring.
func _apply_lab_0000f47c(
	entity: RefCounted,
	local_28: int,
	local_2a: int,
	attitude_22_before: int,
	i_var20_speed: int
) -> void:
	var is_player: bool = entity == designated_player_entity
	var next_idx: int = (dat_0001bc84 + 1) % 0x78
	var ring_at_next: int = int(dat_0001bc8c[next_idx]) if next_idx < dat_0001bc8c.size() else 0
	var ep: Dictionary = FlightMathScript.apply_lab_0000f47c(
		local_28,
		local_2a,
		attitude_22_before,
		last_landing_u_var13,
		i_var20_speed,
		fun_00001d56_scale,
		is_player,
		dat_0001bc80,
		dat_0001bc84,
		ring_at_next
	)
	entity.set_u8_field("field_63f", 0)
	entity.set_u16_field("pos_20", int(ep.get("pos_20", 0)))
	entity.set_u16_field("attitude_22", int(ep.get("attitude_22", 0)))
	entity.set_s16_field("field_24", int(ep.get("field_24", 0)))
	entity.set_field("movement_62a", int(ep.get("movement_62a", 0)))
	last_f47c_field_24 = int(ep.get("field_24", 0))
	last_f47c_ring_value = int(ep.get("ring_value", 0))
	last_f47c_applied = true
	if bool(ep.get("wrote_ring", false)):
		var widx: int = int(ep.get("ring_write_index", 0))
		if widx >= 0 and widx < dat_0001bc8c.size():
			dat_0001bc8c[widx] = int(ep.get("ring_value", 0))
		dat_0001bc80 = int(ep.get("dat_0001bc80", 0))
		dat_0001bc84 = int(ep.get("dat_0001bc84", 0))
	## [RECONSTRUCTED] 67b/679 char epilogue immediately after ring (14631–14647).
	_apply_e792_char_epilogue(entity)
	## [RECONSTRUCTED] field_19d/19f weapon phase (14648–14671).
	_apply_e792_weapon_19d_branch(entity)
	## [RECONSTRUCTED] field_676 / 677 secondary+tertiary weapons (14673–14719).
	_apply_e792_weapon_676_branch(entity)
	_apply_e792_weapon_677_branch(entity)

## [RECONSTRUCTED] field_67b / direction_char_679 / field_67a / status_1a1 (14631–14647).
func _apply_e792_char_epilogue(entity: RefCounted) -> void:
	var ch: Dictionary = FlightMathScript.apply_e792_char_epilogue(
		entity.get_s8_field("field_67b"),
		entity.get_s8_field("direction_char_679"),
		entity.get_u8_field("field_67a"),
		entity.get_u8_field("flags_685"),
		entity.get_u16_field("status_1a1")
	)
	entity.set_s8_field("field_67b", int(ch.get("field_67b", 0)))
	entity.set_s8_field("direction_char_679", int(ch.get("direction_char_679", 0)))
	entity.set_u8_field("field_67a", int(ch.get("field_67a", 0)))
	entity.set_u16_field("status_1a1", int(ch.get("status_1a1", 0)))
	last_char_epilogue_bumped_67b = bool(ch.get("bumped_67b", false))
	last_char_epilogue_bumped_679 = bool(ch.get("bumped_679", false))

## [RECONSTRUCTED] field_19d==1 fire gate + 19f/18d/19d wrap (14648–14671).
## FUN_00012840 post-spawn writes applied when spawn_12840_entity is set.
func _apply_e792_weapon_19d_branch(entity: RefCounted) -> void:
	var br: Dictionary = FlightMathScript.apply_e792_weapon_19d_branch(
		entity.get_s8_field("field_19d"),
		entity.get_s8_field("field_19f"),
		entity.get_s16_field("field_18d"),
		mission_short_90
	)
	last_weapon_19d_need_12840 = bool(br.get("need_12840", false))
	last_weapon_19d_fired = bool(br.get("fired", false))
	if last_weapon_19d_need_12840:
		last_12840_result = _call_fun_00012840(entity)
		## [RECONSTRUCTED] non-null + player → DAT_0001b880 / short*[0x30a]=1 / DAT_0001b846 (14655–14658).
		if last_12840_result != 0 and entity == designated_player_entity:
			dat_0001b880 = last_12840_result
			dat_0001b846 = 1
			if spawn_12840_entity != null:
				spawn_12840_entity.set_u16_field("field_614", 1)
	entity.set_s8_field("field_19d", int(br.get("field_19d", 0)))
	entity.set_s8_field("field_19f", int(br.get("field_19f", 0)))
	entity.set_s16_field("field_18d", int(br.get("field_18d", 0)))

## [RECONSTRUCTED] FUN_00005116 free-slot + fill + world gate (5705–5746).
## Grow (01ba8) and real FUN_000046da deferred — mock installs spawn_05116_world_obj.
func _call_fun_00005116(
	_desc: int,
	param_2_x: int,
	param_3_y: int,
	param_4_z: int,
	param_5: int,
	param_6: int,
	param_7: int,
	param_8: int
) -> int:
	last_05116_slot_index = -1
	last_05116_result = 0
	last_05116_need_grow = false
	last_05116_need_051ec = false
	var table_base: int = int(mem_u32.get(dat_0001d6fc + 0x30, 0))
	var count: int = dat_0001d6fc_slot_count
	if table_base == 0 or count < 0:
		return 0
	var occupied: Array = []
	for i in range(count):
		occupied.append(int(mem_u32.get(table_base + i * 0x18 + 0x14, 0)))
	var idx: int = FlightMathScript.find_05116_free_slot_index(occupied)
	if idx >= count:
		## [DEFERRED] FUN_00001ba8 grow-by-10 when pool full.
		last_05116_need_grow = true
		return 0
	last_05116_slot_index = idx
	var slot: int = table_base + idx * 0x18
	var fill: Dictionary = FlightMathScript.apply_05116_slot_fill(
		param_2_x, param_3_y, param_4_z, param_5, param_6, param_7, param_8
	)
	mem_u32[slot + 0] = int(fill.get("slot_u16_0", 0))
	mem_u32[slot + 2] = int(fill.get("slot_u16_2", 0))
	mem_u32[slot + 4] = int(fill.get("slot_u16_4", 0))
	mem_u32[slot + 6] = int(fill.get("slot_u16_6", 0))
	mem_u32[slot + 8] = int(fill.get("slot_x", 0))
	mem_u32[slot + 0xC] = int(fill.get("slot_y", 0))
	mem_u32[slot + 0x10] = int(fill.get("slot_z", 0))
	## [INFERRED] Mock FUN_000046da: publish world obj into slot+0x14 and entity at world+8.
	mem_u32[slot + 0x14] = spawn_05116_world_obj
	if spawn_05116_world_obj != 0:
		mem_u32[spawn_05116_world_obj + 0x44] = spawn_05116_world_field_44
		mem_u32[spawn_05116_world_obj + 8] = spawn_05116_entity_handle
	var gate: Dictionary = FlightMathScript.apply_05116_world_gate(
		spawn_05116_world_obj,
		spawn_05116_world_field_44
	)
	last_05116_need_051ec = bool(gate.get("need_051ec", false))
	if last_05116_need_051ec:
		## Minimal fail cleanup: clear slot (full 051ec needs entity object).
		mem_u32[slot + 0x14] = 0
		last_05116_result = 0
		return 0
	last_05116_result = int(gate.get("world_obj", 0))
	return last_05116_result


## [RECONSTRUCTED] FUN_00012840 (17551–17571): 05116 → *(world+8) → field writes.
## Pool configured (table + count>0) → call 05116; else entity-fixture bypass (no allocator).
func _call_fun_00012840(entity: RefCounted) -> int:
	var world: int = int(entity.world_obj_ptr)
	var speed: int = _to_s16(int(entity.get_field("movement_62a")))
	var p20: int = entity.get_u16_field("pos_20")
	var a22: int = entity.get_u16_field("attitude_22")
	var f24: int = entity.get_s16_field("field_24") & 0xFFFF
	var wx: int = int(mem_u32.get(world + 0x18, 0))
	var wy: int = int(mem_u32.get(world + 0x1c, 0))
	var wz: int = int(mem_u32.get(world + 0x20, 0))
	last_12840_args = {
		"speed": speed,
		"param_2": 0,
		"world_x": wx,
		"world_y": wy,
		"world_z": wz,
		"pos_20": p20,
		"attitude_22": a22,
		"field_24": f24,
	}
	var table_base: int = int(mem_u32.get(dat_0001d6fc + 0x30, 0))
	var use_pool: bool = table_base != 0 and dat_0001d6fc_slot_count > 0
	var result_handle: int = 0
	if use_pool:
		## Original: 05116(DAT_00026280, xyz, att, 0); entity = *(result+8).
		var world_obj: int = _call_fun_00005116(dat_00026280, wx, wy, wz, p20, a22, f24, 0)
		if world_obj == 0:
			return 0
		result_handle = int(mem_u32.get(world_obj + 8, 0))
		if result_handle == 0:
			return 0
	elif spawn_12840_entity != null:
		result_handle = spawn_12840_handle
	else:
		return 0
	if spawn_12840_entity == null:
		return result_handle
	var wr: Dictionary = FlightMathScript.apply_fun_00012840_spawn_fields(
		speed,
		0,
		p20,
		a22,
		f24,
		spawn_12840_entity.get_u16_field("field_61c")
	)
	spawn_12840_entity.set_u16_field("field_610", int(wr.get("field_610", 0)))
	spawn_12840_entity.set_u16_field("field_61c", int(wr.get("field_61c", 0)))
	spawn_12840_entity.set_u16_field("pos_20", int(wr.get("pos_20", 0)))
	spawn_12840_entity.set_u16_field("attitude_22", int(wr.get("attitude_22", 0)))
	spawn_12840_entity.set_s16_field("field_24", int(wr.get("field_24", 0)))
	return result_handle

## [RECONSTRUCTED] field_676==1 fire gate + 682-=2 + wrap 2→0 (14673–14693).
func _apply_e792_weapon_676_branch(entity: RefCounted) -> void:
	var br: Dictionary = FlightMathScript.apply_e792_weapon_676_branch(
		entity.get_s8_field("field_676"),
		entity.get_s16_field("field_682"),
		entity.get_u8_field("flags_685"),
		entity.get_u16_field("pos_20")
	)
	last_weapon_676_need_15d20 = bool(br.get("need_15d20", false))
	last_weapon_676_fired = bool(br.get("fired", false))
	if last_weapon_676_need_15d20:
		last_15d20_result = _call_fun_00015d20_stub(entity)
		## [DEFERRED] non-null + player → result[0x1b]=1
	entity.set_s8_field("field_676", int(br.get("field_676", 0)))
	entity.set_s16_field("field_682", int(br.get("field_682", 0)))

## [DEFERRED] FUN_00015d20 body. Records args; returns 0.
func _call_fun_00015d20_stub(entity: RefCounted) -> int:
	var world: int = int(entity.world_obj_ptr)
	var tpl_44: int = 0
	if entity.external_template != null:
		tpl_44 = entity.external_template.get_s16_field("field_44")
	var yaw_arg: int = (entity.get_s16_field("movement_626") - tpl_44) & 0x3FFF
	last_15d20_args = {
		"speed": _to_s16(int(entity.get_field("movement_62a"))),
		"param_2": 1,
		"world_x": int(mem_u32.get(world + 0x18, 0)),
		"world_y": int(mem_u32.get(world + 0x1c, 0)),
		"world_z": int(mem_u32.get(world + 0x20, 0)),
		"pos_20": entity.get_u16_field("pos_20"),
		"attitude_22": entity.get_u16_field("attitude_22"),
		"field_24": entity.get_s16_field("field_24") & 0xFFFF,
		"yaw_arg": yaw_arg,
	}
	return 0

## [RECONSTRUCTED] field_677==1 fire + status|1 + player globals (14695–14719).
func _apply_e792_weapon_677_branch(entity: RefCounted) -> void:
	var is_player: bool = entity == designated_player_entity
	var br: Dictionary = FlightMathScript.apply_e792_weapon_677_branch(
		entity.get_s8_field("field_677"),
		entity.get_u8_field("flags_685"),
		entity.get_u16_field("status_1a1"),
		is_player,
		entity.get_s8_field("weapon_count_67d"),
		entity.get_s8_field("weapon_count_67e")
	)
	last_weapon_677_need_19430 = bool(br.get("need_19430", false))
	last_weapon_677_fired = bool(br.get("fired", false))
	if last_weapon_677_need_19430:
		last_19430_result = _call_fun_00019430_stub(entity)
		if is_player:
			if bool(br.get("set_dat_0001b874", false)):
				dat_0001b874 = 1
			if bool(br.get("clear_dat_0001b872", false)):
				dat_0001b872 = 0
			if bool(br.get("set_dat_0001d858_9", false)):
				dat_0001d858 = 9
			if bool(br.get("set_dat_0001b87a", false)):
				dat_0001b87a = 1
			dat_0001b87c = last_19430_result
			## [DEFERRED] world+7 & 0x40 clear, FUN_000137da, FUN_00006ed6
	entity.set_s8_field("field_677", int(br.get("field_677", 0)))
	entity.set_u16_field("status_1a1", int(br.get("status_1a1", 0)))

## [DEFERRED] FUN_00019430 body. Records args; returns 0.
func _call_fun_00019430_stub(entity: RefCounted) -> int:
	var world: int = int(entity.world_obj_ptr)
	last_19430_args = {
		"speed": _to_s16(int(entity.get_field("movement_62a"))),
		"world_x": int(mem_u32.get(world + 0x18, 0)),
		"world_y": int(mem_u32.get(world + 0x1c, 0)),
		"world_z": int(mem_u32.get(world + 0x20, 0)),
		"pos_20": entity.get_u16_field("pos_20"),
		"attitude_22": entity.get_u16_field("attitude_22"),
		"field_24": entity.get_s16_field("field_24") & 0xFFFF,
	}
	return 0

## [RECONSTRUCTED] flags_685&2 ammo tail (14721–14734); 11544-callsite draws [INFERRED].
func _apply_e792_flags685_bit2_tail(entity: RefCounted) -> void:
	last_flags685_bit2_active = false
	last_flags685_bit2_dec_67d = false
	last_flags685_bit2_dec_67e = false
	var flags: int = entity.get_u8_field("flags_685")
	if (flags & 2) == 0:
		return
	var draws: Array = [_rng_consume_11544_callsite()]
	## Second draw only when first &0x3f == 0 (matches original control flow).
	if (int(draws[0]) & 0x3F) == 0:
		draws.append(_rng_consume_11544_callsite())
	var br: Dictionary = FlightMathScript.apply_e792_flags685_bit2_tail(
		flags,
		entity.get_s8_field("weapon_count_67d"),
		entity.get_s8_field("weapon_count_67e"),
		draws
	)
	last_flags685_bit2_active = bool(br.get("active", false))
	last_flags685_bit2_dec_67d = bool(br.get("decremented_67d", false))
	last_flags685_bit2_dec_67e = bool(br.get("decremented_67e", false))
	entity.set_s8_field("weapon_count_67d", int(br.get("weapon_count_67d", 0)))
	entity.set_s8_field("weapon_count_67e", int(br.get("weapon_count_67e", 0)))

## [RECONSTRUCTED] bVar6 cleanup (14736–14748).
func _apply_e792_bvar6_cleanup(entity: RefCounted) -> void:
	var cu: Dictionary = FlightMathScript.apply_e792_bvar6_cleanup(
		e792_b_var6,
		entity.get_u16_field("status_1a1"),
		entity.get_s16_field("status_1a2")
	)
	last_bvar6_cleanup_applied = bool(cu.get("applied", false))
	if not last_bvar6_cleanup_applied:
		return
	entity.set_u16_field("status_1a1", int(cu.get("status_1a1", 0)))
	entity.set_s16_field("status_1a2", int(cu.get("status_1a2", 0)))
	entity.set_field("state_32", int(cu.get("state_32", 0)))
	if bool(cu.get("clear_61a_61e", false)):
		entity.set_s16_field("movement_61a", 0)
		entity.set_s16_field("movement_61e", 0)

func _to_s16(value: int) -> int:
	value &= 0xFFFF
	return value - 0x1_0000 if (value & 0x8000) != 0 else value

## [RECONSTRUCTED] FUN_00013452(world): 13346(*(w+0x18),*(w+0x1c),*(w+0x20)); store to field_0b.
func _apply_fun_00013452_hard_crash(entity: RefCounted) -> void:
	var world: int = int(entity.world_obj_ptr)
	var wx: int = int(mem_u32.get(world + 0x18, 0))
	var wy: int = int(mem_u32.get(world + 0x1c, 0))
	var wz: int = int(mem_u32.get(world + 0x20, 0))
	last_13452_args = {"world": world, "x_18": wx, "y_1c": wy, "z_20": wz}
	last_13452_result = FlightMathScript.fun_00013452(
		wx, wy, wz, dat_0001c1e0_count, dat_0001bda8_plus_16
	)
	entity.set_u8_field("field_0b", last_13452_result & 0xFF)

func _entity_s32(entity: RefCounted, key: String) -> int:
	var v: int = entity.get_field(key) & 0xFFFFFFFF
	return v - 0x1_0000_0000 if v >= 0x8000_0000 else v

func compute_template_field_40_adjustment(entity: RefCounted) -> int:
	var template: RefCounted = entity.external_template
	if template == null:
		return 0
	return FlightMathScript.compute_template_field_40_adjustment(
		template.get_s16_field("field_40"),
		entity.get_s8_field("direction_char_679")
	)

## Snapshot first entity in entity_array_2 (player) as proven-offset dict; null if none.
func _snapshot_player() -> Variant:
	if entity_array_2.is_empty():
		return null
	var entity: RefCounted = entity_array_2[0]
	var out: Dictionary = {}
	for key in EntityStateScript.OFFSETS:
		var v: int = entity.get_field(key)
		if v != 0:
			out[key] = v
	return out if out.size() > 0 else null

func get_tick_count() -> int:
	return _tick_count

## Return a copy of the trace buffer (for tests or logging). Clear with clear_trace().
func get_trace() -> Array:
	return _trace.duplicate()

## Last trace record (after latest tick); for TraceWriter. Returns null if none.
func get_last_trace_record() -> Variant:
	if _trace.is_empty():
		return null
	return _trace[_trace.size() - 1]

func clear_trace() -> void:
	_trace.clear()

## Push a key/action for this frame (consumed in tick).
func push_input(action: String, value: int) -> void:
	input_packet[action] = value

## Clear input after tick (call at start of tick or end).
func clear_input() -> void:
	input_packet.clear()

func load_loader_metadata_from_json_text(text: String) -> void:
	loader_metadata = LoaderMetadataScript.from_json_text(text)

func load_loader_metadata_from_file(path: String) -> void:
	loader_metadata = LoaderMetadataScript.from_file(path)

func resolve_loader_target(segment_id: int, stored_tail: int) -> Dictionary:
	return loader_metadata.get_target(segment_id, stored_tail)

## Resolve loader target by ID00 jump-table entry offset (A5-relative; LOADER_CHAIN §5).
func resolve_loader_target_by_id00_entry_offset(id00_entry_offset: int) -> Dictionary:
	return loader_metadata.get_target_by_id00_entry_offset(id00_entry_offset)

func get_loader_target_count() -> int:
	return loader_metadata.get_target_count()
