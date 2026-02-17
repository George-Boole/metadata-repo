<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="ISMCAT-ID-00002">
    <sch:p class="ruleText">
        [ISMCAT-ID-00002][Error] The @arh:DESVersion is less than the minimum version 
        allowed: 3. 
        
        Human Readable: The ARH version imported by ISMCAT must be greater than or equal to 3. 
    </sch:p>
    <sch:p class="codeDesc">
        For all elements that contain @arh:DESVersion, this rule verifies that the version
        is greater than or equal to the minimum allowed version: 3.  
    </sch:p>
    <sch:rule id="ISMCAT-ID-00002-R1" context="*[@arh:DESVersion]">
        <sch:let name="version" value="number(if (contains(@arh:DESVersion,'-')) then substring-before(@arh:DESVersion,'-') else @arh:DESVersion)"/>
        <sch:assert test="$version &gt;= 3" flag="error" role="error">
            [ISMCAT-ID-00002][Error] The @arh:DESVersion is less than the minimum version 
            allowed: 3. 
            
            Human Readable: The ARH version imported by ISMCAT must be greater than or equal to 3. 
        </sch:assert>
    </sch:rule>
</sch:pattern>