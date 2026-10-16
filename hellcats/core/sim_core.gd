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
## [RECONSTRUCTED] *(DAT_0001b5a0 + 0xb0) — gates FUN_000044a4 type-5 flag 0x40.
var mission_short_b0: int = 0
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
var last_05116_grew: bool = false
var last_05116_need_051ec: bool = false
## Next table base for 01ba8 grow (avoids overlapping old mem_u32 keys).
var spawn_05116_grow_table_base: int = 0xA000
var dat_00026280: int = 0
## [RECONSTRUCTED] pool+0x2c short compared in FUN_000046da (5233).
var dat_0001d6fc_short_2c: int = 0
var last_046da_identity: Dictionary = {}
var last_045ba: Dictionary = {}
## Camera globals for FUN_00003b98 (Capstone SUBA DAT_0001d838/834/830).
var dat_0001d838: int = 0
var dat_0001d834: int = 0
var dat_0001d830: int = 0
## Optional override of abs axes; null → derive from world+0x18/1c/20 − camera.
var spawn_046da_03b98_axes_override = null
## Last 04e6e kind2 +0x4c payload (01a68 stand-in for Ghidra FUN_00001a48 call sites).
var spawn_04e6e_ptr_4c: int = 0
## When true, keep fixed spawn_04e6e_ptr_4c / world_field_44 instead of heap alloc.
var spawn_04e6e_use_mock_ptrs: bool = false
## Last FUN_00001a68 buffer payload for FUN_00004808 → obj+0x48 (updated each spawn).
var spawn_04808_buf_ptr: int = 0
## Last FUN_00001a68 index payload for poly0 → record+0x18 (updated each spawn).
var spawn_04808_index_ptr: int = 0
## Optional poly desc stream base in mem_u32; 0 → skip record fill.
var spawn_04808_desc_ptr: int = 0
## Optional PackedInt32Array / Array of u16 index words after desc+0x0E (poly 0).
## Or Array of Arrays — one word list per poly when multi-poly loop is active.
var spawn_04808_index_words: Array = []
## Legacy mock stride (unused when per-poly 01a68 alloc is active).
var spawn_04808_index_stride: int = 0x100
## Persistent 01a68 heap state (bump + small/large freelists).
var heap_01a68: Dictionary = {}
## When true, keep fixed spawn_04808_* mocks instead of 01a68 (tests only).
var spawn_04808_use_mock_ptrs: bool = false
## [RECONSTRUCTED] FUN_00004e6e kind2 list heads (world-obj ptrs, not EntityState arrays).
var dat_0001b5a4_world: Array = []
var dat_0001d4a4_world: Array = []
## Far-list for 046da when 03b98 metric − obj+0xc >= 0x19c80 (decomp ~5257).
var dat_0001d0e4_world: Array = []
var dat_0001c1dc_count: int = 0
var dat_0001daa2: int = 0
var last_03b98: Dictionary = {}
var last_03b98_axes: Dictionary = {}
var last_046da_04e6e_gate: Dictionary = {}
var last_04e6e_kind2: Dictionary = {}
var last_04e6e_list: Dictionary = {}
var last_04808: Dictionary = {}
## Optional mesh/desc base for post-04808 FUN_00002bd8 arg3 (mocked).
var spawn_02bd8_mesh_ptr: int = 0
## Template nodes for 02bd8 walks: {s2,s4,s6,dx,dy,dz} (no-rotate only).
var spawn_02bd8_nodes: Array = []
## Flat xyz triples for both-aux mesh source (01c5c count = 02bd8 param_2).
var spawn_02bd8_mesh_xyz: Array = []
var last_02bd8_gate: Dictionary = {}
var last_02bd8_args: Dictionary = {}
var last_02bd8_commit: Dictionary = {}
var last_02bd8_walk: Dictionary = {}
## 046da-site 02bd8(obj,1,null,null) — kept when nested 04e6e overwrites last_02bd8_*.
var last_046da_02bd8_commit: Dictionary = {}
var last_046da_02bd8_walk: Dictionary = {}
## Optional node list override for 046da 02bd8 walk; null → build from +0x24 chain.
var spawn_046da_02bd8_nodes = null
var last_04e6e_followup: Dictionary = {}
var last_04e6e_path: Dictionary = {}
var last_01c5c: Dictionary = {}
var last_03ea0: Dictionary = {}
var last_15762: Dictionary = {}
var last_04958: Dictionary = {}
var last_04916: Dictionary = {}
## DAT_0001b190 distance-band table for FUN_00003da8 (b18c[s]=table[s-1]).
## Loaded from ROM fixture in _init; mock fallback only if fixture missing.
var dat_0001b190: Array = []
var last_03da8: Dictionary = {}
## Fallback *(template+0xe) when parent/embed chain cannot be resolved.
var spawn_0435a_scale_src: int = 0x1000
## Fallback per-poly *(stream+10) when template stream cannot be walked.
var spawn_0435a_poly_srcs: Array = []
## When set, treat world+8 as player entity for 0435a *5 path (DAT_0001b738).
var spawn_0435a_is_player: bool = false
var last_0435a: Dictionary = {}
var last_044a4: Dictionary = {}
## Last 04690/046da vtable +8 install result.
var last_04690_plus8: Dictionary = {}
## DAT_0001b524 keyed template pointers (FUN_00000054 Block A publish).
var dat_0001b524: Dictionary = {}
## When set to install imm (e.g. 0x16A1A / 0x11590), 046da runs real factory body.
var spawn_1b524_factory_imm: int = 0
## Optional 1b524 key override; <0 → use desc[1] (04690). Tests may set 0x5858/0x0999.
var spawn_1b524_type_key: int = -1
## DAT_0001b540 published pointer (FUN_00000054 Block B → 115b0 handle+4).
var dat_0001b540: int = 0
## Absolute fixed slots from 00054 Block B (key=slot_abs → payload_ptr).
var dat_00054_fixed_slots: Dictionary = {}
var last_00054_block_b: Dictionary = {}
## Last FUN_00016a3a / 115b0 factory apply result (empty when mock handle path).
var last_16a3a_factory: Dictionary = {}
var last_115b0_factory: Dictionary = {}
## Last 1b524 factory resolve (tpl+6 vs fallback imm).
var last_1b524_factory_resolve: Dictionary = {}
var _fun_0000435a_calls_this_tick: int = 0
var last_046da_deferred: bool = false
var last_weapon_676_fired: bool = false
var last_weapon_676_need_15d20: bool = false
var last_15d20_args: Dictionary = {}
var last_15d20_result: int = 0
## [INFERRED] Mock *(05116+8) for FUN_00015bf6 / 15d20 field writes.
var spawn_15bf6_entity: RefCounted = null
var spawn_15bf6_handle: int = 0x15BF6
var dat_0002664a: int = 0
var last_15bf6_locals: Dictionary = {}
var last_weapon_677_fired: bool = false
var last_weapon_677_need_19430: bool = false
var last_19430_args: Dictionary = {}
var last_19430_result: int = 0
## [INFERRED] Mock *(05116+8) for FUN_00019430 field writes.
var spawn_19430_entity: RefCounted = null
var spawn_19430_handle: int = 0x19430
var dat_00026780: int = 0
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
	dat_0001b190 = FlightMathScript.load_dat_0001b190_table()
	heap_01a68 = {"heap_cursor": 0, "heap_base": 0x100000}
	dat_00054_fixed_slots = {}
	last_00054_block_b = {}
	overlay_00054_published = false
	last_00054_all = {}
	last_016e2 = {}
	last_016e2_child_table = {}
	dat_0001b5a0 = 0
	spawn_04690_obj = 0
	spawn_04690_child_objs = []
	last_04690 = {}
	dat_0001bdb4 = 0
	dat_0001bdb0 = 0
	dat_0001bdac = 0
	dat_0001bda8 = 0
	dat_0001bda4 = 0
	dat_0001b734 = 0
	dat_0001bc28 = 0
	dat_0001bc34 = 0
	dat_0001bc38 = 0
	last_016e2_child_04690 = {}
	last_016e2_bdb_hooks = {}
	last_016e2_bda_tail = {}
	last_04e4e_calls = []
	last_01be4_calls = []
	last_04e6e_calls = []
	last_01c04_calls = []
	spawn_01be4_new_ptr = 0
	spawn_01be4_nbytes = -1
	spawn_046da_child_objs = []
	last_046da_kind3_calls = []
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
	_fun_0000435a_calls_this_tick = 0
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

## Per-entity update: FUN_000044a4 (0435a + type-5 flags), then e792 slices [MVP mix].
func _update_single_entity(entity: RefCounted, param_2: int, _pass_id: int) -> void:
	if entity == null:
		return
	## [RECONSTRUCTED] FUN_000044a4(world, param_2) (5079–5091).
	var world: int = int(entity.world_obj_ptr)
	if world != 0:
		_apply_fun_000044a4(world, param_2)
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
## Capstone @0xE864–0xE894: 11544×2 → 61e/field_24 and 61a/pos_20, then clear 669 / early exit.
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
	var att: Dictionary = FlightMathScript.apply_contact_61a_61e_attitude(
		_rng_consume_11544_callsite(),
		_rng_consume_11544_callsite(),
		entity.get_s16_field("movement_61e"),
		entity.get_s16_field("movement_61a"),
		entity.get_s16_field("field_24"),
		entity.get_u16_field("pos_20")
	)
	entity.set_s16_field("movement_61e", int(att.get("movement_61e", 0)))
	entity.set_s16_field("movement_61a", int(att.get("movement_61a", 0)))
	entity.set_s16_field("field_24", int(att.get("field_24", 0)))
	entity.set_u16_field("pos_20", int(att.get("pos_20", 0)))
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

## [RECONSTRUCTED] FUN_00001ba8 table grow for 05116 (2252–2271, 5726–5731).
## Copies old slots to a new base, zeros +10 slots, count+=10. Real 01b84/019d0 deferred.
func _grow_05116_table(old_base: int, old_count: int) -> int:
	var plan: Dictionary = FlightMathScript.apply_01ba8_05116_grow(old_count)
	var new_count: int = int(plan.get("new_count", old_count + 10))
	var new_base: int = spawn_05116_grow_table_base
	spawn_05116_grow_table_base = new_base + new_count * 0x18 + 0x40
	for i in range(old_count):
		var src: int = old_base + i * 0x18
		var dst: int = new_base + i * 0x18
		for off in [0, 2, 4, 6, 8, 0xC, 0x10, 0x14]:
			mem_u32[dst + off] = int(mem_u32.get(src + off, 0))
	for i in range(old_count, new_count):
		var dst2: int = new_base + i * 0x18
		for off2 in [0, 2, 4, 6, 8, 0xC, 0x10, 0x14]:
			mem_u32[dst2 + off2] = 0
	mem_u32[dat_0001d6fc + 0x30] = new_base
	dat_0001d6fc_slot_count = new_count
	last_05116_grew = true
	return new_base


## [RECONSTRUCTED] FUN_000046da: 045ba → identity → 02bd8(walk+commit) → +8 → 0435a(…,1) → gate.
## [DEFERRED] real 01b6c/01a48 heap.
func _read_045ba_desc(desc_ptr: int) -> Dictionary:
	var d: Dictionary = {
		0: int(mem_u32.get(desc_ptr, 0)) & 0xFF,
		2: int(mem_u32.get(desc_ptr + 2, 0)),
		6: int(mem_u32.get(desc_ptr + 6, 0)),
		10: int(mem_u32.get(desc_ptr + 10, 0)),
		0x0E: int(mem_u32.get(desc_ptr + 0x0E, 0)),
		0x12: int(mem_u32.get(desc_ptr + 0x12, 0)),
		0x16: int(mem_u32.get(desc_ptr + 0x16, 0)),
		0x18: int(mem_u32.get(desc_ptr + 0x18, 0)),
		0x1A: int(mem_u32.get(desc_ptr + 0x1A, 0)),
		0x1C: int(mem_u32.get(desc_ptr + 0x1C, 0)),
		0x1E: int(mem_u32.get(desc_ptr + 0x1E, 0)),
		0x20: int(mem_u32.get(desc_ptr + 0x20, 0)),
		"desc_ptr": desc_ptr,
	}
	return d


func _apply_045ba_result_to_mem(obj: int, result: Dictionary) -> void:
	var u8m: Dictionary = result.get("u8", {})
	var u16m: Dictionary = result.get("u16", {})
	var u32m: Dictionary = result.get("u32", {})
	for k in u8m.keys():
		mem_u32[obj + int(k)] = int(u8m[k]) & 0xFF
	for k in u16m.keys():
		mem_u32[obj + int(k)] = int(u16m[k]) & 0xFFFF
	for k in u32m.keys():
		mem_u32[obj + int(k)] = int(u32m[k]) & 0xFFFFFFFF


## [RECONSTRUCTED] FUN_00000054 Block B → fixed slots; sets dat_0001b540 for 115b0.
func publish_00054_block_b() -> Dictionary:
	dat_00054_fixed_slots = {}
	last_00054_block_b = FlightMathScript.apply_00054_block_b(heap_01a68, dat_00054_fixed_slots)
	dat_0001b540 = int(last_00054_block_b.get("dat_0001b540", 0))
	## Mirror absolute slot globals into mem_u32 for tpl-style reads.
	for slot_abs in dat_00054_fixed_slots.keys():
		mem_u32[int(slot_abs)] = int(dat_00054_fixed_slots[slot_abs])
	return last_00054_block_b


