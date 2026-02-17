<?xml version="1.0" encoding="UTF-8"?><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="ISM-ID-00326">

   <sch:p class="ruleText">[ISM-ID-00326][Error] ORCON information (i.e. @ism:disseminationControls of the resource node
      contains [OC]) requires ORCON profile NTK metadata.</sch:p>

   <sch:p class="codeDesc">If the document is an ISM_USGOV_RESOURCE and the resource node's ism:disseminationControls
      attribute contains [OC], the document must have OC profile NTK metadata. That is, there must be an NTK assertion
      with an ntk:AccessPolicy value of ‘urn:us:gov:ic:aces:ntk:oc’.</sch:p>

   <sch:rule id="ISM-ID-00326-R1" context="*[$ISM_USGOV_RESOURCE              and generate-id(.) = generate-id($ISM_RESOURCE_ELEMENT)         and util:containsAnyOfTheTokens(@ism:disseminationControls, ('OC'))]">
      <sch:assert test="/*//ntk:AccessPolicy[.='urn:us:gov:ic:aces:ntk:oc']" flag="error" role="error">[ISM-ID-00326][Error] ORCON
         information (i.e. @ism:disseminationControls of the resource node contains [OC]) requires ORCON profile NTK
         metadata.</sch:assert>
   </sch:rule>
</sch:pattern>