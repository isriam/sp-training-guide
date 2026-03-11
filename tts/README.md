# SP Study Guide — TTS Audio Pipeline

Generate spoken-word MP3 audio from study guide modules using Kokoro TTS.

## Voice Settings

| Setting | Value |
|---------|-------|
| Engine | Kokoro (via Open Speech on jw-pc) |
| Voice | `will` — `am_puck(1)+am_liam(1)+am_onyx(0.5)` |
| Speed | 1.1x |
| Format | MP3 (`--format mp3`) |
| Bitrate | 128kbps MP3 |
| Max chunk | ~2000 chars per TTS call |

## Storage

MP3 files are stored in git alongside their source markdown in `modules/<module>/`.

Each section has up to two MP3s:
- `<section>.mp3` — section content (lecture)
- `<section>-answers.mp3` — answer key (review Q&A)

## Pronunciation Dictionary

See [`pronunciation.txt`](pronunciation.txt) — 80+ SP protocol acronyms mapped to phonetic spellings.

Applied as a preprocessing step before TTS. Without this, Kokoro mispronounces most networking acronyms (IS-IS → "isis", OSPF → sneeze, BGP → gibberish).

### Format
```
# Comments start with #
RAW_TERM|spoken replacement
```

### Rules
- Longer/compound terms come first (e.g., `SR-MPLS` before `MPLS`)
- Case-sensitive matching with word boundaries
- Periods between letters force letter-by-letter pronunciation: `I.S.I.S.`

## Pipeline

### Input Types

**Section content** — markdown files in `modules/`. Strip tables, code blocks, bullet points. Convert to natural prose paragraphs. Keep section headers as spoken transitions.

**Answer keys** — two formats exist:
1. **Separate `-answers.md` files** (Modules 2–11): `## Question N` → `### Answer` structure
2. **Inline Discussion blocks** (Modules 1, 12): `**Q1.**` → `> **Discussion:**` embedded in section files

Use `answers-to-tts.py` (see Scripts below) to extract answer keys into spoken text regardless of format.

### Steps

#### 1. Convert markdown → spoken text

For answer keys:
```bash
python3 answers-to-tts.py <answers.md> > spoken.txt
```

For section content, manually convert or write a similar extractor.

#### 2. Apply pronunciation dictionary
```bash
python3 scripts/apply-pronunciation.py spoken.txt pronunciation.txt > pronounced.txt
```

#### 3. Chunk text (~2000 chars per chunk)
```bash
python3 scripts/chunk-text.py pronounced.txt --max-chars 2000 --output-dir /tmp --prefix chunk
```

#### 4. Generate audio per chunk (Kokoro)
```bash
for chunk in /tmp/chunk_*.txt; do
  python3 ~/.openclaw/skills/voice/scripts/tts-kokoro \
    "$(cat "$chunk")" \
    --voice will --format mp3 \
    --output "${chunk%.txt}.mp3"
done
```

#### 5. Concatenate chunks → final MP3
```bash
ls /tmp/chunk_*.mp3 | sort | sed "s|.*|file '&'|" > /tmp/concat.txt
ffmpeg -y -f concat -safe 0 -i /tmp/concat.txt -c:a libmp3lame -b:a 128k output.mp3
```

#### 6. Clean up
```bash
rm /tmp/chunk_*.txt /tmp/chunk_*.mp3 /tmp/concat.txt
```

### Batch Generation

Use `gen-module-tts.sh` to generate all answer key MP3s for an entire module:

```bash
bash tts/scripts/gen-module-tts.sh modules/03-bgp
```

This runs the full pipeline (extract → pronounce → chunk → TTS → concat) for every `-answers.md` file in the module directory. Skips sections that already have an MP3.

## Scripts

| Script | Purpose |
|--------|---------|
| `scripts/apply-pronunciation.py` | Apply pronunciation dictionary to text |
| `scripts/chunk-text.py` | Split text at paragraph boundaries for chunking |
| `scripts/generate-audio.sh` | Single-file TTS generator (section content) |
| `scripts/gen-module-tts.sh` | Batch answer key TTS for an entire module |
| `scripts/answers-to-tts.py` | Extract answer key markdown → spoken text |

## Prerequisites

- **Open Speech server** running on jw-pc (`192.0.2.24:8100`) — provides Kokoro TTS
- **ffmpeg** — for MP3 concatenation
- **Voice skill** — `~/.openclaw/skills/voice/scripts/tts-kokoro` must be available

Check availability:
```bash
python3 ~/.openclaw/skills/voice/scripts/tts-kokoro --check
```

## Adding New Pronunciations

Edit `pronunciation.txt`. Test with:
```bash
echo "The OSPF LSDB contains IS-IS TLVs" | python3 scripts/apply-pronunciation.py /dev/stdin pronunciation.txt
# Expected: The O.S.P.F. L.S.D.B. contains I.S.I.S. T.L.V.s
```
