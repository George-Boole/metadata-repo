<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="UIAS-ID-00072">
    <sch:p xmlns:ism="urn:us:gov:ic:ism" ism:classification="U" ism:ownerProducer="USA"
        class="ruleText"> [UIAS-ID-00072][Error] The
        saml:Attribute[@Name='region']/saml:AttributeValue element MUST have "ANAN". Human Readable:
        IF the 'Region' attribute is present, the 'ANAN' element MUST be provided. </sch:p>

    <sch:p xmlns:ism="urn:us:gov:ic:ism" ism:classification="U" ism:ownerProducer="USA"
        class="codeDesc"> The saml:Attribute[@Name='region']/saml:AttributeValue element MUST have at
        least 2 values. Human Readable: IF the 'Region' attribute is present, there MUST be at least
        2 values provided.</sch:p>

    <sch:rule id="UIAS-ID-00072-R1" context="saml:Attribute[@Name = 'region']/saml:AttributeValue">

        <sch:let name="valueText" value="normalize-space(.)"/>

        <sch:assert test="contains($valueText, 'ANAN')" flag="error" role="error">
            [UIAS-ID-00072][Error] IF the 'Region' attribute is present, the 'ANAN' element MUST be
            provided. </sch:assert>

        <sch:assert test="count(tokenize($valueText, ' ')) &gt; 1" flag="error" role="error">
            [UIAS-ID-00072][Error] IF the 'Region' attribute is present, there MUST be at least 2
            values provided. </sch:assert>
    </sch:rule>
</sch:pattern>
