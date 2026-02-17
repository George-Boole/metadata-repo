<?xml version="1.0" encoding="UTF-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="IC-EDH-ID-00010">
    <sch:p class="ruleText">
        [IC-EDH-ID-00010][Error] The @ntk:DESVersion is less than the minimum version 
        allowed: 10. 
        
        Human Readable: The NTK version imported by IC-EDH must be greater than or equal to 10. 
    </sch:p>
    <sch:p class="codeDesc">
        For all elements that contain @ntk:DESVersion, this rule verifies that the version
        is greater than or equal to the minimum allowed version: 10.  
    </sch:p>
    <sch:rule context="*[@ntk:DESVersion]">
        <sch:let name="version" value="number(if (contains(@ntk:DESVersion,'-')) then substring-before(@ntk:DESVersion,'-') else @ntk:DESVersion)"/>
        <sch:assert test="$version &gt;= 10" flag="error">
            [IC-EDH-ID-00010][Error] The @ntk:DESVersion is less than the minimum version 
            allowed: 10. 

            Human Readable: The NTK version imported by IC-EDH must be greater than or equal to 10.
        </sch:assert>
    </sch:rule>
</sch:pattern>
