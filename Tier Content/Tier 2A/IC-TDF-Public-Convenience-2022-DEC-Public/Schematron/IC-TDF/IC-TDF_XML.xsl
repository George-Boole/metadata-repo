<?xml version="1.0" encoding="UTF-8"?>
<!--UNCLASSIFIED--><xsl:stylesheet xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                xmlns:saxon="http://saxon.sf.net/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:schold="http://www.ascc.net/xml/schematron"
                xmlns:iso="http://purl.oclc.org/dsdl/schematron"
                xmlns:xhtml="http://www.w3.org/1999/xhtml"
                xmlns:cve="urn:us:gov:ic:cve"
                xmlns:tdf="urn:us:gov:ic:tdf"
                xmlns:ism="urn:us:gov:ic:ism"
                xmlns:arh="urn:us:gov:ic:arh"
                xmlns:edh="urn:us:gov:ic:edh"
                xmlns:ntk="urn:us:gov:ic:ntk"
                xmlns:icid="urn:us:gov:ic:id"
                xmlns:usagency="urn:us:gov:ic:usagency"
                xmlns:revrecall="urn:us:gov:ic:revrecall"
                xmlns:util="urn:us:gov:ic:tdf:xsl:util"
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
<xsl:function xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                 name="util:containsAnyOfTheTokens"
                 as="xs:boolean">
        <xsl:param name="attribute"/>
        <xsl:param name="tokenList" as="xs:string+"/>
        <xsl:value-of select="some $attrToken in tokenize(normalize-space(string($attribute)), ' ') satisfies $attrToken = $tokenList"/>
    </xsl:function>
   <xsl:function xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                 name="util:containsOnlyTheTokens"
                 as="xs:boolean">
        <xsl:param name="attribute"/>
        <xsl:param name="tokenList" as="xs:string+"/>
        <xsl:value-of select="every $attrToken in tokenize(normalize-space(string($attribute)), ' ') satisfies $attrToken = $tokenList"/>
   </xsl:function>

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
         <svrl:text>
        This is the root file for the specifications Schematron ruleset. It loads all of the required CVEs, 
        declares some variables, and includes all of the Rule .sch files.</svrl:text>
         <svrl:ns-prefix-in-attribute-values uri="http://www.w3.org/2001/XMLSchema" prefix="xs"/>
         <svrl:ns-prefix-in-attribute-values uri="urn:us:gov:ic:cve" prefix="cve"/>
         <svrl:ns-prefix-in-attribute-values uri="urn:us:gov:ic:cve" prefix="cve"/>
         <svrl:ns-prefix-in-attribute-values uri="urn:us:gov:ic:tdf" prefix="tdf"/>
         <svrl:ns-prefix-in-attribute-values uri="urn:us:gov:ic:ism" prefix="ism"/>
         <svrl:ns-prefix-in-attribute-values uri="urn:us:gov:ic:arh" prefix="arh"/>
         <svrl:ns-prefix-in-attribute-values uri="urn:us:gov:ic:edh" prefix="edh"/>
         <svrl:ns-prefix-in-attribute-values uri="urn:us:gov:ic:ntk" prefix="ntk"/>
         <svrl:ns-prefix-in-attribute-values uri="urn:us:gov:ic:id" prefix="icid"/>
         <svrl:ns-prefix-in-attribute-values uri="urn:us:gov:ic:usagency" prefix="usagency"/>
         <svrl:ns-prefix-in-attribute-values uri="urn:us:gov:ic:revrecall" prefix="revrecall"/>
         <svrl:ns-prefix-in-attribute-values uri="urn:us:gov:ic:tdf:xsl:util" prefix="util"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-TDF-ID-00026</xsl:attribute>
            <xsl:attribute name="name">IC-TDF-ID-00026</xsl:attribute>
            <svrl:text>[IC-TDF-ID-00026][Error] If payload attribute @isEncrypted="true", then there needs to be two handling assertions
           with attribute scope="PAYL": one with attribute @appliesToState="encrypted" and the other with attribute appliesToState="unencrypted".
           Human Readable: Encrypted payloads require handling assertions for both encrypted and unencrypted payload states.</svrl:text>
            <svrl:text>If there exists a TDO payload element with attribute @isEncrypted as true, this rule ensures there is one handling
           assertion of @scope PAYL and @appliestostate of encrypted, and one handling assertion of @scope PAYL and @appliestostate of
           unencrypted.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M15"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-TDF-ID-00027</xsl:attribute>
            <xsl:attribute name="name">IC-TDF-ID-00027</xsl:attribute>
            <svrl:text>[IC-TDF-ID-00027][Error] If payload attribute @isEncrypted="true", the handling assertion with @scope="PAYL" that
           contains @appliesToState="unencrypted" must contain an edh:externalEDH. Human Readable: When content is encrypted, the handling assertion
           describing the content in an unencrypted state is in effect external.</svrl:text>
            <svrl:text>If there exists a TDO payload element with attribute @isEncrypted as true, this rule ensures that there is one
           handling assertion of @scope PAYL, @appliestostate of unencrypted, and has descendant element ExternalEdh.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M16"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-TDF-ID-00028</xsl:attribute>
            <xsl:attribute name="name">IC-TDF-ID-00028</xsl:attribute>
            <svrl:text>[IC-TDF-ID-00028][Error] If payload attribute @isEncrypted="true" and the payload is not external, the handling
           assertion with @scope="PAYL" that contains @appliesToState="encrypted" must contain a regular edh:EDH. Human Readable: Internal content
           requires an EDH.</svrl:text>
            <svrl:text>Given a TDO with an internal payload with attribute @isEncrypted="true", the handling assertion with @scope="PAYL"
           that contains @appliesToState="encrypted" must contain a regular edh:EDH.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M17"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-TDF-ID-00030</xsl:attribute>
            <xsl:attribute name="name">IC-TDF-ID-00030</xsl:attribute>
            <svrl:text>[IC-TDF-ID-00030][Error] If statement attribute @isEncrypted="true", the statement metadata that contains
           @appliesToState="unencrypted" must contain an arh:ExternalSecurity Human Readable: When statement content is encrypted, the handling
           statement describing the content in an unencrypted state is in effect external.</svrl:text>
            <svrl:text>Given a TDO with an encrypted assertion (statement attribute @isEncrypted="true"), the statement metadata that
           contains @appliesToState="unencrypted" must contain an arh:ExternalSecurity.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M18"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-TDF-ID-00031</xsl:attribute>
            <xsl:attribute name="name">IC-TDF-ID-00031</xsl:attribute>
            <svrl:text>[IC-TDF-ID-00031][Error] If assertion statement attribute @isEncrypted="true", then there needs to be two statement
           metadata elements: one with attribute @appliesToState="encrypted" and the other with attribute appliesToState="unencrypted". Human
           Readable: If an assertion statement is encrypted, it must have statement metadata to describe handling for both its encrypted state, and
           unencrypted state.</svrl:text>
            <svrl:text>If a TDO has an encrypted assertion (@isEncrypted="true"), then there needs to be two statement metadata elements:
           one with attribute @appliesToState="encrypted" and the other with attribute appliesToState="unencrypted".</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M19"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-TDF-ID-00003</xsl:attribute>
            <xsl:attribute name="name">IC-TDF-ID-00003</xsl:attribute>
            <svrl:text>[IC-TDF-ID-00003][Error] For element TrustedDataObject, there must be at least one element HandlingAssertion which
           specifies attribute scope containing [PAYL]. Human Readable: There must exist at least one handling marking for the payload.</svrl:text>
            <svrl:text>For each TrustedDataObject, this rule ensures that the count of HandlingAssertion element which specify attribute
           scope containing [PAYL] is greater than or equal to 1.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M20"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-TDF-ID-00004</xsl:attribute>
            <xsl:attribute name="name">IC-TDF-ID-00004</xsl:attribute>
            <svrl:text>[IC-TDF-ID-00004][Error] For element TrustedDataObject, there must be exactly one element HandlingAssertion that
           specifies attribute scope containing [TDO] and contains an EDH element. Human Readable: There must exist a single EDH HandlingAssertion
           scoped for the entire TrustedDataObject.</svrl:text>
            <svrl:text>For element TrustedDataObject, this rule ensures that the count of HandlingAssertion elements that specify
           attribute scope containing [TDO] and have child::tdf:HandlingStatement/edh:Edh is exactly 1.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M21"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-TDF-ID-00005</xsl:attribute>
            <xsl:attribute name="name">IC-TDF-ID-00005</xsl:attribute>
            <svrl:text>[IC-TDF-ID-00005][Error] For element TrustedDataCollection, there must be exactly one element HandlingAssertion
           that specifies @scope="TDC" and contains an EDH element. Human Readable: There must exist a single EDH HandlingAssertion scoped for the
           entire TrustedDataCollection.</svrl:text>
            <svrl:text>For element TrustedDataCollection, this rule ensures that the count of HandlingAssertion elements that specify
           attribute scope containing [TDC] and contain an EDH element is exactly 1.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M22"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-TDF-ID-00016</xsl:attribute>
            <xsl:attribute name="name">IC-TDF-ID-00016</xsl:attribute>
            <svrl:text>[IC-TDF-ID-00016][Error] EDH HandlingAssertions with TDO scope must have an ARH security element has
           ism:resourceElement="true". Human Readable: An EDH HandlingAssertion with scope pertaining to the entire TrustedDataObject (TDO) must
           declare itself a resource level object.</svrl:text>
            <svrl:text>EDH HandlingAssertions with scope containing [TDO], ensure that its decendant ARH element, Security or
           ExternalSecurity, has ism:resourceElement="true".</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M23"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-TDF-ID-00017</xsl:attribute>
            <xsl:attribute name="name">IC-TDF-ID-00017</xsl:attribute>
            <svrl:text>[IC-TDF-ID-00017][Error] EDH HandlingAssertions with scope containing the token [TDC] must have an EDH whose ARH
           security element has ism:resourceElement="true" specified. Human Readable: When a HandlingAssertion has scope pertaining to the entire
           TrustedDataCollection (TDC) it must declare itself a resource level object.</svrl:text>
            <svrl:text>Where an EDH HandlingAssertion exists with scope containing [TDC], this rule ensures that its decendant ARH
           element, Security or ExternalSecurity, has ism:resourceElement specified with a value of true.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M24"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-TDF-ID-00018</xsl:attribute>
            <xsl:attribute name="name">IC-TDF-ID-00018</xsl:attribute>
            <svrl:text>[IC-TDF-ID-00018][Error] HandlingAssertions with scope containing the token [TDO] cannot use the ExternalEdh child
           element. Human Readable: When a HandlingAssertion has scope pertaining to the entire TrustedDataObject (TDO), it must never use the
           ExternalEdh child element because the HandlingAssertion will always refer to the object in which it resides.</svrl:text>
            <svrl:text>Where a HandlingAssertion exists with scope containing [TDO], this rule ensures that it does not have a child of
           ExternalEdh.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M25"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-TDF-ID-00019</xsl:attribute>
            <xsl:attribute name="name">IC-TDF-ID-00019</xsl:attribute>
            <svrl:text>[IC-TDF-ID-00019][Error] HandlingAssertions with scope containing the token [TDC] cannot use the ExternalEdh child
           element. Human Readable: When a HandlingAssertion has scope pertaining to the entire TrustedDataCollection (TDC), it must never use the
           ExternalEdh child element because the HandlingAssertion will always refer to the Collection in which it resides.</svrl:text>
            <svrl:text>Where a HandlingAssertion exists with scope containing [TDC], this rule ensures that it does not have a child of
           ExternalEdh.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M26"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-TDF-ID-00033</xsl:attribute>
            <xsl:attribute name="name">IC-TDF-ID-00033</xsl:attribute>
            <svrl:text>[IC-TDF-ID-00033][Error] A TrustedDataObject with a ReferencePayload must have an ExternalEDH element in the
           HandlingAssertion with scope [PAYL].</svrl:text>
            <svrl:text>For TrustedDataObject elements with a ReferencePayload, ensure that the HandlingAssertion with scope [PAYL] has an
           ExternalEDH element.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M27"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-TDF-ID-00034</xsl:attribute>
            <xsl:attribute name="name">IC-TDF-ID-00034</xsl:attribute>
            <svrl:text>[IC-TDF-ID-00034][Error] An Assertion with a ReferenceStatement must have an ExternalEDH or ExternalSecurity
           element in the StatementMetadata.</svrl:text>
            <svrl:text>For Assertion elements with a ReferenceStatement, ensure that the StatementMetadata has an ExternalEDH or
           ExternalSecurity element.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M28"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-TDF-ID-00036</xsl:attribute>
            <xsl:attribute name="name">IC-TDF-ID-00036</xsl:attribute>
            <svrl:text>
        This abstract pattern checks to see if the validation environment has at least the version / revision of the
        Schema as of the writing of this specification. 
        The calling rule must pass in '201903', 'IC-EDH', '../../Schema/IC-EDH/IC-EDH.xsd', 'IC-TDF-ID-00036'.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M29"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-TDF-ID-00042</xsl:attribute>
            <xsl:attribute name="name">IC-TDF-ID-00042</xsl:attribute>
            <svrl:text>[IC-TDF-ID-00042][Error] The first HandlingAssertion of a TDF must have the attribute scope with a value of [TDO]
           or [TDC] and contain an EDH.</svrl:text>
            <svrl:text>This rule triggers on the first HandlingAssertion element for each TDF and tests that the value of the @tdf:scope
           attribute is set a value of [TDO] or [TDC] and that an EDH exists. Otherwise, an error is triggered. This prevents some other handling
           assertion such as Revision Recall from being the ISM resource node for the entire TDO.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M30"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-TDF-ID-00043</xsl:attribute>
            <xsl:attribute name="name">IC-TDF-ID-00043</xsl:attribute>
            <svrl:text>[IC-TDF-ID-00043][Error] ntk:Access elements on portions of a TDO must be rolled up to the resource level. As such
           there must be an ntk:Access on the HandlingAssertion with scope [TDO]. Precise rollup is left to the creator to determine. Human Readable:
           If there is an ntk:Access in any portion of a TDO, then there must be an ntk:Access in the HandlingAssertion with scope="TDO"</svrl:text>
            <svrl:text>This rule triggers on any ntk:Access that exists except for one in the tdf:HandlingAssertion with a scope [TDO]. If
           it triggers it checks that there is an ntk:Access in the HandlingAssertion with scope [TDO] otherwise it sets an error.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M31"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-TDF-ID-00044</xsl:attribute>
            <xsl:attribute name="name">IC-TDF-ID-00044</xsl:attribute>
            <svrl:text>[IC-TDF-ID-00044][Error] ntk:Access elements on child TDOs or Assertions must be rolled up to the resource level.
           As such there must be an ntk:Access on the HandlingAssertion with scope [TDC]. Precise rollup is left to the creator to determine. Human
           Readable: If there is an ntk:Access in any portion of a TDC, then there must be an ntk:Access in the HandlingAssertion with
           scope="TDC"</svrl:text>
            <svrl:text>This rule triggers on any ntk:Access that exists except for one in the tdf:HandlingAssertion with a scope [TDC]. If
           it triggers it checks that there is an ntk:Access in the HandlingAssertion with scope [TDC] otherwise it sets an error.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M32"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-TDF-ID-00045</xsl:attribute>
            <xsl:attribute name="name">IC-TDF-ID-00045</xsl:attribute>
            <svrl:text>
        This abstract pattern checks to see if the validation environment has at least the version / revision of the
        Schema as of the writing of this specification. 
        The calling rule must pass in '202111', 'RevRecall', '../../Schema/RevRecall/RevRecall_XML.xsd', 'IC-TDF-ID-00045'.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M33"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-TDF-ID-00046</xsl:attribute>
            <xsl:attribute name="name">IC-TDF-ID-00046</xsl:attribute>
            <svrl:text>For all ism:DESVersion attributes found on the TDF skeleton, ensure all the versions are the same. The TDF Skeleton
           includes the TDF elements themselves and descendents of tdf:HandlingAssertion or tdf:StatementMetadata elements.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M34"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-TDF-ID-00049</xsl:attribute>
            <xsl:attribute name="name">IC-TDF-ID-00049</xsl:attribute>
            <svrl:text>For all ism:DESVersion attributes found on the TDF skeleton, ensure all the versions are the same. The TDF Skeleton
           includes the TDF elements themselves and descendents of tdf:HandlingAssertion or tdf:StatementMetadata elements.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M35"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-TDF-ID-00050</xsl:attribute>
            <xsl:attribute name="name">IC-TDF-ID-00050</xsl:attribute>
            <svrl:text>For all ism:DESVersion attributes found on the TDF skeleton, ensure all the versions are the same. The TDF Skeleton
           includes the TDF elements themselves and descendents of tdf:HandlingAssertion or tdf:StatementMetadata elements.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M36"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-TDF-ID-00051</xsl:attribute>
            <xsl:attribute name="name">IC-TDF-ID-00051</xsl:attribute>
            <svrl:text>For all ism:DESVersion attributes found on the TDF skeleton, ensure all the versions are the same. The TDF Skeleton
           includes the TDF elements themselves and descendents of tdf:HandlingAssertion or tdf:StatementMetadata elements.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M37"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-TDF-ID-00052</xsl:attribute>
            <xsl:attribute name="name">IC-TDF-ID-00052</xsl:attribute>
            <svrl:text>For all ism:DESVersion attributes found on the TDF skeleton, ensure all the versions are the same. The TDF Skeleton
           includes the TDF elements themselves and descendents of tdf:HandlingAssertion or tdf:StatementMetadata elements.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M38"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-TDF-ID-00053</xsl:attribute>
            <xsl:attribute name="name">IC-TDF-ID-00053</xsl:attribute>
            <svrl:text>For all ism:DESVersion attributes found on the TDF skeleton, ensure all the versions are the same. The TDF Skeleton
           includes the TDF elements themselves and descendents of tdf:HandlingAssertion or tdf:StatementMetadata elements.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M39"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-TDF-ID-00054</xsl:attribute>
            <xsl:attribute name="name">IC-TDF-ID-00054</xsl:attribute>
            <svrl:text>
        [IC-TDF-ID-00054][Warning] tdf:version attribute SHOULD be specified as version 202111-IC-TDF.202111
        with an optional extension.
    </svrl:text>
            <svrl:text>
        This rule supports extending the version identifier with an optional trailing hyphen and up to 23 additional
        characters. The version must match the regular expression "^202111-IC-TDF.202111(-.{1,23})?$".
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M40"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-TDF-ID-00055</xsl:attribute>
            <xsl:attribute name="name">IC-TDF-ID-00055</xsl:attribute>
            <svrl:text>[IC-TDF-ID-00055][Error] For element TrustedDataObject whose payload is NOT encrypted, there must not be more than
           one element HandlingAssertion that specifies attribute scope containing [PAYL] and contains an EDH element. Human Readable: For
           TrustedDataObjects with unencrypted payloads, there must not be more than a single EDH HandlingAssertion scoped for the payload.</svrl:text>
            <svrl:text>For element TrustedDataObject whose payload is NOT encrypted, ensure that the count of HandlingAssertion elements
           that specify attribute scope containing [PAYL] and have child::tdf:HandlingStatement/edh:Edh is not more than 1.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M41"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-TDF-ID-00056</xsl:attribute>
            <xsl:attribute name="name">IC-TDF-ID-00056</xsl:attribute>
            <svrl:text>
        This abstract pattern checks to see if the validation environment has at least the version / revision of the
        CVE as of the writing of this specification. 
        The calling rule must pass in '202111', 'ISM', '../../CVE/ISM/CVEnumISMClassificationAll.xml', 'IC-TDF-ID-00056'.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M42"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-TDF-ID-00057</xsl:attribute>
            <xsl:attribute name="name">IC-TDF-ID-00057</xsl:attribute>
            <svrl:text>
        This abstract pattern checks to see if the validation environment has at least the version / revision of the
        Schema as of the writing of this specification. 
        The calling rule must pass in '202111', 'IC-SF', '../../Schema/IC-SF/IC-SF.xsd', 'IC-TDF-ID-00057'.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M43"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-TDF-ID-00058</xsl:attribute>
            <xsl:attribute name="name">IC-TDF-ID-00058</xsl:attribute>
            <svrl:text>
        This abstract pattern checks to see if the validation environment has at least the version / revision of the
        Schema as of the writing of this specification. 
        The calling rule must pass in '202111', 'BASE-TDF', '../../Schema/BASE-TDF/BASE-TDF.xsd', 'IC-TDF-ID-00058'.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M44"/>
      </svrl:schematron-output>
   </xsl:template>

   <!--SCHEMATRON PATTERNS-->


