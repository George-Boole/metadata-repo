<?xml version="1.0" encoding="UTF-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:ism="urn:us:gov:ic:ism" xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="VIRT-ID-00003">
   <sch:p class="ruleText" ism:classification="U" ism:ownerProducer="USA">
      [VIRT-ID-00003][Warning] virt:DESVersion attribute SHOULD be specified as 
      version 202010.202205 (Version:2020-OCT Revision: 2022-MAY) with an optional extension.  
   </sch:p>
   <sch:p class="codeDesc" ism:classification="U" ism:ownerProducer="USA">
      This rule supports extending the version identifier with an optional trailing hyphen
      and up to 23 additional characters. The version must match the regular expression
      “^202010.202205(-.{1,23})?$".
   </sch:p>
   <sch:rule id="VIRT-ID-00003-R1" context="*[@virt:DESVersion]">
      <sch:assert test="matches(@virt:DESVersion,'^202010.202205(-.{1,23})?$')" flag="warning" role="warning">
         [VIRT-ID-00003][Warning] virt:DESVersion attribute SHOULD be specified as 
         version 202010.202205 (Version:2020-OCT Revision: 2022-MAY) with an optional extension. 
      </sch:assert>
   </sch:rule>
</sch:pattern>