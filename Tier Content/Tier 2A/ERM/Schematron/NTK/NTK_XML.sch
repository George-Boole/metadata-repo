<?xml version="1.0" encoding="UTF-8"?>
<!--UNCLASSIFIED--><?ICEA master?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
   <sch:ns uri="urn:us:gov:ic:pubs" prefix="pubs"/>
   <sch:ns uri="urn:us:gov:ic:cve" prefix="cve"/>
   <sch:ns uri="http://www.w3.org/1999/xlink" prefix="xlink"/>
   <sch:ns uri="urn:us:gov:ic:ism" prefix="ism"/>
   <sch:ns uri="urn:us:gov:ic:mat" prefix="mat"/>
   <sch:ns uri="urn:us:gov:ic:ntk" prefix="ntk"/>
   <sch:ns uri="urn:us:gov:ic:irm" prefix="irm"/>
   <sch:ns uri="http://www.w3.org/2001/XMLSchema" prefix="xs"/>

   <sch:include href="Lib/VocabHasCorrespondingVersion.sch"/>
   <sch:include href="Lib/ValueExistsInList.sch"/>
   <sch:include href="Lib/ValidateTokenValuesExistenceInList.sch"/>

   <!--************************-->
   <!-- (U) Global Lets        -->
   <!--************************-->

   <!-- Built in vocabulary types (builtinVocab) and their sources (buildinVocabSource).
      These two lists must be kept in sync and order matters. -->
   <sch:let name="builtins"
            value="( ('group:iaaems','JWICS:IAAEMS'), ('individual:icpki','IC-PKI:DN'), ('individual:cadpki','CAD-PKI:DN'),  ('individual:acsspki','ACSS-PKI:DN'),  ('organization:usa-agency','urn:us:gov:ic:cvenum:usagency:agencyacronym'), ('datasphere:license','urn:us:gov:ic:cvenum:lic:license'), ('datasphere:mn:issue','urn:us:gov:ic:cvenum:mn:issue'), ('datasphere:mn:region','urn:us:gov:ic:cvenum:mn:region'))"/>

   <!-- Split out the built ins for ease of use -->
   <sch:let name="builtinVocab"
            value="for $each in $builtins[position() mod 2 eq 1] return $each"/>
   <sch:let name="builtinVocabSource"
            value="for $each in $builtins[position() mod 2 eq 0] return $each"/>

   <!-- (U) Resources  -->
   <sch:let name="accessPolicyList"
            value="document('../../CVE/NTK/CVEnumNTKAccessPolicy.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>
   <sch:let name="profileDESList"
            value="document('../../CVE/NTK/CVEnumNTKProfileDes.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>
   <sch:let name="licenseList"
            value="document('../../CVE/LIC/CVEnumLicLicense.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>
   <sch:let name="usagencyList"
            value="document('../../CVE/USAgency/CVEnumUSAgencyAcronym.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>
   <sch:let name="issueList"
            value="document('../../CVE/MN/CVEnumMNIssue.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>
   <sch:let name="regionList"
            value="document('../../CVE/MN/CVEnumMNRegion.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>

   <!--****************************-->
<!-- (U) NTK ID Rules -->
<!--****************************-->

<!--(U) ICO-->
   <sch:include href="./Rules/ICO/NTK_ID_00026.sch"/>

   <!--(U) MN-->
   <sch:include href="./Rules/MN/NTK_ID_00010.sch"/>
   <sch:include href="./Rules/MN/NTK_ID_00011.sch"/>
   <sch:include href="./Rules/MN/NTK_ID_00012.sch"/>
   <sch:include href="./Rules/MN/NTK_ID_00013.sch"/>
   <sch:include href="./Rules/MN/NTK_ID_00030.sch"/>
   <sch:include href="./Rules/MN/NTK_ID_00031.sch"/>
   <sch:include href="./Rules/MN/NTK_ID_00046.sch"/>

   <!--(U) agencyDissem-->
   <sch:include href="./Rules/agencyDissem/NTK_ID_00028.sch"/>
   <sch:include href="./Rules/agencyDissem/NTK_ID_00035.sch"/>

   <!--(U) datasphere-->
   <sch:include href="./Rules/datasphere/NTK_ID_00021.sch"/>
   <sch:include href="./Rules/datasphere/NTK_ID_00022.sch"/>

   <!--(U) exdis-->
   <sch:include href="./Rules/exdis/NTK_ID_00040.sch"/>
   <sch:include href="./Rules/exdis/NTK_ID_00050.sch"/>

   <!--(U) general-->
   <sch:include href="./Rules/general/NTK_ID_00002.sch"/>
   <sch:include href="./Rules/general/NTK_ID_00004.sch"/>
   <sch:include href="./Rules/general/NTK_ID_00006.sch"/>
   <sch:include href="./Rules/general/NTK_ID_00007.sch"/>
   <sch:include href="./Rules/general/NTK_ID_00009.sch"/>
   <sch:include href="./Rules/general/NTK_ID_00018.sch"/>
   <sch:include href="./Rules/general/NTK_ID_00019.sch"/>
   <sch:include href="./Rules/general/NTK_ID_00020.sch"/>
   <sch:include href="./Rules/general/NTK_ID_00023.sch"/>
   <sch:include href="./Rules/general/NTK_ID_00024.sch"/>
   <sch:include href="./Rules/general/NTK_ID_00025.sch"/>
   <sch:include href="./Rules/general/NTK_ID_00027.sch"/>
   <sch:include href="./Rules/general/NTK_ID_00029.sch"/>
   <sch:include href="./Rules/general/NTK_ID_00032.sch"/>
   <sch:include href="./Rules/general/NTK_ID_00033.sch"/>
   <sch:include href="./Rules/general/NTK_ID_00041.sch"/>
   <sch:include href="./Rules/general/NTK_ID_00042.sch"/>
   <sch:include href="./Rules/general/NTK_ID_00043.sch"/>
   <sch:include href="./Rules/general/NTK_ID_00044.sch"/>
   <sch:include href="./Rules/general/NTK_ID_00045.sch"/>
   <sch:include href="./Rules/general/NTK_ID_00048.sch"/>
   <sch:include href="./Rules/general/NTK_ID_00051.sch"/>

   <!--(U) grp-ind-->
   <sch:include href="./Rules/grp-ind/NTK_ID_00016.sch"/>
   <sch:include href="./Rules/grp-ind/NTK_ID_00017.sch"/>

   <!--(U) orcon-->
   <sch:include href="./Rules/orcon/NTK_ID_00039.sch"/>
   <sch:include href="./Rules/orcon/NTK_ID_00049.sch"/>

   <!--(U) permissive-->
   <sch:include href="./Rules/permissive/NTK_ID_00034.sch"/>

   <!--(U) propin-->
   <sch:include href="./Rules/propin/NTK_ID_00014.sch"/>
   <sch:include href="./Rules/propin/NTK_ID_00015.sch"/>
   <sch:include href="./Rules/propin/NTK_ID_00036.sch"/>

   <!--(U) restrictive-->
   <sch:include href="./Rules/restrictive/NTK_ID_00037.sch"/>
   <sch:include href="./Rules/restrictive/NTK_ID_00038.sch"/>
</sch:schema>
<!--UNCLASSIFIED-->
