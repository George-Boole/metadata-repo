<?xml version="1.0" encoding="UTF-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" xmlns:ism="urn:us:gov:ic:ism" id="NTK-ID-00013">

    <sch:p ism:classification="U" ism:ownerProducer="USA" class="ruleText">[NTK-ID-00013][Error] If Vocabulary Type is specified in an MN NTK assertion, it must
        specify a version for either the issue (datasphere:mn:issue) or region (datasphere:mn:region)
        vocabularies.</sch:p>

    <sch:p ism:classification="U" ism:ownerProducer="USA" class="codeDesc">If an ntk:VocabularyType element exists in an MN NTK assertion
        (ntk:VocabularyType[../ntk:AccessPolicy = 'urn:us:gov:ic:aces:ntk:mn']), then (1) @ntk:name must be
        ‘datasphere:mn:issue’ or ‘datasphere:mn:region’ and (2) the @ntk:sourceVersion attribute is required.</sch:p>

    <sch:rule context="ntk:AccessProfile[ntk:AccessPolicy = 'urn:us:gov:ic:aces:ntk:mn']/ntk:VocabularyType">
        <sch:assert test="@ntk:sourceVersion">[NTK-ID-00013][Error] The @ntk:sourceVersion attribute is
            required.</sch:assert>
        <sch:assert test="@ntk:name = 'datasphere:mn:issue' or @ntk:name = 'datasphere:mn:region'">[NTK-ID-00013][Error] The
            name attribute must be ‘datasphere:mn:issue’ or ‘datasphere:mn:region’.</sch:assert>
    </sch:rule>
</sch:pattern>
