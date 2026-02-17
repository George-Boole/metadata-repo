<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="IC-TDF-ID-00014">
    <sch:p class="ruleText">
    	[IC-TDF-ID-00014][Error] If EncryptionInformation is specified, then
    	the data it refers to must be labeled as encrypted. (Assertion Statement
    	or TrustedDataObject Payload).
    </sch:p>
	  <sch:p class="codeDesc">
		This rule ensures that the following sibling of EncryptionInformation, the
		Payload or Assertion Statement, has the encrypted attribute set to 
		true.
	</sch:p>
	<sch:rule id="IC-TDF-ID-00014-R1" context="tdf:EncryptionInformation[parent::tdf:Assertion] | tdf:EncryptionInformation[parent::tdf:TrustedDataObject]">
		    <sch:assert test="following-sibling::tdf:*[@tdf:isEncrypted=true()]" flag="error" role="error">
			[IC-TDF-ID-00014][Error] If EncryptionInformation is specified, then
			the data it refers to must be labeled as encrypted. (Assertion Statement
			or TrustedDataObject Payload).
		</sch:assert>
    </sch:rule>
</sch:pattern>