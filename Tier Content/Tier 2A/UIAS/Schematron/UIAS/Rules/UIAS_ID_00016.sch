<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="UIAS-ID-00016">
    <sch:p xmlns:ism="urn:us:gov:ic:ism" ism:classification="U" ism:ownerProducer="USA" class="ruleText">
        [UIAS-ID-00016][Error] dutyOrganization must be present.
        
        Human Readable: An element with @Name=dutyOrganization must be present.
    </sch:p>
    <sch:p xmlns:ism="urn:us:gov:ic:ism" ism:classification="U" ism:ownerProducer="USA" class="codeDesc">
        dutyOrganization must be present.
    </sch:p>
    <sch:rule id="UIAS-ID-00016-R1" context="saml:AttributeStatement">
        <sch:assert test="saml:Attribute[@Name='dutyOrganization']" flag="error" role="error">
            [UIAS-ID-00016][Error] An element with @Name=dutyOrganization must be present.
        </sch:assert>
    </sch:rule>
</sch:pattern>