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

## [RECONSTRUCTED] LAB_0000f47c yaw epilogue (14606–14629).
## Clears field_63f; writes pos_20/attitude_22; blends field_24 from uVar13 +
## e40c(local_2a−attitude_22)*scale>>12; writes movement_62a; player ring
## DAT_0001bc8c[0x78] / bc80 / bc84.
## scale_01d56: injected stand-in for FUN_00001d56 (Ghidra body unusable).
## [UNKNOWN] real FUN_00001d56 — callers treat return as signed short scale.
static func apply_lab_0000f47c(
	local_28: int,
	local_2a: int,
	attitude_22_before: int,
	u_var13: int,
	i_var20_speed: int,
	scale_01d56: int,
	is_player: bool,
	dat_0001bc80: int,
	dat_0001bc84: int,
	ring_slot_at_next: int
) -> Dictionary:
	var scale: int = _to_s16(scale_01d56)
	var i_var25: int = fun_0000e40c(_to_s16(local_2a) - _to_s16(attitude_22_before))
	var field_24: int = (
		(u_var13 & 0x3FFF) + _to_s16((i_var25 * scale) >> 12)
	) & 0x3FFF
	var ring_val: int = 0
	var next_bc80: int = dat_0001bc80
	var next_bc84: int = dat_0001bc84 & 0xFFFF
	var wrote_ring: bool = false
	if is_player:
		## (speed * ((scale<<13)>>12)) / 0x1ce ; clamp ±0x1d80
		var scaled: int = (scale << 13) >> 12
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
static var _trig_sin_table: PackedInt32Array = PackedInt32Array()
static var _trig_cos_table: PackedInt32Array = PackedInt32Array()
static var _trig_af6c_table: PackedInt32Array = PackedInt32Array()
static var _trig_tables_from_dump: bool = false
static var _trig_af6c_from_dump: bool = false

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

## [RECONSTRUCTED] FUN_000021a0 — fourth-angle matrix DAT_0001d78c (2716–2728).
static func fun_000021a0(sc: Dictionary) -> Array:
	var c3: int = int(sc.get("c3", 0x1000))
	var s3: int = int(sc.get("s3", 0))
	return [c3, 0, s3, 0, 0x1000, 0, -s3, 0, c3]

## [RECONSTRUCTED] FUN_00002562 — M78c*M7a4*M7d4*M7bc into out (2929–2937).
static func fun_00002562(m_78c: Array, m_7a4: Array, m_7d4: Array, m_7bc: Array) -> Array:
	var out: Array = fun_00001d02(m_78c, m_7a4)
	var tmp: Array = fun_00001d02(out, m_7d4)
	return fun_00001d02(tmp, m_7bc)

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
