<?xml version="1.0" encoding="UTF-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" xmlns:ism="urn:us:gov:ic:ism" id="NTK-ID-00022">

    <sch:p ism:classification="U" ism:ownerProducer="USA" class="ruleText">[NTK-ID-00022][Error] Datasphere Profile NTK assertions must use ‘datasphere’ vocabularies
        for access profile values.</sch:p>

    <sch:p ism:classification="U" ism:ownerProducer="USA" class="codeDesc">For NTK assertions that use the ‘urn:us:gov:ic:ntk:profile:datasphere’ profile DES,
        ntk:AccessProfileValue/@ntk:vocabulary must start with ‘datasphere:’.</sch:p>

    <sch:rule context="ntk:AccessProfile[ntk:ProfileDes = 'urn:us:gov:ic:ntk:profile:datasphere']/ntk:AccessProfileValue">
        <sch:assert test="starts-with(@ntk:vocabulary, 'datasphere:')" flag="error">[NTK-ID-00022][Error] For
            ntk:AccessProfileValue elements in Datasphere NTK assertions, the @ntk:vocabulary attribute must start with
            ‘datasphere:’.</sch:assert>
    </sch:rule>
</sch:pattern>
