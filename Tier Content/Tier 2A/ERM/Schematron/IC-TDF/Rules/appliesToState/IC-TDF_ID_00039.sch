<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="IC-TDF-ID-00039">
    <sch:p class="ruleText">
    	[IC-TDF-ID-00039][Error] Attribute @appliesToState is only allowed on HandlingAssertions with scope PAYL.
    	
    	Human Readable: Only Handling Assertions with scope PAYL can use the appliesToState attribute because
    	the attribute indicates the state (encrypted or unencrypted) of the payload to which the assertion appies.		
    </sch:p>
	  <sch:p class="codeDesc">
	  	If attribute @appliesToState is defined on a handlingAssertion, this rule ensures that handlingAssertion has scope PAYL
	</sch:p>
	  <sch:rule id="IC-TDF-ID-00039-R1" context="tdf:TrustedDataObject/tdf:HandlingAssertion[@tdf:appliesToState]">
		    <sch:assert test="@tdf:scope='PAYL'" flag="error" role="error">
			[IC-TDF-ID-00039][Error] Attribute @appliesToState is only allowed with HandlingAssertions 
			of scope PAYL
			
			Human Readable: Only Handling Assertions with scope PAYL can use the appliesToState attribute because
			the attribute indicates the state (encrypted or unencrypted) of the payload to which the assertion appies.		
		</sch:assert>
    </sch:rule>
</sch:pattern>