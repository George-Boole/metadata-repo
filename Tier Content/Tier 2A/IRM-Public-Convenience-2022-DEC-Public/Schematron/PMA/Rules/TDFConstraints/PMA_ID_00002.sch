<?xml version="1.0" encoding="UTF-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="PMA-ID-00002">
    <sch:p class="ruleText">[PMA-ID-00002][Error] pma:ProductionMetricsAssertion element must have ancestor that is a tdf:TrustedDataObject.
        
        Human Readable: PMA assertions must live within a TDO.</sch:p>
    <sch:p class="codeDesc">
        The ancestor of each pma:ProductionMetricsAssertion element must be some tdf:TrustedDataObject or tdf:TrustedDataCollection.
    </sch:p>
    
    <sch:rule id="PMA-ID-00002-R1" context="pma:ProductionMetricsAssertion">
        <sch:assert test="ancestor::tdf:TrustedDataObject | ancestor::tdf:TrustedDataCollection" flag="error" role="error">
            [PMA-ID-00002][Error] pma:ProductionMetricsAssertion element must have ancestor that is a tdf:TrustedDataObject or tdf:TrustedDataCollection.
            
            Human Readable: PMA assertions must live within a TDO/TDC.
        </sch:assert>
    </sch:rule>
</sch:pattern>