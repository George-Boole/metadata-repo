<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="IC-TDF-ID-00013">
    <sch:p class="ruleText">
    	[IC-TDF-ID-00013][Error] Elements ReferenceList and BoundValueList are
    	currently not allowed. Key questions regarding the functionality of
    	granular references and granular binding are still being defined. The 
    	rest of the rules/structure relating to these elements are included in
    	the spec to give the community an idea of how these rules/structures 
    	will be defined.
    	
    	If there is a use-case which requires granular references or granular
    	binding, please send an email to ic-standards-support@iarpa.gov so that
    	the use-case can be incorporated while defining the behavior and rules.
    	
    </sch:p>
	  <sch:p class="codeDesc">
		Elements ReferenceList and BoundValueList are
		not allowed in v1.  This rule will in the future require that elements which specify element ReferenceList or Binding/BoundValueList
		have attribute scope is specified with a value of [EXPLICIT].
	</sch:p>
	  <sch:rule id="IC-TDF-ID-00013-R1" context="tdf:ReferenceList | tdf:Binding/tdf:BoundValueList">
		    <sch:assert test="false()" flag="error" role="error">
			[IC-TDF-ID-00013][Error] Elements ReferenceList and BoundValueList are
			currently not allowed. Key questions regarding the functionality of
			granular references and granular binding are still being defined. The 
			rest of the rules/structure relating to these elements are included in
			the spec to give the community an idea of how these rules/structures 
			will be defined.
			
			If there is a use-case which requires granular references or granular
			binding, please send an email to ic-standards-support@iarpa.gov so that
			the use-case can be incorporated while defining the behavior and rules.
			
		</sch:assert>
    </sch:rule>
</sch:pattern>