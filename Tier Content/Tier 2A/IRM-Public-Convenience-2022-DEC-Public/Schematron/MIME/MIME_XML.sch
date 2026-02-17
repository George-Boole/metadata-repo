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
    <sch:ns uri="urn:us:gov:ic:ism" prefix="ism"/>
    <sch:ns uri="urn:us:gov:ic:ac" prefix="ac"/>
    <sch:ns uri="urn:us:gov:ic:edh:xsl:util" prefix="util"/>
    <sch:ns uri="http://www.w3.org/2001/XMLSchema" prefix="xs"/>
    <sch:ns uri="urn:us:gov:ic:mime" prefix="mime"/>
    <sch:ns uri="urn:us:gov:ic:cve" prefix="cve"/>
    
    <sch:p xmlns:ism="urn:us:gov:ic:ism"
          class="codeDesc"
          ism:classification="U"
          ism:ownerProducer="USA">
        This is the root file for the specifications Schematron ruleset. It loads all of the required CVEs, 
        declares some variables, and includes all of the Rule .sch files.</sch:p>
    
    
    <!--====================-->
    <!-- (U) Universal Lets -->
    <!--====================-->
    <sch:let name="deprecatedMimeTypeList"
            value="document('../../CVE/MIME/CVEnumMIMEType.xml')/cve:CVE/cve:Enumeration/cve:Term[./@deprecated]/cve:Value"/>
    <sch:let name="mimeTypeList"
            value="document('../../CVE/MIME/CVEnumMIMEType.xml')/cve:CVE/cve:Enumeration/cve:Term[not(./@deprecated)]/cve:Value"/>
    <sch:let name="nonRegexMimeTypeList"
            value="document('../../CVE/MIME/CVEnumMIMEType.xml')/cve:CVE/cve:Enumeration/cve:Term[not(./@deprecated)]/cve:Value[not(./@regularExpression)]"/>

   <!--****************************-->
<!-- (U) MIME Phases -->
<!--****************************-->
<!--****************************-->
<!-- (U) MIME ID Rules -->
<!--****************************-->

<!--(U) -->
   <sch:include href="./Rules/MIME_ID_00001.sch"/>
   <sch:include href="./Rules/MIME_ID_00002.sch"/>
   <sch:include href="./Rules/MIME_ID_00003.sch"/>

   <!--****************************-->
<!-- (U) MIME Phases -->
<!--****************************--></sch:schema>
<!--UNCLASSIFIED-->
