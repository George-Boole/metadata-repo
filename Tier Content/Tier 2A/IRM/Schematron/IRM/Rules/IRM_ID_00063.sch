<?xml version="1.0" encoding="utf-8"?>
<?ICEA pattern?>
<?ICEA min_accessible?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:ism="urn:us:gov:ic:ism" xmlns:sch="http://purl.oclc.org/dsdl/schematron"
  id="IRM-ID-00063">
  <sch:p class="ruleText" ism:classification="U" ism:ownerProducer="USA">[IRM-ID-00063][Error]
    Element irm:ICResourceMetadataPackage/irm:creator/irm:organization must specify attribute
    @irm:acronym. Human Readable: The IRM card must specify a creator organization with an IC
    agency acronym for the referenced resource.</sch:p>
  <sch:p class="codeDesc" ism:classification="U" ism:ownerProducer="USA">Make sure that element
    irm:ICResourceMetadataPackage/irm:creator/irm:organization exists and specifies attribute
    @irm:acronym.</sch:p>
  <sch:rule id="IRM-ID-00063-R1"
    context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage[$IC_COMPLIANCE]">
    <sch:assert test="irm:creator/irm:organization/@irm:acronym" flag="error" role="error"
      >[IRM-ID-00063][Error] Element irm:ICResourceMetadataPackage/irm:creator/irm:organization must
      specify attribute @irm:acronym. Human Readable: The IRM card must specify a creator
      organization with an IC agency acronym for the referenced resource.</sch:assert>
  </sch:rule>
</sch:pattern>
