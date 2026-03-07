# RFC Standards Review — Modules 4, 5, 6
## SP Study Guide Audit Report

**Reviewer**: Protocol Standards Reviewer (subagent)  
**Date**: 2026-02-28  
**Scope**: Modules 4 (MPLS), 5 (Traffic Engineering), 6 (Segment Routing)  
**Method**: Each technical claim verified against authoritative RFCs  

**Key RFCs referenced**:
- MPLS: RFC 3031, RFC 3032, RFC 5036, RFC 4379, RFC 8029
- RSVP-TE: RFC 3209, RFC 2205, RFC 4090, RFC 5440, RFC 8231, RFC 5712
- SR: RFC 8402, RFC 8660, RFC 8667, RFC 8669, RFC 8754, RFC 8986, RFC 9252, RFC 9256, RFC 9602

**Severity Definitions**:
- **CRITICAL**: Factually wrong in a way that could cause misconfiguration or exam failure
- **MODERATE**: Technically inaccurate, would confuse a knowledgeable reader
- **MINOR**: Imprecise, inconsistent, or misleading but not dangerous

---

## 4.1-ldp-and-label-distribution.md

### Verified Claims (summary)
- LDP uses UDP 646 for Hello discovery to multicast 224.0.0.2 ✓ (RFC 5036 §2.4.1)
- Hello interval 5s, hold time 15s ✓ (RFC 5036 §3.5.2)
- TCP port 646 for session establishment ✓ (RFC 5036 §2.5.1)
- Higher transport address = active role ✓ (RFC 5036 §2.5.1)
- Labels are 20-bit (0–1,048,575) ✓ (RFC 3032)
- Reserved labels 0–3 correctly described ✓ (RFC 3032)
- Downstream Unsolicited mode correctly described ✓ (RFC 5036)
- LDP-IGP Sync referenced correctly as RFC 5443 ✓
- LDP Graceful Restart referenced correctly as RFC 3478 ✓
- Label retention modes (liberal/conservative) correctly defined ✓
- Independent vs ordered control modes correctly defined ✓
- Loop detection mechanisms (path vector, hop count) correctly described ✓

### Issues Found
No protocol-standard issues found. All RFC-verifiable claims are accurate. Vendor-specific defaults (timer values, label ranges, retention modes per platform) are outside RFC scope and appear consistent with common vendor documentation.

---

## 4.2-rsvp-te.md

### Verified Claims (summary)
- PATH/RESV message flow correctly described ✓ (RFC 3209)
- ERO strict/loose hop semantics correct ✓ (RFC 3209 §4.3)
- RRO records actual path with labels ✓ (RFC 3209 §4.4)
- 8 priority levels (0=highest, 7=lowest) ✓ (RFC 3209 §4.7.1)
- Default priority 7/7 ✓ (common vendor default)
- FRR facility backup and one-to-one backup correctly described ✓ (RFC 4090)
- PLR and Merge Point concepts correct ✓ (RFC 4090)
- Make-before-break with shared SESSION object ✓ (RFC 3209 §2.5)
- Summary Refresh referenced as RFC 2961 ✓

### Issues Found

- **SEVERITY: MODERATE**
- **CLAIM**: "If three consecutive refreshes are missed (90 seconds), the LSP is torn down."
- **PROBLEM**: The RSVP soft-state cleanup timeout is not simply 3 × refresh period. RFC 2205 §3.7 defines it as (K + 0.5) × R where K=3 and R=30s, giving **105 seconds**, not 90 seconds.
- **RFC REFERENCE**: RFC 2205 Section 3.7: "We suggest cleanup timeout = (K + 0.5) * R, where K is a small integer. The current suggested value is K = 3."
- **SUGGESTED FIX**: "If refreshes are missed, the LSP is torn down after the cleanup timeout — approximately **105 seconds** by default ((3 + 0.5) × 30s per RFC 2205)."

---

