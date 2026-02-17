<?xml version="1.0" encoding="UTF-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="PM-ID-00001">
    <sch:p class="ruleText">
        [PM-ID-00001][Warning] pm:CESVersion attribute SHOULD be specified as version 202211 (Version:2022-NOV) with an optional extension.
    </sch:p>
    <sch:p class="codeDesc">
        This rule supports extending the version identifier with an optional trailing hyphen
        and up to 23 additional characters. The version must match the regular expression
        “^202211(-.{1,23})?$".
    </sch:p>
    <sch:rule id="PM-ID-00001-R1" context="*[@pm:CESVersion]">
        <sch:assert test="matches(@pm:CESVersion,'^202211(\-.{1,23})?$')" flag="warning" role="warning">
            [PM-ID-00001][Warning] pm:CESVersion attribute SHOULD be specified as version 202211 (Version:2022-NOV) with an optional extension. 
            Found :<sch:value-of select="./@pm:CESVersion"/>
        </sch:assert>
    </sch:rule>
</sch:pattern>