# Hybrid Metacard Standard v3

**Status:** Draft for enterprise baseline adoption  
**Audience:** Data governance, security, records management, architecture, and platform engineering teams  
**Primary Goal:** Define a practical, enterprise-wide hybrid metacard profile that unifies discovery metadata (IRM), security markings (ISM), and records management (ERM), while carrying transport-ready bindings for EDH and TDF.  
**Secondary Goal:** Define an implementation pattern for Netwrix Data Classification (5.7) taxonomies and API-serving of metacards.

---

## 1) Executive Summary

This standard establishes a **single logical metacard** for data assets across a large organization. The metacard is built from current technical metadata specifications, with DDMS treated as historical context only.

### 1.1 Scope in v3

- **In scope:**
  - IRM discovery/catalog metadata
  - ISM security marking metadata
  - ERM records management metadata
  - EDH binding metadata for exchange
  - TDF binding metadata for transport/protection
  - Optional UIAS/UAIS context fields for identity-aware policy integration
- **Out of scope:**
  - Replacing authoritative source systems for security/records decisions
  - Defining cryptographic algorithms beyond approved organizational policy
  - Product-specific UI walk-throughs for every Netwrix console page

### 1.2 Design principles

1. **One logical metacard, many technical renderings** (JSON operational profile; XML crosswalk to standards).
2. **Authoritative-first population** for high-integrity governance fields (classification, owner, retention controls, legal holds).
3. **Taxonomy-derived enrichment** for discovery and inferable values.
4. **Versioned profile contract** to support long-term interoperability.
5. **Security-first publishing**: API output is filtered by policy and caller context.

---

## 2) Standards Baseline and Interpretation

This v3 profile is grounded in the repository’s current technical standards packages and schemas.

### 2.1 DDMS disposition

- DDMS 3.1 concepts (including historical “metacard” framing) are treated as **deprecated context**.
- The operational baseline uses **IRM + ISM + ERM + EDH + TDF**, with optional UIAS/UAIS alignment.

### 2.2 Current standards used by this profile

- **IRM** (`urn:us:gov:ic:irm`) — discovery and resource catalog metadata.
- **ISM** (`urn:us:gov:ic:ism`) — security markings and handling attributes.
- **ERM** (`urn:us:gov:ic:erm`) — records governance and disposition controls.
- **EDH** (`urn:us:gov:ic:edh`) — exchange header metadata.
- **BASE-TDF / IC-TDF** — transport package assertions, bindings, payload protection.
- **UIAS/UAIS** (`urn:us:gov:ic:uias`) — identity/attribute context (optional but recommended for policy integration).

---

## 3) Hybrid Metacard Model (Logical)

The enterprise metacard is represented as six layers plus governance metadata.

```text
HybridMetacard
├── profile (profile id/version, status, validation stamp)
├── irm (discovery/catalog)
├── ism (security markings)
├── erm (records management)
├── edhBinding (exchange binding data)
├── tdfBinding (transport/binding data)
├── uiasContext (optional identity/access context)
└── governance (source authority, confidence, provenance)
```

### 3.1 Canonical profile identifier

- `metacardProfileId`: `ORG-HYBRID-METACARD`
- `metacardProfileVersion`: `3.0.0`

### 3.2 Cardinality conventions

- **R** = required for all assets
- **C** = conditionally required
- **O** = optional
- **A** = authoritative source required (must not be taxonomy-only)

---

## 4) Normative Field Dictionary

## 4.1 IRM Layer (Discovery/Catalog)

| Field Key | Req | Notes |
|---|---|---|
| `irm.metacardInfo.identifier[]` | R | Unique identifiers for this metacard assertion. |
| `irm.identifier[]` | R | Unique identifiers for described asset. |
| `irm.title[]` | R | Human-readable title(s). |
| `irm.description` | O | Summary/abstract. |
| `irm.language[]` | O | Language tags/codes. |
| `irm.dates.created` | C | Required when available from source metadata. |
| `irm.dates.posted` | O | Catalog publication date. |
| `irm.dates.validTil` | O | Catalog expiry/date-to-review. |
| `irm.creator[]` / `publisher[]` / `contributor[]` / `pointOfContact[]` | R | At least one contact role must be present. |
| `irm.format.mimeType` | C | Required if `irm.format` present. |
| `irm.format.extent` | O | Size/extent. |
| `irm.subjectCoverage[]` | R | One or more controlled coverage terms. |
| `irm.temporalCoverage[]` | O | Temporal scope. |
| `irm.geospatialCoverage[]` | O | Geospatial scope. |
| `irm.relatedResource[]` | O | Lineage/dependency links. |
| `irm.resourceManagement` | O | Tasking/processing management data. |
| `irm.compliesWith` | R | Validation/compliance profile declaration. |

