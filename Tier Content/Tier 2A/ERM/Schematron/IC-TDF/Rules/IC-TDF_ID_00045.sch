<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="IC-TDF-ID-00045">
    <sch:p class="ruleText">
        [IC-TDF-ID-00045][Error] The @revrecall:DESVersion is less than the minimum version 
        allowed: 201412. 
        
        Human Readable: The RevRecall version imported by IC-TDF must be greater than or equal to 2014-DEC. 
    </sch:p>
    <sch:p class="codeDesc">
        For all elements that contain @revrecall:DESVersion, ensure that the version
        is greater than or equal to the minimum allowed version: 201412.  
    </sch:p>
    <sch:rule id="IC-TDF-ID-00045-R1" context="*[@revrecall:DESVersion]">
        <sch:let name="version" value="number(if (contains(@revrecall:DESVersion,'-')) then substring-before(@revrecall:DESVersion,'-') else @revrecall:DESVersion)"/>
        <sch:assert test="$version &gt;= 201412" flag="error" role="error">
            [IC-TDF-ID-00045][Error] The @revrecall:DESVersion is less than the minimum version 
            allowed: 201412. 
            
            Human Readable: The RevRecall version imported by IC-TDF must be greater than or equal to 2014-DEC.
        </sch:assert>
    </sch:rule>
</sch:pattern>