<?xml version="1.0" encoding="UTF-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" xmlns:ism="urn:us:gov:ic:ism" id="NTK-ID-00019">
    <sch:p ism:classification="U" ism:ownerProducer="USA" class="ruleText">
        [NTK-ID-00019][Error] VocabularyTypes must have a source unless being derived from 
        an existing built-in type.
    </sch:p>
    <sch:p ism:classification="U" ism:ownerProducer="USA" class="codeDesc">
        For each VocabularyType that does not have a source, make sure that it is one of the built-in types
        or otherwise already declared with a source.
    </sch:p>
    <sch:rule context="ntk:VocabularyType[not(@ntk:source)]">
        
        <sch:assert test="(some $type in $builtinVocab satisfies $type=@ntk:name)" flag="error">
            [NTK-ID-00019][Error] VocabularyTypes must have a source unless being derived from 
            an existing built-in type.
        </sch:assert>
    </sch:rule>
</sch:pattern>
