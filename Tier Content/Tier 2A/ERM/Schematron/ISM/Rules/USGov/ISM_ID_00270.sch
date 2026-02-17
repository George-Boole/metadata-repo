<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="ISM-ID-00270">
	
	<sch:p class="ruleText"> [ISM-ID-00270][Error] All classificationReason attributes must be a
		string with 4096 characters or less. </sch:p>
	<sch:p class="codeDesc"> For all elements which contain an classificationReason attribute, this
		rule ensures that the classificationReason value is a string with 4096 characters or less. </sch:p>
	<sch:rule id="ISM-ID-00270-R1" context="*[@ism:classificationReason]">
		<sch:assert test="string-length(@ism:classificationReason) &lt;= 4096" flag="error" role="error">
			[ISM-ID-00270][Error] All classificationReason attributes must be a string with 4096
			characters or less. </sch:assert>
	</sch:rule>
</sch:pattern>