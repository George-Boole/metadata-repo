<?xml version="1.0" encoding="UTF-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" xmlns:ism="urn:us:gov:ic:ism" id="NTK-ID-00010">

    <sch:p ism:classification="U" ism:ownerProducer="USA" class="ruleText">[NTK-ID-00010][Error] Mission Need NTK assertions must use the “datasphere” profile
        DES.</sch:p>

    <sch:p ism:classification="U" ism:ownerProducer="USA" class="codeDesc">ntk:AccessProfile elements that have an ntk:AccessPolicy child with the MN value
        (urn:us:gov:ic:aces:ntk:mn) must have an ntk:ProfileDes with the datasphere value
        (urn:us:gov:ic:ntk:profile:datasphere).</sch:p>

    <sch:rule context="ntk:AccessProfile[ntk:AccessPolicy = 'urn:us:gov:ic:aces:ntk:mn']/ntk:ProfileDes">
        <sch:assert test=". = 'urn:us:gov:ic:ntk:profile:datasphere'" flag="error">[NTK-ID-00010][Error] Mission Need
            NTK assertions must use the “datasphere” profile DES.</sch:assert>
    </sch:rule>
</sch:pattern>
