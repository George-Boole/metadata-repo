<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="IC-TDF-ID-00037">
    <sch:p class="ruleText">
        [IC-TDF-ID-00037][Error] The @arh:DESVersion is less than the minimum version 
        allowed: 1. 
        
        Human Readable: The arh version imported by IC-TDF must be greater than or equal to 1. 
    </sch:p>
    <sch:p class="codeDesc">
        For all elements that contain @arh:DESVersion, verify that the version
        is greater than or equal to the minimum allowed version: 1.  
    </sch:p>
    <sch:rule id="IC-TDF-ID-00037-R1" context="*[@arh:DESVersion]">
        <sch:let name="version" value="number(if (contains(@arh:DESVersion,'-')) then substring-before(@arh:DESVersion,'-') else @arh:DESVersion)"/>
        <sch:assert test="$version &gt;= 1" flag="error" role="error">
            [IC-TDF-ID-00037][Error] The @arh:DESVersion is less than the minimum version 
            allowed: 1. 
            
            Human Readable: The arh version imported by IC-TDF must be greater than or equal to 1. 
        </sch:assert>
    </sch:rule>
</sch:pattern>