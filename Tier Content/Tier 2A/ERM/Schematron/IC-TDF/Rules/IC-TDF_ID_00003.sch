<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="IC-TDF-ID-00003">
    <sch:p class="ruleText">
    	[IC-TDF-ID-00003][Error] For element TrustedDataObject, there must be 
    	at least one element HandlingAssertion which specifies attribute scope
    	containing [PAYL].
    	
    	Human Readable: There must exist at least one handling marking for the payload.
    </sch:p>
    <sch:p class="codeDesc">
    	For each TrustedDataObject, this rule ensures that the count of HandlingAssertion
        element which specify attribute scope containing [PAYL] is greater than or equal to 1.
    </sch:p>
	  <sch:rule id="IC-TDF-ID-00003-R1" context="tdf:TrustedDataObject">
		    <sch:assert test="count(child::tdf:HandlingAssertion[util:containsAnyOfTheTokens(@tdf:scope, ('PAYL'))])&gt;= 1" flag="error" role="error">			
        	[IC-TDF-ID-00003][Error] For element TrustedDataObject, there must be 
        	at least one element HandlingAssertion which specifies attribute scope
        	containing [PAYL].
        	
        	Human Readable: There must exist at least one handling marking for the payload.
        </sch:assert>
    </sch:rule>
</sch:pattern>