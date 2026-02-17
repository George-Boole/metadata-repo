<?xml version="1.0" encoding="utf-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:ism="urn:us:gov:ic:ism"
             xmlns:sch="http://purl.oclc.org/dsdl/schematron"
             id="IC-EDH-ID-00013">
    <sch:p class="ruleText"
           ism:classification="U"
           ism:ownerProducer="USA">[IC-EDH-ID-00013][Error] Element edh:DataItemCreateDateTime of type xs:dateTime must have a timezone. Human
           Readable: The EDH element DataItemCreateDateTime must have a timezone.</sch:p>
    <sch:p class="codeDesc"
           ism:classification="U"
           ism:ownerProducer="USA">The EDH element edh:DataItemCreateDateTime must have a timezone. According to
           http://www.w3.org/TR/xmlschema-2/#dateTime, datetime is represented by: '-'? yyyy '-' mm '-' dd 'T' hh ':' mm ':' ss ('.' s+)? (zzzzzz)?
           where the timezone zzzzzz is represented by: (('+' | '-') hh ':' mm) | 'Z' This rule enforces and makes the timezone zzzzzz
           mandatory.</sch:p>
    <sch:rule id="IC-EDH-ID-00013-R1"
              context="edh:DataItemCreateDateTime">
        <sch:assert test="matches(., '^-?\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(\.\d+)?(((\+|-)\d{2}:\d{2})|Z)$')"
                    flag="error"
                    role="error">[IC-EDH-ID-00013][Error] edh:DataItemCreateDateTime of type xs:dateTime must have a timezone. Human Readable: The
                    EDH element DataItemCreateDateTime must have a timezone.</sch:assert>
    </sch:rule>
</sch:pattern>
