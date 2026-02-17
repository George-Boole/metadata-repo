<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="IC-TDF-ID-00027">
	  <sch:p class="ruleText">
		[IC-TDF-ID-00027][Error] If payload attribute @isEncrypted="true", the handling 
		assertion with @scope="PAYL" that contains @appliesToState="unencrypted"  must 
		contain an edh:externalEDH.
		
		Human Readable: When content is encrypted, the handling assertion describing 
		the content in an unencrypted state is in effect external.
	</sch:p>
	  <sch:p class="codeDesc">
	  	If there exists a TDO payload element with attribute @isEncrypted as true, this rule ensures that there
		is one handling assertion of @scope PAYL, @appliestostate of unencrypted, and has descendant 
		element ExternalEdh.
	</sch:p>
	  <sch:rule id="IC-TDF-ID-00027-R1" context="tdf:TrustedDataObject/tdf:*[@tdf:isEncrypted=true()]">
		    <sch:assert test="count(parent::node()/tdf:HandlingAssertion[util:containsAnyOfTheTokens(@tdf:scope, ('PAYL'))    and @tdf:appliesToState='unencrypted']/tdf:HandlingStatement/edh:ExternalEdh)= 1" flag="error" role="error">
			[IC-TDF-ID-00027][Error] If payload attribute @isEncrypted="true", the handling 
			assertion with @scope="PAYL" that contains @appliesToState="unencrypted"  must 
			contain an edh:externalEDH. 
			
			Human Readable: When content is encrypted, the handling assertion describing the content in an unencrypted state is in effect external.
		</sch:assert>
	  </sch:rule>
</sch:pattern>