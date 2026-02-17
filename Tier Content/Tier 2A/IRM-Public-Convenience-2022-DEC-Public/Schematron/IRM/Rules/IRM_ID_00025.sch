<?xml version="1.0" encoding="utf-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:ism="urn:us:gov:ic:ism"
             xmlns:sch="http://purl.oclc.org/dsdl/schematron"
             id="IRM-ID-00025">
    <sch:p class="ruleText"
           ism:classification="U"
           ism:ownerProducer="USA">[IRM-ID-00025][Error] The attribute @ism:excludeFromRollup must not be specified for any element in the namespace
           [urn:us:gov:ic:irm] in a TDF IRM assertion. Human readable: Elements in IRM TDF assertions are not allowed to be excluded from roll-up
           because the security markings are now in the TDF assertion statement metadata.</sch:p>
    <sch:p class="codeDesc"
           ism:classification="U"
           ism:ownerProducer="USA">The attribute @ism:excludeFromRollup must not be specified for any element in the namespace [urn:us:gov:ic:irm] in
           a TDF IRM assertion.</sch:p>
    <sch:rule id="IRM-ID-00025-R1"
          context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:*">
        <sch:assert test="not(@ism:excludeFromRollup)"
                    flag="error"
                    role="error">[IRM-ID-00025][Error]The attribute @ism:excludeFromRollup must not be specified for any element in the namespace
                    [urn:us:gov:ic:irm] in a TDF IRM assertion. Human readable: Elements in IRM TDF assertions are not allowed to be excluded from
                    roll-up because the security markings are now in the TDF assertion statement metadata.</sch:assert>
    </sch:rule>
</sch:pattern>
