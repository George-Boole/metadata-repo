<?xml version="1.0" encoding="UTF-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" xmlns:ism="urn:us:gov:ic:ism" id="MIME-ID-00001">
    <sch:p class="ruleText" ism:ownerProducer="USA" ism:classification="U">
        [MIME-ID-00001][Warning] Deprecated MIME types should not be used. 
    </sch:p>
    
    <sch:p class="codeDesc" ism:ownerProducer="USA" ism:classification="U">
        Deprecated MIME types should not be used.
    </sch:p>
    <sch:rule id="MIME-ID-00001-R1" context="*[@mime:mimeType]">
        <sch:assert test="not(some $deprecatedMimeTypeValue in $deprecatedMimeTypeList satisfies @mime:mimeType = $deprecatedMimeTypeValue)" flag="warning" role="warning">
            [MIME-ID-00001][Warning] Deprecated MIME types should not be used.  
        </sch:assert>
    </sch:rule>
    <sch:rule id="MIME-ID-00001-R2" context="mime:MimeType">
        <sch:assert test="not(some $deprecatedMimeTypeValue in $deprecatedMimeTypeList satisfies . = $deprecatedMimeTypeValue)" flag="warning" role="warning">
            [MIME-ID-00001][Warning] Deprecated MIME types should not be used.  
        </sch:assert>
    </sch:rule>
</sch:pattern>
