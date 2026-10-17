class_name StrictPacificConflict
extends RefCounted
## Strict translations owned by the Pacific Conflict CODE overlay.
## The sole provenance and verification record lives in mappings/functions.json.

const C68kScript := preload("res://strict_port/compat/c68k.gd")

const DAT_0001bdbc: int = 0x1bdbc
const _DAT_0002666e: int = 0x2666e
const DAT_00026672: int = 0x26672
const DAT_00026676: int = 0x26676

var memory

func _init(param_memory = null) -> void:
	memory = param_memory

## Source parameter names, expression order, and byte result are preserved.
static func contact_pair_hash(param_1: int, param_2: int) -> int:
	return C68kScript.u8(C68kScript.u8(param_1) ^ (C68kScript.s8(param_2) << 2))

func find_contact_record(param_1: int, param_2: int) -> int:
	assert(memory != null, "find_contact_record requires original global memory")
	var piVar1: int
	var bVar3: int
	var uVar2: int
	var sVar4: int

	bVar3 = contact_pair_hash(C68kScript.u8(param_1), C68kScript.s8(param_2))
	uVar2 = bVar3
	sVar4 = 0x100
	while true:
		sVar4 = C68kScript.s16(sVar4 - 1)
		if sVar4 == -1:
			return 0
		piVar1 = memory.read_u32(DAT_0001bdbc + C68kScript.s16(uVar2) * 4)
		if piVar1 != 0 and param_1 == memory.read_u32(piVar1) and param_2 == memory.read_u32(piVar1 + 4):
			break
		uVar2 = C68kScript.u32((C68kScript.s16(uVar2) + 1) & 0xff)
	return piVar1

func reset_radar_tracks() -> void:
	assert(memory != null, "reset_radar_tracks requires original global memory")
	memory.write_u32(DAT_00026672, 0)
	memory.write_u32(DAT_00026676, 0)
	memory.write_u8(_DAT_0002666e, 1)
	return
