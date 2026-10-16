#ifndef RNG_ID05_H
#define RNG_ID05_H

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

/* ID05.c FUN_00000746 — seed A5[-0x6c] style state. */
void rng_id05_seed(uint32_t *state, uint32_t seed);

/* ID05.c FUN_00000728 — LCG step + 15-bit extract.
 * state = state * 0x41c64e6d + 0x3039  (mod 2^32)
 * return (state << 1) >> 17   as unsigned 15-bit value
 */
uint16_t rng_id05_next(uint32_t *state);

#ifdef __cplusplus
}
#endif

#endif /* RNG_ID05_H */
