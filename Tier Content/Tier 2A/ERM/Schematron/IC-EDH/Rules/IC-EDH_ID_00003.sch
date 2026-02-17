<?xml version="1.0" encoding="UTF-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="IC-EDH-ID-00003">
    <sch:p class="ruleText">
        [IC-EDH-ID-00003][Error] The dataItemCreateDateTime must not be later the
        ism:createDate.
        
        Human Readable: Data items cannot be newer than their security markings.
    </sch:p>
    <sch:p class="codeDesc">
        For EDH element DataItemCreateDateTime, ensure that the sibling ARH element 
        (Security or ExternalSecurity) has ism:createDate that is not older than the
        data item itself. This comparison is done strictly on the date, and to 
        compensate for the loss of using time, the ism:createDate is incremented one
        day and less than, not less than or equal to. 
    </sch:p>
    <sch:rule context="edh:DataItemCreateDateTime[following-sibling::arh:*/@ism:createDate]">
        <sch:assert test="xsd:date(substring-before(xsd:string(.),'T')) &lt; functx:next-day(following-sibling::arh:*/@ism:createDate)"
                  flag="error">
            [IC-EDH-ID-00003][Error] The dataItemCreateDateTime must not be later the
            ism:createDate.
            
            Human Readable: Data items cannot be newer than their security markings.
        </sch:assert>
    </sch:rule>
</sch:pattern>
