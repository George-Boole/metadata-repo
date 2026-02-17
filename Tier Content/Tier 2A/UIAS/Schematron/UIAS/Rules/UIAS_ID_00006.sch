<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="UIAS-ID-00006">
    <sch:p xmlns:ism="urn:us:gov:ic:ism" ism:classification="U" ism:ownerProducer="USA" class="ruleText">
        [UIAS-ID-00006][Error] If aICP is present, then entityType must be a member of CVEnumUIASPersonEntityType.
        
        Human Readable: If an element with @Name=aICP has a value, then an element with @Name=entityType 
        must have one of the values in CVEnumUIASPersonEntityType. 
    </sch:p>
    <sch:p xmlns:ism="urn:us:gov:ic:ism" ism:classification="U" ism:ownerProducer="USA" class="codeDesc">
        Check for presence of attribute aICP, if present check that attribute entityType is a PE.
    </sch:p>
    <sch:rule id="UIAS-ID-00006-R1" context="saml:AttributeStatement[saml:Attribute[@Name='aICP']]/saml:Attribute[@Name='entityType']">
        <sch:assert test="saml:AttributeValue[some $entityType in $personEntityList satisfies $entityType = tokenize(normalize-space(string(.)),' ')[1]]" flag="error" role="error">
            [UIAS-ID-00006][Error] If an element with @Name=aICP has a value, then an element with 
            @Name=entityType must have one of the values in CVEnumUIASPersonEntityType.
        </sch:assert>
    </sch:rule>
</sch:pattern>