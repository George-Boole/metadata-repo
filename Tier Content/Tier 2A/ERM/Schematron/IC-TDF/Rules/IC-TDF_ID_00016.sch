<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="IC-TDF-ID-00016">
	<sch:p class="ruleText">[IC-TDF-ID-00016][Error] EDH HandlingAssertions with TDO
		scope must have an ARH security element has ism:resourceElement="true".
		
		Human Readable: An EDH HandlingAssertion with scope pertaining to the entire
		TrustedDataObject (TDO) must declare itself a resource level object.</sch:p>
	
	<sch:p class="codeDesc">EDH HandlingAssertions with scope containing [TDO], ensure
		that its decendant ARH element, Security or ExternalSecurity, has ism:resourceElement="true".</sch:p>
	
	<sch:rule id="IC-TDF-ID-00016-R1" context="tdf:HandlingAssertion[child::tdf:HandlingStatement/edh:Edh and util:containsAnyOfTheTokens(@tdf:scope, ('TDO'))]">
		
		<sch:assert test="descendant::arh:*[@ism:resourceElement=true()]" flag="error" role="error">[IC-TDF-ID-00016][Error] HandlingAssertions with scope containing the token [TDO] must
			have an EDH whose ARH security element has ism:resourceElement="true" specified.
			
			Human Readable: An EDH HandlingAssertion with scope pertaining to the entire
			TrustedDataObject (TDO) must declare itself a resource level object.</sch:assert>
	</sch:rule>
</sch:pattern>