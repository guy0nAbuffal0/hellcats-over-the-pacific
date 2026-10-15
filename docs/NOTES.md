# Daily log (evidence-first)

Every statement is tagged: **[RECONSTRUCTED]** (from decompiler/binary), **[INFERRED]** (reasoning from evidence), **[UNKNOWN]** (unverified or missing).

## Template (copy for new days)

```markdown
### YYYY-MM-DD
- [RECONSTRUCTED] ...
- [INFERRED] ...
- [UNKNOWN] ...
```

## Entries

### 2026-10-15 — FUN_00012840 wired through FUN_00005116 pool

- **[RECONSTRUCTED]** When `*(DAT_0001d6fc+0x30)` and slot count > 0: `12840` calls `05116(DAT_00026280, xyz, att, 0)`, then `entity=*(world+8)`, then post-spawn field writes (17551–17571).
- **[INFERRED]** Without a configured pool, entity-fixture bypass remains (no allocator) for unit harnesses.
- **Validation:** `_test_fun_00012840_via_05116_pool`; Godot **13 passed, 0 failed**; Python QA green.

### 2026-10-15 — FUN_00005116 free-slot scan + fill + world gate

- **[RECONSTRUCTED]** `FUN_00005116` (5705–5746): scan `*(DAT_0001d6fc+0x30)` slots of `0x18` for `+0x14==0`; fill `+0/+2/+4/+6` attitudes and `+8/+c/+10` xyz; `046da`; return world at `+0x14` iff `*(world+0x44)!=0` else `051ec`→0.
- **[DEFERRED]** `FUN_00001ba8` grow-by-10 when full; real `FUN_000046da` (mock installs `spawn_05116_world_obj` / `world+8` entity handle).
- **Godot:** `find_05116_free_slot_index` / `apply_05116_slot_fill` / `apply_05116_world_gate`; `SimCore._call_fun_00005116`.
- **Validation:** Godot **13 passed, 0 failed**; Python QA green. `12840` still uses entity fixture for field writes.

### 2026-10-15 — FUN_00012840 post-spawn field writes (05116 deferred)

- **[RECONSTRUCTED]** `FUN_00012840` (17551–17571): `05116(DAT_00026280, xyz, att, 0)` → on success `entity=*(obj+8)`; if `param_2≠0` `field_61c|=0x40`; write `field_610=param_1`, `+0x20/+0x22/+0x24=param_6/7/8`.
- **[RECONSTRUCTED]** Player fire latch (14655–14658): non-null + player → `DAT_0001b880`, `short*[0x30a]=1` (byte `0x614`), `DAT_0001b846=1`.
- **[RECONSTRUCTED]** `FUN_00005116` free-slot path — see entry “FUN_00005116 free-slot…”. `01ba8`/`046da` still deferred.
- **Godot:** `apply_fun_00012840_spawn_fields`; `SimCore._call_fun_00012840`; entity offsets `field_610`/`614`/`61c`.
- **Validation:** Godot **13 passed, 0 failed**; Python QA green. Mission 1 unchanged.

### 2026-10-15 — FUN_00011544 call-site alias + flags_685&2 + @ field_18c

- **[RECONSTRUCTED]** Binary `Hellcats/Pacific Conflict`: 17× `LEA.L $11544; JSR (An)` then use D0 as u16 (`&0x7f` / `&0x3f` / …). Bytes at `$11544` are the `1150a` warm-up epilogue (`cursor+=0xd8`; 10000×`BSR $11564`; `MOVEM`; `RTS`). Bytes at `$11564` are the overlay RNG. Zero absolute LEA/JSR to `$11564`.
- **[INFERRED]** Call-site “FUN_00011544” ≡ one `FUN_00011564` draw (D0 = `sum>>16`). Executing `$11544` literally would be 10k draws + unbalanced MOVEM — not viable per tick. Godot: `RngOverlay11564.fun_00011544_callsite()` → `next()`.
- **[RECONSTRUCTED]** `flags_685&2` ammo tail (14721–14734): first callsite draw; if `(d0&0x3f)==0` second draw; if `(d1&1)==0` or `67d==0` then `67e--` if nonzero else `67d--`. Godot: `apply_e792_flags685_bit2_tail` / `SimCore._apply_e792_flags685_bit2_tail`.
- **[RECONSTRUCTED]** Grounded `@` (0x40): two callsite draws → `field_18c += (d0&0x7f)`, `uVar13=(d1&0x7f)-0x40` with speed scale; optional third `11564` for `b854` when player/`b856==0`/speed≥`0x2d1` (14537–14555).
- **[DEFERRED]** Contact-path `0x61a`/`0x61e` attitude writes via 11544 (bad decomp / separate sites).
- **Validation:** Godot **13 passed, 0 failed**; `python3 tools/qa/test_regression.py` green. Mission 1 / `FlightModelMvp` unchanged.

### 2026-10-15 — FUN_00011564 overlay RNG fixture (not yet SimCore)

- **[RECONSTRUCTED]** `FUN_00011564` (Pacific Conflict.c:16407–16433): table RNG at `DAT_00026008`…`0x260e4` (56 words **[INFERRED]** from span); `*p4 = *p5 + *p3`; return `sum >> 16`; wrap rules `+4`/`-0xd8`, `+0x17`/`-0x20`, `+0x36`/`-1` words vs limit `0x260e7`.
- **[RECONSTRUCTED]** Godot: `hellcats/core/rng_overlay_11564.gd` + `godot/tests/unit/test_rng_overlay_11564.gd` fixture sequence.
- **SimCore wiring:** `_rng_consume()` uses `RngOverlay11564`; ID05 on `rng_id05`.
- **[RECONSTRUCTED]** `FUN_000114ca` + `FUN_0001150a` fill (`table[1]=param`, `table[i+1]=114ca(0x1df5e0d,table[i])+1` for i=1..0x36), cursor `0x260e4`, then 10000×`11564`. `set_seed` = full `init_1150a`.
- **[UNKNOWN]** Pre-init value of `table[0]`; treated as 0.
- **Validation:** fill + warm-up fixtures; suite **12 passed, 0 failed**.

### 2026-10-15 — FUN_0000e792 contact early-out (SimCore)

- **[RECONSTRUCTED]** When `(status_1a1 & 8) != 0` (Pacific Conflict.c:14083–14104): compare `pos_2e` to surface`+(-0x16)`; set `position_velocity_c` to `-0x16` or `pos_2e+template_field_40_adj-surface`; if `field_0b==0x10` OR status `0x1000` and if player set `DAT_0001b850=1`; clear `movement_669`; **return** (skips later e792 slices).
- **[RECONSTRUCTED]** `iVar1 = *param_1` is a pointer; surface = `*(iVar1+0x1c)` (14084). Same pattern `*DAT_0001b738+0x1c` (7354, 7671). Godot: `EntityState.world_obj_ptr` + `SimCore.mem_u32[ptr+0x1c]`.
- **[INFERRED]** `field_00` type byte vs word-0 pointer overlay unresolved without a byte-accurate entity image.
- **[DEFERRED]** `FUN_00011544` RNG updates to `0x61a`/`0x61e` (bad decomp / void return).
- **Validation:** contact tests use `world_obj_ptr` + `mem_u32`; suite green; Mission 1 not wired.

