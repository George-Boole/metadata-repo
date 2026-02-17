<?xml version="1.0" encoding="UTF-8"?>
<!--UNCLASSIFIED--><?ICEA master?><!-- Distribution Notice:
            This document is being made available by the Intelligence Community Chief Information Officer
            to Federal, State, Local, Tribal, and Foreign Partners and associated contractors. Approval for
            any further distribution must be coordinated via the Intelligence Community Chief Information 
            Officer, at ic-standards-support@iarpa.gov. -->
<!-- WARNING: 
    Once compiled into an XSLT the result will 
    be the aggregate classification of all the CVES 
    and included .sch files
-->
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
   <sch:ns uri="urn:us:gov:ic:ism" prefix="ism"/>
   <sch:ns uri="urn:us:gov:ic:ntk" prefix="ntk"/>
   <sch:ns uri="urn:us:gov:ic:taxonomy:catt:tetragraph" prefix="catt"/>
   <sch:ns uri="urn:us:gov:ic:cve" prefix="cve"/>
   <sch:ns uri="deprecated:value:function" prefix="dvf"/>
   <sch:ns uri="urn:us:gov:ic:ism:xsl:util" prefix="util"/>
   <sch:p class="codeDesc">This is the root file for the ISM Schematron rule set. It loads all of
      the required CVEs declares some variables and includes all of the Rule .sch files. </sch:p>

   <!-- (U) Abstract Patterns -->
   <sch:include href="Lib/AttributeContributesToRollup.sch"/>
   <sch:include href="Lib/AttributeContributesToRollupWithException.sch"/>
   <sch:include href="Lib/AttributeContributesToRollupWithClassification.sch"/>
   <sch:include href="Lib/AttributeValueDeprecatedError.sch"/>
   <sch:include href="Lib/AttributeValueDeprecatedWarning.sch"/>
   <sch:include href="Lib/CheckCommonCountries.sch"/>
   <sch:include href="Lib/DataHasCorrespondingNotice.sch"/>
   <sch:include href="Lib/DataHasCorrespondingNoticeWithException.sch"/>
   <sch:include href="Lib/MutuallyExclusiveAttributeValues.sch"/>
   <sch:include href="Lib/NonCompilationDocumentRollup.sch"/>
   <sch:include href="Lib/NoticeHasCorrespondingData.sch"/>
   <sch:include href="Lib/NoticeHasCorrespondingDataUnclassDoc.sch"/>
   <sch:include href="Lib/NtkHasCorrespondingData.sch"/>
   <sch:include href="Lib/TypeConstraintPatterns.sch"/>
   <sch:include href="Lib/ValidateValueExistenceInList.sch"/>
   <sch:include href="Lib/ValidateTokenValuesExistenceInList.sch"/>
   <sch:include href="Lib/ValidateTokenValuesExistenceInListWhenContributesToRollup.sch"/>
   <sch:include href="Lib/ValidateTokenValuesExistenceInListWhenContributesToRollupACCM.sch"/>
   <sch:include href="Lib/ValuesOrderedAccordingToCve.sch"/>
   <sch:include href="Lib/ValuesOrderedAccordingToCveWhenContributesToRollup.sch"/>
   <sch:include href="Lib/ValuesOrderedAccordingToCveWhenContributesToRollupACCM.sch"/>

   <!-- (U) Resources  -->
   <sch:let name="countriesList"
            value="document('../../CVE/ISMCAT/CVEnumISMCATOwnerProducer.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>
   <sch:let name="classificationAllList"
            value="document('../../CVE/ISM/CVEnumISMClassificationAll.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>
   <sch:let name="classificationUSList"
            value="document('../../CVE/ISM/CVEnumISMClassificationUS.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>
   <sch:let name="ownerProducerList"
            value="document('../../CVE/ISMCAT/CVEnumISMCATOwnerProducer.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>
   <sch:let name="declassExceptionList"
            value="document('../../CVE/ISM/CVEnumISM25X.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>
   <sch:let name="FGIsourceOpenList"
            value="document('../../CVE/ISMCAT/CVEnumISMCATFGIOpen.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>
   <sch:let name="FGIsourceProtectedList"
            value="document('../../CVE/ISMCAT/CVEnumISMCATFGIProtected.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>
   <sch:let name="nonICmarkingsList"
            value="document('../../CVE/ISM/CVEnumISMNonIC.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>
   <sch:let name="releasableToList"
            value="document('../../CVE/ISMCAT/CVEnumISMCATRelTo.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>
   <sch:let name="SCIcontrolsList"
            value="document('../../CVE/ISM/CVEnumISMSCIControls.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>
   <sch:let name="SARIdentifierList"
            value="document('../../CVE/ISM/CVEnumISMSAR.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>
   <sch:let name="validAttributeList"
            value="document('../../CVE/ISM/CVEnumISMAttributes.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>
   <sch:let name="validElementList"
            value="document('../../CVE/ISM/CVEnumISMElements.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>
   <sch:let name="noticeList"
            value="document('../../CVE/ISM/CVEnumISMNotice.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>
   <sch:let name="nonUSControlsList"
            value="document('../../CVE/ISM/CVEnumISMNonUSControls.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>
   <sch:let name="exemptFromList"
            value="document('../../CVE/ISM/CVEnumISMExemptFrom.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>
   <sch:let name="atomicEnergyMarkingsList"
            value="document('../../CVE/ISM/CVEnumISMAtomicEnergyMarkings.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>
   <sch:let name="displayOnlyToList"
            value="document('../../CVE/ISMCAT/CVEnumISMCATRelTo.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>
   <sch:let name="pocTypeList"
            value="document('../../CVE/ISM/CVEnumISMPocType.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>
   <sch:let name="compliesWithList"
            value="document('../../CVE/ISM/CVEnumISMCompliesWith.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>

   <!-- ISMCAT Dependencies -->
   <sch:let name="catRaw"
            value="document('../../Taxonomy/ISMCAT/TetragraphTaxonomy.xml')"/>
   
   <sch:let name="catt"
            value="document('../../Taxonomy/ISMCAT/TetragraphTaxonomyDenormalized.xml')"/>
   
   <sch:let name="cattMappings" value="$catt//catt:Tetragraph"/>
   <sch:let name="tetragraphList"
            value="document('../../CVE/ISMCAT/CVEnumISMCATTetragraph.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>


   <!-- Grab all of the distinct groupsing of  @ism:ownerProducer, @ism:releasableTo, @ism:displayOnlyTo, @ism:FGIsourceOpen, and @ism:FGIsourceProtected
         Then tokenize each of one of the groupings and get the distinct of that set of tokens.-->
   <sch:let name="countriesAndTetras"
            value="distinct-values(for $each in distinct-values((/descendant-or-self::node()//@ism:ownerProducer | /descendant-or-self::node()//@ism:releasableTo | /descendant-or-self::node()//@ism:displayOnlyTo | /descendant-or-self::node()//@ism:FGIsourceOpen | /descendant-or-self::node()//@ism:FGIsourceProtected)) return util:tokenize($each))"/>
   <sch:let name="tetras"
            value="for $value in $countriesAndTetras return if ($catt//catt:Tetragraph[catt:TetraToken=$value]) then $value else null"/>
   
   <sch:let name="catt_new"
            value="for $node in $catt//* return if (local-name($node)='Organization') then 'MEM' else $node"/>


   <!-- (U) Resources that may include FOUO values -->
   <sch:let name="disseminationControlsList"
            value="document('../../CVE/ISM/CVEnumISMDissem.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>

   <!-- ==========================================================================-->
   <!-- (U) Universal Lets                                                        -->
   <!-- ==========================================================================-->

   <!-- ISM_RESOURCE_ELEMENT (node): The first element with attribute ism:resourceElement='true' -->
   <sch:let name="ISM_RESOURCE_ELEMENT"
            value="          (for $each in (//*)          return             if (                                                                               if(string( $each/@ism:resourceElement) castable as xs:boolean)                                                                                    then                                                                                       if($each/@ism:resourceElement = true()) then true() else false()                                                                                    else false())                                                                             then   $each else null)[1]"/>

   <!-- (U) ISM_RESOURCE_CREATE_DATE (date): The date a Resource was created, or the ism:createDate attribute on the
         ISM_RESOURCE_ELEMENT node. -->
   <sch:let name="ISM_RESOURCE_CREATE_DATE"
            value="$ISM_RESOURCE_ELEMENT/@ism:createDate"/>


   <!-- ==========================================================================-->
   <!-- (U) Get Variables for 'Complies With'                                     -->
   <!-- ==========================================================================-->

   <!-- ISM_USGOV_RESOURCE (boolean): True if the compliesWith attribute contains 'USGov' -->
   <sch:let name="ISM_USGOV_RESOURCE"
            value="util:containsAnyOfTheTokens($ISM_RESOURCE_ELEMENT/@ism:compliesWith, ('USGov'))"/>

   <!-- ISM_OTHER_AUTH_RESOURCE (boolean): True if the compliesWith attribute contains 'otherAuth' -->
   <sch:let name="ISM_OTHER_AUTH_RESOURCE"
            value="util:containsAnyOfTheTokens($ISM_RESOURCE_ELEMENT/@ism:compliesWith, ('OtherAuthority'))"/>

   <!-- ISM_USIC_RESOURCE (boolean): True if the compliesWith attribute contains 'USIC' -->
   <sch:let name="ISM_USIC_RESOURCE"
            value="util:containsAnyOfTheTokens($ISM_RESOURCE_ELEMENT/@ism:compliesWith, ('USIC'))"/>

   <!-- ISM_USDOD_RESOURCE (boolean): True if the compliesWith attribute contains 'USDOD' -->
   <sch:let name="ISM_USDOD_RESOURCE"
            value="util:containsAnyOfTheTokens($ISM_RESOURCE_ELEMENT/@ism:compliesWith, ('USDOD'))"/>

   <!-- ==========================================================================-->
   <!-- (U) Get Exemption Variables                                               -->
   <!-- ==========================================================================-->

   <!-- (U) ISM_710_FDR_EXEMPT (boolean): True if the document claims exemption from mandatory 
            Foreign Disclosure and Release markings in ICD-710. False otherwise. -->
   <sch:let name="ISM_710_FDR_EXEMPT"
            value="index-of(tokenize(normalize-space(string($ISM_RESOURCE_ELEMENT/@ism:exemptFrom)), ' '), 'IC_710_MANDATORY_FDR') &gt; 0 or not($ISM_USIC_RESOURCE)"/>

   <!-- (U) ISM_DOD_DISTRO_EXEMPT (boolean): True if the document claims exemption from requirements 
            to have DoD Distribution Statements. False otherwise. -->
   <sch:let name="ISM_DOD_DISTRO_EXEMPT"
            value="index-of(tokenize(normalize-space(string($ISM_RESOURCE_ELEMENT/@ism:exemptFrom)), ' '), 'DOD_DISTRO_STATEMENT') &gt; 0 or not($ISM_USDOD_RESOURCE)"/>

   <!-- (U) ISM_ORCON_POC_DATE (date): The date after which a point-of-contact is required for all documents containing ORCON data -->
   <sch:let name="ISM_ORCON_POC_DATE" value="xs:date('2011-03-11')"/>

   <!-- ==========================================================================-->
   <!-- (U) Get Banner Attributes                                                 -->
   <!-- ==========================================================================-->

   <sch:let name="bannerClassification"
            value="normalize-space(string($ISM_RESOURCE_ELEMENT/@ism:classification))"/>
   <sch:let name="bannerDisseminationControls"
            value="normalize-space(string($ISM_RESOURCE_ELEMENT/@ism:disseminationControls))"/>
   <sch:let name="bannerDisplayOnlyTo"
            value="normalize-space(string($ISM_RESOURCE_ELEMENT/@ism:displayOnlyTo))"/>
   <sch:let name="bannerNonICmarkings"
            value="normalize-space(string($ISM_RESOURCE_ELEMENT/@ism:nonICmarkings))"/>
   <sch:let name="bannerFGIsourceOpen"
            value="normalize-space(string($ISM_RESOURCE_ELEMENT/@ism:FGIsourceOpen))"/>
   <sch:let name="bannerFGIsourceProtected"
            value="normalize-space(string($ISM_RESOURCE_ELEMENT/@ism:FGIsourceProtected))"/>
   <sch:let name="bannerReleasableTo"
            value="normalize-space(string($ISM_RESOURCE_ELEMENT/@ism:releasableTo))"/>
   <sch:let name="bannerSCIcontrols"
            value="normalize-space(string($ISM_RESOURCE_ELEMENT/@ism:SCIcontrols))"/>
   <sch:let name="bannerNotice"
            value="normalize-space(string($ISM_RESOURCE_ELEMENT/@ism:noticeType))"/>
   <sch:let name="bannerSARIdentifier"
            value="normalize-space(string($ISM_RESOURCE_ELEMENT/@ism:SARIdentifier))"/>
   <sch:let name="bannerAtomicEnergyMarkings"
            value="normalize-space(string($ISM_RESOURCE_ELEMENT/@ism:atomicEnergyMarkings))"/>

   <!-- ==========================================================================-->
   <!-- (U) Tokenize Banner Attributes                                            -->
   <!-- ==========================================================================-->

   <sch:let name="bannerDisseminationControls_tok"
            value="tokenize(normalize-space(string($bannerDisseminationControls)), ' ')"/>
   <sch:let name="bannerDisplayOnlyTo_tok"
            value="tokenize(normalize-space(string($bannerDisplayOnlyTo)), ' ')"/>
   <sch:let name="bannerNonICmarkings_tok"
            value="tokenize(normalize-space(string($bannerNonICmarkings)), ' ')"/>
   <sch:let name="bannerFGIsourceOpen_tok"
            value="tokenize(normalize-space(string($bannerFGIsourceOpen)), ' ')"/>
   <sch:let name="bannerFGIsourceProtected_tok"
            value="tokenize(normalize-space(string($bannerFGIsourceProtected)), ' ')"/>
   <sch:let name="bannerReleasableTo_tok"
            value="tokenize(normalize-space(string($bannerReleasableTo)), ' ')"/>
   <sch:let name="bannerSCIcontrols_tok"
            value="tokenize(normalize-space(string($bannerSCIcontrols)), ' ')"/>
   <sch:let name="bannerNotice_tok"
            value="tokenize(normalize-space(string($bannerNotice)), ' ')"/>
   <sch:let name="bannerSARIdentifier_tok"
            value="tokenize(normalize-space(string($bannerSARIdentifier)), ' ')"/>
   <sch:let name="bannerAtomicEnergyMarkings_tok"
            value="tokenize(normalize-space(string($bannerAtomicEnergyMarkings)), ' ')"/>

   <!-- ==========================================================================-->
   <!-- (U) Get all portions that meet ISM_CONTRIBUTES, or all non-resource nodes -->
   <!-- that do not specify ism:excludeFromRollup='true' and have an              -->
   <!-- ism:classification.                                                       -->
   <!-- Similar portion classifications include ISM_CONTRIBUTES_CLASSIFIED, or    -->
   <!-- all portions meeting ISM_CONTRIBUTES that also have an ism:classification -->
   <!-- attribute not equal to [U], and ISM_CONTRIBUTES_USA, or all portions      -->
   <!-- meeting ISM_CONTRIBUTES that also have an ism:ownerProducer containing    -->
   <!-- [USA].                                                                    -->
   <!-- ==========================================================================-->
   <sch:let name="partTags"
            value="/descendant-or-self::node()[@ism:classification and util:contributesToRollup(.) and not(generate-id(.) = generate-id($ISM_RESOURCE_ELEMENT))]"/>

   <!-- (U) Get Part Attributes -->
   <sch:let name="partClassification"
            value="          for $token in $partTags/@ism:classification          return             tokenize(normalize-space(string($token)), ' ')"/>
   <sch:let name="partOwnerProducer"
            value="          for $token in $partTags/@ism:ownerProducer          return             tokenize(normalize-space(string($token)), ' ')"/>
   <sch:let name="partDisseminationControls"
            value="          for $token in $partTags/@ism:disseminationControls          return             tokenize(normalize-space(string($token)), ' ')"/>
   <sch:let name="partDisplayOnlyTo"
            value="          for $token in $partTags/@ism:displayOnlyTo          return             tokenize(normalize-space(string($token)), ' ')"/>
   <sch:let name="partAtomicEnergyMarkings"
            value="          for $token in $partTags/@ism:atomicEnergyMarkings          return             tokenize(normalize-space(string($token)), ' ')"/>
   <sch:let name="partNonICmarkings"
            value="          for $token in $partTags/@ism:nonICmarkings          return             tokenize(normalize-space(string($token)), ' ')"/>
   <sch:let name="partFGIsourceOpen"
            value="          for $token in $partTags/@ism:FGIsourceOpen          return             tokenize(normalize-space(string($token)), ' ')"/>
   <sch:let name="partFGIsourceProtected"
            value="          for $token in $partTags/@ism:FGIsourceProtected          return             tokenize(normalize-space(string($token)), ' ')"/>
   <sch:let name="partSCIcontrols"
            value="          for $token in $partTags/@ism:SCIcontrols          return             tokenize(normalize-space(string($token)), ' ')"/>
   <sch:let name="partNoticeType"
            value="          for $token in $partTags/@ism:noticeType          return             tokenize(normalize-space(string($token)), ' ')"/>
   <sch:let name="partSARIdentifier"
            value="          for $token in $partTags/@ism:SARIdentifier          return             tokenize(normalize-space(string($token)), ' ')"/>

   <sch:let name="partPocType"
            value="//*/@ism:pocType[util:contributesToRollup(./parent::node()) and not(generate-id(./parent::node()) = generate-id($ISM_RESOURCE_ELEMENT)) and not(./parent::node()/@ism:externalNotice = true())]"/>

   <!-- (U) Tokenize portion Attributes -->
   <sch:let name="partClassification_tok"
            value="          for $token in $partClassification          return             tokenize(normalize-space(string($token)), ' ')"/>
   <sch:let name="partOwnerProducer_tok"
            value="          for $token in $partOwnerProducer          return             tokenize(normalize-space(string($token)), ' ')"/>
   <sch:let name="partDisseminationControls_tok"
            value="          for $token in $partDisseminationControls          return             tokenize(normalize-space(string($token)), ' ')"/>
   <sch:let name="partDisplayOnlyTo_tok"
            value="          for $token in $partDisplayOnlyTo          return             tokenize(normalize-space(string($token)), ' ')"/>
   <sch:let name="partAtomicEnergyMarkings_tok"
            value="          for $token in $partAtomicEnergyMarkings          return             tokenize(normalize-space(string($token)), ' ')"/>
   <sch:let name="partNonICmarkings_tok"
            value="          for $token in $partNonICmarkings          return             tokenize(normalize-space(string($token)), ' ')"/>
   <sch:let name="partSCIcontrols_tok"
            value="          for $token in $partSCIcontrols          return             tokenize(normalize-space(string($token)), ' ')"/>
   <sch:let name="partNoticeType_tok"
            value="          for $token in $partNoticeType          return             tokenize(normalize-space(string($token)), ' ')"/>
   <sch:let name="partSARIdentifier_tok"
            value="          for $token in $partSARIdentifier          return             tokenize(normalize-space(string($token)), ' ')"/>
   <sch:let name="partPocType_tok"
            value="          for $token in $partPocType          return             tokenize(normalize-space(string($token)), ' ')"/>

   <!-- (U) Tokenize Notice Nodes -->
   <sch:let name="partNoticeNodeType"
            value="          for $token in $partTags/@ism:noticeType          return             tokenize(normalize-space(string($token)), ' ')"/>

   <!-- 
          (U) ISM_NSI_EO_APPLIES (boolean): 
          True if the current Classified National Security Information Executive 
          Order applies to this resource. This variable will be true if all of the following 4 conditions are satisfied:
          1) The document is a ISM_USGOV_RESOURCE
          AND 
          2) The ISM_RESOURCE_ELEMENT node has attribute ism:classification with a value other than [U]
          AND
          3) The ISM_RESOURCE_CREATE_DATE is on or after 11 April 1996  (180 days after 14 October 1995 signature of E.O. 12958)
          AND
          4) At least one element meeting ISM_CONTRIBUTES_CLASSIFIED does not have the attribute ism:atomicEnergyMarkings 
        -->
   <sch:let name="ISM_NSI_EO_APPLIES"
            value="          $ISM_USGOV_RESOURCE and not($ISM_RESOURCE_ELEMENT/@ism:classification = 'U') and $ISM_RESOURCE_CREATE_DATE &gt;= xs:date('1996-04-11') and (some $element in $partTags             satisfies not($element/@ism:classification = 'U') and not($element/@ism:atomicEnergyMarkings))"/>


   <!-- (U) Check roll-up of attributes in portions to the banner   -->
   <sch:let name="dcTags"
            value="          for $piece in $disseminationControlsList          return             $piece/text()"/>
   <sch:let name="dcTagsFound"
            value="          for $token in $dcTags          return             if (index-of($partDisseminationControls_tok, $token) &gt; 0 and (not(index-of($bannerDisseminationControls_tok, $token) &gt; 0))) then                $token             else                null"/>
   <sch:let name="aeaTags"
            value="          for $piece in $atomicEnergyMarkingsList          return             $piece/text()"/>
   <sch:let name="aeaTagsFound"
            value="          for $token in $aeaTags          return             if (index-of($partAtomicEnergyMarkings_tok, $token) &gt; 0 and (not(index-of($bannerAtomicEnergyMarkings_tok, $token) &gt; 0))) then                $token             else                null"/>

   <!-- Regex -->
   <sch:let name="ACCMRegex" value="'^ACCM-[A-Z0-9\-_]{1,61}$'"/>

   <!-- nonACCM values left and right of ACCM values defined in CVEnumISMNonIC.xml -->
   <sch:let name="nonACCMLeftSet" value="'DS'"/>
   <sch:let name="nonACCMRightSet" value="'XD,ND,SBU,SBU-NF,LES,LES-NF,SSI,NNPI'"/>
   <sch:let name="nonACCMLeftSetTok" value="tokenize($nonACCMLeftSet, ',')"/>
   <sch:let name="nonACCMRightSetTok" value="tokenize($nonACCMRightSet, ',')"/>

   <!--****************************-->
   <!-- (U) Custom XSLT functions   -->
   <!--****************************-->

   <!--
    Returns true if the attribute @ism:excludeFromRollup is present and evaluates to 'true'
      -->
   <xsl:function xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                 name="util:contributesToRollup"
                 as="xs:boolean">
      <xsl:param name="context"/>
      <xsl:value-of select="not(string($context/@ism:excludeFromRollup) = string(true()))"/>
   </xsl:function>

   <!-- Evaluate the attribute value tokens to determine whether any values 
            have been deprecated by comparing deprecation dates against $curDate. 
            If the value is deprecated, return either an ERROR or WARNING message, 
            depending on the isError flag. -->
   <xsl:function xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                 name="dvf:deprecated"
                 as="xs:string*">
      <xsl:param name="attribute" as="xs:string"/>
      <xsl:param name="depTerms" as="element()*"/>
      <xsl:param name="curDate" as="xs:date?"/>
      <xsl:param name="isError" as="xs:boolean"/>
      <!--$curDate param is optional in order to prevent compiled XSLT from breaking 
                    when otherwise invalid documents are executed against the rules 
                    (e.g. missing @ism:createDate). 
                    
                    Only execute if there is date to compare against. -->
      <xsl:if test="count($curDate) = 1">
         <xsl:for-each select="$depTerms[cve:Value = tokenize($attribute, ' ')]">
            <xsl:if test="($isError and $curDate gt xs:date(@deprecated)) or (not($isError) and $curDate le xs:date(@deprecated))">
               <xsl:sequence select="concat('[', string(current()/cve:Value), '] has been deprecated and is not authorized for use after  ', current()/@deprecated)"/>
            </xsl:if>
         </xsl:for-each>
      </xsl:if>
   </xsl:function>

   <!--
    Returns true if any token in the attribute value matches one of the provided regular expressions. 
  -->
   <xsl:function xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                 name="util:containsAnyTokenMatching"
                 as="xs:boolean">
      <xsl:param name="attribute"/>
      <xsl:param name="regexList" as="xs:string+"/>
      <xsl:value-of select="             some $attrToken in tokenize(normalize-space(string($attribute)), ' ')                satisfies (some $regex in $regexList                   satisfies matches($attrToken, $regex))"/>
   </xsl:function>

   <!--
    Returns true if any token in the attribute value matches at least one token in the provided list.
  -->
   <xsl:function xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                 name="util:containsAnyOfTheTokens"
                 as="xs:boolean">
      <xsl:param name="attribute"/>
      <xsl:param name="tokenList" as="xs:string*"/>
      <xsl:value-of select="             some $attrToken in tokenize(normalize-space(string($attribute)), ' ')                satisfies $attrToken = $tokenList"/>
   </xsl:function>

   <!--
    Returns true if all token in the attribute value match at least one token in the provided list.
  -->
   <xsl:function xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                 name="util:containsOnlyTheTokens"
                 as="xs:boolean">
      <xsl:param name="attribute"/>
      <xsl:param name="tokenList" as="xs:string*"/>
      <xsl:value-of select="             every $attrToken in tokenize(normalize-space(string($attribute)), ' ')                satisfies $attrToken = $tokenList"/>
   </xsl:function>

   <!--
    Returns true if the token string value matches at least one token in the provided list.
  -->
   <xsl:function xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                 name="util:existInTokenSet"
                 as="xs:boolean">
      <xsl:param name="stringTokenValue"/>
      <xsl:param name="tokenList" as="xs:string*"/>
      <xsl:value-of select="tokenize($stringTokenValue, ' ') = $tokenList"/>
   </xsl:function>

   <!--
        Return a list of values as a space delimited string from a sequence of tokens that only matches the regex
    -->
   <xsl:function xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                 name="util:getStringFromSequenceWithOnlyRegexValues"
                 as="xs:string">
      <xsl:param name="attrValues"/>
      <xsl:param name="regex"/>
      <xsl:variable name="StringWithOnlyRegexValues">
         <xsl:for-each select="$attrValues">
            <!-- if value does match the regex, return that value -->
            <xsl:if test="matches(current(), $regex)">
               <xsl:value-of select="current()"/>
            </xsl:if>
            <xsl:value-of select="' '"/>
         </xsl:for-each>
      </xsl:variable>
      <xsl:value-of select="normalize-space(string($StringWithOnlyRegexValues))"/>
   </xsl:function>

   <!--
        Return a list of values as a space delimited string from a sequence of tokens that filters out anything matching the regex 
    -->
   <xsl:function xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                 name="util:getStringFromSequenceWithoutRegexValues"
                 as="xs:string">
      <xsl:param name="attrValues"/>
      <xsl:param name="regex"/>
      <xsl:variable name="StringWithoutRegexValues">
         <xsl:for-each select="$attrValues">
            <!-- if value does not match the regex, return that value -->
            <xsl:if test="not(matches(current(), $regex))">
               <xsl:value-of select="current()"/>
            </xsl:if>
            <xsl:value-of select="' '"/>
         </xsl:for-each>
      </xsl:variable>
      <xsl:value-of select="normalize-space(string($StringWithoutRegexValues))"/>
   </xsl:function>

   <!--
        Return a list of values as a space delimited string from a sequence of tokens
    -->
   <xsl:function xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                 name="util:getStringFromSequence"
                 as="xs:string">
      <xsl:param name="attrValues"/>
      <xsl:variable name="StringValues">
         <xsl:for-each select="$attrValues">
            <xsl:value-of select="current()"/>
            <xsl:value-of select="' '"/>
         </xsl:for-each>
      </xsl:variable>
      <xsl:value-of select="normalize-space(string($StringValues))"/>
   </xsl:function>

   <!--
        Determines if values in an attribute are in sorted alphabetical order
    -->
   <xsl:function xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                 name="util:nonalphabeticValues"
                 as="xs:string">
      <xsl:param name="attrValues"/>
      <xsl:variable name="badValues">
         <xsl:for-each select="$attrValues">
            <!-- iterate over each attribute value, except the last one because the comparison is i to i+1 so the last one gets incorporated -->
            <xsl:if test="not(index-of($attrValues, current())[last()] = count($attrValues))">
               <!-- compares if current value is greater than next value meaning its out of alphabetical order -->
               <xsl:if test="compare(current(), $attrValues[index-of($attrValues, current()) + 1]) = 1">
                  <xsl:value-of select="$attrValues[index-of($attrValues, current()) + 1]"/>
               </xsl:if>
               <xsl:value-of select="' '"/>
            </xsl:if>
         </xsl:for-each>
      </xsl:variable>
      <xsl:value-of select="normalize-space(string($badValues))"/>
   </xsl:function>

   <!--
        Determines if ACCM values are in the correct relative order to Non ACCMs when nonIC attribute
        is excluded from rollup.
        NOTE: This function only checks the left and right boundaries when transitioning from nonACCM to ACCM and vice versa
        since ACCM to ACCM values and nonACCM to nonACCM values have checks already for value and order validation.
    -->
   <xsl:function xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                 name="util:relativeOrderBetweenACCMAndNonACCMWhenExcludeFromRollup"
                 as="xs:string">
      <xsl:param name="attrValues" as="xs:string*"/>

      <xsl:variable name="badValues">
         <xsl:for-each select="$attrValues">
            <!-- iterate over each attribute value, except the last one because the comparison is i to i+1 so the last one gets incorporated -->
            <xsl:if test="not(index-of($attrValues, current())[last()] = count($attrValues))">
               <!-- Left Boundary Check (current is nonACCM, next is ACCM, current element is NOT from LEFT set, return current element) -->
               <xsl:if test="not(matches(current(), $ACCMRegex)) and matches($attrValues[index-of($attrValues, current()) + 1], $ACCMRegex) and not(util:existInTokenSet(current(), $nonACCMLeftSetTok))">
                  <xsl:value-of select="current()"/>
               </xsl:if>
               <!-- Right Boundary Check (current is ACCM, next is nonACCM, next element is NOT from RIGHT set, return next element) -->
               <xsl:if test="matches(current(), $ACCMRegex) and not(matches($attrValues[index-of($attrValues, current()) + 1], $ACCMRegex)) and not(util:existInTokenSet($attrValues[index-of($attrValues, current()) + 1], $nonACCMRightSetTok))">
                  <xsl:value-of select="$attrValues[index-of($attrValues, current()) + 1]"/>
               </xsl:if>
               <xsl:value-of select="' '"/>
            </xsl:if>
         </xsl:for-each>
      </xsl:variable>
      <xsl:value-of select="normalize-space(string($badValues))"/>
   </xsl:function>

   <!--
        Determines if values in an attribute are in sorted order based on a master list
    -->
   <xsl:function xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                 name="util:unorderedValues"
                 as="xs:string">
      <xsl:param name="attrValues" as="xs:string*"/>
      <xsl:param name="tokenList" as="xs:string*"/>

      <xsl:variable name="badValues">
         <xsl:for-each select="$attrValues">
            <!-- iterate over each attribute value, except the last one because he comparison is i to i+1 so the last one gets incorporated -->
            <xsl:if test="not(index-of($attrValues, current())[last()] = count($attrValues))">

               <!-- calculate the indicies of attrValues[i] and attrValues[i+1] within the TokenList -->
               <xsl:variable name="indexOfValue"
                             select="util:getIndexFromListMatch(current(), $tokenList)"/>
               <xsl:variable name="indexOfNextValue"
                             select="util:getIndexFromListMatch($attrValues[index-of($attrValues, current()) + 1], $tokenList)"/>


               <xsl:choose>
                  <xsl:when test="$indexOfValue = $indexOfNextValue">
                     <!-- if same index in tokenList, make sure that attrValues[i] < attrValues[i+1] -->
                     <!-- this comparison is required because of regular expressions in the list. Two tokens
                                 may have the same index in the list, but then they must be in order between themselves -->
                     <xsl:if test="compare(current(), $attrValues[index-of($attrValues, current()) + 1]) = 1">
                        <xsl:value-of select="$attrValues[index-of($attrValues, current()) + 1]"/>
                     </xsl:if>
                  </xsl:when>
                  <xsl:when test="$indexOfValue &gt; $indexOfNextValue">
                     <!-- if index of i > index of i+1, then i+1 is out of order so return it -->
                     <xsl:value-of select="$attrValues[index-of($attrValues, current()) + 1]"/>
                  </xsl:when>
               </xsl:choose>
               <xsl:value-of select="' '"/>
            </xsl:if>
         </xsl:for-each>
      </xsl:variable>
      <xsl:value-of select="normalize-space(string($badValues))"/>
   </xsl:function>

   <!--
        Determines if values in an attribute are in sorted order based on a master list
    -->
   <xsl:function xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                 name="util:unsortedValues"
                 as="xs:string">
      <xsl:param name="attribute"/>
      <xsl:param name="tokenList" as="xs:string*"/>
      <xsl:variable name="attrValues"
                    select="tokenize(normalize-space(string($attribute)), ' ')"/>

      <xsl:variable name="badValues">
         <xsl:for-each select="$attrValues">
            <!-- iterate over each attribute value, except the last one because he comparison is i to i+1 so the last one gets incorporated -->
            <xsl:if test="not(index-of($attrValues, current())[last()] = count($attrValues))">

               <!-- calculate the indicies of attrValues[i] and attrValues[i+1] within the TokenList -->
               <xsl:variable name="indexOfValue"
                             select="util:getIndexFromListMatch(current(), $tokenList)"/>
               <xsl:variable name="indexOfNextValue"
                             select="util:getIndexFromListMatch($attrValues[index-of($attrValues, current()) + 1], $tokenList)"/>


               <xsl:choose>
                  <xsl:when test="$indexOfValue = $indexOfNextValue">
                     <!-- if same index in tokenList, make sure that attrValues[i] < attrValues[i+1] -->
                     <!-- this comparison is required because of regular expressions in the list. Two tokens
                                 may have the same index in the list, but then they must be in order between themselves -->
                     <xsl:if test="compare(current(), $attrValues[index-of($attrValues, current()) + 1]) = 1">
                        <xsl:value-of select="$attrValues[index-of($attrValues, current()) + 1]"/>
                     </xsl:if>
                  </xsl:when>
                  <xsl:when test="$indexOfValue &gt; $indexOfNextValue">
                     <!-- if index of i > index of i+1, then i+1 is out of order so return it -->
                     <xsl:value-of select="$attrValues[index-of($attrValues, current()) + 1]"/>
                  </xsl:when>
               </xsl:choose>
               <xsl:value-of select="' '"/>
            </xsl:if>
         </xsl:for-each>
      </xsl:variable>
      <xsl:value-of select="normalize-space(string($badValues))"/>
   </xsl:function>


   <!-- Return the index position in the list that matches the value. -1 if no match -->
   <xsl:function xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                 name="util:getIndexFromListMatch"
                 as="xs:integer">
      <xsl:param name="value" as="xs:string"/>
      <xsl:param name="list" as="xs:string*"/>

      <xsl:variable name="index">
         <xsl:for-each select="$list">
            <xsl:if test="matches($value, concat('^', current(), '$'))">
               <xsl:value-of select="index-of($list, current())[1]"/>
            </xsl:if>
         </xsl:for-each>
      </xsl:variable>

      <xsl:choose>
         <xsl:when test="$index = ''">
            <xsl:value-of select="-1"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="number($index[1])"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:function>

   <!--
     Returns true if the value match the provided regular expressions. 
   -->
   <xsl:function xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                 name="util:meetsType"
                 as="xs:boolean">
      <xsl:param name="value"/>
      <xsl:param name="typePattern" as="xs:string"/>
      <xsl:value-of select="matches(normalize-space(string($value)), concat('^(', $typePattern, ')$'))"/>
   </xsl:function>

   <!-- *************************************************************************************************************** -->
   <!-- ******** ADDED 2016-03-29 by CIA/DDI/ADO/DSSG/DAI/DAS -->
   <!-- Helper functions for implementing new common country functions for ISM-ID-00318 & ISM-ID-00320 -->
   <sch:let name="decomposableTetraElems"
            value="$cattMappings[@decomposable[. = 'Yes']]"/>
   <sch:let name="decomposableTetras"
            value="$decomposableTetraElems/catt:TetraToken/text()"/>

   <!-- Returns the sequence of country codes that correspond to the given $tetra -->
   <xsl:function xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                 name="util:getCountriesForTetra"
                 as="xs:string*">
      <xsl:param name="tetra" as="xs:string"/>

      <xsl:sequence select="$decomposableTetraElems[catt:TetraToken/text() = $tetra]/catt:Membership/catt:Country/text()"/>
   </xsl:function>

   <!-- Returns normalized $value with a preceding and subsequent space (' ') character -->
   <xsl:function xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                 name="util:padValue"
                 as="xs:string">
      <xsl:param name="value" as="xs:string?"/>

      <xsl:value-of select="concat(' ', normalize-space($value), ' ')"/>
   </xsl:function>

   <!-- Returns the given $value with its values broken into tokens using whitespace as delimiters -->
   <xsl:function xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                 name="util:tokenize"
                 as="xs:string*">
      <xsl:param name="value" as="xs:string?"/>

      <xsl:sequence select="tokenize(normalize-space($value), ' ')"/>
   </xsl:function>

   <!-- Returns the given sequence of $values joined into a normalized single string  -->
   <xsl:function xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                 name="util:join"
                 as="xs:string">
      <xsl:param name="values" as="xs:string*"/>

      <xsl:sequence select="normalize-space(string-join($values, ' '))"/>
   </xsl:function>

   <!-- Returns the given sequence of $values sorted alphabetically -->
   <xsl:function xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                 name="util:sort"
                 as="xs:string*">
      <xsl:param name="values" as="xs:string*"/>

      <xsl:variable name="sortedValues">
         <xsl:for-each select="$values">
            <xsl:sort select="."/>
            <xsl:value-of select="util:padValue(.)"/>
         </xsl:for-each>
      </xsl:variable>

      <xsl:sequence select="util:tokenize($sortedValues)"/>
   </xsl:function>

   <!-- Returns the number of occurrences of $value in the given sequence of $expandedRelToStrings. 
        Counts are pre-calculated in $countryHash, so this function matches the counts in $countryHash 
        to the expanded countries in $expandedRelToStrings -->
   <xsl:function xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                 name="util:countIn"
                 as="xs:double">
      <xsl:param name="value" as="xs:string"/>
      <xsl:param name="expandedRelToStrings" as="xs:string*"/>
      <xsl:param name="countryHash" as="item()*"/>

      <xsl:variable name="counts" as="xs:integer*">
         <xsl:for-each select="$expandedRelToStrings">
            <xsl:if test="util:containsAnyOfTheTokens(., $value)">
               <!-- If expanded RelTo string contains target country, return its original count from countryHash -->
               <xsl:variable name="expandedPosition" select="position()"/>
               <xsl:sequence select="$countryHash[position() = $expandedPosition * 2]"/>
            </xsl:if>
         </xsl:for-each>
      </xsl:variable>

      <xsl:sequence select="sum($counts)"/>
   </xsl:function>

   <!-- Returns true if all tokens in $subset sequence are also present in $superset sequence -->
   <xsl:function xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                 name="util:isSubsetOf"
                 as="xs:boolean">
      <xsl:param name="subset" as="xs:string*"/>
      <xsl:param name="superset" as="xs:string*"/>

      <xsl:sequence select="             (every $subsetToken in $subset                satisfies $subsetToken = $superset)"/>
   </xsl:function>

   <!-- Returns true if the given $relTo string (e.g. 'USA CAN GBR') contains any 
        tetragraphs that can be decomposed into its constituent countries  -->
   <xsl:function xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                 name="util:containsDecomposableTetra"
                 as="xs:boolean">
      <xsl:param name="relTo" as="xs:string?"/>

      <xsl:sequence select="normalize-space($relTo) and util:containsAnyOfTheTokens($relTo, $decomposableTetras)"/>
   </xsl:function>

   <!-- Given a sequence of $relToStrings (e.g. ('USA CAN GBR', 'USA AUS SPAA')), returns a set of tokens 
        that are each of these $relToStrings decomposed using util:expandDecomposableTetras() -->
   <xsl:function xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                 name="util:expandAllTetras"
                 as="xs:string*">
      <xsl:param name="relToStrings" as="xs:string*"/>

      <xsl:variable name="allTokens" as="xs:string*">
         <xsl:for-each select="$relToStrings">
            <xsl:variable name="expandedCountryTokens" select="util:expandDecomposableTetras(.)"/>
            <xsl:value-of select="util:padValue(util:join($expandedCountryTokens))"/>
         </xsl:for-each>
      </xsl:variable>

      <xsl:sequence select="$allTokens"/>
   </xsl:function>

   <!-- Recursively remove all decomposable tetragraphs in the given $relTo string 
        and replace them with their constituent countries. Note: Does not include USA -->
   <xsl:function xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                 name="util:expandDecomposableTetras"
                 as="xs:string*">
      <xsl:param name="relTo" as="xs:string"/>

      <xsl:variable name="expandedTetras">
         <xsl:choose>
            <xsl:when test="util:containsDecomposableTetra($relTo)">
               <xsl:variable name="currTetra"
                             select="util:tokenize($relTo)[. = $decomposableTetras][1]"/>
               <xsl:variable name="currTetraCountries"
                             select="util:join(util:getCountriesForTetra($currTetra))"/>
               <xsl:variable name="expandCurrTetra"
                             select="replace(util:padValue($relTo), util:padValue($currTetra), util:padValue($currTetraCountries))"/>

               <xsl:value-of select="util:expandDecomposableTetras($expandCurrTetra)"/>
            </xsl:when>

            <xsl:otherwise>
               <xsl:value-of select="normalize-space($relTo)"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>

      <xsl:sequence select="distinct-values(util:tokenize($expandedTetras))[. != 'USA']"/>
   </xsl:function>

   <!-- Given the sequence of $relToStrings (e.g. ('USA CAN GBR', 'USA AUS ZWE', 'USA CAN GBR')), returns 
         a sequence of unique strings and their counts, (e.g. ('USA CAN GBR', 2, 'USA AUS ZWE', 1) -->
   <xsl:function xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                 name="util:createCountryHash"
                 as="item()*">
      <xsl:param name="relToStrings" as="xs:string*"/>

      <xsl:for-each-group select="$relToStrings" group-by=".">
         <xsl:sequence select="current-grouping-key(), count(current-group())"/>
      </xsl:for-each-group>
   </xsl:function>

   <!-- Return the sequence of countries that form the intersection of common countries on all FD&R portions.
        Note: Does not include USA -->
   <xsl:function xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                 name="util:calculateCommonCountries"
                 as="xs:string*">
      <xsl:param name="portionCountryStrings" as="xs:string*"/>

      <!-- Create "hash" of each RelTo string and the number of occurrences in the document -->
      <xsl:variable name="countryHash"
                    select="util:createCountryHash($portionCountryStrings)"/>

      <!-- Expand tetragraphs in portion RelTo strings to get distinct countries -->
      <xsl:variable name="expandedTetras"
                    select="util:expandAllTetras($countryHash[position() mod 2 = 1])"/>
      <xsl:variable name="distinctCountryTokens"
                    select="distinct-values(util:tokenize(util:join($expandedTetras)))[. != 'USA']"/>

      <!-- Return country values that appear on every portion w/ FD&R markings -->
      <xsl:sequence select="$distinctCountryTokens[util:countIn(., $expandedTetras, $countryHash) = $countFdrPortions]"/>
   </xsl:function>

   <sch:let name="countFdrPortions" value="count($partTags[util:containsFDR(.)])"/>

   <sch:let name="relToCalculatedBannerTokens"
            value="util:calculateCommonCountries($partTags/@ism:releasableTo)"/>
   <sch:let name="relToActualBannerTokens"
            value="util:expandDecomposableTetras($ISM_RESOURCE_ELEMENT/@ism:releasableTo)"/>

   <sch:let name="displayToCalculatedBannerTokens"
            value="util:calculateCommonCountries(($partTags/@ism:releasableTo, $partTags/@ism:displayOnlyTo))"/>
   <sch:let name="displayToActualBannerTokens"
            value="util:expandDecomposableTetras(util:join(($ISM_RESOURCE_ELEMENT/@ism:releasableTo, $ISM_RESOURCE_ELEMENT/@ism:displayOnlyTo)))"/>

   <!-- Functions to support FD&R roll-up constraints -->

   <!-- if input is a tetragraph and decomposable, return countries that belong to it -->
   <xsl:function xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                 name="util:decomposeTetragraphs"
                 as="xs:string*">
      <xsl:param name="releasableTo" as="xs:string"/>
      <xsl:value-of select="             for $token in tokenize(normalize-space($releasableTo), ' ')             return                if (util:isTetragraph($token)) then                   util:getTetragraphMembership($token)                else                   $token"/>
   </xsl:function>

   <!-- Returns true if the input is a tetragraph -->
   <xsl:function xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                 name="util:isTetragraph"
                 as="xs:boolean">
      <xsl:param name="value" as="xs:string"/>

      <xsl:value-of select="             some $token in $tetragraphList                satisfies $token = $value"/>
   </xsl:function>


   <!-- Returns true if the input contains any tetragraph that is not decomposable -->
   <xsl:function xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                 name="util:containsSpecialTetra"
                 as="xs:boolean">
      <xsl:param name="releasableTo" as="xs:string"/>
      <!-- may need to change @decomposable to @catt:decomposable because there is a bug in the schema. -->
      <xsl:value-of select="             some $token in tokenize(normalize-space($releasableTo), ' ')                satisfies util:isTetragraph($token) and $catt//catt:Tetragraph[catt:TetraToken = $token]/@decomposable[not(. = 'Yes' or . = 'Maybe')]"/>
   </xsl:function>

   <!-- Return true if the input contains any tetragraph where decomposable is "Maybe" -->
   <xsl:function xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                 name="util:containsMaybeTetra"
                 as="xs:boolean">
      <xsl:param name="releasableTo" as="xs:string"/>
      <xsl:value-of select="             some $token in tokenize(normalize-space($releasableTo), ' ')                satisfies util:isTetragraph($token) and $catt//catt:Tetragraph[catt:TetraToken = $token]/@decomposable[. = 'Maybe']"/>
   </xsl:function>

   <xsl:function xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                 name="util:relToContainsMaybeTetra"
                 as="xs:boolean">
      <xsl:param name="bannerRelTo" as="xs:string"/>
      <xsl:param name="remainingPartTags" as="node()*"/>

      <xsl:variable name="portion" select="$remainingPartTags[1]"/>

      <xsl:choose>
         <xsl:when test="count($remainingPartTags) = 0">
            <!-- base case, no more portions to look at, must not be any maybes -->
            <xsl:value-of select="false()"/>
         </xsl:when>
         <xsl:when test="$bannerRelTo and util:containsMaybeTetra($bannerRelTo)">
            <xsl:value-of select="true()"/>
         </xsl:when>
         <xsl:when test="$portion/@ism:releasableTo and util:containsMaybeTetra($portion/@ism:releasableTo)">
            <xsl:value-of select="true()"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="util:relToContainsMaybeTetraHelper($bannerRelTo, subsequence($remainingPartTags, 2))"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:function>

   <!-- convenience function for iterating to the next portion and updating the common countries list -->
   <xsl:function xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                 name="util:relToContainsMaybeTetraHelper"
                 as="xs:string*">
      <xsl:param name="bannerRelTo" as="xs:string"/>
      <xsl:param name="remainingPartTags" as="node()*"/>

      <xsl:variable name="portion" select="$remainingPartTags[1]"/>

      <xsl:choose>
         <xsl:when test="count($remainingPartTags) = 1">
            <!-- This is checking the last item in the list, give empty list to kill recursion -->
            <xsl:value-of select="util:relToContainsMaybeTetra($bannerRelTo, ())"/>
         </xsl:when>
         <xsl:otherwise>
            <!-- remove the first portion in the list (the one just checked) -->
            <xsl:value-of select="util:relToContainsMaybeTetra($bannerRelTo, subsequence($remainingPartTags, 2))"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:function>

   <xsl:function xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                 name="util:displayToContainsMaybeTetra"
                 as="xs:boolean">
      <xsl:param name="bannerDisplayTo" as="xs:string"/>
      <xsl:param name="remainingPartTags" as="node()*"/>

      <xsl:variable name="portion" select="$remainingPartTags[1]"/>

      <xsl:choose>
         <xsl:when test="count($remainingPartTags) = 0">
            <!-- base case, no more portions to look at, must not be any maybes -->
            <xsl:value-of select="false()"/>
         </xsl:when>
         <xsl:when test="$bannerDisplayTo and util:containsMaybeTetra($bannerDisplayTo)">
            <xsl:value-of select="true()"/>
         </xsl:when>
         <xsl:when test="$portion/@ism:displayOnlyTo and util:containsMaybeTetra($portion/@ism:displayOnlyTo)">
            <xsl:value-of select="true()"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="util:displayToContainsMaybeTetra($bannerDisplayTo, subsequence($remainingPartTags, 2))"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:function>

   <!-- convenience function for iterating to the next portion and updating the common countries list -->
   <xsl:function xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                 name="util:displayToContainsMaybeTetraHelper"
                 as="xs:string*">
      <xsl:param name="bannerDisplayTo" as="xs:string"/>
      <xsl:param name="remainingPartTags" as="node()*"/>

      <xsl:variable name="portion" select="$remainingPartTags[1]"/>

      <xsl:choose>
         <xsl:when test="count($remainingPartTags) = 1">
            <!-- Checking the last item in the list, give empty list to kill recursion -->
            <xsl:value-of select="util:displayToContainsMaybeTetra($bannerDisplayTo, ())"/>
         </xsl:when>
         <xsl:otherwise>
            <!-- remove the first portion in the list (the one just checked) -->
            <xsl:value-of select="util:displayToContainsMaybeTetra($bannerDisplayTo, subsequence($remainingPartTags, 2))"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:function>

   <!-- Accepts the banner and portion @ism:releasableTo, decomposes them and   
        Returns true if the banner contains a special tetragraph OR  
        every token in the banner (except USA) is also in the portion; false otherwise -->
   <xsl:function xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                 name="util:bannerIsSubset"
                 as="xs:boolean">
      <xsl:param name="bannerRelTo" as="xs:string"/>
      <xsl:param name="portionRelTo" as="xs:string"/>
      <xsl:variable name="bannerRelToDecomposed"
                    select="tokenize(normalize-space(util:decomposeTetragraphs($bannerRelTo)), ' ')"/>
      <xsl:variable name="portionRelToDecomposed"
                    select="tokenize(normalize-space(util:decomposeTetragraphs($portionRelTo)), ' ')"/>
      <xsl:value-of select="             util:containsSpecialTetra($bannerRelTo) or (every $bannerToken in $bannerRelToDecomposed                satisfies (some $portionToken in $portionRelToDecomposed                   satisfies if ($bannerToken = 'USA') then                      true()                   else                      $bannerToken = $portionToken))"/>
   </xsl:function>

   <!--
        Accepts an element.
        Returns true if the element contains any Foreign Disclosure & Release (FD&R) markings; false otherwise.
    -->
   <xsl:function xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                 name="util:containsFDR"
                 as="xs:boolean">
      <xsl:param name="elementNode" as="node()"/>
      <xsl:value-of select="$elementNode/@ism:releasableTo or $elementNode/@ism:displayOnlyTo or util:containsAnyOfTheTokens($elementNode/@ism:disseminationControls, ('NF', 'RELIDO')) or util:containsAnyOfTheTokens($elementNode/@ism:nonICmarkings, ('LES-NF', 'SBU-NF'))"/>
   </xsl:function>

   <!-- Returns all of the tokens (except USA) in the first list that are also in the second list. -->
   <xsl:function xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                 name="util:intersectionOfCountries"
                 as="xs:string*">
      <xsl:param name="commonCountries" as="xs:string"/>
      <xsl:param name="portionRelTo" as="xs:string"/>
      <xsl:variable name="portionRelToDecomposed"
                    select="tokenize(normalize-space(util:decomposeTetragraphs($portionRelTo)), ' ')"/>
      <xsl:value-of select="             for $token in tokenize(normalize-space($commonCountries), ' ')             return                if ($token = $portionRelToDecomposed and not($token = 'USA')) then                   $token                else                   ()"/>
   </xsl:function>

   <!-- Recursively iterates over the contributing portions in a document and makes sure that the releasability markings
    are consistent with the banner. Returns the list of common countries if no portion fails constraint checking -->
   <xsl:function xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                 name="util:recursivelyCheckRelTo"
                 as="xs:string*">
      <xsl:param name="bannerRelTo" as="xs:string"/>
      <xsl:param name="commonCountries" as="xs:string"/>
      <xsl:param name="remainingPartTags" as="node()*"/>

      <xsl:variable name="portion" select="$remainingPartTags[1]"/>

      <xsl:choose>
         <xsl:when test="count(tokenize($commonCountries, ' ')) = 0">
            <!-- base case, if commonCountries is the empty set, then there 
                    is no common country to release to and the document is NF -->
            <xsl:value-of select="()"/>
         </xsl:when>
         <xsl:when test="count($remainingPartTags) = 0">
            <!-- base case, no more portions to look at, return commonCountries -->
            <xsl:value-of select="$commonCountries"/>
         </xsl:when>
         <xsl:when test="not(util:containsFDR($portion)) and $portion/@ism:classification = 'U'">
            <!-- normal unclass portion without FRD markings does not impact releasability, iterate over this portion -->
            <xsl:value-of select="util:recursivelyCheckRelTo($bannerRelTo, $commonCountries, subsequence($remainingPartTags, 2))"/>
         </xsl:when>
         <xsl:when test="not($portion/@ism:releasableTo)">
            <!-- this portion contributes and is not releasable, so it means there are no common countries -->
            <xsl:value-of select="()"/>
         </xsl:when>
         <xsl:when test="util:containsSpecialTetra($portion/@ism:releasableTo)">
            <!-- this portion has special tetras. This function cannot handle special tetras, so iterate over this portion -->
            <xsl:value-of select="util:recursivelyCheckRelTo($bannerRelTo, $commonCountries, subsequence($remainingPartTags, 2))"/>
         </xsl:when>
         <xsl:otherwise>
            <!-- this portion has no special tetras, check it -->
            <xsl:choose>
               <xsl:when test="util:bannerIsSubset($bannerRelTo, $portion/@ism:releasableTo)">
                  <!-- banner releasableTo is correctly a subset of this portion releasableTo, iterate to next portion -->
                  <xsl:value-of select="util:recursivelyCheckRelToRecurseHelper($bannerRelTo, $commonCountries, $remainingPartTags)"/>
               </xsl:when>
               <xsl:otherwise>
                  <!-- banner says releasableTo a country that this portion is not releasableTo, so it is wrong -->
                  <xsl:value-of select="('BANNER_NOT_A_SUBSET_OF_A_PORTION')"/>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:function>

   <!-- convenience function for iterating to the next portion and updating the common countries list -->
   <xsl:function xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                 name="util:recursivelyCheckRelToRecurseHelper"
                 as="xs:string*">
      <xsl:param name="bannerRelTo" as="xs:string"/>
      <xsl:param name="commonCountries" as="xs:string"/>
      <xsl:param name="remainingPartTags" as="node()*"/>

      <xsl:variable name="portion" select="$remainingPartTags[1]"/>

      <xsl:choose>
         <xsl:when test="count($remainingPartTags) = 1">
            <!-- Checking the last item in the list, give empty list to kill recursion -->
            <xsl:value-of select="util:recursivelyCheckRelTo($bannerRelTo, util:intersectionOfCountries($commonCountries, $portion/@ism:releasableTo), ())"/>
         </xsl:when>
         <xsl:otherwise>
            <!-- remove the first portion in the list (the one just checked) -->
            <xsl:value-of select="util:recursivelyCheckRelTo($bannerRelTo, util:intersectionOfCountries($commonCountries, $portion/@ism:releasableTo), subsequence($remainingPartTags, 2))"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:function>

   <!-- 
    Returns true if the element is uncaveated and has no Foreign Disclosure or Release markings.
  -->
   <xsl:function xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                 name="util:isUncaveatedAndNoFDR"
                 as="xs:boolean">
      <xsl:param name="element"/>
      <xsl:value-of select="not($element/@ism:disseminationControls) and not($element/@ism:SCIcontrols) and not($element/@ism:nonICmarkings) and not($element/@ism:atomicEnergyMarkings) and not($element/@ism:FGIsourceOpen) and not($element/@ism:FGIsourceProtected) and not($element/@ism:nonUSControls) and not($element/@ism:SARIdentifier)"/>
   </xsl:function>

   <!-- The function that should be called from schematron rules.
        This function iterates through the portions until it gets to a portion 
        that has @ism:releasableTo and does not contain a special tetra in @ism:releasableTo.
        It uses the countries in @ism:releasableTo from that portion as the initial common 
        countries list for the recursive function. 
    -->
   <xsl:function xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                 name="util:checkRelToPortionsAgainstBannerAndGetCommonCountries"
                 as="xs:string*">
      <xsl:param name="bannerRelTo" as="xs:string"/>
      <xsl:param name="remainingPartTags" as="node()*"/>

      <xsl:variable name="portion" select="$remainingPartTags[1]"/>

      <xsl:choose>
         <xsl:when test="count($remainingPartTags) = 0">
            <!-- no portions provided, so choose either: had no portions to begin with OR no portion had a special tetra -->
            <xsl:value-of select="('PASS')"/>
         </xsl:when>
         <xsl:when test="util:containsFDR($portion) and not($portion/@ism:releasableTo)">
            <!-- this portion contributes, contains FD&R markings, and is not releasable so the commonCountry set is empty -->

            <xsl:value-of select="()"/>
         </xsl:when>
         <xsl:when test="$portion/@ism:releasableTo and not(util:containsSpecialTetra($portion/@ism:releasableTo))">
            <!-- first portion with releasableTo that does not have a special tetra; use it to seed common country list -->
            <xsl:value-of select="util:recursivelyCheckRelTo($bannerRelTo, util:decomposeTetragraphs($portion/@ism:releasableTo), $remainingPartTags)"/>

         </xsl:when>
         <xsl:otherwise>
            <!-- remove the first portion in the list (the one just checked) -->
            <xsl:value-of select="util:checkRelToPortionsAgainstBannerAndGetCommonCountries($bannerRelTo, subsequence($remainingPartTags, 2))"/>

         </xsl:otherwise>
      </xsl:choose>
   </xsl:function>

   <!-- DISPLAY ONLY TO RULES -->

   <!-- Returns the @ism:releasableTo and @ism:displayOnlyTo strings concatenated together -->
   <xsl:function xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                 name="util:getDisplayToCountries">
      <xsl:param name="portion" as="node()"/>
      <xsl:value-of select="normalize-space(concat(normalize-space(string($portion/@ism:releasableTo)), ' ', normalize-space(string($portion/@ism:displayOnlyTo))))"/>
   </xsl:function>

   <!-- Returns true if this element specifies attribute @ism:releasableTo or @ism:displayOnlyTo -->
   <xsl:function xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                 name="util:isDisplayable"
                 as="xs:boolean">
      <xsl:param name="portion" as="node()"/>
      <xsl:value-of select="$portion/@ism:releasableTo or $portion/@ism:displayOnlyTo"/>
   </xsl:function>

   <!-- Recursively iterates over the contributing portions in a document and makes sure that the displayability markings
    are consistent with the banner. Returns the list of common countries if no portion fails constraint checking -->
   <xsl:function xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                 name="util:recursivelyCheckDisplayTo"
                 as="xs:string*">
      <xsl:param name="bannerRelToAndDisplayTo" as="xs:string"/>
      <xsl:param name="commonCountries" as="xs:string"/>
      <xsl:param name="remainingPartTags" as="node()*"/>

      <xsl:variable name="portion" select="$remainingPartTags[1]"/>

      <xsl:choose>
         <xsl:when test="count(tokenize($commonCountries, ' ')) = 0">
            <!-- base case, if commonCountries is the empty set, then there 
                    is no common country to display to -->
            <xsl:value-of select="()"/>
         </xsl:when>
         <xsl:when test="count($remainingPartTags) = 0">
            <!-- base case, no more portions to look at, return commonCountries -->
            <xsl:value-of select="$commonCountries"/>
         </xsl:when>
         <xsl:when test="not(util:containsFDR($portion)) and $portion/@ism:classification = 'U'">
            <!-- normal unclass portion without FRD markings does not impact displayability, iterate over this portion -->
            <xsl:value-of select="util:recursivelyCheckDisplayTo($bannerRelToAndDisplayTo, $commonCountries, subsequence($remainingPartTags, 2))"/>
         </xsl:when>
         <xsl:when test="not($portion/@ism:releasableTo) and not($portion/@ism:displayOnlyTo)">
            <!-- this portion contributes and is not displayable, so it means there are no common countries -->
            <xsl:value-of select="()"/>
         </xsl:when>
         <xsl:when test="util:containsSpecialTetra(util:getDisplayToCountries($portion))">
            <!-- this portion has special tetras. This function cannot handle special tetras, so iterate over this portion -->
            <xsl:value-of select="util:recursivelyCheckDisplayTo($bannerRelToAndDisplayTo, $commonCountries, subsequence($remainingPartTags, 2))"/>
         </xsl:when>
         <xsl:otherwise>
            <!-- this portion has no special tetras, check it -->
            <xsl:choose>
               <xsl:when test="util:bannerIsSubset($bannerRelToAndDisplayTo, util:getDisplayToCountries($portion))">
                  <!-- banner displayTo list is correctly a subset of this portion displayTo list, iterate to next portion -->
                  <xsl:value-of select="util:recursivelyCheckDisplayToRecurseHelper($bannerRelToAndDisplayTo, $commonCountries, $remainingPartTags)"/>
               </xsl:when>
               <xsl:otherwise>
                  <!-- banner says displayTo a country that this portion is not displayable to, so it is wrong -->
                  <xsl:value-of select="('BANNER_NOT_A_SUBSET_OF_A_PORTION')"/>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:function>

   <!-- convenience function for iterating to the next portion and updating the common countries list -->
   <xsl:function xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                 name="util:recursivelyCheckDisplayToRecurseHelper"
                 as="xs:string*">
      <xsl:param name="bannerRelToAndDisplayTo" as="xs:string"/>
      <xsl:param name="commonCountries" as="xs:string"/>
      <xsl:param name="remainingPartTags" as="node()*"/>

      <xsl:variable name="portion" select="$remainingPartTags[1]"/>

      <xsl:choose>
         <xsl:when test="count($remainingPartTags) = 1">
            <!-- Checking the last item in the list, give empty list to kill recursion -->
            <xsl:value-of select="util:recursivelyCheckDisplayTo($bannerRelToAndDisplayTo, util:intersectionOfCountries($commonCountries, util:getDisplayToCountries($portion)), ())"/>
         </xsl:when>
         <xsl:otherwise>
            <!-- remove the first portion in the list (the one just checked) -->
            <xsl:value-of select="util:recursivelyCheckDisplayTo($bannerRelToAndDisplayTo, util:intersectionOfCountries($commonCountries, util:getDisplayToCountries($portion)), subsequence($remainingPartTags, 2))"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:function>

   <!-- The function that should be called from schematron rules.
        This function iterates through the portions until it gets to a portion 
        that has @ism:releasableTo and does not contain a special tetra in @ism:releasableTo.
        It uses the countries in @ism:releasableTo from that portion as the initial common 
        countries list for the recursive function. 
    -->
   <xsl:function xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                 name="util:checkDisplayToPortionsAgainstBannerAndGetCommonCountries"
                 as="xs:string*">
      <xsl:param name="bannerRelToAndDisplayTo" as="xs:string"/>
      <xsl:param name="remainingPartTags" as="node()*"/>

      <xsl:variable name="portion" select="$remainingPartTags[1]"/>

      <xsl:choose>
         <xsl:when test="count($remainingPartTags) = 0">
            <!-- no portions provided, so choose either: had no portions to begin with OR no portion had a special tetra -->
            <xsl:value-of select="('PASS')"/>
         </xsl:when>
         <xsl:when test="util:containsFDR($portion) and not(util:isDisplayable($portion))">
            <!-- this portion contributes, contains FD&R markings, and is not displayable so the commonCountry set is empty -->
            <xsl:value-of select="()"/>
         </xsl:when>
         <xsl:when test="util:isDisplayable($portion) and not(util:containsSpecialTetra(util:getDisplayToCountries($portion)))">
            <!-- first portion with releasableTo or displayOnlyTo that does not have a special tetra; use it to seed common country list -->
            <xsl:value-of select="util:recursivelyCheckDisplayTo($bannerRelToAndDisplayTo, util:decomposeTetragraphs(util:getDisplayToCountries($portion)), $remainingPartTags)"/>
         </xsl:when>
         <xsl:otherwise>
            <!-- remove the first portion in the list (the one just checked) and iterate -->
            <xsl:value-of select="util:checkDisplayToPortionsAgainstBannerAndGetCommonCountries($bannerRelToAndDisplayTo, subsequence($remainingPartTags, 2))"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:function>

   <xsl:function xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                 name="util:getTetragraphMembership">
      <xsl:param name="tetra"/>

      <xsl:value-of select="             if ($catt//catt:Tetragraph[@decomposable = 'Yes']) then                tokenize(string-join((for $country in $catt//catt:Tetragraph[catt:TetraToken = $tetra]/catt:Membership/*/text()                return                   $country), ' '), ' ')             else                $tetra"/>
   </xsl:function>

   <xsl:function xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                 name="util:getTetragraphReleasability">
      <xsl:param name="tetra"/>

      <xsl:value-of select="             distinct-values(for $token in tokenize($catt//catt:Tetragraph[catt:TetraToken = $tetra]/@ism:releasableTo, ' ')             return                if (index-of($catt//catt:TetraToken, $token) &gt; 0) then                   util:getTetragraphMembership($token)                else                   $token)"/>
   </xsl:function>

   <!--****************************-->
<!-- (U) ISM ID Rules -->
<!--****************************-->

<!--(U) USDOD-->
   <sch:include href="./Rules/USDOD/ISM_ID_00155.sch"/>
   <sch:include href="./Rules/USDOD/ISM_ID_00157.sch"/>
   <sch:include href="./Rules/USDOD/ISM_ID_00158.sch"/>
   <sch:include href="./Rules/USDOD/ISM_ID_00161.sch"/>
   <sch:include href="./Rules/USDOD/ISM_ID_00162.sch"/>
   <sch:include href="./Rules/USDOD/ISM_ID_00227.sch"/>
   <sch:include href="./Rules/USDOD/ISM_ID_00237.sch"/>
   <sch:include href="./Rules/USDOD/ISM_ID_00238.sch"/>
   <sch:include href="./Rules/USDOD/ISM_ID_00239.sch"/>
   <sch:include href="./Rules/USDOD/ISM_ID_00240.sch"/>

   <!--(U) USGov-->
   <sch:include href="./Rules/USGov/ISM_ID_00014.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00016.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00017.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00026.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00028.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00030.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00031.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00032.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00033.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00035.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00037.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00038.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00040.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00041.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00042.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00043.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00044.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00045.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00047.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00048.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00049.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00056.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00058.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00059.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00064.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00065.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00066.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00067.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00068.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00070.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00071.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00072.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00073.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00074.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00075.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00077.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00078.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00079.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00080.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00081.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00084.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00085.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00086.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00087.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00088.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00090.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00095.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00096.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00097.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00099.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00100.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00104.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00105.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00107.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00108.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00109.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00110.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00121.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00124.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00127.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00128.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00129.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00130.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00132.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00133.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00134.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00135.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00136.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00137.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00138.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00139.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00141.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00142.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00143.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00145.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00146.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00147.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00148.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00149.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00150.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00151.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00152.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00153.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00154.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00159.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00164.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00165.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00166.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00167.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00168.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00169.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00170.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00173.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00174.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00175.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00176.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00178.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00179.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00180.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00181.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00183.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00184.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00185.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00186.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00187.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00188.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00189.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00190.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00191.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00192.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00193.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00196.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00197.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00198.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00199.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00200.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00201.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00202.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00203.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00204.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00205.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00206.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00207.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00208.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00209.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00210.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00211.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00213.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00214.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00217.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00219.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00221.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00223.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00226.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00228.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00229.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00230.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00231.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00241.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00242.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00243.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00244.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00245.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00246.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00250.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00252.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00253.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00254.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00255.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00256.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00257.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00258.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00259.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00260.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00261.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00262.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00263.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00264.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00265.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00266.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00267.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00268.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00269.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00270.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00271.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00272.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00273.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00274.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00275.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00276.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00277.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00278.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00279.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00280.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00281.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00282.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00283.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00284.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00285.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00286.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00287.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00288.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00289.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00290.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00291.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00292.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00293.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00294.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00295.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00296.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00297.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00298.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00299.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00302.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00303.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00304.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00305.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00306.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00307.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00308.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00309.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00310.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00311.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00313.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00314.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00315.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00316.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00317.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00318.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00319.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00320.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00321.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00324.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00325.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00326.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00327.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00328.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00329.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00330.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00331.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00332.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00333.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00335.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00336.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00341.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00343.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00344.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00345.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00346.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00347.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00348.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00349.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00350.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00351.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00352.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00353.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00354.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00355.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00356.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00357.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00361.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00362.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00363.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00364.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00365.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00367.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00368.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00369.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00370.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00371.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00372.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00373.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00374.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00379.sch"/>
   <sch:include href="./Rules/USGov/ISM_ID_00380.sch"/>

   <!--(U) USIC-->
   <sch:include href="./Rules/USIC/ISM_ID_00119.sch"/>
   <sch:include href="./Rules/USIC/ISM_ID_00225.sch"/>
   <sch:include href="./Rules/USIC/ISM_ID_00251.sch"/>

   <!--(U) general-->
   <sch:include href="./Rules/general/ISM_ID_00002.sch"/>
   <sch:include href="./Rules/general/ISM_ID_00012.sch"/>
   <sch:include href="./Rules/general/ISM_ID_00102.sch"/>
   <sch:include href="./Rules/general/ISM_ID_00103.sch"/>
   <sch:include href="./Rules/general/ISM_ID_00118.sch"/>
   <sch:include href="./Rules/general/ISM_ID_00125.sch"/>
   <sch:include href="./Rules/general/ISM_ID_00163.sch"/>
   <sch:include href="./Rules/general/ISM_ID_00194.sch"/>
   <sch:include href="./Rules/general/ISM_ID_00195.sch"/>
   <sch:include href="./Rules/general/ISM_ID_00236.sch"/>
   <sch:include href="./Rules/general/ISM_ID_00248.sch"/>
   <sch:include href="./Rules/general/ISM_ID_00300.sch"/>
   <sch:include href="./Rules/general/ISM_ID_00322.sch"/>
   <sch:include href="./Rules/general/ISM_ID_00323.sch"/>
   <sch:include href="./Rules/general/ISM_ID_00337.sch"/>
   <sch:include href="./Rules/general/ISM_ID_00338.sch"/>
   <sch:include href="./Rules/general/ISM_ID_00339.sch"/>
   <sch:include href="./Rules/general/ISM_ID_00340.sch"/>
   <sch:include href="./Rules/general/ISM_ID_00358.sch"/>
   <sch:include href="./Rules/general/ISM_ID_00359.sch"/>
   <sch:include href="./Rules/general/ISM_ID_00360.sch"/>
   <sch:include href="./Rules/general/ISM_ID_00366.sch"/>
   <sch:include href="./Rules/general/ISM_ID_00375.sch"/>
   <sch:include href="./Rules/general/ISM_ID_00376.sch"/>
   <sch:include href="./Rules/general/ISM_ID_00377.sch"/>
   <sch:include href="./Rules/general/ISM_ID_00378.sch"/>
   <sch:include href="./Rules/general/ISM_ID_00381.sch"/>
</sch:schema>
<!--UNCLASSIFIED-->
