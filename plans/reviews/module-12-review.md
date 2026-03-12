# Module 12 Technical Review

## Summary
- Reviewed all 10 markdown files in `modules/12-case-studies/` with targeted scans for RFC references, protocol claims, timer values, label behavior, and transport assertions.
- Material accuracy issues found in Modules **12.1, 12.3, 12.4, and 12.5**.
- **No material standards errors found** during targeted review of:
  - `12.2-dci-with-evpn.md`
  - `12.2-dci-with-evpn-answers.md`
- Repeated issues in answer files generally mirror the main content files.

### 12.1-isp-backbone-design.md — Route Reflector Session Math Is Wrong
- **Severity**: minor
- **Current text**: "With two RRs per cluster (redundancy), 14 PoPs = 28 RR sessions per router maximum."
- **Correction**: "With two route reflectors in a cluster, a client normally has two RR sessions, not one session per PoP. If every PE peers only to its redundant RRs, the per-router RR session count is typically 2 (or 3 if using three global RRs), not 28."
- **Source**: RFC 4456

### 12.1-isp-backbone-design.md — SRGB Guidance Misstates Standards
- **Severity**: minor
- **Current text**: "Standard: IANA recommended SRGB is 16000–23999" / "Rule: Every router in the network uses the SAME SRGB range — this is the whole point"
- **Correction**: "There is no IANA-recommended SRGB range. The SRGB is a locally configured label block, and nodes do not have to use the same SRGB. Using a common SRGB is an operational simplification, not a protocol requirement."
- **Source**: RFC 8402; RFC 8660

### 12.1-isp-backbone-design.md — Default BGP Timer Is Incorrect
- **Severity**: minor
- **Current text**: "Mitigation: IBGP hold-down timers tuned to 3s (not default 90s)"
- **Correction**: "The BGP default hold time is 180 seconds with a default keepalive of 60 seconds. If fast failure detection is desired, call out BFD or explicitly configured reduced BGP timers rather than a 'default 90s' hold timer."
- **Source**: RFC 4271

### 12.1-isp-backbone-design.md — SR Does Not Mean ‘Zero Protocol Change’ on Transit Routers
- **Severity**: minor
- **Current text**: "Zero protocol change needed at P routers."
- **Correction**: "Segment Routing removes per-LSP signaling state such as RSVP-TE/LDP state from transit behavior, but P routers still need SR-capable forwarding and the relevant control-plane support (for example, SR extensions in IS-IS/OSPF or policy/signaling support as deployed)."
- **Source**: RFC 8402; RFC 8667

### 12.1-isp-backbone-design.md — LDP Discovery Is Not Label Distribution
- **Severity**: minor
- **Current text**: "LDP labels are distributed via LDP Discovery."
- **Correction**: "LDP discovery uses Hellos (UDP 646), while label advertisement/distribution occurs over the established LDP session (TCP 646)."
- **Source**: RFC 5036

### 12.1-isp-backbone-design.md — Node-SID Stack Does Not Guarantee a Specific Direct Link
- **Severity**: critical
- **Current text**: "The SR-TE policy uses explicit SIDs: [NY-P1-SID, CHI-P1-SID] — a 2-label stack forcing the direct path."
- **Correction**: "A stack of node SIDs does not guarantee use of a specific inter-router link; it guarantees shortest-path forwarding toward those nodes. To force a specific direct link/corridor, use an adjacency-SID, a binding-SID for a precomputed SR policy, or another explicit policy construct that encodes the exact path."
- **Source**: RFC 8402; RFC 8667

### 12.1-isp-backbone-design.md — IS-IS Graceful Shutdown Is Confused with Graceful Restart Signaling
- **Severity**: minor
- **Current text**: "`isis graceful-shutdown` or equivalent — sends IS-IS GR notification to neighbors"
- **Correction**: "Do not describe an IS-IS traffic-drain operation as sending a graceful-restart notification. Graceful drain is typically implemented with overload-bit/max-metric behavior so transit traffic avoids the node; graceful restart signaling is a different mechanism used for restart handling."
- **Source**: RFC 3277; RFC 5306

### 12.1-isp-backbone-design-answers.md — Route Reflector Session Math Is Wrong
- **Severity**: minor
- **Current text**: "With two RRs per cluster (redundancy), 14 PoPs = 28 RR sessions per router maximum."
- **Correction**: "With two route reflectors in a cluster, a client normally has two RR sessions, not one session per PoP. If every PE peers only to its redundant RRs, the per-router RR session count is typically 2 (or 3 if using three global RRs), not 28."
- **Source**: RFC 4456

### 12.1-isp-backbone-design-answers.md — SRGB Guidance Misstates Standards
- **Severity**: minor
- **Current text**: "Standard: IANA recommended SRGB is 16000–23999" / "Rule: Every router in the network uses the SAME SRGB range — this is the whole point"
- **Correction**: "There is no IANA-recommended SRGB range. The SRGB is a locally configured label block, and nodes do not have to use the same SRGB. Using a common SRGB is an operational simplification, not a protocol requirement."
- **Source**: RFC 8402; RFC 8660

