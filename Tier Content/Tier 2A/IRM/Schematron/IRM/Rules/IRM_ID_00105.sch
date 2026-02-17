<?xml version="1.0" encoding="utf-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:ism="urn:us:gov:ic:ism" xmlns:sch="http://purl.oclc.org/dsdl/schematron"
  id="IRM-ID-00105">
  <sch:p class="ruleText" ism:classification="U" ism:ownerProducer="USA">[IRM-ID-00105][Error] Use
    of the @irm:qualifier on the irm:nonStateActor element is required.</sch:p>
  <sch:p class="codeDesc" ism:classification="U" ism:ownerProducer="USA">If the irm:nonStateActor
    element is specified within a TDF assertion affected by an IRM assertion, then verify that the
    @irm:qualifier attribute is present on the element.</sch:p>
  <sch:rule id="IRM-ID-00105-R1"
    context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage[$IC_COMPLIANCE]//irm:nonStateActor">
    <sch:assert test="@irm:qualifier" flag="error" role="error">[IRM-ID-00105][Error] Use of the
      @irm:qualifier on the irm:nonStateActor element is required.</sch:assert>
  </sch:rule>
</sch:pattern>
