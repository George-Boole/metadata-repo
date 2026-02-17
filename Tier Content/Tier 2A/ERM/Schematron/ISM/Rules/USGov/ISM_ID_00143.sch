<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="ISM-ID-00143">
    <sch:p class="ruleText">
        [ISM-ID-00143][Error] If ISM_USGOV_RESOURCE and attribute 
        derivativelyClassifiedBy is specified, then attribute derivedFrom must
        be specified. 
        
        Human Readable: Derivatively Classified data including DOE data requires
        a derived from value to be identified.
    </sch:p>
    <sch:p class="codeDesc">
    	If the document is an ISM_USGOV_RESOURCE, for each element which 
    	specifies attribute ism:derivativelyClassifiedBy this rule ensures that
    	attribute ism:derivedFrom is specified.
    </sch:p>
	  <sch:rule id="ISM-ID-00143-R1" context="*[$ISM_USGOV_RESOURCE and @ism:derivativelyClassifiedBy]">
        <sch:assert test="@ism:derivedFrom" flag="error" role="error">
        	[ISM-ID-00143][Error] If ISM_USGOV_RESOURCE and attribute 
        	derivativelyClassifiedBy is specified, then attribute derivedFrom must
        	be specified. 
        	
        	Human Readable: Derivatively Classified data including DOE data requires
        	a derived from value to be identified.
        </sch:assert>
    </sch:rule>
</sch:pattern>