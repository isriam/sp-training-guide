# Module 05 — Math & Calculation Audit

**Auditor**: Sentinel (math-only scope)
**Date**: 2026-03-12
**Verdict**: NEARLY CLEAN — 1 minor internal inconsistency found, all core calculations verified correct.

## Summary

Audited 11 markdown files across Module 05 (Traffic Engineering). Checked every arithmetic operation, formula, bandwidth calculation, scaling claim, bitmask operation, timer value, and cross-file numerical consistency.

**All major calculations are correct.** The affinity bitmask math, full-mesh tunnel counts, hierarchical scaling reductions, BFD detection times, RSVP refresh rates, SRGB label arithmetic, percentage reductions, and PCEP timer ratios all check out. One minor internal inconsistency was found.

## Files Audited

| # | File | Calculations Found | Result |
|---|------|-------------------|--------|
| 1 | `5.1-te-fundamentals-theory.md` | Bandwidth encoding (10G→1.25×10⁹ B/s), affinity bitmask examples, priority levels, admin group bit width | ✅ Clean |
| 2 | `5.1-te-fundamentals.md` | RSVP timers, full-mesh count (200×199=39,800), hierarchical reduction (1,656 tunnels, 24× reduction), RSVP session counts (398/PE), scaling limits | ⚠️ 1 minor issue |
| 3 | `5.1-te-fundamentals-answers.md` | Affinity mask math (0x3 & 0x5 = 0x1 ≠ 0x5), TE metric path costs (2×10=20 vs 1×100=100), full-mesh/hierarchical counts, preemption priority logic | ✅ Clean |
| 4 | `5.2-rsvp-te-advanced-theory.md` | Timer ranges (30-120s grace period), no specific arithmetic | ✅ Clean |
| 5 | `5.2-rsvp-te-advanced.md` | Auto-BW intervals (86400s=24h), RSVP hello (3s/9s=3× multiplier), soft preemption timer (30s), scaling table | ✅ Clean |
| 6 | `5.2-rsvp-te-advanced-answers.md` | RSVP refresh rate (1,600/30=53.3 msg/s), auto-bandwidth overflow math | ✅ Clean |
| 7 | `5.3-segment-routing-te-theory.md` | SRGB arithmetic (16000+1=16001), Flex-Algo range (128-255=128 algos), ODN policy count (~200×5=1,000) | ✅ Clean |
| 8 | `5.3-segment-routing-te.md` | PCEP timers (120s/30s=4× ratio), label stack depths, MSD values | ✅ Clean |
| 9 | `5.3-segment-routing-te-answers.md` | RSVP session count (800 PATH+800 RESV=1,600), refresh rate (1,600/30=53 msg/s), transit instances (4×1000=4,000) | ✅ Clean |
| 10 | `5.4-te-deployment-and-design.md` | Full-mesh counts (100×99=9,900; 200×199=39,800), BFD timing (3×10ms=30ms, 3×50ms=150ms), graceful shutdown metric (4,294,967,295=2³²−1) | ✅ Clean |
| 11 | `5.4-te-deployment-and-design-answers.md` | Full-mesh (75×74=5,550), core mesh (8×7=56), PE-to-core (75×8=600), total hierarchical (656), reduction (88.2%, 8.46×), BFD timing | ✅ Clean |

---

## Issues Found

### 5.1-te-fundamentals.md — RSVP Hello Timeout Multiplier Inconsistency

- **Severity**: minor
- **Current text** (TE Tunnel Lifecycle section): `"Hello keepalives (every 3s default, 3.5x timeout)"`
- **Current text** (Key Knobs table, same file): `"RSVP hello interval | 3s | 3s (9s dead) | 3s hello / 9s dead"`
- **Correction**: The "3.5x timeout" claim yields a dead time of 10.5s, but the Key Knobs table in the same file states 9s dead (which is 3× the hello interval, not 3.5×). Standard implementations use a miss-count multiplier of 3 (Junos default) or 4 (some Cisco configurations), never 3.5. Change the lifecycle description to `"Hello keepalives (every 3s default, 3x miss-count = 9s dead)"` to match the Key Knobs table and standard defaults.
- **Source**: Derived from: 9s ÷ 3s = 3.0× (not 3.5×). RFC 3209 does not specify default hello parameters; vendor defaults are 3s interval with miss-count of 3 (Junos) or 4 (some Cisco).

