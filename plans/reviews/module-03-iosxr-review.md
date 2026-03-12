# Module 03 — IOS-XR Syntax Review

**Reviewer:** Sentinel (IOS-XR CLI Specialist)
**Date:** 2026-03-12
**Scope:** All markdown files in `modules/03-bgp/`
**Focus:** IOS-XR configuration syntax, show commands, operational commands only

---

## Summary

**13 files reviewed. 7 IOS-XR syntax issues found (1 critical, 6 minor).**

The IOS-XR content is concentrated in `3.1-bgp-fundamentals-at-sp-scale.md` and its answer key. Sections 3.2, 3.3, and 3.4 use IOS-XE and Junos for configuration examples — no IOS-XR config blocks to validate there (though the 3.4 answer key has a correct IOS-XR route-policy example). The 3.1 IOS-XR configuration block is structurally sound — hierarchical neighbor model, explicit AF activation, route-policy syntax all correct. Issues are in show commands and a misleading community config on iBGP peers.

### Files Reviewed

| File | IOS-XR Content | Issues |
|------|---------------|--------|
| 3.1-bgp-fundamentals-at-sp-scale.md | Config block, show commands table, key knobs table | 6 |
| 3.1-bgp-fundamentals-at-sp-scale-answers.md | Diagnostic commands in answers | 1 |
| 3.1-bgp-fundamentals-at-sp-scale-theory.md | No IOS-XR syntax | 0 |
| 3.2-ibgp-design.md | IOS-XE and Junos only | 0 |
| 3.2-ibgp-design-answers.md | Brief IOS-XR show references | 0 |
| 3.2-ibgp-design-theory.md | No IOS-XR syntax | 0 |
| 3.3-ebgp-peering.md | IOS-XE and Junos only | 0 |
| 3.3-ebgp-peering-answers.md | Brief IOS-XR references (correct) | 0 |
| 3.3-ebgp-peering-theory.md | No IOS-XR syntax | 0 |
| 3.4-bgp-policy-and-traffic-engineering.md | IOS-XE and Junos only | 0 |
| 3.4-bgp-policy-and-traffic-engineering-answers.md | IOS-XR route-policy example (correct) | 0 |
| 3.4-bgp-policy-and-traffic-engineering-theory.md | No IOS-XR syntax | 0 |
| README.md | No technical syntax | 0 |

---

## Issues

### 3.1-bgp-fundamentals-at-sp-scale.md — Show Commands Table — Ambiguous `advertised` / `received` Keywords

- **Severity**: critical
- **Current text**:
  ```
  | `show bgp ipv4 unicast neighbors X.X.X.X advertised` | ... | What we're sending |
  | `show bgp ipv4 unicast neighbors X.X.X.X received`   | ... | What we're receiving |
  ```
- **Correction**: Use the full keywords `advertised-routes` and `received-routes`:
  ```
  | `show bgp ipv4 unicast neighbors X.X.X.X advertised-routes` | ... | What we're sending |
  | `show bgp ipv4 unicast neighbors X.X.X.X received-routes`   | ... | What we're receiving (pre-policy, requires soft-reconfig inbound) |
  ```
  In IOS-XR, `show bgp neighbors <ip>` supports both `advertised-routes` and `advertised-count` as subcommands. The abbreviation `advertised` is ambiguous between them and will return `% Ambiguous command`. Same for `received` vs `received-routes` / `received-count`. The documented canonical forms are `advertised-routes` and `received-routes`.
- **Source**: Cisco IOS-XR BGP Command Reference — `show bgp neighbors`

---

### 3.1-bgp-fundamentals-at-sp-scale.md — Config Block — `send-community-ebgp` on iBGP Peer

- **Severity**: minor
- **Current text** (under iBGP neighbor 10.0.0.100, remote-as 65000):
  ```
  address-family ipv4 unicast
   send-community-ebgp
   next-hop-self
  ...
  address-family vpnv4 unicast
   send-extended-community-ebgp
  ...
  address-family ipv6 unicast
   send-community-ebgp
  ```
- **Correction**: Remove `send-community-ebgp` and `send-extended-community-ebgp` from the iBGP neighbor stanzas. These commands only affect eBGP sessions. On iBGP sessions, both standard and extended communities are sent by default in IOS-XR — no configuration is needed. The commands are accepted by the parser but are no-ops on iBGP peers, making the example misleading for study purposes. They are correctly placed on the eBGP neighbor (198.51.100.1) further down.
- **Source**: Cisco IOS-XR BGP Configuration Guide — "Sending Communities" section; communities are always sent to iBGP peers

---

### 3.1-bgp-fundamentals-at-sp-scale.md — Show Commands Table — `show bgp all summary`

- **Severity**: minor
- **Current text**:
  ```
  | `show bgp all summary` | `show bgp summary instance all` | All AF summary |
  ```
- **Correction**: For all address families in IOS-XR, the canonical command is:
  ```
  show bgp all all summary
  ```
  The first `all` specifies AFI (all address family identifiers), the second `all` specifies SAFI (all subsequent AFIs). Using `show bgp all summary` without the second `all` may only show a single SAFI or produce unexpected results depending on IOS-XR version. Some versions may accept the single-`all` form; for portability and clarity, always specify both.
- **Source**: Cisco IOS-XR BGP Command Reference — `show bgp summary`

---

### 3.1-bgp-fundamentals-at-sp-scale.md — Show Commands Table — `bestpath` Keyword

- **Severity**: minor
- **Current text**:
  ```
  | `show bgp ipv4 unicast X.X.X.X/YY bestpath` | ... | Best path selection reason |
  ```
