<?xml version="1.0" encoding="UTF-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" xmlns:ism="urn:us:gov:ic:ism" id="NTK-ID-00007">
    <sch:p ism:classification="U" ism:ownerProducer="USA" class="ruleText">
        [NTK-ID-00007][Error] The attribute @ntk:externalReference must be set to 
        true when the ExternalAccess element is used.
        
        Human Readable: If the ExternalAccess element is used, then the attribute @ntk:externalReference must have a value of true.
    </sch:p>
    
    <sch:p ism:classification="U" ism:ownerProducer="USA" class="codeDesc">
        Make sure the externalReference attribute is specified with a value of
        true when the ExternalAccess element is used.
    </sch:p>
    
    <sch:rule context="ntk:ExternalAccess">
        <sch:assert test="@ntk:externalReference=true()" flag="error">
            [NTK-ID-00007][Error] The attribute @ntk:externalReference must be set to 
            true when the ExternalAccess element is used.
            
            Human Readable: If the ExternalAccess element is used, then the attribute @ntk:externalReference must have a value of true.
        </sch:assert>
    </sch:rule>
</sch:pattern>