### 12.1-isp-backbone-design-answers.md — Default BGP Timer Is Incorrect
- **Severity**: minor
- **Current text**: "Mitigation: IBGP hold-down timers tuned to 3s (not default 90s)"
- **Correction**: "The BGP default hold time is 180 seconds with a default keepalive of 60 seconds. If fast failure detection is desired, call out BFD or explicitly configured reduced BGP timers rather than a 'default 90s' hold timer."
- **Source**: RFC 4271

### 12.1-isp-backbone-design-answers.md — SR Does Not Mean ‘Zero Protocol Change’ on Transit Routers
- **Severity**: minor
- **Current text**: "Zero protocol change needed at P routers."
- **Correction**: "Segment Routing removes per-LSP signaling state such as RSVP-TE/LDP state from transit behavior, but P routers still need SR-capable forwarding and the relevant control-plane support (for example, SR extensions in IS-IS/OSPF or policy/signaling support as deployed)."
- **Source**: RFC 8402; RFC 8667

### 12.1-isp-backbone-design-answers.md — LDP Discovery Is Not Label Distribution
- **Severity**: minor
- **Current text**: "LDP labels are distributed via LDP Discovery."
- **Correction**: "LDP discovery uses Hellos (UDP 646), while label advertisement/distribution occurs over the established LDP session (TCP 646)."
- **Source**: RFC 5036

### 12.1-isp-backbone-design-answers.md — Node-SID Stack Does Not Guarantee a Specific Direct Link
- **Severity**: critical
- **Current text**: "The SR-TE policy uses explicit SIDs: [NY-P1-SID, CHI-P1-SID] — a 2-label stack forcing the direct path."
- **Correction**: "A stack of node SIDs does not guarantee use of a specific inter-router link; it guarantees shortest-path forwarding toward those nodes. To force a specific direct link/corridor, use an adjacency-SID, a binding-SID for a precomputed SR policy, or another explicit policy construct that encodes the exact path."
- **Source**: RFC 8402; RFC 8667

### 12.1-isp-backbone-design-answers.md — IS-IS Graceful Shutdown Is Confused with Graceful Restart Signaling
- **Severity**: minor
- **Current text**: "`isis graceful-shutdown` or equivalent — sends IS-IS GR notification to neighbors"
- **Correction**: "Do not describe an IS-IS traffic-drain operation as sending a graceful-restart notification. Graceful drain is typically implemented with overload-bit/max-metric behavior so transit traffic avoids the node; graceful restart signaling is a different mechanism used for restart handling."
- **Source**: RFC 3277; RFC 5306

### 12.3-mobile-backhaul-5g-transport.md — eCPRI over GTP-U Claim Is Incorrect
- **Severity**: minor
- **Current text**: "c) Over GTP-U — rarely used, future 3GPP option"
- **Correction**: "Do not present GTP-U as a standard eCPRI transport option. eCPRI fronthaul is standardized over Ethernet and can also be carried over UDP/IP; GTP-U is used for 3GPP user-plane interfaces such as F1-U/N3, not for eCPRI fronthaul transport."
- **Source**: eCPRI Specification v2.0; O-RAN Open Fronthaul CUS-Plane Specification

### 12.3-mobile-backhaul-5g-transport.md — Holdover Math Is Internally Inconsistent and Numerically Wrong
- **Severity**: critical
- **Current text**: "Prairie Wireless OCXO holdover budget: maintain ±130 ns for ~1 hour" / "130 ns / (1 µs / 86400 s) ≈ 11.2 seconds"
- **Correction**: "Those two statements are inconsistent, and the 11.2-second calculation is wrong by orders of magnitude. 1 µs/day is about 11.6 ps/s, so 130 ns of drift budget corresponds to about 11,232 seconds (~3.1 hours), not 11.2 seconds. If you assume 10 µs/day drift, the same 130 ns budget is about 18.7 minutes, not ~1 hour."
- **Source**: ITU-T G.8275.1; ITU-T G.8273.2

### 12.3-mobile-backhaul-5g-transport-answers.md — eCPRI over GTP-U Claim Is Incorrect
- **Severity**: minor
- **Current text**: "c) Over GTP-U — rarely used, future 3GPP option"
- **Correction**: "Do not present GTP-U as a standard eCPRI transport option. eCPRI fronthaul is standardized over Ethernet and can also be carried over UDP/IP; GTP-U is used for 3GPP user-plane interfaces such as F1-U/N3, not for eCPRI fronthaul transport."
- **Source**: eCPRI Specification v2.0; O-RAN Open Fronthaul CUS-Plane Specification

