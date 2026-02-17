<?xml version="1.0" encoding="utf-8"?>
<sch:pattern xmlns:ism="urn:us:gov:ic:ism"
             xmlns:sch="http://purl.oclc.org/dsdl/schematron"
             id="IRM-ID-00090">
    <sch:p class="ruleText"
           ism:classification="U"
           ism:ownerProducer="USA">[IRM-ID-00090][Error] If subDivisionCode codespace is GENC codespace, then value must be in the GENC
           subDivisionCode cve.</sch:p>
    <sch:p class="codeDesc"
           ism:classification="U"
           ism:ownerProducer="USA">If subDivisionCode codespace is GENC codespace, then value must be in the GENC subDivisionCode cve.</sch:p>
    <sch:rule id="IRM-ID-00090-R1"
      context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:geospatialCoverage//irm:subDivisionCode">

        <sch:let name="isGENCSubDivision"
                 value="matches(normalize-space(./@irm:codespace), '^as:GENC:6:(ed3|3-[1-9][0-9]*)$')" />
        <sch:assert test="not($isGENCSubDivision) or (some $token in $gencSubDivisionList satisfies $token = normalize-space(./@irm:code))"
                    flag="error"
                    role="error">[IRM-ID-00090][Error] If subDivisionCode codespace is GENC codespace, then value must be in the GENC subDivisionCode
                    cve.</sch:assert>
    </sch:rule>
</sch:pattern>