- **Correction**: IOS-XR does not have a `bestpath` filter keyword on `show bgp <prefix>`. The standard `show bgp ipv4 unicast X.X.X.X/YY` output includes all paths with the best path marked by `>`. For explicit best-path comparison detail, use:
  ```
  show bgp ipv4 unicast X.X.X.X/YY detail
  ```
  which shows the decision reason. The `bestpath` keyword is an IOS-XE construct (`show bgp ipv4 unicast <prefix> bestpath`), not IOS-XR.
- **Source**: Cisco IOS-XR BGP Command Reference — `show bgp`

---

### 3.1-bgp-fundamentals-at-sp-scale.md — Key Knobs Table — `bgp bestpath as-path multipath-relax`

- **Severity**: minor
- **Current text** (in Key Knobs comparison table):
  ```
  | `bgp bestpath as-path multipath-relax` | Off | `multipath multiple-as` | Enable for ECMP |
  ```
  Listed with an "IOS-XR Default" value of "Off", implying the command exists in IOS-XR in this exact form.
- **Correction**: This command IS supported in IOS-XR 6.0+ (ASR 9000, NCS 5500), but the table should clarify it is configured under the `router bgp` process globally, not per-address-family. For completeness, note that IOS-XR also requires `maximum-paths ebgp <n>` (or `maximum-paths ibgp <n>`) under the address-family to actually enable multipath — `multipath-relax` alone is not sufficient. Consider a footnote or expanding the table row to show the full IOS-XR multipath config:
  ```
  router bgp 65000
   bgp bestpath as-path multipath-relax
   address-family ipv4 unicast
    maximum-paths ebgp 8
    maximum-paths ibgp 8
  ```
- **Source**: Cisco IOS-XR BGP Configuration Guide — "BGP Multipath"

---

### 3.1-bgp-fundamentals-at-sp-scale.md — Explanatory Note — `send-community` Comparison

- **Severity**: minor
- **Current text** (note below the IOS-XR config block):
  > IOS-XE also uses `send-community both` instead of IOS-XR's `send-community-ebgp` / `send-extended-community-ebgp`.
- **Correction**: The statement is factually correct about the command names, but it omits a key distinction: these IOS-XR commands are **only needed for eBGP peers**. iBGP peers send all communities by default in IOS-XR. The note should clarify:
  > IOS-XE uses `send-community both` on all peers. IOS-XR uses `send-community-ebgp` / `send-extended-community-ebgp` **on eBGP peers only** — iBGP peers send communities by default.

  Without this distinction, readers will (as demonstrated in the config block above) add these commands to iBGP peers unnecessarily.
- **Source**: Cisco IOS-XR BGP Configuration Guide — community advertisement behavior

---

### 3.1-bgp-fundamentals-at-sp-scale-answers.md — Answer 1 — `show access-lists interface`

- **Severity**: minor
- **Current text**:
  ```
  IOS-XR: show access-lists interface GigabitEthernet0/0/0/0
  ```
- **Correction**: IOS-XR does not support the form `show access-lists interface <if>` directly. To check ACLs applied to an interface, use:
  ```
  show running-config interface GigabitEthernet0/0/0/0 | include access-group
  ```
  To view ACL content with hardware hit counts:
  ```
  show access-lists ipv4 <acl-name> hardware ingress interface GigabitEthernet0/0/0/0 location <node>
  ```
  The form `show access-lists interface <if>` is IOS-XE syntax.
- **Source**: Cisco IOS-XR IP Addresses and Services Command Reference — `show access-lists`

---

## Verified Clean (IOS-XR syntax confirmed correct)

The following IOS-XR elements were validated and are syntactically correct:

**3.1 Configuration Block:**
- ✅ `router bgp 65000` — correct process-level entry
- ✅ `bgp router-id 10.0.0.1` — correct
- ✅ `bgp log neighbor changes detail` — correct
- ✅ `timers bgp 10 30` — correct (keepalive 10s, hold 30s)
- ✅ Hierarchical `neighbor` → `remote-as` → `update-source` → `address-family` model — correct IOS-XR style
- ✅ `password encrypted <value>` — correct IOS-XR syntax
- ✅ `next-hop-self` under iBGP neighbor AF — correct
- ✅ `ebgp-multihop 2` — correct
- ✅ `route-policy <name> in/out` — correct (IOS-XR uses `route-policy`, not `route-map`)
- ✅ `maximum-prefix 1000000 85` — correct
- ✅ Explicit AF activation per neighbor — correct IOS-XR model (no auto-activation)

**3.1 Show Commands (valid entries):**
- ✅ `show bgp summary`
- ✅ `show bgp ipv4 unicast`
- ✅ `show bgp ipv4 unicast neighbors X.X.X.X`
- ✅ `show bgp vpnv4 unicast`
- ✅ `show bgp l2vpn evpn`

**3.1 Answers — Diagnostic Commands:**
- ✅ `show lpts bindings brief`
- ✅ `show run router bgp | include neighbor|update-source`
- ✅ `show route <prefix>`
- ✅ `telnet <peer-ip> 179`

**3.4 Answers — IOS-XR Route-Policy:**
- ✅ `route-policy TRANSIT-B-OUT` / `set as-path prepend 65000 65000` / `end-policy`
- ✅ `route-policy CUSTOMER-RTBH-IN` with `if/then/else/endif/pass/drop` RPL syntax
- ✅ `set next-hop`, `set local-preference`, `set community (...) additive`, `set origin igp`
- ✅ `router static` / `address-family ipv4 unicast` / `192.0.2.1/32 Null0`

**3.1 Theory Notes:**
- ✅ Correct statement that IOS-XR does not auto-activate IPv4 unicast (no `no bgp default ipv4-unicast` needed)
- ✅ Correct identification of `route-policy` as IOS-XR's policy mechanism (vs IOS-XE `route-map`)
