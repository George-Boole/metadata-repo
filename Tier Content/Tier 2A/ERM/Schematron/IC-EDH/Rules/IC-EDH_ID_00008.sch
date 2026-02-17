<?xml version="1.0" encoding="UTF-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="IC-EDH-ID-00008">
    <sch:p class="ruleText">
        [IC-EDH-ID-00008][Error] The @ism:DESVersion is less than the minimum version 
        allowed: 13. 
        
        Human Readable: The ISM version imported by IC-EDH must be greater than or equal to 13. 
    </sch:p>
    <sch:p class="codeDesc">
        For all elements that contain @ism:DESVersion, this rule verifies that the version
        is greater than or equal to the minimum allowed version: 13.  
    </sch:p>
    <sch:rule context="*[@ism:DESVersion]">
        <sch:let name="version" value="number(if (contains(@ism:DESVersion,'-')) then substring-before(@ism:DESVersion,'-') else @ism:DESVersion)"/>
        <sch:assert test="$version &gt;= 13" flag="error">
            [IC-EDH-ID-00008][Error] The @ism:DESVersion is less than the minimum version 
            allowed: 13. 
            
            Human Readable: The ISM version imported by IC-EDH must be greater than or equal to 13.
        </sch:assert>
    </sch:rule>
</sch:pattern>
