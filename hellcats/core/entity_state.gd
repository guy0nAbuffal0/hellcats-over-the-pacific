class_name EntityState
extends RefCounted
## Entity state with only proven offsets (Pacific Conflict / FUN_0000e792, FUN_000041ec).
## Store as Dictionary keyed by offset name; can swap to PackedByteArray later.

## Proven offset keys (string) -> int value. Use 32-bit where original is 32-bit.
const OFFSETS := {
	"field_00": 0x00,   # type byte
	"field_01": 0x01,   # [RECONSTRUCTED] used by FUN_0000528a / FUN_000051ec
	"field_02": 0x02,   # [RECONSTRUCTED] compared to field_01 in FUN_000051ec
	"field_04": 0x04,
	"field_0b": 0x0b,   # [RECONSTRUCTED] FUN_0000e792 contact: == 0x10 sets status 0x1000
	"flags_07": 0x07,   # [RECONSTRUCTED] FUN_0000528a early-out when bit 1 set
	"entity_data_ptr": 0x08,
	"attitude_0e": 0x0e,  # [RECONSTRUCTED] pitch short; *0x10 vs -0x168/-0xd8 on landing (14450–14460)
	"position_velocity_c": 0x0c,
	"ptr_10": 0x10,
	"ptr_14": 0x14,
	"pos_18": 0x18,
	"pos_1c": 0x1c,
	"pos_20": 0x20,  # [RECONSTRUCTED] also local_28 / *(param_1+8) attitude ushort (14064, 14467)
	"attitude_22": 0x22,  # [RECONSTRUCTED] local_2a reverse attitude (Pacific Conflict.c:14065, 14341–14342)
	"field_24": 0x24,   # [RECONSTRUCTED] sVar17 / *(param_1+9); also DAT_0001d6fc compare in FUN_0000528a
	"pos_2e": 0x2e,
	"state_32": 0x32,
	"count_3a": 0x3a,
	"field_3c": 0x3c,   # [RECONSTRUCTED] written by FUN_0000528a / FUN_000051ec (32-bit)
	"ptr_48": 0x48,
	"index_50": 0x50,
	"movement_61a": 0x61a,
	"movement_61e": 0x61e,
	"movement_626": 0x626,  # [RECONSTRUCTED] FUN_0000e792 speed accumulator (Pacific Conflict.c:14299–14304)
	"movement_634": 0x634,  # [RECONSTRUCTED] sVar12 term (param_1+0x18d as int*)
	"movement_636": 0x636,  # [RECONSTRUCTED] thrust accumulator (Pacific Conflict.c:14379–14382)
	"movement_63a": 0x63a,  # [RECONSTRUCTED] smoothed thrust index after e4a4
	"field_63e": 0x63e,  # [RECONSTRUCTED] reverse-flight / gear flag (Pacific Conflict.c:14305)
	"field_63f": 0x63f,  # [RECONSTRUCTED] pre-stall gate with field_190 (Pacific Conflict.c:14601–14603)
	"movement_662": 0x662,
	"movement_666": 0x666,
	"movement_62a": 0x62a,
	"movement_669": 0x669,
	"movement_66a": 0x66a,
	"movement_66e": 0x66e,
	"movement_672": 0x672,
	"weapon_count_67c": 0x67c,
	"weapon_count_67d": 0x67d,
	"weapon_count_67e": 0x67e,
	"field_676": 0x676,  # [RECONSTRUCTED] e792 secondary weapon phase; fire at 1, wrap 2→0 (14673–14693)
	"field_677": 0x677,  # [RECONSTRUCTED] e792 tertiary weapon; 1→fire→2 (14695–14702)
	"field_682": 0x682,  # [RECONSTRUCTED] ammo/count for 676 fire; -=2 (14674–14685)
	"field_67b": 0x67b,  # [RECONSTRUCTED] e4a4 throttle char; e792 epilogue increments
	"direction_char_679": 0x679,
	"field_67a": 0x67a,  # [RECONSTRUCTED] e792 char epilogue ORs 2 (14639–14645)
	"flags_685": 0x685,
	"field_18c": 0x18c,  # [RECONSTRUCTED] added into local_a before >>6; reset to 0xffa5 (14441–14442)
	"field_18d": 0x18d,  # [RECONSTRUCTED] e792 weapon branch -=0x10 when mission+0x90!=2 (14661–14662)
	"field_18e": 0x18e,  # [RECONSTRUCTED] 0x63e vertical/thrust accumulator (Pacific Conflict.c:14411–14416)
	"field_190": 0x190,  # [RECONSTRUCTED] stall state byte (param_1+400); 1→penalty, 2→stalled (14422–14428)
	"field_199": 0x199,  # [RECONSTRUCTED] local_48 source in 626 block (Pacific Conflict.c:14278–14297)
	"field_19a": 0x19a,
	"field_19d": 0x19d,  # [RECONSTRUCTED] e792 weapon phase; fire at 1, wrap 4→0 (14648–14671)
	"field_19e": 0x19e,  # [RECONSTRUCTED] e4a4 overspeed / countdown byte
	"field_19f": 0x19f,  # [RECONSTRUCTED] e792 weapon ammo/count; decremented on fire (14660)
	"field_610": 0x610,  # [RECONSTRUCTED] FUN_00012840 writes param_1 (speed) (17566)
	"field_614": 0x614,  # [RECONSTRUCTED] player fire latch short*[0x30a]=1 (14657)
	"field_61c": 0x61c,  # [RECONSTRUCTED] FUN_00012840 ORs 0x40 when param_2!=0 (17563–17564)
	"field_641": 0x641,  # [RECONSTRUCTED] adds tpl+0x32 into 63e thrust (14394)
	"status_1a0": 0x1a0,
	"status_1a1": 0x1a1,
	"status_1a2": 0x1a2,  # [RECONSTRUCTED] bVar6 cleanup clamp/clear (14737–14741)
	"status_1a3": 0x1a3,
}

