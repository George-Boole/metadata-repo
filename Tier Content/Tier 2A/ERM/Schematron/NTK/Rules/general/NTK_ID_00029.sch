<?xml version="1.0" encoding="UTF-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" xmlns:ism="urn:us:gov:ic:ism" is-a="VocabHasCorrespondingVersion" id="NTK-ID-00029">

    <sch:p ism:classification="U" ism:ownerProducer="USA" class="ruleText">[NTK-ID-00029][Error] An @ntk:sourceVersion must be specified for the built-in
        organization:usa-agency vocabulary type.</sch:p>

    <sch:p ism:classification="U" ism:ownerProducer="USA" class="codeDesc">Use the VocabHasCorrespondingVersion abstract pattern to require an ntk:VocabularyType with
        @sourceVersion specified and @name = 'organization:usa-agency'.</sch:p>

    <sch:param name="context"
        value="ntk:AccessProfile[ntk:AccessProfileValue/@ntk:vocabulary='organization:usa-agency']"/>
    <sch:param name="vocab" value="'organization:usa-agency'"/>
    <sch:param name="errMsg"
        value="'[NTK-ID-00029][Error] An @ntk:sourceVersion must be specified for the built-in organization:usa-agency vocabulary type.'"/>

</sch:pattern>
