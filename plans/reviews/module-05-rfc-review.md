# Module 05 — RFC Cross-Reference Audit

**Auditor**: Sentinel (RFC accuracy subagent)
**Date**: 2026-03-12
**Scope**: All markdown files in `modules/05-te/`
**Total unique RFCs cited**: 35
**Verdict**: 4 critical issues, 4 minor issues found

---

## Files Audited

| File | RFC refs | Issues |
|------|----------|--------|
| 5.1-te-fundamentals.md | 11 | 1 critical |
| 5.1-te-fundamentals-answers.md | 1 | 0 |
| 5.1-te-fundamentals-theory.md | 10 | 2 minor |
| 5.2-rsvp-te-advanced.md | 7 | 0 |
| 5.2-rsvp-te-advanced-answers.md | 0 | 0 |
| 5.2-rsvp-te-advanced-theory.md | 8 | 1 critical, 1 minor |
| 5.3-segment-routing-te.md | 7 | 0 |
| 5.3-segment-routing-te-answers.md | 1 | 0 |
| 5.3-segment-routing-te-theory.md | 11 | 1 critical |
| 5.4-te-deployment-and-design.md | 5 | 1 critical |
| 5.4-te-deployment-and-design-answers.md | 0 | 0 |
| README.md | 0 | 0 |

---

## Critical Issues

### 5.1-te-fundamentals.md — IS-IS SRLG encoding is wrong

- **Severity**: critical
- **Current text**: `| SRLG | Sub-TLV 16 (RFC 4205) | Sub-TLV (RFC 4203) | Shared risk group |`
- **Correction**: In IS-IS, SRLG is advertised as standalone **TLV 138** (GMPLS-SRLG), defined in RFC 4205 (obsoleted by RFC 5307). It is NOT Sub-TLV 16 under TLV 22. Sub-TLV 16 is the **OSPF** SRLG encoding from RFC 4203. The IS-IS column has the OSPF sub-TLV number. Correct IS-IS entry should be: `TLV 138 (RFC 5307)`.
- **Source**: RFC 5307 Section 1 — defines TLV 138 (GMPLS-SRLG); RFC 4203 Section 1.3 — defines OSPF Sub-TLV 16 (Shared Risk Link Group). IANA IS-IS TLV registry confirms TLV 138 for SRLG.

### 5.2-rsvp-te-advanced-theory.md — IS-IS SRLG advertisement encoding wrong

- **Severity**: critical
- **Current text**: `IS-IS SRLG advertisement: Carried in sub-TLV under TLV 22 (link SRLG, RFC 5307) or via a dedicated TLV for SRLG constraints.`
- **Correction**: RFC 5307 defines IS-IS SRLG as **TLV 138** — a standalone TLV, NOT a sub-TLV under TLV 22. There is no SRLG sub-TLV defined under TLV 22 in any RFC. The statement should read: "Carried in TLV 138 (GMPLS-SRLG, RFC 5307)." The "or via a dedicated TLV" clause is the correct encoding — it IS a dedicated TLV. The first clause (sub-TLV under TLV 22) is wrong.
- **Source**: RFC 5307 Section 1 — TLV table explicitly shows `TLV Type 138 | variable | GMPLS-SRLG`. The sub-TLVs added to TLV 22 are only 4 (Link Local/Remote Identifiers), 20 (Link Protection Type), and 21 (Interface Switching Capability Descriptor).

### 5.3-segment-routing-te-theory.md — RFC 9252 description attributes wrong topic

- **Severity**: critical
- **Current text**: `| RFC 9252 | 2022 | BGP Overlay Services Based on Segment Routing over IPv6 (SRv6) | BGP color community for SRv6 steering |`
- **Correction**: RFC 9252 defines BGP encoding procedures for **SRv6-based overlay services** (L3VPN, EVPN, Internet services using SRv6 SIDs). It does NOT define or primarily discuss the BGP color extended community for SR-TE steering. The color extended community and its use for SR-TE policy steering is defined in **RFC 9256** (Segment Routing Policy Architecture). A student looking up RFC 9252 for "BGP color community" would find L3VPN/EVPN SRv6 SID encoding instead. The description column should read: "SRv6 SID encoding for BGP L3VPN, EVPN, and Internet overlay services".
- **Source**: RFC 9252 Abstract — "This document defines procedures and messages for SRv6-based BGP services, including Layer 3 Virtual Private Network (L3VPN), Ethernet VPN (EVPN), and Internet services." RFC 9256 Section 2.1 — defines policy identification via `<headend, color, endpoint>` tuple.

