<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="IC-TDF-ID-00040">
	  <sch:p class="ruleText">
        [IC-TDF-ID-00040][Error] If there are more than one EncryptionInformation elements
        specified in any one EncryptionInformation Group than @tdf:sequenceNum must also
        be specified.
        
       </sch:p>
    <sch:p class="codeDesc">
        This rule checks that if there are more than one tdf:EncryptionInformation in any encryption
        group (if it has siblings) then it checks that a tdf:sequenceNum attribute is present on the 
        EncryptionInformation element.
    </sch:p>
	  <sch:rule id="IC-TDF-ID-00040-R1" context="tdf:EncryptionInformation[count((preceding-sibling::tdf:EncryptionInformation, following-sibling::tdf:EncryptionInformation))&gt;0]">
		    <sch:assert test="@tdf:sequenceNum" flag="error" role="error">
			[IC-TDF-ID-00040][Error] If there are more than one EncryptionInformation elements
			specified in any one EncryptionInformation Group than @tdf:sequenceNum must also
			be specified.
			</sch:assert>
	  </sch:rule>
</sch:pattern>