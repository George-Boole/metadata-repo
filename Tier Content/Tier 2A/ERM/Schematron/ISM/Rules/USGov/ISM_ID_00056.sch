<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="ISM-ID-00056">
    <sch:p class="ruleText"> [ISM-ID-00056][Error] If the document is an ISM_USGOV_RESOURCE and
        attribute classification of ISM_RESOURCE_ELEMENT has a value of [U] then no element meeting
        ISM_CONTRIBUTES in the document may have a classification attribute of [C], [S], [TS], or [R]. 
        
        Human Readable: USA UNCLASSIFIED documents can't have portion markings with the
        classification TOP SECRET, SECRET, CONFIDENTIAL, or RESTRICTED data. </sch:p>
    <sch:p class="codeDesc"> If the document is an ISM_USGOV_RESOURCE and attribute
        ism:classification on $ISM_RESOURCE_ELEMENT has a value of [U], this rule ensures that no
        element meeting ISM_CONTRIBUTES has attribute ism:classification with value [C], [S], [TS],
        [R]. </sch:p>
    <sch:rule id="ISM-ID-00056-R1" context="*[$ISM_USGOV_RESOURCE and generate-id(.) = generate-id($ISM_RESOURCE_ELEMENT) and normalize-space(string(@ism:classification)) = 'U']">
        <sch:assert test="                 every $ele in $partTags                     satisfies not(util:containsAnyOfTheTokens($ele/@ism:classification, ('C', 'S', 'TS', 'R')))" flag="error" role="error"> [ISM-ID-00056][Error] If ISM_USGOV_RESOURCE and attribute classification
            of ISM_RESOURCE_ELEMENT has a value of [U] then no element meeting ISM_CONTRIBUTES in
            the document may have a classification attribute of [C], [S], [TS], or [R]. Human
            Readable: USA UNCLASSIFIED documents can't have portion markings with the classification
            TOP SECRET, SECRET, CONFIDENTIAL, or RESTRICTED data. </sch:assert>
    </sch:rule>
</sch:pattern>