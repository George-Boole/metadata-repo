<?xml version="1.0" encoding="UTF-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" xmlns:ism="urn:us:gov:ic:ism" id="NTK-ID-00040">
   
   <sch:p ism:classification="U" ism:ownerProducer="USA" class="ruleText">[NTK-ID-00040][Error] EXDIS requires the USA-Agency Vocabulary
      (organization:usa-agency).</sch:p>
   
   <sch:p ism:classification="U" ism:ownerProducer="USA" class="codeDesc">
      If AccessPolicy for the AccessProfile is EXDIS, then the vocabulary for the AccessProfileValue must be USA-Agency.
   </sch:p>
   
   <sch:rule context="ntk:AccessProfile[ntk:AccessPolicy = 'urn:us:gov:ic:aces:ntk:xd']/ntk:AccessProfileValue">
      <sch:assert test="@ntk:vocabulary = 'organization:usa-agency'">[NTK-ID-00040][Error] EXDIS requires the USA-Agency
         Vocabulary (organization:usa-agency).</sch:assert>
   </sch:rule>
</sch:pattern>