### 2026-10-15 — FUN_0000528a / FUN_000051ec (SimCore cleanup)

- **[RECONSTRUCTED]** `FUN_0000528a` (Pacific Conflict.c:5784–5798): early-out if `param_1[7]&2`; else if `(field_24==DAT_0001d6fc && b88e<=field_01<=b88c) || type!=2` → `FUN_000051ec`; else type-2 alt `field_04\|=0x42`, `field_3c=DAT_0001b838`.
- **[RECONSTRUCTED]** `FUN_000051ec` entity writes: `pos_18=1000000000`, `field_04\|=2`, `field_3c=0`; optional `DAT_0001bc64` clear when `field_01!=field_02` and in `[b88e,b88c]`; `DAT_00024cf0++`; clear `DAT_0001b880` when `entity+8` matches.
- **[RECONSTRUCTED]** Indirect stores via `SimCore.mem_u32`: table poke `*( *(DAT_0001d6fc+0x30) + 0x14 + field_02*0x18 ) = 0` when `field_01!=field_02`; `**(entity+8)=0` when `entity_data_ptr!=0`.
- **[INFERRED]** Flat `mem_u32` address map stands in for Mac heap; not a full allocator.
- **Entity offsets added:** `field_01`, `field_02`, `flags_07`, `field_24`, `field_3c`.
- **Validation:** `_test_fun_0000528a_branches` (incl. indirect); suite **11 passed, 0 failed**; Python QA passed.

### 2026-10-15 — FUN_00005df8 slot clear (SimCore)

- **[RECONSTRUCTED]** `FUN_00005df8` (Pacific Conflict.c:6434–6447): when `DAT_0001b5a0+0xac == 0`, for `i` in `0..6`, if `DAT_0001bc64[i] != 0` call **`FUN_0000528a`** then set the slot to 0.
- **[RECONSTRUCTED]** Godot: `SimCore.dat_0001bc64` (7 slots), `_call_05df8()`, `last_tick_order.fun_00005df8_*` / `fun_0000528a_calls`.
- **Validation:** `_test_fun_00005df8_slot_clear`; suite green; Python QA green.
- **Follow-up:** `FUN_0000528a` / partial `FUN_000051ec` ported in the same-day entry above.

### 2026-10-15 — FUN_00006fb8 post-tick global reset (SimCore)

- **[RECONSTRUCTED]** `FUN_00006fb8` (Pacific Conflict.c:7180–7189) assigns `100000000` to **`DAT_0001d718`**, **`DAT_0001d724`**, **`DAT_0001d714`**, **`DAT_0001d720`**, **`DAT_0001d710`**, **`DAT_0001d71c`** after the four entity passes in **`FUN_000044e8`**.
- **[RECONSTRUCTED]** Godot: `SimCore._call_06fb8()` writes the same six fields; `last_tick_order.fun_00006fb8_ran` / `fun_00006fb8_globals`; skipped when phase gate closed.
- **[INFERRED]** Later readers treat some of these as coordinate / distance bases (e.g. uses near Pacific Conflict.c:5413). Exact game names **[UNKNOWN]**.
- **Validation:** `test_sim_tick_ordering.gd` `_test_fun_00006fb8_reset`; full suite **11 passed, 0 failed**; Python QA passed.
- **Not claimed:** playable Mission-1 wiring; `FUN_00005df8` still placeholder.

### 2026-10-15 — P0 headless test reliability (class_name + QA paths)

- **[INFERRED]** Fresh `godot --headless --path . --script res://godot/tests/run_all.gd` without a `.godot/` global class cache does not resolve `class_name` identifiers used as type annotations. That broke `EntityState.from_bytes() -> EntityState` (script failed to parse → `preload(...).new()` failed) and logged parse errors for `HudAttitudeStrip` / `MissionCheckpoint`.
- **[MVP AUTHORING DECISION]** Keep `class_name` declarations for editor convenience, but type cross-script references with base types (`Control`, `Node3D`) or leave returns untyped so headless CI works without an imported project cache.
- **Files:** `hellcats/core/entity_state.gd`, `hellcats/ui/hud_mvp.gd`, `hellcats/mission/checkpoint_manager.gd`, `hellcats/mission/mission_controller.gd`, `tools/qa/test_regression.py` (`EXPECTED_RUNNER_PATHS` aligned with `run_all.gd`), `hellcats/tests/fixtures/proven_loader_targets.json` (byte-synced to migrated fixture).
- **Validation:** Godot **11 passed, 0 failed** (exit 0); `python3 tools/qa/test_regression.py` **All deterministic QA regression checks passed** (exit 0).
- **Not claimed:** visual fidelity, Mission 1 playthrough, or original-flight parity. No gameplay behavior changed.

### 2026-04-08 — Convergence Loop Mode (batch: mission bridge + RNG draws + FUN_0000435a counts)

- **[INFERRED]** Backlog + loop template: `docs/CONVERGENCE_BACKLOG.md`, `docs/CONVERGENCE_LOOP_TEMPLATE.md`.
- **[RECONSTRUCTED]** **Iteration 1 — Mission gates:** `MissionController` sets **`mission_phase_a8` / `mission_flag_ac`** (running: 1/1; terminal: 0/0); **`get_mission_sim_bridge_state()`**. See `docs/contracts/mission_state_DAT_contract.md`.
- **[RECONSTRUCTED]** **Iteration 2 — RNG timing:** `SimCore._rng_consume()` counts draws per tick; **`last_tick_order.rng_draws_this_tick`**.
- **[RECONSTRUCTED]** **Iteration 3 — FUN_0000435a / param_2:** **`last_tick_order.param_2_entity_updates`** `{0: n, 1: m}`; contract `docs/contracts/FUN_0000435a_contract.md` (type 0x02 loop gated by `param_2==0` not yet branched in code).
- **Validation:** `godot/tests/integration/test_sim_tick_ordering.gd` (includes RNG/param2 counts).

### 2026-10-15 — e792 bVar6 cleanup epilogue

- **[RECONSTRUCTED]** End of `FUN_0000e792` (14736–14748): when `bVar6` (rough landing 14462 or grounded `field_0b` switch), clamp/clear `status_1a2`, `status=(status&0x8000)|0x900`, `state_32=0xe772`, clear `movement_61a`/`61e`. Godot: `apply_e792_bvar6_cleanup`; `SimCore.e792_b_var6`.
- **[RECONSTRUCTED]** `flags_685&2` ammo-decrement tail — see entry “FUN_00011544 call-site alias…”.
- **Validation:** `test_flight_math.gd` (`_test_e792_bvar6_cleanup`); `test_sim_tick_ordering.gd` (`_test_fun_0000e792_bvar6_cleanup`).

### 2026-10-15 — e792 field_676/677 weapon tails

