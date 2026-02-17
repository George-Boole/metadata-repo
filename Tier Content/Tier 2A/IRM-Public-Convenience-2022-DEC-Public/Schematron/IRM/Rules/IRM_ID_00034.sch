<?xml version="1.0" encoding="utf-8"?>
<sch:pattern xmlns:ism="urn:us:gov:ic:ism"
             xmlns:sch="http://purl.oclc.org/dsdl/schematron"
             id="IRM-ID-00034"
             is-a="ValidateValueExistenceInList">
    <sch:p class="ruleText"
           ism:classification="U"
           ism:ownerProducer="USA">[IRM-ID-00034][Error] For element irm:language, attribute irm:qualifier must have a value in
           CVEnumIRMCompoundLanguageQualifierType.xml. Human Readable: If a qualifier is specified for a language, it must appear in the
           CompoundLanguageQualifierType CVE.</sch:p>
    <sch:p class="codeDesc"
           ism:classification="U"
           ism:ownerProducer="USA">This rule uses an abstract pattern to consolidate logic. It checks that the value in parameter $searchTerm is
           contained in the parameter $list. The parameter $searchTerm is relative in scope to the parameter $context. The value for the parameter
           $list is a variable defined in the main document (IRM_XML.sch), which reads values from a specific CVE file.</sch:p>
    <sch:param name="ruleText"
               value="' [IRM-ID-00034][Error] For element irm:language, attribute irm:qualifier must have a value in CVEnumIRMCompoundLanguageQualifierType.xml. '" />
    <sch:param name="codeDesc"
               value="' This rule uses an abstract pattern to consolidate logic. It checks that the value in parameter $searchTerm is contained in the parameter $list. The parameter $searchTerm is relative in scope to the parameter $context. The value for the parameter $list is a variable defined in the main document (IRM_XML.sch), which reads values from a specific CVE file. '" />
    <sch:param name="context"
           value="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage[$IC_COMPLIANCE]//irm:language" />
    <sch:param name="searchTerm"
               value="@irm:qualifier" />
    <sch:param name="list"
               value="$compoundLanguageQualifierTypeList" />
    <sch:param name="errMsg"
               value="' [IRM-ID-00034][Error] For element irm:language, attribute irm:qualifier must have a value in CVEnumIRMCompoundLanguageQualifierType.xml. '" />
</sch:pattern>