<!--PATTERN IC-TDF-ID-00026-->


	<!--RULE IC-TDF-ID-00026-R1-->
<xsl:template match="tdf:TrustedDataObject/tdf:*[@tdf:isEncrypted=true()]"
                 priority="1000"
                 mode="M15">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:TrustedDataObject/tdf:*[@tdf:isEncrypted=true()]"
                       id="IC-TDF-ID-00026-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="count(parent::node()/tdf:HandlingAssertion[util:containsAnyOfTheTokens(@tdf:scope, ('PAYL')) and @tdf:appliesToState='encrypted'])= 1 and count(parent::node()/tdf:HandlingAssertion[util:containsAnyOfTheTokens(@tdf:scope, ('PAYL')) and @tdf:appliesToState='unencrypted'])= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(parent::node()/tdf:HandlingAssertion[util:containsAnyOfTheTokens(@tdf:scope, ('PAYL')) and @tdf:appliesToState='encrypted'])= 1 and count(parent::node()/tdf:HandlingAssertion[util:containsAnyOfTheTokens(@tdf:scope, ('PAYL')) and @tdf:appliesToState='unencrypted'])= 1">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IC-TDF-ID-00026][Error] If payload attribute @isEncrypted="true", then there needs to be two handling assertions
                    with attribute scope="PAYL": one with attribute @appliesToState="encrypted" and the other with attribute
                    appliesToState="unencrypted".</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M15"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M15"/>
   <xsl:template match="@*|node()" priority="-2" mode="M15">
      <xsl:apply-templates select="*" mode="M15"/>
   </xsl:template>

   <!--PATTERN IC-TDF-ID-00027-->


	<!--RULE IC-TDF-ID-00027-R1-->
