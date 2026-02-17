<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" xmlns:ism="urn:us:gov:ic:ism" id="ISM-ID-00333" ism:resourceElement="true" ism:createDate="2011-01-27" ism:classification="U" ism:ownerProducer="USA">
  <sch:p class="ruleText" ism:classification="U" ism:ownerProducer="USA"> [ISM-ID-00333][Error] If
    ISM_USGOV_RESOURCE and attribute SCIcontrols contains a token matching [HCS-X], where X is
    represented by the regular expression character class [A-Z], then it must also contain the name
    token [HCS]. 
    
    Human Readable: A USA document with HCS compartment data must also specify that it
    contains HCS data. </sch:p>
  <sch:p class="codeDesc" ism:classification="U" ism:ownerProducer="USA"> If the document is an
    ISM_USGOV_RESOURCE, for each element which specifies attribute ism:SCIcontrols with a value
    containing a token matching [HCS-X], where X is represented by the regular expression character
    class [A-Z], this rule ensures that attribute ism:SCIcontrols is specified with a value
    containing the token [HCS]. </sch:p>
  <sch:rule id="ISM-ID-00333-R1" context="*[$ISM_USGOV_RESOURCE and util:containsAnyTokenMatching(@ism:SCIcontrols, ('^HCS-[A-Z]$'))]" ism:classification="U" ism:ownerProducer="USA">
    <sch:assert test="util:containsAnyOfTheTokens(@ism:SCIcontrols, ('HCS'))" flag="error" role="error">
      [ISM-ID-00333][Error] If ISM_USGOV_RESOURCE and attribute SCIcontrols contains a token
      matching [HCS-X], where X is represented by the regular expression character class [A-Z], then
      it must also contain the name token [HCS]. Human Readable: A USA document with HCS compartment
      data must also specify that it contains HCS data. </sch:assert>
  </sch:rule>
</sch:pattern>