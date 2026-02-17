<?xml version="1.0" encoding="UTF-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" xmlns:ism="urn:us:gov:ic:ism" id="NTK-ID-00012">

    <sch:p ism:classification="U" ism:ownerProducer="USA" class="ruleText">[NTK-ID-00012][Error] The Access Profile Value must not have an @ntk:qualifier attribute
        specified for MN NTK assertions.</sch:p>

    <sch:p ism:classification="U" ism:ownerProducer="USA" class="codeDesc">Given an MN NTK assertion (ntk:AccessPolicy = 'urn:us:gov:ic:ntk:profile:mn'), the
        ntk:AccessProfileValue/@ntk:qualifier attribute is not allowed.</sch:p>

    <sch:rule context="ntk:AccessProfile[ntk:AccessPolicy = 'urn:us:gov:ic:aces:ntk:mn']/ntk:AccessProfileValue">
        <sch:assert test="not(@ntk:qualifier)" flag="error">[NTK-ID-00012][Error] The Access Profile Value must not have
            an @ntk:qualifier attribute specified for MN NTK assertions.</sch:assert>
    </sch:rule>
</sch:pattern>