### 5.4-te-deployment-and-design.md — Wrong RFC in sources line (likely typo)

- **Severity**: critical
- **Current text**: `*Sources: RFC 4090, RFC 3209, RFC 5286, RFC 7490, RFC 9514, Cisco IOS-XE MPLS TE Configuration Guide...*`
- **Correction**: RFC 9514 is "Border Gateway Protocol - Link State (BGP-LS) Extensions for Segment Routing over IPv6 (SRv6)" — a BGP-LS/SRv6 RFC that is never discussed in this file. The Key RFCs section of the same file correctly lists **RFC 9855 (TI-LFA)** but the sources line has RFC 9514 instead. This is almost certainly a typo — **RFC 9514 should be RFC 9855**.
- **Source**: RFC 9514 title page — "BGP-LS Extensions for SRv6"; RFC 9855 title page — "Topology Independent Loop-Free Alternate (TI-LFA) Fast Reroute using Segment Routing". The file's Key RFCs line (4 lines above) correctly has RFC 9855.

---

## Minor Issues

### 5.1-te-fundamentals-theory.md — RFC 4124 title significantly abbreviated

- **Severity**: minor
- **Current text**: `| RFC 4124 | 2005 | Protocol Extensions for DS-TE |`
- **Correction**: Actual title is "Protocol Extensions for Support of Diffserv-aware MPLS Traffic Engineering". The table abbreviates to "Protocol Extensions for DS-TE" which drops "Support of" and replaces the full form with the acronym. Same pattern affects RFC 4125 ("Maximum Allocation Bandwidth Constraints Model for DS-TE" vs actual "...for Diffserv-aware MPLS Traffic Engineering") and RFC 4127. Not wrong, but inconsistent with other entries that use full titles.
- **Source**: RFC 4124 title page.

### 5.1-te-fundamentals-theory.md — RFC 5440 description mischaracterizes scope

- **Severity**: minor
- **Current text**: `| RFC 5440 | 2009 | Path Computation Element (PCE) Communication Protocol (PCEP) | PCE architecture for centralized path computation |`
- **Correction**: RFC 5440 defines the **PCEP protocol** (message formats, state machines, procedures), not the PCE architecture. The PCE architecture is defined in **RFC 4655** ("A Path Computation Element (PCE)-Based Architecture"). The description should read: "PCEP protocol: message formats and procedures for PCC-PCE communication".
- **Source**: RFC 5440 Abstract — "This document specifies the Path Computation Element (PCE) Communication Protocol (PCEP) for communications between a Path Computation Client (PCC) and a PCE." RFC 4655 defines the architecture.

### 5.2-rsvp-te-advanced-theory.md — RFC 4090 title truncated

- **Severity**: minor
- **Current text**: `| RFC 4090 | 2005 | Fast Reroute Extensions to RSVP-TE |`
- **Correction**: Actual title is "Fast Reroute Extensions to RSVP-TE **for LSP Tunnels**". Missing the "for LSP Tunnels" suffix.
- **Source**: RFC 4090 title page.

### Multiple files — RFC 2961 common name differs from actual title

- **Severity**: minor
- **Current text**: Referenced as "RSVP Refresh Reduction" (5.1-te-fundamentals.md, 5.1-te-fundamentals-answers.md, 5.2-rsvp-te-advanced.md)
- **Correction**: Actual title is "RSVP Refresh **Overhead** Reduction Extensions". The files use the common industry shorthand which omits "Overhead" and "Extensions". Not likely to cause confusion since "RFC 2961" uniquely identifies the document, but noted for completeness.
- **Source**: RFC 2961 title page.

---

## Verified Clean References (28 of 35)

All other RFC citations were verified against the IETF RFC Editor. The following RFCs are correctly cited for topic, number, and approximate title:

RFC 2205, RFC 2702, RFC 3209, RFC 3630, RFC 3945, RFC 4090 (topic correct, title truncated), RFC 4105, RFC 4125, RFC 4127, RFC 4203, RFC 4875, RFC 5152, RFC 5286, RFC 5305, RFC 5307, RFC 5440 (title correct, description imprecise), RFC 5441, RFC 5712, RFC 7308, RFC 7490, RFC 8231, RFC 8281, RFC 8402, RFC 8491, RFC 8664, RFC 8665, RFC 8667, RFC 9256, RFC 9350, RFC 9855

**No non-existent RFCs cited. No drafts cited as RFCs.**
