#!/bin/sh
# Install asar 1.91 into tools/bin (repo-local, gitignored) and check prerequisites. Linux/macOS.
# Needs: git, cmake (>=3.10), a C++ compiler, python3. Re-running is safe.
set -e
cd "$(dirname "$0")/.."
BIN=tools/bin; mkdir -p "$BIN"
if [ -x "$BIN/asar" ] && "$BIN/asar" --version 2>/dev/null | grep -q "Asar 1.91"; then echo "asar 1.91 already installed"; else
  for t in git cmake c++; do command -v $t >/dev/null || { echo "MISSING: $t (install it: apt install git cmake g++ / brew install cmake / xcode-select --install; or pip install --user cmake)"; exit 1; }; done
  # prefer GCC when present: some images ship a clang 'c++' without libstdc++
  if [ -z "$CXX" ] && command -v g++ >/dev/null; then export CXX=g++ CC=gcc; fi
  tmp=$(mktemp -d)
  git -c advice.detachedHead=false clone -q --depth 1 --branch v1.91 https://github.com/RPGHacker/asar.git "$tmp/asar"
  cmake -S "$tmp/asar/src" -B "$tmp/build" -DCMAKE_BUILD_TYPE=Release -DASAR_GEN_LIB=OFF >/dev/null 2>&1
  cmake --build "$tmp/build" -j 4 >/dev/null 2>&1
  cp "$(find "$tmp/build" -name asar -type f -perm -u+x | head -1)" "$BIN/asar"
  rm -rf "$tmp"
fi
"$BIN/asar" --version | head -1 | grep -q "Asar 1.91" || { echo "asar version check FAILED"; exit 1; }
echo "asar: $("$BIN/asar" --version | head -1)"
command -v python3 >/dev/null && echo "python3: $(python3 --version)" || echo "WARNING: python3 not found (only needed for tools/disasm65816.py)"
command -v sha1sum >/dev/null || command -v shasum >/dev/null || { echo "MISSING: sha1sum/shasum"; exit 1; }
echo "setup OK. Next: ./build.sh"
