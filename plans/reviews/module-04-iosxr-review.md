# Module 04 — IOS-XR Syntax Review

**Reviewer:** Sentinel (IOS-XR CLI Specialist)
**Date:** 2026-03-12
**Scope:** All markdown files in `modules/04-mpls/`
**Focus:** IOS-XR configuration syntax, show commands, operational commands, platform attribution

---

## Summary

**9 issues found** across 5 files — **4 critical**, **5 minor**.

The most pervasive error is `show mpls forwarding-table` attributed to IOS-XR. This is an IOS-XE command. IOS-XR uses `show mpls forwarding` (no `-table` suffix). This appears in 3 files and would fail on any XR box. A scaling table in 4.1 also misattributes the ASR 1000 (IOS-XE platform) to IOS-XR. One answer file uses wrong IOS-XR syntax for TTL propagation disable.

Configuration blocks in 4.1 (the primary IOS-XR config file) are clean — the `mpls ldp` hierarchy, label allocation, session protection, graceful restart, timers, and interface enablement are all valid IOS-XR syntax. Answer files have more issues because they casually label things "IOS-XE/XR" while using IOS-XE-only syntax.

**Files verified clean (no IOS-XR syntax):**
- `4.2-rsvp-te.md` — All config labeled IOS-XE ✓
- `4.2-rsvp-te-theory.md` — Theory only, no config ✓
- `4.2-rsvp-te-answers.md` — All config labeled IOS-XE ✓
- `4.3-label-operations-theory.md` — Theory only, no config ✓
- `4.4-mpls-oam-and-troubleshooting-theory.md` — Theory only, no config ✓
- `4.1-ldp-and-label-distribution-theory.md` — Theory only, no config ✓
- `README.md` — No config ✓

**Files verified clean (IOS-XR config present and correct):**
- `4.1-ldp-and-label-distribution.md` — IOS-XR config block is valid ✓ (show commands table has issues, see below)
- `4.3-label-operations.md` — Config labeled IOS-XE ✓ (no IOS-XR config)
- `4.4-mpls-oam-and-troubleshooting.md` — Config labeled IOS-XE ✓ (no IOS-XR config)

---

## Issues

### 4.1-ldp-and-label-distribution.md — Show Commands Table — `show mpls forwarding-table` is IOS-XE, not IOS-XR
- **Severity**: critical
- **Current text**: `show mpls forwarding-table` (in the Verification table under the "IOS-XR" column header)
- **Correction**: `show mpls forwarding` — IOS-XR dropped the `-table` suffix. The full prefix-specific form is `show mpls forwarding prefix 10.0.0.5/32` (not `show mpls forwarding-table 10.0.0.5/32`).
- **Source**: Cisco IOS-XR MPLS Command Reference — `show mpls forwarding` command

### 4.1-ldp-and-label-distribution.md — Show Commands Table — `show mpls ldp bindings` prefix format
- **Severity**: minor
- **Current text**: `show mpls ldp bindings 10.0.0.5 32` (space between address and mask length, in "IOS-XR" column)
- **Correction**: `show mpls ldp bindings 10.0.0.5/32` — IOS-XR uses CIDR slash notation for prefix arguments, not the space-separated format used by IOS-XE.
- **Source**: Cisco IOS-XR MPLS Command Reference — `show mpls ldp bindings` command

### 4.1-ldp-and-label-distribution.md — Scaling Table — ASR 1000 listed under "Cisco IOS-XR"
- **Severity**: critical
- **Current text**: Table column header "Cisco IOS-XR" contains rows referencing "ASR 1000: ~500 sessions" and "ASR 1000: ~1M labels"
- **Correction**: The ASR 1000 runs **IOS-XE**, not IOS-XR. IOS-XR platforms include ASR 9000, NCS 5500, NCS 540, NCS 5700, and XRv 9000. Replace "ASR 1000" references with appropriate IOS-XR platforms (e.g., "NCS 5500: ~500 sessions" or "ASR 9000: ~2000 sessions"). Alternatively, change column header to "Cisco IOS-XE / IOS-XR" and clearly label which platform is which.
- **Source**: Cisco ASR 1000 runs IOS-XE; Cisco ASR 9000/NCS 5500 run IOS-XR

### 4.1-ldp-and-label-distribution-answers.md — Q5 Answer — Targeted LDP neighbor hierarchy
- **Severity**: minor
- **Current text**:
  ```
  mpls ldp
      router-id 10.0.0.1
      neighbor 10.0.0.5
        targeted
  ```
  (labeled "IOS-XR")
- **Correction**: On IOS-XR, targeted LDP neighbors are configured under the address-family context:
  ```
  mpls ldp
   router-id 10.0.0.1
   address-family ipv4
    neighbor 10.0.0.5 targeted
  ```
  The `neighbor` subcommand directly under `mpls ldp` (without address-family) is used for password configuration, not for targeted hello.
- **Source**: Cisco IOS-XR MPLS Configuration Guide — Configuring Targeted LDP Sessions

### 4.1-ldp-and-label-distribution-answers.md — Q2 Answer — ACL `deny` syntax
- **Severity**: minor
- **Current text**: `20 deny 0.0.0.0/0 any` (in an ipv4 access-list, labeled "IOS-XR")
- **Correction**: The trailing `any` creates an extended ACL entry (source + destination). For LDP label allocation filtering which matches on prefix, use either `20 deny any any` (extended ACL matching any source, any destination — though this is semantically odd for prefix matching) or simply `20 deny any`. The cleanest IOS-XR approach for this use case is a prefix-set rather than an ACL.
- **Source**: Cisco IOS-XR IP Addresses and Services Command Reference — `ipv4 access-list`

