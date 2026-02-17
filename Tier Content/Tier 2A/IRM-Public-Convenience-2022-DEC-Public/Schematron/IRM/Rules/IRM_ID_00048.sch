<?xml version="1.0" encoding="utf-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:ism="urn:us:gov:ic:ism"
             xmlns:sch="http://purl.oclc.org/dsdl/schematron"
             is-a="ValidateValueExistenceInList"
             id="IRM-ID-00048">
    <sch:p class="ruleText"
           ism:classification="U"
           ism:ownerProducer="USA">[IRM-ID-00048][Error] If element irm:type has attribute @irm:qualifier specified as
           [urn:us:gov:ic:cvenum:intdis:inteldiscipline] the attribute @irm:value must be in CVEnumIntelDiscipline.xml. Human Readable: Intel
           Disciplines must be in the CVEnumIntelDiscipline CVE.</sch:p>
    <sch:p class="codeDesc"
           ism:classification="U"
           ism:ownerProducer="USA">This rule uses an abstract pattern to consolidate logic. It checks that the value in parameter $searchTerm is
           contained in the parameter $list. The parameter $searchTerm is relative in scope to the parameter $context. The value for the parameter
           $list is a variable defined in the main document (IRM_XML.sch), which reads values from a specific CVE file.</sch:p>
    <sch:param name="ruleText"
               value="' [IRM-ID-00048][Error] If element irm:type has attribute @irm:qualifier specified as [urn:us:gov:ic:cvenum:intdis:inteldiscipline] the attribute @irm:value must be in CVEnumIntelDiscipline.xml. Human Readable: Intel Disciplines must be in the CVEnumIntelDiscipline CVE. '" />
    <sch:param name="codeDesc"
               value="' This rule uses an abstract pattern to consolidate logic. It checks that the value in parameter $searchTerm is contained in the parameter $list. The parameter $searchTerm is relative in scope to the parameter $context. The value for the parameter $list is a variable defined in the main document (IRM_XML.sch), which reads values from a specific CVE file. '" />
    <sch:param name="context"
           value="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:type[@irm:qualifier='urn:us:gov:ic:cvenum:intdis:inteldiscipline']" />
    <sch:param name="searchTerm"
               value="@irm:value" />
    <sch:param name="list"
               value="$intelDisciplineList" />
    <sch:param name="errMsg"
               value="' [IRM-ID-00048][Error] If element irm:type has attribute @irm:qualifier specified as [urn:us:gov:ic:cvenum:intdis:inteldiscipline] the attribute @irm:value must be in CVEnumIntelDiscipline.xml. Human Readable: Intel Disciplines must be in the CVEnumIntelDiscipline CVE. '" />
</sch:pattern>
