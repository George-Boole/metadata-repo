<?xml version="1.0" encoding="utf-8"?>
<?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:ism="urn:us:gov:ic:ism"
             xmlns:sch="http://purl.oclc.org/dsdl/schematron"
             id="BASE-TDF-ID-00016">
    <sch:p class="ruleText" ism:ownerProducer="USA" ism:classification="U">[BASE-TDF-ID-00016][Error] If data is labeled as encrypted, then EncryptionInformation must be specified. (Assertion
           Statement or TrustedDataObject Payload).</sch:p>
    <sch:p class="codeDesc" ism:ownerProducer="USA" ism:classification="U">This rule ensures that the previous sibling of the Statement or Payload marked with the encrypted attribute set to
           true is EncryptionInformation.</sch:p>
    <sch:rule id="BASE-TDF-ID-00016-R1" context="tdf:*[@tdf:isEncrypted=true()]">
        <sch:assert test="preceding-sibling::tdf:EncryptionInformation"
                  flag="error"
                  role="error">[BASE-TDF-ID-00016][Error] If data is labeled as encrypted, then EncryptionInformation must be specified. (Assertion
                    Statement or TrustedDataObject Payload).</sch:assert>
    </sch:rule>
</sch:pattern>
