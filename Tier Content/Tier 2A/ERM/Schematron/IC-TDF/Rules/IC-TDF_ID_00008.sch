<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="IC-TDF-ID-00008">
    <sch:p class="ruleText">
    	[IC-TDF-ID-00008][Error] The use of EXPLICIT scope is not currently allowed.
    	Key questions regarding the functionality of Binding within EXPLICIT scope
    	are still being defined. The rest of the rules/structure relating to
    	EXPLICIT scope are included in the spec to give the community an idea of
    	how these rules/structures will be defined.
    	
    	If there is a use-case which requires EXPLICIT scope, please send an 
    	email to ic-standards-support@iarpa.gov so that the use-case can be incorporated while defining the behavior of EXPLICIT scope.
    	
    </sch:p>
	  <sch:p class="codeDesc">
		For any element which specifies attribute scope containing [EXPLICIT],
		we instantly fail because EXPLICIT scope is currently not supported.
	</sch:p>
	  <sch:rule id="IC-TDF-ID-00008-R1" context="*[util:containsAnyOfTheTokens(@tdf:scope, ('EXPLICIT'))]">
		    <sch:assert test="false()" flag="error" role="error">
			[IC-TDF-ID-00008][Error] The use of EXPLICIT scope is not currently allowed.
			Key questions regarding the functionality of Binding within EXPLICIT scope
			are still being defined. The rest of the rules/structure relating to
			EXPLICIT scope are included in the spec to give the community an idea of
			how these rules/structures will be defined.
			
			If there is a use-case which requires EXPLICIT scope, please send an 
			email to ic-standards-support@iarpa.gov so that the use-case can be incorporated while defining the behavior of EXPLICIT scope.
			
		</sch:assert>
    </sch:rule>
</sch:pattern>