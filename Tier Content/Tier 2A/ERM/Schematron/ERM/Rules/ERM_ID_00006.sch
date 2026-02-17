<?xml version="1.0" encoding="UTF-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="ERM-ID-00006">
    <sch:p class="ruleText">[ERM_ID_00006][Error] The attribute appliedBy must be used if dateApplied is present.</sch:p>
    <sch:p class="codeDesc">Records identifying the date of disposition of the record require the individual that performed disposition be specified. </sch:p>
    <sch:rule context="erm:*[@erm:dateApplied]">
        <sch:assert flag="error" test="@erm:appliedBy">
            [ERM_ID_00006][Error] The attribute appliedBy must be used if dateApplied is present.
        </sch:assert>
    </sch:rule> 
</sch:pattern> 