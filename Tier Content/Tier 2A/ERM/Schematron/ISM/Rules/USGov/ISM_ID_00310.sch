<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="ISM-ID-00310">
  <sch:p class="ruleText">
    [ISM-ID-00310][Error] If ISM_USGOV_RESOURCE and attribute SCIcontrols contains the name token [SI-EU],
    then it must also contain the name token [SI].
    
    Human Readable: A USA document that contains ENDSEAL (SI) -ECRU compartment data must also specify that 
    it contains =SI data. 
  </sch:p>
  <sch:p class="codeDesc">
    If the document is an ISM_USGOV_RESOURCE, for each element which
    specifies attribute ism:SCIcontrols with a value containing the token
    [SI-EU] this rule ensures that attribute ism:SCIcontrols is 
    specified with a value containing the token [SI].
  </sch:p>
  <sch:rule id="ISM-ID-00310-R1" context="*[$ISM_USGOV_RESOURCE     and util:containsAnyOfTheTokens(@ism:SCIcontrols, ('SI-EU'))]">
      <sch:assert test="util:containsAnyOfTheTokens(@ism:SCIcontrols, ('SI'))" flag="error" role="error">
      [ISM-ID-00310][Error] If ISM_USGOV_RESOURCE and attribute SCIcontrols contains the name token [SI-EU],
      then it must also contain the name token [SI].
      
      Human Readable: A USA document that contains ENDSEAL (SI) -ECRU compartment data must also specify that 
      it contains SI data. 
    </sch:assert>
  </sch:rule>
</sch:pattern>