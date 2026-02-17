<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="ISM-ID-00300">
    <sch:p class="ruleText">
        [ISM-ID-00300][Warning] DESVersion attributes SHOULD be specified as revision 201609.201707 with an optional extension.
    </sch:p>
    <sch:p class="codeDesc">
        This rule supports extending the version identifier with an optional trailing hypen
        and up to 23 additional characters. The version must match the regular expression
        “^201609.201707(-.{1,23})?$
    </sch:p>
    <sch:rule id="ISM-ID-00300-R1" context="*[@ism:DESVersion]">
        <sch:assert test="matches(@ism:DESVersion,'^201609.201707(-.{1,23})?$')" flag="warning" role="warning">
            [ISM-ID-00300][Warning] DESVersion attributes SHOULD be specified as revision 201609.201707 with an optional extension.
        </sch:assert>
    </sch:rule>
</sch:pattern>