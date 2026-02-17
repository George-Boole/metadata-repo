<?xml version="1.0" encoding="UTF-8"?>
<!--UNCLASSIFIED--><xsl:stylesheet xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                xmlns:saxon="http://saxon.sf.net/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:schold="http://www.ascc.net/xml/schematron"
                xmlns:iso="http://purl.oclc.org/dsdl/schematron"
                xmlns:xhtml="http://www.w3.org/1999/xhtml"
                xmlns:pubs="urn:us:gov:ic:pubs"
                xmlns:cve="urn:us:gov:ic:cve"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:ism="urn:us:gov:ic:ism"
                xmlns:mat="urn:us:gov:ic:mat"
                xmlns:ntk="urn:us:gov:ic:ntk"
                xmlns:irm="urn:us:gov:ic:irm"
                version="2.0"><!--Implementers: please note that overriding process-prolog or process-root is 
    the preferred method for meta-stylesheets to use where possible. -->
<xsl:param name="archiveDirParameter"/>
   <xsl:param name="archiveNameParameter"/>
   <xsl:param name="fileNameParameter"/>
   <xsl:param name="fileDirParameter"/>
   <xsl:variable name="document-uri">
      <xsl:value-of select="document-uri(/)"/>
   </xsl:variable>

   <!--PHASES-->


<!--PROLOG-->
<xsl:output xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
               method="xml"
               omit-xml-declaration="no"
               standalone="yes"
               indent="yes"/>

   <!--XSD TYPES FOR XSLT2-->


<!--KEYS AND FUNCTIONS-->


<!--DEFAULT RULES-->


<!--MODE: SCHEMATRON-SELECT-FULL-PATH-->
<!--This mode can be used to generate an ugly though full XPath for locators-->
<xsl:template match="*" mode="schematron-select-full-path">
      <xsl:apply-templates select="." mode="schematron-get-full-path"/>
   </xsl:template>

   <!--MODE: SCHEMATRON-FULL-PATH-->
