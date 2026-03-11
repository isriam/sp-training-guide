# Module 07 — L3VPN Answer Keys: Adversarial Review

**Reviewer Role:** CCIE-SP Examiner  
**Objective:** Find every way these answer keys could mislead, confuse, or fail a CCIE-SP candidate  
**Date:** 2026-03-09

---

## Executive Summary

Overall the answer keys are **strong** — 80–90% of the content is accurate, well-structured, and at exam-quality depth. However, I found **14 distinct issues** across the 5 files, including **3 critical CLI errors**, **2 dangerous technical misstatements**, and several misleading claims or missing edge cases. Any of these could cost a candidate points or, worse, cause a production outage if used as a reference.

---

## 7.1 — L3VPN Architecture Answers

### Grade: **B+**

#### Issue 1: WRONG CLI — SOO Syntax Missing Parentheses (Q1)
**Claim:** `set extcommunity soo 65000:1001`  
**Problem:** On IOS-XR, inline extcommunity values in route-policy require parentheses.  
**Correct:** `set extcommunity soo (65000:1001)`  
**Evidence:** The source material (7.1 configuration section) uses the correct syntax with parentheses: `set extcommunity soo (65000:1001)`. The answer drops them.  
**Severity:** Medium — IOS-XR will reject the command. Candidate gets a commit error.

#### Issue 2: WRONG CLI — `label mode per-vrf` Placement (Q3)
**Claim:**
```cisco
router bgp 65000
 address-family vpnv4 unicast
  label mode per-vrf
```
**Problem:** The source material consistently places `label mode per-vrf` under the **VRF-specific** address-family, not the global vpnv4 unicast AF:
```cisco
router bgp 65000
 vrf CUST-A
  address-family ipv4 unicast
   label mode per-vrf
```
On IOS-XR 7.5+, a global `label mode` under `address-family vpnv4 unicast` may exist as a default-setter, but this is version-dependent and not the canonical approach. The answer doesn't acknowledge this nuance.  
**Correct:** Show per-VRF placement (consistent with source material), or note that global placement sets a default for all VRFs on 7.5+.  
**Severity:** Medium-High — In an exam lab with older IOS-XR, this fails. Candidate thinks they changed the label mode but didn't.

#### Issue 3: Missing Edge Case — VPNv6 Design Not Addressed (Q1)
**Claim:** Answer covers only IPv4 VRF design.  
**Problem:** In a dual-stack production environment, the same RD/RT/SOO design applies to VPNv6. An exam question about "design the L3VPN" implicitly includes both address families. A candidate who mentions VPNv6 design gets extra credit; one who forgets it loses points.  
**Severity:** Low — cosmetic for Q1, but relevant for a complete exam answer.

#### No Issues: Q2 is solid. RT mismatch diagnosis, explanation of Adj-RIB-In vs VRF RIB behavior, and fix are all correct.

---

## 7.2 — MP-BGP VPNv4/VPNv6 Answers

### Grade: **A-**

#### Issue 4: Misleading Claim — IOS-XR Auto-Default-RT Not Mentioned (Q1)
**Claim:** "The safe migration sequence is: (1) enable RT-Constraint on PEs first, (2) wait for all RT subscriptions to populate on the RR, (3) only then enable RT-Constraint filtering on the RR."  
**Problem:** The source material explicitly states: "IOS-XR does this automatically during the negotiation window" — meaning IOS-XR has an automatic default-RT behavior that sends all routes during initial negotiation. This is a critical mitigation that the answer omits. A candidate who knows this can argue the 200-VRF outage shouldn't happen on IOS-XR, which changes the diagnosis.  
**Severity:** Medium — answer is correct in general but misleading for IOS-XR-specific scenarios.

#### Issue 5: Debatable Ranking — ADD-PATH vs Unique RDs Complexity (Q2)
**Claim:** ADD-PATH ranked as "lowest operational complexity," Unique RDs as "highest."  
**Problem:** ADD-PATH requires capability negotiation and potentially BGP session reset to enable. On some platforms, it needs a `clear bgp` to take effect. Unique RDs require VRF config changes but are conceptually simpler and don't require BGP session disruption. An examiner could argue the ranking should be reversed.  
**Why it matters:** A candidate who ranks them differently with valid reasoning shouldn't be marked wrong.  
**Severity:** Low — defensible either way, but answer should acknowledge the trade-off.

#### Issue 6: inet.3 Resolution — Overstated "Must" (Q3)
**Claim:** "That next-hop must be resolvable in inet.3" and "Junos will not resolve a VPN next-hop against an unlabeled route."  
**Problem:** This is the default behavior, but configurable:
```junos
routing-options {
    resolution {
        rib bgp.l3vpn.0 {
            resolution-ribs inet.0;
        }
    }
}
```
The source material covers this escape hatch. The answer's absolute language could mislead a candidate into thinking there's no workaround. Should say "by default" rather than absolute "must."  
**Severity:** Low — the answer is correct for default behavior, which is what an exam expects, but the absolute language is technically imprecise.

