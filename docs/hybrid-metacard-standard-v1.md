# Hybrid Metacard Standard v1.0

**Status:** Draft Baseline (Organization-Wide)  
**Intent:** Replace legacy DDMS 3.1 metacard usage with a current, interoperable profile based on IRM, ISM, ERM, EDH, TDF, and optional UIAS bindings.  
**Primary Use Cases:** Enterprise discovery/cataloging, security marking automation, records lifecycle management, and transport/security binding for exchange.

---

## 1. Executive Summary

This document defines a **hybrid metacard profile** that can be applied across a large organization as a common metadata contract for data assets. The profile:

- Uses **IRM** for discovery and cataloging metadata.
- Uses **ISM** for classification and handling markings.
- Uses **ERM** for records management metadata.
- Supports **EDH** and **TDF** as transport/exchange bindings.
- Supports optional **UIAS** attributes for identity/access context.

DDMS 3.1 concepts are preserved functionally (single metadata card describing a resource), but implementation is modernized through current IC-era schemas and controlled vocabularies.

---

## 2. Normative Design Principles

1. **Single canonical metacard per data asset version.**
2. **Separation of concerns:**
   - Asset metadata (IRM/ISM/ERM) is persistent.
   - Exchange metadata (EDH/TDF) is event- or distribution-instance specific.
3. **Controlled vocabulary enforcement** for security and records-critical fields.
4. **Machine-first structure** with explicit required fields and validation rules.
5. **Traceability** via immutable identifiers, provenance, and lifecycle timestamps.
6. **API portability** so downstream systems can ingest/emit the same metacard shape.

---

## 3. Source Standards Baseline (Current-State)

- **IRM v2021-NOV** (package metadata indicates current public release track).
- **ISM v2021-NOVr2022-NOV**.
- **ERM v2016-JUL** (still referenced for records metadata model).
- **IC-EDH v2019-MAR**.
- **IC-TDF v2021-NOV**.
- **UIAS v2021-NOV** (optional identity/access assertions).
- **DDMS 3.1** treated as **legacy/obsolete reference only**.

---

## 4. Metacard Logical Model

### 4.1 Top-Level Sections

Each metacard SHALL contain the following top-level sections:

1. `core`
2. `discovery` (IRM)
3. `security` (ISM)
4. `records` (ERM)
5. `bindings`
   - `edh`
   - `tdf`
6. `identity` (optional UIAS)
7. `quality`

### 4.2 Canonical JSON Shape (Normative)

```json
{
  "core": {
    "metacardId": "uuid",
    "resourceId": "string",
    "resourceVersion": "string",
    "schemaVersion": "HMS-1.0",
    "profileVersion": "ORG-HMS-1.0",
    "createdDateTime": "2026-02-18T00:00:00Z",
    "lastUpdatedDateTime": "2026-02-18T00:00:00Z",
    "originSystem": "string",
    "custodianOrg": "string"
  },
  "discovery": {
    "identifier": [{"qualifier": "string", "value": "string"}],
    "title": [{"value": "string", "lang": "eng"}],
    "description": {"value": "string", "lang": "eng"},
    "language": ["eng"],
    "creator": [{"name": ["string"], "email": ["string"], "phone": ["string"]}],
    "publisher": [{"name": ["string"]}],
    "contributor": [{"name": ["string"]}],
    "pointOfContact": [{"name": ["string"], "email": ["string"]}],
    "format": {"mimeType": "application/pdf", "extent": "12345", "medium": "digital"},
    "subjectCoverage": [],
    "temporalCoverage": [],
    "geospatialCoverage": [],
    "rights": {"value": "string"},
    "type": [{"qualifier": "string", "value": "string"}],
    "source": [{"qualifier": "string", "value": "string"}],
    "resourceManagement": {},
    "metacardInfo": {
      "identifier": [{"qualifier": "string", "value": "string"}],
      "dates": {},
      "description": {"value": "string"}
    }
  },
  "security": {
    "classification": "U",
    "ownerProducer": ["USA"],
    "SCIcontrols": [],
    "SARIdentifier": [],
    "disseminationControls": [],
    "releasableTo": [],
    "FGIsourceOpen": [],
    "FGIsourceProtected": [],
    "nonUSControls": [],
    "atomicEnergyMarkings": [],
    "displayOnlyTo": [],
    "declassDate": null,
    "classifiedBy": null,
    "derivedFrom": null,
    "notice": []
  },
  "records": {
    "FoiaOpsIndicator": null,
    "OfficeOfRecord": {
      "country": "USA",
      "organization": "string",
      "subOrganization": "string"
    },
    "RecordDesignationDate": null,
    "VitalRecordsIndicator": null,
    "Disposition": {
      "AppliedBy": null,
      "DateApplied": null,
      "DateEligible": null,
      "DateLimit": null,
      "RecordControl": null,
      "ReviewIndicator": true,
      "Hold": []
    }
  },
  "bindings": {
    "edh": {
      "Identifier": "string",
      "DataItemCreateDateTime": "2026-02-18T00:00:00Z",
      "AuthorizationReference": null,
      "ResponsibleEntity": [
        {
          "role": "Custodian",
          "country": "USA",
          "organization": "string",
          "subOrganization": null
        }
      ],
      "DataSet": null,
      "DESVersion": null
    },
    "tdf": {
      "tdfObjectType": "TrustedDataObject",
      "id": "string",
      "mediaType": "application/octet-stream",
      "scope": "PAYLOAD",
      "isEncrypted": true,
      "uri": null,
      "HandlingAssertion": [],
      "HandlingStatement": [],
      "StatementMetadata": [],
      "ReferenceList": [],
      "Signer": null,
      "EncryptedPolicyObject": null,
      "appliesToState": null
    }
  },
  "identity": {
    "enabled": false,
    "DigitalIdentifier": null,
    "EntityType": null,
    "AuthorityCategory": [],
    "Role": [],
    "Group": [],
    "FineAccessControls": [],
    "HandlingControls": [],
    "LifecycleStatus": null,
    "IcNetworks": [],
    "OriginatingNetwork": null
  },
  "quality": {
    "completenessScore": 0,
    "securityConfidence": 0,
    "recordsConfidence": 0,
    "validationState": "PENDING",
    "validationErrors": []
  }
}
```

