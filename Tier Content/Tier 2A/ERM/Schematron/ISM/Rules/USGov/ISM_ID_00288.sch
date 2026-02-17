<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="ISM-ID-00288">
	  <sch:p class="ruleText">
		[ISM-ID-00288][Error] All noticeReason attributes must be a string with less than 2048 characters. 
	</sch:p>
	  <sch:p class="codeDesc">
	  	For all elements which contain an noticeReason attribute, this rule ensures that the noticeReason value is a string with less
		than 2048 characters.   
	</sch:p>
	  <sch:rule id="ISM-ID-00288-R1" context="*[@ism:noticeReason]">
		    <sch:assert test="string-length(@ism:noticeReason) &lt;= 2048" flag="error" role="error">
			[ISM-ID-00288][Error] All noticeReason attributes must be a string with less than 2048 characters. 
		</sch:assert>
	  </sch:rule>
</sch:pattern>