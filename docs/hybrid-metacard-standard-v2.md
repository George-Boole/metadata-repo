# Hybrid Metacard Standard v2.0

## Status and Purpose

**Status:** Draft baseline for enterprise implementation.  
**Intent:** Define a single, organization-wide metacard profile that unifies:
- **IRM** for discovery/catalog metadata,
- **ISM** for security marking,
- **ERM** for records lifecycle metadata,
- **EDH** and **TDF** for transport/exchange binding,
- **UAIS** for identity-context extension.

This profile is designed to be implementable in repository/catalog tooling and operationalized in enterprise data scanning/classification systems such as Netwrix Data Classification.

---

## 1. Normative Baseline and Version Posture

### 1.1 Legacy/Current Posture
- **DDMS 3.1** is treated as **obsolete/deprecated legacy input**. It may inform migration mapping only.
- **Current profile baseline** uses the available IC XML DES package families represented in this repository.

### 1.2 Baseline Package Lineage (from repository package metadata)
- **IRM** package version: `2021-NOV`
- **ISM** package version: `2021-NOVr2022-NOV`
- **IC-EDH** package version: `2019-MAR`
- **IC-TDF** package version: `2021-NOV`
- **UIAS** package version: `2021-NOV`
- **ERM** package version: `2016-JUL`

> Note: ERM version skew relative to newer IRM/ISM/EDH/TDF/UIAS is expected and handled by profile normalization rules defined in this standard.

### 1.3 Profile Identifier
- **Profile ID:** `ORG-HYBRID-METACARD-2.0`
- **Conformance levels:**
  - **L1 Minimum:** required enterprise-interoperable subset.
  - **L2 Standard:** recommended operational baseline.
  - **L3 Extended:** domain-specific extensions and transport-level assertions.

---

## 2. Architecture of the Hybrid Metacard

The metacard has six primary blocks:

1. **Envelope** (profile metadata, provenance anchors)
2. **IRM block** (discovery and catalog metadata)
3. **ISM block** (security markings)
4. **ERM block** (records/disposition controls)
5. **EDH binding block** (handling metadata for exchange)
6. **TDF binding block** (portable trusted object/collection context)

Optional:
7. **UAIS context block** (identity and attribute assertions used by access systems)

### 2.1 Canonical Serialization
- Canonical representation: **JSON** for enterprise API interoperability.
- Normative mapping targets:
  - IRM XML (`urn:us:gov:ic:irm`)
  - ISM XML (`urn:us:gov:ic:ism`)
  - ERM XML (`urn:us:gov:ic:erm`)
  - EDH XML (`urn:us:gov:ic:edh`)
  - TDF XML (`urn:us:gov:ic:tdf`)
  - UIAS XML (`urn:us:gov:ic:uias`)

---

## 3. Data Model (Normative)

## 3.1 Envelope Block

| Field | Type | Req | Description |
|---|---|---:|---|
| `profile_id` | string | Y | Must equal `ORG-HYBRID-METACARD-2.0` |
| `metacard_id` | string(UUID) | Y | Stable enterprise metacard identifier |
| `metacard_version` | string | Y | Semantic version of card instance |
| `created_at` | datetime | Y | Card creation timestamp |
| `updated_at` | datetime | Y | Last update timestamp |
| `source_system` | string | Y | System producing current card state |
| `asset_locator` | string(URI/path) | Y | Locator to indexed asset |
| `asset_fingerprint.hash` | string | Y | Content hash |
| `asset_fingerprint.size_bytes` | integer | Y | Asset size |
| `asset_fingerprint.mime_type` | string | Y | MIME type |
| `asset_fingerprint.extension` | string | N | File extension |
| `provenance` | object[] | Y | Per-ingest provenance records |

## 3.2 IRM Discovery Block

### L1 Required
- `irm.metacard_info.identifier[]`
- `irm.metacard_info.dates`
- `irm.identifier[]`
- `irm.title[]`
- `irm.creator[]`
- `irm.publisher[]`
- `irm.contributor[]`
- `irm.point_of_contact[]`
- `irm.subject_coverage[]`

### L2 Recommended
- `irm.description`
- `irm.language[]`
- `irm.dates`
- `irm.rights`
- `irm.source[]`
- `irm.type[]`
- `irm.format`
- `irm.temporal_coverage[]`
- `irm.geospatial_coverage[]`
- `irm.virtual_coverage[]`
- `irm.related_resource[]`
- `irm.resource_management`

## 3.3 ISM Security Block

### L1 Required
- `ism.classification`
- `ism.owner_producer[]`

