<?xml version="1.0" encoding="utf-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:ism="urn:us:gov:ic:ism"
             xmlns:sch="http://purl.oclc.org/dsdl/schematron"
             id="IRM-ID-00078">
    <sch:p class="ruleText"
           ism:classification="U"
           ism:ownerProducer="USA">[IRM-ID-00078][Error] For elements irm:acquiredOn and irm:temporalCoverage with child element name [infoCutoff],
           the permissible values for the year range are 1901 through the current year for elements irm:approximableDate, irm:start, and irm:end.
           Human Readable: If elements acquiredOn and temporalCoverage have a child element infoCutoff, then the approximableDate, start and end
           elements must have a year value between 1901 and the current year.</sch:p>
    <sch:p class="codeDesc"
           ism:classification="U"
           ism:ownerProducer="USA">This pattern uses an abstract rule to consolidate logic. It makes sure that the date contained within $dateValue
           has a year value within the range $minYear and $maxYear, inclusive. The abstract rule is extended once for each element required in rule
           IRM-ID-00078.</sch:p>
    <sch:rule abstract="true"
              id="abs.rule00078">
        <sch:let name="minYear"
                 value="1901" />
        <sch:let name="maxYear"
                 value="$currentYear" />
        <sch:let name="dateValue"
                 value="." />
        <sch:let name="errMsg"
            value="' [IRM-ID-00078][Error] For elements irm:acquiredOn and irm:temporalCoverage with child element name [infoCutoff], the permissible values for the year range are 1901 through the current year for elements irm:approximableDate, irm:start, and irm:end. '" />
        <sch:extends rule="abs.dateYearRangeRule" />
    </sch:rule>
    <!-- Begin using abstract rule to check required elements -->
    <sch:rule id="IRM-ID-00078-R2"
        context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:temporalCoverage[irm:name='infoCutOff']/irm:approximableStart/irm:searchableDate/irm:start">

        <sch:extends rule="abs.rule00078" />
    </sch:rule>
    <sch:rule id="IRM-ID-00078-R3"
        context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:temporalCoverage[irm:name='infoCutOff']/irm:approximableStart/irm:searchableDate/irm:end">

        <sch:extends rule="abs.rule00078" />
    </sch:rule>
    <sch:rule id="IRM-ID-00078-R4"
        context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:temporalCoverage[irm:name='infoCutOff']/irm:approximableEnd/irm:searchableDate/irm:start">

        <sch:extends rule="abs.rule00078" />
    </sch:rule>
    <sch:rule id="IRM-ID-00078-R5"
        context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:temporalCoverage[irm:name='infoCutOff']/irm:approximableEnd/irm:searchableDate/irm:end">

        <sch:extends rule="abs.rule00078" />
    </sch:rule>
    <sch:rule id="IRM-ID-00078-R6"
        context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:temporalCoverage[irm:name='infoCutOff']/irm:start">

        <sch:extends rule="abs.rule00078" />
    </sch:rule>
    <sch:rule id="IRM-ID-00078-R7"
        context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:temporalCoverage[irm:name='infoCutOff']/irm:end">

        <sch:extends rule="abs.rule00078" />
    </sch:rule>
    <sch:rule id="IRM-ID-00078-R8"
        context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:acquiredOn/irm:approximableDate">

        <sch:extends rule="abs.rule00078" />
    </sch:rule>
    <sch:rule id="IRM-ID-00078-R9"
        context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:acquiredOn/irm:searchableDate/irm:start">

        <sch:extends rule="abs.rule00078" />
    </sch:rule>
    <sch:rule id="IRM-ID-00078-R10"
        context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:acquiredOn/irm:searchableDate/irm:end">

        <sch:extends rule="abs.rule00078" />
    </sch:rule>
</sch:pattern>
