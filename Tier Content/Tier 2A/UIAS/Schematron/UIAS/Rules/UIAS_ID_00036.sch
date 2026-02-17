<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="UIAS-ID-00036">
    <sch:p xmlns:ism="urn:us:gov:ic:ism" ism:classification="U" ism:ownerProducer="USA" class="ruleText">
        [UIAS-ID-00036][Error] The value of dutyOrganizationUnit element must begin with the value of the dutyOrganization element.
        
        Human Readable:  The value of element with @Name=dutyOrganizationUnit must begin with the value 
        of the element with @Name=dutyOrganization.
    </sch:p>
    <sch:p xmlns:ism="urn:us:gov:ic:ism" ism:classification="U" ism:ownerProducer="USA" class="codeDesc">
        The value of dutyOrganizationUnit must begin with the value of dutyOrganization.
    </sch:p>
    <sch:rule id="UIAS-ID-00036-R1" context="saml:Attribute[@Name='dutyOrganizationUnit']">
        <sch:assert test="normalize-space(string(../saml:Attribute[@Name='dutyOrganization'][1]/saml:AttributeValue)) = tokenize(normalize-space(string(saml:AttributeValue[1])),':')[1]" flag="error" role="error">
            [UIAS-ID-00036][Error] The value of element with @Name=dutyOrganizationUnit must begin with the value 
            of the element with @Name=dutyOrganization.
        </sch:assert>

    </sch:rule>

</sch:pattern>