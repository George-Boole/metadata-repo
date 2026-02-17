<?xml version="1.0" encoding="UTF-8"?>
<?ICEA pattern?> 
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern id="RevRecall-ID-00009" xmlns:sch="http://purl.oclc.org/dsdl/schematron">
    
    <sch:p class="ruleText">[RevRecall-ID-00009][Error] Revision Recall assertions must be Handling
        Assertions.</sch:p>
    
    <sch:p class="codeDesc">The RevisionRecall element must be the grandchild of a HandlingAssertion
        element. This rule is tested from the RevisionRecall context to ensure that non-compliant
        assertions are flagged.</sch:p>
    
    <sch:rule context="rr:RevisionRecall">
        <sch:assert test="../parent::tdf:HandlingAssertion" flag="error">[RevRecall-ID-00009][Error]
            Revision Recall assertions must be Handling Assertions.</sch:assert>
    </sch:rule>
</sch:pattern>
