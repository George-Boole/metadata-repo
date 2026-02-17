<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="IC-TDF-ID-00044">
	  <sch:p class="ruleText">
	  	[IC-TDF-ID-00044][Error] ntk:Access elements on child TDOs or Assertions must be rolled up
	  	to the resource level. As such there must be an ntk:Access on the HandlingAssertion
	  	with scope [TDC]. Precise rollup is left to the creator to determine.
	  	
	  	Human Readable: If there is an ntk:Access in any portion of a TDC, then there must
	  	be an ntk:Access in the HandlingAssertion with scope="TDC"
       </sch:p>
	
    <sch:p class="codeDesc">
    	This rule triggers on any ntk:Access that exists except for one in the tdf:HandlingAssertion
    	with a scope [TDC]. If it triggers it checks that there is an ntk:Access in the 
    	HandlingAssertion with scope [TDC] otherwise it sets an error.
    </sch:p>
	<sch:rule id="IC-TDF-ID-00044-R1" context="tdf:TrustedDataCollection//ntk:Access[not(ancestor::tdf:HandlingAssertion[@tdf:scope='TDC'] or @ntk:externalReference=true())]">
	  	<sch:assert test="ancestor::tdf:TrustedDataCollection/tdf:HandlingAssertion[@tdf:scope='TDC']//ntk:Access" flag="error" role="error">
	  		[IC-TDF-ID-00044][Error] If there is an ntk:Access in any portion of a TDC, then there must
	  		be an ntk:Access in the HandlingAssertion with scope="TDC"
			</sch:assert>
	  </sch:rule>
</sch:pattern>