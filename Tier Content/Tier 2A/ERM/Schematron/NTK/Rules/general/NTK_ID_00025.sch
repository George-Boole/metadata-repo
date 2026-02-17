<?xml version="1.0" encoding="UTF-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" xmlns:ism="urn:us:gov:ic:ism" id="NTK-ID-00025">
    <sch:p ism:classification="U" ism:ownerProducer="USA" class="ruleText">
        [NTK-ID-00025][Error] Sources cannot be overridden. If a
        built-in vocabulary type is specified and the source 
        attribute is present it must equal the built-in source.
    </sch:p>
    <sch:p ism:classification="U" ism:ownerProducer="USA" class="codeDesc">
        When a builtin vocabulary is specified in an ntk:VocabularyType element and the source
        attribute is present, then verify that the source specified matches the built in source 
        value.
    </sch:p>
    <sch:rule context="ntk:VocabularyType[index-of($builtinVocab, @ntk:name) > 0 and @ntk:source]">
        <sch:let name="index" value="index-of($builtinVocab, @ntk:name)"/>
        <sch:assert test="@ntk:source=$builtinVocabSource[$index]" flag="error">
            [NTK-ID-00025][Error] Sources cannot be overridden. If a
            built-in vocabulary type is specified and the source attribute is present it must equal
            the built-in source. The source [<sch:value-of select="@ntk:source"/>] is invalid with
            respect to the vocabulary type [<sch:value-of select="@ntk:name"/>]. A source of
            [<sch:value-of select="$builtinVocabSource[$index]"/>] is expected.
        </sch:assert>
    </sch:rule>
</sch:pattern>
