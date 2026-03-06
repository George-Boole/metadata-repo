# Hybrid Metacard Standard v4

## Status
- **Version:** v4
- **Type:** Enterprise baseline profile
- **Intended use:** Cross-organization metadata standard for discovery, security marking, records governance, and transport binding
- **Primary standards basis:** IRM + ISM + ERM + EDH + IC-TDF, with optional UIAS extension

---

## 1. Executive Summary

This document defines a **hybrid metacard profile** that modernizes DDMS-era “metacard” concepts using current IC/DoD-aligned specifications in this repository. It establishes:

1. A **canonical metacard model** for data discovery/cataloging (IRM).
2. A **security marking model** (ISM) embedded at resource and selected element levels.
3. A **records management model** (ERM) for retention, disposition, and hold workflows.
4. A **transport-ready envelope/binding model** (EDH + IC-TDF) for exchange and cryptographic traceability.
5. An implementation approach for **Netwrix Data Classification** using taxonomy-driven extraction and API publication.

This profile is intended to be applied across large organizations with heterogeneous repositories and mixed structured/unstructured content.

---

## 2. Normative Source Baseline

This profile is derived from schema and examples included in this repository:

- **IRM root and metacard model:** `ICResourceMetadataPackage` + `metacardInfo` in `IC-IRM.xsd`.
- **ISM security attributes:** security marking attribute model in `IC-ISM.xsd`.
- **ERM schema:** `ElectronicRecordsManagementMetadata` model in `ERM_XML.xsd`.
- **EDH schema:** `Edh`, `ExternalEdh`, `ResponsibleEntity`, and required EDH fields in `IC-EDH.xsd`.
- **IC-TDF schema:** `TrustedDataObject`, `HandlingAssertion`, `Binding`, `SignatureValue` model in `IC-TDF.xsd`.
- **Reference composition example:** combined IRM+ISM+EDH+TDF in `UnclassCloudMin.xml` and ERM+EDH+TDF in `ERM_Instance_TDF_Full.xml`.
- **UIAS optional extension:** UIAS schema for identity/authorization attribute modeling.

> DDMS 3.1 is treated as historical context only and is not used as a normative source in this profile.

---

## 3. Metacard Architecture

### 3.1 Logical Layers

The hybrid metacard is defined as five coordinated layers:

1. **Discovery Layer (IRM)**
   - Describes the data asset for search, cataloging, exchange, and stewardship.
2. **Security Layer (ISM)**
   - Provides classification/control markings to enable machine enforcement.
3. **Records Layer (ERM)**
   - Provides retention/disposition/hold metadata.
4. **Exchange Header Layer (EDH)**
   - Provides enterprise exchange header and responsible-entity context.
5. **Transport Binding Layer (IC-TDF)**
   - Provides signing/binding context for transport and integrity.

### 3.2 Physical Serialization Patterns

The profile allows two implementation patterns:

- **Pattern A – Integrated XML assertion package:**
  - IRM assertion as the core card, ISM attributes applied inline, ERM assertion adjacent, EDH and TDF wrapping for transport.
- **Pattern B – API-native JSON record + XML transport wrapper:**
  - Internal canonical JSON object for catalog/API systems; XML rendering generated when EDH/TDF exchange is required.

Both patterns SHALL use identical canonical field semantics and identifiers.

---

## 4. Canonical Field Profile

## 4.1 Required Baseline (Minimum Publishable Metacard)

A metacard is considered publishable only if all required fields below are present.

### A) IRM (Discovery Core)

| Field | Cardinality | Requirement | Notes |
|---|---:|---|---|
| `ICResourceMetadataPackage/@irm:DESVersion` | 1 | Required | IRM DES version |
| `ICResourceMetadataPackage/@irm:compliesWith` | 1 | Required | Validation/profile identifier |
| `metacardInfo` | 1 | Required | Metadata-about-metadata category |
| `metacardInfo/identifier` | 1..n | Required | At least one identifier for the card |
| `metacardInfo/dates` | 1 | Required | Card lifecycle date metadata |
| `identifier` | 1..n | Required | At least one identifier for described asset |
| `title` | 1..n | Required | Human-readable title |
| `subjectCoverage` | 1..n | Required | At least one categorization scope |

### B) ISM (Security Minimum)

| Field | Cardinality | Requirement | Notes |
|---|---:|---|---|
| `ism:classification` | 1 | Required | Core classification level |
| `ism:ownerProducer` | 1..n | Required | Ownership/producer authority |
| `ism:compliesWith` | 1..n | Required | E.g., enterprise policy regime(s) |
| `ism:createDate` | 1 | Required | Security metadata creation date |
| `ism:resourceElement` | 1 | Required | Resource-level marking indicator |

### C) ERM (Records Minimum)

