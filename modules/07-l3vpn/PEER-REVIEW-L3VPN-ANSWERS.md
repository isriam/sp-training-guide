# L3VPN Answer Key — Peer Review Report

**Reviewer:** Senior SP Network Engineer (Peer Review)
**Date:** 2026-03-09
**Scope:** 7.1 through 7.5 answer keys, cross-referenced against source sections
**Standard:** CCIE SP study material — zero tolerance for technical errors

---

## Executive Summary

Overall quality is **strong** — these are clearly written by someone who knows L3VPN at a production level. The explanations are excellent, the troubleshooting methodology is sound, and dual-vendor coverage is well above average for study material. However, I found **1 critical issue, 5 high-severity issues, 8 medium-severity issues, and 9 low-severity issues** that need correction before this goes into anyone's CCIE study rotation.

The critical issue (7.5 Q3 fundamentally mischaracterizing ADD-PATH) would actively teach the wrong thing. That needs to be fixed immediately.

**Overall Grade: B+**

---

## File Grades

| File | Grade | Summary |
|------|-------|---------|
| 7.1 — L3VPN Architecture Answers | **A-** | Excellent design and troubleshooting answers. Minor IOS-XR syntax errors. |
| 7.2 — MP-BGP VPNv4/VPNv6 Answers | **A** | Strongest file. inet.3 explanation is textbook-quality. |
| 7.3 — Inter-AS L3VPN Answers | **B+** | Good migration walkthrough. Some Junos syntax issues and an unclear fix in Q3. |
| 7.4 — Extranet & Shared Services Answers | **B+** | Solid RT design work. Fix 2 in Q3 recommends an ineffective mechanism. |
| 7.5 — Scale & Convergence Answers | **B-** | Contains the critical ADD-PATH error. Some dubious IOS-XR commands. Junos PIC coverage incomplete. |

---

## Issues — CRITICAL (1)

### C1 — 7.5 Q3: ADD-PATH behavior fundamentally wrong
**File:** `7.5-l3vpn-scale-convergence-answers.md`, Question 3, Cause 2
**Statement:** *"ADD-PATH only helps when there are multiple DISTINCT NLRIs (different RDs) for the same customer prefix."*

**This is backwards.** ADD-PATH (RFC 7911) exists *specifically* to advertise multiple paths for the **same** NLRI. The RFC literally says: *"This document defines a BGP extension that allows the advertisement of multiple paths for the same address prefix without the new paths implicitly replacing any previous ones."* A Path Identifier distinguishes the multiple paths.

When RDs are different, the NLRIs are already different — you don't *need* ADD-PATH. The RR naturally advertises both because they're distinct prefixes. ADD-PATH is the solution for when you **can't** or **don't want to** change RDs.

The 7.5 source material correctly states: *"RD-per-PE alternative: ...This achieves the same result as ADD-PATH without requiring ADD-PATH capability."* — confirming they're alternatives, not dependencies.

**Impact:** A candidate who memorizes this will give the wrong answer on an exam question about ADD-PATH. This is the single most dangerous error in the entire module.

**Fix:** Replace with: *"ADD-PATH allows the RR to advertise multiple paths for the same NLRI (same RD+prefix) using path-IDs. With same RDs, ADD-PATH IS the mechanism that lets the RR send both paths. However, if ADD-PATH is not configured or not negotiated, same-RD paths will be suppressed by standard best-path selection, and only one path reaches the PE."*

---

## Issues — HIGH (5)

### H1 — 7.5 Q1: Potentially fabricated IOS-XR command
**File:** `7.5-l3vpn-scale-convergence-answers.md`, Question 1, Change 2
**Statement:** IOS-XR PIC config shows `cef / vpn-with-recursion`

I cannot verify `vpn-with-recursion` as a valid IOS-XR CEF configuration command. The source material (7.5) does **not** mention this command. The source says PIC is enabled by default on IOS-XR 7.x+ for VPN prefixes and references `nexthop trigger-delay critical 0` for pre-7.x. The Q2 answer in the same file uses the valid `bgp attribute-download` approach instead.

**Fix:** Remove `cef / vpn-with-recursion`. Replace with a note that PIC is default on IOS-XR 7.x+, or reference the explicit pre-7.x config from the source material (`nexthop trigger-delay critical 0`).

### H2 — 7.4 Q3 Fix 2: no-export community doesn't prevent VRF re-export
**File:** `7.4-extranet-shared-services-answers.md`, Question 3, Fix 2
**Statement:** Uses `set community (no-export) additive` to prevent hub VRF from re-exporting customer routes.