## Last Block C / D publish results.
var last_00054_block_c: Dictionary = {}
var last_00054_block_d: Dictionary = {}


## [RECONSTRUCTED] FUN_00000054 Block C → DAT_0001b524[key] (5×0x1C; ROM keys=0).
func publish_00054_block_c() -> Dictionary:
	last_00054_block_c = FlightMathScript.apply_00054_block_c(heap_01a68, dat_0001b524)
	return last_00054_block_c


## [RECONSTRUCTED] FUN_00000054 Block D → DAT_0001b58c…1b59c (merged into fixed_slots).
func publish_00054_block_d() -> Dictionary:
	last_00054_block_d = FlightMathScript.apply_00054_block_d(heap_01a68, dat_00054_fixed_slots)
	for slot_abs in dat_00054_fixed_slots.keys():
		mem_u32[int(slot_abs)] = int(dat_00054_fixed_slots[slot_abs])
	return last_00054_block_d


## [RECONSTRUCTED] Full FUN_00000054 overlay: Blocks A–D.
func publish_00054_all() -> Dictionary:
	dat_0001b524.clear()
	var a: Dictionary = FlightMathScript.apply_00054_first_loop(heap_01a68, dat_0001b524)
	var b: Dictionary = publish_00054_block_b()
	var c: Dictionary = publish_00054_block_c()
	var d: Dictionary = publish_00054_block_d()
	var out: Dictionary = {
		"ok": bool(a.get("ok", false))
			and bool(b.get("ok", false))
			and bool(c.get("ok", false))
			and bool(d.get("ok", false)),
		"block_a": a,
		"block_b": b,
		"block_c": c,
		"block_d": d,
	}
	last_00054_all = out
	overlay_00054_published = bool(out.get("ok", false))
	return out


## True after a successful publish_00054_all / init_mission_object_tables entry.
var overlay_00054_published: bool = false
var last_00054_all: Dictionary = {}
## Last FUN_000016e2 (init_mission_object_tables) slice result.
var last_016e2: Dictionary = {}
## Mission/base record (FUN_000016e2 reads +0x8c as root desc).
var dat_0001b5a0: int = 0
## Mock object storage for FUN_00004690 / 045ba result (root instantiate).
var spawn_04690_obj: int = 0
## Optional per-child 04690 object ptrs for FUN_000016e2 second loop; else 01a68 stand-ins.
var spawn_04690_child_objs: Array = []
var last_04690: Dictionary = {}
## DAT_0001bdb4/b0/ac/a8/a4 = resolved children after 016e2 publish hooks.
var dat_0001bdb4: int = 0
var dat_0001bdb0: int = 0
var dat_0001bdac: int = 0
var dat_0001bda8: int = 0
var dat_0001bda4: int = 0
## DAT_0001b734 entity_array_2 count — cleared at end of 016e2 (Capstone clr.l).
var dat_0001b734: int = 0
## Camera/window child trio (Capstone stores at bc28 / bc28+0xC / bc28+0x10).
var dat_0001bc28: int = 0
var dat_0001bc34: int = 0
var dat_0001bc38: int = 0
var last_016e2_child_04690: Dictionary = {}
var last_016e2_bdb_hooks: Dictionary = {}
var last_016e2_bda_tail: Dictionary = {}
## Call logs for setup stubs (bodies deferred).
var last_04e4e_calls: Array = []
var last_01be4_calls: Array = []
var last_04e6e_calls: Array = []
var last_01c04_calls: Array = []


## [RECONSTRUCTED] FUN_00004690 instantiate_object_from_desc (Capstone @0x4690–0x46D8).
## 045ba(desc) → obj; if desc[1]≠0 factory→handle at obj+8 (mock handle); return obj.
## Capstone type = EXTB of byte desc+1. [DEFERRED] live 1b524[byte] factory bodies here.
func _call_fun_00004690(desc: int) -> int:
	last_04690 = {}
	last_04690_plus8 = {}
	if desc == 0 or spawn_04690_obj == 0:
		last_04690 = {"ok": false, "reason": "no_desc_or_obj", "desc": desc}
		return 0
	var desc_fields: Dictionary = _read_045ba_desc(desc)
	var ba: Dictionary = FlightMathScript.apply_045ba_from_desc(desc_fields, dat_0001b838)
	last_045ba = ba
	if bool(ba.get("ok", false)):
		_apply_045ba_result_to_mem(spawn_04690_obj, ba)
	## Capstone @0x46A2–0x46AC: TST.B / MOVE.B / EXTB.L
	var type_u: int = int(mem_u32.get(desc + 1, 0)) & 0xFF
	last_04690_plus8 = FlightMathScript.apply_04690_vtable_plus8(
		type_u, spawn_05116_entity_handle
	)
	if bool(last_04690_plus8.get("install", false)):
		var hptr: int = int(last_04690_plus8.get("handle_ptr", 0))
		mem_u32[spawn_04690_obj + 8] = hptr
		if bool(last_04690_plus8.get("clear_handle", false)):
			mem_u32[hptr] = 0
	else:
		mem_u32[spawn_04690_obj + 8] = 0
	last_04690 = {
		"ok": true,
		"desc": desc,
		"root": spawn_04690_obj,
		"type_byte": type_u,
		"plus8": last_04690_plus8,
	}
	return spawn_04690_obj


## Last child-table build from FUN_000016e2 (alloc/copy/relocate).
var last_016e2_child_table: Dictionary = {}


## [RECONSTRUCTED] FUN_000016e2 child×0x18 table (Capstone @0x1704–0x1764).
## alloc count*0x18 → root+0x30; copy from *(root+0x28)+0x1A; relocate +0x14 by b5a0+0x8c.
## [DEFERRED] second loop: per-child 04690 + back-link.
func _016e2_build_child_table(root: int, mission_base_8c: int) -> Dictionary:
	var count: int = int(mem_u32.get(root + 0x2E, 0)) & 0xFFFF
	var nbytes: int = FlightMathScript.apply_016e2_child_table_bytes(count)
	var src_base: int = FlightMathScript.apply_016e2_child_src_base(
		int(mem_u32.get(root + 0x28, 0))
	)
	var alloc: Dictionary = {"ok": false}
	var table_ptr: int = 0
	if nbytes > 0:
		alloc = FlightMathScript.apply_01a68_alloc(nbytes, heap_01a68)
		table_ptr = int(alloc.get("payload_ptr", 0))
	mem_u32[root + 0x30] = table_ptr
	## Capstone MOVEA.W root+0x2E — treat as s16 count.
	var count_s: int = count if count < 0x8000 else count - 0x10000
	if count_s < 0:
		count_s = 0
	dat_0001d6fc_slot_count = count_s
	var copied: Array = []
	for i in range(count_s):
		var src_words: Array = []
		var src: int = src_base + i * 0x18
		for w in range(6):
			src_words.append(int(mem_u32.get(src + w * 4, 0)))
		var rec: Dictionary = FlightMathScript.apply_016e2_copy_child_record(src_words)
		var words: Array = rec.get("words", []) as Array
		var dest: int = table_ptr + i * 0x18
		for w in range(6):
			mem_u32[dest + w * 4] = int(words[w]) & 0xFFFFFFFF
		var name0: int = int(words[5]) & 0xFFFFFFFF
		var name1: int = FlightMathScript.apply_016e2_relocate_child_name(name0, mission_base_8c)
		mem_u32[dest + 0x14] = name1
		copied.append({
			"index": i,
			"dest": dest,
			"field_14_raw": name0,
			"field_14": name1,
		})
	return {
		"ok": nbytes == 0 or (bool(alloc.get("ok", false)) and table_ptr != 0),
		"count": count_s,
		"bytes": nbytes,
		"table_ptr": table_ptr,
		"src_base": src_base,
		"alloc": alloc,
		"records": copied,
	}


## [RECONSTRUCTED] FUN_000016e2 per-child 04690 (Capstone @0x176C–0x17A0).
## desc=*(table+i*0x18+0x14) → 04690 → store obj back; link +0x24/+1/+2; then bdb4=child0.
func _016e2_resolve_children(root: int, table_ptr: int, count: int) -> Dictionary:
	var saved_root_obj: int = spawn_04690_obj
	var saved_handle: int = spawn_05116_entity_handle
	var kids: Array = []
	var ok_all := true
	for i in range(count):
		var slot: int = table_ptr + i * 0x18
		var child_desc: int = int(mem_u32.get(slot + 0x14, 0))
		var child_obj: int = 0
		if i < spawn_04690_child_objs.size():
			child_obj = int(spawn_04690_child_objs[i])
		else:
			## [INFERRED] 045ba heap stand-in — 0x52 covers kind-2 object size.
			var ha: Dictionary = FlightMathScript.apply_01a68_alloc(0x52, heap_01a68)
			child_obj = int(ha.get("payload_ptr", 0))
			if not bool(ha.get("ok", false)):
				ok_all = false
		spawn_04690_obj = child_obj
		## Distinct mock handle per child so plus8 clear does not collide.
		spawn_05116_entity_handle = (saved_handle + 0x100 * (i + 1)) if saved_handle != 0 else 0
		var obj: int = _call_fun_00004690(child_desc)
		mem_u32[slot + 0x14] = obj
		var link: Dictionary = FlightMathScript.apply_016e2_link_child(root, i)
		if obj != 0:
			mem_u32[obj + 0x24] = int(link.get("field_24", 0))
			mem_u32[obj + 1] = int(link.get("field_01", 0))
			mem_u32[obj + 2] = int(link.get("field_02", 0))
		else:
			ok_all = false
		kids.append({
			"index": i,
			"desc": child_desc,
			"obj": obj,
			"link": link,
			"04690": last_04690.duplicate(),
		})
	spawn_04690_obj = saved_root_obj
	spawn_05116_entity_handle = saved_handle
	var child0: int = 0
	if table_ptr != 0 and count > 0:
		child0 = int(mem_u32.get(table_ptr + 0x14, 0))
	var bdb4: Dictionary = FlightMathScript.apply_016e2_publish_bdb4(child0)
	dat_0001bdb4 = int(bdb4.get("dat_0001bdb4", 0))
	return {
		"ok": ok_all,
		"count": count,
		"children": kids,
		"bdb4": bdb4,
		"dat_0001bdb4": dat_0001bdb4,
	}


## [RECONSTRUCTED] FUN_00004e06 body via 016e2's mid-entry at $4E4E (Capstone @0x4E06–0x4E6C).
## Full path: gate bit1(obj+7); resolve desc; copy +18/1c/20/14; 02bd8(obj,1,0,0).
## [PROVEN] Capstone 016e2 LEA/JSR $4E4E (not $4E06); equivalent effect uses stack arg=obj.
func _call_fun_00004e4e(obj: int) -> Dictionary:
	var r: Dictionary = {
		"fn": "04e4e",
		"obj": int(obj) & 0xFFFFFFFF,
		"skipped": false,
		"copied": false,
		"called_02bd8": false,
	}
	if obj == 0:
		r["ok"] = false
		r["reason"] = "null_obj"
		last_04e4e_calls.append(r)
		return r
	var byte07: int = int(mem_u32.get(obj + 7, 0)) & 0xFF
	var gate: Dictionary = FlightMathScript.apply_04e06_gate(byte07)
	r["gate"] = gate
	if bool(gate.get("skip", false)):
		r["skipped"] = true
		r["ok"] = true
		last_04e4e_calls.append(r)
		return r
	var parent: int = int(mem_u32.get(obj + 0x24, 0))
	var parent_28: int = int(mem_u32.get(parent + 0x28, 0)) if parent != 0 else 0
	var idx: int = int(mem_u32.get(obj + 1, 0)) & 0xFF
	var b5a0_8c: int = int(mem_u32.get(dat_0001b5a0 + 0x8C, 0)) if dat_0001b5a0 != 0 else 0
	var slot: int = parent_28 + 0x2E + idx * 0x18
	var raw_off: int = int(mem_u32.get(slot, 0))
	var dres: Dictionary = FlightMathScript.apply_04e06_desc_ptr(
		parent_28, idx, b5a0_8c, raw_off
	)
	var desc: int = int(dres.get("desc_ptr", 0))
	r["desc"] = dres
	var copies: Dictionary = FlightMathScript.apply_04e06_field_copies(
		int(mem_u32.get(desc + 2, 0)),
		int(mem_u32.get(desc + 6, 0)),
		int(mem_u32.get(desc + 0xA, 0)),
		int(mem_u32.get(desc + 0x12, 0)),
	)
	mem_u32[obj + 0x18] = int(copies.get("field_18", 0))
	mem_u32[obj + 0x1C] = int(copies.get("field_1c", 0))
	mem_u32[obj + 0x20] = int(copies.get("field_20", 0))
	mem_u32[obj + 0x14] = int(copies.get("field_14", 0))
	r["copies"] = copies
	r["copied"] = true
	## 02bd8(obj,1,null,null): commit locals (already written) when chain empty.
	var f24: int = int(mem_u32.get(obj + 0x24, 0))
	var commit: Dictionary = FlightMathScript.apply_02bd8_null_aux_commit(
		int(mem_u32.get(obj + 0x18, 0)),
		int(mem_u32.get(obj + 0x1C, 0)),
		int(mem_u32.get(obj + 0x20, 0)),
		0,
		0,
		f24,
	)
	r["02bd8_commit"] = commit
	r["called_02bd8"] = true
	r["ok"] = bool(dres.get("ok", false))
	last_04e4e_calls.append(r)
	return r


