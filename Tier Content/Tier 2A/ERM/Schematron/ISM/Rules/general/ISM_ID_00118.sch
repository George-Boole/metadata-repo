<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="ISM-ID-00118">
    <sch:p class="ruleText">
        [ISM-ID-00118][Error] The first element in document order having 
        resourceElement true must have createDate specified.
    </sch:p>
    <sch:p class="codeDesc">
        This rule ensures that the resourceElement has attribute createDate specified.
    </sch:p>
    <sch:rule id="ISM-ID-00118-R1" context="*[generate-id(.) = generate-id($ISM_RESOURCE_ELEMENT)][1]">
        <sch:assert test="@ism:createDate" flag="error" role="error">
            [ISM-ID-00118][Error] The first element in document order having 
            resourceElement true must have createDate specified.
        </sch:assert>
    </sch:rule>
</sch:pattern>