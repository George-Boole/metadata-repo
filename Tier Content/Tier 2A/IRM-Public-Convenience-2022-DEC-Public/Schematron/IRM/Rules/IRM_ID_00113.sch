<?xml version="1.0" encoding="utf-8"?>
<sch:pattern xmlns:ism="urn:us:gov:ic:ism"
             xmlns:sch="http://purl.oclc.org/dsdl/schematron"
             id="IRM-ID-00113">
    <sch:p class="ruleText"
           ism:classification="U"
           ism:ownerProducer="USA">[IRM-ID-00113][Error] If present, at least one irm:waterBody in a irm:geographicIdentifier must be a CWW ED1
        codespace: ^wb:CWW:3:(ed1)$</sch:p>
    <sch:p class="codeDesc"
           ism:classification="U"
           ism:ownerProducer="USA">If present, at least one irm:waterBody in a irm:geographicIdentifier must be a CWW ED3 codespace:
        ^wb:CWW:3:(ed1)$</sch:p>
  <sch:rule id="IRM-ID-00113-R1"
      context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:geospatialCoverage">
              
        <sch:let name="hasWaterBody"
                 value="count(irm:geographicIdentifier/irm:waterBody) &gt; 0" />
      <sch:assert test="not($hasWaterBody) or (some $waterBody in irm:geographicIdentifier/irm:waterBody satisfies matches(normalize-space($waterBody/@irm:codespace), '^wb:CWW:3:(ed1)$'))"
                    flag="error"
                    role="error">[IRM-ID-00113][Error] irm:waterBody must be a GENC ED3 codespace: ^wb:CWW:3:(ed1)$</sch:assert>
    </sch:rule>
</sch:pattern>
