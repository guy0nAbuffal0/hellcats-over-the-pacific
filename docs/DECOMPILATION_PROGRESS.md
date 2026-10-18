# C-to-C reconstruction checkpoint

This is the concise entry point for focused semantic reconstruction.

**Next target:** `build_land_outline_at_detail` (FUN_00004958) and
`sink_object_shape_at_waterline` (FUN_00015762), the last RENAMED helpers of
activate_near_range_object. The face-colour chain (assign / queue / write slot / snapshot /
bw pattern) is VERIFIED.

Open questions recorded in `update_aircraft_entity`: blk 3b reads the blk 2b engine
locals uninitialised for non-player aircraft (reachability unknown); blk 2b's divs.w
could trap on a zero divisor (reachability unknown). Section-check comments say
"blk N", never "Block N", so `re_query.py excerpt --block` stays unambiguous.

The overlay heap (sbrk, size-class / large-block growth, alloc, free) and the overlay
RNG (init, mul_mix, next) are fully VERIFIED; the false entry FUN_00001a48 is settled.
Already VERIFIED:
`ai_pursue_target`, `bullet_hits_aircraft`, `steer_entity_toward_point`,
`apply_relative_heading_steer`, `retire_entity`, `dispatch_entity_cleanup`, `deactivate_object`, `release_fractal_reference`, `heap_free_coalesce`, `heap_alloc`, `heap_new_size_class_block`, `heap_add_large_block`, `heap_sbrk`, `isqrt_floor`, `update_aircraft_entity`, `fold_angle_pm_0x2000`, `compute_template_force_from_626` (+ false split e512), `abs_int`, `transform_vecs12_by_matrix3`, `build_attitude_matrix` (wrapper), `load_attitude_angle_sincos`, `fill_attitude_rotation_bases`, `fill_attitude_rotation_basis_4`, `finalize_attitude_matrix_4ang`, `matmul3x3_s16`, `enemy_fighter_notice_object`, `invert_ai_bias_67b_if_positive`, `ai_attack_or_fly`, `ai_fly`, `ai_dive_at_target`, `ai_bombing_run`, `adjust_ai_throttle_vs_speed`, `max_ai_throttle_maybe_invert_679`, `ensure_ai_script_1b2e0_tick`, `tick_ai_climb_then_waypoint`, `advance_route_waypoint`, `ai_bootstrap_climb_phase`, `enqueue_control_inputs_avg4`, `ensure_ai_script_1b340_tick`, `ensure_ai_script_1b310_tick`, `tick_ai_1b310_approach_fire`, `ai_script_try_fire_burst`, `tick_ai_1b370_mission`, `try_begin_landing_approach`, `find_nearest_runway_approach_ends`, `store_xyz_asr`, `tick_landing_approach_glide`, `apply_player_mouse_controls`, `process_flight_input_and_outcome`, `copy_player_pose_to_camera`, `update_bailout_view`, `player_slew_mode`, `point_near_camera_or_type80_object`, `compute_camera_abs_metric`, `nearest_type80_centroid_visitor`, `update_object_camera_metric`, `transform_through_node_chain`, `translate_int3_vecs`, `transform_int3_vecs_by_matrix3`, `build_attitude_matrix_3ang`, `finalize_attitude_matrix_3ang`, `build_attitude_matrix_3ang_alt`, `finalize_attitude_matrix_3ang_alt`, `apply_template_chain_xform`, `apply_template_chain_xform_always`, `activate_near_range_object`, `update_object_distance_band`, `shade_object_faces`, `apply_entity_mission_rates`, `build_object_poly_buffers`, `write_face_palette_slot`, `assign_face_colour`, `snapshot_face_colours`, `queue_face_palette_entry`, `set_object_faces_bw_pattern`, `overlay_rng_next` (lagged additive RNG,
x[n] = x[n-1] + x[n-32] over the 55-long ring 0x2600c..0x260e7).

The angle path feeding `attitude_from_velocity` is established:
`acos_fixed14` and `atan_fixed14` match independent disassembly, and their
cosine/tangent lookup-table scales are recorded in the symbol reference.

A function may be marked `VERIFIED` when its body matches an independent
disassembly of the bytes and every call argument omitted by Ghidra is recorded
as a call-argument correction in
[`DECOMPILATION_SYMBOLS.md`](DECOMPILATION_SYMBOLS.md).

## Current coverage

Run `python3 tools/progress_stats.py` for current orthogonal reconstruction,
strict-port, and resource counts. The segment-qualified canonical records live
in [`DECOMPILATION_INVENTORY.json`](DECOMPILATION_INVENTORY.json); statuses are
reconstruction states, not Godot coverage. The strict-port manifest is the sole
authoritative C-to-GDScript mapping.

## Canonical sources

- Immutable Ghidra exports: `sources/resedit/CODE/*.c`
- Semantic reconstructions: `sources/resedit/CODE/*.decomp.c`
- Function inventory: `DECOMPILATION_INVENTORY.json`
- Symbols, globals, fields, and confidence: `DECOMPILATION_SYMBOLS.md`
- Immutable-source hashes: `DECOMPILATION_PROTECTED_CHECKSUMS.sha256`
- Strict C-to-GDScript mappings: `godot/strict_port/mappings/functions.json`

Source-local provenance comments remain authoritative evidence and must not be
removed merely because the same identity is retrievable elsewhere.

## Focused reconstruction

1. Inspect `git status --short`; do not overwrite unrelated edits.
2. Select one target from this checkpoint.
3. Retrieve only the required function, excerpt, callers, callees, globals, and
   test case with `tools/re_query.py`.
4. Compare the immutable `.c`, semantic `.decomp.c`, and independent
   binary/disassembly evidence.
5. Preserve identifiers, widths, arithmetic, conditions, layouts, and
   unresolved annotations in every evidence-backed edit.
6. Regenerate the inventory and run targeted checks, followed by the validation
   in `README.md` before handoff.

## Priority queue

1. Verify `update_aircraft_entity` (FUN_0000e792; flight update after AI steering).
2. Identify the `overlay_rng_init` caller and its seed source.
3. Continue independent verification of high-traffic Pacific Conflict functions.
4. Resolve remaining ID09/ID05 segment-entry evidence.
5. Investigate `FUN_00003cca` only when its dependencies are needed.

The `$1A48` allocator ABI is resolved: the runtime address maps to `heap_alloc`
at file offset `0x1a68`.
