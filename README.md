# Service Provider Study Guide

An operations-first training guide for engineers building and running service provider backbone networks. 420,000+ words across 12 modules covering everything from IS-IS adjacency formation to SRv6 network programming to coherent optics at 800G.

## What This Is

This is a structured, self-paced curriculum designed for engineers pursuing expert-level service provider certification — or anyone who needs to understand how the world's largest networks actually work.

Every section follows the same pattern: theory → configuration (IOS-XR + Junos) → verification → troubleshooting → war stories → review questions. No vendor favoritism. No textbook abstractions. Real operational knowledge from real networks.

## What This Covers

The expert-level service provider certification track is widely considered the hardest networking certification in existence. It covers the full stack of technologies that service providers use to build and operate backbone networks:

- **Interior Gateway Protocols** at continental scale (IS-IS, OSPF)
- **BGP** as both internet routing protocol and VPN control plane
- **MPLS** forwarding, label distribution, and traffic engineering
- **Segment Routing** (SR-MPLS and SRv6) — the modern replacement for LDP/RSVP-TE
- **L3VPN and L2VPN/EVPN** services that generate SP revenue
- **Optical transport** (DWDM, OTN, coherent optics)
- **5G transport and network slicing**
- **Automation** via YANG, NETCONF, gNMI, streaming telemetry
- **Design case studies** — ISP backbone, DCI, 5G transport, IXP, L2VPN migration

The Juniper equivalent covers comparable depth from the Junos perspective. This guide covers both platforms side by side.

## Design Philosophy

**Operations-first.** Every section starts with "why does this exist and when does it break" — not "RFC 4271 defines BGP as..." Theory serves operations, not the other way around.

**Dual-vendor.** IOS-XR and Junos configurations presented in parallel. Most SP networks run both. You should be fluent in both.

**War stories.** Each section includes at least one real-world incident — a misconfiguration that took down a metro ring, a label leak that propagated across continents, a DIS election that created phantom blackholes. These aren't hypothetical. Learning from failures is faster than learning from theory.

**Progressive depth.** Modules build on each other. IGP → BGP → MPLS → TE → SR → VPN services → transport → slicing → automation → design. The dependency chain is deliberate.

**Exam-ready but not exam-limited.** This guide will prepare you for expert-level SP lab exams, but the goal isn't to pass a test — it's to be the engineer who gets called at 2 AM when a core router is dropping traffic and nobody else can figure out why.

## Curriculum

| Module | Topic | Sections | Audio |
|--------|-------|----------|-------|
| **01** | [Foundations](modules/01-foundations/) | 1 | ~35 min |
| **02** | [IGP at Scale](modules/02-igp/) | 4 | ~2 hr 19 min |
| **03** | [BGP at SP Scale](modules/03-bgp/) | 4 | ~2 hr 46 min |
| **04** | [MPLS Core Operations](modules/04-mpls/) | 4 | ~2 hr 52 min |
| **05** | [Traffic Engineering](modules/05-te/) | 4 | ~2 hr 23 min |
| **06** | [Segment Routing](modules/06-sr/) | 6 | ~3 hr 54 min |
| **07** | [L3VPN Services](modules/07-l3vpn/) | 5 | ~2 hr 53 min |
| **08** | [L2VPN & EVPN](modules/08-l2vpn-evpn/) | 5 | ~3 hr 25 min |
| **09** | [Transport & Optical](modules/09-transport/) | 5 | ~3 hr 14 min |
| **10** | [Network Slicing & 5G](modules/10-slicing/) | 3 | ~2 hr |
| **11** | [Automation & Telemetry](modules/11-automation/) | 5 | ~2 hr 13 min |
| **12** | [Design Case Studies](modules/12-case-studies/) | 5 | ~2 hr 41 min |
| | **Total** | **51** | **~31 hours** |

Each section includes up to 6 files:
- `<section>.md` — Design/lecture content
- `<section>.mp3` — Spoken-word audio of the design content
- `<section>-answers.md` — Review questions with detailed answers
- `<section>-answers.mp3` — Spoken-word audio of Q&A
- `<section>-theory.md` — Deep protocol theory (RFC-anchored, vendor-neutral)
- `<section>-theory.mp3` — Spoken-word audio of theory content

