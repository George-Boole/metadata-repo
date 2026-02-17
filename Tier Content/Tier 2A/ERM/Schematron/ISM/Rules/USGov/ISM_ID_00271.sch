<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="ISM-ID-00271">
	  <sch:p class="ruleText">
		[ISM-ID-00271][Error] All classifiedBy attributes must be a string with less than 1024 characters. 
	</sch:p>
	  <sch:p class="codeDesc">
	  	For all elements which contain an classifiedBy attribute, this rule ensures that the classifiedBy value is a string with less
		than 1024 characters.   
	</sch:p>
	  <sch:rule id="ISM-ID-00271-R1" context="*[@ism:classifiedBy]">
		    <sch:assert test="string-length(@ism:classifiedBy) &lt;= 1024" flag="error" role="error">
			[ISM-ID-00271][Error] All classifiedBy attributes must be a string with less than 1024 characters. 
		</sch:assert>
	  </sch:rule>
</sch:pattern>