---

## 7.3 — Inter-AS L3VPN Answers

### Grade: **B**

#### Issue 7: WRONG CLI — Junos `no-modify-nh` Does Not Exist (Q1, Phase 1)
**Claim:**
```junos
neighbor 10.254.0.1 {
    family inet-vpn { unicast; }
    family inet6-vpn { unicast; }
    no-modify-nh;               ! Preserve original PE next-hop
}
```
**Problem:** `no-modify-nh` is **not a valid Junos BGP configuration statement**. The correct approach on Junos to preserve the next-hop on an eBGP session is an export policy:
```junos
export PRESERVE-NEXT-HOP;
...
policy-statement PRESERVE-NEXT-HOP {
    then {
        next-hop unchanged;
    }
}
```
The source material (7.3 Junos Option C RR config) correctly uses this policy-based approach. The answer invents a CLI knob that doesn't exist.  
**Severity:** CRITICAL — This will cause a Junos commit failure. In an Option C deployment, the next-hop gets rewritten to self by default on eBGP, which is the **catastrophic failure mode** described in the war story. A candidate who types `no-modify-nh` gets a commit error, can't figure out why, and the VPN black-holes.

#### Issue 8: Questionable Fix — `redistribute static` for Labeled-Unicast (Q3)
**Claim:**
```cisco
router bgp 65100
 address-family ipv4 labeled-unicast
  redistribute static route-policy ALLOW-PE-LOOPBACKS
```
**Problem:** The fix for "stitching label not redistributed into AS2 iBGP" shouldn't use `redistribute static`. The PE loopbacks learned via eBGP labeled-unicast from ASBR1 are BGP routes in ASBR2's RIB. They should be re-advertised to AS2's PEs via iBGP labeled-unicast **automatically** if the iBGP session has the `address-family ipv4 labeled-unicast` properly configured.  
**Correct fix:** Ensure ASBR2 has iBGP labeled-unicast sessions to the RR/PEs with the address family active:
```cisco
router bgp 65100
 neighbor-group AS2-PEs
  address-family ipv4 labeled-unicast
```
**Severity:** Medium — the suggested fix won't work (redistributing static routes doesn't bring in eBGP labeled-unicast routes).

#### Issue 9: Invalid IOS-XR RPL Syntax — `through` Range for Extcommunity (Q2)
**Claim:**
```cisco
route-policy INTER-AS-VPN-IN
  if extcommunity rt matches-any (65100:1 through 65100:50) then
    pass
  endif
  drop
end-policy
```
**Problem:** The `through` range syntax is not standard IOS-XR RPL for inline extcommunity matching. The correct approach requires an explicit `extcommunity-set`:
```cisco
extcommunity-set rt INTER-AS-RTS
  65100:1,
  65100:2,
  ...
  65100:50
end-set

route-policy INTER-AS-VPN-IN
  if extcommunity rt matches-any INTER-AS-RTS then
    pass
  endif
  drop
end-policy
```
Or use a regex pattern if supported.  
**Severity:** Medium — commit fails in exam lab, candidate loses time.

---

## 7.4 — Extranet & Shared Services Answers

### Grade: **A-**

#### Issue 10: Missing Edge Case — Overlapping Customer Address Space at Hub (Q1)
**Claim:** All 50 customers export return routes with RT 65000:9001 to the hub VRF.  
**Problem:** If Customer 1 and Customer 2 both use 10.1.0.0/24, and both export with RT 65000:9001, the hub VRF receives two routes for the same prefix from different origins. BGP bestpath selects one — the hub loses the return path to one customer. This is a fundamental shared-services design problem that the answer doesn't address.  
**Fix:** Use unique RDs per PE (already recommended in 7.1) so the hub VRF sees distinct VPNv4 NLRIs. Or use per-customer return RTs (65000:8001 through 65000:8050) so overlapping prefixes are distinguishable. The answer's single shared return RT (65000:9001) is the simple model but has this overlap vulnerability.  
**Severity:** Medium — a real production gotcha that an examiner could probe.

#### No Major Issues: Q2 and Q3 are well-constructed. The three-cause diagnostic for Q2 is thorough. Q3's transitive leaking chain is textbook and the fix (prefix-filtered export policy on hub) is correct.

---

## 7.5 — L3VPN Scale & Convergence Answers

### Grade: **B-**

