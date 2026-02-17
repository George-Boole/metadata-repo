<?xml version="1.0" encoding="utf-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:ism="urn:us:gov:ic:ism"
             xmlns:sch="http://purl.oclc.org/dsdl/schematron"
             id="IRM-ID-00022"
             is-a="CompareDateTimes">
    <sch:p class="ruleText"
           ism:classification="U"
           ism:ownerProducer="USA">[IRM-ID-00022][Error] For any element irm:temporalCoverage, child element irm:start must not be later than child
           element irm:end. Human Readable: For date-time ranges, the start of a range must be earlier than, or equivalent to, the end of that
           range.</sch:p>
    <sch:p class="codeDesc"
           ism:classification="U"
           ism:ownerProducer="USA">This rule uses an abstract pattern to consolidate logic. It compares the date contained within the param
           $primaryDate to each date contained within the param $secondaryDateList (using the comparison operator contained in param $operator) and
           makes sure that each comparison returns true. Implementation details for the abstract pattern can be found in the abstract pattern
           definition file located in the Lib directory.</sch:p>
    <sch:param name="ruleText"
               value="' [IRM-ID-00022][Error] For any element irm:temporalCoverage, child element irm:start must not be later than child element irm:end. '" />
    <sch:param name="codeDesc"
               value="' This rule uses an abstract pattern to consolidate logic. It compares the date contained within the param $primaryDate to each date contained within the param $secondaryDateList (using the comparison operator contained in param $operator) and makes sure that each comparison returns true. Implementation details for the abstract pattern can be found in the abstract pattern definition file located in the Lib directory. '" />
    <sch:param name="context"
           value="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:temporalCoverage" />
    <sch:param name="primaryDate"
               value="irm:start" />
    <sch:param name="operator"
               value="'&lt;='" />
    <sch:param name="secondaryDateList"
               value="(irm:end)" />
    <sch:param name="flag"
               value="'error'" />
</sch:pattern>
