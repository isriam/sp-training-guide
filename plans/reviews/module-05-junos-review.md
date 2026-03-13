# Module 05 — Junos Syntax Validation Review

**Reviewer**: Sentinel (Junos CLI Specialist)
**Date**: 2026-03-12
**Scope**: All Junos OS configuration and CLI commands in `/modules/05-te/`
**Files Checked**: 12 markdown files

## Summary

**14 Junos syntax issues found** — 12 critical (would fail on commit or produce wrong behavior), 2 minor (incorrect defaults documentation).

The worst cluster is in `5.2-rsvp-te-advanced.md` where the auto-bandwidth keywords are IOS-XE-style names mapped onto Junos hierarchy — none of the overflow/underflow keywords match actual Junos CLI. The soft preemption config is also under the wrong protocol stanza (`protocols mpls` instead of `protocols rsvp`). The flex-algo config in `5.3` uses a wrong hierarchy and a non-existent metric-type keyword.

Files with **zero Junos issues**: `5.1-te-fundamentals-theory.md`, `5.2-rsvp-te-advanced-theory.md`, `5.3-segment-routing-te-theory.md`, `5.4-te-deployment-and-design-answers.md`, `README.md`

---

## Critical Issues

### 5.2-rsvp-te-advanced.md — Section "Junos: Auto-Bandwidth" — Wrong keyword `adjust-threshold-percent`
- **Severity**: critical
- **Current text**: `set protocols mpls label-switched-path to-PE5 auto-bandwidth adjust-threshold-percent 10`
- **Correction**: `set protocols mpls label-switched-path to-PE5 auto-bandwidth adjust-threshold 10`
- **Source**: [Juniper TechLibrary — auto-bandwidth](https://www.juniper.net/documentation/us/en/software/junos/mpls/topics/ref/statement/auto-bandwidth-edit-protocols-mpls.html) — keyword is `adjust-threshold <percent>`, no `-percent` suffix exists

### 5.2-rsvp-te-advanced.md — Section "Junos: Auto-Bandwidth" — Wrong keyword `overflow-limit`
- **Severity**: critical
- **Current text**: `set protocols mpls label-switched-path to-PE5 auto-bandwidth overflow-limit 3`
- **Correction**: `set protocols mpls label-switched-path to-PE5 auto-bandwidth adjust-threshold-overflow-limit 3`
- **Source**: [Juniper TechLibrary — auto-bandwidth](https://www.juniper.net/documentation/us/en/software/junos/mpls/topics/ref/statement/auto-bandwidth-edit-protocols-mpls.html) — keyword is `adjust-threshold-overflow-limit`, not `overflow-limit`

### 5.2-rsvp-te-advanced.md — Section "Junos: Auto-Bandwidth" — Non-existent keyword `overflow-threshold-percent`
- **Severity**: critical
- **Current text**: `set protocols mpls label-switched-path to-PE5 auto-bandwidth overflow-threshold-percent 15`
- **Correction**: Remove this line entirely. Junos auto-bandwidth does NOT have a separate overflow threshold percentage. It reuses the `adjust-threshold` value. The `adjust-threshold-overflow-limit` controls the consecutive sample count.
- **Source**: [Juniper TechLibrary — auto-bandwidth](https://www.juniper.net/documentation/us/en/software/junos/mpls/topics/ref/statement/auto-bandwidth-edit-protocols-mpls.html) — no `overflow-threshold-percent` keyword exists in the hierarchy

### 5.2-rsvp-te-advanced.md — Section "Junos: Auto-Bandwidth" — Wrong keyword `underflow-limit`
- **Severity**: critical
- **Current text**: `set protocols mpls label-switched-path to-PE5 auto-bandwidth underflow-limit 5`
- **Correction**: `set protocols mpls label-switched-path to-PE5 auto-bandwidth adjust-threshold-underflow-limit 5`
- **Source**: [Juniper TechLibrary — auto-bandwidth](https://www.juniper.net/documentation/us/en/software/junos/mpls/topics/ref/statement/auto-bandwidth-edit-protocols-mpls.html) — keyword is `adjust-threshold-underflow-limit`

### 5.2-rsvp-te-advanced.md — Section "Junos: Auto-Bandwidth" — Non-existent keyword `underflow-threshold-percent`
- **Severity**: critical
- **Current text**: `set protocols mpls label-switched-path to-PE5 auto-bandwidth underflow-threshold-percent 20`
- **Correction**: Remove this line. Same as overflow — Junos has no separate underflow threshold percentage.
- **Source**: [Juniper TechLibrary — auto-bandwidth](https://www.juniper.net/documentation/us/en/software/junos/mpls/topics/ref/statement/auto-bandwidth-edit-protocols-mpls.html)

### 5.2-rsvp-te-advanced.md — Section "Junos: Soft Preemption" — Wrong protocol stanza for cleanup timer
- **Severity**: critical
- **Current text**: `set protocols mpls soft-preemption cleanup-timer 60`
- **Correction**: `set protocols rsvp preemption soft-preemption cleanup-timer 60`
- **Source**: [Juniper TechLibrary — soft-preemption (Protocols RSVP)](https://www.juniper.net/documentation/us/en/software/junos/cli-reference/topics/ref/statement/soft-preemption-edit-protocols-rsvp.html) — soft-preemption is under `[edit protocols rsvp preemption]`, not `[edit protocols mpls]`

### 5.2-rsvp-te-advanced.md — Section "Junos: Soft Preemption" — Per-LSP soft-preemption not a valid MPLS knob
- **Severity**: critical
- **Current text**: `set protocols mpls label-switched-path to-PE5 soft-preemption`
- **Correction**: `set protocols rsvp preemption soft-preemption` (global RSVP setting). Soft preemption in Junos is configured globally under `[edit protocols rsvp preemption]`, not per-LSP under `[edit protocols mpls label-switched-path]`.
- **Source**: [Juniper TechLibrary — preemption](https://www.juniper.net/documentation/us/en/software/junos/mpls/topics/ref/statement/preemption-edit-protocols-rsvp.html) — hierarchy: `preemption { soft-preemption { cleanup-timer; } } [edit protocols rsvp]`

### 5.2-rsvp-te-advanced-answers.md — Q1 Answer — Wrong keyword `overflow-limit`
- **Severity**: critical
- **Current text**: `set protocols mpls label-switched-path Tunnel100 auto-bandwidth overflow-limit 3`
- **Correction**: `set protocols mpls label-switched-path Tunnel100 auto-bandwidth adjust-threshold-overflow-limit 3`
- **Source**: Same as above — keyword is `adjust-threshold-overflow-limit`

### 5.2-rsvp-te-advanced-answers.md — Q1 Answer — `adjust-threshold-overflow-limit` used as percentage
- **Severity**: critical
- **Current text**: `set protocols mpls label-switched-path Tunnel100 auto-bandwidth adjust-threshold-overflow-limit 15`
- **Correction**: This keyword takes a **count** (number of consecutive overflow samples before triggering immediate adjustment), NOT a percentage. The text says "overflow threshold of 15%" but `adjust-threshold-overflow-limit 15` means "15 consecutive samples", which is semantically wrong. To set the overflow trigger at 3 consecutive samples: `adjust-threshold-overflow-limit 3`. The overflow percentage threshold IS the `adjust-threshold` value itself.
- **Source**: [Juniper TechLibrary — adjust-threshold-overflow-limit](https://www.juniper.net/documentation/us/en/software/junos/mpls/topics/ref/statement/auto-bandwidth-edit-protocols-mpls.html)

### 5.2-rsvp-te-advanced-answers.md — Q3 Answer — Wrong keyword `soft` instead of `soft-preemption`
- **Severity**: critical
- **Current text**: `set protocols rsvp preemption soft cleanup-timer 120`
- **Correction**: `set protocols rsvp preemption soft-preemption cleanup-timer 120`
- **Source**: [Juniper TechLibrary — preemption](https://www.juniper.net/documentation/us/en/software/junos/mpls/topics/ref/statement/preemption-edit-protocols-rsvp.html) — valid children of `preemption` are: `aggressive`, `disabled`, `normal`, `soft-preemption { }`. The keyword `soft` (without `-preemption`) does not exist.

### 5.1-te-fundamentals-answers.md — Q4 Answer — Wrong keyword `auto-policing` for auto-mesh
- **Severity**: critical
- **Current text**: `Junos:  set protocols mpls auto-policing / mesh-group`
- **Correction**: `Junos:  set protocols mpls mesh-group <name>` — `auto-policing` is an entirely different Junos feature (automatic policer application). The Junos auto-mesh feature is `mesh-group`.
- **Source**: [Juniper TechLibrary — mesh-group](https://www.juniper.net/documentation/us/en/software/junos/mpls/topics/ref/statement/mesh-group-edit-protocols-mpls.html)

### 5.3-segment-routing-te.md — Section "Junos: Flex-Algo" — Wrong metric-type keyword and wrong hierarchy
- **Severity**: critical
- **Current text**:
  ```
  set protocols isis source-packet-routing flex-algorithm 128 definition metric-type min-unidirectional-delay
  set protocols isis source-packet-routing flex-algorithm 128 definition admin-group exclude submarine
  ```
- **Correction**:
  ```
  set routing-options flex-algorithm 128 definition metric-type delay-metric
  set routing-options flex-algorithm 128 definition admin-group exclude submarine
  ```
- **Source**: [Juniper TechLibrary — Flex-Algo Definition](https://www.juniper.net/documentation/us/en/software/junos/cli-reference/topics/ref/statement/definition-edit-routing-options-flex-algorithm.html) and [Configuring Flex-Algo](https://www.juniper.net/documentation/us/en/software/junos/is-is/segment-routing/topics/task/isis-configuring-flex-algo-sr.html):
  - Hierarchy is `[edit routing-options flex-algorithm <id> definition]`, not under `protocols isis`
  - Valid metric-type values: `delay-metric | igp-metric | te-metric` — `min-unidirectional-delay` does not exist

---

## Minor Issues

### 5.2-rsvp-te-advanced.md — Key Knobs Table — Junos RSVP refresh defaults wrong
- **Severity**: minor
- **Current text**: Table shows Junos defaults as "Enabled" for both "RSVP summary refresh" and "RSVP refresh reduction"
- **Correction**: Both are **disabled** by default in Junos. Must be explicitly enabled with `set protocols rsvp interface <name> aggregate` (summary refresh) and `set protocols rsvp interface <name> reliable` (refresh reduction). Note: the same parameter in the 5.4 Key Knobs table correctly shows Junos default as "Disabled".
- **Source**: Juniper TechLibrary RSVP interface configuration; also self-contradicted by the 5.4-te-deployment-and-design.md table which correctly states "Disabled" for Junos

### 5.3-segment-routing-te.md — Section "Junos: Flex-Algo" — Flex-algo participation config under wrong hierarchy
- **Severity**: minor
- **Current text**: `set protocols isis source-packet-routing flex-algorithm 128`
- **Correction**: Flex-algo participation and advertising in IS-IS may use `protocols isis source-packet-routing` for the participation flag, but the definition (metric-type, admin-groups) must be under `routing-options flex-algorithm`. The study guide conflates both under `protocols isis source-packet-routing`. Split accordingly.
- **Source**: [Juniper TechLibrary — Flex-Algo in IS-IS](https://www.juniper.net/documentation/us/en/software/junos/is-is/topics/topic-map/infocus-isis-flex-algo-sr.html)

---

## Files Verified Clean (Junos syntax)

| File | Junos Config Present | Status |
|------|---------------------|--------|
| `5.1-te-fundamentals.md` | Yes — LSP, admin-group, path, te-metric, show commands | ✅ Clean |
| `5.1-te-fundamentals-theory.md` | No Junos config | ✅ N/A |
| `5.1-te-fundamentals-answers.md` | Yes — te-metric, show commands | ⚠️ 1 issue (auto-policing) |
| `5.2-rsvp-te-advanced.md` | Yes — auto-BW, soft preemption, SRLG, reopt | ❌ 7 issues |
| `5.2-rsvp-te-advanced-theory.md` | No Junos config | ✅ N/A |
| `5.2-rsvp-te-advanced-answers.md` | Yes — auto-BW, soft preemption | ❌ 3 issues |
| `5.3-segment-routing-te.md` | Yes — SR-TE, PCEP, flex-algo | ⚠️ 2 issues (flex-algo) |
| `5.3-segment-routing-te-theory.md` | No Junos config | ✅ N/A |
| `5.3-segment-routing-te-answers.md` | Yes — show commands, verification | ✅ Clean |
| `5.4-te-deployment-and-design.md` | Yes — LDPoRSVP, FRR, RSVP tuning | ✅ Clean |
| `5.4-te-deployment-and-design-answers.md` | Yes — BFD, FRR | ✅ Clean |
| `README.md` | No config | ✅ N/A |

---

## Corrected Auto-Bandwidth Block (for reference)

The complete corrected Junos auto-bandwidth config should read:

```junos
set protocols mpls label-switched-path to-PE5 to 10.0.0.5
set protocols mpls label-switched-path to-PE5 bandwidth 500m
set protocols mpls label-switched-path to-PE5 auto-bandwidth
set protocols mpls label-switched-path to-PE5 auto-bandwidth adjust-interval 86400
set protocols mpls label-switched-path to-PE5 auto-bandwidth minimum-bandwidth 100m
set protocols mpls label-switched-path to-PE5 auto-bandwidth maximum-bandwidth 5g
set protocols mpls label-switched-path to-PE5 auto-bandwidth adjust-threshold 10
set protocols mpls label-switched-path to-PE5 auto-bandwidth adjust-threshold-overflow-limit 3
set protocols mpls label-switched-path to-PE5 auto-bandwidth adjust-threshold-underflow-limit 5
set protocols mpls label-switched-path to-PE5 auto-bandwidth monitor-bandwidth
```

Note: Junos auto-bandwidth does not support separate overflow/underflow threshold *percentages*. The `adjust-threshold` value is used for all threshold comparisons. The `adjust-threshold-overflow-limit` and `adjust-threshold-underflow-limit` control the number of consecutive samples that must exceed the threshold before triggering an immediate adjustment.

## Corrected Soft Preemption Block (for reference)

```junos
# Global soft preemption (under RSVP, not MPLS)
set protocols rsvp preemption soft-preemption cleanup-timer 60
```

## Corrected Flex-Algo Block (for reference)

```junos
# Define flex-algo (under routing-options, not isis)
set routing-options flex-algorithm 128 definition metric-type delay-metric
set routing-options flex-algorithm 128 definition admin-group exclude submarine

# Participate in flex-algo and assign prefix-SID (under isis)
set protocols isis source-packet-routing flex-algorithm 128
set protocols isis source-packet-routing node-segment ipv4-index 1 algorithm 128 index 128001
```
