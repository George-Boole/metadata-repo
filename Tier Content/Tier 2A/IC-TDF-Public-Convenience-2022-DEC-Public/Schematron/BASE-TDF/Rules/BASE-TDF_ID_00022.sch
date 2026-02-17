<?xml version="1.0" encoding="utf-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:ism="urn:us:gov:ic:ism" xmlns:sch="http://purl.oclc.org/dsdl/schematron"
    id="BASE-TDF-ID-00022">
    <sch:p class="ruleText" ism:ownerProducer="USA" ism:classification="U">
        [BASE-TDF-ID-00022][Error] For any tdf:TrustedDataCollection or tdf:TrustedDataObject containing references to any
        sfhashv (urn:us:gov:ic:sf:hashverification) elements, that tdf:TrustedDataCollection or tdf:TrustedDataObject must 
        have the @sf:DESVersion attribute. 
    </sch:p>
    <sch:p class="codeDesc" ism:ownerProducer="USA" ism:classification="U">
        For any tdf:TrustedDataCollection or tdf:TrustedDataObject containing references to any
        sfhashv (urn:us:gov:ic:sf:hashverification) elements, that tdf:TrustedDataCollection or tdf:TrustedDataObject must 
        have the @sf:DESVersion attribute. 
    </sch:p>
    <sch:rule id="BASE-TDF-ID-00022-R1" context="tdf:TrustedDataCollection[.//sfhashv:* | .//*/@sfhashv:*] | tdf:TrustedDataObject[.//sfhashv:* | .//*/@sfhashv:*]">
        <sch:assert test="./@sf:DESVersion" flag="error" role="error">
            [BASE-TDF-ID-00022][Error] For any tdf:TrustedDataCollection or tdf:TrustedDataObject containing references to any
            sfhashv (urn:us:gov:ic:sf:hashverification) elements, that tdf:TrustedDataCollection or tdf:TrustedDataObject must 
            have the @sf:DESVersion attribute.
        </sch:assert>
    </sch:rule>
</sch:pattern>