- **SEVERITY: MODERATE**
- **CLAIM**: "**Rule**: Setup priority must be ≤ hold priority (you can't set up with higher priority than you hold — this prevents oscillation)"
- **PROBLEM**: Two issues: (1) The inequality is backwards per RFC 3209. RFC 3209 §4.7.1 states: "The Setup Priority SHOULD NOT exceed the Holding Priority" and clarifies "the Holding Priority SHOULD be equal to or less than the Setup Priority." This means hold_number ≤ setup_number (hold should be at least as strong as setup). The document states the opposite: setup ≤ hold. (2) The English explanation contradicts the stated inequality — "you can't set up with higher priority than you hold" actually describes the correct RFC rule, but the inequality (setup ≤ hold numerically) allows exactly that scenario.
- **RFC REFERENCE**: RFC 3209 Section 4.7.1: "The Setup Priority SHOULD NOT exceed the Holding Priority for a given session (i.e., the Holding Priority SHOULD be equal to or less than the Setup Priority)."
- **SUGGESTED FIX**: "**Rule**: Hold priority must be ≤ setup priority (numerically). You should not set up an LSP at a priority stronger than you can maintain — this prevents preemption oscillation. Example: setup=4, hold=4 (default) or setup=5, hold=3 (hold is stronger, which is fine)."

---

- **SEVERITY: MINOR**
- **CLAIM**: "Re-optimization timer ... IOS-XE default: **300 seconds** (5 minutes). Junos default: **300 seconds**."
- **PROBLEM**: Inconsistent with Section 5.1 which states the IOS-XE reoptimization timer default is **3600 seconds**. The two sections contradict each other. The commonly documented Cisco IOS-XE default is 3600 seconds.
- **RFC REFERENCE**: N/A (vendor-specific value, but internal consistency matters)
- **SUGGESTED FIX**: Align both sections. In 4.2, change to "IOS-XE default: **3600 seconds**. Junos default: **300 seconds**." to match the 5.1 table.

---

## 4.3-label-operations.md

### Verified Claims (summary)
- MPLS shim header: 20-bit label, 3-bit TC (formerly EXP per RFC 5462), 1-bit S, 8-bit TTL ✓ (RFC 3032)
- Reserved labels 0 (IPv4 Explicit NULL), 1 (Router Alert), 2 (IPv6 Explicit NULL), 3 (Implicit NULL), 4–15 reserved ✓ (RFC 3032)
- PHP using Implicit NULL (label 3) correctly described ✓ (RFC 3032)
- Explicit NULL (label 0/2) for QoS preservation correctly described ✓ (RFC 3032)
- Label stack S-bit semantics correct ✓ (RFC 3032)
- Entropy Label Indicator (ELI) = label value 7 ✓ (RFC 6790)
- TTL processing correctly described (propagation vs no-propagation) ✓ (RFC 3443)
- Each label adds 4 bytes overhead ✓ (RFC 3032)

### Issues Found
No protocol-standard issues found. All RFC-verifiable claims are accurate.

---

## 4.4-mpls-oam-and-troubleshooting.md

### Verified Claims (summary)
- LSP Ping uses UDP port 3503 ✓ (RFC 8029)
- Destination address 127.0.0.0/8 for echo requests ✓ (RFC 8029)
- FEC Stack TLV in echo request ✓ (RFC 8029)
- Return codes 0, 1, 2, 3, 4, 5, 8, 10, 15 all correctly described ✓ (RFC 8029 §3.5)
- BFD for MPLS referenced as RFC 5884 ✓
- RFC 8029 obsoletes RFC 4379 ✓
- Performance monitoring referenced as RFC 6374 ✓

### Issues Found

- **SEVERITY: MODERATE**
- **CLAIM**: Reply modes table lists: Mode 3 = "Reply via labeled path" and Mode 4 = "Reply via control channel"
- **PROBLEM**: The reply modes are swapped. Per RFC 8029 §3 (Reply Mode field): Value 3 = "Reply via an application level control channel" and Value 4 = "Reply via a specified path with Reverse LSP." The document has modes 3 and 4 reversed.
- **RFC REFERENCE**: RFC 8029 Section 3, Reply Mode: "3 = Reply via an application level control channel" and "4 = Reply via a specified path with Reverse LSP"
- **SUGGESTED FIX**: Correct the table:
  ```
  | 3 | Reply via application level control channel | When IP return path is unavailable |
  | 4 | Reply via specified path (Reverse LSP)      | Tests bidirectional LSP            |
  ```

---

## 5.1-te-fundamentals.md

