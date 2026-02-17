<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="ISM-ID-00163">
    <sch:p class="ruleText">
        [ISM-ID-00163][Error] If attribute nonUSControls exists either 
        1. the attribute ownerProducer must equal [NATO] or a [NATO:NAC] 
            OR 
        2. the attribute FGIsourceOpen must contain [NATO] or a [NATO:NAC]
            OR
        3. the attribute FGIsourceProtected is used (This should only be the case when it is a resource level or super portion marking)
        
        Human Readable: NATO and NATO/NACs are the only owner of classification markings
        for which nonUSControls are currently authorized.
    </sch:p>
    <sch:p class="codeDesc">
        For each element which specifies attribute ism:nonUSControls, this rule ensures that either the attributes ism:ownerProducer or ism:FGIsourceOpen are specified with a value of [NATO] or [NATO:NAC]
        OR the ism:FGIsourceProtected attribute is specified. </sch:p>
    <sch:p class="codeDesc">        
        NOTE: The last case with FGIsourceProtected should only occur when the element is either a resource node or 
        is a super-portion such as the marking of a table where the table contains one or more portions meeting 1 or 2 from the rule description 
        AND one or more portions with the FGIsourceProtected specified.
    </sch:p>
    <sch:rule id="ISM-ID-00163-R1" context="*[@ism:nonUSControls]">
        <sch:assert test="(matches(normalize-space(string(@ism:ownerProducer)), '^NATO:?') or matches(normalize-space(string(@ism:FGIsourceOpen)), 'NATO:?')) or @ism:FGIsourceProtected" flag="error" role="error">
        	[ISM-ID-00163][Error] If attribute nonUSControls exists the attribute 
        	ownerProducer must equal [NATO].
        	
        	Human Readable: NATO and NATO/NACs are the only owner of classification markings
        	for which nonUSControls are currently authorized.
        </sch:assert>
    </sch:rule>
</sch:pattern>