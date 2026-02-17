<?xml version="1.0" encoding="UTF-8"?>
<!--UNCLASSIFIED--><xsl:stylesheet xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                xmlns:saxon="http://saxon.sf.net/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:schold="http://www.ascc.net/xml/schematron"
                xmlns:iso="http://purl.oclc.org/dsdl/schematron"
                xmlns:xhtml="http://www.w3.org/1999/xhtml"
                xmlns:tdf="urn:us:gov:ic:tdf"
                xmlns:ism="urn:us:gov:ic:ism"
                xmlns:sfhashv="urn:us:gov:ic:sf:hashverification"
                xmlns:sf="urn:us:gov:ic:sf"
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
         <svrl:ns-prefix-in-attribute-values uri="urn:us:gov:ic:tdf" prefix="tdf"/>
         <svrl:ns-prefix-in-attribute-values uri="urn:us:gov:ic:ism" prefix="ism"/>
         <svrl:ns-prefix-in-attribute-values uri="urn:us:gov:ic:sf:hashverification" prefix="sfhashv"/>
         <svrl:ns-prefix-in-attribute-values uri="urn:us:gov:ic:sf" prefix="sf"/>
         <svrl:ns-prefix-in-attribute-values uri="urn:us:gov:ic:tdf:xsl:util" prefix="util"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BASE-TDF-ID-00001</xsl:attribute>
            <xsl:attribute name="name">BASE-TDF-ID-00001</xsl:attribute>
            <svrl:text>
        [BASE-TDF-ID-00001][Warning] tdf:version attribute SHOULD be specified as version 202111
        (Version:2021-NOV) with an optional extension.
    </svrl:text>
            <svrl:text>
        This rule supports extending the version identifier with an optional trailing hyphen and up to 23 additional
        characters. The version must match the regular expression "^202111(-.{1,23})?$".
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M7"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BASE-TDF-ID-00002</xsl:attribute>
            <xsl:attribute name="name">BASE-TDF-ID-00002</xsl:attribute>
            <svrl:text>[BASE-TDF-ID-00002][Error] Attribute @appliesToState is only allowed when TDO payload attrbute @isEncrypted equals
           "true". Human Readable: Handling Statement state applicability can only be defined when an encrypted payload is present.</svrl:text>
            <svrl:text>If attribute @appliesToState is defined, this rule ensures that there is a payload element with attribute
           isEncrypted set to true.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M8"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BASE-TDF-ID-00003</xsl:attribute>
            <xsl:attribute name="name">BASE-TDF-ID-00003</xsl:attribute>
            <svrl:text>[BASE-TDF-ID-00003][Error] Attribute @appliesToState is only allowed when TDO statement attribute @isEncrypted equals
           "true". Human Readable: StatementMetadata state applicability can only be defined when an encrypted statement is present.</svrl:text>
            <svrl:text>If attribute @appliesToState is defined, this rule ensures that there is a statement element with attribute
           isEncrypted set to true.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M9"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BASE-TDF-ID-00004</xsl:attribute>
            <xsl:attribute name="name">BASE-TDF-ID-00004</xsl:attribute>
            <svrl:text>[BASE-TDF-ID-00004][Error] Attribute @appliesToState is only allowed on HandlingAssertions
        with scope PAYL. Human Readable: Only Handling Assertions with scope PAYL can use the
        appliesToState attribute because the attribute indicates the state (encrypted or
        unencrypted) of the payload to which the assertion applies.</svrl:text>
            <svrl:text>If attribute
        @appliesToState is defined on a handlingAssertion, this rule ensures that handlingAssertion
        has scope PAYL</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M10"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BASE-TDF-ID-00005</xsl:attribute>
            <xsl:attribute name="name">BASE-TDF-ID-00005</xsl:attribute>
            <svrl:text>[BASE-TDF-ID-00005][Error] All attributes in the TDF namespace MUST contain a non-whitespace value. Human Readable:
           All attributes in the TDF namespace must specify a value.</svrl:text>
            <svrl:text>For all attributes in the tdf namespace, this rule ensures that each contains a non-whitespace value.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M11"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BASE-TDF-ID-00006</xsl:attribute>
            <xsl:attribute name="name">BASE-TDF-ID-00006</xsl:attribute>
            <svrl:text>[BASE-TDF-ID-00006][Error] If the root element is TrustedDataObject, then it must specify attribute version. Human
           Readable: If TrustedDataObject is the root element, then it must declare a TDF version to which it complies.</svrl:text>
            <svrl:text>For a tdf:TrustedDataObject element that is a root element, this rule ensures that it specifies attribute
           tdf:version.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M12"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BASE-TDF-ID-00007</xsl:attribute>
            <xsl:attribute name="name">BASE-TDF-ID-00007</xsl:attribute>
            <svrl:text>[BASE-TDF-ID-00007][Error] For any child element of TrustedDataObject, the only allowable tokens for attribute scope
           are [PAYL], [TDO], or [EXPLICIT]. Human Readable: Scopes defined within a TrustedDataObject must refer to the payload, the entire
           TrustedDataObject, the combination of the payload and the entire TrustedDataObject, or be explicitly defined.</svrl:text>
            <svrl:text>For the scope attribute specified on any child element of TrustedDataObject, this rule ensures that the value only
           contains the tokens [PAYL], [TDO], or [EXPLICIT].</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M13"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BASE-TDF-ID-00008</xsl:attribute>
            <xsl:attribute name="name">BASE-TDF-ID-00008</xsl:attribute>
            <svrl:text>[BASE-TDF-ID-00008][Error] For any child assertion of TrustedDataCollection, the only allowable tokens for attribute
           scope are [TDC], [DESC_PAYL], [DESC_TDO], [TDC_MEMBER], or [EXPLICIT]. Human Readable: Scopes defined within a TrustedDataCollection must
           refer to the descendent TDOs (the list of TDOs), the descendent Payloads, a TDC Member, the entire TrustedDataCollection, or be explicitly
           defined.</svrl:text>
            <svrl:text>For the scope attribute specified on any child element of TrustedDataCollection, this rule ensures that the value
           only contains the tokens [TDC], [DESC_PAYL], [DESC_TDO], [TDC_MEMBER], or [EXPLICIT].</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M14"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BASE-TDF-ID-00009</xsl:attribute>
            <xsl:attribute name="name">BASE-TDF-ID-00009</xsl:attribute>
            <svrl:text>[BASE-TDF-ID-00009][Error] The use of EXPLICIT scope is not currently allowed. Key questions regarding the
           functionality of Binding within EXPLICIT scope are still being defined. The rest of the rules/structure relating to EXPLICIT scope are
           included in the spec to give the community an idea of how these rules/structures will be defined. If there is a use-case which requires
           EXPLICIT scope, please send an email to ic-standards-support@odni.gov so that the use-case can be incorporated while defining the
           behavior of EXPLICIT scope.</svrl:text>
            <svrl:text>For any element which specifies attribute scope containing [EXPLICIT], instantly fail because EXPLICIT scope is
           currently not supported.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M15"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BASE-TDF-ID-00010</xsl:attribute>
            <xsl:attribute name="name">BASE-TDF-ID-00010</xsl:attribute>
            <svrl:text>[BASE-TDF-ID-00010][Error] For element Binding, if element BoundValueList is specified, then element SignatureValue
           must not specify attribute includesStatementMetadata. Human Readable: If BoundValueList is present, then it will explicitly specify
           includesStatementMetadata for each BoundValue and therefore attribute includesStatementMetadata on the SignatureValue is not
           applicable.</svrl:text>
            <svrl:text>For element Binding which specifies BoundValueList, this rule ensures that element SignatureValue does not specify
           attribute includesStatementMetadata.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M16"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BASE-TDF-ID-00011</xsl:attribute>
            <xsl:attribute name="name">BASE-TDF-ID-00011</xsl:attribute>
            <svrl:text>[BASE-TDF-ID-00011][Error] For element Binding, if element BoundValueList is not specified, then element
           SignatureValue must specify attribute includesStatementMetadata. Human Readable: If BoundValueList is not present, then SignatureValue
           must indicate whether or not to include the StatementMetadata of all Assertions included in the binding.</svrl:text>
            <svrl:text>For element Binding that does not have child element BoundValueList, this rule ensures that child element
           SignatureValue specifies attribute includesStatementMetadata.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M17"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BASE-TDF-ID-00012</xsl:attribute>
            <xsl:attribute name="name">BASE-TDF-ID-00012</xsl:attribute>
            <svrl:text>[BASE-TDF-ID-00012][Error] For all BoundValue or Reference elements within a TrustedDataObject, idRef attribute
           values must reference the id value of a descendant of the same TrustedDataObject that contains the Reference or BoundValue element. Human
           Readable: Assertions and HandlingAssertions within a TrustedDataObject must reference elements local to that TrustedDataObject.</svrl:text>
            <svrl:text>For element TrustedDataObject, this rule ensures each attribute @idRef value has matching @id value in the same
           TDO.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M18"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BASE-TDF-ID-00013</xsl:attribute>
            <xsl:attribute name="name">BASE-TDF-ID-00013</xsl:attribute>
            <svrl:text>[BASE-TDF-ID-00013][Error]
    For any element which specifies attribute scope containing [EXPLICIT], then element
    Binding/BoundValueList or element ReferenceList must be specified. Human Readable: Assertions
    with explicit scope require either a BoundValueList or a ReferenceList to identify the elements
    for which the assertion applies.</svrl:text>
            <svrl:text>For elements which specify
    attribute scope with a value of [EXPLICIT], this rule ensures that element
    Binding/BoundValueList or ReferenceList is specified.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M19"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BASE-TDF-ID-00014</xsl:attribute>
            <xsl:attribute name="name">BASE-TDF-ID-00014</xsl:attribute>
            <svrl:text>[BASE-TDF-ID-00014][Error] Elements ReferenceList and BoundValueList are currently not allowed. Key questions
           regarding the functionality of granular references and granular binding are still being defined. The rest of the rules/structure relating
           to these elements are included in the spec to give the community an idea of how these rules/structures will be defined. If there is a
           use-case which requires granular references or granular binding, please send an email to ic-standards-support@odni.gov so that the
           use-case can be incorporated while defining the behavior and rules.</svrl:text>
            <svrl:text>Elements ReferenceList and BoundValueList are not allowed in this version. This rule will in the future require that elements
           which specify element ReferenceList or Binding/BoundValueList have attribute scope is specified with a value of [EXPLICIT].</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M20"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BASE-TDF-ID-00015</xsl:attribute>
            <xsl:attribute name="name">BASE-TDF-ID-00015</xsl:attribute>
            <svrl:text>[BASE-TDF-ID-00015][Error] If EncryptionInformation is specified, then the data it refers to must be labeled as
           encrypted. (Assertion Statement or TrustedDataObject Payload).</svrl:text>
            <svrl:text>This rule ensures that the following sibling of EncryptionInformation, the Payload or Assertion Statement, has the
           encrypted attribute set to true.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M21"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BASE-TDF-ID-00016</xsl:attribute>
            <xsl:attribute name="name">BASE-TDF-ID-00016</xsl:attribute>
            <svrl:text>[BASE-TDF-ID-00016][Error] If data is labeled as encrypted, then EncryptionInformation must be specified. (Assertion
           Statement or TrustedDataObject Payload).</svrl:text>
            <svrl:text>This rule ensures that the previous sibling of the Statement or Payload marked with the encrypted attribute set to
           true is EncryptionInformation.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M22"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BASE-TDF-ID-00017</xsl:attribute>
            <xsl:attribute name="name">BASE-TDF-ID-00017</xsl:attribute>
            <svrl:text>[BASE-TDF-ID-00017][Error] For any handling assertion child element of TrustedDataCollection, the only allowable
           token for attribute scope is [TDC]. Human Readable: Scopes defined within a TrustedDataCollection Handling Assertion must refer to entire
           TrustedDataCollection.</svrl:text>
            <svrl:text>For the scope attribute specified on handlingAssertion child elements of TrustedDataCollection, make sure that
           the value only contains the tokens [TDC].</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M23"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BASE-TDF-ID-00018</xsl:attribute>
            <xsl:attribute name="name">BASE-TDF-ID-00018</xsl:attribute>
            <svrl:text>[BASE-TDF-ID-00018][Error] For the Binding element, every Signer element must specify the issuer attribute and either
           the serial or subject attribute.</svrl:text>
            <svrl:text>This rule checks that for each occurrence of tdf:Signer that @tdf:issuer and either @tdf:subject or @tdf:serial is
           specified.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M24"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BASE-TDF-ID-00019</xsl:attribute>
            <xsl:attribute name="name">BASE-TDF-ID-00019</xsl:attribute>
            <svrl:text>[BASE-TDF-ID-00019][Error] If there are more than one EncryptionInformation elements specified in any one
           EncryptionInformation Group than @tdf:sequenceNum must also be specified.</svrl:text>
            <svrl:text>This rule checks that if there are more than one tdf:EncryptionInformation in any encryption group (if it has
           siblings) then it checks that a tdf:sequenceNum attribute is present on the EncryptionInformation element.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M25"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BASE-TDF-ID-00020</xsl:attribute>
            <xsl:attribute name="name">BASE-TDF-ID-00020</xsl:attribute>
            <svrl:text>[BASE-TDF-ID-00020][Error] All sequenceNum attributes in an EncryptionInformation Group must be sequential,
           incrementing by 1, starting with the number 1, and contain no duplicates.</svrl:text>
            <svrl:text>This rule triggers on the first EncryptionInformation element for each EncryptionInformation Group that has more
           than 1 EncryptionInformation element then checks that the sequenceNum attributes are numerically sequential by 1 starting from 1. A list,
           named $nums, is created containing the value of each sequenceNum attribute within the group. If the total number of items in $nums does
           not equal the number of distinct values in $nums, then a duplicate exists return false. Otherwise, ensure that each number from 1 to N,
           where N is the number of items in $nums, is contained within $nums. If each number is contained, then return true. Otherwise,
           false.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M26"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BASE-TDF-ID-00021</xsl:attribute>
            <xsl:attribute name="name">BASE-TDF-ID-00021</xsl:attribute>
            <svrl:text>
        This abstract pattern checks to see if the validation environment has at least the version / revision of the
        Schema as of the writing of this specification. 
        The calling rule must pass in '202111', 'IC-SF', '../../Schema/IC-SF/IC-SF.xsd', 'BASE-TDF-ID-00021'.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M27"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BASE-TDF-ID-00022</xsl:attribute>
            <xsl:attribute name="name">BASE-TDF-ID-00022</xsl:attribute>
            <svrl:text>
        [BASE-TDF-ID-00022][Error] For any tdf:TrustedDataCollection or tdf:TrustedDataObject containing references to any
        sfhashv (urn:us:gov:ic:sf:hashverification) elements, that tdf:TrustedDataCollection or tdf:TrustedDataObject must 
        have the @sf:DESVersion attribute. 
    </svrl:text>
            <svrl:text>
        For any tdf:TrustedDataCollection or tdf:TrustedDataObject containing references to any
        sfhashv (urn:us:gov:ic:sf:hashverification) elements, that tdf:TrustedDataCollection or tdf:TrustedDataObject must 
        have the @sf:DESVersion attribute. 
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M28"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BASE-TDF-ID-00023</xsl:attribute>
            <xsl:attribute name="name">BASE-TDF-ID-00023</xsl:attribute>
            <svrl:text>
        [BASE-TDF-ID-00023][Warning] If a TDO contains a cryptographic binding for a reference value payload, 
        it should also contain the hash to verify that binding. 
        If the reference value payload is encrypted, then the hash can be the encoded and/or decoded hash. 
        If the reference value payload is not encrypted, then the hash is expected to be the decoded hash. 
    </svrl:text>
            <svrl:text>
        A tdf:TrustedDataObject that contains tdf:Binding and tdf:ReferenceValuePayload
        should contain sfhashv:ContentEncodedHashVerification or sfhashv:ContentDecodedHashVerification if @tdf:isEncrypted = 'true' 
        or just sfhashv:ContentDecodedHashVerification if @tdf:isEncrypted did not exist or @tdf:isEncrypted = 'false'.
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M29"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BASE-TDF-ID-00024</xsl:attribute>
            <xsl:attribute name="name">BASE-TDF-ID-00024</xsl:attribute>
            <svrl:text>
        [BASE-TDF-ID-00024][Warning] If a TDF assertion contains a cryptographic binding for a reference statement, 
        it should also contain the hash to verify that binding. 
        If the reference statement is encrypted, then the hash can be the encoded and/or decoded hash. 
        If the reference statement is not encrypted, then the hash is expected to be the decoded hash. 
    </svrl:text>
            <svrl:text>
        A tdf:Assertion that contains tdf:Binding and tdf:ReferenceStatement
        should contain sfhashv:ContentEncodedHashVerification or sfhashv:ContentDecodedHashVerification if @tdf:isEncrypted = 'true' 
        or just sfhashv:ContentDecodedHashVerification if @tdf:isEncrypted did not exist or @tdf:isEncrypted = 'false'.
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M30"/>
      </svrl:schematron-output>
   </xsl:template>

   <!--SCHEMATRON PATTERNS-->


