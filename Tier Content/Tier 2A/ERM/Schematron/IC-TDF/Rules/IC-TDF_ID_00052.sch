<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="IC-TDF-ID-00052" is-a="CompareVersionsInSkeleton">
    <sch:p class="ruleText">
        [IC-TDF-ID-00052][Error] If there exist multiple version attributes in the 
        same namespace within the TDF skeleton, then they must specify the same version number.
        
        Human Readable: The tdf:version declared for a specification must be the same throughout the IC-TDF
        skeleton including the HandlingAssertions and StatementMetadata within assertions.
    </sch:p>
    <sch:p class="codeDesc">
        This rule uses an abstract pattern to consolidate logic.
        For all tdf:version attributes found on the TDF skeleton, ensure all the versions
        are the same. The TDF Skeleton includes the TDF elements themselves and descendents 
        of tdf:HandlingAssertion or tdf:StatementMetadata elements.
    </sch:p>
    
    <sch:param name="context" value="tdf:*[@tdf:version]          | tdf:HandlingAssertion//*[@tdf:version]          | tdf:StatementMetdata//*[@tdf:version]"/>
    <sch:param name="namespace" value="'urn:us:gov:ic:tdf'"/>
    <sch:param name="attrName" value="'version'"/>
    <sch:param name="ruleID" value="'IC-TDF-ID-00052'"/>
</sch:pattern>