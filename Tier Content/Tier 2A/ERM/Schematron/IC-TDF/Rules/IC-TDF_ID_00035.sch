<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="IC-TDF-ID-00035">
    <sch:p class="ruleText">
    	[IC-TDF-ID-00035][Error] For any handling assertion child element of TrustedDataCollection, the
    	only allowable token for attribute scope is [TDC]. 
    	
    	Human Readable: Scopes defined within a TrustedDataCollection Handling Assertion must refer to
    	entire TrustedDataCollection.
    </sch:p>
	  <sch:p class="codeDesc">
		For the scope attribute specified on handlingAssertion child elements of TrustedDataCollection,
		we make sure that the value only contains the tokens [TDC].
	</sch:p>
	  <sch:rule id="IC-TDF-ID-00035-R1" context="tdf:TrustedDataCollection/tdf:HandlingAssertion">
		    <sch:assert test="util:containsOnlyTheTokens(@tdf:scope, ('TDC'))" flag="error" role="error">			
			[IC-TDF-ID-00035][Error] For any child handlingAssertion of TrustedDataCollection, the
			only allowable tokens for attribute scope is [TDC]. 
			
			Human Readable: Scopes defined within a TrustedDataCollection Handling Assertion must refer to
			entire TrustedDataCollection.
        </sch:assert>
    </sch:rule>
</sch:pattern>