<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="IC-TDF-ID-00009">
    <sch:p class="ruleText">
    	[IC-TDF-ID-00009][Error] For element Binding, if element BoundValueList 
    	is specified, then element SignatureValue must not specify attribute
    	includesStatementMetadata.
    	
    	Human Readable: If BoundValueList is present, then it will explicitly 
    	specify includesStatementMetadata for each BoundValue and therefore
    	attribute includesStatementMetadata on the SignatureValue is not applicable.
    </sch:p>
	  <sch:p class="codeDesc">
	  	For element Binding which specifies BoundValueList, this rule ensures that
		element SignatureValue does not specify attribute includesStatementMetadata.
	</sch:p>
	  <sch:rule id="IC-TDF-ID-00009-R1" context="tdf:Binding[tdf:BoundValueList]">
		    <sch:assert test="not(tdf:SignatureValue/@tdf:includesStatementMetadata)" flag="error" role="error">
        	[IC-TDF-ID-00009][Error] For element Binding, if element BoundValueList 
        	is specified, then element SignatureValue must not specify attribute
        	includesStatementMetadata.
        	
        	Human Readable: If BoundValueList is present, then it will explicitly 
        	specify includesStatementMetadata for each BoundValue and therefore
        	attribute includesStatementMetadata on the SignatureValue is not applicable.
        </sch:assert>
    </sch:rule>
</sch:pattern>