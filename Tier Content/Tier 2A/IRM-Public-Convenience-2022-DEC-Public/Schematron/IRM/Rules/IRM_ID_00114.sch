<?xml version="1.0" encoding="utf-8"?>
<sch:pattern xmlns:ism="urn:us:gov:ic:ism"
             xmlns:sch="http://purl.oclc.org/dsdl/schematron"
             id="IRM-ID-00114">
    <sch:p class="ruleText"
           ism:classification="U"
           ism:ownerProducer="USA">[IRM-ID-00114][Error] If waterBody codespace is CWW codespace, then value must be in the CWW waterBody
           cve.</sch:p>
    <sch:p class="codeDesc"
           ism:classification="U"
           ism:ownerProducer="USA">If waterBody codespace is CWW waterBody, then value must be in the CWW waterBody cve</sch:p>
  <sch:rule id="IRM-ID-00114-R1"
      context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:geospatialCoverage//irm:waterBody">

        <sch:let name="isCWWWaterBody"
            value="matches(normalize-space(./@irm:codespace), '^wb:CWW:3:(ed1)$')" />
        <sch:assert test="not($isCWWWaterBody) or (some $token in $waterBodyList satisfies $token = normalize-space(./@irm:code))"
                    flag="error"
                    role="error">[IRM-ID-00114][Error] irm:waterBody must be in CWW waterBody cve.</sch:assert>
    </sch:rule>
</sch:pattern>
