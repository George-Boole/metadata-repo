<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="UIAS-ID-00012">
    <sch:p xmlns:ism="urn:us:gov:ic:ism" ism:classification="U" ism:ownerProducer="USA" class="ruleText">
        [UIAS-ID-00012][Error] countryOfAffiliation must contain at least one value.
        
        Human Readable: An element with @Name=countryOfAffiliation must contain at least one value.
    </sch:p>
    <sch:p xmlns:ism="urn:us:gov:ic:ism" ism:classification="U" ism:ownerProducer="USA" class="codeDesc">
        countryOfAffiliation must contain at least one value.
    </sch:p>
    <sch:rule id="UIAS-ID-00012-R1" context="saml:Attribute[@Name='countryOfAffiliation']">
        <sch:assert test="count(tokenize(normalize-space(string(saml:AttributeValue[1])), ' ')) &gt; 0" flag="error" role="error">
            [UIAS-ID-00012][Error] An element with @Name=countryOfAffiliation must contain at least one value.
        </sch:assert>
    </sch:rule>
</sch:pattern>