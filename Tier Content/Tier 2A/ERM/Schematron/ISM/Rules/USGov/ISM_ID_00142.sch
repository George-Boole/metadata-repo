<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="ISM-ID-00142">
    <sch:p class="ruleText">[ISM-ID-00142][Error] If the Classified National Security Information
        Executive Order applies to the document, then a classification authority must be
        specified.</sch:p>

    <sch:p class="codeDesc">If ISM_NSI_EO_APPLIES is true (defined in ISM_XML.sch), then the
        resource element (has the attribute @ism:resourceElement="true") must have either
        @ism:classifiedBy or @ism:derivativelyClassifiedBy</sch:p>

    <sch:rule id="ISM-ID-00142-R1" context="*[$ISM_NSI_EO_APPLIES and generate-id(.) = generate-id($ISM_RESOURCE_ELEMENT)]">
        <sch:assert test="@ism:classifiedBy or @ism:derivativelyClassifiedBy" flag="error" role="error">[ISM-ID-00142][Error] If the Classified National Security Information Executive Order
            applies to the document, then a classification authority must be specified.</sch:assert>
    </sch:rule>
</sch:pattern>