<?xml version="1.0" encoding="UTF-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="RevRecall-ID-00011">
    <sch:p xmlns:ism="urn:us:gov:ic:ism" ism:classification="U" ism:ownerProducer="USA"
        class="ruleText">
        [RevRecall-ID-00011][Warning] rr:DESVersion attribute SHOULD be specified
        as version 202111.202205 (Version:2021-NOV Revision: 2022-MAY) with an optional extension. 
    </sch:p>
    <sch:p xmlns:ism="urn:us:gov:ic:ism" ism:classification="U" ism:ownerProducer="USA"
        class="codeDesc">
        This rule supports extending the version identifier with an optional
        trailing hyphen and up to 23 additional characters. The version must match the regular
        expression “^202111.202205(-.{1,23})?$".
    </sch:p>
    <sch:rule id="RevRecall-ID-00011-R1" context="*[@rr:DESVersion]">
        <sch:assert test="matches(@rr:DESVersion, '^202111.202205(\-.{1,23})?$')" flag="warning" role="warning">
            [RevRecall-ID-00011][Warning] rr:DESVersion attribute SHOULD be specified 
            as version 202111.202205 (Version:2021-NOV Revision: 2022-MAY) with an optional extension. 
        </sch:assert>
    </sch:rule>
</sch:pattern>
