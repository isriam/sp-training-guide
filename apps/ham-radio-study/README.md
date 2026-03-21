# 📻 Ham Radio Technician Study App

A Progressive Web App (PWA) for studying the FCC Amateur Radio Technician Class (Element 2) exam. Lives in the [sp-training-guide](https://github.com/isriam/sp-training-guide) repo under `apps/ham-radio-study/`.

## Features

- **📚 411 Questions** — Full 2022–2026 official FCC Technician pool
- **🃏 Flashcards** — Flip cards with spaced-repetition priority (weak spots first)
- **📝 Practice Exams** — 35-question timed tests matching real exam weighting
- **📊 Progress Tracking** — Per-question stats, section mastery, readiness meter
- **🔍 Study by Section** — T1–T0, focus on weak subelements
- **🔊 Text-to-Speech** — Read questions aloud via Web Speech API
- **🌙 Dark/Light Mode** — Auto-detects system preference
- **🏆 Achievements** — 12 badges to earn
- **📡 Offline Support** — Full service worker cache, works without internet
- **📱 Installable** — Add to home screen on iOS/Android/Desktop

## Exam Info

- Need **26/35 correct (74%)** to pass
- Questions drawn proportionally from all subelements
- Pool valid July 1, 2022 – June 30, 2026

## Location in Repo

This app lives at `apps/ham-radio-study/` within the [sp-training-guide](https://github.com/isriam/sp-training-guide) repository alongside the Service Provider study guide content.

## Setup

### Local Development

```bash
# Serve from the repo root or from this directory
python3 -m http.server 8080
# Then visit http://localhost:8080/apps/ham-radio-study/
```

### Deployment

Works on any static host. Serve the `apps/ham-radio-study/` directory (or the repo root with path-based routing). Files needed:

```
apps/ham-radio-study/
  index.html       # Main app
  questions.js     # 411-question pool (117KB)
  sw.js            # Service worker for offline
  manifest.json    # PWA manifest
  icon-192.png     # App icon
  icon-512.png     # App icon
```

**GitHub Pages (repo root):**
Enable Pages in repo Settings → Pages → master branch. The app will be available at:
`https://isriam.github.io/sp-training-guide/apps/ham-radio-study/`

**nginx:**
```nginx
server {
    listen 80;
    root /var/www/sp-training-guide;
    index index.html;
    try_files $uri $uri/ /index.html;
    # PWA needs HTTPS for install prompt
}
```

## Tech Stack

- Plain HTML/CSS/JS — no frameworks, no build step
- localStorage for all persistence
- Web Speech API for TTS
- Service Worker for offline/PWA
- ~175KB total (117KB is the question pool)

## Question Pool Source

Official FCC Technician Class pool (2022–2026) from NCVEC, formatted as JSON by [russolsen/ham_radio_question_pool](https://github.com/russolsen/ham_radio_question_pool).

## License

MIT
