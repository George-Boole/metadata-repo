<?xml version="1.0" encoding="UTF-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="RevRecall-ID-00009">
    
    <sch:p xmlns:ism="urn:us:gov:ic:ism" ism:classification="U" ism:ownerProducer="USA" class="ruleText">[RevRecall-ID-00009][Error] Revision Recall assertions must be Handling
        Assertions.</sch:p>
    
    <sch:p xmlns:ism="urn:us:gov:ic:ism" ism:classification="U" ism:ownerProducer="USA" class="codeDesc">The RevisionRecall element must be the grandchild of a HandlingAssertion
        element. This rule is tested from the RevisionRecall context to ensure that non-compliant
        assertions are flagged.</sch:p>
    
    <sch:rule id="RevRecall-ID-00009-R1" context="rr:RevisionRecall">
        <sch:assert test="../parent::tdf:HandlingAssertion" flag="error" role="error">[RevRecall-ID-00009][Error]
            Revision Recall assertions must be Handling Assertions.</sch:assert>
    </sch:rule>
</sch:pattern>