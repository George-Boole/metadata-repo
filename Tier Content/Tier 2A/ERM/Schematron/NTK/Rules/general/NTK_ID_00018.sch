<?xml version="1.0" encoding="UTF-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" xmlns:ism="urn:us:gov:ic:ism" id="NTK-ID-00018">
    <sch:p ism:classification="U" ism:ownerProducer="USA" class="ruleText">
        [NTK-ID-00018][Error] Vocabulary declarations must have a root from one of the built-in 
        types of 'datasphere', 'organization', 'individual', or 'group'. Declaration of custom
        root types are not permitted.
    </sch:p>
    <sch:p ism:classification="U" ism:ownerProducer="USA" class="codeDesc">
        For all VocabularyType names, ensure that they are all linked to a built-in root vocabulary type.
    </sch:p>
    <sch:rule context="ntk:VocabularyType[@ntk:name]">
        <sch:let name="root" value="substring-before(@ntk:name,':')"/>
        <sch:assert test="string-length($root)>0" flag="error">
            [NTK-ID-00018][Error] Vocabulary declarations must have a root from one of the built-in 
            types of 'datasphere', 'organization', 'individual', or 'group'. Declaration of custom
            root types are not permitted.
        </sch:assert>
        <sch:assert test="some $value in ('datasphere', 'organization', 'individual', 'group') satisfies $root=$value" flag="error">
            [NTK-ID-00018][Error] Vocabulary declarations must have a root from one of the built-in 
            types of 'datasphere', 'organization', 'individual', or 'group'. The root vocabulary type 
            found [<sch:value-of select="$root"/>] is not valid.
        </sch:assert>
    </sch:rule>
</sch:pattern>
