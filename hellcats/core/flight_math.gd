class_name FlightMath
extends RefCounted
## Clean-room helper math reconstructed from Pacific Conflict.c.

const E42A_TABLE := [
	0x0038C460,
	0x00504AE0,
	0x00718EEF,
	0x00A09E00,
	0x00E3369F,
	0x002D002D,
	0x001E000F,
	0x00070002,
	0x000001A5,
]

static func _to_s16(value: int) -> int:
	value &= 0xFFFF
	return value - 0x1_0000 if (value & 0x8000) != 0 else value


static func _to_s32(value: int) -> int:
	value &= 0xFFFFFFFF
	return value - 0x1_0000_0000 if (value & 0x8000_0000) != 0 else value


static func _to_s8(value: int) -> int:
	value &= 0xFF
	return value - 0x100 if (value & 0x80) != 0 else value

static func _half_toward_zero(value: int) -> int:
	if value < 0:
		value += 1
	return value >> 1

static func fun_0000e42a(param_1: int) -> int:
	var index: int = (param_1 >> 16) & 0xFFFF
	if index > 7:
		index = 7
	var current: int = E42A_TABLE[index]
	var nxt: int = E42A_TABLE[index + 1]
	var fraction: int = param_1 & 0xFFFF
	var interpolated: int = _to_s16(current) + ((fraction * (nxt - current)) >> 16)
	return _to_s16(interpolated)

static func fun_0000e468(param_1: int, param_2: int) -> int:
	if param_1 < 0x200:
		var scaled: int = -(param_1 - 0x200) * param_2
		if scaled < 0:
			scaled += 0xFFF
		param_2 -= scaled >> 12
	return param_2

static func fun_0000e570(template_field_38: int, param_1: int) -> int:
	var denominator: int = (param_1 + 0x105) >> 3
	if denominator <= 0:
		return 0
	var ratio: int = int(0x551A / denominator)
	return (template_field_38 * ratio) >> 8

static func compute_template_field_40_adjustment(template_field_40: int, direction_char_679: int) -> int:
	if direction_char_679 == 0x2D:
		return template_field_40
	return _half_toward_zero(template_field_40)

static func compute_local_34(template_field_3c: int, template_field_3e: int, local_26: int, s_var21: int, i_var20: int) -> int:
	if s_var21 == 0:
		return 0
	if template_field_3e < i_var20:
		return ((local_26 * s_var21) / 9) / i_var20
	return (s_var21 * template_field_3c) / 9

## [RECONSTRUCTED] Pacific Conflict.c:14183 —
## local_46 = (int)(short)(0x5e50 / (short)((sVar15 + 0xa25) >> 5)) * sVar21 * 0x666 >> 5
## The 0x666 factor is a literal constant, not entity offset 0x666.
static func compute_local_46(s_var15: int, s_var21: int) -> int:
	var denom: int = (s_var15 + 0xa25) >> 5
	if denom == 0:
		return 0
	var div_val: int = int(0x5e50 / denom)
	div_val = _to_s16(div_val)
	return (div_val * s_var21 * 0x666) >> 5

## [RECONSTRUCTED] Target sVar21 for movement_626 (Pacific Conflict.c:14248–14264, 14293–14294).
static func movement_626_target_s21(movement_662: int, i_var20: int, tpl_34: int, tpl_36: int) -> int:
	var m662: int = _to_s16(movement_662)
	var t34: int = _to_s16(tpl_34)
	var t36: int = _to_s16(tpl_36)
	if i_var20 >= 0xCA8:
		return m662
	if t36 < i_var20:
		var prod: int = m662 * (t34 - 0x200)
		if prod < 0:
			prod += 0x1FF
		var numer: int = (prod >> 9) * (0xCA8 - i_var20)
		var denom: int = 0xCA8 - t36
		if denom == 0:
			return m662
		return _to_s16(m662 + int(numer / denom))
	var scaled: int = m662 * t34
	if scaled < 0:
		scaled += 0x1FF
	return _to_s16(scaled >> 9)

## [RECONSTRUCTED] Gain scale iVar19 before × err (Pacific Conflict.c:14265–14273, 14295).
static func movement_626_scale(i_var20: int) -> int:
	if i_var20 >= 0xCA8:
		return 0x2A
	var prod: int = i_var20 * 0x2A
	if prod < 0:
		prod += 0xFFF
	prod = (prod >> 12) * 0x143A
	if prod < 0:
		prod += 0xFFF
	return prod >> 12

## [RECONSTRUCTED] FUN_00002e08 — abs of signed value (used by e4a4 / throttle).
static func fun_00002e08(value: int) -> int:
	return value if value >= 0 else -value

## [RECONSTRUCTED] FUN_0000e372 — binary-search floor sqrt (Pacific Conflict.c:13734–13758).
static func fun_0000e372(param_1: int) -> int:
	var lo: int = 0
	var hi: int = 0x7FFF
	while lo < hi - 1:
		var mid_sum: int = hi + lo
		if mid_sum < 0:
			mid_sum += 1
		var mid: int = mid_sum >> 1
		if mid * mid <= param_1:
			lo = mid
		else:
			hi = mid
	return lo

## [RECONSTRUCTED] Grounded field_0b type switch (14507–14596).
## Sets bVar6, optional clear/set uVar13 / DAT_0001b856 / DAT_0001b854,
## and 0x10 status OR / early-return.
## Proven FUN_00011564: 0x10 soft yaw; '@' player b854 when b856!=0 (no draw).
## [INFERRED] '@' FUN_00011544-callsite×2 → field_18c / uVar13; optional 11564
## for b854 when b856==0 (see RngOverlay11564.fun_00011544_callsite).
static func apply_grounded_field_0b_switch(
	field_0b: int,
	status_1a1: int,
	direction_char_679: int,
	movement_626: int,
	is_player: bool,
	dat_0001b856: int,
	u_var13_in: int = 0,
	speed_i_var20: int = 0,
	rng_11564_draws: Array = []
) -> Dictionary:
	var c: int = field_0b & 0xFF
	var status: int = status_1a1 & 0xFFFF
	var b_var6: bool = false
	var clear_u_var13: bool = false
	var clear_b856: bool = false
	var early_return: bool = false
	var set_b854: bool = false
	var u_var13: int = u_var13_in & 0x3FFF
	var wrote_u_var13: bool = false
	var field_18c_delta: int = 0
	var wrote_field_18c: bool = false
	var rng_i: int = 0
	var i_var25: int = _to_s16(speed_i_var20) >> 2
	var speed: int = _to_s16(speed_i_var20)
	var abs_679: int = fun_00002e08(_to_s8(direction_char_679))
	if c == 0x40:  # '@'
		if abs_679 != 0x2D:
			b_var6 = true
		## [INFERRED] two FUN_00011544 callsites ≡ two 11564 draws (see RngOverlay11564).
		var draw_a: int = 0
		var draw_b: int = 0
		if rng_i < rng_11564_draws.size():
			draw_a = int(rng_11564_draws[rng_i]) & 0xFFFF
			rng_i += 1
		if rng_i < rng_11564_draws.size():
			draw_b = int(rng_11564_draws[rng_i]) & 0xFFFF
			rng_i += 1
		var u_var16: int = draw_a & 0x7F
		u_var13 = (draw_b & 0x7F) - 0x40
		if i_var25 < 0x438:
			u_var13 = int((i_var25 * _to_s16(u_var13)) / 0x438)
			u_var16 = int((i_var25 * _to_s16(u_var16)) / 0x438)
		u_var13 &= 0x3FFF
		wrote_u_var13 = true
		field_18c_delta = _to_s16(u_var16)
		wrote_field_18c = true
		if is_player:
			if (dat_0001b856 & 0xFF) != 0:
				set_b854 = true
				clear_b856 = true
			elif speed >= 0x2D1:
				var mask: int = 0x1F if speed < 0x10E1 else 0x0F
				var draw_c: int = 0
				if rng_i < rng_11564_draws.size():
					draw_c = int(rng_11564_draws[rng_i]) & 0xFFFF
					rng_i += 1
				if (draw_c & mask) == 0:
					set_b854 = true
	elif c < 0x41:  # 'A'
		if c == 0x20:  # ' '
			if (status & 8) == 0:
				b_var6 = true
		elif c < 0x21:  # '!'
			if c == 0x10:
				status |= 0x1000
				var e40c_626: int = fun_0000e40c(movement_626)
				if _to_s8(direction_char_679) != 0 or e40c_626 < -0x80:
					status |= 0x400
					early_return = true
				else:
					var draw: int = 0
					if rng_i < rng_11564_draws.size():
						draw = int(rng_11564_draws[rng_i]) & 0xFFFF
						rng_i += 1
					var s_var17: int = fun_0000e40c(u_var13_in)
					if s_var17 < 0:
						s_var17 += 1
					u_var13 = ((draw & 0x3F) + (s_var17 >> 1) - 0x20)
					if i_var25 < 0x438:
						u_var13 = int((i_var25 * _to_s16(u_var13)) / 0x438)
					u_var13 &= 0x3FFF
					wrote_u_var13 = true
					if is_player:
						clear_b856 = true
		elif c == 0x30:  # '0'
			if abs_679 != 0x2D:
				b_var6 = true
			clear_u_var13 = true
			u_var13 = 0
			wrote_u_var13 = true
	elif c == 0x60:  # '`'
		if abs_679 != 0x2D:
			b_var6 = true
		clear_u_var13 = true
		u_var13 = 0
		wrote_u_var13 = true
	elif c < 0x61:  # 'a'
		if c == 0x50:  # 'P'
			if abs_679 != 0x2D:
				b_var6 = true
			if is_player and (dat_0001b856 & 0xFF) != 0:
				clear_b856 = true
			clear_u_var13 = true
			u_var13 = 0
			wrote_u_var13 = true
	elif c == 0x70:  # 'p'
		if abs_679 != 0x2D:
			b_var6 = true
		clear_u_var13 = true
		u_var13 = 0
		wrote_u_var13 = true
	return {
		"b_var6": b_var6,
		"status_1a1": status & 0xFFFF,
		"clear_u_var13": clear_u_var13,
		"clear_dat_0001b856": clear_b856,
		"set_dat_0001b854": set_b854,
		"early_return": early_return,
		"u_var13": u_var13 & 0x3FFF,
		"wrote_u_var13": wrote_u_var13,
		"field_18c_delta": field_18c_delta,
		"wrote_field_18c": wrote_field_18c,
		"rng_draws_used": rng_i,
	}


## [RECONSTRUCTED] Grounded post-commit (14497–14603): e372(e²+z²), pvc,
## field_0b switch, local_28 clamp, prestall when !bVar6.
static func apply_grounded_speed_recommit(
	local_e: int,
	local_6: int,
	local_28_in: int,
	pos_2e: int,
	i_var23: int,
	surface_1c: int,
	field_63f: int,
	field_190: int,
	field_0b: int = 0,
	status_1a1: int = 0,
	direction_char_679: int = 0,
	movement_626: int = 0,
	is_player: bool = false,
	dat_0001b856: int = 0,
	u_var13_in: int = 0,
	rng_11564_draws: Array = []
) -> Dictionary:
	var e: int = _to_s16(local_e)
	var z: int = _to_s16(local_6)
	var speed_sq: int = e * e + z * z
	var speed: int = _to_s16(fun_0000e372(speed_sq))
	var sw: Dictionary = apply_grounded_field_0b_switch(
		field_0b,
		status_1a1,
		direction_char_679,
		movement_626,
		is_player,
		dat_0001b856,
		u_var13_in,
		speed,
		rng_11564_draws
	)
	var early: bool = bool(sw.get("early_return", false))
	var local_28: int = _to_s16(local_28_in)
	var set_190: bool = false
	if not early:
		if local_28 > 0x2000:
			local_28 = 0
		var b6: bool = bool(sw.get("b_var6", false))
		set_190 = (not b6) and (field_63f & 0xFF) != 0 and (field_190 & 0xFF) == 0
	return {
		"movement_62a": speed,
		"speed_sq": speed_sq,
		"position_velocity_c": i_var23 - surface_1c,
		"need_13452": pos_2e == 0,
		"local_28": local_28 & 0xFFFF,
		"set_field_190_prestall": set_190,
		"b_var6": bool(sw.get("b_var6", false)),
		"status_1a1": int(sw.get("status_1a1", status_1a1)) & 0xFFFF,
		"clear_u_var13": bool(sw.get("clear_u_var13", false)),
		"clear_dat_0001b856": bool(sw.get("clear_dat_0001b856", false)),
		"set_dat_0001b854": bool(sw.get("set_dat_0001b854", false)),
		"early_return": early,
		"u_var13": int(sw.get("u_var13", u_var13_in)) & 0x3FFF,
		"wrote_u_var13": bool(sw.get("wrote_u_var13", false)),
		"field_18c_delta": int(sw.get("field_18c_delta", 0)),
		"wrote_field_18c": bool(sw.get("wrote_field_18c", false)),
		"rng_draws_used": int(sw.get("rng_draws_used", 0)),
	}

## [RECONSTRUCTED] Call-site FUN_00001d56 ≡ FUN_00001d76 (sin). Capstone: LEA $1d56 is a
## false mid-label 0x20 before real sin @0x1D76 (same pattern as $2DE8→$2E08 abs).
## Arg at @0xF4A0: local_28 / pos_20 angle on stack; D0 = sin-table lerp.
static func fun_00001d56_callsite(angle: int) -> int:
	return fun_00001d76(angle)


## [RECONSTRUCTED] Call-site FUN_00001db8 ≡ FUN_00001dd8 (cos); LEA $1db8 is 0x20 before @0x1DD8.
static func fun_00001db8_callsite(angle: int) -> int:
	return fun_00001dd8(angle)


## [RECONSTRUCTED] LAB_0000f47c yaw epilogue (14606–14629; Capstone @0xF47C–0xF4DA).
## Clears field_63f; writes pos_20/attitude_22; blends field_24 from uVar13 +
## e40c(local_2a−attitude_22)*sin(local_28)>>12; writes movement_62a; player ring
## DAT_0001bc8c[0x78] / bc80 / bc84 via second sin(pos_20) (=local_28 after commit).
static func apply_lab_0000f47c(
	local_28: int,
	local_2a: int,
	attitude_22_before: int,
	u_var13: int,
	i_var20_speed: int,
	is_player: bool,
	dat_0001bc80: int,
	dat_0001bc84: int,
	ring_slot_at_next: int
) -> Dictionary:
	var scale: int = _to_s16(fun_00001d56_callsite(local_28))
	var i_var25: int = fun_0000e40c(_to_s16(local_2a) - _to_s16(attitude_22_before))
	var field_24: int = (
		(u_var13 & 0x3FFF) + _to_s16((i_var25 * scale) >> 12)
	) & 0x3FFF
	var ring_val: int = 0
	var next_bc80: int = dat_0001bc80
	var next_bc84: int = dat_0001bc84 & 0xFFFF
	var wrote_ring: bool = false
	if is_player:
		## Second 01d56-callsite uses pos_20 after commit (== local_28).
		var scale_ring: int = _to_s16(fun_00001d56_callsite(local_28))
		## (speed * ((scale<<13)>>12)) / 0x1ce ; clamp ±0x1d80
		var scaled: int = (scale_ring << 13) >> 12
		ring_val = int((_to_s16(i_var20_speed) * scaled) / 0x1CE)
		if ring_val > 0x1D80:
			ring_val = 0x1D80
		elif ring_val < -0x1D80:
			ring_val = -0x1D80
		var idx: int = next_bc84
		if idx < 0 or idx >= 0x78:
			idx = 0
		var next_idx: int = idx + 1
		if next_idx == 0x78:
			next_idx = 0
		next_bc80 = (dat_0001bc80 + ring_val) - _to_s16(ring_slot_at_next)
		next_bc84 = next_idx
		wrote_ring = true
	return {
		"clear_field_63f": true,
		"pos_20": local_28 & 0xFFFF,
		"attitude_22": local_2a & 0xFFFF,
		"field_24": field_24,
		"movement_62a": _to_s16(i_var20_speed),
		"yaw_delta_e40c": i_var25,
		"scale_01d56": scale,
		"ring_value": ring_val,
		"dat_0001bc80": next_bc80,
		"dat_0001bc84": next_bc84 & 0xFFFF,
		"wrote_ring": wrote_ring,
		"ring_write_index": (dat_0001bc84 & 0xFFFF) if wrote_ring else -1,
	}


## [RECONSTRUCTED] Post-LAB_0000f47c char epilogue (14631–14647).
## 67b: ++ when (0 < c < 0x0f) or c < 0.
## 679: if c < 1 or c > ',' (0x2c) or (flags_685&0x20): only when c < 0 → ++,
##      field_67a|=2, status|=0x2000; else (in 1..0x2c and flag clear) → ++,
##      field_67a|=2, status&=~0x2000.
static func apply_e792_char_epilogue(
	field_67b: int,
	direction_char_679: int,
	field_67a: int,
	flags_685: int,
	status_1a1: int
) -> Dictionary:
	var c67b: int = _to_s8(field_67b)
	var c679: int = _to_s8(direction_char_679)
	var f67a: int = field_67a & 0xFF
	var status: int = status_1a1 & 0xFFFF
	var bumped_67b: bool = false
	var bumped_679: bool = false
	if (c67b > 0 and c67b < 0x0F) or c67b < 0:
		c67b = _to_s8(c67b + 1)
		bumped_67b = true
	if c679 < 1 or c679 > 0x2C or (flags_685 & 0x20) != 0:
		if c679 < 0:
			c679 = _to_s8(c679 + 1)
			f67a = (f67a | 2) & 0xFF
			status = (status | 0x2000) & 0xFFFF
			bumped_679 = true
	else:
		c679 = _to_s8(c679 + 1)
		f67a = (f67a | 2) & 0xFF
		status = (status & 0xDFFF) & 0xFFFF
		bumped_679 = true
	return {
		"field_67b": c67b & 0xFF,
		"direction_char_679": c679 & 0xFF,
		"field_67a": f67a,
		"status_1a1": status,
		"bumped_67b": bumped_67b,
		"bumped_679": bumped_679,
	}


## [RECONSTRUCTED] flags_685&2 ammo-decrement tail (14721–14734).
## RNG draws are call-site FUN_00011544 ≡ [INFERRED] one 11564 each.
## if (draw0&0x3f)==0: second draw; if (draw1&1)==0 or 67d==0: 67e-- if nonzero;
## else 67d--.
static func apply_e792_flags685_bit2_tail(
	flags_685: int,
	weapon_count_67d: int,
	weapon_count_67e: int,
	rng_draws: Array = []
) -> Dictionary:
	var c67d: int = _to_s8(weapon_count_67d)
	var c67e: int = _to_s8(weapon_count_67e)
	var used: int = 0
	var decremented_67d: bool = false
	var decremented_67e: bool = false
	if (flags_685 & 2) != 0:
		var d0: int = int(rng_draws[0]) & 0xFFFF if rng_draws.size() > 0 else 0
		used = 1 if rng_draws.size() > 0 else 0
		if (d0 & 0x3F) == 0:
			var d1: int = int(rng_draws[1]) & 0xFFFF if rng_draws.size() > 1 else 0
			used = 2 if rng_draws.size() > 1 else used
			if (d1 & 1) == 0 or c67d == 0:
				if c67e != 0:
					c67e = _to_s8(c67e - 1)
					decremented_67e = true
			else:
				c67d = _to_s8(c67d - 1)
				decremented_67d = true
	return {
		"weapon_count_67d": c67d & 0xFF,
		"weapon_count_67e": c67e & 0xFF,
		"active": (flags_685 & 2) != 0,
		"decremented_67d": decremented_67d,
		"decremented_67e": decremented_67e,
		"rng_draws_used": used,
	}


## [RECONSTRUCTED] e792 bVar6 cleanup epilogue (14736–14748).
## When bVar6: clamp/clear status_1a2; status=(status&0x8000)|0x900;
## state_32=0xe772; clear movement_61a/61e.
static func apply_e792_bvar6_cleanup(
	b_var6: bool,
	status_1a1: int,
	status_1a2: int
) -> Dictionary:
	if not b_var6:
		return {
			"applied": false,
			"status_1a1": status_1a1 & 0xFFFF,
			"status_1a2": status_1a2 & 0xFFFF,
			"state_32": 0,
			"clear_61a_61e": false,
		}
	var s1a2: int = _to_s16(status_1a2)
	var status: int = status_1a1 & 0xFFFF
	if (status & 1) == 0:
		s1a2 = 0
	elif s1a2 > 0x16:
		s1a2 = 0x16
	status = (status & 0x8000) | 0x900
	return {
		"applied": true,
		"status_1a1": status & 0xFFFF,
		"status_1a2": s1a2 & 0xFFFF,
		"state_32": 0xE772,
		"clear_61a_61e": true,
	}


## [RECONSTRUCTED] FUN_00005116 free-slot scan (5705–5725).
## slot_obj_ptrs[i] = *(table + i*0x18 + 0x14); first zero wins; size means full (grow).
static func find_05116_free_slot_index(slot_obj_ptrs: Array) -> int:
	var n: int = slot_obj_ptrs.size()
	for i in range(n):
		if int(slot_obj_ptrs[i]) == 0:
			return i
	return n


## [RECONSTRUCTED] FUN_00005116 grow request size (5727): (count+10)*0x18 bytes.
static func grow_05116_request_bytes(slot_count: int) -> int:
	return (slot_count + 10) * 0x18


## [RECONSTRUCTED] FUN_00001ba8 grow-by-10 plan for 05116 pool (2252–2271, 5726–5731).
## Flat mem model: always "grow" to new_count=old+10; copy old_count slots; new slots zero.
## [INFERRED] heap header capacity / 01b84/019d0 omitted — logical table only.
static func apply_01ba8_05116_grow(old_slot_count: int) -> Dictionary:
	var old_n: int = maxi(0, old_slot_count)
	return {
		"old_count": old_n,
		"new_count": old_n + 10,
		"request_bytes": grow_05116_request_bytes(old_n),
		"copy_slots": old_n,
		"first_new_index": old_n,
	}


## [RECONSTRUCTED] FUN_00001ba8 current block capacity (2259–2263; Capstone @0x1BB4–0x1BD0).
## If *(payload-4)==0xFF: capacity = (*(payload-8) - 1) * 8; else (1 << *(payload-4)) - 4.
static func apply_01ba8_capacity(header_byte_m4: int, large_words_m8: int) -> Dictionary:
	var hb: int = int(header_byte_m4) & 0xFF
	var large: bool = hb == 0xFF
	var cap: int
	if large:
		cap = (int(large_words_m8) - 1) * 8
	else:
		var shift: int = hb & 0x3F
		cap = (1 << shift) - 4
	return {
		"large": large,
		"capacity": cap & 0xFFFFFFFF,
		"header_byte": hb,
	}


## [RECONSTRUCTED] FUN_00001ba8 grow predicate (2264; Capstone @0x1BD2–0x1BD8).
## need_grow iff capacity < request; else return old ptr unchanged.
static func apply_01ba8_need_grow(capacity: int, request: int) -> Dictionary:
	var need: bool = int(capacity) < int(request)
	return {
		"need_grow": need,
		"return_old": not need,
		"capacity": int(capacity) & 0xFFFFFFFF,
		"request": int(request) & 0xFFFFFFFF,
	}


## [RECONSTRUCTED] 04958 → 01ba8 size arg (5466): (int)sVar9 << 1.
static func apply_04958_01ba8_request(pair_count: int) -> int:
	return (_to_s16(pair_count) << 1) & 0xFFFFFFFF


