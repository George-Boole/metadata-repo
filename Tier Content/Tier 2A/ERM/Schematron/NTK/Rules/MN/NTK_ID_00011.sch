<?xml version="1.0" encoding="UTF-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" xmlns:ism="urn:us:gov:ic:ism" id="NTK-ID-00011">

    <sch:p ism:classification="U" ism:ownerProducer="USA" class="ruleText">[NTK-ID-00011][Error] The Access Profile Value for MN NTK assertions must use the
        appropriate subject or region vocabulary.</sch:p>

    <sch:p ism:classification="U" ism:ownerProducer="USA" class="codeDesc">Given an MN NTK assertion (ntk:AccessPolicy = 'urn:us:gov:ic:aces:ntk:mn'), the
        ntk:AccessProfileValue elements ntk:vocabulary attribute must be either
        'datasphere:mn:issue' or 'datasphere:mn:region'.</sch:p>

    <sch:rule context="ntk:AccessProfile[ntk:AccessPolicy = 'urn:us:gov:ic:aces:ntk:mn']/ntk:AccessProfileValue">
        <sch:assert
            test="@ntk:vocabulary = 'datasphere:mn:issue' or @ntk:vocabulary = 'datasphere:mn:region'"
            flag="error">[NTK-ID-00011][Error] The Access Profile Value for MN NTK assertions must use the appropriate
            subject or region vocabulary.</sch:assert>
    </sch:rule>
</sch:pattern>
