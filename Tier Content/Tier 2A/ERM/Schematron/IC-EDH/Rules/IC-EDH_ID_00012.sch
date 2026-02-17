<?xml version="1.0" encoding="UTF-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="IC-EDH-ID-00012">
   
   <sch:p class="ruleText">[IC-EDH-ID-00012][Error] The @usagency:CESVersion is less than the minimum version allowed:
      201502.
   
      Human Readable: The USAgency version imported by IC-EDH must be greater than or equal to 2015-FEB.
   </sch:p>
   
   <sch:p class="codeDesc">For all edh:Edh and edh:ExternalEdh elements that contain @usagency:CESVersion, this rule
      verifies that the version is greater than or equal to the minimum allowed version: 201502.</sch:p>
   
   <sch:rule context="edh:Edh[@usagency:CESVersion] | edh:ExternalEdh[@usagency:CESVersion]">
      
      <sch:let name="version"
         value="number(if (contains(@usagency:CESVersion,'-')) then substring-before(@usagency:CESVersion,'-') else @usagency:CESVersion)"/>
      
      <sch:assert test="$version &gt;= 201502" flag="error">[IC-EDH-ID-00012][Error] The @usagency:CESVersion is less
         than the minimum version allowed: 201502.
      
         Human Readable: The USAgency version imported by IC-EDH must be greater than or equal to 2015-FEB.</sch:assert>
   </sch:rule>
</sch:pattern>
