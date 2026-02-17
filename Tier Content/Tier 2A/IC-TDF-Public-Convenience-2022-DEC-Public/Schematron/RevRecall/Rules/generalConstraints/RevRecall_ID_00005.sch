<?xml version="1.0" encoding="UTF-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="RevRecall-ID-00005">
    
    <sch:p xmlns:ism="urn:us:gov:ic:ism" ism:classification="U" ism:ownerProducer="USA" class="ruleText">[RevRecall-ID-00005][Error] A RevRecall assertion must not contain an
        ActionInstruction element unless @action="MANUAL_INSTRUCTION".</sch:p>
    
    <sch:p xmlns:ism="urn:us:gov:ic:ism" ism:classification="U" ism:ownerProducer="USA" class="codeDesc">A RevRecall assertion must not contain an ActionInstruction element
        unless @action="MANUAL_INSTRUCTION".</sch:p>
    
    <sch:rule id="RevRecall-ID-00005-R1" context="rr:ActionInstruction">
        <sch:assert test="parent::node()[contains(@rr:action, 'MANUAL_INSTRUCTION')]" flag="error" role="error">[RevRecall-ID-00005][Error] A RevRecall assertion must not contain an ActionInstruction
            element unless @action="MANUAL_INSTRUCTION".</sch:assert>
    </sch:rule>
</sch:pattern>