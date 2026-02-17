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
   <sch:ns uri="urn:us:gov:ic:revrecall" prefix="rr"/>
   <sch:ns uri="http://www.w3.org/1999/xlink" prefix="xl"/>
   <sch:ns prefix="tdf" uri="urn:us:gov:ic:tdf"/>
   
   <!-- ************************************** -->
   <!-- * Abstract Rule and Pattern Includes * -->
   <!-- ************************************** -->
   <sch:include href="./Lib/ValidateValidationEnvSchema.sch"/>
   <sch:include href="./Lib/ValidateValidationEnvCVE.sch"/>

   <!--****************************-->
<!-- (U) RevRecall Phases -->
<!--****************************-->
<!--****************************-->
<!-- (U) RevRecall ID Rules -->
<!--****************************-->

<!--(U) generalConstraints-->
   <sch:include href="./Rules/generalConstraints/RevRecall_ID_00001.sch"/>
   <sch:include href="./Rules/generalConstraints/RevRecall_ID_00003.sch"/>
   <sch:include href="./Rules/generalConstraints/RevRecall_ID_00004.sch"/>
   <sch:include href="./Rules/generalConstraints/RevRecall_ID_00005.sch"/>
   <sch:include href="./Rules/generalConstraints/RevRecall_ID_00006.sch"/>
   <sch:include href="./Rules/generalConstraints/RevRecall_ID_00007.sch"/>
   <sch:include href="./Rules/generalConstraints/RevRecall_ID_00008.sch"/>
   <sch:include href="./Rules/generalConstraints/RevRecall_ID_00009.sch"/>
   <sch:include href="./Rules/generalConstraints/RevRecall_ID_00010.sch"/>
   <sch:include href="./Rules/generalConstraints/RevRecall_ID_00011.sch"/>
   <sch:include href="./Rules/generalConstraints/RevRecall_ID_00012.sch"/>
   <sch:include href="./Rules/generalConstraints/RevRecall_ID_00013.sch"/>

   <!--****************************-->
<!-- (U) RevRecall Phases -->
<!--****************************--></sch:schema>
<!--UNCLASSIFIED-->
