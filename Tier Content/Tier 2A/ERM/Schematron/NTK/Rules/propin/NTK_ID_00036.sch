<?xml version="1.0" encoding="UTF-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" xmlns:ism="urn:us:gov:ic:ism" id="NTK-ID-00036">

   <sch:p ism:classification="U" ism:ownerProducer="USA" class="ruleText">[NTK-ID-00036][Error] PROPIN access policies must have characters after the predefined
      portion ‘urn:us:gov:ic:aces:ntk:propin:’.</sch:p>

   <sch:p ism:classification="U" ism:ownerProducer="USA" class="codeDesc">Given an ntk:AccessPolicy that starts with ‘urn:us:gov:ic:aces:ntk:propin:’, the string
      length must be greater than 30 (that is, there must be characters after the predefined portion).</sch:p>

   <sch:rule context="ntk:AccessPolicy[starts-with(., 'urn:us:gov:ic:aces:ntk:propin:')]">
      <sch:assert test="string-length(.) > 30" flag="error">[NTK-ID-00036][Error] PROPIN access policies
         must have characters after the predefined portion ‘urn:us:gov:ic:aces:ntk:propin:’.</sch:assert>
   </sch:rule>
</sch:pattern>
