<?xml version="1.0" encoding="UTF-8"?>
<?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:ism="urn:us:gov:ic:ism" xmlns:sch="http://purl.oclc.org/dsdl/schematron"
    id="UIAS-ID-00079"
    is-a="ValidateValidationEnvSchema">
    <sch:p class="ruleText" ism:ownerProducer="USA" ism:classification="U">
        [UIAS-ID-00079][Error] Regardless of the version indicated on the instance document, 
        the validation infrastructure MUST use a version of 'VIRT' that is version '202010' (Version:2020-OCT) or later. 
        NOTE: This is not an error of the instance document but of the validation environment itself. 
    </sch:p>
    <sch:p class="codeDesc" ism:ownerProducer="USA" ism:classification="U">
        This rule uses an abstract pattern to consolidate logic. 
        It verifies that the validation infrastructure is using the version specified in parameters.
    </sch:p>
    <sch:param name="MinVersion" value="'202010'"/>
    <sch:param name="SpecToCheck" value="'VIRT'"/>
    <sch:param name="pathToDocument" value="'../../Schema/VIRT/VIRT.xsd'"/>
    <sch:param name="RuleID" value="'UIAS-ID-00079'"/>
</sch:pattern>