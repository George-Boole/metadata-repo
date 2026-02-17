<?xml version="1.0" encoding="UTF-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" xmlns:ism="urn:us:gov:ic:ism" id="NTK-ID-00026">
    <sch:p ism:classification="U" ism:ownerProducer="USA" class="ruleText">
        [NTK-ID-00026][Error] AccessProfiles containing the AccessPolicy [urn:us:gov:ic:aces:ntk:ico] may not have
        ProfileDes, VocabularyType, or AccessProfileValue elements specified.
        
        Human Readable: When the ICO ACES is referenced, no data content may be specified in the AccessProfile.
    </sch:p>
    <sch:p ism:classification="U" ism:ownerProducer="USA" class="codeDesc">
        For every ntk:AccessProfile that has an ntk:AccessPolicy of [urn:us:gov:ic:aces:ntk:ico], 
        the profile does not specify any of the data elements of ntk:ProfileDes, ntk:VocabularyType, 
        or ntk:AccessProfileValue.
    </sch:p>
    <sch:rule context="ntk:AccessProfile[ntk:AccessPolicy='urn:us:gov:ic:aces:ntk:ico']">
        <sch:assert test="not(ntk:ProfileDes | ntk:VocabularyType | ntk:AccessProfileValue)">
            [NTK-ID-00026][Error] AccessProfiles containing the AccessPolicy [urn:us:gov:ic:aces:ntk:ico] may not have
            ProfileDes, VocabularyType, or AccessProfileValue elements specified.
            
            Human Readable: When the ICO ACES is referenced, no data content may be specified in the AccessProfile. 
        </sch:assert>
    </sch:rule>
</sch:pattern>
