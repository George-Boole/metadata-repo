<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="ISM-ID-00322">
    <sch:p class="ruleText">
        [ISM-ID-00322][Warning] The @ism:ISMCATCESVersion imported by ISM SHOULD be greater than or equal to 201707.
        
        Human Readable: The ISMCAT version imported by ISM SHOULD be greater than or equal to 2017-JUL. 
    </sch:p>
    <sch:p class="codeDesc">
        For all elements that contain @ism:ISMCATCESVersion, this rule checks that the version
        is greater than or equal to the minimum allowed version: 201707. 
    </sch:p>
    <sch:rule id="ISM-ID-00322-R1" context="*[@ism:ISMCATCESVersion]">
        <sch:let name="version" value="number(if (contains(@ism:ISMCATCESVersion,'-')) then substring-before(@ism:ISMCATCESVersion,'-') else @ism:ISMCATCESVersion)"/>
        <sch:assert test="$version &gt;= 201707" flag="warning" role="warning">
            [ISM-ID-00322][Warning] The @ism:ISMCATCESVersion imported by ISM SHOULD be greater than or equal to 201707.
            
            Human Readable: The ISMCAT version imported by ISM SHOULD be greater than or equal to 2017-JUL. 
        </sch:assert>
    </sch:rule>
</sch:pattern>