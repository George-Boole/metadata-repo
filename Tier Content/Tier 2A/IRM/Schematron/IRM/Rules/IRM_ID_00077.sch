<?xml version="1.0" encoding="utf-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:ism="urn:us:gov:ic:ism" xmlns:sch="http://purl.oclc.org/dsdl/schematron"
    id="IRM-ID-00077">
    <sch:p class="ruleText" ism:classification="U" ism:ownerProducer="USA">[IRM-ID-00077][Error] For
        element irm:person at least one of the following child elements must have non-whitespace
        content: irm:surname, irm:userID, irm:name, irm:affiliation, irm:postalAddress, irm:phone
        irm:email.</sch:p>
    <sch:p class="codeDesc" ism:classification="U" ism:ownerProducer="USA">This pattern uses an
        abstract rule to consolidate logic. It normalizes the space of the value of the specified
        child elements and makes sure that the length of the resulting string is greater than zero,
        which indicates non-whitespace content. Element irm:postalAddress cannot contain text
        content, so count the number of its child elements that contain non-white space and make
        sure that the count is great than 0. The abstract rule is extended once for each required
        element in rule IRM_ID_00077.</sch:p>
    <!-- Abstract rule, which asserts that at least one of the listed child elements has non-whitespace content -->
    <sch:rule abstract="true" id="abs.rule00077">
        <sch:assert
            test="
                irm:surname[normalize-space(string(text()))] or irm:userID[normalize-space(string(text()))] or irm:name[normalize-space(string(text()))] or irm:affiliation[normalize-space(string(text()))] or irm:phone[normalize-space(string(text()))] or irm:email[normalize-space(string(text()))] or (some $token in ancestor::irm:postalAddress/*/text()
                    satisfies normalize-space(string($token)))"
            flag="error" role="error">[IRM-ID-00077][Error] For element irm:person at least one of
            the following child elements must have non-whitespace content: irm:surname, irm:userID,
            irm:name, irm:affiliation, irm:postalAddress, irm:phone irm:email.</sch:assert>
    </sch:rule>
    <!-- Begin using abstract rule to check required elements -->
    <sch:rule id="IRM-ID-00077-R2"
        context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:person">
        <sch:extends rule="abs.rule00077"/>
    </sch:rule>
</sch:pattern>
