<?xml version="1.0" encoding="UTF-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" xmlns:ism="urn:us:gov:ic:ism" id="IC-EDH-ID-00018">
    <sch:p class="ruleText" ism:classification="U" ism:ownerProducer="USA" >[IC-EDH-ID-00018][Error] The ism:ISMCATCESVersion is missing.</sch:p>
    <sch:p class="codeDesc" ism:classification="U" ism:ownerProducer="USA">This rule verifies that the ISMCAT CESVersion exist.</sch:p>
    <sch:rule id="IC-EDH-ID-00018-R1" context="/">
        <sch:assert test="//@ism:ISMCATCESVersion" flag="error" role="error">
            [IC-EDH-ID-00018][Error] The ism:ISMCATCESVersion is missing.
        </sch:assert>
    </sch:rule>
</sch:pattern>
