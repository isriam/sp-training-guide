#!/usr/bin/env bash
# Regenerate ALL MP3s in the SP Study Guide with the current pronunciation dictionary.
# Uses the manual pipeline: theory-to-tts.py → apply-pronunciation.py → chunk-text.py → tts-kokoro → ffmpeg concat
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
SCRIPTS="$REPO_ROOT/tts/scripts"
DICT="$REPO_ROOT/tts/pronunciation.txt"
TTS_CMD="python3 $HOME/.openclaw/skills/voice/scripts/tts-kokoro"
WORK_ROOT=$(mktemp -d)
trap 'rm -rf "$WORK_ROOT"' EXIT

TOTAL=0
DONE=0
FAILED=0
SKIPPED=0

# Count total MP3s first
TOTAL=$(find "$REPO_ROOT/modules" -name '*.mp3' | wc -l)
echo "=== Full MP3 Regeneration ==="
echo "=== $TOTAL files to process ==="
echo "=== Dictionary: $(grep -c '|' "$DICT") terms ==="
echo ""

# Process each module directory in order
for moddir in "$REPO_ROOT"/modules/[0-9]*; do
  modname=$(basename "$moddir")
  echo "========================================"
  echo "=== MODULE: $modname ==="
  echo "========================================"

  # Find all MP3s in this module
  for mp3 in "$moddir"/*.mp3; do
    [ -f "$mp3" ] || continue
    base=$(basename "$mp3" .mp3)
    md_file="$moddir/$base.md"

    # Check if corresponding .md file exists
    if [ ! -f "$md_file" ]; then
      echo "  SKIP: $base.mp3 (no matching .md file)"
      SKIPPED=$((SKIPPED + 1))
      continue
    fi

    echo "  --- $base ---"
    work="$WORK_ROOT/$modname/$base"
    mkdir -p "$work"

    # Step 1: Extract spoken text (strips code blocks, config, tables as needed)
    python3 "$SCRIPTS/theory-to-tts.py" "$md_file" > "$work/spoken.txt" 2>/dev/null || {
      echo "    FAIL: theory-to-tts.py failed"
      FAILED=$((FAILED + 1))
      continue
    }

    # Check if there's actually text to speak
    if [ ! -s "$work/spoken.txt" ] || [ "$(wc -c < "$work/spoken.txt")" -lt 50 ]; then
      echo "    SKIP: too little text extracted"
      SKIPPED=$((SKIPPED + 1))
      continue
    fi

    # Step 2: Apply pronunciation dictionary
    python3 "$SCRIPTS/apply-pronunciation.py" "$work/spoken.txt" "$DICT" > "$work/pronounced.txt" 2>/dev/null

    # Step 3: Chunk into 2000-char pieces
    python3 "$SCRIPTS/chunk-text.py" "$work/pronounced.txt" --max-chars 2000 --output-dir "$work" --prefix chunk 2>/dev/null

    # Step 4: TTS each chunk
    chunk_count=0
    chunk_fail=0
    for chunk in "$work"/chunk_*.txt; do
      [ -f "$chunk" ] || continue
      cbase=$(basename "$chunk" .txt)
      $TTS_CMD "$(cat "$chunk")" --voice will --format mp3 --output "$work/${cbase}.mp3" > /dev/null 2>&1 || {
        echo "    WARN: chunk $cbase failed"
        chunk_fail=$((chunk_fail + 1))
      }
      chunk_count=$((chunk_count + 1))
    done

    if [ "$chunk_fail" -gt 0 ]; then
      echo "    FAIL: $chunk_fail/$chunk_count chunks failed"
      FAILED=$((FAILED + 1))
      continue
    fi

    # Step 5: Concatenate chunks
    chunk_mp3s=$(ls "$work"/chunk_*.mp3 2>/dev/null | sort)
    if [ -z "$chunk_mp3s" ]; then
      echo "    FAIL: no chunk MP3s produced"
      FAILED=$((FAILED + 1))
      continue
    fi

    ls "$work"/chunk_*.mp3 | sort | sed "s|.*|file '&'|" > "$work/concat.txt"
    ffmpeg -y -f concat -safe 0 -i "$work/concat.txt" -c:a libmp3lame -b:a 128k "$mp3" 2>/dev/null || {
      echo "    FAIL: ffmpeg concat failed"
      FAILED=$((FAILED + 1))
      continue
    }

    size=$(du -sh "$mp3" | cut -f1)
    DONE=$((DONE + 1))
    echo "    OK ($chunk_count chunks, $size) [$DONE/$TOTAL]"

    # Clean up work dir for this file to save disk
    rm -rf "$work"
  done
done

echo ""
echo "========================================"
echo "=== COMPLETE ==="
echo "=== Done: $DONE | Failed: $FAILED | Skipped: $SKIPPED | Total: $TOTAL ==="
echo "========================================"
