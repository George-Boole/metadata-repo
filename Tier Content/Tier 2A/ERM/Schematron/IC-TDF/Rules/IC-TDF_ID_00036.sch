<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="IC-TDF-ID-00036">
    <sch:p class="ruleText">
        [IC-TDF-ID-00036][Error] The @edh:DESVersion is less than the minimum version 
        allowed: 1. 
        
        Human Readable: The edh version imported by IC-TDF must be greater than or equal to 1. 
    </sch:p>
    <sch:p class="codeDesc">
        For all elements that contain @edh:DESVersion, verify that the version
        is greater than or equal to the minimum allowed version: 1.  
    </sch:p>
    <sch:rule id="IC-TDF-ID-00036-R1" context="*[@edh:DESVersion]">
        <sch:let name="version" value="number(if (contains(@edh:DESVersion,'-')) then substring-before(@edh:DESVersion,'-') else @edh:DESVersion)"/>
        <sch:assert test="$version &gt;= 1" flag="error" role="error">
            [IC-TDF-ID-00036][Error] The @edh:DESVersion is less than the minimum version 
            allowed: 1. 
            
            Human Readable: The edh version imported by IC-TDF must be greater than or equal to 1.
        </sch:assert>
    </sch:rule>
</sch:pattern>