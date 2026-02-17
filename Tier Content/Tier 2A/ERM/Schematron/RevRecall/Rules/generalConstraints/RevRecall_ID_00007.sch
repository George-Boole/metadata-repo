<?xml version="1.0" encoding="UTF-8"?>
<?ICEA pattern?> 
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern id="RevRecall-ID-00007" xmlns:sch="http://purl.oclc.org/dsdl/schematron">
    
    <sch:p class="ruleText">[RevRecall-ID-00007][Error] RevRecall assertions must have @tdf:scope
        with the value "TDO".</sch:p>
    
    <sch:p class="codeDesc">Given a Revision Recall handling assertion --
        context="tdf:HandlingAssertion[child::tdf:HandlingStatement/rr:RevisionRecall]" -- assert
        that there exists @tdf:scope with the value "TDO" </sch:p>
    
    <sch:rule context="tdf:TrustedDataObject/tdf:HandlingAssertion[child::tdf:HandlingStatement/rr:RevisionRecall]">
        <sch:assert test="@tdf:scope = 'TDO'" flag="error">[RevRecall-ID-00007][Error] RevRecall
            assertions must have @tdf:scope with the value "TDO".</sch:assert>
    </sch:rule>
</sch:pattern>
