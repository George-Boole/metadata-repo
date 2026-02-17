<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="IC-TDF-ID-00033">
    <sch:p class="ruleText">
    	[IC-TDF-ID-00033][Error] A TrustedDataObject with a ReferencePayload must have an
    	ExternalEDH element in the HandlingAssertion with scope [PAYL].
    	    	
    </sch:p>
	  <sch:p class="codeDesc">
		For TrustedDataObject elements with a ReferencePayload, ensure that the HandlingAssertion
		with scope [PAYL] has an ExternalEDH element.
	</sch:p>
	  <sch:rule id="IC-TDF-ID-00033-R1" context="tdf:TrustedDataObject//tdf:ReferenceValuePayload">
		    <sch:assert test="ancestor::tdf:TrustedDataObject//tdf:HandlingAssertion[@tdf:scope='PAYL']//edh:ExternalEdh" flag="error" role="error">
			[IC-TDF-ID-00033][Error] A TrustedDataObject with a ReferencePayload must have an
			ExternalEDH element in the HandlingAssertion with scope [PAYL].
			
		</sch:assert>
    </sch:rule>
</sch:pattern>