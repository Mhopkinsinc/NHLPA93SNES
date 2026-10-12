# START HERE (instructions for the AI agent)

You are the agent doing this whole project. The human does nothing by hand: you set up the tools, build, work the cleanup, commit and push. Read this file, then `SEGMENT_AGENT.md` (rules and history) and the `Cleanup progress` section of `docs/HANDOFF.md`.

## Hard rules

- Never change a ROM byte. Every commit must build to MATCH (sha1 `76a01492cfb656e9fce0094bca356c312adfea0e`).
- Never force-push, never rewrite pushed history, never push a commit that does not MATCH.
- Never edit `lst/nhlpa93snes.bin`.
- Small commits, one file or file group per commit.

## 1. Setup (fresh clone)

From the repo root:

- Linux / macOS: `sh tools/setup.sh`
  It builds asar 1.91 from the `v1.91` tag into `tools/bin/asar` (gitignored) and checks the version, python3 and sha1sum/shasum. It needs git, cmake 3.10+ and a C++ compiler. If one is missing, install it yourself (`sudo apt-get install -y git cmake g++`, `brew install cmake`, `xcode-select --install`, or `python3 -m pip install --user cmake`) and re-run.
- Windows: `powershell -ExecutionPolicy Bypass -File tools\setup.ps1`
  It downloads the prebuilt asar 1.91 release (`asar191.zip`) into `tools\bin\asar.exe` and checks the version and Python.

Python 3 is only needed for `tools/disasm65816.py` (decoding new regions). The build itself needs only asar.

If setup fails after you have tried to install the missing prerequisite, stop and report the exact error.

## 2. Build and confirm MATCH

- Linux / macOS: `./build.sh`
- Windows: `powershell -ExecutionPolicy Bypass -File build.ps1`

The last line must be `MATCH` and both sha1 lines must equal `76a01492cfb656e9fce0094bca356c312adfea0e`. On a fresh clone, if it is not MATCH, stop and report the output. Do not try to fix a fresh clone.

## 3. Source layout

The segment phase is finished: every bank is disassembled and named (the per-slice log is in `SEGMENT_AGENT.md`).
The source is laid out by bank: `src/nhlpa93snes.asm` includes `src/banks/bXX_<name>.asm` in bank order. Each bank file has one
`org` (the bank start, or the first byte after a block that runs over from the bank before) and then `incsrc` lines in exact ROM order,
nothing else. Code is one routine per file in `src/routines/<93G module>/<Routine>.asm` (`hockey`, `logic`, `middle`, `penalty`,
`video`, `stats`, `sound`, `main`); a routine that falls through into the next keeps both in one file, named after the first. Small
tables a module uses stay in its routines folder. Non-code data is in `src/data/<category>/<Name>.asm` (`sound`, `gfx`, `frames`,
`teams`, `text`). The SNES header and vectors are `src/header/snes_header.asm`. `docs/file_map.md` lists every bank's files with
their addresses (`python3 tools/gen_file_map.py` regenerates it); `docs/name_map.csv` maps the quick-pass `CODE_xxxxxx` names.

## 4. Work loop: cleanup

1. `git pull --ff-only`, `./build.sh` (MATCH), `python3 tools/scan_cleanup.py` for what is left (raw addresses, generic labels, noise comments).
2. Read the `Cleanup progress` section of `docs/HANDOFF.md`: it says what is done and what is next.
3. Work one file (or one file group) at a time. Rebuild after every logical change; it must print MATCH. If not, fix or revert before moving on.
4. Names: 93G first, then 92G, then a name from what the code does (`SEGMENT_AGENT.md` naming rules). Rename across the whole repo at once.
   Keep operand sizes explicit (`lda.b name` / `lda.w name` / `lda.l name`, `lda.w #label>>16`) so asar emits the same bytes.
5. Adding a routine (splitting one out, or naming code that was data): put it in a new file `src/routines/<module>/<Routine>.asm`
   (data: `src/data/<category>/<Name>.asm`) and add its `incsrc` line to the bank file at its exact ROM position. Never add an `org`
   to a routine file. Run `python3 tools/gen_file_map.py` to update `docs/file_map.md`.
6. Commit with a clear message, push, and update the `Cleanup progress` section of `docs/HANDOFF.md` before you stop.

## 5. When stuck

- A rename or address change that cannot be made without changing bytes: leave it and list it with the reason in `docs/HANDOFF.md`.
- 5 failed builds in a row on one change: `git checkout -- <file>` back to the last MATCH state and note what was tried.
