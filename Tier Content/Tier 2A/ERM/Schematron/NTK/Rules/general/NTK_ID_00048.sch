<?xml version="1.0" encoding="UTF-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" xmlns:ism="urn:us:gov:ic:ism" id="NTK-ID-00048">
    <sch:p ism:classification="U" ism:ownerProducer="USA" class="ruleText">
        [NTK-ID-00048][Error] ntk:AccessPolicy, ntk:ProfileDes, and ntk:AccessProfileValue are required to have text content.
    </sch:p>
    
    <sch:p ism:classification="U" ism:ownerProducer="USA" class="codeDesc">
        ntk:AccessPolicy, ntk:ProfileDes, and ntk:AccessProfileValue are required to have text content.
    </sch:p>
    
    <sch:rule context="ntk:AccessPolicy | ntk:ProfileDes | ntk:AccessProfileValue">
        <sch:assert test="not(empty(text()))"
                  flag="error">
            [NTK-ID-00048][Error] ntk:AccessPolicy, ntk:ProfileDes, and ntk:AccessProfileValue are required to have text content.
        </sch:assert>
    </sch:rule>
</sch:pattern>
