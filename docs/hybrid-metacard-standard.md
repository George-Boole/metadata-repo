# Hybrid Metacard Standard Profile (DoD/IC Baseline)

## 1) Purpose and scope

This profile defines a **DoD/IC-wide hybrid metacard** to replace DDMS-era metacard concepts with current standards. It is designed for enterprise use where metadata is generated at scale by automated classification systems and then exported to one or more downstream catalogs.

The profile combines:

- **IRM** for data discovery/catalog metadata (`ICResourceMetadataPackage` and `metacardInfo` semantics).
- **ISM** for security marking at resource and element level.
- **ERM** for records lifecycle/disposition metadata.
- **EDH + TDF-ready binding fields** so records can be wrapped for transport/signature with minimal post-processing.

Per request, this profile emphasizes **access and handling metadata for data assets**, not identity assertion content (UIAS is treated as out of scope for the baseline implementation).

---

## 2) Design principles

1. **Single canonical metacard contract**: one profile, two tiers (minimum + extended).
2. **Separation of concerns**:
   - At-rest discovery/governance metadata (IRM + ISM + ERM)
   - Transport-envelope metadata (EDH + TDF binding)
3. **Machine and human readability**: profile is delivered as narrative guidance, JSON schema, and XML template.
4. **Tool-neutral semantics**: Netwrix can produce the fields, but the contract remains independent of any specific product.
5. **Enumerated-value discipline**: ISM/ISMCAT/ERM coded values must come from controlled vocabularies in your approved baseline release.

---

## 3) Metacard profile structure

Top-level object sections:

- `profile`: profile metadata/versioning
- `asset`: discovery/catalog metadata (IRM-aligned)
- `security`: ISM-aligned security markings
- `records`: ERM-aligned records metadata
- `transport`: EDH and TDF binding preparation fields
- `quality`: validation/completeness and operational metadata

---

## 4) Minimum publishable metacard (required)

A metacard is considered **minimum publishable** only when all required fields below are present and valid.

### 4.1 Asset / IRM minimum

- `asset.metacard.identifiers[0].value`
- `asset.metacard.dates.created`
- `asset.resource.identifiers[0].value`
- `asset.resource.title`
- `asset.resource.subjectKeywords[0]`

### 4.2 Security / ISM minimum

- `security.classification`
- `security.ownerProducer[0]`
- `security.compliesWith[0]`
- `security.createDate`
- `security.resourceElement`

### 4.3 Records / ERM minimum

- `records.officeOfRecord.country`
- `records.officeOfRecord.organization`
- `records.disposition.reviewIndicator`

### 4.4 EDH minimum (transport-ready)

- `transport.edh.identifier`
- `transport.edh.dataItemCreateDateTime`
- `transport.edh.responsibleEntityCustodian.country`
- `transport.edh.responsibleEntityCustodian.organization`

### 4.5 TDF minimum (binding-ready)

- `transport.tdf.version`
- `transport.tdf.binding.signatureAlgorithm`
- `transport.tdf.binding.normalizationMethod`

---

## 5) Extended metacard fields (recommended)

### 5.1 Asset / IRM extended

- Description, subtitle, language, format/mime type, extent, creator/publisher/contact
- Subject category and geospatial/temporal coverage
- Related resource links and rights

### 5.2 Security / ISM extended

- Dissemination controls, releasable/display-only recipients
- CUI controls and decontrol data
- SCI/SAR/non-US/FGI markings when applicable

### 5.3 Records / ERM extended

- FOIA operations indicator
- Record designation date, vital records indicator
- Disposition dates (`dateApplied`, `dateEligible`, `dateLimit`)
- Record control identifier
- Hold details (`identifier`, `type`, `authorizer`, `effectiveDate`, `releasedDate`)

### 5.4 EDH/TDF extended

- EDH authorization reference, originator responsible entity, dataset metadata
- TDF signer subject/issuer/serial and bound value list references

---

## 6) Canonical crosswalk (hybrid profile → standards)

