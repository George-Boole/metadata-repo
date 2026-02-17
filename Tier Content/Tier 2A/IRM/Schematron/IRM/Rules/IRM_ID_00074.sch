<?xml version="1.0" encoding="utf-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:ism="urn:us:gov:ic:ism"
             xmlns:sch="http://purl.oclc.org/dsdl/schematron"
             id="IRM-ID-00074">
    <sch:p class="ruleText"
           ism:classification="U"
           ism:ownerProducer="USA">[IRM-ID-00074][Error] For element irm:searchableDate, elements irm:start and irm:end must match the xsd:dateTime
           format. Human Readable: Within the searchableDate element, the start and end elements values must conform to the xsd:dateTime
           format.</sch:p>
    <sch:p class="codeDesc"
           ism:classification="U"
           ism:ownerProducer="USA">For each element irm:searchableDate, ensure that elements irm:start and irm:end are each castable as
           xs:dateTime type.</sch:p>
    <sch:rule id="IRM-ID-00074-R1"
      context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:searchableDate">
        <sch:assert test="(irm:start castable as xs:dateTime) and (irm:end castable as xs:dateTime)"
                    flag="error"
                    role="error">[IRM-ID-00074][Error] For element irm:searchableDate, elements irm:start and irm:end must match the xsd:dateTime
                    format. Human Readable: Within the searchableDate element, the start and end elements values must conform to the xsd:dateTime
                    format.</sch:assert>
    </sch:rule>
</sch:pattern>
