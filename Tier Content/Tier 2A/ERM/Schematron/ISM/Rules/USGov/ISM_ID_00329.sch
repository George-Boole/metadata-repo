<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="ISM-ID-00329">
    <sch:p class="ruleText">
        [ISM-ID-00329][Error] Attributes declassEvent and declassDate 
        are mutually exclusive.
    </sch:p>
	  <sch:p class="codeDesc">
		An element cannot have both attributes ism:declassEvent and 
		ism:declassDate.
	</sch:p>
	
    <sch:rule id="ISM-ID-00329-R1" context="*[@ism:declassDate and @ism:declassEvent]">
	     <sch:assert test="false()" flag="error" role="error">
	       [ISM-ID-00329][Error] Attributes declassEvent and declassDate 
	       are mutually exclusive.
		</sch:assert>
	  </sch:rule>
</sch:pattern>