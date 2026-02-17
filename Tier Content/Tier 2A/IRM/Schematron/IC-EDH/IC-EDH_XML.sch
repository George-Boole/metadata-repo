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
    <sch:ns uri="urn:us:gov:ic:pubs" prefix="pubs"/>
    <sch:ns uri="urn:us:gov:ic:cve" prefix="cve"/>
    <sch:ns uri="http://www.w3.org/1999/xlink" prefix="xlink"/>
    <sch:ns uri="urn:us:gov:ic:ism" prefix="ism"/>
    <sch:ns uri="urn:us:gov:ic:ntk" prefix="ntk"/>
    <sch:ns uri="urn:us:gov:ic:edh" prefix="edh"/>
    <sch:ns uri="urn:us:gov:ic:arh" prefix="arh"/>
    <sch:ns uri="urn:us:gov:ic:id" prefix="icid"/>
    <sch:ns uri="urn:us:gov:ic:usagency" prefix="usagency"/>
    <sch:ns uri="urn:us:gov:ic:edh:xsl:util" prefix="util"/>
    <sch:ns uri="http://www.w3.org/2001/XMLSchema" prefix="xs"/>
    <sch:ns uri="http://www.functx.com" prefix="functx"/>
    
    <sch:p xmlns:ism="urn:us:gov:ic:ism"
          class="codeDesc"
          ism:classification="U"
          ism:ownerProducer="USA">
        This is the root file for the specifications Schematron ruleset. It loads all of the required CVEs, 
        declares some variables, and includes all of the Rule .sch files.</sch:p>
    
    <!-- ************************************** -->
    <!-- * Abstract Rule and Pattern Includes * -->
    <!-- ************************************** -->
    <sch:include href="./Lib/ValidateValueExistenceInList.sch"/>
    <sch:include href="./Lib/ValidateValidationEnvCVE.sch"/>
    <sch:include href="./Lib/ValidateValidationEnvSchema.sch"/>
    
    <!--====================-->
    <!-- (U) Universal Lets -->
    <!--====================-->
    <sch:let name="usagencyList"
            value="document('../../CVE/USAgency/CVEnumUSAgencyAcronym.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>

    <!--****************************-->
    <!-- (U) Custom XSLT function   -->
    <!--****************************-->
    <!--
    Returns true if any token in the attribute value matches at least one token in the provided list.
  -->
    <xsl:function xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                 name="util:containsAnyOfTheTokens"
                 as="xs:boolean">
        <xsl:param name="attribute"/>
        <xsl:param name="tokenList" as="xs:string+"/>
        <xsl:value-of select=" some $attrToken in tokenize(normalize-space(string($attribute)), ' ') satisfies $attrToken = $tokenList"/>
    </xsl:function>
    <xsl:function xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                 name="functx:next-day"
                 as="xs:date?">
        <xsl:param name="date" as="xs:anyAtomicType?"/>
        <xsl:sequence select=" xs:date($date) + xs:dayTimeDuration('P1D')"/>
   </xsl:function>

   <!--****************************-->
<!-- (U) IC-EDH Phases -->
<!--****************************-->
<!--****************************-->
<!-- (U) IC-EDH ID Rules -->
<!--****************************-->

<!--(U) -->
   <sch:include href="./Rules/IC-EDH_ID_00001.sch"/>
   <sch:include href="./Rules/IC-EDH_ID_00002.sch"/>
   <sch:include href="./Rules/IC-EDH_ID_00003.sch"/>
   <sch:include href="./Rules/IC-EDH_ID_00004.sch"/>
   <sch:include href="./Rules/IC-EDH_ID_00005.sch"/>
   <sch:include href="./Rules/IC-EDH_ID_00006.sch"/>
   <sch:include href="./Rules/IC-EDH_ID_00008.sch"/>
   <sch:include href="./Rules/IC-EDH_ID_00011.sch"/>
   <sch:include href="./Rules/IC-EDH_ID_00012.sch"/>
   <sch:include href="./Rules/IC-EDH_ID_00013.sch"/>
   <sch:include href="./Rules/IC-EDH_ID_00014.sch"/>
   <sch:include href="./Rules/IC-EDH_ID_00015.sch"/>
   <sch:include href="./Rules/IC-EDH_ID_00016.sch"/>
   <sch:include href="./Rules/IC-EDH_ID_00017.sch"/>
   <sch:include href="./Rules/IC-EDH_ID_00018.sch"/>

   <!--****************************-->
<!-- (U) IC-EDH Phases -->
<!--****************************--></sch:schema>
<!--UNCLASSIFIED-->
