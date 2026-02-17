<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="IC-TDF-ID-00006">
    <sch:p class="ruleText">
    	[IC-TDF-ID-00006][Error] For any child element of TrustedDataObject, the
    	only allowable tokens for attribute scope are [PAYL], [TDO], or [EXPLICIT]. 
    	
    	Human Readable: Scopes defined within a TrustedDataObject must refer to
    	the payload, the entire TrustedDataObject, the combination of the payload 
    	and the entire TrustedDataObject, or be explicitly defined.
    </sch:p>
	  <sch:p class="codeDesc">
		For the scope attribute specified on any child element of TrustedDataObject,
		this rule ensures that the value only contains the tokens [PAYL], [TDO], or [EXPLICIT].
	</sch:p>
	  <sch:rule id="IC-TDF-ID-00006-R1" context="tdf:TrustedDataObject/*[@tdf:scope]">
		    <sch:assert test="util:containsOnlyTheTokens(@tdf:scope, ('PAYL', 'TDO', 'EXPLICIT'))" flag="error" role="error">			
			[IC-TDF-ID-00006][Error] For any child element of TrustedDataObject, the
			only allowable tokens for attribute scope are [PAYL], [TDO], or [EXPLICIT]. 
			
			Human Readable: Scopes defined within a TrustedDataObject must refer to
			the payload, the entire TrustedDataObject, the combination of the payload 
			and the entire TrustedDataObject, or be explicitly defined.
        </sch:assert>
    </sch:rule>
</sch:pattern>