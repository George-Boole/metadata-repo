<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="ISM-ID-00364">
    <sch:p class="ruleText">
        [ISM-ID-00364][Error] If an ISM_USGOV_RESOURCE has a value in @compilationReason and @noAggregation is present,
        @noAggregation must be false.
    </sch:p>
    <sch:p class="codeDesc">
        If an ISM_USGOV_RESOURCE has a value in @compilationReason and @noAggregation is present,
        @noAggregation must be false.
    </sch:p>
    <sch:rule id="ISM-ID-00364-R1" context="*[$ISM_USGOV_RESOURCE and string-length(normalize-space(@ism:compilationReason)) &gt; 0 and string-length(normalize-space(@ism:noAggregation)) &gt; 0]">
        <sch:assert test="@ism:noAggregation = false() " flag="error" role="error">
            [ISM-ID-00364][Error] If an ISM_USGOV_RESOURCE has a value in @compilationReason and @noAggregation is present,
            @noAggregation must be false.
        </sch:assert>
    </sch:rule>
</sch:pattern>