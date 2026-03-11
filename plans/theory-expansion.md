# Theory Expansion Plan

> Living document. Update as sections are completed or scope changes.

## Goal

Add protocol theory files to each section that covers a protocol or mechanism. The existing design/deployment files tell you *what to do*. Theory files tell you *why it works* — protocol internals, packet formats, state machines, algorithms, and RFCs.

## File Convention

Each section that gets a theory file follows this naming:

```
<section-name>-theory.md    — protocol mechanics (markdown)
<section-name>-theory.mp3   — TTS audio of theory content
```

These sit alongside the existing 4-file set:

```
modules/XX-topic/
  X.Y-section-name.md              ← design/deployment (existing)
  X.Y-section-name.mp3             ← design audio (existing)
  X.Y-section-name-theory.md       ← protocol theory (NEW)
  X.Y-section-name-theory.mp3      ← theory audio (NEW)
  X.Y-section-name-answers.md      ← Q&A (existing)
  X.Y-section-name-answers.mp3     ← Q&A audio (existing)
```

## Theory File Template

Every theory file follows this structure:

```markdown
# X.Y — [Topic] — Protocol Theory

## Protocol Overview
- What problem it solves
- Where it sits in the stack (L2/L3/control plane/data plane)
- Historical context (when created, why, what it replaced)

## Core Mechanisms
- State machines / FSMs (with state descriptions)
- Packet/PDU formats (field-by-field breakdown)
- Algorithms (SPF, best path, election, etc.)
- Timers and their defaults (with rationale)

## Key RFCs & Standards
- RFC XXXX — [title] — what it defines
- Organized by importance, with brief description of each

## Protocol Interactions
- How it interacts with other protocols in the guide
- Dependencies and assumptions

## Edge Cases & Gotchas
- Known implementation differences between vendors
- Common misunderstandings
- What the RFC says vs what vendors actually do

## Further Reading
- Definitive books, papers, conference talks
```

## Rules

1. **Vendor neutral** — theory files cover protocol mechanics only. No IOS-XR or Junos configs (those stay in the design files).
2. **RFC anchored** — every claim traces to an RFC or standard. Not just "RFC 5305" but what that RFC actually defines.
3. **IE written exam depth** — you should pass the written from theory files alone.
4. **No code blocks unless showing packet formats** — this isn't a config guide. Packet diagrams and field layouts are fine.
5. **Cross-reference the design file** — theory files should reference their companion design file for "how to actually deploy this."
6. **TTS-friendly** — write for narration. Avoid dense tables where prose works. Code blocks (packet formats) will be skipped by TTS.

## Validation Process

1. Write theory file → commit to repo
2. Jeremy reviews for technical accuracy (he knows these protocols at CCIE/JNCIE depth)
3. Sentinel pass for RFC citation accuracy and factual claims
4. Generate TTS after approval
5. Update checklist below

## Section Checklist

### Module 2: IGP
- [x] 2.1 IS-IS Deep Dive — IS-IS PDU types, TLVs, adjacency FSM, SPF, DIS election, L1/L2
- [x] 2.2 OSPF in SP Networks — LSA types, area mechanics, DR/BDR, OSPFv3, stub/NSSA
- [x] 2.3 IGP Convergence Tuning — SPF scheduling, LSA/LSP throttling, BFD, PRC

### Module 3: BGP
- [x] 3.1 BGP Fundamentals — FSM, UPDATE processing, path attributes, NLRI encoding
- [x] 3.2 iBGP Design — RR mechanics, cluster behavior, ADD-PATH, ORF
- [x] 3.3 eBGP Peering — multihop, TTL security, GR/NSR, BFD integration
- [x] 3.4 BGP Policy — community encoding (standard/extended/large), AS-path regex, MED

### Module 4: MPLS
- [x] 4.1 LDP — discovery, session establishment, label distribution modes, liberal vs conservative
- [x] 4.2 RSVP-TE — PATH/RESV messages, ERO/RRO, soft state refresh, make-before-break
- [x] 4.3 Label Operations — push/swap/pop, penultimate hop popping, label stack encoding
- [x] 4.4 MPLS OAM — LSP ping/traceroute, MPLS echo request/reply, BFD for MPLS

