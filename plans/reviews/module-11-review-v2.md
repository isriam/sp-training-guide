# Module 11 (Automation) — Technical Accuracy Review v2

## Summary
- **Files reviewed**: 11
- **Result**: issues found
- **Previous v1 fixes status**: 10 of the 11 previously reported issues appear correctly fixed; 1 previously reported issue remains partially unresolved
- **Additional findings**: 5 new technical issues found in this pass
- **Severity counts**: critical **2**, minor **4**
- **Files with remaining issues**:
  - 11.1-model-driven-networking.md
  - 11.1-model-driven-networking-answers.md
  - 11.2-streaming-telemetry.md
  - 11.3-sr-te-controller-integration.md
- **Verified clean in this pass**:
  - 11.1-model-driven-networking-theory.md
  - 11.2-streaming-telemetry-theory.md
  - 11.3-sr-te-controller-integration-answers.md
  - 11.4-cicd-network-config.md
  - 11.4-cicd-network-config-answers.md
  - 11.5-lab-gnmi-sr-te-automation.md
  - 11.5-lab-gnmi-sr-te-automation-answers.md

### [11.1-model-driven-networking.md] — ncclient example still omits the required `<config>` root
- **Severity**: critical
- **Current text**: "# NOTE: ncclient edit_config() expects the payload rooted in <config>...</config>\nconfig_xml = \"\"\"\n  <interfaces xmlns=\"urn:ietf:params:xml:ns:yang:ietf-interfaces\">\n    <interface> ... </interface>\n  </interfaces>\n\"\"\""
- **Correction**: "Wrap `config_xml` itself in `<config>...</config>`, or change the note to match a helper that actually adds the wrapper. As written, the note is correct but the payload directly below it is not."
- **Source**: RFC 6241 Section 7.2; ncclient `EditConfig` documentation

### [11.1-model-driven-networking-answers.md] — Junos commit-delay explanation misstates the database implementation and remediation
- **Severity**: minor
- **Current text**: "Junos stores config in a SQLite-based CDB. If the CDB is fragmented or the disk is slow (common on older RE/RE-x86 platforms), commit time increases. This is especially noticeable after many incremental commits without a `request system configuration rescue save`."
- **Correction**: "Remove the SQLite/rescue-save claim. Junos documentation describes configuration-database sizing/growth and database resize controls, but `request system configuration rescue save` is a rescue-config backup action, not a documented CDB defragmentation or commit-performance fix."
- **Source**: Juniper `configuration-database` documentation; Juniper `request system configuration database resize` documentation; Juniper `request system configuration rescue save` documentation

### [11.2-streaming-telemetry.md] — `ROUTING-STATE` sensor is pointed at a firewall telemetry path
- **Severity**: minor
- **Current text**: "set services analytics sensor ROUTING-STATE resource /junos/system/linecard/firewall/"
- **Correction**: "Either rename the sensor to reflect firewall telemetry or replace the resource with an actual routing-related native JTI sensor path. `/junos/system/linecard/firewall/` is a firewall sensor path, not routing state."
- **Source**: Juniper JTI Resource Filtering / native sensor-path documentation

### [11.3-sr-te-controller-integration.md] — SR-TE is overstated as always requiring stateful PCE delegation in production
- **Severity**: minor
- **Current text**: "All production SR-TE deployments use **stateful PCE with delegation** — the PCE actively manages LSP segment lists and can update them without PCC request."
- **Correction**: "Reword to say stateful PCE with delegation is common in controller-driven SR-TE deployments, but SR policies can also be locally configured or locally computed without a PCE."
- **Source**: RFC 9256; vendor SR-TE documentation for locally configured SR policies

### [11.3-sr-te-controller-integration.md] — Non-delegated LSP behavior is described incorrectly
- **Severity**: minor
- **Current text**: "**Non-delegated LSP:** PCC retains control. PCE can only suggest updates via PCUpdate; PCC decides whether to apply."
- **Correction**: "For a non-delegated LSP, the PCC retains control and the PCE cannot modify it with `PCUpd`. The PCE may compute/propose a path when requested, but `PCUpd` is for delegated/PCE-controlled LSP state."
- **Source**: RFC 8231 Sections 5 and 7; RFC 8741

### [11.3-sr-te-controller-integration.md] — Junos color extended community syntax is reversed
- **Severity**: critical
- **Current text**: "community COLOR-100 members color:100:0;\ncommunity COLOR-200 members color:200:0;"
- **Correction**: "Use Junos color-community syntax `color:0:100` and `color:0:200` (CO bits first, then the color value)."
- **Source**: RFC 9012; Juniper *Color-Based Traffic Engineering Configuration* documentation