| Field | Cardinality | Requirement | Notes |
|---|---:|---|---|
| `ElectronicRecordsManagementMetadata` | 1 | Required | ERM container |
| `OfficeOfRecord` | 1 | Required | Owning office for records authority |
| `Disposition` | 1 | Required | Disposition context |
| `Disposition/ReviewIndicator` | 1 | Required | Mandatory review flag in schema |

### D) EDH (Exchange Header Minimum)

| Field | Cardinality | Requirement | Notes |
|---|---:|---|---|
| `icid:Identifier` | 1 | Required | Exchange-level item identifier |
| `DataItemCreateDateTime` | 1 | Required | Item creation timestamp |
| `ResponsibleEntity` | 1..2 | Required | Must include Custodian role |
| `arh:Security` or `arh:ExternalSecurity` | 1 | Required | Security block for header |

### E) IC-TDF (Binding Minimum for Transport)

| Field | Cardinality | Requirement | Notes |
|---|---:|---|---|
| `TrustedDataObject/@tdf:version` | 1 | Required | TDF version |
| `HandlingAssertion` | 1..n | Required | At least one scope assertion |
| `HandlingStatement` | 1..n | Required | Contains EDH/ExternalEdh |
| `Binding/Signer` | 1 | Required for signed transport | Subject/issuer strongly recommended |
| `Binding/SignatureValue/@signatureAlgorithm` | 1 | Required | Controlled value |
| `Binding/SignatureValue/@normalizationMethod` | 1 | Required | URI-form normalization method |

---

## 4.2 Recommended Extended Fields

These fields increase operational quality and governance fidelity.

### IRM Extended
- `description`
- `language`
- `format/mimeType`, `format/extent`, `format/medium`
- `creator`, `publisher`, `pointOfContact`
- `rights`
- `relatedResource`
- `temporalCoverage`, `geospatialCoverage`, `virtualCoverage`

### ISM Extended
- CUI set: `cuiBasic`, `cuiSpecified`, `cuiControlledBy`, `cuiControlledByOffice`, `cuiPOC`
- Dissemination set: `disseminationControls`, `releasableTo`, `displayOnlyTo`
- Compartment/set controls: `SCIcontrols`, `SARIdentifier`, `nonUSControls`, `FGIsourceOpen`, `FGIsourceProtected`

### ERM Extended
- `FoiaOpsIndicator`
- `RecordDesignationDate`
- `VitalRecordsIndicator`
- Disposition dates: `DateApplied`, `DateEligible`, `DateLimit`
- `RecordControl`
- Hold structure (`Hold/Authorizer`, `Hold/Identifier`, `Hold/Type`, etc.)

### EDH Extended
- `AuthorizationReference`
- Originator + Custodian dual `ResponsibleEntity`
- `DataSet` metadata when assets belong to a known dataset/product

### TDF Extended
- `BoundValueList` and explicit `BoundValue` hashing references
- `ReferenceValuePayload/@tdf:uri` for externally located payloads
- Binding coverage policy for multi-assertion packages

---

## 5. Canonical JSON Interchange Object (API-Oriented)

Use this structure as the enterprise-neutral API shape; XML representations are generated from this model when needed.

```json
{
  "profile": {
    "name": "hybrid-metacard-standard",
    "version": "4.0"
  },
  "identity": {
    "metacard_id": "urn:example:metacard:...",
    "asset_id": "guide://..."
  },
  "irm": {
    "desVersion": "202111",
    "compliesWith": ["ORG_BASELINE"],
    "metacardInfo": {
      "identifier": [{"qualifier": "IC-ID", "value": "guide://..."}],
      "dates": {"created": "2026-01-15T00:00:00Z"},
      "publisher": [{"organization": {"name": "Enterprise Data Office"}}]
    },
    "resource": {
      "identifier": [{"qualifier": "IC-ID", "value": "guide://..."}],
      "title": ["Asset title"],
      "subjectCoverage": {"keyword": ["finance", "ops"]}
    }
  },
  "ism": {
    "classification": "U",
    "ownerProducer": ["USA"],
    "compliesWith": ["USGov", "USIC"],
    "createDate": "2026-01-15",
    "resourceElement": true
  },
  "erm": {
    "officeOfRecord": {"country": "USA", "organization": "NGA"},
    "disposition": {
      "reviewIndicator": true,
      "recordControl": "RCS-1234"
    }
  },
  "edh": {
    "identifier": "guide://...",
    "dataItemCreateDateTime": "2026-01-15T00:00:00Z",
    "responsibleEntity": [
      {"role": "Custodian", "country": "USA", "organization": "NGA"}
    ]
  },
  "tdf": {
    "version": "202111-IC-TDF.202111",
    "binding": {
      "signer": {"subject": "CN=...", "issuer": "C=US, O=..."},
      "signature": {
        "signatureAlgorithm": "SHA256withECDSA",
        "normalizationMethod": "http://www.w3.org/2008/xmlsec/c14n2"
      }
    }
  }
}
```