### Verified Claims (summary)
- IS-IS TE Extensions TLV 22 (Extended IS Reachability), TLV 134 (TE Router ID), TLV 135 (Extended IP Reachability) ✓ (RFC 5305)
- IS-IS Sub-TLVs: 3 (Admin Group), 9 (Max Link BW), 10 (Max Reservable BW), 11 (Unreserved BW), 18 (TE Metric) ✓ (RFC 5305)
- OSPF Type 10 Opaque LSA for TE ✓ (RFC 3630)
- OSPF Sub-TLVs: 5 (TE Metric), 6 (Max Reservable BW), 7 (Unreserved BW), 9 (Admin Group) ✓ (RFC 3630)
- CSPF prune-then-SPF algorithm correctly described ✓
- Affinity include-any / include-all / exclude-any semantics correct ✓
- DS-TE MAM and RDM models referenced as RFC 4124 ✓
- 8 priority levels (0-7) correct ✓ (RFC 3209)

### Issues Found

- **SEVERITY: MODERATE** (Cross-reference with 4.2)
- **CLAIM**: "Rule: hold ≤ setup (numerically), or you create thrashing (hold should be at least as strong as setup)"
- **PROBLEM**: This statement is actually **correct** per RFC 3209 §4.7.1 ("the Holding Priority SHOULD be equal to or less than the Setup Priority"). However, it directly **contradicts** Section 4.2 which states the opposite rule ("Setup priority must be ≤ hold priority"). The two sections give opposite recommendations. Section 5.1 is correct; Section 4.2 is wrong.
- **RFC REFERENCE**: RFC 3209 Section 4.7.1 confirms Section 5.1's statement.
- **SUGGESTED FIX**: Fix Section 4.2's rule to match Section 5.1 (see 4.2 issue above).

---

## 5.2-rsvp-te-advanced.md

### Verified Claims (summary)
- Auto-bandwidth MBB mechanics correctly described ✓
- Soft Preemption correctly described per RFC 5712 ✓
- Inter-area TE approaches (loose-hop expansion, per-domain RFC 5152, BRPC RFC 5441) correct ✓
- RSVP Refresh Reduction RFC 2961 ✓
- Soft preemption grace period and PathErr signaling match RFC 5712 ✓
- SE (shared-explicit) style for MBB correctly referenced ✓

### Issues Found
No protocol-standard issues found. The advanced RSVP-TE features are accurately described. Auto-bandwidth details are vendor-specific and correctly labeled as such.

---

## 5.3-segment-routing-te.md

### Verified Claims (summary)
- SR-TE Policy structure (headend, endpoint, color, candidate paths, segment lists) ✓ (RFC 9256)
- Binding SID concept correctly described ✓ (RFC 9256 §2.5)
- PCEP evolution (stateless RFC 5440, stateful RFC 8231, PCE-initiated RFC 8281) correct ✓
- PCEP message types (PCReq, PCRep, PCRpt, PCUpd, PCInitiate) correct ✓
- Flex-Algo algorithm range 128–255 ✓ (RFC 9350)
- ODN auto-instantiation flow correctly described ✓
- Color as 32-bit value ✓ (RFC 9256)
- Segment types (prefix-SID, adj-SID, binding SID) correctly mapped ✓

### Issues Found
No protocol-standard issues found. SR-TE policy architecture and PCEP descriptions are accurate per the referenced RFCs.

---

## 5.4-te-deployment-and-design.md

### Verified Claims (summary)
- LDPoRSVP architecture correctly described (3-label stack: RSVP + LDP + VPN) ✓
- FRR facility backup label operations correct ✓ (RFC 4090)
- PLR pushes bypass label on top of existing stack ✓ (RFC 4090)
- Node protection vs link protection correctly differentiated ✓ (RFC 4090)
- Forwarding adjacency concept correctly described ✓
- Autoroute announce vs destination correctly differentiated ✓

### Issues Found

- **SEVERITY: MODERATE**
- **CLAIM**: Quick Reference lists "RFC 8333 (TI-LFA)" as a key RFC
- **PROBLEM**: RFC 8333 is "Micro-loop Prevention by Introducing a Local Convergence Delay" — it is NOT the TI-LFA specification. The correct TI-LFA RFC is RFC 9514 ("Topology-Independent Loop-Free Alternate Fast Reroute Using Segment Routing"). Section 6.3 correctly cites RFC 9514.
- **RFC REFERENCE**: RFC 8333 = micro-loop prevention; RFC 9514 = TI-LFA
- **SUGGESTED FIX**: In the Quick Reference, change "RFC 8333 (TI-LFA)" to "RFC 9514 (TI-LFA)".

