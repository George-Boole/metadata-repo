<?xml version="1.0" encoding="utf-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:ism="urn:us:gov:ic:ism"
             xmlns:sch="http://purl.oclc.org/dsdl/schematron"
             id="IC-EDH-ID-00001">
    <sch:p class="ruleText"
           ism:classification="U"
           ism:ownerProducer="USA">[IC-EDH-ID-00001][Error] Every attribute in the EDH namespace must have a non-whitespace value. Human Readable:
           All attributes in the EDH namespace must specify a value.</sch:p>
    <sch:p class="codeDesc"
           ism:classification="U"
           ism:ownerProducer="USA">Make sure any attribute in the EDH namespace has a value if it is present.</sch:p>
    <sch:rule id="IC-EDH-ID-00001-R1"
              context="*[@edh:*]">
        <sch:assert test="every $attribute in @edh:* satisfies normalize-space(string($attribute))"
                    flag="error"
                    role="error">[IC-EDH-ID-00001][Error] Every attribute in the EDH namespace must have a non-whitespace value. Human Readable: All
                    attributes in the EDH namespace must specify a value.</sch:assert>
    </sch:rule>
</sch:pattern>