## [RECONSTRUCTED] FUN_00001ba8 grow-only plan (2252–2270).
## capacity from header; if capacity < request → alloc+copy+free (caller); else keep.
static func apply_01ba8_realloc_plan(
	header_byte_m4: int, large_words_m8: int, request: int
) -> Dictionary:
	var cap: Dictionary = apply_01ba8_capacity(header_byte_m4, large_words_m8)
	var capacity: int = int(cap.get("capacity", 0))
	var ng: Dictionary = apply_01ba8_need_grow(capacity, request)
	return {
		"large": bool(cap.get("large", false)),
		"capacity": capacity,
		"request": int(request) & 0xFFFFFFFF,
		"need_grow": bool(ng.get("need_grow", false)),
		"keep_old": bool(ng.get("return_old", false)),
		"copy_nbytes": capacity,
	}


## [RECONSTRUCTED] FUN_00001c04 vertex buffer copy (Capstone @0x1C04–0x1C5A; decomp ~2289).
## count = *(s16*)(obj+0x36) + *(s16*)(obj+0x3a); if count<=0 skip.
## Copy count triples (0xC bytes each) from *(obj+0x44) → *(obj+0x4c).
static func apply_01c04_plan(field_36: int, field_3a: int, ptr_44: int, ptr_4c: int) -> Dictionary:
	var c36: int = _to_s16(field_36)
	var c3a: int = _to_s16(field_3a)
	var count: int = c36 + c3a
	var skip: bool = count <= 0
	var nbytes: int = 0 if skip else count * 0xC
	return {
		"ok": true,
		"count": count,
		"skip": skip,
		"nbytes": nbytes,
		"src_ptr": int(ptr_44) & 0xFFFFFFFF,
		"dst_ptr": int(ptr_4c) & 0xFFFFFFFF,
		"stride": 0xC,
	}


## [RECONSTRUCTED] FUN_00001be4 = mid-entry of FUN_00001ba8 @ $1BE4 (Capstone @0x1BE4–0x1C00).
## After 01b84 alloc: 1a63e(old,new,old_cap); 019d0(old); return new.
## 016e2 LEA/JSR $1BE4 (not $1BA8). Register ABI: A2=old, D2=new, D3=nbytes.
static func apply_01be4_tail(old_ptr: int, new_ptr: int, nbytes: int) -> Dictionary:
	return {
		"ok": int(old_ptr) != 0 and int(new_ptr) != 0,
		"entry": "1be4",
		"is_01ba8_mid_entry": true,
		"old_ptr": int(old_ptr) & 0xFFFFFFFF,
		"new_ptr": int(new_ptr) & 0xFFFFFFFF,
		"nbytes": int(nbytes) & 0xFFFFFFFF,
		"call_1a63e": true,
		"call_019d0": true,
		"result_ptr": int(new_ptr) & 0xFFFFFFFF,
	}


## [RECONSTRUCTED] FUN_0001a63e forward non-overlap copy (23890+; Capstone @0x1A63E).
## Copies nbytes from src→dst as packed big-endian bytes via u32 words when aligned.
static func fun_0001a63e_copy_bytes(dst_words: Array, src_words: Array, nbytes: int) -> Dictionary:
	var n: int = maxi(0, int(nbytes))
	var nwords: int = (n + 3) >> 2
	var dst: Array = dst_words.duplicate()
	while dst.size() < nwords:
		dst.append(0)
	for i in range(nwords):
		var src_v: int = int(src_words[i]) if i < src_words.size() else 0
		if i * 4 + 4 <= n:
			dst[i] = src_v & 0xFFFFFFFF
		else:
			## partial last word — keep dst high bytes, copy low (n % 4) bytes from src
			var keep: int = 4 - (n & 3)
			var mask: int = (0xFFFFFFFF << (keep * 8)) & 0xFFFFFFFF
			dst[i] = (int(dst[i]) & mask) | (src_v & (~mask & 0xFFFFFFFF))
	return {"ok": true, "nbytes": n, "words": dst, "nwords": nwords}


## [RECONSTRUCTED] FUN_00005116 slot field layout before FUN_000046da (5732–5739).
## +0=param_8, +2=param_5, +4=param_6, +6=param_7, +8/c/10 = xyz.
static func apply_05116_slot_fill(
	param_2_x: int,
	param_3_y: int,
	param_4_z: int,
	param_5: int,
	param_6: int,
	param_7: int,
	param_8: int
) -> Dictionary:
	return {
		"slot_u16_0": param_8 & 0xFFFF,
		"slot_u16_2": param_5 & 0xFFFF,
		"slot_u16_4": param_6 & 0xFFFF,
		"slot_u16_6": param_7 & 0xFFFF,
		"slot_x": param_2_x & 0xFFFFFFFF,
		"slot_y": param_3_y & 0xFFFFFFFF,
		"slot_z": param_4_z & 0xFFFFFFFF,
	}


## [RECONSTRUCTED] FUN_00005116 success gate after 046da (5741–5745).
## world_obj from slot+0x14; if *(world+0x44)==0 → fail (caller runs 051ec).
static func apply_05116_world_gate(world_obj: int, field_44: int) -> Dictionary:
	var ok: bool = world_obj != 0 and field_44 != 0
	return {
		"success": ok,
		"world_obj": world_obj if ok else 0,
		"need_051ec": world_obj != 0 and field_44 == 0,
	}


## [RECONSTRUCTED] FUN_000045ba / alloc_object_from_desc field copy (5149–5190).
## Kind 2 → size 0x52; kind 3 → size 0x34. Other kinds: ok=false (Ghidra fall-through).
## [DEFERRED] real FUN_00001b6c heap; caller supplies cleared object storage.
## desc: Dictionary of absolute byte offsets → values (u8/u16/u32 as used below).
static func apply_045ba_from_desc(desc: Dictionary, dat_0001b838: int = 0) -> Dictionary:
	var kind: int = int(desc.get(0, 0)) & 0xFF
	var out: Dictionary = {
		"ok": false,
		"kind": kind,
		"size": 0,
		"u8": {},
		"u16": {},
		"u32": {},
	}
	if kind == 2:
		var u8m: Dictionary = {0: 2}
		var u16m: Dictionary = {}
		var u32m: Dictionary = {}
		var flags04: int = int(desc.get(0x16, 0)) & 0xFFFF
		u32m[4] = flags04
		## Ghidra: after [1]=ushort, test byte at obj+6 & 0x20 → obj+5 |= 0x10.
		## With zero-extended u32 write, +6 is 0; keep the OR path for fidelity.
		var b6: int = (flags04 >> 16) & 0xFF
		if (b6 & 0x20) != 0:
			u8m[5] = 0x10
		u32m[0x18] = int(desc.get(2, 0)) & 0xFFFFFFFF
		u32m[0x1C] = int(desc.get(6, 0)) & 0xFFFFFFFF
		u32m[0x20] = int(desc.get(10, 0)) & 0xFFFFFFFF
		u32m[0x0C] = int(desc.get(0x0E, 0)) & 0xFFFFFFFF
		u32m[0x14] = int(desc.get(0x12, 0)) & 0xFFFFFFFF
		u16m[0x34] = int(desc.get(0x18, 0)) & 0xFFFF
		u16m[0x36] = int(desc.get(0x1A, 0)) & 0xFFFF
		var s1c: int = _to_s16(int(desc.get(0x1C, 0)))
		if s1c == 0:
			s1c = 1
		u16m[0x38] = s1c & 0xFFFF
		u16m[0x3A] = int(desc.get(0x1E, 0)) & 0xFFFF
		u16m[0x50] = int(desc.get(0x20, 0)) & 0xFFFF
		u32m[0x40] = dat_0001b838 & 0xFFFFFFFF
		out["ok"] = true
		out["size"] = 0x52
		out["u8"] = u8m
		out["u16"] = u16m
		out["u32"] = u32m
		return out
	if kind == 3:
		var u8m3: Dictionary = {0: 3}
		var u16m3: Dictionary = {}
		var u32m3: Dictionary = {}
		u32m3[0x18] = int(desc.get(2, 0)) & 0xFFFFFFFF
		u32m3[0x1C] = int(desc.get(6, 0)) & 0xFFFFFFFF
		u32m3[0x20] = int(desc.get(10, 0)) & 0xFFFFFFFF
		u32m3[0x0C] = int(desc.get(0x0E, 0)) & 0xFFFFFFFF
		u32m3[0x14] = int(desc.get(0x12, 0)) & 0xFFFFFFFF
		u16m3[0x2C] = int(desc.get(0x16, 0)) & 0xFFFF
		u32m3[0x28] = int(desc.get("desc_ptr", 0)) & 0xFFFFFFFF
		u16m3[0x2E] = int(desc.get(0x18, 0)) & 0xFFFF
		out["ok"] = true
		out["size"] = 0x34
		out["u8"] = u8m3
		out["u16"] = u16m3
		out["u32"] = u32m3
		return out
	return out


## [RECONSTRUCTED] FUN_00003b98 axis loads — Capstone @0x3B98–0x3BD4.
## a = |*(obj+0x18) − DAT_0001d838|; b = |+0x1c − DAT_0001d834|; c = |+0x20 − DAT_0001d830|.
## Abs callee: call sites LEA $2DE8 but that is a false mid-label inside FUN_00002d10 epilogue;
## real abs body is FUN_00002e08 @0x2E08 (`MOVE.L 4(A7),D0; BGE; NEG; RTS`) — same stack ABI.
static func apply_03b98_camera_abs_axes(
	pos_18: int, pos_1c: int, pos_20: int,
	cam_d838: int, cam_d834: int, cam_d830: int
) -> Dictionary:
	## 68k SUBA then abs: interpret 32-bit difference as signed before |x|.
	var a: int = fun_00002e08(_to_s32(pos_18) - _to_s32(cam_d838))
	var b: int = fun_00002e08(_to_s32(pos_1c) - _to_s32(cam_d834))
	var c: int = fun_00002e08(_to_s32(pos_20) - _to_s32(cam_d830))
	return {"a": a, "b": b, "c": c}


## [RECONSTRUCTED] FUN_00003b98 / twin FUN_00003c00 combine (4522–4544, 4898–4919).
## metric = max(a,b,c) + ((sum of other two) >> 2); 03b98 also writes obj+0x10.
## a,b,c: camera-relative abs axes (see apply_03b98_camera_abs_axes).
## Ghidra types 03b98 void; callers use return as D0 (== field_10). Same math as 03c00.
static func apply_fun_00003b98(a: int, b: int, c: int) -> Dictionary:
	var x: int = a
	var y: int = b
	var z: int = c
	var mx: int = x
	var lo: int = y
	if x < y:
		mx = y
		lo = x
	var mid: int = z
	if mx < z:
		mid = mx
		mx = z
	var metric: int = mx + ((mid + lo) >> 2)
	return {
		"field_10": metric,
		"metric": metric,
		"max": mx,
		"mid": mid,
		"lo": lo,
	}


## [RECONSTRUCTED] FUN_000046da post-0435a gate (5252–5258).
## if (metric - obj[+0xc]) < 0x19c80 → FUN_00004e6e; else defer onto DAT_0001d0e4[].
## metric: FUN_00003b98 D0 / field_10.
static func apply_046da_04e6e_distance_gate(metric: int, field_0c: int) -> Dictionary:
	var delta: int = (metric & 0xFFFFFFFF) - (field_0c & 0xFFFFFFFF)
	## signed 32-bit compare as in `(int)(iVar3 - puVar1[3]) < 0x19c80`
	if delta > 0x7FFFFFFF:
		delta -= 0x100000000
	elif delta < -0x80000000:
		delta += 0x100000000
	var need: bool = delta < 0x19C80
	return {
		"delta": delta,
		"need_04e6e": need,
		"deferred": not need,
	}


## [RECONSTRUCTED] FUN_00004e6e kind-2 list publish (5631–5638; Capstone @0x4E8E–0x4EBE).
## if (obj+7)&1 → DAT_0001d4a4[c1e0++]; else → DAT_0001b5a4[b734++].
static func apply_04e6e_kind2_list_select(byte_07: int) -> Dictionary:
	var to_d4a4: bool = (byte_07 & 1) != 0
	return {
		"to_d4a4": to_d4a4,
		"to_b5a4": not to_d4a4,
	}


## [RECONSTRUCTED] FUN_00001a68 size normalize (2149): (request+7) & ~3.
static func apply_01a68_round_bytes(request: int) -> int:
	return int((int(request) + 7) & 0xFFFFFFFC)


## [RECONSTRUCTED] FUN_00001a68 size-class routing (2148–2164) — no freelist / DAT_00020c64.
## Small bins 2..5 when bin_index < 6; else large_words = (request+7)>>3 + 1.
## [DEFERRED] freelist pop, FUN_00001974 / 0199a, return payload pointer.
static func apply_01a68_route(request: int) -> Dictionary:
	var req: int = int(request) & 0xFFFFFFFF
	var rounded: int = apply_01a68_round_bytes(req)
	var bin_index: int = 2
	var t: int = ((rounded - 1) >> 2) & 0xFFFFFFFF
	while t != 0:
		bin_index += 1
		t = (t >> 1) & 0xFFFFFFFF
	if bin_index < 6:
		var block: int = 1 << bin_index
		return {
			"request": req,
			"rounded_bytes": rounded,
			"bin_index": bin_index,
			"use_small_bins": true,
			"small_bin": bin_index,
			"fresh_block_bytes": block,
			"payload_capacity": block - 4,
			"large_words": 0,
		}
	var words: int = ((req + 7) >> 3) + 1
	return {
		"request": req,
		"rounded_bytes": rounded,
		"bin_index": bin_index,
		"use_small_bins": false,
		"small_bin": 0,
		"fresh_block_bytes": words * 8,
		"payload_capacity": words * 8 - 8,
		"large_words": words,
	}


## [RECONSTRUCTED] FUN_00001b38 zero-fill length from 01a68 route (2197–2208) — size only.
## Small: (1<<bin)-4; large: (words-1)*8. No heap write.
static func apply_01b38_zero_bytes(route: Dictionary) -> int:
	if bool(route.get("use_small_bins", false)):
		return int(route.get("payload_capacity", 0))
	var words: int = int(route.get("large_words", 0))
	if words <= 1:
		return 0
	return (words - 1) * 8


## [RECONSTRUCTED] FUN_00001958 (2013–2021): bump DAT_00020c50 against heap_base (mission+0x348).
## state: {heap_cursor, heap_base}. Mutates heap_cursor. Returns block_start.
static func apply_01958_heap_bump(grow_bytes: int, state: Dictionary) -> Dictionary:
	var grow: int = int(grow_bytes) & 0xFFFFFFFF
	var cursor: int = int(state.get("heap_cursor", 0)) & 0xFFFFFFFF
	var base: int = int(state.get("heap_base", 0)) & 0xFFFFFFFF
	var block_start: int = (base + cursor) & 0xFFFFFFFF
	state["heap_cursor"] = (cursor + grow) & 0xFFFFFFFF
	return {
		"ok": true,
		"block_start": block_start,
		"heap_cursor": int(state["heap_cursor"]),
		"heap_base": base,
		"grow_bytes": grow,
	}


## [RECONSTRUCTED] FUN_00001974 (2025–2039): fresh small-bin when freelist head null.
## grow=1<<(bin&0x3f); 01958(grow); header byte=bin at block; return payload=block+4.
## [DEFERRED] DAT_00020c64 freelist; 0xffffffff failure path.
static func apply_01974_fresh_small_bin(bin_index: int, state: Dictionary) -> Dictionary:
	var bin: int = int(bin_index) & 0x3F
	var grow: int = 1 << bin
	var bump: Dictionary = apply_01958_heap_bump(grow, state)
	var block: int = int(bump.get("block_start", 0))
	return {
		"ok": true,
		"size_class": bin,
		"grow_bytes": grow,
		"header_byte": bin,
		"header_offset": block,
		"payload_ptr": (block + 4) & 0xFFFFFFFF,
		"payload_capacity": grow - 4,
		"heap_cursor": int(bump.get("heap_cursor", 0)),
		"01958": bump,
	}


## [RECONSTRUCTED] 01a68 small-bin empty-freelist path: route → 01974(bin).
## Prefer apply_01a68_small_alloc when freelist state is present.
static func apply_01a68_fresh_small_from_request(request: int, state: Dictionary) -> Dictionary:
	var route: Dictionary = apply_01a68_route(request)
	if not bool(route.get("use_small_bins", false)):
		return {
			"ok": false,
			"deferred_large": true,
			"route": route,
		}
	var fresh: Dictionary = apply_01974_fresh_small_bin(int(route.get("small_bin", 0)), state)
	fresh["route"] = route
	fresh["request"] = int(request) & 0xFFFFFFFF
	fresh["from_freelist"] = false
	_01a68_remember_block(state, fresh)
	return fresh


## Ensure freelist bookkeeping arrays on heap state (DAT_00020c64 mock).
static func _01a68_ensure_freelist_state(state: Dictionary) -> void:
	if not state.has("freelist") or not (state["freelist"] is Array):
		state["freelist"] = [0, 0, 0, 0, 0, 0]
	while (state["freelist"] as Array).size() < 6:
		(state["freelist"] as Array).append(0)
	if not state.has("block_next") or not (state["block_next"] is Dictionary):
		state["block_next"] = {}
	if not state.has("block_class") or not (state["block_class"] is Dictionary):
		state["block_class"] = {}


static func _01a68_remember_block(state: Dictionary, alloc: Dictionary) -> void:
	_01a68_ensure_freelist_state(state)
	var header: int = int(alloc.get("header_offset", 0)) & 0xFFFFFFFF
	var bin: int = int(alloc.get("size_class", 0)) & 0x3F
	(state["block_class"] as Dictionary)[header] = bin


## [RECONSTRUCTED] FUN_00001a68 small path (2152–2161): pop DAT_00020c64[bin] or 01974.
## Freelist node: u32 next at block base; on pop overwrite byte0 with bin, return +4.
static func apply_01a68_small_alloc(request: int, state: Dictionary) -> Dictionary:
	var route: Dictionary = apply_01a68_route(request)
	if not bool(route.get("use_small_bins", false)):
		return {
			"ok": false,
			"deferred_large": true,
			"route": route,
		}
	_01a68_ensure_freelist_state(state)
	var bin: int = int(route.get("small_bin", 0))
	var fl: Array = state["freelist"] as Array
	var head: int = int(fl[bin]) & 0xFFFFFFFF
	if head == 0:
		var fresh: Dictionary = apply_01974_fresh_small_bin(bin, state)
		fresh["route"] = route
		fresh["request"] = int(request) & 0xFFFFFFFF
		fresh["from_freelist"] = false
		_01a68_remember_block(state, fresh)
		return fresh
	var nxt: Dictionary = state["block_next"] as Dictionary
	var next_head: int = int(nxt.get(head, 0)) & 0xFFFFFFFF
	fl[bin] = next_head
	nxt.erase(head)
	var payload: int = (head + 4) & 0xFFFFFFFF
	var grow: int = 1 << bin
	var out: Dictionary = {
		"ok": true,
		"size_class": bin,
		"grow_bytes": grow,
		"header_byte": bin,
		"header_offset": head,
		"payload_ptr": payload,
		"payload_capacity": grow - 4,
		"from_freelist": true,
		"route": route,
		"request": int(request) & 0xFFFFFFFF,
		"heap_cursor": int(state.get("heap_cursor", 0)),
	}
	_01a68_remember_block(state, out)
	return out


## [RECONSTRUCTED] FUN_000019d0 small free (2117–2121): push payload−4 onto DAT_00020c64[bin].
## Large coalesce path (header==0xff) → apply_019d0_free_large.
static func apply_019d0_free_small(payload_ptr: int, state: Dictionary) -> Dictionary:
	_01a68_ensure_freelist_state(state)
	var header: int = (int(payload_ptr) - 4) & 0xFFFFFFFF
	var classes: Dictionary = state["block_class"] as Dictionary
	if not classes.has(header):
		return {"ok": false, "reason": "unknown_block", "header_offset": header}
	var bin: int = int(classes[header]) & 0xFF
	if bin == 0xFF:
		return apply_019d0_free_large(payload_ptr, state)
	if bin >= 6:
		return {"ok": false, "deferred_large": true, "size_class": bin}
	var fl: Array = state["freelist"] as Array
	var old_head: int = int(fl[bin]) & 0xFFFFFFFF
	(state["block_next"] as Dictionary)[header] = old_head
	fl[bin] = header
	return {
		"ok": true,
		"size_class": bin,
		"header_offset": header,
		"payload_ptr": int(payload_ptr) & 0xFFFFFFFF,
		"freelist_head": header,
		"prev_head": old_head,
	}


## Ensure large free-ring mock (DAT_00020c60 / 20c58).
static func _01a68_ensure_large_state(state: Dictionary) -> void:
	_01a68_ensure_freelist_state(state)
	if not state.has("large_free") or not (state["large_free"] is Array):
		state["large_free"] = []
	if not state.has("block_words") or not (state["block_words"] is Dictionary):
		state["block_words"] = {}


## [RECONSTRUCTED] FUN_0000199a (2043–2059): bump words<<3, tag words+0xff, free into large ring.
## Returns mock DAT_00020c60 (= new free node addr). Full circular coalesce [SIMPLIFIED]→append list.
static func apply_0199a_fresh_large(words: int, state: Dictionary) -> Dictionary:
	_01a68_ensure_large_state(state)
	var w: int = int(words)
	if w <= 0:
		return {"ok": false, "reason": "bad_words"}
	var bump: Dictionary = apply_01958_heap_bump(w << 3, state)
	var addr: int = int(bump.get("block_start", 0)) & 0xFFFFFFFF
	(state["large_free"] as Array).append({"addr": addr, "words": w})
	state["large_roving"] = addr
	return {
		"ok": true,
		"addr": addr,
		"words": w,
		"grow_bytes": w << 3,
		"header_byte": 0xFF,
		"dat_00020c60": addr,
		"01958": bump,
	}


## [RECONSTRUCTED] FUN_00001a68 large path (2163–2191): words=(n+7)>>3+1; take/split free node.
## Exact: unlink. Larger: shrink free, carve at addr+remain*8. Tag 0xff at carved+4; payload=carved+8.
## Empty/insufficient ring → FUN_0000199a(need) then take.
static func apply_01a68_large_alloc(request: int, state: Dictionary) -> Dictionary:
	var route: Dictionary = apply_01a68_route(request)
	if bool(route.get("use_small_bins", false)):
		return {
			"ok": false,
			"deferred_small": true,
			"route": route,
		}
	_01a68_ensure_large_state(state)
	var need: int = int(route.get("large_words", 0))
	var freelist: Array = state["large_free"] as Array
	var idx: int = -1
	for i in range(freelist.size()):
		if int((freelist[i] as Dictionary).get("words", 0)) >= need:
			idx = i
			break
	var from_0199a: bool = false
	if idx < 0:
		var grown: Dictionary = apply_0199a_fresh_large(need, state)
		if not bool(grown.get("ok", false)):
			return {"ok": false, "reason": "0199a_fail", "route": route}
		from_0199a = true
		freelist = state["large_free"] as Array
		for i in range(freelist.size()):
			if int((freelist[i] as Dictionary).get("words", 0)) >= need:
				idx = i
				break
	if idx < 0:
		return {"ok": false, "reason": "no_block", "route": route}
	var node: Dictionary = freelist[idx] as Dictionary
	var addr: int = int(node.get("addr", 0)) & 0xFFFFFFFF
	var have: int = int(node.get("words", 0))
	var carved: int = addr
	if have == need:
		freelist.remove_at(idx)
	else:
		var remain: int = have - need
		node["words"] = remain
		freelist[idx] = node
		carved = (addr + remain * 8) & 0xFFFFFFFF
	var header: int = (carved + 4) & 0xFFFFFFFF
	var payload: int = (carved + 8) & 0xFFFFFFFF
	(state["block_class"] as Dictionary)[header] = 0xFF
	(state["block_words"] as Dictionary)[carved] = need
	return {
		"ok": true,
		"use_small_bins": false,
		"large_words": need,
		"block_addr": carved,
		"header_offset": header,
		"header_byte": 0xFF,
		"payload_ptr": payload,
		"payload_capacity": need * 8 - 8,
		"from_0199a": from_0199a,
		"split": have != need,
		"route": route,
		"request": int(request) & 0xFFFFFFFF,
		"heap_cursor": int(state.get("heap_cursor", 0)),
	}


