<?xml version="1.0" encoding="UTF-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" xmlns:ism="urn:us:gov:ic:ism" is-a="ValidateTokenValuesExistenceInList" id="NTK-ID-00030">
   
   <sch:p ism:classification="U" ism:ownerProducer="USA" class="ruleText">[NTK-ID-00030][Error] datasphere:mn:issue vocabulary values must exist in the Mission Need Issue CVE.</sch:p>

   <sch:param name="context" value="ntk:AccessProfileValue[@ntk:vocabulary='datasphere:mn:issue']"/>
   <sch:param name="searchTermList" value="."/>
   <sch:param name="list" value="$issueList"/>
   <sch:param name="errMsg" value="'[NTK-ID-00030][Error] datasphere:mn:issue vocabulary values must exist in the Mission Need Issue CVE.'"/>
</sch:pattern>
