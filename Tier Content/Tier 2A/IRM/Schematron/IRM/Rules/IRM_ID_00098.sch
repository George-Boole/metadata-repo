<?xml version="1.0" encoding="utf-8"?>
<sch:pattern xmlns:ism="urn:us:gov:ic:ism"
             xmlns:sch="http://purl.oclc.org/dsdl/schematron"
             id="IRM-ID-00098">
    <sch:p class="ruleText"
           ism:classification="U"
           ism:ownerProducer="USA">[IRM-ID-00098][Error] Use of a GENC codespace requires the presence of the IC-GENC CESVersion attribute.</sch:p>
    <sch:p class="codeDesc"
           ism:classification="U"
           ism:ownerProducer="USA">If a codespace attribute is specified that contains a GENC codespace, then ensure that the IC-GENC CESVersion
           attribute is specified in the IRM assertion on the ICResourceMetadataPackage.</sch:p>
    <sch:rule id="IRM-ID-00098-R1"
      context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//*[starts-with(@irm:codespace,'ge:GENC') or starts-with(@irm:codespace,'as:GENC')]">

        <sch:assert test="ancestor-or-self::tdf:*/tdf:Assertion//irm:ICResourceMetadataPackage/@genc:CESVersion"
                    flag="error"
                    role="error">[IRM-ID-00098][Error] Use of a GENC codespace requires the presence of the IC-GENC CESVersion
                    attribute.</sch:assert>
    </sch:rule>
</sch:pattern>