**IRM baseline rule:** `irm.metacardInfo`, at least one `irm.identifier`, and at least one `irm.title` are mandatory for publishable metacards.

---

## 4.2 ISM Layer (Security Marking)

| Field Key | Req | Notes |
|---|---|---|
| `ism.classification` | R/A | Required for protected resources; use authoritative value when available. |
| `ism.ownerProducer` | R/A | Required with classification. |
| `ism.disseminationControls` | C/A | Conditional by policy/mission rules. |
| `ism.releasableTo` | C/A | Conditional if REL controls apply. |
| `ism.nonUSControls` | C/A | Required where non-US controls are used. |
| `ism.SCIcontrols` | C/A | Required where SCI applies. |
| `ism.SARIdentifier` | C/A | Required where SAR controls apply. |
| `ism.atomicEnergyMarkings` | C/A | Required where atomic energy controls apply. |
| `ism.cuiBasic` / `ism.cuiSpecified` | C/A | CUI handling fields where applicable. |
| `ism.cuiControlledBy` / `ism.cuiControlledByOffice` / `ism.cuiPOC` | C/A | CUI authority references. |
| `ism.declassDate` / `ism.declassEvent` / `ism.declassException` | C/A | Declassification controls where classified. |
| `ism.derivedFrom` / `ism.classificationReason` / `ism.classifiedBy` / `ism.derivativelyClassifiedBy` | C/A | Classification provenance context. |
| `ism.secondBannerLine` | O | Supplemental line for special handling. |
| `ism.handleViaChannels` | O | Channel handling constraints. |

**ISM baseline rule:** if an asset is governed as protected/sensitive, `classification` and `ownerProducer` must be present and policy-valid before API publication.

---

## 4.3 ERM Layer (Records Management)

| Field Key | Req | Notes |
|---|---|---|
| `erm.officeOfRecord` | R/A | Organization responsible for record decisions. |
| `erm.foiaOpsIndicator` | O | Exclusion from FOIA ops/search where policy applies. |
| `erm.recordDesignationDate` | C/A | Date record enters retention lifecycle. |
| `erm.vitalRecordsIndicator` | O | Essential continuity record indicator. |
| `erm.disposition.reviewIndicator` | R/A | Indicates disposition review status. |
| `erm.disposition.recordControl` | C/A | Retention schedule/control identifier. |
| `erm.disposition.dateEligible` | O | Eligible disposition date. |
| `erm.disposition.dateLimit` | O | Deadline for disposition action. |
| `erm.disposition.appliedBy` / `dateApplied` | O | Disposition execution details. |
| `erm.disposition.hold[]` | C/A | Legal/regulatory hold metadata where active. |
| `erm.disposition.hold[].type` | C/A | Hold category token. |
| `erm.disposition.hold[].authorizer` | C/A | Responsible authority for hold. |
| `erm.disposition.hold[].effectiveDate` | C/A | Hold activation timestamp. |
| `erm.disposition.hold[].identifier` | O | Hold identifier. |
| `erm.disposition.hold[].justification` | O | Hold rationale. |
| `erm.disposition.hold[].releasedDate` | O | Hold release timestamp. |

**ERM baseline rule:** metacard publication for declared records requires `officeOfRecord` and `disposition.reviewIndicator` at minimum.

---

## 4.4 EDH Binding Layer (Exchange)

| Field Key | Req | Notes |
|---|---|---|
| `edh.identifier` | R/A | Exchange header ID for data item. |
| `edh.dataItemCreateDateTime` | R/A | Creation timestamp of data item. |
| `edh.authorizationReference` | O/A | Authority reference when required. |
| `edh.responsibleEntity[]` | R/A | Must include one Custodian; optional Originator. |
| `edh.dataSet` | O | Dataset context where applicable. |
| `edh.security` | R/A | ARH security component binding for exchange context. |

**EDH baseline rule:** exactly one Custodian role must exist for EDH-conformant outbound exchange.

---

## 4.5 TDF Binding Layer (Transport/Protection)

| Field Key | Req | Notes |
|---|---|---|
| `tdf.packageType` | R | `TrustedDataObject` or `TrustedDataCollection`. |
| `tdf.assertion[]` | R | Includes handling assertions and metadata assertions. |
| `tdf.binding[]` | C/A | Signature/binding when integrity enforcement required. |
| `tdf.encryptionInformation[]` | C/A | Required for encrypted transport package. |
| `tdf.payload.type` | R | String/base64/reference/structured payload form. |
| `tdf.payload.reference` | C | Required when payload is reference-based. |
| `tdf.hashAlgorithm` / `signatureAlgorithm` | C/A | Required when bound or signed. |
| `tdf.appliesToState` | O | State application semantics as needed. |

