<?xml version="1.0" encoding="UTF-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" xmlns:ism="urn:us:gov:ic:ism" id="NTK-ID-00015">
    
    <sch:p ism:classification="U" ism:ownerProducer="USA" class="ruleText">[NTK-ID-00015][Error] Propin NTK assertions that use the urn:us:gov:ic:aces:ntk:propin:2
        access policy MUST specify a Profile DES.</sch:p>
    
    <sch:p ism:classification="U" ism:ownerProducer="USA" class="codeDesc">If an ntk:AccessProfile has an ntk:AccessPolicy element that has a value of
        ‘urn:us:gov:ic:aces:ntk:propin:2’, then an ntk:ProfileDes MUST be specified.</sch:p>
    
    <sch:rule context="ntk:AccessProfile[ntk:AccessPolicy = 'urn:us:gov:ic:aces:ntk:propin:2']">
        <sch:assert test="ntk:ProfileDes" flag="error">[NTK-ID-00015][Error] NTK assertions that use the
            ‘urn:us:gov:ic:aces:ntk:propin:2’ access policy must specify an ntk:ProfileDes element.</sch:assert>
    </sch:rule>
</sch:pattern>
