# Module 9 (Transport/Optical) — Standards Review

**Reviewer:** Protocol Standards Reviewer (subagent)
**Date:** 2026-02-28
**Standards Referenced:** ITU-T G.694.1, G.709, G.872, G.698.2, OIF 400ZR IA (01.0/02.0), OpenZR+ MSA, RFC 4203, RFC 5307, RFC 7062

---

## 9.1-sp-transport-hierarchy.md

### Verified Claims (summary)
- Three-tier transport model (access/metro/long-haul) is well-structured and accurate
- C-band (1530–1565 nm) and L-band (1565–1625 nm) definitions match ITU-T conventions
- Flex-grid 6.25 GHz granularity per G.694.1 ✓
- Fiber standards correctly referenced: G.652, G.654.E, G.694.1, G.709, G.872
- Propagation delay ~5 μs/km is correct (c/n ≈ 200,000 km/s → 5 μs/km)
- Capacity-reach trade-off table: modulation formats, bits/symbol, and reach estimates are reasonable and include appropriate caveats
- GPON reach constraints and split-ratio loss considerations are accurate per G.984
- EDFA spacing, Raman amplification benefits, and OSNR concepts are sound
- Vendor landscape and emerging trends are current for the 2025–2026 timeframe

### Issues Found

- SEVERITY: **MINOR**
- CLAIM: "OCh-SNCP (UPSR)" and "OMS-SPRing (BLSR)"
- PROBLEM: UPSR and BLSR are SONET/SDH-specific terms (ITU-T G.841). While commonly used as analogies in training materials, they are not formally equivalent to the optical-layer protection schemes defined in ITU-T G.872/G.873. OCh-SNCP is defined in G.873.1; OMS shared protection is defined separately. The parenthetical mapping could confuse readers who look up the actual standards.
- STANDARD REFERENCE: ITU-T G.873.1 (OTN linear protection), ITU-T G.841 (SDH protection)
- SUGGESTED FIX: Change to "OCh-SNCP (analogous to SDH UPSR)" and "OMS-SPRing (analogous to SDH BLSR)" to make the analogy explicit rather than implied equivalence.

**Overall: Clean.** Section 9.1 is technically solid. The one issue is cosmetic.

---

## 9.2-dwdm-fundamentals.md

### Verified Claims (summary)
- DWDM frequency grid: anchor 193.1 THz ≈ 1552.52 nm matches G.694.1 ✓
- Channel formula f(n) = 193.1 + n × Δf ✓
- Flex-grid: central frequency 193.1 + n × 0.00625 THz, slot width m × 12.5 GHz ✓ per G.694.1
- Example C-band channel frequencies/wavelengths verified correct (C17 through C80)
- EDFA characteristics accurate: C-band gain bandwidth ~35 nm/~4.4 THz, NF 4–6 dB (quantum limit ~3 dB), output power +17 to +23 dBm ✓
- OSNR formula verified: constant 58 dB derives correctly from -10·log₁₀(2·h·ν·Bref) with h·ν = 1.28×10⁻¹⁹ J and Bref = 12.5 GHz → 57.96 ≈ 58 ✓
- OSNR calculation example (10 spans) verified: 1 - 5.5 - 10 + 58 = 43.5 dB ✓
- Raman amplification: pump wavelength ~1450 nm for C-band, effective NF -1 to 2 dB correctly qualified as equivalent NF ✓
- Fiber types (G.652.D, G.654.E, G.655, G.657.A2): dispersion and effective area values match ITU-T specs ✓
- G.654.E attenuation ~0.17 dB/km vs G.652.D ~0.20 dB/km ✓
- ROADM CDC-F definitions are accurate and well-explained ✓
- WSS/LCoS technology descriptions are accurate ✓
- Nonlinear impairment descriptions (SPM, XPM, FWM, SBS, SRS) are correct ✓
- SBS threshold ~10 dBm CW, higher for modulated signals ✓
- CWDM: 18 wavelengths at 20 nm spacing per G.694.2 ✓
- 400ZR reach ~120 km, 15–20W, DP-16QAM ✓ per OIF IA

