# Module 02 — RFC Cross-Reference Audit

**Auditor**: Sentinel (RFC Cross-Reference Auditor)
**Date**: 2026-03-12
**Scope**: All markdown files in `modules/02-igp/`
**Total unique RFCs referenced**: 66
**Issues found**: 2 critical, 0 minor

---

## Summary

Audited 66 unique RFC citations across all Module 02 files. Each RFC number was verified against the RFC Editor / IETF Datatracker to confirm: (1) the RFC exists, (2) it covers the topic claimed, (3) specific claims attributed to it are accurate, and (4) no drafts are cited as RFCs.

**2 critical errors found.** The remaining 64 RFC references are accurate.

---

## Issues

### 2.2-ospf-in-sp-networks-theory.md — Wrong RFC for OSPF-LDP Sync

- **Severity**: critical
- **Current text**: "The OSPF-LDP sync feature (RFC 4811) prevents traffic blackholing by suppressing OSPF adjacency until LDP is converged on the link."
- **Correction**: RFC 4811 is "OSPF Out-of-Band Link State Database (LSDB) Resynchronization" (Nguyen, Roy, Zinin — March 2007). It describes a vendor-specific mechanism for resynchronizing OSPF LSDBs without changing the topology view. It has nothing to do with LDP-IGP synchronization. The correct RFC is **RFC 5443** — "LDP IGP Synchronization" (Jork, Atlas, Fang — March 2009), which defines the mechanism to prevent traffic blackholing by advertising max-metric on OSPF/IS-IS links until LDP has converged.
- **Source**: RFC 4811 (https://datatracker.ietf.org/doc/html/rfc4811), RFC 5443 (https://datatracker.ietf.org/doc/html/rfc5443)

### 2.3-igp-convergence-tuning-theory.md — Wrong UDP Port for BFD MPLS LSPs (RFC 5884)

- **Severity**: critical
- **Current text** (line 21): "BFD uses UDP: port 3784 for single-hop (RFC 5881), port 4784 for multi-hop (RFC 5883), port 6784 for MPLS LSP BFD (RFC 5884)."
- **Also** (line 305, RFC table): "RFC 5884 | 2010 | BFD for MPLS LSPs | BFD over MPLS: UDP port 6784, tests LSP data path"
- **Correction**: UDP port 6784 belongs to **Micro-BFD** (RFC 7130 — "BFD on Link Aggregation Group (LAG) Interfaces"), not to RFC 5884. RFC 5884 Section 7 specifies that BFD Control packets for MPLS LSPs use **UDP destination port 3784** (same as single-hop BFD, per RFC 5881) for the ingress→egress direction, and **port 4784** (multi-hop, per RFC 5883) for routed return packets from egress→ingress. The packets are MPLS-encapsulated using the Router Alert label (label 1) or GAL, which distinguishes them from plain single-hop BFD despite sharing the same port number.
- **Source**: RFC 5884 Section 7 (https://datatracker.ietf.org/doc/html/rfc5884#section-7), RFC 7130 Section 2.3 / IANA Section 7 (https://datatracker.ietf.org/doc/html/rfc7130)

---

## Verified Clean — Full File List

The following files were audited. All RFC references not listed as issues above are confirmed correct:

| File | RFC Count | Status |
|------|-----------|--------|
| `2.1-isis-deep-dive-theory.md` | ~25 | ✅ Clean |
| `2.1-isis-deep-dive.md` | ~5 | ✅ Clean |
| `2.1-isis-deep-dive-answers.md` | ~8 | ✅ Clean |
| `2.2-ospf-in-sp-networks-theory.md` | ~28 | ⚠️ 1 critical (RFC 4811) |
| `2.2-ospf-in-sp-networks.md` | ~3 | ✅ Clean |
| `2.2-ospf-in-sp-networks-answers.md` | ~4 | ✅ Clean |
| `2.3-igp-convergence-tuning-theory.md` | ~25 | ⚠️ 1 critical (RFC 5884 port) |
| `2.3-igp-convergence-tuning.md` | ~5 | ✅ Clean |
| `2.3-igp-convergence-tuning-answers.md` | ~5 | ✅ Clean |
| `2.4-igp-decision-framework-theory.md` | ~8 | ✅ Clean |
| `2.4-igp-decision-framework.md` | ~3 | ✅ Clean |
| `2.4-igp-decision-framework-answers.md` | ~4 | ✅ Clean |

---

## Notable Observations (non-issues)

1. **RFC 3847** (IS-IS Restart Signaling) is obsoleted by **RFC 5306** but is cited historically in a timeline table. Not flagged since the table context is chronological.
2. **RFC 3137** (OSPF Stub Router) is obsoleted by **RFC 6987**, but the guide correctly references RFC 6987 as the current document in operational sections.
3. **RFC 8919** (IS-IS Application-Specific Link Attributes) is obsoleted by **RFC 9479** — the guide uses it in a historical RFC table which is acceptable, but worth noting for future updates.
4. **RFC 7752** (BGP-LS) is obsoleted by **RFC 9552** — same observation as above.
5. **RFC 1142** (OSI IS-IS) is historic/obsoleted by **RFC 7142** — cited appropriately as the original base specification.
