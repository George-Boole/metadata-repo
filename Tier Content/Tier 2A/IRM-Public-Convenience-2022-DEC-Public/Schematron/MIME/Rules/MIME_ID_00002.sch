<?xml version="1.0" encoding="UTF-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" 
             xmlns:ism="urn:us:gov:ic:ism" 
             id="MIME-ID-00002">
    <sch:p class="ruleText" ism:ownerProducer="USA" ism:classification="U">
        [MIME-ID-00002][Warning] If element mime:MimeType or attribute @mime:mimeType is specified, 
        it SHOULD have a value from CVEnumMIMEType.xml other than the wildcard entry. The value 
        is not explicitly defined in CVEnumMIMEType.xml and is a match ONLY because of the wildcard entry.
    </sch:p>
    <sch:p class="codeDesc" ism:ownerProducer="USA" ism:classification="U">If element mime:MimeType or attribute @mime:mimeType 
        is specified, it SHOULD have a value from CVEnumMIMEType.xml other than the wildcard entry. The value is not 
        explicitly defined in CVEnumMIMEType.xml and is a match ONLY because of the wildcard entry.
    </sch:p>
    <sch:rule id="MIME-ID-00002-R1" context="*[@mime:mimeType]">
        <sch:assert test="some $token in $nonRegexMimeTypeList satisfies @mime:mimeType = $token or matches(@mime:mimeType, concat('^',$token,'$'))" 
            flag="warning" role="warning">
            [MIME-ID-00002][Warning] If attribute @mime:mimeType is specified, it SHOULD have a value from CVEnumMIMEType.xml 
            other than the wildcard entry. MIME type [<sch:value-of select="@mime:mimeType"/>] is not explicitly defined in CVEnumMIMEType.xml 
            and is a match ONLY because of the wildcard entry.  
        </sch:assert>
    </sch:rule>
    <sch:rule id="MIME-ID-00002-R2" context="mime:MimeType">
        <sch:assert test="some $token in $nonRegexMimeTypeList satisfies . = $token or matches(., concat('^',$token,'$'))" 
            flag="warning" role="warning">
            [MIME-ID-00002][Warning] If element mime:MimeType is specified, it SHOULD have a value from CVEnumMIMEType.xml 
            other than the wildcard entry. MIME type [<sch:value-of select="."/>] is not explicitly defined in CVEnumMIMEType.xml 
            and is a match ONLY because of the wildcard entry. 
        </sch:assert>
    </sch:rule>
</sch:pattern>