<xsl:template match="tdf:TrustedDataObject/tdf:*[@tdf:isEncrypted=true()]"
                 priority="1000"
                 mode="M16">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:TrustedDataObject/tdf:*[@tdf:isEncrypted=true()]"
                       id="IC-TDF-ID-00027-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="count(parent::node()/tdf:HandlingAssertion[util:containsAnyOfTheTokens(@tdf:scope, ('PAYL')) and @tdf:appliesToState='unencrypted']/tdf:HandlingStatement/edh:ExternalEdh)= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(parent::node()/tdf:HandlingAssertion[util:containsAnyOfTheTokens(@tdf:scope, ('PAYL')) and @tdf:appliesToState='unencrypted']/tdf:HandlingStatement/edh:ExternalEdh)= 1">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IC-TDF-ID-00027][Error] If payload attribute @isEncrypted="true", the handling assertion with @scope="PAYL" that
                    contains @appliesToState="unencrypted" must contain an edh:externalEDH. Human Readable: When content is encrypted, the handling
                    assertion describing the content in an unencrypted state is in effect external.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M16"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M16"/>
   <xsl:template match="@*|node()" priority="-2" mode="M16">
      <xsl:apply-templates select="*" mode="M16"/>
   </xsl:template>

   <!--PATTERN IC-TDF-ID-00028-->


	<!--RULE IC-TDF-ID-00028-R1-->
<xsl:template match="tdf:TrustedDataObject[tdf:StringPayload/@tdf:isEncrypted=true()] | tdf:TrustedDataObject[tdf:Base64BinaryPayload/@tdf:isEncrypted=true()] | tdf:TrustedDataObject[tdf:StructuredPayload/@tdf:isEncrypted=true()]"
                 priority="1000"
                 mode="M17">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:TrustedDataObject[tdf:StringPayload/@tdf:isEncrypted=true()] | tdf:TrustedDataObject[tdf:Base64BinaryPayload/@tdf:isEncrypted=true()] | tdf:TrustedDataObject[tdf:StructuredPayload/@tdf:isEncrypted=true()]"
                       id="IC-TDF-ID-00028-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="count(tdf:HandlingAssertion[util:containsAnyOfTheTokens(@tdf:scope, ('PAYL')) and @tdf:appliesToState='encrypted']/tdf:HandlingStatement/edh:Edh)= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(tdf:HandlingAssertion[util:containsAnyOfTheTokens(@tdf:scope, ('PAYL')) and @tdf:appliesToState='encrypted']/tdf:HandlingStatement/edh:Edh)= 1">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IC-TDF-ID-00028][Error] If payload attribute @isEncrypted="true" and the payload is not external, the handling
                    assertion with @scope="PAYL" that contains @appliesToState="encrypted" must contain a regular edh:EDH. Human Readable: Internal
                    content requires an EDH.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M17"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M17"/>
   <xsl:template match="@*|node()" priority="-2" mode="M17">
      <xsl:apply-templates select="*" mode="M17"/>
   </xsl:template>

   <!--PATTERN IC-TDF-ID-00030-->


	<!--RULE IC-TDF-ID-00030-R1-->
