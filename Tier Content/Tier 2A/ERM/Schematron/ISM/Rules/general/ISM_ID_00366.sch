<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="ISM-ID-00366">
    <sch:p class="ruleText">
        [ISM-ID-00366][Error] The @ntk:DESVersion is less than the minimum version 
        allowed: 201508. 
        
        Human Readable: The NTK version imported by ISM must be greater than or equal to 2015-AUG. 
    </sch:p>
    <sch:p class="codeDesc">
        For all elements that contain @ntk:DESVersion, this rule verifies that the version
        is greater than or equal to the minimum allowed version: 201508.  
    </sch:p>
    <sch:rule id="ISM-ID-00366-R1" context="*[@ntk:DESVersion]">
        <sch:let name="version" value="number(if (contains(@ntk:DESVersion,'-')) then substring-before(@ntk:DESVersion,'-') else @ntk:DESVersion)"/>
        <sch:assert test="$version &gt;= 201508" flag="error" role="error">
            [ISM-ID-00366][Error] The @ntk:DESVersion is less than the minimum version 
            allowed: 201508. 
            
            Human Readable: The NTK version imported by ISM must be greater than or equal to 2015-AUG.
        </sch:assert>
    </sch:rule>
</sch:pattern>