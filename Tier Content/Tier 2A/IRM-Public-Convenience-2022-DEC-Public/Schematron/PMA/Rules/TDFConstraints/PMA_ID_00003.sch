<?xml version="1.0" encoding="UTF-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="PMA-ID-00003">
    <sch:p class="ruleText">[PMA-ID-00003][Error] Each TDO/TDC can have at most 1 pma:ProductionMetricsAssertion element.
        
        Human Readable: There can only be one Production Metrics Assertion Root Element per TDO/TDC.</sch:p>
    <sch:p class="codeDesc">
        For each tdf:TrustedDataObject or tdf:TrustedDataCollection this rule ensures that the count of pma:ProductionMetricsAssertion
        element lesser than or equal to 1.
    </sch:p>
    
    <sch:rule id="PMA-ID-00003-R1" context="tdf:TrustedDataObject | tdf:TrustedDataCollection">
        <sch:assert test="count(child::tdf:Assertion/tdf:StructuredStatement/pma:ProductionMetricsAssertion)&lt;= 1" flag="error" role="error">
            [PMA-ID-00003][Error] Each TDO/TDC can have at most 1 pma:ProductionMetricsAssertion element.
            
            Human Readable: There can only be one Production Metrics Assertion Root Element per TDO/TDC.
        </sch:assert>
    </sch:rule>
</sch:pattern>