**TDF baseline rule:** outbound protected transport requires assertion + encryption/binding policy checks before release.

---

## 4.6 UIAS/UAIS Context Layer (Optional in v3 baseline)

| Field Key | Req | Notes |
|---|---|---|
| `uias.entityType` | O | Person/system/service identity category. |
| `uias.clearance` | O/A | Clearance data where integrated with policy engine. |
| `uias.authorityCategory` | O | Access authority category. |
| `uias.role[]` | O | Role context attributes. |
| `uias.group[]` | O | Group affiliation attributes. |
| `uias.countryOfAffiliation` | O | Affiliation country. |
| `uias.originatingNetwork` | O | Origin network identity context. |
| `uias.fineAccessControls` | O/A | Fine-grained controls where supported. |
| `uias.lifecycleStatus` | O | Identity lifecycle state. |

**UIAS guidance:** include when metacards are used directly by policy-based access/routing systems.

---

## 5) Mandatory Validation Rules

A metacard is **Publishable** only if all checks below pass.

1. `profile.metacardProfileVersion` present and supported.
2. IRM minimum set satisfied:
   - `irm.metacardInfo.identifier[]` non-empty
   - `irm.identifier[]` non-empty
   - `irm.title[]` non-empty
3. If `ism.classification` present or implied by source policy, `ism.ownerProducer` must be present.
4. If record-declared asset, `erm.officeOfRecord` and `erm.disposition.reviewIndicator` must be present.
5. If EDH outbound exchange flag is true:
   - `edh.identifier`, `edh.dataItemCreateDateTime`, and one `Custodian` responsible entity are required.
6. If TDF outbound transport flag is true:
   - `tdf.packageType`, at least one assertion, and required encryption/binding fields per policy must be present.
7. API publication policy filter must pass (classification and caller authorization checks).

---

## 6) Enterprise Data Contract (Canonical JSON)

A JSON Schema companion is provided at:

- `docs/companion/hybrid-metacard-standard-v3.schema.json`

A field mapping companion is provided at:

- `docs/companion/hybrid-metacard-standard-v3-crosswalk.csv`

---

## 7) Netwrix Data Classification Implementation Blueprint

> **Important implementation note:** The approach below is a product-agnostic Netwrix 5.7 configuration pattern tailored for taxonomy-driven metadata extraction and API-serving. Final control names, endpoint names, and exact UI paths should be validated against your specific Netwrix deployment and entitlement model.

### 7.1 Taxonomy architecture

Implement **modular taxonomy families**:

1. `MC_IRM_*` — discovery/catalog fields
2. `MC_ISM_*` — security marking fields
3. `MC_ERM_*` — records governance fields
4. `MC_EDH_*` — exchange header fields
5. `MC_TDF_*` — transport/binding fields
6. `MC_UIAS_*` — optional identity context

### 7.2 Rule strategy

Use a tiered extraction strategy:

- **Tier 1: deterministic pattern rules**
  - IDs, timestamps, known control tokens
- **Tier 2: contextual rules**
  - header-label/value proximity and section-aware extraction
- **Tier 3: enrichment transforms**
  - normalize values to controlled vocabulary
  - derive helper flags (e.g., `isProtected`, `isRecord`)

### 7.3 Required taxonomy-to-field mapping practices

- One canonical metacard field key per taxonomy output.
- Keep original extraction token for auditability.
- Store confidence score and extraction source rule ID.
- Add `authoritativeOverride` indicator where external authoritative sources supersede extracted values.

### 7.4 API-serving pattern

Configure Netwrix API exposure so callers can query and retrieve metacard fields as a stable contract:

- Expose a **versioned API projection** containing only `MC_*` metacard fields and governance metadata.
- Include required filtering parameters:
  - classification boundary
  - repository/source
  - modified timestamp range
  - confidence threshold
- Return consistent shape:
  - `assetId`, `metacardProfileVersion`, layered objects (`irm`, `ism`, `erm`, `edhBinding`, `tdfBinding`, `uiasContext`, `governance`)
- Enforce policy filter prior to response serialization.

### 7.5 Recommended configuration sequence

1. Define canonical field dictionary from this standard.
2. Create taxonomy families and terms (`MC_*`).
3. Build extraction and normalization rules.
4. Configure indexing/storage for required fields.
5. Configure API projection and policy filters.
6. Validate with representative corpora (unclassified, CUI, classified metadata containers, record and non-record assets).
7. Move to controlled production wave with drift/quality metrics.

