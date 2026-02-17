<?xml version="1.0" encoding="UTF-8"?>
<!--UNCLASSIFIED--><xsl:stylesheet xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                xmlns:saxon="http://saxon.sf.net/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:schold="http://www.ascc.net/xml/schematron"
                xmlns:iso="http://purl.oclc.org/dsdl/schematron"
                xmlns:xhtml="http://www.w3.org/1999/xhtml"
                xmlns:virt="urn:us:gov:ic:virt"
                xmlns:ism="urn:us:gov:ic:ism"
                xmlns:irm="urn:us:gov:ic:irm"
                xmlns:ntk="urn:us:gov:ic:ntk"
                xmlns:tdf="urn:us:gov:ic:tdf"
                xmlns:icid="urn:us:gov:ic:id"
                xmlns:usagency="urn:us:gov:ic:usagency"
                xmlns:pm="urn:us:gov:ic:pm"
                xmlns:intdis="urn:us:gov:ic:intdis"
                xmlns:local="http://www.example.com/functions/local"
                xmlns:mime="urn:us:gov:ic:mime"
                xmlns:genc="urn:us:gov:ic:icgenc"
                xmlns:cve="urn:us:gov:ic:cve"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:dtf="date:time:function"
                xmlns:util="urn:us:gov:ic:irm:xsl:util"
                version="2.0"><!--Implementers: please note that overriding process-prolog or process-root is 
    the preferred method for meta-stylesheets to use where possible. -->
<xsl:param name="archiveDirParameter"/>
   <xsl:param name="archiveNameParameter"/>
   <xsl:param name="fileNameParameter"/>
   <xsl:param name="fileDirParameter"/>
   <xsl:variable name="document-uri">
      <xsl:value-of select="document-uri(/)"/>
   </xsl:variable>

   <!--PHASES-->


<!--PROLOG-->
<xsl:output xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
               method="xml"
               omit-xml-declaration="no"
               standalone="yes"
               indent="yes"/>

   <!--XSD TYPES FOR XSLT2-->


<!--KEYS AND FUNCTIONS-->
<xsl:function xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                 name="dtf:adjust-CombinedDate-to-GMT-timezone"
                 as="xs:string">
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
   <xsl:function xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                 name="util:meetsType"
                 as="xs:boolean">
        <xsl:param name="value"/>
        <xsl:param name="typePattern" as="xs:string"/>
        <xsl:value-of select="matches(string($value), concat('^(', $typePattern, ')$'))"/>
    </xsl:function>
   <xsl:function xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                 name="util:containsAnyOfTheTokens"
                 as="xs:boolean">
        <xsl:param name="attribute"/>
        <xsl:param name="tokenList" as="xs:string+"/>
        <xsl:value-of select="some $attrToken in tokenize(normalize-space(string($attribute)), ' ') satisfies $attrToken = $tokenList"/>
    </xsl:function>
   <xsl:function xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                 name="util:containsOnlyTheTokensSubstringBefore"
                 as="xs:boolean">
        <xsl:param name="delimiter" as="xs:string"/>
        <xsl:param name="attribute"/>
        <xsl:param name="tokenList" as="xs:string+"/>
        <xsl:value-of select="every $attrToken in tokenize(normalize-space(string($attribute)), ' ') satisfies substring-before($attrToken,$delimiter) = $tokenList"/>
    </xsl:function>
   <xsl:function xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                 name="util:checkUSATokenValidity"
                 as="xs:boolean">
        <xsl:param name="attribute"/>
        <xsl:param name="tokenList" as="xs:string+"/>
        <xsl:value-of select="every $attrToken in tokenize(normalize-space(string($attribute)), ' ') satisfies               if (starts-with($attrToken,'USA'))               then some $token in $tokenList satisfies $attrToken = $token or starts-with($attrToken,$token)              else true()"/>
    </xsl:function>
   <xsl:function xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                 name="dtf:getMaxDay"
                 as="xs:string">
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
   <xsl:function xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                 name="dtf:isLeapYear"
                 as="xs:boolean">
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
   <xsl:function xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                 name="dtf:replaceDateTimeDay"
                 as="xs:dateTime">
        <xsl:param name="dateTime" as="xs:dateTime"/>
        <xsl:param name="newDayString" as="xs:string"/>
        <xsl:variable name="beforeDay" select="substring(string($dateTime), 1, 8)"/>
        <xsl:variable name="afterDay" select="substring(string($dateTime), 11)"/>
        <xsl:value-of select="concat($beforeDay, $newDayString, $afterDay)"/>
    </xsl:function>
   <xsl:function xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                 name="dtf:getYear"
                 as="xs:string">
        <xsl:param name="dateString" as="xs:string"/>
        <xsl:value-of select="substring(dtf:removeTimeZone($dateString), 1, 4)"/>
    </xsl:function>
   <xsl:function xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                 name="dtf:getMonth"
                 as="xs:string">
        <xsl:param name="dateString" as="xs:string"/>
        <xsl:value-of select="substring(dtf:removeTimeZone($dateString), 6, 2)"/>
    </xsl:function>
   <xsl:function xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                 name="dtf:getDay"
                 as="xs:string">
        <xsl:param name="dateString" as="xs:string"/>
        <xsl:value-of select="substring(dtf:removeTimeZone($dateString), 9, 2)"/>
    </xsl:function>
   <xsl:function xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                 name="dtf:getTimeZone"
                 as="xs:string">
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
   <xsl:function xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                 name="dtf:yearPortionHasFourDigits"
                 as="xs:boolean">
        <xsl:param name="dateString" as="xs:string"/>
        <xsl:variable name="dateWithOnlyFourDigitYearAndOptionalTimeZoneRegEx"
                    as="xs:string"
                    select="concat('^\d{4}(',$timeZoneRegEx,')?$')"/>
        <xsl:variable name="dateStartingWithFourDigitYearRegEx"
                    as="xs:string"
                    select="'^\d{4}-.*$'"/>
        <xsl:value-of select="matches($dateString, $dateWithOnlyFourDigitYearAndOptionalTimeZoneRegEx) or matches($dateString, $dateStartingWithFourDigitYearRegEx)"/>
    </xsl:function>
   <xsl:function xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                 name="dtf:removeTimeZone"
                 as="xs:string">
        <xsl:param name="dateString" as="xs:string"/>
        <xsl:value-of select="replace($dateString, $timeZoneRegEx, '')"/>
    </xsl:function>
   <xsl:function xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                 name="dtf:padDateTimeWithTemplate"
                 as="xs:dateTime">
        <xsl:param name="dateString" as="xs:string"/>
        <xsl:param name="dateTemplateString" as="xs:string"/>
        <xsl:value-of select="concat($dateString, substring($dateTemplateString, string-length(normalize-space($dateString))+1))"/>
    </xsl:function>
   <xsl:function xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                 name="dtf:isAllowableDateTimeFormat"
                 as="xs:boolean">
        <xsl:param name="input" as="xs:string"/>
        <xsl:variable name="trimmedInput" as="xs:string" select="normalize-space($input)"/>
        <xsl:value-of select=" matches($trimmedInput, $gYearRegEx) or matches($trimmedInput, $gYearMonthRegEx) or matches($trimmedInput, $dateRegEx) or matches($trimmedInput, $dateHourMinTypeRegEx) or matches($trimmedInput, $dateTimeRegEx)"/>
    </xsl:function>
   <xsl:function xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                 name="dtf:startDate"
                 as="xs:dateTime">
        <xsl:param name="dateString" as="xs:string"/>
        <xsl:variable name="timeZonePortion" select="dtf:getTimeZone($dateString)"/>
        <xsl:variable name="dateTimePortion" select="dtf:removeTimeZone($dateString)"/>
        <xsl:variable name="outputDate"
                    select="dtf:padDateTimeWithTemplate($dateTimePortion, $startDateTimeTemplate)"/>
        <xsl:value-of select="concat($outputDate, $timeZonePortion)"/>
    </xsl:function>
   <xsl:function xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                 name="dtf:endDate"
                 as="xs:dateTime">
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
   <xsl:function xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                 name="dtf:overlaps"
                 as="xs:boolean">
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
   <xsl:function xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                 name="dtf:isBefore"
                 as="xs:boolean">
        <xsl:param name="primary" as="xs:string"/>
        <xsl:param name="secondary" as="xs:string"/>
        <xsl:variable name="primaryEnd" as="xs:dateTime" select="dtf:endDate($primary)"/>
        <xsl:variable name="secondaryStart"
                    as="xs:dateTime"
                    select="dtf:startDate($secondary)"/>
        <xsl:value-of select="$primaryEnd &lt; $secondaryStart"/>
    </xsl:function>
   <xsl:function xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                 name="dtf:isAfter"
                 as="xs:boolean">
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
   <xsl:function xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                 name="dtf:compareDateTimeRanges"
                 as="xs:boolean">
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
                    
                    
                    <xsl:when test="($operator = 'lt' or $operator = '&lt;') and (($primaryStart = $primaryEnd and $primaryStart = $secondaryStart) or ($primaryStart = $primaryEnd and $primaryStart = $secondaryEnd) or ($secondaryStart = $secondaryEnd and $primaryStart = $secondaryStart))">

                        <xsl:value-of select="false()"/>
                    </xsl:when>
                    
                    
                    <xsl:when test="($operator = 'gt' or $operator = '&gt;') and (($primaryStart = $primaryEnd and $primaryEnd = $secondaryEnd) or ($primaryStart = $primaryEnd and $primaryEnd = $secondaryStart) or ($secondaryStart = $secondaryEnd and $primaryEnd = $secondaryEnd))">

                        <xsl:value-of select="false()"/>
                    </xsl:when>
                    
                    <xsl:when test="$operator = 'lt' or $operator = '&lt;' or $operator = '&lt;='">
                        <xsl:value-of select="dtf:isBefore($primary, $secondary) or dtf:overlaps($primary, $secondary)"/>
                    </xsl:when>
                    
                    <xsl:when test="$operator = 'gt' or $operator = '&gt;' or $operator = '&gt;='">
                        <xsl:value-of select="dtf:isAfter($primary, $secondary) or dtf:overlaps($primary, $secondary)"/>
                    </xsl:when>
                    
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
   <xsl:function xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                 name="local:getAbsolutePath"
                 as="xs:string">
        
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
   <xsl:function xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                 name="local:makePathAbsolute"
                 as="xs:string*">
        <xsl:param name="pathTokens" as="xs:string*"/>
        <xsl:param name="resultTokens" as="xs:string*"/>
        <xsl:if test="false()">
            <xsl:message> + DEBUG: local:makePathAbsolute(): Starting...</xsl:message>
            <xsl:message> + DEBUG: pathTokens="<xsl:value-of select="string-join($pathTokens, ',')"/>"</xsl:message>
            <xsl:message> + DEBUG: resultTokens="<xsl:value-of select="string-join($resultTokens, ',')"/>"</xsl:message>
        </xsl:if>
        <xsl:sequence select="if (count($pathTokens) = 0)             then $resultTokens             else if ($pathTokens[1] = '.')             then local:makePathAbsolute($pathTokens[position() &gt; 1], $resultTokens)             else if ($pathTokens[1] = '..')             then local:makePathAbsolute($pathTokens[position() &gt; 1], $resultTokens[position() &lt; last()])             else local:makePathAbsolute($pathTokens[position() &gt; 1], ($resultTokens, $pathTokens[1]))             "/>
   </xsl:function>

   <!--DEFAULT RULES-->


<!--MODE: SCHEMATRON-SELECT-FULL-PATH-->
<!--This mode can be used to generate an ugly though full XPath for locators-->
<xsl:template match="*" mode="schematron-select-full-path">
      <xsl:apply-templates select="." mode="schematron-get-full-path"/>
   </xsl:template>

   <!--MODE: SCHEMATRON-FULL-PATH-->
