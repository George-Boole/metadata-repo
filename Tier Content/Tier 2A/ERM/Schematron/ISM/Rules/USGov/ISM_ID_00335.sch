<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" xmlns:ism="urn:us:gov:ic:ism" id="ISM-ID-00335" ism:resourceElement="true" ism:createDate="2011-01-27" ism:classification="U" ism:ownerProducer="USA">
    <sch:p class="ruleText" ism:classification="U" ism:ownerProducer="USA">
        [ISM-ID-00335][Error] If ISM_USGOV_RESOURCE and attribute SCIcontrols contains the name token [HCS-O],
        then attribute disseminationControls must contain the name token [OC].
        
        Human Readable: A USA document with HCS-OPERATIONS compartment data must be marked for 
        ORIGINATOR CONTROLLED dissemination.
    </sch:p>
    <sch:p class="codeDesc" ism:classification="U" ism:ownerProducer="USA">
      If the document is an ISM_USGOV_RESOURCE, for each element which
      specifies attribute ism:SCIcontrols with a value containing the token
      [HCS-O], this rule ensures that attribute ism:disseminationControls is
      specified with a value containing the token [OC].
    </sch:p>
    <sch:rule id="ISM-ID-00335-R1" context="*[$ISM_USGOV_RESOURCE                         and util:containsAnyOfTheTokens(@ism:SCIcontrols, ('HCS-O'))]" ism:classification="U" ism:ownerProducer="USA">
        <sch:assert test="util:containsAnyOfTheTokens(@ism:disseminationControls, ('OC'))" flag="error" role="error">
            [ISM-ID-00335][Error] If ISM_USGOV_RESOURCE and attribute SCIcontrols contains the name token [HCS-O],
            then attribute disseminationControls must contain the name token [OC].
            
            Human Readable: A USA document with HCS-OPERATIONS data must be marked for 
            ORIGINATOR CONTROLLED dissemination.
        </sch:assert>
    </sch:rule>
</sch:pattern>