- **[RECONSTRUCTED]** `field_676` (14673–14693): when nonzero, if `676==1` and `field_682>1` and `(flags_685&0x10)==0` → stub `FUN_00015d20`, `682-=2`; then `676++` wrap 2→0. `field_677` (14695–14719): when `677==1` and `(flags_685&1)==0` → stub `FUN_00019430`, `status|=1`, `677←2`; player sets `DAT_0001b874`/`b872`/`d858=9`/`b87a`. Godot: `apply_e792_weapon_676_branch` / `677_branch`.
- **[DEFERRED]** `FUN_00015d20` / `FUN_00019430` bodies; world+7 bit clear; `FUN_000137da`; `FUN_00006ed6`.
- **Validation:** `test_flight_math.gd` (`_test_e792_weapon_676_677_branch`); `test_sim_tick_ordering.gd` (`_test_fun_0000e792_weapon_676_677_branch`).

### 2026-10-15 — e792 weapon field_19d/19f branch

- **[RECONSTRUCTED]** When `field_19d!=0` and `field_19f!=0` (14648–14671): if `19d==1` call `FUN_00012840`, `19f--`, `field_18d-=0x10` unless `*(DAT_0001b5a0+0x90)==2`; then `19d++` with wrap when pre-value was 4 → 0. Godot: `apply_e792_weapon_19d_branch`; `SimCore.mission_short_90`.
- **[RECONSTRUCTED]** `FUN_00012840` post-spawn writes + player latch — see entry “FUN_00012840 post-spawn…”. `FUN_00005116` still deferred.
- **Validation:** `test_flight_math.gd` (`_test_e792_weapon_19d_branch`, `_test_fun_00012840_spawn_fields`); `test_sim_tick_ordering.gd` (`_test_fun_0000e792_weapon_19d_branch`, `_test_fun_00012840_spawn_fixture`).

### 2026-10-15 — e792 67b/679 char epilogue

- **[RECONSTRUCTED]** After LAB_0000f47c (14631–14647): `field_67b++` when `(0<c<0x0f)||c<0`; `direction_char_679` mid-range `1..','` with `(flags_685&0x20)==0` → `++`, `field_67a|=2`, `status&=~0x2000`; negative 679 (outer gate) → `++`, `67a|=2`, `status|=0x2000`. `'-'` (0x2d) does not bump. Godot: `apply_e792_char_epilogue`.
- **Validation:** `test_flight_math.gd` (`_test_e792_char_epilogue`); `test_sim_tick_ordering.gd` (`_test_fun_0000e792_char_epilogue`).

### 2026-10-15 — LAB_0000f47c yaw epilogue

- **[RECONSTRUCTED]** LAB_0000f47c (14606–14629): clear `field_63f`; commit `pos_20`/`attitude_22` from `local_28`/`local_2a`; `field_24 = (uVar13 + e40c(local_2a−att22)*scale>>12) & 0x3fff`; `movement_62a = iVar20`; player ring `DAT_0001bc8c[0x78]` / `bc80` / `bc84` with clamp ±`0x1d80`. Godot: `apply_lab_0000f47c`.
- **[UNKNOWN]** `FUN_00001d56` Ghidra body unusable; `SimCore.fun_00001d56_scale` default `0x1000` (fixed-point 1.0 stand-in).
- **Validation:** `test_flight_math.gd` (`_test_lab_0000f47c`); `test_sim_tick_ordering.gd` (`_test_fun_0000e792_lab_0000f47c`).

### 2026-10-15 — grounded field_0b RNG tails (11564)

- **[RECONSTRUCTED]** `0x10` soft: `FUN_00011564` → `uVar13 = ((draw&0x3f)+(e40c(uVar13)>>1 toward 0)−0x20)` scaled by `(speed>>2)/0x438` (14559–14569). `@` + player + `b856≠0` → `DAT_0001b854=1` + clear `b856` (14537–14540, no draw).
- **[RECONSTRUCTED]** `@` `field_18c`/`uVar13` via 11544-callsite — see entry “FUN_00011544 call-site alias…”.
- **Validation:** `test_flight_math.gd` / `test_sim_tick_ordering.gd` field_0b cases (`0x10 soft uVar13`, `@ sets b854`).

### 2026-10-15 — grounded field_0b type switch

- **[RECONSTRUCTED]** Grounded `field_0b` switch (14507–14596): `' '`/`@`/`0`/`P`/`\``/`p` set `bVar6` via `abs(679)!=0x2d` or status&8; `0x10` ORs status `0x1000`/`0x400` with early return; `'P'`/`0x10` soft clear player `DAT_0001b856`; `bVar6` blocks prestall. Godot: `apply_grounded_field_0b_switch`.
- **Validation:** `test_flight_math.gd` (`_test_grounded_field_0b_switch`); `test_sim_tick_ordering.gd` (`_test_fun_0000e792_grounded_field_0b_switch`).

### 2026-10-15 — grounded post-commit speed recommit

- **[RECONSTRUCTED]** Grounded `63e!=0` common prefix: `e372(local_e²+local_6²)` → `movement_62a`, `pvc←iVar23−surface`, optional `13452` when `pos_2e==0`, clamp `local_28>0x2000`, prestall `field_190=1` when `field_63f` (14497–14603).
- **Validation:** `test_flight_math.gd` (`_test_grounded_speed_recommit`); `test_sim_tick_ordering.gd` (`_test_fun_0000e792_grounded_speed_recommit`).

### 2026-10-15 — FUN_00001f22 attitude-from-velocity

- **[RECONSTRUCTED]** `fun_00001e3a` (cos-table acos), `fun_00001ebc` (af6c dump at file `0x1af8c`), `fun_00001f22` → `local_28`/`local_2a` → `pos_20`/`attitude_22` (2516–2632, 14491, 14608–14609).
- **[INFERRED]** `FUN_00002de8` void decompile treated as `abs` on `local_e`/`local_6`.
- **Validation:** `test_flight_math.gd` (`_test_fun_00001f22`).

### 2026-10-15 — FUN_0000e372 airborne speed recommit

- **[RECONSTRUCTED]** `fun_0000e372` binary-search floor sqrt (13734–13758). Airborne path: `movement_62a ← e372(local_e²+a²+6²)`; clear `field_190` when 2 (14486–14495, 14613). Skipped on hard-crash early return.
- **Validation:** `test_flight_math.gd` (`_test_fun_0000e372`); `test_sim_tick_ordering.gd` (`_test_fun_0000e792_airborne_speed_recommit`).

### 2026-10-15 — overlay trig table dump

- **[RECONSTRUCTED]** 256-short BE sin/cos tables dumped from `Pacific Conflict` at file `0x1ab8c` / `0x1ad8c` → `hellcats/tests/fixtures/trig_tables_ab6c_ad6c.json`. Ghidra `DAT_0001ab6c`/`ad6c` labels sit **0x20** before the usable bases. Loaded by `FlightMath._ensure_trig_tables`.
- **Validation:** `test_flight_math.gd` dump spot-checks + `sin(0x1000)==0x1000`.

### 2026-10-15 — FUN_000025a8 attitude matrix

- **[RECONSTRUCTED]** `fun_00001d02` matmul; `fun_000020e6`/`021a0`/`02562`/`025a8` chain; SimCore builds `attitude_matrix_9` before 028dc commit (2942–2949, 14438).
- **Validation:** `test_flight_math.gd` (`_test_fun_000025a8_identity`).

### 2026-10-15 — FUN_00013452 hard-crash unwrap

