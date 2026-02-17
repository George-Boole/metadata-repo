<?xml version="1.0" encoding="utf-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:ism="urn:us:gov:ic:ism" xmlns:sch="http://purl.oclc.org/dsdl/schematron"
    id="BASE-TDF-ID-00001">
    <sch:p class="ruleText" ism:ownerProducer="USA" ism:classification="U">
        [BASE-TDF-ID-00001][Warning] tdf:version attribute SHOULD be specified as version 202111
        (Version:2021-NOV) with an optional extension.
    </sch:p>
    <sch:p class="codeDesc" ism:ownerProducer="USA" ism:classification="U">
        This rule supports extending the version identifier with an optional trailing hyphen and up to 23 additional
        characters. The version must match the regular expression "^202111(-.{1,23})?$".
    </sch:p>
    <sch:rule id="BASE-TDF-ID-00001-R1" context="*[@tdf:version]">
        <sch:assert test="matches(@tdf:version, '^202111(\-.{1,23})?$')" flag="warning" role="warning">
            [BASE-TDF-ID-00001][Warning] tdf:version attribute SHOULD be specified as
            version 202111 (Version:2021-NOV) with an optional extension. Found: <sch:value-of
                select="@tdf:version"/></sch:assert>
    </sch:rule>
</sch:pattern>
