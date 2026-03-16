# Module 02 — IOS-XR Syntax Review

**Reviewer**: Sentinel (IOS-XR CLI Specialist)
**Date**: 2026-03-12
**Scope**: All markdown files in `modules/02-igp/`
**Focus**: IOS-XR configuration mode paths, command keywords, show commands, operational syntax

---

## Summary

**6 issues found** across 12 files (3 critical, 3 minor).

The IOS-XR syntax is largely correct and well-structured. The critical issues are all **hierarchy/mode-path errors** — correct command keywords placed under the wrong configuration submode. These would fail on commit. Show commands and operational mode syntax are clean across all files.

| Severity | Count | Description |
|----------|-------|-------------|
| Critical | 3 | Commands under wrong config submode (would fail on commit) |
| Minor | 3 | Debug command from wrong platform, pseudo-syntax in explanatory text, functional omission |

---

## Files Reviewed

| File | IOS-XR Content | Status |
|------|---------------|--------|
| `2.1-isis-deep-dive.md` | Config blocks, show commands, telemetry paths | **2 issues** |
| `2.1-isis-deep-dive-answers.md` | Show commands, debug commands, config snippets | **2 issues** |
| `2.1-isis-deep-dive-theory.md` | Pure protocol theory — no IOS-XR config | ✅ Clean |
| `2.2-ospf-in-sp-networks.md` | Config blocks, show commands, ABR config | **1 issue** |
| `2.2-ospf-in-sp-networks-answers.md` | Show commands, troubleshooting commands | ✅ Clean |
| `2.2-ospf-in-sp-networks-theory.md` | Pure protocol theory — no IOS-XR config | ✅ Clean |
| `2.3-igp-convergence-tuning.md` | Full convergence configs, show commands, FRR config | **2 issues** |
| `2.3-igp-convergence-tuning-answers.md` | Show commands, config verification | ✅ Clean |
| `2.3-igp-convergence-tuning-theory.md` | BFD/SPF/LFA theory — no IOS-XR config | ✅ Clean |
| `2.4-isis-vs-ospf-decision-framework.md` | Migration config, show commands | ✅ Clean |
| `2.4-isis-vs-ospf-decision-framework-answers.md` | Show commands, troubleshooting | ✅ Clean |
| `README.md` | Module index — no IOS-XR config | ✅ Clean |

---

## Issues

### 2.1-isis-deep-dive.md — IS-IS BFD Commands Under Wrong Hierarchy

- **Severity**: critical
- **Current text**:
```
 interface GigabitEthernet0/0/0/0
  circuit-type level-2-only
  point-to-point
  hello-padding disable
  address-family ipv4 unicast
   metric 10
   bfd minimum-interval 100
   bfd multiplier 3
   bfd fast-detect
  !
```
- **Correction**: `bfd minimum-interval` and `bfd multiplier` are interface-level commands in IOS-XR IS-IS. Only `bfd fast-detect` belongs under `address-family ipv4 unicast`. The correct hierarchy is:
```
 interface GigabitEthernet0/0/0/0
  circuit-type level-2-only
  point-to-point
  hello-padding disable
  bfd minimum-interval 100
  bfd multiplier 3
  address-family ipv4 unicast
   metric 10
   bfd fast-detect
  !
```
- **Source**: Cisco IOS-XR IS-IS Configuration Guide — "Configuring BFD under IS-IS". The `bfd minimum-interval` and `bfd multiplier` commands are configured at `router isis <name> / interface <intf>` level. The `bfd fast-detect` command is configured at `router isis <name> / interface <intf> / address-family {ipv4|ipv6} unicast` level.
- **Note**: The config in section 2.3 (`Complete Convergence-Optimized IS-IS`) has the correct hierarchy — BFD interval/multiplier at interface level, outside address-family. This is an inconsistency between the two files.

---

### 2.1-isis-deep-dive-answers.md — IOS Debug Command Attributed to IOS-XR

- **Severity**: minor
- **Current text**: `"use debug isis adj-packets (IOS-XR)"`
- **Correction**: `debug isis adj-packets` is IOS/IOS-XE syntax. IOS-XR uses a different debug command structure. The IOS-XR equivalent would be `debug isis adjacency` or platform-appropriate tracing/monitoring commands. Alternatively, for packet-level troubleshooting on IOS-XR, use `monitor protocol isis` or the `show isis adjacency log` command.
- **Source**: Cisco IOS-XR IS-IS Command Reference — debug commands differ from IOS classic.

---

### 2.1-isis-deep-dive-answers.md — Overload Bit Advertise Syntax

- **Severity**: minor
- **Current text**:
```
set-overload-bit on-startup wait-for-bgp
  advertise {connected | prefix}    ← controls which prefixes remain reachable
```
- **Correction**: The `advertise connected` and `advertise prefix` keywords shown here don't match IOS-XR IS-IS syntax precisely. In IOS-XR, the overload-bit behavior for attached prefixes is controlled by options like `set-overload-bit on-startup wait-for-bgp` (which by default still advertises attached prefixes) and separate `set-overload-bit advertise external` / `set-overload-bit advertise interlevel` commands under the address-family which control whether external/interlevel prefixes get max-metric during overload. The `connected`/`prefix` keywords as shown are closer to IOS/IOS-XE syntax.
- **Source**: Cisco IOS-XR IS-IS Command Reference — `set-overload-bit` options.
- **Note**: This appears in an answer explanation as pseudo-code illustrating the concept, not as a config block to be pasted. Impact is low since a reader would need to look up exact syntax anyway.

