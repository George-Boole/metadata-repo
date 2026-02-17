<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="ISM-ID-00378">
	  <sch:p class="ruleText">
		[ISM-ID-00378][Error] All joint attributes must be of type Boolean. 
	</sch:p>
	  <sch:p class="codeDesc">
	  	For all elements which contain a joint attribute, this rule ensures that the joint value matches the pattern
		defined for type Boolean. 
	</sch:p>
	  <sch:rule id="ISM-ID-00378-R1" context="*[@ism:joint]">
		    <sch:assert test="util:meetsType(@ism:joint, $BooleanPattern)" flag="error" role="error">
			[ISM-ID-00378][Error] All joint attributes values must be of type Boolean. 
		</sch:assert>
	  </sch:rule>
</sch:pattern>