<xsl:template match="tdf:TrustedDataObject/tdf:Assertion/tdf:*[@tdf:isEncrypted=true()]"
                 priority="1000"
                 mode="M18">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:TrustedDataObject/tdf:Assertion/tdf:*[@tdf:isEncrypted=true()]"
                       id="IC-TDF-ID-00030-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="count(parent::node()/tdf:StatementMetadata[@tdf:appliesToState='unencrypted' and descendant-or-self::arh:ExternalSecurity])= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(parent::node()/tdf:StatementMetadata[@tdf:appliesToState='unencrypted' and descendant-or-self::arh:ExternalSecurity])= 1">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IC-TDF-ID-00030][Error] If statement attribute @isEncrypted="true", the statement metadata that contains
                    @appliesToState="unencrypted" must contain an arh:ExternalSecurity Human Readable: When statement content is encrypted, the
                    handling statement describing the content in an unencrypted state is in effect external.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M18"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M18"/>
   <xsl:template match="@*|node()" priority="-2" mode="M18">
      <xsl:apply-templates select="*" mode="M18"/>
   </xsl:template>

   <!--PATTERN IC-TDF-ID-00031-->


	<!--RULE IC-TDF-ID-00031-R1-->
<xsl:template match="tdf:TrustedDataObject/tdf:Assertion/tdf:*[@tdf:isEncrypted=true()]"
                 priority="1000"
                 mode="M19">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:TrustedDataObject/tdf:Assertion/tdf:*[@tdf:isEncrypted=true()]"
                       id="IC-TDF-ID-00031-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="count(parent::node()/tdf:StatementMetadata[@tdf:appliesToState='encrypted'])= 1 and count(parent::node()/tdf:StatementMetadata[@tdf:appliesToState='unencrypted'])= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(parent::node()/tdf:StatementMetadata[@tdf:appliesToState='encrypted'])= 1 and count(parent::node()/tdf:StatementMetadata[@tdf:appliesToState='unencrypted'])= 1">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IC-TDF-ID-00031][Error] If assertion statement attribute @isEncrypted="true", then there needs to be two statement
                    metadata elements: one with attribute @appliesToState="encrypted" and the other with attribute appliesToState="unencrypted".
                    Human Readable: If an assertion statement is encrypted, it must have statement metadata to describe handling for both for its
                    encrypted state, and unencrypted state.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M19"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M19"/>
   <xsl:template match="@*|node()" priority="-2" mode="M19">
      <xsl:apply-templates select="*" mode="M19"/>
   </xsl:template>

   <!--PATTERN IC-TDF-ID-00003-->


	<!--RULE IC-TDF-ID-00003-R1-->
<xsl:template match="tdf:TrustedDataObject" priority="1000" mode="M20">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:TrustedDataObject"
                       id="IC-TDF-ID-00003-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="count(child::tdf:HandlingAssertion[util:containsAnyOfTheTokens(@tdf:scope, ('PAYL'))])&gt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(child::tdf:HandlingAssertion[util:containsAnyOfTheTokens(@tdf:scope, ('PAYL'))])&gt;= 1">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IC-TDF-ID-00003][Error] For element TrustedDataObject, there must be at least one element HandlingAssertion which
                    specifies attribute scope containing [PAYL]. Human Readable: There must exist at least one handling marking for the
                    payload.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M20"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M20"/>
   <xsl:template match="@*|node()" priority="-2" mode="M20">
      <xsl:apply-templates select="*" mode="M20"/>
   </xsl:template>

   <!--PATTERN IC-TDF-ID-00004-->


	<!--RULE IC-TDF-ID-00004-R1-->
<xsl:template match="tdf:TrustedDataObject" priority="1000" mode="M21">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:TrustedDataObject"
                       id="IC-TDF-ID-00004-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="count(child::tdf:HandlingAssertion[child::tdf:HandlingStatement/edh:Edh and @tdf:scope = 'TDO'])= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(child::tdf:HandlingAssertion[child::tdf:HandlingStatement/edh:Edh and @tdf:scope = 'TDO'])= 1">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IC-TDF-ID-00004][Error] For element TrustedDataObject, there must be exactly one element HandlingAssertion that
                    specifies attribute scope containing [TDO] and contains an EDH element.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M21"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M21"/>
   <xsl:template match="@*|node()" priority="-2" mode="M21">
      <xsl:apply-templates select="*" mode="M21"/>
   </xsl:template>

   <!--PATTERN IC-TDF-ID-00005-->


	<!--RULE IC-TDF-ID-00005-R1-->
<xsl:template match="tdf:TrustedDataCollection" priority="1000" mode="M22">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:TrustedDataCollection"
                       id="IC-TDF-ID-00005-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="count(child::tdf:HandlingAssertion[child::tdf:HandlingStatement/edh:Edh and @tdf:scope = 'TDC'])= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(child::tdf:HandlingAssertion[child::tdf:HandlingStatement/edh:Edh and @tdf:scope = 'TDC'])= 1">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IC-TDF-ID-00005][Error] For element TrustedDataCollection, there must be exactly one element HandlingAssertion that
                    specifies @scope="TDC" and contains an EDH element. Human Readable: There must exist a single EDH HandlingAssertion scoped for
                    the entire TrustedDataCollection.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M22"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M22"/>
   <xsl:template match="@*|node()" priority="-2" mode="M22">
      <xsl:apply-templates select="*" mode="M22"/>
   </xsl:template>

   <!--PATTERN IC-TDF-ID-00016-->


	<!--RULE IC-TDF-ID-00016-R1-->
<xsl:template match="tdf:HandlingAssertion[child::tdf:HandlingStatement/edh:Edh and util:containsAnyOfTheTokens(@tdf:scope, ('TDO'))]"
                 priority="1000"
                 mode="M23">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:HandlingAssertion[child::tdf:HandlingStatement/edh:Edh and util:containsAnyOfTheTokens(@tdf:scope, ('TDO'))]"
                       id="IC-TDF-ID-00016-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="descendant::arh:*[@ism:resourceElement=true()]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="descendant::arh:*[@ism:resourceElement=true()]">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IC-TDF-ID-00016][Error] HandlingAssertions with scope containing the token [TDO] must have an EDH whose ARH
                    security element has ism:resourceElement="true" specified. Human Readable: An EDH HandlingAssertion with scope pertaining to the
                    entire TrustedDataObject (TDO) must declare itself a resource level object.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M23"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M23"/>
   <xsl:template match="@*|node()" priority="-2" mode="M23">
      <xsl:apply-templates select="*" mode="M23"/>
   </xsl:template>

   <!--PATTERN IC-TDF-ID-00017-->


	<!--RULE IC-TDF-ID-00017-R1-->
<xsl:template match="tdf:HandlingAssertion[child::tdf:HandlingStatement/edh:Edh and util:containsAnyOfTheTokens(@tdf:scope, ('TDC'))]"
                 priority="1000"
                 mode="M24">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:HandlingAssertion[child::tdf:HandlingStatement/edh:Edh and util:containsAnyOfTheTokens(@tdf:scope, ('TDC'))]"
                       id="IC-TDF-ID-00017-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="descendant::arh:*[@ism:resourceElement=true()]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="descendant::arh:*[@ism:resourceElement=true()]">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IC-TDF-ID-00017][Error] HandlingAssertions with scope containing the token [TDC] must have an EDH whose ARH
                    security element has ism:resourceElement="true" specified. Human Readable: When a HandlingAssertion has scope pertaining to the
                    entire TrustedDataCollection (TDC) it must declare itself a resource level object.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M24"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M24"/>
   <xsl:template match="@*|node()" priority="-2" mode="M24">
      <xsl:apply-templates select="*" mode="M24"/>
   </xsl:template>

   <!--PATTERN IC-TDF-ID-00018-->


	<!--RULE IC-TDF-ID-00018-R1-->
<xsl:template match="tdf:HandlingAssertion[util:containsAnyOfTheTokens(@tdf:scope, ('TDO'))]"
                 priority="1000"
                 mode="M25">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:HandlingAssertion[util:containsAnyOfTheTokens(@tdf:scope, ('TDO'))]"
                       id="IC-TDF-ID-00018-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="not(descendant::edh:ExternalEdh)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(descendant::edh:ExternalEdh)">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IC-TDF-ID-00018][Error] HandlingAssertions with scope containing the token [TDO] cannot use the ExternalEdh child
                    element. Human Readable: When a HandlingAssertion has scope pertaining to the entire TrustedDataObject (TDO), it must never use
                    the ExternalEdh child element because the HandlingAssertion will always refer to the object in which it resides.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M25"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M25"/>
   <xsl:template match="@*|node()" priority="-2" mode="M25">
      <xsl:apply-templates select="*" mode="M25"/>
   </xsl:template>

   <!--PATTERN IC-TDF-ID-00019-->


	<!--RULE IC-TDF-ID-00019-R1-->