---

## 8) Known Weaknesses, Edge Cases, and Gaps

### 8.1 Taxonomy-only limitations

Some fields cannot be safely inferred from content alone:

- `ism.classification`, `ism.ownerProducer`
- record legal hold state (`erm.disposition.hold[]`)
- authoritative retention control (`erm.disposition.recordControl`)

**Mitigation:** integrate authoritative metadata feeds and apply override precedence.

### 8.2 Mixed classification discovery risk

Index metadata may itself be sensitive. A lower-side API could leak sensitive descriptors.

**Mitigation:** strict field-level classification policy and response filtering by caller context.

### 8.3 Vocabulary drift

Controlled vocabularies evolve; stale terms create interoperability defects.

**Mitigation:** scheduled CVE synchronization, profile versioning, and validation gates for deprecated tokens.

### 8.4 Commingled and derived content

Assets can contain multiple classification contexts or derivative lineage complexity.

**Mitigation:** support commingled markings, preserve provenance, and require revalidation on transformations.

### 8.5 Binary/opaque payloads

Some scanned data cannot expose rich metadata by taxonomy extraction.

**Mitigation:** sidecar metadata ingestion and source-system metadata federation.

### 8.6 Identity context ambiguity

UIAS fields may be unavailable for non-IC domains.

**Mitigation:** keep `uiasContext` optional; require only when policy integration needs identity-aware constraints.

---

## 9) Deployment and Governance Model

### 9.1 Control ownership

- **Metadata Governance Office**: field catalog, profile versioning, drift policy
- **Security Office**: ISM mapping rules and publication controls
- **Records Office**: ERM retention/hold authority mappings
- **Platform Team**: Netwrix taxonomy/rule and API operations

### 9.2 Profile lifecycle

- `v3.x` patch updates: non-breaking clarifications/rule tuning
- `v4.0` major update: breaking field or semantics changes

### 9.3 Operational KPIs

- Required-field completion rate
- Authoritative override rate
- Extraction precision/recall by taxonomy family
- API policy-filter rejection rate
- Vocabulary compliance pass rate

---

## 10) Example Publishable Metacard (Abbreviated)

```json
{
  "profile": {
    "metacardProfileId": "ORG-HYBRID-METACARD",
    "metacardProfileVersion": "3.0.0",
    "status": "Publishable"
  },
  "irm": {
    "metacardInfo": {
      "identifier": ["MC-2026-0001"]
    },
    "identifier": ["ASSET-01-ABC"],
    "title": ["Program Data Asset A"],
    "description": "Sample catalog description.",
    "compliesWith": "ORG-IRM-RULESET-1",
    "subjectCoverage": ["FINANCE", "SUPPLY"]
  },
  "ism": {
    "classification": "U",
    "ownerProducer": "USA"
  },
  "erm": {
    "officeOfRecord": "ORG.RMO",
    "disposition": {
      "reviewIndicator": true,
      "recordControl": "RCS-2026-17"
    }
  },
  "edhBinding": {
    "identifier": "EDH-12345",
    "dataItemCreateDateTime": "2026-02-18T12:00:00Z",
    "responsibleEntity": [
      {"role": "Custodian", "country": "USA", "organization": "ORG"}
    ]
  },
  "tdfBinding": {
    "packageType": "TrustedDataObject",
    "assertion": ["irm", "ism", "erm"]
  },
  "governance": {
    "authoritativeSystem": "Enterprise Catalog",
    "lastValidatedUtc": "2026-02-18T12:05:00Z"
  }
}
```

---

## 11) Implementation Readiness Checklist

- [ ] Canonical field dictionary approved by governance/security/records stakeholders
- [ ] `MC_*` taxonomy families created
- [ ] Authoritative source integration complete for high-integrity fields
- [ ] API projection contract versioned and published
- [ ] Policy filtering validated with role/classification test matrix
- [ ] Quality dashboard operational (precision/recall/completeness)
- [ ] Incident rollback plan documented for taxonomy drift or overexposure

---

## 12) Final Recommendations

1. Adopt this v3 profile as **enterprise baseline** with staged rollout by domain.
2. Keep metacard shape stable; evolve vocabularies and rule packs under version control.
3. Treat ISM/ERM critical fields as authoritative, not purely inferred.
4. Use Netwrix as **collection/index + API serving layer**, not sole system of record for governance decisions.
5. Schedule quarterly standards/taxonomy synchronization and conformance testing.

