<?xml version="1.0" encoding="utf-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:ism="urn:us:gov:ic:ism"
             xmlns:sch="http://purl.oclc.org/dsdl/schematron"
             id="IRM-ID-00007"
             is-a="ValidateValueExistenceInList">
    <sch:p class="ruleText"
           ism:classification="U"
           ism:ownerProducer="USA">[IRM-ID-00007][Error] If element irm:language has the attribute @irm:qualifier value of
           [urn:us:gov:ic:cvenum:irm:iso639-3:trigraph] then the value of attribute @irm:value must be in CVEnumIRMISO639-3Trigraph.xml and no
           country code portion may be specified in the irm:value attribute value. Human Readable: ISO 639-3 trigraph language codes must be in the
           ISO 639-3 trigraph CVE.</sch:p>
    <sch:p class="codeDesc"
           ism:classification="U"
           ism:ownerProducer="USA">This rule uses an abstract pattern to consolidate logic. It checks that the value in parameter $searchTerm is
           contained in the parameter $list. The parameter $searchTerm is relative in scope to the parameter $context. The value for the parameter
           $list is a variable defined in the main document (IRM_XML.sch), which reads values from a specific CVE file. This rule can directly check
           if the value of element Language is in the appropriate list because if a country code portion is specified in the element irm:language's
           value, then the value of element irm:language will not be found in the appropriate list and the assertion will fail as expected.</sch:p>
    <sch:param name="ruleText"
               value="' [IRM-ID-00007][Error] If element irm:language has the attribute @irm:qualifier value of [urn:us:gov:ic:cvenum:irm:iso639-3:trigraph] then the value of attribute @irm:value must be in CVEnumIRMISO639-3Trigraph.xml and no country code portion may be specified in the irm:value attribute value. Human Readable: ISO 639-3 trigraph language codes must in the the ISO 639-3 trigraph CVE. '" />
    <sch:param name="codeDesc"
               value="' This rule uses an abstract pattern to consolidate logic. It checks that the value in parameter $searchTerm is contained in the parameter $list. The parameter $searchTerm is relative in scope to the parameter $context. The value for the parameter $list is a variable defined in the main document (IRM_XML.sch), which reads values from a specific CVE file. '" />
    <sch:param name="context"
               value="irm:language[@irm:qualifier='urn:us:gov:ic:cvenum:irm:iso639-3:trigraph']" />
    <sch:param name="searchTerm"
               value="@irm:value" />
    <sch:param name="list"
               value="$iso639-3TrigraphList" />
    <sch:param name="errMsg"
               value="' [IRM-ID-00007][Error] If element irm:language has the attribute @irm:qualifier value of [urn:us:gov:ic:cvenum:irm:iso639-3:trigraph] then the value of attribute @irm:value must be in CVEnumIRMISO639-3Trigraph.xml and no country code portion may be specified in the irm:value attribute value. Human Readable: ISO 639-3 trigraph language codes must in the the ISO 639-3 trigraph CVE. '" />
</sch:pattern>
