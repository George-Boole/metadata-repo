<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="ISM-ID-00284">
	  <sch:p class="ruleText">
		[ISM-ID-00284][Error] All FGIsourceProtected attributes must be of type NmTokens. 
	</sch:p>
	  <sch:p class="codeDesc">
	  	For all elements which contain an FGIsourceProtected attribute, this rule ensures that the FGIsourceProtected value matches the pattern
		defined for type NmTokens. 
	</sch:p>
	  <sch:rule id="ISM-ID-00284-R1" context="*[@ism:FGIsourceProtected]">
		    <sch:assert test="util:meetsType(@ism:FGIsourceProtected, $NmTokensPattern)" flag="error" role="error">
			[ISM-ID-00284][Error] All FGIsourceProtected attributes values must be of type NmTokens. 
		</sch:assert>
	  </sch:rule>
</sch:pattern>