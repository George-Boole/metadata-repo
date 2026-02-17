<?xml version="1.0" encoding="utf-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:ism="urn:us:gov:ic:ism"
             xmlns:sch="http://purl.oclc.org/dsdl/schematron"
             id="IRM-ID-00045">
    <sch:p class="ruleText"
           ism:classification="U"
           ism:ownerProducer="USA">[IRM-ID-00045][Error] Element irm:geospatialCoverage must have ISM classification markings. Human Readable: The
           geospatialCoverage element must have a classification attribute.</sch:p>
    <sch:p class="codeDesc"
           ism:classification="U"
           ism:ownerProducer="USA">For each irm:geospatialCoverage element, ensure that attribute ism:classification is specified.</sch:p>
    <sch:rule id="IRM-ID-00045-R1"
      context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage[$IC_COMPLIANCE]//irm:geospatialCoverage">
              
        <sch:assert test="@ism:classification"
                    flag="error"
                    role="error">[IRM-ID-00045][Error] Element irm:geospatialCoverage must have ISM classification markings. Human Readable: The
                    geospatialCoverage element must have a classification attribute.</sch:assert>
    </sch:rule>
</sch:pattern>