<!--PATTERN BASE-TDF-ID-00001-->


	<!--RULE BASE-TDF-ID-00001-R1-->
<xsl:template match="*[@tdf:version]" priority="1000" mode="M7">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[@tdf:version]"
                       id="BASE-TDF-ID-00001-R1"/>

		    <!--ASSERT warning-->
<xsl:choose>
         <xsl:when test="matches(@tdf:version, '^202111(\-.{1,23})?$')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="matches(@tdf:version, '^202111(\-.{1,23})?$')">
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [BASE-TDF-ID-00001][Warning] tdf:version attribute SHOULD be specified as
            version 202111 (Version:2021-NOV) with an optional extension. Found: <xsl:text/>
                  <xsl:value-of select="@tdf:version"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M7"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M7"/>
   <xsl:template match="@*|node()" priority="-2" mode="M7">
      <xsl:apply-templates select="*" mode="M7"/>
   </xsl:template>

   <!--PATTERN BASE-TDF-ID-00002-->


	<!--RULE BASE-TDF-ID-00002-R1-->
<xsl:template match="tdf:TrustedDataObject[tdf:HandlingAssertion/@tdf:appliesToState]"
                 priority="1000"
                 mode="M8">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:TrustedDataObject[tdf:HandlingAssertion/@tdf:appliesToState]"
                       id="BASE-TDF-ID-00002-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="./*/@tdf:isEncrypted = true()"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="./*/@tdf:isEncrypted = true()">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[BASE-TDF-ID-00002][Error] Attribute @appliesToState is only allowed when TDO payload attrbute @isEncrypted equals
                    "true". Human Readable: Handling Statement state applicability can only be defined when an encrypted payload is
                    present.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M8"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M8"/>
   <xsl:template match="@*|node()" priority="-2" mode="M8">
      <xsl:apply-templates select="*" mode="M8"/>
   </xsl:template>

   <!--PATTERN BASE-TDF-ID-00003-->


	<!--RULE BASE-TDF-ID-00003-R1-->