#### Issue 11: WRONG TECHNICAL CLAIM — ADD-PATH and Same-RD Behavior (Q3, Cause 2) ⚠️ CRITICAL
**Claim:** "BGP best-path selection picks ONE and advertises only that one, **even with ADD-PATH enabled**. ADD-PATH only helps when there are multiple DISTINCT NLRIs (different RDs) for the same customer prefix."  
**Problem:** This is **factually incorrect** and directly contradicts RFC 7911. ADD-PATH exists *specifically* to advertise multiple paths for the **same NLRI**. It uses a Path Identifier to distinguish paths. Without ADD-PATH, the RR sends only the best path per NLRI. With ADD-PATH, the RR can send N paths per the same NLRI.  
**The source material (7.2 section) correctly states:** "ADD-PATH for VPNv4: RR advertises multiple paths."  
**Why this is dangerous:** A candidate who believes this claim will think ADD-PATH and unique-RDs-per-PE are mutually exclusive alternatives where only unique-RDs works for same-prefix scenarios. In reality, ADD-PATH is the modern solution that works WITH same or different RDs. The recommendation for unique-RDs-per-PE is a belt-and-suspenders approach, not a requirement for ADD-PATH.  
**Correct statement:** "Without ADD-PATH, the RR picks one path and sends only that. WITH ADD-PATH, the RR can send multiple paths for the same NLRI using Path Identifiers. However, using unique RDs per PE is still recommended as defense-in-depth — it ensures path diversity even on platforms/sessions where ADD-PATH isn't negotiated."  
**Severity:** CRITICAL — This is the most dangerous error in the entire module. It reverses the fundamental purpose of ADD-PATH (RFC 7911).

#### Issue 12: WRONG/INVENTED CLI — `cef vpn-with-recursion` and `bgp attribute-download` Placement (Q1, Q2)
**Claim (Q1):**
```cisco
cef
 !
 vpn-with-recursion     ! enables PIC in the VPN FIB
```
**Problem:** `vpn-with-recursion` does not appear to be a valid IOS-XR `cef` subcommand. PIC on IOS-XR 7.x+ is enabled by default for VPN prefixes when ADD-PATH provides multiple paths. No explicit `cef` knob is required. The source material (7.5 configuration section) does NOT include this command.  

**Claim (Q2):**
```cisco
router bgp 65000
 address-family vpnv4 unicast
  bgp attribute-download   ! Download BGP next-hop to FIB for PIC
```
**Problem:** `bgp attribute-download` is a valid IOS-XR command but it belongs under `router bgp <asn>` directly, NOT under an address-family. It's also primarily for enabling per-prefix BGP attribute propagation to CEF for QoS/flowspec, not specifically for PIC enablement.  
**Severity:** High — Two invented/misplaced CLI commands in the convergence answer. A candidate typing these in a lab gets commit errors and can't enable PIC.

#### Issue 13: WRONG TIMING — PE Failure Convergence Omits IGP SPF (Q2)
**Claim:** PE failure convergence table shows:
| PE failure (BFD on PE-RR session) | 3 × 100ms = 300ms | ~50ms (PIC) | ~350ms |

**Problem:** This omits the **IGP SPF reconvergence step**. When a PE fails, the convergence chain for PIC Core is:
1. BFD or IGP adjacency loss detection (~150-300ms)
2. **IGP SPF recomputation** (~200-500ms depending on SPF throttle timers)
3. PE loopback withdrawn from IGP
4. Next-hop tracking detects PE unreachable
5. PIC pointer update (~50ms)

The source material's war story (7.5) correctly shows this timeline: BFD at T=0.15s, IGP SPF at T=0.5s, next-hop tracking at T=0.55s, PIC at T=0.6s = **~600ms total**. The answer's table claims ~350ms, which skips the ~200-350ms IGP SPF step entirely.  
**Severity:** High — A candidate who cites 350ms in an exam will be challenged. The defensible number is ~500-800ms for PE node failure with PIC.

#### Issue 14: Misleading — `maximum-paths ibgp 8 unequal-cost` Syntax (Q2)
**Claim:**
```cisco
vrf CUST-X
 address-family ipv4 unicast
  maximum-paths ibgp 8 unequal-cost
```
**Problem:** `unequal-cost` is not a standard qualifier for `maximum-paths ibgp` on IOS-XR. IOS-XR supports `maximum-paths ibgp <N>` for equal-cost multipath and `maximum-paths eibgp <N>` for mixed eBGP/iBGP. Unequal-cost multipath for BGP requires DMZ-link-bandwidth or similar weight-based mechanisms, not a simple keyword.  
**Severity:** Medium — commit fails or is silently ignored.

---

## Summary: Issues by Attack Vector

