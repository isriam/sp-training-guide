# Module 04 — MPLS: Junos Syntax Review

**Reviewer**: Sentinel (Junos CLI Specialist)
**Date**: 2026-03-12
**Scope**: All 13 markdown files in `modules/04-mpls/`
**Verdict**: **8 issues found** (1 critical, 7 minor)

---

## Summary

Reviewed all Junos OS configuration statements and operational CLI commands across the module. The vast majority of Junos syntax is correct and well-formed — hierarchy paths, knob names, and show commands are accurate. Eight issues were identified: one critical (would fail on commit) and seven minor (wrong keywords, non-existent knobs, or incorrect operational commands that would produce CLI errors).

**Files with issues:**
| File | Issues |
|------|--------|
| 4.1-ldp-and-label-distribution.md | 1 minor |
| 4.1-ldp-and-label-distribution-answers.md | 1 minor |
| 4.2-rsvp-te-answers.md | 2 minor |
| 4.3-label-operations.md | 1 critical, 2 minor |
| 4.4-mpls-oam-and-troubleshooting.md | 1 minor |
| 4.4-mpls-oam-and-troubleshooting-answers.md | 1 minor |

**Clean files (no Junos issues):**
- 4.1-ldp-and-label-distribution-theory.md (no Junos config)
- 4.2-rsvp-te.md ✅
- 4.2-rsvp-te-theory.md (no Junos config)
- 4.3-label-operations-theory.md (no Junos config)
- 4.3-label-operations-answers.md ✅
- 4.4-mpls-oam-and-troubleshooting-theory.md (no Junos config)
- README.md (no Junos config)

---

## Issues

### 4.3-label-operations.md — Section "ECMP for MPLS LSPs" — Invalid LSP load-balance knob

- **Severity**: critical
- **Current text**: `set protocols mpls label-switched-path TO-PE5 load-balance per-flow`
- **Correction**: Remove this line. ECMP load balancing in Junos is configured via routing policy applied to the forwarding table, not per-LSP:
  ```junos
  set policy-options policy-statement ECMP then load-balance per-packet
  set routing-options forwarding-table export ECMP
  ```
  Note: Despite the name `per-packet`, modern Junos with flow-aware hashing performs per-flow balancing. There is no `load-balance` option under `protocols mpls label-switched-path` in Junos.
