<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="IC-TDF-ID-00042">

	<sch:p class="ruleText">[IC-TDF-ID-00042][Error] The first HandlingAssertion of a
		TDF must have the attribute scope with a value of [TDO] or [TDC] and contain an EDH.</sch:p>

	<sch:p class="codeDesc">This rule triggers on the first HandlingAssertion element for each
		TDF and tests that the value of the @tdf:scope attribute is set a value of [TDO] or [TDC] and that an EDH exists.
		Otherwise, an error is triggered. This prevents some other handling assertion such as Revision Recall from being the ISM resource node for the entire TDO.</sch:p>

	<sch:rule id="IC-TDF-ID-00042-R1" context="tdf:*/tdf:HandlingAssertion[1]">
		<sch:assert test="((parent::tdf:TrustedDataObject and @tdf:scope='TDO') or (parent::tdf:TrustedDataCollection and @tdf:scope='TDC')) and ./tdf:HandlingStatement/edh:Edh" flag="error" role="error">[IC-TDF-ID-00042][Error] The first
			HandlingAssertion of a TDF must have the attribute scope with a value of
			[TDO] or [TDC] and contain an EDH.</sch:assert>
	</sch:rule>
</sch:pattern>