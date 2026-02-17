<?xml version="1.0" encoding="utf-8"?>
<?ICEA pattern?>
<?ICEA min_accessible?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:ism="urn:us:gov:ic:ism" xmlns:sch="http://purl.oclc.org/dsdl/schematron"
  id="IRM-ID-00065">
  <sch:p class="ruleText" ism:classification="U" ism:ownerProducer="USA">[IRM-ID-00065][Error]
    Attribute irm:ICResourceMetadataPackage/irm:dates/@irm:created must be castable as an
    xs:dateTime type. Human Readable: The date on which the referenced resource was created must be
    a dateTime type.</sch:p>
  <sch:p class="codeDesc" ism:classification="U" ism:ownerProducer="USA">Make sure that attribute
    dms:resource/irm:dates/@irm:created is castable as an xs:dateTime type.</sch:p>
  <sch:rule id="IRM-ID-00065-R1"
    context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage/irm:dates[@irm:created]">

    <sch:assert test="@irm:created castable as xs:dateTime" flag="error" role="error"
      >[IRM-ID-00065][Error] Attribute irm:ICResourceMetadataPackage/irm:dates/@irm:created must be
      castable as an xs:dateTime type. Human Readable: The date on which the referenced resource was
      created must be a dateTime type.</sch:assert>
  </sch:rule>
</sch:pattern>
