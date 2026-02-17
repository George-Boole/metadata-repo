<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="IC-TDF-ID-00038">
	  <sch:p class="ruleText">
        [IC-TDF-ID-00038][Error] For the Binding element, every Signer element 
        must specify the issuer attribute and either the serial or subject 
        attribute.
        
       </sch:p>
    <sch:p class="codeDesc">
        This rule checks that for each occurrence of tdf:Signer that @tdf:issuer 
        and either @tdf:subject or @tdf:serial is specified.
    </sch:p>
	  <sch:rule id="IC-TDF-ID-00038-R1" context="tdf:Binding/tdf:Signer">
		    <sch:assert test="@tdf:issuer and (@tdf:serial or @tdf:subject)" flag="error" role="error">
			[IC-TDF-ID-00038][Error] For the Binding element, every Signer element 
			must specify the issuer attribute and either the serial or subject
			attribute.
			</sch:assert>
	  </sch:rule>
</sch:pattern>