<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="ISM-ID-00149">
  <sch:p class="ruleText">[ISM-ID-00149][Error] If the document is an ISM_USGOV_RESOURCE and:
    1. Any element in the document meets ISM_CONTRIBUTES in the document has the attribute nonICmarkings
       contain [LES-NF] 
      AND 
    2. ISM_RESOURCE_ELEMENT has the attribute classification [U] 
      AND 
    3. ISM_RESOURCE_ELEMENT does not have the attribute dissemination controls [NF] 
       THEN the ISM_RESOURCE_ELEMENT must have nonICmarkings containing [LES-NF]
    
    Human Readable: Unclassified USA documents having LES-NF and not having NF 
    must have LES-NF at the resource level.</sch:p>
  
  <sch:p class="codeDesc"> If the document is an ISM_USGOV_RESOURCE, the current element is the
    ISM_RESOURCE_ELEMENT, some element meeting ISM_CONTRIBUTES specifies attribute ism:nonICmarkings
    with a value containing the token [LES-NF], and the ISM_RESOURCE_ELEMENT does not have
    attribute ism:disseminationControls with a value containing the token [NF]; then this rule 
    ensures that ISM_RESOURCE_ELEMENT specifies attribute ism:nonICmarkings with a value containing 
    the token [LES-NF].</sch:p>

  <sch:rule id="ISM-ID-00149-R1" context="       *[$ISM_USGOV_RESOURCE and generate-id(.) = generate-id($ISM_RESOURCE_ELEMENT)       and $bannerClassification = 'U' and index-of($partNonICmarkings_tok, 'LES-NF') &gt; 0       and not(util:containsAnyOfTheTokens(string-join(@ism:disseminationControls, ' '), ('NF')))]">
    <sch:assert test="util:containsAnyOfTheTokens(@ism:nonICmarkings, ('LES-NF'))" flag="error" role="error">
      [ISM-ID-00149][Error] Unclassified USA documents having LES-NF and not having NF must 
      have LES-NF at the resource level. </sch:assert>
  </sch:rule>

</sch:pattern>