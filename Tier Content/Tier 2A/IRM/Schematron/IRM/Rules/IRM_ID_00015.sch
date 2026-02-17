<?xml version="1.0" encoding="utf-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:ism="urn:us:gov:ic:ism"
             xmlns:sch="http://purl.oclc.org/dsdl/schematron"
             id="IRM-ID-00015">
    <sch:p class="ruleText"
           ism:classification="U"
           ism:ownerProducer="USA">[IRM-ID-00015][Error] If element irm:dates exists without one of the attributes @irm:created or @irm:posted Human
           Readable: Every irm:dates element must have at least one of @irm:created or @irm:posted.</sch:p>
    <sch:p class="codeDesc"
           ism:classification="U"
           ism:ownerProducer="USA">This rule checks that for each occurrence of irm:dates that either @irm:created or @irm:posted is
           specified.</sch:p>
    <sch:rule id="IRM-ID-00015-R1"
      context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage[$IC_COMPLIANCE]//irm:dates">
        <sch:assert test="@irm:created or @irm:posted"
                    flag="error"
                    role="error">[IRM-ID-00015][Error] Every irm:date must have at least one of @irm:created or @irm:posted.</sch:assert>
    </sch:rule>
</sch:pattern>
