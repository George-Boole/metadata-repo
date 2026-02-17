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
            queryBinding="xslt2">
  <sch:ns uri="urn:us:gov:ic:uias" prefix="uias"/>
  <sch:ns uri="urn:us:gov:ic:ism" prefix="ism"/>
  <sch:ns uri="urn:us:gov:ic:cve" prefix="cve"/>
  <sch:ns uri="urn:us:gov:ic:usagency" prefix="usagency"/>
  <sch:ns uri="urn:us:gov:ic:virt" prefix="virt"/>
  <sch:ns uri="urn:us:gov:ic:mn" prefix="mn"/>
  <sch:ns uri="urn:oasis:names:tc:SAML:2.0:assertion" prefix="saml"/>
  <sch:ns uri="http://www.w3.org/2001/XMLSchema-instance" prefix="xsi"/>
  <sch:ns uri="urn:us:gov:ic:uias:xsl:util" prefix="util"/>

  <sch:p class="codeDesc" ism:classification="U" ism:ownerProducer="USA"> This is the root file for
    the specifications Schematron ruleset. It loads all of the required CVEs, declares some
    variables, and includes all of the Rule .sch files.</sch:p>

  <!-- (U) Abstract Patterns -->

  <sch:include href="Lib/ValidateValueExistenceInList.sch"/>
  <sch:include href="Lib/ValidateEmbeddedValueExistenceinList.sch"/>
  <sch:include href="Lib/ValidateTokenValuesExistenceInList.sch"/>
  <sch:include href="Lib/ValidateTokenValuesExistInNamespaceList.sch"/>
  <sch:include href="Lib/ValidateValidationEnvCVE.sch"/>
  <sch:include href="Lib/ValidateValidationEnvSchema.sch"/>

  <!-- (U) Functions -->
  <xsl:function xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                 name="util:substring-before-last">
      <xsl:param name="input" as="xs:string?"/>
      <xsl:param name="delimiter" as="xs:string"/>
      <xsl:value-of select="codepoints-to-string(reverse(string-to-codepoints(substring-after(codepoints-to-string(reverse(string-to-codepoints($input))), $delimiter))))"/>
  </xsl:function>

  <xsl:function xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                 name="util:existInTokenSet"
                 as="xs:boolean">
      <xsl:param name="stringTokenValue"/>
      <xsl:param name="tokenList" as="xs:string*"/>
      <xsl:value-of select="tokenize($stringTokenValue, ' ') = $tokenList"/>
  </xsl:function>

  <!-- (U) Resources  -->
  <sch:let name="certificateAuthorityList"
            value="document('../../CVE/UIAS/CVEnumUIASCertificateAuthority.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>
  <sch:let name="clearanceList"
            value="document('../../CVE/UIAS/CVEnumUIASClearance.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>
  <sch:let name="entityTypeList"
            value="document('../../CVE/UIAS/CVEnumUIASEntityType.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>
  <sch:let name="personEntityList"
            value="document('../../CVE/UIAS/CVEnumUIASPersonEntityType.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>
  <sch:let name="nonPersonEntityList"
            value="document('../../CVE/UIAS/CVEnumUIASNonPersonEntityType.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>
  <sch:let name="lifeCycleStatusList"
            value="document('../../CVE/UIAS/CVEnumUIASLifeCycleStatus.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>
  <sch:let name="handlingControlsList"
            value="document('../../CVE/UIAS/CVEnumUIASHandlingControls.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>
  <sch:let name="usAgencyList"
            value="document('../../CVE/USAgency/CVEnumUSAgencyAcronym.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>
  <sch:let name="facList"
            value="document('../../CVE/FAC/CVEnumFineAccessControlType.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>
    <sch:let name="SARSourceAuthorityList"
            value="document('../../CVE/FAC/CVEnumFACSARAuthorities.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>
  <sch:let name="authcatList"
            value="document('../../CVE/AUTHCAT/CVEnumAuthCatType.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>
  <sch:let name="regionList"
            value="document('../../CVE/MN/CVEnumMNRegion.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>
  <sch:let name="topicList"
            value="document('../../CVE/MN/CVEnumMNIssue.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>
  <sch:let name="respEntList"
            value="document('../../CVE/ISMCAT/CVEnumISMCATResponsibleEntity.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>
  <sch:let name="networkList"
            value="document('../../CVE/VIRT/CVEnumVIRTNetworkName.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>
  <sch:let name="dissemList"
            value="document('../../CVE/ISM/CVEnumISMDissem.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>
  <sch:let name="auditRoutingOrgList"
            value="document('../../CVE/USAgency/CVEnumAuditRoutingOrg.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>
  <sch:let name="schemaTypeList"
            value="document('../../CVE/UIAS/CVEnumUIASSchemaType.xml')//cve:CVE/cve:Enumeration/cve:Term"/>
  <sch:let name="roleC2SScopeList"
            value="document('../../CVE/ROLE/CVEnumROLEC2SScope.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>
  <sch:let name="rolePAASScopeList"
            value="document('../../CVE/ROLE/CVEnumROLEPAASScope.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>
  <sch:let name="roleNebulaNamedRoleList"
            value="document('../../CVE/ROLE/CVEnumROLENebulaNamedRole.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>
  <sch:let name="roleEnterpriseRoleList"
            value="document('../../CVE/ROLE/CVEnumROLEEnterpriseRole.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>
  <sch:let name="roleNameSpaceList"
            value="document('../../CVE/ROLE/CVEnumROLENamespace.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>
  <sch:let name="roleC2SFunctionList"
            value="document('../../CVE/ROLE/CVEnumROLEC2SFunction.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>
  <sch:let name="rolePAASFunctionList"
            value="document('../../CVE/ROLE/CVEnumROLEPAASFunction.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>

   <!--****************************-->
