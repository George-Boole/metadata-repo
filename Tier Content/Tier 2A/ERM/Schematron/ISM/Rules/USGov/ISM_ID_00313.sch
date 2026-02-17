<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="ISM-ID-00313">
    <sch:p class="ruleText">
        [ISM-ID-00313][Error] If nonICmarkings contains the token [ND] then the 
        attribute disseminationControls must contain [NF].
        
        Human Readable: NODIS data must be marked NOFORN.
    </sch:p>
    <sch:p class="codeDesc">
        If the nonICmarkings contains the ND token, then check that the disseminationControls
        attribute must have NF specified.
    </sch:p>
    <sch:rule id="ISM-ID-00313-R1" context="*[util:containsAnyOfTheTokens(@ism:nonICmarkings, ('ND'))]">
        <sch:assert test="util:containsAnyOfTheTokens(@ism:disseminationControls, ('NF'))" flag="error" role="error">
            [ISM-ID-00313][Error] If nonICmarkings contains the token [ND] then the 
            attribute disseminationControls must contain [NF].
            
            Human Readable: NODIS data must be marked NOFORN.
        </sch:assert>
    </sch:rule>
</sch:pattern>