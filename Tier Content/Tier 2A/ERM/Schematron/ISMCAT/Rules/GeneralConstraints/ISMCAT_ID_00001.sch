<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="ISMCAT-ID-00001">
    <sch:p class="ruleText">[ISMCAT-ID-00001][Warning] ism:ISMCATCESVersion attribute SHOULD be specified as version 201709 with an optional extension.</sch:p>

    <sch:p class="codeDesc">This rule supports extending the version identifier with an optional trailing hypen
        and up to 23 additional characters. The version must match the regular expression
        “^201709(-.{1,23})?$”</sch:p>

    <sch:rule id="ISMCAT-ID-00001-R1" context="*[@ism:ISMCATCESVersion]">
        <sch:assert test="matches(@ism:ISMCATCESVersion,'^201709(-.{1,23})?$')" flag="warning" role="warning">[ISMCAT-ID-00001][Warning] ism:ISMCATCESVersion attribute SHOULD be specified as version 201709 with an optional extension.</sch:assert>
    </sch:rule>
</sch:pattern>