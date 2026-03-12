# Module 02 — Math & Scaling Audit

**Auditor**: Sentinel (subagent)  
**Date**: 2026-03-12  
**Scope**: All 12 markdown files in `modules/02-igp/`  
**Verdict**: **2 minor issues found, 0 critical.** All core formulas, timer calculations, and scaling claims verified clean.

---

## Files Audited

| # | File | Numerical Claims | Status |
|---|------|-----------------|--------|
| 1 | `2.1-isis-deep-dive-theory.md` | NSAP sizes, PDU types, timer defaults, SPF complexity, metric ranges, sequence number range, DIS priority range, pseudonode O(N) reduction | ⚠️ 1 minor |
| 2 | `2.1-isis-deep-dive.md` | Timer table (hello/hold/SPF/LSP), DIS behavior | ✅ Clean |
| 3 | `2.1-isis-deep-dive-answers.md` | Overload max-metric value (2^24 − 2 = 16,777,214) | ✅ Clean |
| 4 | `2.2-ospf-in-sp-networks-theory.md` | Header sizes, timer defaults, dead interval calc, LSA ages, sequence number range, adjacency count formula, max-metric value | ✅ Clean |
| 5 | `2.2-ospf-in-sp-networks.md` | SPF defaults table, BFD calc, reference bandwidth, convergence timing | ✅ Clean |
| 6 | `2.2-ospf-in-sp-networks-answers.md` | AD/preference values (Cisco/Junos), migration math | ✅ Clean |
| 7 | `2.3-igp-convergence-tuning-theory.md` | BFD header size, port numbers, interval negotiation formula, detection time formula, SPF scheduling series, LFA/rLFA/TI-LFA coverage percentages, data rate calculation | ✅ Clean |
| 8 | `2.3-igp-convergence-tuning.md` | BFD calcs, convergence pipeline budget, data rate calc, timer knobs | ⚠️ 1 minor |
| 9 | `2.3-igp-convergence-tuning-answers.md` | Convergence pipeline sum (with/without FRR), tiered BFD calcs | ✅ Clean |
| 10 | `2.4-isis-vs-ospf-decision-framework.md` | Scaling limits, AD/preference values, Junos preference semantics | ✅ Clean |
| 11 | `2.4-isis-vs-ospf-decision-framework-answers.md` | No new numerical claims | ✅ Clean |
| 12 | `README.md` | No numerical claims | ✅ Clean |

---

## Issues Found

### 2.1-isis-deep-dive-theory.md — NSAP Area ID Maximum Size

- **Severity**: minor
- **Current text**: Diagram shows `Area ID: 1-13 bytes` as a separate field from `AFI: 1B`, and body text says "Area ID: Variable length, 1 to 13 bytes"
- **Correction**: ISO 8348 caps NSAP at 20 bytes. With AFI (1B) + System ID (6B) + SEL (1B) = 8 bytes fixed overhead, the Area ID portion (excluding AFI) can be at most **12 bytes** (0–12 bytes), not 13. The *area address* (AFI + Area ID combined) is 1–13 bytes, which the body text correctly states: "The AFI + Area ID together form the 'area address.'" But the diagram and the standalone "1 to 13 bytes" description for Area ID alone are off by one — should read `0-12 bytes` in the diagram or clarify that the 1–13 byte range applies to the area address including AFI.
- **Source**: ISO 8348 (NSAP max = 20 octets); 1(AFI) + 13(Area ID as stated) + 6(SysID) + 1(SEL) = 21 > 20.

---

### 2.3-igp-convergence-tuning.md — Default Convergence Budget Total

- **Severity**: minor
- **Current text**: The convergence budget table states the default total is **"~35 seconds"** with column values: Detection = 30s, LSP/LSA gen = 5000ms, Flooding = 10–100ms, SPF = 5000ms, RIB/FIB = 50–500ms.
- **Correction**: Summing the default column: 30 + 5 + 0.055 + 5 + 0.275 ≈ **~40 seconds**, not ~35. Additionally, the table mixes IS-IS defaults (30s hold timer for detection) with OSPF defaults (5000ms for LSP gen and SPF computation). Pure IS-IS defaults would give ~31s (IS-IS LSP gen and SPF defaults are 50ms, not 5000ms). Pure OSPF defaults would give ~50s (dead interval is 40s, not 30s). Neither matches ~35s.
- **Source**: Arithmetic: 30 + 5 + 0.1 + 5 + 0.5 = 40.6s. The stated "~35 seconds" is ~14% low. Recommend either correcting to "~40 seconds" (using the mixed values shown) or splitting the table into IS-IS vs OSPF default rows.

---

## Verified Calculations (Spot-Check Detail)

These core calculations were verified correct:

