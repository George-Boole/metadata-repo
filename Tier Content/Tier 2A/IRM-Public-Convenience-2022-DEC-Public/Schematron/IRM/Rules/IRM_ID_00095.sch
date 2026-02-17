<?xml version="1.0" encoding="utf-8"?>
<sch:pattern xmlns:ism="urn:us:gov:ic:ism"
             xmlns:sch="http://purl.oclc.org/dsdl/schematron"
             id="IRM-ID-00095">
    <sch:p class="ruleText"
           ism:classification="U"
           ism:ownerProducer="USA">[IRM-ID-00095][Error] If present, at least one irm:subDivisionCode in a irm:geographicIdentifier must be a GENC
           ED3 codespace: ^as:GENC:6:(ed3|3-[1-9][0-9]*)$</sch:p>
    <sch:p class="codeDesc"
           ism:classification="U"
           ism:ownerProducer="USA">If present, at least one irm:subDivisionCode in a irm:geographicIdentifier must be a GENC ED3 codespace:
           ^as:GENC:6:(ed3|3-[1-9][0-9]*)$</sch:p>
    <sch:rule id="IRM-ID-00095-R1"
      context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:geospatialCoverage">
              
        <sch:let name="hasSubDivisions"
                 value="count(irm:geographicIdentifier/irm:subDivisionCode) &gt; 0" />
        <sch:assert test="not($hasSubDivisions) or (some $subDivisionCode in irm:geographicIdentifier/irm:subDivisionCode satisfies matches(normalize-space($subDivisionCode/@irm:codespace), '^as:GENC:6:(ed3|3-[1-9][0-9]*)$'))"
                    flag="error"
                    role="error">[IRM-ID-00095][Error] irm:subDivisionCode must be a GENC ED3 codespace: ^as:GENC:6:(ed3|3-[1-9][0-9]*)$</sch:assert>
    </sch:rule>
</sch:pattern>
