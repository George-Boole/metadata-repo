<?xml version="1.0" encoding="UTF-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" xmlns:ism="urn:us:gov:ic:ism" id="NTK-ID-00024">
    <sch:p ism:classification="U" ism:ownerProducer="USA" class="ruleText">
        [NTK-ID-00024][Error] If there is a Profile DES specified, then there must be at least
        one ntk:AccessProfileValue.
    </sch:p>
    <sch:p ism:classification="U" ism:ownerProducer="USA" class="codeDesc">
        When ntk:ProfileDes exists, make sure there is a following sibling ntk:AccessProfileValue
        also.
    </sch:p>
    <sch:rule context="ntk:ProfileDes">
        <sch:assert test="following-sibling::ntk:AccessProfileValue" flag="error">
            [NTK-ID-00024][Error] If there is a Profile DES specified, then there must be at least
            one ntk:AccessProfileValue.
        </sch:assert>
    </sch:rule>
</sch:pattern>
