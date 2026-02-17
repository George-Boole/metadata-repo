<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="ISM-ID-00226">
    
    <sch:p class="ruleText">
        [ISM-ID-00226][Error] Attributes @ism:noticeType and @ism:unregisteredNoticeType
        may not both be used on the same element. 
        
        Human Readable: Ensure that the ISM attributes noticeType and
        unregisteredNoticeType are not used on the same element.
    </sch:p>
    <sch:p class="codeDesc">
        For each element which has attribute ism:noticeType specified, this rule ensures that ism:unregisteredNoticeType is not specified. 
    </sch:p>

    <sch:rule id="ISM-ID-00226-R1" context="*[@ism:noticeType]">
        <sch:assert flag="error" test="not(@ism:unregisteredNoticeType)" role="error">
            [ISM-ID-00226][Error]
            @ism:noticeType and @ism:unregisteredNoticeType may not both be 
            applied to the same element.
            
            Human Readable: The ISM attributes noticeType and unregisteredNoticeType 
            are mutually exclusive and cannot both be applied to the same element. 
        </sch:assert>
    </sch:rule>
</sch:pattern>