### Issues Found

- SEVERITY: **CRITICAL**
- CLAIM: "fec ofec  ! Open FEC for interop" (in the IOS-XR configuration example for 400ZR)
- PROBLEM: The OIF 400ZR Implementation Agreement specifies **cFEC (Concatenated FEC)**, not oFEC. cFEC uses an inner soft-decision Hamming(128,119) code and an outer hard-decision Staircase BCH(255,239) code. oFEC is the FEC type specified by the **OpenZR+ MSA**, not 400ZR. These are different codes with different NCGs (~9.4 dB for cFEC vs ~11.1 dB for oFEC) and different pre-FEC thresholds. They are **not interoperable** with each other.
- STANDARD REFERENCE: OIF-400ZR-01.0/02.0 §5 "Concatenated FEC (C-FEC)"; OpenZR+ MSA Rev 3.0 (oFEC); Juniper documentation confirms cFEC structure for 400ZR; Acacia/Cisco white paper confirms "concatenated (hard-decision + soft-decision) FEC" for 400ZR
- SUGGESTED FIX: Change `fec ofec` to `fec cfec` in the 400ZR config example. Add a note: "400ZR uses cFEC (concatenated FEC) per OIF IA. OpenZR+ uses oFEC (open FEC) which has higher NCG (~11.1 dB vs ~9.4 dB) but is not interoperable with cFEC."

**Overall: One critical FEC type error.** Everything else in section 9.2 is technically excellent — particularly the OSNR formula derivation, fiber impairment descriptions, and ROADM architecture discussion.

---

## 9.3-otn-optical-transport-network.md

### Verified Claims (summary)
- OTN layer model (OPU/ODU/OTU/OCh/OMS/OTS) matches G.709/G.872 ✓
- OTU/ODU line rates verified correct:
  - OTU1: 2.666 Gbps, OTU2: 10.709 Gbps, OTU2e: 11.096 Gbps, OTU3: 43.018 Gbps, OTU4: 111.810 Gbps ✓
  - ODU0: 1.24416 Gbps, ODU1: 2.498 Gbps, ODU2: 10.037 Gbps, ODU2e: 10.399 Gbps ✓
- Frame structure: 4 rows × 4080 columns = 16,320 bytes ✓
- FAS: 0xF6F6F6282828 (6 bytes) matches G.709 ✓
- MFAS: 1 byte, 256-frame multiframe ✓
- Overhead breakdown (columns 1–14 OH, 15–16 OPU OH, 17–3824 payload, 3825–4080 FEC) ✓
- RS(255,239): 256 columns FEC, 16 interleaved codewords, corrects up to 8 symbol errors per codeword ✓
- RS(255,239) NCG ~6.0 dB (range 5.8–6.2) ✓
- 6 TCM levels per G.709 ✓
- TCM functionality (BIP-8, BEI, TTI, status bits) ✓
- ODU0 has no corresponding OTU0 ✓
- OTUCn and FlexO descriptions (G.709.1, G.709.3) are accurate ✓
- GMP as modern mapping procedure ✓
- GCC0/GCC1/GCC2 locations and purposes ✓
- HAO (G.7044) for hitless ODUflex resize ✓
- OTN protection schemes (SNC/I, SNC/N) per G.873.1 ✓
- Standards roadmap (G.709, G.709.1, G.709.3, G.798, G.872, G.873.x, G.7042, G.7044, G.7710) ✓

### Issues Found

- SEVERITY: **MODERATE**
- CLAIM: "or 2 × ODU3 (31 TS each, 18 TS remaining)"
- PROBLEM: Per ITU-T G.709, ODU3 into ODU4 uses **32 tributary slots** of 1.25G each, not 31. Two ODU3s therefore consume 64 TS, leaving **16 TS remaining** (80 − 64 = 16), not 18. This is confirmed by multiple references including the Thunder-Link G.709 tutorial and RFC 7062, and is consistent with the rate arithmetic: OPU4 effective TS rate × 32 accommodates the ODU3 payload.
- STANDARD REFERENCE: ITU-T G.709 (2020) Table 19-5; RFC 7062 §3.1 confirms ODU3 = 32 TS in ODU4 (1.25G TS granularity)
- SUGGESTED FIX: Change to "or 2 × ODU3 (32 TS each, 16 TS remaining)"

