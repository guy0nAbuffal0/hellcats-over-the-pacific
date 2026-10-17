class_name WorldBuilderMvp
extends Node3D

## [MVP AUTHORING DECISION] Solid volumes match the placeholder meshes below.
const SEA_SURFACE_Y: float = 0.0
const SEA_IMPACT_Y: float = 0.5
const ISLAND_CENTER: Vector3 = Vector3(0.0, -24.0, 2600.0)
const ISLAND_SIZE: Vector3 = Vector3(1200.0, 50.0, 1200.0)

## Axis-aligned island solid (same as BoxMesh at ISLAND_CENTER / ISLAND_SIZE).
static func island_aabb() -> AABB:
	return AABB(ISLAND_CENTER - ISLAND_SIZE * 0.5, ISLAND_SIZE)

## Empty string = no impact; otherwise a failure reason for Mission 1.
static func impact_reason_at(world_position: Vector3) -> String:
	if island_aabb().has_point(world_position):
		return "island_impact"
	if world_position.y <= SEA_IMPACT_Y:
		return "terrain_or_sea_impact"
	return ""

func _ready() -> void:
	_ensure_environment()
	_ensure_light()
	_ensure_sea()
	_ensure_island()
	_ensure_sun_disk()

func _ensure_environment() -> void:
	var environment_node: WorldEnvironment = get_node_or_null("WorldEnvironment")
	if environment_node == null:
		environment_node = WorldEnvironment.new()
		environment_node.name = "WorldEnvironment"
		add_child(environment_node)
	var environment := Environment.new()
	var sky := Sky.new()
	var proc := ProceduralSkyMaterial.new()
	proc.sky_top_color = Color(0.12, 0.28, 0.62)
	proc.sky_horizon_color = Color(0.55, 0.72, 0.9)
	proc.ground_bottom_color = Color(0.02, 0.08, 0.16)
	proc.ground_horizon_color = Color(0.06, 0.22, 0.42)
	proc.sky_curve = 0.08
	proc.ground_curve = 0.02
	sky.sky_material = proc
	environment.background_mode = Environment.BG_SKY
	environment.sky = sky
	environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	environment.ambient_light_color = Color(0.72, 0.8, 0.9)
	environment.fog_enabled = true
	environment.fog_mode = Environment.FOG_MODE_EXPONENTIAL
	environment.fog_density = 0.00035
	environment.fog_light_color = Color(0.78, 0.86, 0.98)
	environment.fog_sky_affect = 0.35
	environment_node.environment = environment

func _ensure_light() -> void:
	var light: DirectionalLight3D = get_node_or_null("SunLight")
	if light == null:
		light = DirectionalLight3D.new()
		light.name = "SunLight"
		add_child(light)
	light.rotation_degrees = Vector3(-38.0, -32.0, 0.0)
	light.light_energy = 1.35
	light.shadow_enabled = true

func _ensure_sea() -> void:
	var sea: MeshInstance3D = get_node_or_null("Sea")
	if sea == null:
		sea = MeshInstance3D.new()
		sea.name = "Sea"
		add_child(sea)
	var plane := PlaneMesh.new()
	plane.size = Vector2(20000.0, 20000.0)
	sea.mesh = plane
	var material := StandardMaterial3D.new()
	material.albedo_color = Color(0.05, 0.22, 0.42)
	material.roughness = 0.12
	material.metallic = 0.02
	sea.set_surface_override_material(0, material)
	sea.position = Vector3(0.0, SEA_SURFACE_Y, 0.0)
	_ensure_sea_body()

func _ensure_sea_body() -> void:
	var body: StaticBody3D = get_node_or_null("SeaBody")
	if body == null:
		body = StaticBody3D.new()
		body.name = "SeaBody"
		add_child(body)
	var shape_node: CollisionShape3D = body.get_node_or_null("CollisionShape3D")
	if shape_node == null:
		shape_node = CollisionShape3D.new()
		shape_node.name = "CollisionShape3D"
		body.add_child(shape_node)
	## Thin box under the sea plane so kinematic queries can hit open water.
	var box := BoxShape3D.new()
	box.size = Vector3(20000.0, 2.0, 20000.0)
	shape_node.shape = box
	body.position = Vector3(0.0, SEA_SURFACE_Y - 1.0, 0.0)

func _ensure_island() -> void:
	var island: MeshInstance3D = get_node_or_null("Island")
	if island == null:
		island = MeshInstance3D.new()
		island.name = "Island"
		add_child(island)
	var mesh := BoxMesh.new()
	mesh.size = ISLAND_SIZE
	island.mesh = mesh
	island.position = ISLAND_CENTER
	var material := StandardMaterial3D.new()
	material.albedo_color = Color(0.34, 0.48, 0.24)
	material.roughness = 0.95
	island.set_surface_override_material(0, material)
	_ensure_island_body()

func _ensure_island_body() -> void:
	var body: StaticBody3D = get_node_or_null("IslandBody")
	if body == null:
		body = StaticBody3D.new()
		body.name = "IslandBody"
		add_child(body)
	var shape_node: CollisionShape3D = body.get_node_or_null("CollisionShape3D")
	if shape_node == null:
		shape_node = CollisionShape3D.new()
		shape_node.name = "CollisionShape3D"
		body.add_child(shape_node)
	var box := BoxShape3D.new()
	box.size = ISLAND_SIZE
	shape_node.shape = box
	body.position = ISLAND_CENTER

func _ensure_sun_disk() -> void:
	var disk: MeshInstance3D = get_node_or_null("SunDisk")
	if disk == null:
		disk = MeshInstance3D.new()
		disk.name = "SunDisk"
		add_child(disk)
	var quad := QuadMesh.new()
	quad.size = Vector2(4200.0, 4200.0)
	disk.mesh = quad
	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color(1.0, 0.98, 0.85)
	mat.emission_enabled = true
	mat.emission = Color(1.0, 0.95, 0.75) * 0.6
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mat.albedo_color.a = 0.55
	mat.cull_mode = BaseMaterial3D.CULL_DISABLED
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mat.billboard_mode = BaseMaterial3D.BILLBOARD_ENABLED
	disk.set_surface_override_material(0, mat)
	disk.position = Vector3(-14000.0, 9500.0, -9000.0)
