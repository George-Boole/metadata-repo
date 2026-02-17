<?xml version="1.0" encoding="utf-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:ism="urn:us:gov:ic:ism"
             xmlns:sch="http://purl.oclc.org/dsdl/schematron"
             id="IRM-ID-00076">
    <sch:p class="ruleText"
           ism:classification="U"
           ism:ownerProducer="USA">[IRM-ID-00076][Error] If the irm:acquiredOn element exists, at least one of its child elements irm:description,
           irm:approximableDate, or irm:searchableDate must be present. Human Readable: The acquiredOn element must have at least one of the
           following child elements: description, approximableDate and searchableDate.</sch:p>
    <sch:p class="codeDesc"
           ism:classification="U"
           ism:ownerProducer="USA">For element irm:acquiredOn, ensure that one or more of the child elements irm:description,
           irm:approximableDate, irm:searchableDate/irm:start, or irm:searchableDate/irm:end is specified with non-whitespace content.</sch:p>
    <sch:rule id="IRM-ID-00076-R1"
      context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:acquiredOn">
        <sch:assert test=" normalize-space(string(irm:description)) or normalize-space(string(irm:approximableDate)) or normalize-space(string(irm:searchableDate/irm:start)) or normalize-space(string(irm:searchableDate/irm:end))"
                    flag="error"
                    role="error">[IRM-ID-00076][Error] If the irm:acquiredOn element exists, at least one of its child elements irm:description,
                    irm:approximableDate, or irm:searchableDate must be present. Human Readable: The acquiredOn element must have at least one of the
                    following child elements: description, approximableDate and searchableDate.</sch:assert>
    </sch:rule>
</sch:pattern>
