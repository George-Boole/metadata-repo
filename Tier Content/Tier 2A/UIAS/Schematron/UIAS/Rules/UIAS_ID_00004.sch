<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="UIAS-ID-00004">
    <sch:p xmlns:ism="urn:us:gov:ic:ism" ism:classification="U" ism:ownerProducer="USA" class="ruleText">
        [UIAS-ID-00004][Error] If ATOStatus is present, entityType must be a Non-Person Entity.
        
        Human Readable: If element with @Name=ATOStatus is present, then element with @Name=entityType must 
        have one of the values in CVEnumUIASNonPersonEntityType.
    </sch:p>
    <sch:p xmlns:ism="urn:us:gov:ic:ism" ism:classification="U" ism:ownerProducer="USA" class="codeDesc">
        ATOStatus must contain a value if the entity is NPE.
    </sch:p>
    <sch:rule id="UIAS-ID-00004-R1" context="saml:AttributeStatement[saml:Attribute[@Name='ATOStatus']]/saml:Attribute[@Name='entityType']">
        <sch:assert test="saml:AttributeValue[some $entityType in $nonPersonEntityList satisfies $entityType = normalize-space(.)]" flag="error" role="error">
            [UIAS-ID-00004][Error]  If element with @Name=ATOStatus is present, then element with @Name=entityType must 
            have one of the values in CVEnumUIASNonPersonEntityType.
        </sch:assert>
    </sch:rule>
</sch:pattern>