### 12.3-mobile-backhaul-5g-transport-answers.md — Holdover Math Is Internally Inconsistent and Numerically Wrong
- **Severity**: critical
- **Current text**: "Prairie Wireless OCXO holdover budget: maintain ±130 ns for ~1 hour" / "130 ns / (1 µs / 86400 s) ≈ 11.2 seconds"
- **Correction**: "Those two statements are inconsistent, and the 11.2-second calculation is wrong by orders of magnitude. 1 µs/day is about 11.6 ps/s, so 130 ns of drift budget corresponds to about 11,232 seconds (~3.1 hours), not 11.2 seconds. If you assume 10 µs/day drift, the same 130 ns budget is about 18.7 minutes, not ~1 hour."
- **Source**: ITU-T G.8275.1; ITU-T G.8273.2

### 12.4-internet-exchange-point-design.md — IPv6 Documentation Prefix Example Is Invalid Syntax
- **Severity**: minor
- **Current text**: "2001:db8:basx::/64"
- **Correction**: "Use a syntactically valid documentation prefix, e.g. `2001:db8:100::/64`. `basx` is not valid hexadecimal and therefore is not a valid IPv6 hextet."
- **Source**: RFC 4291; RFC 3849

### 12.4-internet-exchange-point-design.md — RFC 8326 Is Referenced for the Wrong Communities
- **Severity**: minor
- **Current text**: "BasinIX implements RFC 8326-style graceful shutdown and selective advertisement communities"
- **Correction**: "RFC 8326 defines the well-known GRACEFUL_SHUTDOWN community (`65535:0`). The listed `65530:0:peer-ASN` / `65530:1:peer-ASN` values are operator-defined selective-advertisement communities, not RFC 8326 communities. Either add the actual GSHUT community or remove the RFC 8326 reference from this section."
- **Source**: RFC 8326

### 12.4-internet-exchange-point-design-answers.md — IPv6 Documentation Prefix Example Is Invalid Syntax
- **Severity**: minor
- **Current text**: "2001:db8:basx::/64"
- **Correction**: "Use a syntactically valid documentation prefix, e.g. `2001:db8:100::/64`. `basx` is not valid hexadecimal and therefore is not a valid IPv6 hextet."
- **Source**: RFC 4291; RFC 3849

### 12.4-internet-exchange-point-design-answers.md — RFC 8326 Is Referenced for the Wrong Communities
- **Severity**: minor
- **Current text**: "BasinIX implements RFC 8326-style graceful shutdown and selective advertisement communities"
- **Correction**: "RFC 8326 defines the well-known GRACEFUL_SHUTDOWN community (`65535:0`). The listed `65530:0:peer-ASN` / `65530:1:peer-ASN` values are operator-defined selective-advertisement communities, not RFC 8326 communities. Either add the actual GSHUT community or remove the RFC 8326 reference from this section."
- **Source**: RFC 8326

### 12.5-evpn-l2vpn-migration.md — Targeted LDP Session Scaling Is Overstated
- **Severity**: minor
- **Current text**: "VPWS: 5,000 pseudowires × 2 endpoints = 10,000 targeted LDP sessions" / "Each PW requires point-to-point LDP session between PE pair"
- **Correction**: "A targeted LDP session is established between PE peers, and multiple pseudowires can be multiplexed over the same LDP session. The scale issue is still real, but it should be described as many pseudowires and many PE-pair tLDP sessions — not one tLDP session per pseudowire endpoint."
- **Source**: RFC 5036; RFC 4447

### 12.5-evpn-l2vpn-migration.md — RFC 9572 Citation Does Not Match the Topic
- **Severity**: minor
- **Current text**: "### Option 3: Seamless VPWS-to-EVPN Interworking (RFC 9572)"
- **Correction**: "RFC 9572 is not a VPWS-to-EVPN interworking RFC; it updates EVPN BUM procedures. If this section is meant to reference EVPN-VPWS itself, cite RFC 8214. If it is meant to describe seamless coexistence with legacy VPWS, describe it as vendor-specific or draft-based rather than citing RFC 9572."
- **Source**: RFC 9572; RFC 8214

### 12.5-evpn-l2vpn-migration-answers.md — Targeted LDP Session Scaling Is Overstated
- **Severity**: minor
- **Current text**: "VPWS: 5,000 pseudowires × 2 endpoints = 10,000 targeted LDP sessions" / "Each PW requires point-to-point LDP session between PE pair"
- **Correction**: "A targeted LDP session is established between PE peers, and multiple pseudowires can be multiplexed over the same LDP session. The scale issue is still real, but it should be described as many pseudowires and many PE-pair tLDP sessions — not one tLDP session per pseudowire endpoint."
- **Source**: RFC 5036; RFC 4447

### 12.5-evpn-l2vpn-migration-answers.md — RFC 9572 Citation Does Not Match the Topic
- **Severity**: minor
- **Current text**: "### Option 3: Seamless VPWS-to-EVPN Interworking (RFC 9572)"
- **Correction**: "RFC 9572 is not a VPWS-to-EVPN interworking RFC; it updates EVPN BUM procedures. If this section is meant to reference EVPN-VPWS itself, cite RFC 8214. If it is meant to describe seamless coexistence with legacy VPWS, describe it as vendor-specific or draft-based rather than citing RFC 9572."
- **Source**: RFC 9572; RFC 8214
