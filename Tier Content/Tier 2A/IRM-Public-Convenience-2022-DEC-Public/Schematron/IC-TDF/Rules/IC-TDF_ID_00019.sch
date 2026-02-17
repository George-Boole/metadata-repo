<?xml version="1.0" encoding="utf-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:ism="urn:us:gov:ic:ism"
             xmlns:sch="http://purl.oclc.org/dsdl/schematron"
             id="IC-TDF-ID-00019">
    <sch:p class="ruleText"
           ism:ownerProducer="USA"
           ism:classification="U">[IC-TDF-ID-00019][Error] HandlingAssertions with scope containing the token [TDC] cannot use the ExternalEdh child
           element. Human Readable: When a HandlingAssertion has scope pertaining to the entire TrustedDataCollection (TDC), it must never use the
           ExternalEdh child element because the HandlingAssertion will always refer to the Collection in which it resides.</sch:p>
    <sch:p class="codeDesc"
           ism:ownerProducer="USA"
           ism:classification="U">Where a HandlingAssertion exists with scope containing [TDC], this rule ensures that it does not have a child of
           ExternalEdh.</sch:p>
    <sch:rule id="IC-TDF-ID-00019-R1"
              context="tdf:HandlingAssertion[util:containsAnyOfTheTokens(@tdf:scope, ('TDC'))]">
        <sch:assert test="not(descendant::edh:ExternalEdh)"
                    flag="error"
                    role="error">[IC-TDF-ID-00019][Error] HandlingAssertions with scope containing the token [TDC] cannot use the ExternalEdh child
                    element. Human Readable: When a HandlingAssertion has scope pertaining to the entire TrustedDataCollection (TDC), it must never
                    use the ExternalEdh child element because the HandlingAssertion will always refer to the Collection in which it
                    resides.</sch:assert>
    </sch:rule>
</sch:pattern>
