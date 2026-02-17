<?xml version="1.0" encoding="UTF-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:ism="urn:us:gov:ic:ism" xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="IRM-ID-00110">
    <sch:p class="ruleText" 
        ism:classification="U"
        ism:ownerProducer="USA">
        [IRM-ID-00110][Error] The string before the first underscore of each @irm:compliesWith token must be in IC-GENC.
    </sch:p>
    <sch:p class="codeDesc"  
        ism:classification="U"
        ism:ownerProducer="USA">Checks if the substring before the first underscore of each token in @irm:compliesWith 
        is a country code in IC-GENC.
    </sch:p>
    <sch:rule id="IRM-ID-00110-R1" context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage">
        <sch:assert test="util:containsOnlyTheTokensSubstringBefore('_',@irm:compliesWith,$gencCountryCodeList)" flag="error" role="error">
            [IRM-ID-00110][Error] The string before the first underscore of each @irm:compliesWith token must be in IC-GENC.
            <sch:value-of select="concat('[',@irm:compliesWith,']')"/> 
        </sch:assert>
    </sch:rule>
</sch:pattern>