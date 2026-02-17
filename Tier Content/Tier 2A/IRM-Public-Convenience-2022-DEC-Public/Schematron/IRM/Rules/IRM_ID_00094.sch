<?xml version="1.0" encoding="utf-8"?>
<sch:pattern xmlns:ism="urn:us:gov:ic:ism"
             xmlns:sch="http://purl.oclc.org/dsdl/schematron"
             id="IRM-ID-00094">
    <sch:p class="ruleText"
           ism:classification="U"
           ism:ownerProducer="USA">[IRM-ID-00094][Error] If countrycode codespace is GENC codespace, then value must be in the GENC countrycode
           cve.</sch:p>
    <sch:p class="codeDesc"
           ism:classification="U"
           ism:ownerProducer="USA">If countrycode codespace is GENC codespace, then value must be in the GENC countrycode cve</sch:p>
    <sch:rule id="IRM-ID-00094-R1"
      context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:geospatialCoverage//irm:countryCode">

        <sch:let name="isGENCCountryCode"
                 value="matches(normalize-space(./@irm:codespace), '^ge:GENC:3:(ed3|3-[1-9][0-9]*)$')" />
        <sch:assert test="not($isGENCCountryCode) or (some $token in $gencCountryCodeList satisfies $token = normalize-space(./@irm:code))"
                    flag="error"
                    role="error">[IRM-ID-00094][Error] irm:countryCode must be in GENC countrycode cve.</sch:assert>
    </sch:rule>
</sch:pattern>
