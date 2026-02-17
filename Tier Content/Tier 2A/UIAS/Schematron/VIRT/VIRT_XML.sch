<?xml version="1.0" encoding="UTF-8"?>
<!--UNCLASSIFIED--><?ICEA master?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
    <sch:ns uri="urn:us:gov:ic:cve" prefix="cve"/>
    <sch:ns uri="http://www.w3.org/1999/xlink" prefix="xlink"/>
    <sch:ns uri="urn:us:gov:ic:ism" prefix="ism"/>
    <sch:ns uri="urn:us:gov:ic:virt" prefix="virt"/>
    <sch:ns uri="urn:us:gov:ic:ntk" prefix="ntk"/>
    <sch:ns uri="http://www.w3.org/2001/XMLSchema" prefix="xs"/>
   
    <sch:p xmlns:ism="urn:us:gov:ic:ism"
          class="codeDesc"
          ism:classification="U"
          ism:ownerProducer="USA">
      This is the root file for the specifications Schematron ruleset. 
      It includes all of the Rule .sch files.</sch:p>

   <!--****************************-->
<!-- (U) VIRT Phases -->
<!--****************************-->
<!--****************************-->
<!-- (U) VIRT ID Rules -->
<!--****************************-->

<!--(U) globalConstraints-->
   <sch:include href="./Rules/globalConstraints/VIRT_ID_00001.sch"/>
   <sch:include href="./Rules/globalConstraints/VIRT_ID_00003.sch"/>
   <sch:include href="./Rules/globalConstraints/VIRT_ID_00004.sch"/>
   <sch:include href="./Rules/globalConstraints/VIRT_ID_00005.sch"/>

   <!--****************************-->
<!-- (U) VIRT Phases -->
<!--****************************--></sch:schema>
<!--UNCLASSIFIED-->