<!-- (U) UIAS Phases -->
<!--****************************-->
<!--****************************-->
<!-- (U) UIAS ID Rules -->
<!--****************************-->

<!--(U) -->
   <sch:include href="./Rules/UIAS_ID_00001.sch"/>
   <sch:include href="./Rules/UIAS_ID_00004.sch"/>
   <sch:include href="./Rules/UIAS_ID_00005.sch"/>
   <sch:include href="./Rules/UIAS_ID_00006.sch"/>
   <sch:include href="./Rules/UIAS_ID_00007.sch"/>
   <sch:include href="./Rules/UIAS_ID_00008.sch"/>
   <sch:include href="./Rules/UIAS_ID_00009.sch"/>
   <sch:include href="./Rules/UIAS_ID_00011.sch"/>
   <sch:include href="./Rules/UIAS_ID_00012.sch"/>
   <sch:include href="./Rules/UIAS_ID_00014.sch"/>
   <sch:include href="./Rules/UIAS_ID_00016.sch"/>
   <sch:include href="./Rules/UIAS_ID_00019.sch"/>
   <sch:include href="./Rules/UIAS_ID_00021.sch"/>
   <sch:include href="./Rules/UIAS_ID_00022.sch"/>
   <sch:include href="./Rules/UIAS_ID_00023.sch"/>
   <sch:include href="./Rules/UIAS_ID_00024.sch"/>
   <sch:include href="./Rules/UIAS_ID_00025.sch"/>
   <sch:include href="./Rules/UIAS_ID_00026.sch"/>
   <sch:include href="./Rules/UIAS_ID_00028.sch"/>
   <sch:include href="./Rules/UIAS_ID_00030.sch"/>
   <sch:include href="./Rules/UIAS_ID_00036.sch"/>
   <sch:include href="./Rules/UIAS_ID_00047.sch"/>
   <sch:include href="./Rules/UIAS_ID_00050.sch"/>
   <sch:include href="./Rules/UIAS_ID_00051.sch"/>
   <sch:include href="./Rules/UIAS_ID_00052.sch"/>
   <sch:include href="./Rules/UIAS_ID_00053.sch"/>
   <sch:include href="./Rules/UIAS_ID_00056.sch"/>
   <sch:include href="./Rules/UIAS_ID_00057.sch"/>
   <sch:include href="./Rules/UIAS_ID_00065.sch"/>
   <sch:include href="./Rules/UIAS_ID_00066.sch"/>
   <sch:include href="./Rules/UIAS_ID_00067.sch"/>
   <sch:include href="./Rules/UIAS_ID_00068.sch"/>
   <sch:include href="./Rules/UIAS_ID_00069.sch"/>
   <sch:include href="./Rules/UIAS_ID_00070.sch"/>
   <sch:include href="./Rules/UIAS_ID_00071.sch"/>
   <sch:include href="./Rules/UIAS_ID_00072.sch"/>
   <sch:include href="./Rules/UIAS_ID_00073.sch"/>
   <sch:include href="./Rules/UIAS_ID_00074.sch"/>
   <sch:include href="./Rules/UIAS_ID_00075.sch"/>
   <sch:include href="./Rules/UIAS_ID_00076.sch"/>
   <sch:include href="./Rules/UIAS_ID_00077.sch"/>
   <sch:include href="./Rules/UIAS_ID_00078.sch"/>
   <sch:include href="./Rules/UIAS_ID_00079.sch"/>
   <sch:include href="./Rules/UIAS_ID_00080.sch"/>
   <sch:include href="./Rules/UIAS_ID_00081.sch"/>

   <!--****************************-->
<!-- (U) UIAS Phases -->
<!--****************************--><!--(U) Phase: Non-infrastructure-->
   <sch:phase id="NON_INFRASTRUCTURE">
      <sch:active pattern="UIAS-ID-00081"/>
   </sch:phase>

   <!--(U) Phase: VALUECHECK-->
   <sch:phase id="VALUECHECK">
      <sch:active pattern="UIAS-ID-00081"/>
   </sch:phase>
</sch:schema>
<!--UNCLASSIFIED-->
