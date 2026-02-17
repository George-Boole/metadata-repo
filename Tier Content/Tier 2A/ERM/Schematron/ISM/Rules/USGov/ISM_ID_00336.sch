<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" xmlns:ism="urn:us:gov:ic:ism" id="ISM-ID-00336" ism:resourceElement="true" ism:createDate="2011-01-27" ism:classification="U" ism:ownerProducer="USA">
    <sch:p class="ruleText" ism:classification="U" ism:ownerProducer="USA">
        [ISM-ID-00336][Error] If ISM_USGOV_RESOURCE and attribute SCIcontrols contains a token matching [HCS-P-XXXXXX], 
        where X is represented by the regular expression character class [A-Z0-9]{1,6}, then attribute
        disseminationControls must contain the name token [OC].
        
        Human Readable: A USA document with HCS-PRODUCT sub-compartment data must be marked for 
        ORIGINATOR CONTROLLED dissemination.
    </sch:p>
    <sch:p class="codeDesc" ism:classification="U" ism:ownerProducer="USA">
      If the document is an ISM_USGOV_RESOURCE, for each element which
      specifies attribute ism:SCIcontrols with a value containing a token matching
      [HCS-P-XXXXXX], where X is represented by the regular expression character
      class [A-Z0-9]{1,6}, this rule ensures that attribute ism:disseminationControls is
      specified with a value containing the token [OC].
    </sch:p>
    <sch:rule id="ISM-ID-00336-R1" context="*[$ISM_USGOV_RESOURCE                         and util:containsAnyTokenMatching(@ism:SCIcontrols, ('^HCS-P-[A-Z0-9]{1,6}$'))]" ism:classification="U" ism:ownerProducer="USA">
        <sch:assert test="util:containsAnyOfTheTokens(@ism:disseminationControls, ('OC'))" flag="error" role="error">
            [ISM-ID-00336][Error] If ISM_USGOV_RESOURCE and attribute SCIcontrols contains the name token [HCS-P-XXXXXX], 
            where X is represented by the regular expression character class [A-Z0-9]{1,6},
            then attribute disseminationControls must contain the name token [OC].
            
            Human Readable: A USA document with HCS-PRODUCT sub-compartments must be marked for 
            ORIGINATOR CONTROLLED dissemination.
        </sch:assert>
    </sch:rule>
</sch:pattern>