Theory files cover Modules 2–11 (33 files total). Module 1 is foundational overview; Module 12 is design case studies — neither requires standalone protocol theory.

## Practice Exams

The [`practice-exams/`](practice-exams/) directory contains 130 IE-SP-level questions with detailed answer explanations:

- Module-specific question banks (BGP, SR, L3VPN, EVPN) — 20 questions each
- Full 50-question mixed mock exam
- Dual Opus-reviewed for accuracy (multiple critical corrections applied — RFC 4724, RFC 4577, IS-IS auth scope, TI-LFA defaults)

## Audio Library

Every section includes spoken-word MP3s stored alongside the markdown in `modules/`. ~31 hours of audio across 137+ tracks.

The [`tts/`](tts/) directory contains the full TTS pipeline — pronunciation dictionary, chunking scripts, batch generation tools. See [`tts/README.md`](tts/README.md) for how to generate or regenerate audio.

- **Voice** — Kokoro TTS, `am_puck(1)+am_liam(1)+am_onyx(0.5)` blend at 1.1x
- **Format** — MP3 at 128kbps
- **Pronunciation** — 80+ SP acronyms mapped to phonetic spellings (IS-IS, OSPF, BGP, etc.)
- **Three tracks per section** — `<section>.mp3` (lecture) + `<section>-answers.mp3` (Q&A) + `<section>-theory.mp3` (protocol deep-dive, Modules 2–11)

## Accuracy Review

All 12 modules have been reviewed by GPT-5.4 (Forge) for technical accuracy against authoritative RFCs and standards. 178 issues corrected (57 critical) across the full curriculum. Review reports are in [`plans/reviews/`](plans/reviews/).

## Learning Paths

### Enterprise engineer moving to SP
**01 → 02 → 03 → 04 → 07 → 08 → 05 → 06 → 09 → 10 → 11 → 12**

If you're strong in BGP/MPLS, skim 02-04 and spend depth on 07-11. The VPN services and modern transport modules are where enterprise knowledge has the biggest gaps.

### IE-SP / IE-SP candidate
**01 → 02 → 03 → 04 → 05 → 06 → 07 → 08 → 09 → 10 → 11 → 12**

Full linear order, no skips. Complete review questions and lab exercises after each module. The practice exams are calibrated to lab-exam difficulty.

### Experienced SP engineer — modern catch-up
**05 → 06 → 08 → 09 → 10 → 11 → 07 → 12**

You know MPLS and BGP. Start with TE evolution (RSVP-TE → SR-TE), then EVPN, transport, slicing, and automation. Revisit 02/03 only when troubleshooting dependencies surface.

## Prerequisites

- Solid IP routing fundamentals (SPF, link-state concepts, subnetting)
- CLI comfort on at least one platform (IOS-XR or Junos)
- Basic MPLS awareness (what a label is, what push/swap/pop means)
- Module dependencies are listed at the top of each section

## Key RFCs Referenced

| RFC | Topic |
|-----|-------|
| 1195 | IS-IS for IP |
| 4271 | BGP-4 |
| 3031 | MPLS Architecture |
| 4364 | L3VPN (BGP/MPLS IP VPNs) |
| 7432 | EVPN |
| 8214 | EVPN-VPWS |
| 8402 | Segment Routing Architecture |
| 8986 | SRv6 Network Programming |
| 9252 | BGP Overlay Services (SRv6) |
| 8405 | SPF Back-Off Algorithm |
| 5305 | IS-IS Extensions for TE |

## Related Files

- [LAB-ENVIRONMENT.md](LAB-ENVIRONMENT.md) — Lab topology and platform requirements
- [SOURCES.md](SOURCES.md) — References and source material
- [STUDY-PATH.md](STUDY-PATH.md) — Detailed study sequencing

## License

Licensed under CC BY-NC-SA 4.0. See LICENSE for details.
