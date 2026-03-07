# RFC Standards Review — Modules 7 & 8 (L3VPN, L2VPN & EVPN)

**Reviewer:** Protocol Standards Subagent  
**Date:** 2026-02-28  
**Scope:** 10 files across Modules 7 (L3VPN) and 8 (L2VPN/EVPN)  
**Key RFCs checked:** RFC 4364, RFC 4659, RFC 4684, RFC 4577, RFC 7432, RFC 8365, RFC 9135, RFC 9136, RFC 4761, RFC 4762, RFC 8584, RFC 4447, RFC 4448, RFC 4760, RFC 4360, RFC 7911, RFC 9107, RFC 9014, RFC 9494, RFC 8277, RFC 6514, RFC 9012

---

## Overall Assessment

**Verdict: High quality. 2 moderate issues, 3 minor issues across ~3,000 lines of technical content.**

The modules demonstrate deep, accurate understanding of the protocol standards. The vast majority of RFC references, AFI/SAFI values, route type formats, NLRI encodings, extended community types, and procedural descriptions are correct. Vendor-specific behavior is generally well-labeled and not conflated with protocol standards. The few issues found are internal inconsistencies and minor reference inaccuracies — no critical misrepresentations of protocol behavior.

---

## 7.1 — L3VPN Architecture

### Verified Claims (summary)
- RFC 4364 as the base L3VPN spec (formerly RFC 2547bis) ✓
- VPNv4: AFI 1, SAFI 128; VPNv6: AFI 2, SAFI 128 ✓
- RD is 64-bit, creating 96-bit VPNv4 NLRI ✓
- RD format types: Type 0 (2-byte ASN:4-byte nn), Type 1 (4-byte IP:2-byte nn), Type 2 (4-byte ASN:2-byte nn) — correct per RFC 4364 §4.2 ✓
- RT as BGP Extended Communities (64-bit, RFC 4360) ✓
- Two-label stack model (transport + VPN) ✓
- RT-Constraint: AFI 1, SAFI 132 per RFC 4684 ✓
- SOO prevents re-advertisement to CE interfaces sharing the same SOO — correct per RFC 4364 §7 ✓
- RD has zero influence on route import/export — correct, RD is for uniqueness only ✓
- Per-VRF unique RD recommendation to avoid RR best-path path-hiding — correct design rationale ✓
- MP-BGP (RFC 4760) carries VPN routes ✓
- RR does not need VRF configuration; reflects VPNv4 routes without importing ✓

### Issues Found

- SEVERITY: MODERATE
- CLAIM: "IOS-XR default: **per-CE** allocation."
- PROBLEM: This contradicts sections 7.2 and 7.5, which both correctly state IOS-XR defaults to **per-prefix** label allocation. The actual IOS-XR default `label mode` under VRF address-family is per-prefix. Per-CE is a configurable option, not the default.
- RFC REFERENCE: Not an RFC issue — this is a vendor-specific factual error and an internal inconsistency within the guide.
- SUGGESTED FIX: Change to: "IOS-XR default: **per-prefix** allocation (each VPN route gets its own label). Configurable to per-CE or per-VRF."

---

- SEVERITY: MODERATE
- CLAIM: "Junos default without `vrf-table-label`: **per-prefix** (each VPN route gets its own label)."
- PROBLEM: This contradicts section 7.2, which correctly states the Junos default (without `vrf-table-label`) is **per-next-hop** — one label per protocol next-hop in the VRF. Routes sharing the same CE next-hop share a label. This is explicitly distinguished from per-prefix in 7.2: "This is often conflated with per-prefix, but it's not — if 500 routes all have the same CE next-hop, they share one label."
- RFC REFERENCE: Not an RFC issue — vendor-specific factual error and internal inconsistency.
- SUGGESTED FIX: Change to: "Junos default without `vrf-table-label`: **per-next-hop** (one label per protocol next-hop in the VRF — routes sharing the same CE next-hop share one label). Adding `vrf-table-label` switches Junos to **per-VRF** allocation."

---

## 7.2 — MP-BGP for VPNv4/VPNv6

