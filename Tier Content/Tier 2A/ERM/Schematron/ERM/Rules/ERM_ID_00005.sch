<?xml version="1.0" encoding="UTF-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="ERM-ID-00005">
    <sch:p class="ruleText">[ERM_ID_00005][Error] The attribute dateApplied must be used if appliedBy is present.</sch:p>
    <sch:p class="codeDesc"> Records identifying the individual that performed disposition of the record require the date of disposition be specified. </sch:p>
    <sch:rule context="erm:*[@erm:appliedBy]">
        <sch:assert flag="error" test="@erm:dateApplied">
            [ERM_ID_00005][Error] The attribute dateApplied must be used if appliedBy is present.
        </sch:assert>
    </sch:rule> 
</sch:pattern>