### L2 Recommended
- `ism.dissemination_controls[]`
- `ism.releasable_to[]`
- `ism.display_only_to[]`
- `ism.non_us_controls[]`
- `ism.derived_from`
- `ism.classified_by`
- `ism.classification_reason`
- `ism.declass_date` / `ism.declass_event` / `ism.declass_exception`

### L3 Extended (CUI/Specialized)
- `ism.cui_basic[]`
- `ism.cui_specified[]`
- `ism.cui_controlled_by`
- `ism.cui_controlled_by_office`
- `ism.cui_poc`
- `ism.second_banner_line`
- `ism.handle_via_channels[]`
- `ism.sci_controls[]`
- `ism.sar_identifier[]`

## 3.4 ERM Records Block

### L1 Required
- `erm.office_of_record`
- `erm.disposition.review_indicator`

### L2 Recommended
- `erm.record_designation_date`
- `erm.foia_ops_indicator`
- `erm.vital_records_indicator`
- `erm.disposition.record_control`
- `erm.disposition.date_applied`
- `erm.disposition.date_eligible`
- `erm.disposition.date_limit`

### L3 Extended
- `erm.disposition.hold[]`
  - `authorizer`
  - `date_applied`
  - `effective_date`
  - `identifier`
  - `justification`
  - `released_date`
  - `type`

## 3.5 EDH Binding Block

### L2 Recommended
- `edh.identifier`
- `edh.data_item_create_datetime`
- `edh.responsible_entity[]`
  - `country`
  - `organization`
  - `suborganization`

### L3 Extended
- `edh.authorization_reference`
- `edh.dataset`

## 3.6 TDF Binding Block

### L2 Recommended
- `tdf.object_id`
- `tdf.version`
- `tdf.payload.is_encrypted`
- `tdf.payload.media_type`
- `tdf.payload.uri`

### L3 Extended
- `tdf.assertions[]`
  - `scope`
  - `type`
  - `id`
  - `statement_metadata[]` (`applies_to_state`, embedded `edh`/`external_edh`/`arh`)
- `tdf.payload.filename`
- `tdf.payload.hash_verification`

## 3.7 UAIS Context Block (Optional Extension)

Use for identity-context interoperability where required by mission architecture.

Recommended optional fields:
- `uais.entity_type`
- `uais.digital_identifier[]`
- `uais.clearance`
- `uais.handling_controls[]`
- `uais.group[]`
- `uais.admin_organization`
- `uais.duty_organization`
- `uais.lifecycle_status`

---

## 4. Conformance and Validation Rules

## 4.1 Cross-Block Consistency

1. If `ism.classification` is populated, at least one of `edh` or `tdf.assertions.statement_metadata` SHALL carry equivalent handling semantics for exchange scenarios.
2. If `erm.disposition.hold[]` exists with an active hold, downstream transport SHOULD include handling assertions indicating restricted disposition actions.
3. `asset_fingerprint.hash` SHALL be immutable for a given `metacard_version`.

## 4.2 Provenance Rules

Each populated field SHALL be traceable to source type:
- `authoritative_embedded` (metadata in source asset)
- `authoritative_external` (records/security authoritative system)
- `scanner_extracted` (deterministic parser/file system metadata)
- `taxonomy_inferred` (pattern/NLP/rule inference)

High-impact fields (`ism.classification`, `ism.owner_producer`, `erm.office_of_record`, `erm.disposition.review_indicator`) SHOULD NOT be finalized solely from `taxonomy_inferred` without approval workflow.

## 4.3 Version Matrix Rules

Supported baseline combo for v2.0:
- IRM `2021-NOV`
- ISM `2021-NOVr2022-NOV`
- ERM `2016-JUL`
- IC-EDH `2019-MAR`
- IC-TDF `2021-NOV`
- UIAS `2021-NOV` (optional)

Any alternate combination requires profile extension registration.

---

## 5. Netwrix Data Classification Implementation Blueprint

> This section is implementation guidance to operationalize the profile in a scanner/indexer platform that uses taxonomies and API retrieval.

## 5.1 Taxonomy Design Pattern

Create modular taxonomies aligned to metacard blocks:

1. **`TX-IRM-DISCOVERY`**
   - Purpose: identify IRM discovery/catalog metadata.
   - Inputs: file metadata, path structures, textual labels (`title`, `project`, `document type`, dates, language hints).

2. **`TX-ISM-MARKINGS`**
   - Purpose: capture ISM-equivalent security cues.
   - Inputs: banner/portion marks, dissemination caveats, CUI labels, owner/producer tokens, release controls.

3. **`TX-ERM-RECORDS`**
   - Purpose: identify records lifecycle cues.
   - Inputs: schedule codes, hold phrases, office-of-record patterns, disposition dates/keywords.

