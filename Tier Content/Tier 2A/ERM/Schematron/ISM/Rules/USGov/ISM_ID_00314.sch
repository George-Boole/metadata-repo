<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="ISM-ID-00314">
    <sch:p class="ruleText">
        [ISM-ID-00314][Error] If nonICmarkings contains the token [XD] then the 
        attribute disseminationControls must contain [NF].
        
        Human Readable: EXDIS data must be marked NOFORN.
    </sch:p>
    <sch:p class="codeDesc">
        If the nonICmarkings contains the ND token, then check that the disseminationControls
        attribute must have NF specified.
    </sch:p>
    <sch:rule id="ISM-ID-00314-R1" context="*[util:containsAnyOfTheTokens(@ism:nonICmarkings, ('XD'))]">
        <sch:assert test="util:containsAnyOfTheTokens(@ism:disseminationControls, ('NF'))" flag="error" role="error">
            [ISM-ID-00314][Error] If nonICmarkings contains the token [XD] then the 
            attribute disseminationControls must contain [NF].
            
            Human Readable: EXDIS data must be marked NOFORN.
        </sch:assert>
    </sch:rule>
</sch:pattern>