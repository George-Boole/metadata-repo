<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="ISM-ID-00058">
    <sch:p class="ruleText">
        [ISM-ID-00058][Error] If ISM_USGOV_RESOURCE and attribute classification of ISM_RESOURCE_ELEMENT 
        has a value of [C] then no element meeting ISM_CONTRIBUTES_USA in the document may have a classification attribute of [S] or [TS].
        
        Human Readable: USA CONFIDENTIAL documents can't have TOP SECRET or SECRET data.
    </sch:p>
    <sch:p class="codeDesc">
      If the document is an ISM_USGOV_RESOURCE and attribute ism:classification
      on $ISM_RESOURCE_ELEMENT has a value of [C], this rule ensures that
      no element meeting ISM_CONTRIBUTES_USA has attribute ism:classification with
      value [S], [TS]. 
    </sch:p>
    <sch:rule id="ISM-ID-00058-R1" context="*[$ISM_USGOV_RESOURCE                         and generate-id(.) = generate-id($ISM_RESOURCE_ELEMENT)                         and normalize-space(string(@ism:classification))='C']">
      <sch:assert test="every $ele in $partTags satisfies                 not(util:containsAnyOfTheTokens($ele/@ism:classification, ('S', 'TS')))" flag="error" role="error">
            [ISM-ID-00058][Error] USA CONFIDENTIAL documents can't have TOP SECRET or SECRET data.
        </sch:assert>
    </sch:rule>
</sch:pattern>