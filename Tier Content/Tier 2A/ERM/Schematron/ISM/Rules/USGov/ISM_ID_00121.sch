<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="ISM-ID-00121" is-a="ValuesOrderedAccordingToCveWhenContributesToRollup">
  <sch:p class="ruleText">
    [ISM-ID-00121][Error] If ISM_USGOV_RESOURCE and attribute SARIdentifier 
    is specified and:
    1. if values contribute to rollup, each of its values must be ordered in accordance with
    CVEnumISMSAR.xml
    OR
    2. if values do not contribute to rollup, each of its values must be ordered alphabetically
  </sch:p>
  <sch:p class="codeDesc">
    This rule uses an abstract pattern to consolidate logic. It verifies that
    the attribute ism:$attrLocalName has values in the same order as the list
    $cveTermList, which is defined in the main schematron file, ISM_XML.sch.
  </sch:p>
  <sch:param name="attrLocalName" value="SARIdentifier"/>
  <sch:param name="cveTermList" value="$SARIdentifierList"/>
  <sch:param name="contributesToRollup" value="util:contributesToRollup(.)"/>
  <sch:param name="attrValues" value="tokenize(normalize-space(string(@ism:SARIdentifier)), ' ')"/>
  <sch:param name="cveOrderErrorMessage" value="'[ISM-ID-00121][Error] If ISM_USGOV_RESOURCE and attribute SARIdentifier is specified and contributes to rollup, its values must be ordered in accordance with CVEnumISMSAR.xml.'"/>
  <sch:param name="alphabetOrderErrorMessage" value="'[ISM-ID-00121][Error] If ISM_USGOV_RESOURCE and attribute SARIdentifier is specified but does not contribute to rollup, its values must be ordered alphabetically.'"/>
</sch:pattern>