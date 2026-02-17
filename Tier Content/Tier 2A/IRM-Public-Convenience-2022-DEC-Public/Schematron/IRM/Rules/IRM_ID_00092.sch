<?xml version="1.0" encoding="utf-8"?>
<sch:pattern xmlns:ism="urn:us:gov:ic:ism"
             xmlns:sch="http://purl.oclc.org/dsdl/schematron"
             id="IRM-ID-00092">
    <sch:p class="ruleText"
           ism:classification="U"
           ism:ownerProducer="USA">[IRM-ID-00092][Error] irm:NonStateActor should contain a value from the NonStateActor CVE</sch:p>
    <sch:p class="codeDesc"
           ism:classification="U"
           ism:ownerProducer="USA">Make sure that the value within NonStateActor is a value from the CVE.</sch:p>
    <sch:rule id="IRM-ID-00092-R1"
      context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:nonStateActor[@irm:qualifier='urn:us:gov:ic:cvenum:pm:nonstateactors']">

        <sch:assert test="some $token in $nonStateActorsList satisfies $token = normalize-space(./text())"
                    flag="error"
                    role="error">[IRM-ID-00092][Error] irm:NonStateActor should contain a value from the NonStateActor CVE</sch:assert>
    </sch:rule>
</sch:pattern>
