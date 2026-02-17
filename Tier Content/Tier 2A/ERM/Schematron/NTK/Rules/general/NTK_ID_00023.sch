<?xml version="1.0" encoding="UTF-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" xmlns:ism="urn:us:gov:ic:ism" id="NTK-ID-00023">
    <sch:p ism:classification="U" ism:ownerProducer="USA" class="ruleText">
        [NTK-ID-00023][Error] If ntk:AccessProfileValue or ntk:VocabularyType are specified then there must
        be a Profile DES that defines the use of the ntk:AccessProfile structure.
    </sch:p>
    <sch:p ism:classification="U" ism:ownerProducer="USA" class="codeDesc">
        When there is content in an AccessProfile, either AccessProfileValue or VocabularyType, then
        there must also be a ProfileDes in the AccessProfile.
    </sch:p>
    <sch:rule context="ntk:AccessProfile[ntk:AccessProfileValue or ntk:VocabularyType]">
        <sch:assert test="ntk:ProfileDes" flag="error">
            [NTK-ID-00023][Error] If ntk:AccessProfileValue or ntk:VocabularyType are specified then there must
            be a Profile DES that defines the use of the ntk:AccessProfile structure.
        </sch:assert>
    </sch:rule>
</sch:pattern>