### Verified Claims (summary)
- VPNv4 NLRI encoding: label(3 bytes) + RD(8 bytes) + prefix(variable) — correct per RFC 4364 §4.3.4 ✓
- Next-hop encoding: 12 bytes for VPNv4 (8-byte RD of zeros + 4-byte IPv4) — correct per RFC 4364 §4.3.4 ✓
- VPNv6 next-hop: 24 bytes (8-byte RD of zeros + 16-byte IPv6) — correct per RFC 4659 §3.2.1 ✓
- Label is encoded IN the NLRI, not a separate attribute ✓
- Extended communities are 8 bytes (RFC 4360), transitive by default ✓
- RT-Constraint uses AFI 1, SAFI 132 per RFC 4684 ✓
- 6VPE (RFC 4659) carries IPv6 VPN routes over IPv4 MPLS core via IPv4-mapped-IPv6 next-hop ✓
- RFC 8950 for next-hop encoding when BGP session runs over IPv6 ✓
- ADD-PATH: RFC 7911 ✓
- ORR: RFC 9107 ✓
- LLGR: RFC 9494 ✓
- BGP bestpath selection order correctly described ✓
- Per-prefix as IOS-XR default label allocation — correct (consistent with vendor documentation) ✓
- Per-next-hop as Junos default (without vrf-table-label) — correct ✓
- VPNv4 Multicast SAFI 129 noted as rarely used, with modern MVPN using AFI 1/SAFI 5 per RFC 6514 ✓
- Junos resolves VPN next-hops in inet.3 (MPLS-eligible routes only) ✓

### Issues Found

No issues. This section is technically clean.

---

## 7.3 — Inter-AS L3VPN

### Verified Claims (summary)
- RFC 4364 Section 10 defines three options (10a, 10b, 10c) ✓
- Option A: back-to-back VRF, per-VRF eBGP sessions, traffic decapsulated/re-encapsulated at ASBR — correct per RFC 4364 §10a ✓
- Option B: eBGP VPNv4 at ASBR, next-hop-self mandatory, ASBR allocates new VPN labels — correct per RFC 4364 §10b ✓
- Option C: multihop eBGP VPNv4 between RRs + eBGP labeled-unicast between ASBRs, 3-label stack (transport + stitching + VPN) — correct per RFC 4364 §10c ✓
- `next-hop-self` must NOT be set on the inter-AS VPNv4 multihop session in Option C — correct ✓
- `retain route-target all` needed on Option B ASBRs (IOS-XR-specific but correctly labeled) ✓
- RFC 8277 for labeled-unicast ✓
- RFC 5082 for GTSM ✓
- Labeled-unicast routes install into inet.3 on Junos by default — correct ✓

### Issues Found

- SEVERITY: MINOR
- CLAIM: "RFC 9012 (BGP-CT) and related drafts introduce a transport-class concept..."
- PROBLEM: RFC 9012 is titled "The BGP Tunnel Encapsulation Attribute" — it defines the tunnel encapsulation attribute, which is a building block used by BGP Classful Transport (BGP-CT). BGP-CT itself is defined in separate IETF drafts (draft-ietf-idr-bgp-ct). The parenthetical "(BGP-CT)" incorrectly implies RFC 9012 *is* BGP-CT.
- RFC REFERENCE: RFC 9012 abstract: "This document defines a BGP path attribute known as the Tunnel Encapsulation attribute..."
- SUGGESTED FIX: Change to: "BGP Classful Transport (BGP-CT, draft-ietf-idr-bgp-ct), building on the Tunnel Encapsulation attribute defined in RFC 9012, introduces a transport-class concept..."

---

## 7.4 — Extranet & Shared Services

### Verified Claims (summary)
- RT import/export as the mechanism for extranet — correct per RFC 4364 ✓
- Hub-and-spoke RT model for shared services — correct standard practice ✓
- Prevention of transitive route leaking via export policy — correctly described ✓
- `retain route-target all` needed on RR for extranet/shared-services routes — correct for IOS-XR; Junos noted as retaining all by default when acting as RR ✓
- RFC 4684 for RT-Constraint interaction with extranet ✓
- RFC 4577 reference for OSPF as PE-CE — correct ✓
- Route leaking loop prevention mechanisms (SOO, export policy filtering, RT rewrite) ✓
- Asymmetric extranet requires stateful device for return path — correctly identified ✓

### Issues Found

No issues. This section is technically clean.

---

