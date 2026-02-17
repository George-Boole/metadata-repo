<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="UIAS-ID-00024">
    <sch:p xmlns:ism="urn:us:gov:ic:ism" ism:classification="U" ism:ownerProducer="USA" class="ruleText">
        [UIAS-ID-00024][Error] If entityType is PE, then aICP must be present.
        
        Human Readable:  If element with @Name=entityType has a value of one of the values in 
        CVEnumUIASPersonEntityType, then element with @Name=aICP must have a value.
    </sch:p>
    <sch:p xmlns:ism="urn:us:gov:ic:ism" ism:classification="U" ism:ownerProducer="USA" class="codeDesc">
        Check for attribute entityType = PE, if true make sure there is an aICP attribute present.
    </sch:p>
    <sch:rule id="UIAS-ID-00024-R1" context="saml:Attribute[@Name='entityType']">
        <sch:assert test="( if (saml:AttributeValue[some $entityType in $personEntityList satisfies $entityType = normalize-space(.)])              then                 (count(tokenize(normalize-space(string(../saml:Attribute[@Name='aICP']/saml:AttributeValue)), ' ')) &gt; 0)             else                 true())" flag="error" role="error">
            [UIAS-ID-00024][Error]  If element with @Name=entityType has a value of one of the values in 
            CVEnumUIASPersonEntityType, then element with @Name=aICP must have a value.
        </sch:assert>
    </sch:rule>
</sch:pattern>