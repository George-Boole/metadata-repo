<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="IC-TDF-ID-00026">
	  <sch:p class="ruleText">
		[IC-TDF-ID-00026][Error] If payload attribute @isEncrypted="true", then there needs to 
		be two handling assertions with attribute scope="PAYL": one with attribute 
		@appliesToState="encrypted" and the other with attribute appliesToState="unencrypted".
		
		Human Readable: Encrypted payloads require handling assertions for both encrypted and 
		unencrypted payload states. 
	</sch:p>
	  <sch:p class="codeDesc">
	  	If there exists a TDO payload element with attribute @isEncrypted as true, this rule ensures there
		is one handling assertion of @scope PAYL and @appliestostate of encrypted, and one handling 
		assertion of @scope PAYL and @appliestostate of unencrypted.
	</sch:p>
	  <sch:rule id="IC-TDF-ID-00026-R1" context="tdf:TrustedDataObject/tdf:*[@tdf:isEncrypted=true()]">
		    <sch:assert test="count(parent::node()/tdf:HandlingAssertion[util:containsAnyOfTheTokens(@tdf:scope, ('PAYL')) and @tdf:appliesToState='encrypted'])= 1    and     count(parent::node()/tdf:HandlingAssertion[util:containsAnyOfTheTokens(@tdf:scope, ('PAYL')) and @tdf:appliesToState='unencrypted'])= 1" flag="error" role="error">
			[IC-TDF-ID-00026][Error] If payload attribute @isEncrypted="true", then there needs to 
			be two handling assertions with attribute scope="PAYL": one with attribute 
			@appliesToState="encrypted" and the other with attribute appliesToState="unencrypted".
		</sch:assert>
	  </sch:rule>
</sch:pattern>