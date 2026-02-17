<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="UIAS-ID-00066">
    <sch:p xmlns:ism="urn:us:gov:ic:ism" ism:classification="U" ism:ownerProducer="USA" class="ruleText"> [UIAS-ID-00066][Error] If the xsi:type defined is in the CVEnumUIASSchemaType CVE, 
    then the FriendlyName must be the concatenated string of the UIAS URN ('urn:us:gov:ic:uias:') and the Name.</sch:p>
    
    <sch:p xmlns:ism="urn:us:gov:ic:ism" ism:classification="U" ism:ownerProducer="USA" class="codeDesc"> If @xsi:type is a type defined in the CVEnumUIASSchemaType CVE, then @FriendlyName must be the concatenated
    string of the UIAS URN ('urn:us:gov:ic:uias:') and @Name. </sch:p>
    
    <sch:rule id="UIAS-ID-00066-R1" context="saml:Attribute">
        <sch:let name="attributeName" value="./@Name"/>
        <sch:let name="uiasURN" value="'urn:us:gov:ic:uias:'"/>
        <sch:let name="attributeFriendlyName" value="./@FriendlyName"/>
        <sch:let name="type" value="./saml:AttributeValue[1]/@xsi:type"/>
        <sch:assert test="if (some $item in $schemaTypeList satisfies (matches(normalize-space($type), concat('^',$item//cve:Description,'$'))))                   then not(compare($attributeFriendlyName, concat($uiasURN, $attributeName)))                   else true()" flag="error" role="error"> [UIAS-ID-00066][Error] If the xsi:type defined is in the CVEnumUIASSchemaType CVE, 
            then the FriendlyName must be the concatenated string of the UIAS URN ('urn:us:gov:ic:uias:') and the Name.
        </sch:assert>
    </sch:rule>
</sch:pattern>