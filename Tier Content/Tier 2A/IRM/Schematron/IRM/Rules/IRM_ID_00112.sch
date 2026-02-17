<?xml version="1.0" encoding="utf-8"?>
<sch:pattern xmlns:ism="urn:us:gov:ic:ism"
    xmlns:sch="http://purl.oclc.org/dsdl/schematron"
    id="IRM-ID-00112">
    <sch:p class="ruleText"
        ism:classification="U"
        ism:ownerProducer="USA">[IRM-ID-00112][Warning] If element irm:mimeType is specified, it SHOULD have a value from CVEnumMIMEType.xml 
        other than the wildcard entry. The value is not explicitly defined in CVEnumMIMEType.xml and is a match ONLY because of the wildcard entry.</sch:p>
    <sch:p class="codeDesc"
        ism:classification="U"
        ism:ownerProducer="USA">If element irm:mimeType is specified, it SHOULD have a value from CVEnumMIMEType.xml 
        other than the wildcard entry. The value is not explicitly defined in CVEnumMIMEType.xml and is a match ONLY 
        because of the wildcard entry.</sch:p>
    <sch:rule id="IRM-ID-00112-R1" 
        context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage[$IC_COMPLIANCE]//irm:mimeType">
        <sch:assert test="some $token in $nonRegexMimeTypeList satisfies . = $token or matches(., concat('^',$token,'$'))" 
            flag="warning" role="warning">
            [IRM-ID-00112][Warning] If element irm:mimeType is specified, it SHOULD have a value from CVEnumMIMEType.xml 
            other than the wildcard entry. MIME type [<sch:value-of select="."/>] is not explicitly defined in CVEnumMIMEType.xml 
            and is a match ONLY because of the wildcard entry.
        </sch:assert>
    </sch:rule>
</sch:pattern>