<?xml version="1.0" encoding="utf-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:ism="urn:us:gov:ic:ism"
             xmlns:sch="http://purl.oclc.org/dsdl/schematron"
             id="IRM-ID-00023">
    <sch:p class="ruleText"
           ism:classification="U"
           ism:ownerProducer="USA">[IRM-ID-00023][Error] The permissible values for the year range are 0001 through 9999 for elements irm:start and
           irm:end. Human Readable: irm:start and irm:end must be positive integers less than 10,000.</sch:p>
    <sch:p class="codeDesc"
           ism:classification="U"
           ism:ownerProducer="USA">This pattern uses abstract rules to consolidate logic. For attributes, ensure that each date contained
           within $dateList has a year value within the range $minYear and $maxYear, inclusive.</sch:p>
    <!-- Use abstract rule to handle required attributes -->
    <sch:rule id="IRM-ID-00023-R1"
        context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:start | tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:end">

        <sch:let name="minYear"
                 value="0001" />
        <sch:let name="maxYear"
                 value="9999" />
        <sch:let name="dateList"
                 value="string(.)" />
        <sch:let name="errMsg"
                 value="' [IRM-ID-00023][Error] The permissible values for the year range are 0001 through 9999 for elements irm:start and irm:end. Human Readable: irm:start and irm:end must be positive integers less than 10,000. '" />
        <sch:extends rule="abs.dateListYearRangeRule" />
    </sch:rule>
</sch:pattern>
