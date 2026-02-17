<?xml version="1.0" encoding="utf-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:ism="urn:us:gov:ic:ism"
             xmlns:sch="http://purl.oclc.org/dsdl/schematron"
             id="IRM-ID-00002">
    <sch:p class="ruleText"
           ism:classification="U"
           ism:ownerProducer="USA">[IRM-ID-00002][Error] For every attribute in the namespace [urn:us:gov:ic:irm], a non-whitespace value must be
           specified. Human Readable:</sch:p>
    <sch:p class="codeDesc"
           ism:classification="U"
           ism:ownerProducer="USA">For each element which specifies an attribute in the IRM namespace, ensure that each attribute in the IRM
           namespace specifies a non-whitespace value.</sch:p>
    <sch:rule id="IRM-ID-00002-R1"
          context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//*[@*[namespace-uri() = ('urn:us:gov:ic:irm')]]">

        <sch:assert test=" every $attribute in @*[namespace-uri() = ('urn:us:gov:ic:irm')] satisfies normalize-space(string($attribute))"
                    flag="error"
                    role="error">[IRM-ID-00002][Error] For every attribute in the namespace [urn:us:gov:ic:irm], a non-whitespace value must be
                    specified. Human Readable:</sch:assert>
    </sch:rule>
</sch:pattern>
