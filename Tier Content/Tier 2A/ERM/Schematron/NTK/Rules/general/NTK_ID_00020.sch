<?xml version="1.0" encoding="UTF-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" xmlns:ism="urn:us:gov:ic:ism" id="NTK-ID-00020">
    <sch:p ism:classification="U" ism:ownerProducer="USA" class="ruleText">
        [NTK-ID-00020][Error] All vocabularies used must be of a builtin vocabulary type or 
        be defined in this ntk:AccessProfile in an ntk:VocabularyType. 
    </sch:p>
    <sch:p ism:classification="U" ism:ownerProducer="USA" class="codeDesc">
        For every AccessProfileValue element, verify that the value of the vocabulary attribute
        is either one of the builtin vocabulary types or defined in this AccessProfile.
    </sch:p>
    <sch:rule context="ntk:AccessProfileValue">
        <sch:let name="definedTypes" value="preceding-sibling::ntk:VocabularyType/@ntk:name"/>
        <sch:assert test="(some $value in $builtinVocab satisfies $value=@ntk:vocabulary)
            or (some $value in $definedTypes satisfies $value=@ntk:vocabulary)" flag="error">
            [NTK-ID-00020][Error] Undefined vocabulary type: <sch:value-of select="@ntk:vocabulary"/>. 
            All vocabularies used must be of a builtin vocabulary type or 
            be defined in this ntk:AccessProfile in an ntk:VocabularyType. 
        </sch:assert>
    </sch:rule>
</sch:pattern>
