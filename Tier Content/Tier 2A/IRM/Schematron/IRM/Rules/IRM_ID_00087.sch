<?xml version="1.0" encoding="utf-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:ism="urn:us:gov:ic:ism"
             xmlns:sch="http://purl.oclc.org/dsdl/schematron"
             id="IRM-ID-00087">
    <sch:p class="ruleText"
           ism:classification="U"
           ism:ownerProducer="USA">[IRM-ID-00087][Error] If @irm:qualifier identifies a intelligence discipline URN, then @intdis:CESVersion must
           exist as well.</sch:p>
    <sch:p class="codeDesc"
           ism:classification="U"
           ism:ownerProducer="USA">Make sure that the INTDIS CVE version attribute exists if intelligence discipline resources are
           identified.</sch:p>
    <sch:rule id="IRM-ID-00087-R1"
      context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:type[starts-with(@irm:qualifier,'urn:us:gov:ic:cvenum:intdis:inteldiscipline')]">

        <sch:assert test="ancestor-or-self::tdf:*//@intdis:CESVersion"
                    flag="error"
                    role="error">[IRM-ID-00087][Error] If @irm:qualifier identifies a intelligence discipline URN, then @intdis:CESVersion must exist
                    as well.</sch:assert>
    </sch:rule>
</sch:pattern>
