class_name EntityTemplate
extends RefCounted
## External pointed-to record at param_1[1]; only proven offsets added here.

const OFFSETS := {
	"field_1e": 0x1e,
	"field_20": 0x20,  # [RECONSTRUCTED] drag/thrust template (Pacific Conflict.c:14356–14380)
	"field_22": 0x22,
	"field_24": 0x24,
	"field_26": 0x26,
	"field_28": 0x28,
	"field_2a": 0x2a,
	"field_2c": 0x2c,
	"field_2e": 0x2e,  # [RECONSTRUCTED] 0x63e / 0x18e thrust (Pacific Conflict.c:14388–14395)
	"field_30": 0x30,
	"field_32": 0x32,
	"field_34": 0x34,  # [RECONSTRUCTED] FUN_0000e792 movement_626 scale (Pacific Conflict.c:14250–14263)
	"field_36": 0x36,
	"field_38": 0x38,
	"field_3c": 0x3c,
	"field_3e": 0x3e,
	"field_40": 0x40,
	"field_42": 0x42,
	"field_44": 0x44,
	"field_46": 0x46,
	"field_48": 0x48,
}

var data: Dictionary = {}

func _init() -> void:
	for key in OFFSETS:
		data[key] = 0

func get_field(key: String) -> int:
	return data.get(key, 0) as int

func set_field(key: String, value: int) -> void:
	data[key] = value & 0xFFFFFFFF if value >= 0 else (value + 0x1_0000_0000) & 0xFFFFFFFF

func get_u16_field(key: String) -> int:
	return get_field(key) & 0xFFFF

func get_s16_field(key: String) -> int:
	var value := get_u16_field(key)
	return value - 0x1_0000 if (value & 0x8000) != 0 else value

func set_u16_field(key: String, value: int) -> void:
	data[key] = value & 0xFFFF

func set_s16_field(key: String, value: int) -> void:
	data[key] = value & 0xFFFF
