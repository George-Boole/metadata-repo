<?xml version="1.0" encoding="UTF-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:ism="urn:us:gov:ic:ism" xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="IC-TDF-ID-00057" is-a="ValidateValidationEnvSchema">
    <sch:p class="ruleText" ism:ownerProducer="USA" ism:classification="U">
        [IC-TDF-ID-00057][Error] Regardless of the version indicated on the instance document, the validation infrastructure
        MUST use a version of 'IC-SF' that is version '202111' (Version:2021-NOV) or later. 
        NOTE: This is not an error of the instance document but of the validation environment itself. 
    </sch:p>
    <sch:p class="codeDesc" ism:ownerProducer="USA" ism:classification="U">
        This rule uses an abstract pattern to consolidate logic. It verifies that the validation infrastructure is
        using the version specified in parameters.
    </sch:p>
    <sch:param name="MinVersion" value="'202111'"/>
    <sch:param name="SpecToCheck" value="'IC-SF'"/>
    <sch:param name="pathToDocument" value="'../../Schema/IC-SF/IC-SF.xsd'"/>
    <sch:param name="RuleID" value="'IC-TDF-ID-00057'"/>
</sch:pattern>
