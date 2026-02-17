<?xml version="1.0" encoding="UTF-8"?>
<!--UNCLASSIFIED--><?ICEA master?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<!-- WARNING: 
    Once compiled into an XSLT the result will 
    be the aggregate classification of all the CVES 
    and included .sch files
-->
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
    <sch:ns uri="http://www.w3.org/2001/XMLSchema" prefix="xs"/>
    <sch:ns uri="urn:us:gov:ic:pm" prefix="pm"/>
    
    <sch:p xmlns:ism="urn:us:gov:ic:ism"
          class="codeDesc"
          ism:classification="U"
          ism:ownerProducer="USA">
        This is the root file for the specifications Schematron ruleset. It loads all of the required CVEs, 
        declares some variables, and includes all of the Rule .sch files.</sch:p>

   <!--****************************-->
<!-- (U) PM Phases -->
<!--****************************-->
<!--****************************-->
<!-- (U) PM ID Rules -->
<!--****************************-->

<!--(U) -->
   <sch:include href="./Rules/PM_ID_00001.sch"/>

   <!--****************************-->
<!-- (U) PM Phases -->
<!--****************************--></sch:schema>
<!--UNCLASSIFIED-->
