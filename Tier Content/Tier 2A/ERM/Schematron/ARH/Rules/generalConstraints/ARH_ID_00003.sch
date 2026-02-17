<?xml version="1.0" encoding="UTF-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="ARH-ID-00003">
    <sch:p class="ruleText">
        [ARH-ID-00003][Error] Every ARH attribute in the document must be
        specified with a non-whitespace value.
        
        Human Readable: All attributes in the ARH namespace must specify a value.
    </sch:p>
    
    <sch:p class="codeDesc">
        For each element which specifies an attribute in the ARH namespace, we
        make sure that all attributes in the ARH namespace contain a non-whitespace
        value.
    </sch:p>
    
    <sch:rule context="*[@arh:*]">
        <sch:assert test="every $attribute in @arh:*  satisfies             string-length(normalize-space(string($attribute))) &gt; 0"
                  flag="error">
            [ARH-ID-00003][Error] Every ARH attribute in the document must be specified with a non-whitespace value.
            
            Human Readable: All attributes in the ARH namespace must specify a value.
        </sch:assert>
    </sch:rule>
</sch:pattern>
