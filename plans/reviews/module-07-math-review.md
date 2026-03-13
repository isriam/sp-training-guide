# Module 07 L3VPN — Math & Scaling Audit

**Scope audited:** All `*.md` files under `/home/claude/agent-will/projects/sp-study-guide/modules/07-l3vpn/`.

## Findings

| Severity | File | Line | Current text | Correct value | Reasoning |
|---|---|---:|---|---|---|
| **critical** | `7.1-l3vpn-architecture-theory.md` | 88, 94 | "Prefix Length ... including RD (add 64 to IPv4 mask)" and "VPNv4 /24 has prefix length ... 88 bits in the BGP UPDATE" | For VPNv4 /24 in MP-BGP NLRI, **Length octet on wire = 112 bits** (24 label + 64 RD + 24 IPv4 prefix). | RFC 8277 NLRI encoding defines Length as bits of the remainder of NLRI (includes label field). `88` is only the VPN prefix length excluding the label compatibility field; the text explicitly says "in the BGP UPDATE," so 88 is incorrect in that context. |
| **critical** | `7.2-mp-bgp-vpnv4-vpnv6-theory.md` | 105 | "Junos: per-CE (default...)" | Junos default (without `vrf-table-label`) is **per-next-hop** label allocation. | This affects scale math directly (label-count sizing). The same module elsewhere correctly describes Junos default as per-next-hop. |
| **critical** | `7.2-mp-bgp-vpnv4-vpnv6.md` | 456 | "Without this: per-prefix (one label per route in VRF)" | Without `vrf-table-label`, Junos is **per-next-hop**, not per-prefix. | This comment materially overstates label consumption and can mislead capacity planning. |
| **critical** | `7.5-l3vpn-scale-convergence.md` | 713 | Key Knobs table: "Label mode | per-prefix | per-prefix | ..." (Junos default shown as per-prefix) | Junos default should be **per-next-hop** (without `vrf-table-label`). | Internal inconsistency with other module files and incorrect scaling baseline for Junos FIB/label budgeting. |
| **minor** | `7.3-inter-as-l3vpn-theory.md` | 106 | "Option B: Three labels minimum in transit: transport ... + VPN label ... Stack depth at any point is 2." | At any transit point in Option B, stack depth is **2 labels** (transport + VPN). | Arithmetic/text contradiction in same sentence: it names two label components but says three labels minimum. |
| **minor** | `ADVERSARIAL-REVIEW.md` | 11, 230 | Claims "3 critical CLI errors" and "WRONG CLI (3 Critical, 2 Medium)" | Based on listed entries, CLI issues include **1 critical** (Issue 7), not 3 critical. | Numeric inconsistency in issue counting within the review file itself. |

## Notes

- I verified the rest of the module’s major numeric/scaling assertions (AFI/SAFI values, RD/RT field sizes, MPLS label bit fields, convergence arithmetic examples, and most capacity estimates) and found them broadly consistent.
- The highest-impact problems are the **label-allocation default misstatements** and the **VPNv4 NLRI length encoding math** line in 7.1 theory.