## 7.5 — L3VPN Scale & Convergence

### Verified Claims (summary)
- BGP PIC concept (O(1) next-hop group pointer update vs O(n) per-prefix update) — correctly described ✓
- ADD-PATH (RFC 7911) enables PIC by providing backup paths ✓
- RD-per-PE as alternative to ADD-PATH for path diversity — correct ✓
- BGP Graceful Restart: RFC 4724 ✓
- Long-Lived GR: RFC 9494 ✓
- ORR: RFC 9107 ✓
- RT-Constraint: RFC 4684 ✓
- BGP hold timer defaults: 180s IOS-XR (3x60s keepalive), 90s Junos (3x30s keepalive) ✓
- NSR vs GR comparison — correctly described ✓
- Best-External for advertising backup CE paths ✓
- FIB programming as convergence bottleneck — correctly identified ✓
- Per-VRF label allocation as scale winner (single label per VRF, additional IP lookup on egress PE) ✓

### Issues Found

No issues. This section is technically clean.

---

## 8.1 — Legacy L2VPN: VPWS, VPLS, and H-VPLS

### Verified Claims (summary)
- RFC 4447 for PW signaling via LDP (targeted LDP) ✓
- RFC 4448 for Ethernet over MPLS encapsulation ✓
- RFC 4761 = BGP-signaled VPLS (Kompella); RFC 4762 = LDP-signaled VPLS (Lasserre) — correctly attributed ✓
- RFC 6624 for BGP-signaled VPWS ✓
- RFC 8214 for EVPN-VPWS (modern replacement) ✓
- RFC 8469 makes control word mandatory for Ethernet PWs ✓
- PW signaling: FEC TLV Type 128 (PWid FEC) and Type 129 (Generalized PW FEC) — correct per RFC 4447 ✓
- L2VPN address family: AFI 25, SAFI 65 — correct per RFC 4761 ✓
- Two-label stack (transport + VC label) for pseudowires ✓
- VPLS split-horizon: frames from PW never forwarded to another PW in same SHG ✓
- Full-mesh PW count: N*(N-1)/2 for VPLS with N PEs ✓
- BGP-signaled VPLS uses VE ID + label block with base label + offset mechanism — correct per RFC 4761 §3.2.2 ✓
- H-VPLS described per RFC 4762 §10 ✓
- Control word purpose (prevent ECMP polarization) — correctly explained ✓
- Clarification that "Martini" name properly belongs to RFC 4447 PW signaling, not VPLS itself ✓

### Issues Found

No issues. This section is technically clean.

---

## 8.2 — EVPN Fundamentals

### Verified Claims (summary)
- RFC 7432 as base EVPN spec; AFI 25, SAFI 70 ✓
- Route Type 1 (EAD): per-ES (ETI=0) for mass withdrawal, per-EVI (ETI=EVI tag) for aliasing — correct per RFC 7432 §7.1 ✓
- Route Type 2 (MAC/IP): NLRI format with RD + ESI + ETI + MAC + IP + Labels — correct per RFC 7432 §7.2 ✓
- Route Type 3 (IMET): NLRI with RD + ETI + Originating Router IP — correct per RFC 7432 §7.3 ✓
- Route Type 4 (ES): NLRI with RD + ESI + Originating Router IP — correct per RFC 7432 §7.4 ✓
- Route Type 5 (IP Prefix): NLRI per RFC 9136 ✓
- PMSI Tunnel Types: Ingress Replication=6, P2MP mLDP=2, P2MP RSVP-TE=1 — correct per RFC 6514 §5 ✓
- DF election: default mod-based per RFC 7432 §8.5; HRW and preference-based per RFC 8584 ✓
- Extended communities: MAC Mobility (0x06, 0x00), ESI Label (0x06, 0x01), ES-Import (0x06, 0x02) — correct per RFC 7432 §§7.5-7.7 ✓
- Default Gateway extended community: 0x03, 0x0D (Opaque type, not EVPN type) — correctly identified ✓
- EVPN Layer 2 Attributes: 0x06, 0x04 ✓
- BGP-learned MACs do not age; removed only on route withdrawal — correct per RFC 7432 ✓
- MAC Mobility sequence number: higher sequence wins; sticky bit for static MACs ✓
- ARP/ND suppression via proxy ARP from Type-2 MAC+IP cache ✓
- Service types: VLAN-based, VLAN-bundle, VLAN-aware bundle — correctly described ✓

