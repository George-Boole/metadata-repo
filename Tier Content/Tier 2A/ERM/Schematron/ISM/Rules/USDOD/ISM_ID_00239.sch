<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="ISM-ID-00239">
	  <sch:p class="ruleText">
		[ISM-ID-00239][Error] If ISM_USDOD_RESOURCE and attribute noticeType of
		ISM_RESOURCE_ELEMENT contains the token [DoD-Dist-A], then any element 
		which contributes to rollup should not have an attribute
		@disseminationControls present.
		
		Human Readable: Distribution statement A (Public Release) is incompatible 
		with @disseminationControls present for contributing portions.
	</sch:p>
	  <sch:p class="codeDesc">
		If the document is an ISM_USDOD_RESOURCE and the attribute
		noticeType of ISM_RESOURCE_ELEMENT contains the token [DoD-Dist-A], for
		each element which specifies attribute ism:disseminationControls 
		this rule ensures that attribute ism:disseminationControls is not present.
	</sch:p>
	  <sch:rule id="ISM-ID-00239-R1" context="*[$ISM_USDOD_RESOURCE  and util:containsAnyOfTheTokens($ISM_RESOURCE_ELEMENT/@ism:noticeType, ('DoD-Dist-A'))      and not (@ism:excludeFromRollup=true())]">
		    <sch:assert test="not(@ism:disseminationControls)" flag="error" role="error"> 
			[ISM-ID-00239][Error] If ISM_USDOD_RESOURCE and attribute noticeType of
			ISM_RESOURCE_ELEMENT contains the token [DoD-Dist-A], then any element 
			which contributes to rollup should not have an attribute
			@disseminationControls present.
			
			Human Readable: Distribution statement A (Public Release) is incompatible 
			with @disseminationControls present for contributing portions.
		</sch:assert>
	  </sch:rule>
</sch:pattern>