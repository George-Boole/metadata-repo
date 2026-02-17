<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="IC-TDF-ID-00012">
    <sch:p class="ruleText">
    	[IC-TDF-ID-00012][Error] For any element which specifies attribute scope 
    	containing [EXPLICIT], then element Binding/BoundValueList or 
    	element ReferenceList must be specified.
    	
    	Human Readable: For explicit scope, you must use a BoundValueList or 
    	a ReferenceList to explicitly reference elements are in scope. 
    </sch:p>
	  <sch:p class="codeDesc">
		For elements which specify attribute scope with a value of [EXPLICIT],
		this rule ensures that element Binding/BoundValueList or ReferenceList
		is specified.
	</sch:p>
	  <sch:rule id="IC-TDF-ID-00012-R1" context="*[normalize-space(string(@tdf:scope)) = 'EXPLICIT']">
		    <sch:assert test="tdf:Binding/tdf:BoundValueList or tdf:ReferenceList" flag="error" role="error">
        	[IC-TDF-ID-00012][Error] For any element which specifies attribute scope 
        	containing [EXPLICIT], then element Binding/BoundValueList or 
        	element ReferenceList must be specified.
        	
        	Human Readable: For explicit scope, you must use a BoundValueList or 
        	a ReferenceList to explicitly reference elements are in scope. 
        </sch:assert>
    </sch:rule>
</sch:pattern>