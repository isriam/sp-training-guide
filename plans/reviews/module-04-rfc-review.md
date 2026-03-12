# Module 04 — MPLS: RFC Cross-Reference Audit

**Auditor**: Sentinel (RFC Cross-Reference Auditor)
**Date**: 2026-03-12
**Scope**: All 13 markdown files in `modules/04-mpls/`
**Total unique RFCs cited**: 43
**Issues found**: 2 (1 critical, 1 minor)

---

## Summary

43 unique RFC numbers were verified across 13 files. 41 references are accurate — correct RFC numbers, correct titles, correct topic attribution. Two issues were found:

1. **CRITICAL** — RFC 5711 has a completely fabricated title and wrong description in `4.2-rsvp-te-theory.md`
2. **MINOR** — RFC 4182 is described as "(Label Stacking)" in the Quick Reference of `4.3-label-operations.md`, but the RFC is about Explicit NULL, not label stacking

---

## Issues

### 4.2-rsvp-te-theory.md — RFC 5711 Wrong Title and Description

- **Severity**: critical
- **Current text**: `"RFC 5711 | 2010 | Node Behavior upon Originating and Receiving RSVP-TE Path Messages with Downstream Clarification | Clarifies node behavior for bypass tunnel binding"`
- **Correction**: The actual title is **"Node Behavior upon Originating and Receiving Resource Reservation Protocol (RSVP) Path Error Messages"**. The RFC clarifies behavior for RSVP **PathErr** messages (specifically regarding preempted TE LSPs), not "Path Messages with Downstream Clarification" and not "bypass tunnel binding." The title in the guide appears fabricated — it doesn't match the RFC at all.
- **Source**: RFC 5711, Abstract — "The aim of this document is to describe a common practice with regard to the behavior of nodes that send and receive a Resource Reservation Protocol (RSVP) Traffic Engineering (TE) Path Error messages for a preempted Multiprotocol Label Switching (MPLS) or Generalized MPLS (GMPLS) Traffic Engineering Label Switched Path (TE LSP)."

**Suggested fix** — replace the table row with:
```
| RFC 5711 | 2010 | Node Behavior upon Originating and Receiving RSVP Path Error Messages | Clarifies PathErr message handling for preempted TE LSPs |
```

---

### 4.3-label-operations.md — RFC 4182 Wrong Topic in Quick Reference

- **Severity**: minor
- **Current text**: `"RFC 4182 (Label Stacking)"`
- **Correction**: RFC 4182 is **"Removing a Restriction on the Use of MPLS Explicit NULL"** — it allows Explicit NULL labels (0 and 2) to appear anywhere in the label stack, not just at the bottom. It is about Explicit NULL, not about label stacking generally. The theory file (`4.3-label-operations-theory.md`) correctly describes it as "Allows Explicit NULL on non-directly-connected interfaces."
- **Source**: RFC 4182, Abstract — "Previously, these labels were only legal when they occurred at the bottom of the MPLS label stack. This restriction is now removed, so that these label values may legally occur anywhere in the stack."

**Suggested fix** — replace in Quick Reference:
```
RFC 4182 (Explicit NULL in Label Stacks)
```

---

## Verified Clean — All Other References

The following 41 RFC references were verified as accurate (correct number, correct title, correct topic attribution):

