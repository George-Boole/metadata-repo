<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="IC-TDF-ID-00054">
    <sch:p class="ruleText">
        [IC-TDF-ID-00054][Warning] tdf:version attribute SHOULD be specified as version 201412.201707 with an optional extension.  
    </sch:p>
    <sch:p class="codeDesc">
        This rule supports extending the version identifier with an optional trailing hypen
        and up to 23 additional characters. The version must match the regular expression
        “^201412.201707(-.{1,23})?$
    </sch:p>
    <sch:rule id="IC-TDF-ID-00054-R1" context="*[@tdf:version]">
        <sch:assert test="matches(@tdf:version,'^201412.201707(\-.{1,23})?$')" flag="warning" role="warning">
            [IC-TDF-ID-00054][Warning] tdf:version attribute SHOULD be specified as version 201412.201707 with an optional extension. 
        </sch:assert>
    </sch:rule>
</sch:pattern>