<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="ISM-ID-00108" is-a="NonCompilationDocumentRollup">
    <sch:p class="ruleText">
        [ISM-ID-00108][Error] If ISM_USGOV_RESOURCE and attribute classification 
        of ISM_RESOURCE_ELEMENT has a value of [TS] and attribute compilationReason does not have a value then at least 
        one element meeting ISM_CONTRIBUTES in the document must have a classification attribute of [TS]. 
        
        Human Readable: USA TS documents not using compilation must have TS data.
    </sch:p>
    <sch:p class="codeDesc">
      This rule uses an abstract pattern to consolidate logic. If the document
      is an ISM_USGOV_RESOURCE and attribute $attrLocalName of ISM_RESOURCE_ELEMENT 
      has a value of [$value] and attribute ism:compilationReason does not have a 
      value, this rule ensures that at least one element meeting ISM_CONTRIBUTES 
      specifies attribute $attrLocalName with a value of [$value].
    </sch:p>
  <sch:param name="attrLocalName" value="classification"/>
  <sch:param name="value" value="TS"/>
  <sch:param name="errorMessage" value="'[ISM-ID-00108][Error] USA TS documents not using compilation must have TS data.'"/>
</sch:pattern>