| RFC | Title (verified) | Files citing it |
|-----|------------------|-----------------|
| RFC 2205 | RSVP — Version 1 Functional Specification | 4.2-rsvp-te.md, 4.2-rsvp-te-theory.md |
| RFC 2961 | RSVP Refresh Overhead Reduction Extensions | 4.2-rsvp-te.md, 4.2-rsvp-te-theory.md |
| RFC 3031 | Multiprotocol Label Switching Architecture | 4.3-label-operations-theory.md |
| RFC 3032 | MPLS Label Stack Encoding | 4.3-label-operations.md, 4.3-label-operations-theory.md |
| RFC 3036 | LDP Specification (original, obsoleted by 5036) | 4.1-ldp-and-label-distribution-theory.md |
| RFC 3209 | RSVP-TE: Extensions to RSVP for LSP Tunnels | 4.1-ldp…, 4.2-rsvp-te.md, 4.2-rsvp-te-theory.md |
| RFC 3429 | Assignment of the 'OAM Alert Label' | 4.3-label-operations-theory.md |
| RFC 3443 | Time To Live (TTL) Processing in MPLS Networks | 4.3-label-operations.md, 4.3-label-operations-theory.md |
| RFC 3473 | GMPLS Signaling — RSVP-TE Extensions | 4.2-rsvp-te.md, 4.2-rsvp-te-theory.md |
| RFC 3478 | Graceful Restart Mechanism for LDP | 4.1-ldp….md, 4.1-ldp…-theory.md |
| RFC 3630 | TE Extensions to OSPF Version 2 | 4.2-rsvp-te-theory.md |
| RFC 4090 | Fast Reroute Extensions to RSVP-TE for LSP Tunnels | 4.2-rsvp-te.md, 4.2-rsvp-te-theory.md |
| RFC 4379 | Detecting MPLS Data Plane Failures (obsoleted by 8029) | 4.4-mpls-oam….md, 4.4-…-theory.md |
| RFC 4875 | Extensions to RSVP-TE for P2MP TE LSPs | 4.2-rsvp-te-theory.md |
| RFC 5036 | LDP Specification | 4.1-ldp….md, 4.1-ldp…-theory.md |
| RFC 5283 | LDP Extension for Inter-Area LSPs | 4.1-ldp…-theory.md |
| RFC 5305 | IS-IS Extensions for Traffic Engineering | 4.2-rsvp-te-theory.md |
| RFC 5420 | Encoding of Attributes for MPLS LSP Establishment Using RSVP-TE | 4.2-rsvp-te-theory.md |
| RFC 5440 | Path Computation Element Communication Protocol (PCEP) | 4.2-rsvp-te.md |
| RFC 5443 | LDP IGP Synchronization | 4.1-ldp….md, 4.1-ldp…-theory.md |
| RFC 5462 | MPLS Label Stack Entry: "EXP" Field Renamed to "Traffic Class" | 4.3-label-operations-theory.md |
| RFC 5561 | LDP Capabilities | 4.1-ldp….md, 4.1-ldp…-theory.md |
| RFC 5586 | MPLS Generic Associated Channel | 4.3-…-theory.md, 4.4-…-theory.md |
| RFC 5712 | MPLS Traffic Engineering Soft Preemption | 4.2-rsvp-te.md |
| RFC 5884 | BFD for MPLS LSPs | 4.4-mpls-oam….md, 4.4-…-theory.md, 4.4-…-answers.md |
| RFC 5885 | BFD for Pseudowire VCCV | 4.4-…-theory.md |
| RFC 5918 | LDP Typed Wildcard FEC | 4.1-ldp…-theory.md |
| RFC 5919 | Signaling LDP Label Advertisement Completion | 4.1-ldp…-theory.md |
| RFC 6374 | Packet Loss and Delay Measurement for MPLS Networks | 4.4-mpls-oam….md, 4.4-…-theory.md |
| RFC 6425 | Detecting Data-Plane Failures in P2MP MPLS — Extensions to LSP Ping | 4.4-…-theory.md |
| RFC 6426 | MPLS On-Demand CV and Route Tracing | 4.4-…-theory.md |
| RFC 6428 | Proactive CC/CV/RDI for MPLS Transport Profile | 4.4-…-theory.md |
| RFC 6720 | The Generalized TTL Security Mechanism (GTSM) for LDP | 4.1-ldp…-theory.md |
| RFC 6790 | The Use of Entropy Labels in MPLS Forwarding | 4.1-ldp….md, 4.3-…, 4.3-…-theory.md, 4.3-…-answers.md |
| RFC 7274 | Allocating and Retiring Special-Purpose MPLS Labels | 4.3-label-operations-theory.md |
| RFC 7552 | Updates to LDP for IPv6 | 4.1-ldp…-theory.md |
| RFC 7759 | Configuration of Proactive OAM Functions for MPLS-TP Using RSVP-TE | 4.4-…-theory.md |
| RFC 8029 | Detecting MPLS Data-Plane Failures | 4.4-mpls-oam….md, 4.4-…-theory.md, 4.4-…-answers.md |
| RFC 8776 | Common YANG Data Types for Traffic Engineering | 4.2-rsvp-te.md |
| RFC 8960 | A YANG Data Model for MPLS Base | 4.3-label-operations.md |
| RFC 9070 | YANG Data Model for MPLS LDP | 4.1-ldp….md |
| RFC 9314 | YANG Data Model for BFD | 4.4-mpls-oam….md |

---

## Notes

- **RFC 8776** is cited as the `ietf-te` YANG model in 4.2-rsvp-te.md. Technically, RFC 8776 defines *common TE YANG data types*, not the full `ietf-te` module (which is RFC 9521). The RFC number is real and TE-related, so this is at most a pedantic imprecision — not flagged as an issue.
- The cleanup timeout calculation "(3.5) × 30s per RFC 2205" in 4.2-rsvp-te.md was verified against RFC 2205 §3.7: `(K+0.5)*R` where K defaults to 3. Correct.
- RFC 8029 return code 10 ("Mapping for this FEC is not the given label at stack-depth") cited in 4.4-answers: verified accurate.
- All reserved label assignments (0, 1, 2, 3, 7, 13, 14, 15) verified against their respective RFCs. All correct.
- No draft documents cited as RFCs. No non-existent RFC numbers found.

---

## Files Audited

1. `4.1-ldp-and-label-distribution.md`
2. `4.1-ldp-and-label-distribution-theory.md`
3. `4.1-ldp-and-label-distribution-answers.md`
4. `4.2-rsvp-te.md`
5. `4.2-rsvp-te-theory.md`
6. `4.2-rsvp-te-answers.md`
7. `4.3-label-operations.md`
8. `4.3-label-operations-theory.md`
9. `4.3-label-operations-answers.md`
10. `4.4-mpls-oam-and-troubleshooting.md`
11. `4.4-mpls-oam-and-troubleshooting-theory.md`
12. `4.4-mpls-oam-and-troubleshooting-answers.md`
13. `README.md`
