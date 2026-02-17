<?xml version="1.0" encoding="utf-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:ism="urn:us:gov:ic:ism"
             xmlns:sch="http://purl.oclc.org/dsdl/schematron"
             id="IC-TDF-ID-00046"
             is-a="CompareVersionsInSkeleton">
    <sch:p class="ruleText"
           ism:ownerProducer="USA"
           ism:classification="U">[IC-TDF-ID-00046][Error] If there exist multiple version attributes in the same namespace within the TDF skeleton,
           then they must specify the same version number. Human Readable: The ism:DESVersion declared for a specification must be the same
           throughout the IC-TDF skeleton including the HandlingAssertions and StatementMetadata within assertions.</sch:p>
    <sch:p class="codeDesc"
           ism:ownerProducer="USA"
           ism:classification="U">This rule uses an abstract pattern to consolidate logic. For all ism:DESVersion attributes found on the TDF
           skeleton, ensure all the versions are the same. The TDF Skeleton includes the TDF elements themselves and descendents of
           tdf:HandlingAssertion or tdf:StatementMetadata elements.</sch:p>
    <sch:param name="context"
               value="//tdf:*[@ism:DESVersion] | //tdf:HandlingAssertion//*[@ism:DESVersion] | //tdf:StatementMetdata//*[@ism:DESVersion]" />
    <sch:param name="namespace"
               value="'urn:us:gov:ic:ism'" />
    <sch:param name="attrName"
               value="'DESVersion'" />
    <sch:param name="ruleID"
               value="'IC-TDF-ID-00046'" />
</sch:pattern>
