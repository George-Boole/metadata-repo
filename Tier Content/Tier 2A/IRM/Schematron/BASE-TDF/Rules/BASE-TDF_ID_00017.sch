<?xml version="1.0" encoding="utf-8"?>
<?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:ism="urn:us:gov:ic:ism"
             xmlns:sch="http://purl.oclc.org/dsdl/schematron"
             id="BASE-TDF-ID-00017">
    <sch:p class="ruleText" ism:ownerProducer="USA" ism:classification="U">[BASE-TDF-ID-00017][Error] For any handling assertion child element of TrustedDataCollection, the only allowable
           token for attribute scope is [TDC]. Human Readable: Scopes defined within a TrustedDataCollection Handling Assertion must refer to entire
           TrustedDataCollection.</sch:p>
    <sch:p class="codeDesc" ism:ownerProducer="USA" ism:classification="U">For the scope attribute specified on handlingAssertion child elements of TrustedDataCollection, make sure that
           the value only contains the tokens [TDC].</sch:p>
    <sch:rule id="BASE-TDF-ID-00017-R1"
             context="tdf:TrustedDataCollection/tdf:HandlingAssertion">
        <sch:assert test="util:containsOnlyTheTokens(@tdf:scope, ('TDC'))"
                  flag="error"
                  role="error">[BASE-TDF-ID-00017][Error] For any child handlingAssertion of TrustedDataCollection, the only allowable tokens for
                    attribute scope is [TDC]. Human Readable: Scopes defined within a TrustedDataCollection Handling Assertion must refer to entire
                    TrustedDataCollection.</sch:assert>
    </sch:rule>
</sch:pattern>
