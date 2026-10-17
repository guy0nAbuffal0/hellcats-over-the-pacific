class_name RngOverlay11564
extends RefCounted
## Overlay RNG matching FUN_00011564 (Pacific Conflict.c:16407–16433).
## Init matching FUN_0001150a / FUN_000114ca (Pacific Conflict.c:16355–16385).
## Not the ID05 LCG (FUN_00000728). Do not substitute one for the other.
##
## [RECONSTRUCTED] Additive table step on a 56-word window at DAT_00026008..DAT_000260e4:
##   p4 = cursor+4 (wrap cursor-0xd8 if p4 > 0x260e7)
##   p5 = p4+0x17 words (wrap p4-0x20 words if past limit)
##   p3 = p4+0x36 words (wrap p4-1 word if past limit)
##   *p4 = *p5 + *p3; cursor = p4; return sum >> 16
##
## [INFERRED] Table length 56 from address span 0x26008..0x260e4 inclusive.

const TABLE_BASE: int = 0x26008
const TABLE_LIMIT: int = 0x260e7
const TABLE_WORDS: int = 56
const MOD32: int = 0x1_0000_0000
const FUN_000114CA_MUL: int = 0x1df5e0d
const FUN_0001150A_WARMUP: int = 10000

## uint32 words mirroring DAT_00026008[0..55].
var _table: Array = []
## Index of current DAT_00026008 cursor into _table.
var _cursor_index: int = 0

func _init(initial_seed: int = 0) -> void:
	## Named set_seed: GDScript global seed() would otherwise win inside _init.
	set_seed(initial_seed)

## [RECONSTRUCTED] FUN_000114ca (Pacific Conflict.c:16355–16359).
static func fun_000114ca(param_1: int, param_2: int) -> int:
	var a: int = _wrap_u32(param_1)
	var b: int = _wrap_u32(param_2)
	var cross: int = (b & 0xFFFF) * (a >> 16) + (a & 0xFFFF) * (b >> 16)
	return _wrap_u32(cross * 0x10000 + (b & 0xFFFF) * (a & 0xFFFF))

## Deterministic non-original fill for unit tests only (not FUN_0001150a).
func reset_linear_fixture() -> void:
	_table.clear()
	for i in range(TABLE_WORDS):
		_table.append(_wrap_u32(i * 0x10001 + 0x12345678))
	_cursor_index = _addr_to_index(0x260e4)

## [RECONSTRUCTED] FUN_0001150a fill + optional warm-up (Pacific Conflict.c:16363–16385).
## table[1] = param_1; for i in 1..0x36: table[i+1] = FUN_000114ca(0x1df5e0d, table[i]) + 1;
## cursor = 0x260e4; then warm_up_count × FUN_00011564.
func init_1150a(param_1: int, warm_up_count: int = FUN_0001150A_WARMUP) -> void:
	_table.clear()
	for _i in range(TABLE_WORDS):
		_table.append(0)
	## DAT_0002600c = param_1
	_table[1] = _wrap_u32(param_1)
	## [UNKNOWN] table[0] prior value before init; treat as 0.
	var i_var2: int = 1
	while i_var2 < 0x37:
		var src: int = int(_table[i_var2])
		_table[i_var2 + 1] = _wrap_u32(fun_000114ca(FUN_000114CA_MUL, src) + 1)
		i_var2 += 1
	_cursor_index = _addr_to_index(0x260e4)
	for _j in range(maxi(warm_up_count, 0)):
		next()

## Default seed path: original FUN_0001150a with full warm-up.
func set_seed(s: int) -> void:
	init_1150a(s, FUN_0001150A_WARMUP)

## Trace/replay fingerprint: cursor + first/last words (full table dump is large).
func get_state() -> Dictionary:
	return {
		"kind": "FUN_00011564",
		"cursor_index": _cursor_index,
		"word0": get_table_word(0),
		"word1": get_table_word(1),
		"word55": get_table_word(55),
	}

func set_table(words: Array, cursor_index: int) -> void:
	_table.clear()
	for i in range(TABLE_WORDS):
		var v: int = int(words[i]) if i < words.size() else 0
		_table.append(_wrap_u32(v))
	_cursor_index = clampi(cursor_index, 0, TABLE_WORDS - 1)

func get_cursor_index() -> int:
	return _cursor_index

func get_table_word(index: int) -> int:
	if index < 0 or index >= _table.size():
		return 0
	return int(_table[index])

static func _wrap_u32(value: int) -> int:
	return posmod(value, MOD32)

static func _addr_to_index(addr: int) -> int:
	return (addr - TABLE_BASE) >> 2

static func _index_to_addr(index: int) -> int:
	return TABLE_BASE + (index << 2)

## [INFERRED] Call-site "FUN_00011544" draw ≡ one FUN_00011564 step.
## Binary evidence (Hellcats/Pacific Conflict):
##   - 17× `LEA.L $11544; JSR (An)` then use D0 as u16 (&0x7f/0x3f/…).
##   - Bytes at $11544: 1150a warm-up epilogue (cursor+=0xd8; 10000×BSR $11564; MOVEM; RTS).
##   - Bytes at $11564: overlay RNG (this.next). Zero LEA/JSR absolutes to $11564.
## Executing $11544 as written would be 10k draws + unbalanced MOVEM — not viable per tick.
## D0 convention matches 11564 (sum>>16). Alias until a trampoline/reloc disproves this.
func fun_00011544_callsite() -> int:
	return next()

## One FUN_00011564 draw; returns high 16 bits of the stored sum.
func next() -> int:
	var cursor_addr: int = _index_to_addr(_cursor_index)
	var p4: int = cursor_addr + 4
	if p4 > TABLE_LIMIT:
		p4 = cursor_addr - 0xd8
	var p5: int = p4 + 0x17 * 4
	if p5 > TABLE_LIMIT:
		p5 = p4 - 0x20 * 4
	var p3: int = p4 + 0x36 * 4
	if p3 > TABLE_LIMIT:
		p3 = p4 - 4
	var i4: int = _addr_to_index(p4)
	var i5: int = _addr_to_index(p5)
	var i3: int = _addr_to_index(p3)
	var u1: int = int(_table[i5])
	var u2: int = int(_table[i3])
	var sum: int = _wrap_u32(u1 + u2)
	_table[i4] = sum
	_cursor_index = i4
	return (sum >> 16) & 0xFFFF
