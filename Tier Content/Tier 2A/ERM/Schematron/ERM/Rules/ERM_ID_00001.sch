<?xml version="1.0" encoding="UTF-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="ERM-ID-00001"> 
    <sch:p class="ruleText"> [ERM_ID_00001][Error] All attributes in the ERM namespace MUST contain a non-whitespace value. 
    </sch:p> 
    <sch:p class="codeDesc"> Make sure any attribute in the ERM namespace has a value if it is present. 
    </sch:p>
    <sch:rule context="*[@erm:*]">         
        <sch:assert flag="error" test="every $attribute in @erm:* satisfies normalize-space(string($attribute))"> 
            [ERM_ID_00001][Error] All attributes in the ERM namespace MUST contain a non-whitespace value. 
        </sch:assert>
    </sch:rule> 
</sch:pattern>