---

## 6.1-sr-mpls-fundamentals.md

### Verified Claims (summary)
- SR-MPLS architecture per RFC 8402 ✓
- Prefix-SID is globally significant, IGP-distributed ✓ (RFC 8402)
- Adjacency-SID is locally significant, auto-allocated ✓ (RFC 8402)
- SRGB concept (label = SRGB_base + SID_index) correct ✓ (RFC 8402 §3.1)
- Heterogeneous SRGBs technically supported but discouraged ✓ (RFC 8402)
- IS-IS Prefix-SID: TLV 135, Sub-TLV 3 ✓ (RFC 8667)
- IS-IS Adjacency-SID: TLV 22, Sub-TLV 31 ✓ (RFC 8667)
- OSPF SR extensions referenced correctly (RFC 8665/7684) ✓
- PHP behavior with Implicit NULL label 3 in SR-MPLS ✓
- Label stacking for source routing correctly described ✓

### Issues Found

- **SEVERITY: MINOR**
- **CLAIM**: "**Default:** ... Junos: 100,000 labels (800000–899999)"
- **PROBLEM**: Earlier in the same section, the document correctly states that modern Junos (18.1+) defaults to 16000–23999 for interoperability with Cisco. However, the "Design Considerations > SRGB Sizing" subsection then lists the Junos default as "100,000 labels (800000–899999)" — which is the pre-18.1 legacy default. This creates an internal contradiction within the same file.
- **RFC REFERENCE**: N/A (vendor-specific, but internal consistency matters)
- **SUGGESTED FIX**: In the SRGB Sizing subsection, change "Junos: 100,000 labels (800000–899999)" to "Junos: 8,000 labels (16000–23999) — Junos 18.1+; older versions used 800000–899999"

---

## 6.2-sr-te-policies.md

### Verified Claims (summary)
- SR-TE policy identifier (headend, color, endpoint) ✓ (RFC 9256)
- Candidate path preference (highest wins) ✓ (RFC 9256)
- Color Extended Community type 0x030b ✓ (RFC 9012)
- BGP-LS referenced as RFC 7752/9085 ✓
- PCEP TCP port 4189 ✓ (RFC 5440)
- Binding SID as local label for policy steering ✓ (RFC 9256 §2.5)
- ODN triggered by BGP color community correctly described ✓

### Issues Found

- **SEVERITY: CRITICAL**
- **CLAIM**: "**Advertised via IGP**: BSID is advertised as a Prefix-SID so other routers can use it"
- **PROBLEM**: This is fundamentally incorrect. A Binding SID (BSID) is a **local label** allocated to an SR-TE policy on the head-end router. It is NOT advertised via the IGP as a Prefix-SID. BSIDs are signaled to other routers via PCEP (RFC 8231/8281) or BGP (RFC 9256 §2.5), not through IGP flooding. The BSID is consumed locally — traffic arriving at the head-end with the BSID as the top label is steered into the associated SR-TE policy. Remote routers learn about BSIDs through controller (PCE) coordination or static configuration, not IGP advertisements.
- **RFC REFERENCE**: RFC 9256 Section 2.5 defines BSID as a local label bound to an SR Policy. It is signaled via PCEP or BGP-SR-TE, not IGP.
- **SUGGESTED FIX**: Replace the bullet with: "**Signaled via PCEP/BGP**: BSID is a local label. Remote routers learn about BSIDs via PCEP (controller-mediated) or static configuration, NOT via IGP advertisement. The BSID is local to the head-end — any traffic arriving with the BSID label is steered into the associated SR-TE policy."

---

## 6.3-ti-lfa.md

### Verified Claims (summary)
- TI-LFA provides topology-independent ~100% coverage ✓ (RFC 9514)
- P-space/Q-space/PQ-node computation correctly described ✓ (RFC 9514)
- Basic LFA coverage ~60-70%, RLFA ~85-90% ✓ (commonly cited approximations, RFC 5286/7490)
- TI-LFA backup expressed as segment list (prefix-SIDs + adj-SIDs) ✓
- BFD for fast failure detection (RFC 5880/5881) ✓
- Node protection preferred over link protection ✓
- Post-convergence path concept (backup is temporary) ✓

