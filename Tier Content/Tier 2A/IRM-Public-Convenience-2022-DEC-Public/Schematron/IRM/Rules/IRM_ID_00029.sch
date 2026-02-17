<?xml version="1.0" encoding="utf-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:ism="urn:us:gov:ic:ism" xmlns:sch="http://purl.oclc.org/dsdl/schematron"
  id="IRM-ID-00029">
  <sch:p class="ruleText" ism:classification="U" ism:ownerProducer="USA">[IRM-ID-00029][Error] If
    element irm:geospatialCoverage has attribute @irm:precedence with a value of [Secondary], there
    must be at least one sibling element irm:geospatialCoverage for which attribute @irm:precedence
    has a value of [Primary]. Human Readable: If a secondary country code is provided, there must
    also be a primary country code.</sch:p>
  <sch:p class="codeDesc" ism:classification="U" ism:ownerProducer="USA">If there is an element
    geospatialCoverage with attribute precedence specified with a value of [Secondary], make sure
    that there is at least one sibling geospatialCoverage element with attribute precedence
    specified with a value of [Primary].</sch:p>
  <sch:rule id="IRM-ID-00029-R1"
    context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:geospatialCoverage[@irm:precedence = 'Secondary']">

    <sch:assert test="../irm:geospatialCoverage[@irm:precedence = 'Primary']" flag="error"
      role="error">[IRM-ID-00029][Error] If element irm:geospatialCoverage has attribute
      @irm:precedence with a value of [Secondary], there must be at least one sibling element
      irm:geospatialCoverage for which attribute @irm:precedence has a value of [Primary]. Human
      Readable: If a secondary country code is provided, there must also be a primary country
      code.</sch:assert>
  </sch:rule>
</sch:pattern>
