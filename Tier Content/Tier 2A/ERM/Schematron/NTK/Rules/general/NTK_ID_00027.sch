<?xml version="1.0" encoding="UTF-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" xmlns:ism="urn:us:gov:ic:ism" is-a="ValidateTokenValuesExistenceInList" id="NTK-ID-00027">

    <sch:p ism:classification="U" ism:ownerProducer="USA" class="ruleText">[NTK-ID-00027][Error] organization:usa-agency vocabulary values must exist in the USAgency
        CVE.</sch:p>

    <sch:param name="context"
        value="ntk:AccessProfile/ntk:AccessProfileValue[@ntk:vocabulary='organization:usa-agency']"/>
    <sch:param name="searchTermList" value="."/>
    <sch:param name="list" value="$usagencyList"/>
    <sch:param name="errMsg"
        value="'[NTK-ID-00027][Error] organization:usa-agency vocabulary values must exist in the USAgency CVE.'"/>
</sch:pattern>