<xsl:template match="tdf:HandlingAssertion[util:containsAnyOfTheTokens(@tdf:scope, ('TDC'))]"
                 priority="1000"
                 mode="M26">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:HandlingAssertion[util:containsAnyOfTheTokens(@tdf:scope, ('TDC'))]"
                       id="IC-TDF-ID-00019-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="not(descendant::edh:ExternalEdh)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(descendant::edh:ExternalEdh)">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IC-TDF-ID-00019][Error] HandlingAssertions with scope containing the token [TDC] cannot use the ExternalEdh child
                    element. Human Readable: When a HandlingAssertion has scope pertaining to the entire TrustedDataCollection (TDC), it must never
                    use the ExternalEdh child element because the HandlingAssertion will always refer to the Collection in which it
                    resides.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M26"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M26"/>
   <xsl:template match="@*|node()" priority="-2" mode="M26">
      <xsl:apply-templates select="*" mode="M26"/>
   </xsl:template>

   <!--PATTERN IC-TDF-ID-00033-->


	<!--RULE IC-TDF-ID-00033-R1-->
<xsl:template match="tdf:TrustedDataObject//tdf:ReferenceValuePayload"
                 priority="1000"
                 mode="M27">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:TrustedDataObject//tdf:ReferenceValuePayload"
                       id="IC-TDF-ID-00033-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="ancestor::tdf:TrustedDataObject//tdf:HandlingAssertion[@tdf:scope='PAYL']//edh:ExternalEdh"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="ancestor::tdf:TrustedDataObject//tdf:HandlingAssertion[@tdf:scope='PAYL']//edh:ExternalEdh">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IC-TDF-ID-00033][Error] A TrustedDataObject with a ReferencePayload must have an ExternalEDH element in the
                    HandlingAssertion with scope [PAYL].</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M27"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M27"/>
   <xsl:template match="@*|node()" priority="-2" mode="M27">
      <xsl:apply-templates select="*" mode="M27"/>
   </xsl:template>

   <!--PATTERN IC-TDF-ID-00034-->


	<!--RULE IC-TDF-ID-00034-R1-->
<xsl:template match="tdf:Assertion//tdf:ReferenceStatement"
                 priority="1000"
                 mode="M28">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:Assertion//tdf:ReferenceStatement"
                       id="IC-TDF-ID-00034-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="ancestor::tdf:Assertion/tdf:StatementMetadata[edh:ExternalEdh or arh:ExternalSecurity]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="ancestor::tdf:Assertion/tdf:StatementMetadata[edh:ExternalEdh or arh:ExternalSecurity]">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IC-TDF-ID-00034][Error] An Assertion with a ReferenceStatement must have an ExternalEDH or ExternalSecurity element
                    in the StatementMetadata.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M28"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M28"/>
   <xsl:template match="@*|node()" priority="-2" mode="M28">
      <xsl:apply-templates select="*" mode="M28"/>
   </xsl:template>

   <!--PATTERN IC-TDF-ID-00036-->


	<!--RULE ValidateValidationEnvSchema-R1-->
<xsl:template match="/" priority="1000" mode="M29">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/"
                       id="ValidateValidationEnvSchema-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="document('../../Schema/IC-EDH/IC-EDH.xsd')//xsd:schema//@version castable as xs:double              and document('../../Schema/IC-EDH/IC-EDH.xsd')//xsd:schema//@version &gt;= '201903'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('../../Schema/IC-EDH/IC-EDH.xsd')//xsd:schema//@version castable as xs:double and document('../../Schema/IC-EDH/IC-EDH.xsd')//xsd:schema//@version &gt;= '201903'">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
            [<xsl:text/>
                  <xsl:value-of select="'IC-TDF-ID-00036'"/>
                  <xsl:text/>][Error] Version [ <xsl:text/>
                  <xsl:value-of select="document('../../Schema/IC-EDH/IC-EDH.xsd')//xsd:schema//@version"/>
                  <xsl:text/> ] of <xsl:text/>
                  <xsl:value-of select="'IC-EDH'"/>
                  <xsl:text/> found; 
            Version [<xsl:text/>
                  <xsl:value-of select="'201903'"/>
                  <xsl:text/>] or later is required. The latest version of <xsl:text/>
                  <xsl:value-of select="'IC-EDH'"/>
                  <xsl:text/> 
            is not being used in the validation infrastructure. Regardless of the version indicated on the instance document, 
            the validation infrastructure needs to use a version of <xsl:text/>
                  <xsl:value-of select="'IC-EDH'"/>
                  <xsl:text/> that is
            version [<xsl:text/>
                  <xsl:value-of select="'201903'"/>
                  <xsl:text/>] or later. NOTE: This is not an error of the instance
            document but of the validation environment itself. The incorrect value was found in <xsl:text/>
                  <xsl:value-of select="document-uri(document('../../Schema/IC-EDH/IC-EDH.xsd'))"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M29"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M29"/>
   <xsl:template match="@*|node()" priority="-2" mode="M29">
      <xsl:apply-templates select="*" mode="M29"/>
   </xsl:template>

   <!--PATTERN IC-TDF-ID-00042-->


	<!--RULE IC-TDF-ID-00042-R1-->
<xsl:template match="tdf:*/tdf:HandlingAssertion[1]" priority="1000" mode="M30">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:*/tdf:HandlingAssertion[1]"
                       id="IC-TDF-ID-00042-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="((parent::tdf:TrustedDataObject and @tdf:scope='TDO') or (parent::tdf:TrustedDataCollection and @tdf:scope='TDC')) and ./tdf:HandlingStatement/edh:Edh"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="((parent::tdf:TrustedDataObject and @tdf:scope='TDO') or (parent::tdf:TrustedDataCollection and @tdf:scope='TDC')) and ./tdf:HandlingStatement/edh:Edh">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IC-TDF-ID-00042][Error] The first HandlingAssertion of a TDF must have the attribute scope with a value of [TDO] or
                    [TDC] and contain an EDH.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M30"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M30"/>
   <xsl:template match="@*|node()" priority="-2" mode="M30">
      <xsl:apply-templates select="*" mode="M30"/>
   </xsl:template>

   <!--PATTERN IC-TDF-ID-00043-->


	<!--RULE IC-TDF-ID-00043-R1-->
<xsl:template match="tdf:TrustedDataObject//ntk:Access[not(ancestor::tdf:HandlingAssertion[@tdf:scope='TDO'] or @ntk:externalReference=true())]"
                 priority="1000"
                 mode="M31">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:TrustedDataObject//ntk:Access[not(ancestor::tdf:HandlingAssertion[@tdf:scope='TDO'] or @ntk:externalReference=true())]"
                       id="IC-TDF-ID-00043-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="ancestor::tdf:TrustedDataObject/tdf:HandlingAssertion[@tdf:scope='TDO']//ntk:Access"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="ancestor::tdf:TrustedDataObject/tdf:HandlingAssertion[@tdf:scope='TDO']//ntk:Access">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IC-TDF-ID-00043][Error] If there is an ntk:Access in any portion of a TDO, then there must be an ntk:Access in the
                    HandlingAssertion with scope="TDO"</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M31"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M31"/>
   <xsl:template match="@*|node()" priority="-2" mode="M31">
      <xsl:apply-templates select="*" mode="M31"/>
   </xsl:template>

   <!--PATTERN IC-TDF-ID-00044-->


	<!--RULE IC-TDF-ID-00044-R1-->
<xsl:template match="tdf:TrustedDataCollection//ntk:Access[not(ancestor::tdf:HandlingAssertion[@tdf:scope='TDC'] or @ntk:externalReference=true())]"
                 priority="1000"
                 mode="M32">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:TrustedDataCollection//ntk:Access[not(ancestor::tdf:HandlingAssertion[@tdf:scope='TDC'] or @ntk:externalReference=true())]"
                       id="IC-TDF-ID-00044-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="ancestor::tdf:TrustedDataCollection/tdf:HandlingAssertion[@tdf:scope='TDC']//ntk:Access"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="ancestor::tdf:TrustedDataCollection/tdf:HandlingAssertion[@tdf:scope='TDC']//ntk:Access">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IC-TDF-ID-00044][Error] If there is an ntk:Access in any portion of a TDC, then there must be an ntk:Access in the
                    HandlingAssertion with scope="TDC"</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M32"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M32"/>
   <xsl:template match="@*|node()" priority="-2" mode="M32">
      <xsl:apply-templates select="*" mode="M32"/>
   </xsl:template>

   <!--PATTERN IC-TDF-ID-00045-->


	<!--RULE ValidateValidationEnvSchema-R1-->
