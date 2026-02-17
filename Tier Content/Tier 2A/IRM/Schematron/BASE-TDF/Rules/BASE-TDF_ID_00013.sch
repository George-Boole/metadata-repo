<?xml version="1.0" encoding="utf-8"?>
<?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:ism="urn:us:gov:ic:ism" xmlns:sch="http://purl.oclc.org/dsdl/schematron"
  id="BASE-TDF-ID-00013">
  <sch:p class="ruleText" ism:ownerProducer="USA" ism:classification="U">[BASE-TDF-ID-00013][Error]
    For any element which specifies attribute scope containing [EXPLICIT], then element
    Binding/BoundValueList or element ReferenceList must be specified. Human Readable: Assertions
    with explicit scope require either a BoundValueList or a ReferenceList to identify the elements
    for which the assertion applies.</sch:p>
  <sch:p class="codeDesc" ism:ownerProducer="USA" ism:classification="U">For elements which specify
    attribute scope with a value of [EXPLICIT], this rule ensures that element
    Binding/BoundValueList or ReferenceList is specified.</sch:p>
  <sch:rule id="BASE-TDF-ID-00013-R1" context="*[normalize-space(string(@tdf:scope)) = 'EXPLICIT']">
    <sch:assert test="tdf:Binding/tdf:BoundValueList or tdf:ReferenceList" flag="error" role="error"
      >[BASE-TDF-ID-00013][Error] For any element which specifies attribute scope containing
      [EXPLICIT], then element Binding/BoundValueList or element ReferenceList must be specified.
      Human Readable: Assertions with explicit scope require either a BoundValueList or a
      ReferenceList to identify the elements for which the assertion applies.</sch:assert>
  </sch:rule>
</sch:pattern>