<xsl:template match="tdf:TrustedDataObject/tdf:Assertion[tdf:StatementMetadata/@tdf:appliesToState]"
                 priority="1000"
                 mode="M9">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:TrustedDataObject/tdf:Assertion[tdf:StatementMetadata/@tdf:appliesToState]"
                       id="BASE-TDF-ID-00003-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="./*/@tdf:isEncrypted = true()"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="./*/@tdf:isEncrypted = true()">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[BASE-TDF-ID-00003][Error] Attribute @appliesToState is only allowed when TDO statement attribute @isEncrypted equals
                    "true". Human Readable: StatementMetadata state applicability can only be defined when an encrypted statement is
                    present.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M9"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M9"/>
   <xsl:template match="@*|node()" priority="-2" mode="M9">
      <xsl:apply-templates select="*" mode="M9"/>
   </xsl:template>

   <!--PATTERN BASE-TDF-ID-00004-->


	<!--RULE BASE-TDF-ID-00004-R1-->
<xsl:template match="tdf:TrustedDataObject/tdf:HandlingAssertion[@tdf:appliesToState]"
                 priority="1000"
                 mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:TrustedDataObject/tdf:HandlingAssertion[@tdf:appliesToState]"
                       id="BASE-TDF-ID-00004-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="@tdf:scope = 'PAYL'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@tdf:scope = 'PAYL'">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[BASE-TDF-ID-00004][Error]
            Attribute @appliesToState is only allowed with HandlingAssertions of scope PAYL Human
            Readable: Only Handling Assertions with scope PAYL can use the appliesToState attribute
            because the attribute indicates the state (encrypted or unencrypted) of the payload to
            which the assertion applies.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M10"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M10"/>
   <xsl:template match="@*|node()" priority="-2" mode="M10">
      <xsl:apply-templates select="*" mode="M10"/>
   </xsl:template>

   <!--PATTERN BASE-TDF-ID-00005-->


	<!--RULE BASE-TDF-ID-00005-R1-->
