<?xml version="1.0" encoding="UTF-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="ARH-ID-00005">
    <sch:p class="ruleText">
        [ARH-ID-00005][Error] The @ism:DESVersion is less than the minimum version 
        allowed: 12. 
        
        Human Readable: The ism version imported by ARH must be greater than or equal to 12. 
    </sch:p>
    <sch:p class="codeDesc">
        For all elements that contain @ism:DESVersion, we verify that the version
        is greater than or equal to the minimum allowed version: 12.  
    </sch:p>
    <sch:rule context="*[@ism:DESVersion]">
        <sch:assert test="number(@ism:DESVersion) &gt;= 12" flag="error">
            [ARH-ID-00005][Error] The @ism:DESVersion is less than the minimum version 
            allowed: 12. 
            
            Human Readable: The ism version imported by ARH must be greater than or equal to 12.
        </sch:assert>
    </sch:rule>
</sch:pattern>
