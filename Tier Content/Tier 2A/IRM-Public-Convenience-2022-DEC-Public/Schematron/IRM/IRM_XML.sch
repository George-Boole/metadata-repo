<?xml version="1.0" encoding="UTF-8"?>
<!--UNCLASSIFIED--><?ICEA master?>
<!-- UNCLASSIFIED -->
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<!-- WARNING: 
    Once compiled into an XSLT the result will 
    be the aggregate classification of all the CVES 
    and included .sch files
-->
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron"
            xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
            queryBinding="xslt2">
    
    <sch:ns uri="http://www.w3.org/2001/XMLSchema" prefix="xsd"/>
    <sch:ns uri="urn:us:gov:ic:virt" prefix="virt"/>
    <sch:ns uri="urn:us:gov:ic:ism" prefix="ism"/>
    <sch:ns uri="urn:us:gov:ic:irm" prefix="irm"/>
    <sch:ns uri="urn:us:gov:ic:ntk" prefix="ntk"/>
    <sch:ns uri="urn:us:gov:ic:tdf" prefix="tdf"/>
    <sch:ns uri="urn:us:gov:ic:id" prefix="icid"/>
    <sch:ns uri="urn:us:gov:ic:usagency" prefix="usagency"/>
    <sch:ns uri="urn:us:gov:ic:pm" prefix="pm"/>
    <sch:ns uri="urn:us:gov:ic:intdis" prefix="intdis"/>
    <sch:ns uri="http://www.example.com/functions/local" prefix="local"/>
    <sch:ns uri="urn:us:gov:ic:mime" prefix="mime"/>
    <sch:ns uri="urn:us:gov:ic:icgenc" prefix="genc"/>
    <sch:ns uri="urn:us:gov:ic:cve" prefix="cve"/>
    <sch:ns uri="http://www.w3.org/1999/xlink" prefix="xlink"/>
    <sch:ns uri="http://www.w3.org/1999/XSL/Transform" prefix="xsl"/>
    <sch:ns uri="date:time:function" prefix="dtf"/>
    <sch:ns prefix="util" uri="urn:us:gov:ic:irm:xsl:util"/>
    
    <sch:p xmlns:ism="urn:us:gov:ic:ism"
          class="codeDesc"
          ism:classification="U"
          ism:ownerProducer="USA">
        This is the root file for the specifications Schematron ruleset. It loads all of the required CVEs, 
        declares some variables, and includes all of the Rule .sch files.</sch:p>
    
    <sch:let name="IRM_COMPLIES_WITH"
            value="irm:ICResourceMetadataPackage/@irm:compliesWith"/>
    <sch:let name="MIN_DISCOVERABLE_OR_GREATER"
            value="util:containsAnyOfTheTokens($IRM_COMPLIES_WITH, ('MIN_DISCOVERABLE'))"/>
    <sch:let name="MIN_ACCESSIBLE_OR_GREATER"
            value="$MIN_DISCOVERABLE_OR_GREATER or util:containsAnyOfTheTokens($IRM_COMPLIES_WITH, ('MIN_ACCESSIBLE'))"/>
    <sch:let name="COMPLIANCE_ATTRIBUTE"
            value="//irm:ICResourceMetadataPackage/@irm:compliesWith"/>
    <sch:let name="IC_COMPLIANCE"
            value="some $token in $COMPLIANCE_ATTRIBUTE satisfies $token='USA_IC'"/>
    <!-- (U) Resources  -->
    <sch:let name="coverageIso3166DigraphList"
            value="document('../../CVE/IRM/CVEnumIRMCoverageISO3166Digraph.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>
    <sch:let name="iso639DigraphList"
            value="document('../../CVE/IRM/CVEnumIRMISO639Digraph.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>
    <sch:let name="iso639-2TrigraphList"
            value="document('../../CVE/IRM/CVEnumIRMISO639-2Trigraph.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>
    <sch:let name="iso639-3TrigraphList"
            value="document('../../CVE/IRM/CVEnumIRMISO639-3Trigraph.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>
    <sch:let name="mimeTypeList"
            value="document('../../CVE/MIME/CVEnumMIMEType.xml')//cve:Value"/>
    <sch:let name="nonRegexMimeTypeList"
            value="document('../../CVE/MIME/CVEnumMIMEType.xml')/cve:CVE/cve:Enumeration/cve:Term[not(./@deprecated)]/cve:Value[not(./@regularExpression)]"/> 
    <sch:let name="deprecatedMimeTypeList"
            value="document('../../CVE/MIME/CVEnumMIMEType.xml')/cve:CVE/cve:Enumeration/cve:Term[./@deprecated]/cve:Value"/>
    <sch:let name="compliesWithUSATypeList"
            value="document('../../CVE/IRM/CVEnumIRMCompliesWithUSA.xml')//cve:Value"/>
    <sch:let name="compoundLanguageQualifierTypeList"
            value="document('../../CVE/IRM/CVEnumIRMCompoundLanguageQualifierType.xml')//cve:Value"/>
    <sch:let name="intelDisciplineComponentTechniqueList"
            value="document('../../CVE/INTDIS/CVEnumIntelDisciplineComponentTechnique.xml')//cve:Value"/>
    <sch:let name="intelDisciplineComponentList"
            value="document('../../CVE/INTDIS/CVEnumIntelDisciplineComponent.xml')//cve:Value"/>
    <sch:let name="intelDisciplineList"
            value="document('../../CVE/INTDIS/CVEnumIntelDiscipline.xml')//cve:Value"/>
    <sch:let name="positiveIntelList"
            value="document('../../CVE/IRM/CVEnumIRMPositiveIntel.xml')//cve:Value"/>
    <sch:let name="activityList"
            value="document('../../CVE/IRM/CVEnumIRMActivity.xml')//cve:Value"/>
    <sch:let name="executableIndicatorList"
            value="document('../../CVE/IRM/CVEnumIRMExecutableIndicator.xml')//cve:Value"/>
    <sch:let name="maliciousCodeIndicatorList"
            value="document('../../CVE/IRM/CVEnumIRMMaliciousCodeIndicator.xml')//cve:Value"/>
    <sch:let name="coveragePrecedenceList"
            value="document('../../CVE/IRM/CVEnumIRMCoveragePrecedence.xml')//cve:Value"/>
    <sch:let name="USAgencyAcronymList"
            value="document('../../CVE/USAgency/CVEnumUSAgencyAcronym.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>
    <sch:let name="nonStateActorsList"
            value="document('../../CVE/PM/CVEnumPMNonStateActors.xml')//cve:Value"/>
    <sch:let name="gencCountryCodeList"
            value="document('../../CVE/IC-GENC/CVEnumGENCCountryCode.xml')//cve:Value"/>
    <sch:let name="waterBodyList"
            value="document('../../CVE/IRM/CVEnumIRMWaterBody.xml')//cve:Value"/>
    <sch:let name="gencSubDivisionList"
            value="document('../../CVE/IC-GENC/CVEnumGENCSubDivisionCode.xml')//cve:Value"/>
    <!-- **************************** -->
    <!-- * General Global Variables * -->
    <!-- **************************** -->
    <sch:let name="GMTTimeZoneOffset" value="'PT0H'"/>
    <sch:let name="currentYear"
            value="year-from-dateTime(adjust-dateTime-to-timezone(current-dateTime(), xs:dayTimeDuration($GMTTimeZoneOffset)))"/>
    <sch:let name="timeZoneRegEx" value="'Z|[\+-]\d{2}:\d{2}'"/>
    <sch:let name="endsWithTimeZoneRegEx" value="concat('^.*',$timeZoneRegEx,'$')"/>
    <sch:let name="startDateTimeTemplate" value="'0001-01-01T00:00:00.000'"/>
    <sch:let name="endDateTimeTemplate" value="'9999-12-01T23:59:59.999'"/>
    <sch:let name="defaultTimeZone" value="'Z'"/>
    <sch:let name="gYearRegEx" value="'^\d{4}(Z|[\+-]\d{2}:\d{2})?$'"/>
    <sch:let name="gYearMonthRegEx" value="'^\d{4}-\d{2}(Z|[\+-]\d{2}:\d{2})?$'"/>
    <sch:let name="dateRegEx" value="'^\d{4}-\d{2}-\d{2}(Z|[\+-]\d{2}:\d{2})?$'"/>
    <sch:let name="dateHourMinTypeRegEx"
            value="'^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}(Z|[\+-]\d{2}:\d{2})?$'"/>
    <sch:let name="dateTimeRegEx"
            value="'^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(\.\d{1,3})?(Z|[\+-]\d{2}:\d{2})?$'"/>
    <!-- ************************************** -->
    <!-- * Abstract Rule and Pattern Includes * -->
    <!-- ************************************** -->
    <sch:include href="./Lib/ValidateValueExistenceInList.sch"/>
    <sch:include href="./Lib/DateListYearRangeRule.sch"/>
    <sch:include href="./Lib/DateYearRangeRule.sch"/>
    <sch:include href="./Lib/CompareDateTimes.sch"/>
    <sch:include href="./Lib/IsmEnforcement.sch"/>
    <sch:include href="./Lib/ICIdentifierRestrictions.sch"/>
    <sch:include href="./Lib/TypeConstraintPatterns.sch"/>
    <sch:include href="./Lib/ValidateValidationEnvSchema.sch"/>
    <sch:include href="./Lib/ValidateValidationEnvCVE.sch"/>
    <!-- ************************************* -->
    <!-- * Custom XSLT2 Function Definitions * -->
    <!-- ************************************* -->
    
    <!--
     Returns value of irm:CombinedDateType adjusted to GMT timezone.
   -->
    <xsl:function name="dtf:adjust-CombinedDate-to-GMT-timezone" as="xs:string">
        <xsl:param name="combinedDate" as="xs:string"/>
        <xsl:choose>
            <xsl:when test="matches($combinedDate, $timeZoneRegEx)">
                <xsl:choose>
                    <xsl:when test="matches($combinedDate, $dateRegEx)">
                        <xsl:value-of select="adjust-date-to-timezone(xs:date($combinedDate), xs:dayTimeDuration($GMTTimeZoneOffset))"/>
                    </xsl:when>
                    <xsl:when test="matches($combinedDate, $dateHourMinTypeRegEx)">
                        <xsl:variable name="zeroSecondsPadding" select="':00'"/>
                        <xsl:variable name="combinedDatePadWithSeconds"
                                select="concat(substring($combinedDate, 1, 16), $zeroSecondsPadding, substring($combinedDate, 17))"/>
                        <xsl:value-of select="adjust-dateTime-to-timezone(xs:dateTime($combinedDatePadWithSeconds), xs:dayTimeDuration($GMTTimeZoneOffset))"/>
                    </xsl:when>
                    <xsl:when test="matches($combinedDate, $dateTimeRegEx)">
                        <xsl:value-of select="adjust-dateTime-to-timezone(xs:dateTime($combinedDate), xs:dayTimeDuration($GMTTimeZoneOffset))"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$combinedDate"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$combinedDate"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    <!--
     Returns true if the raw value match the provided regular expressions. 
   -->
    <xsl:function name="util:meetsType" as="xs:boolean">
        <xsl:param name="value"/>
        <xsl:param name="typePattern" as="xs:string"/>
        <xsl:value-of select="matches(string($value), concat('^(', $typePattern, ')$'))"/>
    </xsl:function>
    <!--
    Returns true if any token in the attribute value matches at least one token in the provided list.
        -->
    <xsl:function name="util:containsAnyOfTheTokens" as="xs:boolean">
        <xsl:param name="attribute"/>
        <xsl:param name="tokenList" as="xs:string+"/>
        <xsl:value-of select="some $attrToken in tokenize(normalize-space(string($attribute)), ' ') satisfies $attrToken = $tokenList"/>
    </xsl:function>
    <!--
    Returns true if the substring-before with a specific delimiter of all tokens in the attribute value matches at least one token in the provided list.
    -->
    <xsl:function name="util:containsOnlyTheTokensSubstringBefore" as="xs:boolean">
        <xsl:param name="delimiter" as="xs:string"/>
        <xsl:param name="attribute"/>
        <xsl:param name="tokenList" as="xs:string+"/>
        <xsl:value-of select="every $attrToken in tokenize(normalize-space(string($attribute)), ' ') satisfies substring-before($attrToken,$delimiter) = $tokenList"/>
    </xsl:function>
    <!--
    Returns true if all tokens starting with USA are values in or start with USA values from $tokenList 
    -->
    <xsl:function name="util:checkUSATokenValidity" as="xs:boolean">
        <xsl:param name="attribute"/>
        <xsl:param name="tokenList" as="xs:string+"/>
        <xsl:value-of select="every $attrToken in tokenize(normalize-space(string($attribute)), ' ') satisfies               if (starts-with($attrToken,'USA'))               then some $token in $tokenList satisfies $attrToken = $token or starts-with($attrToken,$token)              else true()"/>
    </xsl:function>
    <!--
                Returns the maximum day of the month for an xs:dateTime as an xs:string.
                @param {xs:dateTime} date The date time from which to get the month
                @returns {xs:string} String representation of the maximum day of the month
        -->
    <xsl:function name="dtf:getMaxDay" as="xs:string">
        <xsl:param name="date" as="xs:dateTime"/>
        <xsl:variable name="month" select="number(dtf:getMonth(string($date)))"/>
        <xsl:choose>
            <xsl:when test="$month = (1,3,5,7,8,10,12)">
                <xsl:value-of select="31"/>
            </xsl:when>
            <xsl:when test="$month = (4,6,9,11)">
                <xsl:value-of select="30"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="dtf:isLeapYear(string($date))">
                        <xsl:value-of select="29"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="28"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    <!--
                @param {xs:date} date String representation of a date
                @returns {xs:boolean} Returns true if the date provided occurs in a 
                    leap year; otherwise returns false.
        -->
    <xsl:function name="dtf:isLeapYear" as="xs:boolean">
        <xsl:param name="date" as="xs:string"/>
        <xsl:variable name="year" as="xs:integer" select="xs:integer(dtf:getYear($date))"/>
        <xsl:choose>
            <xsl:when test="$year mod 100 = 0">
                <xsl:choose>
                    <xsl:when test="$year mod 400 = 0">
                        <xsl:value-of select="true()"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="false()"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="$year mod 4 = 0">
                        <xsl:value-of select="true()"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="false()"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    <!--
                Replaces the day portion of the provided dateTime with the new day provided.
                @param {xs:dateTime} dateTime An xs:dateTime to be updated with new day.
                @param {xs:string} newDayString String representation of day portion of a date.
                @returns {xs:dateTime} Returns new xs:dateTime with updated day portion. 
                leap year; otherwise returns false.
        -->
    <xsl:function name="dtf:replaceDateTimeDay" as="xs:dateTime">
        <xsl:param name="dateTime" as="xs:dateTime"/>
        <xsl:param name="newDayString" as="xs:string"/>
        <xsl:variable name="beforeDay" select="substring(string($dateTime), 1, 8)"/>
        <xsl:variable name="afterDay" select="substring(string($dateTime), 11)"/>
        <xsl:value-of select="concat($beforeDay, $newDayString, $afterDay)"/>
    </xsl:function>
    <!--
                Returns a string representation of the year portion of the date
                represented by the provided string.
                @param {xs:string} dateString String representation of a date in one
                    of the allowable formats.
                @returns {xs:string} String representation of the year portion of the 
                    date represented by the provided string.
        -->
    <xsl:function name="dtf:getYear" as="xs:string">
        <xsl:param name="dateString" as="xs:string"/>
        <xsl:value-of select="substring(dtf:removeTimeZone($dateString), 1, 4)"/>
    </xsl:function>
    <!--
                Returns a string representation of the month portion of the date
                represented by the provided string.
                @param {xs:string} dateString String representation of a date in one
                    of the allowable formats.
                @returns {xs:string} String representation of the month portion of the 
                date represented by the provided string.
        -->
    <xsl:function name="dtf:getMonth" as="xs:string">
        <xsl:param name="dateString" as="xs:string"/>
        <xsl:value-of select="substring(dtf:removeTimeZone($dateString), 6, 2)"/>
    </xsl:function>
    <!--
                Returns a string representation of the day portion of the date
                represented by the provided string.
                @param {xs:string} dateString String representation of a date in one
                    of the allowable formats.
                @returns {xs:string} String representation of the day portion of the 
                date represented by the provided string.
        -->
    <xsl:function name="dtf:getDay" as="xs:string">
        <xsl:param name="dateString" as="xs:string"/>
        <xsl:value-of select="substring(dtf:removeTimeZone($dateString), 9, 2)"/>
    </xsl:function>
    <!--
                Returns a string representation of the timezone portion of the date
                represented by the provided string.
                @param {xs:string} dateString String representation of a date in one
                    of the allowable formats.
                @returns {xs:string} String representation of the timezone portion of
                    the date represented by the provided string.
        -->
    <xsl:function name="dtf:getTimeZone" as="xs:string">
        <xsl:param name="dateString" as="xs:string"/>
        <xsl:variable name="dateTimeEndingWithTimezone"
                    as="xs:string"
                    select="concat('^.*(',$timeZoneRegEx,')$')"/>
        <xsl:choose>
            <xsl:when test="matches($dateString, $dateTimeEndingWithTimezone)">
                <xsl:value-of select="replace($dateString, $dateTimeEndingWithTimezone, '$1')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$defaultTimeZone"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    <!--
                Returns true if the year portion of the date represented by the provided
                string contains four (4) digits; otherwise returns false.
                @param {xs:string} dateString String representation of a date in one
                    of the allowable formats.
                @returns {xs:string} true if the year portion of the date represented by
                    the provided string contains four (4) digits; otherwise returns false.
        -->
    <xsl:function name="dtf:yearPortionHasFourDigits" as="xs:boolean">
        <xsl:param name="dateString" as="xs:string"/>
        <xsl:variable name="dateWithOnlyFourDigitYearAndOptionalTimeZoneRegEx"
                    as="xs:string"
                    select="concat('^\d{4}(',$timeZoneRegEx,')?$')"/>
        <xsl:variable name="dateStartingWithFourDigitYearRegEx"
                    as="xs:string"
                    select="'^\d{4}-.*$'"/>
        <xsl:value-of select="matches($dateString, $dateWithOnlyFourDigitYearAndOptionalTimeZoneRegEx) or matches($dateString, $dateStartingWithFourDigitYearRegEx)"/>
    </xsl:function>
    <!--
                Removes the timezone portion of the date represented by the provided
                string and returns all remaining portions.
                @param {xs:string} dateString String representation of a date in one
                    of the allowable formats.
                @returns {xs:string} String representation of a date without a timezone
                    portion.
        -->
    <xsl:function name="dtf:removeTimeZone" as="xs:string">
        <xsl:param name="dateString" as="xs:string"/>
        <xsl:value-of select="replace($dateString, $timeZoneRegEx, '')"/>
    </xsl:function>
    <!--
                Uses the template provided to fill in missing portions of the string
                representation of a dateTime provided and returns a full xs:dateTime.
                The dateString provided must not contain a timezone.
                @param {xs:string} dateString String representation of a date in one
                    of the allowable formats.
                @param {xs:string} dateTemplateString String template of a default date
                    from which to pad missing portions of the dateString parameter.
                @returns {xs:dateTime} An xs:dateTime represented by the string date provided.
        -->
    <xsl:function name="dtf:padDateTimeWithTemplate" as="xs:dateTime">
        <xsl:param name="dateString" as="xs:string"/>
        <xsl:param name="dateTemplateString" as="xs:string"/>
        <xsl:value-of select="concat($dateString, substring($dateTemplateString, string-length(normalize-space($dateString))+1))"/>
    </xsl:function>
    <!--
                Returns true if the string provided represents an allowable dateTime
                format; false, otherwise. The allowable dateTime formats are defined
                in the DES for the PUBS.XML specification.
                @returns {xs:boolean} Returns true if the string provided represents an 
                    allowable dateTime format; false, otherwise. 
        -->
    <xsl:function name="dtf:isAllowableDateTimeFormat" as="xs:boolean">
        <xsl:param name="input" as="xs:string"/>
        <xsl:variable name="trimmedInput" as="xs:string" select="normalize-space($input)"/>
        <xsl:value-of select=" matches($trimmedInput, $gYearRegEx) or matches($trimmedInput, $gYearMonthRegEx) or matches($trimmedInput, $dateRegEx) or matches($trimmedInput, $dateHourMinTypeRegEx) or matches($trimmedInput, $dateTimeRegEx)"/>
    </xsl:function>
    <!--
                Returns the earliest xs:dateTime possible for the provided string
                representation of a dateTime. Fills in missing portions of the 
                dateTime with the earliest possible values. Default values for missing
                portions:
                MM = 01
                DD = 01
                hh = 00
                mm = 00
                ss = 00
                s  = 000
                @param {xs:string} dateString String representation of a date in one
                    of the allowable formats.
                @returns {xs:dateTime} The earliest xs:dateTime possible for the 
                    provided string representation of a dateTime.
        -->
    <xsl:function name="dtf:startDate" as="xs:dateTime">
        <xsl:param name="dateString" as="xs:string"/>
        <xsl:variable name="timeZonePortion" select="dtf:getTimeZone($dateString)"/>
        <xsl:variable name="dateTimePortion" select="dtf:removeTimeZone($dateString)"/>
        <xsl:variable name="outputDate"
                    select="dtf:padDateTimeWithTemplate($dateTimePortion, $startDateTimeTemplate)"/>
        <xsl:value-of select="concat($outputDate, $timeZonePortion)"/>
    </xsl:function>
    <!--
                Returns the latest xs:dateTime possible for the provided string
                representation of a dateTime. Fills in missing portions of the 
                dateTime with the latest possible values. Default values for missing
                portions:
                MM = 12
                DD = maximum day of the month
                hh = 23
                mm = 59
                ss = 59
                s  = 999
                @param {xs:string} dateString String representation of a date in one
                    of the allowable formats.
                @returns {xs:dateTime} The latest xs:dateTime possible for the 
                    provided string representation of a dateTime.
        -->
    <xsl:function name="dtf:endDate" as="xs:dateTime">
        <xsl:param name="input" as="xs:string"/>
        <xsl:variable name="timeZonePortion" select="dtf:getTimeZone($input)"/>
        <xsl:variable name="dateTimePortion" select="dtf:removeTimeZone($input)"/>
        <xsl:variable name="outputDate"
                    select="dtf:padDateTimeWithTemplate($dateTimePortion, $endDateTimeTemplate)"/>
        <xsl:variable name="outputWithCorrectedDay"
                    select="dtf:replaceDateTimeDay($outputDate, dtf:getMaxDay($outputDate))"/>
        <xsl:choose>
            <xsl:when test="dtf:getDay($input)">
                <xsl:value-of select="concat($outputDate, $timeZonePortion)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="concat($outputWithCorrectedDay, $timeZonePortion)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    <!--
                Calculates the date range implied for both primary and secondary and 
                determines if there is any overlap between the two ranges. Overlap is
                defined as the start of primary date range less than or equal to the 
                end of secondary date range, inclusive, and the start of the secondary
                date range less than or equal to the end of the primary date range.
                Returns true if there is any overlap; otherwise, returns false.
                @param {xs:string} primary String representation of a date in one
                    of the allowable formats.
                @param {xs:string} secondary String representation of a date in one
                    of the allowable formats.
                @returns {xs:boolean} Returns true if the date ranges implied by primary 
                    and secondary overlap at all; otherwise, returns false.
        -->
    <xsl:function name="dtf:overlaps" as="xs:boolean">
        <xsl:param name="primary" as="xs:string"/>
        <xsl:param name="secondary" as="xs:string"/>
        <xsl:variable name="primaryStart"
                    as="xs:dateTime"
                    select="dtf:startDate($primary)"/>
        <xsl:variable name="primaryEnd" as="xs:dateTime" select="dtf:endDate($primary)"/>
        <xsl:variable name="secondaryStart"
                    as="xs:dateTime"
                    select="dtf:startDate($secondary)"/>
        <xsl:variable name="secondaryEnd"
                    as="xs:dateTime"
                    select="dtf:endDate($secondary)"/>
        <xsl:value-of select="$primaryStart &lt;= $secondaryEnd and $secondaryStart &lt;= $primaryEnd"/>
    </xsl:function>
    <!--
                Determines if the date range implied by the string representation in 
                primary is strictly before the date range implied by the string
                representation in secondary. Returns true if the end of the date
                range implied by primary is less than the start of the date range
                implied by secondary; otherwise, returns false.
                @param {xs:string} primary String representation of a date in one
                    of the allowable formats.
                @param {xs:string} secondary String representation of a date in one
                    of the allowable formats.
                @returns {xs:boolean} Returns true if the date range implied by primary 
                    is strictly earlier than the date range implied by secondary; otherwise,
                    returns false.
        -->
    <xsl:function name="dtf:isBefore" as="xs:boolean">
        <xsl:param name="primary" as="xs:string"/>
        <xsl:param name="secondary" as="xs:string"/>
        <xsl:variable name="primaryEnd" as="xs:dateTime" select="dtf:endDate($primary)"/>
        <xsl:variable name="secondaryStart"
                    as="xs:dateTime"
                    select="dtf:startDate($secondary)"/>
        <xsl:value-of select="$primaryEnd &lt; $secondaryStart"/>
    </xsl:function>
    <!--
                Determines if the date range implied by the string representation in 
                primary is strictly after the date range implied by the string
                representation in secondary. Returns true if the end of the date
                range implied by primary is less than the start of the date range
                implied by secondary; otherwise, returns false.
                @param {xs:string} primary String representation of a date in one
                    of the allowable formats.
                @param {xs:string} secondary String representation of a date in one
                    of the allowable formats.
                @returns {xs:boolean} Returns true if the date range implied by primary 
                    is strictly later than the date range implied by secondary; otherwise,
                    returns false.
        -->
    <xsl:function name="dtf:isAfter" as="xs:boolean">
        <xsl:param name="primary" as="xs:string"/>
        <xsl:param name="secondary" as="xs:string"/>
        <xsl:variable name="primaryStart"
                    as="xs:dateTime"
                    select="dtf:startDate($primary)"/>
        <xsl:variable name="secondaryEnd"
                    as="xs:dateTime"
                    select="dtf:endDate($secondary)"/>
        <xsl:value-of select="$secondaryEnd &lt; $primaryStart"/>
    </xsl:function>
    <!--
                Determines if the date range implied by the string representation in 
                primary satisfies the comparison to the date range implied by secondary
                using the provided comparison operator; otherwise, returns false.
                
                Both primary and secondary must be in one of the allowable formats
                and represent dates with four digits in the year portion.
                @param {xs:string} primary String representation of a date in one
                    of the allowable formats.
                @param {xs:string} secondary String representation of a date in one
                    of the allowable formats.
                @returns {xs:boolean} Returns true if the date range implied by primary 
                    satisfies the comparison to the date range implied by secondary using
                    the provided comparison operator; otherwise, returns false.
        -->
    <xsl:function name="dtf:compareDateTimeRanges" as="xs:boolean">
        <xsl:param name="primary" as="xs:string"/>
        <xsl:param name="operator" as="xs:string"/>
        <xsl:param name="secondary" as="xs:string"/>
        <xsl:variable name="primaryAndSecondayYearPortionsHaveFourDigits"
                    as="xs:boolean"
                    select="dtf:yearPortionHasFourDigits($primary) and dtf:yearPortionHasFourDigits($secondary)"/>
        <xsl:choose>
            <xsl:when test="$primaryAndSecondayYearPortionsHaveFourDigits">
                <xsl:variable name="primaryStart"
                          as="xs:dateTime"
                          select="dtf:startDate($primary)"/>
                <xsl:variable name="primaryEnd" as="xs:dateTime" select="dtf:endDate($primary)"/>
                <xsl:variable name="secondaryStart"
                          as="xs:dateTime"
                          select="dtf:startDate($secondary)"/>
                <xsl:variable name="secondaryEnd"
                          as="xs:dateTime"
                          select="dtf:endDate($secondary)"/>
                <xsl:choose>
                    <!-- 'Less Than' Edge Case -->
                    <!-- 2010-01-01T00:00:00.000Z < 2010 -->
                    <xsl:when test="($operator = 'lt' or $operator = '&lt;') and (($primaryStart = $primaryEnd and $primaryStart = $secondaryStart) or ($primaryStart = $primaryEnd and $primaryStart = $secondaryEnd) or ($secondaryStart = $secondaryEnd and $primaryStart = $secondaryStart))">

                        <xsl:value-of select="false()"/>
                    </xsl:when>
                    <!-- 'Greater Than' Edge Case -->
                    <!-- 2010-12-31T23:59:59.999Z > 2010 -->
                    <xsl:when test="($operator = 'gt' or $operator = '&gt;') and (($primaryStart = $primaryEnd and $primaryEnd = $secondaryEnd) or ($primaryStart = $primaryEnd and $primaryEnd = $secondaryStart) or ($secondaryStart = $secondaryEnd and $primaryEnd = $secondaryEnd))">

                        <xsl:value-of select="false()"/>
                    </xsl:when>
                    <!-- 'Less Than' and 'Less Than or Equal' -->
                    <xsl:when test="$operator = 'lt' or $operator = '&lt;' or $operator = '&lt;='">
                        <xsl:value-of select="dtf:isBefore($primary, $secondary) or dtf:overlaps($primary, $secondary)"/>
                    </xsl:when>
                    <!-- 'Greater Than' and 'Greater Than or Equal' -->
                    <xsl:when test="$operator = 'gt' or $operator = '&gt;' or $operator = '&gt;='">
                        <xsl:value-of select="dtf:isAfter($primary, $secondary) or dtf:overlaps($primary, $secondary)"/>
                    </xsl:when>
                    <!-- Default to false() -->
                    <xsl:otherwise>
                        <xsl:value-of select="false()"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="false()"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:function>
    
    <xsl:function name="local:getAbsolutePath" as="xs:string">
        <!-- Given a path resolves any ".." or "." terms to produce an absolute path -->
        <xsl:param name="sourcePath" as="xs:string"/>
        <xsl:variable name="pathTokens"
                    select="tokenize($sourcePath, '/')"
                    as="xs:string*"/>
        <xsl:if test="false()">
            <xsl:message> + DEBUG local:getAbsolutePath(): Starting</xsl:message>
            <xsl:message> + sourcePath="<xsl:value-of select="$sourcePath"/>"</xsl:message>
        </xsl:if>
        <xsl:variable name="baseResult"
                    select="string-join(local:makePathAbsolute($pathTokens, ()), '/')"
                    as="xs:string"/>
        <xsl:variable name="result"
                    as="xs:string"
                    select="if (starts-with($sourcePath, '/') and not(starts-with($baseResult, '/')))             then concat('/', $baseResult)             else $baseResult             "/>
        <xsl:if test="false()">
            <xsl:message> + DEBUG: result="<xsl:value-of select="$result"/>"</xsl:message>
        </xsl:if>
        <xsl:value-of select="$result"/>
    </xsl:function>
    
    <xsl:function name="local:makePathAbsolute" as="xs:string*">
        <xsl:param name="pathTokens" as="xs:string*"/>
        <xsl:param name="resultTokens" as="xs:string*"/>
        <xsl:if test="false()">
            <xsl:message> + DEBUG: local:makePathAbsolute(): Starting...</xsl:message>
            <xsl:message> + DEBUG: pathTokens="<xsl:value-of select="string-join($pathTokens, ',')"/>"</xsl:message>
            <xsl:message> + DEBUG: resultTokens="<xsl:value-of select="string-join($resultTokens, ',')"/>"</xsl:message>
        </xsl:if>
        <xsl:sequence select="if (count($pathTokens) = 0)             then $resultTokens             else if ($pathTokens[1] = '.')             then local:makePathAbsolute($pathTokens[position() &gt; 1], $resultTokens)             else if ($pathTokens[1] = '..')             then local:makePathAbsolute($pathTokens[position() &gt; 1], $resultTokens[position() &lt; last()])             else local:makePathAbsolute($pathTokens[position() &gt; 1], ($resultTokens, $pathTokens[1]))             "/>
   </xsl:function>
    

   <!--****************************-->
