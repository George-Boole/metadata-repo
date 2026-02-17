<?xml version="1.0" encoding="UTF-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" xmlns:ism="urn:us:gov:ic:ism" is-a="ValidateTokenValuesExistenceInList" id="NTK-ID-00031">
   
   <sch:p ism:classification="U" ism:ownerProducer="USA" class="ruleText">[NTK-ID-00031][Error] datasphere:mn:region vocabulary values must exist in the Mission Need Region CVE.</sch:p>
   
   <sch:param name="context" value="ntk:AccessProfileValue[@ntk:vocabulary='datasphere:mn:region']"/>
   <sch:param name="searchTermList" value="."/>
   <sch:param name="list" value="$regionList"/>
   <sch:param name="errMsg" value="'[NTK-ID-00031][Error] datasphere:mn:region vocabulary values must exist in the Mission Need Region CVE.'"/>
</sch:pattern>
