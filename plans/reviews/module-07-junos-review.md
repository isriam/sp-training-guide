# Module 07 — Junos CLI Validation Report

Validated all Markdown files under:
`/home/claude/agent-will/projects/sp-study-guide/modules/07-l3vpn/`

Focus: Junos CLI syntax, hierarchy, show commands, and Junos-specific defaults.

## Findings Summary
- **Total findings:** 5
- **Critical:** 1
- **Minor:** 4

## Detailed Findings

| Severity | File | Line | Current text | Correct text | Source |
|---|---|---:|---|---|---|
| **critical** | `7.5-l3vpn-scale-convergence.md` | 663 | `inet.3;` (under `routing-options resolution rib bgp.l3vpn.0`) | `resolution-ribs inet.3;` (or `resolution-ribs [ inet.3 inet.0 ];` if intentionally adding fallback) | Juniper CLI reference: **resolution-ribs** syntax under `routing-options resolution rib` — https://www.juniper.net/documentation/us/en/software/junos/cli-reference/topics/ref/statement/resolution-ribs-edit-routing-options.html |
| **minor** | `7.4-extranet-shared-services.md` | 675 | ``show route table bgp.rtc.0`` | ``show route table bgp.rtarget.0`` | Juniper Route Target Filtering docs identify RT membership table as **bgp.rtarget.0** — https://www.juniper.net/documentation/us/en/software/junos/vpn-l3/topics/topic-map/l3-vpns-route-target-filtering.html |
| **minor** | `7.2-mp-bgp-vpnv4-vpnv6.md` | 456 | `# Without this: per-prefix (one label per route in VRF)` | `# Without this: per-next-hop label allocation (default); with vrf-table-label = per-table/per-VRF label` | Juniper L3VPN label allocation behavior (`per-nexthop` vs `per-table`) — https://www.juniper.net/documentation/en_US/junos/topics/usage-guidelines/vpns-configuring-label-allocation-and-substitution-policy.html |
| **minor** | `7.2-mp-bgp-vpnv4-vpnv6-theory.md` | 105 | `- Junos: per-CE (default, can be changed with vrf-table-label for per-VRF)` | `- Junos: per-next-hop default (often appears per-CE in simple topologies); vrf-table-label changes to per-table/per-VRF` | Juniper L3VPN label allocation behavior (`per-nexthop`/`per-table`) — https://www.juniper.net/documentation/en_US/junos/topics/usage-guidelines/vpns-configuring-label-allocation-and-substitution-policy.html |
| **minor** | `7.5-l3vpn-scale-convergence.md` | 713 | `| Label mode | per-prefix | per-prefix | per-vrf (at scale) | ... |` | Junos default column should be `per-next-hop` (or `per-nexthop`) rather than `per-prefix` | Juniper L3VPN label allocation behavior (`per-nexthop` default, `vrf-table-label` for per-table) — https://www.juniper.net/documentation/en_US/junos/topics/usage-guidelines/vpns-configuring-label-allocation-and-substitution-policy.html |

---

No additional Junos CLI hierarchy/command commit-fail errors were found in the remaining module files beyond the items above.