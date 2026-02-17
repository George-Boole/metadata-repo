<?xml version="1.0" encoding="UTF-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="IC-EDH-ID-00011">
    <sch:p class="ruleText">
        [IC-EDH-ID-00011][Error] The @icid:DESVersion is less than the minimum version 
        allowed: 1. 
        
        Human Readable: The IC-ID version imported by IC-EDH must be greater than or equal to 1. 
    </sch:p>
    <sch:p class="codeDesc">
        For all edh:Edh elements that contain @icid:DESVersion, this rule verifies that the version
        is greater than or equal to the minimum allowed version: 1.  
    </sch:p>
    <sch:rule context="edh:Edh[@icid:DESVersion]">
        <sch:let name="version" value="number(if (contains(@icid:DESVersion,'-')) then substring-before(@icid:DESVersion,'-') else @icid:DESVersion)"/>
        <sch:assert test="$version &gt;= 1" flag="error">
            [IC-EDH-ID-00011][Error] The @icid:DESVersion is less than the minimum version 
            allowed: 1. 
                      
            Human Readable: The IC-ID version imported by IC-EDH must be greater than or equal to 1.
        </sch:assert>
    </sch:rule>
</sch:pattern>