<!--This mode can be used to generate an ugly though full XPath for locators-->
<xsl:template match="*" mode="schematron-get-full-path">
      <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      <xsl:text>/</xsl:text>
      <xsl:choose>
         <xsl:when test="namespace-uri()=''">
            <xsl:value-of select="name()"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>*:</xsl:text>
            <xsl:value-of select="local-name()"/>
            <xsl:text>[namespace-uri()='</xsl:text>
            <xsl:value-of select="namespace-uri()"/>
            <xsl:text>']</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:variable name="preceding"
                    select="count(preceding-sibling::*[local-name()=local-name(current())                                   and namespace-uri() = namespace-uri(current())])"/>
      <xsl:text>[</xsl:text>
      <xsl:value-of select="1+ $preceding"/>
      <xsl:text>]</xsl:text>
   </xsl:template>
   <xsl:template match="@*" mode="schematron-get-full-path">
      <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      <xsl:text>/</xsl:text>
      <xsl:choose>
         <xsl:when test="namespace-uri()=''">@<xsl:value-of select="name()"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>@*[local-name()='</xsl:text>
            <xsl:value-of select="local-name()"/>
            <xsl:text>' and namespace-uri()='</xsl:text>
            <xsl:value-of select="namespace-uri()"/>
            <xsl:text>']</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!--MODE: SCHEMATRON-FULL-PATH-2-->
<!--This mode can be used to generate prefixed XPath for humans-->
<xsl:template match="node() | @*" mode="schematron-get-full-path-2">
      <xsl:for-each select="ancestor-or-self::*">
         <xsl:text>/</xsl:text>
         <xsl:value-of select="name(.)"/>
         <xsl:if test="preceding-sibling::*[name(.)=name(current())]">
            <xsl:text>[</xsl:text>
            <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
            <xsl:text>]</xsl:text>
         </xsl:if>
      </xsl:for-each>
      <xsl:if test="not(self::*)">
         <xsl:text/>/@<xsl:value-of select="name(.)"/>
      </xsl:if>
   </xsl:template>
   <!--MODE: SCHEMATRON-FULL-PATH-3-->
<!--This mode can be used to generate prefixed XPath for humans 
	(Top-level element has index)-->
<xsl:template match="node() | @*" mode="schematron-get-full-path-3">
      <xsl:for-each select="ancestor-or-self::*">
         <xsl:text>/</xsl:text>
         <xsl:value-of select="name(.)"/>
         <xsl:if test="parent::*">
            <xsl:text>[</xsl:text>
            <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
            <xsl:text>]</xsl:text>
         </xsl:if>
      </xsl:for-each>
      <xsl:if test="not(self::*)">
         <xsl:text/>/@<xsl:value-of select="name(.)"/>
      </xsl:if>
   </xsl:template>

   <!--MODE: GENERATE-ID-FROM-PATH -->
<xsl:template match="/" mode="generate-id-from-path"/>
   <xsl:template match="text()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.text-', 1+count(preceding-sibling::text()), '-')"/>
   </xsl:template>
   <xsl:template match="comment()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.comment-', 1+count(preceding-sibling::comment()), '-')"/>
   </xsl:template>
   <xsl:template match="processing-instruction()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.processing-instruction-', 1+count(preceding-sibling::processing-instruction()), '-')"/>
   </xsl:template>
   <xsl:template match="@*" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.@', name())"/>
   </xsl:template>
   <xsl:template match="*" mode="generate-id-from-path" priority="-0.5">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:text>.</xsl:text>
      <xsl:value-of select="concat('.',name(),'-',1+count(preceding-sibling::*[name()=name(current())]),'-')"/>
   </xsl:template>

   <!--MODE: GENERATE-ID-2 -->
<xsl:template match="/" mode="generate-id-2">U</xsl:template>
   <xsl:template match="*" mode="generate-id-2" priority="2">
      <xsl:text>U</xsl:text>
      <xsl:number level="multiple" count="*"/>
   </xsl:template>
   <xsl:template match="node()" mode="generate-id-2">
      <xsl:text>U.</xsl:text>
      <xsl:number level="multiple" count="*"/>
      <xsl:text>n</xsl:text>
      <xsl:number count="node()"/>
   </xsl:template>
   <xsl:template match="@*" mode="generate-id-2">
      <xsl:text>U.</xsl:text>
      <xsl:number level="multiple" count="*"/>
      <xsl:text>_</xsl:text>
      <xsl:value-of select="string-length(local-name(.))"/>
      <xsl:text>_</xsl:text>
      <xsl:value-of select="translate(name(),':','.')"/>
   </xsl:template>
   <!--Strip characters--><xsl:template match="text()" priority="-1"/>

   <!--SCHEMA SETUP-->
<xsl:template match="/">
      <svrl:schematron-output xmlns:svrl="http://purl.oclc.org/dsdl/svrl" title="" schemaVersion="">
         <xsl:comment>
            <xsl:value-of select="$archiveDirParameter"/>   
		 <xsl:value-of select="$archiveNameParameter"/>  
		 <xsl:value-of select="$fileNameParameter"/>  
		 <xsl:value-of select="$fileDirParameter"/>
         </xsl:comment>
         <svrl:ns-prefix-in-attribute-values uri="urn:us:gov:ic:pubs" prefix="pubs"/>
         <svrl:ns-prefix-in-attribute-values uri="urn:us:gov:ic:cve" prefix="cve"/>
         <svrl:ns-prefix-in-attribute-values uri="http://www.w3.org/1999/xlink" prefix="xlink"/>
         <svrl:ns-prefix-in-attribute-values uri="urn:us:gov:ic:ism" prefix="ism"/>
         <svrl:ns-prefix-in-attribute-values uri="urn:us:gov:ic:mat" prefix="mat"/>
         <svrl:ns-prefix-in-attribute-values uri="urn:us:gov:ic:ntk" prefix="ntk"/>
         <svrl:ns-prefix-in-attribute-values uri="urn:us:gov:ic:irm" prefix="irm"/>
         <svrl:ns-prefix-in-attribute-values uri="http://www.w3.org/2001/XMLSchema" prefix="xs"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NTK-ID-00026</xsl:attribute>
            <xsl:attribute name="name">NTK-ID-00026</xsl:attribute>
            <svrl:text>
        [NTK-ID-00026][Error] AccessProfiles containing the AccessPolicy [urn:us:gov:ic:aces:ntk:ico] may not have
        ProfileDes, VocabularyType, or AccessProfileValue elements specified.
        
        Human Readable: When the ICO ACES is referenced, no data content may be specified in the AccessProfile.
    </svrl:text>
            <svrl:text>
        For every ntk:AccessProfile that has an ntk:AccessPolicy of [urn:us:gov:ic:aces:ntk:ico], 
        the profile does not specify any of the data elements of ntk:ProfileDes, ntk:VocabularyType, 
        or ntk:AccessProfileValue.
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M17"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NTK-ID-00010</xsl:attribute>
            <xsl:attribute name="name">NTK-ID-00010</xsl:attribute>
            <svrl:text>[NTK-ID-00010][Error] Mission Need NTK assertions must use the “datasphere” profile
        DES.</svrl:text>
            <svrl:text>ntk:AccessProfile elements that have an ntk:AccessPolicy child with the MN value
        (urn:us:gov:ic:aces:ntk:mn) must have an ntk:ProfileDes with the datasphere value
        (urn:us:gov:ic:ntk:profile:datasphere).</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M18"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NTK-ID-00011</xsl:attribute>
            <xsl:attribute name="name">NTK-ID-00011</xsl:attribute>
            <svrl:text>[NTK-ID-00011][Error] The Access Profile Value for MN NTK assertions must use the
        appropriate subject or region vocabulary.</svrl:text>
            <svrl:text>Given an MN NTK assertion (ntk:AccessPolicy = 'urn:us:gov:ic:aces:ntk:mn'), the
        ntk:AccessProfileValue elements ntk:vocabulary attribute must be either
        'datasphere:mn:issue' or 'datasphere:mn:region'.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M19"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NTK-ID-00012</xsl:attribute>
            <xsl:attribute name="name">NTK-ID-00012</xsl:attribute>
            <svrl:text>[NTK-ID-00012][Error] The Access Profile Value must not have an @ntk:qualifier attribute
        specified for MN NTK assertions.</svrl:text>
            <svrl:text>Given an MN NTK assertion (ntk:AccessPolicy = 'urn:us:gov:ic:ntk:profile:mn'), the
        ntk:AccessProfileValue/@ntk:qualifier attribute is not allowed.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M20"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NTK-ID-00013</xsl:attribute>
            <xsl:attribute name="name">NTK-ID-00013</xsl:attribute>
            <svrl:text>[NTK-ID-00013][Error] If Vocabulary Type is specified in an MN NTK assertion, it must
        specify a version for either the issue (datasphere:mn:issue) or region (datasphere:mn:region)
        vocabularies.</svrl:text>
            <svrl:text>If an ntk:VocabularyType element exists in an MN NTK assertion
        (ntk:VocabularyType[../ntk:AccessPolicy = 'urn:us:gov:ic:aces:ntk:mn']), then (1) @ntk:name must be
        ‘datasphere:mn:issue’ or ‘datasphere:mn:region’ and (2) the @ntk:sourceVersion attribute is required.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M21"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NTK-ID-00030</xsl:attribute>
            <xsl:attribute name="name">NTK-ID-00030</xsl:attribute>
            <svrl:text>This abstract pattern checks to see if an attribute of an element exists
        in a list or matches the pattern defined by the list. The calling rule must pass the
        context, search term list, attribute value to check, and an error message.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M22"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NTK-ID-00031</xsl:attribute>
            <xsl:attribute name="name">NTK-ID-00031</xsl:attribute>
            <svrl:text>This abstract pattern checks to see if an attribute of an element exists
        in a list or matches the pattern defined by the list. The calling rule must pass the
        context, search term list, attribute value to check, and an error message.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M23"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NTK-ID-00046</xsl:attribute>
            <xsl:attribute name="name">NTK-ID-00046</xsl:attribute>
            <svrl:text>[NTK-ID-00046][Error] 
        When both issues (datasphere:mn:issue) and regions (datasphere:mn:region) are specified
        for in a Mission Need NTK instance, the version of the list specified for both must be the 
        same.</svrl:text>
            <svrl:text>
        For Mission Need profile NTK instances that have Vocabulary Types of both issue and region,
        the verify that the @ntk:sourceVersion attribute values specified for both datasphere:mn:issue 
        and datasphere:mn:region are the same.
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M24"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NTK-ID-00028</xsl:attribute>
            <xsl:attribute name="name">NTK-ID-00028</xsl:attribute>
            <svrl:text>
        [NTK-ID-00028][Error] An Agency Dissemination NTK must have one and only one entry
        qualified as the originator.
    </svrl:text>
            <svrl:text>
        For every ntk:AccessProfile with an ntk:ProfileDes of [urn:us:gov:ic:ntk:profile:agencydissem], this rule ensures
        that it has one and only one ntk:AccessProfileValue element with an @ntk:qualifier of
        [originator].
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M25"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NTK-ID-00035</xsl:attribute>
            <xsl:attribute name="name">NTK-ID-00035</xsl:attribute>
            <svrl:text>[NTK-ID-00035][Error] The @ntk:qualifier attribute value of either ‘originator’ or ‘dissemto’
      is required on every AccessProfileValue element for NTK Access Profiles based on the Agency Dissemination profile
      DES.</svrl:text>
            <svrl:text>Given an ntk:AccessProfile with an ntk:ProfileDes value of
      ‘urn:us:gov:ic:ntk:profile:agencydissem’, one of ntk:AccessProfileValue/@qualifier='originator' or
      ntk:AccessProfileValue/@qualifier='dissemto' must exist.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M26"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NTK-ID-00021</xsl:attribute>
            <xsl:attribute name="name">NTK-ID-00021</xsl:attribute>
            <svrl:text>[NTK-ID-00021][Error] Datasphere Profile NTK assertions must use ‘datasphere’ as the prefix
        for vocabulary names.</svrl:text>
            <svrl:text>For NTK assertions that use the ‘urn:us:gov:ic:ntk:profile:datasphere’ profile DES,
        ntk:VocabularyType/@ntk:name must start with ‘datasphere:’.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M27"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NTK-ID-00022</xsl:attribute>
            <xsl:attribute name="name">NTK-ID-00022</xsl:attribute>
            <svrl:text>[NTK-ID-00022][Error] Datasphere Profile NTK assertions must use ‘datasphere’ vocabularies
        for access profile values.</svrl:text>
            <svrl:text>For NTK assertions that use the ‘urn:us:gov:ic:ntk:profile:datasphere’ profile DES,
        ntk:AccessProfileValue/@ntk:vocabulary must start with ‘datasphere:’.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M28"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NTK-ID-00040</xsl:attribute>
            <xsl:attribute name="name">NTK-ID-00040</xsl:attribute>
            <svrl:text>[NTK-ID-00040][Error] EXDIS requires the USA-Agency Vocabulary
      (organization:usa-agency).</svrl:text>
            <svrl:text>
      If AccessPolicy for the AccessProfile is EXDIS, then the vocabulary for the AccessProfileValue must be USA-Agency.
   </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M29"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NTK-ID-00050</xsl:attribute>
            <xsl:attribute name="name">NTK-ID-00050</xsl:attribute>
            <svrl:text>[NTK-ID-00050][Error] 
      EXDIS profiles requires ntk:ProfileDes with type agencydissem (urn:us:gov:ic:ntk:profile:agencydissem).</svrl:text>
            <svrl:text>.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M30"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NTK-ID-00002</xsl:attribute>
            <xsl:attribute name="name">NTK-ID-00002</xsl:attribute>
            <svrl:text>
        [NTK-ID-00002][Error]
        ntk:RequiresAnyOf and ntk:RequiresAllOf must contain ntk:AccessProfileList.
        
        Human Readable: ntk:RequiresAnyOf and ntk:RequiresAllOf must have the child element ntk:AccessProfileList.
    </svrl:text>
            <svrl:text>
        This rule ensures that ntk:AccessProfileList exist as a child element of ntk:RequiresAnyOf and 
        ntk:RequiresAllOf.
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M31"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NTK-ID-00004</xsl:attribute>
            <xsl:attribute name="name">NTK-ID-00004</xsl:attribute>
            <svrl:text>
        [NTK-ID-00004][Error] Every attribute in the NTK namespace must be
        specified with a non-whitespace value.
    </svrl:text>
            <svrl:text>
        For each element which specifies an attribute in the NTK namespace, this rule ensures that all attributes in the NTK namespace contain a non-whitespace
        value.
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M32"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NTK-ID-00006</xsl:attribute>
            <xsl:attribute name="name">NTK-ID-00006</xsl:attribute>
            <svrl:text>
        [NTK-ID-00006][Error]The attribute 
        DESVersion in the namespace urn:us:gov:ic:ntk must be specified.
        
        Human Readable: The data encoding specification version must
        be specified.
    </svrl:text>
            <svrl:text>
        Make sure that the attribute ntk:DESVersion is specified.
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M33"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NTK-ID-00007</xsl:attribute>
            <xsl:attribute name="name">NTK-ID-00007</xsl:attribute>
            <svrl:text>
        [NTK-ID-00007][Error] The attribute @ntk:externalReference must be set to 
        true when the ExternalAccess element is used.
        
        Human Readable: If the ExternalAccess element is used, then the attribute @ntk:externalReference must have a value of true.
    </svrl:text>
            <svrl:text>
        Make sure the externalReference attribute is specified with a value of
        true when the ExternalAccess element is used.
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M34"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NTK-ID-00009</xsl:attribute>
            <xsl:attribute name="name">NTK-ID-00009</xsl:attribute>
            <svrl:text>[NTK-ID-00009][Error] The @ism:DESVersion is less than the minimum version allowed:
      201508.</svrl:text>
            <svrl:text>For all elements that contain @ism:DESVersion, this rule ensures that the version is greater
      than or equal to the minimum allowed version: 201508.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M35"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NTK-ID-00018</xsl:attribute>
            <xsl:attribute name="name">NTK-ID-00018</xsl:attribute>
            <svrl:text>
        [NTK-ID-00018][Error] Vocabulary declarations must have a root from one of the built-in 
        types of 'datasphere', 'organization', 'individual', or 'group'. Declaration of custom
        root types are not permitted.
    </svrl:text>
            <svrl:text>
        For all VocabularyType names, ensure that they are all linked to a built-in root vocabulary type.
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M36"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NTK-ID-00019</xsl:attribute>
            <xsl:attribute name="name">NTK-ID-00019</xsl:attribute>
            <svrl:text>
        [NTK-ID-00019][Error] VocabularyTypes must have a source unless being derived from 
        an existing built-in type.
    </svrl:text>
            <svrl:text>
        For each VocabularyType that does not have a source, make sure that it is one of the built-in types
        or otherwise already declared with a source.
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M37"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NTK-ID-00020</xsl:attribute>
            <xsl:attribute name="name">NTK-ID-00020</xsl:attribute>
            <svrl:text>
        [NTK-ID-00020][Error] All vocabularies used must be of a builtin vocabulary type or 
        be defined in this ntk:AccessProfile in an ntk:VocabularyType. 
    </svrl:text>
            <svrl:text>
        For every AccessProfileValue element, verify that the value of the vocabulary attribute
        is either one of the builtin vocabulary types or defined in this AccessProfile.
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M38"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NTK-ID-00023</xsl:attribute>
            <xsl:attribute name="name">NTK-ID-00023</xsl:attribute>
            <svrl:text>
        [NTK-ID-00023][Error] If ntk:AccessProfileValue or ntk:VocabularyType are specified then there must
        be a Profile DES that defines the use of the ntk:AccessProfile structure.
    </svrl:text>
            <svrl:text>
        When there is content in an AccessProfile, either AccessProfileValue or VocabularyType, then
        there must also be a ProfileDes in the AccessProfile.
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M39"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NTK-ID-00024</xsl:attribute>
            <xsl:attribute name="name">NTK-ID-00024</xsl:attribute>
            <svrl:text>
        [NTK-ID-00024][Error] If there is a Profile DES specified, then there must be at least
        one ntk:AccessProfileValue.
    </svrl:text>
            <svrl:text>
        When ntk:ProfileDes exists, make sure there is a following sibling ntk:AccessProfileValue
        also.
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M40"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NTK-ID-00025</xsl:attribute>
            <xsl:attribute name="name">NTK-ID-00025</xsl:attribute>
            <svrl:text>
        [NTK-ID-00025][Error] Sources cannot be overridden. If a
        built-in vocabulary type is specified and the source 
        attribute is present it must equal the built-in source.
    </svrl:text>
            <svrl:text>
        When a builtin vocabulary is specified in an ntk:VocabularyType element and the source
        attribute is present, then verify that the source specified matches the built in source 
        value.
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M41"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NTK-ID-00027</xsl:attribute>
            <xsl:attribute name="name">NTK-ID-00027</xsl:attribute>
            <svrl:text>This abstract pattern checks to see if an attribute of an element exists
        in a list or matches the pattern defined by the list. The calling rule must pass the
        context, search term list, attribute value to check, and an error message.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M42"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NTK-ID-00029</xsl:attribute>
            <xsl:attribute name="name">NTK-ID-00029</xsl:attribute>
            <svrl:text>Abstract pattern to require an ntk:VocabularyType with @ntk:sourceVersion for a specified
      vocabulary.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M43"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NTK-ID-00032</xsl:attribute>
            <xsl:attribute name="name">NTK-ID-00032</xsl:attribute>
            <svrl:text>Abstract pattern to require an ntk:VocabularyType with @ntk:sourceVersion for a specified
      vocabulary.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M44"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NTK-ID-00033</xsl:attribute>
            <xsl:attribute name="name">NTK-ID-00033</xsl:attribute>
            <svrl:text>Abstract pattern to require an ntk:VocabularyType with @ntk:sourceVersion for a specified
      vocabulary.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M45"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NTK-ID-00041</xsl:attribute>
            <xsl:attribute name="name">NTK-ID-00041</xsl:attribute>
            <svrl:text>[NTK-ID-00041][Error] Source versions (@ntk:sourceVersion) must be consistent for all NTK Profiles
   within a document that contribute to the actual overall access restrictions of the document.</svrl:text>
            <svrl:text>For any given vocabularyType that is tied to a CES, determine how many distinct versions of that
   CES are specified. Report an error if there is more than one version found.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M46"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NTK-ID-00042</xsl:attribute>
            <xsl:attribute name="name">NTK-ID-00042</xsl:attribute>
            <svrl:text>This abstract pattern verifies that a value at a given context matches fome value in a list
      using regular expression matching. The calling rule must pass the context, search term list, attribute value to
      check, and an error message.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M47"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NTK-ID-00043</xsl:attribute>
            <xsl:attribute name="name">NTK-ID-00043</xsl:attribute>
            <svrl:text>[NTK-ID-00043][Error] The source version (@ntk:sourceVersion) must match the version of the CVE being used
      to validate values of the NTK instance.</svrl:text>
            <svrl:text>For any given vocabularyType that is tied to a CES, check the claimed sourceVersion against
      the version of the CVE file being used for validation and ensure they are equal.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M48"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NTK-ID-00044</xsl:attribute>
            <xsl:attribute name="name">NTK-ID-00044</xsl:attribute>
            <svrl:text>Abstract pattern to require an ntk:VocabularyType with @ntk:sourceVersion for a specified
      vocabulary.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M49"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NTK-ID-00045</xsl:attribute>
            <xsl:attribute name="name">NTK-ID-00045</xsl:attribute>
            <svrl:text>This abstract pattern verifies that a value at a given context matches fome value in a list
      using regular expression matching. The calling rule must pass the context, search term list, attribute value to
      check, and an error message.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M50"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NTK-ID-00048</xsl:attribute>
            <xsl:attribute name="name">NTK-ID-00048</xsl:attribute>
            <svrl:text>
        [NTK-ID-00048][Error] ntk:AccessPolicy, ntk:ProfileDes, and ntk:AccessProfileValue are required to have text content.
    </svrl:text>
            <svrl:text>
        ntk:AccessPolicy, ntk:ProfileDes, and ntk:AccessProfileValue are required to have text content.
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M51"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NTK-ID-00051</xsl:attribute>
            <xsl:attribute name="name">NTK-ID-00051</xsl:attribute>
            <svrl:text>This abstract pattern verifies that a value at a given context matches fome value in a list
      using regular expression matching. The calling rule must pass the context, search term list, attribute value to
      check, and an error message.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M52"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NTK-ID-00016</xsl:attribute>
            <xsl:attribute name="name">NTK-ID-00016</xsl:attribute>
            <svrl:text>[NTK-ID-00016][Error] Grp-ind Profile NTK assertions must use appropriate ‘group’ and
        ‘individual’ vocabularies for vocabulary type definitions.</svrl:text>
            <svrl:text>For NTK assertions that use the ‘urn:us:gov:ic:ntk:profile:grp-ind’ profile DES,
        ntk:VocabularyType/@name must start with ‘group:’ or ‘individual:’.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M53"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NTK-ID-00017</xsl:attribute>
            <xsl:attribute name="name">NTK-ID-00017</xsl:attribute>
            <svrl:text>[NTK-ID-00017][Error] Grp-ind Profile NTK assertions must use appropriate ‘group’ and
        ‘individual’ vocabularies for access profile values.</svrl:text>
            <svrl:text>For NTK assertions that use the ‘urn:us:gov:ic:ntk:profile:group’ profile DES,
        ntk:AccessProfileValue/@ntk:vocabulary must start with ‘group:’ or ‘individual:’.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M54"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NTK-ID-00039</xsl:attribute>
            <xsl:attribute name="name">NTK-ID-00039</xsl:attribute>
            <svrl:text>[NTK-ID-00039][Error] ORCON requires the USA-Agency Vocabulary
      (organization:usa-agency).</svrl:text>
            <svrl:text>
      If AccessPolicy for the AccessProfile is ORCON, then the vocabulary for the AccessProfileValue must be USA-Agency.
   </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M55"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NTK-ID-00049</xsl:attribute>
            <xsl:attribute name="name">NTK-ID-00049</xsl:attribute>
            <svrl:text>[NTK-ID-00049][Error] 
      ORCON profiles requires ntk:ProfileDes with type agencydissem (urn:us:gov:ic:ntk:profile:agencydissem).</svrl:text>
            <svrl:text>
      If AccessPolicy for the AccessProfile is ORCON, then the ProfileDes must be agencydissem.
   </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M56"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NTK-ID-00034</xsl:attribute>
            <xsl:attribute name="name">NTK-ID-00034</xsl:attribute>
            <svrl:text>[NTK-ID-00034][Error] Use of the permissive access policy requires the Group &amp; Individual
      Profile DES.</svrl:text>
            <svrl:text>If ntk:AccessProfile has an ntk:AccessPolicy = 'urn:us:gov:ic:aces:ntk:permissive',
      ntk:ProfileDes must be 'urn:us:gov:ic:ntk:profile:grp-ind'.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M57"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NTK-ID-00014</xsl:attribute>
            <xsl:attribute name="name">NTK-ID-00014</xsl:attribute>
            <svrl:text>[NTK-ID-00014][Error] For group-based PROPIN NTK assertions that
        contain ntk:ProfileDes elements, ntk:ProfileDes must specify the URN for Profile DES type: ‘grp-ind’.</svrl:text>
            <svrl:text>The value of ntk:ProfileDes element in a PROPIN NTK assertion (the ntk:AccessPolicy value
        starts with ‘urn:us:gov:ic:ntk:propin:’) must be ‘urn:us:gov:ic:ntk:profile:grp-ind’.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M58"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NTK-ID-00015</xsl:attribute>
            <xsl:attribute name="name">NTK-ID-00015</xsl:attribute>
            <svrl:text>[NTK-ID-00015][Error] Propin NTK assertions that use the urn:us:gov:ic:aces:ntk:propin:2
        access policy MUST specify a Profile DES.</svrl:text>
            <svrl:text>If an ntk:AccessProfile has an ntk:AccessPolicy element that has a value of
        ‘urn:us:gov:ic:aces:ntk:propin:2’, then an ntk:ProfileDes MUST be specified.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M59"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NTK-ID-00036</xsl:attribute>
            <xsl:attribute name="name">NTK-ID-00036</xsl:attribute>
            <svrl:text>[NTK-ID-00036][Error] PROPIN access policies must have characters after the predefined
      portion ‘urn:us:gov:ic:aces:ntk:propin:’.</svrl:text>
            <svrl:text>Given an ntk:AccessPolicy that starts with ‘urn:us:gov:ic:aces:ntk:propin:’, the string
      length must be greater than 30 (that is, there must be characters after the predefined portion).</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M60"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NTK-ID-00037</xsl:attribute>
            <xsl:attribute name="name">NTK-ID-00037</xsl:attribute>
            <svrl:text>[NTK-ID-00037][Error] Use of the restrictive access policy requires the Group &amp;
      Individual Profile DES.</svrl:text>
            <svrl:text>If ntk:AccessProfile has an ntk:AccessPolicy = 'urn:us:gov:ic:aces:ntk:restrictive',
      ntk:ProfileDes must be 'urn:us:gov:ic:ntk:profile:grp-ind'.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M61"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NTK-ID-00038</xsl:attribute>
            <xsl:attribute name="name">NTK-ID-00038</xsl:attribute>
            <svrl:text>[NTK-ID-00038][Error] Use of the restrictive access policy requires a Group vocabulary
      type.</svrl:text>
            <svrl:text>If ntk:AccessProfile has an ntk:AccessPolicy = 'urn:us:gov:ic:aces:ntk:restrictive',
      then ntk:AccessProfileValue/@ntk:vocabulary must start with 'group:'.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M62"/>
      </svrl:schematron-output>
   </xsl:template>

   <!--SCHEMATRON PATTERNS-->
<xsl:param name="builtins"
              select="( ('group:iaaems','JWICS:IAAEMS'), ('individual:icpki','IC-PKI:DN'), ('individual:cadpki','CAD-PKI:DN'),  ('individual:acsspki','ACSS-PKI:DN'),  ('organization:usa-agency','urn:us:gov:ic:cvenum:usagency:agencyacronym'), ('datasphere:license','urn:us:gov:ic:cvenum:lic:license'), ('datasphere:mn:issue','urn:us:gov:ic:cvenum:mn:issue'), ('datasphere:mn:region','urn:us:gov:ic:cvenum:mn:region'))"/>
   <xsl:param name="builtinVocab"
              select="for $each in $builtins[position() mod 2 eq 1] return $each"/>
   <xsl:param name="builtinVocabSource"
              select="for $each in $builtins[position() mod 2 eq 0] return $each"/>
   <xsl:param name="accessPolicyList"
              select="document('../../CVE/NTK/CVEnumNTKAccessPolicy.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>
   <xsl:param name="profileDESList"
              select="document('../../CVE/NTK/CVEnumNTKProfileDes.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>
   <xsl:param name="licenseList"
              select="document('../../CVE/LIC/CVEnumLicLicense.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>
   <xsl:param name="usagencyList"
              select="document('../../CVE/USAgency/CVEnumUSAgencyAcronym.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>
   <xsl:param name="issueList"
              select="document('../../CVE/MN/CVEnumMNIssue.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>
   <xsl:param name="regionList"
              select="document('../../CVE/MN/CVEnumMNRegion.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>

   <!--PATTERN NTK-ID-00026-->


	<!--RULE -->
<xsl:template match="ntk:AccessProfile[ntk:AccessPolicy='urn:us:gov:ic:aces:ntk:ico']"
                 priority="1000"
                 mode="M17">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ntk:AccessProfile[ntk:AccessPolicy='urn:us:gov:ic:aces:ntk:ico']"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(ntk:ProfileDes | ntk:VocabularyType | ntk:AccessProfileValue)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(ntk:ProfileDes | ntk:VocabularyType | ntk:AccessProfileValue)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [NTK-ID-00026][Error] AccessProfiles containing the AccessPolicy [urn:us:gov:ic:aces:ntk:ico] may not have
            ProfileDes, VocabularyType, or AccessProfileValue elements specified.
            
            Human Readable: When the ICO ACES is referenced, no data content may be specified in the AccessProfile. 
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M17"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M17"/>
   <xsl:template match="@*|node()" priority="-2" mode="M17">
      <xsl:apply-templates select="*" mode="M17"/>
   </xsl:template>

   <!--PATTERN NTK-ID-00010-->


	<!--RULE -->
<xsl:template match="ntk:AccessProfile[ntk:AccessPolicy = 'urn:us:gov:ic:aces:ntk:mn']/ntk:ProfileDes"
                 priority="1000"
                 mode="M18">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ntk:AccessProfile[ntk:AccessPolicy = 'urn:us:gov:ic:aces:ntk:mn']/ntk:ProfileDes"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test=". = 'urn:us:gov:ic:ntk:profile:datasphere'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test=". = 'urn:us:gov:ic:ntk:profile:datasphere'">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[NTK-ID-00010][Error] Mission Need
            NTK assertions must use the “datasphere” profile DES.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M18"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M18"/>
   <xsl:template match="@*|node()" priority="-2" mode="M18">
      <xsl:apply-templates select="*" mode="M18"/>
   </xsl:template>

   <!--PATTERN NTK-ID-00011-->


	<!--RULE -->
<xsl:template match="ntk:AccessProfile[ntk:AccessPolicy = 'urn:us:gov:ic:aces:ntk:mn']/ntk:AccessProfileValue"
                 priority="1000"
                 mode="M19">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ntk:AccessProfile[ntk:AccessPolicy = 'urn:us:gov:ic:aces:ntk:mn']/ntk:AccessProfileValue"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="@ntk:vocabulary = 'datasphere:mn:issue' or @ntk:vocabulary = 'datasphere:mn:region'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="@ntk:vocabulary = 'datasphere:mn:issue' or @ntk:vocabulary = 'datasphere:mn:region'">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[NTK-ID-00011][Error] The Access Profile Value for MN NTK assertions must use the appropriate
            subject or region vocabulary.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M19"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M19"/>
   <xsl:template match="@*|node()" priority="-2" mode="M19">
      <xsl:apply-templates select="*" mode="M19"/>
   </xsl:template>

   <!--PATTERN NTK-ID-00012-->


	<!--RULE -->
<xsl:template match="ntk:AccessProfile[ntk:AccessPolicy = 'urn:us:gov:ic:aces:ntk:mn']/ntk:AccessProfileValue"
                 priority="1000"
                 mode="M20">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ntk:AccessProfile[ntk:AccessPolicy = 'urn:us:gov:ic:aces:ntk:mn']/ntk:AccessProfileValue"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(@ntk:qualifier)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(@ntk:qualifier)">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[NTK-ID-00012][Error] The Access Profile Value must not have
            an @ntk:qualifier attribute specified for MN NTK assertions.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M20"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M20"/>
   <xsl:template match="@*|node()" priority="-2" mode="M20">
      <xsl:apply-templates select="*" mode="M20"/>
   </xsl:template>

   <!--PATTERN NTK-ID-00013-->


	<!--RULE -->
<xsl:template match="ntk:AccessProfile[ntk:AccessPolicy = 'urn:us:gov:ic:aces:ntk:mn']/ntk:VocabularyType"
                 priority="1000"
                 mode="M21">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ntk:AccessProfile[ntk:AccessPolicy = 'urn:us:gov:ic:aces:ntk:mn']/ntk:VocabularyType"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="@ntk:sourceVersion"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@ntk:sourceVersion">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[NTK-ID-00013][Error] The @ntk:sourceVersion attribute is
            required.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="@ntk:name = 'datasphere:mn:issue' or @ntk:name = 'datasphere:mn:region'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="@ntk:name = 'datasphere:mn:issue' or @ntk:name = 'datasphere:mn:region'">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[NTK-ID-00013][Error] The
            name attribute must be ‘datasphere:mn:issue’ or ‘datasphere:mn:region’.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M21"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M21"/>
   <xsl:template match="@*|node()" priority="-2" mode="M21">
      <xsl:apply-templates select="*" mode="M21"/>
   </xsl:template>

   <!--PATTERN NTK-ID-00030-->


	<!--RULE -->
<xsl:template match="ntk:AccessProfileValue[@ntk:vocabulary='datasphere:mn:issue']"
                 priority="1000"
                 mode="M22">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ntk:AccessProfileValue[@ntk:vocabulary='datasphere:mn:issue']"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="every $searchTerm in tokenize(normalize-space(string(.)), ' ') satisfies                   $searchTerm = $issueList or (some $Term in $issueList satisfies (matches(normalize-space($searchTerm), concat('^',$Term,'$'))))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $searchTerm in tokenize(normalize-space(string(.)), ' ') satisfies $searchTerm = $issueList or (some $Term in $issueList satisfies (matches(normalize-space($searchTerm), concat('^',$Term,'$'))))">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="'[NTK-ID-00030][Error] datasphere:mn:issue vocabulary values must exist in the Mission Need Issue CVE.'"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M22"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M22"/>
   <xsl:template match="@*|node()" priority="-2" mode="M22">
      <xsl:apply-templates select="*" mode="M22"/>
   </xsl:template>

   <!--PATTERN NTK-ID-00031-->


	<!--RULE -->
<xsl:template match="ntk:AccessProfileValue[@ntk:vocabulary='datasphere:mn:region']"
                 priority="1000"
                 mode="M23">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ntk:AccessProfileValue[@ntk:vocabulary='datasphere:mn:region']"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="every $searchTerm in tokenize(normalize-space(string(.)), ' ') satisfies                   $searchTerm = $regionList or (some $Term in $regionList satisfies (matches(normalize-space($searchTerm), concat('^',$Term,'$'))))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $searchTerm in tokenize(normalize-space(string(.)), ' ') satisfies $searchTerm = $regionList or (some $Term in $regionList satisfies (matches(normalize-space($searchTerm), concat('^',$Term,'$'))))">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="'[NTK-ID-00031][Error] datasphere:mn:region vocabulary values must exist in the Mission Need Region CVE.'"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M23"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M23"/>
   <xsl:template match="@*|node()" priority="-2" mode="M23">
      <xsl:apply-templates select="*" mode="M23"/>
   </xsl:template>

   <!--PATTERN NTK-ID-00046-->


	<!--RULE -->
<xsl:template match="ntk:AccessProfile[ntk:AccessPolicy = 'urn:us:gov:ic:aces:ntk:mn']         [ntk:VocabularyType[@ntk:name='datasphere:mn:issue'] and ntk:VocabularyType[@ntk:name='datasphere:mn:region']]"
                 priority="1000"
                 mode="M24">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ntk:AccessProfile[ntk:AccessPolicy = 'urn:us:gov:ic:aces:ntk:mn']         [ntk:VocabularyType[@ntk:name='datasphere:mn:issue'] and ntk:VocabularyType[@ntk:name='datasphere:mn:region']]"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="ntk:VocabularyType[@ntk:name='datasphere:mn:issue']/@ntk:sourceVersion                    = ntk:VocabularyType[@ntk:name='datasphere:mn:region']/@ntk:sourceVersion"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="ntk:VocabularyType[@ntk:name='datasphere:mn:issue']/@ntk:sourceVersion = ntk:VocabularyType[@ntk:name='datasphere:mn:region']/@ntk:sourceVersion">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [NTK-ID-00046][Error] When both issues (datasphere:mn:issue) and regions (datasphere:mn:region) are specified
            for in a Mission Need NTK instance, the version of the list specified for both must be the 
            same.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M24"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M24"/>
   <xsl:template match="@*|node()" priority="-2" mode="M24">
      <xsl:apply-templates select="*" mode="M24"/>
   </xsl:template>

   <!--PATTERN NTK-ID-00028-->


	<!--RULE -->
<xsl:template match="ntk:AccessProfile[ntk:ProfileDes='urn:us:gov:ic:ntk:profile:agencydissem']"
                 priority="1000"
                 mode="M25">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ntk:AccessProfile[ntk:ProfileDes='urn:us:gov:ic:ntk:profile:agencydissem']"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(ntk:AccessProfileValue[@ntk:qualifier='originator']) = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(ntk:AccessProfileValue[@ntk:qualifier='originator']) = 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [NTK-ID-00028][Error] An Agency Dissemination NTK must have one and only one entry
            qualified as the originator.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M25"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M25"/>
   <xsl:template match="@*|node()" priority="-2" mode="M25">
      <xsl:apply-templates select="*" mode="M25"/>
   </xsl:template>

   <!--PATTERN NTK-ID-00035-->


	<!--RULE -->
<xsl:template match="ntk:AccessProfile[ntk:ProfileDes='urn:us:gov:ic:ntk:profile:agencydissem']/ntk:AccessProfileValue"
                 priority="1000"
                 mode="M26">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ntk:AccessProfile[ntk:ProfileDes='urn:us:gov:ic:ntk:profile:agencydissem']/ntk:AccessProfileValue"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="@ntk:qualifier = 'originator' or @ntk:qualifier = 'dissemto'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="@ntk:qualifier = 'originator' or @ntk:qualifier = 'dissemto'">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[NTK-ID-00035][Error] The
         @ntk:qualifier attribute value of either ‘originator’ or ‘dissemto’ is required on every AccessProfileValue
         element for NTK Access Profiles based on the Agency Dissemination profile DES.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M26"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M26"/>
   <xsl:template match="@*|node()" priority="-2" mode="M26">
      <xsl:apply-templates select="*" mode="M26"/>
   </xsl:template>

   <!--PATTERN NTK-ID-00021-->


	<!--RULE -->
<xsl:template match="ntk:AccessProfile[ntk:ProfileDes = 'urn:us:gov:ic:ntk:profile:datasphere']/ntk:VocabularyType"
                 priority="1000"
                 mode="M27">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ntk:AccessProfile[ntk:ProfileDes = 'urn:us:gov:ic:ntk:profile:datasphere']/ntk:VocabularyType"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="starts-with(@ntk:name, 'datasphere:')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="starts-with(@ntk:name, 'datasphere:')">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[NTK-ID-00021][Error] For
            ntk:VocabularyType elements in Datasphere NTK assertions, the @ntk:name attribute must start with
            ‘datasphere:’.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M27"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M27"/>
   <xsl:template match="@*|node()" priority="-2" mode="M27">
      <xsl:apply-templates select="*" mode="M27"/>
   </xsl:template>

   <!--PATTERN NTK-ID-00022-->


	<!--RULE -->
<xsl:template match="ntk:AccessProfile[ntk:ProfileDes = 'urn:us:gov:ic:ntk:profile:datasphere']/ntk:AccessProfileValue"
                 priority="1000"
                 mode="M28">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ntk:AccessProfile[ntk:ProfileDes = 'urn:us:gov:ic:ntk:profile:datasphere']/ntk:AccessProfileValue"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="starts-with(@ntk:vocabulary, 'datasphere:')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="starts-with(@ntk:vocabulary, 'datasphere:')">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[NTK-ID-00022][Error] For
            ntk:AccessProfileValue elements in Datasphere NTK assertions, the @ntk:vocabulary attribute must start with
            ‘datasphere:’.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M28"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M28"/>
   <xsl:template match="@*|node()" priority="-2" mode="M28">
      <xsl:apply-templates select="*" mode="M28"/>
   </xsl:template>

   <!--PATTERN NTK-ID-00040-->


	<!--RULE -->
<xsl:template match="ntk:AccessProfile[ntk:AccessPolicy = 'urn:us:gov:ic:aces:ntk:xd']/ntk:AccessProfileValue"
                 priority="1000"
                 mode="M29">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ntk:AccessProfile[ntk:AccessPolicy = 'urn:us:gov:ic:aces:ntk:xd']/ntk:AccessProfileValue"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="@ntk:vocabulary = 'organization:usa-agency'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="@ntk:vocabulary = 'organization:usa-agency'">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[NTK-ID-00040][Error] EXDIS requires the USA-Agency
         Vocabulary (organization:usa-agency).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M29"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M29"/>
   <xsl:template match="@*|node()" priority="-2" mode="M29">
      <xsl:apply-templates select="*" mode="M29"/>
   </xsl:template>

   <!--PATTERN NTK-ID-00050-->


	<!--RULE -->
<xsl:template match="ntk:AccessProfile[ntk:AccessPolicy = 'urn:us:gov:ic:aces:ntk:xd']"
                 priority="1000"
                 mode="M30">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ntk:AccessProfile[ntk:AccessPolicy = 'urn:us:gov:ic:aces:ntk:xd']"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="ntk:ProfileDes = 'urn:us:gov:ic:ntk:profile:agencydissem'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="ntk:ProfileDes = 'urn:us:gov:ic:ntk:profile:agencydissem'">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[NTK-ID-00050][Error] 
         EXDIS profiles requires ntk:ProfileDes with type agencydissem (urn:us:gov:ic:ntk:profile:agencydissem).
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M30"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M30"/>
   <xsl:template match="@*|node()" priority="-2" mode="M30">
      <xsl:apply-templates select="*" mode="M30"/>
   </xsl:template>

   <!--PATTERN NTK-ID-00002-->


	<!--RULE -->
<xsl:template match="ntk:RequiresAnyOf|ntk:RequiresAllOf"
                 priority="1000"
                 mode="M31">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ntk:RequiresAnyOf|ntk:RequiresAllOf"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="ntk:AccessProfileList"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ntk:AccessProfileList">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [NTK-ID-00002][Error]
            ntk:RequiresAnyOf and ntk:RequiresAllOf must contain ntk:AccessProfileList.
            
            Human Readable: ntk:RequiresAnyOf and ntk:RequiresAllOf must have the child element ntk:AccessProfileList.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M31"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M31"/>
   <xsl:template match="@*|node()" priority="-2" mode="M31">
      <xsl:apply-templates select="*" mode="M31"/>
   </xsl:template>

   <!--PATTERN NTK-ID-00004-->


	<!--RULE -->
<xsl:template match="*[@ntk:*]" priority="1000" mode="M32">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="*[@ntk:*]"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="every $attribute in @ntk:* satisfies               normalize-space(string($attribute))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $attribute in @ntk:* satisfies normalize-space(string($attribute))">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [NTK-ID-00004][Error] Every attribute in the document must be specified with a non-whitespace value.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M32"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M32"/>
   <xsl:template match="@*|node()" priority="-2" mode="M32">
      <xsl:apply-templates select="*" mode="M32"/>
   </xsl:template>

   <!--PATTERN NTK-ID-00006-->


	<!--RULE -->
<xsl:template match="/*[descendant-or-self::ntk:* or descendant-or-self::*/@ntk:*]"
                 priority="1000"
                 mode="M33">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*[descendant-or-self::ntk:* or descendant-or-self::*/@ntk:*]"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="some $element in descendant-or-self::node() satisfies $element/@ntk:DESVersion"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="some $element in descendant-or-self::node() satisfies $element/@ntk:DESVersion">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [NTK-ID-00006][Error] The attribute 
            DESVersion in the namespace urn:us:gov:ic:ntk must be specified.
            
            Human Readable: The data encoding specification version must 
            be specified.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M33"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M33"/>
   <xsl:template match="@*|node()" priority="-2" mode="M33">
      <xsl:apply-templates select="*" mode="M33"/>
   </xsl:template>

   <!--PATTERN NTK-ID-00007-->


	<!--RULE -->
<xsl:template match="ntk:ExternalAccess" priority="1000" mode="M34">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="ntk:ExternalAccess"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="@ntk:externalReference=true()"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="@ntk:externalReference=true()">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [NTK-ID-00007][Error] The attribute @ntk:externalReference must be set to 
            true when the ExternalAccess element is used.
            
            Human Readable: If the ExternalAccess element is used, then the attribute @ntk:externalReference must have a value of true.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M34"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M34"/>
   <xsl:template match="@*|node()" priority="-2" mode="M34">
      <xsl:apply-templates select="*" mode="M34"/>
   </xsl:template>

   <!--PATTERN NTK-ID-00009-->


	<!--RULE -->
<xsl:template match="*[@ism:DESVersion]" priority="1000" mode="M35">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="*[@ism:DESVersion]"/>
      <xsl:variable name="version"
                    select="number(if (contains(@ism:DESVersion,'-')) then substring-before(@ism:DESVersion,'-') else @ism:DESVersion)"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="$version &gt;= 201508"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="$version &gt;= 201508">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[NTK-ID-00009][Error] The @ism:DESVersion is less than the
         minimum version allowed: 201508.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M35"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M35"/>
   <xsl:template match="@*|node()" priority="-2" mode="M35">
      <xsl:apply-templates select="*" mode="M35"/>
   </xsl:template>

   <!--PATTERN NTK-ID-00018-->


	<!--RULE -->
<xsl:template match="ntk:VocabularyType[@ntk:name]" priority="1000" mode="M36">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ntk:VocabularyType[@ntk:name]"/>
      <xsl:variable name="root" select="substring-before(@ntk:name,':')"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="string-length($root)&gt;0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="string-length($root)&gt;0">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [NTK-ID-00018][Error] Vocabulary declarations must have a root from one of the built-in 
            types of 'datasphere', 'organization', 'individual', or 'group'. Declaration of custom
            root types are not permitted.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="some $value in ('datasphere', 'organization', 'individual', 'group') satisfies $root=$value"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="some $value in ('datasphere', 'organization', 'individual', 'group') satisfies $root=$value">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [NTK-ID-00018][Error] Vocabulary declarations must have a root from one of the built-in 
            types of 'datasphere', 'organization', 'individual', or 'group'. The root vocabulary type 
            found [<xsl:text/>
                  <xsl:value-of select="$root"/>
                  <xsl:text/>] is not valid.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M36"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M36"/>
   <xsl:template match="@*|node()" priority="-2" mode="M36">
      <xsl:apply-templates select="*" mode="M36"/>
   </xsl:template>

   <!--PATTERN NTK-ID-00019-->


	<!--RULE -->
<xsl:template match="ntk:VocabularyType[not(@ntk:source)]"
                 priority="1000"
                 mode="M37">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ntk:VocabularyType[not(@ntk:source)]"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(some $type in $builtinVocab satisfies $type=@ntk:name)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="(some $type in $builtinVocab satisfies $type=@ntk:name)">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [NTK-ID-00019][Error] VocabularyTypes must have a source unless being derived from 
            an existing built-in type.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M37"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M37"/>
   <xsl:template match="@*|node()" priority="-2" mode="M37">
      <xsl:apply-templates select="*" mode="M37"/>
   </xsl:template>

   <!--PATTERN NTK-ID-00020-->


	<!--RULE -->
<xsl:template match="ntk:AccessProfileValue" priority="1000" mode="M38">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ntk:AccessProfileValue"/>
      <xsl:variable name="definedTypes"
                    select="preceding-sibling::ntk:VocabularyType/@ntk:name"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(some $value in $builtinVocab satisfies $value=@ntk:vocabulary)             or (some $value in $definedTypes satisfies $value=@ntk:vocabulary)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="(some $value in $builtinVocab satisfies $value=@ntk:vocabulary) or (some $value in $definedTypes satisfies $value=@ntk:vocabulary)">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [NTK-ID-00020][Error] Undefined vocabulary type: <xsl:text/>
                  <xsl:value-of select="@ntk:vocabulary"/>
                  <xsl:text/>. 
            All vocabularies used must be of a builtin vocabulary type or 
            be defined in this ntk:AccessProfile in an ntk:VocabularyType. 
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M38"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M38"/>
   <xsl:template match="@*|node()" priority="-2" mode="M38">
      <xsl:apply-templates select="*" mode="M38"/>
   </xsl:template>

   <!--PATTERN NTK-ID-00023-->


	<!--RULE -->
<xsl:template match="ntk:AccessProfile[ntk:AccessProfileValue or ntk:VocabularyType]"
                 priority="1000"
                 mode="M39">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ntk:AccessProfile[ntk:AccessProfileValue or ntk:VocabularyType]"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="ntk:ProfileDes"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ntk:ProfileDes">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [NTK-ID-00023][Error] If ntk:AccessProfileValue or ntk:VocabularyType are specified then there must
            be a Profile DES that defines the use of the ntk:AccessProfile structure.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M39"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M39"/>
   <xsl:template match="@*|node()" priority="-2" mode="M39">
      <xsl:apply-templates select="*" mode="M39"/>
   </xsl:template>

   <!--PATTERN NTK-ID-00024-->


	<!--RULE -->
<xsl:template match="ntk:ProfileDes" priority="1000" mode="M40">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="ntk:ProfileDes"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="following-sibling::ntk:AccessProfileValue"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="following-sibling::ntk:AccessProfileValue">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [NTK-ID-00024][Error] If there is a Profile DES specified, then there must be at least
            one ntk:AccessProfileValue.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M40"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M40"/>
   <xsl:template match="@*|node()" priority="-2" mode="M40">
      <xsl:apply-templates select="*" mode="M40"/>
   </xsl:template>

   <!--PATTERN NTK-ID-00025-->


	<!--RULE -->
<xsl:template match="ntk:VocabularyType[index-of($builtinVocab, @ntk:name) &gt; 0 and @ntk:source]"
                 priority="1000"
                 mode="M41">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ntk:VocabularyType[index-of($builtinVocab, @ntk:name) &gt; 0 and @ntk:source]"/>
      <xsl:variable name="index" select="index-of($builtinVocab, @ntk:name)"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="@ntk:source=$builtinVocabSource[$index]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="@ntk:source=$builtinVocabSource[$index]">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [NTK-ID-00025][Error] Sources cannot be overridden. If a
            built-in vocabulary type is specified and the source attribute is present it must equal
            the built-in source. The source [<xsl:text/>
                  <xsl:value-of select="@ntk:source"/>
                  <xsl:text/>] is invalid with
            respect to the vocabulary type [<xsl:text/>
                  <xsl:value-of select="@ntk:name"/>
                  <xsl:text/>]. A source of
            [<xsl:text/>
                  <xsl:value-of select="$builtinVocabSource[$index]"/>
                  <xsl:text/>] is expected.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M41"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M41"/>
   <xsl:template match="@*|node()" priority="-2" mode="M41">
      <xsl:apply-templates select="*" mode="M41"/>
   </xsl:template>

   <!--PATTERN NTK-ID-00027-->


	<!--RULE -->
<xsl:template match="ntk:AccessProfile/ntk:AccessProfileValue[@ntk:vocabulary='organization:usa-agency']"
                 priority="1000"
                 mode="M42">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ntk:AccessProfile/ntk:AccessProfileValue[@ntk:vocabulary='organization:usa-agency']"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="every $searchTerm in tokenize(normalize-space(string(.)), ' ') satisfies                   $searchTerm = $usagencyList or (some $Term in $usagencyList satisfies (matches(normalize-space($searchTerm), concat('^',$Term,'$'))))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $searchTerm in tokenize(normalize-space(string(.)), ' ') satisfies $searchTerm = $usagencyList or (some $Term in $usagencyList satisfies (matches(normalize-space($searchTerm), concat('^',$Term,'$'))))">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="'[NTK-ID-00027][Error] organization:usa-agency vocabulary values must exist in the USAgency CVE.'"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M42"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M42"/>
   <xsl:template match="@*|node()" priority="-2" mode="M42">
      <xsl:apply-templates select="*" mode="M42"/>
   </xsl:template>

   <!--PATTERN NTK-ID-00029-->


	<!--RULE -->
<xsl:template match="ntk:AccessProfile[ntk:AccessProfileValue/@ntk:vocabulary='organization:usa-agency']"
                 priority="1000"
                 mode="M43">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ntk:AccessProfile[ntk:AccessProfileValue/@ntk:vocabulary='organization:usa-agency']"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="ntk:VocabularyType[@ntk:name='organization:usa-agency']/@ntk:sourceVersion"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="ntk:VocabularyType[@ntk:name='organization:usa-agency']/@ntk:sourceVersion">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="'[NTK-ID-00029][Error] An @ntk:sourceVersion must be specified for the built-in organization:usa-agency vocabulary type.'"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M43"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M43"/>
   <xsl:template match="@*|node()" priority="-2" mode="M43">
      <xsl:apply-templates select="*" mode="M43"/>
   </xsl:template>

   <!--PATTERN NTK-ID-00032-->


	<!--RULE -->
<xsl:template match="ntk:AccessProfile[ntk:AccessProfileValue/@ntk:vocabulary='datasphere:mn:issue']"
                 priority="1000"
                 mode="M44">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ntk:AccessProfile[ntk:AccessProfileValue/@ntk:vocabulary='datasphere:mn:issue']"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="ntk:VocabularyType[@ntk:name='datasphere:mn:issue']/@ntk:sourceVersion"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="ntk:VocabularyType[@ntk:name='datasphere:mn:issue']/@ntk:sourceVersion">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="'[NTK-ID-00032][Error] An @ntk:sourceVersion must be specified for the built-in datasphere:mn:issue vocabulary type.'"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M44"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M44"/>
   <xsl:template match="@*|node()" priority="-2" mode="M44">
      <xsl:apply-templates select="*" mode="M44"/>
   </xsl:template>

   <!--PATTERN NTK-ID-00033-->


	<!--RULE -->
<xsl:template match="ntk:AccessProfile[ntk:AccessProfileValue/@ntk:vocabulary='datasphere:mn:region']"
                 priority="1000"
                 mode="M45">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ntk:AccessProfile[ntk:AccessProfileValue/@ntk:vocabulary='datasphere:mn:region']"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="ntk:VocabularyType[@ntk:name='datasphere:mn:region']/@ntk:sourceVersion"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="ntk:VocabularyType[@ntk:name='datasphere:mn:region']/@ntk:sourceVersion">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="'[NTK-ID-00033][Error]An @ntk:sourceVersion must be specified for the built-in datasphere:mn:region vocabulary type.'"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M45"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M45"/>
   <xsl:template match="@*|node()" priority="-2" mode="M45">
      <xsl:apply-templates select="*" mode="M45"/>
   </xsl:template>

   <!--PATTERN NTK-ID-00041-->


	<!--RULE -->
<xsl:template match="ntk:Access//ntk:VocabularyType[@ntk:name='datasphere:mn:region']"
                 priority="1003"
                 mode="M46">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ntk:Access//ntk:VocabularyType[@ntk:name='datasphere:mn:region']"/>
      <xsl:variable name="vocab" select="'datasphere:mn:region'"/>
      <xsl:variable name="versions"
                    select="distinct-values(for $version in //ntk:Access//ntk:VocabularyType[@ntk:name=$vocab]/@ntk:sourceVersion return $version)"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(count($versions)&gt;1)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(count($versions)&gt;1)">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[NTK-ID-00041][Error] 
        Source versions (@ntk:sourceVersion) must be consistent for all NTK Profiles
        within a document that contribute to the actual overall access restrictions of the document.
        Found <xsl:text/>
                  <xsl:value-of select="$vocab"/>
                  <xsl:text/> versions: <xsl:text/>
                  <xsl:value-of select="$versions"/>
                  <xsl:text/> 
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M46"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="ntk:Access//ntk:VocabularyType[@ntk:name='datasphere:mn:issue']"
                 priority="1002"
                 mode="M46">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ntk:Access//ntk:VocabularyType[@ntk:name='datasphere:mn:issue']"/>
      <xsl:variable name="vocab" select="'datasphere:mn:issue'"/>
      <xsl:variable name="versions"
                    select="distinct-values(for $version in //ntk:Access//ntk:VocabularyType[@ntk:name=$vocab]/@ntk:sourceVersion return $version)"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(count($versions)&gt;1)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(count($versions)&gt;1)">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[NTK-ID-00041][Error] 
        Source versions (@ntk:sourceVersion) must be consistent for all NTK Profiles
        within a document that contribute to the actual overall access restrictions of the document.
        Found <xsl:text/>
                  <xsl:value-of select="$vocab"/>
                  <xsl:text/> versions: <xsl:text/>
                  <xsl:value-of select="$versions"/>
                  <xsl:text/> 
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M46"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="ntk:Access//ntk:VocabularyType[@ntk:name='organization:usa-agency']"
                 priority="1001"
                 mode="M46">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ntk:Access//ntk:VocabularyType[@ntk:name='organization:usa-agency']"/>
      <xsl:variable name="vocab" select="'organization:usa-agency'"/>
      <xsl:variable name="versions"
                    select="distinct-values(for $version in //ntk:Access//ntk:VocabularyType[@ntk:name=$vocab]/@ntk:sourceVersion return $version)"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(count($versions)&gt;1)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(count($versions)&gt;1)">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[NTK-ID-00041][Error] 
        Source versions (@ntk:sourceVersion) must be consistent for all NTK Profiles
        within a document that contribute to the actual overall access restrictions of the document.
        Found <xsl:text/>
                  <xsl:value-of select="$vocab"/>
                  <xsl:text/> versions: <xsl:text/>
                  <xsl:value-of select="$versions"/>
                  <xsl:text/> 
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M46"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="ntk:Access//ntk:VocabularyType[@ntk:name='datasphere:license']"
                 priority="1000"
                 mode="M46">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ntk:Access//ntk:VocabularyType[@ntk:name='datasphere:license']"/>
      <xsl:variable name="vocab" select="'datasphere:license'"/>
      <xsl:variable name="versions"
                    select="distinct-values(for $version in //ntk:Access//ntk:VocabularyType[@ntk:name=$vocab]/@ntk:sourceVersion return $version)"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(count($versions)&gt;1)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(count($versions)&gt;1)">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[NTK-ID-00041][Error] 
        Source versions (@ntk:sourceVersion) must be consistent for all NTK Profiles
        within a document that contribute to the actual overall access restrictions of the document.
        Found <xsl:text/>
                  <xsl:value-of select="$vocab"/>
                  <xsl:text/> versions: <xsl:text/>
                  <xsl:value-of select="$versions"/>
                  <xsl:text/> 
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M46"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M46"/>
   <xsl:template match="@*|node()" priority="-2" mode="M46">
      <xsl:apply-templates select="*" mode="M46"/>
   </xsl:template>

   <!--PATTERN NTK-ID-00042-->


	<!--RULE -->
<xsl:template match="ntk:AccessPolicy[starts-with(., 'urn:us:gov:ic:aces:ntk:')]"
                 priority="1000"
                 mode="M47">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ntk:AccessPolicy[starts-with(., 'urn:us:gov:ic:aces:ntk:')]"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="some $Term in $accessPolicyList satisfies (matches(normalize-space(.), concat('^',$Term,'$')))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="some $Term in $accessPolicyList satisfies (matches(normalize-space(.), concat('^',$Term,'$')))">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="'[NTK-ID-00042][Error] Access Policy URNs that start with IC CIO reserved portion must exist in NTKAccessPolicy CVE.'"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M47"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M47"/>
   <xsl:template match="@*|node()" priority="-2" mode="M47">
      <xsl:apply-templates select="*" mode="M47"/>
   </xsl:template>

   <!--PATTERN NTK-ID-00043-->


	<!--RULE -->
<xsl:template match="ntk:Access//ntk:VocabularyType[@ntk:name='datasphere:mn:region']"
                 priority="1002"
                 mode="M48">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ntk:Access//ntk:VocabularyType[@ntk:name='datasphere:mn:region']"/>
      <xsl:variable name="cve"
                    select="document('../../CVE/MN/CVEnumMNRegion.xml')//cve:CVE"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="$cve/@specVersion = @ntk:sourceVersion"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="$cve/@specVersion = @ntk:sourceVersion">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[NTK-ID-00043][Error] 
        The source version (@ntk:sourceVersion) must match the version of the CVE being used
        to validate values of the NTK instance.
        The NTK claims that the vocabulary <xsl:text/>
                  <xsl:value-of select="@ntk:name"/>
                  <xsl:text/> is compliant with 
        <xsl:text/>
                  <xsl:value-of select="@ntk:sourceVersion"/>
                  <xsl:text/>, but the CVE used points at spec version 
        <xsl:text/>
                  <xsl:value-of select="$cve/@specVersion"/>
                  <xsl:text/>.
     </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M48"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="ntk:Access//ntk:VocabularyType[@ntk:name='datasphere:mn:issue']"
                 priority="1001"
                 mode="M48">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ntk:Access//ntk:VocabularyType[@ntk:name='datasphere:mn:issue']"/>
      <xsl:variable name="cve" select="document('../../CVE/MN/CVEnumMNIssue.xml')//cve:CVE"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="$cve/@specVersion = @ntk:sourceVersion"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="$cve/@specVersion = @ntk:sourceVersion">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[NTK-ID-00043][Error] 
        The source version (@ntk:sourceVersion) must match the version of the CVE being used
        to validate values of the NTK instance.
        The NTK claims that the vocabulary <xsl:text/>
                  <xsl:value-of select="@ntk:name"/>
                  <xsl:text/> is compliant with 
        <xsl:text/>
                  <xsl:value-of select="@ntk:sourceVersion"/>
                  <xsl:text/>, but the CVE used points at spec version 
        <xsl:text/>
                  <xsl:value-of select="$cve/@specVersion"/>
                  <xsl:text/>.
     </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M48"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="ntk:Access//ntk:VocabularyType[@ntk:name='datasphere:license']"
                 priority="1000"
                 mode="M48">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ntk:Access//ntk:VocabularyType[@ntk:name='datasphere:license']"/>
      <xsl:variable name="cve"
                    select="document('../../CVE/LIC/CVEnumLicLicense.xml')//cve:CVE"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="$cve/@specVersion = @ntk:sourceVersion"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="$cve/@specVersion = @ntk:sourceVersion">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[NTK-ID-00043][Error] 
        The source version (@ntk:sourceVersion) must match the version of the CVE being used
        to validate values of the NTK instance.
        The NTK claims that the vocabulary <xsl:text/>
                  <xsl:value-of select="@ntk:name"/>
                  <xsl:text/> is compliant with 
        <xsl:text/>
                  <xsl:value-of select="@ntk:sourceVersion"/>
                  <xsl:text/>, but the CVE used points at spec version 
        <xsl:text/>
                  <xsl:value-of select="$cve/@specVersion"/>
                  <xsl:text/>.
     </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M48"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M48"/>
   <xsl:template match="@*|node()" priority="-2" mode="M48">
      <xsl:apply-templates select="*" mode="M48"/>
   </xsl:template>

   <!--PATTERN NTK-ID-00044-->


	<!--RULE -->
<xsl:template match="ntk:AccessProfile[ntk:AccessProfileValue/@ntk:vocabulary='datasphere:license']"
                 priority="1000"
                 mode="M49">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ntk:AccessProfile[ntk:AccessProfileValue/@ntk:vocabulary='datasphere:license']"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="ntk:VocabularyType[@ntk:name='datasphere:license']/@ntk:sourceVersion"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="ntk:VocabularyType[@ntk:name='datasphere:license']/@ntk:sourceVersion">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="'[NTK-ID-00044][Error]An @ntk:sourceVersion must be specified for the built-in datasphere:license vocabulary type.'"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M49"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M49"/>
   <xsl:template match="@*|node()" priority="-2" mode="M49">
      <xsl:apply-templates select="*" mode="M49"/>
   </xsl:template>

   <!--PATTERN NTK-ID-00045-->


	<!--RULE -->
<xsl:template match="ntk:AccessProfileValue[@ntk:vocabulary='datasphere:license']"
                 priority="1000"
                 mode="M50">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ntk:AccessProfileValue[@ntk:vocabulary='datasphere:license']"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="some $Term in $licenseList satisfies (matches(normalize-space(.), concat('^',$Term,'$')))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="some $Term in $licenseList satisfies (matches(normalize-space(.), concat('^',$Term,'$')))">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="'[NTK-ID-00045][Error] If an ntk:AccessProfileValue with @ntk:vocabulary of [datasphere:license]        is specified, then the value must exist in the LIC.CES License CVE (CVEnumLicLicense.xml)'"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M50"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M50"/>
   <xsl:template match="@*|node()" priority="-2" mode="M50">
      <xsl:apply-templates select="*" mode="M50"/>
   </xsl:template>

   <!--PATTERN NTK-ID-00048-->


	<!--RULE -->
<xsl:template match="ntk:AccessPolicy | ntk:ProfileDes | ntk:AccessProfileValue"
                 priority="1000"
                 mode="M51">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ntk:AccessPolicy | ntk:ProfileDes | ntk:AccessProfileValue"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(empty(text()))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(empty(text()))">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [NTK-ID-00048][Error] ntk:AccessPolicy, ntk:ProfileDes, and ntk:AccessProfileValue are required to have text content.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M51"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M51"/>
   <xsl:template match="@*|node()" priority="-2" mode="M51">
      <xsl:apply-templates select="*" mode="M51"/>
   </xsl:template>

   <!--PATTERN NTK-ID-00051-->


	<!--RULE -->
<xsl:template match="ntk:ProfileDes[starts-with(., 'urn:us:gov:ic:ntk:')]"
                 priority="1000"
                 mode="M52">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ntk:ProfileDes[starts-with(., 'urn:us:gov:ic:ntk:')]"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="some $Term in $profileDESList satisfies (matches(normalize-space(.), concat('^',$Term,'$')))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="some $Term in $profileDESList satisfies (matches(normalize-space(.), concat('^',$Term,'$')))">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="'[NTK-ID-00051][Error] Profile DES URNs that start with IC CIO reserved portion must exist in NTKProfileDes CVE.'"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M52"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M52"/>
   <xsl:template match="@*|node()" priority="-2" mode="M52">
      <xsl:apply-templates select="*" mode="M52"/>
   </xsl:template>

   <!--PATTERN NTK-ID-00016-->


	<!--RULE -->
<xsl:template match="ntk:AccessProfile[ntk:ProfileDes = 'urn:us:gov:ic:ntk:profile:grp-ind']/ntk:VocabularyType"
                 priority="1000"
                 mode="M53">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ntk:AccessProfile[ntk:ProfileDes = 'urn:us:gov:ic:ntk:profile:grp-ind']/ntk:VocabularyType"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="starts-with(@ntk:name, 'group:') or starts-with(@ntk:name, 'individual:')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="starts-with(@ntk:name, 'group:') or starts-with(@ntk:name, 'individual:')">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[NTK-ID-00016][Error] The @ntk:name attribute must start with either ‘group:’ or
            ‘individual:’.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M53"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M53"/>
   <xsl:template match="@*|node()" priority="-2" mode="M53">
      <xsl:apply-templates select="*" mode="M53"/>
   </xsl:template>

   <!--PATTERN NTK-ID-00017-->


	<!--RULE -->
<xsl:template match="ntk:AccessProfile[ntk:ProfileDes = 'urn:us:gov:ic:ntk:profile:grp-ind']/ntk:AccessProfileValue"
                 priority="1000"
                 mode="M54">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ntk:AccessProfile[ntk:ProfileDes = 'urn:us:gov:ic:ntk:profile:grp-ind']/ntk:AccessProfileValue"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="starts-with(@ntk:vocabulary, 'group:') or starts-with(@ntk:vocabulary, 'individual:')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="starts-with(@ntk:vocabulary, 'group:') or starts-with(@ntk:vocabulary, 'individual:')">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[NTK-ID-00017][Error] The @ntk:vocabulary attribute must start with ‘group:’ or
            ‘individual:’.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M54"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M54"/>
   <xsl:template match="@*|node()" priority="-2" mode="M54">
      <xsl:apply-templates select="*" mode="M54"/>
   </xsl:template>

   <!--PATTERN NTK-ID-00039-->


	<!--RULE -->
<xsl:template match="ntk:AccessProfile[ntk:AccessPolicy = 'urn:us:gov:ic:aces:ntk:oc']/ntk:AccessProfileValue"
                 priority="1000"
                 mode="M55">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ntk:AccessProfile[ntk:AccessPolicy = 'urn:us:gov:ic:aces:ntk:oc']/ntk:AccessProfileValue"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="@ntk:vocabulary = 'organization:usa-agency'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="@ntk:vocabulary = 'organization:usa-agency'">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[NTK-ID-00039][Error] ORCON requires the USA-Agency
         Vocabulary (organization:usa-agency).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M55"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M55"/>
   <xsl:template match="@*|node()" priority="-2" mode="M55">
      <xsl:apply-templates select="*" mode="M55"/>
   </xsl:template>

   <!--PATTERN NTK-ID-00049-->


	<!--RULE -->
<xsl:template match="ntk:AccessProfile[ntk:AccessPolicy = 'urn:us:gov:ic:aces:ntk:oc']"
                 priority="1000"
                 mode="M56">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ntk:AccessProfile[ntk:AccessPolicy = 'urn:us:gov:ic:aces:ntk:oc']"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="ntk:ProfileDes = 'urn:us:gov:ic:ntk:profile:agencydissem'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="ntk:ProfileDes = 'urn:us:gov:ic:ntk:profile:agencydissem'">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[NTK-ID-00049][Error] 
         ORCON profiles requires ntk:ProfileDes with type agencydissem (urn:us:gov:ic:ntk:profile:agencydissem).
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M56"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M56"/>
   <xsl:template match="@*|node()" priority="-2" mode="M56">
      <xsl:apply-templates select="*" mode="M56"/>
   </xsl:template>

   <!--PATTERN NTK-ID-00034-->


	<!--RULE -->
<xsl:template match="ntk:AccessProfile[ntk:AccessPolicy='urn:us:gov:ic:aces:ntk:permissive']/ntk:ProfileDes"
                 priority="1000"
                 mode="M57">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ntk:AccessProfile[ntk:AccessPolicy='urn:us:gov:ic:aces:ntk:permissive']/ntk:ProfileDes"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test=". = 'urn:us:gov:ic:ntk:profile:grp-ind'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test=". = 'urn:us:gov:ic:ntk:profile:grp-ind'">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[NTK-ID-00034][Error] Use of the
         permissive access policy requires the Group and Individual Profile DES.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M57"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M57"/>
   <xsl:template match="@*|node()" priority="-2" mode="M57">
      <xsl:apply-templates select="*" mode="M57"/>
   </xsl:template>

   <!--PATTERN NTK-ID-00014-->


	<!--RULE -->
<xsl:template match="ntk:AccessProfile[matches(ntk:AccessPolicy,'^urn:us:gov:ic:aces:ntk:propin:[1-2]$')]/ntk:ProfileDes"
                 priority="1000"
                 mode="M58">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ntk:AccessProfile[matches(ntk:AccessPolicy,'^urn:us:gov:ic:aces:ntk:propin:[1-2]$')]/ntk:ProfileDes"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test=". = 'urn:us:gov:ic:ntk:profile:grp-ind'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test=". = 'urn:us:gov:ic:ntk:profile:grp-ind'">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[NTK-ID-00014][Error] For group-based PROPIN NTK assertions that contain ntk:ProfileDes elements, ntk:ProfileDes must specify the 
            URN for Profile DES type: ‘grp-ind’.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M58"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M58"/>
   <xsl:template match="@*|node()" priority="-2" mode="M58">
      <xsl:apply-templates select="*" mode="M58"/>
   </xsl:template>

   <!--PATTERN NTK-ID-00015-->


	<!--RULE -->
<xsl:template match="ntk:AccessProfile[ntk:AccessPolicy = 'urn:us:gov:ic:aces:ntk:propin:2']"
                 priority="1000"
                 mode="M59">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ntk:AccessProfile[ntk:AccessPolicy = 'urn:us:gov:ic:aces:ntk:propin:2']"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="ntk:ProfileDes"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ntk:ProfileDes">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[NTK-ID-00015][Error] NTK assertions that use the
            ‘urn:us:gov:ic:aces:ntk:propin:2’ access policy must specify an ntk:ProfileDes element.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M59"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M59"/>
   <xsl:template match="@*|node()" priority="-2" mode="M59">
      <xsl:apply-templates select="*" mode="M59"/>
   </xsl:template>

   <!--PATTERN NTK-ID-00036-->


	<!--RULE -->
<xsl:template match="ntk:AccessPolicy[starts-with(., 'urn:us:gov:ic:aces:ntk:propin:')]"
                 priority="1000"
                 mode="M60">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ntk:AccessPolicy[starts-with(., 'urn:us:gov:ic:aces:ntk:propin:')]"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="string-length(.) &gt; 30"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="string-length(.) &gt; 30">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[NTK-ID-00036][Error] PROPIN access policies
         must have characters after the predefined portion ‘urn:us:gov:ic:aces:ntk:propin:’.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M60"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M60"/>
   <xsl:template match="@*|node()" priority="-2" mode="M60">
      <xsl:apply-templates select="*" mode="M60"/>
   </xsl:template>

   <!--PATTERN NTK-ID-00037-->


	<!--RULE -->
<xsl:template match="ntk:AccessProfile[ntk:AccessPolicy='urn:us:gov:ic:aces:ntk:restrictive']/ntk:ProfileDes"
                 priority="1000"
                 mode="M61">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ntk:AccessProfile[ntk:AccessPolicy='urn:us:gov:ic:aces:ntk:restrictive']/ntk:ProfileDes"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test=". = 'urn:us:gov:ic:ntk:profile:grp-ind'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test=". = 'urn:us:gov:ic:ntk:profile:grp-ind'">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[NTK-ID-00037][Error] Use of the
         restrictive access policy requires the Group and Individual Profile DES.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M61"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M61"/>
   <xsl:template match="@*|node()" priority="-2" mode="M61">
      <xsl:apply-templates select="*" mode="M61"/>
   </xsl:template>

   <!--PATTERN NTK-ID-00038-->


	<!--RULE -->
<xsl:template match="ntk:AccessProfile[ntk:AccessPolicy='urn:us:gov:ic:aces:ntk:restrictive']/ntk:AccessProfileValue"
                 priority="1000"
                 mode="M62">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ntk:AccessProfile[ntk:AccessPolicy='urn:us:gov:ic:aces:ntk:restrictive']/ntk:AccessProfileValue"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="starts-with(@ntk:vocabulary, 'group:')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="starts-with(@ntk:vocabulary, 'group:')">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[NTK-ID-00038][Error] Use of the restrictive
         access policy requires a Group vocabulary type.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M62"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M62"/>
   <xsl:template match="@*|node()" priority="-2" mode="M62">
      <xsl:apply-templates select="*" mode="M62"/>
   </xsl:template>
</xsl:stylesheet>
<!--UNCLASSIFIED-->
