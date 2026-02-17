<?xml version="1.0" encoding="utf-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:ism="urn:us:gov:ic:ism"
             xmlns:sch="http://purl.oclc.org/dsdl/schematron"
             is-a="IsmEnforcement"
             id="IRM-ID-00042">
    <sch:p class="ruleText"
           ism:classification="U"
           ism:ownerProducer="USA">[IRM-ID-00042][Error] If element irm:type is specified with a qualifier of
           [urn:us:gov:ic:cvenum:intdis:inteldiscipline:component], then attribute ism:classification must also be specified. Human Readable: If the
           type element has the qualifier attribute with the value 'urn:us:gov:ic:cvenum:intdis:inteldiscipline:component' then the type element must
           also have the classification attribute that is not empty.</sch:p>
    <sch:p class="codeDesc"
           ism:classification="U"
           ism:ownerProducer="USA">For each irm:type element which specifies attribute irm:qualifier with a value of
           [urn:us:gov:ic:cvenum:intdis:inteldiscipline:component], ensure that attribtue ism:classification is specified.</sch:p>
    <sch:param name="ruleText"
               value="'[IRM-ID-00042][Error] If element irm:type is specified with a qualifier of [urn:us:gov:ic:cvenum:intdis:inteldiscipline:component], then attribute ism:classification must also be specified.'" />
    <sch:param name="codeDesc"
               value="' For each irm:type element which specifies attribute irm:qualifier with a value of [urn:us:gov:ic:cvenum:intdis:inteldiscipline:component], ensure that attribtue ism:classification is specified.'" />
    <sch:param name="context"
           value="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage//irm:type[@irm:qualifier='urn:us:gov:ic:cvenum:intdis:inteldiscipline:component']" />
    <sch:param name="errMsg"
               value="' [IRM-ID-00042][Error] If element irm:type is specified with a qualifier of [urn:us:gov:ic:cvenum:intdis:inteldiscipline:component], then attribute ism:classification must also be specified. '" />
</sch:pattern>
