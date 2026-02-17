<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="ISM-ID-00205" is-a="AttributeValueDeprecatedError">
    <sch:p class="ruleText">
    	[ISM-ID-00205][Error] Attribute SCIcontrols must not contain values
    	which have passed their deprecation date.
    </sch:p>
    <sch:p class="codeDesc">
    	For each element which specifies attribute ism:SCIControls, this rule ensures that the value of ism:SCIControls has not been deprecated.
    	This is indicated in the CVE file by an attribute (@deprecated) 
    	on the term element for that SCIControls value. 
    	If the date value in @deprecated is in the future, then a 
    	deprecation warning will be given. If the date value has 
    	already occurred, then a deprecation error will be given. 
	</sch:p>
	
	  <sch:param name="ruleId" value="'ISM-ID-00205'"/>
	  <sch:param name="context" value="*[@ism:SCIcontrols]"/>
	  <sch:param name="attrName" value="SCIcontrols"/>
	  <sch:param name="cveName" value="CVEnumISMSCIControls"/>
	  <sch:param name="cveSpec" value="ISM"/>
</sch:pattern>