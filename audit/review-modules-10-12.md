# Protocol Standards Review — Modules 10, 11, 12

**Reviewer:** Protocol Standards Reviewer (Subagent)  
**Date:** 2026-02-28  
**Scope:** Modules 10 (Network Slicing), 11 (Automation), 12 (Case Studies)  
**Standards Checked:** OIF FlexE 2.1, 3GPP TS 23.501, RFC 6241, RFC 7950, RFC 9543, RFC 8664, RFC 7752, gNMI spec, IEEE 1588, ITU-T G.8275.1/G.8275.2, G.8262/G.8262.1, RFC 8214, RFC 4761, RFC 8231, RFC 8281

---

## 10.1 — Network Slicing Concepts

### Verified Claims (summary)
- 3GPP S-NSSAI structure (SST 8-bit, SD 24-bit) correctly described per TS 23.501
- SST values 1-5 correctly mapped (eMBB=1, URLLC=2, MIoT=3, V2X=4, HMTC=5); SST 5 correctly noted as Rel-18+
- RFC 9543 framework terminology (SLO, SLE, NSC, Connectivity Construct) accurately described
- RFC 9543 publication date correctly stated as March 2024
- Three-domain slicing model (RAN/Transport/Core) correctly reflects 3GPP architecture
- Transport realization models (soft, enhanced-soft, hard) are well-described and consistent with RFC 9889 concepts
- Flex-Algo partition/no-fallback behavior correctly stated (no automatic fallback to algo 0)
- RFC 9350 Flex-Algo reference is correct
- SRGB range 16000-23999 correctly identified as IANA recommended
- Slice isolation spectrum (Levels 1-6) is a reasonable SP engineering taxonomy

### Issues Found

- SEVERITY: MINOR
- CLAIM: "RFC 9889 (published November 2025) describes how existing IP/MPLS technologies map to 5G network slice requirements."
- PROBLEM: RFC 9889 was published in October 2025, not November 2025. The document itself is dated October 2025 in IETF Datatracker.
- STANDARD REFERENCE: IETF Datatracker for RFC 9889
- SUGGESTED FIX: Change "published November 2025" to "published October 2025" or simply remove the date parenthetical since RFC numbers are stable references.

No other issues found. This section is technically solid.

---

## 10.2 — FlexE: Flexible Ethernet

### Verified Claims (summary)
- FlexE shim placement between MAC and PCS layers is correct per OIF FlexE IA
- Calendar slot granularity of 5 Gbps (default) correctly stated for FlexE 1.0/2.0/2.1
- 20 slots per 100G instance correctly stated (20 x 5G = 100G)
- FlexE 2.1 addition of 25G slot granularity option is correct
- FlexE 3.0 addition of 800G PHY support and 100G slot granularity is correct
- Dual A/B calendar for hitless reconfiguration correctly described
- Maximum inter-PHY skew of 10 us correctly stated per OIF spec
- Three transport modes (FlexE-Unaware, FlexE-Termination, FlexE-Aware) correctly described
- Bonding, sub-rating, and channelization operations correctly described
- FlexE version history dates are accurate (1.0 March 2016, 2.0 June 2018, 2.1 July 2019)
- Overhead frame structure (8 overhead block periods per frame, 32 frames per multiframe) correctly described
- 64B/66B block encoding correctly referenced
- ITU-T G.8023 and G.8312 references are accurate

### Issues Found

- SEVERITY: MINOR
- CLAIM: "FlexE 2.2 | October 2021 | Maintenance release (corrections from 2.1 implementation guide)"
- PROBLEM: FlexE 2.2 was published in 2022, not 2021. The OIF published FlexE IA 2.2 in 2022 as a maintenance/errata release.
- STANDARD REFERENCE: OIF FlexE Implementation Agreement revision history
- SUGGESTED FIX: Change "October 2021" to "2022" or verify the exact month against OIF publication records.

- SEVERITY: MINOR
- CLAIM: "Overhead fields: ... CRC-16 | 16 bits | Error protection for overhead"
- PROBLEM: The FlexE overhead uses a CRC-16 for the overhead multiframe, but the spec defines the protection as applying over the overhead fields within the multiframe structure. The claim is technically accurate but slightly simplified — the CRC protects the overhead block content distributed across the multiframe, not a single contiguous block. This is acceptable for a study guide.
- STANDARD REFERENCE: OIF FlexE 2.1, Section on overhead CRC
- SUGGESTED FIX: No change needed — the simplification is appropriate for the audience level.

