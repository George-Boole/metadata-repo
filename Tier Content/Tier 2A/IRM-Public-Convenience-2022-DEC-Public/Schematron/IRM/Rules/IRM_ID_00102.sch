<?xml version="1.0" encoding="utf-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:ism="urn:us:gov:ic:ism"
             xmlns:sch="http://purl.oclc.org/dsdl/schematron"
             id="IRM-ID-00102">
    <sch:p class="ruleText"
           ism:classification="U"
           ism:ownerProducer="USA">[IRM-ID-00102][Error] If element irm:organization has attribute @irm:acronym specified, 
           then the country value must be defined by the GENC CES. Human Readable: Utilized agency acronyms
           country component must have the country defined in the GENC CES.</sch:p>
    <sch:p class="codeDesc"
           ism:classification="U"
           ism:ownerProducer="USA">For irm:organization with @irm:acronym specified, if @irm:acronym contains a country component which is not 'USA',
           then the country value must be defined by the GENC CES.</sch:p>
    <sch:rule id="IRM-ID-00102-R1"
      context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage[$IC_COMPLIANCE]//irm:organization[@irm:acronym]">
              
        <sch:let name="CC"
                 value="tokenize(normalize-space(@irm:acronym),'\.')[1]" />
        <sch:assert test="some $token in $gencCountryCodeList satisfies $token = normalize-space($CC)"
                    flag="error"
                    role="error">[IRM-ID-00102][Error] If element irm:organization has attribute @irm:acronym specified,
          then the country value must be defined by the GENC CES. Found <sch:value-of select="./@irm:acronym"/> </sch:assert>
    </sch:rule>
</sch:pattern>
