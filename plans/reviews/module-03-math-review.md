# Module 03 — BGP: Math & Numerical Audit

**Auditor**: Sentinel (math-auditor subagent)
**Date**: 2026-03-12
**Scope**: All 13 markdown files in `modules/03-bgp/`
**Focus**: Arithmetic, formulas, scaling numbers, timer values, cross-file consistency

---

## Summary

**13 files audited. 2 issues found. 0 critical, 2 minor.**

The module's math is overwhelmingly clean. All full-mesh session formulas (N(N-1)/2) are correct across every instance. Community hex↔decimal conversions are consistent. Scaling estimates (DFZ size, memory, RR capacity) are reasonable for 2024-era numbers. NLRI encoding math checks out. The two issues found are a factual inaccuracy about hold timer defaults and a step-count inconsistency in the best-path algorithm between companion files.

---

## Issues

### 3.1-bgp-fundamentals-at-sp-scale-theory.md — Hold Timer Default Claim

- **Severity**: minor
- **Current text**: "Hold Timer: Negotiated from OPEN messages. If 0, no keepalives (dangerous). Default 90s for most implementations."
- **Correction**: RFC 4271 §10 *suggests* 90 seconds, but the majority of deployed implementations default to 180s. Cisco IOS/IOS-XE/IOS-XR default to 60s keepalive / 180s hold. Arista EOS and FRRouting also default to 180s. Only Junos and Nokia SR-OS default to 90s. The guide's own Key Knobs table in `3.1-bgp-fundamentals-at-sp-scale.md` correctly lists IOS-XR at 60s/180s and Junos at 30s/90s, contradicting this "90s for most" claim. Suggested fix: "RFC 4271 suggests 90 seconds; actual defaults vary — Cisco/Arista: 180s, Junos/Nokia: 90s."
- **Source**: RFC 4271 §10 ("Suggested value: 90 seconds"); Cisco IOS-XR Configuration Guide (hold-time default 180s); Junos BGP Reference (hold-time default 90s)

### 3.1-bgp-fundamentals-at-sp-scale.md vs 3.1-theory — Best Path Step Count Inconsistency

- **Severity**: minor
- **Current text (main file)**: Lists 11 steps: Weight → LOCAL_PREF → Locally originated → AS_PATH → ORIGIN → MED → eBGP/iBGP → IGP metric → Oldest route → Lowest Router ID → Lowest peer IP
- **Current text (theory file)**: Lists 12 steps: same sequence but includes "Lowest Cluster List length (RFC 4456)" as step 11 between Router ID and Lowest neighbor address
- **Correction**: The Cluster List length comparison IS part of the standard decision process (RFC 4456 §9, Cisco documented order). Both files should list 12 steps or the main file should note the omission. The theory file's 12-step version is the complete one. The main file's 11-step version drops Cluster List length, creating an inconsistency within the same section's companion files.
- **Source**: RFC 4456 §9 (Route Reflector loop prevention via CLUSTER_LIST), Cisco BGP Best Path Selection Algorithm documentation

---

## Verified Clean — All Calculations Checked

### Full-Mesh Session Formulas (N(N-1)/2)
All instances verified across 3 files:
- N=10: 45 ✓ (3.2-theory, 3.2-main, 3.1-main)
- N=50: 1,225 ✓ (3.2-theory, 3.2-main)
- N=100: 4,950 ✓ (3.2-main)
- N=200: 19,900 ✓ (3.2-theory, 3.2-main, 3.1-main overview)
- N=500: 124,750 ✓ (3.2-main)
- N=1000: 499,500 ✓ (3.2-theory)

### NLRI Encoding Math
- /24 prefix = 1 byte length + 3 bytes prefix = 4 bytes ✓
- 1000 × 4 bytes = 4,000 bytes ≈ "~4KB" ✓

### Timer Ratios
- Keepalive = Hold Time / 3: 90/3=30 ✓, 180/3=60 ✓, 30/3=10 ✓

