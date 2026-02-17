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
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron"
            xmlns:ism="urn:us:gov:ic:ism"
            xmlns:sfhashv="urn:us:gov:ic:sf:hashverification"
            queryBinding="xslt2">
    <sch:ns uri="urn:us:gov:ic:tdf" prefix="tdf"/>
    <sch:ns uri="urn:us:gov:ic:ism" prefix="ism"/>
    <sch:ns uri="urn:us:gov:ic:sf:hashverification" prefix="sfhashv"/>
    <sch:ns uri="urn:us:gov:ic:sf" prefix="sf"/>
    <sch:ns prefix="util" uri="urn:us:gov:ic:tdf:xsl:util"/>


    <!--****************************-->
    <!-- (U) Utility functions      -->
    <!--****************************-->
    <!--
    Returns true if any token in the attribute value matches at least one token in the provided list.
  -->
    <xsl:function xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                 name="util:containsAnyOfTheTokens"
                 as="xs:boolean">
        <xsl:param name="attribute"/>
        <xsl:param name="tokenList" as="xs:string+"/>
        <xsl:value-of select="some $attrToken in tokenize(normalize-space(string($attribute)), ' ') satisfies $attrToken = $tokenList"/>
    </xsl:function>
    <!--
                Returns true if every token in the attribute is contained in the provided list.
        -->
    <xsl:function xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                 name="util:containsOnlyTheTokens"
                 as="xs:boolean">
        <xsl:param name="attribute"/>
        <xsl:param name="tokenList" as="xs:string+"/>
        <xsl:value-of select="every $attrToken in tokenize(normalize-space(string($attribute)), ' ') satisfies $attrToken = $tokenList"/>
   </xsl:function>
    
    <!-- ************************************** -->
    <!-- * Abstract Rule and Pattern Includes * -->
    <!-- ************************************** -->
    <sch:include href="./Lib/ValidateValidationEnvSchema.sch"/>
    <sch:include href="./Lib/ValidateValidationEnvCVE.sch"/>

   <!--****************************-->
<!-- (U) BASE-TDF Phases -->
<!--****************************-->
<!--****************************-->
<!-- (U) BASE-TDF ID Rules -->
<!--****************************-->

<!--(U) -->
   <sch:include href="./Rules/BASE-TDF_ID_00001.sch"/>
   <sch:include href="./Rules/BASE-TDF_ID_00002.sch"/>
   <sch:include href="./Rules/BASE-TDF_ID_00003.sch"/>
   <sch:include href="./Rules/BASE-TDF_ID_00004.sch"/>
   <sch:include href="./Rules/BASE-TDF_ID_00005.sch"/>
   <sch:include href="./Rules/BASE-TDF_ID_00006.sch"/>
   <sch:include href="./Rules/BASE-TDF_ID_00007.sch"/>
   <sch:include href="./Rules/BASE-TDF_ID_00008.sch"/>
   <sch:include href="./Rules/BASE-TDF_ID_00009.sch"/>
   <sch:include href="./Rules/BASE-TDF_ID_00010.sch"/>
   <sch:include href="./Rules/BASE-TDF_ID_00011.sch"/>
   <sch:include href="./Rules/BASE-TDF_ID_00012.sch"/>
   <sch:include href="./Rules/BASE-TDF_ID_00013.sch"/>
   <sch:include href="./Rules/BASE-TDF_ID_00014.sch"/>
   <sch:include href="./Rules/BASE-TDF_ID_00015.sch"/>
   <sch:include href="./Rules/BASE-TDF_ID_00016.sch"/>
   <sch:include href="./Rules/BASE-TDF_ID_00017.sch"/>
   <sch:include href="./Rules/BASE-TDF_ID_00018.sch"/>
   <sch:include href="./Rules/BASE-TDF_ID_00019.sch"/>
   <sch:include href="./Rules/BASE-TDF_ID_00020.sch"/>
   <sch:include href="./Rules/BASE-TDF_ID_00021.sch"/>
   <sch:include href="./Rules/BASE-TDF_ID_00022.sch"/>
   <sch:include href="./Rules/BASE-TDF_ID_00023.sch"/>
   <sch:include href="./Rules/BASE-TDF_ID_00024.sch"/>

   <!--****************************-->
<!-- (U) BASE-TDF Phases -->
<!--****************************--></sch:schema>
<!--UNCLASSIFIED-->
