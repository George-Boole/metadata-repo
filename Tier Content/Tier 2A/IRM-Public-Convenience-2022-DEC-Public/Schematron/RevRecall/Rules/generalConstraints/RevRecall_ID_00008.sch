<?xml version="1.0" encoding="UTF-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="RevRecall-ID-00008">
    
    <sch:p xmlns:ism="urn:us:gov:ic:ism" ism:classification="U" ism:ownerProducer="USA" class="ruleText">[RevRecall-ID-00008][Error] For a Trusted Data Collection, RevRecall
        handling assertions must have @tdf:scope with the value "TDC".</sch:p>
    
    <sch:p xmlns:ism="urn:us:gov:ic:ism" ism:classification="U" ism:ownerProducer="USA" class="codeDesc">Given a Revision Recall handling assertion for a TDC --
        context="tdf:HandlingAssertion[child::tdf:HandlingStatement/rr:RevisionRecall]" -- 
        assert that there exists @tdf:scope with the value "TDC" </sch:p>
    
    <sch:rule id="RevRecall-ID-00008-R1" context="tdf:TrustedDataCollection/tdf:HandlingAssertion[child::tdf:HandlingStatement/rr:RevisionRecall]">
        <sch:assert test="@tdf:scope = 'TDC'" flag="error" role="error">[RevRecall-ID-00008][Error] For a Trusted Data Collection, RevRecall
            handling assertions must have @tdf:scope with the value "TDC".</sch:assert>
    </sch:rule>
</sch:pattern>