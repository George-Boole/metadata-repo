<?xml version="1.0" encoding="UTF-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" xmlns:ism="urn:us:gov:ic:ism" id="NTK-ID-00037">

   <sch:p ism:classification="U" ism:ownerProducer="USA" class="ruleText">[NTK-ID-00037][Error] Use of the restrictive access policy requires the Group &amp;
      Individual Profile DES.</sch:p>

   <sch:p ism:classification="U" ism:ownerProducer="USA" class="codeDesc">If ntk:AccessProfile has an ntk:AccessPolicy = 'urn:us:gov:ic:aces:ntk:restrictive',
      ntk:ProfileDes must be 'urn:us:gov:ic:ntk:profile:grp-ind'.</sch:p>

   <sch:rule context="ntk:AccessProfile[ntk:AccessPolicy='urn:us:gov:ic:aces:ntk:restrictive']/ntk:ProfileDes">
      <sch:assert test=". = 'urn:us:gov:ic:ntk:profile:grp-ind'" flag="error">[NTK-ID-00037][Error] Use of the
         restrictive access policy requires the Group and Individual Profile DES.</sch:assert>
   </sch:rule>
</sch:pattern>