---

- SEVERITY: **MODERATE**
- CLAIM: FEC table entry: "oFEC (open FEC, OIF) | ~11.1 dB | ~1.5 × 10⁻² | ~25% | 400ZR/ZR+ standard"
- PROBLEM: Two errors in this row. (1) **oFEC is NOT the 400ZR standard.** The OIF 400ZR IA specifies cFEC (concatenated FEC). oFEC is the OpenZR+ MSA standard. The "Notes" column should say "OpenZR+ standard" not "400ZR/ZR+ standard." (2) **oFEC overhead is ~15% (14.8%), not ~25%.** The ~25% figure significantly overstates the bandwidth penalty. Section 9.5 of the same study guide correctly states "~14.8% net coding overhead" for oFEC.
- STANDARD REFERENCE: OIF-400ZR-02.0 (specifies cFEC); OpenZR+ MSA Rev 3.0 (specifies oFEC with ~14.8% overhead)
- SUGGESTED FIX: Change row to: "oFEC (open FEC, OpenZR+ MSA) | ~11.1 dB | ~1.5 × 10⁻² | ~15% | OpenZR+ standard". Add/update the cFEC row: "cFEC (concatenated FEC, OIF) | ~9.4 dB | ~4.5 × 10⁻³ | ~15% | 400ZR standard, FlexO"

---

- SEVERITY: **MINOR**
- CLAIM: "FEC limit/threshold: The pre-FEC BER at which FEC can no longer correct all errors. For RS(255,239): ~1.8 × 10⁻⁴."
- PROBLEM: The ~1.8 × 10⁻⁴ value is a conservative operating threshold found in some ITU-T/submarine literature (targeting post-FEC BER < 10⁻¹² with wide margin). The actual correction cliff for RS(255,239) — where post-FEC errors begin appearing — is approximately **3.8 × 10⁻³**, which is the value cited in section 9.5's FEC table. Both values appear in industry literature but represent different operating points. Using 1.8 × 10⁻⁴ as "the threshold at which FEC can no longer correct" is misleading — the code continues correcting up to ~3.8 × 10⁻³ for random errors.
- STANDARD REFERENCE: RS(255,239) correction capability t=8 symbols; at BER ~3.8×10⁻³, expected symbol errors ≈ correction limit
- SUGGESTED FIX: Change to: "For RS(255,239): ~3.8 × 10⁻³ (hard correction limit for random errors). Conservative operating targets often use ~1 × 10⁻⁴ to maintain margin."

---

## 9.4-packet-optical-integration.md

### Verified Claims (summary)
- Integration spectrum (ships-in-the-night through converged) is well-structured ✓
- Multi-layer coordination architecture (BGP-LS, YANG, RESTCONF/NETCONF) ✓
- GMPLS switching capabilities (PSC, L2SC, TDM, LSC, FSC) match RFC 3945/4202 ✓
- GMPLS hierarchy PSC < L2SC < TDM < LSC < FSC ✓
- UNI (UNI-C, UNI-N) architecture per OIF UNI specification ✓
- SRLG concepts and configuration examples ✓
- OpenConfig YANG models for optical equipment correctly listed ✓
- OpenROADM MSA description accurate ✓
- TAPI (ONF Transport API) service descriptions ✓
- Alien wavelength concept and challenges accurately described ✓
- OpenZR+ specifications (100–400G, DP-QPSK to DP-16QAM, flex-grid, oFEC) ✓
- IPoDWDM architecture and migration strategy well-reasoned ✓
- BGP-LS and SRLG configuration examples (IOS-XR/Junos) look syntactically reasonable ✓

### Issues Found

