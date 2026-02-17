<?xml version="1.0" encoding="utf-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:ism="urn:us:gov:ic:ism"
             xmlns:sch="http://purl.oclc.org/dsdl/schematron"
             id="IC-TDF-ID-00028">
    <sch:p class="ruleText"
           ism:ownerProducer="USA"
           ism:classification="U">[IC-TDF-ID-00028][Error] If payload attribute @isEncrypted="true" and the payload is not external, the handling
           assertion with @scope="PAYL" that contains @appliesToState="encrypted" must contain a regular edh:EDH. Human Readable: Internal content
           requires an EDH.</sch:p>
    <sch:p class="codeDesc"
           ism:ownerProducer="USA"
           ism:classification="U">Given a TDO with an internal payload with attribute @isEncrypted="true", the handling assertion with @scope="PAYL"
           that contains @appliesToState="encrypted" must contain a regular edh:EDH.</sch:p>
    <sch:rule id="IC-TDF-ID-00028-R1"
              context="tdf:TrustedDataObject[tdf:StringPayload/@tdf:isEncrypted=true()] | tdf:TrustedDataObject[tdf:Base64BinaryPayload/@tdf:isEncrypted=true()] | tdf:TrustedDataObject[tdf:StructuredPayload/@tdf:isEncrypted=true()]">

        <sch:assert test="count(tdf:HandlingAssertion[util:containsAnyOfTheTokens(@tdf:scope, ('PAYL')) and @tdf:appliesToState='encrypted']/tdf:HandlingStatement/edh:Edh)= 1"
                    flag="error"
                    role="error">[IC-TDF-ID-00028][Error] If payload attribute @isEncrypted="true" and the payload is not external, the handling
                    assertion with @scope="PAYL" that contains @appliesToState="encrypted" must contain a regular edh:EDH. Human Readable: Internal
                    content requires an EDH.</sch:assert>
    </sch:rule>
</sch:pattern>
