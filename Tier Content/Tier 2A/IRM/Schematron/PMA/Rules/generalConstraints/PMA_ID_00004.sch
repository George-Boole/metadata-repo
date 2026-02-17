<?xml version="1.0" encoding="UTF-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="PMA-ID-00004">
    <sch:p class="ruleText">
        [PMA-ID-00004][Warning] pma:DESVersion attribute SHOULD be specified as revision 201903.201909 (Version:2019-MAR Revision: 2019-SEP) 
        with an optional extension.
    </sch:p>
    <sch:p class="codeDesc">
        This rule supports extending the version identifier with an optional trailing hyphen
        and up to 23 additional characters. The version must match the regular expression
        “^201903.201909(-.{1,23})?$".
    </sch:p>
    <sch:rule id="PMA-ID-00004-R1" context="*[@pma:DESVersion]">
        <sch:assert test="matches(@pma:DESVersion,'^201903.201909(\-.{1,23})?$')" flag="warning" role="warning">
            [PMA-ID-00004][Warning] pma:DESVersion attribute SHOULD be specified as version 201903.201909 (Version:2019-MAR Revision: 2019-SEP) 
            with an optional extension. The value provided was: <sch:value-of select="./@pma:DESVersion"/>
        </sch:assert>
    </sch:rule>
</sch:pattern>