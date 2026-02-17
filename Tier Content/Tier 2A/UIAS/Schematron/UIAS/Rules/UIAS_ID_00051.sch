<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="UIAS-ID-00051">
    <sch:p xmlns:ism="urn:us:gov:ic:ism" ism:classification="U" ism:ownerProducer="USA" class="ruleText">
        [UIAS-ID-00051][Error] There can only be one saml:Attribute with any given @Name
    </sch:p>
    <sch:p xmlns:ism="urn:us:gov:ic:ism" ism:classification="U" ism:ownerProducer="USA" class="codeDesc">
        Use the context to look for prior siblings with the same name. Fail if any are found. 
    </sch:p>
    <sch:rule id="UIAS-ID-00051-R1" context="saml:Attribute[@Name=preceding-sibling::saml:Attribute/@Name]">
        <sch:assert test="false()" flag="error" role="error">
            [UIAS-ID-00051][Error] Duplicate saml:Attribute/@Name are not allowed. More than one of "<sch:value-of select="./@Name"/>" was found.
        </sch:assert>
</sch:rule>   
</sch:pattern>