<xsl:template match="*[@tdf:*]" priority="1000" mode="M11">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[@tdf:*]"
                       id="BASE-TDF-ID-00005-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="every $attribute in @tdf:* satisfies normalize-space(string($attribute))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $attribute in @tdf:* satisfies normalize-space(string($attribute))">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[BASE-TDF-ID-00005][Error] All attributes in the TDF namespace must specify a value.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M11"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M11"/>
   <xsl:template match="@*|node()" priority="-2" mode="M11">
      <xsl:apply-templates select="*" mode="M11"/>
   </xsl:template>

   <!--PATTERN BASE-TDF-ID-00006-->


	<!--RULE BASE-TDF-ID-00006-R1-->
<xsl:template match="/tdf:TrustedDataObject" priority="1000" mode="M12">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/tdf:TrustedDataObject"
                       id="BASE-TDF-ID-00006-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="@tdf:version"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@tdf:version">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[BASE-TDF-ID-00006][Error] If TrustedDataObject is the root element, then it must declare a TDF version to which it
                    complies.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M12"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M12"/>
   <xsl:template match="@*|node()" priority="-2" mode="M12">
      <xsl:apply-templates select="*" mode="M12"/>
   </xsl:template>

   <!--PATTERN BASE-TDF-ID-00007-->


	<!--RULE BASE-TDF-ID-00007-R1-->
