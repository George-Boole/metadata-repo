<?xml version="1.0" encoding="UTF-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" xmlns:ism="urn:us:gov:ic:ism" id="NTK-ID-00050">
   
   <sch:p ism:classification="U" ism:ownerProducer="USA" class="ruleText">[NTK-ID-00050][Error] 
      EXDIS profiles requires ntk:ProfileDes with type agencydissem (urn:us:gov:ic:ntk:profile:agencydissem).</sch:p>
   
   <sch:p ism:classification="U" ism:ownerProducer="USA" class="codeDesc">.</sch:p>
   
   <sch:rule context="ntk:AccessProfile[ntk:AccessPolicy = 'urn:us:gov:ic:aces:ntk:xd']">
      <sch:assert test="ntk:ProfileDes = 'urn:us:gov:ic:ntk:profile:agencydissem'">[NTK-ID-00050][Error] 
         EXDIS profiles requires ntk:ProfileDes with type agencydissem (urn:us:gov:ic:ntk:profile:agencydissem).
      </sch:assert>
   </sch:rule>
</sch:pattern>