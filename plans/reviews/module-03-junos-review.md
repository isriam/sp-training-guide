# Module 03 — BGP: Junos Syntax Review

**Reviewer**: Sentinel (Junos CLI Specialist)
**Date**: 2026-03-12
**Scope**: All `.md` files in `modules/03-bgp/` — Junos configuration and operational command syntax only
**Verdict**: **NEARLY CLEAN — 2 minor issues found**

---

## Summary

Reviewed 13 markdown files. All Junos configuration blocks (hierarchy paths, knob names, policy syntax) are correct and would commit cleanly. Two minor issues found in operational mode commands — one invalid show command and one misused diagnostic command. No critical issues.

### Files Reviewed

| File | Junos Content | Status |
|------|--------------|--------|
| `3.1-bgp-fundamentals-at-sp-scale.md` | Config block, show command table, key knobs table | ⚠️ 1 minor issue |
| `3.1-bgp-fundamentals-at-sp-scale-theory.md` | No Junos config/commands | ✅ Clean (no Junos) |
| `3.1-bgp-fundamentals-at-sp-scale-answers.md` | Diagnostic commands in answers | ⚠️ 1 minor issue |
| `3.2-ibgp-design.md` | Config block (RR), show command table | ✅ Clean |
| `3.2-ibgp-design-theory.md` | No Junos config/commands | ✅ Clean (no Junos) |
| `3.2-ibgp-design-answers.md` | No Junos-specific config | ✅ Clean (no Junos) |
| `3.3-ebgp-peering.md` | Config block (full eBGP policy), show commands | ✅ Clean |
| `3.3-ebgp-peering-theory.md` | No Junos config/commands | ✅ Clean (no Junos) |
| `3.3-ebgp-peering-answers.md` | One inline Junos show command | ✅ Clean |
| `3.4-bgp-policy-and-traffic-engineering.md` | Config block (multipath/ECMP), show commands | ✅ Clean |
| `3.4-bgp-policy-and-traffic-engineering-theory.md` | No Junos config/commands | ✅ Clean (no Junos) |
| `3.4-bgp-policy-and-traffic-engineering-answers.md` | Policy config blocks (prepend, RTBH) | ✅ Clean |
| `README.md` | No Junos content | ✅ Clean (no Junos) |

---

## Issues

### 3.1-bgp-fundamentals-at-sp-scale.md — Show Command Table — Invalid `show bgp summary instance all`

- **Severity**: minor
- **Section**: Verification & Monitoring → Show Commands table, last row
- **Current text**: `show bgp summary instance all`
- **Correction**: `show bgp summary` (already shows all address families for the default routing instance). For per-instance BGP summary, use `show bgp summary instance <instance-name>` for each routing instance individually. There is no `instance all` wildcard for this command.
- **Explanation**: The table maps IOS-XR's `show bgp all summary` (which shows all address families) to the Junos equivalent. In Junos, `show bgp summary` already displays all configured address families in its output — no special keyword is needed. The `instance` keyword in Junos selects a routing instance (VRF), not an address family. The value `all` is not a valid instance name or keyword for this command.
- **Source**: Juniper TechLibrary — [show bgp summary](https://www.juniper.net/documentation/us/en/software/junos/bgp/topics/ref/command/show-bgp-summary.html)

---

### 3.1-bgp-fundamentals-at-sp-scale-answers.md — Q1 Answer — Invalid `test policy` Usage

- **Severity**: minor
- **Section**: Question 1 Answer, Cause 1 diagnostic block
- **Current text**: `test policy <filter-name> 179`
- **Correction**: Remove this line or replace with a valid diagnostic approach. `test policy` in Junos evaluates a **routing policy** against a route prefix — it cannot test firewall filter rules or port accessibility. To verify TCP/179 is not being blocked by a firewall filter, use: `show firewall log` (already listed), `show firewall filter <filter-name>` to inspect filter counters, or attempt a TCP connection with `telnet <peer-ip> 179` (if available on the platform).
- **Explanation**: The Junos `test policy` command syntax is `test policy <policy-name> <prefix>`. It evaluates whether a routing policy would accept/reject a given route prefix. Passing `179` as the second argument would be interpreted as an invalid prefix, and the command has no relevance to firewall filter (ACL) testing. This appears to be a conflation with IOS-XR's control-plane policy testing.
- **Source**: Juniper TechLibrary — [test policy](https://www.juniper.net/documentation/us/en/software/junos/routing-policy/topics/ref/command/test-policy.html)

---

## Verified Clean — Notable Items

The following Junos syntax was verified correct (items that could be easy to get wrong):

| Item | File | Verdict |
|------|------|---------|
| `protocols bgp group <name> cluster <id>` (RR cluster-id) | 3.2 | ✅ `cluster` is the correct Junos keyword (not `cluster-id`) |
| `family evpn { signaling; }` | 3.1, 3.2 | ✅ Correct EVPN family syntax |
| `family inet-vpn { unicast; }` | 3.1, 3.2 | ✅ Correct VPNv4 family syntax |
| `add-path { send { path-count 3; } receive; }` | 3.2 | ✅ Correct ADD-PATH syntax under family |
| `prefix-limit { maximum N; teardown P idle-timeout M; }` | 3.1, 3.2, 3.3 | ✅ Correct prefix-limit with auto-recovery |
| `multihop { ttl 1; }` (IX route server) | 3.3 | ✅ Valid — disables directly-connected check while keeping TTL=1 |
| `community GSHUT members graceful-shutdown;` | 3.3 | ✅ `graceful-shutdown` is a recognized well-known community in Junos |
| `from route-filter 0.0.0.0/0 prefix-length-range /25-/32;` | 3.3 | ✅ Valid route-filter syntax for prefix length matching |
| `as-path-prepend "65000 65000";` | 3.4 answers | ✅ Correct prepend syntax in policy-statement |
| `multipath { multiple-as; }` under BGP group | 3.4 | ✅ Valid multipath config at group level |
| `load-balance per-packet;` in forwarding-table export | 3.4 | ✅ Correct (hash-based per-flow despite name) |
| `show route table bgp.l3vpn.0` | 3.1 | ✅ Correct VPNv4 RIB table name |
| `show route table bgp.evpn.0` | 3.1 | ✅ Correct EVPN RIB table name |
| `show validation session` / `show validation database` | 3.3 | ✅ Correct RPKI validation commands |
| `show route damping decayed` | 3.4 | ✅ Correct dampening display command |
| `show route forwarding-table destination X.X.X.X` | 3.4 | ✅ Correct FIB verification command |
| `policy-statement` with `then reject;` default | 3.3, 3.4 answers | ✅ Valid explicit default deny |

---

## Conclusion

The Junos content across Module 03 is solid. Both configuration blocks and the vast majority of operational commands use correct syntax, hierarchy paths, and knob names. The two issues found are both in show/diagnostic commands (not config that would fail on commit) and are minor enough to be caught by anyone running them on a real box. No critical issues, no wrong hierarchy paths, no invalid knob names.