## [RECONSTRUCTED] FUN_000019d0 large free (2094–2115) — insert + adjacent coalesce.
## Capstone: if block+words*8==next → absorb next; if prev+prev.words*8==block → merge into prev
## (then 01a48 cursor — deferred). Circular ring walk [SIMPLIFIED]→ array adjacency.
static func apply_019d0_free_large(payload_ptr: int, state: Dictionary) -> Dictionary:
	_01a68_ensure_large_state(state)
	var carved: int = (int(payload_ptr) - 8) & 0xFFFFFFFF
	var words_map: Dictionary = state["block_words"] as Dictionary
	if not words_map.has(carved):
		return {"ok": false, "reason": "unknown_large", "block_addr": carved}
	var w: int = int(words_map[carved])
	words_map.erase(carved)
	var freelist: Array = state["large_free"] as Array
	var coalesced_forward: bool = false
	var coalesced_backward: bool = false
	## Absorb next free block if immediately after us (2101–2103).
	for i in range(freelist.size() - 1, -1, -1):
		var nxt: Dictionary = freelist[i] as Dictionary
		var naddr: int = int(nxt.get("addr", 0)) & 0xFFFFFFFF
		if (carved + w * 8) & 0xFFFFFFFF == naddr:
			w += int(nxt.get("words", 0))
			freelist.remove_at(i)
			coalesced_forward = true
			break
	## Merge into previous free block if we sit immediately after it (2108–2112).
	for i in range(freelist.size()):
		var prev: Dictionary = freelist[i] as Dictionary
		var paddr: int = int(prev.get("addr", 0)) & 0xFFFFFFFF
		var pw: int = int(prev.get("words", 0))
		if (paddr + pw * 8) & 0xFFFFFFFF == carved:
			pw += w
			prev["words"] = pw
			freelist[i] = prev
			carved = paddr
			w = pw
			coalesced_backward = true
			state["large_roving"] = paddr
			return {
				"ok": true,
				"large": true,
				"block_addr": carved,
				"words": w,
				"payload_ptr": int(payload_ptr) & 0xFFFFFFFF,
				"coalesce": true,
				"coalesced_forward": coalesced_forward,
				"coalesced_backward": true,
				"01a48_cursor": false,
			}
	freelist.append({"addr": carved, "words": w})
	state["large_roving"] = carved
	return {
		"ok": true,
		"large": true,
		"block_addr": carved,
		"words": w,
		"payload_ptr": int(payload_ptr) & 0xFFFFFFFF,
		"coalesce": coalesced_forward,
		"coalesced_forward": coalesced_forward,
		"coalesced_backward": coalesced_backward,
		"01a48_cursor": false,
	}


## [RECONSTRUCTED] DAT_0001b524 factory slot write (e.g. @0x16AB2 / decomp ~17695).
## *(table[type] + 6) = factory_addr. Table entries are runtime template structs (FUN_00000054).
static func apply_1b524_set_factory(template_ptr: int, factory_addr: int) -> Dictionary:
	return {
		"template_ptr": int(template_ptr) & 0xFFFFFFFF,
		"factory_offset": 6,
		"factory_addr": int(factory_addr) & 0xFFFFFFFF,
		"wrote": int(template_ptr) != 0,
	}


## [PROVEN] Binary stores factory immediates that land mid-instruction / epilogue;
## real LINK/MOVEA entries are +0x20 (same class as $1A48→$1A68).
## Capstone: `#0x16a1a` @0x16AB2 → entry `FUN_00016a3a` @0x16a3a; `#0x11590` @0x115F0 → `FUN_000115b0` @0x115b0.
static func apply_1b524_factory_entry_addr(stored_imm: int) -> Dictionary:
	var s: int = int(stored_imm) & 0xFFFFFFFF
	var known: Dictionary = {0x16A1A: 0x16A3A, 0x11590: 0x115B0}
	if known.has(s):
		var entry: int = int(known[s])
		return {
			"stored": s,
			"entry": entry,
			"adjusted": true,
			"delta": (entry - s) & 0xFFFFFFFF,
		}
	return {"stored": s, "entry": s, "adjusted": false, "delta": 0}


## [RECONSTRUCTED] FUN_000016e2 root publish (Capstone @0x16FC): DAT_0001d6fc = 04690(desc).
static func apply_016e2_publish_root(root_ptr: int, desc_ptr: int) -> Dictionary:
	var root: int = int(root_ptr) & 0xFFFFFFFF
	return {
		"ok": root != 0,
		"dat_0001d6fc": root,
		"desc_ptr": int(desc_ptr) & 0xFFFFFFFF,
		"root_ptr": root,
	}


## [RECONSTRUCTED] FUN_000016e2 child table size (Capstone @0x170C–0x1716).
## count = s16(root+0x2E); bytes = count*3<<3 = count*0x18.
static func apply_016e2_child_table_bytes(count: int) -> int:
	var n: int = _to_s16(count)
	if n < 0:
		n = 0
	return n * 0x18


## [RECONSTRUCTED] FUN_000016e2 embedded child source (Capstone @0x1704–0x170A).
## src = *(root+0x28) + 0x1A.
static func apply_016e2_child_src_base(root_field_28: int) -> int:
	return (int(root_field_28) + 0x1A) & 0xFFFFFFFF


## [RECONSTRUCTED] FUN_000016e2 relocate record+0x14 (Capstone @0x174A–0x1754).
## *(table+i*0x18+0x14) += *(DAT_0001b5a0+0x8C).
static func apply_016e2_relocate_child_name(field_14: int, mission_base_8c: int) -> int:
	return (int(field_14) + int(mission_base_8c)) & 0xFFFFFFFF


## [RECONSTRUCTED] FUN_000016e2 one child record copy (six longs / 0x18).
## src_u32: length ≥6 absolute words from embedded table.
static func apply_016e2_copy_child_record(src_u32: Array) -> Dictionary:
	var out: Array = []
	for i in range(6):
		var v: int = 0
		if i < src_u32.size():
			v = int(src_u32[i]) & 0xFFFFFFFF
		out.append(v)
	return {
		"stride": 0x18,
		"words": out,
		"field_14": int(out[5]) & 0xFFFFFFFF,
	}


## [RECONSTRUCTED] FUN_000016e2 per-child link (Capstone @0x1784–0x178E).
## After 04690: obj+0x24=root; byte obj+1=obj+2=index.
static func apply_016e2_link_child(root_ptr: int, index: int) -> Dictionary:
	var idx: int = int(index) & 0xFF
	return {
		"field_24": int(root_ptr) & 0xFFFFFFFF,
		"field_01": idx,
		"field_02": idx,
	}


## [RECONSTRUCTED] FUN_000016e2 publish DAT_0001bdb4 (Capstone @0x17A2–0x17AC).
## bdb4 = *( *(DAT_0001d6fc+0x30) + 0x14 )  — child[0] object after resolve.
static func apply_016e2_publish_bdb4(child0_obj: int) -> Dictionary:
	return {
		"ok": int(child0_obj) != 0,
		"dat_0001bdb4": int(child0_obj) & 0xFFFFFFFF,
	}


## [RECONSTRUCTED] FUN_000016e2 child slot object (table + index*0x18 + 0x14).
static func apply_016e2_child_slot_obj(table_ptr: int, index: int) -> int:
	return (int(table_ptr) + int(index) * 0x18 + 0x14) & 0xFFFFFFFF


## [RECONSTRUCTED] FUN_000016e2 bdac select (Capstone @0x17FC–0x1832).
## if *(b5a0+0x90)==2: child[3] @ +0x5C; else child[2] @ +0x44 (+ optional 04e6e).
static func apply_016e2_bdac_select(mission_short_90: int, table_ptr: int) -> Dictionary:
	var is_mission_2: bool = _to_s16(mission_short_90) == 2
	var index: int = 3 if is_mission_2 else 2
	var off: int = 0x5C if is_mission_2 else 0x44
	return {
		"is_mission_2": is_mission_2,
		"child_index": index,
		"table_offset": off,
		"slot_addr": apply_016e2_child_slot_obj(table_ptr, index),
		"call_04e4e": is_mission_2,
		"call_04e6e": not is_mission_2,
	}


## [RECONSTRUCTED] FUN_00004e06 gate (Capstone @0x4E0E–0x4E14; decomp ~5559).
## Skip body when bit1 of obj+7 is set.
static func apply_04e06_gate(byte_07: int) -> Dictionary:
	var skip: bool = (int(byte_07) & 2) != 0
	return {"skip": skip, "run_body": not skip}


## [RECONSTRUCTED] FUN_00004e06 desc pointer (decomp ~5560–5562; Capstone @0x4E16–0x4E38).
## desc = *(b5a0+0x8c) + *( *(parent+0x28) + 0x2E + (obj+1)*0x18 ).
static func apply_04e06_desc_ptr(
	parent_28: int, child_index_byte: int, b5a0_8c: int, raw_desc_off: int
) -> Dictionary:
	var idx: int = int(child_index_byte) & 0xFF
	var slot: int = (int(parent_28) + 0x2E + idx * 0x18) & 0xFFFFFFFF
	return {
		"ok": int(parent_28) != 0,
		"slot_addr": slot,
		"child_index": idx,
		"desc_ptr": (int(b5a0_8c) + int(raw_desc_off)) & 0xFFFFFFFF,
	}


## [RECONSTRUCTED] FUN_00004e06 field copies (Capstone @0x4E3C–0x4E52; decomp ~5563–5566).
## obj+0x18/1c/20/14 ← desc+2/6/a/12. Mid-entry FUN_00004e4e is only the last store.
static func apply_04e06_field_copies(
	desc_2: int, desc_6: int, desc_a: int, desc_12: int
) -> Dictionary:
	return {
		"field_18": int(desc_2) & 0xFFFFFFFF,
		"field_1c": int(desc_6) & 0xFFFFFFFF,
		"field_20": int(desc_a) & 0xFFFFFFFF,
		"field_14": int(desc_12) & 0xFFFFFFFF,
		"call_02bd8": true,
		"02bd8_param_2": 1,
		"02bd8_param_3": 0,
		"02bd8_param_4": 0,
	}


## [RECONSTRUCTED] FUN_00004e4e mid-entry tail (Capstone @0x4E4E; decomp ~5580–5581).
## *(obj+0x14)=*(desc+0x12); then 02bd8(obj,1,0,0). 016e2 JSRs here (LEA $4e4e).
static func apply_04e4e_tail(desc_12: int) -> Dictionary:
	return {
		"field_14": int(desc_12) & 0xFFFFFFFF,
		"call_02bd8": true,
		"02bd8_param_2": 1,
		"02bd8_param_3": 0,
		"02bd8_param_4": 0,
		"entry": "4e4e",
	}


## [RECONSTRUCTED] FUN_000016e2 bda8 from *(bdac+0x48) (Capstone @0x183E–0x184C).
static func apply_016e2_publish_bda8(bdac_obj: int, field_48: int) -> Dictionary:
	return {
		"ok": int(bdac_obj) != 0,
		"dat_0001bda8": int(field_48) & 0xFFFFFFFF,
		"source": "bdac+0x48",
	}


## [RECONSTRUCTED] FUN_000016e2 bda4 = child[4] @ table+0x74 (Capstone @0x184E–0x185F).
static func apply_016e2_publish_bda4(table_ptr: int, child4_obj: int) -> Dictionary:
	return {
		"ok": int(table_ptr) != 0,
		"dat_0001bda4": int(child4_obj) & 0xFFFFFFFF,
		"slot_addr": apply_016e2_child_slot_obj(table_ptr, 4),
		"call_04e6e": true,
		"call_01c04": true,
	}


## [RECONSTRUCTED] FUN_000016e2 bc28 window (Capstone @0x186E–0x18C8).
## iVar4 = *(short*)(root+0x2C); b88e=iVar4-1; bc28/34/38 = child[i-1/i/i+1]; b88c=iVar4+1.
static func apply_016e2_bc28_window(root_short_2c: int, table_ptr: int) -> Dictionary:
	var i_var4: int = _to_s16(root_short_2c)
	var b88e: int = (i_var4 - 1) & 0xFFFF
	var b88c: int = (i_var4 + 1) & 0xFFFF
	var idx0: int = i_var4 - 1
	return {
		"ok": int(table_ptr) != 0,
		"i_var4": i_var4,
		"dat_0001b88e": b88e,
		"dat_0001b88c": b88c,
		"bc28_slot": apply_016e2_child_slot_obj(table_ptr, idx0),
		"bc34_slot": apply_016e2_child_slot_obj(table_ptr, i_var4),
		"bc38_slot": apply_016e2_child_slot_obj(table_ptr, i_var4 + 1),
	}


## [RECONSTRUCTED] 04690 type index: DAT_0001b524[desc[1]] (decomp ~6077 / Capstone 04690).
## Capstone @0x46A2–0x46B4: TST.B / MOVE.B / EXTB.L — byte type, sign-extended.
## override_key < 0 → use desc_type; else force override (tests / Block A without matching desc).
static func apply_1b524_type_key(desc_type: int, override_key: int = -1) -> Dictionary:
	var desc_k: int = int(desc_type)
	if desc_k >= 0x8000 and desc_k <= 0xFFFF:
		desc_k = desc_k - 0x10000
	if int(override_key) >= 0:
		return {
			"type_key": int(override_key),
			"desc_type": desc_k,
			"source": "override",
		}
	return {
		"type_key": desc_k,
		"desc_type": desc_k,
		"source": "desc[1]",
	}


## [RECONSTRUCTED] 04690 factory resolve: tmpl=1b524[type]; imm=*(tmpl+6); entry=+0x20 fixup.
## Prefer tpl+6; fallback_imm for tests / pre-install. source: "tpl+6" | "fallback" | "none".
static func apply_1b524_resolve_factory(
	template_table: Dictionary,
	type_key: int,
	tpl_plus6_imm: int,
	fallback_imm: int = 0
) -> Dictionary:
	var key_s: int = int(type_key)
	if key_s >= 0x8000:
		key_s = (key_s & 0xFFFF) - 0x10000
	elif key_s > 0xFFFF:
		key_s = key_s & 0xFFFF
	var tpl: int = int(template_table.get(key_s, 0)) & 0xFFFFFFFF
	if tpl == 0 and template_table.has(int(type_key) & 0xFFFF):
		key_s = int(type_key) & 0xFFFF
		tpl = int(template_table[key_s]) & 0xFFFFFFFF
	var from_tpl: int = int(tpl_plus6_imm) & 0xFFFFFFFF
	var fb: int = int(fallback_imm) & 0xFFFFFFFF
	var imm: int = 0
	var source: String = "none"
	if from_tpl != 0:
		imm = from_tpl
		source = "tpl+6"
	elif fb != 0:
		imm = fb
		source = "fallback"
	var entry_info: Dictionary = apply_1b524_factory_entry_addr(imm)
	return {
		"type_key": key_s,
		"template_ptr": tpl,
		"imm": imm,
		"source": source,
		"entry": int(entry_info.get("entry", 0)),
		"adjusted": bool(entry_info.get("adjusted", false)),
		"entry_resolve": entry_info,
	}


## [RECONSTRUCTED] FUN_00016a3a factory body (Capstone @0x16a3a–0x16a76; decomp ~20803).
## Signature matches 04690 call: (obj, type, …) → handle in D0.
## handle = 01b6c(0x58); *handle=obj; obj+4 |= 0x12000; obj+0x34=0; handle+4 = 1b524[type].
## [DEFERRED] real FUN_00001b6c — caller supplies handle_ptr (cleared 0x58 stand-in).
static func apply_16a3a_factory(
	obj_ptr: int,
	obj_flags_04: int,
	type_key: int,
	template_table: Dictionary,
	handle_ptr: int
) -> Dictionary:
	var key_s: int = int(type_key)
	if key_s >= 0x8000:
		key_s = (key_s & 0xFFFF) - 0x10000
	elif key_s > 0xFFFF:
		key_s = key_s & 0xFFFF
	var tpl: int = int(template_table.get(key_s, 0)) & 0xFFFFFFFF
	if tpl == 0 and template_table.has(int(type_key) & 0xFFFF):
		tpl = int(template_table[int(type_key) & 0xFFFF]) & 0xFFFFFFFF
	var h: int = int(handle_ptr) & 0xFFFFFFFF
	return {
		"ok": h != 0,
		"factory_entry": 0x16A3A,
		"stored_install_imm": 0x16A1A,
		"alloc_size": 0x58,
		"handle_ptr": h,
		"handle_u32_00": int(obj_ptr) & 0xFFFFFFFF,
		"handle_u32_04": tpl,
		"obj_ptr": int(obj_ptr) & 0xFFFFFFFF,
		"obj_flags_04": (int(obj_flags_04) | 0x12000) & 0xFFFFFFFF,
		"obj_u16_34": 0,
		"type_key": key_s,
		"via_01b6c": true,
	}


## [RECONSTRUCTED] FUN_000115b0 factory body (Capstone @0x115b0–0x115d8; decomp ~16437).
## 04690 still calls (obj,type,0); body uses obj only.
## handle = 01b6c(0xa2); *handle=obj; obj+4 |= 0x112000; handle+4 = *(DAT_0001b540).
## Capstone: MOVE.L $1b540.L,$4(A0) — load from absolute slot (Block B publish target).
## [DEFERRED] real FUN_00001b6c — caller supplies handle_ptr + dat_0001b540 value.
static func apply_115b0_factory(
	obj_ptr: int,
	obj_flags_04: int,
	dat_0001b540: int,
	handle_ptr: int
) -> Dictionary:
	var h: int = int(handle_ptr) & 0xFFFFFFFF
	return {
		"ok": h != 0,
		"factory_entry": 0x115B0,
		"stored_install_imm": 0x11590,
		"alloc_size": 0xA2,
		"handle_ptr": h,
		"handle_u32_00": int(obj_ptr) & 0xFFFFFFFF,
		"handle_u32_04": int(dat_0001b540) & 0xFFFFFFFF,
		"obj_ptr": int(obj_ptr) & 0xFFFFFFFF,
		"obj_flags_04": (int(obj_flags_04) | 0x112000) & 0xFFFFFFFF,
		"via_01b6c": true,
	}


const DAT_00054_RECORDS_PATH := "res://hellcats/tests/fixtures/dat_00054_template_records_4a.json"
static var _00054_records_4a: Array = []
static var _00054_records_loaded: bool = false


## Load FUN_00000054 first-loop 4×0x4A template records (file 0x1a790).
static func load_00054_template_records_4a() -> Array:
	if _00054_records_loaded and _00054_records_4a.size() == 4:
		return _00054_records_4a.duplicate(true)
	_00054_records_4a = []
	if FileAccess.file_exists(DAT_00054_RECORDS_PATH):
		var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(DAT_00054_RECORDS_PATH))
		if typeof(parsed) == TYPE_DICTIONARY:
			var recs: Array = (parsed as Dictionary).get("records", []) as Array
			if recs.size() == 4:
				_00054_records_4a = recs
				_00054_records_loaded = true
				return _00054_records_4a.duplicate(true)
	_00054_records_loaded = false
	return []


## [RECONSTRUCTED] FUN_00000054 publish (0x0088–0x008A): table[sign_extend(key)] = block_ptr.
## key is s16 at record+0; Movea.W then (A5,A0.L*4).
static func apply_00054_publish_slot(table: Dictionary, key_u16: int, block_ptr: int) -> Dictionary:
	var ku: int = int(key_u16) & 0xFFFF
	var key_s: int = ku if ku < 0x8000 else ku - 0x10000
	table[key_s] = int(block_ptr) & 0xFFFFFFFF
	return {
		"key_u16": ku,
		"key_signed": key_s,
		"block_ptr": int(block_ptr) & 0xFFFFFFFF,
		"slot_index": key_s,
	}


## [RECONSTRUCTED] FUN_00000054 first loop one record (0x006C–0x00A0).
## alloc 0x4A (LEA $1A48 stand-in→01a68) → copy 0x4A from static src → publish by key.
## Copy body = FUN_00000032 [deferred detail]; we retain bytes_hex on the publish result.
static func apply_00054_first_loop_record(
	record: Dictionary,
	heap_state: Dictionary,
	table: Dictionary
) -> Dictionary:
	var alloc: Dictionary = apply_01a68_alloc(0x4A, heap_state)
	if not bool(alloc.get("ok", false)):
		return {"ok": false, "alloc": alloc}
	var ptr: int = int(alloc.get("payload_ptr", 0))
	var pub: Dictionary = apply_00054_publish_slot(table, int(record.get("key", 0)), ptr)
	return {
		"ok": true,
		"alloc": alloc,
		"publish": pub,
		"record_size": 0x4A,
		"bytes_hex": str(record.get("bytes_hex", "")),
		"src_offset": str(record.get("file_offset", "")),
	}


## [RECONSTRUCTED] FUN_00000054 first loop ×4 (0x0058–0x00A0): records @0x1a790 step 0x4A.
## Keys from ROM: 0x5858, 0x0999, 0x0999, 0x0999 — last 0x0999 wins.
static func apply_00054_first_loop(heap_state: Dictionary, table: Dictionary) -> Dictionary:
	var recs: Array = load_00054_template_records_4a()
	var steps: Array = []
	for rec in recs:
		if not (rec is Dictionary):
			break
		steps.append(apply_00054_first_loop_record(rec as Dictionary, heap_state, table))
	return {
		"ok": steps.size() == 4,
		"steps": steps,
		"record_count": steps.size(),
		"table_keys": table.keys(),
	}


const DAT_00054_BLOCK_B_PATH := "res://hellcats/tests/fixtures/dat_00054_block_b_fixed_slots.json"
static var _00054_block_b: Array = []
static var _00054_block_b_loaded: bool = false


## Load FUN_00000054 Block B fixed-slot records (16× 0x1A/0x20 → DAT_0001b538…1b574).
static func load_00054_block_b_records() -> Array:
	if _00054_block_b_loaded and _00054_block_b.size() == 16:
		return _00054_block_b.duplicate(true)
	_00054_block_b = []
	if FileAccess.file_exists(DAT_00054_BLOCK_B_PATH):
		var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(DAT_00054_BLOCK_B_PATH))
		if typeof(parsed) == TYPE_DICTIONARY:
			var recs: Array = (parsed as Dictionary).get("records", []) as Array
			if recs.size() == 16:
				_00054_block_b = recs
				_00054_block_b_loaded = true
				return _00054_block_b.duplicate(true)
	_00054_block_b_loaded = false
	return []


## [RECONSTRUCTED] FUN_00000054 Block B one slot (Capstone @0xA2+): alloc nbytes → *(A5+off)=ptr.
## A5=$1B524; slot_abs = A5+off. Copy body deferred (bytes_hex retained).
static func apply_00054_block_b_slot(
	record: Dictionary,
	heap_state: Dictionary,
	fixed_slots: Dictionary
) -> Dictionary:
	var nbytes: int = int(record.get("size", 0x1A))
	var alloc: Dictionary = apply_01a68_alloc(nbytes, heap_state)
	if not bool(alloc.get("ok", false)):
		return {"ok": false, "alloc": alloc}
	var ptr: int = int(alloc.get("payload_ptr", 0))
	var slot_abs: int = int(record.get("slot_abs", 0))
	var a5_off: int = int(record.get("a5_offset", 0))
	fixed_slots[slot_abs] = ptr
	return {
		"ok": true,
		"alloc": alloc,
		"slot_abs": slot_abs,
		"a5_offset": a5_off,
		"block_ptr": ptr,
		"record_size": nbytes,
		"bytes_hex": str(record.get("bytes_hex", "")),
		"src_offset": str(record.get("file_offset", "")),
	}