### Issues Found

- SEVERITY: MINOR
- CLAIM: "3 bytes but only 20 bits are the label (standard MPLS encoding — top 20 bits label, bottom 4 bits flags/TC/S/TTL packed per RFC 3032)."
- PROBLEM: The 3-byte MPLS label field in BGP NLRI encoding does NOT contain TTL. The 3-byte field contains: 20-bit label value + 3-bit TC (Traffic Class, formerly EXP) + 1-bit S (Bottom-of-Stack). TTL only appears in the full 4-byte MPLS shim header on the wire (20-bit label + 3-bit TC + 1-bit S + 8-bit TTL = 32 bits). The parenthetical incorrectly includes TTL in the 3-byte encoding.
- RFC REFERENCE: RFC 3032 §2.1 defines the full 4-byte shim header; the 3-byte label encoding in BGP NLRI (per RFC 3107/RFC 8277) omits the TTL octet.
- SUGGESTED FIX: Change to: "*3 bytes but only 20 bits are the label (standard MPLS label encoding — top 20 bits label, bottom 4 bits: 3-bit TC + 1-bit S (bottom-of-stack), per RFC 3032/RFC 8277 label encoding).*"

---

## 8.3 — EVPN-MPLS vs EVPN-VXLAN

### Verified Claims (summary)
- RFC 7432 for EVPN-MPLS; RFC 8365 for EVPN-VXLAN overlay framework ✓
- RFC 7348 for VXLAN data plane spec ✓
- VXLAN overhead: 36 bytes L3 (20 IP + 8 UDP + 8 VXLAN), 50 bytes on wire (+ 14 outer Ethernet) — correctly calculated ✓
- UDP port 4789 (IANA standard per RFC 7348); Linux historically used 8472 — correct ✓
- 24-bit VNI (~16M segments), globally significant vs. 20-bit MPLS label, locally significant ✓
- RFC 6790 for entropy labels; RFC 6391 for FAT pseudowires ✓
- BGP Encapsulation Extended Community (RFC 8365 §5.1) distinguishes MPLS vs VXLAN ✓
- Symmetric vs asymmetric IRB models — correctly described ✓
- DCI gateway architecture with re-encapsulation between MPLS and VXLAN ✓
- Two-EVI-in-one-bridge-domain stitching pattern for DCI gateways ✓

### Issues Found

No issues. This section is technically clean.

---

## 8.4 — EVPN Multi-Homing

### Verified Claims (summary)
- ESI: 10-byte identifier, Types 0-5 — correct per RFC 7432 §5 ✓
- ESI 0 = single-homed; all-zeros = no MH procedures — correct ✓
- DF election via RT-4 (ES Route) exchange — correct per RFC 7432 §8.5 ✓
- Mod-based DF election (RFC 7432): VLAN mod N with PEs sorted by IP — correct ✓
- HRW and preference-based algorithms: RFC 8584 — confirmed (RFC 8584 §3 defines Type 2: HRW, Type 3: Preference-based) ✓
- All-active: both PEs forward unicast; only DF forwards BUM toward CE — correct per RFC 7432 §8.1.1 ✓
- Single-active: one PE forwards all traffic; CE doesn't need LACP — correct per RFC 7432 §8.1.2 ✓
- Aliasing via per-EVI EAD (RT-1): enables ECMP at remote PEs across all PEs in ES — correct per RFC 7432 §8.1.1 ✓
- Mass withdrawal via per-ES EAD (RT-1) withdrawal: one BGP UPDATE fails over all MACs — correct per RFC 7432 §8.2 ✓
- Split-horizon via ESI label in MPLS data plane — correct per RFC 7432 §8.3 ✓
- MAC synchronization via RT-2 with ESI field populated — correctly described ✓
- DF election only controls BUM toward CE; unicast flows through all PEs — correctly emphasized ✓
- VLAN-bundle service (ETI=0) results in single DF for entire ES — correct per RFC 7432 §8.5 ✓
- ES-Import RT auto-derived from ESI bytes 1-6 ✓

### Issues Found