## Optional harness for 01be4 mid-entry (A2=old, D2=new, D3=nbytes).
## 016e2 LEA A2=$1BE4 clobbers old-ptr — leave 0 until register ABI is recovered.
var spawn_01be4_new_ptr: int = 0
var spawn_01be4_nbytes: int = -1


## [RECONSTRUCTED] FUN_00001be4 = FUN_00001ba8 mid-entry @ $1BE4 (Capstone @0x1BE4–0x1C00).
## Tail: 1a63e(old,new,nbytes) + 019d0(old). Full 01ba8 gate is before this entry.
func _call_fun_00001be4(obj: int) -> Dictionary:
	var r: Dictionary = {
		"fn": "01be4",
		"obj": int(obj) & 0xFFFFFFFF,
		"is_01ba8_mid_entry": true,
		"entry": "1be4",
	}
	if spawn_01be4_new_ptr == 0 or spawn_01be4_nbytes < 0:
		r["ok"] = true
		r["deferred_abi"] = true
		r["reason"] = "016e2_LEA_clobbers_A2_or_no_harness_new"
		last_01be4_calls.append(r)
		return r
	var tail: Dictionary = FlightMathScript.apply_01be4_tail(
		obj, spawn_01be4_new_ptr, spawn_01be4_nbytes
	)
	r["tail"] = tail
	var nbytes: int = int(tail.get("nbytes", 0))
	var nwords: int = (nbytes + 3) >> 2
	var src_words: Array = []
	var dst_words: Array = []
	for i in range(nwords):
		src_words.append(int(mem_u32.get(obj + i * 4, 0)))
		dst_words.append(int(mem_u32.get(spawn_01be4_new_ptr + i * 4, 0)))
	var copied: Dictionary = FlightMathScript.fun_0001a63e_copy_bytes(
		dst_words, src_words, nbytes
	)
	var out_words: Array = copied.get("words", [])
	for i in range(out_words.size()):
		mem_u32[spawn_01be4_new_ptr + i * 4] = int(out_words[i]) & 0xFFFFFFFF
	r["1a63e"] = copied
	## 019d0(old): invoke only when payload is a tracked heap block.
	var hdr: int = (obj - 4) & 0xFFFFFFFF
	var tracked: bool = (heap_01a68.get("block_class", {}) as Dictionary).has(hdr)
	if tracked:
		r["019d0"] = FlightMathScript.apply_019d0_free_small(obj, heap_01a68)
	else:
		r["019d0"] = {"fn": "019d0", "obj": obj, "deferred_untracked": true}
	r["result_ptr"] = int(tail.get("result_ptr", 0))
	r["ok"] = bool(tail.get("ok", false))
	r["deferred_abi"] = false
	last_01be4_calls.append(r)
	return r


## [RECONSTRUCTED] FUN_00004e6e kind2 after +0x4c/+0x44: 04808 → 02bd8 → 0435a → 03da8.
## Shared by `_call_fun_00004e6e` (016e2) and nested 046da near-path.
func _04e6e_kind2_04808_followup(obj: int) -> Dictionary:
	var f36: int = int(mem_u32.get(obj + 0x36, 0))
	var f3a: int = int(mem_u32.get(obj + 0x3A, 0))
	var byte06: int = int(mem_u32.get(obj + 6, 0)) & 0xFF
	var byte07: int = int(mem_u32.get(obj + 7, 0)) & 0xFF
	var f38: int = int(mem_u32.get(obj + 0x38, 0))
	var buf_bytes: int = FlightMathScript.apply_04808_buffer_bytes(f3a, f38, byte06)
	var buf_alloc: Dictionary = {}
	var buf_ptr: int = spawn_04808_buf_ptr
	if spawn_04808_use_mock_ptrs and buf_ptr != 0:
		buf_alloc = {"ok": true, "payload_ptr": buf_ptr, "mocked": true}
	else:
		buf_alloc = FlightMathScript.apply_01a68_alloc(buf_bytes, heap_01a68)
		buf_ptr = int(buf_alloc.get("payload_ptr", 0))
		spawn_04808_buf_ptr = buf_ptr
	mem_u32[obj + 0x48] = buf_ptr
	last_04808 = {
		"buffer_bytes": buf_bytes,
		"field_48": buf_ptr,
		"buf_alloc": buf_alloc,
		"index_allocs": [],
	}
	## Desc stream: spawn override, else tpl+0x22+(36+3a)*0xC (5644–5647).
	var desc_ptr: int = spawn_04808_desc_ptr
	var desc_source: String = "spawn"
	if desc_ptr == 0:
		var tpl_r: Dictionary = _0435a_resolve_scale_src(obj)
		var tpl: int = int(tpl_r.get("template_ptr", 0))
		if tpl != 0:
			var daddr: Dictionary = FlightMathScript.apply_04e6e_04808_desc_addr(tpl, f36, f3a)
			desc_ptr = int(daddr.get("desc_ptr", 0))
			desc_source = "mem_tpl"
			last_04808["desc_addr"] = daddr
	last_04808["desc_source"] = desc_source
	if desc_ptr != 0 and _to_s16(f3a) > 0:
		var poly_n: int = _to_s16(f3a)
		var polys: Array = []
		var stream_off: int = 0
		for pi in range(poly_n):
			var dp: int = desc_ptr + stream_off
			var poly_desc: Dictionary = {
				0: int(mem_u32.get(dp + 0, 0)),
				4: int(mem_u32.get(dp + 4, 0)),
				5: int(mem_u32.get(dp + 5, 0)),
				6: int(mem_u32.get(dp + 6, 0)),
				7: int(mem_u32.get(dp + 7, 0)),
				8: int(mem_u32.get(dp + 8, 0)),
				9: int(mem_u32.get(dp + 9, 0)),
				0x0A: int(mem_u32.get(dp + 0x0A, 0)),
			}
			var words_in: Array = []
			if spawn_04808_index_words.size() > 0 and spawn_04808_index_words[0] is Array:
				if pi < spawn_04808_index_words.size():
					words_in = spawn_04808_index_words[pi]
			elif pi == 0:
				words_in = spawn_04808_index_words
			polys.append({"desc": poly_desc, "words": words_in})
			stream_off += FlightMathScript.apply_04808_stream_advance(
				int(poly_desc.get(8, 0)) & 0xFF
			)
		var loop_r: Dictionary = FlightMathScript.apply_04808_poly_loop(polys, poly_n)
		last_04808["loop"] = loop_r
		var recs: Array = loop_r.get("records", [])
		if recs.size() > 0:
			last_04808["record"] = recs[0].get("record", {})
			last_04808["index"] = recs[0].get("index_words", {})
		var index_allocs: Array = []
		for entry in recs:
			var base: int = buf_ptr + int(entry.get("rec_base", 0))
			var rec: Dictionary = entry.get("record", {})
			mem_u32[base + 0x08] = int(rec.get("rec_u32_08", 0))
			mem_u32[base + 0x0C] = int(rec.get("rec_u32_0c", 0))
			mem_u32[base + 0x10] = int(rec.get("rec_u8_10", 0))
			mem_u32[base + 0x11] = int(rec.get("rec_u8_11", 0))
			mem_u32[base + 0x12] = int(rec.get("rec_u8_12", 0))
			mem_u32[base + 0x13] = int(rec.get("rec_u8_13", 0))
			mem_u32[base + 0x14] = int(rec.get("rec_u16_14", 0))
			mem_u32[base + 0x16] = int(rec.get("rec_u8_16", 0))
			mem_u32[base + 0x17] = int(rec.get("rec_u8_17", 0))
			mem_u32[base + 0x1C] = int(rec.get("rec_u32_1c", 0))
			var idx: Dictionary = entry.get("index_words", {})
			var idx_bytes: int = FlightMathScript.apply_04808_index_alloc_bytes(
				int(rec.get("rec_u16_14", 0))
			)
			var idx_alloc: Dictionary = {}
			var iptr: int = 0
			if spawn_04808_use_mock_ptrs and spawn_04808_index_ptr != 0:
				iptr = spawn_04808_index_ptr + int(entry.get("index", 0)) * spawn_04808_index_stride
				idx_alloc = {"ok": true, "payload_ptr": iptr, "mocked": true}
			else:
				idx_alloc = FlightMathScript.apply_01a68_alloc(idx_bytes, heap_01a68)
				iptr = int(idx_alloc.get("payload_ptr", 0))
			if index_allocs.is_empty():
				spawn_04808_index_ptr = iptr
			index_allocs.append(idx_alloc)
			mem_u32[base + 0x18] = iptr
			var words: Array = idx.get("words", [])
			for wi in range(words.size()):
				mem_u32[iptr + wi * 2] = int(words[wi]) & 0xFFFF
		last_04808["index_allocs"] = index_allocs
	var trailer: Dictionary = FlightMathScript.apply_04808_bit1_trailer(f3a, f38, byte06)
	last_04808["trailer"] = trailer
	if bool(trailer.get("enabled", false)):
		var tbase: int = buf_ptr + int(trailer.get("trailer_offset", 0))
		var tw: Array = trailer.get("words", [])
		for ti in range(tw.size()):
			mem_u32[tbase + ti * 2] = int(tw[ti]) & 0xFFFF
	dat_0001daa2 = 1
	last_04808["dat_0001daa2"] = 1
	var byte05: int = int(mem_u32.get(obj + 5, 0)) & 0xFF
	last_04e6e_path = FlightMathScript.apply_04e6e_post_04808_path(byte05, byte06, byte07)
	last_02bd8_gate = FlightMathScript.apply_04e6e_02bd8_gate(byte05, byte06, byte07)
	last_01c5c = {}
	last_03ea0 = {}
	last_15762 = {}
	last_04958 = {}
	last_04916 = {}
	var path: String = str(last_04e6e_path.get("path", ""))
	var verts44: int = int(mem_u32.get(obj + 0x44, 0))
	var mesh_ptr: int = spawn_02bd8_mesh_ptr
	if mesh_ptr == 0:
		var tpl_r: Dictionary = _0435a_resolve_scale_src(obj)
		var tpl: int = int(tpl_r.get("template_ptr", 0))
		if tpl != 0:
			mesh_ptr = tpl + 0x22
	if path == "02bd8":
		## Keep prior mesh contract: both-aux only when spawn_02bd8_mesh_ptr set.
		last_02bd8_args = FlightMathScript.apply_04e6e_02bd8_args(
			obj, f36, f3a, spawn_02bd8_mesh_ptr, verts44
		)
		var lx: int = int(mem_u32.get(obj + 0x18, 0))
		var ly: int = int(mem_u32.get(obj + 0x1C, 0))
		var lz: int = int(mem_u32.get(obj + 0x20, 0))
		if spawn_02bd8_mesh_ptr != 0 and verts44 != 0:
			var f34: int = int(mem_u32.get(obj + 0x34, 0))
			var count28: int = int(last_02bd8_args.get("param_2_count", 1))
			last_02bd8_walk = FlightMathScript.apply_02bd8_both_aux_walk(
				count28, spawn_02bd8_mesh_xyz, spawn_02bd8_nodes, f34
			)
			last_02bd8_walk["path"] = "both_aux"
			var out_xyz: Array = last_02bd8_walk.get("xyz", [])
			for vi in range(out_xyz.size()):
				mem_u32[verts44 + vi * 4] = int(out_xyz[vi])
		elif spawn_02bd8_mesh_ptr == 0 or verts44 == 0:
			last_02bd8_walk = FlightMathScript.apply_02bd8_null_aux_walk(
				lx, ly, lz, spawn_02bd8_nodes
			)
			last_02bd8_walk["path"] = "null_or"
			lx = int(last_02bd8_walk.get("x", lx))
			ly = int(last_02bd8_walk.get("y", ly))
			lz = int(last_02bd8_walk.get("z", lz))
		var f24: int = int(mem_u32.get(obj + 0x24, 0))
		last_02bd8_commit = FlightMathScript.apply_02bd8_null_aux_commit(
			lx, ly, lz, spawn_02bd8_mesh_ptr, verts44, f24
		)
		if bool(last_02bd8_commit.get("commit", false)):
			mem_u32[obj + 0x18] = int(last_02bd8_commit.get("field_18", 0))
			mem_u32[obj + 0x1C] = int(last_02bd8_commit.get("field_1c", 0))
			mem_u32[obj + 0x20] = int(last_02bd8_commit.get("field_20", 0))
		_04e6e_kind2_0435a_03da8_03ea0(obj)
	elif path == "01c5c":
		## [RECONSTRUCTED] 5661: 01c5c(36+3a, mesh, verts, 0,0,0) then rates/band/03ea0.
		var args_1c: Dictionary = FlightMathScript.apply_04e6e_02bd8_args(
			obj, f36, f3a, mesh_ptr, verts44
		)
		var count_1c: int = int(args_1c.get("param_2_count", 0))
		var src_xyz: Array = []
		if mesh_ptr != 0 and count_1c > 0:
			for vi in range(count_1c * 3):
				src_xyz.append(int(mem_u32.get(mesh_ptr + vi * 4, 0)))
		last_01c5c = FlightMathScript.apply_fun_00001c5c(count_1c, src_xyz, 0, 0, 0)
		last_01c5c["mesh_ptr"] = mesh_ptr
		last_01c5c["verts_ptr"] = verts44
		if verts44 != 0:
			var out_xyz2: Array = last_01c5c.get("xyz", [])
			for vi2 in range(out_xyz2.size()):
				mem_u32[verts44 + vi2 * 4] = int(out_xyz2[vi2])
		_04e6e_kind2_0435a_03da8_03ea0(obj)
	elif path == "15762":
		## [RECONSTRUCTED] 5667–5682: 0435a/03da8 then 15762 through bias_1a; 1562e deferred.
		_04e6e_kind2_0435a_03da8_only(obj)
		last_15762 = _apply_fun_00015762(obj)
		last_04e6e_followup["path"] = "15762"
		last_04e6e_followup["15762"] = last_15762
	else:
		## [RECONSTRUCTED] 5686–5693: 04958 entry; then 04916 if b5a0+0xe==1 else 03ea0.
		## No 0435a/03da8 before 04958 (unlike +7/+5/02bd8 paths).
		last_04958 = _apply_fun_00004958(obj)
		var b5a0_0e: int = 0
		if dat_0001b5a0 != 0:
			b5a0_0e = int(mem_u32.get(dat_0001b5a0 + 0x0E, 0))
		var fu49: Dictionary = FlightMathScript.apply_04e6e_post_04958_followup(b5a0_0e)
		if bool(fu49.get("need_04916", false)):
			last_04916 = _apply_fun_00004916(obj, 0x80)
			last_04e6e_followup = {
				"path": "04958",
				"04958": last_04958,
				"followup": "04916",
				"04916": last_04916,
			}
		else:
			last_03ea0 = {"called": true, "deferred_body": true, "obj": obj & 0xFFFFFFFF}
			last_04e6e_followup = {
				"path": "04958",
				"04958": last_04958,
				"followup": "03ea0",
				"need_03ea0": true,
			}
	return {
		"04808": last_04808,
		"path": last_04e6e_path,
		"02bd8_gate": last_02bd8_gate,
		"01c5c": last_01c5c,
		"03ea0": last_03ea0,
		"15762": last_15762,
		"04958": last_04958,
		"04916": last_04916,
		"followup": last_04e6e_followup,
		"ok": true,
	}


