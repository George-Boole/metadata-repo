<?xml version="1.0" encoding="utf-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:ism="urn:us:gov:ic:ism"
             xmlns:sch="http://purl.oclc.org/dsdl/schematron"
             is-a="ValidateValueExistenceInList"
             id="IC-EDH-ID-00006">
    <sch:p class="ruleText"
           ism:classification="U"
           ism:ownerProducer="USA">[IC-EDH-ID-00006][Error] If the Country of the ResponsibleEntity is [USA] then the value of Organization must be a
           term from the USAgency CES. Human Readable: If the Country element contains USA, the agency in the Organization element must be defined in
           the USAgency CES.</sch:p>
    <sch:param name="context"
               value="edh:Country[.='USA']" />
    <sch:param name="list"
               value="$usagencyList" />
    <sch:param name="searchTerm"
               value="following-sibling::edh:Organization" />
    <sch:param name="errMsg"
               value="' [IC-EDH-ID-00006][Error] If the Country of the ResponsibleEntity is [USA] then the value of Organization must be a term from the USAgency CES. Human Readable: If the Country element contains USA, the agency in the Organization element must be defined in the USAgency CES. '" />
</sch:pattern>
