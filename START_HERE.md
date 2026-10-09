# START HERE (instructions for the AI agent)

You are the agent doing this whole project. The human does nothing by hand: you set up the tools, build, work the segment queue, commit and push. Read this file, then `SEGMENT_AGENT.md` and `PROMPT.md`.

## Hard rules

- Never change a ROM byte. Every commit must build to MATCH (sha1 `76a01492cfb656e9fce0094bca356c312adfea0e`).
- Never force-push, never rewrite pushed history, never push a commit that does not MATCH.
- Never edit `lst/nhlpa93snes.bin`.
- One segment per commit.

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

## 3. Work loop: one bank per run

A run covers one bank: the 8 segments of the bank that holds the current segment (e.g. `bank80_8000` ... `bank80_F000`). Then you stop and wait.

1. `git pull --ff-only` on `main`.
2. Open `SEGMENT_AGENT.md`. The current segment is the line marked `<- CURRENT` (the first row not `matched`). This run's bank is that segment's bank.
3. Do that segment exactly as `PROMPT.md` says. Follow every rule in `SEGMENT_AGENT.md`.
   A segment is done only when it is **fully named**: every routine, every local label, every RAM variable it touches (in `src/ram93snes.asm`), parameters / arguments passed in registers or RAM, constants and bit values (equates instead of magic numbers), hardware registers (`src/inc/snes_regs.asm`), data tables, and comments on routines and non-obvious lines. Naming only the routines is not done. No `CODE_` labels and no unexplained `db` in code may remain.
4. Build after each batch of edits. It must print MATCH. If it does not, undo your last edit and redo it; the build lists the first differing offsets.
5. When the segment is done: mark the row `matched` with the byte range, add one History line, move `<- CURRENT` to the next row.
   If you ran out of context: mark the row `in progress` with what is named and keep it current; end the run there and report.
6. Build once more (MATCH), commit only this segment's files plus `SEGMENT_AGENT.md`, `src/ram93snes.asm`, `src/inc/snes_regs.asm` if changed:
   `git commit -m "<segment>: <short summary>"`
7. `git push origin main`. If rejected because the remote moved: `git pull --rebase`, build (MATCH), push. Never `--force`.
8. If the bank has another segment, go to step 3 with it.
9. When the bank's last segment is committed and pushed, **STOP**. Post a summary to the user:
   - segments done (and any `in progress` / `blocked`, with why)
   - functions, local labels, RAM variables, constants named (lists, with the 93G/92G counterpart where there is one)
   - the final build result (MATCH and sha1)
   - the commit hash of each segment
   Then wait. Do not start the next bank until the user says continue.

## 4. When stuck

- 5 failed builds in a row on one segment, or code you cannot trace (unknown M/X width, a jump you cannot resolve): put the edits back to the last MATCH state (`git checkout -- <file>`), keep whatever named part still MATCHes.
- In that segment's row, set the status to `blocked` and write in the Note what is unresolved (address, what you tried, what you suspect).
- Commit and push that (MATCH), then move `<- CURRENT` to the next row and continue. A later session (or the human) comes back to blocked rows.
- Never mark a row `matched` that still has `CODE_` names or unexplained `db` in code.
