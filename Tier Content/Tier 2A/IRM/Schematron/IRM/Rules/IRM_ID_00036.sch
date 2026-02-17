<?xml version="1.0" encoding="utf-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:ism="urn:us:gov:ic:ism"
             xmlns:sch="http://purl.oclc.org/dsdl/schematron"
             id="IRM-ID-00036">
    <sch:p class="ruleText"
           ism:classification="U"
           ism:ownerProducer="USA">[IRM-ID-00036][Error] For any element, if any attribute is specified with the xlink namespace
           [http://www.w3.org/1999/xlink], then attributes @xlink:type and/or @xlink:href must be specified. Human Readable: If any XLink attributes
           are specified for an element, then the type and/or URL of the link must also be specified.</sch:p>
    <sch:p class="codeDesc"
           ism:classification="U"
           ism:ownerProducer="USA">Makes sure that for each element that has any attribute in the xlink namespace has either xlink:type or xlink:href
           specified.</sch:p>
    <sch:rule id="IRM-ID-00036-R1"
      context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//*[@xlink:*]">
              
        <sch:assert test="normalize-space(string(@xlink:type)) or normalize-space(string(@xlink:href))"
                    flag="error"
                    role="error">[IRM-ID-00036][Error] For any element, if any attribute is specified with the xlink namespace
                    [http://www.w3.org/1999/xlink], then attributes @xlink:type and/or @xlink:href must be specified. Human Readable: If any XLink
                    attributes are specified for an element, then the type and/or URL of the link must also be specified.</sch:assert>
    </sch:rule>
</sch:pattern>
