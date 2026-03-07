# RFC Standards Review — Modules 1, 2, 3

**Reviewer:** Protocol Standards Subagent  
**Date:** 2026-02-28  
**Scope:** Modules 1 (Foundations), 2 (IGP), 3 (BGP)  
**Method:** Line-by-line review against authoritative RFCs listed in SOURCES.md  

---

## Summary

| Severity | Count |
|----------|-------|
| CRITICAL | 2 |
| MODERATE | 2 |
| MINOR | 3 |
| **Total Issues** | **7** |

Overall assessment: The guide is **technically strong** for a study resource. The majority of protocol claims are accurate. The issues found are concentrated in specific RFC number citations and a few attribute behavior claims rather than systemic misunderstandings. No fundamental algorithmic descriptions (SPF, best-path selection, etc.) are wrong.

---

## 1.1-1.4-sp-foundations.md

### Verified Claims (summary)
- Three-tier architecture (P/PE/CE) correctly described
- MPLS label scaling argument (O(N) vs O(routes×N)) is correct
- Convergence budget breakdown (BFD + FRR + propagation ≈ 50ms) is accurate
- MPLS TC field is correctly identified as 3-bit (per RFC 5462 renaming EXP→TC)
- VRF isolation model, RD/RT mechanics, and EVPN role are correctly described
- BFD timer math (interval × multiplier) is correct
- Route reflector O(N²)→O(N) scaling is correctly stated
- Inter-AS Option A/B/C descriptions are accurate

### Issues Found

No RFC-level protocol errors found. This module is primarily architectural and design-level, making few specific protocol claims that could conflict with RFCs. The vendor-specific defaults (SRGB ranges, BGP scanner interval) are correctly attributed to their respective platforms.

**Note (not an issue):** The module states "Unique cluster-ID per RR (ensures clients receive routes from all RRs independently; shared cluster-ID causes RRs to discard each other's reflected routes)" in §1.4 (National Carrier topology). Module 3.2 advocates the opposite pattern (shared cluster-ID for redundant RRs). Both are valid designs with different tradeoffs — unique cluster-IDs for path diversity, shared for duplicate reduction. This is a design philosophy difference, not an RFC error, but the guide would benefit from consistent framing or a cross-reference note acknowledging both patterns.

---

## 2.1-isis-deep-dive.md

### Verified Claims (summary)
- NET format (AFI.Area.SystemID.SEL) correctly described
- IS-IS level hierarchy (L1 intra-area, L2 backbone, L1/L2 border) accurate
- PDU types (IIH, LSP, CSNP, PSNP) correctly listed
- Three-way handshake (RFC 5303): Down → Init → Up — correct
- DIS behavior (preemption, no backup, pseudonode LSP) — correct per ISO 10589
- TLV table: All type codes verified correct
  - TLV 1 (Area Addresses) ✓
  - TLV 2 (IS Neighbors, old) ✓
  - TLV 22 (Extended IS Reachability, RFC 5305) ✓
  - TLV 135 (Extended IP Reachability, RFC 5305) ✓
  - TLV 236 (IPv6 Reachability, RFC 5308) ✓
  - TLV 229 (Multi-Topology, RFC 5120) ✓
  - TLV 242 (Router Capability, RFC 7981) ✓
- SPF backoff algorithm (RFC 8405) correctly described
- LSP lifetime default 1200s — correct per ISO 10589 (maximumAge)
- LSP refresh default 900s — correct per ISO 10589 (maximumLSPGenerationInterval)
- Default hello 10s, hold 30s (hello × multiplier 3) — correct
- Overload bit behavior correctly described

### Issues Found

**Section is clean.** No RFC-level errors detected. All TLV codes, timer defaults, and protocol behaviors match their respective specifications.

---

## 2.2-ospf-in-sp-networks.md

### Verified Claims (summary)
- OSPF packet types (1-5: Hello, DBD, LSR, LSU, LSAck) — correct per RFC 2328
- LSA type table (Types 1-11) — all correctly described per RFC 2328/RFC 5340/RFC 5250
- Area types (Standard, Stub, Totally Stubby, NSSA, Totally NSSA) — correct per RFC 2328/RFC 3101
- OSPFv3 differences from OSPFv2 — accurate per RFC 5340
- OSPFv3 authentication via IPsec — correct per RFC 5340 §2.2
- OSPFv3 Address Families via RFC 5838 — correct
- Default hello 10s, dead 40s — correct per RFC 2328 Appendix C.3
- OSPF runs over IP protocol 89 — correct
- LFA (RFC 5286) and Remote LFA (RFC 7490) correctly referenced

