<?xml version="1.0" encoding="utf-8"?>
<?ICEA pattern?>
<?ICEA min_accessible?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:ism="urn:us:gov:ic:ism"
             xmlns:sch="http://purl.oclc.org/dsdl/schematron"
             id="IRM-ID-00062"
             is-a="ICIdentifierRestrictions">
    <sch:p class="ruleText"
           ism:classification="U"
           ism:ownerProducer="USA">[IRM-ID-00062][Error] The value of an IC-ID identifier must follow standardized convention. Human Readable: The
           IC-ID identifier value has to follow standardized convention.</sch:p>
    <sch:p class="codeDesc"
           ism:classification="U"
           ism:ownerProducer="USA">This rule uses an abstract pattern that contains the logic for ensuring the value found if a given context exists,
           both provided as parameters from this implementation, follows the IC-ID identifier standardized convention.</sch:p>
    <sch:param name="context"
           value="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:identifier[@irm:qualifier='IC-ID']" />
    <sch:param name="value"
               value="string(@irm:value)" />
    <sch:param name="errorMessage"
               value="'[IRM-ID-00062][Error] The value of an IC-ID identifier must follow standardized convention. Human Readable: The IC-ID identifier value has to follow standardized convention.'" />
</sch:pattern>
