<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="ISM-ID-00035" is-a="ValuesOrderedAccordingToCveWhenContributesToRollupACCM">
  <sch:p class="ruleText">
    [ISM-ID-00035][Error] If ISM_USGOV_RESOURCE and attribute nonICmarkings is 
    specified and:
    1. if values contribute to rollup, each of its values must be ordered in accordance with
    CVEnumISMNonIC.xml
    OR
    2. if values do not contribute to rollup
    a. non-ACCM values must be ordered in accordance with CVEnumISMNonIC.xml
    b. ACCM values must be in alphabetical order.
  </sch:p>
  <sch:p class="codeDesc">
    This rule uses an abstract pattern to consolidate logic. It verifies that
    the attribute ism:$attrLocalName has values in the same order as the list
    $cveTermList, which is defined in the main schematron file, ISM_XML.sch.
  </sch:p>
  <sch:param name="attrLocalName" value="nonICmarkings"/>
  <sch:param name="cveTermList" value="$nonICmarkingsList"/>
  <sch:param name="contributesToRollup" value="util:contributesToRollup(.)"/>
  <sch:param name="attrValues" value="tokenize(normalize-space(string(@ism:nonICmarkings)), ' ')"/>
  <sch:param name="nonACCMAttrValuesTok" value="tokenize(normalize-space(string(util:getStringFromSequenceWithoutRegexValues(tokenize(normalize-space(string(@ism:nonICmarkings)), ' '), $ACCMRegex))), ' ')"/>
  <sch:param name="nonACCMCveTermListTok" value="tokenize(normalize-space(string(util:getStringFromSequenceWithoutRegexValues($nonICmarkingsList, $ACCMRegex))), ' ')"/>
  <sch:param name="ACCMAttrValuesTok" value="tokenize(normalize-space(string(util:getStringFromSequenceWithOnlyRegexValues(tokenize(normalize-space(string(@ism:nonICmarkings)), ' '), $ACCMRegex))), ' ')"/>
  <sch:param name="includedInRollUpErrorMessage" value="'[ISM-ID-00035][Error] If ISM_USGOV_RESOURCE and attribute nonICmarkings is specified and contributes to rollup, its values must be ordered in accordance with CVEnumISMNonIC.xml.'"/>
  <sch:param name="excludedFromRollUpNonACCMErrorMessage" value="'[ISM-ID-00035][Error] If ISM_USGOV_RESOURCE and attribute nonICmarkings is specified but does not contribute to rollup, its non-ACCM values must be ordered in accordance with CVEnumISMNonIC.xml.'"/>
  <sch:param name="excludedFromRollUpACCMErrorMessage" value="'[ISM-ID-00035][Error] If ISM_USGOV_RESOURCE and attribute nonICmarkings is specified but does not contribute to rollup, its ACCM values must be ordered alphabetically.'"/>
  <sch:param name="excludedFromRollUpACCMRelativeLocationErrorMessage" value="'[ISM-ID-00035][Error] If ISM_USGOV_RESOURCE and attribute nonICmarkings is specified but does not contribute to rollup, its ACCM values should be in the correct relative order to the non-ACCM values'"/>  
</sch:pattern>