- **[RECONSTRUCTED]** `fun_00013452` → `fun_00013346(*(world+0x18/1c/20))`; empty-list returns `*(DAT_0001bda8+0x16)`; SimCore stores result to `field_0b` when hard-crash `pos_2e==0` (14456–14458, 18173–18143).
- **[DEFERRED]** Non-empty `FUN_00013346` walk (`FUN_00003c00` / `1320a` / `13070`).
- **Validation:** `test_flight_math.gd` (`_test_fun_00013452_empty_list`); `test_sim_tick_ordering.gd` (`_test_fun_0000e792_landing_13452`).

### 2026-10-15 — FUN_0000e40c + gentle DAT_0001b856

- **[RECONSTRUCTED]** `fun_0000e40c` angle fold (13782–13793). Gentle landing gate: `abs(e40c(uVar13))>0x200` or `e40c(local_28)<-0x100` → rough; else player `dat_0001b856=1` (14464–14471). `uVar13=(sVar22+field_24)&0x3fff`; `local_28` from `pos_20` (+0x20).
- **Validation:** `test_flight_math.gd` (`_test_fun_0000e40c`, `_test_landing_pitch_followon`); `test_sim_tick_ordering.gd` (`_test_fun_0000e792_landing_gentle_b856`).

### 2026-10-15 — landing pitch follow-on

- **[RECONSTRUCTED]** `apply_landing_pitch_followon`: hard crash `attitude_0e*0x10 < -0x168` → `status|0x400` + early return; rough/gentle clear `field_18e` + player `dat_0001b868=1` (Pacific Conflict.c:14450–14476).
- **Validation:** `test_flight_math.gd` (`_test_landing_pitch_followon`); `test_sim_tick_ordering.gd` (`_test_fun_0000e792_landing_hard_crash`).

### 2026-10-15 — field_63e landing / airborne clear

- **[RECONSTRUCTED]** Touchdown + leave-ground on `field_63e` after position commit (Pacific Conflict.c:14446–14449, 14479–14484). Surface from `world_obj+0x1c`; `iVar23 = pos_2e + field_40_adj`.
- **Validation:** `test_flight_math.gd` (`_test_landing_touchdown_63e`); `test_sim_tick_ordering.gd` (`_test_fun_0000e792_landing_63e`).

### 2026-10-15 — FUN_000028dc + position commit (identity stub)

- **[RECONSTRUCTED]** `FlightMath.fun_000028dc_one` + `apply_position_commit_after_028dc`; SimCore writes `field_18c=0xffa5` and `param_1[2..4]` (Pacific Conflict.c:14441–14445).
- **[MVP STUB]** `SimCore.attitude_matrix_9` = identity until `FUN_000025a8` (sin/cos matrix build) is reconstructed.
- **Validation:** `test_flight_math.gd` (`_test_028dc_position_commit`); `test_sim_tick_ordering.gd` (`_test_fun_0000e792_position_commit`).

### 2026-10-15 — local_34 / stall iVar25

- **[RECONSTRUCTED]** `FlightMath.apply_ivar25_stall_step` + SimCore: `field_190==1` penalty, `(local_34<<2)/sVar12` add, stall→`field_190=2` / `dat_0001b868=2` (Pacific Conflict.c:14422–14433).
- **[DEFERRED]** `FUN_000025a8` position write to `param_1[2–4]`.
- **Validation:** `test_flight_math.gd` (`_test_ivar25_stall_step`); `test_sim_tick_ordering.gd` (`_test_fun_0000e792_stall_ivar25`).

### 2026-10-15 — post-thrust 0x63e / field_18e

- **[RECONSTRUCTED]** `FlightMath.compute_63e_thrust_delta` + `apply_field_18e_update`; SimCore after 0x636 thrust updates `field_18e` and subtracts from `movement_62a` (Pacific Conflict.c:14384–14421).
- **[DEFERRED]** `FUN_000025a8` position; stall when `iVar25<1` / `param_1+400`.
- **Validation:** `test_flight_math.gd` (`_test_field_18e_63e`); `test_sim_tick_ordering.gd` (`_test_fun_0000e792_field_18e_63e`).

### 2026-10-15 — reverse local_48 / DAT_0001b858 / attitude_22

- **[RECONSTRUCTED]** Designated smoothing stashes `last_local_46`/`last_local_42`; reverse path computes `last_reverse_local_48`, clears `dat_0001b858` for player, updates `attitude_22` (Pacific Conflict.c:14321–14342).
- **Validation:** `test_flight_math.gd` (`_test_compute_reverse_local_48`); `test_sim_tick_ordering.gd` (`_test_fun_0000e792_reverse_local_48`).

### 2026-10-15 — 0x626 reverse-flight clamps

- **[RECONSTRUCTED]** `FlightMath.apply_movement_626_reverse_clamp` + `SimCore._apply_movement_626_reverse_clamp` after 626 step, before e4a4 (Pacific Conflict.c:14305–14319). Gate: `field_63e!=0` and `direction=='-'`.
- **Validation:** `test_flight_math.gd` (`_test_movement_626_reverse_clamp`); `test_sim_tick_ordering.gd` (`_test_fun_0000e792_626_reverse_clamp`).

### 2026-10-15 — quadratic e468 + 0x636 thrust

- **[RECONSTRUCTED]** `FlightMath.apply_e468_quadratic_drag_raw` + `apply_thrust_636_step`; SimCore writes `0x636` and updates `movement_62a` (iVar25) after linear drag (Pacific Conflict.c:14362–14383; asm `0xEE50`).
- **[DEFERRED]** `0x63e` attitude block / position integration; `0x626` clamps.
- **Validation:** FlightMath unit cases + `test_sim_tick_ordering.gd` (`_test_fun_0000e792_e4a4_linear_drag` extended).

### 2026-10-15 — e4a4 + e468 linear drag in SimCore

- **[RECONSTRUCTED]** `SimCore._apply_e4a4_and_linear_drag` after `movement_626`: per-entity e468, e4a4 → `0x63a`/`0x19e`, `last_drag_ivar10` (asm `0xEDF8`).
- **Validation:** `test_sim_tick_ordering.gd` (`_test_fun_0000e792_e4a4_linear_drag`); prior FlightMath unit cases.

### 2026-10-15 — e4a4 + e468 linear drag (FlightMath)

- **[RECONSTRUCTED]** `FlightMath.fun_0000e4a4` + `apply_e468_linear_drag` (Pacific Conflict.c:13832–13872, 14356–14361; asm `0xEDF8` DIVS by e468).
- **Validation:** `test_flight_math.gd` (`_test_fun_0000e4a4_and_e468_drag`).

### 2026-10-15 — movement_626 speed step

- **[RECONSTRUCTED]** `FlightMath.apply_movement_626_step` + `SimCore._apply_movement_626_step` (Pacific Conflict.c:14248–14304). Runs for every entity past contact early-out (not designated-only). `e468` unused here.
- **[DEFERRED]** `0x626` clamps / reverse-flight; drag path that DIVs by `last_e468_out` (asm `0xEDF8`).
- **Validation:** `test_flight_math.gd` (`_test_apply_movement_626_step`); `test_sim_tick_ordering.gd` (`_test_fun_0000e792_movement_626_step`).

### 2026-10-15 — e42a from world+0x1c + e468 stash

