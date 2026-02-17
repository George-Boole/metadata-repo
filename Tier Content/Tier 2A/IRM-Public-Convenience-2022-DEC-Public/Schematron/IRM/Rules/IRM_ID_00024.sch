<?xml version="1.0" encoding="utf-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:ism="urn:us:gov:ic:ism"
             xmlns:sch="http://purl.oclc.org/dsdl/schematron"
             id="IRM-ID-00024">
    <sch:p class="ruleText"
           ism:classification="U"
           ism:ownerProducer="USA">[IRM-ID-00024][Warning] For elements irm:start and irm:end and attributes @irm:approvedOn, @irm:dateProcessed,
           @irm:receivedOn, @irm:infoCutOff, @irm:posted, @irm:validTil, and @irm:created, if the time designator (T) is specified, it is recommended
           that time zone be specified. Human Readable: For elements and attributes of date-time types, if the time designator (T) is specified, it
           is recommended that time zone be specified.</sch:p>
    <sch:p class="codeDesc"
           ism:classification="U"
           ism:ownerProducer="USA">The pattern applies to irm:start and irm:end elements, as well as any element that contains one or more attributes
           @irm:approvedOn, @irm:infoCutOff, @irm:posted, and @irm:created. It joins each of these attribute values, if present, into a larger
           space-separated string. It then breaks this string into tokens at each space character. If the value of the token contains the time zone
           designator (T), then it makes sure that the token value matches the regular expression for a timeZone, which is defined in the main schema
           file (IRM_XML.sch).</sch:p>
    <!-- Abstract rule, which asserts that if the date $primaryDate specifies the 
        time designator (T), then the timezone is specified -->
    <sch:rule abstract="true"
              id="abs.rule00024">
        <sch:assert test=" every $date in $dateList satisfies if($date castable as xs:dateTime and contains(string($date),'T')) then matches(string($date),$endsWithTimeZoneRegEx) else true()"
                    flag="warning"
                    role="warning">[IRM-ID-00024][Warning] For elements and attributes of date-time types, if the time designator (T) is specified,
                    it is recommended that time zone be specified.</sch:assert>
    </sch:rule>
    <!-- Begin using abstract rule on required elements and attributes -->
    <sch:rule id="IRM-ID-00024-R2"
        context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:start">
        <sch:let name="dateList"
                 value="." />
        <sch:extends rule="abs.rule00024" />
    </sch:rule>
    <sch:rule id="IRM-ID-00024-R3"
        context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:end">
        <sch:let name="dateList"
                 value="." />
        <sch:extends rule="abs.rule00024" />
    </sch:rule>
    <sch:rule id="IRM-ID-00024-R4"
        context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//* [@irm:approvedOn | @irm:dateProcessed | @irm:receivedOn | @irm:posted | @irm:created | @irm:infoCutOff | @irm:validTil]">

        <sch:let name="dateList"
                 value=" (@irm:approvedOn, @irm:dateProcessed, @irm:receivedOn, @irm:posted, @irm:created, @irm:infoCutOff, @irm:validTil) " />
        <sch:extends rule="abs.rule00024" />
    </sch:rule>
</sch:pattern>
