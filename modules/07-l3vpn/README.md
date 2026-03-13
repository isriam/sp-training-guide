# Module 7 — MPLS L3VPN Services

This module focuses on the service-provider problem space around l3vpn. It connects design intent to operations so you can make defensible architecture choices and troubleshoot production-impacting issues with confidence.

## Sections in this module

| Section | Topic | What it covers | Est. time |
|---|---|---|---:|
| 7.1 | [7.1 — MPLS L3VPN Architecture](7.1-l3vpn-architecture.md) | MPLS L3VPN (RFC 4364, which obsoletes RFC 2547 and followed the `rfc2547bis` draft lineage) is the backbone revenue engine of every service pro... | 4 min |
| 7.2 | [7.2 — MP-BGP for VPNv4/VPNv6](7.2-mp-bgp-vpnv4-vpnv6.md) | MP-BGP is the control plane that makes L3VPN scale. Without it, every PE would need a full mesh... | 4 min |
| 7.3 | [7.3 — Inter-AS L3VPN](7.3-inter-as-l3vpn.md) | When a single VPN customer spans multiple autonomous systems — different providers, different r... | 5 min |
| 7.4 | [7.4 — Extranet & Shared Services](7.4-extranet-shared-services.md) | Every SP eventually gets the request: "We need Customer A to reach Customer B's database." Or: ... | 5 min |
| 7.5 | [7.5 — L3VPN Scale & Convergence](7.5-l3vpn-scale-convergence.md) | The first four sections taught you how L3VPN works. This section teaches you how it works at **... | 5 min |

## Prerequisites
- Modules 3–4 (MP-BGP and MPLS labels).
- Recommended: complete [Module 6 — Segment Routing](../06-sr/README.md) first.

## What you'll be able to do
- explain why this technology is used in SP networks
- map control-plane signals to forwarding outcomes
- verify healthy operation using platform show commands
- identify common failure patterns and likely root causes

## Key protocols/technologies covered
- BGP, L3VPN, MP-BGP, MPLS

## Labs
- See [`../../labs`](../../labs) for available lab guides tied to this module.