<xsl:template match="/" priority="1000" mode="M33">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/"
                       id="ValidateValidationEnvSchema-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="document('../../Schema/RevRecall/RevRecall_XML.xsd')//xsd:schema//@version castable as xs:double              and document('../../Schema/RevRecall/RevRecall_XML.xsd')//xsd:schema//@version &gt;= '202111'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('../../Schema/RevRecall/RevRecall_XML.xsd')//xsd:schema//@version castable as xs:double and document('../../Schema/RevRecall/RevRecall_XML.xsd')//xsd:schema//@version &gt;= '202111'">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
            [<xsl:text/>
                  <xsl:value-of select="'IC-TDF-ID-00045'"/>
                  <xsl:text/>][Error] Version [ <xsl:text/>
                  <xsl:value-of select="document('../../Schema/RevRecall/RevRecall_XML.xsd')//xsd:schema//@version"/>
                  <xsl:text/> ] of <xsl:text/>
                  <xsl:value-of select="'RevRecall'"/>
                  <xsl:text/> found; 
            Version [<xsl:text/>
                  <xsl:value-of select="'202111'"/>
                  <xsl:text/>] or later is required. The latest version of <xsl:text/>
                  <xsl:value-of select="'RevRecall'"/>
                  <xsl:text/> 
            is not being used in the validation infrastructure. Regardless of the version indicated on the instance document, 
            the validation infrastructure needs to use a version of <xsl:text/>
                  <xsl:value-of select="'RevRecall'"/>
                  <xsl:text/> that is
            version [<xsl:text/>
                  <xsl:value-of select="'202111'"/>
                  <xsl:text/>] or later. NOTE: This is not an error of the instance
            document but of the validation environment itself. The incorrect value was found in <xsl:text/>
                  <xsl:value-of select="document-uri(document('../../Schema/RevRecall/RevRecall_XML.xsd'))"/>
                  <xsl:text/>
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

   <!--PATTERN IC-TDF-ID-00046-->


	<!--RULE CompareVersionsInSkeleton-R1-->
<xsl:template match="//tdf:*[@ism:DESVersion] | //tdf:HandlingAssertion//*[@ism:DESVersion] | //tdf:StatementMetdata//*[@ism:DESVersion]"
                 priority="1000"
                 mode="M34">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//tdf:*[@ism:DESVersion] | //tdf:HandlingAssertion//*[@ism:DESVersion] | //tdf:StatementMetdata//*[@ism:DESVersion]"
                       id="CompareVersionsInSkeleton-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="every $ver in (//tdf:*/@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:ism'] | //tdf:HandlingAssertion//@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:ism'] | //tdf:StatementMetadata//@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:ism']) satisfies (number(if (contains($ver,'-')) then substring-before($ver,'-') else $ver))=(number(if (contains(@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:ism'],'-')) then substring-before(@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:ism'],'-') else @*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:ism']))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $ver in (//tdf:*/@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:ism'] | //tdf:HandlingAssertion//@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:ism'] | //tdf:StatementMetadata//@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:ism']) satisfies (number(if (contains($ver,'-')) then substring-before($ver,'-') else $ver))=(number(if (contains(@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:ism'],'-')) then substring-before(@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:ism'],'-') else @*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:ism']))">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[
        <xsl:text/>
                  <xsl:value-of select="'IC-TDF-ID-00046'"/>
                  <xsl:text/>][Error] The {
        <xsl:text/>
                  <xsl:value-of select="'urn:us:gov:ic:ism'"/>
                  <xsl:text/>}
        <xsl:text/>
                  <xsl:value-of select="'DESVersion'"/>
                  <xsl:text/> declared must be the same throughout the IC-TDF skeleton including the HandlingAssertions and
        StatementMetadata within assertions. Versions found: 
        <xsl:text/>
                  <xsl:value-of select="string-join(distinct-values(for $ver in (//tdf:*/@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:ism'] | //tdf:HandlingAssertion//@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:ism'] | //tdf:StatementMetadata//@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:ism']) return $ver), ', ')"/>
                  <xsl:text/>
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

   <!--PATTERN IC-TDF-ID-00049-->


	<!--RULE CompareVersionsInSkeleton-R1-->
<xsl:template match="tdf:*[@edh:DESVersion] | tdf:HandlingAssertion//*[@edh:DESVersion] | tdf:StatementMetdata//*[@edh:DESVersion]"
                 priority="1000"
                 mode="M35">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:*[@edh:DESVersion] | tdf:HandlingAssertion//*[@edh:DESVersion] | tdf:StatementMetdata//*[@edh:DESVersion]"
                       id="CompareVersionsInSkeleton-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="every $ver in (//tdf:*/@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:edh'] | //tdf:HandlingAssertion//@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:edh'] | //tdf:StatementMetadata//@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:edh']) satisfies (number(if (contains($ver,'-')) then substring-before($ver,'-') else $ver))=(number(if (contains(@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:edh'],'-')) then substring-before(@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:edh'],'-') else @*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:edh']))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $ver in (//tdf:*/@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:edh'] | //tdf:HandlingAssertion//@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:edh'] | //tdf:StatementMetadata//@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:edh']) satisfies (number(if (contains($ver,'-')) then substring-before($ver,'-') else $ver))=(number(if (contains(@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:edh'],'-')) then substring-before(@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:edh'],'-') else @*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:edh']))">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[
        <xsl:text/>
                  <xsl:value-of select="'IC-TDF-ID-00049'"/>
                  <xsl:text/>][Error] The {
        <xsl:text/>
                  <xsl:value-of select="'urn:us:gov:ic:edh'"/>
                  <xsl:text/>}
        <xsl:text/>
                  <xsl:value-of select="'DESVersion'"/>
                  <xsl:text/> declared must be the same throughout the IC-TDF skeleton including the HandlingAssertions and
        StatementMetadata within assertions. Versions found: 
        <xsl:text/>
                  <xsl:value-of select="string-join(distinct-values(for $ver in (//tdf:*/@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:edh'] | //tdf:HandlingAssertion//@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:edh'] | //tdf:StatementMetadata//@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:edh']) return $ver), ', ')"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M35"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M35"/>
   <xsl:template match="@*|node()" priority="-2" mode="M35">
      <xsl:apply-templates select="*" mode="M35"/>
   </xsl:template>

   <!--PATTERN IC-TDF-ID-00050-->


	<!--RULE CompareVersionsInSkeleton-R1-->
<xsl:template match="tdf:*[@icid:DESVersion] | tdf:HandlingAssertion//*[@icid:DESVersion] | tdf:StatementMetdata//*[@icid:DESVersion]"
                 priority="1000"
                 mode="M36">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:*[@icid:DESVersion] | tdf:HandlingAssertion//*[@icid:DESVersion] | tdf:StatementMetdata//*[@icid:DESVersion]"
                       id="CompareVersionsInSkeleton-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="every $ver in (//tdf:*/@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:id'] | //tdf:HandlingAssertion//@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:id'] | //tdf:StatementMetadata//@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:id']) satisfies (number(if (contains($ver,'-')) then substring-before($ver,'-') else $ver))=(number(if (contains(@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:id'],'-')) then substring-before(@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:id'],'-') else @*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:id']))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $ver in (//tdf:*/@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:id'] | //tdf:HandlingAssertion//@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:id'] | //tdf:StatementMetadata//@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:id']) satisfies (number(if (contains($ver,'-')) then substring-before($ver,'-') else $ver))=(number(if (contains(@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:id'],'-')) then substring-before(@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:id'],'-') else @*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:id']))">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[
        <xsl:text/>
                  <xsl:value-of select="'IC-TDF-ID-00050'"/>
                  <xsl:text/>][Error] The {
        <xsl:text/>
                  <xsl:value-of select="'urn:us:gov:ic:id'"/>
                  <xsl:text/>}
        <xsl:text/>
                  <xsl:value-of select="'DESVersion'"/>
                  <xsl:text/> declared must be the same throughout the IC-TDF skeleton including the HandlingAssertions and
        StatementMetadata within assertions. Versions found: 
        <xsl:text/>
                  <xsl:value-of select="string-join(distinct-values(for $ver in (//tdf:*/@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:id'] | //tdf:HandlingAssertion//@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:id'] | //tdf:StatementMetadata//@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:id']) return $ver), ', ')"/>
                  <xsl:text/>
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

   <!--PATTERN IC-TDF-ID-00051-->


	<!--RULE CompareVersionsInSkeleton-R1-->
