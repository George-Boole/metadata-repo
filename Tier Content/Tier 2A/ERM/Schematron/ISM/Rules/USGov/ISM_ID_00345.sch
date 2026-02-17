<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="ISM-ID-00345">
	  <sch:p class="ruleText">
	  	
	  	[ISM-ID-00345][Error] If ISM_USGOV_RESOURCE and attribute disseminationControls contains the value [EYES], 
	  	releasableTo must only contain the token values of [USA], [AUS], [CAN], [GBR] or [NZL]. 
	  </sch:p>
	  <sch:p class="codeDesc">
	  	If ISM_USGOV_RESOURCE, for each element which specifies the attribute disseminationControls with the value of [EYES], this rule ensures that attribute
	  	releasableTo is specified with the token values of [USA], [AUS], [CAN], [GBR] or [NZL].	  
	  </sch:p>
	  <sch:rule id="ISM-ID-00345-R1" context="*[$ISM_USGOV_RESOURCE                         and util:containsAnyOfTheTokens(@ism:disseminationControls, ('EYES'))]">
		<sch:assert test="util:containsOnlyTheTokens(@ism:releasableTo, ('USA', 'AUS','CAN','GBR', 'NZL'))" flag="error" role="error">
			[ISM-ID-00345][Error] If attribute disseminationControls contains the value [EYES], 
			the attribute releasableTo must only contain the values of [USA], [AUS], [CAN], [GBR] or [NZL].
        </sch:assert>
      </sch:rule>
</sch:pattern>