## [RECONSTRUCTED] FUN_00004958 through simple poly cull (5342 / 5374–5462).
## Call-site immediates from 5686; local_1be4 rel; nested 02bd8; then per-poly
## index walk for index_count==1 (project xz → cull if pairs<3).
## [DEFERRED] 03c68 thinning, b190/b242 clip chain, local_f54 gather.
func _apply_fun_00004958(obj: int) -> Dictionary:
	var args: Dictionary = FlightMathScript.apply_04e6e_04958_args()
	var f36: int = int(mem_u32.get(obj + 0x36, 0))
	var f3a: int = int(mem_u32.get(obj + 0x3A, 0))
	var verts: int = int(mem_u32.get(obj + 0x44, 0))
	var n3a: int = FlightMathScript._to_s16(f3a)
	var n36: int = FlightMathScript._to_s16(f36)
	var need: int = maxi(n36 + n3a, 1)
	var verts_xyz: Array = []
	if verts != 0:
		for vi in range(need * 3):
			verts_xyz.append(int(mem_u32.get(verts + vi * 4, 0)))
	var rel: Dictionary = FlightMathScript.apply_04958_entry_rel(verts_xyz, f36, f3a)
	var tpl_r: Dictionary = _0435a_resolve_scale_src(obj)
	var tpl: int = int(tpl_r.get("template_ptr", 0))
	var stream: Dictionary = {}
	var walk58: Dictionary = {}
	var poly_walk: Array = []
	var s1a: int = 0
	var stacked: Array = []
	if tpl != 0:
		s1a = int(mem_u32.get(tpl + 0x1A, 0))
		var s1e: int = int(mem_u32.get(tpl + 0x1E, 0))
		stream = FlightMathScript.apply_04958_poly_stream(tpl, s1a, s1e)
		## 5396: count=*(s16*)(tpl+0x1a); src=tpl+0x22 as int32×3 (not packed +2/+6/+10).
		var n1a: int = FlightMathScript._to_s16(s1a)
		var src_xyz: Array = []
		for i in range(maxi(n1a, 0)):
			var rec: int = tpl + 0x22 + i * 0xC
			src_xyz.append(int(mem_u32.get(rec + 0, 0)))
			src_xyz.append(int(mem_u32.get(rec + 4, 0)))
			src_xyz.append(int(mem_u32.get(rec + 8, 0)))
		if n1a > 0 and src_xyz.size() >= n1a * 3:
			var nodes: Array = _02bd8_nodes_from_parent_chain(obj)
			var f34: int = int(mem_u32.get(obj + 0x34, 0))
			walk58 = FlightMathScript.apply_02bd8_both_aux_walk(n1a, src_xyz, nodes, f34)
			walk58["path"] = "04958_both_aux"
			walk58["count_1a"] = n1a
			last_02bd8_walk = walk58
			stacked = walk58.get("xyz", []) as Array
		## 5400–5495: walk field_3a polys; 03c68 thinning when index_count>1.
		var cur: int = int(stream.get("poly_stream", 0))
		var poly_base: int = int(mem_u32.get(obj + 0x48, 0))
		var param_3: int = int(args.get("param_3", 0))
		var phase_a8: int = 0
		if dat_0001b5a0 != 0:
			phase_a8 = int(mem_u32.get(dat_0001b5a0 + 0xA8, 0))
		for pi in range(maxi(n3a, 0)):
			if cur == 0:
				break
			var icount: int = int(mem_u32.get(cur + 8, 0)) & 0xFF
			var hdr: Dictionary = FlightMathScript.apply_04958_poly_stream_header(cur, icount)
			var words: Array = []
			for wi in range(icount):
				words.append(int(mem_u32.get(cur + 0x0E + wi * 2, 0)))
			var pairs: Dictionary = FlightMathScript.apply_04958_poly_pairs(
				stacked,
				words,
				dat_0001d724,
				dat_0001d71c,
				param_3,
				dat_0001d838,
				dat_0001d830,
				phase_a8,
			)
			pairs["header"] = hdr
			pairs["poly_index"] = pi
			if bool(pairs.get("ok", false)) and bool(pairs.get("cull", false)) and poly_base != 0:
				var slot: int = poly_base + pi * 0x20
				var fl: int = int(mem_u32.get(slot + 0x13, 0)) & 0xFF
				mem_u32[slot + 0x13] = (fl | 2) & 0xFF
				pairs["flag_13"] = int(mem_u32.get(slot + 0x13, 0))
			poly_walk.append(pairs)
			cur = int(hdr.get("next_stream", 0))
	return {
		"args": args,
		"entry_rel": rel,
		"poly_stream": stream,
		"02bd8": walk58,
		"auStack_15e4": stacked,
		"applied_02bd8": not walk58.is_empty(),
		"poly_walk": poly_walk,
		"applied_poly_walk": poly_walk.size() > 0,
		"verts_ptr": verts,
		"deferred_body": true,
		"ok": true,
	}


## [RECONSTRUCTED] FUN_00004916 (5319–5337): write table word + 0xff into each poly slot.
func _apply_fun_00004916(obj: int, param_2: int) -> Dictionary:
	var f3a: int = int(mem_u32.get(obj + 0x3A, 0))
	var poly: int = int(mem_u32.get(obj + 0x48, 0))
	var table_base: int = 0
	if dat_0001b5a0 != 0:
		table_base = int(mem_u32.get(dat_0001b5a0 + 0x88, 0))
	var word: int = 0
	if table_base != 0:
		word = int(mem_u32.get(table_base + param_2 * 2, 0))
	var plan: Dictionary = FlightMathScript.apply_fun_00004916(f3a, word, param_2)
	var n: int = int(plan.get("count", 0))
	var slots: Array = plan.get("slots", []) as Array
	if poly != 0:
		for i in range(n):
			var slot: int = poly + i * 0x20
			var ent: Dictionary = slots[i] as Dictionary if i < slots.size() else {}
			mem_u32[slot + 4] = int(ent.get("field_4", 0))
			mem_u32[slot + 0x0F] = 0xFF
	plan["poly_ptr"] = poly
	plan["table_base"] = table_base
	plan["param_2"] = param_2
	plan["table_word"] = word
	return plan


## [RECONSTRUCTED] FUN_00015762 through bias_1a (5669–5682 / 19920–19958).
## [DEFERRED] asStack_2924 init, 1562e poly emit, return.
## 19928: 02bd8(obj, count, &local_1e94, &local_1e94) — both-aux; no +18/1c/20 commit.
func _apply_fun_00015762(obj: int) -> Dictionary:
	var handle: int = int(mem_u32.get(obj + 8, 0))
	var type_key: int = 0
	var h34: int = 0
	var h36: int = 0
	var h38: int = 0
	var h40: int = 0
	if handle != 0:
		var type_ptr: int = int(mem_u32.get(handle + 4, 0))
		if type_ptr != 0:
			type_key = int(mem_u32.get(type_ptr, 0))
		h34 = int(mem_u32.get(handle + 0x34, 0))
		h36 = int(mem_u32.get(handle + 0x36, 0))
		h38 = int(mem_u32.get(handle + 0x38, 0))
		h40 = int(mem_u32.get(handle + 0x40, 0))
	var args: Dictionary = FlightMathScript.apply_04e6e_15762_args(
		handle, type_key, h34, h36, h38, h40
	)
	var tpl_r: Dictionary = _0435a_resolve_scale_src(obj)
	var tpl: int = int(tpl_r.get("template_ptr", 0))
	var plan: Dictionary = {}
	var walk62: Dictionary = {}
	var rel62: Dictionary = {}
	var bias62: Dictionary = {}
	if tpl != 0:
		var s1a: int = int(mem_u32.get(tpl + 0x1A, 0))
		var s1e: int = int(mem_u32.get(tpl + 0x1E, 0))
		var n: int = FlightMathScript._to_s16(s1a) + FlightMathScript._to_s16(s1e)
		## 19927: 02976(count, tpl+0x22, …) — packed shorts at +2/+6/+10 per 0xC.
		var src_xyz: Array = []
		for i in range(maxi(n, 0)):
			var rec: int = tpl + 0x22 + i * 0xC
			src_xyz.append(int(mem_u32.get(rec + 2, 0)))
			src_xyz.append(int(mem_u32.get(rec + 6, 0)))
			src_xyz.append(int(mem_u32.get(rec + 10, 0)))
		plan = FlightMathScript.apply_15762_entry_plan(
			tpl,
			s1a,
			s1e,
			int(args.get("param_2", 0)),
			int(args.get("param_3", 0)),
			int(args.get("param_4", 0)),
			int(args.get("param_5", 0)),
			src_xyz,
		)
		## 19928: both-aux 02bd8 on local_1e94 (src≡dst); commit skipped when aux non-null.
		var xyz: Array = plan.get("local_1e94", []) as Array
		if bool(plan.get("applied_02976", false)) and xyz.size() >= maxi(n, 0) * 3:
			var nodes: Array = _02bd8_nodes_from_parent_chain(obj)
			var f34: int = int(mem_u32.get(obj + 0x34, 0))
			walk62 = FlightMathScript.apply_02bd8_both_aux_walk(n, xyz, nodes, f34)
			xyz = walk62.get("xyz", xyz) as Array
			plan["local_1e94"] = xyz
			plan["applied_02bd8"] = true
			plan["deferred_02bd8"] = false
			plan["02bd8"] = walk62
			last_02bd8_walk = walk62
			last_02bd8_walk["path"] = "15762_both_aux"
			## 19929–19942: local_3324[i] = vert[i+1a] - vert[0]
			rel62 = FlightMathScript.apply_15762_local_3324_rel(xyz, s1a, s1e)
			plan["local_3324"] = rel62.get("xyz", [])
			plan["applied_local_3324"] = bool(rel62.get("applied", false))
			## 19944–19958: bias first 1a verts (BE low-16 subtract).
			bias62 = FlightMathScript.apply_15762_bias_1a_low16(
				xyz,
				s1a,
				int(mem_u32.get(obj + 0x18, 0)),
				int(mem_u32.get(obj + 0x20, 0)),
				int(args.get("param_5", 0)),
				f34,
			)
			plan["local_1e94"] = bias62.get("xyz", xyz)
			plan["applied_bias_1a"] = bool(bias62.get("applied", false))
			plan["bias_1a"] = bias62
	return {
		"args": args,
		"entry": plan,
		"02bd8": walk62,
		"local_3324": rel62,
		"bias_1a": bias62,
		"handle": handle,
		"deferred_body": true,
	}


