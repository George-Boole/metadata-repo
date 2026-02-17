<?xml version="1.0" encoding="UTF-8"?>
<!--UNCLASSIFIED--><?ICEA master?>
<!-- UNCLASSIFIED -->
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<!-- WARNING: 
    Once compiled into an XSLT the result will 
    be the aggregate classification of all the CVES 
    and included .sch files
-->
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
    <sch:ns uri="urn:us:gov:ic:usagency" prefix="usagency"/>
    <sch:ns uri="urn:us:gov:ic:edh:xsl:util" prefix="util"/>
    <sch:ns uri="http://www.w3.org/2001/XMLSchema" prefix="xs"/>
    <sch:ns uri="urn:us:gov:ic:icgenc" prefix="genc"/>


    <!--====================-->
    <!-- (U) Universal Lets -->
    <!--====================-->

    <!-- ************************************** -->
    <!-- * Abstract Rule and Pattern Includes * -->
    <!-- ************************************** -->
    <sch:include href="Lib/AllowableGencValue.sch"/>

   <!--****************************-->
<!-- (U) IC-GENC Phases -->
<!--****************************-->
<!--****************************-->
<!-- (U) IC-GENC ID Rules -->
<!--****************************-->

<!--(U) -->
   <sch:include href="./Rules/IC-GENC_ID_00001.sch"/>

   <!--****************************-->
<!-- (U) IC-GENC Phases -->
<!--****************************--></sch:schema>
<!--UNCLASSIFIED-->
