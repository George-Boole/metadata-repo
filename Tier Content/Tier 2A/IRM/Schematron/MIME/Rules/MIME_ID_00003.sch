<?xml version="1.0" encoding="UTF-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="MIME-ID-00003">
    <sch:p class="ruleText">
        [MIME-ID-00003][Warning] mime:CESVersion attribute SHOULD be specified
        as version 202010 (Version:2020-OCT) with an optional extension. 
    </sch:p>
    <sch:p class="codeDesc">
        This rule supports extending the version identifier with an optional
        trailing hyphen and up to 23 additional characters. The version must match the regular
        expression “^202010(-.{1,23})?$".
    </sch:p>
    <sch:rule id="MIME-ID-00003-R1" context="*[@mime:CESVersion]">
        <sch:assert test="matches(@mime:CESVersion, '^202010(\-.{1,23})?$')" flag="warning" role="warning">
            [MIME-ID-00003][Warning] mime:CESVersion attribute SHOULD be specified
            as version 202010 (Version:2020-OCT) with an optional extension. Found :<sch:value-of select="./@mime:CESVersion"/>
        </sch:assert>
    </sch:rule>
</sch:pattern>
