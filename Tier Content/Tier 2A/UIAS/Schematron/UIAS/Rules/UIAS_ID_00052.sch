<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="UIAS-ID-00052">
    <sch:p xmlns:ism="urn:us:gov:ic:ism" ism:classification="U" ism:ownerProducer="USA" class="ruleText">
        [UIAS-ID-00052][Error] There can only be one and only one saml:AttributeValue in any saml:Attribute
    </sch:p>
    <sch:p xmlns:ism="urn:us:gov:ic:ism" ism:classification="U" ism:ownerProducer="USA" class="codeDesc">
        Use the context to look for prior siblings with the same name. Fail if any are found. 
    </sch:p>
    <sch:rule id="UIAS-ID-00052-R1" context="saml:Attribute[count(saml:AttributeValue)!=1]">
        <sch:assert test="not(count(saml:AttributeValue)=0)" flag="error" role="error">
            [UIAS-ID-00052][Error] A saml:AttributeValue must be specified there was not one found.
        </sch:assert>
        <sch:assert test="not(count(saml:AttributeValue)&gt;1)" flag="error" role="error">
            [UIAS-ID-00052][Error] More than one saml:AttributeValue must not be be specified 
            there were <sch:value-of select="count(saml:AttributeValue)"/> found.
        </sch:assert>
</sch:rule>   
</sch:pattern>