## [RECONSTRUCTED] FUN_00000054 Block B ×16 (binary @0xA2–0x252).
## Publishes DAT_0001b538…1b574 incl. DAT_0001b540 (115b0 handle+4 source).
static func apply_00054_block_b(heap_state: Dictionary, fixed_slots: Dictionary) -> Dictionary:
	var recs: Array = load_00054_block_b_records()
	var steps: Array = []
	for rec in recs:
		if not (rec is Dictionary):
			break
		steps.append(apply_00054_block_b_slot(rec as Dictionary, heap_state, fixed_slots))
	return {
		"ok": steps.size() == 16,
		"steps": steps,
		"record_count": steps.size(),
		"slot_abs_list": fixed_slots.keys(),
		"dat_0001b540": int(fixed_slots.get(0x1B540, 0)),
	}


const DAT_00054_BLOCK_C_PATH := "res://hellcats/tests/fixtures/dat_00054_block_c_keyed_1c.json"
static var _00054_block_c: Array = []
static var _00054_block_c_loaded: bool = false


## Load FUN_00000054 Block C 5×0x1C keyed records (file 0x1aa5e).
static func load_00054_block_c_records() -> Array:
	if _00054_block_c_loaded and _00054_block_c.size() == 5:
		return _00054_block_c.duplicate(true)
	_00054_block_c = []
	if FileAccess.file_exists(DAT_00054_BLOCK_C_PATH):
		var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(DAT_00054_BLOCK_C_PATH))
		if typeof(parsed) == TYPE_DICTIONARY:
			var recs: Array = (parsed as Dictionary).get("records", []) as Array
			if recs.size() == 5:
				_00054_block_c = recs
				_00054_block_c_loaded = true
				return _00054_block_c.duplicate(true)
	_00054_block_c_loaded = false
	return []


## [RECONSTRUCTED] FUN_00000054 Block C one record (binary @0x256–0x2A2).
## alloc 0x1C → publish DAT_0001b524[sign_extend(key)] (same as Block A).
static func apply_00054_block_c_record(
	record: Dictionary,
	heap_state: Dictionary,
	table: Dictionary
) -> Dictionary:
	var alloc: Dictionary = apply_01a68_alloc(0x1C, heap_state)
	if not bool(alloc.get("ok", false)):
		return {"ok": false, "alloc": alloc}
	var ptr: int = int(alloc.get("payload_ptr", 0))
	var pub: Dictionary = apply_00054_publish_slot(table, int(record.get("key", 0)), ptr)
	return {
		"ok": true,
		"alloc": alloc,
		"publish": pub,
		"record_size": 0x1C,
		"bytes_hex": str(record.get("bytes_hex", "")),
		"src_offset": str(record.get("file_offset", "")),
	}


## [RECONSTRUCTED] FUN_00000054 Block C ×5: records @0x1AA5E step 0x1C → 1b524[key].
static func apply_00054_block_c(heap_state: Dictionary, table: Dictionary) -> Dictionary:
	var recs: Array = load_00054_block_c_records()
	var steps: Array = []
	for rec in recs:
		if not (rec is Dictionary):
			break
		steps.append(apply_00054_block_c_record(rec as Dictionary, heap_state, table))
	return {
		"ok": steps.size() == 5,
		"steps": steps,
		"record_count": steps.size(),
		"table_keys": table.keys(),
	}


const DAT_00054_BLOCK_D_PATH := "res://hellcats/tests/fixtures/dat_00054_block_d_fixed_slots.json"
static var _00054_block_d: Array = []
static var _00054_block_d_loaded: bool = false


## Load FUN_00000054 Block D fixed-slot records (5×0x1A → DAT_0001b58c…1b59c).
static func load_00054_block_d_records() -> Array:
	if _00054_block_d_loaded and _00054_block_d.size() == 5:
		return _00054_block_d.duplicate(true)
	_00054_block_d = []
	if FileAccess.file_exists(DAT_00054_BLOCK_D_PATH):
		var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(DAT_00054_BLOCK_D_PATH))
		if typeof(parsed) == TYPE_DICTIONARY:
			var recs: Array = (parsed as Dictionary).get("records", []) as Array
			if recs.size() == 5:
				_00054_block_d = recs
				_00054_block_d_loaded = true
				return _00054_block_d.duplicate(true)
	_00054_block_d_loaded = false
	return []


## [RECONSTRUCTED] FUN_00000054 Block D ×5 (binary @0x2A4–0x332).
## Same pattern as Block B; A5 offsets +0x68…+0x78 → DAT_0001b58c…1b59c.
static func apply_00054_block_d(heap_state: Dictionary, fixed_slots: Dictionary) -> Dictionary:
	var recs: Array = load_00054_block_d_records()
	var steps: Array = []
	for rec in recs:
		if not (rec is Dictionary):
			break
		## Reuse Block B slot publisher (alloc nbytes → fixed_slots[slot_abs]).
		steps.append(apply_00054_block_b_slot(rec as Dictionary, heap_state, fixed_slots))
	return {
		"ok": steps.size() == 5,
		"steps": steps,
		"record_count": steps.size(),
		"slot_abs_list": fixed_slots.keys(),
		"dat_0001b58c": int(fixed_slots.get(0x1B58C, 0)),
		"dat_0001b59c": int(fixed_slots.get(0x1B59C, 0)),
	}


## [RECONSTRUCTED] FUN_00001a68 entry: small freelist/01974 or large/0199a.
static func apply_01a68_alloc(request: int, state: Dictionary) -> Dictionary:
	var route: Dictionary = apply_01a68_route(request)
	if bool(route.get("use_small_bins", false)):
		return apply_01a68_small_alloc(request, state)
	return apply_01a68_large_alloc(request, state)


## [RECONSTRUCTED] FUN_00004e6e kind-2 01a48 size (Capstone @0x4EC4–0x4ED6).
## bytes = (s16(obj+0x36) + s16(obj+0x3a)) * 0xC — pushed before both 01a48 calls.
static func apply_04e6e_kind2_alloc_bytes(field_36: int, field_3a: int) -> int:
	return (_to_s16(field_36) + _to_s16(field_3a)) * 0xC


## [RECONSTRUCTED] FUN_00004e6e kind-3 plan (Capstone @0x5072–0x5106; decomp ~5605–5627).
## Publish to d4a4; child table = same layout as 016e2; then 046da(obj,i,i) per child.
static func apply_04e6e_kind3_plan(field_2e: int) -> Dictionary:
	var count: int = _to_s16(field_2e)
	if count < 0:
		count = 0
	return {
		"to_d4a4": true,
		"count": count,
		"table_bytes": apply_016e2_child_table_bytes(count),
		"call_046da_per_child": true,
		"call_03b98": true,
	}


## [RECONSTRUCTED] FUN_00004808 main buffer size (5278–5280; Capstone @0x4814–0x483A).
## bytes = field_3a*0x20; if (obj+6)&2: += field_3a*6 + field_38*2.
static func apply_04808_buffer_bytes(field_3a: int, field_38: int, byte_06: int) -> int:
	var n: int = _to_s16(field_3a) * 0x20
	if (byte_06 & 2) != 0:
		n += _to_s16(field_3a) * 6 + _to_s16(field_38) * 2
	return n


## [RECONSTRUCTED] FUN_00004808 one poly record @ stride 0x20 (Capstone @0x4858–0x4898).
## desc: byte offsets in the source stream (param_2).
## Writes: +8=0; +0xc=u32@0; +0x10..13=bytes@4..7; +0x14=u16(byte@8);
## +0x16=byte9&0xf0; +0x17=byte9&0x0f; +0x1c=u32@0xa; +0x18←index ptr (01a68).
static func apply_04808_poly_record(desc: Dictionary) -> Dictionary:
	var b9: int = int(desc.get(9, 0)) & 0xFF
	var count: int = int(desc.get(8, 0)) & 0xFF
	return {
		"rec_u32_08": 0,
		"rec_u32_0c": int(desc.get(0, 0)) & 0xFFFFFFFF,
		"rec_u8_10": int(desc.get(4, 0)) & 0xFF,
		"rec_u8_11": int(desc.get(5, 0)) & 0xFF,
		"rec_u8_12": int(desc.get(6, 0)) & 0xFF,
		"rec_u8_13": int(desc.get(7, 0)) & 0xFF,
		"rec_u16_14": count,
		"rec_u8_16": b9 & 0xF0,
		"rec_u8_17": b9 & 0x0F,
		"rec_u32_1c": int(desc.get(0x0A, 0)) & 0xFFFFFFFF,
		"index_count": count,
		"stride": 0x20,
	}


## [RECONSTRUCTED] FUN_00004808 index heap size (Capstone @0x48A2–0x48AA).
## bytes = s16(count) << 1  — count is poly+0x14 (= desc byte@8).
static func apply_04808_index_alloc_bytes(count: int) -> int:
	return _to_s16(count) << 1


## [RECONSTRUCTED] FUN_00004808 index-word copy (Capstone @0x48B8–0x48CE).
## src_words: u16 values from desc stream @+0x0E; dest length = count.
## Returns normalized u16 list (no heap). Pointer install is SimCore's mock 01a68.
static func apply_04808_index_words(src_words: Array, count: int = -1) -> Dictionary:
	var n: int = count if count >= 0 else src_words.size()
	n = _to_s16(n)
	if n < 0:
		n = 0
	var out: Array = []
	for i in range(n):
		var w: int = 0
		if i < src_words.size():
			w = int(src_words[i]) & 0xFFFF
		out.append(w)
	return {
		"index_count": n,
		"alloc_bytes": apply_04808_index_alloc_bytes(n),
		"words": out,
		"rec_offset_18": 0x18,
		"stream_advance": apply_04808_stream_advance(n),
	}


## [RECONSTRUCTED] FUN_00004808 desc cursor advance after one poly (5297–5302).
## advance = 0x0E + count*2 (header through index words).
static func apply_04808_stream_advance(index_count: int) -> int:
	return 0x0E + _to_s16(index_count) * 2


## [RECONSTRUCTED] FUN_00004808 (obj+6)&2 trailer (5306–5311).
## After poly array: at buf+field_3a*0x20 write u16 words 0 .. field_38-1.
static func apply_04808_bit1_trailer(field_3a: int, field_38: int, byte_06: int) -> Dictionary:
	var enabled: bool = (byte_06 & 2) != 0
	var n: int = _to_s16(field_38) if enabled else 0
	if n < 0:
		n = 0
	var words: Array = []
	if enabled:
		for i in range(n):
			words.append(i & 0xFFFF)
	return {
		"enabled": enabled,
		"trailer_offset": _to_s16(field_3a) * 0x20,
		"word_count": n,
		"words": words,
	}


## [RECONSTRUCTED] FUN_00004808 poly loop (5284–5305; Capstone @0x4858–0x48E4).
## polys: Array of { "desc": Dictionary, "words": Array }. Bound = field_3a; stride 0x20.
## [DEFERRED] real 01a68 per poly.
static func apply_04808_poly_loop(polys: Array, field_3a: int) -> Dictionary:
	var n: int = _to_s16(field_3a)
	if n < 0:
		n = 0
	var records: Array = []
	var stream_off: int = 0
	var limit: int = mini(n, polys.size())
	for i in range(limit):
		var entry = polys[i]
		var desc: Dictionary = {}
		var words: Array = []
		if entry is Dictionary:
			desc = entry.get("desc", {})
			words = entry.get("words", [])
		var rec: Dictionary = apply_04808_poly_record(desc)
		var idx: Dictionary = apply_04808_index_words(words, int(rec.get("index_count", 0)))
		var adv: int = int(idx.get("stream_advance", 0))
		records.append({
			"index": i,
			"rec_base": i * 0x20,
			"stream_offset": stream_off,
			"record": rec,
			"index_words": idx,
			"stream_advance": adv,
		})
		stream_off += adv
	return {
		"poly_count": n,
		"filled": records.size(),
		"stride": 0x20,
		"records": records,
		"stream_end": stream_off,
	}


## [RECONSTRUCTED] FUN_00004e6e → 15762 angle args (5669–5682).
## If handle==0 or type_key=**(s16**)(handle+4) outside [0x15,0x19] → all zeros;
## else shorts from handle+0x34/+0x36/+0x38/+0x40 → 15762(param_2..5).
static func apply_04e6e_15762_args(
	handle_ptr: int,
	type_key_s16: int,
	handle_34: int,
	handle_36: int,
	handle_38: int,
	handle_40: int
) -> Dictionary:
	var key: int = _to_s16(type_key_s16)
	var zeroed: bool = handle_ptr == 0 or key < 0x15 or key > 0x19
	if zeroed:
		return {
			"ok": true,
			"zeroed": true,
			"type_key": key,
			"param_2": 0,
			"param_3": 0,
			"param_4": 0,
			"param_5": 0,
		}
	return {
		"ok": true,
		"zeroed": false,
		"type_key": key,
		"param_2": _to_s16(handle_34),
		"param_3": _to_s16(handle_36),
		"param_4": _to_s16(handle_38),
		"param_5": _to_s16(handle_40),
	}


## [RECONSTRUCTED] FUN_00015762 entry plan (19920–19928) + 02976 (19927).
## tpl stream count = *(s16*)(tpl+0x1a)+*(s16*)(tpl+0x1e); 0253e(p2,p3,p4);
## then 02976(count, tpl+0x22, local_1e94, matrix). Nested 02bd8 is both-aux
## (19928): apply_02bd8_both_aux_walk — wired by SimCore after this plan.
## src_vecs12_xyz: flat s16 triples from 0xC records at +2/+6/+10 (length ≥ 3*count).
static func apply_15762_entry_plan(
	tpl: int,
	s16_1a: int,
	s16_1e: int,
	param_2: int,
	param_3: int,
	param_4: int,
	param_5: int,
	src_vecs12_xyz: Array = []
) -> Dictionary:
	var n: int = _to_s16(s16_1a) + _to_s16(s16_1e)
	var stream: int = (tpl + 0x22 + n * 0xC) & 0xFFFFFFFF if tpl != 0 else 0
	var mat: Array = fun_0000253e(param_2, param_3, param_4)
	var xform: Dictionary = {}
	var applied_02976: bool = false
	if n > 0 and src_vecs12_xyz.size() >= n * 3:
		xform = fun_00002976(n, src_vecs12_xyz, mat)
		applied_02976 = true
	return {
		"ok": tpl != 0,
		"tpl": tpl & 0xFFFFFFFF,
		"count_1a_1e": n,
		"poly_stream": stream,
		"param_5": _to_s16(param_5),
		"matrix9": mat,
		"applied_0253e": true,
		"applied_02976": applied_02976,
		"local_1e94": xform.get("xyz", []),
		"applied_02bd8": false,
		"deferred_02bd8": true,
	}


## [RECONSTRUCTED] FUN_00015762 local_3324 relative copy (19929–19942).
## For i in 0..count_1e-1: local_3324[i] = local_1e94[i+count_1a] - local_1e94[0].
static func apply_15762_local_3324_rel(
	local_1e94: Array, count_1a: int, count_1e: int
) -> Dictionary:
	var n1a: int = _to_s16(count_1a)
	var n1e: int = _to_s16(count_1e)
	var out: Array = []
	if n1e <= 0:
		return {"ok": true, "count_1e": n1e, "xyz": out, "applied": false}
	var ox: int = int(local_1e94[0]) if local_1e94.size() > 0 else 0
	var oy: int = int(local_1e94[1]) if local_1e94.size() > 1 else 0
	var oz: int = int(local_1e94[2]) if local_1e94.size() > 2 else 0
	for i in range(n1e):
		var src: int = (i + n1a) * 3
		var x: int = int(local_1e94[src]) if src < local_1e94.size() else 0
		var y: int = int(local_1e94[src + 1]) if src + 1 < local_1e94.size() else 0
		var z: int = int(local_1e94[src + 2]) if src + 2 < local_1e94.size() else 0
		out.append(_to_s32(x - ox))
		out.append(_to_s32(y - oy))
		out.append(_to_s32(z - oz))
	return {"ok": true, "count_1e": n1e, "xyz": out, "applied": true}


## [RECONSTRUCTED] FUN_00015762 bias first count_1a verts (19944–19958).
## BE low-16 of each int32: x -= (field_18<<sh); y -= (param_5<<sh); z -= (field_20<<sh).
## sh = field_34 & 0x3f. Mutates a duplicate of local_1e94.
static func apply_15762_bias_1a_low16(
	local_1e94: Array,
	count_1a: int,
	field_18: int,
	field_20: int,
	param_5: int,
	field_34: int
) -> Dictionary:
	var n1a: int = _to_s16(count_1a)
	var sh: int = _to_s16(field_34) & 0x3F
	## C: (short)(field<<sh) — low 16 of shifted int32.
	var dx: int = _to_s16(((field_18 << sh) & 0xFFFFFFFF) & 0xFFFF)
	var dy: int = _to_s16(((_to_s16(param_5) << sh) & 0xFFFFFFFF) & 0xFFFF)
	var dz: int = _to_s16(((field_20 << sh) & 0xFFFFFFFF) & 0xFFFF)
	var out: Array = local_1e94.duplicate()
	if n1a <= 0:
		return {
			"ok": true,
			"count_1a": n1a,
			"xyz": out,
			"applied": false,
			"shift": sh,
			"dx": dx,
			"dy": dy,
			"dz": dz,
		}
	for i in range(n1a):
		var base: int = i * 3
		if base + 2 >= out.size():
			break
		out[base] = _be_int_sub_low16(int(out[base]), dx)
		out[base + 1] = _be_int_sub_low16(int(out[base + 1]), dy)
		out[base + 2] = _be_int_sub_low16(int(out[base + 2]), dz)
	return {
		"ok": true,
		"count_1a": n1a,
		"xyz": out,
		"applied": true,
		"shift": sh,
		"dx": dx,
		"dy": dy,
		"dz": dz,
	}


## BE int32: subtract delta from the low 16-bit half (short at +2), keep high half.
static func _be_int_sub_low16(value: int, delta_s16: int) -> int:
	var v: int = value & 0xFFFFFFFF
	var lo: int = _to_s16(v & 0xFFFF) - _to_s16(delta_s16)
	return _to_s32((v & 0xFFFF0000) | (lo & 0xFFFF))


## [RECONSTRUCTED] FUN_00004e6e → 04958 call-site args (5686).
## Fixed immediates: param_2=0xb4e1, param_3=0, param_4=0x7fe4.
static func apply_04e6e_04958_args() -> Dictionary:
	return {
		"ok": true,
		"param_2": 0xB4E1,
		"param_3": 0,
		"param_4": 0x7FE4,
	}


## [RECONSTRUCTED] FUN_00004958 entry local_1be4 rel (5378–5392).
## Same shape as 15762 local_3324: for i in 0..field_3a-1,
## local_1be4[i] = verts[i+field_36] - verts[0] (int32×3 at obj+0x44).
static func apply_04958_entry_rel(
	verts_xyz: Array, field_36: int, field_3a: int
) -> Dictionary:
	var rel: Dictionary = apply_15762_local_3324_rel(verts_xyz, field_36, field_3a)
	return {
		"ok": true,
		"local_1be4": rel.get("xyz", []),
		"count_3a": _to_s16(field_3a),
		"base_36": _to_s16(field_36),
		"applied": bool(rel.get("applied", false)),
	}


## [RECONSTRUCTED] FUN_00004958 poly_stream tip (5394–5395).
## stream = tpl+0x22 + (*(s16*)(tpl+0x1a)+*(s16*)(tpl+0x1e))*0xC
## (decomp: (uint*)(tpl+0x22) + 1a*3 + 1e*3 → same byte offset).
static func apply_04958_poly_stream(tpl: int, s16_1a: int, s16_1e: int) -> Dictionary:
	var n: int = _to_s16(s16_1a) + _to_s16(s16_1e)
	var stream: int = (tpl + 0x22 + n * 0xC) & 0xFFFFFFFF if tpl != 0 else 0
	return {"ok": tpl != 0, "tpl": tpl & 0xFFFFFFFF, "count_1a_1e": n, "poly_stream": stream}


## [RECONSTRUCTED] FUN_00004916 (5319–5337).
## For i in 0..field_3a-1: *(poly+4)=*(s16*)(table+param_2*2); *(u8*)(poly+0xf)=0xff; poly+=0x20.
static func apply_fun_00004916(
	field_3a: int, table_word_at_param2: int, param_2: int = 0x80
) -> Dictionary:
	var n: int = _to_s16(field_3a)
	var word: int = _to_s16(table_word_at_param2)
	var slots: Array = []
	for _i in range(maxi(n, 0)):
		slots.append({"field_4": word, "field_0f": 0xFF})
	return {
		"ok": true,
		"count": maxi(n, 0),
		"param_2_index": param_2,
		"slots": slots,
		"applied": n > 0,
	}


## [RECONSTRUCTED] FUN_00003c68 (Capstone @0x3C68–0x3CC0).
## Six stack longs: (x0,y0,z0,x1,y1,z1) → abs-delta metric
##   a=|x1-x0|, b=|y1-y0|, c=|z1-z0|; return max + ((sum of other two)>>2).
## Abs via LEA $2DE8 (false entry) ≡ FUN_00002e08. Twin of 03c00 but pairwise.
static func fun_00003c68(
	x0: int, y0: int, z0: int, x1: int, y1: int, z1: int
) -> int:
	var a: int = fun_00002e08(_to_s32(x1) - _to_s32(x0))
	var b: int = fun_00002e08(_to_s32(y1) - _to_s32(y0))
	var c: int = fun_00002e08(_to_s32(z1) - _to_s32(z0))
	return int(apply_fun_00003b98(a, b, c).get("metric", 0))


## [RECONSTRUCTED] FUN_00004958 project one xz pair (5410–5415).
## out_x = (vert_x - DAT_0001d724) >> (param_3 & 0x3f)
## out_z = (vert_z - DAT_0001d71c) >> (param_3 & 0x3f)  — uses components 0 and 2.
static func apply_04958_project_xz(
	vert_x: int, vert_z: int, dat_724: int, dat_71c: int, param_3: int
) -> Dictionary:
	var sh: int = param_3 & 0x3F
	return {
		"x": _to_s32((vert_x - dat_724) >> sh),
		"z": _to_s32((vert_z - dat_71c) >> sh),
		"shift": sh,
	}


## [RECONSTRUCTED] FUN_00004958 poly stream header (5405 / 5493; matches 04808 desc).
## count = *(u8*)(stream+8); indices = s16[count] at stream+0xe; next = stream+0xe+count*2.
static func apply_04958_poly_stream_header(stream: int, index_count: int) -> Dictionary:
	var n: int = index_count & 0xFF
	return {
		"stream": stream & 0xFFFFFFFF,
		"index_count": n,
		"indices_off": 0x0E,
		"next_stream": (stream + 0x0E + n * 2) & 0xFFFFFFFF,
	}


## [RECONSTRUCTED] FUN_00004958 poly index walk + 03c68 thinning (5402–5462; Capstone @0x4AAE).
## First index always emitted. Later: edge=03c68(prev,cur); acc+=edge;
## cam=03c68(cam_xz,cur); accept if cam/(phase_a8+3) <= acc (then acc←0).
## y components pushed as 0 at call site. pair_count<3 → cull.
static func apply_04958_poly_pairs(
	au_stack_15e4: Array,
	index_words: Array,
	dat_724: int,
	dat_71c: int,
	param_3: int,
	cam_x: int = 0,
	cam_z: int = 0,
	phase_a8: int = 0
) -> Dictionary:
	var n: int = index_words.size()
	var pairs: Array = []
	var accepted: Array = []
	var acc: int = 0
	var prev_x: int = 0
	var prev_z: int = 0
	var denom: int = _to_s16(phase_a8) + 3
	if denom == 0:
		denom = 1
	for i in range(n):
		var idx: int = _to_s16(int(index_words[i]))
		var base: int = idx * 3
		var vx: int = int(au_stack_15e4[base]) if base < au_stack_15e4.size() else 0
		var vz: int = int(au_stack_15e4[base + 2]) if base + 2 < au_stack_15e4.size() else 0
		var take: bool = i == 0
		var edge: int = 0
		var cam_m: int = 0
		if not take:
			edge = fun_00003c68(prev_x, 0, prev_z, vx, 0, vz)
			acc = acc + edge
			cam_m = fun_00003c68(cam_x, 0, cam_z, vx, 0, vz)
			## Capstone: if cam_m / (a8+3) <= acc → accept
			take = _div_trunc(cam_m, denom) <= acc
		if take:
			acc = 0
			prev_x = vx
			prev_z = vz
			var proj: Dictionary = apply_04958_project_xz(vx, vz, dat_724, dat_71c, param_3)
			pairs.append({"x": int(proj.get("x", 0)), "z": int(proj.get("z", 0))})
			accepted.append({
				"index": idx,
				"edge": edge,
				"cam_metric": cam_m,
				"vert_x": vx,
				"vert_z": vz,
			})
	var pair_count: int = pairs.size()
	var cull: bool = pair_count < 3
	return {
		"ok": true,
		"deferred_03c68": false,
		"pair_count": pair_count,
		"pairs": pairs,
		"accepted": accepted,
		"cull": cull,
		"flag_or_13": 2 if cull else 0,
		"index_count": n,
		"denom": denom,
	}