### ASN Ranges
- 2-byte: 0–65535 (2^16 - 1 = 65,535) ✓
- 4-byte: 0–4,294,967,295 (2^32 - 1) ✓
- AS_TRANS: 23456 ✓ (RFC 6793)

### Community Hex ↔ Decimal Cross-Check
- NO_EXPORT: 0xFFFFFF01 = 65535:65281 ✓
- NO_ADVERTISE: 0xFFFFFF02 = 65535:65282 ✓
- NO_EXPORT_SUBCONFED: 0xFFFFFF03 = 65535:65283 ✓
- NOPEER: 0xFFFFFF04 = 65535:65284 ✓
- BLACKHOLE: 65535:666 = 0xFFFF029A ✓
- GRACEFUL_SHUTDOWN: 65535:0 ✓ (RFC 8326)

### Community/Attribute Sizes
- Standard community: 4 bytes / 32-bit ✓ (consistent across 3.1-theory, 3.4-theory, 3.4-main)
- Extended community: 8 bytes / 64-bit ✓ (consistent across all files)
- Large community: 12 bytes / 96-bit ✓ (consistent across all files)
- BGP header: 19 bytes (16 marker + 2 length + 1 type) ✓
- KEEPALIVE: 19 bytes (header only) ✓

### Scaling Estimates (reasonable for 2024 era)
- Full IPv4 DFZ: ~950K prefixes ✓
- Full IPv6 DFZ: ~220K prefixes ✓
- Growth: ~50K/year IPv4 (slightly high vs 4-year average of ~37K/year but within rounding) ✓
- Memory per 1M routes: ~500MB–1GB ✓
- RR capacity: 5–10M paths ✓
- BGP sessions per router: 500–2000+ ✓
- BGP convergence cold start: 5–15 minutes ✓
- RPKI ROA coverage: ~50% IPv4 ✓

### Answer File Arithmetic
- 3.2-answers Q3: "~400 (200 PEs × 2 RRs) + 16 (8 regional RRs × 2 top-level RRs)" → 400 + 16 = 416 ✓
- All LOCAL_PREF comparison logic in answer files follows correct best-path step ordering ✓

---

## Files Audited

| # | File | Numerical Claims | Issues |
|---|------|-----------------|--------|
| 1 | `3.1-bgp-fundamentals-at-sp-scale-theory.md` | Header sizes, timer defaults, ASN ranges, community hex values, NLRI encoding | 1 (hold timer default) |
| 2 | `3.1-bgp-fundamentals-at-sp-scale.md` | DFZ size, scaling numbers, timer defaults, ASN ranges, best-path steps | 1 (step count vs theory) |
| 3 | `3.1-bgp-fundamentals-at-sp-scale-answers.md` | Best-path step references | 0 |
| 4 | `3.2-ibgp-design-theory.md` | Full-mesh formulas (6 instances) | 0 |
| 5 | `3.2-ibgp-design.md` | Full-mesh formulas (4 instances), RR scaling | 0 |
| 6 | `3.2-ibgp-design-answers.md` | Session count math, RR hierarchy sizing | 0 |
| 7 | `3.3-ebgp-peering-theory.md` | GTSM TTL values, BFD timers | 0 |
| 8 | `3.3-ebgp-peering.md` | Max-prefix limits, bogon ranges, DFZ filtering thresholds | 0 |
| 9 | `3.3-ebgp-peering-answers.md` | Max-prefix sizing, policy values | 0 |
| 10 | `3.4-bgp-policy-and-traffic-engineering-theory.md` | Community sizes, attribute encoding | 0 |
| 11 | `3.4-bgp-policy-and-traffic-engineering.md` | Community decimal values, well-known community table, FlowSpec AFI/SAFI | 0 |
| 12 | `3.4-bgp-policy-and-traffic-engineering-answers.md` | Prepend effectiveness estimates, policy values | 0 |
| 13 | `README.md` | Time estimates only | 0 |