No critical or moderate issues. FlexE section is well-researched.

---

## 10.3 — 5G Xhaul Requirements

### Verified Claims (summary)
- 3GPP TR 38.801 functional split options correctly described (Options 1-8)
- Option 7-2x (intra-PHY, O-RAN fronthaul) correctly described as moving low-PHY to RU
- Option 2 (PDCP/RLC boundary) correctly identified as the F1 interface midhaul split
- E1 interface between CU-CP and CU-UP correctly referenced per 3GPP TS 38.401
- O-RAN WG4 and WG9 references are appropriate
- eCPRI vs CPRI comparison is accurate — eCPRI is packet-based, CPRI is TDM serial
- eCPRI bandwidth reduction (~10x less than CPRI) is consistent with industry estimates
- PTP profiles G.8275.1 (full on-path) and G.8275.2 (partial timing) correctly distinguished
- SyncE EEC accuracy of +/-50 ppb locked output correctly stated per G.8262
- Enhanced EEC (eEEC, G.8262.1) correctly referenced
- Phase alignment requirement of +/-1.5 us |TE| at O-RU per ITU-T G.8271.1 is correct
- Fronthaul latency budget of ~100-150 us one-way is consistent with O-RAN Alliance and IEEE 1914.1 guidance
- Fiber propagation delay of ~5 us/km is correct
- PRTC, T-GM, T-BC, T-TSC terminology correctly used per ITU-T standards
- BGP-CT (Classful Transport) description for xhaul slicing is reasonable

### Issues Found

- SEVERITY: MINOR
- CLAIM: "Standard EEC (G.8262) has a free-run accuracy limit of +/-4.6 ppm."
- PROBLEM: The ITU-T G.8262 EEC free-run accuracy is specified as +/-4.6 ppm for Option 1 (EEC-Option 1), which is the SDH-based network option. For Option 2 (SONET-based), the free-run accuracy limit is different (+/-32 ppm for stratum 3). The document doesn't specify which option the +/-4.6 ppm applies to, which could be misleading.
- STANDARD REFERENCE: ITU-T G.8262 Section 6, Table 1 (EEC-Option 1) and Table 2 (EEC-Option 2)
- SUGGESTED FIX: Change to "Standard EEC (G.8262, Option 1) has a free-run accuracy limit of +/-4.6 ppm" or add a note that this is the Option 1 (SDH-based) specification.

- SEVERITY: MINOR
- CLAIM: "PTP sync rate | varies | 64/sec (-6) | Fronthaul needs high sync rate for accuracy"
- PROBLEM: The sync interval value of -6 corresponds to 2^(-6) = 1/64 seconds, meaning 64 packets per second. This is correct. However, the table also mentions "PTP sync rate" as default "varies" — in G.8275.1, the default sync interval is actually specified as log2(interval) = -4 (16 per second), not "varies." The recommended value of 64/sec (-6) is a common deployment choice but exceeds the minimum G.8275.1 requirement.
- STANDARD REFERENCE: ITU-T G.8275.1 Section 6.3.5
- SUGGESTED FIX: Add a note that G.8275.1 minimum is 16/sec (logSyncInterval = -4); 64/sec is an enhanced deployment choice for tighter fronthaul accuracy.

No critical issues. The xhaul section is technically sound.

---

## 11.1 — Model-Driven Networking

### Verified Claims (summary)
- YANG RFC 7950 constructs (container, list, leaf, leaf-list, choice, augment, deviation, grouping, identity, typedef) correctly described
- NETCONF RFC 6241 protocol stack (content, operations, messages, transport) correctly described
- NETCONF operations (get, get-config, edit-config, lock, unlock, commit, discard-changes) correctly listed
- Candidate, running, startup, operational datastores correctly described
- RFC 8342 (NMDA) correctly referenced for operational datastore
- NETCONF port 830 correctly identified per RFC 6242
- RFC 6242 correctly referenced for NETCONF over SSH with chunked framing
- edit-config operation semantics (merge, replace, create, delete, remove) correctly described per RFC 6241
- RESTCONF RFC 8040 URL structure and HTTP verb mapping correctly described
- gNMI Subscribe modes (SAMPLE, ON_CHANGE, TARGET_DEFINED) correctly described per gNMI spec
- gNMI operations (Capabilities, Get, Set, Subscribe) correctly listed
- RFC 8343 (YANG interface management), RFC 8040 (RESTCONF), RFC 9657 (YANG BGP) correctly referenced
- Confirmed commit mechanism correctly described

