# Ghidra automation

## Install

| Item | Value |
|------|-------|
| Distribution | NSA public binary zip **Ghidra 12.1.4** |
| Path | `/Users/math/Sites/tests/ghidra_12.1.x` |
| Headless | `support/analyzeHeadless` (present) |
| GUI | `ghidraRun` (present) |
| Java | **JDK 21** required (`application.java.min=21`). Local: Homebrew `openjdk@21` |
| Env | Set `GHIDRA_INSTALL_DIR` / `JAVA_HOME` only in wrapper scripts — no Cursor MCP changes |

Do **not** reuse historical project leftovers under `/Users/math/Sites/tests/ghidra` as the primary project; disposable projects go under `artifacts/reverse-engineering/id05/ghidra_project/`.

## Scripts

| File | Role |
|------|------|
| `tools/ghidra/run_id05_headless.sh` | Import `ID05.bin` as raw binary, processor `68000:BE:32:default`, base `0` |
| `tools/ghidra/ExportId05.java` | Post-script: write function list JSON |

```bash
export JAVA_HOME=/opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home
bash tools/ghidra/run_id05_headless.sh
# → artifacts/reverse-engineering/id05/functions.json
```

## Successful operations

- Raw Binary loader, block name `CODE5`, base address `0x0`.
- Analysis completes on Apple Silicon with JDK 21.
- Function inventory includes **`FUN_00000728`** at entry `00000728` (and `FUN_00000006` at `00000006`).
- Output artifact: `artifacts/reverse-engineering/id05/functions.json`.

## Blocker: macOS ARM decompiler

Public Ghidra 12.1.4 ships decompiler natives only under:

- `Ghidra/Features/Decompiler/os/linux_x86_64/decompile`
- `Ghidra/Features/Decompiler/os/win_x86_64/decompile.exe`

**Missing:** `os/mac_* /decompile` (including `mac_arm_64`).

Consequence:

- Headless **function listing** works.
- Headless **decompile** of `FUN_00000728` does **not** run on this host without building a native decompiler or obtaining a macOS binary.
- A stock Makefile attempt under `Features/Decompiler/src/decompile` defaulted to **`-arch x86_64`**, which is the wrong architecture for Apple Silicon — aborted; see `artifacts/reverse-engineering/id05/decompiler-build.log`.

**Workaround for semantics today:** use protected Ghidra C export `ID05.c` (already in-repo) plus Capstone byte checks. Do not overwrite `ID05.c`.

## Supported vs unsupported (this machine)

| Operation | Status |
|-----------|--------|
| Import raw CODE / set 68000 BE | Supported |
| Auto-analyze + list functions | Supported |
| Export function JSON | Supported |
| Export decompiled C via headless | **Blocked** (no mac_arm_64 `decompile`) |
| REA as Ghidra provider for 68000 | Unsupported (see `docs/research/rea/`) |
