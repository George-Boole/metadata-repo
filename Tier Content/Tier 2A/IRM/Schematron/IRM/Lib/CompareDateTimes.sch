<?xml version="1.0" encoding="utf-8"?>
<?ICEA abstractPattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<!-- 
    $context := an xpath to an element
    $primaryDate := an xpath, relative to $context, to a date to compare against all dates in $secondaryDateList
    $secondaryDateList := a list of xpaths, relative to $context, each to a dates in which to compare against $primaryDate
    $operator := the equality operator to use for comparing each date in $secondaryDateList to $primaryDate
    
    First, ensure that the primaryDate is an allowable date format. If the primary date is not a valid 
    date format, then return true because there is no guarantee the value provided is not allowed. Then, for
    each date in $secondaryDateList, perform the same check for a valid date format and compare the 
    secondaryDate to the primaryDate. To perform comparisons between dates, take the comparison operator
    contained in the param $operator and ensure that all comparisons between primary and secondary dates
    return true.
-->
<sch:pattern xmlns:ism="urn:us:gov:ic:ism"
             xmlns:sch="http://purl.oclc.org/dsdl/schematron"
             abstract="true"
             id="CompareDateTimes">
    <sch:p class="codeDesc"
           ism:classification="U"
           ism:ownerProducer="USA">$context := an xpath to an element</sch:p>
    <sch:p class="codeDesc"
           ism:classification="U"
           ism:ownerProducer="USA">$primaryDate := an xpath, relative to $context, to a date to compare against all dates in
           $secondaryDateList</sch:p>
    <sch:p class="codeDesc"
           ism:classification="U"
           ism:ownerProducer="USA">$secondaryDateList := a list of xpaths, relative to $context, each to a dates in which to compare against
           $primaryDate</sch:p>
    <sch:p ism:classification="U"
           ism:ownerProducer="USA">$operator := the equality operator to use for comparing each date in $secondaryDateList to $primaryDate</sch:p>
    <sch:p class="codeDesc"
           ism:classification="U"
           ism:ownerProducer="USA">First, ensure that the primaryDate is an allowable date format. If the primary date is not a valid 
        date format, then return true because there is no guarantee the value provided is not allowed. Then, for
        each date in $secondaryDateList, perform the same check for a valid date format and compare the 
        secondaryDate to the primaryDate. To perform comparisons between dates, take the comparison operator
        contained in the param $operator and ensure that all comparisons between primary and secondary dates
        return true.</sch:p>
    <sch:rule id="CompareDateTimes-R1"
              context="$context">
        <sch:assert test="if ($flag = 'warning' and dtf:isAllowableDateTimeFormat(string($primaryDate))) then every $secondaryDate in $secondaryDateList satisfies if(dtf:isAllowableDateTimeFormat(string($secondaryDate))) then dtf:compareDateTimeRanges(string($primaryDate), $operator, string($secondaryDate)) else true() else true()"
                    flag="warning"
                    role="warning">
            <sch:value-of select="$ruleText" />
        </sch:assert>
        <sch:assert test="if ($flag = 'error' and dtf:isAllowableDateTimeFormat(string($primaryDate))) then every $secondaryDate in $secondaryDateList satisfies if(dtf:isAllowableDateTimeFormat(string($secondaryDate))) then dtf:compareDateTimeRanges(string($primaryDate), $operator, string($secondaryDate)) else true() else true()"
                    flag="error"
                    role="error">
            <sch:value-of select="$ruleText" />
        </sch:assert>
    </sch:rule>
</sch:pattern>