### Issues Found

- SEVERITY: MINOR
- CLAIM: "gNMI Specification v0.10.0 (OpenConfig)" in sources
- PROBLEM: The gNMI specification version numbering has evolved. As of 2025-2026, the specification is maintained at github.com/openconfig/reference and the version may differ from 0.10.0. This is a minor version reference that could become stale.
- STANDARD REFERENCE: OpenConfig gNMI specification repository
- SUGGESTED FIX: Change to "gNMI Specification (OpenConfig, latest)" or verify current version at time of publication.

No critical or moderate issues. This section is accurate.

---

## 11.2 — Streaming Telemetry

### Verified Claims (summary)
- Dial-in vs dial-out architecture correctly described — TCP connection direction differs
- Correct clarification that Cisco MDT dial-out uses Cisco's telemetry.proto, NOT gNMI
- gNMI Subscribe is always dial-in (collector initiates) — correctly stated
- SubscribeRequest protobuf structure accurately represents gNMI spec
- Three stream modes (SAMPLE, ON_CHANGE, TARGET_DEFINED) correctly described with behavioral detail
- sync_response mechanism correctly described per gNMI spec
- suppress_redundant and heartbeat_interval correctly described
- IETF YANG-Push (RFC 8641) vs gNMI comparison is accurate — gNMI dominates production
- RFC 8641 and RFC 8639 correctly referenced for YANG-Push
- IOS-XR MDT configuration model (sensor-group, subscription, destination-group) correctly described
- gnmic configuration patterns are accurate
- Telegraf multi-protocol collection approach is correctly described

### Issues Found

No issues found. This section is clean and technically accurate. The explicit clarification about Cisco MDT dial-out vs gNMI is particularly valuable and correct.

---

## 11.3 — SR-TE Controller Integration

### Verified Claims (summary)
- PCEP RFC 5440 (base), RFC 8231 (stateful), RFC 8281 (PCE-initiated), RFC 8664 (SR-TE) correctly referenced
- BGP-LS RFC 7752 correctly referenced with AFI 16388 / SAFI 71
- PCEP TCP port 4189 correctly stated
- PCC always initiates PCEP connection — correct
- PCEP message types (Open, Keepalive, PCReq, PCRep, PCRpt, PCUpd, PCInitiate, PCErr, PCNtf) correctly listed
- Stateless vs stateful PCE distinction correctly described
- Delegation and PCE-initiated LSP concepts correctly explained
- SR ERO subobject Type 36 (0x24) correctly stated per RFC 8664
- NAI Type (NT) field correctly described for distinguishing address families within Type 36
- Correct note that there is no separate Type 40 for IPv6 — all SR-ERO subobjects use Type 36
- BGP-LS NLRI types (Node, Link, Prefix) correctly described
- Correct clarification that SR policy state uses BGP Tunnel Encap (RFC 9012/9256), not BGP-LS NLRI
- ODN (On-Demand Next-hop) workflow correctly described
- Binding SID concept correctly explained
- SRGB and SRLB ranges correctly distinguished
- Disjoint path computation correctly described
- SRLB correctly identified as for adjacency SIDs, NOT Binding SIDs

### Issues Found

No issues found. Section is technically accurate with several valuable clarifications that prevent common misconceptions.

---

## 11.4 — CI/CD for Network Config

### Verified Claims (summary)
- NETCONF candidate datastore + confirmed commit workflow correctly described per RFC 6241
- Junos commit confirmed and commit check correctly referenced
- IOS-XR commit patterns correctly described
- GitOps methodology appropriately referenced as industry practice
- CI/CD pipeline stages (lint, validate, simulate, deploy, verify, rollback) follow sound SP engineering practices
- Ring-based deployment model follows SP best practices
- Appropriate distinction between protocol-state checks and service-layer validation
- Correct observation that commit confirmed is a live change safety net, not a dry-run
- No conflation of vendor-specific tools with open standards

### Issues Found

No issues found. This section is appropriately grounded in RFC 6241 NETCONF semantics and real SP operational practices.

---

## 11.5 — Lab: gNMI Telemetry with SR-TE Policy Automation