### 1. WRONG CLI (3 Critical, 2 Medium)
| # | File | Issue | Severity |
|---|------|-------|----------|
| 1 | 7.1 Q1 | SOO missing parentheses | Medium |
| 2 | 7.1 Q3 | `label mode per-vrf` wrong context | Medium-High |
| 7 | 7.3 Q1 | Junos `no-modify-nh` doesn't exist | **CRITICAL** |
| 9 | 7.3 Q2 | `through` range not valid RPL | Medium |
| 12 | 7.5 Q1/Q2 | `cef vpn-with-recursion` invented, `bgp attribute-download` wrong context | High |
| 14 | 7.5 Q2 | `maximum-paths ibgp 8 unequal-cost` | Medium |

### 2. WRONG DEFAULTS
No major issues found. IOS-XR per-prefix default and Junos per-next-hop default are stated consistently (though the Junos characterization as "per-next-hop" vs "per-prefix" is debatable across platforms/versions — see source material contradiction in 7.1 Key Knobs table vs Theory section).

### 3. WRONG RFCs
**All RFC references verified correct:**
- RT-Constraint = RFC 4684 ✅
- ADD-PATH = RFC 7911 ✅
- VPNv4 = AFI 1 SAFI 128 ✅
- VPNv6 = AFI 2 SAFI 128 ✅
- RT-Constraint = AFI 1 SAFI 132 ✅
- Labeled-Unicast = AFI 1 SAFI 4 ✅
- ORR = RFC 9107 ✅
- Graceful Restart = RFC 4724 ✅
- LLGR = RFC 9494 ✅

### 4. MISLEADING ANSWERS
| # | File | Issue | Severity |
|---|------|-------|----------|
| 4 | 7.2 Q1 | IOS-XR auto-default-RT omitted | Medium |
| 6 | 7.2 Q3 | inet.3 "must" overstated | Low |
| 11 | 7.5 Q3 | ADD-PATH / same-RD claim **reversed** | **CRITICAL** |

### 5. DANGEROUS ADVICE
| # | File | Issue | Impact |
|---|------|-------|--------|
| 7 | 7.3 Q1 | `no-modify-nh` → commit fails → next-hop rewrite → VPN black hole | Production outage |
| 8 | 7.3 Q3 | `redistribute static` won't fix the actual problem | Wasted troubleshooting time |
| 11 | 7.5 Q3 | Believing ADD-PATH doesn't work with same RDs → wrong PIC design | Failed PIC deployment |

### 6. MISSING EDGE CASES
| # | File | Issue | Severity |
|---|------|-------|----------|
| 3 | 7.1 Q1 | VPNv6 not mentioned | Low |
| 10 | 7.4 Q1 | Overlapping customer addresses at hub | Medium |

### 7. TIMING
| # | File | Issue | Severity |
|---|------|-------|----------|
| 13 | 7.5 Q2 | PE failure convergence omits IGP SPF (claims 350ms, reality ~600ms) | High |

### 8. OPTION C 3-LABEL STACK
**Verified correct.** The label stack description, ASBR2 swap L2→L1, and end-to-end packet walk are accurate.

---

## Grades Summary

| File | Grade | Critical Issues | Notes |
|------|-------|----------------|-------|
| 7.1 L3VPN Architecture | **B+** | 0 | Solid content, 2 CLI syntax errors |
| 7.2 MP-BGP VPNv4/VPNv6 | **A-** | 0 | Well-written, minor omissions |
| 7.3 Inter-AS L3VPN | **B** | 1 | `no-modify-nh` is a landmine |
| 7.4 Extranet & Shared Services | **A-** | 0 | Strong, missing one edge case |
| 7.5 Scale & Convergence | **B-** | 1 | ADD-PATH claim reversal + invented CLI + wrong timing |

**Overall Module Grade: B**

---

## Priority Fix List

1. **🔴 CRITICAL — 7.5 Q3 Cause 2:** Fix the ADD-PATH / same-RD claim. Currently states the opposite of RFC 7911.
2. **🔴 CRITICAL — 7.3 Q1:** Replace `no-modify-nh` with proper Junos export policy (`next-hop unchanged`).
3. **🟠 HIGH — 7.5 Q1/Q2:** Remove invented `cef vpn-with-recursion`, fix `bgp attribute-download` placement.
4. **🟠 HIGH — 7.5 Q2:** Add IGP SPF step to convergence timing table (~350ms → ~600ms).
5. **🟡 MEDIUM — 7.1 Q1:** Add parentheses to SOO syntax.
6. **🟡 MEDIUM — 7.1 Q3:** Move `label mode per-vrf` to per-VRF context or add version note.
7. **🟡 MEDIUM — 7.3 Q2:** Replace `through` range with proper extcommunity-set definition.
8. **🟡 MEDIUM — 7.3 Q3:** Replace `redistribute static` with proper iBGP labeled-unicast session fix.
9. **🟡 MEDIUM — 7.5 Q2:** Remove `unequal-cost` from `maximum-paths ibgp`.
10. **🟢 LOW — 7.2 Q1:** Mention IOS-XR auto-default-RT behavior during RT-Constraint migration.
