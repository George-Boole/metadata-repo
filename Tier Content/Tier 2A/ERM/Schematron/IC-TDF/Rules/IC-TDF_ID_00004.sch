<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="IC-TDF-ID-00004">
	<sch:p class="ruleText"> [IC-TDF-ID-00004][Error] For element TrustedDataObject, there must be
		exactly one element HandlingAssertion that specifies attribute scope containing [TDO] and
		contains an EDH element.
		
		Human Readable: There must exist a single EDH HandlingAssertion scoped for the entire TrustedDataObject.</sch:p>
	
	<sch:p class="codeDesc">For element TrustedDataObject, this rule ensures that the count of
		HandlingAssertion elements that specify attribute scope containing [TDO] and have
		child::tdf:HandlingStatement/edh:Edh is exactly 1.</sch:p>
	
	<sch:rule id="IC-TDF-ID-00004-R1" context="tdf:TrustedDataObject">
		<sch:assert test="count(child::tdf:HandlingAssertion[child::tdf:HandlingStatement/edh:Edh and    @tdf:scope = 'TDO'])= 1" flag="error" role="error">[IC-TDF-ID-00004][Error] For element TrustedDataObject, there must be
			exactly one element HandlingAssertion that specifies attribute scope containing [TDO] and
			contains an EDH element.</sch:assert>
	</sch:rule>
</sch:pattern>