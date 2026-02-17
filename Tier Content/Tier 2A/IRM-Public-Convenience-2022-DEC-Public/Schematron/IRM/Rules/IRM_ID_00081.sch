<?xml version="1.0" encoding="utf-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:ism="urn:us:gov:ic:ism" xmlns:sch="http://purl.oclc.org/dsdl/schematron"
    id="IRM-ID-00081">
    <sch:p class="ruleText" ism:classification="U" ism:ownerProducer="USA">[IRM-ID-00081][Error] A
        irm:type element with @irm:qualifer ProductLine or Intel must not contain any text. Human
        Readable: IRM Types of ProductLine or Intel must not contain any text within the
        element.</sch:p>
    <sch:p class="codeDesc" ism:classification="U" ism:ownerProducer="USA">For all irm:type elements
        that contain a @irm:qualifier of urn:us:gov:ic:irm:productline or that start with
        urn:us:gov:ic:cvenum:intdis, verify that the element does not contain any text.</sch:p>
    <sch:rule id="IRM-ID-00081-R1"
        context="irm:type[$IC_COMPLIANCE][@irm:qualifier = 'urn:us:gov:ic:irm:productline'] | irm:type[$IC_COMPLIANCE][contains(@irm:qualifier, 'urn:us:gov:ic:cvenum:intdis')]">
        <sch:assert test="not(normalize-space(text()))" flag="error" role="error"
            >[IRM-ID-00081][Error] A irm:type element with @irm:qualifer ProductLine or Intel must
            not contain any text. Human Readable: IRM Types of ProductLine or Intel must not
            contain any text within the element.</sch:assert>
    </sch:rule>
</sch:pattern>
