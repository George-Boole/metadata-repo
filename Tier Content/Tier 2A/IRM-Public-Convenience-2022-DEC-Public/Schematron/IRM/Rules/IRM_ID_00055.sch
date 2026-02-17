<?xml version="1.0" encoding="utf-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:ism="urn:us:gov:ic:ism"
             xmlns:sch="http://purl.oclc.org/dsdl/schematron"
             id="IRM-ID-00055">
    <sch:p class="ruleText"
           ism:classification="U"
           ism:ownerProducer="USA">[IRM-ID-00055][Error] If irm:geospatialCoverage/@order is specified then there must be one and only one of
           irm:geospatialIdentifier/irm:countryCode or irm:geospatialIdentifier/irm:subDivisionCode. Human Readable: A single order value must be
           applied to one country code or one subdivision code but not to both.</sch:p>
    <sch:p class="codeDesc"
           ism:classification="U"
           ism:ownerProducer="USA">Make sure that there is only one irm:countryCode or order irm:subDivisionCode when irm:geospatialCoverage uses the
           order attribute.</sch:p>
    <sch:rule id="IRM-ID-00055-R1"
      context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage[$IC_COMPLIANCE]//irm:geospatialCoverage[@irm:order]">

        <sch:assert id="IRM-00055"
                    test="count(irm:geographicIdentifier/irm:countryCode) + count(irm:geographicIdentifier/irm:subDivisionCode) = 1"
                    flag="error"
                    role="error">[IRM-ID-00055][Error] If irm:geospatialCoverage/@order is specified then there must be one and only one of
                    irm:geospatialIdentifier/irm:countryCode or irm:geospatialIdentifier/irm:subDivisionCode. Human Readable: A single order value
                    must be applied to one country code or one subdivision code</sch:assert>
    </sch:rule>
</sch:pattern>
