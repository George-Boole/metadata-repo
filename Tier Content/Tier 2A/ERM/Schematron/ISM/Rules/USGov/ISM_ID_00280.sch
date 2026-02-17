<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="ISM-ID-00280">
	  <sch:p class="ruleText">
		[ISM-ID-00280][Error] All displayOnlyTo attributes must be of type NmTokens. 
	</sch:p>
	  <sch:p class="codeDesc">
	  	For all elements which contain an displayOnlyTo attribute, this rule ensures that the displayOnlyTo value matches the pattern
		defined for type NmTokens. 
	</sch:p>
	  <sch:rule id="ISM-ID-00280-R1" context="*[@ism:displayOnlyTo]">
		    <sch:assert test="util:meetsType(@ism:displayOnlyTo, $NmTokensPattern)" flag="error" role="error">
			[ISM-ID-00280][Error] All displayOnlyTo attributes values must be of type NmTokens. 
		</sch:assert>
	  </sch:rule>
</sch:pattern>