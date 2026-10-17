extends RefCounted
## Deterministic fixtures for FUN_00011564 / FUN_0001150a.

const Assertions := preload("res://tests/helpers/assertions.gd")
const RngOverlayScript := preload("res://hellcats/core/rng_overlay_11564.gd")

## Linear-fixture outputs (reset_linear_fixture, not 1150a).
const LINEAR_FIXTURE_OUTPUTS := [9399, 14085, 18771, 23458, 28147, 32836, 37526, 42218]

## After FUN_0001150a(0) fill only (no warm-up).
const FILL0_WORD2 := 1
const FILL0_WORD3 := 31415822
const FILL0_WORD55 := 426280394

## After FUN_0001150a(0) + 10000 warm-up draws.
const WARM0_CURSOR := 45
const WARM0_NEXT4 := [42625, 59345, 6542, 14398]

func run() -> bool:
	var ok := true
	ok = _test_linear_fixture_sequence() and ok
	ok = _test_fun_000114ca() and ok
	ok = _test_fun_0001150a_fill() and ok
	ok = _test_fun_0001150a_warmup() and ok
	ok = _test_not_id05_lcg() and ok
	return ok

func _test_linear_fixture_sequence() -> bool:
	var rng = RngOverlayScript.new(0)
	rng.reset_linear_fixture()
	var ok := Assertions.assert_true(rng.get_cursor_index() == 55, "linear cursor at 0x260e4 index")
	for i in range(LINEAR_FIXTURE_OUTPUTS.size()):
		var got: int = rng.next()
		ok = Assertions.assert_true(
			got == int(LINEAR_FIXTURE_OUTPUTS[i]),
			"linear fixture[%d]: got %d want %d" % [i, got, int(LINEAR_FIXTURE_OUTPUTS[i])]
		) and ok
	return ok

func _test_fun_000114ca() -> bool:
	var ok := Assertions.assert_true(
		RngOverlayScript.fun_000114ca(0x1df5e0d, 0) == 0,
		"114ca(mul,0)==0"
	)
	ok = Assertions.assert_true(
		RngOverlayScript.fun_000114ca(0x1df5e0d, 1) + 1 == FILL0_WORD3,
		"114ca(mul,1)+1 matches fill word3"
	) and ok
	return ok

func _test_fun_0001150a_fill() -> bool:
	var rng = RngOverlayScript.new(0)
	rng.init_1150a(0, 0)
	var ok := Assertions.assert_true(rng.get_table_word(1) == 0, "1150a table[1]==param")
	ok = Assertions.assert_true(rng.get_table_word(2) == FILL0_WORD2, "1150a table[2]") and ok
	ok = Assertions.assert_true(rng.get_table_word(3) == FILL0_WORD3, "1150a table[3]") and ok
	ok = Assertions.assert_true(rng.get_table_word(55) == FILL0_WORD55, "1150a table[55]") and ok
	ok = Assertions.assert_true(rng.get_cursor_index() == 55, "1150a cursor before warm-up") and ok
	return ok

func _test_fun_0001150a_warmup() -> bool:
	var rng = RngOverlayScript.new(0)
	## set_seed / _init path
	var ok := Assertions.assert_true(rng.get_cursor_index() == WARM0_CURSOR, "1150a warm cursor")
	for i in range(WARM0_NEXT4.size()):
		var got: int = rng.next()
		ok = Assertions.assert_true(
			got == int(WARM0_NEXT4[i]),
			"1150a warm next[%d]: got %d want %d" % [i, got, int(WARM0_NEXT4[i])]
		) and ok
	return ok

func _test_not_id05_lcg() -> bool:
	const Rng68kScript := preload("res://hellcats/core/rng.gd")
	var overlay = RngOverlayScript.new(0x12345678)
	var lcg = Rng68kScript.new(0x12345678)
	var same := 0
	for _i in 8:
		if overlay.next() == lcg.next():
			same += 1
	return Assertions.assert_true(same < 8, "overlay 11564 sequence differs from ID05 LCG")