---

## Verified Calculations (Spot-Check Detail)

These are the key calculations I verified — all correct:

| Calculation | Location | Check |
|-------------|----------|-------|
| 10 Gbps = 1.25×10⁹ bytes/sec | 5.1 theory | 10×10⁹ ÷ 8 = 1.25×10⁹ ✅ |
| 0x00000006 = bits 1,2 | 5.1 theory | 0x6 = 0110₂ ✅ |
| Affinity: 0x6 & 0x2 = 0x2 (pass include-any) | 5.1 theory | 0110 & 0010 = 0010 ✅ |
| Affinity: 0x6 & 0x4 = 0x4 (fail exclude-any) | 5.1 theory | 0110 & 0100 = 0100 ≠ 0 ✅ |
| Mask check: (0x3 & 0x5) vs (0x5 & 0x5) → 0x1 ≠ 0x5 | 5.1 answers Q1 | 0011 & 0101 = 0001, 0101 & 0101 = 0101 ✅ |
| TE cost: 2 hops × 10 = 20 vs 1 hop × 100 = 100 | 5.1 answers Q2 | Arithmetic ✅ |
| Full-mesh: 200×199 = 39,800 | 5.1 main | ✅ |
| Full-mesh: 75×74 = 5,550 | 5.4 answers Q1 | ✅ |
| Full-mesh: 100×99 = 9,900 | 5.4 main | ✅ |
| PE sessions: 199 ingress + 199 egress = 398 | 5.1 answers Q4 | ✅ |
| Hierarchical: 200×8 + 8×7 = 1,600 + 56 = 1,656 | 5.1 answers Q4 | ✅ |
| Hierarchical: 75×8 + 8×7 = 600 + 56 = 656 | 5.4 answers Q1 | ✅ |
| Reduction: 39,800÷1,656 ≈ 24× | 5.1 answers Q4 | 24.03× ✅ |
| Reduction: (5,550−656)÷5,550 ≈ 88.2% | 5.4 answers Q1 | 88.18% ✅ |
| Ratio: 5,550÷656 ≈ 8.46× | 5.4 answers Q1 | 8.46× ✅ |
| RSVP refresh: 1,600÷30 ≈ 53 msg/s | 5.2/5.3 answers | 53.33 ✅ |
| 86,400s = 24h | 5.2 main | 24×60×60 = 86,400 ✅ |
| PCEP dead-timer: 120s = 4×30s keepalive | 5.3 main | ✅ |
| BFD: 3×10ms = 30ms detection | 5.4 answers Q2 | ✅ |
| BFD: 3×50ms = 150ms detection | 5.4 answers Q2 | ✅ |
| SRGB: 16,000 + 1 = 16,001 | 5.3 theory | ✅ |
| Flex-Algo range: 128–255 = 128 algorithms | 5.3 theory/main | ✅ |
| Graceful shutdown metric: 4,294,967,295 = 2³²−1 | 5.4 main | ✅ |
| RSVP hello: 9s÷3s = 3× multiplier | 5.1/5.2 tables | ✅ |
| RSVP hello: 27s÷9s = 3× multiplier | 5.2 scaling | ✅ |

---

## Cross-File Consistency Check

| Claim | Files Mentioning | Consistent? |
|-------|-----------------|-------------|
| Full-mesh formula: N×(N−1) | 5.1 main, 5.1 answers, 5.4 main, 5.4 answers | ✅ |
| Priority range 0-7 (0=highest) | 5.1 theory, 5.1 main, 5.1 answers | ✅ |
| Admin group = 32-bit bitmask | 5.1 theory, 5.1 main, 5.3 theory | ✅ |
| RSVP refresh default = 30s | 5.1 main, 5.2 main, 5.2 answers | ✅ |
| Auto-BW recommended interval = 3600-86400s | 5.2 main, 5.2 answers | ✅ |
| Flex-Algo range 128-255 | 5.3 theory, 5.3 main | ✅ |
| RSVP hello default 3s | 5.1 main, 5.2 main | ✅ (table values consistent) |
| Soft preemption default 30s | 5.2 theory, 5.2 main | ✅ |
| Reoptimization defaults (3600s IOS-XE, 300s Junos) | 5.1 main, 5.2 main, 5.2 theory | ✅ |

---

*Audit complete. One minor fix needed (hello timeout multiplier). All substantive math is correct.*
