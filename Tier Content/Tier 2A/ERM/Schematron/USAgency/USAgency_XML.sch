<?xml version="1.0" encoding="UTF-8"?>
<!--UNCLASSIFIED--><!--UNCLASSIFIED--><?ICEA master?><!-- Notices - Distribution Notice:
            This document is being made available by the Intelligence Community Chief Information Officer
            to Federal, State, Local, Tribal, and Foreign Partners and associated contractors. Approval for
            any further distribution must be coordinated via the Intelligence Community Chief Information 
            Officer, at ic-standards-support@iarpa.gov.-->
<!-- WARNING: 
    Once compiled into an XSLT the result will 
    be the aggregate classification of all the CVES 
    and included .sch files
-->
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
    <sch:ns uri="urn:us:gov:ic:usagency" prefix="usagency"/>
    <sch:ns uri="urn:us:gov:ic:edh:xsl:util" prefix="util"/>
    <sch:ns uri="http://www.w3.org/2001/XMLSchema" prefix="xs"/>


    <!--====================-->
    <!-- (U) Universal Lets -->
    <!--====================-->

    <!-- ************************************** -->
    <!-- * Abstract Rule and Pattern Includes * -->
    <!-- ************************************** -->
    <sch:include href="Lib/AllowableUSAgencyValue.sch"/>

   <!--****************************-->
<!-- (U) USAgency ID Rules -->
<!--****************************-->

<!--(U) -->
   <sch:include href="./Rules/USAgency_ID_00001.sch"/>
</sch:schema>
<!--UNCLASSIFIED--><!--UNCLASSIFIED-->
