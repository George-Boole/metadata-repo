<?xml version="1.0" encoding="UTF-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="RevRecall-ID-00006">
    
    <sch:p xmlns:ism="urn:us:gov:ic:ism" ism:classification="U" ism:ownerProducer="USA" class="ruleText">[RevRecall-ID-00006][Error] TDF elements must have no more than one Revision Recall assertion.</sch:p>
    
    <sch:p xmlns:ism="urn:us:gov:ic:ism" ism:classification="U" ism:ownerProducer="USA" class="codeDesc">Verify that the number of Revision Recall assertions is not more than 1.</sch:p>
    
    <sch:rule id="RevRecall-ID-00006-R1" context="tdf:*[count(tdf:HandlingAssertion/tdf:HandlingStatement/rr:RevisionRecall) &gt; 1]">
        
        <sch:assert test="false()" flag="error" role="error">[RevRecall-ID-00006][Error] TDF elements must have no more than one Revision Recall assertion.</sch:assert>
    </sch:rule>
    
</sch:pattern>