<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" is-a="ValidateTokenValuesExistenceInList" id="UIAS-ID-00021">
    <sch:p xmlns:ism="urn:us:gov:ic:ism" ism:classification="U" ism:ownerProducer="USA" class="ruleText">
        [UIAS-ID-00021][Error] entityType value must be a member of the UIAS internal CVEnumUIASEntityType.
        
        Human Readable: The element with @Name=entityType must be a member of the UIAS internal CVEnum CVEnumUIASEntityType.
    </sch:p>
    <sch:p xmlns:ism="urn:us:gov:ic:ism" ism:classification="U" ism:ownerProducer="USA" class="codeDesc">
        check that entityType value is a member of the UIAS internal CVEnum CVEnumUIASEntityType.
    </sch:p>
    <sch:param name="context" value="saml:Attribute[@Name='entityType']"/>
    <sch:param name="list" value="$entityTypeList"/>
    <sch:param name="searchTermList" value="normalize-space(saml:AttributeValue)"/>
    <sch:param name="errMsg" value="' [UIAS-ID-00021][Error] The element with @Name=entityType must be a member of the UIAS internal CVEnum CVEnumUIASEntityType.  '"/>
</sch:pattern>