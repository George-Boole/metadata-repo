<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" xmlns:ism="urn:us:gov:ic:ism" id="ISM-ID-00330" ism:DESVersion="201412" ism:resourceElement="true" ism:createDate="2011-01-27" ism:classification="U" ism:ownerProducer="USA">
    <sch:p class="ruleText" ism:classification="U" ism:ownerProducer="USA">
        [ISM-ID-00330][Error] If ISM_USGOV_RESOURCE and attribute SCIcontrols contains the name token [HCS-P], then attribute 
        classification must have a value of [TS], or [S].
        
        Human Readable: A USA document with HCS-PRODUCT compartment data must be classified SECRET or TOP SECRET.
    </sch:p>
    <sch:p class="codeDesc" ism:classification="U" ism:ownerProducer="USA">
        If the document is an ISM_USGOV_RESOURCE, for each element which
        specifies attribute ism:SCIcontrols with a value containing the token
        [HCS-P] ensure that attribute ism:classification is 
        specified with a value containing the token [TS], or [S].
    </sch:p>
    <sch:rule id="ISM-ID-00330-R1" context="*[$ISM_USGOV_RESOURCE                       and util:containsAnyOfTheTokens(@ism:SCIcontrols, ('HCS-P'))]" ism:classification="U" ism:ownerProducer="USA">
        <sch:assert test="util:containsAnyOfTheTokens(@ism:classification, ('TS', 'S'))" flag="error" role="error">
            [ISM-ID-00330][Error] If ISM_USGOV_RESOURCE and attribute SCIcontrols contains the name token [HCS-P], then attribute 
            classification must have a value of [TS], or [S].
            
            Human Readable: A USA document with HCS-PRODUCT compartment data must be classified SECRET or TOP SECRET.
        </sch:assert>
    </sch:rule>
</sch:pattern>