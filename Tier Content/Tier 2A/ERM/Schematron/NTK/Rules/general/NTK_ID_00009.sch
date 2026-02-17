<?xml version="1.0" encoding="UTF-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" xmlns:ism="urn:us:gov:ic:ism" id="NTK-ID-00009">

   <sch:p ism:classification="U" ism:ownerProducer="USA" class="ruleText">[NTK-ID-00009][Error] The @ism:DESVersion is less than the minimum version allowed:
      201508.</sch:p>

   <sch:p ism:classification="U" ism:ownerProducer="USA" class="codeDesc">For all elements that contain @ism:DESVersion, this rule ensures that the version is greater
      than or equal to the minimum allowed version: 201508.</sch:p>

   <sch:rule context="*[@ism:DESVersion]">

      <sch:let name="version"
         value="number(if (contains(@ism:DESVersion,'-')) then substring-before(@ism:DESVersion,'-') else @ism:DESVersion)"/>

      <sch:assert test="$version &gt;= 201508" flag="error">[NTK-ID-00009][Error] The @ism:DESVersion is less than the
         minimum version allowed: 201508.</sch:assert>
   </sch:rule>
</sch:pattern>
