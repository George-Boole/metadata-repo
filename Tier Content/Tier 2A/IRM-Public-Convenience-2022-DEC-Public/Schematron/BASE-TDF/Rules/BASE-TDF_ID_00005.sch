<?xml version="1.0" encoding="utf-8"?>
<?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:ism="urn:us:gov:ic:ism"
             xmlns:sch="http://purl.oclc.org/dsdl/schematron"
             id="BASE-TDF-ID-00005">
    <sch:p class="ruleText" ism:ownerProducer="USA" ism:classification="U">[BASE-TDF-ID-00005][Error] All attributes in the TDF namespace MUST contain a non-whitespace value. Human Readable:
           All attributes in the TDF namespace must specify a value.</sch:p>
    <sch:p class="codeDesc" ism:ownerProducer="USA" ism:classification="U">For all attributes in the tdf namespace, this rule ensures that each contains a non-whitespace value.</sch:p>
    <sch:rule id="BASE-TDF-ID-00005-R1" context="*[@tdf:*]">
        <sch:assert test="every $attribute in @tdf:* satisfies normalize-space(string($attribute))"
                  flag="error"
                  role="error">[BASE-TDF-ID-00005][Error] All attributes in the TDF namespace must specify a value.</sch:assert>
    </sch:rule>
</sch:pattern>
