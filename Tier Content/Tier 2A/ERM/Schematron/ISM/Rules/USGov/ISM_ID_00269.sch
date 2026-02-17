<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="ISM-ID-00269">
	  <sch:p class="ruleText">
		[ISM-ID-00269][Error] All classification attributes must be of type NmToken. 
	</sch:p>
	  <sch:p class="codeDesc">
	  	For all elements which contain an classification attribute, this rule ensures that the classification value matches the pattern
		defined for type NmTokens.  
	</sch:p>
	  <sch:rule id="ISM-ID-00269-R1" context="*[@ism:classification]">
		    <sch:assert test="util:meetsType(@ism:classification, $NmTokenPattern)" flag="error" role="error">
			[ISM-ID-00269][Error] All classification attributes values must be of type NmToken. 
		</sch:assert>
	  </sch:rule>
</sch:pattern>