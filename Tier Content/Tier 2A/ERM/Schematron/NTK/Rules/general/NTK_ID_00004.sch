<?xml version="1.0" encoding="UTF-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" xmlns:ism="urn:us:gov:ic:ism" id="NTK-ID-00004">
    <sch:p ism:classification="U" ism:ownerProducer="USA" class="ruleText">
        [NTK-ID-00004][Error] Every attribute in the NTK namespace must be
        specified with a non-whitespace value.
    </sch:p>
    
    <sch:p ism:classification="U" ism:ownerProducer="USA" class="codeDesc">
        For each element which specifies an attribute in the NTK namespace, this rule ensures that all attributes in the NTK namespace contain a non-whitespace
        value.
    </sch:p>
    
    <sch:rule context="*[@ntk:*]">
        <sch:assert test="every $attribute in @ntk:* satisfies               normalize-space(string($attribute))"
                  flag="error">
            [NTK-ID-00004][Error] Every attribute in the document must be specified with a non-whitespace value.
        </sch:assert>
    </sch:rule>
</sch:pattern>
