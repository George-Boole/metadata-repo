<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="ISM-ID-00309">
    <sch:p class="ruleText">
        [ISM-ID-00309][Error] If ISM_USGOV_RESOURCE and attribute SCIcontrols contains a token matching [TK-KAND-XXXXXX],
        where X is represented by the regular expression character class [A-Z]{1,6}, then it must also contain the
        name token [TK-KAND].
        
        Human Readable: A USA document that contains TALENT KEYHOLE (TK) KANDIK sub-compartments must
        also specify that it contains TK -KANDIK compartment data.
    </sch:p>
    <sch:p class="codeDesc">
        If the document is an ISM_USGOV_RESOURCE, for each element which
        specifies attribute ism:SCIcontrols with a value containing a token
        matching [TK-KAND-XXXXXX], where X is represented by the regular expression
        character class [A-Z]{1,6}, then this rule ensures that attribute ism:SCIcontrols is 
        specified with a value containing the token [TK-KAND].
    </sch:p>
    <sch:rule id="ISM-ID-00309-R1" context="*[$ISM_USGOV_RESOURCE         and util:containsAnyTokenMatching(@ism:SCIcontrols, ('^TK-KAND-[A-Z]{1,6}$'))]">
        <sch:assert test="util:containsAnyOfTheTokens(@ism:SCIcontrols, ('TK-KAND'))" flag="error" role="error">
            [ISM-ID-00309][Error] If ISM_USGOV_RESOURCE and attribute SCIcontrols contains a token matching [TK-KAND-XXXXXX],
            where X is represented by the regular expression character class [A-Z]{1,6}, then it must also contain the
            name token [TK-KAND].
            
            Human Readable: A USA document that contains TALENT KEYHOLE (TK) KANDIK sub-compartments must
            also specify that it contains TK -KANDIK compartment data.
        </sch:assert>
    </sch:rule>
</sch:pattern>