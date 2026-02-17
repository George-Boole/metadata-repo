<?xml version="1.0" encoding="UTF-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" xmlns:ism="urn:us:gov:ic:ism" id="NTK-ID-00002">
    <sch:p ism:classification="U" ism:ownerProducer="USA" class="ruleText">
        [NTK-ID-00002][Error]
        ntk:RequiresAnyOf and ntk:RequiresAllOf must contain ntk:AccessProfileList.
        
        Human Readable: ntk:RequiresAnyOf and ntk:RequiresAllOf must have the child element ntk:AccessProfileList.
    </sch:p>
    
    <sch:p ism:classification="U" ism:ownerProducer="USA" class="codeDesc">
        This rule ensures that ntk:AccessProfileList exist as a child element of ntk:RequiresAnyOf and 
        ntk:RequiresAllOf.
    </sch:p>
    
    <sch:rule context="ntk:RequiresAnyOf|ntk:RequiresAllOf">
        <sch:assert test="ntk:AccessProfileList"
                  flag="error">
            [NTK-ID-00002][Error]
            ntk:RequiresAnyOf and ntk:RequiresAllOf must contain ntk:AccessProfileList.
            
            Human Readable: ntk:RequiresAnyOf and ntk:RequiresAllOf must have the child element ntk:AccessProfileList.
        </sch:assert>
    </sch:rule>
</sch:pattern>