- SEVERITY: **CRITICAL**
- CLAIM: 400ZR table row: "FEC | oFEC (concatenated, ~6.2 dB NCG)"
- PROBLEM: Three errors compounded. (1) **Wrong FEC type**: 400ZR uses cFEC (concatenated FEC), not oFEC. (2) **Wrong NCG**: cFEC NCG is ~9.4 dB, not 6.2 dB. The 6.2 dB value is for standard RS(255,239) HD-FEC — a completely different code. (3) **Misleading label**: Calling it "concatenated" while labeling it "oFEC" creates confusion, since cFEC is the concatenated code and oFEC is a different (block-based iterative SD) code. This error would lead to incorrect link budget calculations — the actual cFEC provides approximately 3.2 dB more coding gain than the stated 6.2 dB, a massive difference in reach planning.
- STANDARD REFERENCE: OIF-400ZR-02.0 §5 defines C-FEC; cFEC NCG ~9.4 dB per multiple industry references; oFEC NCG ~11.1 dB per OpenZR+ MSA
- SUGGESTED FIX: Change to: "FEC | cFEC (concatenated HD+SD, ~9.4 dB NCG)"

---

- SEVERITY: **MODERATE**
- CLAIM: 400ZR table row: "Wavelength Grid | 100 GHz ITU grid, C-band (48 channels)"
- PROBLEM: The OIF 400ZR IA (02.0) explicitly supports **75 GHz channel spacing** on the ITU-T G.694.1 flex-grid, yielding approximately **64 channels** in the C-band. While 400ZR can also operate on a 100 GHz fixed grid (48 channels), this is the less common deployment and not the primary specification. This table is also internally inconsistent with section 9.5, which correctly states "75 GHz" and "~64 channels." Juniper documentation confirms 400ZR supports both 75 GHz and 100 GHz spacing.
- STANDARD REFERENCE: OIF-400ZR-02.0 (added 75 GHz support); Juniper coherent optics documentation
- SUGGESTED FIX: Change to: "Wavelength Grid | 75 GHz flex-grid (preferred) or 100 GHz fixed, C-band (~64 or 48 channels)"

---

- SEVERITY: **MINOR**
- CLAIM: "RFC 4258 | IETF | GMPLS OTN framework"
- PROBLEM: RFC 4258 is "Requirements for Generalized Multi-Protocol Label Switching (GMPLS) Signaling Usage and Extensions for Automatically Switched Optical Network (ASON)." The GMPLS OTN control framework is actually **RFC 7062** ("Framework for GMPLS and PCE Control of G.709 Optical Transport Networks").
- STANDARD REFERENCE: RFC 4258 (ASON signaling requirements), RFC 7062 (GMPLS/PCE OTN framework)
- SUGGESTED FIX: Change to: "RFC 7062 | IETF | GMPLS and PCE framework for G.709 OTN" (keep RFC 4258 separately as ASON signaling requirements if desired)

---

- SEVERITY: **MINOR**
- CLAIM: 400ZR table row: "Power | <15W per module"
- PROBLEM: Internally inconsistent with section 9.5, which states "Power: ~15–20W" and "A 400G ZR QSFP-DD module's DSP burns ~12–15W of the total ~18–20W." The OIF IA targets <15W but many real-world 400ZR modules consume 15–20W. The "<15W" is the spec target; "15–20W" in section 9.5 better reflects deployed reality.
- STANDARD REFERENCE: OIF-400ZR-02.0 power specification; vendor datasheets (Acacia, Inphi/Marvell)
- SUGGESTED FIX: Change to: "Power | 15–20W per module" to match section 9.5 and deployed reality. Or qualify: "<15W (OIF target); 15–20W typical in deployed modules"

---

## 9.5-coherent-optics.md

### Verified Claims (summary)
- Coherent vs direct detection comparison ✓
- 90° optical hybrid and balanced photodetector architecture ✓
- DSP pipeline (CD compensation, PMD tracking, carrier recovery, FEC) ✓
- Modulation format constellation diagrams and bits/symbol:
  - DP-QPSK: 4 bits/sym, DP-8QAM: 6, DP-16QAM: 8, DP-32QAM: 10, DP-64QAM: 12 ✓
