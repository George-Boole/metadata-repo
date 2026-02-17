<?xml version="1.0" encoding="utf-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:ism="urn:us:gov:ic:ism"
             xmlns:sch="http://purl.oclc.org/dsdl/schematron"
             id="IC-EDH-ID-00002">
    <sch:p class="ruleText"
           ism:classification="U"
           ism:ownerProducer="USA">[IC-EDH-ID-00002][Error] The attribute DESVersion in the namespace urn:us:gov:ic:edh must be specified. Human
           Readable: The data encoding specification version number must be specified.</sch:p>
    <sch:p class="codeDesc"
           ism:classification="U"
           ism:ownerProducer="USA">Make sure that the attribute edh:DESVersion is specified.</sch:p>
    <sch:rule id="IC-EDH-ID-00002-R1"
              context="/">
        <sch:assert test="some $element in descendant-or-self::node() satisfies $element/@edh:DESVersion"
                    flag="error"
                    role="error">[IC-EDH-ID-00002][Error] The attribute DESVersion in the namespace urn:us:gov:ic:edh must be specified. Human
                    Readable: The data encoding specification version must be specified.</sch:assert>
    </sch:rule>
</sch:pattern>
