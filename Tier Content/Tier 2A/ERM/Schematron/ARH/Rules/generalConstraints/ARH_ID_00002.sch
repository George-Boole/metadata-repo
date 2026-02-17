<?xml version="1.0" encoding="UTF-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="ARH-ID-00002">
    <sch:p class="ruleText">
        [ARH-ID-00002][Error] The attribute 
        DESVersion in the namespace urn:us:gov:ic:arh must be specified.
        
        Human Readable: The data encoding specification version number must
        be specified.
    </sch:p>
    <sch:p class="codeDesc">
        Make sure that the attribute arh:DESVersion 
        is specified.
    </sch:p>
    <sch:rule context="/">
        <sch:assert test="some $element in descendant-or-self::node() satisfies $element/@arh:DESVersion"
                  flag="error">
            [ARH-ID-00002][Error] The attribute 
            DESVersion in the namespace urn:us:gov:ic:arh must be specified.
            
            Human Readable: The data encoding specification version must 
            be specified.
        </sch:assert>
    </sch:rule>
</sch:pattern>
