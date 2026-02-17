<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="ISM-ID-00150">
  <sch:p class="ruleText">
    [ISM-ID-00150][Error] If ISM_USGOV_RESOURCE and:
    1. Any element, other than ISM_RESOURCE_ELEMENT, meeting ISM_CONTRIBUTES in the document has the attribute nonICmarkings containing [LES]
    AND
    2. No element meeting ISM_CONTRIBUTES in the document has the attribute noticeType containing [LES]
    
    Human Readable: USA documents containing LES data must also have an LES notice.
  </sch:p>
  <sch:p class="codeDesc">
    If the document is an ISM_USGOV_RESOURCE, for each element which
    is not the ISM_RESOURCE_ELEMENT and meets ISM_CONTRIBUTES and specifies 
    attribute ism:nonICmarkings with a value containing the token [LES], this rule ensures that an element meeting ISM_CONTRIBUTES specifies attribute
    ism:noticeType with a value containing the token [LES].
  </sch:p>
  <sch:rule id="ISM-ID-00150-R1" context="*[$ISM_USGOV_RESOURCE                       and not(generate-id(.) = generate-id($ISM_RESOURCE_ELEMENT))                       and util:containsAnyOfTheTokens(@ism:nonICmarkings, ('LES'))]">
      <sch:assert test="some $elem in $partTags satisfies          ($elem[@ism:noticeType]          and util:containsAnyOfTheTokens($elem/@ism:noticeType, ('LES'))          and not ($elem/@ism:externalNotice=true()))" flag="error" role="error">
      [ISM-ID-00150][Error] If ISM_USGOV_RESOURCE and:
      1. Any element, other than ISM_RESOURCE_ELEMENT, meeting ISM_CONTRIBUTES in the document has the attribute nonICmarkings containing [LES]
      AND
      2. No element meeting ISM_CONTRIBUTES in the document has the attribute noticeType containing [LES]
      
      Human Readable: USA documents containing LES data must also have an LES notice.
    </sch:assert>
  </sch:rule>
</sch:pattern>