- OSNR requirements per modulation format are reasonable ✓
- Reach estimates for each modulation format are reasonable and consistent with section 9.1 ✓
- Probabilistic Constellation Shaping (PCS): 1–1.5 dB OSNR gain, continuous rate adaptation ✓
- PCS approaching Shannon limit (~0.5 dB gap vs ~1.5 dB for uniform QAM) ✓
- Single-carrier vs multi-carrier 800G approaches accurately described ✓
- KP4-FEC (RS(544,514), IEEE 802.3 Clause 119) correctly identified as host-side only ✓
- oFEC overhead correctly stated as ~14.8% net coding overhead (contradicting section 9.3's ~25%) ✓
- oFEC NCG ~11.1 dB confirmed by OpenZR+ MSA documentation and GIGALIGHT reference ✓
- OSFP-XD form factor for 800G pluggables ✓
- PAM4 as bridge technology for short-reach ✓
- Capacity calculations: 64×400G (75 GHz) = 25.6 Tb/s, 32×800G (150 GHz) = 25.6 Tb/s — correct, with accurate insight that 800G doesn't increase total fiber capacity at wider spacing ✓
- Coherent module architecture (tunable laser, DP-IQ modulator, ICR, DSP ASIC) ✓
- CMIS management interface ✓
- Vendor DSP implementations (WaveLogic, ICE, PSE, CIM) accurately described ✓
- 800G+ roadmap and challenges (power, bandwidth, spectral width) are current ✓

### Issues Found

- SEVERITY: **CRITICAL**
- CLAIM: Under "400ZR (OIF Implementation Agreement)": "FEC: oFEC (concatenated, interoperable)" and the FEC table entry "oFEC (OIF standard) | ~11.1 dB | ~1.25×10⁻² | ~15% | 400ZR"
- PROBLEM: **400ZR uses cFEC, not oFEC.** The OIF 400ZR IA explicitly specifies C-FEC (Concatenated FEC) with NCG ~9.4 dB. oFEC is the OpenZR+ MSA standard with NCG ~11.1 dB. These are different codes and are **not interoperable** with each other. This same error appears in sections 9.2, 9.3, and 9.4 — it is a systemic confusion throughout Module 9. Additionally, the code structure described in this section ("Concatenated code: Hamming(128,119) inner + Staircase outer") is actually the **cFEC** structure, per Juniper documentation: "CFEC concatenates two FEC codes with each other, an inner soft-decision Hamming(128,119) code and an outer Staircase BCH(255,239) hard-decision outer code." The section correctly describes the structure but assigns it the wrong name.
- STANDARD REFERENCE: OIF-400ZR-02.0 §5 "Concatenated FEC (C-FEC)"; OpenZR+ MSA Rev 3.0 (oFEC); Juniper Networks coherent optics documentation (confirms cFEC = Hamming + Staircase); Acacia white paper confirms 400ZR uses "concatenated (hard-decision + soft-decision) FEC"
- SUGGESTED FIX: (1) Change 400ZR FEC to "cFEC (concatenated FEC, interoperable per OIF IA)". (2) Move the Hamming(128,119) + Staircase description under cFEC. (3) Update FEC table: "cFEC (OIF 400ZR standard) | ~9.4 dB | ~4.5×10⁻³ | ~15% | 400ZR" and "oFEC (OpenZR+ MSA standard) | ~11.1 dB | ~1.25×10⁻² | ~15% | OpenZR+". (4) Fix this same error in sections 9.2, 9.3, and 9.4.

---

- SEVERITY: **MINOR**
- CLAIM: "Grid: 75 GHz fixed channel spacing" (under 400ZR specification)
- PROBLEM: The OIF 400ZR IA uses the ITU-T G.694.1 **flex-grid** with 75 GHz slot width (6 × 12.5 GHz), not a "fixed" grid. Describing it as "fixed channel spacing" is misleading since the underlying mechanism is flex-grid allocation. The distinction matters for network planning — a flex-grid ROADM is needed to support 75 GHz slots alongside other slot widths.
- STANDARD REFERENCE: OIF-400ZR-02.0; ITU-T G.694.1 flex-grid definition
- SUGGESTED FIX: Change to "Grid: 75 GHz slot width (ITU-T G.694.1 flex-grid)"

---

- SEVERITY: **MINOR**
- CLAIM: FEC table: "HD-FEC (RS) | ~6.2 dB | 3.8×10⁻³ | ~7% | Legacy 10G/40G"
- PROBLEM: The pre-FEC BER threshold of 3.8×10⁻³ is the hard correction cliff for RS(255,239), but section 9.3 cites ~1.8×10⁻⁴ for the same code. While both values have support in industry literature (3.8×10⁻³ = theoretical correction limit for random errors; 1.8×10⁻⁴ = conservative operating threshold in ITU-T G.975 context), having two different values in the same study guide without explanation creates confusion. The values should be reconciled with clear definitions.
- STANDARD REFERENCE: RS(255,239) correction capability t=8 symbols; various ITU-T and industry references
- SUGGESTED FIX: Use 3.8×10⁻³ consistently as the correction cliff and note in section 9.3 that operational targets are typically 1–2 orders of magnitude below the cliff for margin. Or add a "Notes" column to both FEC tables explaining the definition used.

---

## Cross-Section Issues

### Systemic Issue: 400ZR FEC Confusion (cFEC vs oFEC)

This is the most significant finding in the review. The confusion between cFEC and oFEC for 400ZR appears in **all five sections**:

| Section | Claim | Correct |
|---------|-------|---------|
| 9.2 | Config example: `fec ofec` for 400ZR | Should be `fec cfec` |
| 9.3 | FEC table: oFEC = "400ZR/ZR+ standard" | oFEC = OpenZR+ only; 400ZR = cFEC |
| 9.3 | FEC table: oFEC overhead ~25% | oFEC overhead ~15% |
| 9.4 | 400ZR table: "oFEC (concatenated, ~6.2 dB NCG)" | cFEC, ~9.4 dB NCG |
| 9.5 | 400ZR spec: "FEC: oFEC" | Should be cFEC |
| 9.5 | FEC table: "oFEC (OIF standard)... 400ZR" | oFEC is OpenZR+ standard |
| 9.5 | oFEC structure "Hamming(128,119) + Staircase" | This IS the cFEC structure |

**Root cause:** The author appears to have conflated the two FEC types. cFEC (concatenated FEC) is the OIF 400ZR standard; oFEC (open FEC) is the OpenZR+ MSA standard. They have different structures, different NCGs, and are not interoperable.

**Impact:** High. Incorrect FEC type affects link budget calculations, interoperability planning, and operational troubleshooting. A network engineer using oFEC NCG (~11.1 dB) for 400ZR link budget instead of cFEC NCG (~9.4 dB) would overestimate reach by ~20–30%.

**Recommended fix:** A single pass through all five sections replacing 400ZR's FEC references with cFEC and ensuring oFEC is attributed only to OpenZR+.

---

## Summary

| Section | Critical | Moderate | Minor | Status |
|---------|----------|----------|-------|--------|
| 9.1 | 0 | 0 | 1 | ✅ Clean |
| 9.2 | 1 | 0 | 0 | ⚠️ FEC type error |
| 9.3 | 0 | 2 | 1 | ⚠️ ODU3 TS count + FEC issues |
| 9.4 | 1 | 1 | 2 | ❌ FEC NCG error + grid error |
| 9.5 | 1 | 0 | 2 | ⚠️ FEC type error |
| **Cross-section** | **1** | — | — | ❌ Systemic cFEC/oFEC confusion |

**Total: 3 CRITICAL, 3 MODERATE, 6 MINOR issues**

The critical issues all stem from a single root cause (cFEC/oFEC confusion). Fixing this systemic issue resolves all three critical findings. The moderate issues (ODU3 TS count, oFEC overhead, 400ZR grid) are independent and straightforward to correct.

**Overall assessment:** Module 9 is technically excellent in its coverage of DWDM physics, amplifier engineering, ROADM architecture, OTN framing, coherent DSP, and packet-optical integration. The depth and accuracy of the optical engineering content is impressive. The cFEC/oFEC confusion is a notable blind spot that should be corrected before publication, as it affects practical network design decisions. All other issues are minor or moderate and easily fixable.
