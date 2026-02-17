<?xml version="1.0" encoding="utf-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:ism="urn:us:gov:ic:ism"
             xmlns:sch="http://purl.oclc.org/dsdl/schematron"
             id="IRM-ID-00101">
    <sch:p class="ruleText"
           ism:classification="U"
           ism:ownerProducer="USA">[IRM-ID-00101][Error] If element irm:organization has attribute @irm:acronym specified and the acronym begins with
           "USA.", then the organization value must be defined by the USAgency CES. Human Readable: Utilized agency acronyms beginning with "USA."
           must be defined in the USAgency CES.</sch:p>
    <sch:p class="codeDesc"
           ism:classification="U"
           ism:ownerProducer="USA">For irm:organization with @irm:acronym specified, if @irm:acronym begins with 'USA.', then the country value must
           be defined by the USAgency CES.</sch:p>
    <sch:rule id="IRM-ID-00101-R1"
      context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage[$IC_COMPLIANCE]//irm:organization[@irm:acronym]">
              
        <sch:assert test="if (starts-with(normalize-space(@irm:acronym),'USA.')) then (some $token in $USAgencyAcronymList satisfies $token = normalize-space( @irm:acronym )) else true()"
                    flag="error"
                    role="error">[IRM-ID-00101][Error] If element irm:organization has attribute @irm:acronym specified and the acronym begins with
          "USA.", then the organization value must be defined by the USAgency CES. Found <sch:value-of select="normalize-space( @irm:acronym )"/> </sch:assert>
    </sch:rule>
</sch:pattern>
