<?xml version="1.0" encoding="UTF-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" xmlns:ism="urn:us:gov:ic:ism" id="UIAS-ID-00070" 
    is-a="ValidateTokenValuesExistInNamespaceList">
    <sch:p ism:classification="U" ism:ownerProducer="USA" class="ruleText">
        [UIAS-ID-00070][Error] If the element with @Name-Role uses Nebula namespace, the scope value must 
        exist in the list of allowed Nebula scope values.
    </sch:p>
    <sch:p ism:classification="U" ism:ownerProducer="USA" class="codeDesc">
        If element with @Name-Role uses Nebula namespace, invoke abstract rule ValueExistsInList to check if the value exists
        in the list of allowed Nebula scope values.
    </sch:p>
    <sch:param name="context" value="saml:Attribute[@Name='role']"/>
    <sch:param name="namespaceValue" value="saml:AttributeValue[1]"/>
    <sch:param name="namespaceUsed" value="'Nebula'"/>
    <sch:param name="tokenList" value="$roleNebulaNamedRoleList"/>
    <sch:param name="errMsg" value="'[UIAS-ID-00070][Error] If the element with @Name-Role uses Nebula namespace, the scope value must 
        exist in the list of allowed Nebula scope values.'"/>
</sch:pattern>