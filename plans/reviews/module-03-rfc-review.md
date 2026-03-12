# Module 03 — BGP: RFC Cross-Reference Audit

**Auditor**: Sentinel (RFC cross-reference subagent)
**Date**: 2026-03-12
**Scope**: All 13 markdown files in `modules/03-bgp/`
**Total unique RFCs cited**: 48
**Verdict**: 8 issues found (3 critical, 5 minor)

---

## Files Audited

| # | File | RFC refs | Issues |
|---|---|---:|---:|
| 1 | `3.1-bgp-fundamentals-at-sp-scale.md` | 14 | 0 |
| 2 | `3.1-bgp-fundamentals-at-sp-scale-theory.md` | 35 | 3 |
| 3 | `3.1-bgp-fundamentals-at-sp-scale-answers.md` | 0 | 0 |
| 4 | `3.2-ibgp-design.md` | 6 | 0 |
| 5 | `3.2-ibgp-design-theory.md` | 14 | 2 |
| 6 | `3.2-ibgp-design-answers.md` | 1 | 0 |
| 7 | `3.3-ebgp-peering.md` | 12 | 0 |
| 8 | `3.3-ebgp-peering-theory.md` | 13 | 1 |
| 9 | `3.3-ebgp-peering-answers.md` | 5 | 0 |
| 10 | `3.4-bgp-policy-and-traffic-engineering.md` | 10 | 0 |
| 11 | `3.4-bgp-policy-and-traffic-engineering-theory.md` | 12 | 1 |
| 12 | `3.4-bgp-policy-and-traffic-engineering-answers.md` | 4 | 1 |
| 13 | `README.md` | 0 | 0 |

---

## Issues

### 3.1-bgp-fundamentals-at-sp-scale-theory.md — Wrong Cease Subcode for Hard Reset

- **Severity**: critical
- **Current text**: "Subcode 8: Hard Reset (RFC 8538 — used with Graceful Restart to signal non-graceful close)"
- **Correction**: Hard Reset is **Cease subcode 9**, not 8. Subcode 8 is "Out of Resources" (RFC 4486). Verified against IANA BGP Cease NOTIFICATION message subcodes registry (updated 2026-03-09).
- **Source**: IANA BGP Parameters registry; RFC 8538 Section 4

---

### 3.2-ibgp-design-theory.md — Wrong Section Numbers for RFC 4456

- **Severity**: critical
- **Current text**: "RFC 4456 — The route reflector specification. Short, clear, and essential. Section 8 (Redundant RRs) and Section 10 (Cluster ID) are critical."
- **Correction**: RFC 4456 Section 7 is "Redundant RRs" (not Section 8). Section 8 is "Avoiding Routing Information Loops". Section 10 is "Implementation Considerations" (not "Cluster ID"). Cluster ID is discussed primarily in Sections 5 (Terminology and Concepts) and 7 (Redundant RRs). Correct citation: "Section 7 (Redundant RRs) and Section 10 (Implementation Considerations)."
- **Source**: RFC 4456 Table of Contents (April 2006)

---

### 3.2-ibgp-design-theory.md — RFC 7911 Section Descriptions Swapped

- **Severity**: critical
- **Current text**: "RFC 7911 — The ADD-PATH specification. Sections 3 (Capability) and 4 (NLRI encoding) are the core mechanics."
- **Correction**: Section 3 is "Extended NLRI Encodings" and Section 4 is "ADD-PATH Capability" — the topic descriptions are reversed. Should read: "Sections 3 (NLRI encoding) and 4 (Capability)."
- **Source**: RFC 7911 Table of Contents (July 2016)

---

### 3.4-bgp-policy-and-traffic-engineering-theory.md — Wrong Title for RFC 7196

- **Severity**: minor
- **Current text**: "| RFC 7196 | 2014 | Recommendations for Use of BGP Route Flap Damping | Modern conservative guidance on damping |"
- **Correction**: The actual title is **"Making Route Flap Damping Usable"**, not "Recommendations for Use of BGP Route Flap Damping". The table title appears fabricated.
- **Source**: RFC 7196 (May 2014), rfc-editor.org

---

