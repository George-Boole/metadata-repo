<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="IC-TDF-ID-00055">
	<sch:p class="ruleText"> [IC-TDF-ID-00055][Error] For element TrustedDataObject whose payload is NOT encrypted,
		there must not be more than one element HandlingAssertion that specifies attribute scope containing [PAYL] and
		contains an EDH element.
		
		Human Readable: For TrustedDataObjects with unencrypted payloads, there must not be more than a single 
		EDH HandlingAssertion scoped for the payload.</sch:p>
	
	<sch:p class="codeDesc">For element TrustedDataObject whose payload is NOT encrypted, ensure that the count of
		HandlingAssertion elements that specify attribute scope containing [PAYL] and have
		child::tdf:HandlingStatement/edh:Edh is not more than 1.</sch:p>
	
	<sch:rule id="IC-TDF-ID-00055-R1" context="tdf:TrustedDataObject[not(tdf:*/@tdf:isEncrypted=true())]">
		<sch:assert test="not(count(child::tdf:HandlingAssertion[child::tdf:HandlingStatement/edh:Edh and @tdf:scope = 'PAYL']) &gt; 1)" flag="error" role="error">[IC-TDF-ID-00055][Error] For element TrustedDataObject whose payload is NOT encrypted,
			there must not be more than one element HandlingAssertion that specifies attribute scope containing [PAYL] and
			contains an EDH element.
			
			Human Readable: For TrustedDataObjects with unencrypted payloads, there must not be more than a single 
			EDH HandlingAssertion scoped for the payload.</sch:assert>
	</sch:rule>
</sch:pattern>