## [RECONSTRUCTED] 0435a(obj,0); 03da8; record 03ea0 (LAB_00005056) — body deferred.
func _04e6e_kind2_0435a_03da8_03ea0(obj: int) -> void:
	_04e6e_kind2_0435a_03da8_only(obj)
	last_03ea0 = {"called": true, "deferred_body": true, "obj": obj & 0xFFFFFFFF}
	last_04e6e_followup["need_03ea0"] = true


func _04e6e_kind2_0435a_03da8_only(obj: int) -> void:
	var metric10: int = int(mem_u32.get(obj + 0x10, 0))
	last_04e6e_followup = FlightMathScript.apply_04e6e_post_02bd8_followup(obj, metric10)
	_apply_fun_0000435a(obj, 0)
	last_03da8 = FlightMathScript.apply_fun_00003da8(
		int(mem_u32.get(obj + 0x30, 0)), metric10, dat_0001b190
	)
	if bool(last_03da8.get("ok", false)) and int(last_03da8.get("changed", 0)) != 0:
		mem_u32[obj + 0x30] = int(last_03da8.get("field_30", 0))


## [RECONSTRUCTED] FUN_00004e6e (Capstone @0x4E6E+; decomp ~5587).
## kind2: list + vertex alloc + 04808/02bd8/0435a/03da8. kind3: d4a4 + 046da×N.
func _call_fun_00004e6e(obj: int) -> Dictionary:
	var r: Dictionary = {"fn": "04e6e", "obj": int(obj) & 0xFFFFFFFF}
	if obj == 0:
		r["ok"] = false
		r["reason"] = "null_obj"
		last_04e6e_calls.append(r)
		return r
	var kind: int = int(mem_u32.get(obj, 0)) & 0xFF
	r["kind"] = kind
	if kind == 3:
		r = _04e6e_kind3(obj, r)
		last_04e6e_calls.append(r)
		return r
	if kind != 2:
		r["ok"] = true
		r["deferred_kind"] = kind
		last_04e6e_calls.append(r)
		return r
	var byte07: int = int(mem_u32.get(obj + 7, 0)) & 0xFF
	var lst: Dictionary = FlightMathScript.apply_04e6e_kind2_list_select(byte07)
	r["list"] = lst
	if bool(lst.get("to_d4a4", false)):
		dat_0001d4a4_world.append(obj)
		dat_0001c1e0_count += 1
	else:
		dat_0001b5a4_world.append(obj)
		dat_0001b734 += 1
	var f36: int = int(mem_u32.get(obj + 0x36, 0)) & 0xFFFF
	var f3a: int = int(mem_u32.get(obj + 0x3A, 0)) & 0xFFFF
	var vert_bytes: int = FlightMathScript.apply_04e6e_kind2_alloc_bytes(f36, f3a)
	var ptr_4c: int = 0
	var ptr_44: int = 0
	var alloc_4c: Dictionary = {}
	var alloc_44: Dictionary = {}
	if spawn_04e6e_use_mock_ptrs:
		ptr_4c = spawn_04e6e_ptr_4c
		ptr_44 = spawn_05116_world_field_44
		alloc_4c = {"ok": true, "payload_ptr": ptr_4c, "mocked": true}
		alloc_44 = {"ok": true, "payload_ptr": ptr_44, "mocked": true}
	else:
		alloc_4c = FlightMathScript.apply_01a68_alloc(maxi(vert_bytes, 4), heap_01a68)
		alloc_44 = FlightMathScript.apply_01a68_alloc(maxi(vert_bytes, 4), heap_01a68)
		ptr_4c = int(alloc_4c.get("payload_ptr", 0))
		ptr_44 = int(alloc_44.get("payload_ptr", 0))
	var vp: Dictionary = FlightMathScript.apply_04e6e_kind2_vertex_ptrs(
		ptr_4c, ptr_44, f36, f3a
	)
	mem_u32[obj + 0x4C] = ptr_4c
	mem_u32[obj + 0x44] = ptr_44
	r["kind2"] = vp
	r["alloc_4c"] = alloc_4c
	r["alloc_44"] = alloc_44
	r["dat_0001b734"] = dat_0001b734
	r["followup"] = _04e6e_kind2_04808_followup(obj)
	r["deferred_followup"] = false
	r["ok"] = bool(alloc_4c.get("ok", false)) and bool(alloc_44.get("ok", false))
	last_04e6e_calls.append(r)
	return r


## Optional per-index child objs for kind-3 046da (else 01a68 0x52 stand-in).
var spawn_046da_child_objs: Array = []
var last_046da_kind3_calls: Array = []


## [RECONSTRUCTED] Build 02bd8 null-aux nodes by walking obj+0x24 parents (3343–3375).
## Each step: slot = *(cur+0x30) + idx*0x18; next idx=*(cur+2); next=*(cur+0x24).
func _02bd8_nodes_from_parent_chain(obj: int) -> Array:
	var nodes: Array = []
	var cur: int = int(mem_u32.get(obj + 0x24, 0))
	var idx: int = int(mem_u32.get(obj + 2, 0)) & 0xFF
	var guard: int = 0
	while cur != 0 and guard < 32:
		guard += 1
		var table: int = int(mem_u32.get(cur + 0x30, 0))
		if table == 0:
			break
		var slot: int = table + idx * 0x18
		nodes.append(
			FlightMathScript.apply_02bd8_chain_slot_node(
				int(mem_u32.get(slot + 2, 0)),
				int(mem_u32.get(slot + 4, 0)),
				int(mem_u32.get(slot + 6, 0)),
				int(mem_u32.get(slot + 8, 0)),
				int(mem_u32.get(slot + 0x0C, 0)),
				int(mem_u32.get(slot + 0x10, 0)),
			)
		)
		idx = int(mem_u32.get(cur + 2, 0)) & 0xFF
		cur = int(mem_u32.get(cur + 0x24, 0))
	return nodes


## [RECONSTRUCTED] 046da-site FUN_00002bd8(obj,1,null,null): walk then commit (5236 / 3343–3381).
func _apply_046da_02bd8(world_obj: int) -> Dictionary:
	var lx: int = int(mem_u32.get(world_obj + 0x18, 0))
	var ly: int = int(mem_u32.get(world_obj + 0x1C, 0))
	var lz: int = int(mem_u32.get(world_obj + 0x20, 0))
	var f24: int = int(mem_u32.get(world_obj + 0x24, 0))
	var nodes: Array = []
	var source: String = "none"
	if spawn_046da_02bd8_nodes is Array:
		nodes = spawn_046da_02bd8_nodes as Array
		source = "override"
	elif f24 != 0:
		nodes = _02bd8_nodes_from_parent_chain(world_obj)
		source = "mem_chain"
	var walk: Dictionary = {}
	if nodes.size() > 0:
		walk = FlightMathScript.apply_02bd8_null_aux_walk(lx, ly, lz, nodes)
		lx = int(walk.get("x", lx))
		ly = int(walk.get("y", ly))
		lz = int(walk.get("z", lz))
	last_046da_02bd8_walk = walk
	last_02bd8_walk = walk
	var commit: Dictionary = FlightMathScript.apply_02bd8_null_aux_commit(
		lx, ly, lz, 0, 0, f24
	)
	last_046da_02bd8_commit = commit
	last_02bd8_commit = commit
	if bool(commit.get("commit", false)):
		mem_u32[world_obj + 0x18] = int(commit.get("field_18", 0))
		mem_u32[world_obj + 0x1C] = int(commit.get("field_1c", 0))
		mem_u32[world_obj + 0x20] = int(commit.get("field_20", 0))
	return {
		"walk": walk,
		"commit": commit,
		"source": source,
		"node_count": nodes.size(),
	}


## [RECONSTRUCTED] FUN_000046da for kind-3 parent (5223–5259).
## Front: desc←embed; 045ba; table store; links.
## Tail: 02bd8(obj,1,0,0); optional +8; 0435a(obj,1); 03b98; gate→04e6e or d0e4.
func _046da_from_parent(parent: int, index: int) -> Dictionary:
	var r: Dictionary = {"fn": "046da", "parent": parent, "index": index}
	var embed: int = int(mem_u32.get(parent + 0x28, 0))
	var b5a0_8c: int = 0
	if dat_0001b5a0 != 0:
		b5a0_8c = int(mem_u32.get(dat_0001b5a0 + 0x8C, 0))
	var slot: int = embed + index * 0x18 + 0x2E
	var raw: int = int(mem_u32.get(slot, 0))
	var dres: Dictionary = FlightMathScript.apply_046da_desc_ptr(embed, index, b5a0_8c, raw)
	var desc: int = int(dres.get("desc_ptr", 0))
	r["desc"] = dres
	var child_obj: int = 0
	if index < spawn_046da_child_objs.size():
		child_obj = int(spawn_046da_child_objs[index])
	else:
		var ha: Dictionary = FlightMathScript.apply_01a68_alloc(0x52, heap_01a68)
		child_obj = int(ha.get("payload_ptr", 0))
		r["alloc"] = ha
	if desc != 0 and child_obj != 0:
		var fields: Dictionary = _read_045ba_desc(desc)
		var ba: Dictionary = FlightMathScript.apply_045ba_from_desc(fields, dat_0001b838)
		if bool(ba.get("ok", false)):
			_apply_045ba_result_to_mem(child_obj, ba)
		r["045ba"] = ba
	var table: int = int(mem_u32.get(parent + 0x30, 0))
	if table != 0:
		mem_u32[table + index * 0x18 + 0x14] = child_obj
	var parent_2c: int = int(mem_u32.get(parent + 0x2C, 0)) & 0xFFFF
	var links: Dictionary = FlightMathScript.apply_046da_parent_child_links(
		parent,
		index,
		index,
		parent_2c,
		int(mem_u32.get(child_obj + 3, 0)) & 0xFF,
		int(mem_u32.get(child_obj + 4, 0)),
	)
	if child_obj != 0:
		mem_u32[child_obj + 0x24] = int(links.get("field_24", 0))
		mem_u32[child_obj + 1] = int(links.get("field_01", 0))
		mem_u32[child_obj + 2] = int(links.get("field_02", 0))
		mem_u32[child_obj + 3] = int(links.get("field_03", 0))
		mem_u32[child_obj + 4] = int(links.get("flags_04", 0))
	r["links"] = links
	r["child_obj"] = child_obj
	## --- tail (5236–5259) ---
	if child_obj != 0:
		var bd8: Dictionary = _apply_046da_02bd8(child_obj)
		r["02bd8"] = bd8
		r["02bd8_commit"] = bd8.get("commit", {})
		var type_b: int = 0
		if desc != 0:
			type_b = int(mem_u32.get(desc + 1, 0)) & 0xFF
		var plus8: Dictionary = FlightMathScript.apply_04690_vtable_plus8(
			type_b, spawn_05116_entity_handle
		)
		r["plus8"] = plus8
		if bool(plus8.get("install", false)):
			mem_u32[child_obj + 8] = int(plus8.get("field_08", 0))
			if bool(plus8.get("clear_handle", false)) and spawn_05116_entity_handle != 0:
				mem_u32[spawn_05116_entity_handle] = 0
		## [RECONSTRUCTED] Pacific Conflict.c:5251 — FUN_0000435a(puVar1, 1).
		## param_2=1 skips kind2 poly +0x1c loop (5048); gate/+0xc still apply.
		r["0435a"] = _apply_fun_0000435a(child_obj, 1)
		r["deferred_0435a"] = false
		var axes: Dictionary = FlightMathScript.apply_03b98_camera_abs_axes(
			int(mem_u32.get(child_obj + 0x18, 0)),
			int(mem_u32.get(child_obj + 0x1C, 0)),
			int(mem_u32.get(child_obj + 0x20, 0)),
			dat_0001d838,
			dat_0001d834,
			dat_0001d830,
		)
		var b98: Dictionary = FlightMathScript.apply_fun_00003b98(
			int(axes.get("a", 0)), int(axes.get("b", 0)), int(axes.get("c", 0))
		)
		var metric: int = int(b98.get("metric", 0))
		mem_u32[child_obj + 0x10] = int(b98.get("field_10", 0))
		r["03b98"] = b98
		var field_0c: int = int(mem_u32.get(child_obj + 0x0C, 0))
		var gate: Dictionary = FlightMathScript.apply_046da_04e6e_distance_gate(metric, field_0c)
		r["distance_gate"] = gate
		if bool(gate.get("need_04e6e", false)):
			r["nested_04e6e"] = _call_fun_00004e6e(child_obj)
		else:
			dat_0001d0e4_world.append(child_obj)
			dat_0001c1dc_count += 1
			r["deferred_d0e4"] = true
	r["deferred_tail"] = false
	r["ok"] = child_obj != 0 and desc != 0
	last_046da_kind3_calls.append(r)
	return r


