<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="UIAS-ID-00067">
    <sch:p xmlns:ism="urn:us:gov:ic:ism" ism:classification="U" ism:ownerProducer="USA" class="ruleText">
        [UIAS-ID-00067][Warning] uias:DESVersion attribute SHOULD be specified as version 202111 (Version:2021-NOV) with an optional extension.
    </sch:p>
    <sch:p xmlns:ism="urn:us:gov:ic:ism" ism:classification="U" ism:ownerProducer="USA" class="codeDesc">
        This rule supports extending the version identifier with an optional trailing hyphen
        and up to 23 additional characters. The version must match the regular expression
        “^202111(-.{1,23})?$".
    </sch:p>
    <sch:rule id="UIAS-ID-00067-R1" context="*[@uias:DESVersion]">
        <sch:assert test="matches(@uias:DESVersion,'^202111(\-.{1,23})?$')" flag="warning" role="warning">
            [UIAS-ID-00067][Warning] uias:DESVersion attribute SHOULD be specified as version 202111 (Version:2021-NOV) with an optional extension. 
            Found <sch:value-of select="@uias:DESVersion"/>.
        </sch:assert>
    </sch:rule>
</sch:pattern>