<!--This mode can be used to generate an ugly though full XPath for locators-->
<xsl:template match="*" mode="schematron-get-full-path">
      <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      <xsl:text>/</xsl:text>
      <xsl:choose>
         <xsl:when test="namespace-uri()=''">
            <xsl:value-of select="name()"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>*:</xsl:text>
            <xsl:value-of select="local-name()"/>
            <xsl:text>[namespace-uri()='</xsl:text>
            <xsl:value-of select="namespace-uri()"/>
            <xsl:text>']</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:variable name="preceding"
                    select="count(preceding-sibling::*[local-name()=local-name(current())                                   and namespace-uri() = namespace-uri(current())])"/>
      <xsl:text>[</xsl:text>
      <xsl:value-of select="1+ $preceding"/>
      <xsl:text>]</xsl:text>
   </xsl:template>
   <xsl:template match="@*" mode="schematron-get-full-path">
      <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      <xsl:text>/</xsl:text>
      <xsl:choose>
         <xsl:when test="namespace-uri()=''">@<xsl:value-of select="name()"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>@*[local-name()='</xsl:text>
            <xsl:value-of select="local-name()"/>
            <xsl:text>' and namespace-uri()='</xsl:text>
            <xsl:value-of select="namespace-uri()"/>
            <xsl:text>']</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!--MODE: SCHEMATRON-FULL-PATH-2-->
<!--This mode can be used to generate prefixed XPath for humans-->
<xsl:template match="node() | @*" mode="schematron-get-full-path-2">
      <xsl:for-each select="ancestor-or-self::*">
         <xsl:text>/</xsl:text>
         <xsl:value-of select="name(.)"/>
         <xsl:if test="preceding-sibling::*[name(.)=name(current())]">
            <xsl:text>[</xsl:text>
            <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
            <xsl:text>]</xsl:text>
         </xsl:if>
      </xsl:for-each>
      <xsl:if test="not(self::*)">
         <xsl:text/>/@<xsl:value-of select="name(.)"/>
      </xsl:if>
   </xsl:template>
   <!--MODE: SCHEMATRON-FULL-PATH-3-->
<!--This mode can be used to generate prefixed XPath for humans 
	(Top-level element has index)-->
<xsl:template match="node() | @*" mode="schematron-get-full-path-3">
      <xsl:for-each select="ancestor-or-self::*">
         <xsl:text>/</xsl:text>
         <xsl:value-of select="name(.)"/>
         <xsl:if test="parent::*">
            <xsl:text>[</xsl:text>
            <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
            <xsl:text>]</xsl:text>
         </xsl:if>
      </xsl:for-each>
      <xsl:if test="not(self::*)">
         <xsl:text/>/@<xsl:value-of select="name(.)"/>
      </xsl:if>
   </xsl:template>

   <!--MODE: GENERATE-ID-FROM-PATH -->
<xsl:template match="/" mode="generate-id-from-path"/>
   <xsl:template match="text()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.text-', 1+count(preceding-sibling::text()), '-')"/>
   </xsl:template>
   <xsl:template match="comment()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.comment-', 1+count(preceding-sibling::comment()), '-')"/>
   </xsl:template>
   <xsl:template match="processing-instruction()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.processing-instruction-', 1+count(preceding-sibling::processing-instruction()), '-')"/>
   </xsl:template>
   <xsl:template match="@*" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.@', name())"/>
   </xsl:template>
   <xsl:template match="*" mode="generate-id-from-path" priority="-0.5">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:text>.</xsl:text>
      <xsl:value-of select="concat('.',name(),'-',1+count(preceding-sibling::*[name()=name(current())]),'-')"/>
   </xsl:template>

   <!--MODE: GENERATE-ID-2 -->
<xsl:template match="/" mode="generate-id-2">U</xsl:template>
   <xsl:template match="*" mode="generate-id-2" priority="2">
      <xsl:text>U</xsl:text>
      <xsl:number level="multiple" count="*"/>
   </xsl:template>
   <xsl:template match="node()" mode="generate-id-2">
      <xsl:text>U.</xsl:text>
      <xsl:number level="multiple" count="*"/>
      <xsl:text>n</xsl:text>
      <xsl:number count="node()"/>
   </xsl:template>
   <xsl:template match="@*" mode="generate-id-2">
      <xsl:text>U.</xsl:text>
      <xsl:number level="multiple" count="*"/>
      <xsl:text>_</xsl:text>
      <xsl:value-of select="string-length(local-name(.))"/>
      <xsl:text>_</xsl:text>
      <xsl:value-of select="translate(name(),':','.')"/>
   </xsl:template>
   <!--Strip characters--><xsl:template match="text()" priority="-1"/>

   <!--SCHEMA SETUP-->
<xsl:template match="/">
      <svrl:schematron-output xmlns:svrl="http://purl.oclc.org/dsdl/svrl" title="" schemaVersion="">
         <xsl:comment>
            <xsl:value-of select="$archiveDirParameter"/>   
		 <xsl:value-of select="$archiveNameParameter"/>  
		 <xsl:value-of select="$fileNameParameter"/>  
		 <xsl:value-of select="$fileDirParameter"/>
         </xsl:comment>
         <svrl:text>
        This is the root file for the specifications Schematron ruleset. It loads all of the required CVEs, 
        declares some variables, and includes all of the Rule .sch files.</svrl:text>
         <svrl:ns-prefix-in-attribute-values uri="http://www.w3.org/2001/XMLSchema" prefix="xsd"/>
         <svrl:ns-prefix-in-attribute-values uri="urn:us:gov:ic:virt" prefix="virt"/>
         <svrl:ns-prefix-in-attribute-values uri="urn:us:gov:ic:ism" prefix="ism"/>
         <svrl:ns-prefix-in-attribute-values uri="urn:us:gov:ic:irm" prefix="irm"/>
         <svrl:ns-prefix-in-attribute-values uri="urn:us:gov:ic:ntk" prefix="ntk"/>
         <svrl:ns-prefix-in-attribute-values uri="urn:us:gov:ic:tdf" prefix="tdf"/>
         <svrl:ns-prefix-in-attribute-values uri="urn:us:gov:ic:id" prefix="icid"/>
         <svrl:ns-prefix-in-attribute-values uri="urn:us:gov:ic:usagency" prefix="usagency"/>
         <svrl:ns-prefix-in-attribute-values uri="urn:us:gov:ic:pm" prefix="pm"/>
         <svrl:ns-prefix-in-attribute-values uri="urn:us:gov:ic:intdis" prefix="intdis"/>
         <svrl:ns-prefix-in-attribute-values uri="http://www.example.com/functions/local" prefix="local"/>
         <svrl:ns-prefix-in-attribute-values uri="urn:us:gov:ic:mime" prefix="mime"/>
         <svrl:ns-prefix-in-attribute-values uri="urn:us:gov:ic:icgenc" prefix="genc"/>
         <svrl:ns-prefix-in-attribute-values uri="urn:us:gov:ic:cve" prefix="cve"/>
         <svrl:ns-prefix-in-attribute-values uri="http://www.w3.org/1999/xlink" prefix="xlink"/>
         <svrl:ns-prefix-in-attribute-values uri="http://www.w3.org/1999/XSL/Transform" prefix="xsl"/>
         <svrl:ns-prefix-in-attribute-values uri="date:time:function" prefix="dtf"/>
         <svrl:ns-prefix-in-attribute-values uri="urn:us:gov:ic:irm:xsl:util" prefix="util"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <svrl:text>Abstract rule, which asserts that each date contained within the list $dateList has a year value within the range
           $minYear and $maxYear, inclusive. If any value in $dateList is not a valid date format, then return true because there is no guarantee
           the value provided is not allowed.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M58"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <svrl:text>Abstract rule, which asserts that the date contained within $dateValue has a year value within the range $minYear
           and $maxYear, inclusive.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M59"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">typeConstraintPatterns</xsl:attribute>
            <xsl:attribute name="name">typeConstraintPatterns</xsl:attribute>
            <svrl:text>Collection of global variables for use in other Schematron rules.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M60"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IRM-ID-00002</xsl:attribute>
            <xsl:attribute name="name">IRM-ID-00002</xsl:attribute>
            <svrl:text>[IRM-ID-00002][Error] For every attribute in the namespace [urn:us:gov:ic:irm], a non-whitespace value must be
           specified. Human Readable:</svrl:text>
            <svrl:text>For each element which specifies an attribute in the IRM namespace, ensure that each attribute in the IRM
           namespace specifies a non-whitespace value.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M85"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IRM-ID-00005</xsl:attribute>
            <xsl:attribute name="name">IRM-ID-00005</xsl:attribute>
            <svrl:text>irm:language[@irm:qualifier='urn:us:gov:ic:cvenum:irm:iso639:digraph'] := the context in which the searchValue exists</svrl:text>
            <svrl:text>@irm:value := the value which you want to verify is in the list</svrl:text>
            <svrl:text>$iso639DigraphList := the list in which to search for the searchValue</svrl:text>
            <svrl:text>' [IRM-ID-00005][Error] If element irm:language has the attribute @irm:qualifier value of [urn:us:gov:ic:cvenum:irm:iso639:digraph] then the value of attribute @irm:value must be in CVEnumIRMISO639Digraph.xml and no country code portion may be specified in the irm:language element value. Human Readable: ISO 639 digraph language codes must be in the ISO 639 digraph CVE. ' := the error message text to display when the assertion fails</svrl:text>
            <svrl:text>This abstract pattern checks to see if an attribute of an element exists in a list.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M86"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IRM-ID-00006</xsl:attribute>
            <xsl:attribute name="name">IRM-ID-00006</xsl:attribute>
            <svrl:text>irm:language[@irm:qualifier='urn:us:gov:ic:cvenum:irm:iso639-2:trigraph'] := the context in which the searchValue exists</svrl:text>
            <svrl:text>@irm:value := the value which you want to verify is in the list</svrl:text>
            <svrl:text>$iso639-2TrigraphList := the list in which to search for the searchValue</svrl:text>
            <svrl:text>' [IRM-ID-00006][Error] If element irm:language has the attribute @irm:qualifier value of [urn:us:gov:ic:cvenum:irm:iso639-2:trigraph] then the value of attribute @irm:value must be in CVEnumIRMISO639-2Trigraph.xml and no country code portion may be specified in the irm:value attribute value. Human Readable: ISO 639-2 trigraph language codes must be in the ISO 639-2 trigraph CVE. ' := the error message text to display when the assertion fails</svrl:text>
            <svrl:text>This abstract pattern checks to see if an attribute of an element exists in a list.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M87"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IRM-ID-00007</xsl:attribute>
            <xsl:attribute name="name">IRM-ID-00007</xsl:attribute>
            <svrl:text>irm:language[@irm:qualifier='urn:us:gov:ic:cvenum:irm:iso639-3:trigraph'] := the context in which the searchValue exists</svrl:text>
            <svrl:text>@irm:value := the value which you want to verify is in the list</svrl:text>
            <svrl:text>$iso639-3TrigraphList := the list in which to search for the searchValue</svrl:text>
            <svrl:text>' [IRM-ID-00007][Error] If element irm:language has the attribute @irm:qualifier value of [urn:us:gov:ic:cvenum:irm:iso639-3:trigraph] then the value of attribute @irm:value must be in CVEnumIRMISO639-3Trigraph.xml and no country code portion may be specified in the irm:value attribute value. Human Readable: ISO 639-3 trigraph language codes must in the the ISO 639-3 trigraph CVE. ' := the error message text to display when the assertion fails</svrl:text>
            <svrl:text>This abstract pattern checks to see if an attribute of an element exists in a list.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M88"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IRM-ID-00010</xsl:attribute>
            <xsl:attribute name="name">IRM-ID-00010</xsl:attribute>
            <svrl:text>[IRM-ID-00010][Error] If element irm:language has the attribute @irm:qualifier value of [RFC5646] then the
           language code portion of the @irm:value attribute value must be in CVEnumIRMISO639Digraph.xml or CVEnumIRMISO639-2Trigraph.xml and the
           country code portion, if present, must be in CVEnumIRMCoverageISO3166Digraph.xml. Human Readable: RFC5646 language codes must comply with
           the RFC by using parts from ISO 639 Digraph or ISO 639-2 Trigraph and ISO 3166 Digraph.</svrl:text>
            <svrl:text>Finds irm:language elements and checks its qualifier attribute for a value of [RFC5646]. If this value is found it
           will ensure that the value of the element's irm:value attribute exists in the CVEnumIRMISO639Digraph.xml or CVEnumIRMISO639-2Trigraph.xml
           enumeration files represented by the $iso639DigraphList or $iso639-2TrigraphList variables. Country code portions (denoted by '-'
           separation) must be in the CVEnumIRMCoverageISO3166Digraph.xml enumeration file represented by the $coverageIso3166TrigraphList
           variable.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M89"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IRM-ID-00015</xsl:attribute>
            <xsl:attribute name="name">IRM-ID-00015</xsl:attribute>
            <svrl:text>[IRM-ID-00015][Error] If element irm:dates exists without one of the attributes @irm:created or @irm:posted Human
           Readable: Every irm:dates element must have at least one of @irm:created or @irm:posted.</svrl:text>
            <svrl:text>This rule checks that for each occurrence of irm:dates that either @irm:created or @irm:posted is
           specified.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M90"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IRM-ID-00016</xsl:attribute>
            <xsl:attribute name="name">IRM-ID-00016</xsl:attribute>
            <svrl:text>[IRM-ID-00016][Error] The permissible values for the year range are 1901 through the current year for attributes
           @irm:approvedOn, @irm:dateProcessed, @irm:receivedOn, @irm:infoCutOff, @irm:posted, and @irm:created. Human Readable: Dates must be after
           1901 and in the past for @irm:approvedOn, @irm:dateProcessed, @irm:receivedOn, @irm:infoCutOff, @irm:posted, and @irm:created.</svrl:text>
            <svrl:text>This pattern uses abstract rules to consolidate logic. For attributes, ensure that each date contained
           within $dateList has a year value within the range $minYear and $maxYear, inclusive.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M91"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IRM-ID-00017</xsl:attribute>
            <xsl:attribute name="name">IRM-ID-00017</xsl:attribute>
            <svrl:text>[IRM-ID-00017][Error] The permissible values for the year range are 1901 through 9999 for attribute @irm:validTil.
           Human Readable: @irm:validTil must be after 1901.</svrl:text>
            <svrl:text>This pattern uses abstract rules to consolidate logic. For attributes, ensure that each date contained
           within $dateList has a year value within the range $minYear and $maxYear, inclusive.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M92"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IRM-ID-00019</xsl:attribute>
            <xsl:attribute name="name">IRM-ID-00019</xsl:attribute>
            <svrl:text>tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage[$IC_COMPLIANCE]//*[@irm:approvedOn] := an xpath to an element</svrl:text>
            <svrl:text>@irm:approvedOn := an xpath, relative to tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage[$IC_COMPLIANCE]//*[@irm:approvedOn], to a date to compare against all dates in
           (@irm:created, @irm:posted)</svrl:text>
            <svrl:text>(@irm:created, @irm:posted) := a list of xpaths, relative to tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage[$IC_COMPLIANCE]//*[@irm:approvedOn], each to a dates in which to compare against
           @irm:approvedOn</svrl:text>
            <svrl:text>'&lt;=' := the equality operator to use for comparing each date in (@irm:created, @irm:posted) to @irm:approvedOn</svrl:text>
            <svrl:text>First, ensure that the primaryDate is an allowable date format. If the primary date is not a valid 
        date format, then return true because there is no guarantee the value provided is not allowed. Then, for
        each date in (@irm:created, @irm:posted), perform the same check for a valid date format and compare the 
        secondaryDate to the primaryDate. To perform comparisons between dates, take the comparison operator
        contained in the param '&lt;=' and ensure that all comparisons between primary and secondary dates
        return true.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M93"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IRM-ID-00020</xsl:attribute>
            <xsl:attribute name="name">IRM-ID-00020</xsl:attribute>
            <svrl:text>tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage[$IC_COMPLIANCE]//*[@irm:infoCutOff] := an xpath to an element</svrl:text>
            <svrl:text>@irm:infoCutOff := an xpath, relative to tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage[$IC_COMPLIANCE]//*[@irm:infoCutOff], to a date to compare against all dates in
           (@irm:created, @irm:posted)</svrl:text>
            <svrl:text>(@irm:created, @irm:posted) := a list of xpaths, relative to tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage[$IC_COMPLIANCE]//*[@irm:infoCutOff], each to a dates in which to compare against
           @irm:infoCutOff</svrl:text>
            <svrl:text>'&lt;=' := the equality operator to use for comparing each date in (@irm:created, @irm:posted) to @irm:infoCutOff</svrl:text>
            <svrl:text>First, ensure that the primaryDate is an allowable date format. If the primary date is not a valid 
        date format, then return true because there is no guarantee the value provided is not allowed. Then, for
        each date in (@irm:created, @irm:posted), perform the same check for a valid date format and compare the 
        secondaryDate to the primaryDate. To perform comparisons between dates, take the comparison operator
        contained in the param '&lt;=' and ensure that all comparisons between primary and secondary dates
        return true.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M94"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IRM-ID-00021</xsl:attribute>
            <xsl:attribute name="name">IRM-ID-00021</xsl:attribute>
            <svrl:text>tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage[$IC_COMPLIANCE]//*[@irm:validTil] := an xpath to an element</svrl:text>
            <svrl:text>@irm:validTil := an xpath, relative to tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage[$IC_COMPLIANCE]//*[@irm:validTil], to a date to compare against all dates in
           (@irm:created, @irm:posted, @irm:infoCutOff, @irm:approvedOn)</svrl:text>
            <svrl:text>(@irm:created, @irm:posted, @irm:infoCutOff, @irm:approvedOn) := a list of xpaths, relative to tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage[$IC_COMPLIANCE]//*[@irm:validTil], each to a dates in which to compare against
           @irm:validTil</svrl:text>
            <svrl:text>'&gt;=' := the equality operator to use for comparing each date in (@irm:created, @irm:posted, @irm:infoCutOff, @irm:approvedOn) to @irm:validTil</svrl:text>
            <svrl:text>First, ensure that the primaryDate is an allowable date format. If the primary date is not a valid 
        date format, then return true because there is no guarantee the value provided is not allowed. Then, for
        each date in (@irm:created, @irm:posted, @irm:infoCutOff, @irm:approvedOn), perform the same check for a valid date format and compare the 
        secondaryDate to the primaryDate. To perform comparisons between dates, take the comparison operator
        contained in the param '&gt;=' and ensure that all comparisons between primary and secondary dates
        return true.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M95"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IRM-ID-00022</xsl:attribute>
            <xsl:attribute name="name">IRM-ID-00022</xsl:attribute>
            <svrl:text>tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:temporalCoverage := an xpath to an element</svrl:text>
            <svrl:text>irm:start := an xpath, relative to tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:temporalCoverage, to a date to compare against all dates in
           (irm:end)</svrl:text>
            <svrl:text>(irm:end) := a list of xpaths, relative to tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:temporalCoverage, each to a dates in which to compare against
           irm:start</svrl:text>
            <svrl:text>'&lt;=' := the equality operator to use for comparing each date in (irm:end) to irm:start</svrl:text>
            <svrl:text>First, ensure that the primaryDate is an allowable date format. If the primary date is not a valid 
        date format, then return true because there is no guarantee the value provided is not allowed. Then, for
        each date in (irm:end), perform the same check for a valid date format and compare the 
        secondaryDate to the primaryDate. To perform comparisons between dates, take the comparison operator
        contained in the param '&lt;=' and ensure that all comparisons between primary and secondary dates
        return true.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M96"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IRM-ID-00023</xsl:attribute>
            <xsl:attribute name="name">IRM-ID-00023</xsl:attribute>
            <svrl:text>[IRM-ID-00023][Error] The permissible values for the year range are 0001 through 9999 for elements irm:start and
           irm:end. Human Readable: irm:start and irm:end must be positive integers less than 10,000.</svrl:text>
            <svrl:text>This pattern uses abstract rules to consolidate logic. For attributes, ensure that each date contained
           within $dateList has a year value within the range $minYear and $maxYear, inclusive.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M97"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IRM-ID-00024</xsl:attribute>
            <xsl:attribute name="name">IRM-ID-00024</xsl:attribute>
            <svrl:text>[IRM-ID-00024][Warning] For elements irm:start and irm:end and attributes @irm:approvedOn, @irm:dateProcessed,
           @irm:receivedOn, @irm:infoCutOff, @irm:posted, @irm:validTil, and @irm:created, if the time designator (T) is specified, it is recommended
           that time zone be specified. Human Readable: For elements and attributes of date-time types, if the time designator (T) is specified, it
           is recommended that time zone be specified.</svrl:text>
            <svrl:text>The pattern applies to irm:start and irm:end elements, as well as any element that contains one or more attributes
           @irm:approvedOn, @irm:infoCutOff, @irm:posted, and @irm:created. It joins each of these attribute values, if present, into a larger
           space-separated string. It then breaks this string into tokens at each space character. If the value of the token contains the time zone
           designator (T), then it makes sure that the token value matches the regular expression for a timeZone, which is defined in the main schema
           file (IRM_XML.sch).</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M98"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IRM-ID-00025</xsl:attribute>
            <xsl:attribute name="name">IRM-ID-00025</xsl:attribute>
            <svrl:text>[IRM-ID-00025][Error] The attribute @ism:excludeFromRollup must not be specified for any element in the namespace
           [urn:us:gov:ic:irm] in a TDF IRM assertion. Human readable: Elements in IRM TDF assertions are not allowed to be excluded from roll-up
           because the security markings are now in the TDF assertion statement metadata.</svrl:text>
            <svrl:text>The attribute @ism:excludeFromRollup must not be specified for any element in the namespace [urn:us:gov:ic:irm] in
           a TDF IRM assertion.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M99"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IRM-ID-00029</xsl:attribute>
            <xsl:attribute name="name">IRM-ID-00029</xsl:attribute>
            <svrl:text>[IRM-ID-00029][Error] If
    element irm:geospatialCoverage has attribute @irm:precedence with a value of [Secondary], there
    must be at least one sibling element irm:geospatialCoverage for which attribute @irm:precedence
    has a value of [Primary]. Human Readable: If a secondary country code is provided, there must
    also be a primary country code.</svrl:text>
            <svrl:text>If there is an element
    geospatialCoverage with attribute precedence specified with a value of [Secondary], make sure
    that there is at least one sibling geospatialCoverage element with attribute precedence
    specified with a value of [Primary].</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M100"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IRM-ID-00030</xsl:attribute>
            <xsl:attribute name="name">IRM-ID-00030</xsl:attribute>
            <svrl:text>[IRM-ID-00030][Error] If attribute @irm:order is specified with integer value N, there must exist other @irm:order
           attributes with values 1 to N-1 with no duplicates. Human Readable: The values of attribute @irm:order must be numbered sequentially with
           no duplicates, beginning at 1.</svrl:text>
            <svrl:text>A list, named $orderList, is created containing the value of each order attribute within the document after
           normalizing to remove extra white-space. If the total number of items in $orderList does not equal the number of distinct values in
           $orderList, then return false because a duplicate exists. Otherwise, ensure that each number from 1 to N, where N is the number of
           items in $orderList, is contained within $orderList. If each number is contained, then return true. Otherwise, false.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M101"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IRM-ID-00033</xsl:attribute>
            <xsl:attribute name="name">IRM-ID-00033</xsl:attribute>
            <svrl:text>tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage[$IC_COMPLIANCE]//irm:mimeType := the context in which the searchValue exists</svrl:text>
            <svrl:text>. := the value which you want to verify is in the list</svrl:text>
            <svrl:text>$mimeTypeList := the list in which to search for the searchValue</svrl:text>
            <svrl:text>' [IRM-ID-00033][Error] If element irm:mimeType is specified, it must match any explicit values or         the media type wildcard regex from CVEnumMIMEType.xml. ' := the error message text to display when the assertion fails</svrl:text>
            <svrl:text>This abstract pattern checks to see if an attribute of an element exists in a list.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M102"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IRM-ID-00034</xsl:attribute>
            <xsl:attribute name="name">IRM-ID-00034</xsl:attribute>
            <svrl:text>tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage[$IC_COMPLIANCE]//irm:language := the context in which the searchValue exists</svrl:text>
            <svrl:text>@irm:qualifier := the value which you want to verify is in the list</svrl:text>
            <svrl:text>$compoundLanguageQualifierTypeList := the list in which to search for the searchValue</svrl:text>
            <svrl:text>' [IRM-ID-00034][Error] For element irm:language, attribute irm:qualifier must have a value in CVEnumIRMCompoundLanguageQualifierType.xml. ' := the error message text to display when the assertion fails</svrl:text>
            <svrl:text>This abstract pattern checks to see if an attribute of an element exists in a list.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M103"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IRM-ID-00036</xsl:attribute>
            <xsl:attribute name="name">IRM-ID-00036</xsl:attribute>
            <svrl:text>[IRM-ID-00036][Error] For any element, if any attribute is specified with the xlink namespace
           [http://www.w3.org/1999/xlink], then attributes @xlink:type and/or @xlink:href must be specified. Human Readable: If any XLink attributes
           are specified for an element, then the type and/or URL of the link must also be specified.</svrl:text>
            <svrl:text>Makes sure that for each element that has any attribute in the xlink namespace has either xlink:type or xlink:href
           specified.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M104"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IRM-ID-00040</xsl:attribute>
            <xsl:attribute name="name">IRM-ID-00040</xsl:attribute>
            <svrl:text>$qualifier := the qualifier value that requires ism to be present</svrl:text>
            <svrl:text>' [IRM-ID-00040][Error] If element irm:type is specified with a qualifier of [urn:us:gov:ic:cvenum:irm:activity], then attribute ism:classification must also be specified. ' := the error message text to display when the assertion fails</svrl:text>
            <svrl:text>This abstract pattern checks that if a particular qualifier is specified on a irm:type element that
           ism:classification is also specified.</svrl:text>
            <svrl:text>Example usage: &lt;sch:pattern xmlns:ism="urn:us:gov:ic:ism" is-a="DdmsTypeIsmEnforcement" id="IRM_ID_00039"
           xmlns:sch="http://purl.oclc.org/dsdl/schematron"&gt; &lt;sch:param name="ruleText" value=""/&gt; &lt;sch:param name="codeDesc"
           value=""/&gt; &lt;sch:param name="context" value="irm:type[@irm:qualifier=$qualifier]"/&gt; &lt;sch:param name="errMsg" value="'
           [IRM-ID-00039][Error] If irm:type is specified with a qualifier of urn:us:gov:ic:irm:productline then ism:classification must also be
           specified. '"/&gt; &lt;/sch:pattern&gt; Note: $iso4217TrigraphList is defined in the main document, IRM_XML.xml.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M105"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IRM-ID-00041</xsl:attribute>
            <xsl:attribute name="name">IRM-ID-00041</xsl:attribute>
            <svrl:text>$qualifier := the qualifier value that requires ism to be present</svrl:text>
            <svrl:text>' [IRM-ID-00041][Error] If element irm:type is specified with a qualifier of [urn:us:gov:ic:cvenum:intdis:inteldiscipline], then attribute ism:classification must also be specified. ' := the error message text to display when the assertion fails</svrl:text>
            <svrl:text>This abstract pattern checks that if a particular qualifier is specified on a irm:type element that
           ism:classification is also specified.</svrl:text>
            <svrl:text>Example usage: &lt;sch:pattern xmlns:ism="urn:us:gov:ic:ism" is-a="DdmsTypeIsmEnforcement" id="IRM_ID_00039"
           xmlns:sch="http://purl.oclc.org/dsdl/schematron"&gt; &lt;sch:param name="ruleText" value=""/&gt; &lt;sch:param name="codeDesc"
           value=""/&gt; &lt;sch:param name="context" value="irm:type[@irm:qualifier=$qualifier]"/&gt; &lt;sch:param name="errMsg" value="'
           [IRM-ID-00039][Error] If irm:type is specified with a qualifier of urn:us:gov:ic:irm:productline then ism:classification must also be
           specified. '"/&gt; &lt;/sch:pattern&gt; Note: $iso4217TrigraphList is defined in the main document, IRM_XML.xml.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M106"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IRM-ID-00042</xsl:attribute>
            <xsl:attribute name="name">IRM-ID-00042</xsl:attribute>
            <svrl:text>$qualifier := the qualifier value that requires ism to be present</svrl:text>
            <svrl:text>' [IRM-ID-00042][Error] If element irm:type is specified with a qualifier of [urn:us:gov:ic:cvenum:intdis:inteldiscipline:component], then attribute ism:classification must also be specified. ' := the error message text to display when the assertion fails</svrl:text>
            <svrl:text>This abstract pattern checks that if a particular qualifier is specified on a irm:type element that
           ism:classification is also specified.</svrl:text>
            <svrl:text>Example usage: &lt;sch:pattern xmlns:ism="urn:us:gov:ic:ism" is-a="DdmsTypeIsmEnforcement" id="IRM_ID_00039"
           xmlns:sch="http://purl.oclc.org/dsdl/schematron"&gt; &lt;sch:param name="ruleText" value=""/&gt; &lt;sch:param name="codeDesc"
           value=""/&gt; &lt;sch:param name="context" value="irm:type[@irm:qualifier=$qualifier]"/&gt; &lt;sch:param name="errMsg" value="'
           [IRM-ID-00039][Error] If irm:type is specified with a qualifier of urn:us:gov:ic:irm:productline then ism:classification must also be
           specified. '"/&gt; &lt;/sch:pattern&gt; Note: $iso4217TrigraphList is defined in the main document, IRM_XML.xml.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M107"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IRM-ID-00043</xsl:attribute>
            <xsl:attribute name="name">IRM-ID-00043</xsl:attribute>
            <svrl:text>$qualifier := the qualifier value that requires ism to be present</svrl:text>
            <svrl:text>' [IRM-ID-00043][Error] If element irm:type is specified with a qualifier of [urn:us:gov:ic:cvenum:intdis:inteldiscipline:component:technique], then attribute ism:classification must also be specified. ' := the error message text to display when the assertion fails</svrl:text>
            <svrl:text>This abstract pattern checks that if a particular qualifier is specified on a irm:type element that
           ism:classification is also specified.</svrl:text>
            <svrl:text>Example usage: &lt;sch:pattern xmlns:ism="urn:us:gov:ic:ism" is-a="DdmsTypeIsmEnforcement" id="IRM_ID_00039"
           xmlns:sch="http://purl.oclc.org/dsdl/schematron"&gt; &lt;sch:param name="ruleText" value=""/&gt; &lt;sch:param name="codeDesc"
           value=""/&gt; &lt;sch:param name="context" value="irm:type[@irm:qualifier=$qualifier]"/&gt; &lt;sch:param name="errMsg" value="'
           [IRM-ID-00039][Error] If irm:type is specified with a qualifier of urn:us:gov:ic:irm:productline then ism:classification must also be
           specified. '"/&gt; &lt;/sch:pattern&gt; Note: $iso4217TrigraphList is defined in the main document, IRM_XML.xml.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M108"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IRM-ID-00044</xsl:attribute>
            <xsl:attribute name="name">IRM-ID-00044</xsl:attribute>
            <svrl:text>$qualifier := the qualifier value that requires ism to be present</svrl:text>
            <svrl:text>' [IRM-ID-00044][Error] If element irm:type is specified with a qualifier of [urn:us:gov:ic:irm:productline] then attribute ism:classification must also be specified. ' := the error message text to display when the assertion fails</svrl:text>
            <svrl:text>This abstract pattern checks that if a particular qualifier is specified on a irm:type element that
           ism:classification is also specified.</svrl:text>
            <svrl:text>Example usage: &lt;sch:pattern xmlns:ism="urn:us:gov:ic:ism" is-a="DdmsTypeIsmEnforcement" id="IRM_ID_00039"
           xmlns:sch="http://purl.oclc.org/dsdl/schematron"&gt; &lt;sch:param name="ruleText" value=""/&gt; &lt;sch:param name="codeDesc"
           value=""/&gt; &lt;sch:param name="context" value="irm:type[@irm:qualifier=$qualifier]"/&gt; &lt;sch:param name="errMsg" value="'
           [IRM-ID-00039][Error] If irm:type is specified with a qualifier of urn:us:gov:ic:irm:productline then ism:classification must also be
           specified. '"/&gt; &lt;/sch:pattern&gt; Note: $iso4217TrigraphList is defined in the main document, IRM_XML.xml.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M109"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IRM-ID-00045</xsl:attribute>
            <xsl:attribute name="name">IRM-ID-00045</xsl:attribute>
            <svrl:text>[IRM-ID-00045][Error] Element irm:geospatialCoverage must have ISM classification markings. Human Readable: The
           geospatialCoverage element must have a classification attribute.</svrl:text>
            <svrl:text>For each irm:geospatialCoverage element, ensure that attribute ism:classification is specified.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M110"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IRM-ID-00046</xsl:attribute>
            <xsl:attribute name="name">IRM-ID-00046</xsl:attribute>
            <svrl:text>tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:type[@irm:qualifier='urn:us:gov:ic:cvenum:intdis:inteldiscipline:component:technique'] := the context in which the searchValue exists</svrl:text>
            <svrl:text>@irm:value := the value which you want to verify is in the list</svrl:text>
            <svrl:text>$intelDisciplineComponentTechniqueList := the list in which to search for the searchValue</svrl:text>
            <svrl:text>' [IRM-ID-00046][Error] If element irm:type has attribute @irm:qualifier specified as [urn:us:gov:ic:cvenum:intdis:inteldiscipline:component:technique] the attribute @irm:value must be in CVEnumIntelDisciplineComponentTechnique.xml. Human Readable: Intel Discipline Component Techniques must be in the CVEnumIntelDisciplineComponentTechnique CVE. ' := the error message text to display when the assertion fails</svrl:text>
            <svrl:text>This abstract pattern checks to see if an attribute of an element exists in a list.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M111"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IRM-ID-00047</xsl:attribute>
            <xsl:attribute name="name">IRM-ID-00047</xsl:attribute>
            <svrl:text>tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:type[@irm:qualifier='urn:us:gov:ic:cvenum:intdis:inteldiscipline:component'] := the context in which the searchValue exists</svrl:text>
            <svrl:text>@irm:value := the value which you want to verify is in the list</svrl:text>
            <svrl:text>$intelDisciplineComponentList := the list in which to search for the searchValue</svrl:text>
            <svrl:text>' [IRM-ID-00047][Error] If element irm:type has attribute @irm:qualifier specified as [urn:us:gov:ic:cvenum:intdis:inteldiscipline:component] the attribute @irm:value must be in CVEnumIntelDisciplineComponent.xml. Human Readable: Intel Discipline Components must be in the CVEnumIntelDisciplineComponent CVE. ' := the error message text to display when the assertion fails</svrl:text>
            <svrl:text>This abstract pattern checks to see if an attribute of an element exists in a list.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M112"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IRM-ID-00048</xsl:attribute>
            <xsl:attribute name="name">IRM-ID-00048</xsl:attribute>
            <svrl:text>tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:type[@irm:qualifier='urn:us:gov:ic:cvenum:intdis:inteldiscipline'] := the context in which the searchValue exists</svrl:text>
            <svrl:text>@irm:value := the value which you want to verify is in the list</svrl:text>
            <svrl:text>$intelDisciplineList := the list in which to search for the searchValue</svrl:text>
            <svrl:text>' [IRM-ID-00048][Error] If element irm:type has attribute @irm:qualifier specified as [urn:us:gov:ic:cvenum:intdis:inteldiscipline] the attribute @irm:value must be in CVEnumIntelDiscipline.xml. Human Readable: Intel Disciplines must be in the CVEnumIntelDiscipline CVE. ' := the error message text to display when the assertion fails</svrl:text>
            <svrl:text>This abstract pattern checks to see if an attribute of an element exists in a list.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M113"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IRM-ID-00053</xsl:attribute>
            <xsl:attribute name="name">IRM-ID-00053</xsl:attribute>
            <svrl:text>tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:type[@irm:qualifier='urn:us:gov:ic:cvenum:irm:activity'] := the context in which the searchValue exists</svrl:text>
            <svrl:text>@irm:value := the value which you want to verify is in the list</svrl:text>
            <svrl:text>$activityList := the list in which to search for the searchValue</svrl:text>
            <svrl:text>' [IRM-ID-00053][Error] If element irm:type has attribute @irm:qualifier specified as [urn:us:gov:ic:cvenum:irm:activity] the attribute @irm:value must be in CVEnumIRMActivity.xml. Human Readable: Activity must be in the CVEnumIRMActivity CVE. ' := the error message text to display when the assertion fails</svrl:text>
            <svrl:text>This abstract pattern checks to see if an attribute of an element exists in a list.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M114"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IRM-ID-00054</xsl:attribute>
            <xsl:attribute name="name">IRM-ID-00054</xsl:attribute>
            <svrl:text>tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage[$IC_COMPLIANCE]//irm:geospatialCoverage[@irm:precedence] := the context in which the searchValue exists</svrl:text>
            <svrl:text>@irm:precedence := the value which you want to verify is in the list</svrl:text>
            <svrl:text>$coveragePrecedenceList := the list in which to search for the searchValue</svrl:text>
            <svrl:text>' [IRM-ID-00054][Error] If element irm:geospatialCoverage has attribute @irm:precedence specified, then the value must be in CVEnumIRMCoveragePrecedence.xml. Human Readable: Geospatial Coverage Precedence must be in the CVEnumIRMCoveragePrecedence CVE. ' := the error message text to display when the assertion fails</svrl:text>
            <svrl:text>This abstract pattern checks to see if an attribute of an element exists in a list.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M115"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IRM-ID-00055</xsl:attribute>
            <xsl:attribute name="name">IRM-ID-00055</xsl:attribute>
            <svrl:text>[IRM-ID-00055][Error] If irm:geospatialCoverage/@order is specified then there must be one and only one of
           irm:geospatialIdentifier/irm:countryCode or irm:geospatialIdentifier/irm:subDivisionCode. Human Readable: A single order value must be
           applied to one country code or one subdivision code but not to both.</svrl:text>
            <svrl:text>Make sure that there is only one irm:countryCode or order irm:subDivisionCode when irm:geospatialCoverage uses the
           order attribute.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M116"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IRM-ID-00062</xsl:attribute>
            <xsl:attribute name="name">IRM-ID-00062</xsl:attribute>
            <svrl:text>A valid IC-Identifier must meet the following criteria: (1) The id must begin with 'guide://' (2) The prefix for
           the id is an integer up to 16 digits with no leading zeros allowed (3) The suffix is an alphanumeric string limited to 36 characters of
           the set that includes A-Z, a-z, 0-9, underscore, hyphen, and period (4) There are no additional characters proceeding the ID. In order to
           determine the provided IC-Identifier meets these criteria, the value parameter is matched against the following regex:
           ^guide://([1-9][0-9]{0,15}|0)/[A-Za-z0-9_\-\.]{1,36}$.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M117"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IRM-ID-00063</xsl:attribute>
            <xsl:attribute name="name">IRM-ID-00063</xsl:attribute>
            <svrl:text>[IRM-ID-00063][Error]
    Element irm:ICResourceMetadataPackage/irm:creator/irm:organization must specify attribute
    @irm:acronym. Human Readable: The IRM card must specify a creator organization with an IC
    agency acronym for the referenced resource.</svrl:text>
            <svrl:text>Make sure that element
    irm:ICResourceMetadataPackage/irm:creator/irm:organization exists and specifies attribute
    @irm:acronym.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M118"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IRM-ID-00064</xsl:attribute>
            <xsl:attribute name="name">IRM-ID-00064</xsl:attribute>
            <svrl:text>[IRM-ID-00064][Error]
    Element irm:ICResourceMetadataPackage/irm:dates must specify attribute @irm:created. Human
    Readable: The IRM card must specify the date on which the referenced resource was
    created.</svrl:text>
            <svrl:text>Make sure that element
    irm:ICResourceMetadataPackage/irm:dates exists and specifies attribute @irm:created.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M119"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IRM-ID-00065</xsl:attribute>
            <xsl:attribute name="name">IRM-ID-00065</xsl:attribute>
            <svrl:text>[IRM-ID-00065][Error]
    Attribute irm:ICResourceMetadataPackage/irm:dates/@irm:created must be castable as an
    xs:dateTime type. Human Readable: The date on which the referenced resource was created must be
    a dateTime type.</svrl:text>
            <svrl:text>Make sure that attribute
    dms:resource/irm:dates/@irm:created is castable as an xs:dateTime type.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M120"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IRM-ID-00068</xsl:attribute>
            <xsl:attribute name="name">IRM-ID-00068</xsl:attribute>
            <svrl:text>[IRM-ID-00068][Error] For element irm:taskID, if attribute xlink:href exists, then the attribute must have a
           non-null value. Human Readable:</svrl:text>
            <svrl:text>The normalize-spaced value of attribute xlink:href is checked to make sure the length of the resulting string is
           greater than zero, which indicates non-whitespace content.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M121"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IRM-ID-00070</xsl:attribute>
            <xsl:attribute name="name">IRM-ID-00070</xsl:attribute>
            <svrl:text>tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:type[@irm:qualifier='urn:us:gov:ic:cvenum:irm:executableindicator'] := the context in which the searchValue exists</svrl:text>
            <svrl:text>@irm:value := the value which you want to verify is in the list</svrl:text>
            <svrl:text>$executableIndicatorList := the list in which to search for the searchValue</svrl:text>
            <svrl:text>' [IRM-ID-00070][Error] If element irm:type has attribute @irm:qualifier specified as [urn:us:gov:ic:cvenum:irm:executableindicator] the attribute @irm:value must be in CVEnumIRMExecutableIndicator.xml. HHuman Readable: Executable Indicator Value must be in the CVEnumIRMExecutableIndicator CVE. ' := the error message text to display when the assertion fails</svrl:text>
            <svrl:text>This abstract pattern checks to see if an attribute of an element exists in a list.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M122"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IRM-ID-00071</xsl:attribute>
            <xsl:attribute name="name">IRM-ID-00071</xsl:attribute>
            <svrl:text>tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:type[@irm:qualifier='urn:us:gov:ic:cvenum:irm:maliciouscodeindicator'] := the context in which the searchValue exists</svrl:text>
            <svrl:text>@irm:value := the value which you want to verify is in the list</svrl:text>
            <svrl:text>$maliciousCodeIndicatorList := the list in which to search for the searchValue</svrl:text>
            <svrl:text>' [IRM-ID-00071][Error] If element irm:type has attribute @irm:qualifier specified as [urn:us:gov:ic:cvenum:irm:maliciouscodeindicator] the attribute @irm:value must be in CVEnumIRMMaliciousCodeIndicator.xml. Human Readable: Malicious Code Indicator values must be in the CVEnumIRMMaliciousCodeIndicator CVE. ' := the error message text to display when the assertion fails</svrl:text>
            <svrl:text>This abstract pattern checks to see if an attribute of an element exists in a list.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M123"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IRM-ID-00072</xsl:attribute>
            <xsl:attribute name="name">IRM-ID-00072</xsl:attribute>
            <svrl:text>[IRM-ID-00072][Error] For element irm:searchableDate, irm:start must be earlier than irm:end. Human Readable:
           Within the searchableDate element, the date within the start element must be earlier than the date within the end element.</svrl:text>
            <svrl:text>For each element irm:searchableDate, the child elements irm:start and irm:end are cast as xs:dateTime types, then
           compared to ensure start is less than end.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M124"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IRM-ID-00073</xsl:attribute>
            <xsl:attribute name="name">IRM-ID-00073</xsl:attribute>
            <svrl:text>tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:type[@irm:qualifier='urn:us:gov:ic:cvenum:irm:positive:intel'] := the context in which the searchValue exists</svrl:text>
            <svrl:text>@irm:value := the value which you want to verify is in the list</svrl:text>
            <svrl:text>$positiveIntelList := the list in which to search for the searchValue</svrl:text>
            <svrl:text>' [IRM-ID-00073][Error] If element irm:type has attribute @irm:qualifier specified as [urn:us:gov:ic:cvenum:irm:positive:intel] the attribute @irm:value must be in CVEnumIRMPositiveIntel.xml. Human Readable: Positive Intel values must be in the CVEnumIRMPositiveIntel CVE. ' := the error message text to display when the assertion fails</svrl:text>
            <svrl:text>This abstract pattern checks to see if an attribute of an element exists in a list.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M125"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IRM-ID-00074</xsl:attribute>
            <xsl:attribute name="name">IRM-ID-00074</xsl:attribute>
            <svrl:text>[IRM-ID-00074][Error] For element irm:searchableDate, elements irm:start and irm:end must match the xsd:dateTime
           format. Human Readable: Within the searchableDate element, the start and end elements values must conform to the xsd:dateTime
           format.</svrl:text>
            <svrl:text>For each element irm:searchableDate, ensure that elements irm:start and irm:end are each castable as
           xs:dateTime type.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M126"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IRM-ID-00076</xsl:attribute>
            <xsl:attribute name="name">IRM-ID-00076</xsl:attribute>
            <svrl:text>[IRM-ID-00076][Error] If the irm:acquiredOn element exists, at least one of its child elements irm:description,
           irm:approximableDate, or irm:searchableDate must be present. Human Readable: The acquiredOn element must have at least one of the
           following child elements: description, approximableDate and searchableDate.</svrl:text>
            <svrl:text>For element irm:acquiredOn, ensure that one or more of the child elements irm:description,
           irm:approximableDate, irm:searchableDate/irm:start, or irm:searchableDate/irm:end is specified with non-whitespace content.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M127"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IRM-ID-00077</xsl:attribute>
            <xsl:attribute name="name">IRM-ID-00077</xsl:attribute>
            <svrl:text>[IRM-ID-00077][Error] For
        element irm:person at least one of the following child elements must have non-whitespace
        content: irm:surname, irm:userID, irm:name, irm:affiliation, irm:postalAddress, irm:phone
        irm:email.</svrl:text>
            <svrl:text>This pattern uses an
        abstract rule to consolidate logic. It normalizes the space of the value of the specified
        child elements and makes sure that the length of the resulting string is greater than zero,
        which indicates non-whitespace content. Element irm:postalAddress cannot contain text
        content, so count the number of its child elements that contain non-white space and make
        sure that the count is great than 0. The abstract rule is extended once for each required
        element in rule IRM_ID_00077.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M128"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IRM-ID-00078</xsl:attribute>
            <xsl:attribute name="name">IRM-ID-00078</xsl:attribute>
            <svrl:text>[IRM-ID-00078][Error] For elements irm:acquiredOn and irm:temporalCoverage with child element name [infoCutoff],
           the permissible values for the year range are 1901 through the current year for elements irm:approximableDate, irm:start, and irm:end.
           Human Readable: If elements acquiredOn and temporalCoverage have a child element infoCutoff, then the approximableDate, start and end
           elements must have a year value between 1901 and the current year.</svrl:text>
            <svrl:text>This pattern uses an abstract rule to consolidate logic. It makes sure that the date contained within $dateValue
           has a year value within the range $minYear and $maxYear, inclusive. The abstract rule is extended once for each element required in rule
           IRM-ID-00078.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M129"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IRM-ID-00079</xsl:attribute>
            <xsl:attribute name="name">IRM-ID-00079</xsl:attribute>
            <svrl:text> This abstract pattern
        checks to see if the validation environment has at least the version / revision of the
        Schema as of the writing of this specification. The calling rule must pass in '1',
        'IC-ID', '../../Schema/IC-ID/IC-ID.xsd', 'IRM-ID-00079'.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M130"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IRM-ID-00080</xsl:attribute>
            <xsl:attribute name="name">IRM-ID-00080</xsl:attribute>
            <svrl:text>
        This abstract pattern checks to see if the validation environment has at least the version / revision of the
        CVE as of the writing of this specification. 
        The calling rule must pass in '201703.201802', 'USAgency', '../../CVE/USAgency/CVEnumUSAgencyAcronym.xml', 'IRM-ID-00080'.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M131"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IRM-ID-00081</xsl:attribute>
            <xsl:attribute name="name">IRM-ID-00081</xsl:attribute>
            <svrl:text>[IRM-ID-00081][Error] A
        irm:type element with @irm:qualifer ProductLine or Intel must not contain any text. Human
        Readable: IRM Types of ProductLine or Intel must not contain any text within the
        element.</svrl:text>
            <svrl:text>For all irm:type elements
        that contain a @irm:qualifier of urn:us:gov:ic:irm:productline or that start with
        urn:us:gov:ic:cvenum:intdis, verify that the element does not contain any text.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M132"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IRM-ID-00086</xsl:attribute>
            <xsl:attribute name="name">IRM-ID-00086</xsl:attribute>
            <svrl:text>
        This abstract pattern checks to see if the validation environment has at least the version / revision of the
        CVE as of the writing of this specification. 
        The calling rule must pass in '201707', 'INTDIS', '../../CVE/INTDIS/CVEnumIntelDiscipline.xml', 'IRM-ID-00086'.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M133"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IRM-ID-00087</xsl:attribute>
            <xsl:attribute name="name">IRM-ID-00087</xsl:attribute>
            <svrl:text>[IRM-ID-00087][Error] If @irm:qualifier identifies a intelligence discipline URN, then @intdis:CESVersion must
           exist as well.</svrl:text>
            <svrl:text>Make sure that the INTDIS CVE version attribute exists if intelligence discipline resources are
           identified.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M134"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IRM-ID-00088</xsl:attribute>
            <xsl:attribute name="name">IRM-ID-00088</xsl:attribute>
            <svrl:text>
        This abstract pattern checks to see if the validation environment has at least the version / revision of the
        CVE as of the writing of this specification. 
        The calling rule must pass in '202010', 'MIME', '../../CVE/MIME/CVEnumMIMEType.xml', 'IRM-ID-00088'.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M135"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IRM-ID-00089</xsl:attribute>
            <xsl:attribute name="name">IRM-ID-00089</xsl:attribute>
            <svrl:text>[IRM-ID-00089][Error] If @irm:mimeType exists, then @mime:CESVersion must exist as well.</svrl:text>
            <svrl:text>Make sure that the MIME CVE version attribute exists if the internet media type of the resource is
           defined.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M136"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IRM-ID-00090</xsl:attribute>
            <xsl:attribute name="name">IRM-ID-00090</xsl:attribute>
            <svrl:text>[IRM-ID-00090][Error] If subDivisionCode codespace is GENC codespace, then value must be in the GENC
           subDivisionCode cve.</svrl:text>
            <svrl:text>If subDivisionCode codespace is GENC codespace, then value must be in the GENC subDivisionCode cve.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M137"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IRM-ID-00091</xsl:attribute>
            <xsl:attribute name="name">IRM-ID-00091</xsl:attribute>
            <svrl:text>[IRM-ID-00091][Warning] Deprecated MIME types should not be used.</svrl:text>
            <svrl:text>Deprecated MIME types should not be used.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M138"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IRM-ID-00092</xsl:attribute>
            <xsl:attribute name="name">IRM-ID-00092</xsl:attribute>
            <svrl:text>[IRM-ID-00092][Error] irm:NonStateActor should contain a value from the NonStateActor CVE</svrl:text>
            <svrl:text>Make sure that the value within NonStateActor is a value from the CVE.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M139"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IRM-ID-00093</xsl:attribute>
            <xsl:attribute name="name">IRM-ID-00093</xsl:attribute>
            <svrl:text>[IRM-ID-00093][Error] If present, at least one irm:countryCode in a irm:geographicIdentifier must be a GENC ED3
           codespace: ^ge:GENC:3:(ed3|3-[1-9][0-9]*)$</svrl:text>
            <svrl:text>If present, at least one irm:countryCode in a irm:geographicIdentifier must be a GENC ED3 codespace:
           ^ge:GENC:3:(ed3|3-[1-9][0-9]*)$</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M140"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IRM-ID-00094</xsl:attribute>
            <xsl:attribute name="name">IRM-ID-00094</xsl:attribute>
            <svrl:text>[IRM-ID-00094][Error] If countrycode codespace is GENC codespace, then value must be in the GENC countrycode
           cve.</svrl:text>
            <svrl:text>If countrycode codespace is GENC codespace, then value must be in the GENC countrycode cve</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M141"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IRM-ID-00095</xsl:attribute>
            <xsl:attribute name="name">IRM-ID-00095</xsl:attribute>
            <svrl:text>[IRM-ID-00095][Error] If present, at least one irm:subDivisionCode in a irm:geographicIdentifier must be a GENC
           ED3 codespace: ^as:GENC:6:(ed3|3-[1-9][0-9]*)$</svrl:text>
            <svrl:text>If present, at least one irm:subDivisionCode in a irm:geographicIdentifier must be a GENC ED3 codespace:
           ^as:GENC:6:(ed3|3-[1-9][0-9]*)$</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M142"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IRM-ID-00096</xsl:attribute>
            <xsl:attribute name="name">IRM-ID-00096</xsl:attribute>
            <svrl:text>
        This abstract pattern checks to see if the validation environment has at least the version / revision of the
        CVE as of the writing of this specification. 
        The calling rule must pass in '202111', 'ISM', '../../CVE/ISM/CVEnumISMClassificationAll.xml', 'IRM-ID-00096'.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M143"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IRM-ID-00098</xsl:attribute>
            <xsl:attribute name="name">IRM-ID-00098</xsl:attribute>
            <svrl:text>[IRM-ID-00098][Error] Use of a GENC codespace requires the presence of the IC-GENC CESVersion attribute.</svrl:text>
            <svrl:text>If a codespace attribute is specified that contains a GENC codespace, then ensure that the IC-GENC CESVersion
           attribute is specified in the IRM assertion on the ICResourceMetadataPackage.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M144"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IRM-ID-00099</xsl:attribute>
            <xsl:attribute name="name">IRM-ID-00099</xsl:attribute>
            <svrl:text>
        This abstract pattern checks to see if the validation environment has at least the version / revision of the
        CVE as of the writing of this specification. 
        The calling rule must pass in '201909', 'IC-GENC', '../../CVE/IC-GENC/CVEnumGENCCountryCode.xml', 'IRM-ID-00099'.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M145"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IRM-ID-00100</xsl:attribute>
            <xsl:attribute name="name">IRM-ID-00100</xsl:attribute>
            <svrl:text>[IRM-ID-00100][Error] If a irm:ICResourceMetadataPackage element is present in a tdf:StructuredStatement within a tdf:Assertion,
           then the tdf:Assertion must also contain a tdf:StatementMetadata element.</svrl:text>
            <svrl:text>If a irm:ICResourceMetadataPackage element is present in a tdf:StructuredStatement within a tdf:Assertion, then the tdf:Assertion
           must also contain a tdf:StatementMetadata element.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M146"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IRM-ID-00101</xsl:attribute>
            <xsl:attribute name="name">IRM-ID-00101</xsl:attribute>
            <svrl:text>[IRM-ID-00101][Error] If element irm:organization has attribute @irm:acronym specified and the acronym begins with
           "USA.", then the organization value must be defined by the USAgency CES. Human Readable: Utilized agency acronyms beginning with "USA."
           must be defined in the USAgency CES.</svrl:text>
            <svrl:text>For irm:organization with @irm:acronym specified, if @irm:acronym begins with 'USA.', then the country value must
           be defined by the USAgency CES.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M147"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IRM-ID-00102</xsl:attribute>
            <xsl:attribute name="name">IRM-ID-00102</xsl:attribute>
            <svrl:text>[IRM-ID-00102][Error] If element irm:organization has attribute @irm:acronym specified, 
           then the country value must be defined by the GENC CES. Human Readable: Utilized agency acronyms
           country component must have the country defined in the GENC CES.</svrl:text>
            <svrl:text>For irm:organization with @irm:acronym specified, if @irm:acronym contains a country component which is not 'USA',
           then the country value must be defined by the GENC CES.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M148"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IRM-ID-00103</xsl:attribute>
            <xsl:attribute name="name">IRM-ID-00103</xsl:attribute>
            <svrl:text>[IRM-ID-00103][Error] If element irm:organization has attribute @irm:acronym specified, then attribute
           @irm:acronym must be of type NmToken.</svrl:text>
            <svrl:text>For irm:organization that have @irm:acronym, @irm:acronym must be of type NmToken.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M149"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IRM-ID-00104</xsl:attribute>
            <xsl:attribute name="name">IRM-ID-00104</xsl:attribute>
            <svrl:text>[IRM-ID-00104][Error] If
    element irm:organization has attribute @irm:acronym specified and @irm:acronym has a country
    prefix, then the agency suffix after the dot delimiter must be of type NmToken.</svrl:text>
            <svrl:text>For irm:organization that
    have @irm:acronym, the agency suffix after the dot delimiter must be of type NmToken.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M150"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IRM-ID-00105</xsl:attribute>
            <xsl:attribute name="name">IRM-ID-00105</xsl:attribute>
            <svrl:text>[IRM-ID-00105][Error] Use
    of the @irm:qualifier on the irm:nonStateActor element is required.</svrl:text>
            <svrl:text>If the irm:nonStateActor
    element is specified within a TDF assertion affected by an IRM assertion, then verify that the
    @irm:qualifier attribute is present on the element.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M151"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IRM-ID-00106</xsl:attribute>
            <xsl:attribute name="name">IRM-ID-00106</xsl:attribute>
            <svrl:text> This abstract pattern
        checks to see if the validation environment has at least the version / revision of the
        Schema as of the writing of this specification. The calling rule must pass in '201903.201909',
        'PMA', '../../Schema/PMA/PMA-XML.xsd', 'IRM-ID-00106'.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M152"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IRM-ID-00107</xsl:attribute>
            <xsl:attribute name="name">IRM-ID-00107</xsl:attribute>
            <svrl:text> This abstract pattern
        checks to see if the validation environment has at least the version / revision of the
        Schema as of the writing of this specification. The calling rule must pass in '202010',
        'VIRT', '../../Schema/VIRT/VIRT.xsd', 'IRM-ID-00107'.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M153"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IRM-ID-00108</xsl:attribute>
            <xsl:attribute name="name">IRM-ID-00108</xsl:attribute>
            <svrl:text>
        [IRM-ID-00108][Warning] irm:DESVersion attribute SHOULD be specified as version 202111 (Version:2021-NOV) with an optional extension.
    </svrl:text>
            <svrl:text>
        This rule supports extending the version identifier with an optional trailing hyphen
        and up to 23 additional characters. The version must match the regular expression
        “^202111(-.{1,23})?$".
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M154"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IRM-ID-00109</xsl:attribute>
            <xsl:attribute name="name">IRM-ID-00109</xsl:attribute>
            <svrl:text>
        [IRM-ID-00109][Error] If the tokens in @irm:compliesWith starts with "USA", they must be a value that exists or starts
        with a value from CVEnumIRMCompliesWithUSA. 
    </svrl:text>
            <svrl:text>If @irm:compliesWith starts-with USA, must be or start with a value from CVE values start-with USA.
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M155"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IRM-ID-00110</xsl:attribute>
            <xsl:attribute name="name">IRM-ID-00110</xsl:attribute>
            <svrl:text>
        [IRM-ID-00110][Error] The string before the first underscore of each @irm:compliesWith token must be in IC-GENC.
    </svrl:text>
            <svrl:text>Checks if the substring before the first underscore of each token in @irm:compliesWith 
        is a country code in IC-GENC.
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M156"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IRM-ID-00111</xsl:attribute>
            <xsl:attribute name="name">IRM-ID-00111</xsl:attribute>
            <svrl:text>
        [IRM-ID-00111][Error] If irm:virtualCoverage exists, then it must include at least @virt:protocol
        or @virt:address.
    </svrl:text>
            <svrl:text>If irm:virtualCoverage exists, then it must include at least @virt:protocol
        or @virt:address.
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M157"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IRM-ID-00112</xsl:attribute>
            <xsl:attribute name="name">IRM-ID-00112</xsl:attribute>
            <svrl:text>[IRM-ID-00112][Warning] If element irm:mimeType is specified, it SHOULD have a value from CVEnumMIMEType.xml 
        other than the wildcard entry. The value is not explicitly defined in CVEnumMIMEType.xml and is a match ONLY because of the wildcard entry.</svrl:text>
            <svrl:text>If element irm:mimeType is specified, it SHOULD have a value from CVEnumMIMEType.xml 
        other than the wildcard entry. The value is not explicitly defined in CVEnumMIMEType.xml and is a match ONLY 
        because of the wildcard entry.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M158"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IRM-ID-00113</xsl:attribute>
            <xsl:attribute name="name">IRM-ID-00113</xsl:attribute>
            <svrl:text>[IRM-ID-00113][Error] If present, at least one irm:waterBody in a irm:geographicIdentifier must be a CWW ED1
        codespace: ^wb:CWW:3:(ed1)$</svrl:text>
            <svrl:text>If present, at least one irm:waterBody in a irm:geographicIdentifier must be a CWW ED3 codespace:
        ^wb:CWW:3:(ed1)$</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M159"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IRM-ID-00114</xsl:attribute>
            <xsl:attribute name="name">IRM-ID-00114</xsl:attribute>
            <svrl:text>[IRM-ID-00114][Error] If waterBody codespace is CWW codespace, then value must be in the CWW waterBody
           cve.</svrl:text>
            <svrl:text>If waterBody codespace is CWW waterBody, then value must be in the CWW waterBody cve</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M160"/>
      </svrl:schematron-output>
   </xsl:template>

   <!--SCHEMATRON PATTERNS-->
<xsl:param name="IRM_COMPLIES_WITH"
              select="irm:ICResourceMetadataPackage/@irm:compliesWith"/>
   <xsl:param name="MIN_DISCOVERABLE_OR_GREATER"
              select="util:containsAnyOfTheTokens($IRM_COMPLIES_WITH, ('MIN_DISCOVERABLE'))"/>
   <xsl:param name="MIN_ACCESSIBLE_OR_GREATER"
              select="$MIN_DISCOVERABLE_OR_GREATER or util:containsAnyOfTheTokens($IRM_COMPLIES_WITH, ('MIN_ACCESSIBLE'))"/>
   <xsl:param name="COMPLIANCE_ATTRIBUTE"
              select="//irm:ICResourceMetadataPackage/@irm:compliesWith"/>
   <xsl:param name="IC_COMPLIANCE"
              select="some $token in $COMPLIANCE_ATTRIBUTE satisfies $token='USA_IC'"/>
   <xsl:param name="coverageIso3166DigraphList"
              select="document('../../CVE/IRM/CVEnumIRMCoverageISO3166Digraph.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>
   <xsl:param name="iso639DigraphList"
              select="document('../../CVE/IRM/CVEnumIRMISO639Digraph.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>
   <xsl:param name="iso639-2TrigraphList"
              select="document('../../CVE/IRM/CVEnumIRMISO639-2Trigraph.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>
   <xsl:param name="iso639-3TrigraphList"
              select="document('../../CVE/IRM/CVEnumIRMISO639-3Trigraph.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>
   <xsl:param name="mimeTypeList"
              select="document('../../CVE/MIME/CVEnumMIMEType.xml')//cve:Value"/>
   <xsl:param name="nonRegexMimeTypeList"
              select="document('../../CVE/MIME/CVEnumMIMEType.xml')/cve:CVE/cve:Enumeration/cve:Term[not(./@deprecated)]/cve:Value[not(./@regularExpression)]"/>
   <xsl:param name="deprecatedMimeTypeList"
              select="document('../../CVE/MIME/CVEnumMIMEType.xml')/cve:CVE/cve:Enumeration/cve:Term[./@deprecated]/cve:Value"/>
   <xsl:param name="compliesWithUSATypeList"
              select="document('../../CVE/IRM/CVEnumIRMCompliesWithUSA.xml')//cve:Value"/>
   <xsl:param name="compoundLanguageQualifierTypeList"
              select="document('../../CVE/IRM/CVEnumIRMCompoundLanguageQualifierType.xml')//cve:Value"/>
   <xsl:param name="intelDisciplineComponentTechniqueList"
              select="document('../../CVE/INTDIS/CVEnumIntelDisciplineComponentTechnique.xml')//cve:Value"/>
   <xsl:param name="intelDisciplineComponentList"
              select="document('../../CVE/INTDIS/CVEnumIntelDisciplineComponent.xml')//cve:Value"/>
   <xsl:param name="intelDisciplineList"
              select="document('../../CVE/INTDIS/CVEnumIntelDiscipline.xml')//cve:Value"/>
   <xsl:param name="positiveIntelList"
              select="document('../../CVE/IRM/CVEnumIRMPositiveIntel.xml')//cve:Value"/>
   <xsl:param name="activityList"
              select="document('../../CVE/IRM/CVEnumIRMActivity.xml')//cve:Value"/>
   <xsl:param name="executableIndicatorList"
              select="document('../../CVE/IRM/CVEnumIRMExecutableIndicator.xml')//cve:Value"/>
   <xsl:param name="maliciousCodeIndicatorList"
              select="document('../../CVE/IRM/CVEnumIRMMaliciousCodeIndicator.xml')//cve:Value"/>
   <xsl:param name="coveragePrecedenceList"
              select="document('../../CVE/IRM/CVEnumIRMCoveragePrecedence.xml')//cve:Value"/>
   <xsl:param name="USAgencyAcronymList"
              select="document('../../CVE/USAgency/CVEnumUSAgencyAcronym.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>
   <xsl:param name="nonStateActorsList"
              select="document('../../CVE/PM/CVEnumPMNonStateActors.xml')//cve:Value"/>
   <xsl:param name="gencCountryCodeList"
              select="document('../../CVE/IC-GENC/CVEnumGENCCountryCode.xml')//cve:Value"/>
   <xsl:param name="waterBodyList"
              select="document('../../CVE/IRM/CVEnumIRMWaterBody.xml')//cve:Value"/>
   <xsl:param name="gencSubDivisionList"
              select="document('../../CVE/IC-GENC/CVEnumGENCSubDivisionCode.xml')//cve:Value"/>
   <xsl:param name="GMTTimeZoneOffset" select="'PT0H'"/>
   <xsl:param name="currentYear"
              select="year-from-dateTime(adjust-dateTime-to-timezone(current-dateTime(), xs:dayTimeDuration($GMTTimeZoneOffset)))"/>
   <xsl:param name="timeZoneRegEx" select="'Z|[\+-]\d{2}:\d{2}'"/>
   <xsl:param name="endsWithTimeZoneRegEx" select="concat('^.*',$timeZoneRegEx,'$')"/>
   <xsl:param name="startDateTimeTemplate" select="'0001-01-01T00:00:00.000'"/>
   <xsl:param name="endDateTimeTemplate" select="'9999-12-01T23:59:59.999'"/>
   <xsl:param name="defaultTimeZone" select="'Z'"/>
   <xsl:param name="gYearRegEx" select="'^\d{4}(Z|[\+-]\d{2}:\d{2})?$'"/>
   <xsl:param name="gYearMonthRegEx" select="'^\d{4}-\d{2}(Z|[\+-]\d{2}:\d{2})?$'"/>
   <xsl:param name="dateRegEx" select="'^\d{4}-\d{2}-\d{2}(Z|[\+-]\d{2}:\d{2})?$'"/>
   <xsl:param name="dateHourMinTypeRegEx"
              select="'^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}(Z|[\+-]\d{2}:\d{2})?$'"/>
   <xsl:param name="dateTimeRegEx"
              select="'^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(\.\d{1,3})?(Z|[\+-]\d{2}:\d{2})?$'"/>

   <!--PATTERN -->
<xsl:template match="text()" priority="-1" mode="M58"/>
   <xsl:template match="@*|node()" priority="-2" mode="M58">
      <xsl:apply-templates select="*" mode="M58"/>
   </xsl:template>

   <!--PATTERN -->
<xsl:template match="text()" priority="-1" mode="M59"/>
   <xsl:template match="@*|node()" priority="-2" mode="M59">
      <xsl:apply-templates select="*" mode="M59"/>
   </xsl:template>

   <!--PATTERN typeConstraintPatterns-->
<xsl:variable name="NameStartCharPattern" select="':|[A-Z]|_|[a-z]'"/>
   <xsl:variable name="NameCharPattern"
                 select="concat($NameStartCharPattern, '|-|\.|[0-9]')"/>
   <xsl:variable name="NmTokenPattern" select="concat('(', $NameCharPattern, ')+')"/>
   <xsl:variable name="NmTokensPattern"
                 select="concat($NmTokenPattern, '( ', $NmTokenPattern, ')*')"/>
   <xsl:variable name="BooleanPattern" select="'(false|true|0|1)'"/>
   <xsl:variable name="DatePattern"
                 select="'-?([1-9][0-9]{3,}|0[0-9]{3})-(0[1-9]|1[0-2])-(0[1-9]|[12][0-9]|3[01])(Z|(\+|-)((0[0-9]|1[0-3]):[0-5][0-9]|14:00))?'"/>
   <xsl:template match="text()" priority="-1" mode="M60"/>
   <xsl:template match="@*|node()" priority="-2" mode="M60">
      <xsl:apply-templates select="*" mode="M60"/>
   </xsl:template>

   <!--PATTERN IRM-ID-00002-->


	<!--RULE IRM-ID-00002-R1-->
<xsl:template match="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//*[@*[namespace-uri() = ('urn:us:gov:ic:irm')]]"
                 priority="1000"
                 mode="M85">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//*[@*[namespace-uri() = ('urn:us:gov:ic:irm')]]"
                       id="IRM-ID-00002-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test=" every $attribute in @*[namespace-uri() = ('urn:us:gov:ic:irm')] satisfies normalize-space(string($attribute))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $attribute in @*[namespace-uri() = ('urn:us:gov:ic:irm')] satisfies normalize-space(string($attribute))">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IRM-ID-00002][Error] For every attribute in the namespace [urn:us:gov:ic:irm], a non-whitespace value must be
                    specified. Human Readable:</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M85"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M85"/>
   <xsl:template match="@*|node()" priority="-2" mode="M85">
      <xsl:apply-templates select="*" mode="M85"/>
   </xsl:template>

   <!--PATTERN IRM-ID-00005-->


	<!--RULE ValidateValueExistenceInList-R1-->
<xsl:template match="irm:language[@irm:qualifier='urn:us:gov:ic:cvenum:irm:iso639:digraph']"
                 priority="1000"
                 mode="M86">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="irm:language[@irm:qualifier='urn:us:gov:ic:cvenum:irm:iso639:digraph']"
                       id="ValidateValueExistenceInList-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test=" some $token in $iso639DigraphList satisfies $token = @irm:value or matches(@irm:value, concat('^',$token,'$'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="some $token in $iso639DigraphList satisfies $token = @irm:value or matches(@irm:value, concat('^',$token,'$'))">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="' [IRM-ID-00005][Error] If element irm:language has the attribute @irm:qualifier value of [urn:us:gov:ic:cvenum:irm:iso639:digraph] then the value of attribute @irm:value must be in CVEnumIRMISO639Digraph.xml and no country code portion may be specified in the irm:language element value. Human Readable: ISO 639 digraph language codes must be in the ISO 639 digraph CVE. '"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M86"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M86"/>
   <xsl:template match="@*|node()" priority="-2" mode="M86">
      <xsl:apply-templates select="*" mode="M86"/>
   </xsl:template>

   <!--PATTERN IRM-ID-00006-->


	<!--RULE ValidateValueExistenceInList-R1-->
<xsl:template match="irm:language[@irm:qualifier='urn:us:gov:ic:cvenum:irm:iso639-2:trigraph']"
                 priority="1000"
                 mode="M87">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="irm:language[@irm:qualifier='urn:us:gov:ic:cvenum:irm:iso639-2:trigraph']"
                       id="ValidateValueExistenceInList-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test=" some $token in $iso639-2TrigraphList satisfies $token = @irm:value or matches(@irm:value, concat('^',$token,'$'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="some $token in $iso639-2TrigraphList satisfies $token = @irm:value or matches(@irm:value, concat('^',$token,'$'))">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="' [IRM-ID-00006][Error] If element irm:language has the attribute @irm:qualifier value of [urn:us:gov:ic:cvenum:irm:iso639-2:trigraph] then the value of attribute @irm:value must be in CVEnumIRMISO639-2Trigraph.xml and no country code portion may be specified in the irm:value attribute value. Human Readable: ISO 639-2 trigraph language codes must be in the ISO 639-2 trigraph CVE. '"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M87"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M87"/>
   <xsl:template match="@*|node()" priority="-2" mode="M87">
      <xsl:apply-templates select="*" mode="M87"/>
   </xsl:template>

   <!--PATTERN IRM-ID-00007-->


	<!--RULE ValidateValueExistenceInList-R1-->
<xsl:template match="irm:language[@irm:qualifier='urn:us:gov:ic:cvenum:irm:iso639-3:trigraph']"
                 priority="1000"
                 mode="M88">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="irm:language[@irm:qualifier='urn:us:gov:ic:cvenum:irm:iso639-3:trigraph']"
                       id="ValidateValueExistenceInList-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test=" some $token in $iso639-3TrigraphList satisfies $token = @irm:value or matches(@irm:value, concat('^',$token,'$'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="some $token in $iso639-3TrigraphList satisfies $token = @irm:value or matches(@irm:value, concat('^',$token,'$'))">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="' [IRM-ID-00007][Error] If element irm:language has the attribute @irm:qualifier value of [urn:us:gov:ic:cvenum:irm:iso639-3:trigraph] then the value of attribute @irm:value must be in CVEnumIRMISO639-3Trigraph.xml and no country code portion may be specified in the irm:value attribute value. Human Readable: ISO 639-3 trigraph language codes must in the the ISO 639-3 trigraph CVE. '"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M88"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M88"/>
   <xsl:template match="@*|node()" priority="-2" mode="M88">
      <xsl:apply-templates select="*" mode="M88"/>
   </xsl:template>

   <!--PATTERN IRM-ID-00010-->


	<!--RULE IRM-ID-00010-R1-->
<xsl:template match="irm:language[@irm:qualifier='RFC5646']"
                 priority="1000"
                 mode="M89">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="irm:language[@irm:qualifier='RFC5646']"
                       id="IRM-ID-00010-R1"/>
      <xsl:variable name="tokens" select="tokenize(@irm:value,'-')"/>
      <xsl:variable name="primarySubtag" select="$tokens[1]"/>
      <xsl:variable name="secondarySubtag" select="$tokens[2]"/>
      <xsl:variable name="badPrimaryValues"
                    select=" if($primarySubtag and ( index-of($iso639-2TrigraphList,lower-case($primarySubtag))&gt;0 or index-of($iso639DigraphList,$primarySubtag)&gt;0)) then null else $primarySubtag"/>
      <xsl:variable name="badSecondaryValues"
                    select=" if($secondarySubtag and index-of($coverageIso3166DigraphList,$secondarySubtag)&gt;0) then null else $secondarySubtag"/>
      <xsl:variable name="badValues"
                    select="string-join(($badPrimaryValues, $badSecondaryValues), ' ')"/>
      <xsl:variable name="primarySubtagValid"
                    select=" $primarySubtag and count($badPrimaryValues) = 0"/>
      <xsl:variable name="secondarySubtagValid"
                    select=" if(not($secondarySubtag)) then true() else count($badSecondaryValues) = 0 "/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="$primarySubtagValid and $secondarySubtagValid"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="$primarySubtagValid and $secondarySubtagValid">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IRM-ID-00010][Error] If element irm:language has the attribute @irm:qualifier value of [RFC5646] then the language
                    code portion of the @irm:value attribute value must be in CVEnumIRMISO639Digraph.xml or CVEnumIRMISO639-2Trigraph.xml and the
                    country code portion, if present, must be in CVEnumIRMCoverageISO3166Digraph.xml. Human Readable: RFC5646 language codes must
                    comply with the RFC by using parts from ISO 639 Digraph or ISO 639-2 Trigraph and ISO 3166 Digraph. The following values were
                    found but are not in the CVEs: 
        <xsl:text/>
                  <xsl:value-of select="for $each in tokenize($badValues, ' ') return concat('[',$each,'] ')"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M89"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M89"/>
   <xsl:template match="@*|node()" priority="-2" mode="M89">
      <xsl:apply-templates select="*" mode="M89"/>
   </xsl:template>

   <!--PATTERN IRM-ID-00015-->


	<!--RULE IRM-ID-00015-R1-->
<xsl:template match="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage[$IC_COMPLIANCE]//irm:dates"
                 priority="1000"
                 mode="M90">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage[$IC_COMPLIANCE]//irm:dates"
                       id="IRM-ID-00015-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="@irm:created or @irm:posted"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="@irm:created or @irm:posted">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IRM-ID-00015][Error] Every irm:date must have at least one of @irm:created or @irm:posted.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M90"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M90"/>
   <xsl:template match="@*|node()" priority="-2" mode="M90">
      <xsl:apply-templates select="*" mode="M90"/>
   </xsl:template>

   <!--PATTERN IRM-ID-00016-->


	<!--RULE IRM-ID-00016-R1-->
<xsl:template match="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage[$IC_COMPLIANCE]//*[@irm:approvedOn | @irm:dateProcessed | @irm:receivedOn | @irm:posted | @irm:created | @irm:infoCutOff]"
                 priority="1000"
                 mode="M91">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage[$IC_COMPLIANCE]//*[@irm:approvedOn | @irm:dateProcessed | @irm:receivedOn | @irm:posted | @irm:created | @irm:infoCutOff]"
                       id="IRM-ID-00016-R1"/>
      <xsl:variable name="minYear" select="1901"/>
      <xsl:variable name="maxYear" select="$currentYear"/>
      <xsl:variable name="dateList"
                    select=" (string(@irm:approvedOn), string(@irm:dateProcessed), string(@irm:receivedOn), string(@irm:posted), string(@irm:created), string(@irm:infoCutOff))"/>
      <xsl:variable name="errMsg"
                    select="' [IRM-ID-00016][Error] The permissible values for the year range are 1901 through the current year for attributes @irm:approvedOn, @irm:dateProcessed, @irm:receivedOn, @irm:infoCutOff, @irm:posted, and @irm:created. Human Readable: Dates must be after 1901 and in the past for @irm:approvedOn, @irm:dateProcessed, @irm:receivedOn, @irm:infoCutOff, @irm:posted, and @irm:created. '"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="every $date in tokenize(normalize-space(string-join($dateList, ' ')),' ') satisfies if(not(dtf:isAllowableDateTimeFormat(string($date)))) then true() else xs:integer(substring(string(dtf:adjust-CombinedDate-to-GMT-timezone($date)), 1, 4)) &lt;= $maxYear and xs:integer(substring(string(dtf:adjust-CombinedDate-to-GMT-timezone($date)), 1, 4)) &gt;= $minYear"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $date in tokenize(normalize-space(string-join($dateList, ' ')),' ') satisfies if(not(dtf:isAllowableDateTimeFormat(string($date)))) then true() else xs:integer(substring(string(dtf:adjust-CombinedDate-to-GMT-timezone($date)), 1, 4)) &lt;= $maxYear and xs:integer(substring(string(dtf:adjust-CombinedDate-to-GMT-timezone($date)), 1, 4)) &gt;= $minYear">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="$errMsg"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M91"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M91"/>
   <xsl:template match="@*|node()" priority="-2" mode="M91">
      <xsl:apply-templates select="*" mode="M91"/>
   </xsl:template>

   <!--PATTERN IRM-ID-00017-->


	<!--RULE IRM-ID-00017-R1-->
<xsl:template match="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage[$IC_COMPLIANCE]//*[@irm:validTil]"
                 priority="1000"
                 mode="M92">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage[$IC_COMPLIANCE]//*[@irm:validTil]"
                       id="IRM-ID-00017-R1"/>
      <xsl:variable name="minYear" select="1901"/>
      <xsl:variable name="maxYear" select="9999"/>
      <xsl:variable name="dateList" select="(string(@irm:validTil))"/>
      <xsl:variable name="errMsg"
                    select="' [IRM-ID-00017][Error] The permissible values for the year range are 1901 through 9999 for attribute @irm:validTil. Human Readable: @irm:validTil must be after 1901. '"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="every $date in tokenize(normalize-space(string-join($dateList, ' ')),' ') satisfies if(not(dtf:isAllowableDateTimeFormat(string($date)))) then true() else xs:integer(substring(string(dtf:adjust-CombinedDate-to-GMT-timezone($date)), 1, 4)) &lt;= $maxYear and xs:integer(substring(string(dtf:adjust-CombinedDate-to-GMT-timezone($date)), 1, 4)) &gt;= $minYear"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $date in tokenize(normalize-space(string-join($dateList, ' ')),' ') satisfies if(not(dtf:isAllowableDateTimeFormat(string($date)))) then true() else xs:integer(substring(string(dtf:adjust-CombinedDate-to-GMT-timezone($date)), 1, 4)) &lt;= $maxYear and xs:integer(substring(string(dtf:adjust-CombinedDate-to-GMT-timezone($date)), 1, 4)) &gt;= $minYear">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="$errMsg"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M92"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M92"/>
   <xsl:template match="@*|node()" priority="-2" mode="M92">
      <xsl:apply-templates select="*" mode="M92"/>
   </xsl:template>

   <!--PATTERN IRM-ID-00019-->


	<!--RULE CompareDateTimes-R1-->
<xsl:template match="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage[$IC_COMPLIANCE]//*[@irm:approvedOn]"
                 priority="1000"
                 mode="M93">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage[$IC_COMPLIANCE]//*[@irm:approvedOn]"
                       id="CompareDateTimes-R1"/>

		    <!--ASSERT warning-->
<xsl:choose>
         <xsl:when test="if ('warning' = 'warning' and dtf:isAllowableDateTimeFormat(string(@irm:approvedOn))) then every $secondaryDate in (@irm:created, @irm:posted) satisfies if(dtf:isAllowableDateTimeFormat(string($secondaryDate))) then dtf:compareDateTimeRanges(string(@irm:approvedOn), '&lt;=', string($secondaryDate)) else true() else true()"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="if ('warning' = 'warning' and dtf:isAllowableDateTimeFormat(string(@irm:approvedOn))) then every $secondaryDate in (@irm:created, @irm:posted) satisfies if(dtf:isAllowableDateTimeFormat(string($secondaryDate))) then dtf:compareDateTimeRanges(string(@irm:approvedOn), '&lt;=', string($secondaryDate)) else true() else true()">
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="' [IRM-ID-00019][Warning] @irm:approvedOn must not be later than @irm:created and @irm:posted. '"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="if ('warning' = 'error' and dtf:isAllowableDateTimeFormat(string(@irm:approvedOn))) then every $secondaryDate in (@irm:created, @irm:posted) satisfies if(dtf:isAllowableDateTimeFormat(string($secondaryDate))) then dtf:compareDateTimeRanges(string(@irm:approvedOn), '&lt;=', string($secondaryDate)) else true() else true()"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="if ('warning' = 'error' and dtf:isAllowableDateTimeFormat(string(@irm:approvedOn))) then every $secondaryDate in (@irm:created, @irm:posted) satisfies if(dtf:isAllowableDateTimeFormat(string($secondaryDate))) then dtf:compareDateTimeRanges(string(@irm:approvedOn), '&lt;=', string($secondaryDate)) else true() else true()">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="' [IRM-ID-00019][Warning] @irm:approvedOn must not be later than @irm:created and @irm:posted. '"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M93"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M93"/>
   <xsl:template match="@*|node()" priority="-2" mode="M93">
      <xsl:apply-templates select="*" mode="M93"/>
   </xsl:template>

   <!--PATTERN IRM-ID-00020-->


	<!--RULE CompareDateTimes-R1-->
<xsl:template match="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage[$IC_COMPLIANCE]//*[@irm:infoCutOff]"
                 priority="1000"
                 mode="M94">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage[$IC_COMPLIANCE]//*[@irm:infoCutOff]"
                       id="CompareDateTimes-R1"/>

		    <!--ASSERT warning-->
<xsl:choose>
         <xsl:when test="if ('error' = 'warning' and dtf:isAllowableDateTimeFormat(string(@irm:infoCutOff))) then every $secondaryDate in (@irm:created, @irm:posted) satisfies if(dtf:isAllowableDateTimeFormat(string($secondaryDate))) then dtf:compareDateTimeRanges(string(@irm:infoCutOff), '&lt;=', string($secondaryDate)) else true() else true()"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="if ('error' = 'warning' and dtf:isAllowableDateTimeFormat(string(@irm:infoCutOff))) then every $secondaryDate in (@irm:created, @irm:posted) satisfies if(dtf:isAllowableDateTimeFormat(string($secondaryDate))) then dtf:compareDateTimeRanges(string(@irm:infoCutOff), '&lt;=', string($secondaryDate)) else true() else true()">
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="' [IRM-ID-00020][Error] @irm:infoCutOff must not be later than @irm:created, and @irm:posted. '"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="if ('error' = 'error' and dtf:isAllowableDateTimeFormat(string(@irm:infoCutOff))) then every $secondaryDate in (@irm:created, @irm:posted) satisfies if(dtf:isAllowableDateTimeFormat(string($secondaryDate))) then dtf:compareDateTimeRanges(string(@irm:infoCutOff), '&lt;=', string($secondaryDate)) else true() else true()"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="if ('error' = 'error' and dtf:isAllowableDateTimeFormat(string(@irm:infoCutOff))) then every $secondaryDate in (@irm:created, @irm:posted) satisfies if(dtf:isAllowableDateTimeFormat(string($secondaryDate))) then dtf:compareDateTimeRanges(string(@irm:infoCutOff), '&lt;=', string($secondaryDate)) else true() else true()">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="' [IRM-ID-00020][Error] @irm:infoCutOff must not be later than @irm:created, and @irm:posted. '"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M94"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M94"/>
   <xsl:template match="@*|node()" priority="-2" mode="M94">
      <xsl:apply-templates select="*" mode="M94"/>
   </xsl:template>

   <!--PATTERN IRM-ID-00021-->


	<!--RULE CompareDateTimes-R1-->
<xsl:template match="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage[$IC_COMPLIANCE]//*[@irm:validTil]"
                 priority="1000"
                 mode="M95">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage[$IC_COMPLIANCE]//*[@irm:validTil]"
                       id="CompareDateTimes-R1"/>

		    <!--ASSERT warning-->
<xsl:choose>
         <xsl:when test="if ('warning' = 'warning' and dtf:isAllowableDateTimeFormat(string(@irm:validTil))) then every $secondaryDate in (@irm:created, @irm:posted, @irm:infoCutOff, @irm:approvedOn) satisfies if(dtf:isAllowableDateTimeFormat(string($secondaryDate))) then dtf:compareDateTimeRanges(string(@irm:validTil), '&gt;=', string($secondaryDate)) else true() else true()"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="if ('warning' = 'warning' and dtf:isAllowableDateTimeFormat(string(@irm:validTil))) then every $secondaryDate in (@irm:created, @irm:posted, @irm:infoCutOff, @irm:approvedOn) satisfies if(dtf:isAllowableDateTimeFormat(string($secondaryDate))) then dtf:compareDateTimeRanges(string(@irm:validTil), '&gt;=', string($secondaryDate)) else true() else true()">
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="' [IRM-ID-00021][Warning] @irm:validTil must not be earlier than @irm:created, @irm:posted, @irm:infoCutOff, and @irm:approvedOn. '"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="if ('warning' = 'error' and dtf:isAllowableDateTimeFormat(string(@irm:validTil))) then every $secondaryDate in (@irm:created, @irm:posted, @irm:infoCutOff, @irm:approvedOn) satisfies if(dtf:isAllowableDateTimeFormat(string($secondaryDate))) then dtf:compareDateTimeRanges(string(@irm:validTil), '&gt;=', string($secondaryDate)) else true() else true()"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="if ('warning' = 'error' and dtf:isAllowableDateTimeFormat(string(@irm:validTil))) then every $secondaryDate in (@irm:created, @irm:posted, @irm:infoCutOff, @irm:approvedOn) satisfies if(dtf:isAllowableDateTimeFormat(string($secondaryDate))) then dtf:compareDateTimeRanges(string(@irm:validTil), '&gt;=', string($secondaryDate)) else true() else true()">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="' [IRM-ID-00021][Warning] @irm:validTil must not be earlier than @irm:created, @irm:posted, @irm:infoCutOff, and @irm:approvedOn. '"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M95"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M95"/>
   <xsl:template match="@*|node()" priority="-2" mode="M95">
      <xsl:apply-templates select="*" mode="M95"/>
   </xsl:template>

   <!--PATTERN IRM-ID-00022-->


	<!--RULE CompareDateTimes-R1-->
<xsl:template match="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:temporalCoverage"
                 priority="1000"
                 mode="M96">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:temporalCoverage"
                       id="CompareDateTimes-R1"/>

		    <!--ASSERT warning-->
<xsl:choose>
         <xsl:when test="if ('error' = 'warning' and dtf:isAllowableDateTimeFormat(string(irm:start))) then every $secondaryDate in (irm:end) satisfies if(dtf:isAllowableDateTimeFormat(string($secondaryDate))) then dtf:compareDateTimeRanges(string(irm:start), '&lt;=', string($secondaryDate)) else true() else true()"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="if ('error' = 'warning' and dtf:isAllowableDateTimeFormat(string(irm:start))) then every $secondaryDate in (irm:end) satisfies if(dtf:isAllowableDateTimeFormat(string($secondaryDate))) then dtf:compareDateTimeRanges(string(irm:start), '&lt;=', string($secondaryDate)) else true() else true()">
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="' [IRM-ID-00022][Error] For any element irm:temporalCoverage, child element irm:start must not be later than child element irm:end. '"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="if ('error' = 'error' and dtf:isAllowableDateTimeFormat(string(irm:start))) then every $secondaryDate in (irm:end) satisfies if(dtf:isAllowableDateTimeFormat(string($secondaryDate))) then dtf:compareDateTimeRanges(string(irm:start), '&lt;=', string($secondaryDate)) else true() else true()"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="if ('error' = 'error' and dtf:isAllowableDateTimeFormat(string(irm:start))) then every $secondaryDate in (irm:end) satisfies if(dtf:isAllowableDateTimeFormat(string($secondaryDate))) then dtf:compareDateTimeRanges(string(irm:start), '&lt;=', string($secondaryDate)) else true() else true()">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="' [IRM-ID-00022][Error] For any element irm:temporalCoverage, child element irm:start must not be later than child element irm:end. '"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M96"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M96"/>
   <xsl:template match="@*|node()" priority="-2" mode="M96">
      <xsl:apply-templates select="*" mode="M96"/>
   </xsl:template>

   <!--PATTERN IRM-ID-00023-->


	<!--RULE IRM-ID-00023-R1-->
<xsl:template match="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:start | tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:end"
                 priority="1000"
                 mode="M97">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:start | tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:end"
                       id="IRM-ID-00023-R1"/>
      <xsl:variable name="minYear" select="0001"/>
      <xsl:variable name="maxYear" select="9999"/>
      <xsl:variable name="dateList" select="string(.)"/>
      <xsl:variable name="errMsg"
                    select="' [IRM-ID-00023][Error] The permissible values for the year range are 0001 through 9999 for elements irm:start and irm:end. Human Readable: irm:start and irm:end must be positive integers less than 10,000. '"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="every $date in tokenize(normalize-space(string-join($dateList, ' ')),' ') satisfies if(not(dtf:isAllowableDateTimeFormat(string($date)))) then true() else xs:integer(substring(string(dtf:adjust-CombinedDate-to-GMT-timezone($date)), 1, 4)) &lt;= $maxYear and xs:integer(substring(string(dtf:adjust-CombinedDate-to-GMT-timezone($date)), 1, 4)) &gt;= $minYear"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $date in tokenize(normalize-space(string-join($dateList, ' ')),' ') satisfies if(not(dtf:isAllowableDateTimeFormat(string($date)))) then true() else xs:integer(substring(string(dtf:adjust-CombinedDate-to-GMT-timezone($date)), 1, 4)) &lt;= $maxYear and xs:integer(substring(string(dtf:adjust-CombinedDate-to-GMT-timezone($date)), 1, 4)) &gt;= $minYear">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="$errMsg"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M97"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M97"/>
   <xsl:template match="@*|node()" priority="-2" mode="M97">
      <xsl:apply-templates select="*" mode="M97"/>
   </xsl:template>

   <!--PATTERN IRM-ID-00024-->


	<!--RULE IRM-ID-00024-R2-->
<xsl:template match="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:start"
                 priority="1002"
                 mode="M98">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:start"
                       id="IRM-ID-00024-R2"/>
      <xsl:variable name="dateList" select="."/>

		    <!--ASSERT warning-->
<xsl:choose>
         <xsl:when test=" every $date in $dateList satisfies if($date castable as xs:dateTime and contains(string($date),'T')) then matches(string($date),$endsWithTimeZoneRegEx) else true()"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $date in $dateList satisfies if($date castable as xs:dateTime and contains(string($date),'T')) then matches(string($date),$endsWithTimeZoneRegEx) else true()">
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IRM-ID-00024][Warning] For elements and attributes of date-time types, if the time designator (T) is specified,
                    it is recommended that time zone be specified.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M98"/>
   </xsl:template>

	  <!--RULE IRM-ID-00024-R3-->
<xsl:template match="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:end"
                 priority="1001"
                 mode="M98">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:end"
                       id="IRM-ID-00024-R3"/>
      <xsl:variable name="dateList" select="."/>

		    <!--ASSERT warning-->
<xsl:choose>
         <xsl:when test=" every $date in $dateList satisfies if($date castable as xs:dateTime and contains(string($date),'T')) then matches(string($date),$endsWithTimeZoneRegEx) else true()"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $date in $dateList satisfies if($date castable as xs:dateTime and contains(string($date),'T')) then matches(string($date),$endsWithTimeZoneRegEx) else true()">
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IRM-ID-00024][Warning] For elements and attributes of date-time types, if the time designator (T) is specified,
                    it is recommended that time zone be specified.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M98"/>
   </xsl:template>

	  <!--RULE IRM-ID-00024-R4-->
<xsl:template match="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//* [@irm:approvedOn | @irm:dateProcessed | @irm:receivedOn | @irm:posted | @irm:created | @irm:infoCutOff | @irm:validTil]"
                 priority="1000"
                 mode="M98">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//* [@irm:approvedOn | @irm:dateProcessed | @irm:receivedOn | @irm:posted | @irm:created | @irm:infoCutOff | @irm:validTil]"
                       id="IRM-ID-00024-R4"/>
      <xsl:variable name="dateList"
                    select=" (@irm:approvedOn, @irm:dateProcessed, @irm:receivedOn, @irm:posted, @irm:created, @irm:infoCutOff, @irm:validTil) "/>

		    <!--ASSERT warning-->
<xsl:choose>
         <xsl:when test=" every $date in $dateList satisfies if($date castable as xs:dateTime and contains(string($date),'T')) then matches(string($date),$endsWithTimeZoneRegEx) else true()"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $date in $dateList satisfies if($date castable as xs:dateTime and contains(string($date),'T')) then matches(string($date),$endsWithTimeZoneRegEx) else true()">
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IRM-ID-00024][Warning] For elements and attributes of date-time types, if the time designator (T) is specified,
                    it is recommended that time zone be specified.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M98"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M98"/>
   <xsl:template match="@*|node()" priority="-2" mode="M98">
      <xsl:apply-templates select="*" mode="M98"/>
   </xsl:template>

   <!--PATTERN IRM-ID-00025-->


	<!--RULE IRM-ID-00025-R1-->
<xsl:template match="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:*"
                 priority="1000"
                 mode="M99">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:*"
                       id="IRM-ID-00025-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="not(@ism:excludeFromRollup)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(@ism:excludeFromRollup)">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IRM-ID-00025][Error]The attribute @ism:excludeFromRollup must not be specified for any element in the namespace
                    [urn:us:gov:ic:irm] in a TDF IRM assertion. Human readable: Elements in IRM TDF assertions are not allowed to be excluded from
                    roll-up because the security markings are now in the TDF assertion statement metadata.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M99"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M99"/>
   <xsl:template match="@*|node()" priority="-2" mode="M99">
      <xsl:apply-templates select="*" mode="M99"/>
   </xsl:template>

   <!--PATTERN IRM-ID-00029-->


	<!--RULE IRM-ID-00029-R1-->
<xsl:template match="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:geospatialCoverage[@irm:precedence = 'Secondary']"
                 priority="1000"
                 mode="M100">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:geospatialCoverage[@irm:precedence = 'Secondary']"
                       id="IRM-ID-00029-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="../irm:geospatialCoverage[@irm:precedence = 'Primary']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="../irm:geospatialCoverage[@irm:precedence = 'Primary']">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IRM-ID-00029][Error] If element irm:geospatialCoverage has attribute
      @irm:precedence with a value of [Secondary], there must be at least one sibling element
      irm:geospatialCoverage for which attribute @irm:precedence has a value of [Primary]. Human
      Readable: If a secondary country code is provided, there must also be a primary country
      code.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M100"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M100"/>
   <xsl:template match="@*|node()" priority="-2" mode="M100">
      <xsl:apply-templates select="*" mode="M100"/>
   </xsl:template>

   <!--PATTERN IRM-ID-00030-->


	<!--RULE IRM-ID-00030-R1-->
<xsl:template match="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage[//@irm:order]"
                 priority="1000"
                 mode="M101">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage[//@irm:order]"
                       id="IRM-ID-00030-R1"/>
      <xsl:variable name="orderList"
                    select="tokenize(string-join(//@irm:order/normalize-space(), ' '), ' ')"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="(count(distinct-values($orderList)) = count($orderList) and (every $index in 1 to count($orderList) satisfies index-of($orderList, xs:string($index))))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="(count(distinct-values($orderList)) = count($orderList) and (every $index in 1 to count($orderList) satisfies index-of($orderList, xs:string($index))))">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IRM-ID-00030][Error] If attribute @irm:order is specified with integer value N, there must exist other @irm:order
                    attributes with values 1 to N-1 with no duplicates. Human Readable: The values of attribute @irm:order must be numbered
                    sequentially with no duplicates, beginning at 1.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M101"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M101"/>
   <xsl:template match="@*|node()" priority="-2" mode="M101">
      <xsl:apply-templates select="*" mode="M101"/>
   </xsl:template>

   <!--PATTERN IRM-ID-00033-->


	<!--RULE ValidateValueExistenceInList-R1-->
<xsl:template match="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage[$IC_COMPLIANCE]//irm:mimeType"
                 priority="1000"
                 mode="M102">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage[$IC_COMPLIANCE]//irm:mimeType"
                       id="ValidateValueExistenceInList-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test=" some $token in $mimeTypeList satisfies $token = . or matches(., concat('^',$token,'$'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="some $token in $mimeTypeList satisfies $token = . or matches(., concat('^',$token,'$'))">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="' [IRM-ID-00033][Error] If element irm:mimeType is specified, it must match any explicit values or         the media type wildcard regex from CVEnumMIMEType.xml. '"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M102"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M102"/>
   <xsl:template match="@*|node()" priority="-2" mode="M102">
      <xsl:apply-templates select="*" mode="M102"/>
   </xsl:template>

   <!--PATTERN IRM-ID-00034-->


	<!--RULE ValidateValueExistenceInList-R1-->
<xsl:template match="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage[$IC_COMPLIANCE]//irm:language"
                 priority="1000"
                 mode="M103">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage[$IC_COMPLIANCE]//irm:language"
                       id="ValidateValueExistenceInList-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test=" some $token in $compoundLanguageQualifierTypeList satisfies $token = @irm:qualifier or matches(@irm:qualifier, concat('^',$token,'$'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="some $token in $compoundLanguageQualifierTypeList satisfies $token = @irm:qualifier or matches(@irm:qualifier, concat('^',$token,'$'))">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="' [IRM-ID-00034][Error] For element irm:language, attribute irm:qualifier must have a value in CVEnumIRMCompoundLanguageQualifierType.xml. '"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M103"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M103"/>
   <xsl:template match="@*|node()" priority="-2" mode="M103">
      <xsl:apply-templates select="*" mode="M103"/>
   </xsl:template>

   <!--PATTERN IRM-ID-00036-->


	<!--RULE IRM-ID-00036-R1-->
<xsl:template match="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//*[@xlink:*]"
                 priority="1000"
                 mode="M104">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//*[@xlink:*]"
                       id="IRM-ID-00036-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="normalize-space(string(@xlink:type)) or normalize-space(string(@xlink:href))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="normalize-space(string(@xlink:type)) or normalize-space(string(@xlink:href))">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IRM-ID-00036][Error] For any element, if any attribute is specified with the xlink namespace
                    [http://www.w3.org/1999/xlink], then attributes @xlink:type and/or @xlink:href must be specified. Human Readable: If any XLink
                    attributes are specified for an element, then the type and/or URL of the link must also be specified.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M104"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M104"/>
   <xsl:template match="@*|node()" priority="-2" mode="M104">
      <xsl:apply-templates select="*" mode="M104"/>
   </xsl:template>

   <!--PATTERN IRM-ID-00040-->


	<!--RULE IsmEnforcement-R1-->
<xsl:template match="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:type[@irm:qualifier='urn:us:gov:ic:cvenum:irm:activity']"
                 priority="1000"
                 mode="M105">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:type[@irm:qualifier='urn:us:gov:ic:cvenum:irm:activity']"
                       id="IsmEnforcement-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="@ism:classification"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@ism:classification">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="' [IRM-ID-00040][Error] If element irm:type is specified with a qualifier of [urn:us:gov:ic:cvenum:irm:activity], then attribute ism:classification must also be specified. '"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M105"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M105"/>
   <xsl:template match="@*|node()" priority="-2" mode="M105">
      <xsl:apply-templates select="*" mode="M105"/>
   </xsl:template>

   <!--PATTERN IRM-ID-00041-->


	<!--RULE IsmEnforcement-R1-->
<xsl:template match="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:type[@irm:qualifier='urn:us:gov:ic:cvenum:intdis:inteldiscipline']"
                 priority="1000"
                 mode="M106">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:type[@irm:qualifier='urn:us:gov:ic:cvenum:intdis:inteldiscipline']"
                       id="IsmEnforcement-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="@ism:classification"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@ism:classification">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="' [IRM-ID-00041][Error] If element irm:type is specified with a qualifier of [urn:us:gov:ic:cvenum:intdis:inteldiscipline], then attribute ism:classification must also be specified. '"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M106"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M106"/>
   <xsl:template match="@*|node()" priority="-2" mode="M106">
      <xsl:apply-templates select="*" mode="M106"/>
   </xsl:template>

   <!--PATTERN IRM-ID-00042-->


	<!--RULE IsmEnforcement-R1-->
<xsl:template match="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:type[@irm:qualifier='urn:us:gov:ic:cvenum:intdis:inteldiscipline:component']"
                 priority="1000"
                 mode="M107">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:type[@irm:qualifier='urn:us:gov:ic:cvenum:intdis:inteldiscipline:component']"
                       id="IsmEnforcement-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="@ism:classification"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@ism:classification">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="' [IRM-ID-00042][Error] If element irm:type is specified with a qualifier of [urn:us:gov:ic:cvenum:intdis:inteldiscipline:component], then attribute ism:classification must also be specified. '"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M107"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M107"/>
   <xsl:template match="@*|node()" priority="-2" mode="M107">
      <xsl:apply-templates select="*" mode="M107"/>
   </xsl:template>

   <!--PATTERN IRM-ID-00043-->


	<!--RULE IsmEnforcement-R1-->
<xsl:template match="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:type[@irm:qualifier='urn:us:gov:ic:cvenum:intdis:inteldiscipline:component:technique']"
                 priority="1000"
                 mode="M108">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:type[@irm:qualifier='urn:us:gov:ic:cvenum:intdis:inteldiscipline:component:technique']"
                       id="IsmEnforcement-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="@ism:classification"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@ism:classification">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="' [IRM-ID-00043][Error] If element irm:type is specified with a qualifier of [urn:us:gov:ic:cvenum:intdis:inteldiscipline:component:technique], then attribute ism:classification must also be specified. '"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M108"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M108"/>
   <xsl:template match="@*|node()" priority="-2" mode="M108">
      <xsl:apply-templates select="*" mode="M108"/>
   </xsl:template>

   <!--PATTERN IRM-ID-00044-->


	<!--RULE IsmEnforcement-R1-->
<xsl:template match="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:type[@irm:qualifier='urn:us:gov:ic:irm:productline']"
                 priority="1000"
                 mode="M109">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:type[@irm:qualifier='urn:us:gov:ic:irm:productline']"
                       id="IsmEnforcement-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="@ism:classification"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@ism:classification">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="' [IRM-ID-00044][Error] If element irm:type is specified with a qualifier of [urn:us:gov:ic:irm:productline] then attribute ism:classification must also be specified. '"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M109"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M109"/>
   <xsl:template match="@*|node()" priority="-2" mode="M109">
      <xsl:apply-templates select="*" mode="M109"/>
   </xsl:template>

   <!--PATTERN IRM-ID-00045-->


	<!--RULE IRM-ID-00045-R1-->
<xsl:template match="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage[$IC_COMPLIANCE]//irm:geospatialCoverage"
                 priority="1000"
                 mode="M110">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage[$IC_COMPLIANCE]//irm:geospatialCoverage"
                       id="IRM-ID-00045-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="@ism:classification"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@ism:classification">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IRM-ID-00045][Error] Element irm:geospatialCoverage must have ISM classification markings. Human Readable: The
                    geospatialCoverage element must have a classification attribute.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M110"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M110"/>
   <xsl:template match="@*|node()" priority="-2" mode="M110">
      <xsl:apply-templates select="*" mode="M110"/>
   </xsl:template>

   <!--PATTERN IRM-ID-00046-->


	<!--RULE ValidateValueExistenceInList-R1-->
<xsl:template match="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:type[@irm:qualifier='urn:us:gov:ic:cvenum:intdis:inteldiscipline:component:technique']"
                 priority="1000"
                 mode="M111">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:type[@irm:qualifier='urn:us:gov:ic:cvenum:intdis:inteldiscipline:component:technique']"
                       id="ValidateValueExistenceInList-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test=" some $token in $intelDisciplineComponentTechniqueList satisfies $token = @irm:value or matches(@irm:value, concat('^',$token,'$'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="some $token in $intelDisciplineComponentTechniqueList satisfies $token = @irm:value or matches(@irm:value, concat('^',$token,'$'))">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="' [IRM-ID-00046][Error] If element irm:type has attribute @irm:qualifier specified as [urn:us:gov:ic:cvenum:intdis:inteldiscipline:component:technique] the attribute @irm:value must be in CVEnumIntelDisciplineComponentTechnique.xml. Human Readable: Intel Discipline Component Techniques must be in the CVEnumIntelDisciplineComponentTechnique CVE. '"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M111"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M111"/>
   <xsl:template match="@*|node()" priority="-2" mode="M111">
      <xsl:apply-templates select="*" mode="M111"/>
   </xsl:template>

   <!--PATTERN IRM-ID-00047-->


	<!--RULE ValidateValueExistenceInList-R1-->
<xsl:template match="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:type[@irm:qualifier='urn:us:gov:ic:cvenum:intdis:inteldiscipline:component']"
                 priority="1000"
                 mode="M112">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:type[@irm:qualifier='urn:us:gov:ic:cvenum:intdis:inteldiscipline:component']"
                       id="ValidateValueExistenceInList-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test=" some $token in $intelDisciplineComponentList satisfies $token = @irm:value or matches(@irm:value, concat('^',$token,'$'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="some $token in $intelDisciplineComponentList satisfies $token = @irm:value or matches(@irm:value, concat('^',$token,'$'))">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="' [IRM-ID-00047][Error] If element irm:type has attribute @irm:qualifier specified as [urn:us:gov:ic:cvenum:intdis:inteldiscipline:component] the attribute @irm:value must be in CVEnumIntelDisciplineComponent.xml. Human Readable: Intel Discipline Components must be in the CVEnumIntelDisciplineComponent CVE. '"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M112"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M112"/>
   <xsl:template match="@*|node()" priority="-2" mode="M112">
      <xsl:apply-templates select="*" mode="M112"/>
   </xsl:template>

   <!--PATTERN IRM-ID-00048-->


	<!--RULE ValidateValueExistenceInList-R1-->
<xsl:template match="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:type[@irm:qualifier='urn:us:gov:ic:cvenum:intdis:inteldiscipline']"
                 priority="1000"
                 mode="M113">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:type[@irm:qualifier='urn:us:gov:ic:cvenum:intdis:inteldiscipline']"
                       id="ValidateValueExistenceInList-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test=" some $token in $intelDisciplineList satisfies $token = @irm:value or matches(@irm:value, concat('^',$token,'$'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="some $token in $intelDisciplineList satisfies $token = @irm:value or matches(@irm:value, concat('^',$token,'$'))">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="' [IRM-ID-00048][Error] If element irm:type has attribute @irm:qualifier specified as [urn:us:gov:ic:cvenum:intdis:inteldiscipline] the attribute @irm:value must be in CVEnumIntelDiscipline.xml. Human Readable: Intel Disciplines must be in the CVEnumIntelDiscipline CVE. '"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M113"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M113"/>
   <xsl:template match="@*|node()" priority="-2" mode="M113">
      <xsl:apply-templates select="*" mode="M113"/>
   </xsl:template>

   <!--PATTERN IRM-ID-00053-->


	<!--RULE ValidateValueExistenceInList-R1-->
<xsl:template match="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:type[@irm:qualifier='urn:us:gov:ic:cvenum:irm:activity']"
                 priority="1000"
                 mode="M114">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:type[@irm:qualifier='urn:us:gov:ic:cvenum:irm:activity']"
                       id="ValidateValueExistenceInList-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test=" some $token in $activityList satisfies $token = @irm:value or matches(@irm:value, concat('^',$token,'$'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="some $token in $activityList satisfies $token = @irm:value or matches(@irm:value, concat('^',$token,'$'))">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="' [IRM-ID-00053][Error] If element irm:type has attribute @irm:qualifier specified as [urn:us:gov:ic:cvenum:irm:activity] the attribute @irm:value must be in CVEnumIRMActivity.xml. Human Readable: Activity must be in the CVEnumIRMActivity CVE. '"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M114"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M114"/>
   <xsl:template match="@*|node()" priority="-2" mode="M114">
      <xsl:apply-templates select="*" mode="M114"/>
   </xsl:template>

   <!--PATTERN IRM-ID-00054-->


	<!--RULE ValidateValueExistenceInList-R1-->
<xsl:template match="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage[$IC_COMPLIANCE]//irm:geospatialCoverage[@irm:precedence]"
                 priority="1000"
                 mode="M115">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage[$IC_COMPLIANCE]//irm:geospatialCoverage[@irm:precedence]"
                       id="ValidateValueExistenceInList-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test=" some $token in $coveragePrecedenceList satisfies $token = @irm:precedence or matches(@irm:precedence, concat('^',$token,'$'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="some $token in $coveragePrecedenceList satisfies $token = @irm:precedence or matches(@irm:precedence, concat('^',$token,'$'))">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="' [IRM-ID-00054][Error] If element irm:geospatialCoverage has attribute @irm:precedence specified, then the value must be in CVEnumIRMCoveragePrecedence.xml. Human Readable: Geospatial Coverage Precedence must be in the CVEnumIRMCoveragePrecedence CVE. '"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M115"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M115"/>
   <xsl:template match="@*|node()" priority="-2" mode="M115">
      <xsl:apply-templates select="*" mode="M115"/>
   </xsl:template>

   <!--PATTERN IRM-ID-00055-->


	<!--RULE IRM-ID-00055-R1-->
<xsl:template match="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage[$IC_COMPLIANCE]//irm:geospatialCoverage[@irm:order]"
                 priority="1000"
                 mode="M116">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage[$IC_COMPLIANCE]//irm:geospatialCoverage[@irm:order]"
                       id="IRM-ID-00055-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="count(irm:geographicIdentifier/irm:countryCode) + count(irm:geographicIdentifier/irm:subDivisionCode) = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(irm:geographicIdentifier/irm:countryCode) + count(irm:geographicIdentifier/irm:subDivisionCode) = 1">
               <xsl:attribute name="id">IRM-00055</xsl:attribute>
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IRM-ID-00055][Error] If irm:geospatialCoverage/@order is specified then there must be one and only one of
                    irm:geospatialIdentifier/irm:countryCode or irm:geospatialIdentifier/irm:subDivisionCode. Human Readable: A single order value
                    must be applied to one country code or one subdivision code</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M116"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M116"/>
   <xsl:template match="@*|node()" priority="-2" mode="M116">
      <xsl:apply-templates select="*" mode="M116"/>
   </xsl:template>

   <!--PATTERN IRM-ID-00062-->


	<!--RULE ICIdentifierRestrictions-R1-->
<xsl:template match="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:identifier[@irm:qualifier='IC-ID']"
                 priority="1000"
                 mode="M117">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:identifier[@irm:qualifier='IC-ID']"
                       id="ICIdentifierRestrictions-R1"/>
      <xsl:variable name="icidRegEx"
                    select="'^guide://([1-9][0-9]{0,15}|0)/[A-Za-z0-9_\-\.]{1,36}$'"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="matches(string(string(@irm:value)),$icidRegEx)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="matches(string(string(@irm:value)),$icidRegEx)">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="'[IRM-ID-00062][Error] The value of an IC-ID identifier must follow standardized convention. Human Readable: The IC-ID identifier value has to follow standardized convention.'"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M117"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M117"/>
   <xsl:template match="@*|node()" priority="-2" mode="M117">
      <xsl:apply-templates select="*" mode="M117"/>
   </xsl:template>

   <!--PATTERN IRM-ID-00063-->


	<!--RULE IRM-ID-00063-R1-->
<xsl:template match="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage[$IC_COMPLIANCE]"
                 priority="1000"
                 mode="M118">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage[$IC_COMPLIANCE]"
                       id="IRM-ID-00063-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="irm:creator/irm:organization/@irm:acronym"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="irm:creator/irm:organization/@irm:acronym">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IRM-ID-00063][Error] Element irm:ICResourceMetadataPackage/irm:creator/irm:organization must
      specify attribute @irm:acronym. Human Readable: The IRM card must specify a creator
      organization with an IC agency acronym for the referenced resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M118"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M118"/>
   <xsl:template match="@*|node()" priority="-2" mode="M118">
      <xsl:apply-templates select="*" mode="M118"/>
   </xsl:template>

   <!--PATTERN IRM-ID-00064-->


	<!--RULE IRM-ID-00064-R1-->
<xsl:template match="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage[$IC_COMPLIANCE]"
                 priority="1000"
                 mode="M119">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage[$IC_COMPLIANCE]"
                       id="IRM-ID-00064-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="irm:dates/@irm:created"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="irm:dates/@irm:created">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IRM-ID-00064][Error]
      Element irm:ICResourceMetadataPackage/irm:dates must specify attribute @irm:created. Human
      Readable: The IRM card must specify the date on which the referenced resource was
      created.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M119"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M119"/>
   <xsl:template match="@*|node()" priority="-2" mode="M119">
      <xsl:apply-templates select="*" mode="M119"/>
   </xsl:template>

   <!--PATTERN IRM-ID-00065-->


	<!--RULE IRM-ID-00065-R1-->
<xsl:template match="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage/irm:dates[@irm:created]"
                 priority="1000"
                 mode="M120">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage/irm:dates[@irm:created]"
                       id="IRM-ID-00065-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="@irm:created castable as xs:dateTime"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="@irm:created castable as xs:dateTime">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IRM-ID-00065][Error] Attribute irm:ICResourceMetadataPackage/irm:dates/@irm:created must be
      castable as an xs:dateTime type. Human Readable: The date on which the referenced resource was
      created must be a dateTime type.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M120"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M120"/>
   <xsl:template match="@*|node()" priority="-2" mode="M120">
      <xsl:apply-templates select="*" mode="M120"/>
   </xsl:template>

   <!--PATTERN IRM-ID-00068-->


	<!--RULE IRM-ID-00068-R1-->
<xsl:template match="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:taskID[@xlink:href]"
                 priority="1000"
                 mode="M121">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:taskID[@xlink:href]"
                       id="IRM-ID-00068-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="normalize-space(string(@xlink:href))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="normalize-space(string(@xlink:href))">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IRM-ID-00068][Error] For element irm:taskID if attribute xlink:href exists, then the attribute must have a non-null
                    value. Human Readable:</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M121"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M121"/>
   <xsl:template match="@*|node()" priority="-2" mode="M121">
      <xsl:apply-templates select="*" mode="M121"/>
   </xsl:template>

   <!--PATTERN IRM-ID-00070-->


	<!--RULE ValidateValueExistenceInList-R1-->
<xsl:template match="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:type[@irm:qualifier='urn:us:gov:ic:cvenum:irm:executableindicator']"
                 priority="1000"
                 mode="M122">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:type[@irm:qualifier='urn:us:gov:ic:cvenum:irm:executableindicator']"
                       id="ValidateValueExistenceInList-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test=" some $token in $executableIndicatorList satisfies $token = @irm:value or matches(@irm:value, concat('^',$token,'$'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="some $token in $executableIndicatorList satisfies $token = @irm:value or matches(@irm:value, concat('^',$token,'$'))">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="' [IRM-ID-00070][Error] If element irm:type has attribute @irm:qualifier specified as [urn:us:gov:ic:cvenum:irm:executableindicator] the attribute @irm:value must be in CVEnumIRMExecutableIndicator.xml. HHuman Readable: Executable Indicator Value must be in the CVEnumIRMExecutableIndicator CVE. '"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M122"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M122"/>
   <xsl:template match="@*|node()" priority="-2" mode="M122">
      <xsl:apply-templates select="*" mode="M122"/>
   </xsl:template>

   <!--PATTERN IRM-ID-00071-->


	<!--RULE ValidateValueExistenceInList-R1-->
<xsl:template match="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:type[@irm:qualifier='urn:us:gov:ic:cvenum:irm:maliciouscodeindicator']"
                 priority="1000"
                 mode="M123">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:type[@irm:qualifier='urn:us:gov:ic:cvenum:irm:maliciouscodeindicator']"
                       id="ValidateValueExistenceInList-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test=" some $token in $maliciousCodeIndicatorList satisfies $token = @irm:value or matches(@irm:value, concat('^',$token,'$'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="some $token in $maliciousCodeIndicatorList satisfies $token = @irm:value or matches(@irm:value, concat('^',$token,'$'))">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="' [IRM-ID-00071][Error] If element irm:type has attribute @irm:qualifier specified as [urn:us:gov:ic:cvenum:irm:maliciouscodeindicator] the attribute @irm:value must be in CVEnumIRMMaliciousCodeIndicator.xml. Human Readable: Malicious Code Indicator values must be in the CVEnumIRMMaliciousCodeIndicator CVE. '"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M123"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M123"/>
   <xsl:template match="@*|node()" priority="-2" mode="M123">
      <xsl:apply-templates select="*" mode="M123"/>
   </xsl:template>

   <!--PATTERN IRM-ID-00072-->


	<!--RULE IRM-ID-00072-R1-->
<xsl:template match="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:searchableDate"
                 priority="1000"
                 mode="M124">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:searchableDate"
                       id="IRM-ID-00072-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="if((irm:start castable as xs:dateTime) and (irm:end castable as xs:dateTime)) then xs:dateTime(irm:start) &lt; xs:dateTime(irm:end) else false()"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="if((irm:start castable as xs:dateTime) and (irm:end castable as xs:dateTime)) then xs:dateTime(irm:start) &lt; xs:dateTime(irm:end) else false()">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IRM-ID-00072][Error] For element irm:searchableDate, irm:start must be earlier than irm:end. Human Readable: Within
                    the searchableDate element, the date within the start element must be earlier than the date within the end element.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M124"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M124"/>
   <xsl:template match="@*|node()" priority="-2" mode="M124">
      <xsl:apply-templates select="*" mode="M124"/>
   </xsl:template>

   <!--PATTERN IRM-ID-00073-->


	<!--RULE ValidateValueExistenceInList-R1-->
<xsl:template match="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:type[@irm:qualifier='urn:us:gov:ic:cvenum:irm:positive:intel']"
                 priority="1000"
                 mode="M125">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:type[@irm:qualifier='urn:us:gov:ic:cvenum:irm:positive:intel']"
                       id="ValidateValueExistenceInList-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test=" some $token in $positiveIntelList satisfies $token = @irm:value or matches(@irm:value, concat('^',$token,'$'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="some $token in $positiveIntelList satisfies $token = @irm:value or matches(@irm:value, concat('^',$token,'$'))">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="' [IRM-ID-00073][Error] If element irm:type has attribute @irm:qualifier specified as [urn:us:gov:ic:cvenum:irm:positive:intel] the attribute @irm:value must be in CVEnumIRMPositiveIntel.xml. Human Readable: Positive Intel values must be in the CVEnumIRMPositiveIntel CVE. '"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M125"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M125"/>
   <xsl:template match="@*|node()" priority="-2" mode="M125">
      <xsl:apply-templates select="*" mode="M125"/>
   </xsl:template>

   <!--PATTERN IRM-ID-00074-->


	<!--RULE IRM-ID-00074-R1-->
<xsl:template match="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:searchableDate"
                 priority="1000"
                 mode="M126">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:searchableDate"
                       id="IRM-ID-00074-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="(irm:start castable as xs:dateTime) and (irm:end castable as xs:dateTime)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="(irm:start castable as xs:dateTime) and (irm:end castable as xs:dateTime)">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IRM-ID-00074][Error] For element irm:searchableDate, elements irm:start and irm:end must match the xsd:dateTime
                    format. Human Readable: Within the searchableDate element, the start and end elements values must conform to the xsd:dateTime
                    format.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M126"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M126"/>
   <xsl:template match="@*|node()" priority="-2" mode="M126">
      <xsl:apply-templates select="*" mode="M126"/>
   </xsl:template>

   <!--PATTERN IRM-ID-00076-->


	<!--RULE IRM-ID-00076-R1-->
<xsl:template match="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:acquiredOn"
                 priority="1000"
                 mode="M127">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:acquiredOn"
                       id="IRM-ID-00076-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test=" normalize-space(string(irm:description)) or normalize-space(string(irm:approximableDate)) or normalize-space(string(irm:searchableDate/irm:start)) or normalize-space(string(irm:searchableDate/irm:end))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="normalize-space(string(irm:description)) or normalize-space(string(irm:approximableDate)) or normalize-space(string(irm:searchableDate/irm:start)) or normalize-space(string(irm:searchableDate/irm:end))">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IRM-ID-00076][Error] If the irm:acquiredOn element exists, at least one of its child elements irm:description,
                    irm:approximableDate, or irm:searchableDate must be present. Human Readable: The acquiredOn element must have at least one of the
                    following child elements: description, approximableDate and searchableDate.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M127"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M127"/>
   <xsl:template match="@*|node()" priority="-2" mode="M127">
      <xsl:apply-templates select="*" mode="M127"/>
   </xsl:template>

   <!--PATTERN IRM-ID-00077-->


	<!--RULE IRM-ID-00077-R2-->
<xsl:template match="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:person"
                 priority="1000"
                 mode="M128">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:person"
                       id="IRM-ID-00077-R2"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="                 irm:surname[normalize-space(string(text()))] or irm:userID[normalize-space(string(text()))] or irm:name[normalize-space(string(text()))] or irm:affiliation[normalize-space(string(text()))] or irm:phone[normalize-space(string(text()))] or irm:email[normalize-space(string(text()))] or (some $token in ancestor::irm:postalAddress/*/text()                     satisfies normalize-space(string($token)))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="irm:surname[normalize-space(string(text()))] or irm:userID[normalize-space(string(text()))] or irm:name[normalize-space(string(text()))] or irm:affiliation[normalize-space(string(text()))] or irm:phone[normalize-space(string(text()))] or irm:email[normalize-space(string(text()))] or (some $token in ancestor::irm:postalAddress/*/text() satisfies normalize-space(string($token)))">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IRM-ID-00077][Error] For element irm:person at least one of
            the following child elements must have non-whitespace content: irm:surname, irm:userID,
            irm:name, irm:affiliation, irm:postalAddress, irm:phone irm:email.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M128"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M128"/>
   <xsl:template match="@*|node()" priority="-2" mode="M128">
      <xsl:apply-templates select="*" mode="M128"/>
   </xsl:template>

   <!--PATTERN IRM-ID-00078-->


	<!--RULE IRM-ID-00078-R2-->
<xsl:template match="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:temporalCoverage[irm:name='infoCutOff']/irm:approximableStart/irm:searchableDate/irm:start"
                 priority="1008"
                 mode="M129">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:temporalCoverage[irm:name='infoCutOff']/irm:approximableStart/irm:searchableDate/irm:start"
                       id="IRM-ID-00078-R2"/>
      <xsl:variable name="minYear" select="1901"/>
      <xsl:variable name="maxYear" select="$currentYear"/>
      <xsl:variable name="dateValue" select="."/>
      <xsl:variable name="errMsg"
                    select="' [IRM-ID-00078][Error] For elements irm:acquiredOn and irm:temporalCoverage with child element name [infoCutoff], the permissible values for the year range are 1901 through the current year for elements irm:approximableDate, irm:start, and irm:end. '"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="if(not(dtf:yearPortionHasFourDigits(string($dateValue)))) then false() else xs:integer(substring(string(dtf:adjust-CombinedDate-to-GMT-timezone($dateValue)), 1, 4)) &lt;= $maxYear and xs:integer(substring(string(dtf:adjust-CombinedDate-to-GMT-timezone($dateValue)), 1, 4)) &gt;= $minYear"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="if(not(dtf:yearPortionHasFourDigits(string($dateValue)))) then false() else xs:integer(substring(string(dtf:adjust-CombinedDate-to-GMT-timezone($dateValue)), 1, 4)) &lt;= $maxYear and xs:integer(substring(string(dtf:adjust-CombinedDate-to-GMT-timezone($dateValue)), 1, 4)) &gt;= $minYear">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="$errMsg"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M129"/>
   </xsl:template>

	  <!--RULE IRM-ID-00078-R3-->
<xsl:template match="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:temporalCoverage[irm:name='infoCutOff']/irm:approximableStart/irm:searchableDate/irm:end"
                 priority="1007"
                 mode="M129">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:temporalCoverage[irm:name='infoCutOff']/irm:approximableStart/irm:searchableDate/irm:end"
                       id="IRM-ID-00078-R3"/>
      <xsl:variable name="minYear" select="1901"/>
      <xsl:variable name="maxYear" select="$currentYear"/>
      <xsl:variable name="dateValue" select="."/>
      <xsl:variable name="errMsg"
                    select="' [IRM-ID-00078][Error] For elements irm:acquiredOn and irm:temporalCoverage with child element name [infoCutoff], the permissible values for the year range are 1901 through the current year for elements irm:approximableDate, irm:start, and irm:end. '"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="if(not(dtf:yearPortionHasFourDigits(string($dateValue)))) then false() else xs:integer(substring(string(dtf:adjust-CombinedDate-to-GMT-timezone($dateValue)), 1, 4)) &lt;= $maxYear and xs:integer(substring(string(dtf:adjust-CombinedDate-to-GMT-timezone($dateValue)), 1, 4)) &gt;= $minYear"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="if(not(dtf:yearPortionHasFourDigits(string($dateValue)))) then false() else xs:integer(substring(string(dtf:adjust-CombinedDate-to-GMT-timezone($dateValue)), 1, 4)) &lt;= $maxYear and xs:integer(substring(string(dtf:adjust-CombinedDate-to-GMT-timezone($dateValue)), 1, 4)) &gt;= $minYear">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="$errMsg"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M129"/>
   </xsl:template>

	  <!--RULE IRM-ID-00078-R4-->
<xsl:template match="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:temporalCoverage[irm:name='infoCutOff']/irm:approximableEnd/irm:searchableDate/irm:start"
                 priority="1006"
                 mode="M129">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:temporalCoverage[irm:name='infoCutOff']/irm:approximableEnd/irm:searchableDate/irm:start"
                       id="IRM-ID-00078-R4"/>
      <xsl:variable name="minYear" select="1901"/>
      <xsl:variable name="maxYear" select="$currentYear"/>
      <xsl:variable name="dateValue" select="."/>
      <xsl:variable name="errMsg"
                    select="' [IRM-ID-00078][Error] For elements irm:acquiredOn and irm:temporalCoverage with child element name [infoCutoff], the permissible values for the year range are 1901 through the current year for elements irm:approximableDate, irm:start, and irm:end. '"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="if(not(dtf:yearPortionHasFourDigits(string($dateValue)))) then false() else xs:integer(substring(string(dtf:adjust-CombinedDate-to-GMT-timezone($dateValue)), 1, 4)) &lt;= $maxYear and xs:integer(substring(string(dtf:adjust-CombinedDate-to-GMT-timezone($dateValue)), 1, 4)) &gt;= $minYear"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="if(not(dtf:yearPortionHasFourDigits(string($dateValue)))) then false() else xs:integer(substring(string(dtf:adjust-CombinedDate-to-GMT-timezone($dateValue)), 1, 4)) &lt;= $maxYear and xs:integer(substring(string(dtf:adjust-CombinedDate-to-GMT-timezone($dateValue)), 1, 4)) &gt;= $minYear">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="$errMsg"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M129"/>
   </xsl:template>

	  <!--RULE IRM-ID-00078-R5-->
<xsl:template match="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:temporalCoverage[irm:name='infoCutOff']/irm:approximableEnd/irm:searchableDate/irm:end"
                 priority="1005"
                 mode="M129">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:temporalCoverage[irm:name='infoCutOff']/irm:approximableEnd/irm:searchableDate/irm:end"
                       id="IRM-ID-00078-R5"/>
      <xsl:variable name="minYear" select="1901"/>
      <xsl:variable name="maxYear" select="$currentYear"/>
      <xsl:variable name="dateValue" select="."/>
      <xsl:variable name="errMsg"
                    select="' [IRM-ID-00078][Error] For elements irm:acquiredOn and irm:temporalCoverage with child element name [infoCutoff], the permissible values for the year range are 1901 through the current year for elements irm:approximableDate, irm:start, and irm:end. '"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="if(not(dtf:yearPortionHasFourDigits(string($dateValue)))) then false() else xs:integer(substring(string(dtf:adjust-CombinedDate-to-GMT-timezone($dateValue)), 1, 4)) &lt;= $maxYear and xs:integer(substring(string(dtf:adjust-CombinedDate-to-GMT-timezone($dateValue)), 1, 4)) &gt;= $minYear"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="if(not(dtf:yearPortionHasFourDigits(string($dateValue)))) then false() else xs:integer(substring(string(dtf:adjust-CombinedDate-to-GMT-timezone($dateValue)), 1, 4)) &lt;= $maxYear and xs:integer(substring(string(dtf:adjust-CombinedDate-to-GMT-timezone($dateValue)), 1, 4)) &gt;= $minYear">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="$errMsg"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M129"/>
   </xsl:template>

	  <!--RULE IRM-ID-00078-R6-->
<xsl:template match="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:temporalCoverage[irm:name='infoCutOff']/irm:start"
                 priority="1004"
                 mode="M129">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:temporalCoverage[irm:name='infoCutOff']/irm:start"
                       id="IRM-ID-00078-R6"/>
      <xsl:variable name="minYear" select="1901"/>
      <xsl:variable name="maxYear" select="$currentYear"/>
      <xsl:variable name="dateValue" select="."/>
      <xsl:variable name="errMsg"
                    select="' [IRM-ID-00078][Error] For elements irm:acquiredOn and irm:temporalCoverage with child element name [infoCutoff], the permissible values for the year range are 1901 through the current year for elements irm:approximableDate, irm:start, and irm:end. '"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="if(not(dtf:yearPortionHasFourDigits(string($dateValue)))) then false() else xs:integer(substring(string(dtf:adjust-CombinedDate-to-GMT-timezone($dateValue)), 1, 4)) &lt;= $maxYear and xs:integer(substring(string(dtf:adjust-CombinedDate-to-GMT-timezone($dateValue)), 1, 4)) &gt;= $minYear"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="if(not(dtf:yearPortionHasFourDigits(string($dateValue)))) then false() else xs:integer(substring(string(dtf:adjust-CombinedDate-to-GMT-timezone($dateValue)), 1, 4)) &lt;= $maxYear and xs:integer(substring(string(dtf:adjust-CombinedDate-to-GMT-timezone($dateValue)), 1, 4)) &gt;= $minYear">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="$errMsg"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M129"/>
   </xsl:template>

	  <!--RULE IRM-ID-00078-R7-->
<xsl:template match="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:temporalCoverage[irm:name='infoCutOff']/irm:end"
                 priority="1003"
                 mode="M129">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:temporalCoverage[irm:name='infoCutOff']/irm:end"
                       id="IRM-ID-00078-R7"/>
      <xsl:variable name="minYear" select="1901"/>
      <xsl:variable name="maxYear" select="$currentYear"/>
      <xsl:variable name="dateValue" select="."/>
      <xsl:variable name="errMsg"
                    select="' [IRM-ID-00078][Error] For elements irm:acquiredOn and irm:temporalCoverage with child element name [infoCutoff], the permissible values for the year range are 1901 through the current year for elements irm:approximableDate, irm:start, and irm:end. '"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="if(not(dtf:yearPortionHasFourDigits(string($dateValue)))) then false() else xs:integer(substring(string(dtf:adjust-CombinedDate-to-GMT-timezone($dateValue)), 1, 4)) &lt;= $maxYear and xs:integer(substring(string(dtf:adjust-CombinedDate-to-GMT-timezone($dateValue)), 1, 4)) &gt;= $minYear"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="if(not(dtf:yearPortionHasFourDigits(string($dateValue)))) then false() else xs:integer(substring(string(dtf:adjust-CombinedDate-to-GMT-timezone($dateValue)), 1, 4)) &lt;= $maxYear and xs:integer(substring(string(dtf:adjust-CombinedDate-to-GMT-timezone($dateValue)), 1, 4)) &gt;= $minYear">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="$errMsg"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M129"/>
   </xsl:template>

	  <!--RULE IRM-ID-00078-R8-->
<xsl:template match="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:acquiredOn/irm:approximableDate"
                 priority="1002"
                 mode="M129">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:acquiredOn/irm:approximableDate"
                       id="IRM-ID-00078-R8"/>
      <xsl:variable name="minYear" select="1901"/>
      <xsl:variable name="maxYear" select="$currentYear"/>
      <xsl:variable name="dateValue" select="."/>
      <xsl:variable name="errMsg"
                    select="' [IRM-ID-00078][Error] For elements irm:acquiredOn and irm:temporalCoverage with child element name [infoCutoff], the permissible values for the year range are 1901 through the current year for elements irm:approximableDate, irm:start, and irm:end. '"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="if(not(dtf:yearPortionHasFourDigits(string($dateValue)))) then false() else xs:integer(substring(string(dtf:adjust-CombinedDate-to-GMT-timezone($dateValue)), 1, 4)) &lt;= $maxYear and xs:integer(substring(string(dtf:adjust-CombinedDate-to-GMT-timezone($dateValue)), 1, 4)) &gt;= $minYear"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="if(not(dtf:yearPortionHasFourDigits(string($dateValue)))) then false() else xs:integer(substring(string(dtf:adjust-CombinedDate-to-GMT-timezone($dateValue)), 1, 4)) &lt;= $maxYear and xs:integer(substring(string(dtf:adjust-CombinedDate-to-GMT-timezone($dateValue)), 1, 4)) &gt;= $minYear">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="$errMsg"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M129"/>
   </xsl:template>

	  <!--RULE IRM-ID-00078-R9-->
<xsl:template match="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:acquiredOn/irm:searchableDate/irm:start"
                 priority="1001"
                 mode="M129">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:acquiredOn/irm:searchableDate/irm:start"
                       id="IRM-ID-00078-R9"/>
      <xsl:variable name="minYear" select="1901"/>
      <xsl:variable name="maxYear" select="$currentYear"/>
      <xsl:variable name="dateValue" select="."/>
      <xsl:variable name="errMsg"
                    select="' [IRM-ID-00078][Error] For elements irm:acquiredOn and irm:temporalCoverage with child element name [infoCutoff], the permissible values for the year range are 1901 through the current year for elements irm:approximableDate, irm:start, and irm:end. '"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="if(not(dtf:yearPortionHasFourDigits(string($dateValue)))) then false() else xs:integer(substring(string(dtf:adjust-CombinedDate-to-GMT-timezone($dateValue)), 1, 4)) &lt;= $maxYear and xs:integer(substring(string(dtf:adjust-CombinedDate-to-GMT-timezone($dateValue)), 1, 4)) &gt;= $minYear"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="if(not(dtf:yearPortionHasFourDigits(string($dateValue)))) then false() else xs:integer(substring(string(dtf:adjust-CombinedDate-to-GMT-timezone($dateValue)), 1, 4)) &lt;= $maxYear and xs:integer(substring(string(dtf:adjust-CombinedDate-to-GMT-timezone($dateValue)), 1, 4)) &gt;= $minYear">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="$errMsg"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M129"/>
   </xsl:template>

	  <!--RULE IRM-ID-00078-R10-->
<xsl:template match="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:acquiredOn/irm:searchableDate/irm:end"
                 priority="1000"
                 mode="M129">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:acquiredOn/irm:searchableDate/irm:end"
                       id="IRM-ID-00078-R10"/>
      <xsl:variable name="minYear" select="1901"/>
      <xsl:variable name="maxYear" select="$currentYear"/>
      <xsl:variable name="dateValue" select="."/>
      <xsl:variable name="errMsg"
                    select="' [IRM-ID-00078][Error] For elements irm:acquiredOn and irm:temporalCoverage with child element name [infoCutoff], the permissible values for the year range are 1901 through the current year for elements irm:approximableDate, irm:start, and irm:end. '"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="if(not(dtf:yearPortionHasFourDigits(string($dateValue)))) then false() else xs:integer(substring(string(dtf:adjust-CombinedDate-to-GMT-timezone($dateValue)), 1, 4)) &lt;= $maxYear and xs:integer(substring(string(dtf:adjust-CombinedDate-to-GMT-timezone($dateValue)), 1, 4)) &gt;= $minYear"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="if(not(dtf:yearPortionHasFourDigits(string($dateValue)))) then false() else xs:integer(substring(string(dtf:adjust-CombinedDate-to-GMT-timezone($dateValue)), 1, 4)) &lt;= $maxYear and xs:integer(substring(string(dtf:adjust-CombinedDate-to-GMT-timezone($dateValue)), 1, 4)) &gt;= $minYear">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="$errMsg"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M129"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M129"/>
   <xsl:template match="@*|node()" priority="-2" mode="M129">
      <xsl:apply-templates select="*" mode="M129"/>
   </xsl:template>

   <!--PATTERN IRM-ID-00079-->


	<!--RULE ValidateValidationEnvSchema-R1-->
<xsl:template match="/" priority="1000" mode="M130">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/"
                       id="ValidateValidationEnvSchema-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="             document('../../Schema/IC-ID/IC-ID.xsd')//xsd:schema//@version castable as xs:double             and document('../../Schema/IC-ID/IC-ID.xsd')//xsd:schema//@version &gt;= '1'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('../../Schema/IC-ID/IC-ID.xsd')//xsd:schema//@version castable as xs:double and document('../../Schema/IC-ID/IC-ID.xsd')//xsd:schema//@version &gt;= '1'">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> [<xsl:text/>
                  <xsl:value-of select="'IRM-ID-00079'"/>
                  <xsl:text/>][Error] Version [
            <xsl:text/>
                  <xsl:value-of select="document('../../Schema/IC-ID/IC-ID.xsd')//xsd:schema//@version"/>
                  <xsl:text/> ] of
            <xsl:text/>
                  <xsl:value-of select="'IC-ID'"/>
                  <xsl:text/> found; Version [<xsl:text/>
                  <xsl:value-of select="'1'"/>
                  <xsl:text/>] or later is required. The latest version of <xsl:text/>
                  <xsl:value-of select="'IC-ID'"/>
                  <xsl:text/> is not being used in the validation infrastructure.
            Regardless of the version indicated on the instance document, the validation
            infrastructure needs to use a version of <xsl:text/>
                  <xsl:value-of select="'IC-ID'"/>
                  <xsl:text/> that is
            version [<xsl:text/>
                  <xsl:value-of select="'1'"/>
                  <xsl:text/>] or later. NOTE: This is not an error of
            the instance document but of the validation environment itself. The incorrect value was
            found in <xsl:text/>
                  <xsl:value-of select="document-uri(document('../../Schema/IC-ID/IC-ID.xsd'))"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M130"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M130"/>
   <xsl:template match="@*|node()" priority="-2" mode="M130">
      <xsl:apply-templates select="*" mode="M130"/>
   </xsl:template>

   <!--PATTERN IRM-ID-00080-->


	<!--RULE ValidateValidationEnvCVE-R1-->
<xsl:template match="/" priority="1000" mode="M131">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/"
                       id="ValidateValidationEnvCVE-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="document('../../CVE/USAgency/CVEnumUSAgencyAcronym.xml')//cve:CVE//@specVersion castable as xs:double              and document('../../CVE/USAgency/CVEnumUSAgencyAcronym.xml')//cve:CVE//@specVersion &gt;= '201703.201802'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('../../CVE/USAgency/CVEnumUSAgencyAcronym.xml')//cve:CVE//@specVersion castable as xs:double and document('../../CVE/USAgency/CVEnumUSAgencyAcronym.xml')//cve:CVE//@specVersion &gt;= '201703.201802'">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
            [<xsl:text/>
                  <xsl:value-of select="'IRM-ID-00080'"/>
                  <xsl:text/>][Error] Version [ <xsl:text/>
                  <xsl:value-of select="document('../../CVE/USAgency/CVEnumUSAgencyAcronym.xml')//cve:CVE//@specVersion"/>
                  <xsl:text/> ] of <xsl:text/>
                  <xsl:value-of select="'USAgency'"/>
                  <xsl:text/> found; 
            Version [<xsl:text/>
                  <xsl:value-of select="'201703.201802'"/>
                  <xsl:text/>] or later is required. The latest version of <xsl:text/>
                  <xsl:value-of select="'USAgency'"/>
                  <xsl:text/> 
            is not being used in the validation infrastructure. Regardless of the version indicated on the instance document, 
            the validation infrastructure needs to use a version of <xsl:text/>
                  <xsl:value-of select="'USAgency'"/>
                  <xsl:text/> that is
            version [<xsl:text/>
                  <xsl:value-of select="'201703.201802'"/>
                  <xsl:text/>] or later. NOTE: This is not an error of the instance
            document but of the validation environment itself. The incorrect value was found in <xsl:text/>
                  <xsl:value-of select="document-uri(document('../../CVE/USAgency/CVEnumUSAgencyAcronym.xml'))"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M131"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M131"/>
   <xsl:template match="@*|node()" priority="-2" mode="M131">
      <xsl:apply-templates select="*" mode="M131"/>
   </xsl:template>

   <!--PATTERN IRM-ID-00081-->


	<!--RULE IRM-ID-00081-R1-->
<xsl:template match="irm:type[$IC_COMPLIANCE][@irm:qualifier = 'urn:us:gov:ic:irm:productline'] | irm:type[$IC_COMPLIANCE][contains(@irm:qualifier, 'urn:us:gov:ic:cvenum:intdis')]"
                 priority="1000"
                 mode="M132">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="irm:type[$IC_COMPLIANCE][@irm:qualifier = 'urn:us:gov:ic:irm:productline'] | irm:type[$IC_COMPLIANCE][contains(@irm:qualifier, 'urn:us:gov:ic:cvenum:intdis')]"
                       id="IRM-ID-00081-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="not(normalize-space(text()))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(normalize-space(text()))">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IRM-ID-00081][Error] A irm:type element with @irm:qualifer ProductLine or Intel must
            not contain any text. Human Readable: IRM Types of ProductLine or Intel must not
            contain any text within the element.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M132"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M132"/>
   <xsl:template match="@*|node()" priority="-2" mode="M132">
      <xsl:apply-templates select="*" mode="M132"/>
   </xsl:template>

   <!--PATTERN IRM-ID-00086-->


	<!--RULE ValidateValidationEnvCVE-R1-->
<xsl:template match="/" priority="1000" mode="M133">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/"
                       id="ValidateValidationEnvCVE-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="document('../../CVE/INTDIS/CVEnumIntelDiscipline.xml')//cve:CVE//@specVersion castable as xs:double              and document('../../CVE/INTDIS/CVEnumIntelDiscipline.xml')//cve:CVE//@specVersion &gt;= '201707'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('../../CVE/INTDIS/CVEnumIntelDiscipline.xml')//cve:CVE//@specVersion castable as xs:double and document('../../CVE/INTDIS/CVEnumIntelDiscipline.xml')//cve:CVE//@specVersion &gt;= '201707'">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
            [<xsl:text/>
                  <xsl:value-of select="'IRM-ID-00086'"/>
                  <xsl:text/>][Error] Version [ <xsl:text/>
                  <xsl:value-of select="document('../../CVE/INTDIS/CVEnumIntelDiscipline.xml')//cve:CVE//@specVersion"/>
                  <xsl:text/> ] of <xsl:text/>
                  <xsl:value-of select="'INTDIS'"/>
                  <xsl:text/> found; 
            Version [<xsl:text/>
                  <xsl:value-of select="'201707'"/>
                  <xsl:text/>] or later is required. The latest version of <xsl:text/>
                  <xsl:value-of select="'INTDIS'"/>
                  <xsl:text/> 
            is not being used in the validation infrastructure. Regardless of the version indicated on the instance document, 
            the validation infrastructure needs to use a version of <xsl:text/>
                  <xsl:value-of select="'INTDIS'"/>
                  <xsl:text/> that is
            version [<xsl:text/>
                  <xsl:value-of select="'201707'"/>
                  <xsl:text/>] or later. NOTE: This is not an error of the instance
            document but of the validation environment itself. The incorrect value was found in <xsl:text/>
                  <xsl:value-of select="document-uri(document('../../CVE/INTDIS/CVEnumIntelDiscipline.xml'))"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M133"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M133"/>
   <xsl:template match="@*|node()" priority="-2" mode="M133">
      <xsl:apply-templates select="*" mode="M133"/>
   </xsl:template>

   <!--PATTERN IRM-ID-00087-->


	<!--RULE IRM-ID-00087-R1-->
<xsl:template match="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:type[starts-with(@irm:qualifier,'urn:us:gov:ic:cvenum:intdis:inteldiscipline')]"
                 priority="1000"
                 mode="M134">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:type[starts-with(@irm:qualifier,'urn:us:gov:ic:cvenum:intdis:inteldiscipline')]"
                       id="IRM-ID-00087-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="ancestor-or-self::tdf:*//@intdis:CESVersion"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="ancestor-or-self::tdf:*//@intdis:CESVersion">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IRM-ID-00087][Error] If @irm:qualifier identifies a intelligence discipline URN, then @intdis:CESVersion must exist
                    as well.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M134"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M134"/>
   <xsl:template match="@*|node()" priority="-2" mode="M134">
      <xsl:apply-templates select="*" mode="M134"/>
   </xsl:template>

   <!--PATTERN IRM-ID-00088-->


	<!--RULE ValidateValidationEnvCVE-R1-->
<xsl:template match="/" priority="1000" mode="M135">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/"
                       id="ValidateValidationEnvCVE-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="document('../../CVE/MIME/CVEnumMIMEType.xml')//cve:CVE//@specVersion castable as xs:double              and document('../../CVE/MIME/CVEnumMIMEType.xml')//cve:CVE//@specVersion &gt;= '202010'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('../../CVE/MIME/CVEnumMIMEType.xml')//cve:CVE//@specVersion castable as xs:double and document('../../CVE/MIME/CVEnumMIMEType.xml')//cve:CVE//@specVersion &gt;= '202010'">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
            [<xsl:text/>
                  <xsl:value-of select="'IRM-ID-00088'"/>
                  <xsl:text/>][Error] Version [ <xsl:text/>
                  <xsl:value-of select="document('../../CVE/MIME/CVEnumMIMEType.xml')//cve:CVE//@specVersion"/>
                  <xsl:text/> ] of <xsl:text/>
                  <xsl:value-of select="'MIME'"/>
                  <xsl:text/> found; 
            Version [<xsl:text/>
                  <xsl:value-of select="'202010'"/>
                  <xsl:text/>] or later is required. The latest version of <xsl:text/>
                  <xsl:value-of select="'MIME'"/>
                  <xsl:text/> 
            is not being used in the validation infrastructure. Regardless of the version indicated on the instance document, 
            the validation infrastructure needs to use a version of <xsl:text/>
                  <xsl:value-of select="'MIME'"/>
                  <xsl:text/> that is
            version [<xsl:text/>
                  <xsl:value-of select="'202010'"/>
                  <xsl:text/>] or later. NOTE: This is not an error of the instance
            document but of the validation environment itself. The incorrect value was found in <xsl:text/>
                  <xsl:value-of select="document-uri(document('../../CVE/MIME/CVEnumMIMEType.xml'))"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M135"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M135"/>
   <xsl:template match="@*|node()" priority="-2" mode="M135">
      <xsl:apply-templates select="*" mode="M135"/>
   </xsl:template>

   <!--PATTERN IRM-ID-00089-->


	<!--RULE IRM-ID-00089-R1-->
<xsl:template match="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:mimeType"
                 priority="1000"
                 mode="M136">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:mimeType"
                       id="IRM-ID-00089-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="//@mime:CESVersion"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="//@mime:CESVersion">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IRM-ID-00089][Error] If @irm:mimeType exists, then @mime:CESVersion must exist as well.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M136"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M136"/>
   <xsl:template match="@*|node()" priority="-2" mode="M136">
      <xsl:apply-templates select="*" mode="M136"/>
   </xsl:template>

   <!--PATTERN IRM-ID-00090-->


	<!--RULE IRM-ID-00090-R1-->
<xsl:template match="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:geospatialCoverage//irm:subDivisionCode"
                 priority="1000"
                 mode="M137">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:geospatialCoverage//irm:subDivisionCode"
                       id="IRM-ID-00090-R1"/>
      <xsl:variable name="isGENCSubDivision"
                    select="matches(normalize-space(./@irm:codespace), '^as:GENC:6:(ed3|3-[1-9][0-9]*)$')"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="not($isGENCSubDivision) or (some $token in $gencSubDivisionList satisfies $token = normalize-space(./@irm:code))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($isGENCSubDivision) or (some $token in $gencSubDivisionList satisfies $token = normalize-space(./@irm:code))">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IRM-ID-00090][Error] If subDivisionCode codespace is GENC codespace, then value must be in the GENC subDivisionCode
                    cve.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M137"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M137"/>
   <xsl:template match="@*|node()" priority="-2" mode="M137">
      <xsl:apply-templates select="*" mode="M137"/>
   </xsl:template>

   <!--PATTERN IRM-ID-00091-->


	<!--RULE IRM-ID-00091-R1-->
<xsl:template match="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:mimeType"
                 priority="1000"
                 mode="M138">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:mimeType"
                       id="IRM-ID-00091-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="not(some $deprecatedMimeTypeValue in $deprecatedMimeTypeList satisfies . = $deprecatedMimeTypeValue)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(some $deprecatedMimeTypeValue in $deprecatedMimeTypeList satisfies . = $deprecatedMimeTypeValue)">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IRM-ID-00091][Warning] Deprecated MIME types should not be used.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M138"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M138"/>
   <xsl:template match="@*|node()" priority="-2" mode="M138">
      <xsl:apply-templates select="*" mode="M138"/>
   </xsl:template>

   <!--PATTERN IRM-ID-00092-->


	<!--RULE IRM-ID-00092-R1-->
<xsl:template match="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:nonStateActor[@irm:qualifier='urn:us:gov:ic:cvenum:pm:nonstateactors']"
                 priority="1000"
                 mode="M139">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:nonStateActor[@irm:qualifier='urn:us:gov:ic:cvenum:pm:nonstateactors']"
                       id="IRM-ID-00092-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="some $token in $nonStateActorsList satisfies $token = normalize-space(./text())"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="some $token in $nonStateActorsList satisfies $token = normalize-space(./text())">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IRM-ID-00092][Error] irm:NonStateActor should contain a value from the NonStateActor CVE</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M139"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M139"/>
   <xsl:template match="@*|node()" priority="-2" mode="M139">
      <xsl:apply-templates select="*" mode="M139"/>
   </xsl:template>

   <!--PATTERN IRM-ID-00093-->


	<!--RULE IRM-ID-00093-R1-->
<xsl:template match="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:geospatialCoverage"
                 priority="1000"
                 mode="M140">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:geospatialCoverage"
                       id="IRM-ID-00093-R1"/>
      <xsl:variable name="hasCountryCodes"
                    select="count(irm:geographicIdentifier/irm:countryCode) &gt; 0"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="not($hasCountryCodes) or (some $countryCode in irm:geographicIdentifier/irm:countryCode satisfies matches(normalize-space($countryCode/@irm:codespace), '^ge:GENC:3:(ed3|3-[1-9][0-9]*)$'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($hasCountryCodes) or (some $countryCode in irm:geographicIdentifier/irm:countryCode satisfies matches(normalize-space($countryCode/@irm:codespace), '^ge:GENC:3:(ed3|3-[1-9][0-9]*)$'))">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IRM-ID-00093][Error] irm:countryCode must be a GENC ED3 codespace: ^ge:GENC:3:(ed3|3-[1-9][0-9]*)$</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M140"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M140"/>
   <xsl:template match="@*|node()" priority="-2" mode="M140">
      <xsl:apply-templates select="*" mode="M140"/>
   </xsl:template>

   <!--PATTERN IRM-ID-00094-->


	<!--RULE IRM-ID-00094-R1-->
<xsl:template match="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:geospatialCoverage//irm:countryCode"
                 priority="1000"
                 mode="M141">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:geospatialCoverage//irm:countryCode"
                       id="IRM-ID-00094-R1"/>
      <xsl:variable name="isGENCCountryCode"
                    select="matches(normalize-space(./@irm:codespace), '^ge:GENC:3:(ed3|3-[1-9][0-9]*)$')"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="not($isGENCCountryCode) or (some $token in $gencCountryCodeList satisfies $token = normalize-space(./@irm:code))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($isGENCCountryCode) or (some $token in $gencCountryCodeList satisfies $token = normalize-space(./@irm:code))">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IRM-ID-00094][Error] irm:countryCode must be in GENC countrycode cve.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M141"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M141"/>
   <xsl:template match="@*|node()" priority="-2" mode="M141">
      <xsl:apply-templates select="*" mode="M141"/>
   </xsl:template>

   <!--PATTERN IRM-ID-00095-->


	<!--RULE IRM-ID-00095-R1-->
<xsl:template match="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:geospatialCoverage"
                 priority="1000"
                 mode="M142">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:geospatialCoverage"
                       id="IRM-ID-00095-R1"/>
      <xsl:variable name="hasSubDivisions"
                    select="count(irm:geographicIdentifier/irm:subDivisionCode) &gt; 0"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="not($hasSubDivisions) or (some $subDivisionCode in irm:geographicIdentifier/irm:subDivisionCode satisfies matches(normalize-space($subDivisionCode/@irm:codespace), '^as:GENC:6:(ed3|3-[1-9][0-9]*)$'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($hasSubDivisions) or (some $subDivisionCode in irm:geographicIdentifier/irm:subDivisionCode satisfies matches(normalize-space($subDivisionCode/@irm:codespace), '^as:GENC:6:(ed3|3-[1-9][0-9]*)$'))">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IRM-ID-00095][Error] irm:subDivisionCode must be a GENC ED3 codespace: ^as:GENC:6:(ed3|3-[1-9][0-9]*)$</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M142"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M142"/>
   <xsl:template match="@*|node()" priority="-2" mode="M142">
      <xsl:apply-templates select="*" mode="M142"/>
   </xsl:template>

   <!--PATTERN IRM-ID-00096-->


	<!--RULE ValidateValidationEnvCVE-R1-->
<xsl:template match="/" priority="1000" mode="M143">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/"
                       id="ValidateValidationEnvCVE-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="document('../../CVE/ISM/CVEnumISMClassificationAll.xml')//cve:CVE//@specVersion castable as xs:double              and document('../../CVE/ISM/CVEnumISMClassificationAll.xml')//cve:CVE//@specVersion &gt;= '202111'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('../../CVE/ISM/CVEnumISMClassificationAll.xml')//cve:CVE//@specVersion castable as xs:double and document('../../CVE/ISM/CVEnumISMClassificationAll.xml')//cve:CVE//@specVersion &gt;= '202111'">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
            [<xsl:text/>
                  <xsl:value-of select="'IRM-ID-00096'"/>
                  <xsl:text/>][Error] Version [ <xsl:text/>
                  <xsl:value-of select="document('../../CVE/ISM/CVEnumISMClassificationAll.xml')//cve:CVE//@specVersion"/>
                  <xsl:text/> ] of <xsl:text/>
                  <xsl:value-of select="'ISM'"/>
                  <xsl:text/> found; 
            Version [<xsl:text/>
                  <xsl:value-of select="'202111'"/>
                  <xsl:text/>] or later is required. The latest version of <xsl:text/>
                  <xsl:value-of select="'ISM'"/>
                  <xsl:text/> 
            is not being used in the validation infrastructure. Regardless of the version indicated on the instance document, 
            the validation infrastructure needs to use a version of <xsl:text/>
                  <xsl:value-of select="'ISM'"/>
                  <xsl:text/> that is
            version [<xsl:text/>
                  <xsl:value-of select="'202111'"/>
                  <xsl:text/>] or later. NOTE: This is not an error of the instance
            document but of the validation environment itself. The incorrect value was found in <xsl:text/>
                  <xsl:value-of select="document-uri(document('../../CVE/ISM/CVEnumISMClassificationAll.xml'))"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M143"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M143"/>
   <xsl:template match="@*|node()" priority="-2" mode="M143">
      <xsl:apply-templates select="*" mode="M143"/>
   </xsl:template>

   <!--PATTERN IRM-ID-00098-->


	<!--RULE IRM-ID-00098-R1-->
<xsl:template match="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//*[starts-with(@irm:codespace,'ge:GENC') or starts-with(@irm:codespace,'as:GENC')]"
                 priority="1000"
                 mode="M144">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//*[starts-with(@irm:codespace,'ge:GENC') or starts-with(@irm:codespace,'as:GENC')]"
                       id="IRM-ID-00098-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="ancestor-or-self::tdf:*/tdf:Assertion//irm:ICResourceMetadataPackage/@genc:CESVersion"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="ancestor-or-self::tdf:*/tdf:Assertion//irm:ICResourceMetadataPackage/@genc:CESVersion">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IRM-ID-00098][Error] Use of a GENC codespace requires the presence of the IC-GENC CESVersion
                    attribute.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M144"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M144"/>
   <xsl:template match="@*|node()" priority="-2" mode="M144">
      <xsl:apply-templates select="*" mode="M144"/>
   </xsl:template>

   <!--PATTERN IRM-ID-00099-->


	<!--RULE ValidateValidationEnvCVE-R1-->
<xsl:template match="/" priority="1000" mode="M145">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/"
                       id="ValidateValidationEnvCVE-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="document('../../CVE/IC-GENC/CVEnumGENCCountryCode.xml')//cve:CVE//@specVersion castable as xs:double              and document('../../CVE/IC-GENC/CVEnumGENCCountryCode.xml')//cve:CVE//@specVersion &gt;= '201909'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('../../CVE/IC-GENC/CVEnumGENCCountryCode.xml')//cve:CVE//@specVersion castable as xs:double and document('../../CVE/IC-GENC/CVEnumGENCCountryCode.xml')//cve:CVE//@specVersion &gt;= '201909'">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
            [<xsl:text/>
                  <xsl:value-of select="'IRM-ID-00099'"/>
                  <xsl:text/>][Error] Version [ <xsl:text/>
                  <xsl:value-of select="document('../../CVE/IC-GENC/CVEnumGENCCountryCode.xml')//cve:CVE//@specVersion"/>
                  <xsl:text/> ] of <xsl:text/>
                  <xsl:value-of select="'IC-GENC'"/>
                  <xsl:text/> found; 
            Version [<xsl:text/>
                  <xsl:value-of select="'201909'"/>
                  <xsl:text/>] or later is required. The latest version of <xsl:text/>
                  <xsl:value-of select="'IC-GENC'"/>
                  <xsl:text/> 
            is not being used in the validation infrastructure. Regardless of the version indicated on the instance document, 
            the validation infrastructure needs to use a version of <xsl:text/>
                  <xsl:value-of select="'IC-GENC'"/>
                  <xsl:text/> that is
            version [<xsl:text/>
                  <xsl:value-of select="'201909'"/>
                  <xsl:text/>] or later. NOTE: This is not an error of the instance
            document but of the validation environment itself. The incorrect value was found in <xsl:text/>
                  <xsl:value-of select="document-uri(document('../../CVE/IC-GENC/CVEnumGENCCountryCode.xml'))"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M145"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M145"/>
   <xsl:template match="@*|node()" priority="-2" mode="M145">
      <xsl:apply-templates select="*" mode="M145"/>
   </xsl:template>

   <!--PATTERN IRM-ID-00100-->


	<!--RULE IRM-ID-00100-R1-->
<xsl:template match="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage"
                 priority="1000"
                 mode="M146">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage"
                       id="IRM-ID-00100-R1"/>
      <xsl:variable name="hasStatementMetadata"
                    select="count(../preceding-sibling::tdf:StatementMetadata) &gt; 0"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="$hasStatementMetadata"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="$hasStatementMetadata">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IRM-ID-00100][Error] tdf:Assertion must contain tdf:StatementMetadata when tdf:StructuredStatement contains
              irm:ICResourceMetadataPackage.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M146"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M146"/>
   <xsl:template match="@*|node()" priority="-2" mode="M146">
      <xsl:apply-templates select="*" mode="M146"/>
   </xsl:template>

   <!--PATTERN IRM-ID-00101-->


	<!--RULE IRM-ID-00101-R1-->
<xsl:template match="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage[$IC_COMPLIANCE]//irm:organization[@irm:acronym]"
                 priority="1000"
                 mode="M147">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage[$IC_COMPLIANCE]//irm:organization[@irm:acronym]"
                       id="IRM-ID-00101-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="if (starts-with(normalize-space(@irm:acronym),'USA.')) then (some $token in $USAgencyAcronymList satisfies $token = normalize-space( @irm:acronym )) else true()"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="if (starts-with(normalize-space(@irm:acronym),'USA.')) then (some $token in $USAgencyAcronymList satisfies $token = normalize-space( @irm:acronym )) else true()">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IRM-ID-00101][Error] If element irm:organization has attribute @irm:acronym specified and the acronym begins with
          "USA.", then the organization value must be defined by the USAgency CES. Found <xsl:text/>
                  <xsl:value-of select="normalize-space( @irm:acronym )"/>
                  <xsl:text/> 
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M147"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M147"/>
   <xsl:template match="@*|node()" priority="-2" mode="M147">
      <xsl:apply-templates select="*" mode="M147"/>
   </xsl:template>

   <!--PATTERN IRM-ID-00102-->


	<!--RULE IRM-ID-00102-R1-->
<xsl:template match="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage[$IC_COMPLIANCE]//irm:organization[@irm:acronym]"
                 priority="1000"
                 mode="M148">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage[$IC_COMPLIANCE]//irm:organization[@irm:acronym]"
                       id="IRM-ID-00102-R1"/>
      <xsl:variable name="CC" select="tokenize(normalize-space(@irm:acronym),'\.')[1]"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="some $token in $gencCountryCodeList satisfies $token = normalize-space($CC)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="some $token in $gencCountryCodeList satisfies $token = normalize-space($CC)">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IRM-ID-00102][Error] If element irm:organization has attribute @irm:acronym specified,
          then the country value must be defined by the GENC CES. Found <xsl:text/>
                  <xsl:value-of select="./@irm:acronym"/>
                  <xsl:text/> 
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M148"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M148"/>
   <xsl:template match="@*|node()" priority="-2" mode="M148">
      <xsl:apply-templates select="*" mode="M148"/>
   </xsl:template>

   <!--PATTERN IRM-ID-00103-->


	<!--RULE IRM-ID-00103-R1-->
<xsl:template match="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage[$IC_COMPLIANCE]//irm:organization[@irm:acronym]"
                 priority="1000"
                 mode="M149">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage[$IC_COMPLIANCE]//irm:organization[@irm:acronym]"
                       id="IRM-ID-00103-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="util:meetsType(@irm:acronym, $NmTokenPattern)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="util:meetsType(@irm:acronym, $NmTokenPattern)">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IRM-ID-00103][Error] If element irm:organization has attribute @irm:acronym specified, then attribute @irm:acronym
                    must be of type NmToken.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M149"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M149"/>
   <xsl:template match="@*|node()" priority="-2" mode="M149">
      <xsl:apply-templates select="*" mode="M149"/>
   </xsl:template>

   <!--PATTERN IRM-ID-00104-->


	<!--RULE IRM-ID-00104-R1-->
<xsl:template match="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage[$IC_COMPLIANCE]//irm:organization[@irm:acronym]"
                 priority="1000"
                 mode="M150">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage[$IC_COMPLIANCE]//irm:organization[@irm:acronym]"
                       id="IRM-ID-00104-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="util:meetsType(substring-after(@irm:acronym, '.'), $NmTokenPattern)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="util:meetsType(substring-after(@irm:acronym, '.'), $NmTokenPattern)">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IRM-ID-00104][Error] If element irm:organization has attribute
      @irm:acronym specified, then the agency suffix after the dot delimiter must be of type
      NmToken. Found <xsl:text/>
                  <xsl:value-of select="normalize-space(@irm:acronym)"/>
                  <xsl:text/> substring was:
        <xsl:text/>
                  <xsl:value-of select="substring-after(@irm:acronym, '.')"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M150"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M150"/>
   <xsl:template match="@*|node()" priority="-2" mode="M150">
      <xsl:apply-templates select="*" mode="M150"/>
   </xsl:template>

   <!--PATTERN IRM-ID-00105-->


	<!--RULE IRM-ID-00105-R1-->
<xsl:template match="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage[$IC_COMPLIANCE]//irm:nonStateActor"
                 priority="1000"
                 mode="M151">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage[$IC_COMPLIANCE]//irm:nonStateActor"
                       id="IRM-ID-00105-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="@irm:qualifier"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@irm:qualifier">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IRM-ID-00105][Error] Use of the
      @irm:qualifier on the irm:nonStateActor element is required.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M151"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M151"/>
   <xsl:template match="@*|node()" priority="-2" mode="M151">
      <xsl:apply-templates select="*" mode="M151"/>
   </xsl:template>

   <!--PATTERN IRM-ID-00106-->


	<!--RULE ValidateValidationEnvSchema-R1-->
<xsl:template match="/" priority="1000" mode="M152">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/"
                       id="ValidateValidationEnvSchema-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="             document('../../Schema/PMA/PMA-XML.xsd')//xsd:schema//@version castable as xs:double             and document('../../Schema/PMA/PMA-XML.xsd')//xsd:schema//@version &gt;= '201903.201909'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('../../Schema/PMA/PMA-XML.xsd')//xsd:schema//@version castable as xs:double and document('../../Schema/PMA/PMA-XML.xsd')//xsd:schema//@version &gt;= '201903.201909'">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> [<xsl:text/>
                  <xsl:value-of select="'IRM-ID-00106'"/>
                  <xsl:text/>][Error] Version [
            <xsl:text/>
                  <xsl:value-of select="document('../../Schema/PMA/PMA-XML.xsd')//xsd:schema//@version"/>
                  <xsl:text/> ] of
            <xsl:text/>
                  <xsl:value-of select="'PMA'"/>
                  <xsl:text/> found; Version [<xsl:text/>
                  <xsl:value-of select="'201903.201909'"/>
                  <xsl:text/>] or later is required. The latest version of <xsl:text/>
                  <xsl:value-of select="'PMA'"/>
                  <xsl:text/> is not being used in the validation infrastructure.
            Regardless of the version indicated on the instance document, the validation
            infrastructure needs to use a version of <xsl:text/>
                  <xsl:value-of select="'PMA'"/>
                  <xsl:text/> that is
            version [<xsl:text/>
                  <xsl:value-of select="'201903.201909'"/>
                  <xsl:text/>] or later. NOTE: This is not an error of
            the instance document but of the validation environment itself. The incorrect value was
            found in <xsl:text/>
                  <xsl:value-of select="document-uri(document('../../Schema/PMA/PMA-XML.xsd'))"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M152"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M152"/>
   <xsl:template match="@*|node()" priority="-2" mode="M152">
      <xsl:apply-templates select="*" mode="M152"/>
   </xsl:template>

   <!--PATTERN IRM-ID-00107-->


	<!--RULE ValidateValidationEnvSchema-R1-->
<xsl:template match="/" priority="1000" mode="M153">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/"
                       id="ValidateValidationEnvSchema-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="             document('../../Schema/VIRT/VIRT.xsd')//xsd:schema//@version castable as xs:double             and document('../../Schema/VIRT/VIRT.xsd')//xsd:schema//@version &gt;= '202010'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('../../Schema/VIRT/VIRT.xsd')//xsd:schema//@version castable as xs:double and document('../../Schema/VIRT/VIRT.xsd')//xsd:schema//@version &gt;= '202010'">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> [<xsl:text/>
                  <xsl:value-of select="'IRM-ID-00107'"/>
                  <xsl:text/>][Error] Version [
            <xsl:text/>
                  <xsl:value-of select="document('../../Schema/VIRT/VIRT.xsd')//xsd:schema//@version"/>
                  <xsl:text/> ] of
            <xsl:text/>
                  <xsl:value-of select="'VIRT'"/>
                  <xsl:text/> found; Version [<xsl:text/>
                  <xsl:value-of select="'202010'"/>
                  <xsl:text/>] or later is required. The latest version of <xsl:text/>
                  <xsl:value-of select="'VIRT'"/>
                  <xsl:text/> is not being used in the validation infrastructure.
            Regardless of the version indicated on the instance document, the validation
            infrastructure needs to use a version of <xsl:text/>
                  <xsl:value-of select="'VIRT'"/>
                  <xsl:text/> that is
            version [<xsl:text/>
                  <xsl:value-of select="'202010'"/>
                  <xsl:text/>] or later. NOTE: This is not an error of
            the instance document but of the validation environment itself. The incorrect value was
            found in <xsl:text/>
                  <xsl:value-of select="document-uri(document('../../Schema/VIRT/VIRT.xsd'))"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M153"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M153"/>
   <xsl:template match="@*|node()" priority="-2" mode="M153">
      <xsl:apply-templates select="*" mode="M153"/>
   </xsl:template>

   <!--PATTERN IRM-ID-00108-->


	<!--RULE IRM-ID-00108-R1-->
<xsl:template match="*[@irm:DESVersion]" priority="1000" mode="M154">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[@irm:DESVersion]"
                       id="IRM-ID-00108-R1"/>

		    <!--ASSERT warning-->
<xsl:choose>
         <xsl:when test="matches(@irm:DESVersion,'^202111(\-.{1,23})?$')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="matches(@irm:DESVersion,'^202111(\-.{1,23})?$')">
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [IRM-ID-00108][Warning] irm:DESVersion attribute SHOULD be specified as version 202111 (Version:2021-NOV) with an optional extension.  
            The value provided was: <xsl:text/>
                  <xsl:value-of select="@irm:DESVersion"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M154"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M154"/>
   <xsl:template match="@*|node()" priority="-2" mode="M154">
      <xsl:apply-templates select="*" mode="M154"/>
   </xsl:template>

   <!--PATTERN IRM-ID-00109-->


	<!--RULE IRM-ID-00109-R1-->
<xsl:template match="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage"
                 priority="1000"
                 mode="M155">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage"
                       id="IRM-ID-00109-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="util:checkUSATokenValidity(@irm:compliesWith,$compliesWithUSATypeList)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="util:checkUSATokenValidity(@irm:compliesWith,$compliesWithUSATypeList)">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [IRM-ID-00109][Error] If the tokens in @irm:compliesWith starts with "USA", they must be a value that exists or starts
            with a value from CVEnumIRMCompliesWithUSA. <xsl:text/>
                  <xsl:value-of select="concat('[',@irm:compliesWith,']')"/>
                  <xsl:text/> 
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M155"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M155"/>
   <xsl:template match="@*|node()" priority="-2" mode="M155">
      <xsl:apply-templates select="*" mode="M155"/>
   </xsl:template>

   <!--PATTERN IRM-ID-00110-->


	<!--RULE IRM-ID-00110-R1-->
<xsl:template match="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage"
                 priority="1000"
                 mode="M156">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage"
                       id="IRM-ID-00110-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="util:containsOnlyTheTokensSubstringBefore('_',@irm:compliesWith,$gencCountryCodeList)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="util:containsOnlyTheTokensSubstringBefore('_',@irm:compliesWith,$gencCountryCodeList)">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [IRM-ID-00110][Error] The string before the first underscore of each @irm:compliesWith token must be in IC-GENC.
            <xsl:text/>
                  <xsl:value-of select="concat('[',@irm:compliesWith,']')"/>
                  <xsl:text/> 
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M156"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M156"/>
   <xsl:template match="@*|node()" priority="-2" mode="M156">
      <xsl:apply-templates select="*" mode="M156"/>
   </xsl:template>

   <!--PATTERN IRM-ID-00111-->


	<!--RULE IRM-ID-00111-R1-->
<xsl:template match="irm:virtualCoverage" priority="1000" mode="M157">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="irm:virtualCoverage"
                       id="IRM-ID-00111-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="exists(./@virt:protocol) or exists(./@virt:address)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="exists(./@virt:protocol) or exists(./@virt:address)">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [IRM-ID-00110][Error] If irm:virtualCoverage exists, then it must include at least @virt:protocol
            or @virt:address.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M157"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M157"/>
   <xsl:template match="@*|node()" priority="-2" mode="M157">
      <xsl:apply-templates select="*" mode="M157"/>
   </xsl:template>

   <!--PATTERN IRM-ID-00112-->


	<!--RULE IRM-ID-00112-R1-->
<xsl:template match="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage[$IC_COMPLIANCE]//irm:mimeType"
                 priority="1000"
                 mode="M158">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage[$IC_COMPLIANCE]//irm:mimeType"
                       id="IRM-ID-00112-R1"/>

		    <!--ASSERT warning-->
<xsl:choose>
         <xsl:when test="some $token in $nonRegexMimeTypeList satisfies . = $token or matches(., concat('^',$token,'$'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="some $token in $nonRegexMimeTypeList satisfies . = $token or matches(., concat('^',$token,'$'))">
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [IRM-ID-00112][Warning] If element irm:mimeType is specified, it SHOULD have a value from CVEnumMIMEType.xml 
            other than the wildcard entry. MIME type [<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>] is not explicitly defined in CVEnumMIMEType.xml 
            and is a match ONLY because of the wildcard entry.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M158"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M158"/>
   <xsl:template match="@*|node()" priority="-2" mode="M158">
      <xsl:apply-templates select="*" mode="M158"/>
   </xsl:template>

   <!--PATTERN IRM-ID-00113-->


	<!--RULE IRM-ID-00113-R1-->
<xsl:template match="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:geospatialCoverage"
                 priority="1000"
                 mode="M159">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:geospatialCoverage"
                       id="IRM-ID-00113-R1"/>
      <xsl:variable name="hasWaterBody"
                    select="count(irm:geographicIdentifier/irm:waterBody) &gt; 0"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="not($hasWaterBody) or (some $waterBody in irm:geographicIdentifier/irm:waterBody satisfies matches(normalize-space($waterBody/@irm:codespace), '^wb:CWW:3:(ed1)$'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($hasWaterBody) or (some $waterBody in irm:geographicIdentifier/irm:waterBody satisfies matches(normalize-space($waterBody/@irm:codespace), '^wb:CWW:3:(ed1)$'))">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IRM-ID-00113][Error] irm:waterBody must be a GENC ED3 codespace: ^wb:CWW:3:(ed1)$</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M159"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M159"/>
   <xsl:template match="@*|node()" priority="-2" mode="M159">
      <xsl:apply-templates select="*" mode="M159"/>
   </xsl:template>

   <!--PATTERN IRM-ID-00114-->


	<!--RULE IRM-ID-00114-R1-->
<xsl:template match="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:geospatialCoverage//irm:waterBody"
                 priority="1000"
                 mode="M160">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:geospatialCoverage//irm:waterBody"
                       id="IRM-ID-00114-R1"/>
      <xsl:variable name="isCWWWaterBody"
                    select="matches(normalize-space(./@irm:codespace), '^wb:CWW:3:(ed1)$')"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="not($isCWWWaterBody) or (some $token in $waterBodyList satisfies $token = normalize-space(./@irm:code))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($isCWWWaterBody) or (some $token in $waterBodyList satisfies $token = normalize-space(./@irm:code))">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IRM-ID-00114][Error] irm:waterBody must be in CWW waterBody cve.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M160"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M160"/>
   <xsl:template match="@*|node()" priority="-2" mode="M160">
      <xsl:apply-templates select="*" mode="M160"/>
   </xsl:template>
</xsl:stylesheet>
<!--UNCLASSIFIED-->
