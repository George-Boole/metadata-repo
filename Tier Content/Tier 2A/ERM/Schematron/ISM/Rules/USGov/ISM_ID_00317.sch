<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="ISM-ID-00317">
    <sch:p class="ruleText">
        [ISM-ID-00317][Error] If ISM_USGOV_RESOURCE and attribute declassExemption of ISM_RESOURCE_ELEMENT contains 
        [NATO-AEA] then at least one element meeting ISM_CONTRIBUTES in the document must have a 
        ownerProducer attribute containing [NATO] and one portion containing ism:atomicEnergyMarkings.
        
        Human Readable: USA documents marked with a NATO-AEA declass exemption must have at least one NATO portion 
        and one portion that contains Atomic Energy Markings.
    </sch:p>
    <sch:p class="codeDesc">
      If the document is an ISM_USGOV_RESOURCE, the current element is the
      ISM_RESOURCE_ELEMENT, and attribute ism:declassExemption is specified
      with a value containing the value [NATO-AEA], then this rule ensures that some
      element meeting ISM_CONTRIBUTES specifies attribute ism:ownerProducer
      with a value containing [NATO] and ism:atomicEnergyMarkings.
    </sch:p>
    <sch:rule id="ISM-ID-00317-R1" context="*[$ISM_USGOV_RESOURCE                         and generate-id(.) = generate-id($ISM_RESOURCE_ELEMENT)                         and util:containsAnyOfTheTokens(@ism:declassException, ('NATO-AEA'))]">
        <sch:assert test="util:containsAnyTokenMatching(string-join($partOwnerProducer_tok, ' '), ('NATO:?'))                           and count($partAtomicEnergyMarkings_tok)&gt;0" flag="error" role="error">
            [ISM-ID-00317][Error] USA documents marked with a NATO-AEA declass exemption must have at least one NATO portion 
            and one portion that contains Atomic Energy Markings.
        </sch:assert>
    </sch:rule>
</sch:pattern>