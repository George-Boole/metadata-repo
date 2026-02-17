<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="IC-TDF-ID-00017">
    <sch:p class="ruleText">
    	[IC-TDF-ID-00017][Error] EDH HandlingAssertions with scope containing
    	the token [TDC] must have an EDH whose ARH security element has
    	ism:resourceElement="true" specified.
    	
    	Human Readable: When a HandlingAssertion has scope pertaining to
    	the entire TrustedDataCollection (TDC) it must declare itself a resource level
    	object.
    </sch:p>
	  <sch:p class="codeDesc">
		Where an EDH HandlingAssertion exists with scope containing [TDC], this rule ensures that its decendant ARH element,
		Security or ExternalSecurity, has ism:resourceElement specified with a value of true.
	</sch:p>
	<sch:rule id="IC-TDF-ID-00017-R1" context="tdf:HandlingAssertion[child::tdf:HandlingStatement/edh:Edh and util:containsAnyOfTheTokens(@tdf:scope, ('TDC'))]">
		    <sch:assert test="descendant::arh:*[@ism:resourceElement=true()]" flag="error" role="error">
		    	[IC-TDF-ID-00017][Error] HandlingAssertions with scope containing the token [TDC] must
		    	have an EDH whose ARH security element has ism:resourceElement="true" specified.
			
			Human Readable: When a HandlingAssertion has scope pertaining to
			the entire TrustedDataCollection (TDC) it must declare itself a resource level
			object.
		</sch:assert>
    </sch:rule>
</sch:pattern>