- **[RECONSTRUCTED]** Designated-player prep: `FUN_0000e42a(*(world_obj+0x1c))` (not entity `pos_1c`); `FUN_0000e468(surface−pos_2e, e42a)` stored as `SimCore.last_e468_out` for later speed math (asm `0xEDF8`); `e570`/`local_46` still use raw e42a.
- **Validation:** `test_sim_tick_ordering.gd` (`_test_fun_0000e792_e42a_from_world_1c`).

### 2026-10-15 — FUN_00011544 deferral + local_46 literal 0x666

- **[DEFERRED]** `FUN_00011544`: Ghidra body is `1150a` warm-up epilogue (`unaff_D3`, 10k×`11564`); binary at file `0x11544` matches that. Call sites (14× `LEA 0x11544`) treat **D0** as RNG (`& 0x7f`, etc.). **Not proven** ≡ single `FUN_00011564` draw — do not alias overlay `next()` for contact `0x61a`/`0x61e`.
- **[RECONSTRUCTED]** `local_46` factor is literal **`0x666`**, not field `movement_666` (Pacific Conflict.c:14183). Fixed in `FlightMath.compute_local_46` + `SimCore._apply_movement_smoothing`.
- **Validation:** `test_flight_math.gd` (`compute_local_46`); `test_sim_tick_ordering.gd` (`_test_fun_0000e792_local_46_literal_0666`).

### 2026-10-15 — Mission 1 JSON success / start_mode wiring

- **[MVP AUTHORING DECISION]** `success.complete_all_required_objectives` drives `MissionObjectivesM1.is_mission_success()` (true → required only; false → all steps including optional).
- **[MVP AUTHORING DECISION]** `start_mode` read by `MissionController`; only `"airborne"` supported; other values warn and fall back.
- **Validation:** `godot/tests/unit/test_mission_objectives_m1.gd` (both success policies). Godot + Python regression green.

### 2026-10-15 — Mission 1 sea/island MVP solids

- **[MVP AUTHORING DECISION]** `WorldBuilderMvp.impact_reason_at` + `island_aabb()` share sea (`y <= 0.5`) and island AABB volumes with the placeholder meshes; `SeaBody` / `IslandBody` `StaticBody3D` shapes created alongside meshes.
- **[MVP APPROXIMATION]** `PlayerAircraft` and `MissionController` use that helper for impact / failure; not a port of `FUN_00005df8` / `FUN_00006fb8` / original terrain.
- **Validation:** `godot/tests/unit/test_world_collision_mvp.gd`; runner 13 scripts. Godot 13/0; `tools/qa/test_regression.py` pass.

### 2026-04-08 — Entity tick ordering convergence (FUN_000044e8 / FUN_000044a4)

- **[RECONSTRUCTED]** `SimCore.tick()` now records **`last_tick_order`**: four passes in order **DAT_0001d4a4** → **DAT_0001b5a4** → **DAT_0001d0e4** → **DAT_0001cbe4** with **`param_2`** **0, 0, 1, 1**, then **`_call_06fb8()`**, matching Pacific Conflict.c:5105–5142.
- **[RECONSTRUCTED]** **`FUN_000044a4`** second argument surfaced as **`last_pass_param_2`** / **`last_pass_id`** during **`_run_pass`** (Pacific Conflict.c:5109–5139).
- **[INFERRED]** Optional **`tick_order_trace_enabled`**: player **`movement_66e`/`672`/`66a`** snapshots before tick, after pass 2 (array 2), and after full gated section; **`rng_state_after_tick`**.
- **[MVP APPROXIMATION]** Mission-1 **playable** loop remains **`PlayerAircraft` + `FlightModelMvp`**; **`SimCore`** is the **deterministic** bridge for parity tests and future wiring (see `docs/contracts/tick_FUN_000044e8_contract.md`).

**Validation:** `godot/tests/integration/test_sim_tick_ordering.gd`. Run: `godot --headless --path . -s godot/tests/run_all.gd`.

### 2026-04-08 — Flight model convergence pass (FUN_0000e792 motion slice)

- **[RECONSTRUCTED]** `FlightModelMvp` now drives pitch/roll/yaw from **FUN_0000e792-style** smoothed accumulators **`movement_66e`**, **`movement_672`**, **`movement_66a`** using `FlightMath.add_delta_smoothed_int` / `add_delta_smoothed_s16` (Pacific Conflict.c:14182–14242; see `docs/contracts/flight_FUN_0000e792_contract.md`).
- **[INFERRED]** Axis assignment **66e→pitch**, **672→roll**, **66a→yaw** for MVP integration; full `local_46`/`local_42` airspeed/template chain not ported.
- **[MVP APPROXIMATION]** Command targets are **scaled** `[-1,1]` × `pitch_max_int` / `roll_max_int` / `yaw_max_int` (default **8192** in `aircraft_mvp.json` → `movement_smoothing`).
- **[MVP TUNING]** `roll_auto_level_gain` still applied when roll stick neutral; rates/drag unchanged unless data changes.
- **[INFERRED]** Per-tick **`FlightModelMvp.last_flight_trace`** (and `PlayerAircraft.get_flight_trace()`) exposes accumulators, norms, telemetry for QA.

**Validation:** `godot/tests/unit/test_flight_model_mvp.gd` (straight, sustained turn, climb, descend, throttle sequence, smoothing). Run: `godot --headless --path . -s godot/tests/run_all.gd`.

### 2026-04-08 — Input convergence pass (FUN_0000740a → Godot)

- **[RECONSTRUCTED]** `PlayerInputMap` now mirrors **press/hold/release** traces and **throttle step** (`+`/`-` / keypad) as **edges** → `throttle_impulse`, with **hold** throttle still on `W`/`S` / Page Up/Down (`read_input_packet`, `compute_outputs`). See `docs/contracts/input_godot_contract.md`.
- **[RECONSTRUCTED]** `FlightModelMvp` applies `controls.throttle_impulse` as an instant delta on top of axis rate (original `DAT_00024cf6` path is not fully ported).
- **[MVP APPROXIMATION]** Single gate **`player_active`** instead of `DAT_0001d858` / overlay / mission `+0x98` branches; gated presses recorded in `trace.ignored`.
- **[INFERRED]** Per-tick trace: `pressed` / `held` / `released` / `normalized` / `gated` — inspect `PlayerInputMap.last_input_trace` during play or tests.
- **[UNKNOWN]** Full Mac `param_2` enum parity; only Godot action edges are logged.

**Validation:** `godot/tests/unit/test_player_input_frame.gd` (deterministic scenarios: hold pitch, tap roll, throttle steps, gate). Run: `godot --headless --path . -s godot/tests/run_all.gd` (from project root; requires Godot 4 on `PATH`).

### FUN_000044e8 — main sim update order

