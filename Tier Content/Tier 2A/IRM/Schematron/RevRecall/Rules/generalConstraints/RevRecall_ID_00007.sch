<?xml version="1.0" encoding="UTF-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="RevRecall-ID-00007">
    
    <sch:p xmlns:ism="urn:us:gov:ic:ism" ism:classification="U" ism:ownerProducer="USA" class="ruleText">[RevRecall-ID-00007][Error] For a Trusted Data Object, RevRecall 
        handling assertions must have @tdf:scope with the value "TDO".</sch:p>
    
    <sch:p xmlns:ism="urn:us:gov:ic:ism" ism:classification="U" ism:ownerProducer="USA" class="codeDesc">Given a Revision Recall handling assertion for a TDO --
        context="tdf:HandlingAssertion[child::tdf:HandlingStatement/rr:RevisionRecall]" -- 
        assert that there exists @tdf:scope with the value "TDO" </sch:p>
    
    <sch:rule id="RevRecall-ID-00007-R1" context="tdf:TrustedDataObject/tdf:HandlingAssertion[child::tdf:HandlingStatement/rr:RevisionRecall]">
        <sch:assert test="@tdf:scope = 'TDO'" flag="error" role="error">[RevRecall-ID-00007][Error] For a Trusted Data Object, RevRecall 
            handling assertions must have @tdf:scope with the value "TDO".</sch:assert>
    </sch:rule>
</sch:pattern>