var data: Dictionary = {}
var external_template: RefCounted = null
## [RECONSTRUCTED] iVar1 = *param_1 — word at entity+0 is a pointer (Pacific Conflict.c:14061, 7354, 7671).
## Surface height is *(world_obj_ptr + 0x1c). field_00 type byte may overlay byte 0 of this word on BE;
## kept as a separate Dictionary key until a byte-accurate entity buffer exists.
var world_obj_ptr: int = 0

func _init() -> void:
	for key in OFFSETS:
		data[key] = 0

func get_field(key: String) -> int:
	return data.get(key, 0) as int

func set_field(key: String, value: int) -> void:
	data[key] = value & 0xFFFFFFFF if value >= 0 else (value + 0x1_0000_0000) & 0xFFFFFFFF

func get_u8_field(key: String) -> int:
	return get_field(key) & 0xFF

func get_s8_field(key: String) -> int:
	var value := get_u8_field(key)
	return value - 0x100 if (value & 0x80) != 0 else value

func get_u16_field(key: String) -> int:
	return get_field(key) & 0xFFFF

func get_s16_field(key: String) -> int:
	var value := get_u16_field(key)
	return value - 0x1_0000 if (value & 0x8000) != 0 else value

func set_u8_field(key: String, value: int) -> void:
	data[key] = value & 0xFF

func set_s8_field(key: String, value: int) -> void:
	data[key] = value & 0xFF

func set_u16_field(key: String, value: int) -> void:
	data[key] = value & 0xFFFF

func set_s16_field(key: String, value: int) -> void:
	data[key] = value & 0xFFFF

## Optional: build from PackedByteArray when format is fixed (big-endian).
## Return type is untyped so headless runs work without a global class_name cache.
static func from_bytes(_buf: PackedByteArray, _base: int):
	var e = new()
	# TODO: decode when layout is final
	return e