### Issues Found

**Section is clean.** No RFC-level protocol errors. The vendor-specific defaults (SPF timer defaults, reference bandwidth) are correctly attributed to their respective platforms rather than claimed as RFC-mandated.

---

## 2.3-igp-convergence-tuning.md

### Verified Claims (summary)
- Convergence pipeline stages correctly ordered: Detection → Notification → SPF → RIB → FIB
- BFD async mode detection time = 3× interval — correct per RFC 5880
- Micro-BFD (RFC 7130) for LAG member links — correct
- SPF throttle three-timer model (initial-wait, second-wait, max-wait) — correct per RFC 8405
- LFA (RFC 5286), Remote LFA (RFC 7490) correctly described
- LFA coverage limitation (40-80% typical) — accurate operational characterization
- Remote LFA coverage (90-95% typical) — accurate operational characterization
- IS-IS default hello 10s / hold 30s, OSPF default hello 10s / dead 40s — correct

### Issues Found

- **SEVERITY: CRITICAL**
- **CLAIM:** "RFC 8400 (TI-LFA)" (in Quick Reference section: "Key RFCs: RFC 5880 (BFD), RFC 5286 (LFA), RFC 7490 (rLFA), RFC 8400 (TI-LFA), RFC 8405 (SPF backoff)")
- **PROBLEM:** RFC 8400 is "Extensions to RSVP-TE for Label Switched Path (LSP) Egress Protection" (Chen et al., June 2018). It has nothing to do with TI-LFA. The correct RFC for TI-LFA is **RFC 9855** ("Topology Independent Fast Reroute using Segment Routing").
- **RFC REFERENCE:** RFC 8400 title page: "Extensions to RSVP-TE for Label Switched Path (LSP) Egress Protection." RFC 9855 (published from draft-ietf-rtgwg-segment-routing-ti-lfa) is the actual TI-LFA specification.
- **SUGGESTED FIX:** Replace all references to "RFC 8400 (TI-LFA)" with "RFC 9855 (TI-LFA)" throughout the document. Specific locations:
  - Quick Reference: `RFC 8400 (TI-LFA)` → `RFC 9855 (TI-LFA)`
  - Any inline references to RFC 8400 in the context of TI-LFA

---

- **SEVERITY: MINOR**
- **CLAIM:** "Detection (BFD) | 30s (IGP hello)" (in the convergence budget table, "Default" column)
- **PROBLEM:** The 30s value is the IS-IS hold time (10s hello × 3 multiplier). OSPF's default dead timer is 40s (10s hello × 4). The table labels this generically as "IGP hello" but uses the IS-IS-specific value.
- **RFC REFERENCE:** RFC 2328 Appendix C.3 specifies OSPF RouterDeadInterval default as 40 seconds. ISO 10589 specifies IS-IS holdingTime as 30 seconds (with helloInterval of 10s and multiplier of 3).
- **SUGGESTED FIX:** Change to "30-40s (IGP hello)" or add a note: "30s for IS-IS (10s × 3), 40s for OSPF (10s × 4)"

---

## 2.4-isis-vs-ospf-decision-framework.md

