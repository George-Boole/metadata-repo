<?xml version="1.0" encoding="UTF-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="IC-EDH-ID-00014">
    
    <sch:p class="ruleText">[IC-EDH-ID-00014][Error] The @ism:ISMCATCESVersion is less than the minimum version allowed:
        201505.
    
        Human Readable: The ISMCAT version imported by IC-EDH must be greater than or equal to 2015-MAY.
    </sch:p>
    
    <sch:p class="codeDesc">For all edh:Edh and edh:ExternalEdh elements that contain @ism:ISMCATCESVersion, this rule
        verifies that the version is greater than or equal to the minimum allowed version: 201505.</sch:p>
    
    <sch:rule context="edh:Edh[@ism:ISMCATCESVersion] | edh:ExternalEdh[@ism:ISMCATCESVersion]">
        
        <sch:let name="version"
            value="number(if (contains(@ism:ISMCATCESVersion,'-')) then substring-before(@ism:ISMCATCESVersion,'-') else @ism:ISMCATCESVersion)"/>
        
        <sch:assert test="$version &gt;= 201505" flag="error">[IC-EDH-ID-00014][Error] The @ism:ISMCATCESVersion is less
            than the minimum version allowed: 201505.
        
            Human Readable: The ISMCAT version imported by IC-EDH must be greater than or equal to 2015-MAY.
        </sch:assert>
    </sch:rule>
</sch:pattern>