The `no-export` well-known community (RFC 1997) prevents routes from being advertised to **eBGP peers**. It does NOT prevent VRF export via RT-based policy. VRF export into MP-iBGP VPNv4 is iBGP — `no-export` has no effect. The hub VRF's export route-policy would need to explicitly check for a custom community and drop matching routes. The answer doesn't show this check in the export policy.

**Impact:** A candidate implements "Fix 2" thinking it provides defense-in-depth, but it does nothing.

**Fix:** Replace `no-export` with a custom community (e.g., `65000:666` meaning "do-not-re-export") and add an explicit check in the hub's export route-policy:
```
route-policy HUB-EXPORT-SAFE
  if community matches-any (65000:666) then
    drop
  endif
  if destination in HUB-OWN-SERVICES then
    pass
  endif
  drop
end-policy
```

### H3 — 7.1 Q3: `label mode per-vrf` placed under wrong config context
**File:** `7.1-l3vpn-architecture-answers.md`, Question 3, Priority 2
**Config shown:**
```
router bgp 65000
 address-family vpnv4 unicast
  label mode per-vrf
```

On IOS-XR, `label mode per-vrf` is configured under the **VRF's** address-family (`router bgp 65000 / vrf <name> / address-family ipv4 unicast / label mode per-vrf`), NOT under the global `address-family vpnv4 unicast`. Verified via Cisco XRdocs (NCS-5500 VRF routing guide). The source material (7.1) correctly shows it under the VRF.

**Fix:** Change to:
```
router bgp 65000
 vrf CUST-A
  address-family ipv4 unicast
   label mode per-vrf
```

### H4 — 7.5 Q2: Junos PIC claimed as default — it requires explicit config
**File:** `7.5-l3vpn-scale-convergence-answers.md`, Questions 1 and 2
**Statement:** Q1: *"PIC is enabled by default in recent Junos when multiple paths are available"*; Q2: *"PIC...activates automatically when ADD-PATH is enabled"*

The 7.5 source material explicitly shows Junos PIC requires configuration:
```junos
routing-options {
    forwarding-table {
        indirect-next-hop;
        chained-composite-next-hop {
            ingress { l3vpn; }
        }
    }
}
```

Without `indirect-next-hop` and `chained-composite-next-hop`, Junos does not enable PIC for L3VPN. The answer file contradicts its own source material.

**Fix:** Remove claims of default PIC behavior. Include the explicit Junos PIC configuration from the source, or at minimum note that `indirect-next-hop` and `chained-composite-next-hop ingress l3vpn` are required.

### H5 — 7.3 Q1: Junos `no-modify-nh` is not valid syntax
**File:** `7.3-inter-as-l3vpn-answers.md`, Question 1, Phase 1
**Config shown (Junos RR2):**
```junos
neighbor 10.254.0.1 {
    family inet-vpn { unicast; }
    no-modify-nh;
}
```

`no-modify-nh` is not standard Junos BGP syntax. The correct approach (shown in the 7.3 source material) is an export policy with `next-hop unchanged`:
```junos
export PRESERVE-NEXT-HOP;
...
policy-statement PRESERVE-NEXT-HOP {
    then { next-hop unchanged; }
}
```

**Fix:** Replace `no-modify-nh` with the export policy approach from the source material.

---

## Issues — MEDIUM (8)

### M1 — 7.1 Q1: IOS-XR SOO syntax missing parentheses
**File:** `7.1-l3vpn-architecture-answers.md`, Question 1
**Shows:** `set extcommunity soo 65000:1001`
**Correct:** `set extcommunity soo (65000:1001)` — parentheses required for inline community in IOS-XR RPL. The source material correctly uses parentheses.

### M2 — 7.3 Q2: IOS-XR route-policy `through` keyword in inline extcommunity match
**File:** `7.3-inter-as-l3vpn-answers.md`, Question 2
**Shows:** `if extcommunity rt matches-any (65100:1 through 65100:50) then`
**Issue:** The `through` keyword for inline extcommunity ranges may not be valid IOS-XR RPL syntax. Standard approach uses a named `extcommunity-set rt` with range syntax.

