<?xml version="1.0" encoding="utf-8"?>
<?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:ism="urn:us:gov:ic:ism"
             xmlns:sch="http://purl.oclc.org/dsdl/schematron"
             id="BASE-TDF-ID-00006">
    <sch:p class="ruleText" ism:ownerProducer="USA" ism:classification="U">[BASE-TDF-ID-00006][Error] If the root element is TrustedDataObject, then it must specify attribute version. Human
           Readable: If TrustedDataObject is the root element, then it must declare a TDF version to which it complies.</sch:p>
    <sch:p class="codeDesc" ism:ownerProducer="USA" ism:classification="U">For a tdf:TrustedDataObject element that is a root element, this rule ensures that it specifies attribute
           tdf:version.</sch:p>
    <sch:rule id="BASE-TDF-ID-00006-R1" context="/tdf:TrustedDataObject">
        <sch:assert test="@tdf:version" flag="error" role="error">[BASE-TDF-ID-00006][Error] If TrustedDataObject is the root element, then it must declare a TDF version to which it
                    complies.</sch:assert>
    </sch:rule>
</sch:pattern>
