<?xml version="1.0" encoding="utf-8"?>
<?ICEA abstractPattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<!-- Abstract rule, which asserts that the date contained
                 within $dateValue has a year value within the range
                 $minYear and $maxYear, inclusive. -->
<sch:pattern xmlns:ism="urn:us:gov:ic:ism"
             xmlns:sch="http://purl.oclc.org/dsdl/schematron">
    <sch:p class="codeDesc"
           ism:classification="U"
           ism:ownerProducer="USA">Abstract rule, which asserts that the date contained within $dateValue has a year value within the range $minYear
           and $maxYear, inclusive.</sch:p>
    <sch:rule abstract="true"
              id="abs.dateYearRangeRule">
        <sch:assert test="if(not(dtf:yearPortionHasFourDigits(string($dateValue)))) then false() else xs:integer(substring(string(dtf:adjust-CombinedDate-to-GMT-timezone($dateValue)), 1, 4)) &lt;= $maxYear and xs:integer(substring(string(dtf:adjust-CombinedDate-to-GMT-timezone($dateValue)), 1, 4)) &gt;= $minYear"
                    flag="error"
                    role="error">
            <sch:value-of select="$errMsg" />
        </sch:assert>
    </sch:rule>
</sch:pattern>
