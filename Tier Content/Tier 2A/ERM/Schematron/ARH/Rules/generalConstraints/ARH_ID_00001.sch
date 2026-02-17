<?xml version="1.0" encoding="UTF-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="ARH-ID-00001">
    <sch:p class="ruleText">
        [ARH-ID-00001][Error] The ARH elements cannot be used as root elements.
        
        Human Readable: ARH is not designed to stand-alone and therefore should never
        be used as a root element.
    </sch:p>
    <sch:p class="codeDesc">
        We make sure that ARH:Security or ARH:ExternalSecurity are not used as the root element.
    </sch:p>
    <sch:rule context="/arh:*">
        <sch:assert test="false()" flag="error">
            [ARH-ID-00001][Error] The ARH elements cannot be used as root elements.
            
            Human Readable: ARH is not designed to stand-alone and therefore should never
            be used as a root element.
        </sch:assert>
    </sch:rule>
</sch:pattern>