---

### 2.2-ospf-in-sp-networks.md — NSSA default-information-originate at Wrong Level

- **Severity**: critical
- **Current text**:
```
 area 10
  nssa                               ! NSSA area
  range 10.10.0.0/16                 ! Summarize into Area 0
  default-information-originate      ! Inject default into NSSA
```
- **Correction**: In IOS-XR OSPF, `default-information-originate` for an NSSA area is a sub-option of the `nssa` command, not a standalone area-level command. `default-information-originate` at the area level (outside the `nssa` submode) is not valid and would fail on commit. The correct syntax is:
```
 area 10
  nssa default-information-originate
  range 10.10.0.0/16                 ! Summarize into Area 0
```
Or in hierarchical form:
```
 area 10
  nssa
   default-information-originate
  !
  range 10.10.0.0/16
```
- **Source**: Cisco IOS-XR OSPF Configuration Guide — "Configuring NSSA". The `default-information-originate` is a keyword/sub-option of the `nssa` command within the area configuration.

---

### 2.3-igp-convergence-tuning.md — IS-IS mesh-group Under Wrong Hierarchy

- **Severity**: critical
- **Current text**:
```
router isis 1
  address-family ipv4 unicast
    ! Disable flooding on non-essential links
    interface GigabitEthernet0/0/0/2
      mesh-group blocked
```
- **Correction**: `interface` configuration and `mesh-group` are at the `router isis` level, not nested under `address-family ipv4 unicast`. You cannot enter interface submode from within address-family. This would fail on commit. The correct hierarchy is:
```
router isis 1
 interface GigabitEthernet0/0/0/2
  mesh-group blocked
```
- **Source**: Cisco IOS-XR IS-IS Configuration Guide — "Configuring IS-IS Mesh Groups". The `mesh-group` command is configured at `router isis <name> / interface <intf>` level.

---

### 2.3-igp-convergence-tuning.md — Missing bfd fast-detect in "Complete" IS-IS Config

- **Severity**: minor
- **Current text** (Complete Convergence-Optimized IS-IS):
```
 interface GigabitEthernet0/0/0/0
  point-to-point
  address-family ipv4 unicast
   fast-reroute per-prefix
   fast-reroute per-prefix ti-lfa
   metric 100
  !
  bfd minimum-interval 50
  bfd multiplier 3
  hello-interval 10
  hello-multiplier 3
```
- **Correction**: The `bfd minimum-interval` and `bfd multiplier` are correctly placed at the interface level (good — matches the fix needed in 2.1). However, `bfd fast-detect` is missing from the `address-family ipv4 unicast` submode. Without `bfd fast-detect`, BFD intervals are configured but IS-IS will not actually register with BFD for fast failure detection on this interface. For a config labeled "Convergence-Optimized," this is a functional gap. Add `bfd fast-detect` under the address-family:
```
  address-family ipv4 unicast
   fast-reroute per-prefix
   fast-reroute per-prefix ti-lfa
   metric 100
   bfd fast-detect
  !
```
- **Source**: Cisco IOS-XR IS-IS Configuration Guide — BFD requires both interval/multiplier at interface level AND `bfd fast-detect` under the address-family to activate.

---

## Verified Clean — Notable Items

The following IOS-XR elements were checked and confirmed correct:

**Show commands** (all files): `show isis neighbors`, `show isis database`, `show isis database detail`, `show isis topology`, `show isis route`, `show isis statistics`, `show isis interface`, `show isis spf-log`, `show isis fast-reroute`, `show isis segment-routing label table`, `show ospf neighbor`, `show ospf database`, `show ospf database summary`, `show ospf interface`, `show ospf route`, `show ospf border-routers`, `show ospf database opaque-area`, `show ospf statistics`, `show bfd session`, `show cef ipv4 <prefix>`, `show route <prefix> detail` — all valid IOS-XR operational commands.

**IS-IS config keywords**: `router isis`, `is-type level-2-only`, `net`, `metric-style wide`, `segment-routing mpls`, `spf prefix-priority critical tag`, `circuit-type`, `point-to-point`, `hello-padding disable`, `passive`, `prefix-sid index`, `set-overload-bit on-startup wait-for-bgp`, `distance`, `log adjacency changes`, `spf-interval`, `prc-interval`, `lsp-gen-interval` — all valid.

**OSPF config keywords**: `router ospf`, `router-id`, `timers throttle spf`, `timers throttle lsa all`, `fast-reroute per-prefix`, `passive enable`, `network point-to-point`, `bfd minimum-interval/multiplier/fast-detect` (under OSPF area/interface), `nssa`, `range`, `auto-cost reference-bandwidth`, `prefix-suppression`, `cost`, `log adjacency changes detail` — all valid.

**Telemetry paths**: `Cisco-IOS-XR-clns-isis-oper:isis/instances/instance/neighbors`, `Cisco-IOS-XR-clns-isis-oper:isis/instances/instance/levels/level/lsp-table` — valid IOS-XR YANG paths.

**TI-LFA config** (2.3): `fast-reroute per-prefix` and `fast-reroute per-prefix ti-lfa` correctly placed under `interface / address-family ipv4 unicast` — valid.

**Migration config** (2.4): `distance 105` under `router isis / address-family ipv4 unicast` — valid IOS-XR syntax for changing IS-IS administrative distance.