| Claim | File | Verification |
|-------|------|-------------|
| 3 × 10s hello = 30s hold time | 2.1-theory | 3 × 10 = 30 ✓ |
| 4 × 10s hello = 40s dead interval | 2.2-theory | 4 × 10 = 40 ✓ |
| 1200s MaxAge = 20 minutes | 2.1-theory | 1200 ÷ 60 = 20 ✓ |
| 3600s MaxAge = 1 hour | 2.2-theory | 3600 ÷ 3600 = 1 ✓ |
| 1800s LSRefreshTime = 30 minutes | 2.2-theory | 1800 ÷ 60 = 30 ✓ |
| 10/3 DIS hello rate = 3.3s | 2.1-theory | 10 ÷ 3 = 3.33 ✓ |
| N(N-1)/2 full-mesh adjacencies, N=10 → 45 | 2.2-theory | 10×9÷2 = 45 ✓ |
| 2(N-2)+1 DR/BDR adjacencies, N=10 → 17 | 2.2-theory | 2×8+1 = 17 ✓ |
| BFD 50ms × 3 = 150ms detection | 2.3-deploy | 50 × 3 = 150 ✓ |
| BFD 100ms × 3 = 300ms detection | 2.3-answers | 100 × 3 = 300 ✓ |
| BFD 300ms × 3 = 900ms detection | 2.3-answers | 300 × 3 = 900 ✓ |
| 100 Gbps × 1s = 12.5 GB | 2.3-theory | 100×10⁹÷8 = 12.5×10⁹ bytes ✓ |
| SPF series Ti=50, Ts=200, Tm=5000: 50, 250, 650, 1450, 3050ms | 2.3-theory | 50, 50+200, 250+400, 650+800, 1450+1600 ✓ |
| 2^24 − 1 = 16,777,215 (wide metric max) | 2.1-theory | ✓ |
| 2^24 − 2 = 16,777,214 (overload metric) | 2.1-answers | ✓ |
| 0xFFFF = 65,535 (OSPF max-metric) | 2.2-theory | ✓ |
| 0x80000001 → 0x7FFFFFFF (OSPF seq range) | 2.2-theory | Signed 32-bit range ✓ |
| OSPFv2 header = 24 bytes | 2.2-theory | 1+1+2+4+4+2+2+8 = 24 ✓ |
| OSPFv3 header = 16 bytes | 2.2-theory | 1+1+2+4+4+2+1+1 = 16 ✓ |
| BFD control header = 24 bytes | 2.3-theory | 4+4+4+4+4+4 = 24 ✓ |
| Convergence w/o FRR: ~550-620ms (Q1 answer) | 2.3-answers | 300+50+10+50+10+200 = 620; ~550 with pipelining ✓ |
| Convergence w/ TI-LFA: ~300ms (Q1 answer) | 2.3-answers | BFD only: 100×3 = 300 ✓ |
| SPF complexity O((V+E) log V) | 2.1-theory | Standard Dijkstra with binary heap ✓ |
| LFA link-protect: D(N,D) < D(N,S)+D(S,D) | 2.3-theory | Matches RFC 5286 §3 ✓ |
| BFD TX = max(local DesiredMinTx, remote RequiredMinRx) | 2.3-theory | Matches RFC 5880 §6.8.7 ✓ |
| DetectTime = remote DetectMult × max(local RxMin, remote TxMin) | 2.3-theory | Matches RFC 5880 §6.8.4 ✓ |

## Cross-File Consistency

| Value | Files Referencing | Consistent? |
|-------|-------------------|-------------|
| IS-IS MaxAge = 1200s | 2.1-theory, 2.1-deploy, 2.2-theory (comparison) | ✅ |
| IS-IS refresh = 900s | 2.1-theory, 2.1-deploy | ✅ |
| OSPF MaxAge = 3600s | 2.2-theory, 2.2-deploy | ✅ |
| OSPF refresh = 1800s | 2.2-theory | ✅ |
| IS-IS SPF defaults 50/200/5000ms | 2.1-theory, 2.1-deploy, 2.3-theory (math example) | ✅ |
| OSPF SPF IOS-XR defaults 5000/10000/10000ms | 2.2-deploy | ✅ |
| SP recommended SPF 50/100/5000ms | 2.2-deploy ("Aggressive SP"), 2.3-deploy | ✅ |
| Cisco AD: IS-IS=115, OSPF=110 | 2.2-answers, 2.4-deploy, 2.4-answers | ✅ |
| Junos preference: OSPF=10, IS-IS L1=15, L2=18 | 2.2-answers, 2.4-deploy | ✅ |
| LFA coverage ~40-80% | 2.3-theory ("Ring ~50%, Grid 80-90%"), 2.3-deploy ("40-80%") | ✅ |
| rLFA coverage ~90-95% | 2.3-theory, 2.3-deploy | ✅ |
| TI-LFA coverage 100% | 2.3-theory, 2.3-deploy | ✅ |
| BFD ports 3784/4784/6784/3785 | 2.3-theory | ✅ |
