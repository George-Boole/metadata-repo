<?xml version="1.0" encoding="utf-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:ism="urn:us:gov:ic:ism" xmlns:sch="http://purl.oclc.org/dsdl/schematron"
  id="IRM-ID-00104">
  <sch:p class="ruleText" ism:classification="U" ism:ownerProducer="USA">[IRM-ID-00104][Error] If
    element irm:organization has attribute @irm:acronym specified and @irm:acronym has a country
    prefix, then the agency suffix after the dot delimiter must be of type NmToken.</sch:p>
  <sch:p class="codeDesc" ism:classification="U" ism:ownerProducer="USA">For irm:organization that
    have @irm:acronym, the agency suffix after the dot delimiter must be of type NmToken.</sch:p>
  <sch:rule id="IRM-ID-00104-R1"
    context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage[$IC_COMPLIANCE]//irm:organization[@irm:acronym]">

    <sch:assert test="util:meetsType(substring-after(@irm:acronym, '.'), $NmTokenPattern)"
      flag="error" role="error">[IRM-ID-00104][Error] If element irm:organization has attribute
      @irm:acronym specified, then the agency suffix after the dot delimiter must be of type
      NmToken. Found <sch:value-of select="normalize-space(@irm:acronym)"/> substring was:
        <sch:value-of select="substring-after(@irm:acronym, '.')"/>
    </sch:assert>
  </sch:rule>
</sch:pattern>
