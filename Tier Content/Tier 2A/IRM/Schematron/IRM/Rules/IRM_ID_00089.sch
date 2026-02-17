<?xml version="1.0" encoding="utf-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:ism="urn:us:gov:ic:ism"
             xmlns:sch="http://purl.oclc.org/dsdl/schematron"
             id="IRM-ID-00089">
    <sch:p class="ruleText"
           ism:classification="U"
           ism:ownerProducer="USA">[IRM-ID-00089][Error] If @irm:mimeType exists, then @mime:CESVersion must exist as well.</sch:p>
    <sch:p class="codeDesc"
           ism:classification="U"
           ism:ownerProducer="USA">Make sure that the MIME CVE version attribute exists if the internet media type of the resource is
           defined.</sch:p>
    <sch:rule id="IRM-ID-00089-R1"
      context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:mimeType">
        <sch:assert test="//@mime:CESVersion"
                    flag="error"
                    role="error">[IRM-ID-00089][Error] If @irm:mimeType exists, then @mime:CESVersion must exist as well.</sch:assert>
    </sch:rule>
</sch:pattern>
