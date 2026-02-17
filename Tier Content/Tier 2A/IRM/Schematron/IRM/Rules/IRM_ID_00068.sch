<?xml version="1.0" encoding="utf-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:ism="urn:us:gov:ic:ism"
             xmlns:sch="http://purl.oclc.org/dsdl/schematron"
             id="IRM-ID-00068">
    <sch:p class="ruleText"
           ism:classification="U"
           ism:ownerProducer="USA">[IRM-ID-00068][Error] For element irm:taskID, if attribute xlink:href exists, then the attribute must have a
           non-null value. Human Readable:</sch:p>
    <sch:p class="codeDesc"
           ism:classification="U"
           ism:ownerProducer="USA">The normalize-spaced value of attribute xlink:href is checked to make sure the length of the resulting string is
           greater than zero, which indicates non-whitespace content.</sch:p>
    <sch:rule id="IRM-ID-00068-R1"
      context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:taskID[@xlink:href]">
              
        <sch:assert test="normalize-space(string(@xlink:href))"
                    flag="error"
                    role="error">[IRM-ID-00068][Error] For element irm:taskID if attribute xlink:href exists, then the attribute must have a non-null
                    value. Human Readable:</sch:assert>
    </sch:rule>
</sch:pattern>
