<?xml version="1.0" encoding="utf-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:ism="urn:us:gov:ic:ism"
             xmlns:sch="http://purl.oclc.org/dsdl/schematron"
             id="IRM-ID-00016">
    <sch:p class="ruleText"
           ism:classification="U"
           ism:ownerProducer="USA">[IRM-ID-00016][Error] The permissible values for the year range are 1901 through the current year for attributes
           @irm:approvedOn, @irm:dateProcessed, @irm:receivedOn, @irm:infoCutOff, @irm:posted, and @irm:created. Human Readable: Dates must be after
           1901 and in the past for @irm:approvedOn, @irm:dateProcessed, @irm:receivedOn, @irm:infoCutOff, @irm:posted, and @irm:created.</sch:p>
    <sch:p class="codeDesc"
           ism:classification="U"
           ism:ownerProducer="USA">This pattern uses abstract rules to consolidate logic. For attributes, ensure that each date contained
           within $dateList has a year value within the range $minYear and $maxYear, inclusive.</sch:p>
    <!-- Use abstract rule to handle required attributes -->
    <sch:rule id="IRM-ID-00016-R1"
        context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage[$IC_COMPLIANCE]//*[@irm:approvedOn | @irm:dateProcessed | @irm:receivedOn | @irm:posted | @irm:created | @irm:infoCutOff]">

        <sch:let name="minYear"
                 value="1901" />
        <sch:let name="maxYear"
                 value="$currentYear" />
        <sch:let name="dateList"
                 value=" (string(@irm:approvedOn), string(@irm:dateProcessed), string(@irm:receivedOn), string(@irm:posted), string(@irm:created), string(@irm:infoCutOff))" />
        <sch:let name="errMsg"
                 value="' [IRM-ID-00016][Error] The permissible values for the year range are 1901 through the current year for attributes @irm:approvedOn, @irm:dateProcessed, @irm:receivedOn, @irm:infoCutOff, @irm:posted, and @irm:created. Human Readable: Dates must be after 1901 and in the past for @irm:approvedOn, @irm:dateProcessed, @irm:receivedOn, @irm:infoCutOff, @irm:posted, and @irm:created. '" />
        <sch:extends rule="abs.dateListYearRangeRule" />
    </sch:rule>
</sch:pattern>
