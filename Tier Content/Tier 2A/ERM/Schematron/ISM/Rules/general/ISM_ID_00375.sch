<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="ISM-ID-00375">
    <sch:p class="ruleText">
        [ISM-ID-00375][Error] The ISMCATCESVersion being used for validation does not contain the needed
        TetragraphTaxonomy files. This will prevent ISM validation from functioning. NOTE: This is not an
        erorr of the instance document but of the validation environment itself.
        
        Human Readable: The version of ISMCAT being used in the validaiton infrastructure is missing essential
        components required for ISM validation to proceed. Regardless of the version indicated on the instance 
        document, the validation infrastructure needs to use a minimum version of ISMCAT that is 2017-JUL or later.
    </sch:p>
    <sch:p class="codeDesc">
        Verifies that the validation infrastructure has the minimum required version of ISMCAT by checking the
        version declared in the ISMCAT Tetragraph CVE.
    </sch:p>
    <sch:rule id="ISM-ID-00375-R1" context="/">
        <sch:let name="cve" value="document('../../CVE/ISMCAT/CVEnumISMCATTetragraph.xml')//cve:CVE"/>
        <sch:assert test="$cve/@specVersion &gt;= 201707" flag="error" role="error">
            [ISM-ID-00375][Error] The version of ISMCAT being used in the validation infrastructure is missing essential
            components required for ISM validation to proceed. Regardless of the version indicated on the instance 
            document, the validation infrastructure needs to use a minimum version of ISMCAT that is 2017-JUL or later.
        </sch:assert>
    </sch:rule>
</sch:pattern>