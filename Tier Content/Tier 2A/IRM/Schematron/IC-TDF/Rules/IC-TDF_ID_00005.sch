<?xml version="1.0" encoding="utf-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:ism="urn:us:gov:ic:ism"
             xmlns:sch="http://purl.oclc.org/dsdl/schematron"
             id="IC-TDF-ID-00005">
    <sch:p class="ruleText"
           ism:ownerProducer="USA"
           ism:classification="U">[IC-TDF-ID-00005][Error] For element TrustedDataCollection, there must be exactly one element HandlingAssertion
           that specifies @scope="TDC" and contains an EDH element. Human Readable: There must exist a single EDH HandlingAssertion scoped for the
           entire TrustedDataCollection.</sch:p>
    <sch:p class="codeDesc"
           ism:ownerProducer="USA"
           ism:classification="U">For element TrustedDataCollection, this rule ensures that the count of HandlingAssertion elements that specify
           attribute scope containing [TDC] and contain an EDH element is exactly 1.</sch:p>
    <sch:rule id="IC-TDF-ID-00005-R1"
              context="tdf:TrustedDataCollection">
        <sch:assert test="count(child::tdf:HandlingAssertion[child::tdf:HandlingStatement/edh:Edh and @tdf:scope = 'TDC'])= 1"
                    flag="error"
                    role="error">[IC-TDF-ID-00005][Error] For element TrustedDataCollection, there must be exactly one element HandlingAssertion that
                    specifies @scope="TDC" and contains an EDH element. Human Readable: There must exist a single EDH HandlingAssertion scoped for
                    the entire TrustedDataCollection.</sch:assert>
    </sch:rule>
</sch:pattern>
