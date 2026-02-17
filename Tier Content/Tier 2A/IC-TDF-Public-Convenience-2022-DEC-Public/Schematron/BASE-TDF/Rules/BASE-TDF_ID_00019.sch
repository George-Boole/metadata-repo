<?xml version="1.0" encoding="utf-8"?>
<?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:ism="urn:us:gov:ic:ism"
             xmlns:sch="http://purl.oclc.org/dsdl/schematron"
             id="BASE-TDF-ID-00019">
    <sch:p class="ruleText" ism:ownerProducer="USA" ism:classification="U">[BASE-TDF-ID-00019][Error] If there are more than one EncryptionInformation elements specified in any one
           EncryptionInformation Group than @tdf:sequenceNum must also be specified.</sch:p>
    <sch:p class="codeDesc" ism:ownerProducer="USA" ism:classification="U">This rule checks that if there are more than one tdf:EncryptionInformation in any encryption group (if it has
           siblings) then it checks that a tdf:sequenceNum attribute is present on the EncryptionInformation element.</sch:p>
    <sch:rule id="BASE-TDF-ID-00019-R1"
             context="tdf:EncryptionInformation[count((preceding-sibling::tdf:EncryptionInformation, following-sibling::tdf:EncryptionInformation))&gt;0]">
              
        <sch:assert test="@tdf:sequenceNum" flag="error" role="error">[BASE-TDF-ID-00019][Error] If there are more than one EncryptionInformation elements specified in any one
                    EncryptionInformation Group than @tdf:sequenceNum must also be specified.</sch:assert>
    </sch:rule>
</sch:pattern>
