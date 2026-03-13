# Module 05 — IOS-XR Syntax Review

**Reviewer**: IOS-XR CLI Specialist (Sentinel subagent)
**Date**: 2026-03-12
**Scope**: All markdown files in `modules/05-te/`
**Focus**: IOS-XR configuration syntax, show commands, operational commands only

---

## Summary

**3 IOS-XR syntax issues found** across 12 files reviewed.

IOS-XR content in this module is **minimal** — the vast majority of configuration examples are labeled **IOS-XE** and **Junos**. IOS-XR-specific syntax appears only in:
- `5.3-segment-routing-te-answers.md` (8 explicit IOS-XR references)
- `5.3-segment-routing-te.md` (1 passing note about IOS-XR PCE hierarchy)
- `5.1-te-fundamentals.md` (1 factual mention of IOS-XE/XR CSPF tie-breaking)

Of the 8 explicit IOS-XR commands/configs in the answers file, **5 are correct** and **3 have issues** (2 critical, 1 minor).

### Verified Clean IOS-XR Syntax

| File | Line | Command/Config | Status |
|------|------|----------------|--------|
| 5.3-segment-routing-te-answers.md | 12 | `show bgp vpnv4 unicast <prefix> detail` | ✅ Valid |
| 5.3-segment-routing-te-answers.md | 26 | `show segment-routing traffic-eng policy color 100 endpoint ipv4 10.0.0.5` | ✅ Valid |
| 5.3-segment-routing-te-answers.md | 38-47 | `segment-routing traffic-eng / on-demand color 100 / dynamic / pcep` | ✅ Valid |
| 5.3-segment-routing-te-answers.md | 123 | `show isis database detail <node-id> \| include MSD` | ✅ Valid |
| 5.3-segment-routing-te-answers.md | 272 | `show isis flex-algo 128` | ✅ Valid |

---

## Issues

### 5.3-segment-routing-te-answers.md — Line 142 — Wrong `traceroute` Command Keyword

- **Severity**: critical
- **Current text**: `IOS-XR: traceroute segment-routing mpls policy name <policy>`
- **Correction**: `traceroute sr-mpls <endpoint-ip> policy name <policy-name>`
- **Source**: Cisco IOS-XR Segment Routing Command Reference (XR 7.x). The base command is `traceroute sr-mpls`, not `traceroute segment-routing mpls`. The `segment-routing` keyword is used in configuration mode (`segment-routing traffic-eng`), but the operational traceroute command uses the abbreviated `sr-mpls` form. Running `traceroute segment-routing` would produce an unrecognized command error.

---

### 5.3-segment-routing-te-answers.md — Lines 177-181 — Wrong Config Hierarchy and Keyword for MSD

- **Severity**: critical
- **Current text**:
  ```
  IOS-XR:
    segment-routing traffic-eng
     pce
      segment-routing
       max-sid-depth 6
  ```
- **Correction**:
  ```
  segment-routing traffic-eng
   maximum-sid-depth 6
  ```
- **Source**: Cisco IOS-XR Segment Routing Configuration Guide (XR 7.x). Two errors here: (1) There is no `segment-routing` sub-mode under `pce` — the `pce` stanza only contains `peer`, `logging`, `timers`, etc. (2) The keyword is `maximum-sid-depth`, not `max-sid-depth`. MSD is configured at the top level of `segment-routing traffic-eng`, not nested under `pce`. This config block would fail on commit at the `segment-routing` line under `pce`.

---

### 5.3-segment-routing-te-answers.md — Line 133 — Invalid `show mpls forwarding drop` Command

- **Severity**: minor
- **Current text**: `IOS-XR: show mpls forwarding drop`
- **Correction**: `show cef drops location <loc>` or `show controllers np counters all location <loc> | include drop` (the latter is already shown on the next line in the file)
- **Source**: Cisco IOS-XR MPLS Command Reference. The `show mpls forwarding` command in IOS-XR accepts `labels`, `prefix`, `detail`, `location`, etc. — but not a `drop` keyword. MPLS forwarding drops on IOS-XR are surfaced via `show cef drops` (generic) or `show controllers np counters` (NP-specific on ASR 9000/NCS). The file already provides the `show controllers np counters` alternative on the very next line, so the practical impact is low — but the `show mpls forwarding drop` command itself would return an error.

---

## Files Reviewed

| # | File | IOS-XR Content | Issues |
|---|------|----------------|--------|
| 1 | 5.1-te-fundamentals.md | 1 passing mention (CSPF tie-breaking) | 0 |
| 2 | 5.1-te-fundamentals-answers.md | None (IOS-XE/Junos only) | 0 |
| 3 | 5.1-te-fundamentals-theory.md | None (pure theory) | 0 |
| 4 | 5.2-rsvp-te-advanced.md | None (IOS-XE/Junos only) | 0 |
| 5 | 5.2-rsvp-te-advanced-answers.md | None (IOS-XE/Junos only) | 0 |
| 6 | 5.2-rsvp-te-advanced-theory.md | None (pure theory) | 0 |
| 7 | 5.3-segment-routing-te.md | 1 note about IOS-XR PCE hierarchy | 0 |
| 8 | 5.3-segment-routing-te-answers.md | 8 explicit IOS-XR references | **3** |
| 9 | 5.3-segment-routing-te-theory.md | None (pure theory) | 0 |
| 10 | 5.4-te-deployment-and-design.md | None (IOS-XE/Junos only) | 0 |
| 11 | 5.4-te-deployment-and-design-answers.md | None (IOS-XE/Junos only) | 0 |
| 12 | README.md | None | 0 |

---

## Observation

Module 05 is overwhelmingly IOS-XE + Junos. For an SP study guide targeting CCIE-SP / JNCIE-SP, the near-total absence of IOS-XR configuration is notable — IOS-XR is the platform running on ASR 9000, NCS 5500/5700, and NCS 540/560, which are the dominant SP router platforms. Sections 5.1, 5.2, and 5.4 have zero IOS-XR config blocks. This is not a syntax error but a coverage gap worth flagging.
