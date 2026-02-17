<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="ISM-ID-00290">
	  <sch:p class="ruleText">
		[ISM-ID-00290][Error] All externalNotice attributes must be of type Boolean. 
	</sch:p>
	  <sch:p class="codeDesc">
	  	For all elements which contain an externalNotice attribute, this rule ensures that the externalNotice value matches the pattern
		defined for type Boolean. 
	</sch:p>
	  <sch:rule id="ISM-ID-00290-R1" context="*[@ism:externalNotice]">
		    <sch:assert test="util:meetsType(@ism:externalNotice, $BooleanPattern)" flag="error" role="error">
			[ISM-ID-00290][Error] All externalNotice attributes values must be of type Boolean. 
		</sch:assert>
	  </sch:rule>
</sch:pattern>