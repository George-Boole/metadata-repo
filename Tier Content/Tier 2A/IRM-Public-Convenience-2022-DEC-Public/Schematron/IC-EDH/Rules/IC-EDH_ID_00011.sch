<?xml version="1.0" encoding="UTF-8"?>
<?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:ism="urn:us:gov:ic:ism" xmlns:sch="http://purl.oclc.org/dsdl/schematron"
             id="IC-EDH-ID-00011"
             is-a="ValidateValidationEnvSchema">
    <sch:p class="ruleText" ism:ownerProducer="USA" ism:classification="U">[IC-EDH-ID-00011][Error] Regardless of the version indicated on the instance document, 
            the validation infrastructure MUST use a version of 'IC-ID' that is version '1' or later. NOTE: This is not an error of the instance
                document but of the validation environment itself. </sch:p>
    <sch:p class="codeDesc" ism:ownerProducer="USA" ism:classification="U">This rule uses an abstract pattern to consolidate logic. 
        It verifies that the validation infrastructure is using the version specified in parameters.</sch:p>
    <sch:param name="MinVersion" value="'1'"/>
    <sch:param name="SpecToCheck" value="'IC-ID'"/>
    <sch:param name="pathToDocument" value="'../../Schema/IC-ID/IC-ID.xsd'"/>
    <sch:param name="RuleID" value="'IC-EDH-ID-00011'"/>
</sch:pattern>