- **Source**: Juniper TechLibrary — [Configuring Load Balancing](https://www.juniper.net/documentation/us/en/software/junos/load-balance/topics/topic-map/load-balance-overview.html); `[edit protocols mpls label-switched-path]` hierarchy reference

---

### 4.1-ldp-and-label-distribution-answers.md — Answer 1 — Wrong LDP-IGP sync hierarchy

- **Severity**: minor
- **Current text**:
  ```
  # or globally:
  protocols ldp {
    igp-synchronization holddown-interval 30;
  }
  ```
- **Correction**: LDP-IGP synchronization in Junos is configured under the IGP protocol, not under `protocols ldp`. The correct global syntax is:
  ```junos
  set protocols isis ldp-synchronization hold-time 30
  ```
  The main config file (4.1-ldp-and-label-distribution.md) correctly shows this under IS-IS. The answer file contradicts it with a non-existent `protocols ldp` hierarchy.
- **Source**: Juniper TechLibrary — [Configuring LDP-IGP Synchronization](https://www.juniper.net/documentation/us/en/software/junos/mpls/topics/topic-map/ldp-igp-synchronization.html)

---

### 4.2-rsvp-te-answers.md — Answer 5 — Wrong keyword `administrative-group`

- **Severity**: minor
- **Current text**: `set protocols mpls interface ge-0/0/0.0 administrative-group MAINT`
- **Correction**: `set protocols mpls interface ge-0/0/0.0 admin-group MAINT`
  The correct Junos keyword is `admin-group`. The main config file (4.2-rsvp-te.md) correctly uses `admin-group` throughout. This answer file uses a different, non-canonical keyword that would fail on commit.
- **Source**: Juniper TechLibrary — [admin-group (Protocols MPLS)](https://www.juniper.net/documentation/us/en/software/junos/mpls/topics/ref/statement/admin-group-protocols-mpls.html)

---

### 4.2-rsvp-te-answers.md — Answer 5 — Non-existent `request mpls lsp reroute` command

- **Severity**: minor
- **Current text**: `request mpls lsp reroute name <lsp-name>`
- **Correction**: The correct Junos operational command to force LSP re-optimization/reroute is:
  ```
  clear mpls lsp name <lsp-name> optimize
  ```
  `request mpls lsp reroute` does not exist in the Junos CLI. The `clear mpls lsp optimize` command triggers make-before-break re-optimization.
- **Source**: Juniper TechLibrary — [clear mpls lsp](https://www.juniper.net/documentation/us/en/software/junos/mpls/topics/ref/command/clear-mpls-lsp.html)

---

### 4.3-label-operations.md — Section "ECMP Hashing for MPLS" — Questionable `payload ip` syntax

- **Severity**: minor
- **Current text**:
  ```junos
  set forwarding-options hash-key family mpls payload ip
  ```
- **Correction**: The `payload ip` sub-option is non-standard. Depending on platform and Junos version, the correct syntax is typically one of:
  ```junos
  # MX series (Memory-Enhanced FPCs):
  set forwarding-options enhanced-hash-key family mpls label-1-exp
  set forwarding-options enhanced-hash-key family mpls payload

  # Or standard hash-key:
  set forwarding-options hash-key family mpls payload
  ```
  The `ip` qualifier after `payload` is not a standard option. Use `payload` alone to include the IP header in the hash, or use the `enhanced-hash-key` hierarchy for finer control.
- **Source**: Juniper TechLibrary — [Configuring MPLS ECMP Hash](https://www.juniper.net/documentation/us/en/software/junos/load-balance/topics/topic-map/load-balance-mpls.html)

---

### 4.1-ldp-and-label-distribution.md — Section "Label Retention Policy" — Non-existent `label-retention-mode` knob

- **Severity**: minor
- **Current text**:
  ```junos
  # set protocols ldp label-retention-mode liberal
  ```
- **Correction**: This knob does not exist in Junos. Junos uses conservative label retention by default and does not expose a configuration option to switch to liberal retention. The behavior is architecturally baked in. Remove this line or replace the comment with:
  ```
  # Junos always uses conservative label retention (not configurable)
  # This is rarely a problem due to fast LDP convergence
  ```
  The comment text is acceptable since it says "only change if you need faster convergence," but the syntax itself is fabricated and would confuse anyone who tried to use it.
- **Source**: Juniper TechLibrary — [Understanding LDP](https://www.juniper.net/documentation/us/en/software/junos/mpls/topics/concept/mpls-ldp-overview.html)

---

### 4.4-mpls-oam-and-troubleshooting-answers.md — Answer 5 — Extraneous `fec` keyword in `ping mpls ldp`

- **Severity**: minor
- **Current text**:
  ```
  ping mpls ldp fec 10.0.0.5/32 size 1400 count 5 rapid
  ping mpls ldp fec 10.0.0.5/32 size 1472 count 5 rapid
  ```
- **Correction**: The `fec` keyword is not part of the standard `ping mpls ldp` syntax. The correct command is:
  ```
  ping mpls ldp 10.0.0.5/32 size 1400 count 5 rapid
  ping mpls ldp 10.0.0.5/32 size 1472 count 5 rapid
  ```
  The `ldp` keyword already implies an LDP FEC. The main config file (4.4-mpls-oam-and-troubleshooting.md) correctly uses the syntax without `fec`.
- **Source**: Juniper TechLibrary — [ping mpls ldp](https://www.juniper.net/documentation/us/en/software/junos/mpls/topics/ref/command/ping-mpls-ldp.html)

---

### 4.4-mpls-oam-and-troubleshooting.md — Section "RPM for MPLS" — Questionable `mpls-lsp-ping` probe type

- **Severity**: minor
- **Current text**:
  ```junos
  set services rpm probe MPLS-HEALTH test LSP-TO-PE5 probe-type mpls-lsp-ping
  ```
- **Correction**: `mpls-lsp-ping` is not a standard RPM probe type in Junos. Valid RPM probe types include `icmp-ping`, `icmp-ping-timestamp`, `tcp-ping`, `udp-ping`, `http-get`, `http-metadata-get`. For MPLS LSP monitoring, Junos uses operational commands (`ping mpls ldp`, `ping mpls rsvp`) or BFD-based LSP liveness detection — not RPM probes. If periodic testing is needed, consider:
  ```junos
  # Use event-options to schedule periodic MPLS ping
  set event-options generate-event MPLS-CHECK time-interval 30
  set event-options policy MPLS-MONITOR events MPLS-CHECK
  set event-options policy MPLS-MONITOR then execute-commands commands "ping mpls ldp 10.0.0.5/32 count 3"
  ```
- **Source**: Juniper TechLibrary — [RPM Probe Types](https://www.juniper.net/documentation/us/en/software/junos/flow-monitoring/topics/topic-map/real-time-performance-monitoring.html)

---

## Notes

- All Junos show commands in verification tables (`show ldp session`, `show ldp database`, `show mpls lsp`, `show rsvp session`, `show ted database`, `show route table mpls.0`, `show bfd session`, etc.) are syntactically correct.
- Junos configuration in 4.2-rsvp-te.md (RSVP-TE section) is clean — LSP definitions, path definitions, admin-groups, SRLG, link-protection hierarchy are all correct.
- The `set protocols rsvp interface ge-0/0/0.0 link-protection node-link-protection` hierarchy is correct — `node-link-protection` IS a child statement under `link-protection` in Junos.
- `set protocols ldp explicit-null`, `set protocols ldp deaggregate`, `set protocols ldp transport-address router-id`, `set protocols ldp track-igp-metric`, and `set protocols ldp egress-policy` are all valid Junos knobs.
- `set protocols ldp session-protection timeout 0` is valid (timeout 0 = infinite protection).
