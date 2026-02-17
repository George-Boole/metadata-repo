<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="ISM-ID-00202" is-a="AttributeValueDeprecatedWarning">
    <sch:p class="ruleText">
    	[ISM-ID-00202][Warning] Attribute SARIdentifier should not contain any
    	values which will be deprecated.
    </sch:p>
	  <sch:p class="codeDesc">
	  	For each element which specifies attribute ism:SARIdentifier, this rule ensures that the value of ism:SARIdentifier has not been deprecated.
		This is indicated in the CVE file by an attribute (@deprecated) 
		on the term element for that SARIdentifier value. 
		If the date value in @deprecated is in the future, then a 
		deprecation warning will be given. If the date value has 
		already occurred, then a deprecation error will be given. 
	</sch:p>
	
	  <sch:param name="ruleId" value="'ISM-ID-00202'"/>
	  <sch:param name="context" value="*[@ism:SARIdentifier]"/>
	  <sch:param name="attrName" value="SARIdentifier"/>
	  <sch:param name="cveName" value="CVEnumISMSAR"/>
	  <sch:param name="cveSpec" value="ISM"/>
</sch:pattern>