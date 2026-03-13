# Module 07 L3VPN — RFC Cross-Reference Audit

Scope: All Markdown files under `/home/claude/agent-will/projects/sp-study-guide/modules/07-l3vpn/`

Audit focus: RFC number validity, title correctness, section-reference correctness, publication metadata, obsolescence/update handling, and claim attribution.

## Summary

- Files reviewed: 18 markdown files
- Findings: **10**
  - **Critical:** 5
  - **Minor:** 5

---

## Findings

### 1) Fabricated RFC citation (`RFC 2547bis` does not exist as an RFC)
- **Severity:** critical
- **File:** `modules/07-l3vpn/7.1-l3vpn-architecture.md`
- **Line:** 5
- **Current text:** `MPLS L3VPN (RFC 4364, formerly RFC 2547bis) ...`
- **Correct RFC info:** There is **no RFC named "RFC 2547bis"**. `rfc2547bis` was an Internet-Draft lineage that became **RFC 4364**; RFC 4364 **obsoletes RFC 2547**.
- **Source:**
  - https://www.rfc-editor.org/info/rfc4364 (obsoletes RFC 2547)
  - https://www.rfc-editor.org/info/rfc2547
  - https://www.rfc-editor.org/info/rfc2547bis (404 / nonexistent RFC)

### 2) Fabricated RFC citation (`RFC 2547bis`)
- **Severity:** critical
- **File:** `modules/07-l3vpn/7.1-l3vpn-architecture-theory.md`
- **Line:** 7
- **Current text:** `... revised as RFC 2547bis, which became RFC 4364 (2006).`
- **Correct RFC info:** `RFC 2547bis` is not an RFC. Correct progression is RFC 2547 (1999) → work progressed via `rfc2547bis` drafts → published as RFC 4364 (2006), which obsoletes RFC 2547.
- **Source:**
  - https://www.rfc-editor.org/info/rfc4364
  - https://www.rfc-editor.org/info/rfc2547
  - https://datatracker.ietf.org/doc/draft-ietf-l3vpn-rfc2547bis/

### 3) Fabricated RFC citation propagated in module index
- **Severity:** critical
- **File:** `modules/07-l3vpn/README.md`
- **Line:** 9
- **Current text:** `MPLS L3VPN (RFC 4364, formerly RFC 2547bis) ...`
- **Correct RFC info:** Same correction as above: no RFC 2547bis; RFC 4364 obsoletes RFC 2547.
- **Source:**
  - https://www.rfc-editor.org/info/rfc4364
  - https://www.rfc-editor.org/info/rfc2547

### 4) Wrong RFC attributed to BGP Classful Transport (BGP-CT)
- **Severity:** critical
- **File:** `modules/07-l3vpn/7.3-inter-as-l3vpn.md`
- **Line:** 232
- **Current text:** `RFC 9012 (BGP-CT) ... introduce a transport-class concept ...`
- **Correct RFC info:** RFC 9012 is **Tunnel Encapsulation Attribute**, not BGP-CT. BGP Classful Transport is specified in **RFC 9832** (Experimental, 2025).
- **Source:**
  - https://www.rfc-editor.org/info/rfc9012
  - https://www.rfc-editor.org/info/rfc9832

### 5) Wrong RFC title in sources list (same misattribution)
- **Severity:** critical
- **File:** `modules/07-l3vpn/7.3-inter-as-l3vpn.md`
- **Line:** 842
- **Current text:** `RFC 9012 (BGP Classful Transport Planes)`
- **Correct RFC info:** Title `BGP Classful Transport Planes` corresponds to **RFC 9832**, not RFC 9012. RFC 9012 title is about tunnel encapsulation.
- **Source:**
  - https://www.rfc-editor.org/info/rfc9012
  - https://www.rfc-editor.org/info/rfc9832

### 6) Wrong section reference in RFC 4364 (VRF section)
- **Severity:** minor
- **File:** `modules/07-l3vpn/7.1-l3vpn-architecture-theory.md`
- **Line:** 188
- **Current text:** `Sections 4 (VRF), 4.2 (RD), and 4.3 (RT) are essential.`
- **Correct RFC info:** In RFC 4364, **VRFs are Section 3** (`VRFs: Multiple Forwarding Tables in PEs`), not Section 4. Section 4 is VPN route distribution via BGP.
- **Source:**
  - https://www.rfc-editor.org/rfc/rfc4364.html (Table of Contents)

### 7) Wrong section reference in RFC 4364 (Internet access)
- **Severity:** minor
- **File:** `modules/07-l3vpn/7.4-extranet-shared-services-theory.md`
- **Line:** 149
- **Current text:** `RFC 4364 Section 7 — Internet access patterns for VPNs.`
- **Correct RFC info:** Internet access from VPNs is **RFC 4364 Section 11** (`Accessing the Internet from a VPN`). Section 7 is PE learning routes from CEs.
- **Source:**
  - https://www.rfc-editor.org/rfc/rfc4364.html (Table of Contents)

### 8) Outdated RFC cited as primary reference without update in protocol interaction text
- **Severity:** minor
- **File:** `modules/07-l3vpn/7.3-inter-as-l3vpn-theory.md`
- **Line:** 124
- **Current text:** `Option C depends on labeled unicast BGP (RFC 3107) ...`
- **Correct RFC info:** RFC 3107 is obsoleted by **RFC 8277**. Current normative reference should be RFC 8277 (or explicitly state historical RFC 3107, obsoleted by 8277).
- **Source:**
  - https://www.rfc-editor.org/info/rfc3107 (obsoleted by RFC 8277)
  - https://www.rfc-editor.org/info/rfc8277

### 9) Outdated RFC listed in further reading without obsolescence note
- **Severity:** minor
- **File:** `modules/07-l3vpn/7.3-inter-as-l3vpn-theory.md`
- **Line:** 151
- **Current text:** `RFC 3107 — Labeled unicast BGP. Required for Option C understanding.`
- **Correct RFC info:** Prefer RFC 8277 (which obsoletes RFC 3107), or annotate RFC 3107 as historical/obsoleted.
- **Source:**
  - https://www.rfc-editor.org/info/rfc3107
  - https://www.rfc-editor.org/info/rfc8277

### 10) Outdated RFC in answer-key sources without obsolescence note
- **Severity:** minor
- **File:** `modules/07-l3vpn/7.3-inter-as-l3vpn-answers.md`
- **Line:** 327
- **Current text:** `... RFC 3107 (Labeled Unicast) ...`
- **Correct RFC info:** Replace with RFC 8277, or explicitly mark RFC 3107 as obsoleted by RFC 8277.
- **Source:**
  - https://www.rfc-editor.org/info/rfc3107
  - https://www.rfc-editor.org/info/rfc8277

---

## Notes

- No fabricated numeric RFCs were found besides the non-existent `RFC 2547bis` label usage.
- Publication years checked in RFC tables (e.g., 4364/4659/4760/4684/4724/7911/8277) were otherwise consistent.
- Most shortened RFC titles appear to be informal abbreviations rather than semantic mis-citations; only materially wrong title/topic mapping (RFC 9012 ↔ BGP-CT) was flagged as critical.