## [RECONSTRUCTED] FUN_00004e6e kind-3 (Capstone @0x5072–0x5106).
## d4a4 publish; child×0x18 table; 046da(obj,i,i) per child (incl. 0435a param_2=1).
func _04e6e_kind3(obj: int, r: Dictionary) -> Dictionary:
	dat_0001d4a4_world.append(obj)
	dat_0001c1e0_count += 1
	var plan: Dictionary = FlightMathScript.apply_04e6e_kind3_plan(
		int(mem_u32.get(obj + 0x2E, 0)) & 0xFFFF
	)
	r["kind3_plan"] = plan
	var b5a0_8c: int = 0
	if dat_0001b5a0 != 0:
		b5a0_8c = int(mem_u32.get(dat_0001b5a0 + 0x8C, 0))
	var table: Dictionary = _016e2_build_child_table(obj, b5a0_8c)
	r["child_table"] = table
	r["dat_0001c1e0"] = dat_0001c1e0_count
	last_046da_kind3_calls = []
	var count: int = int(plan.get("count", 0))
	var kids: Array = []
	var ok_all := bool(table.get("ok", false))
	for i in range(count):
		var one: Dictionary = _046da_from_parent(obj, i)
		kids.append(one)
		if not bool(one.get("ok", false)):
			ok_all = false
	r["046da_calls"] = kids
	r["046da_count"] = count
	r["deferred_046da_loop"] = false
	var any_deferred_0435a := false
	for k in kids:
		if bool((k as Dictionary).get("deferred_0435a", true)):
			any_deferred_0435a = true
			break
	r["deferred_0435a"] = any_deferred_0435a
	r["ok"] = ok_all
	return r


## Alias kept for prior call sites.
func _call_fun_00004e6e_stub(obj: int) -> Dictionary:
	return _call_fun_00004e6e(obj)


## [RECONSTRUCTED] FUN_00001c04 (Capstone @0x1C04–0x1C5A): copy *(obj+0x44)→*(obj+0x4c).
func _call_fun_00001c04(obj: int) -> Dictionary:
	var r: Dictionary = {"fn": "01c04", "obj": int(obj) & 0xFFFFFFFF}
	if obj == 0:
		r["ok"] = false
		r["reason"] = "null_obj"
		last_01c04_calls.append(r)
		return r
	var f36: int = int(mem_u32.get(obj + 0x36, 0)) & 0xFFFF
	var f3a: int = int(mem_u32.get(obj + 0x3A, 0)) & 0xFFFF
	var p44: int = int(mem_u32.get(obj + 0x44, 0))
	var p4c: int = int(mem_u32.get(obj + 0x4C, 0))
	var plan: Dictionary = FlightMathScript.apply_01c04_plan(f36, f3a, p44, p4c)
	r["plan"] = plan
	if bool(plan.get("skip", false)):
		r["ok"] = true
		r["copied_words"] = 0
		last_01c04_calls.append(r)
		return r
	if p44 == 0 or p4c == 0:
		r["ok"] = false
		r["reason"] = "null_buf"
		last_01c04_calls.append(r)
		return r
	var nbytes: int = int(plan.get("nbytes", 0))
	var nwords: int = nbytes >> 2
	for i in range(nwords):
		mem_u32[p4c + i * 4] = int(mem_u32.get(p44 + i * 4, 0)) & 0xFFFFFFFF
	r["copied_words"] = nwords
	r["ok"] = true
	last_01c04_calls.append(r)
	return r


## [RECONSTRUCTED] FUN_000016e2 bdb publish + hooks (Capstone @0x17A2–0x1832).
## bdb4→04e4e/01be4; bdb0=child[1]→04e4e then 01be4(bdb4!); bdac child[2|3].
func _016e2_publish_bdb_hooks(table_ptr: int) -> Dictionary:
	last_04e4e_calls = []
	last_01be4_calls = []
	last_04e6e_calls = []
	dat_0001bdb4 = int(mem_u32.get(table_ptr + 0x14, 0))
	_call_fun_00004e4e(dat_0001bdb4)
	_call_fun_00001be4(dat_0001bdb4)
	dat_0001bdb0 = int(mem_u32.get(table_ptr + 0x2C, 0))  # child[1] +0x14
	_call_fun_00004e4e(dat_0001bdb0)
	## Capstone @0x17EA: second 01be4 pushes bdb4 again (not bdb0).
	_call_fun_00001be4(dat_0001bdb4)
	var mission_90: int = 0
	if dat_0001b5a0 != 0:
		mission_90 = int(mem_u32.get(dat_0001b5a0 + 0x90, 0)) & 0xFFFF
	var sel: Dictionary = FlightMathScript.apply_016e2_bdac_select(mission_90, table_ptr)
	var slot: int = int(sel.get("slot_addr", 0))
	dat_0001bdac = int(mem_u32.get(slot, 0))
	if bool(sel.get("call_04e4e", false)):
		_call_fun_00004e4e(dat_0001bdac)
	if bool(sel.get("call_04e6e", false)):
		_call_fun_00004e6e_stub(dat_0001bdac)
	return {
		"ok": true,
		"dat_0001bdb4": dat_0001bdb4,
		"dat_0001bdb0": dat_0001bdb0,
		"dat_0001bdac": dat_0001bdac,
		"bdac_select": sel,
		"04e4e_calls": last_04e4e_calls.duplicate(),
		"01be4_calls": last_01be4_calls.duplicate(),
		"04e6e_calls": last_04e6e_calls.duplicate(),
	}


## [RECONSTRUCTED] FUN_000016e2 bda8/bda4/1b734 + bc28 window (Capstone @0x183E–0x18D4).
func _016e2_publish_bda_tail(root: int, table_ptr: int) -> Dictionary:
	last_01c04_calls = []
	var field_48: int = int(mem_u32.get(dat_0001bdac + 0x48, 0)) if dat_0001bdac != 0 else 0
	var pub8: Dictionary = FlightMathScript.apply_016e2_publish_bda8(dat_0001bdac, field_48)
	dat_0001bda8 = int(pub8.get("dat_0001bda8", 0))
	var child4: int = int(mem_u32.get(table_ptr + 0x74, 0))
	var pub4: Dictionary = FlightMathScript.apply_016e2_publish_bda4(table_ptr, child4)
	dat_0001bda4 = int(pub4.get("dat_0001bda4", 0))
	_call_fun_00004e6e_stub(dat_0001bda4)
	_call_fun_00001c04(dat_0001bda4)
	dat_0001b734 = 0
	var short_2c: int = int(mem_u32.get(root + 0x2C, 0)) & 0xFFFF
	var win: Dictionary = FlightMathScript.apply_016e2_bc28_window(short_2c, table_ptr)
	dat_0001b88e = int(win.get("dat_0001b88e", 0)) & 0xFFFF
	dat_0001b88c = int(win.get("dat_0001b88c", 0)) & 0xFFFF
	dat_0001bc28 = int(mem_u32.get(int(win.get("bc28_slot", 0)), 0))
	dat_0001bc34 = int(mem_u32.get(int(win.get("bc34_slot", 0)), 0))
	dat_0001bc38 = int(mem_u32.get(int(win.get("bc38_slot", 0)), 0))
	return {
		"ok": bool(pub8.get("ok", false)) and bool(pub4.get("ok", false)) and bool(win.get("ok", false)),
		"bda8": pub8,
		"bda4": pub4,
		"window": win,
		"dat_0001bda8": dat_0001bda8,
		"dat_0001bda4": dat_0001bda4,
		"dat_0001b734": dat_0001b734,
		"dat_0001bc28": dat_0001bc28,
		"dat_0001bc34": dat_0001bc34,
		"dat_0001bc38": dat_0001bc38,
		"04e6e_calls": last_04e6e_calls.duplicate(),
		"01c04_calls": last_01c04_calls.duplicate(),
	}


## [RECONSTRUCTED] FUN_000016e2 entry (Capstone @0x16E2–0x18D4; decomp ~1930).
## $54 → 04690 root → 1d6fc → child table → per-child 04690 → bdb* → bda* → bc28.
func init_mission_object_tables() -> Dictionary:
	var pub: Dictionary = publish_00054_all()
	var desc: int = 0
	if dat_0001b5a0 != 0:
		desc = int(mem_u32.get(dat_0001b5a0 + 0x8C, 0))
	var root: int = _call_fun_00004690(desc)
	var pub_root: Dictionary = FlightMathScript.apply_016e2_publish_root(root, desc)
	if bool(pub_root.get("ok", false)):
		dat_0001d6fc = int(pub_root.get("dat_0001d6fc", 0))
	last_016e2_child_table = {}
	last_016e2_child_04690 = {}
	last_016e2_bdb_hooks = {}
	last_016e2_bda_tail = {}
	if root != 0:
		last_016e2_child_table = _016e2_build_child_table(root, desc)
		var table_ptr: int = int(last_016e2_child_table.get("table_ptr", 0))
		var count: int = int(last_016e2_child_table.get("count", 0))
		last_016e2_child_04690 = _016e2_resolve_children(root, table_ptr, count)
		if table_ptr != 0:
			last_016e2_bdb_hooks = _016e2_publish_bdb_hooks(table_ptr)
			last_016e2_bda_tail = _016e2_publish_bda_tail(root, table_ptr)
	last_016e2 = {
		"ok": bool(pub.get("ok", false))
			and bool(pub_root.get("ok", false))
			and bool(last_016e2_child_table.get("ok", root == 0))
			and bool(last_016e2_child_04690.get("ok", root == 0))
			and bool(last_016e2_bdb_hooks.get("ok", root == 0))
			and bool(last_016e2_bda_tail.get("ok", root == 0)),
		"called_00054": true,
		"called_04690": true,
		"overlay_00054": pub,
		"root_publish": pub_root,
		"child_table": last_016e2_child_table,
		"child_04690": last_016e2_child_04690,
		"bdb_hooks": last_016e2_bdb_hooks,
		"bda_tail": last_016e2_bda_tail,
		"desc_ptr": desc,
		"root_ptr": root,
		"dat_0001d6fc": dat_0001d6fc,
		"dat_0001bdb4": dat_0001bdb4,
		"dat_0001bdb0": dat_0001bdb0,
		"dat_0001bdac": dat_0001bdac,
		"dat_0001bda8": dat_0001bda8,
		"dat_0001bda4": dat_0001bda4,
		"dat_0001bc28": dat_0001bc28,
		"deferred_04690_root": false,
		"deferred_child_table": false,
		"deferred_child_04690": false,
		"deferred_bdb_hooks": false,
		"deferred_bda_bc28": false,
	}
	return last_016e2