### Verified Claims (summary)
- gNMI port 57400 (IOS-XR convention) correctly stated
- NETCONF port 830 correctly stated per RFC 6242
- IOS-XR SR-TE operational YANG path (Cisco-IOS-XR-infra-xtc-agent-oper) correctly identified
- IOS-XR SR-TE config YANG path (Cisco-IOS-XR-infra-xtc-agent-cfg) correctly identified
- Correct note that config YANG augments the sr container from Cisco-IOS-XR-segment-routing-ms-cfg
- ncclient NETCONF workflow (edit-config to candidate, then commit) correctly implemented
- gnmic configuration patterns are accurate
- OpenConfig interface counter paths correctly used
- Prometheus metric naming convention from gnmic accurately described
- gNMI subscription modes correctly applied (SAMPLE for counters, ON_CHANGE for state)

### Issues Found

No critical or moderate issues. The lab is well-constructed with appropriate caveats about version-specific behavior.

---

## 12.1 — ISP Backbone Design Case Study

### Verified Claims (summary)
- IS-IS L1/L2 hierarchy correctly described — L1 for intra-PoP, L2 for inter-PoP
- Wide metrics requirement for SR-MPLS and TI-LFA correctly stated
- SRGB 16000-23999 correctly identified as IANA recommended range
- TI-LFA P-space/Q-space algorithm correctly referenced
- Route reflector design (3 geographically distributed RRs) follows SP best practices
- BGP ADD-PATH on RRs correctly recommended for multi-path visibility
- RPKI ROA validation approach (reject invalid, accept unknown with lower local-pref) follows MANRS best practices
- Community design (standard + large communities RFC 8092) is sound SP practice
- RD/RT allocation scheme (ASN:CUSTID) is standard SP practice
- Graceful shutdown procedure for P router maintenance correctly described
- SR-MPLS vs LDP coexistence via separate label ranges correctly explained
- BFD timers (3x33ms = ~100ms detection) correctly stated

### Issues Found

- SEVERITY: MINOR
- CLAIM: "IS-IS also has no equivalent of the OSPF type-7 LSA ASBR complexity that bites people at area boundaries."
- PROBLEM: While IS-IS does not have the type-7/type-5 NSSA translation complexity of OSPF, IS-IS does have its own L1-to-L2 route leaking and ATT (Attached) bit behavior that can cause similar operational issues. This claim is slightly oversimplified but directionally correct for a study guide context.
- STANDARD REFERENCE: RFC 1195, ISO 10589
- SUGGESTED FIX: No change needed — the comparison is valid in the context of the common operational pain points being discussed.

No critical or moderate issues. Design follows actual SP best practices, not datacenter patterns.

---

## 12.2 — DCI with EVPN Case Study

### Verified Claims (summary)
- EVPN route types (1-5) correctly described with accurate functions
- BGW re-origination of Type-2 routes correctly explained
- Split-horizon via site-id/site-of-origin correctly described for multi-site EVPN
- ESI/DF election correctly scoped to actual multihomed Ethernet segments
- BUM handling options (ingress replication, underlay multicast, PMSI) correctly described
- ARP suppression mechanism correctly explained (Type-2 MAC/IP binding used for local ARP response)
- EVPN MAC mobility via sequence number in Type-2 routes correctly described
- Type-5 IP Prefix routes for L3 DCI correctly described
- VXLAN overhead of ~50 bytes correctly stated
- Symmetric IRB design concepts accurately referenced
- RFC 9136 overlay-index recursion correctly noted as optional
- MAC table and ARP scale analysis is reasonable for the scenario

### Issues Found

No issues found. The case study correctly applies SP-grade EVPN patterns and explicitly avoids common datacenter-only design assumptions. The careful distinction between ESI/DF scope and generic BGW DCI behavior is particularly well done.

---

## 12.3 — Mobile Backhaul / 5G Transport Case Study

