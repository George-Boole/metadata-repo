<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="UIAS-ID-00053">
    <sch:p xmlns:ism="urn:us:gov:ic:ism" ism:classification="U" ism:ownerProducer="USA" class="ruleText"> 
        [UIAS-ID-00053][Error] The RoleOrg value of the C2S &amp; PAAS role taxonomy appended with the prefix "USA." 
        MUST be a value found in CVEnumUSAgencyAcronym.xml. </sch:p>
    <sch:p xmlns:ism="urn:us:gov:ic:ism" ism:classification="U" ism:ownerProducer="USA" class="codeDesc"> 
        Tokenize on space to get all the roles for each role tokenize on - to get the parts, 
        verify the 1st part is C2S or PAAS if so verify the 2nd part appended with "USA." prefix is in USAgency.</sch:p>
    <sch:rule id="UIAS-ID-00053-R1" context="saml:Attribute[@Name = 'role']">
        <sch:assert test="every $token in tokenize(normalize-space(string(saml:AttributeValue[1])), ' ')              
            satisfies (not(tokenize(string($token), '-')[1]='C2S') and not(tokenize(string($token), '-')[1]='PAAS') ) 
            or
            (every $C2SorPAAStoken in tokenize(string($token), '-')[2] satisfies 
                concat('USA.', $C2SorPAAStoken) = $usAgencyList 
                or (some $item in $usAgencyList satisfies (matches(normalize-space(concat('USA.', $C2SorPAAStoken)), concat('^',$item,'$')))))" flag="error" role="error"> 
            [UIAS-ID-00053][Error] The RoleOrg value of the C2S &amp; PAAS role taxonomy appended with the prefix "USA." 
            MUST be a value found in CVEnumUSAgencyAcronym.xml. </sch:assert>
    </sch:rule>
</sch:pattern>