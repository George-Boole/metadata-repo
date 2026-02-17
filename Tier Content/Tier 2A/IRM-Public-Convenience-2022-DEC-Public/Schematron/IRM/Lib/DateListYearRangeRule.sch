<?xml version="1.0" encoding="utf-8"?>
<?ICEA abstractPattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<!-- Abstract rule, which asserts that each date contained within 
         the list $dateList has a year value within the range 
         $minYear and $maxYear, inclusive. If any value in $dateListis not a valid 
         date format, then return true because there is no guarantee the value
         provided is not allowed.-->
<sch:pattern xmlns:ism="urn:us:gov:ic:ism"
             xmlns:sch="http://purl.oclc.org/dsdl/schematron">
    <sch:p class="codeDesc"
           ism:classification="U"
           ism:ownerProducer="USA">Abstract rule, which asserts that each date contained within the list $dateList has a year value within the range
           $minYear and $maxYear, inclusive. If any value in $dateList is not a valid date format, then return true because there is no guarantee
           the value provided is not allowed.</sch:p>
    <sch:rule abstract="true"
              id="abs.dateListYearRangeRule">
        <sch:assert test="every $date in tokenize(normalize-space(string-join($dateList, ' ')),' ') satisfies if(not(dtf:isAllowableDateTimeFormat(string($date)))) then true() else xs:integer(substring(string(dtf:adjust-CombinedDate-to-GMT-timezone($date)), 1, 4)) &lt;= $maxYear and xs:integer(substring(string(dtf:adjust-CombinedDate-to-GMT-timezone($date)), 1, 4)) &gt;= $minYear"
                    flag="error"
                    role="error">
            <sch:value-of select="$errMsg" />
        </sch:assert>
    </sch:rule>
</sch:pattern>