---

## 5. Required vs Optional Fields

### 5.1 Mandatory at Ingest (Minimum Publishable)

- `core.metacardId`
- `core.resourceId`
- `core.schemaVersion`
- `core.createdDateTime`
- `discovery.identifier[]` (at least 1)
- `discovery.title[]` (at least 1)
- `security.classification`
- `security.ownerProducer[]` (at least 1)
- `records.OfficeOfRecord`
- `records.Disposition.ReviewIndicator`

### 5.2 Mandatory for Cross-Domain Exchange

- `bindings.edh.Identifier`
- `bindings.edh.DataItemCreateDateTime`
- `bindings.edh.ResponsibleEntity[]` (must include one `Custodian`)
- `bindings.tdf.id` (if transported as TDF)
- `bindings.tdf.isEncrypted` (if transported as TDF)

---

## 6. Validation Rules (Normative)

1. **Classification-owner consistency:** `security.classification` SHALL NOT be null when `ownerProducer` exists.
2. **EDH role cardinality:** `ResponsibleEntity` SHALL contain exactly one `Custodian`; MAY contain one `Originator`.
3. **ERM review requirement:** `records.Disposition.ReviewIndicator` SHALL exist for all records.
4. **Hold structure integrity:** every `Hold` SHALL include `Type`, `Authorizer`, `DateApplied`, `EffectiveDate`.
5. **Controlled vocab only:** ISM/ERM enumerated fields SHALL use approved vocabulary values.
6. **No silent inference:** inferred security/records fields SHALL include confidence and source in `quality` or companion provenance.
7. **Immutable card ID:** `core.metacardId` SHALL NOT change across updates to the same logical metacard.

---

## 7. DDMS 3.1 to Hybrid Mapping (Legacy Transition)

| DDMS 3.1 Concept | Hybrid v1 Destination |
|---|---|
| `ddms:Resource` root | `core + discovery + security + records + bindings` |
| Discovery fields (`Title`, `Description`, `Identifier`) | `discovery.title`, `discovery.description`, `discovery.identifier` |
| Security in DDMS/ICISM linkage | `security` (explicit ISM attributes) |
| Temporal/geospatial coverage | `discovery.temporalCoverage`, `discovery.geospatialCoverage` |
| Related resources | `discovery.resourceManagement` and/or explicit relationship extensions |

---

## 8. Netwrix Data Classification Implementation Profile

> This section defines the implementation profile to make Netwrix a metacard producer. Site-specific control names in your deployment may vary.

### 8.1 Taxonomy Set Required