---

## 6. Netwrix Implementation Profile

> Note: this section is an implementation profile template designed for Netwrix Data Classification deployments that use taxonomy/pattern-based extraction and API serving.

## 6.1 Taxonomy Set Design

Implement five coordinated taxonomy families:

1. `mc_irm_discovery`
   - Title, description, identifiers, dates, format, subject keywords, creator/publisher/POC.
2. `mc_ism_marking`
   - Classification, ownerProducer, dissemination controls, releasability/CUI controls.
3. `mc_erm_records`
   - Office of record, record control, disposition status/dates, hold metadata.
4. `mc_edh_header`
   - EDH identifier, create datetime, responsible entity role/country/org, authorization reference.
5. `mc_tdf_binding`
   - TDF version, binding signer fields, signature algorithm, normalization method, payload URI.

## 6.2 Rule Authoring Strategy

Use blended extraction logic per taxonomy:

- **Pattern/regex rules:** identifiers, timestamps, policy IDs, record control numbers.
- **Dictionary/enumeration rules:** controlled lists for ISM/ERM categories.
- **Contextual proximity rules:** co-occurrence constraints (e.g., classification near ownerProducer).
- **Source precedence:** prefer embedded metadata/properties over raw body text hits.
- **Confidence thresholds:** high-impact security/records fields require stricter confidence gates.

## 6.3 Stewardship and Attestation

Define field criticality tiers:

- **Tier 1 (human attestation required):** classification, ownerProducer, legal hold indicators.
- **Tier 2 (review queue):** dissemination controls, officeOfRecord, recordControl.
- **Tier 3 (auto-publish):** title, format, keyword, language, basic dates.

## 6.4 API Serving Model

Recommended serving pipeline:

1. Netwrix scans/indexes assets and applies taxonomy tags.
2. API integration extracts taxonomy outcomes + confidence + source evidence.
3. Metacard assembler maps tags into canonical hybrid metacard object (Section 5).
4. Optional serializer emits IRM/EDH/TDF XML package for transport workflows.
5. Publish to catalog/search and downstream policy enforcement systems.

## 6.5 API Output Requirements

Each served metacard SHOULD include:

- `profile.name`, `profile.version`
- `source_system`, `scan_timestamp`, `extractor_version`
- `field_confidence` per field
- `evidence` pointer (where safe)
- `validation_status` and `validation_errors`
- `vocabulary_version` references used at extraction time

---

## 7. Validation and Compliance Rules

## 7.1 Completeness Gates

A record SHALL be rejected from production metacard publication if:

- Any required baseline field in Section 4.1 is missing.
- ISM minimum security set is incomplete.
- ERM required elements are incomplete for records-managed content.
- EDH/TDF required fields are missing for transport-bound assets.

## 7.2 Consistency Rules

- `identity.asset_id` SHOULD match canonical IRM/EDH identifiers.
- `ism.createDate` SHALL NOT be later than metacard publication timestamp.
- If legal hold is active, ERM disposition terminal actions SHALL be blocked.
- If `releasableTo` exists, `classification/ownerProducer` SHALL be present.

## 7.3 Versioning Rules

- Profile version and source DES/CES versions MUST be captured as metadata.
- Vocabulary updates MUST be backward-compatible or accompanied by mapping migrations.

---

## 8. Key Risks, Gaps, and Edge Cases

1. **Inference limits for policy semantics**
   - Classification, ownerProducer, and legal hold are often policy declarations, not inferable text.
2. **False positives in unstructured scans**
   - Raw regex hits can over-tag unless constrained by context and confidence gates.
3. **Vocabulary drift over time**
   - Controlled value enumerations evolve; taxonomies can become stale without synchronization.
4. **Transport metadata availability**
   - EDH/TDF binding metadata may only exist at packaging time, not in at-rest scans.
5. **Cross-domain harmonization**
   - Multi-agency and coalition environments require explicit profile overlays for jurisdictional differences.

---

## 9. Implementation Checklist

- [ ] Approve required baseline fields (Section 4.1).
- [ ] Approve extended field list (Section 4.2).
- [ ] Define enterprise controlled value sources and update cadence.
- [ ] Build Netwrix taxonomy families and confidence thresholds.
- [ ] Implement metacard assembler mapping from taxonomy outputs.
- [ ] Add completeness + consistency validators before API publication.
- [ ] Pilot on representative repositories (structured + unstructured).
- [ ] Measure precision/recall and adjust rule packs.
- [ ] Promote to production with versioned governance.

---

## 10. Companion Artifacts

This v4 document is accompanied by:

- `docs/hybrid-metacard-standard-v4-field-mapping.csv`
  - Field-level implementation mapping (canonical path, taxonomy family, extraction strategy, confidence tier, required/optional)

