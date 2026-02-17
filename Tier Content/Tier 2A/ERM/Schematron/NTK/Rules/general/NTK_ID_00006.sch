<?xml version="1.0" encoding="UTF-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" xmlns:ism="urn:us:gov:ic:ism" id="NTK-ID-00006">
    <sch:p ism:classification="U" ism:ownerProducer="USA" class="ruleText">
        [NTK-ID-00006][Error]The attribute 
        DESVersion in the namespace urn:us:gov:ic:ntk must be specified.
        
        Human Readable: The data encoding specification version must
        be specified.
    </sch:p>
    
    <sch:p ism:classification="U" ism:ownerProducer="USA" class="codeDesc">
        Make sure that the attribute ntk:DESVersion is specified.
    </sch:p>
    
    <sch:rule context="/*[descendant-or-self::ntk:* or descendant-or-self::*/@ntk:*]">
        <sch:assert test="some $element in descendant-or-self::node() satisfies $element/@ntk:DESVersion"
                  flag="error">
            [NTK-ID-00006][Error] The attribute 
            DESVersion in the namespace urn:us:gov:ic:ntk must be specified.
            
            Human Readable: The data encoding specification version must 
            be specified.
        </sch:assert>
    </sch:rule>
</sch:pattern>
