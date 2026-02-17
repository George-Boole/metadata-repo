<?xml version="1.0" encoding="utf-8"?>
<?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:ism="urn:us:gov:ic:ism"
             xmlns:sch="http://purl.oclc.org/dsdl/schematron"
             id="BASE-TDF-ID-00015">
    <sch:p class="ruleText" ism:ownerProducer="USA" ism:classification="U">[BASE-TDF-ID-00015][Error] If EncryptionInformation is specified, then the data it refers to must be labeled as
           encrypted. (Assertion Statement or TrustedDataObject Payload).</sch:p>
    <sch:p class="codeDesc" ism:ownerProducer="USA" ism:classification="U">This rule ensures that the following sibling of EncryptionInformation, the Payload or Assertion Statement, has the
           encrypted attribute set to true.</sch:p>
    <sch:rule id="BASE-TDF-ID-00015-R1"
             context="tdf:EncryptionInformation[parent::tdf:Assertion] | tdf:EncryptionInformation[parent::tdf:TrustedDataObject]">
        <sch:assert test="following-sibling::tdf:*[@tdf:isEncrypted=true()]"
                  flag="error"
                  role="error">[BASE-TDF-ID-00015][Error] If EncryptionInformation is specified, then the data it refers to must be labeled as
                    encrypted. (Assertion Statement or TrustedDataObject Payload).</sch:assert>
    </sch:rule>
</sch:pattern>
