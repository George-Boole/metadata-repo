<?xml version="1.0" encoding="UTF-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" xmlns:ism="urn:us:gov:ic:ism" id="NTK-ID-00014">

    <sch:p ism:classification="U" ism:ownerProducer="USA" class="ruleText">[NTK-ID-00014][Error] For group-based PROPIN NTK assertions that
        contain ntk:ProfileDes elements, ntk:ProfileDes must specify the URN for Profile DES type: ‘grp-ind’.</sch:p>

    <sch:p ism:classification="U" ism:ownerProducer="USA" class="codeDesc">The value of ntk:ProfileDes element in a PROPIN NTK assertion (the ntk:AccessPolicy value
        starts with ‘urn:us:gov:ic:ntk:propin:’) must be ‘urn:us:gov:ic:ntk:profile:grp-ind’.</sch:p>

    <sch:rule context="ntk:AccessProfile[matches(ntk:AccessPolicy,'^urn:us:gov:ic:aces:ntk:propin:[1-2]$')]/ntk:ProfileDes">
        <sch:assert
            test=". = 'urn:us:gov:ic:ntk:profile:grp-ind'"
            flag="error">[NTK-ID-00014][Error] For group-based PROPIN NTK assertions that contain ntk:ProfileDes elements, ntk:ProfileDes must specify the 
            URN for Profile DES type: ‘grp-ind’.</sch:assert>
    </sch:rule>
</sch:pattern>
