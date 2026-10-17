# Sound system (ID02) — iterations 138–142, 2026-10-16/17

Summary of the application-side sound code in CODE segment 2. Offsets are
physical file offsets in `ID02.bin`. Byte sequences and data layouts are
**[PROVEN]**; names of low-memory globals and traps come from Inside
Macintosh (**[STRONG INFERENCE]**); interpretations are marked.

## Hardware model

The game drives the classic Macintosh sound buffer directly: low-memory
`SoundBase` (`$0266`) points to a 370-word buffer whose high bytes are
unsigned 8-bit samples (0x80 = silence). It is refilled from a hook on the
vertical-blanking level-1 interrupt vector, `Lvl1DT[1]` at low-memory
`$0196` (table `Lvl1DT` at `$0192`).

## Data structures

| Address | Layout | Notes |
|---|---|---|
| `A5-0x7d0` | 2 channel records × 0x238 bytes | channel 1 at `A5-0x598` |
| record +0x000 | long: current (head) node | set by `play_sample_on_channel` |
| record +0x004 | long: free-list head | popped by `alloc_sound_buffer_node` |
| record +0x008 | 20 nodes × 0x1c bytes | linked via node +0x14 at init |
| record +0x230 | long: tail pointer | initialised to record+8 |
| node +0x00 | long: cursor (current position) | |
| node +0x04 | long: fraction (cleared) | 32.32 resampling accumulator |
| node +0x08 | long: sample buffer | |
| node +0x0c / +0x10 | long: start / end offsets | |
| node +0x14 | long: free-list link | |
| node +0x18 | long: continuation (next node, or itself to loop) | |
| `A5-0xc26` | 0x456 bytes = 0x80 | silence source (3 × 370) |
| `A5-0xc32` / `-0xc2e` / `-0xc2a` | step integer / fraction / 370 | init values 1, 0, 0x172 |
| `A5-0xc38` | word: sound active | |
| `A5-0xc36` | long: saved previous `$0196` vector | |
| `A5-0x360` / `A5-0x35c` | single-channel / two-channel handler addresses | JT entries |
| `A5-0x356` | Sound Manager channel | `SndDisposeChannel` at shutdown |

## Functions

| ID02 file | Name | Role |
|---|---|---|
| 0x3dd0 | `init_sound_system` | build records, silence, prime handlers, hook `$0196` |
| 0x3d50 | `alloc_sound_buffer_node` | pop + fill a node |
| 0x3f54 | `play_sample_on_channel` | queue sample (optional sustain loop); service slot `-0x10de` |
| 0x4050 | `enqueue_sample_on_channel` | as play, without setting the channel head; service slot `-0x10da` |
| 0x412e | `set_sound_playback_rate` | 16.16 rate clamped 0.5x..3x → step and samples-per-VBL; slot `-0x10d6` |
| 0x41a6 | `release_channel_loop` | append silence, un-loop every node up to it; slot `-0x10ce` |
| 0x42b0 | `is_channel_playing` | current node buffer ≠ silence; slot `-0x10d2` |
| 0x4242 | `silence_sound_channel` | queue looping silence; service slot `-0x10ca` |
| 0x3d36 | `clear_sound_buffer_to_silence` | 370 × 0x80 into `SoundBase` |
| 0x39a8 | `vbl_sound_handler_ch0_unrolled` | VBL refill, channel 0 (×8 unrolled) |
| 0x3aae | `vbl_sound_handler_ch0_variant` | VBL refill, channel 0 (alternative) |
| 0x3bc4 | `vbl_sound_handler_two_channel` | VBL refill mixing channels 0 and 1 |
| 0x3db8 | `select_two_channel_sound_handler` | `$0196` ← two-channel handler when ch == 1 |
| 0x4318 | `shutdown_sound` | silence, restore `$0196`, clear buffer, `SndDisposeChannel` |

## VBL handler pattern [PROVEN, bytes]

1. `CLR.L -(A7)` reserves a return slot; `MOVEM.L D0-D7/A0-A6,-(A7)`.
2. A5 is loaded from a long stored inside the handler's own code. If it is
   zero (the priming call made by `init_sound_system`), the handler stores
   `CurrentA5` there and returns immediately (self-modifying code).
3. Otherwise the saved old vector (`A5-0xc36`) is written into the reserved
   slot, the buffer is refilled, registers are restored and `RTS` jumps to
   the previous handler (chaining).

## Sound resources (iteration 218)

| ID02 file | Name | Role |
|---|---|---|
| 0x1edc | `load_named_sound_into_slot` | GetNamedResource('snd ', name), memory check (0x3000 bytes), mark purgeable, store in slot `A5-0xd62[i]` |
| 0x1e68 | `release_sound_slots` | 20 slots: RecoverHandle(slot - 0x14), HPurge, HUnlock, clear |
| 0x1dd4 | `show_sound_error_dialog_once` | DLOG 139 "Sound Error", shown once |
| 0x1f8e | `load_game_sounds` | 11 named sounds into slots 0, 1, 2, 5–12 (slot 0 variant chosen by free memory > 0x2e400); `A5-0x112a` = &slots for the overlay |
| 0x20be | `lock_sound_slots` | HLock each handle, slot = data pointer *h + 0x14 |

## Open questions

- Exact difference between the two channel-0 handler variants.
- End-of-buffer and continuation handling inside the handlers.
- Whether nodes from `enqueue_sample_on_channel` are actually reached
  (depends on handler end-of-buffer logic).
- ~~How the three-node sustain loop is released~~ — `release_channel_loop`
  (iteration 144) rewrites continuations to break self-loops.
