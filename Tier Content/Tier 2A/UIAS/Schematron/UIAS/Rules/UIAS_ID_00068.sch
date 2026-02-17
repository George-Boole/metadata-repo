<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="UIAS-ID-00068">
    <sch:p xmlns:ism="urn:us:gov:ic:ism" ism:classification="U" ism:ownerProducer="USA" class="ruleText">
        [UIAS-ID-00068][Error] SCI control values (with at least one or more "-") must have its hierarchical parent value
        (without the last "-xxx") in the same list.
    </sch:p>
    
    <sch:p xmlns:ism="urn:us:gov:ic:ism" ism:classification="U" ism:ownerProducer="USA" class="codeDesc">
        Every SCI token in saml:AttributeValue that has at least one "-" must have its hierarchical parent value which
        is the substring before the last "-" be in the token list.
    </sch:p>
    
    <sch:rule id="UIAS-ID-00068-R1" context="saml:Attribute[@Name='fineAccessControls']">
        <sch:let name="tokenList" value="tokenize(normalize-space(string(./saml:AttributeValue)), ' ')"/>
        <sch:assert test="every $evaluatedToken in $tokenList satisfies 
            if (not(matches($evaluatedToken, 'SAR-')) and not(matches($evaluatedToken, 'NATO-'))
            and matches($evaluatedToken, '-'))
            then util:existInTokenSet(util:substring-before-last($evaluatedToken, '-'), $tokenList)
            else true()" flag="error" role="error">
            [UIAS-ID-00068][Error] SCI control values (with at least one or more "-") must have its hierarchical parent value
            (without the last "-xxx") in the same list.      
            Some token in <sch:value-of select="$tokenList"/> is missing its hierarchical parent value
            (without the last "-xxx").
        </sch:assert>
    </sch:rule>
</sch:pattern>