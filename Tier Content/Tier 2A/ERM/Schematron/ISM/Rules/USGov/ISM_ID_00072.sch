<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="ISM-ID-00072" is-a="AttributeContributesToRollup">
  <sch:p class="ruleText">
    [ISM-ID-00072][Error] If ISM_USGOV_RESOURCE and any element meeting ISM_CONTRIBUTES 
    in the document have the attribute atomicEnergyMarkings containing [RD] then the ISM_RESOURCE_ELEMENT must have 
    atomicEnergyMarkings containing [RD].
    
    Human Readable: USA documents having Restricted Data (RD) must have RD at the resource level.
  </sch:p>
  <sch:p class="codeDesc">
    This rule uses an abstract pattern to consolidate logic. If the document
    is an ISM_USGOV_RESOURCE and an element meeting ISM_CONTRIBUTES
    specifies $attrLocalName with a value containing the token $value, this rule ensures that the ISM_RESOURCE_ELEMENT specifies the attribute
    $attrLocalName with a value containing the token $value.
  </sch:p>
  <sch:param name="attrLocalName" value="atomicEnergyMarkings"/>
  <sch:param name="value" value="RD"/>
  <sch:param name="errorMessage" value="'[ISM-ID-00072][Error] USA documents having Restricted Data (RD) must have RD at the resource level.'"/>
</sch:pattern>