<?xml version="1.0" encoding="UTF-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="ERM-ID-00004">
    <sch:p class="ruleText"> [ERM_ID_00004][Error] The attribute dateEligible must be present if reviewIndicator is [true]. </sch:p>
    <sch:p class="codeDesc"> Records having completed a review against the Agency Record Control Schedule require the date the record is eligible for disposition. </sch:p>
    <sch:rule context="erm:*[@erm:reviewIndicator='true']">
        <sch:assert flag="error" test="@erm:dateEligible">
            [ERM_ID_00004][Error] The attribute dateEligible must be present if reviewIndicator is [true].
        </sch:assert>
    </sch:rule> 
</sch:pattern>