### M3 — 7.3 Q3: Fix for ASBR2 redistribution is unclear/incorrect
**File:** `7.3-inter-as-l3vpn-answers.md`, Question 3
**Shows:** `redistribute static route-policy ALLOW-PE-LOOPBACKS` as the fix for ASBR2 not redistributing labeled-unicast into AS2 iBGP.
**Issue:** The fix should be ensuring the iBGP labeled-unicast address-family is activated toward AS2's RR/PEs so routes learned from eBGP labeled-unicast are re-advertised into iBGP. `redistribute static` doesn't inject eBGP-learned labeled-unicast routes.

### M4 — 7.5 Q2: `unequal-cost` keyword on `maximum-paths ibgp`
**File:** `7.5-l3vpn-scale-convergence-answers.md`, Question 2
**Shows:** `maximum-paths ibgp 8 unequal-cost`
**Issue:** IOS-XR iBGP multipath uses `maximum-paths ibgp <N>` for equal-cost. Unequal-cost multipath for iBGP requires DMZ Link Bandwidth or similar mechanisms, not an `unequal-cost` keyword. This keyword exists on IOS-XE but not IOS-XR.

### M5 — 7.2 source config comment contradicts theory (affects answer grounding)
**File:** `7.2-mp-bgp-vpnv4-vpnv6.md` (source), Junos config section
**Shows:** Comment `# Without this: per-prefix (one label per route in VRF)`
**Issue:** This contradicts the theory section (same file) which correctly states Junos default is per-next-hop, not per-prefix. The answers correctly reference per-next-hop, but the source has an internal inconsistency that should be fixed to avoid confusion.

### M6 — 7.1 Q3: RT-Constraint config shown for PE but missing RR-side activation
**File:** `7.1-l3vpn-architecture-answers.md`, Question 3
**Shows:** RT-Constraint config only for the PE side.
**Issue:** The source material emphasizes "Both PE and RR must enable rt-filter for constraint to work." The answer should show RR-side configuration too, or at minimum note it's required. A candidate implementing only the PE side will see no effect.

### M7 — 7.5 Q1 and Q2: Inconsistent PIC configuration between questions
**File:** `7.5-l3vpn-scale-convergence-answers.md`
**Issue:** Q1 uses the dubious `cef vpn-with-recursion` for IOS-XR PIC. Q2 uses `bgp attribute-download` (valid). Same file, same topic, different approaches with no explanation of when to use which. Creates confusion about the "real" PIC config.

### M8 — 7.2 Q1: Doesn't mention IOS-XR automatic default RT behavior
**File:** `7.2-mp-bgp-vpnv4-vpnv6-answers.md`, Question 1
**Issue:** The source material explicitly states: *"IOS-XR does this automatically during the negotiation window"* (automatic default RT that prevents route withholding during RT-Constraint migration). The answer doesn't mention this, which is a significant nuance — it means the described failure is less likely on IOS-XR than implied.

---

## Issues — LOW (9)

