<?xml version="1.0" encoding="UTF-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="IC-EDH-ID-00004">
    <sch:p class="ruleText">
        [IC-EDH-ID-00004][Error] The EDH elements cannot be used as root elements.
        
        Human Readable: EDH is not designed to stand-alone and therefore should never
        be used as a root element.
    </sch:p>
    <sch:p class="codeDesc">
        This rule is to ensure edh:Edh or edh:ExternalEdh are not used as the root element.
    </sch:p>
    <sch:rule context="/edh:*">
        <sch:assert test="false()" flag="error">
            [IC-EDH-ID-00004][Error] The EDH elements cannot be used as root elements.
            
            Human Readable: EDH is not designed to stand-alone and therefore should never
            be used as a root element.
        </sch:assert>
    </sch:rule>
</sch:pattern>
