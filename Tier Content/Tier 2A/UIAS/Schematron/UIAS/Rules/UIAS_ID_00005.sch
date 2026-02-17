<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="UIAS-ID-00005">
    <sch:p xmlns:ism="urn:us:gov:ic:ism" ism:classification="U" ism:ownerProducer="USA" class="ruleText">
        [UIAS-ID-00005][Error] If a saml attribute with @Name=aICP is true, then the saml attribute with @Name=isICMember must be true.
        
        Human Readable: If aICP is true, then isICmember must be true.
    </sch:p>
    <sch:p xmlns:ism="urn:us:gov:ic:ism" ism:classification="U" ism:ownerProducer="USA" class="codeDesc">
        For a saml attribute whose name is isICMember, verify that if there is a saml 
        attribute with name aICP and its value is true, then the value of isICMember 
        must be true.
    </sch:p>
    <sch:rule id="UIAS-ID-00005-R1" context="saml:Attribute[@Name='isICMember']">
        <sch:assert test="if (normalize-space(string(../saml:Attribute[@Name='aICP']/saml:AttributeValue)) = 'true')             then saml:AttributeValue['true' = normalize-space(.)]             else true()" flag="error" role="error">
            [UIAS-ID-00005][Error]  If aICP is true, then isICmember must be true.
        </sch:assert>
    </sch:rule>
    
</sch:pattern>