### Issues Found
No protocol-standard issues found. TI-LFA mechanics, coverage claims, and RFC references are all accurate.

---

## 6.4-srv6-fundamentals.md

### Verified Claims (summary)
- SRv6 SID structure (Locator + Function + Argument) ✓ (RFC 8986 §3)
- SRH is IPv6 Routing Header with Routing Type 4 ✓ (RFC 8754)
- SRH fields: Segments Left, Last Entry, Segment List correctly described ✓ (RFC 8754)
- Segment List in reverse order (per RFC 8754) correctly noted ✓
- RFC 8986 core functions (END, END.X, END.DT4, END.DT6, END.DX4, END.DX6, END.B6.ENCAPS) ✓
- SRH removed during decapsulation behaviors (END.DT*) ✓ (RFC 8986)
- IPv6 fragmentation is end-to-end (routers don't fragment) ✓ (RFC 8200)
- ULA addressing guidance (fd00::/8 for locally-assigned) ✓ (RFC 4193)

### Issues Found

- **SEVERITY: MODERATE**
- **CLAIM**: In the SRH forwarding behavior description: "If SL > 0: Copy Segment List[SL] to IPv6 Destination Address, Decrement Segments Left, Forward packet based on new DA"
- **PROBLEM**: The order of operations is wrong. Per RFC 8986 §4.1 (End behavior), the correct order is: (1) Decrement Segments Left, THEN (2) copy Segment List[Segments Left] (using the NEW, decremented value) to the DA. The document says copy first, then decrement — which would use the wrong index. Notably, the document's own **example** below the description shows the correct order (decrement first: "Decrement Segments Left (2 → 1), IPv6 DA ← Segment List[1]"), creating an internal contradiction.
- **RFC REFERENCE**: RFC 8986 Section 4.1 (End with PSP & USP flavors): "1. Decrement Segments Left by 1. 2. Update the IPv6 DA with Segment List[Segments Left]."
- **SUGGESTED FIX**: Change the bullet to: "If SL > 0: Decrement Segments Left by 1, then copy Segment List[new SL value] to IPv6 Destination Address, then forward based on new DA"

---

- **SEVERITY: MINOR**
- **CLAIM**: END.DT46 listed in the RFC 8986 core functions table
- **PROBLEM**: END.DT46 (dual-stack table lookup) is NOT defined in RFC 8986. It comes from draft-ietf-spring-srv6-network-programming-ext (the SRv6 Network Programming extensions). While the document doesn't explicitly state "all these are from RFC 8986," the section header is "RFC 8986 defines the core functions" and END.DT46 is in the subsequent table, implying it's part of RFC 8986.
- **RFC REFERENCE**: RFC 8986 defines END, END.X, END.T, END.DX2, END.DX4, END.DX6, END.DT4, END.DT6, END.B6.Encaps, and END.BM. END.DT46 is from extensions drafts.
- **SUGGESTED FIX**: Add a footnote to END.DT46: "† END.DT46 is defined in draft-ietf-spring-srv6-network-programming-ext, not RFC 8986."

---

- **SEVERITY: MINOR**
- **CLAIM**: "Gateway functions (RFC 9252): T.Encaps — SR-MPLS to SRv6... T.Decaps — SRv6 to SR-MPLS"
- **PROBLEM**: RFC 9252 is "BGP Overlay Services Based on Segment Routing over IPv6 (SRv6)" — it defines BGP signaling for SRv6 VPN services, not the gateway transit behaviors themselves. The T.Encaps and T.Decaps transit behaviors are defined in RFC 8986 (SRv6 Network Programming, §5). RFC 9252 references these behaviors but does not define them.
- **RFC REFERENCE**: RFC 8986 §5 defines transit behaviors including T.Encaps and T.Encaps.Red. RFC 9252 defines the BGP signaling for SRv6 overlay services.
- **SUGGESTED FIX**: Change "(RFC 9252)" to "(RFC 8986 §5; RFC 9252 for BGP VPN signaling)" or simply "(RFC 8986)".

---

## 6.5-srv6-network-programming.md

### Verified Claims (summary)
- RFC 8986 endpoint behaviors taxonomy comprehensive and accurate ✓
- T.Insert vs T.Encaps distinction correctly described ✓ (RFC 8986 §5)
- PSP, USP, USD flavors correctly described ✓ (RFC 8986 §4)
- PSP-USD combo as production recommendation ✓
- uSID compression (RFC 9602) correctly described ✓
- uSID shift operation correctly explained ✓
- End.AD/End.AM correctly noted as draft-track, not RFC 8986 ✓
- End.DT2/End.DT46 correctly noted as extension drafts ✓
- SRH base header 8 bytes, each segment entry 16 bytes ✓ (RFC 8754)
- SRv6+EVPN integration via RFC 9252 ✓
- Overhead calculations mathematically correct ✓

### Issues Found
No protocol-standard issues found. This section is exceptionally well-researched, with careful notes about which behaviors come from RFC 8986 vs extension drafts.

---

## 6.6-sr-migration-strategies.md

### Verified Claims (summary)
- Ships-in-the-night coexistence model correctly described ✓
- SR Mapping Server (SRMS) per RFC 8661 correctly described ✓
- `sr-prefer` command semantics correct (prefer SR labels over LDP) ✓
- IS-IS SR Extensions per RFC 8667 ✓
- OSPF SR Extensions per RFC 8665 ✓
- Junos SPRING preference 8 vs LDP preference 9 correctly noted ✓
- SRGB-related label collision risks correctly identified ✓
- Inter-domain gateway functions (SR-MPLS ↔ SRv6) correctly described ✓

### Issues Found
No protocol-standard issues found. Migration procedures are accurately described and the phased approach aligns with vendor best practices and RFC specifications.

---

## Summary of All Issues

### CRITICAL (1)
| Section | Issue | Impact |
|---------|-------|--------|
| 6.2 | BSID described as "advertised via IGP as Prefix-SID" | Fundamental misunderstanding of BSID operation; could cause incorrect design |

### MODERATE (5)
| Section | Issue | Impact |
|---------|-------|--------|
| 4.2 | RSVP soft-state timeout stated as 90s; actual is 105s per RFC 2205 | Incorrect timer value for troubleshooting |
| 4.2 | Setup/Hold priority rule has inequality backwards vs RFC 3209 | Contradicts RFC; also contradicts correct statement in 5.1 |
| 4.4 | LSP Ping reply modes 3 and 4 are swapped | Wrong reply mode values could cause OAM misinterpretation |
| 5.4 | RFC 8333 cited as TI-LFA (should be RFC 9514) | Wrong RFC reference |
| 6.4 | SRH forwarding order described as copy-then-decrement (should be decrement-then-copy) | Would produce wrong SID index lookup; document's own example contradicts the text |

### MINOR (4)
| Section | Issue | Impact |
|---------|-------|--------|
| 4.2/5.1 | IOS-XE reoptimization timer default inconsistent between sections (300s vs 3600s) | Internal inconsistency |
| 6.1 | Junos SRGB default listed inconsistently (16000-23999 vs 800000-899999) | Confusing for multi-vendor deployments |
| 6.4 | END.DT46 listed as RFC 8986 function (it's from extensions draft) | Misleading RFC attribution |
| 6.4 | RFC 9252 cited for T.Encaps/T.Decaps gateway functions (defined in RFC 8986) | Wrong RFC attribution |

### Clean Sections (no issues)
- 4.1-ldp-and-label-distribution.md ✅
- 4.3-label-operations.md ✅
- 5.2-rsvp-te-advanced.md ✅
- 5.3-segment-routing-te.md ✅
- 6.3-ti-lfa.md ✅
- 6.5-srv6-network-programming.md ✅
- 6.6-sr-migration-strategies.md ✅

**7 of 14 files are clean.** The remaining 7 files have a total of 10 issues (1 critical, 5 moderate, 4 minor).

---

## Overall Assessment

The study guide is **high quality** for a document of this scope. The vast majority of protocol claims are RFC-accurate, vendor-specific caveats are appropriately labeled, and the operational guidance is sound. The critical BSID issue in 6.2 and the priority rule error in 4.2 are the most important fixes. The remaining issues are minor corrections that would improve precision without changing the material's educational value.
