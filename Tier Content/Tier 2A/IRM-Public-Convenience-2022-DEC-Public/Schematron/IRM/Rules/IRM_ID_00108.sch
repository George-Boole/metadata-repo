<?xml version="1.0" encoding="UTF-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="IRM-ID-00108">
    <sch:p class="ruleText">
        [IRM-ID-00108][Warning] irm:DESVersion attribute SHOULD be specified as version 202111 (Version:2021-NOV) with an optional extension.
    </sch:p>
    <sch:p class="codeDesc">
        This rule supports extending the version identifier with an optional trailing hyphen
        and up to 23 additional characters. The version must match the regular expression
        “^202111(-.{1,23})?$".
    </sch:p>
    <sch:rule id="IRM-ID-00108-R1" context="*[@irm:DESVersion]">
        <sch:assert test="matches(@irm:DESVersion,'^202111(\-.{1,23})?$')" flag="warning" role="warning">
            [IRM-ID-00108][Warning] irm:DESVersion attribute SHOULD be specified as version 202111 (Version:2021-NOV) with an optional extension.  
            The value provided was: <sch:value-of select="@irm:DESVersion"/>
        </sch:assert>
    </sch:rule>
</sch:pattern>