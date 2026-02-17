<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="ISM-ID-00352" is-a="NtkHasCorrespondingData">

   <sch:p class="ruleText">[ISM-ID-00352][Error] Banner or portion that contributes to roll-up must contain [PR] if
      PROPIN NTK metadata exists.</sch:p>

   <sch:p class="codeDesc">Invokes abstract rule NtkHasCorrespondingData.</sch:p>

   <sch:param name="ruleId" value="'ISM-ID-00352'"/>
   <sch:param name="policyName" value="'PROPIN'"/>
   <sch:param name="uriPrefix" value="'urn:us:gov:ic:aces:ntk:propin:'"/>
   <sch:param name="attr" value="'disseminationControls'"/>
   <sch:param name="dataType" value="'PR'"/>
   <sch:param name="dataTokenList" value="$partDisseminationControls_tok"/>
   <sch:param name="bannerTokenList" value="$bannerDisseminationControls_tok"/>
</sch:pattern>