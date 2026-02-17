<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="UIAS-ID-00056">
    <sch:p xmlns:ism="urn:us:gov:ic:ism" ism:classification="U" ism:ownerProducer="USA" class="ruleText"> [UIAS-ID-00056][Warning] The saml:Attribute/@Name SHOULD be in the CVE CVEnumUIASSchemaTypes.xml unless it is a local/extended attribute.</sch:p>
    <sch:p xmlns:ism="urn:us:gov:ic:ism" ism:classification="U" ism:ownerProducer="USA" class="codeDesc">  
            Given the AttributeName, lookup that name in the SchemaTypes to make sure it's a valid AttributeName</sch:p>
    <sch:rule id="UIAS-ID-00056-R1" context="saml:Attribute">
        <sch:let name="attributeName" value="./@Name"/>
        <sch:assert test="$attributeName = $schemaTypeList//cve:Value or (some $item in $schemaTypeList//cve:Value satisfies (matches(normalize-space($attributeName), concat('^',$item,'$'))))" flag="error" role="error"> [UIAS-ID-00056][Warning] The saml:Attribute/@Name SHOULD be in the CVE CVEnumUIASSchemaTypes.xml 
            <sch:value-of select="$attributeName"/> was not in CVEnumUIASSchemaTypes it MAY be a local/extended attribute. </sch:assert>
    </sch:rule>
</sch:pattern>