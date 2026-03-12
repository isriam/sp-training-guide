# Module 04 — Math & Calculation Audit

**Auditor**: Sentinel (math-auditor subagent)
**Date**: 2026-03-12
**Scope**: All 13 markdown files in `modules/04-mpls/`
**Verdict**: 3 issues found (1 critical, 2 minor). All other calculations verified clean.

---

## Issues Found

### 4.2-rsvp-te-theory.md — RSVP Cleanup Timeout Formula Is Wrong

- **Severity**: critical
- **Current text**: "If 3 consecutive refreshes are missed (default: 3 × 30 = 90 seconds), the state is deleted."
- **Correction**: RFC 2205 §3.7 specifies cleanup timeout as `(K + 0.5) × R` where K=3 (miss count) and R=30s (refresh period). Correct value: `3.5 × 30 = 105 seconds`, not 90. The sibling file `4.2-rsvp-te.md` already states this correctly: "approximately 105 seconds by default ((3.5) × 30s per RFC 2205)."
- **Source**: RFC 2205 Section 3.7 — "The cleanup timeout should be (K + 0.5) * R, where K is a small integer."

---

### 4.1 files — Inconsistent IS-IS Max Metric Value

- **Severity**: minor
- **Current text (4.1-ldp-and-label-distribution.md)**: "IS-IS: 2^24-1"
- **Current text (4.1-ldp-and-label-distribution-answers.md)**: "IS-IS: 2^24 - 2 = 16777214"
- **Correction**: Both values are defensible depending on implementation — IS-IS wide metric max is 2^24−1 = 16,777,215, but some implementations use 2^24−2 = 16,777,214 to avoid the absolute ceiling. However, the two files in the same section should agree on a single value. Pick one and use it consistently. The arithmetic in the answers file (2^24 − 2 = 16,777,214) is correct. The design file's 2^24−1 = 16,777,215 is also correct arithmetic. The inconsistency is the problem.
- **Source**: RFC 5305 (IS-IS TE extensions); vendor documentation for LDP-IGP sync max-metric behavior.

---

### 4.2-rsvp-te.md — Inconsistent IOS-XE Re-optimization Timer Default

- **Severity**: minor
- **Current text (body)**: "IOS-XE default: **3600 seconds** (60 minutes)."
- **Current text (Key Knobs table, same file)**: "Re-optimization timer | IOS-XE Default: **300s**"
- **Correction**: The body and table contradict each other within the same file. Verify the actual platform default and use one consistent value. The 3600→60 minute arithmetic and the 300s value are both internally correct — the problem is they can't both be the default. The config example in the same file sets `mpls traffic-eng reoptimize timers frequency 300`, which aligns with the table.
- **Source**: Cisco IOS-XE MPLS TE configuration guide for the specific platform in scope.

---

## Verified Clean — All Other Calculations

The following numerical claims were checked and confirmed correct:

| File | Claims Verified |
|------|----------------|
| **4.1-ldp-and-label-distribution-theory.md** | LDP PDU header 10 bytes (2+2+6), LDP ID 6 bytes (4+2), Hello 5s, Hold 15s (3×5), reserved labels 0/3, UDP/TCP port 646 |
| **4.1-ldp-and-label-distribution.md** | 20-bit label range 0–1,048,575 (2^20), Hello/Hold timers, liberal retention scaling (10 peers × 100K = 1M bindings), OSPF max metric 65535 |
| **4.1-ldp-and-label-distribution-answers.md** | OSPF max metric 65535, 2^24−2 = 16,777,214 arithmetic |
| **4.2-rsvp-te-theory.md** | RSVP header 8 bytes, protocol 46, refresh 30s, 10K LSPs → 20K msgs/30s ≈ 667 msg/s, Tunnel/LSP ID 16-bit, admin groups 32-bit, 8 priority levels (0–7), FRR sub-200ms |
| **4.2-rsvp-te.md** | Cleanup 3.5×30=105s, RSVP Hello 3×3s=9s, full mesh 100 PEs ≈ 10K LSPs (100×99=9900), RSVP BW 8,000,000 kbps = 8 Gbps = 80% of 10G, tunnel BW 1,000,000 kbps = 1 Gbps, reopt timer 3600/60=60min, 2N state for 1:1 backup, FRR label stack depth +1 |
| **4.2-rsvp-te-answers.md** | 50×49=2,450 tunnels, 50×49/2=1,225 pairs, 2×2450=4,900 state blocks, 100×99=9,900, 3×2.5G=7.5G, 8−7.5=0.5G remaining |
| **4.3-label-operations-theory.md** | Label stack entry 4 bytes (20+3+1+8=32 bits), label range 0–1,048,575, reserved labels 0–15 (0,1,2,3,7,13,14,15 all correct), 3 labels overhead = 3×4=12 bytes, MTU example 9000+12=9012 |
| **4.3-label-operations.md** | Label header 32 bits, label range 0–1,048,575, each label 4 bytes, 3-label stack = 12 bytes, MTU recommendations (9216, 1530), TTL propagation example (255→254→pop, IP 64→63), VPN overhead 2×4=8 bytes, FRR overhead 4×4=16 bytes |
| **4.3-label-operations-answers.md** | 3×4=12 bytes overhead, 1500−12=1488 bytes max, 2×4=8 bytes for 2-label stack |
| **4.4-mpls-oam-and-troubleshooting-theory.md** | UDP port 3503, BFD port 3784, 127/8 destination, two-way delay formula (T4−T1)−(T3−T2), one-way delay T2−T1 |
| **4.4-mpls-oam-and-troubleshooting.md** | BFD 100ms×3=300ms, 50ms×3=150ms, RSVP Hello 9+s consistent with 3×3s |
| **4.4-mpls-oam-and-troubleshooting-answers.md** | 1400+8=1408 bytes, 1472+20+8=1500, 1500+8=1508 |
| **README.md** | No numerical claims |

---

## Files Audited (13 total)

1. `4.1-ldp-and-label-distribution-theory.md`
2. `4.1-ldp-and-label-distribution.md`
3. `4.1-ldp-and-label-distribution-answers.md`
4. `4.2-rsvp-te-theory.md`
5. `4.2-rsvp-te.md`
6. `4.2-rsvp-te-answers.md`
7. `4.3-label-operations-theory.md`
8. `4.3-label-operations.md`
9. `4.3-label-operations-answers.md`
10. `4.4-mpls-oam-and-troubleshooting-theory.md`
11. `4.4-mpls-oam-and-troubleshooting.md`
12. `4.4-mpls-oam-and-troubleshooting-answers.md`
13. `README.md`
