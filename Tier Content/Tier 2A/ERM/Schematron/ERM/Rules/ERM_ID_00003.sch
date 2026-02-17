<?xml version="1.0" encoding="UTF-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="ERM-ID-00003"> 
    <sch:p class="ruleText"> [ERM_ID_00003][Error] The attribute recordControl must be used if reviewIndicator is [true].</sch:p>
    <sch:p class="codeDesc"> Records having completed a review against the Agency Record Control Schedule require the assigned Agency Record Control Schedule identifier be specified. </sch:p>
    <sch:rule context="erm:*[@erm:reviewIndicator='true']">
        <sch:assert flag="error" test="@erm:recordControl"> 
            [ERM_ID_00003][Error] The attribute recordControl must be used if reviewIndicator is [true]. 
        </sch:assert>
    </sch:rule> 
</sch:pattern>
