<?xml version="1.0" encoding="utf-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:ism="urn:us:gov:ic:ism"
             xmlns:sch="http://purl.oclc.org/dsdl/schematron"
             id="IRM-ID-00072">
    <sch:p class="ruleText"
           ism:classification="U"
           ism:ownerProducer="USA">[IRM-ID-00072][Error] For element irm:searchableDate, irm:start must be earlier than irm:end. Human Readable:
           Within the searchableDate element, the date within the start element must be earlier than the date within the end element.</sch:p>
    <sch:p class="codeDesc"
           ism:classification="U"
           ism:ownerProducer="USA">For each element irm:searchableDate, the child elements irm:start and irm:end are cast as xs:dateTime types, then
           compared to ensure start is less than end.</sch:p>
    <sch:rule id="IRM-ID-00072-R1"
      context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:searchableDate">
        <sch:assert test="if((irm:start castable as xs:dateTime) and (irm:end castable as xs:dateTime)) then xs:dateTime(irm:start) &lt; xs:dateTime(irm:end) else false()"
                    flag="error"
                    role="error">[IRM-ID-00072][Error] For element irm:searchableDate, irm:start must be earlier than irm:end. Human Readable: Within
                    the searchableDate element, the date within the start element must be earlier than the date within the end element.</sch:assert>
    </sch:rule>
</sch:pattern>
