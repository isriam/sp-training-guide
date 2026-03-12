# Module 02 — Junos Syntax Review

**Reviewer**: Sentinel (Junos CLI Specialist)
**Date**: 2026-03-12
**Scope**: All markdown files in `modules/02-igp/`
**Focus**: Junos OS configuration syntax and CLI commands ONLY

---

## Summary

**3 distinct Junos syntax issues found across 5 instances in 2 files.**

| Severity | Count | Files Affected |
|----------|-------|----------------|
| Critical | 3 issues (5 instances) | `2.3-igp-convergence-tuning.md`, `2.1-isis-deep-dive.md` |
| Minor | 0 | — |

The majority of Junos configuration and show commands across all 12 files are **syntactically correct**. The IS-IS base config (2.1), OSPF configs (2.2), TI-LFA/backup-spf-options (2.3), and all show command tables validate clean against Juniper TechLibrary. The issues below are concentrated in SPF timer configuration and overload syntax in the convergence tuning section.

---

## Files Reviewed

| File | Junos Content | Status |
|------|--------------|--------|
| `2.1-isis-deep-dive.md` | IS-IS config block, show command table, overload/prefix-priority references | ⚠️ 1 issue |
| `2.1-isis-deep-dive-theory.md` | No Junos config blocks (pure protocol theory) | ✅ Clean |
| `2.1-isis-deep-dive-answers.md` | Show commands, overload options (`advertise-high-metrics`, `allow-route-leaking`) | ✅ Clean |
| `2.2-ospf-in-sp-networks.md` | OSPF config blocks, NSSA/area-range, BFD, LFA, show commands | ✅ Clean |
| `2.2-ospf-in-sp-networks-theory.md` | No Junos config blocks (pure protocol theory) | ✅ Clean |
| `2.2-ospf-in-sp-networks-answers.md` | Preference values, migration strategy references | ✅ Clean |
| `2.3-igp-convergence-tuning.md` | SPF timers, TI-LFA config, complete IS-IS config block | ⚠️ 2 issues (4 instances) |
| `2.3-igp-convergence-tuning-theory.md` | No Junos config blocks (pure protocol theory) | ✅ Clean |
| `2.3-igp-convergence-tuning-answers.md` | SPF timer references, show commands | ✅ Clean |
| `2.4-isis-vs-ospf-decision-framework.md` | Ships-in-the-night config, preference knob | ✅ Clean |
| `2.4-isis-vs-ospf-decision-framework-answers.md` | Show commands, preference references | ✅ Clean |
| `README.md` | No Junos content | ✅ N/A |

---

## Issues

### 2.3-igp-convergence-tuning.md — Section "SPF Throttling" — Invalid `overload-timeout` keyword

- **Severity**: critical
- **Current text**:
  ```
  IS-IS (Junos):
    protocols isis {
        spf-delay 50;
        overload-timeout 60;
    }
  ```
- **Correction**: The hyphenated keyword `overload-timeout` does not exist in Junos. `overload` is a container statement with `timeout` as a child option:
  ```
  protocols isis {
      spf-options {
          delay 50;
      }
      overload {
          timeout 60;
      }
  }
  ```
