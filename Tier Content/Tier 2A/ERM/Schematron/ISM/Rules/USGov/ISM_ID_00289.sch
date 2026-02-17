<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="ISM-ID-00289">
	  <sch:p class="ruleText">
		[ISM-ID-00289][Error] All noticeType attributes must be of type NmTokens. 
	</sch:p>
	  <sch:p class="codeDesc">
	  	For all elements which contain an noticeType attribute, this rule ensures that the noticeType value matches the pattern
		defined for type NmTokens. 
	</sch:p>
	  <sch:rule id="ISM-ID-00289-R1" context="*[@ism:noticeType]">
		    <sch:assert test="util:meetsType(@ism:noticeType, $NmTokensPattern)" flag="error" role="error">
			[ISM-ID-00289][Error] All noticeType attributes values must be of type NmTokens. 
		</sch:assert>
	  </sch:rule>
</sch:pattern>