<?xml version="1.0" encoding="utf-8"?>
<?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:ism="urn:us:gov:ic:ism" xmlns:sch="http://purl.oclc.org/dsdl/schematron"
    id="BASE-TDF-ID-00004">
    <sch:p class="ruleText" ism:ownerProducer="USA" ism:classification="U"
        >[BASE-TDF-ID-00004][Error] Attribute @appliesToState is only allowed on HandlingAssertions
        with scope PAYL. Human Readable: Only Handling Assertions with scope PAYL can use the
        appliesToState attribute because the attribute indicates the state (encrypted or
        unencrypted) of the payload to which the assertion applies.</sch:p>
    <sch:p class="codeDesc" ism:ownerProducer="USA" ism:classification="U">If attribute
        @appliesToState is defined on a handlingAssertion, this rule ensures that handlingAssertion
        has scope PAYL</sch:p>
    <sch:rule id="BASE-TDF-ID-00004-R1"
        context="tdf:TrustedDataObject/tdf:HandlingAssertion[@tdf:appliesToState]">
        <sch:assert test="@tdf:scope = 'PAYL'" flag="error" role="error">[BASE-TDF-ID-00004][Error]
            Attribute @appliesToState is only allowed with HandlingAssertions of scope PAYL Human
            Readable: Only Handling Assertions with scope PAYL can use the appliesToState attribute
            because the attribute indicates the state (encrypted or unencrypted) of the payload to
            which the assertion applies.</sch:assert>
    </sch:rule>
</sch:pattern>