## Alias kept for older unit tests — delegates to apply_04958_poly_pairs.
static func apply_04958_poly_pairs_simple(
	au_stack_15e4: Array,
	index_words: Array,
	dat_724: int,
	dat_71c: int,
	param_3: int
) -> Dictionary:
	return apply_04958_poly_pairs(
		au_stack_15e4, index_words, dat_724, dat_71c, param_3, 0, 0, 0
	)


## [RECONSTRUCTED] FUN_0000b190 (10308–10366; Capstone @0xB190).
## Sutherland-style clip of closed xz ring against x == clip_plane (DAT_00020aee).
## pairs: [{x,z}, …] count>=1; returns output pairs + count (byte_delta>>3).
static func fun_0000b190(pairs: Array, clip_plane: int) -> Dictionary:
	var n: int = pairs.size()
	var out: Array = []
	if n == 0:
		return {"count": 0, "pairs": out, "clip_plane": clip_plane}
	var plane: int = _to_s32(clip_plane)
	for i in range(n):
		var cur: Dictionary = pairs[i] as Dictionary
		var prev: Dictionary = pairs[(i - 1 + n) % n] as Dictionary
		## Decomp walks with piVar7 = previous; first iter uses last vertex.
		var cx: int = int(cur.get("x", 0))
		var cz: int = int(cur.get("z", 0))
		var px: int = int(prev.get("x", 0))
		var pz: int = int(prev.get("z", 0))
		if cx < plane:
			if plane <= px:
				## Entering from outside←inside along edge prev→cur? decomp: curr out, prev in.
				var dx: int = px - cx
				var iz: int = cz
				if dx != 0:
					iz = cz + _div_trunc((pz - cz) * (plane - cx), dx)
				out.append({"x": plane, "z": _to_s32(iz)})
		else:
			if px < plane:
				## curr in, prev out — emit intersection then current.
				var dx2: int = cx - px
				var iz2: int = pz
				if dx2 != 0:
					iz2 = pz + _div_trunc((cz - pz) * (plane - px), dx2)
				out.append({"x": plane, "z": _to_s32(iz2)})
				out.append({"x": cx, "z": cz})
			else:
				out.append({"x": cx, "z": cz})
	return {
		"count": out.size(),
		"pairs": out,
		"clip_plane": plane,
	}


## [RECONSTRUCTED] 04958 post-pairs: if count>=3, b190 against plane=-param_4 (5430–5431).
## Returns updated pairs/count; cull if b190 yields 0. b242+ deferred.
static func apply_04958_clip_b190(pairs_result: Dictionary, param_4: int) -> Dictionary:
	var pair_count: int = int(pairs_result.get("pair_count", 0))
	var pairs: Array = pairs_result.get("pairs", []) as Array
	var r: Dictionary = pairs_result.duplicate(true)
	r["applied_b190"] = false
	r["deferred_b242"] = false
	if pair_count < 3:
		return r
	var plane: int = -_to_s16(param_4)
	var clipped: Dictionary = fun_0000b190(pairs, plane)
	var n_out: int = int(clipped.get("count", 0))
	r["applied_b190"] = true
	r["b190"] = clipped
	r["clip_plane_b190"] = plane
	r["pairs"] = clipped.get("pairs", [])
	r["pair_count"] = n_out
	if n_out == 0:
		r["cull"] = true
		r["flag_or_13"] = 2
	else:
		r["cull"] = false
		r["flag_or_13"] = 0
		r["deferred_b242"] = true
	return r


## [RECONSTRUCTED] FUN_0000b242 (10371–10429; Capstone @0xB242).
## Mirror of b190: closed xz ring clip keep x <= clip_plane (DAT_00020aec).
static func fun_0000b242(pairs: Array, clip_plane: int) -> Dictionary:
	var n: int = pairs.size()
	var out: Array = []
	if n == 0:
		return {"count": 0, "pairs": out, "clip_plane": clip_plane}
	var plane: int = _to_s32(clip_plane)
	for i in range(n):
		var cur: Dictionary = pairs[i] as Dictionary
		var prev: Dictionary = pairs[(i - 1 + n) % n] as Dictionary
		var cx: int = int(cur.get("x", 0))
		var cz: int = int(cur.get("z", 0))
		var px: int = int(prev.get("x", 0))
		var pz: int = int(prev.get("z", 0))
		if plane < cx:
			if px <= plane:
				## curr out (x>plane), prev in — emit intersection.
				var dx: int = px - cx
				var iz: int = cz
				if dx != 0:
					iz = cz + _div_trunc((pz - cz) * (plane - cx), dx)
				out.append({"x": plane, "z": _to_s32(iz)})
		else:
			if plane < px:
				## curr in, prev out — emit intersection then current.
				var dx2: int = cx - px
				var iz2: int = pz
				if dx2 != 0:
					iz2 = pz + _div_trunc((cz - pz) * (plane - px), dx2)
				out.append({"x": plane, "z": _to_s32(iz2)})
				out.append({"x": cx, "z": cz})
			else:
				out.append({"x": cx, "z": cz})
	return {
		"count": out.size(),
		"pairs": out,
		"clip_plane": plane,
	}


## [RECONSTRUCTED] 04958 after b190: if count!=0 → b242 plane=param_4 (5437–5438).
## Cull if b242 yields 0. b2f4+ deferred.
static func apply_04958_clip_b242(pairs_result: Dictionary, param_4: int) -> Dictionary:
	var r: Dictionary = pairs_result.duplicate(true)
	r["applied_b242"] = false
	r["deferred_b2f4"] = false
	if not bool(r.get("deferred_b242", false)):
		return r
	var pairs: Array = r.get("pairs", []) as Array
	var plane: int = _to_s16(param_4)
	var clipped: Dictionary = fun_0000b242(pairs, plane)
	var n_out: int = int(clipped.get("count", 0))
	r["applied_b242"] = true
	r["deferred_b242"] = false
	r["b242"] = clipped
	r["clip_plane_b242"] = plane
	r["pairs"] = clipped.get("pairs", [])
	r["pair_count"] = n_out
	if n_out == 0:
		r["cull"] = true
		r["flag_or_13"] = 2
	else:
		r["cull"] = false
		r["flag_or_13"] = 0
		r["deferred_b2f4"] = true
	return r


## [RECONSTRUCTED] FUN_0000b2f4 (10434–10483; Capstone @0xB2F4).
## Closed xz ring clip keep z >= clip_plane (DAT_00020aea).
static func fun_0000b2f4(pairs: Array, clip_plane: int) -> Dictionary:
	var n: int = pairs.size()
	var out: Array = []
	if n == 0:
		return {"count": 0, "pairs": out, "clip_plane": clip_plane}
	var plane: int = _to_s32(clip_plane)
	for i in range(n):
		var cur: Dictionary = pairs[i] as Dictionary
		var prev: Dictionary = pairs[(i - 1 + n) % n] as Dictionary
		var cx: int = int(cur.get("x", 0))
		var cz: int = int(cur.get("z", 0))
		var px: int = int(prev.get("x", 0))
		var pz: int = int(prev.get("z", 0))
		if cz < plane:
			if plane <= pz:
				## curr out (z<plane), prev in — emit intersection at z=plane.
				var dz: int = pz - cz
				var ix: int = cx
				if dz != 0:
					ix = cx + _div_trunc((px - cx) * (plane - cz), dz)
				out.append({"x": _to_s32(ix), "z": plane})
		else:
			if pz < plane:
				## curr in, prev out — emit intersection then current.
				var dz2: int = cz - pz
				var ix2: int = px
				if dz2 != 0:
					ix2 = px + _div_trunc((cx - px) * (plane - pz), dz2)
				out.append({"x": _to_s32(ix2), "z": plane})
				out.append({"x": cx, "z": cz})
			else:
				out.append({"x": cx, "z": cz})
	return {
		"count": out.size(),
		"pairs": out,
		"clip_plane": plane,
	}


## [RECONSTRUCTED] 04958 after b242: if count!=0 → b2f4 plane=-param_4 (5444–5445).
## Cull if b2f4 yields 0. b3aa deferred.
static func apply_04958_clip_b2f4(pairs_result: Dictionary, param_4: int) -> Dictionary:
	var r: Dictionary = pairs_result.duplicate(true)
	r["applied_b2f4"] = false
	r["deferred_b3aa"] = false
	if not bool(r.get("deferred_b2f4", false)):
		return r
	var pairs: Array = r.get("pairs", []) as Array
	var plane: int = -_to_s16(param_4)
	var clipped: Dictionary = fun_0000b2f4(pairs, plane)
	var n_out: int = int(clipped.get("count", 0))
	r["applied_b2f4"] = true
	r["deferred_b2f4"] = false
	r["b2f4"] = clipped
	r["clip_plane_b2f4"] = plane
	r["pairs"] = clipped.get("pairs", [])
	r["pair_count"] = n_out
	if n_out == 0:
		r["cull"] = true
		r["flag_or_13"] = 2
	else:
		r["cull"] = false
		r["flag_or_13"] = 0
		r["deferred_b3aa"] = true
	return r


## [RECONSTRUCTED] FUN_0000b3aa (10488–10537; Capstone @0xB3AA).
## Mirror of b2f4: closed xz ring clip keep z <= clip_plane (DAT_0001b73e).
static func fun_0000b3aa(pairs: Array, clip_plane: int) -> Dictionary:
	var n: int = pairs.size()
	var out: Array = []
	if n == 0:
		return {"count": 0, "pairs": out, "clip_plane": clip_plane}
	var plane: int = _to_s32(clip_plane)
	for i in range(n):
		var cur: Dictionary = pairs[i] as Dictionary
		var prev: Dictionary = pairs[(i - 1 + n) % n] as Dictionary
		var cx: int = int(cur.get("x", 0))
		var cz: int = int(cur.get("z", 0))
		var px: int = int(prev.get("x", 0))
		var pz: int = int(prev.get("z", 0))
		if plane < cz:
			if pz <= plane:
				## curr out (z>plane), prev in — emit intersection at z=plane.
				var dz: int = pz - cz
				var ix: int = cx
				if dz != 0:
					ix = cx + _div_trunc((px - cx) * (plane - cz), dz)
				out.append({"x": _to_s32(ix), "z": plane})
		else:
			if plane < pz:
				## curr in, prev out — emit intersection then current.
				var dz2: int = cz - pz
				var ix2: int = px
				if dz2 != 0:
					ix2 = px + _div_trunc((cx - px) * (plane - pz), dz2)
				out.append({"x": _to_s32(ix2), "z": plane})
				out.append({"x": cx, "z": cz})
			else:
				out.append({"x": cx, "z": cz})
	return {
		"count": out.size(),
		"pairs": out,
		"clip_plane": plane,
	}


## [RECONSTRUCTED] 04958 after b2f4: if count!=0 → b3aa plane=param_4 (5451–5452).
## Final clip; cull if count 0. Surviving count → poly+0x14 deferred to caller.
static func apply_04958_clip_b3aa(pairs_result: Dictionary, param_4: int) -> Dictionary:
	var r: Dictionary = pairs_result.duplicate(true)
	r["applied_b3aa"] = false
	if not bool(r.get("deferred_b3aa", false)):
		return r
	var pairs: Array = r.get("pairs", []) as Array
	var plane: int = _to_s16(param_4)
	var clipped: Dictionary = fun_0000b3aa(pairs, plane)
	var n_out: int = int(clipped.get("count", 0))
	r["applied_b3aa"] = true
	r["deferred_b3aa"] = false
	r["b3aa"] = clipped
	r["clip_plane_b3aa"] = plane
	r["pairs"] = clipped.get("pairs", [])
	r["pair_count"] = n_out
	if n_out == 0:
		r["cull"] = true
		r["flag_or_13"] = 2
	else:
		r["cull"] = false
		r["flag_or_13"] = 0
		r["write_count_14"] = true
	return r


## [RECONSTRUCTED] FUN_00004e6e post-04958 follow-up (5687–5693).
## If *(s16*)(b5a0+0xe)==1 → 04916(obj,0x80); else 03ea0.
static func apply_04e6e_post_04958_followup(b5a0_field_0e: int) -> Dictionary:
	var v: int = _to_s16(b5a0_field_0e)
	var need_04916: bool = v == 1
	return {
		"b5a0_0e": v,
		"need_04916": need_04916,
		"need_03ea0": not need_04916,
		"path": "04916" if need_04916 else "03ea0",
	}


## [RECONSTRUCTED] FUN_00004e6e post-04808 path select (5653–5693).
## Priority: +6 bit4 → 04958; else +7 bit4 → 15762; else +5 bit4 → 01c5c; else 02bd8.
## 02bd8 and 01c5c paths both end at 0435a/03da8 then 03ea0 (LAB_00005056).
static func apply_04e6e_post_04808_path(byte_05: int, byte_06: int, byte_07: int) -> Dictionary:
	var b5: int = byte_05 & 0xFF
	var b6: int = byte_06 & 0xFF
	var b7: int = byte_07 & 0xFF
	var bit4_05: bool = (b5 & 0x10) != 0
	var bit4_06: bool = (b6 & 0x10) != 0
	var bit4_07: bool = (b7 & 0x10) != 0
	var path: String = "02bd8"
	if bit4_06:
		path = "04958"
	elif bit4_07:
		path = "15762"
	elif bit4_05:
		path = "01c5c"
	return {
		"path": path,
		"need_02bd8": path == "02bd8",
		"need_01c5c": path == "01c5c",
		"need_15762": path == "15762",
		"need_04958": path == "04958",
		"need_03ea0": path == "02bd8" or path == "01c5c",
		"bit4_05": bit4_05,
		"bit4_06": bit4_06,
		"bit4_07": bit4_07,
	}


## [RECONSTRUCTED] FUN_00004e6e post-04808 → 02bd8 flag gate (Capstone @0x4F4A/4F88/4FEE).
## need_02bd8 iff bit4 clear on obj+5, +6, and +7. Else alternate 01c5c / 0435a paths.
static func apply_04e6e_02bd8_gate(byte_05: int, byte_06: int, byte_07: int) -> Dictionary:
	var p: Dictionary = apply_04e6e_post_04808_path(byte_05, byte_06, byte_07)
	return {
		"need_02bd8": bool(p.get("need_02bd8", false)),
		"bit4_05": bool(p.get("bit4_05", false)),
		"bit4_06": bool(p.get("bit4_06", false)),
		"bit4_07": bool(p.get("bit4_07", false)),
		"path": str(p.get("path", "")),
	}


## [RECONSTRUCTED] FUN_00002bd8 call args from 04e6e (5653–5656; Capstone @0x502E–0x503A).
## (obj, s16(36)+s16(3a), mesh_base, *(obj+0x44)). Template-walk body still deferred.
static func apply_04e6e_02bd8_args(
	obj: int,
	field_36: int,
	field_3a: int,
	mesh_base: int,
	field_44: int
) -> Dictionary:
	return {
		"param_1_obj": obj & 0xFFFFFFFF,
		"param_2_count": _to_s16(field_36) + _to_s16(field_3a),
		"param_3_mesh": mesh_base & 0xFFFFFFFF,
		"param_4_verts": field_44 & 0xFFFFFFFF,
	}


## [RECONSTRUCTED] FUN_000044a4 type-5 flag tweak (5083–5089).
## When entity*(+8)!=0 and **(short**)(entity+4)==5:
##   mission_b0==0 → flags_04 |= 0x40; else flags_04 &= ~0x40.
static func apply_044a4_type5_flags(
	flags_04: int,
	entity_ptr: int,
	type_short: int,
	mission_b0: int
) -> Dictionary:
	if entity_ptr == 0 or _to_s16(type_short) != 5:
		return {
			"applied": false,
			"flags_04": flags_04 & 0xFFFFFFFF,
			"set_bit40": false,
		}
	var out: int = flags_04 & 0xFFFFFFFF
	var set_bit: bool = _to_s16(mission_b0) == 0
	if set_bit:
		out = out | 0x40
	else:
		out = out & ~0x40
	return {
		"applied": true,
		"flags_04": out & 0xFFFFFFFF,
		"set_bit40": set_bit,
	}


## [RECONSTRUCTED] FUN_0000435a template base iVar5 (5020–5022).
## tpl = *(b5a0+0x8c) + *( *(obj+0x24)+0x28 + 0x2e + (obj+1)*0x18 ).
static func apply_0435a_template_addr(
	b5a0_8c: int,
	parent_embed: int,
	obj_byte_01: int,
	raw_off: int
) -> Dictionary:
	var idx: int = obj_byte_01 & 0xFF
	var slot: int = parent_embed + 0x2E + idx * 0x18
	var ok: bool = b5a0_8c != 0 and parent_embed != 0
	return {
		"ok": ok,
		"slot_addr": slot & 0xFFFFFFFF,
		"index": idx,
		"template_ptr": (b5a0_8c + raw_off) & 0xFFFFFFFF if ok else 0,
	}


## [RECONSTRUCTED] FUN_0000435a outer gate (5018–5019).
## Enter body iff (obj+7)&2==0 and 0 < mission_phase_a8 < 6.
static func apply_0435a_gate(byte_07: int, mission_phase_a8: int) -> Dictionary:
	var phase: int = _to_s16(mission_phase_a8)
	var enter: bool = (byte_07 & 2) == 0 and phase > 0 and phase < 6
	return {"enter": enter, "phase_a8": phase}


## [RECONSTRUCTED] FUN_0000435a scale factor iVar4 (5023–5028).
## (obj+5)&2==0 → phase_a8-1; else 1.
static func apply_0435a_scale_factor(byte_05: int, mission_phase_a8: int) -> int:
	if (byte_05 & 2) == 0:
		return _to_s16(mission_phase_a8) - 1
	return 1


## [RECONSTRUCTED] FUN_0000435a +0xc update + kind2 clamp (5029–5046).
## Skip when field_0c==1000000000. scale_src = *(template+0xe).
## iVar4==0 → ASR-style half; else *iVar4. Kind2 clamp to 0x42B209 if >(and +6 bit4 clear).
static func apply_0435a_field_0c(
	field_0c_in: int,
	scale_src_0e: int,
	scale_factor: int,
	kind: int,
	byte_06: int
) -> Dictionary:
	const SENTINEL := 1000000000
	const CLAMP_42B209 := 0x42B209
	if field_0c_in == SENTINEL:
		return {
			"wrote": false,
			"field_0c": field_0c_in & 0xFFFFFFFF,
			"clamped": false,
		}
	var out_0c: int = 0
	if scale_factor == 0:
		var v: int = scale_src_0e
		if v < 0:
			v = v + 1
		out_0c = v >> 1
	else:
		out_0c = scale_src_0e * scale_factor
	var clamped: bool = false
	if (kind & 0xFF) == 2 and out_0c > CLAMP_42B209 and (byte_06 & 0x10) == 0:
		out_0c = CLAMP_42B209
		clamped = true
	return {
		"wrote": true,
		"field_0c": out_0c & 0xFFFFFFFF,
		"clamped": clamped,
		"scale_factor": scale_factor,
	}


## [RECONSTRUCTED] FUN_0000435a one poly +0x1c value (5056–5068).
## src = *(stream+10). Player → src*5; scale==0 → half; else src*scale.
static func apply_0435a_poly_1c_value(src_0a: int, scale_factor: int, is_player: bool) -> int:
	if is_player:
		return (src_0a + src_0a * 4) & 0xFFFFFFFF
	if scale_factor == 0:
		var v: int = src_0a
		if v < 0:
			v = v + 1
		return (v >> 1) & 0xFFFFFFFF
	return (src_0a * scale_factor) & 0xFFFFFFFF


## [RECONSTRUCTED] FUN_00004e6e → 04808 desc stream (5644–5647).
## desc = tpl + 0x22 + (*(s16*)(obj+0x36)+*(s16*)(obj+0x3a))*0xC.
static func apply_04e6e_04808_desc_addr(tpl: int, field_36: int, field_3a: int) -> Dictionary:
	var n: int = _to_s16(field_36) + _to_s16(field_3a)
	var off: int = 0x22 + n * 0xC
	return {
		"ok": tpl != 0,
		"count_36_3a": n,
		"offset": off & 0xFFFFFFFF,
		"desc_ptr": (tpl + off) & 0xFFFFFFFF,
	}


## [RECONSTRUCTED] FUN_0000435a poly stream base (5049).
## stream = tpl + 0x22 + *(s16*)(tpl+0x1a)*0xC + *(s16*)(tpl+0x1e)*0xC.
static func apply_0435a_poly_stream_base(tpl: int, s16_1a: int, s16_1e: int) -> Dictionary:
	var a: int = _to_s16(s16_1a)
	var e: int = _to_s16(s16_1e)
	var off: int = 0x22 + a * 0xC + e * 0xC
	return {
		"ok": tpl != 0,
		"offset": off & 0xFFFFFFFF,
		"stream_base": (tpl + off) & 0xFFFFFFFF,
		"s16_1a": a,
		"s16_1e": e,
	}


## [RECONSTRUCTED] FUN_0000435a stream step (5069): +0xE + *(u8*)(rec+8)*2.
static func apply_0435a_poly_stream_advance(stream: int, byte_08: int) -> int:
	return (stream + 0x0E + (byte_08 & 0xFF) * 2) & 0xFFFFFFFF


## [RECONSTRUCTED] FUN_0000435a kind2 param_2==0 poly +0x1c loop (5048–5071).
## srcs: per-poly *(stream+10). Writes stride 0x20 at buf+0x1c.
static func apply_0435a_poly_1c_loop(
	srcs: Array,
	field_3a: int,
	scale_factor: int,
	is_player: bool,
	param_2: int,
	kind: int
) -> Dictionary:
	if (kind & 0xFF) != 2 or param_2 != 0:
		return {"ran": false, "values": [], "count": 0}
	var n: int = _to_s16(field_3a)
	if n < 0:
		n = 0
	var values: Array = []
	var limit: int = mini(n, srcs.size())
	for i in range(limit):
		values.append(apply_0435a_poly_1c_value(int(srcs[i]), scale_factor, is_player))
	return {
		"ran": true,
		"values": values,
		"count": values.size(),
		"rec_offset_1c": 0x1C,
		"stride": 0x20,
		"is_player": is_player,
	}


## [RECONSTRUCTED] FUN_00004e6e after 02bd8 on kind2 fall-through (5657–5658).
## Always: FUN_0000435a(obj, 0); FUN_00003da8(obj, *(obj+0x10)).
static func apply_04e6e_post_02bd8_followup(obj: int, field_10: int) -> Dictionary:
	return {
		"need_0435a": true,
		"0435a_param_2": 0,
		"need_03da8": true,
		"03da8_param_2": field_10 & 0xFFFFFFFF,
		"obj": obj & 0xFFFFFFFF,
	}


