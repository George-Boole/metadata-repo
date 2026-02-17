<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="IC-TDF-ID-00007">
    <sch:p class="ruleText">
    	[IC-TDF-ID-00007][Error] For any child assertion of TrustedDataCollection, 
    	the only allowable tokens for attribute scope are [TDC], [DESC_PAYL], [DESC_TDO], [TDC_MEMBER], or [EXPLICIT].
    	
    	Human Readable: Scopes defined within a TrustedDataCollection must refer
    	to the descendent TDOs (the list of TDOs), the descendent Payloads, a TDC Member, the entire TrustedDataCollection, or
    	be explicitly defined.
    </sch:p>
	  <sch:p class="codeDesc">
		For the scope attribute specified on any child element of TrustedDataCollection,
		this rule ensures that the value only contains the tokens [TDC], [DESC_PAYL], [DESC_TDO], [TDC_MEMBER], or [EXPLICIT].
	</sch:p>
	  <sch:rule id="IC-TDF-ID-00007-R1" context="tdf:TrustedDataCollection/*[@tdf:scope]">
		    <sch:assert test="util:containsOnlyTheTokens(@tdf:scope, ('TDC', 'DESC_PAYL', 'DESC_TDO', 'TDC_MEMBER', 'EXPLICIT'))" flag="error" role="error">
			[IC-TDF-ID-00007][Error] For any child element of TrustedDataCollection, 
			the only allowable tokens for attribute scope are [TDC], [DESC_PAYL], [DESC_TDO], [TDC_MEMBER], or [EXPLICIT].
			
			
			Human Readable: Scopes defined within a TrustedDataCollection must refer
			to the descendent TDOs (the list of TDOs), the descendent Payloads, a TDC Member, the entire TrustedDataCollection, or
			be explicitly defined.
        </sch:assert>
    </sch:rule>
</sch:pattern>