class_name StrictPacificConflict
extends RefCounted
## Strict translations owned by the Pacific Conflict CODE overlay.
## Provenance and verification state live in mappings/functions.json.

const C68kScript := preload("res://strict_port/compat/c68k.gd")

## source_function: contact_pair_hash (Original: FUN_0001358c)
## source_address: 0x1358c
## Source parameter names, expression order, and byte result are preserved.
static func contact_pair_hash(param_1: int, param_2: int) -> int:
	return C68kScript.u8(C68kScript.u8(param_1) ^ (C68kScript.s8(param_2) << 2))
