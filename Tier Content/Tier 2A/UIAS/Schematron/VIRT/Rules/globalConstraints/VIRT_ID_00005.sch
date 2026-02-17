<?xml version="1.0" encoding="UTF-8"?>
<?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:ism="urn:us:gov:ic:ism" xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="VIRT-ID-00005">
    <sch:p class="ruleText" ism:classification="U" ism:ownerProducer="USA">
        [VIRT-ID-00005][Error] If virt:VirtualCoverage exists, then it must include at least @virt:protocol
        or @virt:address.
    </sch:p>
    
    <sch:p class="codeDesc" ism:classification="U" ism:ownerProducer="USA">
        If virt:VirtualCoverage exists, then it must include at least @virt:protocol or @virt:address.
    </sch:p>
    
    <sch:rule id="VIRT-ID-00005-R1" context="virt:VirtualCoverage">
        <sch:assert test="exists(./@virt:protocol) or exists(./@virt:address)" flag="error" role="error">
            [VIRT-ID-00005][Error] If virt:VirtualCoverage exists, then it must include at least @virt:protocol
            or @virt:address.
        </sch:assert>
    </sch:rule>
</sch:pattern>