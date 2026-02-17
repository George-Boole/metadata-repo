<?xml version="1.0" encoding="UTF-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:ism="urn:us:gov:ic:ism" xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="IRM-ID-00109">
    <sch:p class="ruleText" 
        ism:classification="U"
        ism:ownerProducer="USA">
        [IRM-ID-00109][Error] If the tokens in @irm:compliesWith starts with "USA", they must be a value that exists or starts
        with a value from CVEnumIRMCompliesWithUSA. 
    </sch:p>
    <sch:p class="codeDesc"  
        ism:classification="U"
        ism:ownerProducer="USA">If @irm:compliesWith starts-with USA, must be or start with a value from CVE values start-with USA.
    </sch:p>
    <sch:rule id="IRM-ID-00109-R1" context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage">
        <sch:assert test="util:checkUSATokenValidity(@irm:compliesWith,$compliesWithUSATypeList)" flag="error" role="error">
            [IRM-ID-00109][Error] If the tokens in @irm:compliesWith starts with "USA", they must be a value that exists or starts
            with a value from CVEnumIRMCompliesWithUSA. <sch:value-of select="concat('[',@irm:compliesWith,']')"/> 
        </sch:assert>
    </sch:rule>
</sch:pattern>