func _call_fun_000046da(desc: int, template_index: int, slot_index: int) -> void:
	last_046da_identity = {}
	last_045ba = {}
	last_03b98 = {}
	last_046da_04e6e_gate = {}
	last_04e6e_kind2 = {}
	last_046da_02bd8_commit = {}
	last_046da_02bd8_walk = {}
	last_046da_deferred = false
	if spawn_05116_world_obj == 0:
		return
	## [RECONSTRUCTED] FUN_000045ba field copy into mock world obj (heap still deferred).
	if desc != 0:
		var desc_fields: Dictionary = _read_045ba_desc(desc)
		last_045ba = FlightMathScript.apply_045ba_from_desc(desc_fields, dat_0001b838)
		if bool(last_045ba.get("ok", false)):
			_apply_045ba_result_to_mem(spawn_05116_world_obj, last_045ba)
	var idn: Dictionary = FlightMathScript.apply_046da_identity_stores(
		dat_0001d6fc,
		template_index,
		slot_index,
		dat_0001d6fc_short_2c,
		int(mem_u32.get(spawn_05116_world_obj + 3, 0)),
		int(mem_u32.get(spawn_05116_world_obj + 4, 0))
	)
	last_046da_identity = idn
	mem_u32[spawn_05116_world_obj + 0x24] = int(idn.get("field_24", 0))
	mem_u32[spawn_05116_world_obj + 1] = int(idn.get("field_01", 0))
	mem_u32[spawn_05116_world_obj + 2] = int(idn.get("field_02", 0))
	mem_u32[spawn_05116_world_obj + 3] = int(idn.get("field_03", 0))
	mem_u32[spawn_05116_world_obj + 4] = int(idn.get("flags_04", 0))
	## [RECONSTRUCTED] Pacific Conflict.c:5236 — FUN_00002bd8(obj, 1, null, null) before factory.
	_apply_046da_02bd8(spawn_05116_world_obj)
	## [RECONSTRUCTED] 046da/04690 vtable +8 when desc[1]≠0 (factory → handle; *handle=0).
	## Resolve: type=desc[1] → tmpl=1b524[type]; imm=*(tmpl+6) (+0x20).
	var desc_type: int = 0
	if desc != 0:
		desc_type = int(mem_u32.get(desc + 1, 0))
	else:
		desc_type = template_index
	var type_key_info: Dictionary = FlightMathScript.apply_1b524_type_key(
		desc_type, spawn_1b524_type_key
	)
	var type_key: int = int(type_key_info.get("type_key", 0))
	## plus8 gate uses low byte≠0 (existing apply_04690_vtable_plus8 contract).
	var type_byte: int = type_key & 0xFF
	var table_base: int = int(mem_u32.get(dat_0001d6fc + 0x30, 0))
	var slot_addr: int = table_base + slot_index * 0x18
	var handle_for_plus8: int = spawn_05116_entity_handle
	last_16a3a_factory = {}
	last_115b0_factory = {}
	last_1b524_factory_resolve = {}
	if type_byte != 0 and (
		spawn_1b524_factory_imm != 0 or not dat_0001b524.is_empty()
	):
		if dat_0001b524.is_empty():
			FlightMathScript.apply_00054_first_loop(heap_01a68, dat_0001b524)
		var tpl_ptr: int = int(dat_0001b524.get(type_key, 0))
		var tpl6_imm: int = 0
		if tpl_ptr != 0:
			tpl6_imm = int(mem_u32.get(tpl_ptr + 6, 0))
		last_1b524_factory_resolve = FlightMathScript.apply_1b524_resolve_factory(
			dat_0001b524,
			type_key,
			tpl6_imm,
			spawn_1b524_factory_imm
		)
		last_1b524_factory_resolve["type_key_info"] = type_key_info
		var fac_entry_addr: int = int(last_1b524_factory_resolve.get("entry", 0))
		var fac_entry: Dictionary = last_1b524_factory_resolve.get("entry_resolve", {}) as Dictionary
		if fac_entry_addr == 0x16A3A:
			## [INFERRED] 01b6c(0x58) stand-in via live 01a68 large alloc.
			var h_alloc: Dictionary = FlightMathScript.apply_01a68_alloc(0x58, heap_01a68)
			var h_ptr: int = int(h_alloc.get("payload_ptr", 0))
			var flags_in: int = int(mem_u32.get(spawn_05116_world_obj + 4, 0))
			last_16a3a_factory = FlightMathScript.apply_16a3a_factory(
				spawn_05116_world_obj,
				flags_in,
				type_key,
				dat_0001b524,
				h_ptr
			)
			last_16a3a_factory["alloc"] = h_alloc
			last_16a3a_factory["entry_resolve"] = fac_entry
			last_16a3a_factory["resolve"] = last_1b524_factory_resolve
			if bool(last_16a3a_factory.get("ok", false)):
				handle_for_plus8 = h_ptr
				mem_u32[h_ptr] = int(last_16a3a_factory.get("handle_u32_00", 0))
				mem_u32[h_ptr + 4] = int(last_16a3a_factory.get("handle_u32_04", 0))
				mem_u32[spawn_05116_world_obj + 4] = int(last_16a3a_factory.get("obj_flags_04", 0))
				mem_u32[spawn_05116_world_obj + 0x34] = 0
		elif fac_entry_addr == 0x115B0:
			## Block B publishes DAT_0001b540 (Capstone MOVE.L $1b540.L → handle+4).
			if dat_0001b540 == 0 and dat_00054_fixed_slots.is_empty():
				publish_00054_block_b()
			## [INFERRED] 01b6c(0xa2) stand-in via live 01a68.
			var h_alloc2: Dictionary = FlightMathScript.apply_01a68_alloc(0xA2, heap_01a68)
			var h_ptr2: int = int(h_alloc2.get("payload_ptr", 0))
			var flags_in2: int = int(mem_u32.get(spawn_05116_world_obj + 4, 0))
			last_115b0_factory = FlightMathScript.apply_115b0_factory(
				spawn_05116_world_obj,
				flags_in2,
				dat_0001b540,
				h_ptr2
			)
			last_115b0_factory["alloc"] = h_alloc2
			last_115b0_factory["entry_resolve"] = fac_entry
			last_115b0_factory["resolve"] = last_1b524_factory_resolve
			if bool(last_115b0_factory.get("ok", false)):
				handle_for_plus8 = h_ptr2
				mem_u32[h_ptr2] = int(last_115b0_factory.get("handle_u32_00", 0))
				mem_u32[h_ptr2 + 4] = int(last_115b0_factory.get("handle_u32_04", 0))
				mem_u32[spawn_05116_world_obj + 4] = int(last_115b0_factory.get("obj_flags_04", 0))
	last_04690_plus8 = FlightMathScript.apply_046da_factory_plus8(
		type_byte,
		handle_for_plus8,
		int(mem_u32.get(slot_addr + 2, 0)),
		int(mem_u32.get(slot_addr + 4, 0)),
		int(mem_u32.get(slot_addr + 6, 0)),
		int(mem_u32.get(slot_addr + 0, 0)) & 0xFFFF
	)
	if bool(last_04690_plus8.get("install", false)):
		var hptr: int = int(last_04690_plus8.get("handle_ptr", 0))
		mem_u32[spawn_05116_world_obj + 8] = hptr
		if bool(last_04690_plus8.get("clear_handle", false)):
			mem_u32[hptr] = 0
		if bool(last_04690_plus8.get("write_aux", false)):
			mem_u32[hptr + 0x20] = int(last_04690_plus8.get("aux_20", 0)) & 0xFFFF
			mem_u32[hptr + 0x22] = int(last_04690_plus8.get("aux_22", 0)) & 0xFFFF
			mem_u32[hptr + 0x24] = int(last_04690_plus8.get("aux_24", 0)) & 0xFFFF
	else:
		mem_u32[spawn_05116_world_obj + 8] = 0
	## [RECONSTRUCTED] Pacific Conflict.c:5251 — FUN_0000435a(world, 1) before 03b98.
	last_0435a = _apply_fun_0000435a(spawn_05116_world_obj, 1)
	## [RECONSTRUCTED] FUN_00003b98 Capstone: abs(pos−camera) ×3 → combine → +0x10 / D0.
	var ax: int = 0
	var ay: int = 0
	var az: int = 0
	if spawn_046da_03b98_axes_override is Array and spawn_046da_03b98_axes_override.size() >= 3:
		ax = int(spawn_046da_03b98_axes_override[0])
		ay = int(spawn_046da_03b98_axes_override[1])
		az = int(spawn_046da_03b98_axes_override[2])
		last_03b98_axes = {"a": ax, "b": ay, "c": az, "override": true}
	else:
		last_03b98_axes = FlightMathScript.apply_03b98_camera_abs_axes(
			int(mem_u32.get(spawn_05116_world_obj + 0x18, 0)),
			int(mem_u32.get(spawn_05116_world_obj + 0x1C, 0)),
			int(mem_u32.get(spawn_05116_world_obj + 0x20, 0)),
			dat_0001d838,
			dat_0001d834,
			dat_0001d830
		)
		ax = int(last_03b98_axes.get("a", 0))
		ay = int(last_03b98_axes.get("b", 0))
		az = int(last_03b98_axes.get("c", 0))
	last_03b98 = FlightMathScript.apply_fun_00003b98(ax, ay, az)
	var metric: int = int(last_03b98.get("metric", 0))
	mem_u32[spawn_05116_world_obj + 0x10] = int(last_03b98.get("field_10", 0))
	var field_0c: int = int(mem_u32.get(spawn_05116_world_obj + 0x0C, 0))
	last_046da_04e6e_gate = FlightMathScript.apply_046da_04e6e_distance_gate(metric, field_0c)
	last_04e6e_list = {}
	last_04808 = {}
	last_02bd8_gate = {}
	last_02bd8_args = {}
	last_02bd8_walk = {}
	last_04e6e_followup = {}
	last_03da8 = {}
	## Keep last_0435a / last_046da_02bd8_commit from 046da; nested 04e6e may overwrite last_*.
	if bool(last_046da_04e6e_gate.get("need_04e6e", false)):
		## Kind-2: list publish → heap×2 size=(36+3a)*0xC → +0x4c/+0x44 (5631–5643).
		## Capstone: LEA $1A48+JSR×2 → +0x4C/+0x44, but $1A48 is heap_free epilogue
		## ($1A68 = heap_alloc = +0x20). Stand-in apply_01a68_alloc matches push-size ABI.
		var byte07: int = int(mem_u32.get(spawn_05116_world_obj + 7, 0)) & 0xFF
		last_04e6e_list = FlightMathScript.apply_04e6e_kind2_list_select(byte07)
		if bool(last_04e6e_list.get("to_d4a4", false)):
			dat_0001d4a4_world.append(spawn_05116_world_obj)
		else:
			dat_0001b5a4_world.append(spawn_05116_world_obj)
		var f36: int = int(mem_u32.get(spawn_05116_world_obj + 0x36, 0))
		var f3a: int = int(mem_u32.get(spawn_05116_world_obj + 0x3A, 0))
		var vert_bytes: int = FlightMathScript.apply_04e6e_kind2_alloc_bytes(f36, f3a)
		var alloc_4c: Dictionary = {}
		var alloc_44: Dictionary = {}
		var ptr_4c: int = 0
		var ptr_44: int = 0
		if spawn_04e6e_use_mock_ptrs:
			## Fixture install (incl. 0 → 05116 gate fail; VERT_BASE vertex tables).
			ptr_4c = spawn_04e6e_ptr_4c
			ptr_44 = spawn_05116_world_field_44
			alloc_4c = {"ok": true, "payload_ptr": ptr_4c, "mocked": true}
			alloc_44 = {"ok": true, "payload_ptr": ptr_44, "mocked": true}
		else:
			alloc_4c = FlightMathScript.apply_01a68_alloc(vert_bytes, heap_01a68)
			alloc_44 = FlightMathScript.apply_01a68_alloc(vert_bytes, heap_01a68)
			ptr_4c = int(alloc_4c.get("payload_ptr", 0))
			ptr_44 = int(alloc_44.get("payload_ptr", 0))
		last_04e6e_kind2 = FlightMathScript.apply_04e6e_kind2_vertex_ptrs(
			ptr_4c, ptr_44, f36, f3a
		)
		last_04e6e_kind2["alloc_4c"] = alloc_4c
		last_04e6e_kind2["alloc_44"] = alloc_44
		last_04e6e_kind2["via_01a68"] = not spawn_04e6e_use_mock_ptrs
		mem_u32[spawn_05116_world_obj + 0x4C] = ptr_4c
		mem_u32[spawn_05116_world_obj + 0x44] = ptr_44
		_04e6e_kind2_04808_followup(spawn_05116_world_obj)
	else:
		last_046da_deferred = true
		## Deferred DAT_0001d0e4 path: +0x44 not allocated here → 05116 gate fails.
		mem_u32[spawn_05116_world_obj + 0x44] = 0


## [RECONSTRUCTED] FUN_000044a4 (5079–5091): 0435a then type-5 flags_04 ±0x40.
func _apply_fun_000044a4(world_obj: int, param_2: int) -> Dictionary:
	last_044a4 = {}
	if world_obj == 0:
		return last_044a4
	_apply_fun_0000435a(world_obj, param_2)
	var ent: int = int(mem_u32.get(world_obj + 8, 0))
	var type_short: int = 0
	if ent != 0:
		## **(short**)(entity+4) — mock: mem_u32[entity+4] = ptr; mem_u32[ptr] = type.
		var type_ptr: int = int(mem_u32.get(ent + 4, 0))
		if type_ptr != 0:
			type_short = int(mem_u32.get(type_ptr, 0)) & 0xFFFF
	var fl: Dictionary = FlightMathScript.apply_044a4_type5_flags(
		int(mem_u32.get(world_obj + 4, 0)),
		ent,
		type_short,
		mission_short_b0
	)
	last_044a4 = {
		"param_2": param_2,
		"world_obj": world_obj,
		"entity": ent,
		"type_short": type_short,
		"type5": fl,
	}
	if bool(fl.get("applied", false)):
		mem_u32[world_obj + 4] = int(fl.get("flags_04", 0))
	return last_044a4


## [RECONSTRUCTED] Resolve 0435a iVar5 template + *(tpl+0xe) (5020–5038).
## Falls back to spawn_0435a_scale_src when parent/embed/b5a0+0x8c missing.
func _0435a_resolve_scale_src(world_obj: int) -> Dictionary:
	var parent: int = int(mem_u32.get(world_obj + 0x24, 0))
	var embed: int = int(mem_u32.get(parent + 0x28, 0)) if parent != 0 else 0
	var b5a0_8c: int = int(mem_u32.get(dat_0001b5a0 + 0x8C, 0)) if dat_0001b5a0 != 0 else 0
	var idx: int = int(mem_u32.get(world_obj + 1, 0)) & 0xFF
	var raw_off: int = 0
	if embed != 0:
		raw_off = int(mem_u32.get(embed + 0x2E + idx * 0x18, 0))
	var addr: Dictionary = FlightMathScript.apply_0435a_template_addr(
		b5a0_8c, embed, idx, raw_off
	)
	if bool(addr.get("ok", false)):
		var tpl: int = int(addr.get("template_ptr", 0))
		return {
			"scale_src": int(mem_u32.get(tpl + 0x0E, 0)),
			"template_ptr": tpl,
			"source": "mem_0e",
			"addr": addr,
		}
	return {
		"scale_src": spawn_0435a_scale_src,
		"template_ptr": 0,
		"source": "spawn_fallback",
		"addr": addr,
	}