- **[RECONSTRUCTED]** `FUN_000044e8` (Pacific Conflict.c:5094) is the main sim tick: it checks `*(short *)(DAT_0001b5a0 + 0xac)`; if zero, calls `FUN_00005df8()`. [Pacific Conflict.c:5101-5102]
- **[RECONSTRUCTED]** If `0 < *(short *)(DAT_0001b5a0 + 0xa8) && *(short *)(DAT_0001b5a0 + 0xa8) < 6`, it then updates four entity arrays in order: (1) `DAT_0001d4a4` count `DAT_0001c1e0`, (2) `DAT_0001b5a4` count `DAT_0001b734`, (3) `DAT_0001d0e4` count `DAT_0001c1dc`, (4) `DAT_0001cbe4` count `DAT_0001c1d8`. [Pacific Conflict.c:5104-5138]
- **[RECONSTRUCTED]** Each array is iterated with `FUN_000044a4((char *)*puVar2, param_2)`: arrays 1–2 use `param_2 = 0`, arrays 3–4 use `param_2 = 1`. [Pacific Conflict.c:5109, 5117, 5126, 5135]
- **[RECONSTRUCTED]** After all four arrays, `FUN_00006fb8()` is called. [Pacific Conflict.c:5139]
- **[INFERRED]** This order is the single source of truth for our SimCore tick; reordering would break parity with the original.

### FUN_0000740a — input handler variables

- **[RECONSTRUCTED]** `FUN_0000740a(int param_1, int param_2)` (Pacific Conflict.c:7366) is an input/key handler. `param_1` and `param_2` are key code and action (e.g. 3 = press). [Pacific Conflict.c:7366, 7452-7466]
- **[RECONSTRUCTED]** It reads/writes: `DAT_0001d858` (game state, e.g. 1, 8, 9), `DAT_0001b738` (player entity pointer), `DAT_0001b870`, `DAT_0001b87c`, `DAT_0001b884`, `DAT_0001b86e`, `DAT_0001b86c`, `DAT_0001b888`, `DAT_00020b2a`, `DAT_0001b5a0` (mission base). [Pacific Conflict.c:7391-7393, 7396-7445]
- **[RECONSTRUCTED]** Mission block at `DAT_0001b5a0`: `*(short *)(DAT_0001b5a0 + 0x98)` and `*(short *)(DAT_0001b5a0 + 0x25e)`, `(DAT_0001b5a0 + 0x2b6)`, `(DAT_0001b5a0 + 0x2be)` (callbacks). [Pacific Conflict.c:7420-7425]
- **[RECONSTRUCTED]** Player-relative reads: `*DAT_0001b738 + 7`, `*DAT_0001b738 + 4`, `*DAT_0001b738 + 0x18/0x1c/0x20`, `(int)DAT_0001b738 + 0x22`, `(int)DAT_0001b738 + 0x63e`; and `(int)piVar14 + 0x19a`, `(int)piVar14 + 0x19e`, `(int)piVar14 + 0x62a`, `(int)piVar14 + 0x32`. [Pacific Conflict.c:7398-7401, 7433-7436, 7473-7477]
- **[INFERRED]** Replay/trace input packets should map to the same (param_1, param_2) semantics used here; exact key-to-param_1 mapping is [UNKNOWN] until we capture a key table.

### FUN_0000e792 — entity (param_1) offsets

- **[RECONSTRUCTED]** `FUN_0000e792(int *param_1)` (Pacific Conflict.c:14016) updates a single entity; `param_1` is the entity pointer (int* = 4-byte units). [Pacific Conflict.c:14016, 14058]
- **[RECONSTRUCTED]** Offsets used in FUN_0000e792 (byte offsets from entity base) are documented in STRUCTS.md “Entity (FUN_0000e792)” table; each row cites the line(s) where the offset is read or written. [Pacific Conflict.c:14060-14334 and surrounding]
- **[INFERRED]** Entity layout is shared by all four arrays; FUN_000044a4 calls FUN_0000e792 (or equivalent logic), so the same offsets apply to entity_array_1..4. [UNKNOWN] whether any array uses a different struct.
- **[RECONSTRUCTED]** A minimal ported slice now exists in Godot for lines 14103-14135: if `(flags_685 & 4) != 0`, `movement_662` is perturbed by `(FUN_00011564() & 0x7f) - 0x40` and clamped to `[-0x200, 0x200]`; if `(flags_685 & 8) != 0`, `movement_666` is perturbed the same way and clamped to `[-0x140, 0x140]`; if `(status_1a1 & 1) != 0`, then `movement_662 = 0` and `movement_666 = 0xff80`. [Pacific Conflict.c:14103-14135; `godot/hellcats/core/sim_core.gd`]
- **[RECONSTRUCTED]** A second minimal slice now exists in Godot for lines 14137-14152: `movement_669` is set to `1` only when the `(flags_685 & 0x40)`, `status_1a3`, `status_1a1 & 0x300`, and `67d/67e` gate allows it; otherwise it is cleared and the local accumulator becomes zero. If `flags_685` is negative, the signed byte at `0x19a` is halved toward zero before being added into `status_1a0`. [Pacific Conflict.c:14137-14152; `godot/hellcats/core/sim_core.gd`]
- **[RECONSTRUCTED]** The threshold/decrement logic at lines 14153-14163 is now ported in Godot using a minimal external auxiliary record: if `external_template.field_1e < status_1a0`, subtract that threshold from `status_1a0`, draw one RNG value, and decrement `67e` unless `(rng & 1) != 0` and `67d != 0`, in which case decrement `67d`. [Pacific Conflict.c:14153-14163; `godot/hellcats/core/entity_template.gd`; `godot/hellcats/core/sim_core.gd`]
- **[RECONSTRUCTED]** `param_1[1]` also has a proven short at `+0x40`, used earlier in entity setup and in `FUN_0000e792`; this stays documented as external pointed-to state, not folded into `EntityState`. [Pacific Conflict.c:4446, 13615, 13661, 13699, 14068, 14071]
- **[RECONSTRUCTED]** Additional external-template shorts are now documented and modeled at offsets `+0x3c`, `+0x3e`, `+0x42`, `+0x44`, `+0x46`, and `+0x48`, because the next adjacent `FUN_0000e792` math block references them directly. [Pacific Conflict.c:14173, 14177, 14298, 14302-14306, 14679, 14914, 15044]
- **[RECONSTRUCTED]** Godot now exposes a reusable helper for the `+0x40` rule from `FUN_0000e792`: if `direction_char_679 == '-'`, use `external_template.field_40` directly; otherwise halve it toward zero. [Pacific Conflict.c:14067-14074; `godot/hellcats/core/sim_core.gd`]
- **[RECONSTRUCTED]** The helper trio behind the next math block is now reconstructed in `godot/hellcats/core/flight_math.gd`: `FUN_0000e42a(uint)` uses the raw overlapping table at `DAT_0001b2c0`; `FUN_0000e468(int, short)` damps the second parameter only when the first is below `0x200`; `FUN_0000e570(short, int*)` scales `external_template.field_38` by a ratio derived from `param_1`. [Pacific Conflict.c:13796-13915]
- **[INFERRED]** `compute_local_34()` is now modeled as a pure helper using the already-proven `external_template.field_3c`, `field_3e`, and the output of `FUN_0000e570`, but it is not yet wired into the live tick because the surrounding block still depends on more helper-driven state (`0x66e`, `0x672`, `0x66a`) and ownership semantics.

### FUN_0000e792 — ownership branch (DAT_0001b738 / DAT_0001b888) and 0x66e / 0x672 / 0x66a

