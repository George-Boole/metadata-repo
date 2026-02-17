<?xml version="1.0" encoding="UTF-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="IC-EDH-ID-00016">
   <sch:p class="ruleText">
      [IC-EDH-ID-00016][Warning] edh:DESVersion attribute SHOULD be specified as version 201903 (Version:2019-MAR) with an optional extension.  
   </sch:p>
   <sch:p class="codeDesc">
      This rule supports extending the version identifier with an optional trailing hyphen
      and up to 23 additional characters. The version must match the regular expression
      “^201903(-.{1,23})?$".
   </sch:p>
   <sch:rule id="IC-EDH-ID-00016-R1" 
             context="*[@edh:DESVersion]">
      <sch:assert test="matches(@edh:DESVersion,'^201903(\-.{1,23})?$')" flag="warning" role="warning">
         [IC-EDH-ID-00016][Warning] edh:DESVersion attribute SHOULD be specified as version 201903 (Version:2019-MAR) with an optional extension. 
         The value provided was: <sch:value-of select="@edh:DESVersion"/>
      </sch:assert>
   </sch:rule>
</sch:pattern>