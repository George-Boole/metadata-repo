<?xml version="1.0" encoding="UTF-8"?>
<?ICEA pattern?> 
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern id="RevRecall-ID-00006" xmlns:sch="http://purl.oclc.org/dsdl/schematron">
    
    <sch:p class="ruleText">[RevRecall-ID-00006][Error] Revision Recall assertions must not have
        sibling Revision Recall assertions.</sch:p>
    
    <sch:p class="codeDesc">Given the context of a RevRecall assertion that has a sibling RevRecall
        assertion, fail. Failing in this context generates errors for a TDO/TDC with multiple
        RevRecall assertions. The context explicitly restricts this rule to the TDF skeleton
        and does not look in TDF extension points which includes structured payloads and structured
        content of regular assertions. Currently, only respecting RevRecall HandlingAssertions 
        in the main TDF structure is mandatory.</sch:p>
    
    <sch:p class="codeDesc">NOTE: The explicit path to rr:RevisionRecall is used in the predicates
        instead of descendent::rr:RevisionRecall to limit the search. Therefore, RevRecall
        assertions must satisfy tdf:HandlingAssertion/tdf:HandlingStatement/rr:RevisionRecall in order to
        trip this rule.</sch:p>
    
    <sch:rule
        context="tdf:HandlingAssertion[tdf:HandlingStatement/rr:RevisionRecall and
        (
        preceding-sibling::tdf:HandlingAssertion[tdf:HandlingStatement/rr:RevisionRecall] or
        following-sibling::tdf:HandlingAssertion[tdf:HandlingStatement/rr:RevisionRecall]
        )]">
        
        <sch:assert test="false()" flag="error">[RevRecall-ID-00006][Error] Revision Recall
            assertions must not have sibling Revision Recall assertions.</sch:assert>
    </sch:rule>
</sch:pattern>
