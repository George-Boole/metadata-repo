<?xml version="1.0" encoding="utf-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:ism="urn:us:gov:ic:ism"
             xmlns:sch="http://purl.oclc.org/dsdl/schematron"
             id="IRM-ID-00091">
    <sch:p class="ruleText"
           ism:classification="U"
           ism:ownerProducer="USA">[IRM-ID-00091][Warning] Deprecated MIME types should not be used.</sch:p>
    <sch:p class="codeDesc"
           ism:classification="U"
           ism:ownerProducer="USA">Deprecated MIME types should not be used.</sch:p>
    <sch:rule id="IRM-ID-00091-R1"
      context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:mimeType">
        <sch:assert test="not(some $deprecatedMimeTypeValue in $deprecatedMimeTypeList satisfies . = $deprecatedMimeTypeValue)"
                    flag="error"
                    role="error">[IRM-ID-00091][Warning] Deprecated MIME types should not be used.</sch:assert>
    </sch:rule>
</sch:pattern>
