extends RefCounted
## Mission 1 placeholder solids: sea impact y and island AABB match WorldBuilderMvp meshes.

const WorldBuilderScript := preload("res://hellcats/world/world_builder_mvp.gd")

func run() -> bool:
	var ok := true
	ok = _check_sea_open_water() and ok
	ok = _check_island_volume() and ok
	ok = _check_clear_air() and ok
	ok = _check_island_aabb_matches_constants() and ok
	return ok

func _check_sea_open_water() -> bool:
	## Open water away from the island footprint.
	var reason: String = WorldBuilderScript.impact_reason_at(Vector3(0.0, 0.5, 0.0))
	if reason != "terrain_or_sea_impact":
		print("FAIL sea at y=0.5 expected terrain_or_sea_impact got '%s'" % reason)
		return false
	reason = WorldBuilderScript.impact_reason_at(Vector3(0.0, 0.51, 0.0))
	if not reason.is_empty():
		print("FAIL sea just above threshold should clear, got '%s'" % reason)
		return false
	return true

func _check_island_volume() -> bool:
	## Top of island box is at y = -24 + 25 = 1.0; center xz is island.
	var on_top: String = WorldBuilderScript.impact_reason_at(Vector3(0.0, 0.9, 2600.0))
	if on_top != "island_impact":
		print("FAIL island top expected island_impact got '%s'" % on_top)
		return false
	var through_core: String = WorldBuilderScript.impact_reason_at(Vector3(0.0, -10.0, 2600.0))
	if through_core != "island_impact":
		print("FAIL island core expected island_impact got '%s'" % through_core)
		return false
	## Above the box top is clear even over the island xz.
	var above: String = WorldBuilderScript.impact_reason_at(Vector3(0.0, 1.1, 2600.0))
	if not above.is_empty():
		print("FAIL above island should clear, got '%s'" % above)
		return false
	return true

func _check_clear_air() -> bool:
	var reason: String = WorldBuilderScript.impact_reason_at(Vector3(100.0, 500.0, 100.0))
	if not reason.is_empty():
		print("FAIL clear air got '%s'" % reason)
		return false
	return true

func _check_island_aabb_matches_constants() -> bool:
	var aabb: AABB = WorldBuilderScript.island_aabb()
	var expected_pos: Vector3 = WorldBuilderScript.ISLAND_CENTER - WorldBuilderScript.ISLAND_SIZE * 0.5
	if aabb.position != expected_pos or aabb.size != WorldBuilderScript.ISLAND_SIZE:
		print("FAIL island_aabb mismatch pos=%s size=%s" % [aabb.position, aabb.size])
		return false
	return true
