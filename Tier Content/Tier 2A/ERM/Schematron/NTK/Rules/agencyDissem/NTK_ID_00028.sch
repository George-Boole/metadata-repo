<?xml version="1.0" encoding="UTF-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" xmlns:ism="urn:us:gov:ic:ism" id="NTK-ID-00028">
    <sch:p ism:classification="U" ism:ownerProducer="USA" class="ruleText">
        [NTK-ID-00028][Error] An Agency Dissemination NTK must have one and only one entry
        qualified as the originator.
    </sch:p>
    <sch:p ism:classification="U" ism:ownerProducer="USA" class="codeDesc">
        For every ntk:AccessProfile with an ntk:ProfileDes of [urn:us:gov:ic:ntk:profile:agencydissem], this rule ensures
        that it has one and only one ntk:AccessProfileValue element with an @ntk:qualifier of
        [originator].
    </sch:p>
    <sch:rule context="ntk:AccessProfile[ntk:ProfileDes='urn:us:gov:ic:ntk:profile:agencydissem']">
        <sch:assert test="count(ntk:AccessProfileValue[@ntk:qualifier='originator']) = 1">
            [NTK-ID-00028][Error] An Agency Dissemination NTK must have one and only one entry
            qualified as the originator.
        </sch:assert>
    </sch:rule>
</sch:pattern>