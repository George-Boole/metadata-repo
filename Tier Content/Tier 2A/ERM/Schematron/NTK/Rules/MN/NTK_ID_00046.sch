<?xml version="1.0" encoding="UTF-8"?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" xmlns:ism="urn:us:gov:ic:ism" id="NTK-ID-00046">
    
    <sch:p ism:classification="U" ism:ownerProducer="USA" class="ruleText">[NTK-ID-00046][Error] 
        When both issues (datasphere:mn:issue) and regions (datasphere:mn:region) are specified
        for in a Mission Need NTK instance, the version of the list specified for both must be the 
        same.</sch:p>
    
    <sch:p ism:classification="U" ism:ownerProducer="USA" class="codeDesc">
        For Mission Need profile NTK instances that have Vocabulary Types of both issue and region,
        the verify that the @ntk:sourceVersion attribute values specified for both datasphere:mn:issue 
        and datasphere:mn:region are the same.
    </sch:p>
    
    <sch:rule context="ntk:AccessProfile[ntk:AccessPolicy = 'urn:us:gov:ic:aces:ntk:mn']
        [ntk:VocabularyType[@ntk:name='datasphere:mn:issue'] and ntk:VocabularyType[@ntk:name='datasphere:mn:region']]">
        <sch:assert 
            test="ntk:VocabularyType[@ntk:name='datasphere:mn:issue']/@ntk:sourceVersion 
                  = ntk:VocabularyType[@ntk:name='datasphere:mn:region']/@ntk:sourceVersion">
            [NTK-ID-00046][Error] When both issues (datasphere:mn:issue) and regions (datasphere:mn:region) are specified
            for in a Mission Need NTK instance, the version of the list specified for both must be the 
            same.
        </sch:assert>
    </sch:rule>
</sch:pattern>