## [RECONSTRUCTED] FUN_00003da8 (4675–4697).
## Band index at obj+0x30 vs DAT_0001b190[s]*4; DAT_0001b18c[s] ≡ table[s-1].
## If param_2 in [table[s-1], table[s]) → return 0 (no write). Else adjust s, write +0x30, return 1.
static func apply_fun_00003da8(field_30: int, param_2: int, table: Array) -> Dictionary:
	var s: int = _to_s16(field_30)
	var p2: int = param_2
	var changed: int = 1
	if table.is_empty() or s < 0 or s >= table.size():
		return {
			"ok": false,
			"changed": 0,
			"field_30": s & 0xFFFF,
			"return": 0,
		}
	var upper: int = int(table[s])
	if p2 < upper:
		var lower: int = int(table[s - 1]) if s > 0 else -0x80000000
		if lower <= p2:
			return {
				"ok": true,
				"changed": 0,
				"field_30": s & 0xFFFF,
				"return": 0,
			}
		s = s - 2
		while s >= 0 and p2 < int(table[s]):
			s = s - 1
		s = s + 1
	else:
		s = s + 1
		while s < table.size() and int(table[s]) <= p2:
			s = s + 1
	if s < 0:
		s = 0
	if s >= table.size():
		s = table.size() - 1
	return {
		"ok": true,
		"changed": changed,
		"field_30": s & 0xFFFF,
		"return": 1,
	}


## [RECONSTRUCTED] FUN_00001c5c (2313–2331).
## For count (low word) vec3s: dst = src + (dx,dy,dz). Same buffer allowed.
static func apply_fun_00001c5c(
	count: int,
	src_xyz: Array,
	add_x: int,
	add_y: int,
	add_z: int
) -> Dictionary:
	var n: int = _to_s16(count)
	if n < 0:
		n = 0
	var out: Array = []
	for i in range(n):
		var base: int = i * 3
		var x: int = int(src_xyz[base]) if base < src_xyz.size() else 0
		var y: int = int(src_xyz[base + 1]) if base + 1 < src_xyz.size() else 0
		var z: int = int(src_xyz[base + 2]) if base + 2 < src_xyz.size() else 0
		out.append((x + add_x) & 0xFFFFFFFF)
		out.append((y + add_y) & 0xFFFFFFFF)
		out.append((z + add_z) & 0xFFFFFFFF)
	return {"count": n, "xyz": out}


## [RECONSTRUCTED] FUN_00002bd8 rotation predicate (3347–3349).
static func apply_02bd8_node_need_rotate(s2: int, s4: int, s6: int) -> bool:
	return _to_s16(s2) != 0 or _to_s16(s4) != 0 or _to_s16(s6) != 0


## [RECONSTRUCTED] FUN_00002bd8 both-aux delta shift (3367–3370).
## dx/dy/dz <<= (field_34 & 0x3f) before 01c5c(count, mesh, verts, ...).
static func apply_02bd8_shifted_deltas(dx: int, dy: int, dz: int, field_34: int) -> Dictionary:
	var sh: int = _to_s16(field_34) & 0x3F
	return {
		"shift": sh,
		"dx": (dx << sh) & 0xFFFFFFFF,
		"dy": (dy << sh) & 0xFFFFFFFF,
		"dz": (dz << sh) & 0xFFFFFFFF,
	}


## [RECONSTRUCTED] FUN_00002bd8 one template node, both-aux path (3362–3371).
## !rotate: 01c5c(count, src, dst, shifted deltas).
## rotate: 0253e(s2,s4,s6)→matrix (or fixture matrix9) then 02ada.
## After node, next src = dst (param_3 ← param_4).
static func apply_02bd8_both_aux_node(
	count: int,
	src_xyz: Array,
	dx: int,
	dy: int,
	dz: int,
	field_34: int,
	s2: int = 0,
	s4: int = 0,
	s6: int = 0,
	matrix9: Array = []
) -> Dictionary:
	var need_rot: bool = apply_02bd8_node_need_rotate(s2, s4, s6)
	if need_rot:
		var built_0253e: bool = false
		var mat: Array = matrix9
		if mat.is_empty():
			mat = fun_0000253e(s2, s4, s6)
			built_0253e = true
		var rot: Dictionary = fun_00002ada(count, src_xyz, mat)
		return {
			"ok": true,
			"need_rotate": true,
			"applied_02ada": true,
			"applied_0253e": built_0253e,
			"matrix9": mat,
			"xyz": rot.get("xyz", []),
			"02ada": rot,
		}
	var sh: Dictionary = apply_02bd8_shifted_deltas(dx, dy, dz, field_34)
	var added: Dictionary = apply_fun_00001c5c(
		count,
		src_xyz,
		int(sh.get("dx", 0)),
		int(sh.get("dy", 0)),
		int(sh.get("dz", 0))
	)
	return {
		"ok": true,
		"need_rotate": false,
		"shift": int(sh.get("shift", 0)),
		"xyz": added.get("xyz", []),
		"01c5c": added,
	}


## [RECONSTRUCTED] FUN_00002bd8 both-aux walk (3362–3375).
## nodes: {s2,s4,s6,dx,dy,dz,matrix9?}. After each step src←dst.
## Missing matrix9 → build via 0253e(s2,s4,s6).
static func apply_02bd8_both_aux_walk(
	count: int,
	src_xyz: Array,
	nodes: Array,
	field_34: int
) -> Dictionary:
	var cur: Array = src_xyz.duplicate()
	var steps: int = 0
	var blocked_rotate: bool = false
	for node in nodes:
		if not (node is Dictionary):
			break
		var mat: Array = node.get("matrix9", [])
		var step: Dictionary = apply_02bd8_both_aux_node(
			count,
			cur,
			int(node.get("dx", 0)),
			int(node.get("dy", 0)),
			int(node.get("dz", 0)),
			field_34,
			int(node.get("s2", 0)),
			int(node.get("s4", 0)),
			int(node.get("s6", 0)),
			mat if mat is Array else []
		)
		if not bool(step.get("ok", false)):
			blocked_rotate = true
			break
		cur = step.get("xyz", cur)
		steps += 1
	return {
		"steps": steps,
		"blocked_rotate": blocked_rotate,
		"xyz": cur,
		"count": _to_s16(count),
		"field_34": _to_s16(field_34),
	}


## [RECONSTRUCTED] FUN_00002bd8 one template node, null-OR-aux path (3355–3360).
## Optional rotate (0253e→02ada), then always 01c5c(1, local, deltas) — decomp order.
static func apply_02bd8_null_aux_node(
	local_x: int,
	local_y: int,
	local_z: int,
	dx: int,
	dy: int,
	dz: int,
	s2: int = 0,
	s4: int = 0,
	s6: int = 0,
	matrix9: Array = []
) -> Dictionary:
	var need_rot: bool = apply_02bd8_node_need_rotate(s2, s4, s6)
	var x: int = local_x
	var y: int = local_y
	var z: int = local_z
	var built_0253e: bool = false
	var rot: Dictionary = {}
	var mat: Array = []
	if need_rot:
		mat = matrix9
		if mat.is_empty():
			mat = fun_0000253e(s2, s4, s6)
			built_0253e = true
		rot = fun_00002ada(1, [x, y, z], mat)
		var rxyz: Array = rot.get("xyz", [x, y, z])
		x = int(rxyz[0]) if rxyz.size() > 0 else 0
		y = int(rxyz[1]) if rxyz.size() > 1 else 0
		z = int(rxyz[2]) if rxyz.size() > 2 else 0
	var added: Dictionary = apply_fun_00001c5c(1, [x, y, z], dx, dy, dz)
	var xyz: Array = added.get("xyz", [x, y, z])
	return {
		"ok": true,
		"need_rotate": need_rot,
		"applied_02ada": need_rot,
		"applied_0253e": built_0253e,
		"applied_01c5c": true,
		"matrix9": mat,
		"x": int(xyz[0]) if xyz.size() > 0 else 0,
		"y": int(xyz[1]) if xyz.size() > 1 else 0,
		"z": int(xyz[2]) if xyz.size() > 2 else 0,
		"02ada": rot,
		"01c5c": added,
	}


## [RECONSTRUCTED] One 02bd8 chain level's slot fields (3345–3360).
## slot = *(parent+0x30) + index*0x18; angles at +2/+4/+6; deltas at +8/+0xc/+0x10.
static func apply_02bd8_chain_slot_node(
	s2: int, s4: int, s6: int, dx: int, dy: int, dz: int
) -> Dictionary:
	return {
		"s2": _to_s16(s2),
		"s4": _to_s16(s4),
		"s6": _to_s16(s6),
		"dx": dx,
		"dy": dy,
		"dz": dz,
	}


## [RECONSTRUCTED] FUN_00002bd8 template chain walk, null-OR aux (3343–3375).
## nodes: {s2,s4,s6,dx,dy,dz,matrix9?}. Missing matrix9 → 0253e(s2,s4,s6).
static func apply_02bd8_null_aux_walk(
	local_x: int,
	local_y: int,
	local_z: int,
	nodes: Array
) -> Dictionary:
	var x: int = local_x
	var y: int = local_y
	var z: int = local_z
	var steps: int = 0
	var blocked_rotate: bool = false
	for node in nodes:
		if not (node is Dictionary):
			break
		var mat: Array = node.get("matrix9", [])
		var step: Dictionary = apply_02bd8_null_aux_node(
			x, y, z,
			int(node.get("dx", 0)),
			int(node.get("dy", 0)),
			int(node.get("dz", 0)),
			int(node.get("s2", 0)),
			int(node.get("s4", 0)),
			int(node.get("s6", 0)),
			mat if mat is Array else []
		)
		if not bool(step.get("ok", false)):
			blocked_rotate = true
			break
		x = int(step.get("x", x))
		y = int(step.get("y", y))
		z = int(step.get("z", z))
		steps += 1
	return {
		"steps": steps,
		"blocked_rotate": blocked_rotate,
		"x": x & 0xFFFFFFFF,
		"y": y & 0xFFFFFFFF,
		"z": z & 0xFFFFFFFF,
	}


## [RECONSTRUCTED] FUN_00002bd8 null-aux epilogue (3377–3381).
## When param_3==0 AND param_4==0, write working locals back to obj+0x18/+0x1c/+0x20.
## Empty template chain (+0x24==0): locals unchanged (identity commit). Non-null aux: no write.
## Also used by FUN_00002d10 epilogue (3434–3437) — identical commit gate.
static func apply_02bd8_null_aux_commit(
	pos_18: int,
	pos_1c: int,
	pos_20: int,
	param_3: int,
	param_4: int,
	field_24: int = 0
) -> Dictionary:
	var both_null: bool = (param_3 == 0) and (param_4 == 0)
	var empty_chain: bool = field_24 == 0
	return {
		"commit": both_null,
		"empty_template_chain": empty_chain,
		"field_18": pos_18 & 0xFFFFFFFF,
		"field_1c": pos_1c & 0xFFFFFFFF,
		"field_20": pos_20 & 0xFFFFFFFF,
		## Identity when chain empty; mutated values [DEFERRED] when chain walks.
		"locals_unchanged": empty_chain,
	}


## [RECONSTRUCTED] FUN_00002d10 one null-aux node (3408–3429).
## Always 0253e(s2,s4,s6) → 02ada(1) → 01c5c(1, deltas) — no angle gate, no +0x34 shift.
static func apply_02d10_null_aux_node(
	local_x: int,
	local_y: int,
	local_z: int,
	dx: int,
	dy: int,
	dz: int,
	s2: int = 0,
	s4: int = 0,
	s6: int = 0
) -> Dictionary:
	var mat: Array = fun_0000253e(s2, s4, s6)
	var rot: Dictionary = fun_00002ada(1, [local_x, local_y, local_z], mat)
	var rxyz: Array = rot.get("xyz", [local_x, local_y, local_z])
	var added: Dictionary = apply_fun_00001c5c(
		1,
		rxyz,
		dx, dy, dz
	)
	var xyz: Array = added.get("xyz", rxyz)
	return {
		"ok": true,
		"applied_0253e": true,
		"applied_02ada": true,
		"applied_01c5c": true,
		"matrix9": mat,
		"x": int(xyz[0]) if xyz.size() > 0 else 0,
		"y": int(xyz[1]) if xyz.size() > 1 else 0,
		"z": int(xyz[2]) if xyz.size() > 2 else 0,
		"02ada": rot,
		"01c5c": added,
	}


## [RECONSTRUCTED] FUN_00002d10 null-aux walk (3407–3432).
## nodes: {s2,s4,s6,dx,dy,dz}. Sibling of 02bd8; always rotate+translate per node.
## Both-aux mesh path [DEFERRED]. Epilogue: apply_02bd8_null_aux_commit.
static func apply_02d10_null_aux_walk(
	local_x: int,
	local_y: int,
	local_z: int,
	nodes: Array
) -> Dictionary:
	var x: int = local_x
	var y: int = local_y
	var z: int = local_z
	var steps: int = 0
	for node in nodes:
		if not (node is Dictionary):
			break
		var step: Dictionary = apply_02d10_null_aux_node(
			x, y, z,
			int(node.get("dx", 0)),
			int(node.get("dy", 0)),
			int(node.get("dz", 0)),
			int(node.get("s2", 0)),
			int(node.get("s4", 0)),
			int(node.get("s6", 0))
		)
		x = int(step.get("x", x))
		y = int(step.get("y", y))
		z = int(step.get("z", z))
		steps += 1
	return {
		"steps": steps,
		"x": x & 0xFFFFFFFF,
		"y": y & 0xFFFFFFFF,
		"z": z & 0xFFFFFFFF,
	}


## [RECONSTRUCTED] FUN_00004e6e kind-2 vertex buffer ptrs (5640–5643).
## Call sites labeled FUN_00001a48(size); Capstone size=(36+3a)*0xC. ABI BLOCKED —
## SimCore installs via apply_01a68_alloc (heap_alloc) until 01a48 vs 01a68 is resolved.
static func apply_04e6e_kind2_vertex_ptrs(
	ptr_4c: int,
	ptr_44: int,
	field_36: int = 0,
	field_3a: int = 0
) -> Dictionary:
	var nbytes: int = apply_04e6e_kind2_alloc_bytes(field_36, field_3a)
	return {
		"field_4c": ptr_4c & 0xFFFFFFFF,
		"field_44": ptr_44 & 0xFFFFFFFF,
		"alloc_bytes": nbytes,
		"vertex_count_sum": _to_s16(field_36) + _to_s16(field_3a),
		"kind": 2,
	}


## [RECONSTRUCTED] FUN_00004690 vtable +8 (5202–5208; Capstone @0x46A2–0x46D0).
## if type_byte==0: no +8 write. Else factory(obj,type,0)→handle; obj+8=handle; if handle: *handle=0.
## Factory body / DAT_0001b524[type]+6 [DEFERRED] — caller supplies handle_ptr.
static func apply_04690_vtable_plus8(type_byte: int, handle_ptr: int) -> Dictionary:
	var t: int = type_byte & 0xFF
	if t == 0:
		return {
			"install": false,
			"type_byte": 0,
			"field_08": 0,
			"clear_handle": false,
			"handle_ptr": 0,
		}
	var h: int = int(handle_ptr) & 0xFFFFFFFF
	return {
		"install": true,
		"type_byte": t,
		"field_08": h,
		"clear_handle": h != 0,
		"handle_ptr": h,
		"factory_arg3": 0,
	}


## [RECONSTRUCTED] FUN_000046da factory branch (5237–5248).
## Same +8 install as 04690, but factory arg3 = slot short; if handle: copy slot+2/+4/+6 → handle+0x20/22/24.
static func apply_046da_factory_plus8(
	type_byte: int,
	handle_ptr: int,
	slot_u16_2: int = 0,
	slot_u16_4: int = 0,
	slot_u16_6: int = 0,
	factory_arg3: int = 0
) -> Dictionary:
	var base: Dictionary = apply_04690_vtable_plus8(type_byte, handle_ptr)
	base["factory_arg3"] = int(factory_arg3) & 0xFFFF
	base["aux_20"] = int(slot_u16_2) & 0xFFFF
	base["aux_22"] = int(slot_u16_4) & 0xFFFF
	base["aux_24"] = int(slot_u16_6) & 0xFFFF
	base["write_aux"] = bool(base.get("clear_handle", false))
	return base


## [RECONSTRUCTED] FUN_000046da identity stores after alloc (5227–5235).
## world[9]=pool (DAT_0001d6fc); +1=template; +2=slot; if slot==tpl +3++; if tpl<pool_2c flags|=1.
## Vtable +8: apply_046da_factory_plus8 when template desc[1]≠0.
static func apply_046da_identity_stores(
	pool_d6fc: int,
	template_index: int,
	slot_index: int,
	pool_2c: int,
	field_03_in: int = 0,
	flags_04_in: int = 0
) -> Dictionary:
	var f03: int = field_03_in & 0xFF
	var flags04: int = flags_04_in & 0xFFFFFFFF
	var bumped_03: bool = false
	var or_flag1: bool = false
	if slot_index == template_index:
		f03 = (f03 + 1) & 0xFF
		bumped_03 = true
	if template_index < _to_s16(pool_2c):
		flags04 = flags04 | 1
		or_flag1 = true
	return {
		"field_24": pool_d6fc & 0xFFFFFFFF,
		"field_01": template_index & 0xFF,
		"field_02": slot_index & 0xFF,
		"field_03": f03,
		"flags_04": flags04,
		"bumped_03": bumped_03,
		"ored_flag1": or_flag1,
	}


## [RECONSTRUCTED] FUN_000046da desc from parent embed (5223–5224; Capstone @0x46E2+).
## desc = *(b5a0+0x8c) + *( *(parent+0x28) + idx*0x18 + 0x2E ).
static func apply_046da_desc_ptr(
	parent_28: int, child_index: int, b5a0_8c: int, raw_off: int
) -> Dictionary:
	var idx: int = int(child_index)
	return {
		"slot_addr": (int(parent_28) + idx * 0x18 + 0x2E) & 0xFFFFFFFF,
		"desc_ptr": (int(b5a0_8c) + int(raw_off)) & 0xFFFFFFFF,
		"child_index": idx,
	}


## [RECONSTRUCTED] FUN_000046da child links for kind-3 parent (5226–5235).
## +0x24=parent (not 1d6fc); +1/+2 indices; bump +3 if equal; OR flags if idx < parent+0x2c.
static func apply_046da_parent_child_links(
	parent: int,
	param_2: int,
	param_3: int,
	parent_2c: int,
	field_03_in: int = 0,
	flags_04_in: int = 0
) -> Dictionary:
	var base: Dictionary = apply_046da_identity_stores(
		parent, param_2, param_3, parent_2c, field_03_in, flags_04_in
	)
	base["field_24"] = int(parent) & 0xFFFFFFFF
	return base


## [RECONSTRUCTED] FUN_00012840 post-spawn field writes (17561–17570).
## Caller supplies the entity at *(FUN_00005116(...)+8).
## if param_2!=0: field_61c|=0x40; field_610=param_1; pos_20/att22/field_24=param_6/7/8.
static func apply_fun_00012840_spawn_fields(
	param_1_speed: int,
	param_2: int,
	param_6_pos_20: int,
	param_7_attitude_22: int,
	param_8_field_24: int,
	field_61c_in: int = 0
) -> Dictionary:
	var f61c: int = field_61c_in & 0xFFFF
	if param_2 != 0:
		f61c = (f61c | 0x40) & 0xFFFF
	return {
		"field_610": _to_s16(param_1_speed) & 0xFFFF,
		"field_61c": f61c,
		"pos_20": param_6_pos_20 & 0xFFFF,
		"attitude_22": param_7_attitude_22 & 0xFFFF,
		"field_24": param_8_field_24 & 0xFFFF,
		"ored_61c_40": param_2 != 0,
	}


## [RECONSTRUCTED] FUN_00015bf6 local init + optional 028dc + 11544 (20098–20107).
## local_e/a=0; local_6=(param_1>>4)+0x2015; if matrix9 size≥9 → 028dc in-place; then RNG.
static func apply_15bf6_local_perturb(
	param_1_speed: int,
	rng_draws: Array,
	matrix9: Array = []
) -> Dictionary:
	var local_e: int = 0
	var local_a: int = 0
	var local_6: int = _to_s16((_to_s16(param_1_speed) >> 4) + 0x2015)
	var applied_028dc: bool = false
	if matrix9.size() >= 9:
		var rot: Dictionary = fun_000028dc_one(local_e, local_a, local_6, matrix9)
		local_e = int(rot.get("local_e", 0))
		local_a = int(rot.get("local_a", 0))
		local_6 = int(rot.get("local_6", 0))
		applied_028dc = true
	var used: int = 0
	if rng_draws.size() > 0:
		local_e = _to_s16((int(rng_draws[0]) & 0x3F) + local_e - 0x20)
		used = 1
	if rng_draws.size() > 1:
		local_a = _to_s16((int(rng_draws[1]) & 0x3F) + local_a - 0x20)
		used = 2
	if rng_draws.size() > 2:
		local_6 = _to_s16((int(rng_draws[2]) & 0x3F) + local_6 - 0x20)
		used = 3
	return {
		"local_e": local_e,
		"local_a": local_a,
		"local_6": local_6,
		"spawn_x_delta": local_e >> 2,
		"spawn_y_delta": local_a >> 2,
		"spawn_z_delta": local_6 >> 2,
		"rng_draws_used": used,
		"applied_028dc": applied_028dc,
	}


## [RECONSTRUCTED] FUN_0001a63e forward copy for 15bf6 path (23890–24010; nbytes=0x12).
## General memmove deferred; spawn uses non-overlap 18-byte / 9×s16 matrix src→dst.
## Third arg at call site is immediate 0x12 (Ghidra &DAT_00000012 artifact).
static func fun_0001a63e_copy_matrix9(src: Array) -> Array:
	var dst: Array = [0, 0, 0, 0, 0, 0, 0, 0, 0]
	var n: int = mini(9, src.size())
	for i in range(n):
		dst[i] = _to_s16(int(src[i]))
	return dst


## [RECONSTRUCTED] FUN_00015bf6 post-05116 entity writes (20114–20125).
## state_32=local_a<<4; +8/+c/+10 = locals>>2; field_38=0; count_3a=(param_2==0)?1:2.
static func apply_fun_00015bf6_spawn_fields(
	local_e: int,
	local_a: int,
	local_6: int,
	param_2: int
) -> Dictionary:
	var le: int = _to_s16(local_e)
	var la: int = _to_s16(local_a)
	var l6: int = _to_s16(local_6)
	return {
		"state_32": la << 4,
		"entity_data_ptr": le >> 2,
		"position_velocity_c": la >> 2,
		"ptr_10": l6 >> 2,
		"field_38": 0,
		"count_3a": 1 if param_2 == 0 else 2,
	}


## [RECONSTRUCTED] FUN_00019430 post-spawn field writes (23092–23097, 23111–23112).
## field_610←DAT_0001b838 (u32); field_614←param_1; +0x20/22/24; field_618=7; field_61c=0x62.
static func apply_fun_00019430_spawn_fields(
	param_1_speed: int,
	param_5_pos_20: int,
	param_6_attitude_22: int,
	param_7_field_24: int,
	dat_0001b838: int
) -> Dictionary:
	return {
		"field_610": dat_0001b838 & 0xFFFFFFFF,
		"field_614": _to_s16(param_1_speed) & 0xFFFF,
		"pos_20": param_5_pos_20 & 0xFFFF,
		"attitude_22": param_6_attitude_22 & 0xFFFF,
		"field_24": param_7_field_24 & 0xFFFF,
		"field_618": 7,
		"field_61c": 0x62,
	}


