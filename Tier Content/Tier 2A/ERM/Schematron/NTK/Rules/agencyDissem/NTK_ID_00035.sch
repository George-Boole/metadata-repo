<?xml version="1.0" encoding="UTF-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" xmlns:ism="urn:us:gov:ic:ism" id="NTK-ID-00035">
   <sch:p ism:classification="U" ism:ownerProducer="USA" class="ruleText">[NTK-ID-00035][Error] The @ntk:qualifier attribute value of either ‘originator’ or ‘dissemto’
      is required on every AccessProfileValue element for NTK Access Profiles based on the Agency Dissemination profile
      DES.</sch:p>

   <sch:p ism:classification="U" ism:ownerProducer="USA" class="codeDesc">Given an ntk:AccessProfile with an ntk:ProfileDes value of
      ‘urn:us:gov:ic:ntk:profile:agencydissem’, one of ntk:AccessProfileValue/@qualifier='originator' or
      ntk:AccessProfileValue/@qualifier='dissemto' must exist.</sch:p>

   <sch:rule context="ntk:AccessProfile[ntk:ProfileDes='urn:us:gov:ic:ntk:profile:agencydissem']/ntk:AccessProfileValue">
      <sch:assert test="@ntk:qualifier = 'originator' or @ntk:qualifier = 'dissemto'">[NTK-ID-00035][Error] The
         @ntk:qualifier attribute value of either ‘originator’ or ‘dissemto’ is required on every AccessProfileValue
         element for NTK Access Profiles based on the Agency Dissemination profile DES.</sch:assert>
   </sch:rule>
</sch:pattern>
