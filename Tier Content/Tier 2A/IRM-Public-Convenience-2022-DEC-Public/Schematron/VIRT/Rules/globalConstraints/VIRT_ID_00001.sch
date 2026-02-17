<?xml version="1.0" encoding="UTF-8"?>
<?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:ism="urn:us:gov:ic:ism" xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="VIRT-ID-00001">
    <sch:p class="ruleText" ism:classification="U" ism:ownerProducer="USA">
        [VIRT-ID-00001][Error] Every attribute in the document must be specified with a non-whitespace value.
    </sch:p>
    
    <sch:p class="codeDesc" ism:classification="U" ism:ownerProducer="USA">
        For each element with at least one attribute specified, this rule normalizes the space of 
        the value of each attribute and make sure that the resulting string has a length 
        greater than zero, which indicates non-whitespace content.
    </sch:p>
    
    <sch:rule id="VIRT-ID-00001-R1" context="*">
        <sch:assert test="every $attribute in ./@virt:* satisfies             string-length(normalize-space(string($attribute))) &gt; 0" flag="error" role="error">
            [VIRT-ID-00001][Error] Every attribute in the document must be specified with a non-whitespace value.
        </sch:assert>
    </sch:rule>
</sch:pattern>