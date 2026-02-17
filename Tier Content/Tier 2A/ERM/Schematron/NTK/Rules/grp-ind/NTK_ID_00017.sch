<?xml version="1.0" encoding="UTF-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" xmlns:ism="urn:us:gov:ic:ism" id="NTK-ID-00017">

    <sch:p ism:classification="U" ism:ownerProducer="USA" class="ruleText">[NTK-ID-00017][Error] Grp-ind Profile NTK assertions must use appropriate ‘group’ and
        ‘individual’ vocabularies for access profile values.</sch:p>

    <sch:p ism:classification="U" ism:ownerProducer="USA" class="codeDesc">For NTK assertions that use the ‘urn:us:gov:ic:ntk:profile:group’ profile DES,
        ntk:AccessProfileValue/@ntk:vocabulary must start with ‘group:’ or ‘individual:’.</sch:p>

    <sch:rule context="ntk:AccessProfile[ntk:ProfileDes = 'urn:us:gov:ic:ntk:profile:grp-ind']/ntk:AccessProfileValue">
        <sch:assert test="starts-with(@ntk:vocabulary, 'group:') or starts-with(@ntk:vocabulary, 'individual:')"
            flag="error">[NTK-ID-00017][Error] The @ntk:vocabulary attribute must start with ‘group:’ or
            ‘individual:’.</sch:assert>
    </sch:rule>
</sch:pattern>
