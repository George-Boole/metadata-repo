<?xml version="1.0" encoding="UTF-8"?>
<?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:ism="urn:us:gov:ic:ism" xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="VIRT-ID-00004">
    <sch:p class="ruleText" ism:classification="U" ism:ownerProducer="USA">
        [VIRT-ID-00004][Error] If there exists VIRT elements and/or attributes in a document, then a VIRT DESVersion 
        attribute must be declared in the document as well.
    </sch:p>
    
    <sch:p class="codeDesc" ism:classification="U" ism:ownerProducer="USA">
        In a document, if elements or attributes with the VIRT namespace exists, then the VIRT DESVersion attribute must exist.
    </sch:p>
    
    <sch:rule id="VIRT-ID-00004-R1" context="/">
        <sch:assert test="if (.//virt:* or .//*[@virt:*]) then exists(.//@virt:DESVersion) else true() " flag="error" role="error">
            [VIRT-ID-00004][Error] If there exists VIRT elements and/or attributes in a document, then a VIRT DESVersion 
            attribute must be declared in the document as well.
        </sch:assert>
    </sch:rule>
</sch:pattern>