### Verified Claims (summary)
- Protocol comparison table (runs on, extensibility, area hierarchy, etc.) — accurate
- Scalability characteristics comparison — accurate operational characterization
- Convergence comparison (BFD identical, SPF delays configurable) — correct
- Segment routing support comparison — accurate
- IS-IS NBMA limitation — correct (IS-IS doesn't support NBMA natively)
- Junos route preferences: OSPF internal = 10, IS-IS L2 = 18 — correct
- Ships-in-the-night migration strategy — correctly described
- CONFED_SEQUENCE/CONFED_SET path segment types — correct per RFC 5065 §3

### Issues Found

- **SEVERITY: MINOR**
- **CLAIM:** "Direct L2 frames (ethertype 0xFE)" (in Protocol Fundamentals comparison table, IS-IS Encapsulation column)
- **PROBLEM:** IS-IS does not use Ethernet II framing with an ethertype. IS-IS PDUs are encapsulated in IEEE 802.2 LLC frames with DSAP and SSAP both set to 0xFE. The value 0xFE is an LLC Service Access Point (SAP), not an Ethernet II ethertype. Ethertypes are 2-byte values in DIX/Ethernet II frames (e.g., 0x0800 for IPv4, 0x86DD for IPv6). IS-IS uses 802.2 LLC framing, which is a fundamentally different encapsulation.
- **RFC REFERENCE:** ISO 10589 specifies IS-IS encapsulation over 802.2 LLC. IEEE 802.2 defines SAP 0xFE.
- **SUGGESTED FIX:** Change "Direct L2 frames (ethertype 0xFE)" to "Direct L2 frames (IEEE 802.2 LLC, SAP 0xFE)" or "Direct L2 frames (LLC SAP 0xFE)"

---

## 3.1-bgp-fundamentals-at-sp-scale.md

### Verified Claims (summary)
- BGP FSM states (Idle, Connect, Active, OpenSent, OpenConfirm, Established) — correct per RFC 4271 §8
- Path attribute type codes all verified correct:
  - ORIGIN (1), AS_PATH (2), NEXT_HOP (3), MED (4), LOCAL_PREF (5), ATOMIC_AGGREGATE (6), AGGREGATOR (7) — RFC 4271
  - COMMUNITY (8) — RFC 1997
  - ORIGINATOR_ID (9), CLUSTER_LIST (10) — RFC 4456
  - EXTENDED COMMUNITY (16) — RFC 4360
  - AIGP (26) — RFC 7311
  - LARGE COMMUNITY (32) — RFC 8092
- Attribute classifications (well-known mandatory/discretionary, optional transitive/non-transitive) — correct per RFC 4271
- Best-path selection order — correct (Weight correctly identified as Cisco-proprietary)
- BGP message types (OPEN, UPDATE, KEEPALIVE, NOTIFICATION, ROUTE-REFRESH) — correct
- KEEPALIVE size: 19 bytes — correct per RFC 4271 §4.4
- MP-BGP AFI/SAFI table — all values verified correct
- 4-byte ASN (RFC 6793) — correctly described
- AS_TRANS behavior correctly described in prose (value 23456)
- OPEN capabilities list (4-byte ASN, MP extensions, Route Refresh, GR, ADD-PATH) — correct

### Issues Found

- **SEVERITY: CRITICAL**
- **CLAIM:** (In 4-Byte ASN table) "| 65535 | Reserved (AS_TRANS) |"
- **PROBLEM:** AS 65535 is NOT AS_TRANS. AS_TRANS is AS number **23456**, defined in RFC 6793 §6 as a reserved 2-byte ASN used as a placeholder when a 4-byte ASN cannot be represented in a 2-byte AS_PATH. AS 65535 is reserved by IANA as "Reserved" (the last 16-bit ASN), but it is not the AS_TRANS value. The document's own prose below the table correctly identifies AS_TRANS as 23456, creating an internal contradiction.
- **RFC REFERENCE:** RFC 6793 §6: "a 2-octet AS number value 23456 is used for the AS_TRANS value." IANA AS Numbers registry lists 65535 as "Reserved" and 23456 as "AS_TRANS" (RFC 6793).
- **SUGGESTED FIX:** Change the table entry from `| 65535 | Reserved (AS_TRANS) |` to `| 65535 | Reserved |` and add a separate row: `| 23456 | AS_TRANS (RFC 6793) |`

  Complete corrected table:
  ```
  | Range | Use |
  |-------|-----|
  | 0 | Reserved |
  | 1-64495 | Public 2-byte |
  | 23456 | AS_TRANS (RFC 6793) |
  | 64496-64511 | Documentation (RFC 5398) |
  | 64512-65534 | Private 2-byte |
  | 65535 | Reserved |
  | 65536-4199999999 | Public 4-byte |
  | 4200000000-4294967294 | Private 4-byte |
  | 4294967295 | Reserved |
  ```

---

- **SEVERITY: MODERATE**
- **CLAIM:** (In Key Knobs table) "Keepalive / Hold | ... | Junos Default: 60s / 90s"
- **PROBLEM:** Junos default hold-time is 90 seconds, but the keepalive interval in Junos is derived as hold-time ÷ 3 = **30 seconds**, not 60 seconds. Junos does not independently configure a keepalive timer — it is always 1/3 of the negotiated hold-time. The 60s keepalive value shown appears to be the IOS-XR default incorrectly copied into the Junos column.
- **RFC REFERENCE:** RFC 4271 §4.4: "A reasonable maximum time between KEEPALIVE messages would be one third of the Hold Time interval." Juniper Junos documentation confirms keepalive = hold-time/3.
- **SUGGESTED FIX:** Change Junos default from "60s / 90s" to "30s / 90s"

---

## 3.2-ibgp-design.md

### Verified Claims (summary)
- Full-mesh formula n(n-1)/2 — correct
- Route Reflector (RFC 4456) reflection rules — all three rules verified correct:
  - From eBGP → clients + non-clients ✓
  - From client → other clients + non-clients ✓
  - From non-client → clients only ✓
- ORIGINATOR_ID (type 9) loop prevention — correct per RFC 4456 §9
- CLUSTER_LIST (type 10) loop prevention — correct per RFC 4456 §9
- ADD-PATH (RFC 7911) for optimal path problem — correct
- BGP Optimal Route Reflection (RFC 9107) — correct
- Confederation (RFC 5065) basic description — correct
- CONFED_SEQUENCE and CONFED_SET don't count for AS_PATH length — correct per RFC 5065 §5.3
- Shared cluster-ID for redundant RRs — correct recommendation per RFC 4456 §7

### Issues Found

- **SEVERITY: MODERATE**
- **CLAIM:** "LOCAL_PREF, MED, and NEXT_HOP are preserved across confederation boundaries (unlike true eBGP)"
- **PROBLEM:** NEXT_HOP is **NOT** preserved across confederation boundaries. Per RFC 5065, NEXT_HOP follows normal eBGP rules at confederation member-AS boundaries — meaning the NEXT_HOP is changed to the address of the advertising speaker. Only LOCAL_PREF and MED receive special handling (preserved unlike true eBGP where LOCAL_PREF would be stripped).

  The document's own configuration example contradicts this claim: the confederation eBGP neighbor config shows `neighbor 10.1.0.1 next-hop-self-all` — an explicit next-hop-self override would be unnecessary if NEXT_HOP were already preserved by the protocol.
- **RFC REFERENCE:** RFC 5065 §5.2 specifies that LOCAL_PREF and MED are preserved across confederation boundaries. NEXT_HOP is not included in the list of specially preserved attributes. RFC 5065 §4.1 treats inter-member-AS sessions using eBGP-style rules, and NEXT_HOP follows standard eBGP behavior (changed at boundary).
- **SUGGESTED FIX:** Change "LOCAL_PREF, MED, and NEXT_HOP are preserved across confederation boundaries (unlike true eBGP)" to:

  "LOCAL_PREF and MED are preserved across confederation boundaries (unlike true eBGP, where LOCAL_PREF is not carried). NEXT_HOP follows normal eBGP rules — it changes at confederation member-AS boundaries unless explicitly overridden with `next-hop-self`."

---

## 3.3-ebgp-peering.md

### Verified Claims (summary)
- Peering relationships (transit, peer, customer, IX RS) correctly described
- LOCAL_PREF scheme (customer 150, peer 100, transit 80) — standard operational practice, correct
- RPKI ROV states (Valid, Invalid, NotFound) — correct per RFC 6811
- TCP MD5 (RFC 2385) — correct
- TCP-AO (RFC 5925) — correct
- GTSM (RFC 5082) — correct: TTL set to 255 outgoing, require ≥254 incoming for hops=1
- GTSM and ebgp-multihop mutual exclusivity — correct per implementation and RFC intent
- Graceful Shutdown (RFC 8326) community 65535:0 — correct
- BLACKHOLE community (RFC 7999) — correct
- Bogon prefix list — all entries verified correct against RFC 5737, RFC 6890, RFC 1918, RFC 6598, RFC 3927, RFC 2544
- Route server transparency (no ASN insertion) — correct
- Valley-free routing principle — correct
- Prefix filtering recommendations align with RFC 7454 (BCP 194)

### Issues Found

**Section is clean.** No RFC-level protocol errors. The security recommendations (RPKI, GTSM, prefix filtering, max-prefix) align with RFC 7454 best practices.

---

## 3.4-bgp-policy-and-traffic-engineering.md

### Verified Claims (summary)
- Well-Known Communities — all values verified correct:
  - NO_EXPORT: 65535:65281 (0xFFFFFF01) — correct per RFC 1997
  - NO_ADVERTISE: 65535:65282 (0xFFFFFF02) — correct per RFC 1997
  - NO_EXPORT_SUBCONFED: 65535:65283 (0xFFFFFF03) — correct per RFC 1997
  - NOPEER: 65535:65284 (0xFFFFFF04) — correct per RFC 3765
  - GRACEFUL_SHUTDOWN: 65535:0 (0xFFFF0000) — correct per RFC 8326
  - BLACKHOLE: 65535:666 (0xFFFF029A) — correct per RFC 7999
- Extended Communities (RFC 4360) — correct
- Large Communities (RFC 8092) — 96-bit, ASN:Function:Parameter format correct
- MED comparison scope (same neighbor AS by default) — correct per RFC 4271 §9.1.2.2
- Flowspec (RFC 8955) — correct
- ADD-PATH (RFC 7911) — correct
- RTBH mechanism correctly described
- AS_PATH prepending mechanics — correct
- Selective announcement (aggregate + more-specifics) — correct technique

### Issues Found

- **SEVERITY: MINOR**
- **CLAIM:** "RFC 7196 recommends against dampening for most cases" (in Key Knobs table, `bgp dampening` row)
- **PROBLEM:** RFC 7196 ("Making Route Flap Damping Usable") does not recommend against route flap dampening. It recommends **revised parameter values** that make dampening less aggressive and more appropriate for modern networks. The RFC's purpose is to make dampening usable, not to discourage its use. The previous recommendation against aggressive dampening came from RIPE-580 and operational community consensus, not from RFC 7196 itself.
- **RFC REFERENCE:** RFC 7196 Abstract: "This document [...] describes a set of Best Current Practices for the application of BGP route flap dampening." It provides updated parameters (e.g., 2000 suppress threshold, 750 reuse) rather than recommending removal.
- **SUGGESTED FIX:** Change "RFC 7196 recommends against dampening for most cases" to "RFC 7196 provides updated dampening parameters; most modern SP networks disable dampening or use very conservative settings per RIPE-580/RFC 7196 guidance"

---

## Cross-Module Issues

### Cluster-ID Design Inconsistency (Informational — Not an RFC Error)

Module 1.4 (National Carrier) recommends: "Unique cluster-ID per RR (ensures clients receive routes from all RRs independently)"

Module 3.2 (War Story) recommends: "Redundant RRs serving the same clients MUST share a cluster-id"

Both are valid designs per RFC 4456. The choice depends on whether path diversity (unique cluster-IDs + ADD-PATH) or duplicate reduction (shared cluster-IDs) is prioritized. The guide would benefit from acknowledging both patterns in one location and cross-referencing.

### TI-LFA RFC Number Propagation

The incorrect RFC 8400 citation for TI-LFA appears in Module 2.3. Check all other modules (4, 5, 6 especially) for the same error — the correct RFC is **RFC 9855**.

---

## Appendix: RFC Quick-Reference for Corrections

| Document Claim | Cited As | Correct RFC | Title |
|---------------|----------|-------------|-------|
| TI-LFA | RFC 8400 | **RFC 9855** | Topology Independent Fast Reroute using Segment Routing |
| RSVP-TE Egress Protection | (confused with TI-LFA) | RFC 8400 | Extensions to RSVP-TE for LSP Egress Protection |
| AS_TRANS value | 65535 (in table) | 23456 | Per RFC 6793 §6 |

---

*Review methodology: Each file was read in full and every technical claim was compared against the authoritative RFCs listed in SOURCES.md. Only issues where the reviewer has high confidence in the RFC specification were flagged. Vendor-specific defaults and operational recommendations were verified where possible but are inherently implementation-dependent and were not flagged unless clearly wrong.*
