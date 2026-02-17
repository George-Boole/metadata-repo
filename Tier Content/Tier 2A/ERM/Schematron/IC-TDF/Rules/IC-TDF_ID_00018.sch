<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="IC-TDF-ID-00018">
    <sch:p class="ruleText">
    	[IC-TDF-ID-00018][Error] HandlingAssertions with scope containing
    	the token [TDO] cannot use the ExternalEdh child element.
    	
    	Human Readable: When a HandlingAssertion has scope pertaining to
    	the entire TrustedDataObject (TDO), it must never use the
    	ExternalEdh child element because the HandlingAssertion will 
    	always refer to the object in which it resides.
    </sch:p>
	  <sch:p class="codeDesc">
		Where a HandlingAssertion exists with scope containing [TDO], this rule ensures that it does
		not have a child of ExternalEdh.
	</sch:p>
	  <sch:rule id="IC-TDF-ID-00018-R1" context="tdf:HandlingAssertion[util:containsAnyOfTheTokens(@tdf:scope, ('TDO'))]">
		    <sch:assert test="not(descendant::edh:ExternalEdh)" flag="error" role="error">
			[IC-TDF-ID-00018][Error] HandlingAssertions with scope containing
			the token [TDO] cannot use the ExternalEdh child element.
			
			Human Readable: When a HandlingAssertion has scope pertaining to
			the entire TrustedDataObject (TDO), it must never use the
			ExternalEdh child element because the HandlingAssertion will 
			always refer to the object in which it resides.
		</sch:assert>
    </sch:rule>
</sch:pattern>