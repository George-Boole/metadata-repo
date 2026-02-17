<?xml version="1.0" encoding="utf-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:ism="urn:us:gov:ic:ism" xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="BASE-TDF-ID-00024">
    <sch:p class="ruleText" ism:ownerProducer="USA" ism:classification="U">
        [BASE-TDF-ID-00024][Warning] If a TDF assertion contains a cryptographic binding for a reference statement, 
        it should also contain the hash to verify that binding. 
        If the reference statement is encrypted, then the hash can be the encoded and/or decoded hash. 
        If the reference statement is not encrypted, then the hash is expected to be the decoded hash. 
    </sch:p>
    <sch:p class="codeDesc" ism:ownerProducer="USA" ism:classification="U">
        A tdf:Assertion that contains tdf:Binding and tdf:ReferenceStatement
        should contain sfhashv:ContentEncodedHashVerification or sfhashv:ContentDecodedHashVerification if @tdf:isEncrypted = 'true' 
        or just sfhashv:ContentDecodedHashVerification if @tdf:isEncrypted did not exist or @tdf:isEncrypted = 'false'.
    </sch:p>
    <sch:rule id="BASE-TDF-ID-00024-R1" context="tdf:Assertion[.//tdf:Binding and .//tdf:ReferenceStatement]">
        <sch:assert test="if (.//*/@tdf:isEncrypted and .//*/@tdf:isEncrypted = 'true') 
            then .//sfhashv:ContentEncodedHashVerification or ..//sfhashv:ContentDecodedHashVerification 
            else ..//sfhashv:ContentDecodedHashVerification" flag="warning" role="warning">
            [BASE-TDF-ID-00024][Warning]  If a TDF assertion contains a cryptographic binding for a reference statement, 
            it should also contain the hash to verify that binding. 
            If the reference statement is encrypted, then the hash can be the encoded and/or decoded hash. 
            If the reference statement is not encrypted, then the hash is expected to be the decoded hash. 
        </sch:assert>
    </sch:rule>
</sch:pattern>