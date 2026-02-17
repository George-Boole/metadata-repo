<?xml version="1.0" encoding="UTF-8"?>
<?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:ism="urn:us:gov:ic:ism" xmlns:sch="http://purl.oclc.org/dsdl/schematron"
             id="IC-EDH-ID-00014"
             is-a="ValidateValidationEnvCVE">
    <sch:p class="ruleText" ism:ownerProducer="USA" ism:classification="U">[IC-EDH-ID-00014][Error] Regardless of the version indicated on the instance document, 
            the validation infrastructure MUST use a version of 'ISMCAT' that is version '201903' (Version:2019-MAR) or later. NOTE: This is not an error of the instance
                document but of the validation environment itself. </sch:p>
    <sch:p class="codeDesc" ism:ownerProducer="USA" ism:classification="U">This rule uses an abstract pattern to consolidate logic. 
        It verifies that the validation infrastructure is using the version specified in parameters.</sch:p>
    <sch:param name="MinVersion" value="'201903'"/>
    <sch:param name="SpecToCheck" value="'ISMCAT'"/>
    <sch:param name="pathToDocument" value="'../../CVE/ISMCAT/CVEnumISMCATTetragraph.xml'"/>
    <sch:param name="RuleID" value="'IC-EDH-ID-00014'"/>
</sch:pattern>