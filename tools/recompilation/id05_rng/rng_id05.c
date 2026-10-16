#include "rng_id05.h"

enum {
	LCG_MUL = 0x41c64e6du,
	LCG_ADD = 0x3039u
};

void rng_id05_seed(uint32_t *state, uint32_t seed)
{
	*state = seed;
}

uint16_t rng_id05_next(uint32_t *state)
{
	uint32_t s = *state;
	s = (uint32_t)(s * LCG_MUL + LCG_ADD);
	*state = s;
	/* Match Ghidra: (uint)(state << 1) >> 0x11 */
	return (uint16_t)((s << 1) >> 17);
}