### 3.3-ebgp-peering-theory.md — RFC 5082 Title Severely Truncated

- **Severity**: minor
- **Current text**: "| RFC 5082 | 2007 | The GTSM | TTL-based session protection for directly connected peers |"
- **Correction**: The actual title is **"The Generalized TTL Security Mechanism (GTSM)"**. The table shows only "The GTSM" which loses the expanded form. (Note: the 3.1-theory.md table has a better version: "The GTSM (Generalized TTL Security Mechanism)" — reordered but complete.)
- **Source**: RFC 5082 (October 2007)

---

### 3.4-bgp-policy-and-traffic-engineering-answers.md — NOPEER Misattributed to RFC 1997

- **Severity**: minor
- **Current text**: "All three are well-known BGP communities (RFC 1997) that control route propagation."
- **Correction**: RFC 1997 defines the community attribute and the well-known communities NO_EXPORT (0xFFFFFF01), NO_ADVERTISE (0xFFFFFF02), and NO_EXPORT_SUBCONFED (0xFFFFFF03). **NOPEER (0xFFFFFF04) is defined by RFC 3765**, not RFC 1997. The text later correctly cites RFC 3765 for NOPEER, but the opening sentence incorrectly attributes all three communities to RFC 1997.
- **Source**: RFC 1997 Section 3 (well-known communities); RFC 3765 Section 4 (NOPEER IANA registration)

---

### 3.1-bgp-fundamentals-at-sp-scale-theory.md — RFC 8203 Obsoleted by RFC 9003

- **Severity**: minor
- **Current text**: "RFC 8203 | 2017 | BGP Administrative Shutdown Communication | Shutdown reason string in NOTIFICATION Cease messages" (also cited inline at line 128)
- **Correction**: RFC 8203 was **obsoleted by RFC 9003** ("Extended BGP Administrative Shutdown Communication", January 2021). The concept described is correct, but the canonical reference is now RFC 9003. The IANA registry for Cease subcodes 2 and 4 also cites RFC 9003 as the current reference.
- **Source**: RFC 9003 (January 2021); IANA BGP Cease NOTIFICATION message subcodes

---

### 3.1-bgp-fundamentals-at-sp-scale-theory.md — RFC 7752 Obsoleted by RFC 9552

- **Severity**: minor
- **Current text**: "| RFC 7752 | 2016 | North-Bound Distribution of Link-State and TE Information Using BGP | BGP-LS: topology export to SDN controllers |"
- **Correction**: RFC 7752 was **obsoleted by RFC 9552** ("Distribution of Link-State and Traffic Engineering Information Using BGP", December 2023). The concept is correct, but the canonical reference for BGP-LS is now RFC 9552.
- **Source**: RFC 9552 (December 2023); datatracker.ietf.org

---

## Verified Clean

All other RFC citations across the 13 files were verified correct, including:

- **RFC numbers**: All 48 unique RFC numbers exist and are valid published RFCs (no drafts cited as RFCs, no nonexistent RFC numbers)
- **RFC-to-topic mapping**: Each RFC is cited for its correct subject matter
- **Attribute type codes**: COMMUNITY (8), EXTENDED COMMUNITIES (16), AS4_PATH (17), AIGP (26), LARGE_COMMUNITY (32) — all match IANA registry
- **Capability codes**: Route Refresh (2), 4-Byte ASN (65), ADD-PATH (69), Enhanced Route Refresh (70), BGP Role (9) — all correct
- **AFI/SAFI values**: VPNv4 (1/128), EVPN (25/65), FlowSpec (1/133), BGP-LS (16388/71), RT-Constrain (1/132), Labeled Unicast (1/4) — all correct
- **Community values**: NO_EXPORT (65535:65281), NO_ADVERTISE (65535:65282), NOPEER (65535:65284), GRACEFUL_SHUTDOWN (65535:0), BLACKHOLE (65535:666) — all correct
- **AS_TRANS (23456)**: Correct per RFC 6793
- **Publication years**: All years in RFC tables verified correct
- **RFC titles**: All other titles accurate (minor abbreviations like "TE" for "Traffic Engineering" are acceptable)
