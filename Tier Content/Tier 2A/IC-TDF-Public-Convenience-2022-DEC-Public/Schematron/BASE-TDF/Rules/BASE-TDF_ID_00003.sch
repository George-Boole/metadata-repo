<?xml version="1.0" encoding="utf-8"?>
<?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:ism="urn:us:gov:ic:ism"
             xmlns:sch="http://purl.oclc.org/dsdl/schematron"
             id="BASE-TDF-ID-00003">
    <sch:p class="ruleText" ism:ownerProducer="USA" ism:classification="U">[BASE-TDF-ID-00003][Error] Attribute @appliesToState is only allowed when TDO statement attribute @isEncrypted equals
           "true". Human Readable: StatementMetadata state applicability can only be defined when an encrypted statement is present.</sch:p>
    <sch:p class="codeDesc" ism:ownerProducer="USA" ism:classification="U">If attribute @appliesToState is defined, this rule ensures that there is a statement element with attribute
           isEncrypted set to true.</sch:p>
    <sch:rule id="BASE-TDF-ID-00003-R1"
             context="tdf:TrustedDataObject/tdf:Assertion[tdf:StatementMetadata/@tdf:appliesToState]">
        <sch:assert test="./*/@tdf:isEncrypted = true()" flag="error" role="error">[BASE-TDF-ID-00003][Error] Attribute @appliesToState is only allowed when TDO statement attribute @isEncrypted equals
                    "true". Human Readable: StatementMetadata state applicability can only be defined when an encrypted statement is
                    present.</sch:assert>
    </sch:rule>
</sch:pattern>
