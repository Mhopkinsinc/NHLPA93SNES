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

## 3. Work loop

Repeat until the human tells you to stop or the queue is empty:

1. `git pull --ff-only` on `main`.
2. Open `SEGMENT_AGENT.md`. The current segment is the line marked `<- CURRENT` (the first row not `matched`).
3. Do that segment exactly as `PROMPT.md` says (the text block in it is your instruction for one segment). Follow every rule in `SEGMENT_AGENT.md`.
4. Build after each batch of edits. It must print MATCH. If it does not, undo your last edit and redo it; the build lists the first differing offsets.
5. When the segment is done: mark the row `matched` with the byte range, add one History line, move `<- CURRENT` to the next unfinished row.
   If you ran out of time or context: mark the row `in progress` with the named ranges instead and keep it current.
6. Build once more (MATCH), then commit only this segment's files plus `SEGMENT_AGENT.md`, `src/ram93snes.asm`, `src/inc/snes_regs.asm` if you changed them:
   `git commit -m "<segment>: <short summary>"`
7. `git push origin main`. If the push is rejected because the remote moved, `git pull --rebase`, build again (MATCH), then push. Never `--force`.
8. Next segment.

## 4. When stuck

- 5 failed builds in a row on one segment, or code you cannot trace (unknown M/X width, a jump you cannot resolve): put the edits back to the last MATCH state (`git checkout -- <file>`), keep whatever named part still MATCHes.
- In that segment's row, set the status to `blocked` and write in the Note what is unresolved (address, what you tried, what you suspect).
- Commit and push that (MATCH), then move `<- CURRENT` to the next row and continue. A later session (or the human) comes back to blocked rows.
- Never mark a row `matched` that still has `CODE_` names or unexplained `db` in code.
