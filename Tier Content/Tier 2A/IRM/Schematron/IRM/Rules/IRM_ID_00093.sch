<?xml version="1.0" encoding="utf-8"?>
<sch:pattern xmlns:ism="urn:us:gov:ic:ism"
             xmlns:sch="http://purl.oclc.org/dsdl/schematron"
             id="IRM-ID-00093">
    <sch:p class="ruleText"
           ism:classification="U"
           ism:ownerProducer="USA">[IRM-ID-00093][Error] If present, at least one irm:countryCode in a irm:geographicIdentifier must be a GENC ED3
           codespace: ^ge:GENC:3:(ed3|3-[1-9][0-9]*)$</sch:p>
    <sch:p class="codeDesc"
           ism:classification="U"
           ism:ownerProducer="USA">If present, at least one irm:countryCode in a irm:geographicIdentifier must be a GENC ED3 codespace:
           ^ge:GENC:3:(ed3|3-[1-9][0-9]*)$</sch:p>
    <sch:rule id="IRM-ID-00093-R1"
      context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:geospatialCoverage">
              
        <sch:let name="hasCountryCodes"
                 value="count(irm:geographicIdentifier/irm:countryCode) &gt; 0" />
        <sch:assert test="not($hasCountryCodes) or (some $countryCode in irm:geographicIdentifier/irm:countryCode satisfies matches(normalize-space($countryCode/@irm:codespace), '^ge:GENC:3:(ed3|3-[1-9][0-9]*)$'))"
                    flag="error"
                    role="error">[IRM-ID-00093][Error] irm:countryCode must be a GENC ED3 codespace: ^ge:GENC:3:(ed3|3-[1-9][0-9]*)$</sch:assert>
    </sch:rule>
</sch:pattern>