<xsl:template match="tdf:*[@usagency:CESVersion] | tdf:HandlingAssertion//*[@usagency:CESVersion] | tdf:StatementMetdata//*[@usagency:CESVersion]"
                 priority="1000"
                 mode="M37">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:*[@usagency:CESVersion] | tdf:HandlingAssertion//*[@usagency:CESVersion] | tdf:StatementMetdata//*[@usagency:CESVersion]"
                       id="CompareVersionsInSkeleton-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="every $ver in (//tdf:*/@*[local-name()='CESVersion' and namespace-uri()='urn:us:gov:ic:usagency'] | //tdf:HandlingAssertion//@*[local-name()='CESVersion' and namespace-uri()='urn:us:gov:ic:usagency'] | //tdf:StatementMetadata//@*[local-name()='CESVersion' and namespace-uri()='urn:us:gov:ic:usagency']) satisfies (number(if (contains($ver,'-')) then substring-before($ver,'-') else $ver))=(number(if (contains(@*[local-name()='CESVersion' and namespace-uri()='urn:us:gov:ic:usagency'],'-')) then substring-before(@*[local-name()='CESVersion' and namespace-uri()='urn:us:gov:ic:usagency'],'-') else @*[local-name()='CESVersion' and namespace-uri()='urn:us:gov:ic:usagency']))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $ver in (//tdf:*/@*[local-name()='CESVersion' and namespace-uri()='urn:us:gov:ic:usagency'] | //tdf:HandlingAssertion//@*[local-name()='CESVersion' and namespace-uri()='urn:us:gov:ic:usagency'] | //tdf:StatementMetadata//@*[local-name()='CESVersion' and namespace-uri()='urn:us:gov:ic:usagency']) satisfies (number(if (contains($ver,'-')) then substring-before($ver,'-') else $ver))=(number(if (contains(@*[local-name()='CESVersion' and namespace-uri()='urn:us:gov:ic:usagency'],'-')) then substring-before(@*[local-name()='CESVersion' and namespace-uri()='urn:us:gov:ic:usagency'],'-') else @*[local-name()='CESVersion' and namespace-uri()='urn:us:gov:ic:usagency']))">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[
        <xsl:text/>
                  <xsl:value-of select="'IC-TDF-ID-00051'"/>
                  <xsl:text/>][Error] The {
        <xsl:text/>
                  <xsl:value-of select="'urn:us:gov:ic:usagency'"/>
                  <xsl:text/>}
        <xsl:text/>
                  <xsl:value-of select="'CESVersion'"/>
                  <xsl:text/> declared must be the same throughout the IC-TDF skeleton including the HandlingAssertions and
        StatementMetadata within assertions. Versions found: 
        <xsl:text/>
                  <xsl:value-of select="string-join(distinct-values(for $ver in (//tdf:*/@*[local-name()='CESVersion' and namespace-uri()='urn:us:gov:ic:usagency'] | //tdf:HandlingAssertion//@*[local-name()='CESVersion' and namespace-uri()='urn:us:gov:ic:usagency'] | //tdf:StatementMetadata//@*[local-name()='CESVersion' and namespace-uri()='urn:us:gov:ic:usagency']) return $ver), ', ')"/>
                  <xsl:text/>
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

   <!--PATTERN IC-TDF-ID-00052-->


	<!--RULE CompareVersionsInSkeleton-R1-->
<xsl:template match="tdf:*[@tdf:version] | tdf:HandlingAssertion//*[@tdf:version] | tdf:StatementMetdata//*[@tdf:version]"
                 priority="1000"
                 mode="M38">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:*[@tdf:version] | tdf:HandlingAssertion//*[@tdf:version] | tdf:StatementMetdata//*[@tdf:version]"
                       id="CompareVersionsInSkeleton-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="every $ver in (//tdf:*/@*[local-name()='version' and namespace-uri()='urn:us:gov:ic:tdf'] | //tdf:HandlingAssertion//@*[local-name()='version' and namespace-uri()='urn:us:gov:ic:tdf'] | //tdf:StatementMetadata//@*[local-name()='version' and namespace-uri()='urn:us:gov:ic:tdf']) satisfies (number(if (contains($ver,'-')) then substring-before($ver,'-') else $ver))=(number(if (contains(@*[local-name()='version' and namespace-uri()='urn:us:gov:ic:tdf'],'-')) then substring-before(@*[local-name()='version' and namespace-uri()='urn:us:gov:ic:tdf'],'-') else @*[local-name()='version' and namespace-uri()='urn:us:gov:ic:tdf']))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $ver in (//tdf:*/@*[local-name()='version' and namespace-uri()='urn:us:gov:ic:tdf'] | //tdf:HandlingAssertion//@*[local-name()='version' and namespace-uri()='urn:us:gov:ic:tdf'] | //tdf:StatementMetadata//@*[local-name()='version' and namespace-uri()='urn:us:gov:ic:tdf']) satisfies (number(if (contains($ver,'-')) then substring-before($ver,'-') else $ver))=(number(if (contains(@*[local-name()='version' and namespace-uri()='urn:us:gov:ic:tdf'],'-')) then substring-before(@*[local-name()='version' and namespace-uri()='urn:us:gov:ic:tdf'],'-') else @*[local-name()='version' and namespace-uri()='urn:us:gov:ic:tdf']))">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[
        <xsl:text/>
                  <xsl:value-of select="'IC-TDF-ID-00052'"/>
                  <xsl:text/>][Error] The {
        <xsl:text/>
                  <xsl:value-of select="'urn:us:gov:ic:tdf'"/>
                  <xsl:text/>}
        <xsl:text/>
                  <xsl:value-of select="'version'"/>
                  <xsl:text/> declared must be the same throughout the IC-TDF skeleton including the HandlingAssertions and
        StatementMetadata within assertions. Versions found: 
        <xsl:text/>
                  <xsl:value-of select="string-join(distinct-values(for $ver in (//tdf:*/@*[local-name()='version' and namespace-uri()='urn:us:gov:ic:tdf'] | //tdf:HandlingAssertion//@*[local-name()='version' and namespace-uri()='urn:us:gov:ic:tdf'] | //tdf:StatementMetadata//@*[local-name()='version' and namespace-uri()='urn:us:gov:ic:tdf']) return $ver), ', ')"/>
                  <xsl:text/>
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

   <!--PATTERN IC-TDF-ID-00053-->


	<!--RULE CompareVersionsInSkeleton-R1-->
<xsl:template match="//tdf:*[@ism:ISMCATCESVersion] | //tdf:HandlingAssertion//*[@ism:ISMCATCESVersion] | //tdf:StatementMetdata//*[@ism:ISMCATCESVersion]"
                 priority="1000"
                 mode="M39">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//tdf:*[@ism:ISMCATCESVersion] | //tdf:HandlingAssertion//*[@ism:ISMCATCESVersion] | //tdf:StatementMetdata//*[@ism:ISMCATCESVersion]"
                       id="CompareVersionsInSkeleton-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="every $ver in (//tdf:*/@*[local-name()='ISMCATCESVersion' and namespace-uri()='urn:us:gov:ic:ism'] | //tdf:HandlingAssertion//@*[local-name()='ISMCATCESVersion' and namespace-uri()='urn:us:gov:ic:ism'] | //tdf:StatementMetadata//@*[local-name()='ISMCATCESVersion' and namespace-uri()='urn:us:gov:ic:ism']) satisfies (number(if (contains($ver,'-')) then substring-before($ver,'-') else $ver))=(number(if (contains(@*[local-name()='ISMCATCESVersion' and namespace-uri()='urn:us:gov:ic:ism'],'-')) then substring-before(@*[local-name()='ISMCATCESVersion' and namespace-uri()='urn:us:gov:ic:ism'],'-') else @*[local-name()='ISMCATCESVersion' and namespace-uri()='urn:us:gov:ic:ism']))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $ver in (//tdf:*/@*[local-name()='ISMCATCESVersion' and namespace-uri()='urn:us:gov:ic:ism'] | //tdf:HandlingAssertion//@*[local-name()='ISMCATCESVersion' and namespace-uri()='urn:us:gov:ic:ism'] | //tdf:StatementMetadata//@*[local-name()='ISMCATCESVersion' and namespace-uri()='urn:us:gov:ic:ism']) satisfies (number(if (contains($ver,'-')) then substring-before($ver,'-') else $ver))=(number(if (contains(@*[local-name()='ISMCATCESVersion' and namespace-uri()='urn:us:gov:ic:ism'],'-')) then substring-before(@*[local-name()='ISMCATCESVersion' and namespace-uri()='urn:us:gov:ic:ism'],'-') else @*[local-name()='ISMCATCESVersion' and namespace-uri()='urn:us:gov:ic:ism']))">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[
        <xsl:text/>
                  <xsl:value-of select="'IC-TDF-ID-00053'"/>
                  <xsl:text/>][Error] The {
        <xsl:text/>
                  <xsl:value-of select="'urn:us:gov:ic:ism'"/>
                  <xsl:text/>}
        <xsl:text/>
                  <xsl:value-of select="'ISMCATCESVersion'"/>
                  <xsl:text/> declared must be the same throughout the IC-TDF skeleton including the HandlingAssertions and
        StatementMetadata within assertions. Versions found: 
        <xsl:text/>
                  <xsl:value-of select="string-join(distinct-values(for $ver in (//tdf:*/@*[local-name()='ISMCATCESVersion' and namespace-uri()='urn:us:gov:ic:ism'] | //tdf:HandlingAssertion//@*[local-name()='ISMCATCESVersion' and namespace-uri()='urn:us:gov:ic:ism'] | //tdf:StatementMetadata//@*[local-name()='ISMCATCESVersion' and namespace-uri()='urn:us:gov:ic:ism']) return $ver), ', ')"/>
                  <xsl:text/>
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

   <!--PATTERN IC-TDF-ID-00054-->


	<!--RULE IC-TDF-ID-00054-R1-->
