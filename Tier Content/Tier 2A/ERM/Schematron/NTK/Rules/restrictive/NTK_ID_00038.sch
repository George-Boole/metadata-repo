<?xml version="1.0" encoding="UTF-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" xmlns:ism="urn:us:gov:ic:ism" id="NTK-ID-00038">

   <sch:p ism:classification="U" ism:ownerProducer="USA" class="ruleText">[NTK-ID-00038][Error] Use of the restrictive access policy requires a Group vocabulary
      type.</sch:p>

   <sch:p ism:classification="U" ism:ownerProducer="USA" class="codeDesc">If ntk:AccessProfile has an ntk:AccessPolicy = 'urn:us:gov:ic:aces:ntk:restrictive',
      then ntk:AccessProfileValue/@ntk:vocabulary must start with 'group:'.</sch:p>

   <sch:rule context="ntk:AccessProfile[ntk:AccessPolicy='urn:us:gov:ic:aces:ntk:restrictive']/ntk:AccessProfileValue">
      <sch:assert test="starts-with(@ntk:vocabulary, 'group:')" flag="error">[NTK-ID-00038][Error] Use of the restrictive
         access policy requires a Group vocabulary type.</sch:assert>
   </sch:rule>
</sch:pattern>
