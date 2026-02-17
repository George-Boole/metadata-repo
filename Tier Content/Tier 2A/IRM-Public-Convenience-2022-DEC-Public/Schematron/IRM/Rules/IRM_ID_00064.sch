<?xml version="1.0" encoding="utf-8"?>
<?ICEA pattern?>
<?ICEA min_accessible?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:ism="urn:us:gov:ic:ism" xmlns:sch="http://purl.oclc.org/dsdl/schematron"
  id="IRM-ID-00064">
  <sch:p class="ruleText" ism:classification="U" ism:ownerProducer="USA">[IRM-ID-00064][Error]
    Element irm:ICResourceMetadataPackage/irm:dates must specify attribute @irm:created. Human
    Readable: The IRM card must specify the date on which the referenced resource was
    created.</sch:p>
  <sch:p class="codeDesc" ism:classification="U" ism:ownerProducer="USA">Make sure that element
    irm:ICResourceMetadataPackage/irm:dates exists and specifies attribute @irm:created.</sch:p>
  <sch:rule id="IRM-ID-00064-R1"
    context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage[$IC_COMPLIANCE]">
    <sch:assert test="irm:dates/@irm:created" flag="error" role="error">[IRM-ID-00064][Error]
      Element irm:ICResourceMetadataPackage/irm:dates must specify attribute @irm:created. Human
      Readable: The IRM card must specify the date on which the referenced resource was
      created.</sch:assert>
  </sch:rule>
</sch:pattern>
