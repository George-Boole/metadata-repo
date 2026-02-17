<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="UIAS-ID-00080">
    <sch:p xmlns:ism="urn:us:gov:ic:ism" ism:classification="U" ism:ownerProducer="USA" class="ruleText">
        [UIAS-ID-00080][Error] All SAR tokens in fineAccessControls MUST conform to the regex 
        ^SAR-[A-Z]{3,}:((C|S|TS):){0,1}[A-Za-z0-9._-]{1,}$ . Human Readable:  All SAR tokens in fineAccessControls must conform to
        a regular expression for: SAR-SourceAuthority:Classification:SAPmarking or SAR-SourceAuthority:SAPmarking.
    </sch:p>
    <sch:p xmlns:ism="urn:us:gov:ic:ism" ism:classification="U" ism:ownerProducer="USA" class="codeDesc">
        For all SAR tokens within fineAccessControls, this rule ensures that each token follows the regex
        ^SAR-[A-Z]{3,}:((C|S|TS):){0,1}[A-Za-z0-9._-]{1,}$ . The rule looks for UIAS saml:Attribute elements
        that have attribute Name='fineAccessControls' and that contain SAR fineAccessControls identified by
        'SAR-'.  Next,, a variable $nonmatchingTokens is created that takes all the SAR tokens in the saml
    </sch:p>
    <sch:rule id="UIAS-ID-00080-R1" context="saml:Attribute[@Name='fineAccessControls'][contains(./saml:AttributeValue,'SAR-')]">
        <sch:let name="nonmatchingTokens" value="for $token in tokenize(normalize-space(string(./saml:AttributeValue)), ' ') 
            return if (starts-with($token,'SAR-') and
            not(matches($token,'^SAR-[A-Z]{3,}:((C|S|TS):){0,1}[A-Za-z0-9._-]{1,}$'))) then $token else null"/>
        <sch:assert test="count($nonmatchingTokens) = 0" flag="error" role="error">
            [UIAS-ID-00080][Error] All SAR tokens in the fineAccessControls attribute MUST conform to the regex 
            ^SAR-[A-Z]{3,}:((C|S|TS):){0,1}[A-Za-z0-9._-]{1,}$ . Human Readable:  All SAR tokens in fineAccessControls must conform to
            a regular expression for: SAR-SourceAuthority:Classification:SAPmarking or SAR-SourceAuthority:SAPmarking.
        </sch:assert>
    </sch:rule>
</sch:pattern>