Deploy **five taxonomy families**:

1. **IRM-Discovery Taxonomy**
   - Extract title, identifiers, language, dates, subject terms, geospatial hints, MIME, format.
2. **ISM-Marking Taxonomy**
   - Detect classification banners, dissemination controls, releasability strings, declass lines, authority markings.
3. **ERM-Records Taxonomy**
   - Detect office-of-record cues, disposition/retention phrases, hold notices, FOIA indicators.
4. **EDH-TDF Readiness Taxonomy**
   - Detect EDH fragments, transport policy references, encryption/signature indicators.
5. **UIAS Context Taxonomy (optional)**
   - Detect role/group/network/entity attributes for fine-grained access context.

### 8.2 Normalization Pipeline

Netwrix extraction output SHALL be normalized into canonical HMS v1 fields:

1. **Raw Extraction** (regex, dictionary, pattern, metadata scanner)
2. **Normalization** (synonym collapse, controlled vocab mapping)
3. **Conflict Resolution** (precedence: explicit labels > trusted source metadata > inferred content)
4. **Confidence Assignment** (0–100)
5. **Validation** against HMS v1 rules
6. **API Publication** as canonical metacard JSON

### 8.3 Recommended API Contract (Metacard Serving)

Implement (native or adapter) endpoints:

- `GET /metacards/{metacardId}`
- `GET /metacards?resourceId={id}`
- `GET /metacards/search?classification=...&ownerProducer=...&officeOfRecord=...`
- `GET /metacards/{metacardId}/bindings`
- `GET /metacards/{metacardId}/quality`

### 8.4 Adapter Requirement

If Netwrix built-in API does not return the exact HMS v1 shape, deploy a thin **Metacard Adapter Service** that:

- Reads Netwrix API data.
- Applies taxonomy-to-field mapping table.
- Emits canonical HMS v1 JSON.
- Enforces validation and redaction policy.

---

## 9. Enterprise Governance Model

1. **Metadata Authority Board:** owns schema/profile versions.
2. **Security Marking Authority:** owns ISM vocab and adjudication policy.
3. **Records Authority:** owns ERM schedule/hold mappings.
4. **Integration Authority:** owns API contract and compatibility tests.

### 9.1 Change Control

- Version profile as `ORG-HMS-MAJOR.MINOR`.
- Minor version for additive fields; major for breaking changes.
- Publish compatibility matrix for consuming systems.

---

## 10. Known Gaps and Mitigations

### Gap A: Security inference uncertainty
- **Risk:** false positive/negative classification extraction.
- **Mitigation:** confidence scoring + mandatory review threshold for low-confidence ISM fields.

### Gap B: Records fields may be unavailable from content scans
- **Risk:** missing legally required lifecycle metadata.
- **Mitigation:** connect authoritative records systems and treat taxonomy as supplemental.

### Gap C: EDH/TDF are exchange-context dependent
- **Risk:** stale bindings if stored as static fields.
- **Mitigation:** store binding snapshots per exchange event, not overwrite in place.

### Gap D: Vocabulary drift across business units
- **Risk:** inconsistent tags and policy failure.
- **Mitigation:** central controlled vocabulary registry + linting of new taxonomy rules.

---

## 11. Conformance Levels

### Level 1: Catalog Conformance
- Core + Discovery + minimal Security (`classification`, `ownerProducer`).

### Level 2: Security Conformance
- Full ISM section with controlled vocab and validation pass.

### Level 3: Records Conformance
- Full ERM section with authoritative `OfficeOfRecord` and `Disposition`.

### Level 4: Exchange Conformance
- EDH-complete and, where used, TDF binding-complete.

---

## 12. Implementation Checklist

- [ ] Create canonical HMS v1 JSON schema in metadata platform.
- [ ] Stand up taxonomy families (IRM, ISM, ERM, EDH/TDF, optional UIAS).
- [ ] Build normalization and conflict-resolution rules.
- [ ] Configure confidence scoring and adjudication workflow.
- [ ] Implement API output (native or adapter) using HMS v1 contract.
- [ ] Add validation gates in data publication workflows.
- [ ] Define governance ownership and release management.

---

## 13. Companion Artifacts

This document is accompanied by:

1. `docs/hybrid-metacard-standard-v1.schema.json` (canonical JSON Schema)
2. `docs/hybrid-metacard-netwrix-taxonomy-mapping.csv` (taxonomy-to-field mapping baseline)