- SEVERITY: MINOR
- CLAIM: Quick Reference lists "RFC 8214 — Virtual Subnet: EVPN A-D Route Usage (aliasing details)"
- PROBLEM: RFC 8214 is titled "Virtual Private Wire Service Support in Ethernet VPN (EVPN)" — it defines EVPN-VPWS (point-to-point), not aliasing. The title "Virtual Subnet" is incorrect, and the description "(aliasing details)" is misleading. EVPN aliasing is defined in RFC 7432 §8.1.1.
- RFC REFERENCE: RFC 8214 abstract: "This document describes how Ethernet VPN (EVPN) can be used to support the Virtual Private Wire Service (VPWS)..."
- SUGGESTED FIX: Change to: "RFC 8214 — Virtual Private Wire Service Support in EVPN (EVPN-VPWS)" and remove the aliasing attribution. For aliasing reference, cite RFC 7432 §8.1.1 directly.

---

## 8.5 — EVPN for Data Center Interconnect (DCI)

### Verified Claims (summary)
- RFC 9014 for EVPN Multi-Site interconnect ✓
- RFC 9136 for Type-5 IP prefix advertisement ✓
- MAC Mobility sequence numbers: higher sequence wins — correct per RFC 7432 §15 ✓
- Equal sequence tiebreaker: PE with numerically higher IP wins — correct per RFC 7432 §15.1 ✓
- Site-of-Origin (SoO) extended community for DCI loop prevention — correct per RFC 7432 §15.1 ✓
- Route re-origination at BGW with next-hop-self, new labels, potentially different RTs ✓
- Distributed anycast gateway with same virtual IP/MAC at every site ✓
- ARP suppression at BGW from RT-2 MAC+IP cache ✓
- Type-5 summarization reducing DCI control plane (aggregating host RT-2 routes into prefix RT-5 routes) ✓
- Three DCI topology models (unified, gateway/multi-domain, multi-site RFC 9014) — correctly categorized ✓
- BUM handling options: ingress replication, multicast underlay (P-tunnel via PMSI attribute in RT-3) ✓

### Issues Found

No issues. This section is technically clean.

---

## Summary of All Issues

| # | File | Severity | Issue |
|---|------|----------|-------|
| 1 | 7.1 | **MODERATE** | IOS-XR default label allocation stated as "per-CE" — should be "per-prefix" (contradicts 7.2 and 7.5) |
| 2 | 7.1 | **MODERATE** | Junos default label allocation (without vrf-table-label) stated as "per-prefix" — should be "per-next-hop" (contradicts 7.2) |
| 3 | 7.3 | **MINOR** | RFC 9012 labeled as "(BGP-CT)" — RFC 9012 is the Tunnel Encapsulation Attribute, not BGP-CT itself |
| 4 | 8.2 | **MINOR** | MPLS label NLRI encoding parenthetical incorrectly includes "TTL" — TTL is only in the full 4-byte shim header, not the 3-byte NLRI label field |
| 5 | 8.4 | **MINOR** | RFC 8214 cited with wrong title ("Virtual Subnet") and wrong topic ("aliasing details") — it is actually "EVPN-VPWS" |

**Critical issues: 0**  
**Moderate issues: 2** (both in 7.1, internal inconsistencies with label allocation defaults)  
**Minor issues: 3** (reference inaccuracies)

---

## Checklist Results

| # | Check Item | Result |
|---|-----------|--------|
| 1 | VPN label allocation, RT/RD semantics correct per RFC 4364 | PASS — RD/RT semantics correct throughout; label allocation defaults have 2 moderate inconsistencies in 7.1 |
| 2 | EVPN route types (1-5), ESI handling, DF election match RFC 7432/9135/9136 | PASS — all route type NLRIs, ESI procedures, DF election algorithms correctly described |
| 3 | Inter-AS option A/B/C descriptions accurate | PASS — all three options correctly described per RFC 4364 §10a/b/c |
| 4 | VPLS BGP (RFC 4761) vs LDP (RFC 4762) signaling differences correct | PASS — correctly attributed and differentiated |
| 5 | No conflation of vendor-specific behavior with protocol standard | PASS — vendor-specific details (IOS-XR, Junos) are consistently labeled as such |

---

*Review completed 2026-02-28. No fabricated issues — all findings verified against RFC text or confirmed via IETF source documents.*