- **Source**: [Juniper TechLibrary — overload (Protocols IS-IS)](https://www.juniper.net/documentation/us/en/software/junos/cli-reference/topics/ref/statement/overload-edit-protocols-isis.html) — syntax is `overload { timeout seconds; }` at `[edit protocols isis]`

---

### 2.3-igp-convergence-tuning.md — Section "Complete Convergence-Optimized IS-IS (Junos)" — Same `overload-timeout` issue

- **Severity**: critical
- **Current text**:
  ```junos
  protocols {
      isis {
          level 1 disable;
          lsp-lifetime 65535;
          spf-delay 50;
          overload-timeout 60;
          ...
      }
  }
  ```
- **Correction**: Same fix — replace `overload-timeout 60;` with `overload { timeout 60; }` in this config block:
  ```junos
  protocols {
      isis {
          level 1 disable;
          lsp-lifetime 65535;
          spf-options {
              delay 50;
          }
          overload {
              timeout 60;
          }
          ...
      }
  }
  ```
- **Source**: Same as above

---

### 2.3-igp-convergence-tuning.md — Section "SPF Throttling" — Invalid `spf-delay` keyword

- **Severity**: critical
- **Current text**:
  ```
  IS-IS (Junos):
    protocols isis {
        spf-delay 50;
        overload-timeout 60;
    }
  ```
- **Correction**: `spf-delay` does not exist as a keyword under `[edit protocols isis]`. The correct Junos hierarchy for IS-IS SPF timing is `spf-options { delay <ms>; holddown <ms>; rapid-runs <n>; }`:
  ```
  protocols isis {
      spf-options {
          delay 50;
          holddown 100;
          rapid-runs 3;
      }
  }
  ```
- **Source**: [Juniper TechLibrary — spf-options (Protocols IS-IS)](https://www.juniper.net/documentation/us/en/software/junos/cli-reference/topics/ref/statement/spf-options-edit-protocols-isis.html) — only `spf-options` container exists; no standalone `spf-delay` keyword. Default delay is 200ms, configurable range 50–1000ms.

> **Note**: This same `spf-delay 50` error also appears in the "Complete Convergence-Optimized IS-IS (Junos)" config block later in the same file.

---

### 2.1-isis-deep-dive.md — Section "Prefix Prioritization" — Non-existent Junos feature reference

- **Severity**: critical
- **Current text**: "Junos: `spf-options priority` under `protocols isis`"
- **Correction**: Junos IS-IS does **not** have a `priority` keyword under `spf-options`. The IS-IS `spf-options` statement only accepts `delay`, `holddown`, and `rapid-runs`. There is no direct Junos IS-IS equivalent of IOS-XR's `spf prefix-priority`. Junos handles prefix prioritization at the RPD infrastructure level via `policy-options` route priority, not within the IS-IS protocol configuration. The bullet should either reference the correct Junos mechanism or note that no direct IS-IS knob exists:
  ```
  Junos: No direct IS-IS CLI equivalent; prefix priority is handled
         at the RPD infrastructure level (policy-options prefix-priority)
  ```
- **Source**: [Juniper TechLibrary — spf-options (Protocols IS-IS)](https://www.juniper.net/documentation/us/en/software/junos/cli-reference/topics/ref/statement/spf-options-edit-protocols-isis.html) — `spf-options` only contains `delay`, `holddown`, `rapid-runs`. Also: [Juniper TechLibrary — Configuring Priority for Route Prefixes in RPD](https://www.juniper.net/documentation/us/en/software/junos/routing-policy/topics/example/example-configuring-priority-policy-options.html) for the actual Junos prefix priority mechanism.

---

## Verified Clean — Notable Junos Syntax Confirmed Correct

The following Junos-specific syntax was validated and is correct:

**2.1 — IS-IS Deep Dive:**
- `level 1 disable` ✅
- `source-packet-routing { node-segment ipv4-index; srgb start-label index-range; }` ✅
- `bfd-liveness-detection { minimum-interval; multiplier; }` ✅
- `point-to-point` under IS-IS interface ✅
- `overload { advertise-high-metrics; allow-route-leaking; }` (in answers) ✅
- All show commands: `show isis adjacency`, `show isis database`, `show isis database extensive`, `show isis spf results`, `show isis route`, `show isis statistics`, `show isis interface` ✅

**2.2 — OSPF in SP Networks:**
- `interface-type p2p` ✅
- `area 0.0.0.10 { nssa { default-lsa default-metric 100; area-range ... ; } }` ✅
- `area-range ... restrict` for suppression ✅
- `spf-options { delay; holddown; rapid-runs; }` under OSPF ✅
- `backup-spf-options { remote-backup-calculation; }` ✅
- `node-link-protection` under OSPF interface ✅
- `reference-bandwidth 1t` ✅
- `show ospf route abr` ✅ (confirmed valid filter)
- All other OSPF show commands ✅

**2.3 — Convergence Tuning:**
- `backup-spf-options { use-post-convergence-lfa; use-source-packet-routing; }` ✅
- `node-link-protection` under IS-IS interface ✅
- `lsp-lifetime 65535` ✅
- TI-LFA config pattern ✅
- Show commands: `show isis spf log`, `show isis backup coverage`, `show bfd session`, `show route forwarding-table` ✅

**2.4 — Decision Framework:**
- `preference 9` under `protocols isis` ✅
- Junos preference values (IS-IS L1=15, L2=18, OSPF internal=10) ✅
- Ships-in-the-night config pattern ✅