## [RECONSTRUCTED] Collect *(stream+10) along 0435a poly records (5049–5069).
## Prefer mem walk from template; else spawn_0435a_poly_srcs.
func _0435a_resolve_poly_srcs(template_ptr: int, field_3a: int) -> Dictionary:
	var n: int = field_3a
	if n < 0:
		n = 0
	if template_ptr != 0:
		var base: Dictionary = FlightMathScript.apply_0435a_poly_stream_base(
			template_ptr,
			int(mem_u32.get(template_ptr + 0x1A, 0)),
			int(mem_u32.get(template_ptr + 0x1E, 0)),
		)
		var stream: int = int(base.get("stream_base", 0))
		var srcs: Array = []
		for _i in range(n):
			srcs.append(int(mem_u32.get(stream + 0x0A, 0)))
			var byte08: int = int(mem_u32.get(stream + 8, 0)) & 0xFF
			stream = FlightMathScript.apply_0435a_poly_stream_advance(stream, byte08)
		return {
			"srcs": srcs,
			"source": "mem_stream",
			"stream_base": base,
			"stream_end": stream,
		}
	return {
		"srcs": spawn_0435a_poly_srcs.duplicate(),
		"source": "spawn_fallback",
		"stream_base": {},
		"stream_end": 0,
	}


## [RECONSTRUCTED] FUN_0000435a gate / +0xc / kind2 poly +0x1c (5018–5071).
## Shared by FUN_000044a4 tick passes, 046da (param_2=1), and post-02bd8 spawn followup.
func _apply_fun_0000435a(world_obj: int, param_2: int) -> Dictionary:
	_fun_0000435a_calls_this_tick += 1
	last_0435a = {}
	if world_obj == 0:
		return last_0435a
	var byte05: int = int(mem_u32.get(world_obj + 5, 0)) & 0xFF
	var byte06: int = int(mem_u32.get(world_obj + 6, 0)) & 0xFF
	var byte07: int = int(mem_u32.get(world_obj + 7, 0)) & 0xFF
	var gate35: Dictionary = FlightMathScript.apply_0435a_gate(byte07, mission_phase_a8)
	last_0435a = {"gate": gate35, "param_2": param_2, "world_obj": world_obj}
	if not bool(gate35.get("enter", false)):
		return last_0435a
	var scale35: int = FlightMathScript.apply_0435a_scale_factor(byte05, mission_phase_a8)
	var kind: int = int(mem_u32.get(world_obj + 0, 0))
	var src: Dictionary = _0435a_resolve_scale_src(world_obj)
	last_0435a["scale_src"] = src
	var f0c: Dictionary = FlightMathScript.apply_0435a_field_0c(
		int(mem_u32.get(world_obj + 0x0C, 0)),
		int(src.get("scale_src", spawn_0435a_scale_src)),
		scale35,
		kind,
		byte06
	)
	last_0435a["field_0c"] = f0c
	last_0435a["scale_factor"] = scale35
	if bool(f0c.get("wrote", false)):
		mem_u32[world_obj + 0x0C] = int(f0c.get("field_0c", 0))
	var f3a: int = int(mem_u32.get(world_obj + 0x3A, 0))
	var poly_src: Dictionary = _0435a_resolve_poly_srcs(
		int(src.get("template_ptr", 0)), f3a
	)
	last_0435a["poly_srcs"] = poly_src
	var loop1c: Dictionary = FlightMathScript.apply_0435a_poly_1c_loop(
		poly_src.get("srcs", []),
		f3a,
		scale35,
		spawn_0435a_is_player,
		param_2,
		kind
	)
	last_0435a["poly_1c"] = loop1c
	if bool(loop1c.get("ran", false)):
		var buf: int = int(mem_u32.get(world_obj + 0x48, 0))
		if buf == 0:
			buf = spawn_04808_buf_ptr
		var vals: Array = loop1c.get("values", [])
		for pi in range(vals.size()):
			mem_u32[buf + 0x1C + pi * 0x20] = int(vals[pi])
	return last_0435a


## [RECONSTRUCTED] FUN_00005116 free-slot + grow + fill + world gate (5705–5746).
func _call_fun_00005116(
	desc: int,
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
	last_05116_grew = false
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
		## [RECONSTRUCTED] FUN_00001ba8 grow-by-10 then use first new slot (5726–5731).
		last_05116_need_grow = true
		table_base = _grow_05116_table(table_base, count)
		idx = count
		count = dat_0001d6fc_slot_count
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
	## [RECONSTRUCTED] FUN_000046da: slot+0x14 ← world; identity stores (5226–5235).
	mem_u32[slot + 0x14] = spawn_05116_world_obj
	var template_index: int = int(mem_u32.get(desc + 1, 0)) & 0xFF
	_call_fun_000046da(desc, template_index, idx)
	## Gate reads *(world+0x44) after 046da/04e6e (5741–5745), not the fixture alone.
	var gate: Dictionary = FlightMathScript.apply_05116_world_gate(
		spawn_05116_world_obj,
		int(mem_u32.get(spawn_05116_world_obj + 0x44, 0))
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
		last_15d20_result = _call_fun_00015d20(entity)
		## [RECONSTRUCTED] non-null + player → short*[0x1b]=1 (14682–14683).
		if last_15d20_result != 0 and entity == designated_player_entity and spawn_15bf6_entity != null:
			spawn_15bf6_entity.set_u16_field("field_36", 1)
	entity.set_s8_field("field_676", int(br.get("field_676", 0)))
	entity.set_s16_field("field_682", int(br.get("field_682", 0)))

## [RECONSTRUCTED] FUN_00015d20 (20133–20141): 0262e → 15bf6(param_2=1).
func _call_fun_00015d20(entity: RefCounted) -> int:
	var world: int = int(entity.world_obj_ptr)
	var tpl_44: int = 0
	if entity.external_template != null:
		tpl_44 = entity.external_template.get_s16_field("field_44")
	var yaw_arg: int = (entity.get_s16_field("movement_626") - tpl_44) & 0x3FFF
	var speed: int = _to_s16(int(entity.get_field("movement_62a")))
	var p20: int = entity.get_u16_field("pos_20")
	var a22: int = entity.get_u16_field("attitude_22")
	var f24: int = entity.get_s16_field("field_24") & 0xFFFF
	last_15d20_args = {
		"speed": speed,
		"param_2": 1,
		"world_x": int(mem_u32.get(world + 0x18, 0)),
		"world_y": int(mem_u32.get(world + 0x1c, 0)),
		"world_z": int(mem_u32.get(world + 0x20, 0)),
		"pos_20": p20,
		"attitude_22": a22,
		"field_24": f24,
		"yaw_arg": yaw_arg,
	}
	var matrix9: Array = FlightMathScript.fun_0000262e(yaw_arg, p20, a22, f24)
	return _call_fun_00015bf6(
		speed,
		1,
		int(mem_u32.get(world + 0x18, 0)),
		int(mem_u32.get(world + 0x1c, 0)),
		int(mem_u32.get(world + 0x20, 0)),
		matrix9
	)


## [RECONSTRUCTED] FUN_00015bf6 (20088–20128): 028dc → RNG → 05116 → fields → 1a63e(+0x40).
func _call_fun_00015bf6(
	param_1_speed: int,
	param_2: int,
	param_3_x: int,
	param_4_y: int,
	param_5_z: int,
	matrix9: Array = []
) -> int:
	var draws: Array = [
		_rng_consume_11544_callsite(),
		_rng_consume_11544_callsite(),
		_rng_consume_11544_callsite(),
	]
	var loc: Dictionary = FlightMathScript.apply_15bf6_local_perturb(param_1_speed, draws, matrix9)
	last_15bf6_locals = loc
	var sx: int = param_3_x + int(loc.get("spawn_x_delta", 0))
	var sy: int = param_4_y + int(loc.get("spawn_y_delta", 0))
	var sz: int = param_5_z + int(loc.get("spawn_z_delta", 0))
	var table_base: int = int(mem_u32.get(dat_0001d6fc + 0x30, 0))
	var use_pool: bool = table_base != 0 and dat_0001d6fc_slot_count > 0
	var result_handle: int = 0
	if use_pool:
		var world_obj: int = _call_fun_00005116(dat_0002664a, sx, sy, sz, 0, 0, 0, 0)
		if world_obj == 0:
			return 0
		result_handle = int(mem_u32.get(world_obj + 8, 0))
		if result_handle == 0:
			return 0
	elif spawn_15bf6_entity != null:
		result_handle = spawn_15bf6_handle
	else:
		return 0
	if spawn_15bf6_entity == null:
		return result_handle
	var wr: Dictionary = FlightMathScript.apply_fun_00015bf6_spawn_fields(
		int(loc.get("local_e", 0)),
		int(loc.get("local_a", 0)),
		int(loc.get("local_6", 0)),
		param_2
	)
	spawn_15bf6_entity.set_field("state_32", int(wr.get("state_32", 0)))
	spawn_15bf6_entity.set_field("entity_data_ptr", int(wr.get("entity_data_ptr", 0)))
	spawn_15bf6_entity.set_field("position_velocity_c", int(wr.get("position_velocity_c", 0)))
	spawn_15bf6_entity.set_field("ptr_10", int(wr.get("ptr_10", 0)))
	spawn_15bf6_entity.set_u16_field("field_38", int(wr.get("field_38", 0)))
	spawn_15bf6_entity.set_u16_field("count_3a", int(wr.get("count_3a", 0)))
	## [RECONSTRUCTED] FUN_0001a63e(matrix, entity+0x40, 0x12) — 9×s16 (20126).
	if matrix9.size() >= 9:
		spawn_15bf6_entity.attitude_matrix_40 = FlightMathScript.fun_0001a63e_copy_matrix9(matrix9)
	return result_handle

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
		last_19430_result = _call_fun_00019430(entity)
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

## [RECONSTRUCTED] FUN_00019430 (23077–23114): 05116 → fields → 0xd vertex loop.
func _call_fun_00019430(entity: RefCounted) -> int:
	var world: int = int(entity.world_obj_ptr)
	var speed: int = _to_s16(int(entity.get_field("movement_62a")))
	var p20: int = entity.get_u16_field("pos_20")
	var a22: int = entity.get_u16_field("attitude_22")
	var f24: int = entity.get_s16_field("field_24") & 0xFFFF
	var wx: int = int(mem_u32.get(world + 0x18, 0))
	var wy: int = int(mem_u32.get(world + 0x1c, 0))
	var wz: int = int(mem_u32.get(world + 0x20, 0))
	last_19430_args = {
		"speed": speed,
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
	var spawn_world_obj: int = 0
	if use_pool:
		spawn_world_obj = _call_fun_00005116(dat_00026780, wx, wy, wz, p20, a22, f24, 0)
		if spawn_world_obj == 0:
			return 0
		result_handle = int(mem_u32.get(spawn_world_obj + 8, 0))
		if result_handle == 0:
			return 0
	elif spawn_19430_entity != null:
		result_handle = spawn_19430_handle
	else:
		return 0
	if spawn_19430_entity == null:
		return result_handle
	var wr: Dictionary = FlightMathScript.apply_fun_00019430_spawn_fields(
		speed, p20, a22, f24, dat_0001b838
	)
	spawn_19430_entity.set_field("field_610", int(wr.get("field_610", 0)))
	spawn_19430_entity.set_u16_field("field_614", int(wr.get("field_614", 0)))
	spawn_19430_entity.set_u16_field("pos_20", int(wr.get("pos_20", 0)))
	spawn_19430_entity.set_u16_field("attitude_22", int(wr.get("attitude_22", 0)))
	spawn_19430_entity.set_s16_field("field_24", int(wr.get("field_24", 0)))
	## [RECONSTRUCTED] 0xd vertex >>3 / scale from *(world+0x44) (23098–23110).
	var vert_base: int = 0
	if spawn_world_obj != 0:
		vert_base = int(mem_u32.get(spawn_world_obj + 0x44, 0))
	if vert_base != 0:
		var verts: Array = []
		for i in range(0xD):
			var off: int = vert_base + i * 0xC
			verts.append({
				"x": int(mem_u32.get(off + 0, 0)),
				"y": int(mem_u32.get(off + 4, 0)),
				"z": int(mem_u32.get(off + 8, 0)),
			})
		var vl: Dictionary = FlightMathScript.apply_fun_00019430_vertex_loop(verts)
		var shifted: Array = vl.get("verts_shifted", []) as Array
		for i in range(shifted.size()):
			var sv: Dictionary = shifted[i] as Dictionary
			var off2: int = vert_base + i * 0xC
			mem_u32[off2 + 0] = int(sv.get("x", 0))
			mem_u32[off2 + 4] = int(sv.get("y", 0))
			mem_u32[off2 + 8] = int(sv.get("z", 0))
		spawn_19430_entity.vertex_scale_622 = vl.get("entity_622", []) as Array
		spawn_19430_entity.vertex_scale_656 = vl.get("entity_656", []) as Array
		spawn_19430_entity.vertex_scale_68a = vl.get("entity_68a", []) as Array
	spawn_19430_entity.set_field("field_618", int(wr.get("field_618", 0)))
	spawn_19430_entity.set_u16_field("field_61c", int(wr.get("field_61c", 0)))
	return result_handle

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