- **[RECONSTRUCTED]** The block at Pacific Conflict.c:14179–14244 runs **only when** `(param_1 == DAT_0001b738) || (param_1 == DAT_0001b888)`. No other entity receives the updates to offsets 0x66e, 0x672, or 0x66a in this block. [Pacific Conflict.c:14179]
- **[RECONSTRUCTED]** **DAT_0001b738** is the **player entity pointer**: set when the first qualifying entity is created (e.g. `FUN_0000dff0` at 13616–13617 assigns `DAT_0001b738 = puVar2`). It is read/written across the codebase as the single “player” plane. [Pacific Conflict.c:13616–13617, 4424, 5049, 7351–7358, 7392, 7446, 14179, 14334, etc.]
- **[RECONSTRUCTED]** **DAT_0001b888** is a **second entity pointer** (e.g. target or second player): set to 0 at 6101; set from `*(param_2 + 8)` in FUN_0000ff44 at 15122 when `DAT_0001d858` is 1, 8, or 7 and other conditions. [Pacific Conflict.c:6101, 7450, 7485–7486, 15117–15122]
- **[INFERRED]** The branch is “special” because **only the entity that is the current player or the current target** gets the **movement-smoothing accumulators** at 0x66e (int), 0x672 (short), and 0x66a (int) updated in this block. All other entities skip this block entirely. **[UNKNOWN]** High-level semantics (e.g. “pitch” vs “roll” vs “yaw”) of 0x66e/0x672/0x66a; only the formulas and conditions below are proven.

**Exact conditions under which 0x66e, 0x672, and 0x66a are updated**

- **[RECONSTRUCTED]** **Guard:** Updates occur **only if** `param_1 == DAT_0001b738` **or** `param_1 == DAT_0001b888`. [Pacific Conflict.c:14179]
- **[RECONSTRUCTED]** **0x66e (int):** `local_46` = `(int)(short)(0x5e50 / (short)(sVar15 + 0xa25 >> 5)) * sVar21 * 0x666 >> 5`. Delta = `local_46 - *(int *)((int)param_1 + 0x66e)`. If `|delta| < 8` (i.e. `(delta + 7*(delta<0)) >> 3 == 0`): add delta to 0x66e; else add `(delta + 7*(delta<0)) >> 3` to 0x66e. [Pacific Conflict.c:14180–14194]
- **[RECONSTRUCTED]** **0x672 (short):** If `*(char *)((int)param_1 + 0x669) == 0` **or** `(*(ushort *)(param_1 + 0x1a1) & 0x4300) != 0`, the effective source value is 0; else it is `(short)(local_26 >> 9)`. If `*(char *)((int)param_1 + 0x685) < 0`, that value is adjusted (round toward zero then `>> 1`). Delta = that value − `*(short *)((int)param_1 + 0x672)`. Same rule: add delta or `delta>>3` (with negative rounding). [Pacific Conflict.c:14196–14222]
- **[RECONSTRUCTED]** **0x66a (int):** `local_42 = (iVar20 << 0x11) / 0x1c20` where `iVar20 = *(int *)((int)param_1 + 0x62a) >> 2`. `iVar19` = current `*(int *)((int)param_1 + 0x66a)`. `iVar10 = local_42 - local_46`; then `iVar10 = -(iVar19 - (local_46 + (iVar10 >> 1)))`. Same add delta or `delta>>3`. [Pacific Conflict.c:14180, 14165–14167, 14223–14241]
- **[RECONSTRUCTED]** **0x669 clear:** Inside the same branch, if `(*(byte *)(param_1 + 0x1a1) & 0x40) != 0` **and** `*(int *)((int)param_1 + 0x66e) == 0`, then `*(byte *)((int)param_1 + 0x669) = 0`. [Pacific Conflict.c:14241–14243]

**Safe for live port now vs unresolved**

- **Safe to implement (evidence-backed):** (1) **Branch condition:** run the 0x66e/0x672/0x66a update block only when the entity pointer equals the “player” entity or the “target” entity (Godot must pass the same two designations from its sim state). (2) **Field writes:** the exact delta rules (add full delta when `|delta| < 8`, else add `delta>>3` with negative rounding) and the formulas for `local_46`, `local_42`, and the 0x672 source from `local_26` and the 0x669/0x1a1/0x685 gates. (3) **0x669 clear:** when in this branch and status_1a1 has bit 0x40 and 0x66e is zero, set 0x669 to 0.
- **Unresolved (do not guess):** (1) Semantic names for 0x66e, 0x672, 0x66a (e.g. which axis or control surface). (2) Whether DAT_0001b888 is always “target” or sometimes a second player; Godot can mirror “two designated entities” without ascribing meaning. (3) Any other code paths that read/write these offsets outside FUN_0000e792 (see STRUCTS.md for read sites).

## Doc sync: helper trio, ownership, next live-port

- **[RECONSTRUCTED]** The **helper trio** is reconstructed in `godot/hellcats/core/flight_math.gd`: FUN_0000e42a (raw table at DAT_0001b2c0), FUN_0000e468 (damp when first param &lt; 0x200), FUN_0000e570 (scale external_template.field_38 by ratio from param_1). [Pacific Conflict.c:13796–13915] **[INFERRED]** `compute_local_34()` is modeled from proven external_template fields but not yet wired into the tick.
- **[RECONSTRUCTED]** **Ownership branch status:** Only the entity matching **DAT_0001b738** (player) or **DAT_0001b888** (second designated entity) receives writes to 0x66e, 0x672, 0x66a in the block at 14179–14244. DAT_0001b738 is set at entity creation (e.g. FUN_0000dff0); DAT_0001b888 is set to 0 at 6101 and from FUN_0000ff44 when DAT_0001d858 is 1, 8, or 7. [Pacific Conflict.c:14179, 13616–13617, 6101, 15117–15122]
- **Exact next live-port boundary [RECONSTRUCTED]:** Godot Engineer may port the **movement-smoothing block** (14179–14244) into the per-entity tick: (1) run the 0x66e/0x672/0x66a update **only when** current entity pointer equals SimCore's designated player entity or designated target entity; (2) use the proven formulas and delta rules (add full delta when |delta|&lt;8, else add delta&gt;&gt;3 with negative rounding); (3) apply the 0x669 clear when in branch and (status_1a1 &amp; 0x40) and 0x66e==0. **[UNKNOWN] Blocked:** assigning semantic names to 0x66e/0x672/0x66a; defining DAT_0001b888 beyond "second designated entity"; porting any logic that depends on unverified code paths for these offsets.

## Changelog

| Date       | Topic | Change |
|------------|--------|--------|
| (today)    | FUN_000044e8, FUN_0000740a, FUN_0000e792 | Initial log entries from Pacific Conflict.c. |
| (today)    | FUN_0000e792 ownership branch | Documented DAT_0001b738/DAT_0001b888 branch, 0x66e/0x672/0x66a update conditions, safe vs unresolved for movement-smoothing port. |
| (today)    | Doc sync | Helper trio reconstructed; ownership branch status; exact next live-port boundary (ROADMAP, STRUCTS). |

### ID00 / loader chain