## [RECONSTRUCTED] FUN_00019430 0xd vertex loop (23098–23110).
## verts: Array of 13 dicts {x,y,z} (ints at *(world+0x44)+i*0xc).
## In-place >>3 on each component; entity+0x622/656/68a + i*4 ← *0x1c6 / *0x1c6 / *0x255.
static func apply_fun_00019430_vertex_loop(verts: Array) -> Dictionary:
	var shifted: Array = []
	var out_622: Array = []
	var out_656: Array = []
	var out_68a: Array = []
	var n: int = mini(0xD, verts.size())
	for i in range(n):
		var v: Dictionary = verts[i] as Dictionary
		var x: int = int(v.get("x", 0)) >> 3
		var y: int = int(v.get("y", 0)) >> 3
		var z: int = int(v.get("z", 0)) >> 3
		shifted.append({"x": x, "y": y, "z": z})
		out_622.append(x * 0x1C6)
		out_656.append(y * 0x1C6)
		out_68a.append(z * 0x255)
	while out_622.size() < 0xD:
		shifted.append({"x": 0, "y": 0, "z": 0})
		out_622.append(0)
		out_656.append(0)
		out_68a.append(0)
	return {
		"verts_shifted": shifted,
		"entity_622": out_622,
		"entity_656": out_656,
		"entity_68a": out_68a,
		"count": n,
	}


## [RECONSTRUCTED] e792 weapon phase branch (14648–14671).
## When field_19d!=0 and field_19f!=0: if 19d==1 fire (caller runs FUN_00012840),
## decrement 19f, optionally field_18d-=0x10 when mission_short_90!=2; then
## 19d++ with wrap when pre-increment value was 4 → 0.
## FUN_00012840 post-spawn writes ported; FUN_00005116 allocator still deferred.
static func apply_e792_weapon_19d_branch(
	field_19d: int,
	field_19f: int,
	field_18d: int,
	mission_short_90: int
) -> Dictionary:
	var c19d: int = _to_s8(field_19d)
	var c19f: int = _to_s8(field_19f)
	var s18d: int = _to_s16(field_18d)
	var need_12840: bool = false
	var fired: bool = false
	var adjusted_18d: bool = false
	if c19d != 0 and c19f != 0:
		if c19d == 1:
			need_12840 = true
			fired = true
			c19f = _to_s8(c19f - 1)
			if _to_s16(mission_short_90) != 2:
				s18d = _to_s16(s18d - 0x10)
				adjusted_18d = true
		var before: int = c19d
		c19d = _to_s8(c19d + 1)
		if before == 4:
			c19d = 0
	return {
		"field_19d": c19d & 0xFF,
		"field_19f": c19f & 0xFF,
		"field_18d": s18d & 0xFFFF,
		"need_12840": need_12840,
		"fired": fired,
		"adjusted_18d": adjusted_18d,
	}


## [RECONSTRUCTED] e792 field_676 secondary-weapon phase (14673–14693).
## When 676!=0: if 676==1 and field_682>1 and (flags_685&0x10)==0 → fire
## (caller runs FUN_00015d20), field_682-=2; then 676++ with wrap when
## pre-increment was 2 → 0. local_28=(pos_20+0x40)&0x3fff is stack-only here.
## [DEFERRED] FUN_00015d20 body / player result[0x1b]=1.
static func apply_e792_weapon_676_branch(
	field_676: int,
	field_682: int,
	flags_685: int,
	pos_20: int
) -> Dictionary:
	var c676: int = _to_s8(field_676)
	var s682: int = _to_s16(field_682)
	var need_15d20: bool = false
	var fired: bool = false
	var local_28: int = 0
	if c676 != 0:
		if c676 == 1 and s682 > 1 and (flags_685 & 0x10) == 0:
			need_15d20 = true
			fired = true
			local_28 = (_to_s16(pos_20) + 0x40) & 0x3FFF
			s682 = _to_s16(s682 - 2)
		var before: int = c676
		c676 = _to_s8(c676 + 1)
		if before == 2:
			c676 = 0
	return {
		"field_676": c676 & 0xFF,
		"field_682": s682 & 0xFFFF,
		"need_15d20": need_15d20,
		"fired": fired,
		"local_28_stack": local_28,
	}


## [RECONSTRUCTED] e792 field_677 tertiary-weapon (14695–14719).
## When 677==1 and (flags_685&1)==0: fire (caller runs FUN_00019430),
## status|=1, 677←2; player sets DAT_0001b874/b872/d858/b87a.
## [DEFERRED] FUN_00019430 body; world+7 bit clear; FUN_000137da; FUN_00006ed6.
static func apply_e792_weapon_677_branch(
	field_677: int,
	flags_685: int,
	status_1a1: int,
	is_player: bool,
	weapon_count_67d: int,
	weapon_count_67e: int
) -> Dictionary:
	var c677: int = _to_s8(field_677)
	var status: int = status_1a1 & 0xFFFF
	var need_19430: bool = false
	var fired: bool = false
	var set_b874: bool = false
	var clear_b872: bool = false
	var set_d858_9: bool = false
	var set_b87a: bool = false
	if c677 == 1 and (flags_685 & 1) == 0:
		need_19430 = true
		fired = true
		status = (status | 1) & 0xFFFF
		c677 = 2
		if is_player:
			set_b874 = true
			clear_b872 = true
			set_d858_9 = true
			if (status & 0x3FE) == 0 and (_to_s8(weapon_count_67d) != 0 or _to_s8(weapon_count_67e) != 0):
				set_b87a = true
	return {
		"field_677": c677 & 0xFF,
		"status_1a1": status,
		"need_19430": need_19430,
		"fired": fired,
		"set_dat_0001b874": set_b874,
		"clear_dat_0001b872": clear_b872,
		"set_dat_0001d858_9": set_d858_9,
		"set_dat_0001b87a": set_b87a,
	}


## [RECONSTRUCTED] Airborne post-commit (14486–14495): e372 + FUN_00001f22;
## clears field_190 when ==2. Returns movement_62a, local_28/local_2a, flags.
static func apply_airborne_speed_recommit(
	local_e: int,
	local_a: int,
	local_6: int,
	field_190: int,
	local_28_in: int = 0,
	local_2a_in: int = 0
) -> Dictionary:
	var e: int = _to_s16(local_e)
	var a: int = _to_s16(local_a)
	var z: int = _to_s16(local_6)
	var speed_sq: int = e * e + a * a + z * z
	var speed: int = _to_s16(fun_0000e372(speed_sq))
	var att: Dictionary = fun_00001f22(e, a, z, speed, speed_sq, local_28_in, local_2a_in)
	return {
		"movement_62a": speed,
		"speed_sq": speed_sq,
		"clear_field_190": (field_190 & 0xFF) == 2,
		"local_28": int(att.get("local_28", local_28_in)),
		"local_2a": int(att.get("local_2a", local_2a_in)),
		"wrote_local_28": bool(att.get("wrote_local_28", false)),
		"wrote_local_2a": bool(att.get("wrote_local_2a", false)),
	}

## [RECONSTRUCTED] FUN_0000e40c — fold short into ±0x2000 (Pacific Conflict.c:13782–13793).
static func fun_0000e40c(param_1: int) -> int:
	var v: int = _to_s16(param_1)
	if v < 0x2001:
		if v < -0x2000:
			v += 0x4000
	else:
		v -= 0x4000
	return v

## [RECONSTRUCTED] sVar22 ahead of uVar13 (Pacific Conflict.c:14283–14297).
static func compute_s_var22(i_var20: int, movement_666: int) -> int:
	var m666: int = _to_s16(movement_666)
	if i_var20 >= 0xCA8:
		return m666
	var prod: int = i_var20 * m666
	if prod < 0:
		prod += 0xFFF
	prod = (prod >> 12) * 0x143A
	if prod < 0:
		prod += 0xFFF
	return _to_s16(prod >> 12)

## [RECONSTRUCTED] uVar13 = (sVar22 + sVar17) & 0x3fff (14340). sVar17 = *(param_1+9) → +0x24.
static func compute_landing_u_var13(s_var22: int, attitude_24: int) -> int:
	return (_to_s16(s_var22) + _to_s16(attitude_24)) & 0x3FFF

## [RECONSTRUCTED] FUN_00013452 (18173–18178): unwrap world+0x18/0x1c/0x20 → FUN_00013346.
## Callers treat the return as a char (store to entity+0x0b); decompiler marks 13452 void.
static func fun_00013452(world_x_18: int, world_y_1c: int, world_z_20: int,
		list_count_c1e0: int = 0, bda8_plus_16: int = 0) -> int:
	return fun_00013346(world_x_18, world_y_1c, world_z_20, list_count_c1e0, bda8_plus_16)

## [RECONSTRUCTED] FUN_00013346 empty-list path (18134–18143): when DAT_0001c1e0 count
## yields sVar9==-1 on first decrement, return *(DAT_0001bda8+0x16).
## [DEFERRED] Non-empty object scan (FUN_00003c00 / 1320a / 13070).
static func fun_00013346(
	_world_x: int,
	_world_y: int,
	_world_z: int,
	list_count_c1e0: int = 0,
	bda8_plus_16: int = 0
) -> int:
	var s_var9: int = list_count_c1e0 & 0xFFFF
	if (s_var9 & 0x8000) != 0:
		s_var9 -= 0x1_0000
	s_var9 -= 1
	if s_var9 == -1:
		return bda8_plus_16 & 0xFF
	## Non-empty table walk not ported; fall back to same default as empty exhaust.
	return bda8_plus_16 & 0xFF

## [RECONSTRUCTED] FUN_0000e4a4 (Pacific Conflict.c:13832–13872).
## Returns { "value": s16 thrust index, "field_19e": updated byte (0xC on overspeed else unchanged) }.
static func fun_0000e4a4(
	movement_626: int,
	char_67b: int,
	field_19e_in: int,
	tpl_26: int,
	tpl_28: int,
	tpl_2a: int,
	tpl_2c: int,
	tpl_34: int
) -> Dictionary:
	var s_var3: int
	var s_var2: int
	var abs_67b: int = fun_00002e08(_to_s16(char_67b))
	if _to_s16(char_67b) == 0:
		s_var3 = _to_s16(tpl_26)
		s_var2 = _to_s16(tpl_28)
	else:
		var t26: int = _to_s16(tpl_26)
		var t28: int = _to_s16(tpl_28)
		var t2a: int = _to_s16(tpl_2a)
		var t2c: int = _to_s16(tpl_2c)
		s_var3 = _to_s16(t26 + int((abs_67b * (t2a - t26)) / 0xF))
		s_var2 = _to_s16(t28 + int(((t2c - t28) * abs_67b) / 0xF))
	var m626: int = _to_s16(movement_626)
	var t34: int = _to_s16(tpl_34)
	var field_19e: int = field_19e_in & 0xFF
	if t34 < m626:
		field_19e = 0x0C
		var span: int = 0x20 - (m626 - t34)
		if span < 0:
			span = 0
		var prod: int = span * (s_var2 * t34 + s_var3)
		if prod < 0:
			prod += 0x7FF
		s_var3 = _to_s16(prod >> 11)
	else:
		var prod2: int = s_var2 * m626
		if prod2 < 0:
			prod2 += 0x3F
		s_var3 = _to_s16(s_var3 + (prod2 >> 6))
	return {"value": s_var3, "field_19e": field_19e}

## Truncating (toward-zero) signed division — matches 68k DIVS / Godot int `/`.
static func _div_trunc(numer: int, denom: int) -> int:
	if denom == 0:
		return 0
	return int(numer / denom)

## [RECONSTRUCTED] First e468 DIVS drag term → iVar10 (Pacific Conflict.c:14356–14361 / asm 0xEDF8).
## iVar10 = ((((iVar20 * (tpl_22 * (iVar20 * iVar19 >> 8))) / e468) + bias) >> 3) / 0xA0 / sVar12
static func apply_e468_linear_drag(
	i_var20: int,
	i_var19: int,
	tpl_22: int,
	e468: int,
	s_var12: int
) -> int:
	if e468 == 0 or s_var12 == 0:
		## [INFERRED] Guard; original DIVS trap behavior not modeled.
		return 0
	var t22: int = _to_s16(tpl_22)
	var inner: int = (i_var20 * i_var19) >> 8
	var numer: int = i_var20 * (t22 * inner)
	var i_var10: int = _div_trunc(numer, e468)
	if i_var10 < 0:
		i_var10 += 7
	return _div_trunc(_div_trunc(i_var10 >> 3, 0xA0), s_var12)

## [RECONSTRUCTED] Quadratic e468 DIVS raw product (Pacific Conflict.c:14362–14367 / asm 0xEE50).
## Returns value after /e468 and +7 bias; caller applies (>>3)/0xA0 into 0x636.
static func apply_e468_quadratic_drag_raw(
	i_var20: int,
	i_var19: int,
	tpl_22: int,
	tpl_24: int,
	e468: int
) -> int:
	if e468 == 0:
		return 0
	var t22: int = _to_s16(tpl_22)
	var t24: int = _to_s16(tpl_24)
	var sq: int = (i_var19 * i_var19) >> 4
	var mid: int = (t24 * sq) >> 20
	var inner: int = (i_var20 * mid) >> 8
	var numer: int = i_var20 * (t22 * inner)
	var raw: int = _div_trunc(numer, e468)
	if raw < 0:
		raw += 7
	return raw

## [RECONSTRUCTED] Thrust into 0x636 / iVar25 (Pacific Conflict.c:14368–14383).
## Returns { "movement_636", "movement_62a", "quad_term", "thrust_term" }.
static func apply_thrust_636_step(
	movement_636: int,
	movement_62a: int,
	i_var20: int,
	quadratic_raw: int,
	s_var15: int,
	s_var12: int,
	tpl_20: int,
	char_679: int,
	char_67b: int
) -> Dictionary:
	if s_var12 == 0 or s_var15 == 0:
		return {
			"movement_636": _to_s16(movement_636),
			"movement_62a": movement_62a,
			"quad_term": 0,
			"thrust_term": 0,
		}
	var t20: int = _to_s16(tpl_20)
	var local_4c: int = 0
	var i_var9: int = 0
	if char_679 != 0:
		local_4c = _div_trunc(fun_00002e08(char_679) * t20, 0xB)
	if char_67b != 0:
		i_var9 = _div_trunc(fun_00002e08(char_67b) * t20, 0xF)
	var thrust_inner: int = _div_trunc((i_var20 * (i_var9 + local_4c + t20)) >> 8, s_var15)
	var thrust_term: int = _div_trunc(i_var20 * thrust_inner * 2, 0xA0)
	var quad_term: int = _div_trunc(quadratic_raw >> 3, 0xA0)
	var total: int = _to_s16(movement_636) + thrust_term + quad_term
	var quot: int = _div_trunc(total, s_var12)
	var rem: int = total - quot * s_var12
	return {
		"movement_636": _to_s16(rem),
		"movement_62a": movement_62a - quot,
		"quad_term": quad_term,
		"thrust_term": thrust_term,
	}

## [RECONSTRUCTED] 0x63e path thrust delta into 0x18e (Pacific Conflict.c:14384–14410).
## Returns { "thrust_delta", "set_dat_0001b850" }.
static func compute_63e_thrust_delta(
	i_var20_speed: int,
	char_679: int,
	field_0b: int,
	status_1a1: int,
	field_641: int,
	tpl_46: int,
	tpl_2e: int,
	tpl_30: int,
	tpl_32: int
) -> Dictionary:
	var abs_679: int = fun_00002e08(char_679)
	var thrust_delta: int = 0
	var set_b850: bool = false
	if abs_679 == 0x2D:
		var base: int
		if i_var20_speed < _to_s16(tpl_46) or field_0b == 0x40:  # '@'
			base = _to_s16(tpl_2e)
		else:
			base = _to_s16(tpl_30)
		thrust_delta = base
		if field_641 != 0 or field_0b == 0x50:  # 'P'
			thrust_delta = _to_s16(tpl_32) + thrust_delta
	elif (status_1a1 & 0x10) == 0:
		thrust_delta = 0
	else:
		var scaled: int = _to_s16(tpl_32) * 3
		if scaled < 0:
			scaled += 1
		thrust_delta = scaled >> 1
		set_b850 = true
	return {"thrust_delta": thrust_delta, "set_dat_0001b850": set_b850}

## Identity 3×3 in 0x1000 fixed-point (1.0 << 12) for FUN_000028dc tests / stub matrix.
static func identity_matrix_9() -> Array:
	return [0x1000, 0, 0, 0, 0x1000, 0, 0, 0, 0x1000]

## [RECONSTRUCTED] FUN_00001d02 — 3×3 fixed-point matmul C = A*B >> 12 (2357–2384).
static func fun_00001d02(a9: Array, b9: Array) -> Array:
	var c: Array = [0, 0, 0, 0, 0, 0, 0, 0, 0]
	for row in range(3):
		for col in range(3):
			var acc: int = (
				_to_s16(int(a9[row * 3 + 0])) * _to_s16(int(b9[0 * 3 + col]))
				+ _to_s16(int(a9[row * 3 + 1])) * _to_s16(int(b9[1 * 3 + col]))
				+ _to_s16(int(a9[row * 3 + 2])) * _to_s16(int(b9[2 * 3 + col]))
			)
			c[row * 3 + col] = _to_s16(acc >> 12)
	return c

## [RECONSTRUCTED] 256-entry BE sin/cos tables from Pacific Conflict overlay.
## Usable bases at file 0x1ab8c / 0x1ad8c (Ghidra DAT_0001ab6c/ad6c are 0x20 early).
const TRIG_TABLES_PATH := "res://hellcats/tests/fixtures/trig_tables_ab6c_ad6c.json"
const TRIG_AF6C_PATH := "res://hellcats/tests/fixtures/trig_table_af6c.json"
const DAT_0001B190_PATH := "res://hellcats/tests/fixtures/dat_0001b190_band_table.json"
static var _trig_sin_table: PackedInt32Array = PackedInt32Array()
static var _trig_cos_table: PackedInt32Array = PackedInt32Array()
static var _trig_af6c_table: PackedInt32Array = PackedInt32Array()
static var _trig_tables_from_dump: bool = false
static var _trig_af6c_from_dump: bool = false
static var _dat_0001b190_table: Array = []
static var _dat_0001b190_from_dump: bool = false

static func _ensure_trig_tables() -> void:
	if _trig_sin_table.size() == 256:
		return
	if FileAccess.file_exists(TRIG_TABLES_PATH):
		var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(TRIG_TABLES_PATH))
		if typeof(parsed) == TYPE_DICTIONARY:
			var d: Dictionary = parsed
			var sin_a: Array = d.get("sin", []) as Array
			var cos_a: Array = d.get("cos", []) as Array
			if sin_a.size() == 256 and cos_a.size() == 256:
				_trig_sin_table.resize(256)
				_trig_cos_table.resize(256)
				for i in range(256):
					_trig_sin_table[i] = int(sin_a[i])
					_trig_cos_table[i] = int(cos_a[i])
				_trig_tables_from_dump = true
				return
	## Fallback only if fixture missing — not used when dump is present.
	_trig_sin_table.resize(256)
	_trig_cos_table.resize(256)
	for i in range(256):
		var rad: float = float(i) * TAU / 256.0
		_trig_sin_table[i] = int(round(sin(rad) * 4096.0))
		_trig_cos_table[i] = int(round(cos(rad) * 4096.0))
	_trig_tables_from_dump = false

static func _ensure_af6c_table() -> void:
	if _trig_af6c_table.size() >= 0x81:
		return
	if FileAccess.file_exists(TRIG_AF6C_PATH):
		var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(TRIG_AF6C_PATH))
		if typeof(parsed) == TYPE_DICTIONARY:
			var vals: Array = (parsed as Dictionary).get("values", []) as Array
			if vals.size() >= 0x81:
				_trig_af6c_table.resize(vals.size())
				for i in range(vals.size()):
					_trig_af6c_table[i] = int(vals[i])
				_trig_af6c_from_dump = true
				return
	_trig_af6c_table.resize(0x81)
	_trig_af6c_from_dump = false

## [RECONSTRUCTED] DAT_0001b190 — 40× int32 BE upper bounds @ file 0x1b190 (FUN_00003da8).
## Fallback mock kept only if fixture missing (not ROM-faithful).
static func load_dat_0001b190_table() -> Array:
	if _dat_0001b190_table.size() == 40 and _dat_0001b190_from_dump:
		return _dat_0001b190_table.duplicate()
	if FileAccess.file_exists(DAT_0001B190_PATH):
		var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(DAT_0001B190_PATH))
		if typeof(parsed) == TYPE_DICTIONARY:
			var vals: Array = (parsed as Dictionary).get("values", []) as Array
			if vals.size() == 40:
				_dat_0001b190_table = []
				for i in range(40):
					_dat_0001b190_table.append(int(vals[i]))
				_dat_0001b190_from_dump = true
				return _dat_0001b190_table.duplicate()
	_dat_0001b190_from_dump = false
	_dat_0001b190_table = [0, 0x100, 0x1000, 0x10000, 0x30000, 0x7FFFFFFF]
	return _dat_0001b190_table.duplicate()

## [RECONSTRUCTED] Table lerp (Pacific Conflict.c:2435–2461 / 2485–2511).
static func _trig_lerp(table: PackedInt32Array, param_1: int) -> int:
	var u: int = param_1 + 0x3F if param_1 < 0 else param_1
	var idx: int = (u >> 6) & 0xFF
	var idx1: int = (idx + 1) & 0xFF
	var delta: int = (int(table[idx1]) - int(table[idx])) * -((u & ~0x3F) - param_1)
	if delta < 0:
		delta += 0x3F
	return _to_s16(int(table[idx]) + (delta >> 6))

## [RECONSTRUCTED] FUN_00001d76 — sin-table lerp (overlay table at file 0x1ab8c).
static func fun_00001d76(param_1: int) -> int:
	_ensure_trig_tables()
	return _trig_lerp(_trig_sin_table, _to_s16(param_1))

## [RECONSTRUCTED] FUN_00001dd8 — cos-table lerp (overlay table at file 0x1ad8c).
static func fun_00001dd8(param_1: int) -> int:
	_ensure_trig_tables()
	return _trig_lerp(_trig_cos_table, _to_s16(param_1))

## [RECONSTRUCTED] FUN_00001e3a — acos-style search on cos table (2516–2550).
static func fun_00001e3a(param_1: int) -> int:
	_ensure_trig_tables()
	var p: int = param_1
	if p > 0x1000:
		p = 0x1000
	if p < -0x1000:
		p = -0x1000
	var lo: int = 0
	var hi: int = 0x80
	while lo < hi - 1:
		var mid_sum: int = hi + lo
		if mid_sum < 0:
			mid_sum += 1
		var mid: int = mid_sum >> 1
		if p <= int(_trig_cos_table[mid]):
			lo = mid
		else:
			hi = mid
	var c0: int = int(_trig_cos_table[lo])
	var c1: int = int(_trig_cos_table[lo + 1])
	var denom: int = c0 - c1
	var frac: int = 0
	if denom != 0:
		frac = int(((p - c0) * -0x40) / denom)
	return _to_s16(frac + (lo << 6))

## [RECONSTRUCTED] FUN_00001ebc — ratio→angle via DAT_0001af6c dump at file 0x1af8c (2554–2581).
static func fun_00001ebc(param_1: int) -> int:
	_ensure_af6c_table()
	var lo: int = 0
	var hi: int = 0x7F
	while lo < hi - 1:
		var mid_sum: int = hi + lo
		if mid_sum < 0:
			mid_sum += 1
		var mid: int = mid_sum >> 1
		if int(_trig_af6c_table[mid]) <= param_1:
			lo = mid
		else:
			hi = mid
	var t0: int = int(_trig_af6c_table[lo])
	var t1: int = int(_trig_af6c_table[lo + 1])
	var denom: int = t0 - t1
	var frac: int = 0
	if denom != 0:
		frac = int(((t0 - param_1) * 0x40) / denom)
	return (frac + (lo - 0x3F) * 0x40) & 0x3FFF