### L1 — 7.1 Q1: SOO mechanism described imprecisely
The answer says "the SOO match causes the route to be rejected." The source clarifies the route IS installed in the VRF RIB but is NOT advertised out to CE interfaces tagged with the matching SOO. Filtering happens at CE export, not VRF import. The distinction matters for troubleshooting (the route IS in the table, it's just not advertised).

### L2 — 7.1 Q2: Verification command uses assumed RD
`show bgp vpnv4 unicast rd 65000:200 10.1.0.0/24 detail` — assumes PE2's RD is 65000:200. The question doesn't specify the RD. Minor assumption but worth noting.

### L3 — 7.2 Q2: Imprecise terminology "export RD"
Solution 3 says "PE1: `export RD 65000:1001`" — RDs are assigned to VRFs, not "exported." This is sloppy language that could confuse someone who doesn't yet understand the RD/RT distinction.

### L4 — 7.3 Q1: IOS-XR `next-hop-unchanged` as keyword vs route-policy
The answer uses `next-hop-unchanged` directly under the VPNv4 address-family. The source material uses a route-policy with `set next-hop unchanged`. Both may work on IOS-XR, but inconsistency with the source could confuse a student cross-referencing.

### L5 — 7.4 Q1: Redundant RT setting in hub export policy
The hub VRF has `export route-target 65000:9000` AND the export route-policy also does `set extcommunity rt (65000:9000) additive`. The RT would be applied twice (once by VRF config, once by policy). Not harmful, but sloppy — the source material correctly separates these concerns (policy filters, VRF config applies RT).

### L6 — 7.5 Q1 sources: RFC 5286 cited for PIC
RFC 5286 covers IP Fast Reroute Loop-Free Alternates, not BGP PIC. BGP PIC is a vendor implementation without its own RFC. The citation is related but misleading.

### L7 — 7.3 answer sources: References RFC 3107 instead of RFC 8277
RFC 8277 ("Using BGP to Bind MPLS Labels to Address Prefixes") obsoleted RFC 3107. The source material correctly cites RFC 8277, but the answer key references RFC 3107 in the sources line.

### L8 — 7.5 Q2: Per-CE label claim for Junos
The answer states "Per-CE is the default behavior when each CE is a separate next-hop in the VRF." This is technically describing per-next-hop behavior that happens to produce per-CE-like results. More precise language would help — Junos allocates per-next-hop, not per-CE. They often coincide but the mechanism is different.

### L9 — 7.1 Q2: "One-command fix" is actually multi-line
The question asks for a "one-command fix." The answer provides a full VRF address-family reconfiguration block (IOS-XR) and a policy/community change (Junos). Strictly speaking, changing the export RT in IOS-XR requires entering VRF config mode, AF mode, removing the old RT, adding the new one — that's multiple commands. Pedantic, but an exam grader might ding the phrasing.

---

## Cross-File Consistency Issues

### Consistent ✓
- IOS-XR per-prefix default — consistent across all 5 files
- Junos per-next-hop default — consistent across answer files (source 7.2 has a config comment error, noted as M5)
- RT-Constraint AFI 1, SAFI 132 — consistent and correct per RFC 4684
- RFC numbers — all correct (4364, 4760, 4684, 7911, 9107, 4724)
- RD-per-PE recommendation — consistent from 7.1 through 7.5
- BGP hold timer defaults (IOS-XR 180s, Junos 90s) — consistent

### Minor Inconsistency
- PIC configuration approach varies between 7.5 Q1 (dubious `cef vpn-with-recursion`) and Q2 (`bgp attribute-download`). Noted as M7.
- SOO mechanism precision differs between 7.1 Q1 answer and 7.1 source. Noted as L1.

---

## Convergence Numbers Verification

| Claim | Realistic? | Notes |
|-------|-----------|-------|
| BFD 3×50ms = 150ms detection | ✅ Yes | Standard aggressive BFD |
| RR processing at 100K-500K updates/sec | ✅ Yes | Modern dedicated RR hardware |
| FIB programming NCS-5500 ~50K/sec | ✅ Yes | Ballpark correct for Memory chipset |
| FIB programming ASR 9000 ~100K/sec | ✅ Yes | Reasonable for Typhoon/Tomahawk |
| PIC pointer update ~50ms | ✅ Yes | O(1) operation |
| Total PIC convergence ~600ms | ✅ Yes | Realistic end-to-end |
| PIC Edge ~3ms | ⚠️ Optimistic | Possible with fast-external-fallover + hardware, but 10-50ms is more typical in production |

---

## What's Done Well

1. **Dual-vendor coverage is genuinely excellent.** Both IOS-XR and Junos configs are present for every question that involves configuration. This is rare in study material.

2. **The troubleshooting methodology in every answer follows a logical diagnostic chain.** Not just "check this command" — actual reasoning about what's happening at each step.

3. **The war stories in the source material are realistic and instructive.** They clearly come from (or are modeled on) real production incidents.

4. **RT design work in 7.4 is production-quality.** The transitive leaking chain explanation in Q3 is exactly the kind of thinking that catches real security violations.

5. **The 7.2 Q3 answer (inet.3 resolution) is the best answer in the entire set.** Clear, precise, correctly prioritized causes, and the secondary causes list shows real depth.

6. **Convergence numbers are grounded in reality**, not hand-waved. The per-platform FIB programming rates are useful benchmarks.

---

## Recommendations

1. **Fix C1 immediately** — the ADD-PATH mischaracterization is actively harmful
2. **Fix all HIGH issues** before using as study material — H1-H5 are either wrong commands or wrong mechanisms
3. **Address MEDIUM issues** in the next revision — mostly syntax precision and consistency
4. **LOW issues** can wait — they're polish, not substance
5. **Consider adding a "Common Exam Traps" callout box** to each answer highlighting the non-obvious detail (e.g., "ADD-PATH works with same NLRI, not different" / "no-export doesn't affect VRF export")

---

*Review complete. 23 total issues: 1 CRITICAL, 5 HIGH, 8 MEDIUM, 9 LOW.*