| Hybrid section | Canonical source | Example canonical element/attribute |
|---|---|---|
| `asset.metacard.*` | IRM | `irm:metacardInfo`, `irm:identifier`, `irm:dates` |
| `asset.resource.*` | IRM | `irm:ICResourceMetadataPackage` child elements |
| `security.*` | ISM | `ism:classification`, `ism:ownerProducer`, `ism:disseminationControls` |
| `records.*` | ERM | `erm:ElectronicRecordsManagementMetadata`, `erm:Disposition`, `erm:Hold` |
| `transport.edh.*` | IC-EDH | `edh:Edh`, `icid:Identifier`, `edh:ResponsibleEntity` |
| `transport.tdf.*` | IC-TDF | `tdf:TrustedDataObject`, `tdf:Binding`, `tdf:SignatureValue` |

---

## 7) Netwrix implementation blueprint

> Note: In this execution environment, direct retrieval of Netwrix online docs was blocked by outbound tunnel policy. The implementation below is an operational baseline to be validated against your exact Netwrix 5.7 deployment features.

### 7.1 Taxonomy design (recommended)

Create five coordinated taxonomies:

1. `mc_irm_discovery`
2. `mc_ism_marking`
3. `mc_erm_records`
4. `mc_edh_header`
5. `mc_tdf_binding`

### 7.2 Rule strategy

- **Dictionary/enumeration** rules for controlled tokens (classification codes, dissemination markers, hold types).
- **Regex** rules for identifiers, URI patterns, record controls, dates.
- **Proximity/compound** rules to avoid isolated false positives (e.g., only accept classification when ownerProducer is co-detected).
- **Confidence scoring** with approval workflow for high-impact fields.

### 7.3 Field criticality and workflow

- **Tier 1 (must confirm):** classification, ownerProducer, legal hold metadata, disposition control.
- **Tier 2 (reviewable auto):** dissemination controls, office of record, authorization reference.
- **Tier 3 (auto acceptable):** title, keywords, format, language.

### 7.4 API-serving pattern

Use Netwrix as metacard producer and feed downstream catalogs:

1. Scan/index asset
2. Apply taxonomies and extract candidate metadata
3. Normalize to hybrid metacard JSON contract
4. Validate minimum profile constraints
5. Publish via Netwrix API and/or relay service to enterprise catalog(s)
6. Optionally enrich into EDH/TDF wrapper for data transport operations

### 7.5 Recommended API payload contract

- Emit one metacard object per indexed asset.
- Include `profile.version`, `quality.completenessStatus`, and `quality.validationErrors`.
- Preserve provenance (`quality.sourceSystem`, extraction timestamp, confidence).

---

## 8) Weaknesses, edge cases, and gaps

1. **Policy-vs-content ambiguity**: some ISM/ERM values are policy assertions, not inferable from text.
2. **Version drift risk**: CVEs and schema versions evolve; taxonomy lists can become stale.
3. **Envelope mismatch**: at-rest scans may not include final transport (EDH/TDF) signature context.
4. **Multi-catalog semantics**: different catalogs may flatten or rename fields; strict canonical mapping is required.
5. **Unstructured binaries**: image/PDF scans may need OCR and still produce low-confidence fields.

Mitigation:

- Maintain a versioned profile registry and controlled-value sync process.
- Require human review for Tier 1 fields.
- Track confidence and validation state in payload.
- Keep separate at-rest and transport enrichment steps.

---

## 9) Governance and rollout recommendation

1. **Phase 1 (pilot):** implement minimum metacard + core taxonomies on a limited corpus.
2. **Phase 2 (hardening):** enable extended fields and approval workflow for Tier 1/2.
3. **Phase 3 (enterprise):** publish profile as organizational standard; enforce by API contract tests.
4. **Phase 4 (transport):** introduce EDH/TDF generation service integrated with movement workflows.

---

## 10) Artifacts in this repo

- JSON schema: `docs/hybrid-metacard-profile.schema.json`
- JSON example: `docs/hybrid-metacard-profile.example.json`
- XML template: `docs/hybrid-metacard-profile.xml`
- Netwrix taxonomy mapping matrix: `docs/netwrix-taxonomy-mapping.csv`
