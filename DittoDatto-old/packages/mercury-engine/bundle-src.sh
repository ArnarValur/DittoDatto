#!/bin/bash
# Bundles all .ts files in src/ (and optionally tests/) into a single file for AI review
# Usage: ./bundle-src.sh [--with-tests] [output-file]

WITH_TESTS=false
OUTPUT=""

for arg in "$@"; do
  case "$arg" in
    --with-tests) WITH_TESTS=true ;;
    *) OUTPUT="$arg" ;;
  esac
done

BASE_DIR="$(dirname "$0")"
SRC_DIR="$BASE_DIR/src"
TEST_DIR="$BASE_DIR/tests"

# Default output name
if [ -z "$OUTPUT" ]; then
  if $WITH_TESTS; then
    OUTPUT="src-bundle-full.txt"
  else
    OUTPUT="src-bundle.txt"
  fi
fi

echo "# MercuryEngine — Full Source Bundle" > "$OUTPUT"
echo "# Generated: $(date -Iseconds)" >> "$OUTPUT"

# Count files
SRC_COUNT=$(find "$SRC_DIR" -name '*.ts' | wc -l)
echo "# Source files: $SRC_COUNT" >> "$OUTPUT"

if $WITH_TESTS; then
  TEST_COUNT=$(find "$TEST_DIR" -name '*.ts' | wc -l)
  echo "# Test files: $TEST_COUNT" >> "$OUTPUT"
fi

echo "" >> "$OUTPUT"

# Bundle src/
echo "# ╔══════════════════════════════════════════════════════════════╗" >> "$OUTPUT"
echo "# ║                        SOURCE CODE                         ║" >> "$OUTPUT"
echo "# ╚══════════════════════════════════════════════════════════════╝" >> "$OUTPUT"
echo "" >> "$OUTPUT"

find "$SRC_DIR" -name '*.ts' -type f | sort | while read -r file; do
  relpath="${file#$BASE_DIR/}"
  echo "# ════════════════════════════════════════════════════════════════" >> "$OUTPUT"
  echo "# FILE: $relpath" >> "$OUTPUT"
  echo "# ════════════════════════════════════════════════════════════════" >> "$OUTPUT"
  echo "" >> "$OUTPUT"
  cat "$file" >> "$OUTPUT"
  echo "" >> "$OUTPUT"
done

# Bundle tests/ (optional)
if $WITH_TESTS; then
  echo "# ╔══════════════════════════════════════════════════════════════╗" >> "$OUTPUT"
  echo "# ║                          TESTS                             ║" >> "$OUTPUT"
  echo "# ╚══════════════════════════════════════════════════════════════╝" >> "$OUTPUT"
  echo "" >> "$OUTPUT"

  find "$TEST_DIR" -name '*.ts' -type f | sort | while read -r file; do
    relpath="${file#$BASE_DIR/}"
    echo "# ════════════════════════════════════════════════════════════════" >> "$OUTPUT"
    echo "# FILE: $relpath" >> "$OUTPUT"
    echo "# ════════════════════════════════════════════════════════════════" >> "$OUTPUT"
    echo "" >> "$OUTPUT"
    cat "$file" >> "$OUTPUT"
    echo "" >> "$OUTPUT"
  done
fi

TOTAL=$(wc -l < "$OUTPUT")
echo "✅ Bundled to $OUTPUT ($TOTAL lines)"
