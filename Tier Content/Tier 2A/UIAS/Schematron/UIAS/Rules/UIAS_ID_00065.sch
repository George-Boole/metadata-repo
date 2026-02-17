<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="UIAS-ID-00065">
    <sch:p xmlns:ism="urn:us:gov:ic:ism" ism:classification="U" ism:ownerProducer="USA" class="ruleText">
        [UIAS-ID-00065][Error] The saml:Attribute[@Name='countryOfAffiliation']/saml:AttributeValue element cannot have "NATO" as a value.
        
        Human Readable: The SAML AttributeValue element of a SAML Attribute element with attribute Name='countryOfAffiliation' 
        cannot have NATO as a value.
    </sch:p>
    
    <sch:rule id="UIAS-ID-00065-R1" context="saml:Attribute[@Name='countryOfAffiliation']/saml:AttributeValue">
        <sch:assert test="not(contains(normalize-space(.),'NATO'))" flag="error" role="error">
            [UIAS-ID-00065][Error] The saml:Attribute[@Name='countryOfAffiliation']/saml:AttributeValue element cannot have "NATO" as a value.
            
            Human Readable: The SAML AttributeValue element of a SAML Attribute element with attribute Name='countryOfAffiliation' 
            cannot have NATO as a value.
        </sch:assert>
    </sch:rule>
</sch:pattern>