<!-- (U) IRM Phases -->
<!--****************************-->
<!--****************************-->
<!-- (U) IRM ID Rules -->
<!--****************************-->

<!--(U) -->
   <sch:include href="./Rules/IRM_ID_00002.sch"/>
   <sch:include href="./Rules/IRM_ID_00005.sch"/>
   <sch:include href="./Rules/IRM_ID_00006.sch"/>
   <sch:include href="./Rules/IRM_ID_00007.sch"/>
   <sch:include href="./Rules/IRM_ID_00010.sch"/>
   <sch:include href="./Rules/IRM_ID_00015.sch"/>
   <sch:include href="./Rules/IRM_ID_00016.sch"/>
   <sch:include href="./Rules/IRM_ID_00017.sch"/>
   <sch:include href="./Rules/IRM_ID_00019.sch"/>
   <sch:include href="./Rules/IRM_ID_00020.sch"/>
   <sch:include href="./Rules/IRM_ID_00021.sch"/>
   <sch:include href="./Rules/IRM_ID_00022.sch"/>
   <sch:include href="./Rules/IRM_ID_00023.sch"/>
   <sch:include href="./Rules/IRM_ID_00024.sch"/>
   <sch:include href="./Rules/IRM_ID_00025.sch"/>
   <sch:include href="./Rules/IRM_ID_00029.sch"/>
   <sch:include href="./Rules/IRM_ID_00030.sch"/>
   <sch:include href="./Rules/IRM_ID_00033.sch"/>
   <sch:include href="./Rules/IRM_ID_00034.sch"/>
   <sch:include href="./Rules/IRM_ID_00036.sch"/>
   <sch:include href="./Rules/IRM_ID_00040.sch"/>
   <sch:include href="./Rules/IRM_ID_00041.sch"/>
   <sch:include href="./Rules/IRM_ID_00042.sch"/>
   <sch:include href="./Rules/IRM_ID_00043.sch"/>
   <sch:include href="./Rules/IRM_ID_00044.sch"/>
   <sch:include href="./Rules/IRM_ID_00045.sch"/>
   <sch:include href="./Rules/IRM_ID_00046.sch"/>
   <sch:include href="./Rules/IRM_ID_00047.sch"/>
   <sch:include href="./Rules/IRM_ID_00048.sch"/>
   <sch:include href="./Rules/IRM_ID_00053.sch"/>
   <sch:include href="./Rules/IRM_ID_00054.sch"/>
   <sch:include href="./Rules/IRM_ID_00055.sch"/>
   <sch:include href="./Rules/IRM_ID_00062.sch"/>
   <sch:include href="./Rules/IRM_ID_00063.sch"/>
   <sch:include href="./Rules/IRM_ID_00064.sch"/>
   <sch:include href="./Rules/IRM_ID_00065.sch"/>
   <sch:include href="./Rules/IRM_ID_00068.sch"/>
   <sch:include href="./Rules/IRM_ID_00070.sch"/>
   <sch:include href="./Rules/IRM_ID_00071.sch"/>
   <sch:include href="./Rules/IRM_ID_00072.sch"/>
   <sch:include href="./Rules/IRM_ID_00073.sch"/>
   <sch:include href="./Rules/IRM_ID_00074.sch"/>
   <sch:include href="./Rules/IRM_ID_00076.sch"/>
   <sch:include href="./Rules/IRM_ID_00077.sch"/>
   <sch:include href="./Rules/IRM_ID_00078.sch"/>
   <sch:include href="./Rules/IRM_ID_00079.sch"/>
   <sch:include href="./Rules/IRM_ID_00080.sch"/>
   <sch:include href="./Rules/IRM_ID_00081.sch"/>
   <sch:include href="./Rules/IRM_ID_00086.sch"/>
   <sch:include href="./Rules/IRM_ID_00087.sch"/>
   <sch:include href="./Rules/IRM_ID_00088.sch"/>
   <sch:include href="./Rules/IRM_ID_00089.sch"/>
   <sch:include href="./Rules/IRM_ID_00090.sch"/>
   <sch:include href="./Rules/IRM_ID_00091.sch"/>
   <sch:include href="./Rules/IRM_ID_00092.sch"/>
   <sch:include href="./Rules/IRM_ID_00093.sch"/>
   <sch:include href="./Rules/IRM_ID_00094.sch"/>
   <sch:include href="./Rules/IRM_ID_00095.sch"/>
   <sch:include href="./Rules/IRM_ID_00096.sch"/>
   <sch:include href="./Rules/IRM_ID_00098.sch"/>
   <sch:include href="./Rules/IRM_ID_00099.sch"/>
   <sch:include href="./Rules/IRM_ID_00100.sch"/>
   <sch:include href="./Rules/IRM_ID_00101.sch"/>
   <sch:include href="./Rules/IRM_ID_00102.sch"/>
   <sch:include href="./Rules/IRM_ID_00103.sch"/>
   <sch:include href="./Rules/IRM_ID_00104.sch"/>
   <sch:include href="./Rules/IRM_ID_00105.sch"/>
   <sch:include href="./Rules/IRM_ID_00106.sch"/>
   <sch:include href="./Rules/IRM_ID_00107.sch"/>
   <sch:include href="./Rules/IRM_ID_00108.sch"/>
   <sch:include href="./Rules/IRM_ID_00109.sch"/>
   <sch:include href="./Rules/IRM_ID_00110.sch"/>
   <sch:include href="./Rules/IRM_ID_00111.sch"/>
   <sch:include href="./Rules/IRM_ID_00112.sch"/>
   <sch:include href="./Rules/IRM_ID_00113.sch"/>
   <sch:include href="./Rules/IRM_ID_00114.sch"/>

   <!--****************************-->
<!-- (U) IRM Phases -->
<!--****************************--></sch:schema>
<!--UNCLASSIFIED-->