## [INFERRED] FUN_00002de8 in 01f22 is a broken void decompile; call sites behave as abs().
## [RECONSTRUCTED] FUN_00001f22 attitude from velocity (2586–2632).
## Returns { "local_28", "local_2a", "wrote_local_28", "wrote_local_2a" }.
static func fun_00001f22(
	param_1: int,
	param_2: int,
	param_3: int,
	param_4: int,
	param_5: int,
	local_28_in: int,
	local_2a_in: int
) -> Dictionary:
	var e: int = _to_s16(param_1)
	var a: int = _to_s16(param_2)
	var z: int = _to_s16(param_3)
	var abs_e: int = fun_00002e08(e)
	var abs_z: int = fun_00002e08(z)
	var local_28: int = local_28_in & 0xFFFF
	var local_2a: int = local_2a_in & 0xFFFF
	var wrote_2a: bool = false
	var wrote_28: bool = false
	if abs_z < abs_e:
		if abs_e != 0:
			var u: int = fun_00001ebc(int((z << 12) / abs_e))
			u = 0x1000 - u
			if e > 0:
				u = -u
			local_2a = u & 0x3FFF
			wrote_2a = true
	elif z != 0:
		var u2: int = fun_00001ebc(int((e * -0x1000) / abs_z))
		if z < 0:
			u2 = (0x2000 - u2) & 0x3FFF
		local_2a = u2 & 0xFFFF
		wrote_2a = true
	if param_4 != 0:
		var abs_a: int = fun_00002e08(a)
		var u4: int
		if abs_z + abs_e < abs_a:
			var hyp: int = fun_0000e372(param_5 - a * a)
			u4 = fun_00001e3a(int((_to_s16(hyp) << 12) / param_4)) & 0xFFFF
			if a < 0:
				u4 = (-u4) & 0x3FFF
		else:
			u4 = (0x1000 - _to_s16(fun_00001e3a(int((a << 12) / param_4)))) & 0x3FFF
		local_28 = u4 & 0xFFFF
		wrote_28 = true
	return {
		"local_28": local_28 & 0xFFFF,
		"local_2a": local_2a & 0xFFFF,
		"wrote_local_28": wrote_28,
		"wrote_local_2a": wrote_2a,
	}

## [RECONSTRUCTED] FUN_0000202a — fill sin/cos pairs for four angles (2637–2658).
## Returns {c0,s0,c1,s1,c2,s2,c3,s3} matching DAT_0001d7fa..d7f0 order.
static func fun_0000202a(a0: int, a1: int, a2: int, a3: int) -> Dictionary:
	return {
		"c0": fun_00001dd8(a0), "s0": fun_00001d76(a0),
		"c1": fun_00001dd8(a1), "s1": fun_00001d76(a1),
		"c2": fun_00001dd8(a2), "s2": fun_00001d76(a2),
		"c3": fun_00001dd8(a3), "s3": fun_00001d76(a3),
	}

## [RECONSTRUCTED] FUN_000020e6 — three basis matrices from 0202a pairs (2681–2711).
static func fun_000020e6(sc: Dictionary) -> Dictionary:
	var c0: int = int(sc.get("c0", 0x1000))
	var s0: int = int(sc.get("s0", 0))
	var c1: int = int(sc.get("c1", 0x1000))
	var s1: int = int(sc.get("s1", 0))
	var c2: int = int(sc.get("c2", 0x1000))
	var s2: int = int(sc.get("s2", 0))
	return {
		"m_d7d4": [0x1000, 0, 0, 0, c0, -s0, 0, s0, c0],
		"m_d7bc": [c1, 0, s1, 0, 0x1000, 0, -s1, 0, c1],
		"m_d7a4": [c2, s2, 0, -s2, c2, 0, 0, 0, 0x1000],
	}

## [RECONSTRUCTED] FUN_000021a0 — fourth-angle Y-axis matrix DAT_0001d78c (2716–2728).
static func fun_000021a0(sc: Dictionary) -> Array:
	var c3: int = int(sc.get("c3", 0x1000))
	var s3: int = int(sc.get("s3", 0))
	return [c3, 0, s3, 0, 0x1000, 0, -s3, 0, c3]

## [RECONSTRUCTED] FUN_000021e0 — fourth-angle X-axis matrix (2733–2745 via 025d6).
## [1,0,0; 0,c3,-s3; 0,s3,c3] — twin of 021a0 used by FUN_0000262e.
static func fun_000021e0(sc: Dictionary) -> Array:
	var c3: int = int(sc.get("c3", 0x1000))
	var s3: int = int(sc.get("s3", 0))
	return [0x1000, 0, 0, 0, c3, -s3, 0, s3, c3]

## [RECONSTRUCTED] FUN_00002562 — M78c*M7a4*M7d4*M7bc into out (2929–2937).
static func fun_00002562(m_78c: Array, m_7a4: Array, m_7d4: Array, m_7bc: Array) -> Array:
	var out: Array = fun_00001d02(m_78c, m_7a4)
	var tmp: Array = fun_00001d02(out, m_7d4)
	return fun_00001d02(tmp, m_7bc)

## [RECONSTRUCTED] FUN_000024f8 (2905–2914): after 0202a, 020e6 then
## 01d02(m_d7a4, m_d7d4) → 01d02(temp, m_d7bc). Side-effect DAT_00020ce4=0x2408 deferred.
static func fun_000024f8(sc: Dictionary) -> Array:
	var bases: Dictionary = fun_000020e6(sc)
	var temp: Array = fun_00001d02(bases["m_d7a4"] as Array, bases["m_d7d4"] as Array)
	return fun_00001d02(temp, bases["m_d7bc"] as Array)

## [RECONSTRUCTED] FUN_0000253e (2919–2923): 0202a(a,b,c,0) → 024f8 → s16[9].
## ≡ fun_000025a8(0, a, b, c) when fourth angle is 0 (identity 021a0 path).
static func fun_0000253e(param_1: int, param_2: int, param_3: int) -> Array:
	return fun_000024f8(fun_0000202a(param_1, param_2, param_3, 0))

## [RECONSTRUCTED] FUN_000025a8 (2942–2949): 0202a(p2,p3,p4,p1) → 020e6 → 021a0 → 02562.
## Angle order matches e792 call (14438–14439). Trig from dumped overlay tables.
static func fun_000025a8(param_1: int, param_2: int, param_3: int, param_4: int) -> Array:
	var sc: Dictionary = fun_0000202a(param_2, param_3, param_4, param_1)
	var bases: Dictionary = fun_000020e6(sc)
	var m_78c: Array = fun_000021a0(sc)
	return fun_00002562(
		m_78c,
		bases["m_d7a4"] as Array,
		bases["m_d7d4"] as Array,
		bases["m_d7bc"] as Array
	)

## [RECONSTRUCTED] FUN_0000262e (2970–2976): 0202a(p2,p3,p4,p1) → 025d6 (=020e6→021e0→02562).
## 15d20: 0262e(yaw_arg, pos_20, attitude_22, field_24).
static func fun_0000262e(param_1: int, param_2: int, param_3: int, param_4: int) -> Array:
	var sc: Dictionary = fun_0000202a(param_2, param_3, param_4, param_1)
	var bases: Dictionary = fun_000020e6(sc)
	var m_78c: Array = fun_000021e0(sc)
	return fun_00002562(
		m_78c,
		bases["m_d7a4"] as Array,
		bases["m_d7d4"] as Array,
		bases["m_d7bc"] as Array
	)

## [RECONSTRUCTED] local_48 in 626 block before reverse overwrite (14278–14297).
static func compute_626_local_48(i_var20: int, field_199: int) -> int:
	var f199: int = _to_s16(field_199)
	if i_var20 >= 0xCA8:
		return f199 & 0xFFFF
	var prod: int = i_var20 * f199
	if prod < 0:
		prod += 0xFFF
	prod = (prod >> 12) * 0x143A
	if prod < 0:
		prod += 0xFFF
	return (prod >> 12) & 0xFFFF

## [RECONSTRUCTED] FUN_00002ada (3269–3320; Capstone @0x2ADA).
## Transform count int32 vec3s by s16[9] matrix: column-dots >> 12, NO +0x800 (unlike 028dc).
## matrix9 row-major; out_x = (x*m0 + y*m3 + z*m6) >> 12 (same layout as 028dc).
static func fun_00002ada(count: int, src_xyz: Array, matrix9: Array) -> Dictionary:
	var n: int = _to_s16(count)
	if n < 0:
		n = 0
	var m: Array = matrix9.duplicate()
	while m.size() < 9:
		m.append(0)
	var m0: int = _to_s16(int(m[0]))
	var m1: int = _to_s16(int(m[1]))
	var m2: int = _to_s16(int(m[2]))
	var m3: int = _to_s16(int(m[3]))
	var m4: int = _to_s16(int(m[4]))
	var m5: int = _to_s16(int(m[5]))
	var m6: int = _to_s16(int(m[6]))
	var m7: int = _to_s16(int(m[7]))
	var m8: int = _to_s16(int(m[8]))
	var out: Array = []
	for i in range(n):
		var base: int = i * 3
		var x: int = int(src_xyz[base]) if base < src_xyz.size() else 0
		var y: int = int(src_xyz[base + 1]) if base + 1 < src_xyz.size() else 0
		var z: int = int(src_xyz[base + 2]) if base + 2 < src_xyz.size() else 0
		## 64-bit products via GDScript int; arithmetic >> 12 (no +0x800).
		out.append(((x * m0 + y * m3 + z * m6) >> 12) & 0xFFFFFFFF)
		out.append(((x * m1 + y * m4 + z * m7) >> 12) & 0xFFFFFFFF)
		out.append(((x * m2 + y * m5 + z * m8) >> 12) & 0xFFFFFFFF)
	return {"count": n, "xyz": out}


## [RECONSTRUCTED] FUN_00002976 (3144–3170; Capstone @0x2976).
## count×: read s16 at src +2/+6/+10 (0xC stride), write int32×3 outs.
## Same dots as 028dc (+0x800>>12) but MOVE.L destinations (not packed shorts).
## src_xyz: flat [x0,y0,z0,…] already extracted from +2/+6/+10.
static func fun_00002976(count: int, src_xyz: Array, matrix9: Array) -> Dictionary:
	## Call sites pass small non-negative counts in the low word (DBF-style loop).
	var n: int = count & 0xFFFF
	var m: Array = matrix9.duplicate()
	while m.size() < 9:
		m.append(0)
	var m0: int = _to_s16(int(m[0]))
	var m1: int = _to_s16(int(m[1]))
	var m2: int = _to_s16(int(m[2]))
	var m3: int = _to_s16(int(m[3]))
	var m4: int = _to_s16(int(m[4]))
	var m5: int = _to_s16(int(m[5]))
	var m6: int = _to_s16(int(m[6]))
	var m7: int = _to_s16(int(m[7]))
	var m8: int = _to_s16(int(m[8]))
	var out: Array = []
	for i in range(n):
		var base: int = i * 3
		var x: int = _to_s16(int(src_xyz[base]) if base < src_xyz.size() else 0)
		var y: int = _to_s16(int(src_xyz[base + 1]) if base + 1 < src_xyz.size() else 0)
		var z: int = _to_s16(int(src_xyz[base + 2]) if base + 2 < src_xyz.size() else 0)
		out.append(_to_s32((z * m6 + y * m3 + x * m0 + 0x800) >> 12))
		out.append(_to_s32((z * m7 + y * m4 + x * m1 + 0x800) >> 12))
		out.append(_to_s32((z * m8 + y * m5 + x * m2 + 0x800) >> 12))
	return {"count": n, "xyz": out}


## [RECONSTRUCTED] FUN_000028dc count=1 (Pacific Conflict.c:3111–3139).
## Reads/writes shorts at +2/+6/+10 → (local_e, local_a, local_6).
## out = (z*m[6|7|8] + y*m[3|4|5] + x*m[0|1|2] + 0x800) >> 12
static func fun_000028dc_one(local_e: int, local_a: int, local_6: int, matrix9: Array) -> Dictionary:
	var x: int = _to_s16(local_e)
	var y: int = _to_s16(local_a)
	var z: int = _to_s16(local_6)
	var m: Array = matrix9
	while m.size() < 9:
		m.append(0)
	var out_e: int = _to_s16((z * _to_s16(int(m[6])) + y * _to_s16(int(m[3])) + x * _to_s16(int(m[0])) + 0x800) >> 12)
	var out_a: int = _to_s16((z * _to_s16(int(m[7])) + y * _to_s16(int(m[4])) + x * _to_s16(int(m[1])) + 0x800) >> 12)
	var out_6: int = _to_s16((z * _to_s16(int(m[8])) + y * _to_s16(int(m[5])) + x * _to_s16(int(m[2])) + 0x800) >> 12)
	return {"local_e": out_e, "local_a": out_a, "local_6": out_6}

## [RECONSTRUCTED] Post-028dc position commit (Pacific Conflict.c:14441–14445).
## local_a += field_18c; field_18c = 0xffa5; param_1[2..4] = components >> 6.
## matrix9: from FUN_000025a8 (trig tables may still be [MVP APPROXIMATION]).
static func apply_position_commit_after_028dc(
	ivar10: int,
	ivar25: int,
	field_18c: int,
	matrix9: Array
) -> Dictionary:
	var rotated: Dictionary = fun_000028dc_one(0, _to_s16(ivar10), _to_s16(ivar25), matrix9)
	var local_e: int = int(rotated.get("local_e", 0))
	var local_a: int = int(rotated.get("local_a", 0)) + _to_s16(field_18c)
	var local_6: int = int(rotated.get("local_6", 0))
	return {
		"field_18c": 0xFFA5,
		"param_1_2": local_e >> 6,
		"param_1_3": local_a >> 6,
		"param_1_4": local_6 >> 6,
		"local_e": local_e,
		"local_a": local_a,
		"local_6": local_6,
	}

## [RECONSTRUCTED] Contact early-out 61a/61e → pos_20 / field_24 (14095–14101).
## Capstone @0xE864–0xE894: two 11544-callsite draws (≡11564 [INFERRED]).
## 61e += rng&0x7f; field_24 = (field_24 + 61e) & 0x3fff;
## 61a -= rng&0x7f; pos_20   = (pos_20   + 61a) & 0x3fff.
## Ghidra param_1+9/+8 are uint* slots → offsets 0x24 / 0x20 (field_24 / pos_20).
static func apply_contact_61a_61e_attitude(
	rng_for_61e: int,
	rng_for_61a: int,
	movement_61e: int,
	movement_61a: int,
	field_24: int,
	pos_20: int
) -> Dictionary:
	var m61e: int = _to_s16(_to_s16(movement_61e) + (rng_for_61e & 0x7F))
	var f24: int = (_to_s16(field_24) + m61e) & 0x3FFF
	var m61a: int = _to_s16(_to_s16(movement_61a) - (rng_for_61a & 0x7F))
	var p20: int = (_to_s16(pos_20) + m61a) & 0x3FFF
	return {
		"movement_61e": m61e & 0xFFFF,
		"movement_61a": m61a & 0xFFFF,
		"field_24": f24,
		"pos_20": p20,
	}


## [RECONSTRUCTED] Landing touchdown when field_63e==0 (Pacific Conflict.c:14446–14449).
## surface_1c = *(world+0x1c); i_var23 = pos_2e + field_40_adj.
## Returns { "applied", "field_63e", "position_velocity_c" }.
static func apply_landing_touchdown_63e(
	field_63e: int,
	position_velocity_c: int,
	surface_1c: int,
	i_var23: int
) -> Dictionary:
	if field_63e != 0:
		return {
			"applied": false,
			"field_63e": field_63e & 0xFF,
			"position_velocity_c": position_velocity_c,
		}
	var pvc: int = position_velocity_c
	if (pvc + surface_1c < i_var23) and (i_var23 <= surface_1c):
		return {
			"applied": true,
			"field_63e": 1,
			"position_velocity_c": i_var23 - surface_1c,
		}
	return {
		"applied": false,
		"field_63e": 0,
		"position_velocity_c": pvc,
	}

## [RECONSTRUCTED] Post-touchdown pitch follow-on (Pacific Conflict.c:14450–14476).
## Gentle path: e40c(uVar13) abs>0x200 or e40c(local_28)<-0x100 → rough; else player DAT_0001b856=1.
## FUN_00013452 deferred (need_13452 only). local_28 = entry *(param_1+8) → entity+0x20.
## Returns { "status_1a1", "clear_field_18e", "set_dat_0001b868", "set_dat_0001b856",
##           "early_return", "rough", "hard_crash", "need_13452" }.
static func apply_landing_pitch_followon(
	attitude_0e: int,
	pos_2e: int,
	status_1a1: int,
	is_designated_player: bool,
	u_var13: int = 0,
	local_28: int = 0
) -> Dictionary:
	var pitch_scaled: int = _to_s16(attitude_0e) * 0x10
	var status: int = status_1a1 & 0xFFFF
	if pitch_scaled < -0x168:
		status = status | 0x400
		return {
			"status_1a1": status,
			"clear_field_18e": false,
			"set_dat_0001b868": false,
			"set_dat_0001b856": false,
			"early_return": true,
			"rough": true,
			"hard_crash": true,
			"need_13452": pos_2e == 0,
		}
	var rough: bool = pitch_scaled < -0xD8
	if not rough:
		var folded_13: int = fun_0000e40c(u_var13)
		if fun_00002e08(_to_s16(folded_13)) > 0x200:
			rough = true
		elif _to_s16(fun_0000e40c(local_28)) < -0x100:
			rough = true
	var set_b856: bool = (not rough) and is_designated_player
	return {
		"status_1a1": status,
		"clear_field_18e": true,
		"set_dat_0001b868": is_designated_player,
		"set_dat_0001b856": set_b856,
		"early_return": false,
		"rough": rough,
		"hard_crash": false,
		"need_13452": false,
	}

## [RECONSTRUCTED] Leave ground when field_63e!=0 and altitude clears (14479–14484).
## Returns { "applied", "field_63e", "status_1a1", "clear_dat_0001b868" }.
static func apply_airborne_clear_63e(
	field_63e: int,
	position_velocity_c: int,
	surface_1c: int,
	i_var23: int,
	status_1a1: int
) -> Dictionary:
	if field_63e == 0:
		return {
			"applied": false,
			"field_63e": 0,
			"status_1a1": status_1a1 & 0xFFFF,
			"clear_dat_0001b868": false,
		}
	if i_var23 <= position_velocity_c + surface_1c:
		return {
			"applied": true,
			"field_63e": 0,
			"status_1a1": status_1a1 & 0xEFFF,
			"clear_dat_0001b868": true,
		}
	return {
		"applied": false,
		"field_63e": field_63e & 0xFF,
		"status_1a1": status_1a1 & 0xFFFF,
		"clear_dat_0001b868": false,
	}

## [RECONSTRUCTED] Stall / local_34 into iVar25 (Pacific Conflict.c:14422–14433).
## Returns { "movement_62a", "field_190", "stalled", "set_dat_0001b868" }.
static func apply_ivar25_stall_step(
	movement_62a: int,
	field_190: int,
	local_34: int,
	s_var12: int,
	movement_62a_nonzero_before_zero: bool,
	is_designated_player: bool,
	dat_0001b868: int
) -> Dictionary:
	var i_var25: int = movement_62a
	var f190: int = field_190 & 0xFF
	if f190 == 1:
		i_var25 -= 0xB6
	if s_var12 != 0:
		i_var25 = _div_trunc(local_34 << 2, s_var12) + i_var25
	var stalled: bool = false
	var set_b868: bool = false
	if i_var25 < 1:
		i_var25 = 0
		f190 = 2
		stalled = true
		if movement_62a_nonzero_before_zero and is_designated_player and dat_0001b868 == 1:
			set_b868 = true
	return {
		"movement_62a": i_var25,
		"field_190": f190,
		"stalled": stalled,
		"set_dat_0001b868": set_b868,
	}

## [RECONSTRUCTED] field_18e update + iVar25 subtract (Pacific Conflict.c:14411–14420).
## Store: (short)iVar19 - ((ushort)biased & 0xf000). Delta: (biased_for_shift >> 12).
static func apply_field_18e_update(field_18e: int, thrust_delta: int, ivar10: int) -> Dictionary:
	var i_var19: int = _to_s16(field_18e) + thrust_delta * (0x5B - ivar10)
	var biased: int = i_var19
	if i_var19 < 0:
		biased = i_var19 + 0xFFF
	var stored: int = _to_s16(i_var19) - ((biased & 0xFFFF) & 0xF000)
	stored = stored & 0xFFFF
	var for_shift: int = i_var19
	if for_shift < 0:
		for_shift += 0xFFF
	return {
		"field_18e": stored,
		"movement_62a_delta": for_shift >> 12,
	}

## [RECONSTRUCTED] Reverse local_48 from local_46/local_42/movement_666 (14321–14335).
static func compute_reverse_local_48(local_46: int, local_42: int, movement_666: int) -> int:
	var i_var19: int = local_46 + local_42 * 2
	if i_var19 < 0:
		i_var19 += 1
	var local_48: int
	if (i_var19 >> 1) < 0x10000:
		i_var19 = (i_var19 >> 1) * _to_s16(movement_666)
		if i_var19 < 0:
			i_var19 += 0xFFFF
		local_48 = (i_var19 & 0xFFFFFFFF) >> 16
	else:
		local_48 = _to_s16(movement_666)
	return _to_s16(local_48) >> 2

## [RECONSTRUCTED] Reverse-flight 0x626 clamps when field_63e!=0 and dir=='-' (14306–14319).
static func apply_movement_626_reverse_clamp(
	movement_626: int,
	i_var20: int,
	tpl_42: int,
	tpl_46: int,
	tpl_48: int
) -> int:
	var m626: int = _to_s16(movement_626)
	var t42: int = _to_s16(tpl_42)
	var t46: int = _to_s16(tpl_46)
	var t48: int = _to_s16(tpl_48)
	if t42 < m626:
		m626 = t42
	if i_var20 < t48:
		if t46 < i_var20:
			var denom: int = t48 - t46
			if denom != 0:
				var numer: int = (m626 - t42) * (i_var20 - t46)
				m626 = _to_s16(t42 + _div_trunc(numer, denom))
		else:
			m626 = t42
	return m626

## [RECONSTRUCTED] movement_626 += ((scale * (s21 - (626 - tpl_44)) + bias) >> 8) (14299–14304).
## e468 is NOT in this formula (used later at drag ~14356 / asm 0xEDF8).
static func apply_movement_626_step(
	movement_626: int,
	movement_662: int,
	i_var20: int,
	tpl_34: int,
	tpl_36: int,
	tpl_44: int
) -> int:
	var s21: int = movement_626_target_s21(movement_662, i_var20, tpl_34, tpl_36)
	var scale: int = movement_626_scale(i_var20)
	var cur: int = _to_s16(movement_626)
	var t44: int = _to_s16(tpl_44)
	var err: int = s21 - (cur - t44)
	var prod: int = scale * err
	if prod < 0:
		prod += 0xFF
	## Match (short)((uint)prod >> 8) then add to s16 accumulator.
	var delta: int = ((prod & 0xFFFFFFFF) >> 8) & 0xFFFF
	if (delta & 0x8000) != 0:
		delta -= 0x1_0000
	return _to_s16(cur + delta)

## Proven delta rule (Pacific Conflict.c:14182-14194, 14207-14220, 14230-14239): if |delta| < 8 add delta, else add (delta+7*(delta<0))>>3.
static func add_delta_smoothed_int(current: int, delta: int) -> int:
	var d: int = delta
	if d < 0:
		d += 7
	if (d >> 3) == 0:
		return current + delta
	return current + ((delta + (7 if delta < 0 else 0)) >> 3)

## Same rule for short (0x672); returns new value in short range.
static func add_delta_smoothed_s16(current_s16: int, delta: int) -> int:
	var current: int = current_s16 & 0xFFFF
	if (current & 0x8000) != 0:
		current -= 0x1_0000
	var d: int = delta
	if d < 0:
		d += 7
	var add_val: int
	if (d >> 3) == 0:
		add_val = delta
	else:
		add_val = (delta + (7 if delta < 0 else 0)) >> 3
	var result: int = current + add_val
	result = result & 0xFFFF
	return result - 0x1_0000 if (result & 0x8000) != 0 else result