<xsl:template match="tdf:TrustedDataObject/*[@tdf:scope]"
                 priority="1000"
                 mode="M13">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:TrustedDataObject/*[@tdf:scope]"
                       id="BASE-TDF-ID-00007-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="util:containsOnlyTheTokens(@tdf:scope, ('PAYL', 'TDO', 'EXPLICIT'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="util:containsOnlyTheTokens(@tdf:scope, ('PAYL', 'TDO', 'EXPLICIT'))">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[BASE-TDF-ID-00007][Error] For any child element of TrustedDataObject, the only allowable tokens for attribute scope
                    are [PAYL], [TDO], or [EXPLICIT]. Human Readable: Scopes defined within a TrustedDataObject must refer to the payload, the entire
                    TrustedDataObject, the combination of the payload and the entire TrustedDataObject, or be explicitly defined.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M13"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M13"/>
   <xsl:template match="@*|node()" priority="-2" mode="M13">
      <xsl:apply-templates select="*" mode="M13"/>
   </xsl:template>

   <!--PATTERN BASE-TDF-ID-00008-->


	<!--RULE BASE-TDF-ID-00008-R1-->
<xsl:template match="tdf:TrustedDataCollection/*[@tdf:scope]"
                 priority="1000"
                 mode="M14">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:TrustedDataCollection/*[@tdf:scope]"
                       id="BASE-TDF-ID-00008-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="util:containsOnlyTheTokens(@tdf:scope, ('TDC', 'DESC_PAYL', 'DESC_TDO', 'TDC_MEMBER', 'EXPLICIT'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="util:containsOnlyTheTokens(@tdf:scope, ('TDC', 'DESC_PAYL', 'DESC_TDO', 'TDC_MEMBER', 'EXPLICIT'))">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[BASE-TDF-ID-00008][Error] For any child element of TrustedDataCollection, the only allowable tokens for attribute
                    scope are [TDC], [DESC_PAYL], [DESC_TDO], [TDC_MEMBER], or [EXPLICIT]. Human Readable: Scopes defined within a
                    TrustedDataCollection must refer to the descendent TDOs (the list of TDOs), the descendent Payloads, a TDC Member, the entire
                    TrustedDataCollection, or be explicitly defined.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M14"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M14"/>
   <xsl:template match="@*|node()" priority="-2" mode="M14">
      <xsl:apply-templates select="*" mode="M14"/>
   </xsl:template>

   <!--PATTERN BASE-TDF-ID-00009-->


	<!--RULE BASE-TDF-ID-00009-R1-->
<xsl:template match="*[util:containsAnyOfTheTokens(@tdf:scope, ('EXPLICIT'))]"
                 priority="1000"
                 mode="M15">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[util:containsAnyOfTheTokens(@tdf:scope, ('EXPLICIT'))]"
                       id="BASE-TDF-ID-00009-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="false()"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[BASE-TDF-ID-00009][Error] The use of EXPLICIT scope is not currently allowed. Key questions regarding the
                    functionality of Binding within EXPLICIT scope are still being defined. The rest of the rules/structure relating to EXPLICIT
                    scope are included in the spec to give the community an idea of how these rules/structures will be defined. If there is a
                    use-case which requires EXPLICIT scope, please send an email to ic-standards-support@odni.gov so that the use-case can be
                    incorporated while defining the behavior of EXPLICIT scope.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M15"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M15"/>
   <xsl:template match="@*|node()" priority="-2" mode="M15">
      <xsl:apply-templates select="*" mode="M15"/>
   </xsl:template>

   <!--PATTERN BASE-TDF-ID-00010-->


	<!--RULE BASE-TDF-ID-00010-R1-->
<xsl:template match="tdf:Binding[tdf:BoundValueList]" priority="1000" mode="M16">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:Binding[tdf:BoundValueList]"
                       id="BASE-TDF-ID-00010-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="not(tdf:SignatureValue/@tdf:includesStatementMetadata)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(tdf:SignatureValue/@tdf:includesStatementMetadata)">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[BASE-TDF-ID-00010][Error] For element Binding, if element BoundValueList is specified, then element SignatureValue
                    must not specify attribute includesStatementMetadata. Human Readable: If BoundValueList is present, then it will explicitly
                    specify includesStatementMetadata for each BoundValue and therefore attribute includesStatementMetadata on the SignatureValue is
                    not applicable.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M16"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M16"/>
   <xsl:template match="@*|node()" priority="-2" mode="M16">
      <xsl:apply-templates select="*" mode="M16"/>
   </xsl:template>

   <!--PATTERN BASE-TDF-ID-00011-->


	<!--RULE BASE-TDF-ID-00011-R1-->
<xsl:template match="tdf:Binding[not(tdf:BoundValueList)]"
                 priority="1000"
                 mode="M17">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:Binding[not(tdf:BoundValueList)]"
                       id="BASE-TDF-ID-00011-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="tdf:SignatureValue/@tdf:includesStatementMetadata"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="tdf:SignatureValue/@tdf:includesStatementMetadata">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[BASE-TDF-ID-00011][Error] For element Binding, if element BoundValueList is not specified, then element
                    SignatureValue must specify attribute includesStatementMetadata. Human Readable: If BoundValueList is not present, then
                    SignatureValue must indicate whether or not to include the StatementMetadata of all Assertions included in the
                    binding.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M17"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M17"/>
   <xsl:template match="@*|node()" priority="-2" mode="M17">
      <xsl:apply-templates select="*" mode="M17"/>
   </xsl:template>

   <!--PATTERN BASE-TDF-ID-00012-->


	<!--RULE BASE-TDF-ID-00012-R1-->
<xsl:template match="tdf:TrustedDataObject" priority="1000" mode="M18">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:TrustedDataObject"
                       id="BASE-TDF-ID-00012-R1"/>
      <xsl:variable name="ids" select=".//@tdf:id"/>
      <xsl:variable name="externalIdRefs"
                    select=" for $idRef in .//@tdf:idRef return if($idRef = $ids) then null else $idRef"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="count($externalIdRefs) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count($externalIdRefs) = 0">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[BASE-TDF-ID-00012][Error] For all BoundValue or Reference elements within a TrustedDataObject, idRef attribute values
                    must reference the id value of a descendant of the same TrustedDataObject that contains the Reference or BoundValue element.
                    Human Readable: Assertions and HandlingAssertions within a TrustedDataObject must reference elements local to that
                    TrustedDataObject. The following idRefs reference elements outside of this TrustedDataObject: ( 
        <xsl:text/>
                  <xsl:value-of select="for $externalRef in $externalIdRefs return concat(string($externalRef), ', ')"/>
                  <xsl:text/>).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M18"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M18"/>
   <xsl:template match="@*|node()" priority="-2" mode="M18">
      <xsl:apply-templates select="*" mode="M18"/>
   </xsl:template>

   <!--PATTERN BASE-TDF-ID-00013-->


	<!--RULE BASE-TDF-ID-00013-R1-->
<xsl:template match="*[normalize-space(string(@tdf:scope)) = 'EXPLICIT']"
                 priority="1000"
                 mode="M19">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[normalize-space(string(@tdf:scope)) = 'EXPLICIT']"
                       id="BASE-TDF-ID-00013-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="tdf:Binding/tdf:BoundValueList or tdf:ReferenceList"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="tdf:Binding/tdf:BoundValueList or tdf:ReferenceList">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[BASE-TDF-ID-00013][Error] For any element which specifies attribute scope containing
      [EXPLICIT], then element Binding/BoundValueList or element ReferenceList must be specified.
      Human Readable: Assertions with explicit scope require either a BoundValueList or a
      ReferenceList to identify the elements for which the assertion applies.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M19"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M19"/>
   <xsl:template match="@*|node()" priority="-2" mode="M19">
      <xsl:apply-templates select="*" mode="M19"/>
   </xsl:template>

   <!--PATTERN BASE-TDF-ID-00014-->


	<!--RULE BASE-TDF-ID-00014-R1-->
<xsl:template match="tdf:ReferenceList | tdf:Binding/tdf:BoundValueList"
                 priority="1000"
                 mode="M20">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:ReferenceList | tdf:Binding/tdf:BoundValueList"
                       id="BASE-TDF-ID-00014-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="false()"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[BASE-TDF-ID-00014][Error] Elements ReferenceList and BoundValueList are currently not allowed. Key questions
                    regarding the functionality of granular references and granular binding are still being defined. The rest of the rules/structure
                    relating to these elements are included in the spec to give the community an idea of how these rules/structures will be defined.
                    If there is a use-case which requires granular references or granular binding, please send an email to
                    ic-standards-support@odni.gov so that the use-case can be incorporated while defining the behavior and rules.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M20"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M20"/>
   <xsl:template match="@*|node()" priority="-2" mode="M20">
      <xsl:apply-templates select="*" mode="M20"/>
   </xsl:template>

   <!--PATTERN BASE-TDF-ID-00015-->


	<!--RULE BASE-TDF-ID-00015-R1-->
<xsl:template match="tdf:EncryptionInformation[parent::tdf:Assertion] | tdf:EncryptionInformation[parent::tdf:TrustedDataObject]"
                 priority="1000"
                 mode="M21">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:EncryptionInformation[parent::tdf:Assertion] | tdf:EncryptionInformation[parent::tdf:TrustedDataObject]"
                       id="BASE-TDF-ID-00015-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="following-sibling::tdf:*[@tdf:isEncrypted=true()]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="following-sibling::tdf:*[@tdf:isEncrypted=true()]">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[BASE-TDF-ID-00015][Error] If EncryptionInformation is specified, then the data it refers to must be labeled as
                    encrypted. (Assertion Statement or TrustedDataObject Payload).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M21"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M21"/>
   <xsl:template match="@*|node()" priority="-2" mode="M21">
      <xsl:apply-templates select="*" mode="M21"/>
   </xsl:template>

   <!--PATTERN BASE-TDF-ID-00016-->


	<!--RULE BASE-TDF-ID-00016-R1-->
<xsl:template match="tdf:*[@tdf:isEncrypted=true()]" priority="1000" mode="M22">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:*[@tdf:isEncrypted=true()]"
                       id="BASE-TDF-ID-00016-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="preceding-sibling::tdf:EncryptionInformation"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="preceding-sibling::tdf:EncryptionInformation">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[BASE-TDF-ID-00016][Error] If data is labeled as encrypted, then EncryptionInformation must be specified. (Assertion
                    Statement or TrustedDataObject Payload).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M22"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M22"/>
   <xsl:template match="@*|node()" priority="-2" mode="M22">
      <xsl:apply-templates select="*" mode="M22"/>
   </xsl:template>

   <!--PATTERN BASE-TDF-ID-00017-->


	<!--RULE BASE-TDF-ID-00017-R1-->
<xsl:template match="tdf:TrustedDataCollection/tdf:HandlingAssertion"
                 priority="1000"
                 mode="M23">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:TrustedDataCollection/tdf:HandlingAssertion"
                       id="BASE-TDF-ID-00017-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="util:containsOnlyTheTokens(@tdf:scope, ('TDC'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="util:containsOnlyTheTokens(@tdf:scope, ('TDC'))">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[BASE-TDF-ID-00017][Error] For any child handlingAssertion of TrustedDataCollection, the only allowable tokens for
                    attribute scope is [TDC]. Human Readable: Scopes defined within a TrustedDataCollection Handling Assertion must refer to entire
                    TrustedDataCollection.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M23"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M23"/>
   <xsl:template match="@*|node()" priority="-2" mode="M23">
      <xsl:apply-templates select="*" mode="M23"/>
   </xsl:template>

   <!--PATTERN BASE-TDF-ID-00018-->


	<!--RULE BASE-TDF-ID-00018-R1-->
<xsl:template match="tdf:Binding/tdf:Signer" priority="1000" mode="M24">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:Binding/tdf:Signer"
                       id="BASE-TDF-ID-00018-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="@tdf:issuer and (@tdf:serial or @tdf:subject)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="@tdf:issuer and (@tdf:serial or @tdf:subject)">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[BASE-TDF-ID-00018][Error] For the Binding element, every Signer element must specify the issuer attribute and either
                    the serial or subject attribute.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M24"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M24"/>
   <xsl:template match="@*|node()" priority="-2" mode="M24">
      <xsl:apply-templates select="*" mode="M24"/>
   </xsl:template>

   <!--PATTERN BASE-TDF-ID-00019-->


	<!--RULE BASE-TDF-ID-00019-R1-->
<xsl:template match="tdf:EncryptionInformation[count((preceding-sibling::tdf:EncryptionInformation, following-sibling::tdf:EncryptionInformation))&gt;0]"
                 priority="1000"
                 mode="M25">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:EncryptionInformation[count((preceding-sibling::tdf:EncryptionInformation, following-sibling::tdf:EncryptionInformation))&gt;0]"
                       id="BASE-TDF-ID-00019-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="@tdf:sequenceNum"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@tdf:sequenceNum">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[BASE-TDF-ID-00019][Error] If there are more than one EncryptionInformation elements specified in any one
                    EncryptionInformation Group than @tdf:sequenceNum must also be specified.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M25"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M25"/>
   <xsl:template match="@*|node()" priority="-2" mode="M25">
      <xsl:apply-templates select="*" mode="M25"/>
   </xsl:template>

   <!--PATTERN BASE-TDF-ID-00020-->


	<!--RULE BASE-TDF-ID-00020-R1-->
<xsl:template match="tdf:EncryptionInformation[count(following-sibling::tdf:EncryptionInformation)&gt;0][1]"
                 priority="1000"
                 mode="M26">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:EncryptionInformation[count(following-sibling::tdf:EncryptionInformation)&gt;0][1]"
                       id="BASE-TDF-ID-00020-R1"/>
      <xsl:variable name="nums"
                    select="for $encInfo in (., following-sibling::tdf:EncryptionInformation) return number($encInfo/@tdf:sequenceNum)"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="(count(distinct-values($nums)) = count($nums) and (every $index in 1 to count($nums) satisfies index-of($nums, $index)))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="(count(distinct-values($nums)) = count($nums) and (every $index in 1 to count($nums) satisfies index-of($nums, $index)))">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[BASE-TDF-ID-00020][Error] All sequenceNum attributes in an EncryptionInformation Group must be sequential,
                    incrementing by 1, starting with the number 1, and contain no duplicates.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M26"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M26"/>
   <xsl:template match="@*|node()" priority="-2" mode="M26">
      <xsl:apply-templates select="*" mode="M26"/>
   </xsl:template>

   <!--PATTERN BASE-TDF-ID-00021-->


	<!--RULE ValidateValidationEnvSchema-R1-->
<xsl:template match="/" priority="1000" mode="M27">
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
                  <xsl:value-of select="'BASE-TDF-ID-00021'"/>
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
      <xsl:apply-templates select="*" mode="M27"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M27"/>
   <xsl:template match="@*|node()" priority="-2" mode="M27">
      <xsl:apply-templates select="*" mode="M27"/>
   </xsl:template>

   <!--PATTERN BASE-TDF-ID-00022-->


	<!--RULE BASE-TDF-ID-00022-R1-->
<xsl:template match="tdf:TrustedDataCollection[.//sfhashv:* | .//*/@sfhashv:*] | tdf:TrustedDataObject[.//sfhashv:* | .//*/@sfhashv:*]"
                 priority="1000"
                 mode="M28">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:TrustedDataCollection[.//sfhashv:* | .//*/@sfhashv:*] | tdf:TrustedDataObject[.//sfhashv:* | .//*/@sfhashv:*]"
                       id="BASE-TDF-ID-00022-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="./@sf:DESVersion"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="./@sf:DESVersion">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [BASE-TDF-ID-00022][Error] For any tdf:TrustedDataCollection or tdf:TrustedDataObject containing references to any
            sfhashv (urn:us:gov:ic:sf:hashverification) elements, that tdf:TrustedDataCollection or tdf:TrustedDataObject must 
            have the @sf:DESVersion attribute.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M28"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M28"/>
   <xsl:template match="@*|node()" priority="-2" mode="M28">
      <xsl:apply-templates select="*" mode="M28"/>
   </xsl:template>

   <!--PATTERN BASE-TDF-ID-00023-->


	<!--RULE BASE-TDF-ID-00023-R1-->
<xsl:template match="tdf:TrustedDataObject[.//tdf:Binding and .//tdf:ReferenceValuePayload]"
                 priority="1000"
                 mode="M29">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:TrustedDataObject[.//tdf:Binding and .//tdf:ReferenceValuePayload]"
                       id="BASE-TDF-ID-00023-R1"/>

		    <!--ASSERT warning-->
<xsl:choose>
         <xsl:when test="if (.//*/@tdf:isEncrypted and .//*/@tdf:isEncrypted = 'true')                            then .//sfhashv:ContentEncodedHashVerification or ..//sfhashv:ContentDecodedHashVerification                            else ..//sfhashv:ContentDecodedHashVerification"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="if (.//*/@tdf:isEncrypted and .//*/@tdf:isEncrypted = 'true') then .//sfhashv:ContentEncodedHashVerification or ..//sfhashv:ContentDecodedHashVerification else ..//sfhashv:ContentDecodedHashVerification">
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [BASE-TDF-ID-00023][Warning] If a TDO contains a cryptographic binding for a reference value payload, 
            it should also contain the hash to verify that binding. 
            If the reference value payload is encrypted, then the hash can be the encoded and/or decoded hash. 
            If the reference value payload is not encrypted, then the hash is expected to be the decoded hash. 
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

   <!--PATTERN BASE-TDF-ID-00024-->


	<!--RULE BASE-TDF-ID-00024-R1-->
<xsl:template match="tdf:Assertion[.//tdf:Binding and .//tdf:ReferenceStatement]"
                 priority="1000"
                 mode="M30">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:Assertion[.//tdf:Binding and .//tdf:ReferenceStatement]"
                       id="BASE-TDF-ID-00024-R1"/>

		    <!--ASSERT warning-->
<xsl:choose>
         <xsl:when test="if (.//*/@tdf:isEncrypted and .//*/@tdf:isEncrypted = 'true')              then .//sfhashv:ContentEncodedHashVerification or ..//sfhashv:ContentDecodedHashVerification              else ..//sfhashv:ContentDecodedHashVerification"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="if (.//*/@tdf:isEncrypted and .//*/@tdf:isEncrypted = 'true') then .//sfhashv:ContentEncodedHashVerification or ..//sfhashv:ContentDecodedHashVerification else ..//sfhashv:ContentDecodedHashVerification">
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [BASE-TDF-ID-00024][Warning]  If a TDF assertion contains a cryptographic binding for a reference statement, 
            it should also contain the hash to verify that binding. 
            If the reference statement is encrypted, then the hash can be the encoded and/or decoded hash. 
            If the reference statement is not encrypted, then the hash is expected to be the decoded hash. 
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
</xsl:stylesheet>
<!--UNCLASSIFIED-->
