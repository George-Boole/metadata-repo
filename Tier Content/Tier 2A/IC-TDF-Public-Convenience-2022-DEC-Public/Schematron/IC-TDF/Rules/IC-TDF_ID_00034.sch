<?xml version="1.0" encoding="utf-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:ism="urn:us:gov:ic:ism"
             xmlns:sch="http://purl.oclc.org/dsdl/schematron"
             id="IC-TDF-ID-00034">
    <sch:p class="ruleText"
           ism:ownerProducer="USA"
           ism:classification="U">[IC-TDF-ID-00034][Error] An Assertion with a ReferenceStatement must have an ExternalEDH or ExternalSecurity
           element in the StatementMetadata.</sch:p>
    <sch:p class="codeDesc"
           ism:ownerProducer="USA"
           ism:classification="U">For Assertion elements with a ReferenceStatement, ensure that the StatementMetadata has an ExternalEDH or
           ExternalSecurity element.</sch:p>
    <sch:rule id="IC-TDF-ID-00034-R1"
              context="tdf:Assertion//tdf:ReferenceStatement">
        <sch:assert test="ancestor::tdf:Assertion/tdf:StatementMetadata[edh:ExternalEdh or arh:ExternalSecurity]"
                    flag="error"
                    role="error">[IC-TDF-ID-00034][Error] An Assertion with a ReferenceStatement must have an ExternalEDH or ExternalSecurity element
                    in the StatementMetadata.</sch:assert>
    </sch:rule>
</sch:pattern>
