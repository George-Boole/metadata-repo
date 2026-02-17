<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="UIAS-ID-00057">
    <sch:p xmlns:ism="urn:us:gov:ic:ism" ism:classification="U" ism:ownerProducer="USA" class="ruleText"> [UIAS-ID-00057][Error] The xsi:type of a UIAS attribute MUST match the description for that attribute 
        Name in CVEnumUIASSchemaTypes.xml</sch:p>
    <sch:p xmlns:ism="urn:us:gov:ic:ism" ism:classification="U" ism:ownerProducer="USA" class="codeDesc">  
        Determine the xsi:type of the AttributeValue and check against the correct xsi:type for that AttributeName in the schema </sch:p>
    <sch:rule id="UIAS-ID-00057-R1" context="saml:Attribute">
        <sch:let name="attributeName" value="./@Name"/>
        <sch:let name="type" value="./saml:AttributeValue[1]/@xsi:type"/>
        <sch:assert test="some $item in $schemaTypeList satisfies (                         (matches(normalize-space($attributeName), concat('^',$item//cve:Value,'$'))) and                         (matches(normalize-space($type), concat('^',$item//cve:Description,'$')))                         ) or                         not(some $item in $schemaTypeList satisfies (                         (matches(normalize-space($attributeName), concat('^',$item//cve:Value,'$')))                         ))" flag="error" role="error"> [UIAS-ID-00057][Error] The saml:Attribute/@Name MUST be in the CVE CVEnumUIASSchemaTypes.xml associated with the description matching the xsi:type
           </sch:assert>
    </sch:rule>
</sch:pattern>