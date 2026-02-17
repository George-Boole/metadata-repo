<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="ISM-ID-00323">
    <sch:p class="ruleText">
        [ISM-ID-00323][Error] The attribute 
        ISMCATCESVersion in the namespace urn:us:gov:ic:ism must be specified.
        
        Human Readable: The CVE encoding specification version for ISM CAT must
        be specified.
    </sch:p>
    <sch:p class="codeDesc">
        This rule ensures that the attribute ism:ISMCATCESVersion 
        is specified.
    </sch:p>
    <sch:rule id="ISM-ID-00323-R1" context="/">
        <sch:assert test="some $element in descendant-or-self::node() satisfies $element/@ism:ISMCATCESVersion" flag="error" role="error">
            [ISM-ID-00323][Error] The attribute 
            ISMCATCESVersion in the namespace urn:us:gov:ic:ism must be specified.
            
            Human Readable: The CVE encoding specification version for ISM CAT must
            be specified.
        </sch:assert>
    </sch:rule>
</sch:pattern>