4. **`TX-EDH-TDF-TRANSPORT`**
   - Purpose: detect EDH/TDF-relevant handling and transport context.
   - Inputs: EDH identifiers, responsible-entity text, assertion/binding clues, encryption indicators.

5. **`TX-UAIS-CONTEXT`** (optional)
   - Purpose: enrich identity-context attributes.
   - Inputs: affiliation/org/unit/group labels, identity attributes.

## 5.2 Field Mapping and Confidence Model

For each mapped metacard field, capture:
- `taxonomy_id`
- `rule_id`
- `match_context_hash`
- `confidence` (0–1)
- `decision_state` (`proposed`, `approved`, `rejected`)

Suggested thresholds:
- `<0.70`: keep as `proposed`
- `0.70–0.89`: queue policy review for high-impact fields
- `>=0.90`: auto-approve only for low-risk descriptive IRM fields

## 5.3 API Serving Pattern

Recommended architecture:
1. Query scanner API for indexed asset metadata + taxonomy hits.
2. Transform response into canonical `ORG-HYBRID-METACARD-2.0` JSON.
3. Serve via enterprise metacard API.

Suggested endpoints:
- `GET /metacards/{asset_id}`
- `GET /metacards?classification=...&ownerProducer=...`
- `GET /metacards/{id}/bindings/edh`
- `GET /metacards/{id}/bindings/tdf`
- `GET /metacards/{id}/provenance`

## 5.4 Operational Controls

- Implement immutable audit log for field-level changes.
- Enforce policy that authoritative external systems can override inferred ERM/ISM values.
- Re-scan cadence SHOULD trigger metacard delta generation, not full replacement.
- Preserve prior `metacard_version` records for legal/audit traceability.

---

## 6. Edge Cases and Gap Handling

1. **Version skew:** ERM lineage lag requires strict normalization table and schema-level compatibility checks.
2. **Inference ambiguity:** Distinguish inferred vs authoritative values at field granularity.
3. **Transport mismatch:** ISM in catalog vs EDH/TDF in transport can drift; enforce sync validator.
4. **Partial metadata assets:** binary/object-store assets may lack embedded metadata; use staged enrichment.
5. **Multi-jurisdiction content:** mixed releasability/non-US controls may require cardinality and precedence rules.

---

## 7. Example Canonical JSON Skeleton

```json
{
  "profile_id": "ORG-HYBRID-METACARD-2.0",
  "metacard_id": "9f52f9db-5413-4b33-90bd-8f24d18d3f1d",
  "metacard_version": "2.0.0",
  "created_at": "2026-02-18T00:00:00Z",
  "updated_at": "2026-02-18T00:00:00Z",
  "source_system": "netwrix-dc",
  "asset_locator": "s3://example-bucket/path/file.pdf",
  "asset_fingerprint": {
    "hash": "sha256:...",
    "size_bytes": 123456,
    "mime_type": "application/pdf",
    "extension": "pdf"
  },
  "irm": {
    "identifier": ["urn:asset:123"],
    "title": ["Example Record"],
    "creator": [{"name": "Program Office"}],
    "publisher": [{"name": "Enterprise Publisher"}],
    "contributor": [{"name": "Data Steward"}],
    "point_of_contact": [{"name": "Metadata Team"}],
    "subject_coverage": ["logistics"],
    "metacard_info": {
      "identifier": ["urn:metacard:123"],
      "dates": {"created": "2026-02-18"}
    }
  },
  "ism": {
    "classification": "U",
    "owner_producer": ["USA"],
    "dissemination_controls": ["FEDCON"]
  },
  "erm": {
    "office_of_record": {"organization": "RecordsOffice"},
    "disposition": {
      "review_indicator": true,
      "record_control": "RC-001"
    }
  },
  "edh": {
    "identifier": "edh-id-001",
    "data_item_create_datetime": "2026-02-18T00:00:00Z",
    "responsible_entity": [
      {"country": "USA", "organization": "ODNI", "suborganization": "Example"}
    ]
  },
  "tdf": {
    "object_id": "tdo-001",
    "version": "202111",
    "payload": {
      "uri": "s3://example-bucket/path/file.pdf",
      "media_type": "application/pdf",
      "is_encrypted": false
    }
  },
  "provenance": [
    {
      "field": "ism.classification",
      "source_type": "authoritative_embedded",
      "source_system": "netwrix-dc",
      "rule_id": "TX-ISM-MARKINGS:R-001",
      "confidence": 0.99,
      "timestamp": "2026-02-18T00:00:00Z"
    }
  ]
}
```

---

## 8. Companion Artifacts Included with this Standard

- `docs/hybrid-metacard-standard-v2.mapping.csv` — field-level profile-to-standard mapping.
- `docs/hybrid-metacard-standard-v2.schema.json` — baseline JSON Schema for API validation.