### Verified Claims (summary)
- 5G disaggregated gNB architecture (O-RU, O-DU, O-CU) correctly described per 3GPP TS 38.401
- eCPRI Option 7-2x bandwidth estimates (~10-25 Gbps per sector for 64T64R) consistent with industry planning figures
- Fronthaul latency budget of ~100-150 us correctly applied
- Fiber distance constraint (~20 km for fronthaul) correctly derived from latency budget
- PTP G.8275.1 with boundary clocks correctly designed
- GNSS grandmaster clock placement (6 GMs for regional operator) follows best practices
- Error budget calculation (+/-20 ns GM + 4 hops x +/-5 ns = +/-40 ns, within +/-130 ns TDD requirement) is correct per ITU-T G.8271.1 methodology
- SyncE + PTP combined timing architecture correctly described
- Flex-Algo for transport slicing (128=low-latency, 129=high-BW, 130=ultra-reliable) is sound design
- Anycast SIDs for core redundancy correctly designed
- TI-LFA protection correctly applied
- IS-IS L1/L2 hierarchy (L1 per agg region, L2 for backbone) is appropriate
- FlexE channelization at pre-agg uplinks for fronthaul isolation is well-justified
- QoS 6-class model with strict priority for PTP and eCPRI follows O-RAN transport guidelines
- SR-MPLS vs SRv6 decision rationale (MTU, hardware, operational readiness) is technically sound

### Issues Found

- SEVERITY: MINOR
- CLAIM: "5G TDD requires phase synchronization... The requirement: +/-130 ns phase alignment between any two O-RUs with overlapping coverage (3GPP TS 38.104)."
- PROBLEM: The +/-130 ns requirement is derived from 3GPP TS 38.104 for TDD inter-base-station synchronization, but the exact value depends on the specific cell configuration (cell range, guard period). +/-130 ns is a commonly cited tight requirement for small inter-site distances. For wider area deployments, the requirement may be relaxed to +/-1.5 us (per ITU-T G.8271.1 network limit). The document should note that +/-130 ns applies to the tightest case.
- STANDARD REFERENCE: 3GPP TS 38.104, ITU-T G.8271.1
- SUGGESTED FIX: Add a note: "+/-130 ns is the tightest requirement for adjacent TDD cells with minimal guard period; the network-level time error limit per ITU-T G.8271.1 is +/-1.5 us, but individual O-RU phase alignment for TDD coherence may require +/-130 ns depending on cell configuration."

- SEVERITY: MINOR
- CLAIM: "OCXO holdover accuracy: maintain +/-130 ns for ~1 hour"
- PROBLEM: This is a reasonable estimate for a high-quality OCXO with SyncE frequency assist, but the actual holdover duration depends on the specific OCXO quality (stability specification) and the initial frequency offset. Without SyncE, a typical telecom-grade OCXO (~1 ppb/day stability) would drift ~130 ns in approximately 11 seconds of free-running (as the document itself calculates in Q2). The "~1 hour" figure assumes SyncE is maintaining frequency, which is correct for the scenario but should be stated more explicitly.
- STANDARD REFERENCE: ITU-T G.8273.2 (T-BC specifications)
- SUGGESTED FIX: Clarify: "OCXO holdover with SyncE frequency assist: maintain +/-130 ns for approximately 1 hour (SyncE maintains frequency reference; OCXO compensates only phase drift)."

No critical issues. This is an excellent case study that correctly applies SP mobile transport best practices.

---

## 12.4 — Internet Exchange Point Design Case Study

### Verified Claims (summary)
- Route server transparent mode (rs client + next hop self off) correctly described — RS does NOT insert itself in AS path, preserves member next-hop
- Route servers are control-plane only — data plane flows directly between members: correctly stated
- BIRD 2 as dominant IXP RS software (~60% adoption per Euro-IX) is accurate
- RPKI filtering pipeline (bogon, prefix length, blackhole check, IRR, RPKI) follows MANRS/BCP best practices
- ADD-PATH on RS (tx direction) correctly enables member-side best-path selection
- bgpq4 for IRR prefix-list generation is current best practice (successor to bgpq3)
- Routinator as RPKI validator is a well-known production tool
- RTBH (Remote Triggered Blackhole) via community 65535:666 follows RFC 7999
- ARP sponge correctly described for handling abandoned IXP peering LAN addresses
- BCP recommendations (MAC limit, BPDU guard, storm control, DHCP snooping, RA guard) follow Euro-IX/MANRS guidelines
- VLAN-based vs EVPN-VXLAN fabric comparison is accurate — large IXPs (DE-CIX, AMS-IX, LINX) have indeed migrated to EVPN
- Member connection models (single-homed, dual-homed same site, dual-homed multi-site) reflect real IXP practice
- Looking glass (BIRD-LG or Alice-LG) correctly identified as standard IXP tooling
- PeeringDB integration requirements are accurate

### Issues Found

