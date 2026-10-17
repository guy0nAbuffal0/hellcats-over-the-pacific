#include "rng_id05.h"

#include <stdio.h>
#include <stdint.h>

/* Vectors aligned with godot/hellcats/tests/test_rng.gd (seed 0, five next()). */
static int test_seed0_sequence(void)
{
	uint32_t state = 0;
	uint32_t s = 0;
	int i;
	for (i = 0; i < 5; i++) {
		uint16_t want;
		uint16_t got;
		s = (uint32_t)(s * 0x41c64e6du + 0x3039u);
		want = (uint16_t)((s << 1) >> 17);
		got = rng_id05_next(&state);
		if (got != want || state != s) {
			fprintf(stderr, "FAIL seed0[%d] got=%u want=%u state=0x%x want_state=0x%x\n",
				i, got, want, state, s);
			return 1;
		}
	}
	puts("PASS seed0 sequence");
	return 0;
}

static int test_seed1_state(void)
{
	uint32_t state;
	uint32_t want;
	rng_id05_seed(&state, 1);
	(void)rng_id05_next(&state);
	want = (uint32_t)(1u * 0x41c64e6du + 0x3039u);
	if (state != want) {
		fprintf(stderr, "FAIL seed1 state 0x%x want 0x%x\n", state, want);
		return 1;
	}
	puts("PASS seed1 state");
	return 0;
}

int main(void)
{
	int rc = 0;
	rc |= test_seed0_sequence();
	rc |= test_seed1_state();
	puts(rc ? "SOME FAIL" : "ALL PASS");
	return rc;
}