### 4.3-label-operations-answers.md — Q1 Answer — TTL propagation disable command
- **Severity**: critical
- **Current text**: `mpls ip propagate-ttl forwarded disable` (labeled "IOS-XE / IOS-XR")
- **Correction**: This syntax is invalid on both platforms.
  - **IOS-XE**: `no mpls ip propagate-ttl forwarded`
  - **IOS-XR**: `mpls ip-ttl-propagate disable forwarded`
  Note the hyphenated `ip-ttl-propagate` keyword on IOS-XR vs the space-separated `ip propagate-ttl` on IOS-XE.
- **Source**: Cisco IOS-XR MPLS Command Reference — `mpls ip-ttl-propagate` command

### 4.3-label-operations-answers.md — Q4 Answer — Explicit NULL configuration
- **Severity**: minor
- **Current text**: `mpls ldp explicit-null` (labeled "IOS-XE/XR")
- **Correction**: On IOS-XR, `explicit-null` is configured under the LDP address-family hierarchy:
  ```
  mpls ldp
   address-family ipv4
    explicit-null
  ```
  The flat `mpls ldp explicit-null` form is IOS-XE only. On IOS-XR, entering `mpls ldp explicit-null` at the `mpls ldp` level will fail because `explicit-null` is not a valid subcommand at that hierarchy level.
- **Source**: Cisco IOS-XR MPLS Configuration Guide — Configuring LDP Explicit NULL

### 4.4-mpls-oam-and-troubleshooting-answers.md — Q1, Q2, Q5 — `show mpls forwarding-table` labeled "IOS-XE/XR"
- **Severity**: critical
- **Current text**: Multiple instances of `show mpls forwarding-table` and `show mpls forwarding-table <prefix>` labeled as "IOS-XE/XR" commands in answers to questions 1, 2, and 5.
  - Q1: `show mpls forwarding-table 10.0.0.5 32`
  - Q2: `show mpls forwarding-table 10.0.0.5 32 detail` and `show mpls forwarding-table labels <incoming-label>`
  - Q5: `show mpls forwarding-table <customer-prefix>`
- **Correction**: Split the label. IOS-XE uses `show mpls forwarding-table`. IOS-XR uses `show mpls forwarding`. The IOS-XR equivalents are:
  - `show mpls forwarding prefix 10.0.0.5/32`
  - `show mpls forwarding prefix 10.0.0.5/32 detail`
  - `show mpls forwarding labels <label>`
  - `show mpls forwarding prefix <customer-prefix>`
  Also note IOS-XR uses CIDR notation (`10.0.0.5/32`), not space-separated (`10.0.0.5 32`).
- **Source**: Cisco IOS-XR MPLS Command Reference — `show mpls forwarding` command

### 4.2-rsvp-te.md — Scaling Table — ASR 9000 listed under "Cisco IOS-XE"
- **Severity**: minor
- **Current text**: Table column header "Cisco IOS-XE" contains "ASR 9000: ~20,000+" in the Max RSVP-TE LSPs row
- **Correction**: ASR 9000 runs IOS-XR, not IOS-XE. Either split the column into separate IOS-XE and IOS-XR columns, or relabel the column to "Cisco (IOS-XE / IOS-XR)" and annotate which platform is which.
- **Source**: Cisco ASR 9000 Series runs IOS-XR; ASR 1000 Series runs IOS-XE

---

## Verified Clean — IOS-XR Configuration Block (4.1)

The primary IOS-XR configuration in `4.1-ldp-and-label-distribution.md` was validated line-by-line. The following are all correct:

| Command | Verdict |
|---------|---------|
| `mpls ldp` | ✅ Valid router config mode entry |
| `router-id 10.0.0.1` | ✅ Valid under `mpls ldp` |
| `address-family ipv4` → `label` → `local` → `allocate for host-routes` | ✅ Valid hierarchy |
| `igp sync delay on-session-up 10` | ✅ Valid under `mpls ldp` |
| `session protection duration infinite` | ✅ Valid under `mpls ldp` |
| `graceful-restart` | ✅ Valid under `mpls ldp` |
| `address-family ipv4` → `discovery targeted-hello accept` | ✅ Valid |
| `neighbor 10.0.0.2` → `password encrypted MPLS-LDP-KEY-2026` | ✅ Valid for LDP MD5 auth |
| `discovery hello interval 5` | ✅ Valid under `mpls ldp` |
| `discovery hello holdtime 15` | ✅ Valid under `mpls ldp` |
| `holdtime 180` | ✅ Valid under `mpls ldp` |
| `interface GigabitEthernet0/0/0/0` | ✅ Valid IOS-XR interface naming |
| `interface GigabitEthernet0/0/0/1` | ✅ Valid IOS-XR interface naming |

All IOS-XR show commands in the table (except `show mpls forwarding-table` and the prefix format issue) are valid:
- `show mpls ldp neighbor [detail]` ✅
- `show mpls ldp discovery` ✅
- `show mpls ldp igp sync` ✅
- `show mpls ldp parameters` ✅
- `show mpls ldp neighbor 10.0.0.2 detail` ✅