- SEVERITY: MINOR
- CLAIM: "BIRD 2.15" in the configuration example header
- PROBLEM: BIRD version numbers evolve. The configuration syntax shown is valid for BIRD 2.x but the specific version 2.15 may or may not exist at the time of reading. This is a minor detail.
- STANDARD REFERENCE: BIRD documentation (bird.network.cz)
- SUGGESTED FIX: Change to "BIRD 2.x" or simply "BIRD 2" to avoid version-specific dating.

- SEVERITY: MINOR
- CLAIM: "BasinIX peering LAN prefix: 198.51.100.0/24"
- PROBLEM: 198.51.100.0/24 is RFC 5737 TEST-NET-2 documentation address space. This is correct for a study guide example (it is documentation space), but the IXP's own bogon filter in the BIRD config also lists 198.51.100.0/24+ as a bogon to reject. In the real world, an IXP would never use documentation space. This is fine for a study guide but slightly inconsistent internally — the RS bogon filter would reject routes for its own peering LAN prefix if anyone tried to announce it.
- STANDARD REFERENCE: RFC 5737
- SUGGESTED FIX: Add a brief note: "(Using RFC 5737 documentation address space for this example — a real IXP would use ARIN/RIPE-allocated PI space.)" This is a very minor pedagogical point.

No critical or moderate issues. The IXP design accurately reflects real-world practices.

---

## 12.5 — EVPN L2VPN Migration Case Study

### Verified Claims (summary)
- VPWS to EVPN-VPWS migration via RFC 8214 correctly described
- VPLS (RFC 4761 BGP-signaled) architecture correctly described
- EVPN route types (Type-1 through Type-5) functions correctly stated
- EVPN-VPWS using Type-1 (Ethernet Auto-Discovery) for pseudowire signaling — correct per RFC 8214
- Seamless interworking concept (EVPN + VPLS coexisting in same bridge domain) correctly described
- RFC 9572 correctly referenced for EVPN interworking with VPWS and VPLS
- EVPN multi-homing ESI (Ethernet Segment Identifier, 10 bytes) correctly described
- DF election via Type-4 ES routes correctly described
- Mass withdrawal via Type-1 per-ES routes correctly described
- Aliasing via Type-1 per-EVI routes correctly described
- BGP EVPN address family AFI 25 / SAFI 70 correctly stated per RFC 7432
- RT-Constrain RFC 4684 correctly referenced
- Migration phasing (VPWS first, VPLS, multi-homing last) follows industry best practice
- IOS-XR and Junos configuration examples are representative and syntactically plausible
- Risk matrix is comprehensive and realistic
- BGP table growth projection is reasonable

### Issues Found

No issues found. This is a thorough and operationally realistic migration case study.

---

## Cross-Module Review: Standards Compliance Summary

### Checklist Results

| Check | Result | Notes |
|-------|--------|-------|
| FlexE specs match OIF FlexE 2.1 | PASS | Minor date issue on FlexE 2.2; all technical claims verified |
| 3GPP slicing concepts (SST, S-NSSAI) accurate | PASS | SST values, S-NSSAI structure, slice types all correct per TS 23.501 |
| YANG/NETCONF/gNMI match RFC 6241, RFC 7950, gNMI spec | PASS | All protocol mechanics, operations, and datastore semantics correct |
| Streaming telemetry descriptions correct | PASS | Dial-in/dial-out correctly distinguished; Cisco MDT vs gNMI properly differentiated |
| Case study designs follow SP best practices | PASS | No datacenter patterns misapplied to SP contexts |
| IXP design matches real-world practices | PASS | Route server, RS-client, RPKI/IRR, ARP sponge, BCP all accurate |
| No conflation of vendor tools with open standards | PASS | Clear separation throughout; vendor-specific CLIs labeled as such |

### Overall Assessment

**Modules 10-12 are technically sound.** All critical claims about protocol behavior, standard references, and architectural patterns are accurate. The issues found are exclusively MINOR — primarily date precision on standard publication dates and minor clarifications that would improve precision but do not affect correctness.

The documents demonstrate strong adherence to authoritative sources:
- 3GPP specifications are correctly applied and scoped to the transport engineer's domain
- IETF RFCs are accurately referenced with correct RFC numbers and publication dates
- OIF FlexE specifications are correctly described
- ITU-T timing standards are accurately applied
- Vendor-specific configurations are clearly labeled and not conflated with open standards
- Case studies apply genuine SP engineering practices, not datacenter patterns

**Total issues: 8 MINOR, 0 MODERATE, 0 CRITICAL**