- **[RECONSTRUCTED]** `ID00.bin` begins with four big-endian u32 values: `0x00000598`, `0x0000225e`, `0x00000578`, `0x00000020`. [ResEdit/CODE/ID00.bin bytes `0x0000..0x000f`; verified with `xxd`]
- **[RECONSTRUCTED]** Starting at file offset `0x0012`, `ID00.bin` contains repeated byte patterns `3f 3c <seg_id> a9 f0`, which decode as `MOVE.W #seg_id,-(SP); _LoadSeg`. [ResEdit/CODE/ID00.bin; decoded by `tools/decode_id00_loadseg.py`]
- **[RECONSTRUCTED]** The Toolbox trap `A9F0` is `LoadSeg`. [Apple Toolbox trap table, `A9F0 LoadSeg`]
- **[RECONSTRUCTED]** `ID00.bin` contains 174 `_LoadSeg` entries grouped by CODE resource id in this order: `1` (10 entries), `4` (33), `3` (3), `6` (9), `8` (3), `9` (36), `2` (68), `5` (11), `7` (1). [Decoded from `ID00.bin` by `tools/decode_id00_loadseg.py`]
- **[INFERRED]** `ID00.bin` is acting as a segment loader/dispatch table for CODE resources rather than ordinary gameplay logic.
- **[RECONSTRUCTED]** Correlating the `ID00.bin` tail words against exported `FUN_0000xxxx` symbols in `ID01.c`-`ID09.c` shows strong near-matches in several segments: `ID05` matches 11/11 within `+4` or `+6`, `ID02` matches 65/68 within `+4`, `ID07` matches 1/1 within `+4`, and `ID06` matches 6/9 within `+4`. [Generated by `tools/correlate_id00_to_functions.py`]
- **[INFERRED]** The `ID00.bin` tail word often appears to point a few bytes before the decompiler-labeled function start, most commonly `+4`, and less often `+6`.
- **[INFERRED]** `ID00.bin` therefore likely references segment-local routine entry slots rather than arbitrary data offsets, at least for segments `ID02`, `ID05`, `ID06`, and `ID07`.
- **[RECONSTRUCTED]** The trailing u16 is the segment-local **stored routine offset** (first_instruction_offset − 4, or −6 when segment has 6-byte header). Bytes at tail in ID02: UNLK (4e 5e), RTS (4e 75), then LINK at tail+4; in ID05 first routine: header at 0, LINK at 6 ⇒ tail+6. See [LOADER_CHAIN.md](LOADER_CHAIN.md) §4.2.
- **[RECONSTRUCTED]** Entrypoint handoff: JSR offset(A5) → jump table entry (MOVE.W #seg,-(SP); LoadSeg; .word tail) → LoadSeg → Segment Manager sets routine = base+(tail+4 or tail+6), JMP to routine (LINK). Ibid. §5.

## Loader-chain sync (docs vs artifact)

- **[RECONSTRUCTED]** Per [LOADER_CHAIN.md](LOADER_CHAIN.md) §10, **six** loader targets are proven by byte-level evidence (UNLK/RTS/LINK at tail or 6-byte prologue + RTS/LINK): ID02×1, ID05×1, ID06×3, ID07×1.
- **[RECONSTRUCTED]** `tools/proven_loader_targets.json` currently lists **two** targets (ID02, ID05). The four additional targets (ID06 at 0x0e10, 0x096e, 0x09d8; ID07 at 0x0190) are proven in LOADER_CHAIN but not yet in that JSON; the artifact is updated only when the maintainer re-runs the proof (LOADER_CHAIN §8).
- **[INFERRED]** Godot consumes whatever targets are present in the JSON; the headless test proves SimCore with the two targets currently in the artifact.
- **[UNKNOWN]** Still blocked by address mapping: runtime relocation, jump-table patching, and actual segment load execution are out of scope until the address model is proven further (LOADER_CHAIN §9).
- **Next milestone:** Extend `proven_loader_targets.json` to include the four remaining proven targets (ID06×3, ID07×1), or document the decision to keep the artifact minimal; then proceed to trace capture for parity validation.

### Mission 01 MVP extraction brief (flight school / pilot training)

#### Useful now

- **[RECONSTRUCTED]** `DAT_0001b738` is the player entity pointer and is used as the primary flight actor in the input path (`FUN_0000740a`) and camera/world-anchor updates (`DAT_0001d838/d834/d830` copied from player `+0x18/+0x1c/+0x20`). [Pacific Conflict.c:7392, 7437-7439, 7702-7704]
- **[RECONSTRUCTED]** Mission runtime gating needed for a deterministic training loop is already proven: mission tick uses `*(short *)(DAT_0001b5a0 + 0xac)` and `*(short *)(DAT_0001b5a0 + 0xa8)`; only when `0 < +0xa8 < 6` are all four entity arrays updated. [Pacific Conflict.c:5102-5138]
- **[RECONSTRUCTED]** Input events are key/action pairs (`FUN_0000740a(int param_1, int param_2)`), with explicit press checks (`param_2 == 3`) and release/other-action handling paths. [Pacific Conflict.c:7368, 7455, 7462-7469]
- **[RECONSTRUCTED]** Training-relevant mode/state transitions are keyed through `DAT_0001d858` and values including 1, 5, 7, 8, 9; examples: key `'c'`/`'C'` sets state 5, key `'e'`/`'E'` can enter state 7 when secondary pointer exists, key `'v'`/`'V'` returns to state 1 and recenters anchor vars. [Pacific Conflict.c:7675-7704]
- **[RECONSTRUCTED]** Proven per-frame player-control accumulators exist (`0x66e`, `0x672`, `0x66a`) and are updated only for designated player/secondary entities (`DAT_0001b738` / `DAT_0001b888`) with deterministic smoothing deltas. This is sufficient for an MVP-stable "aircraft feel" seam without full semantic naming. [Pacific Conflict.c:14179-14244]
- **[INFERRED]** HUD-minimum telemetry for MVP can safely use already-proven player fields (`+0x18/+0x1c/+0x20` world position and heading/attitude-related shorts used across input/update paths) even before exact cockpit/HUD parity is solved.

#### Ignore for MVP

- **[INFERRED]** Loader-chain deep work (`ID00` dispatch/tail-offset proof, segment entry correlation) does not unblock a playable single training slice.
- **[INFERRED]** Full DAT block reconstruction for `DAT_0001b5a0` beyond `+0xa8/+0xac/+0x98/+0x25e/+0x2b6/+0x2be` is unnecessary for Mission 01 MVP.
- **[INFERRED]** Full semantic labeling of advanced entity offsets (all `0x61a..0x685` behaviors, full weapon/system modes) is not required for initial flight school progression.
- **[INFERRED]** Exact original non-training states/campaign transitions implied by the broader `DAT_0001d858` FSM can be deferred.

#### Unknown but not blocking

- **[UNKNOWN]** Exact canonical meaning of each `DAT_0001d858` value (1..9) as player-facing named modes.
- **[UNKNOWN]** Exact original keycode-to-keyboard-layout mapping for all `param_1` values; we have direct codepoint evidence for many keys, but not a full authoritative table per platform layout.
- **[UNKNOWN]** Exact historical training mission script/scoring thresholds/objective timing text.
- **[UNKNOWN]** Exact semantic names for movement accumulators `0x66e`, `0x672`, `0x66a` (axis/control-surface identity).
