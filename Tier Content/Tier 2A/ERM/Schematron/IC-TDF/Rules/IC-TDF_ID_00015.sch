<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="IC-TDF-ID-00015">
    <sch:p class="ruleText">
    	[IC-TDF-ID-00015][Error] If data is labeled as encrypted, then
    	EncryptionInformation must be specified. (Assertion Statement
    	or TrustedDataObject Payload).
    	
    </sch:p>
	  <sch:p class="codeDesc">
		This rule ensures that the previous sibling of the Statement or Payload marked
		with the encrypted attribute set to true is EncryptionInformation.
	</sch:p>
	  <sch:rule id="IC-TDF-ID-00015-R1" context="tdf:*[@tdf:isEncrypted=true()]">
		    <sch:assert test="preceding-sibling::tdf:EncryptionInformation" flag="error" role="error">
			[IC-TDF-ID-00015][Error] If data is labeled as encrypted, then
			EncryptionInformation must be specified. (Assertion Statement
			or TrustedDataObject Payload).
			
		</sch:assert>
    </sch:rule>
</sch:pattern>