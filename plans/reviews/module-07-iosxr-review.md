# Module 07 IOS-XR CLI Validation Report

Validated all Markdown files under:
`/home/claude/agent-will/projects/sp-study-guide/modules/07-l3vpn/`

Focus: IOS-XR config syntax, hierarchy placement, show-command correctness, and platform-specific CLI validity.

---

## Findings

| Severity | File | Line | Current text | Correct text | Source |
|---|---|---:|---|---|---|
| **critical** | `7.3-inter-as-l3vpn.md` | 376 | `retain route-target all` under `neighbor ... address-family vpnv4 unicast` | Move `retain route-target all` to global AF scope: `router bgp <asn> -> address-family vpnv4 unicast -> retain route-target all` (not under neighbor) | Cisco IOS-XR BGP/L3VPN CLI hierarchy; same module shows correct hierarchy in `7.4-extranet-shared-services.md` lines 803-809 |
| **critical** | `7.5-l3vpn-scale-convergence-answers.md` | 168-170 | `router bgp 65000 -> address-family vpnv4 unicast -> label mode per-ce` | Use VRF AF scope for label mode: `router bgp 65000 -> vrf <VRF> -> address-family ipv4 unicast -> label mode per-ce` | Cisco IOS-XR L3VPN config hierarchy; same module canonical placement in `7.1-l3vpn-architecture.md` lines 382-385 |
| **minor** | `7.1-l3vpn-architecture.md` | 578 | `Enable address-family rtfilter (IOS-XR)` | `Enable address-family ipv4 rt-filter (IOS-XR)` | Same file already states correct syntax at line 350: `address-family ipv4 rt-filter   ! ... NOT "rtfilter"` |
| **minor** | `7.4-extranet-shared-services.md` | 675 | ``show bgp rt-filter unicast summary`` | ``show bgp ipv4 rt-filter summary`` | IOS-XR RT-Constraint operational command format; same module uses correct form in `7.1-l3vpn-architecture.md` line 518 and `7.5-l3vpn-scale-convergence.md` line 737 |
| **minor** | `7.5-l3vpn-scale-convergence-answers.md` | 188 | `maximum-paths ibgp 8` under `neighbor-group ... address-family vpnv4 unicast` | Place multipath selection under AF process scope (`router bgp -> address-family vpnv4 unicast`), not neighbor-group AF | Cisco IOS-XR BGP command hierarchy (multipath is a local bestpath/FIB behavior, neighbor-group AF is for per-neighbor policy/caps) |

---

## Notes

- Junos-specific syntax observations were intentionally ignored unless they affected IOS-XR examples directly.
- No ASR platform misattribution found (ASR 9000 references align with IOS-XR context).
- No additional IOS-XR default-value errors found beyond the command/hierarchy items above.
