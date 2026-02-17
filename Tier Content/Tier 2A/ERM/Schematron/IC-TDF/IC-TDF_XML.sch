<?xml version="1.0" encoding="UTF-8"?>
<!--UNCLASSIFIED--><?ICEA master?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
    <sch:ns prefix="tdf" uri="urn:us:gov:ic:tdf"/>
    <sch:ns prefix="ism" uri="urn:us:gov:ic:ism"/>
    <sch:ns prefix="arh" uri="urn:us:gov:ic:arh"/>
    <sch:ns prefix="edh" uri="urn:us:gov:ic:edh"/>
    <sch:ns prefix="ntk" uri="urn:us:gov:ic:ntk"/>
    <sch:ns prefix="icid" uri="urn:us:gov:ic:id"/>
    <sch:ns prefix="usagency" uri="urn:us:gov:ic:usagency"/>
    <sch:ns prefix="revrecall" uri="urn:us:gov:ic:revrecall"/>
    <sch:ns prefix="util" uri="urn:us:gov:ic:tdf:xsl:util"/>
    <sch:p class="codeDesc"> This is the root file for the IC-TDF Schematron rule set. It loads all of
        the required CVEs, declares some global variables, and includes all of the Rule .sch files. </sch:p>


    <!-- (U) Abstract Patterns -->
    <sch:include href="Lib/CompareVersionsInSkeleton.sch"/>

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

   <!--****************************-->
<!-- (U) IC-TDF ID Rules -->
<!--****************************-->

<!--(U) -->
   <sch:include href="./Rules/IC-TDF_ID_00001.sch"/>
   <sch:include href="./Rules/IC-TDF_ID_00002.sch"/>
   <sch:include href="./Rules/IC-TDF_ID_00003.sch"/>
   <sch:include href="./Rules/IC-TDF_ID_00004.sch"/>
   <sch:include href="./Rules/IC-TDF_ID_00005.sch"/>
   <sch:include href="./Rules/IC-TDF_ID_00006.sch"/>
   <sch:include href="./Rules/IC-TDF_ID_00007.sch"/>
   <sch:include href="./Rules/IC-TDF_ID_00008.sch"/>
   <sch:include href="./Rules/IC-TDF_ID_00009.sch"/>
   <sch:include href="./Rules/IC-TDF_ID_00010.sch"/>
   <sch:include href="./Rules/IC-TDF_ID_00011.sch"/>
   <sch:include href="./Rules/IC-TDF_ID_00012.sch"/>
   <sch:include href="./Rules/IC-TDF_ID_00013.sch"/>
   <sch:include href="./Rules/IC-TDF_ID_00014.sch"/>
   <sch:include href="./Rules/IC-TDF_ID_00015.sch"/>
   <sch:include href="./Rules/IC-TDF_ID_00016.sch"/>
   <sch:include href="./Rules/IC-TDF_ID_00017.sch"/>
   <sch:include href="./Rules/IC-TDF_ID_00018.sch"/>
   <sch:include href="./Rules/IC-TDF_ID_00019.sch"/>
   <sch:include href="./Rules/IC-TDF_ID_00033.sch"/>
   <sch:include href="./Rules/IC-TDF_ID_00034.sch"/>
   <sch:include href="./Rules/IC-TDF_ID_00035.sch"/>
   <sch:include href="./Rules/IC-TDF_ID_00036.sch"/>
   <sch:include href="./Rules/IC-TDF_ID_00037.sch"/>
   <sch:include href="./Rules/IC-TDF_ID_00038.sch"/>
   <sch:include href="./Rules/IC-TDF_ID_00040.sch"/>
   <sch:include href="./Rules/IC-TDF_ID_00041.sch"/>
   <sch:include href="./Rules/IC-TDF_ID_00042.sch"/>
   <sch:include href="./Rules/IC-TDF_ID_00043.sch"/>
   <sch:include href="./Rules/IC-TDF_ID_00044.sch"/>
   <sch:include href="./Rules/IC-TDF_ID_00045.sch"/>
   <sch:include href="./Rules/IC-TDF_ID_00046.sch"/>
   <sch:include href="./Rules/IC-TDF_ID_00047.sch"/>
   <sch:include href="./Rules/IC-TDF_ID_00048.sch"/>
   <sch:include href="./Rules/IC-TDF_ID_00049.sch"/>
   <sch:include href="./Rules/IC-TDF_ID_00050.sch"/>
   <sch:include href="./Rules/IC-TDF_ID_00051.sch"/>
   <sch:include href="./Rules/IC-TDF_ID_00052.sch"/>
   <sch:include href="./Rules/IC-TDF_ID_00053.sch"/>
   <sch:include href="./Rules/IC-TDF_ID_00054.sch"/>
   <sch:include href="./Rules/IC-TDF_ID_00055.sch"/>

   <!--(U) appliesToState-->
   <sch:include href="./Rules/appliesToState/IC-TDF_ID_00025.sch"/>
   <sch:include href="./Rules/appliesToState/IC-TDF_ID_00026.sch"/>
   <sch:include href="./Rules/appliesToState/IC-TDF_ID_00027.sch"/>
   <sch:include href="./Rules/appliesToState/IC-TDF_ID_00028.sch"/>
   <sch:include href="./Rules/appliesToState/IC-TDF_ID_00030.sch"/>
   <sch:include href="./Rules/appliesToState/IC-TDF_ID_00031.sch"/>
   <sch:include href="./Rules/appliesToState/IC-TDF_ID_00032.sch"/>
   <sch:include href="./Rules/appliesToState/IC-TDF_ID_00039.sch"/>
</sch:schema>
<!--UNCLASSIFIED-->
