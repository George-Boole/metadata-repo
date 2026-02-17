<?xml version="1.0" encoding="utf-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:ism="urn:us:gov:ic:ism"
             xmlns:sch="http://purl.oclc.org/dsdl/schematron"
             id="IC-TDF-ID-00043">
    <sch:p class="ruleText"
           ism:ownerProducer="USA"
           ism:classification="U">[IC-TDF-ID-00043][Error] ntk:Access elements on portions of a TDO must be rolled up to the resource level. As such
           there must be an ntk:Access on the HandlingAssertion with scope [TDO]. Precise rollup is left to the creator to determine. Human Readable:
           If there is an ntk:Access in any portion of a TDO, then there must be an ntk:Access in the HandlingAssertion with scope="TDO"</sch:p>
    <sch:p class="codeDesc"
           ism:ownerProducer="USA"
           ism:classification="U">This rule triggers on any ntk:Access that exists except for one in the tdf:HandlingAssertion with a scope [TDO]. If
           it triggers it checks that there is an ntk:Access in the HandlingAssertion with scope [TDO] otherwise it sets an error.</sch:p>
    <sch:rule id="IC-TDF-ID-00043-R1"
              context="tdf:TrustedDataObject//ntk:Access[not(ancestor::tdf:HandlingAssertion[@tdf:scope='TDO'] or @ntk:externalReference=true())]">
        <sch:assert test="ancestor::tdf:TrustedDataObject/tdf:HandlingAssertion[@tdf:scope='TDO']//ntk:Access"
                    flag="error"
                    role="error">[IC-TDF-ID-00043][Error] If there is an ntk:Access in any portion of a TDO, then there must be an ntk:Access in the
                    HandlingAssertion with scope="TDO"</sch:assert>
    </sch:rule>
</sch:pattern>