### Module 5: Traffic Engineering
- [ ] 5.1 TE Fundamentals — CSPF algorithm, TE metrics, admin groups, bandwidth constraints
- [ ] 5.2 RSVP-TE Advanced — FRR facility/one-to-one, auto-bandwidth, preemption, priorities
- [ ] 5.3 Segment Routing TE — SR-TE policy architecture, BSID, candidate paths, Flex-Algo

### Module 6: Segment Routing
- [ ] 6.1 SR-MPLS Fundamentals — SID types, SRGB, IGP extensions (IS-IS TLV 135 sub-TLV, OSPF)
- [ ] 6.2 SR-TE Policies — policy model, color/endpoint, dynamic/explicit paths, PCE/PCEP
- [ ] 6.3 TI-LFA — algorithm (P/Q space, post-convergence SPF), repair tunnel construction
- [ ] 6.4 SRv6 Fundamentals — SRH format, locator structure, END/END.X/END.DT behaviors
- [ ] 6.5 SRv6 Network Programming — uSID, network programming model, H.Encaps/H.Insert

### Module 7: L3VPN
- [ ] 7.1 L3VPN Architecture — VRF mechanics, RD/RT encoding, VPNv4/v6 NLRI format
- [ ] 7.2 MP-BGP VPNv4/VPNv6 — AFI/SAFI, extended communities, label allocation schemes
- [ ] 7.3 Inter-AS L3VPN — Option A/B/C mechanics, ASBR label stitching, multihop MP-BGP

### Module 8: L2VPN & EVPN
- [ ] 8.1 Legacy L2VPN — pseudowire signaling (LDP/BGP), VPLS MAC learning, PW status TLV
- [ ] 8.2 EVPN Fundamentals — Route types 1-5 format, MAC/IP advertisement, ARP suppression
- [ ] 8.4 EVPN Multi-Homing — ESI encoding, DF election algorithm, aliasing, split-horizon

### Module 9: Transport & Optical
- [ ] 9.2 DWDM Fundamentals — wavelength physics, EDFA gain/noise, Raman amplification, ROADM architecture
- [ ] 9.3 OTN — ODU/OTU framing, TCM fields, FEC (GFEC/EFEC/oFEC), GCC channels
- [ ] 9.5 Coherent Optics — modulation theory (QPSK/8QAM/16QAM), DSP pipeline, PCS, Shannon limit

### Module 10: Slicing
- [ ] 10.2 FlexE — FlexE shim layer, calendar slots, client/group mapping, OIF spec

### Module 11: Automation
- [ ] 11.1 Model-Driven Networking — YANG tree structure, NETCONF layers (SSH/RPC/content), gRPC/gNMI
- [ ] 11.2 Streaming Telemetry — dial-in vs dial-out, gNMI Subscribe modes, sensor paths, protobuf encoding

**Total: ~30 theory files**

### Sections that do NOT need theory files
- Module 1 (Foundations) — already conceptual
- 2.4 IS-IS vs OSPF Decision Framework — design comparison, not protocol theory
- 5.4 TE Deployment and Design — applied design
- 6.6 SR Migration Strategies — operational planning
- 7.4 Extranet/Shared Services — design patterns
- 7.5 L3VPN Scale & Convergence — design/tuning
- 8.3 EVPN-MPLS vs VXLAN — comparison
- 8.5 EVPN DCI — design patterns
- 9.1 SP Transport Hierarchy — overview
- 9.4 Packet-Optical Integration — design
- 10.1 Network Slicing Concepts — conceptual
- 10.3 5G xHaul — requirements/design
- 11.3-11.5 — controller integration, CI/CD, lab (applied)
- Module 12 (Case Studies) — applied design

---

## Future Expansions

_Add new feature plans here as they're scoped._

---

*Last updated: 2026-03-11 — Modules 2, 3, and 4 complete*