<xsl:template match="*[@tdf:version]" priority="1000" mode="M40">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[@tdf:version]"
                       id="IC-TDF-ID-00054-R1"/>

		    <!--ASSERT warning-->
<xsl:choose>
         <xsl:when test="matches(@tdf:version, '^202111-IC-TDF.202111(\-.{1,23})?$')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="matches(@tdf:version, '^202111-IC-TDF.202111(\-.{1,23})?$')">
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [IC-TDF-ID-00054][Warning] tdf:version attribute SHOULD be specified as
            version 202111-IC-TDF.202111 with an optional extension. Found: <xsl:text/>
                  <xsl:value-of select="@tdf:version"/>
                  <xsl:text/>
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

   <!--PATTERN IC-TDF-ID-00055-->


	<!--RULE IC-TDF-ID-00055-R1-->
<xsl:template match="tdf:TrustedDataObject[not(tdf:*/@tdf:isEncrypted=true())]"
                 priority="1000"
                 mode="M41">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:TrustedDataObject[not(tdf:*/@tdf:isEncrypted=true())]"
                       id="IC-TDF-ID-00055-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="not(count(child::tdf:HandlingAssertion[child::tdf:HandlingStatement/edh:Edh and @tdf:scope = 'PAYL']) &gt; 1)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(count(child::tdf:HandlingAssertion[child::tdf:HandlingStatement/edh:Edh and @tdf:scope = 'PAYL']) &gt; 1)">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IC-TDF-ID-00055][Error] For element TrustedDataObject whose payload is NOT encrypted, there must not be more than
                    one element HandlingAssertion that specifies attribute scope containing [PAYL] and contains an EDH element. Human Readable: For
                    TrustedDataObjects with unencrypted payloads, there must not be more than a single EDH HandlingAssertion scoped for the
                    payload.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M41"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M41"/>
   <xsl:template match="@*|node()" priority="-2" mode="M41">
      <xsl:apply-templates select="*" mode="M41"/>
   </xsl:template>

   <!--PATTERN IC-TDF-ID-00056-->


	<!--RULE ValidateValidationEnvCVE-R1-->
<xsl:template match="/" priority="1000" mode="M42">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/"
                       id="ValidateValidationEnvCVE-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="document('../../CVE/ISM/CVEnumISMClassificationAll.xml')//cve:CVE//@specVersion castable as xs:double              and document('../../CVE/ISM/CVEnumISMClassificationAll.xml')//cve:CVE//@specVersion &gt;= '202111'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('../../CVE/ISM/CVEnumISMClassificationAll.xml')//cve:CVE//@specVersion castable as xs:double and document('../../CVE/ISM/CVEnumISMClassificationAll.xml')//cve:CVE//@specVersion &gt;= '202111'">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
            [<xsl:text/>
                  <xsl:value-of select="'IC-TDF-ID-00056'"/>
                  <xsl:text/>][Error] Version [ <xsl:text/>
                  <xsl:value-of select="document('../../CVE/ISM/CVEnumISMClassificationAll.xml')//cve:CVE//@specVersion"/>
                  <xsl:text/> ] of <xsl:text/>
                  <xsl:value-of select="'ISM'"/>
                  <xsl:text/> found; 
            Version [<xsl:text/>
                  <xsl:value-of select="'202111'"/>
                  <xsl:text/>] or later is required. The latest version of <xsl:text/>
                  <xsl:value-of select="'ISM'"/>
                  <xsl:text/> 
            is not being used in the validation infrastructure. Regardless of the version indicated on the instance document, 
            the validation infrastructure needs to use a version of <xsl:text/>
                  <xsl:value-of select="'ISM'"/>
                  <xsl:text/> that is
            version [<xsl:text/>
                  <xsl:value-of select="'202111'"/>
                  <xsl:text/>] or later. NOTE: This is not an error of the instance
            document but of the validation environment itself. The incorrect value was found in <xsl:text/>
                  <xsl:value-of select="document-uri(document('../../CVE/ISM/CVEnumISMClassificationAll.xml'))"/>
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

   <!--PATTERN IC-TDF-ID-00057-->


	<!--RULE ValidateValidationEnvSchema-R1-->
<xsl:template match="/" priority="1000" mode="M43">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/"
                       id="ValidateValidationEnvSchema-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="document('../../Schema/IC-SF/IC-SF.xsd')//xsd:schema//@version castable as xs:double              and document('../../Schema/IC-SF/IC-SF.xsd')//xsd:schema//@version &gt;= '202111'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('../../Schema/IC-SF/IC-SF.xsd')//xsd:schema//@version castable as xs:double and document('../../Schema/IC-SF/IC-SF.xsd')//xsd:schema//@version &gt;= '202111'">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
            [<xsl:text/>
                  <xsl:value-of select="'IC-TDF-ID-00057'"/>
                  <xsl:text/>][Error] Version [ <xsl:text/>
                  <xsl:value-of select="document('../../Schema/IC-SF/IC-SF.xsd')//xsd:schema//@version"/>
                  <xsl:text/> ] of <xsl:text/>
                  <xsl:value-of select="'IC-SF'"/>
                  <xsl:text/> found; 
            Version [<xsl:text/>
                  <xsl:value-of select="'202111'"/>
                  <xsl:text/>] or later is required. The latest version of <xsl:text/>
                  <xsl:value-of select="'IC-SF'"/>
                  <xsl:text/> 
            is not being used in the validation infrastructure. Regardless of the version indicated on the instance document, 
            the validation infrastructure needs to use a version of <xsl:text/>
                  <xsl:value-of select="'IC-SF'"/>
                  <xsl:text/> that is
            version [<xsl:text/>
                  <xsl:value-of select="'202111'"/>
                  <xsl:text/>] or later. NOTE: This is not an error of the instance
            document but of the validation environment itself. The incorrect value was found in <xsl:text/>
                  <xsl:value-of select="document-uri(document('../../Schema/IC-SF/IC-SF.xsd'))"/>
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

   <!--PATTERN IC-TDF-ID-00058-->


	<!--RULE ValidateValidationEnvSchema-R1-->
<xsl:template match="/" priority="1000" mode="M44">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/"
                       id="ValidateValidationEnvSchema-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="document('../../Schema/BASE-TDF/BASE-TDF.xsd')//xsd:schema//@version castable as xs:double              and document('../../Schema/BASE-TDF/BASE-TDF.xsd')//xsd:schema//@version &gt;= '202111'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('../../Schema/BASE-TDF/BASE-TDF.xsd')//xsd:schema//@version castable as xs:double and document('../../Schema/BASE-TDF/BASE-TDF.xsd')//xsd:schema//@version &gt;= '202111'">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
            [<xsl:text/>
                  <xsl:value-of select="'IC-TDF-ID-00058'"/>
                  <xsl:text/>][Error] Version [ <xsl:text/>
                  <xsl:value-of select="document('../../Schema/BASE-TDF/BASE-TDF.xsd')//xsd:schema//@version"/>
                  <xsl:text/> ] of <xsl:text/>
                  <xsl:value-of select="'BASE-TDF'"/>
                  <xsl:text/> found; 
            Version [<xsl:text/>
                  <xsl:value-of select="'202111'"/>
                  <xsl:text/>] or later is required. The latest version of <xsl:text/>
                  <xsl:value-of select="'BASE-TDF'"/>
                  <xsl:text/> 
            is not being used in the validation infrastructure. Regardless of the version indicated on the instance document, 
            the validation infrastructure needs to use a version of <xsl:text/>
                  <xsl:value-of select="'BASE-TDF'"/>
                  <xsl:text/> that is
            version [<xsl:text/>
                  <xsl:value-of select="'202111'"/>
                  <xsl:text/>] or later. NOTE: This is not an error of the instance
            document but of the validation environment itself. The incorrect value was found in <xsl:text/>
                  <xsl:value-of select="document-uri(document('../../Schema/BASE-TDF/BASE-TDF.xsd'))"/>
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
</xsl:stylesheet>
<!--UNCLASSIFIED-->
