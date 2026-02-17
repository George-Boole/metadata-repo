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
         <svrl:text> This is the root file for the IC-TDF Schematron rule set. It loads all of
        the required CVEs, declares some global variables, and includes all of the Rule .sch files. </svrl:text>
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
            <xsl:attribute name="id">IC-TDF-ID-00001</xsl:attribute>
            <xsl:attribute name="name">IC-TDF-ID-00001</xsl:attribute>
            <svrl:text>
        [IC-TDF-ID-00001][Error] All attributes in the TDF namespace MUST contain a non-whitespace value.
        
        Human Readable: All attributes in the TDF namespace must specify a value.
    </svrl:text>
            <svrl:text>
        For all attributes in the tdf namespace, this rule ensures that each contains a non-whitespace value.
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M12"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-TDF-ID-00002</xsl:attribute>
            <xsl:attribute name="name">IC-TDF-ID-00002</xsl:attribute>
            <svrl:text>
        [IC-TDF-ID-00002][Error] If the root element is TrustedDataObject, then it
        must specify attribute version.
        
        Human Readable: If TrustedDataObject is the root element, then it must declare a TDF version to which it complies.  
    </svrl:text>
            <svrl:text>
        For a tdf:TrustedDataObject element that is a root element, this rule ensures that it specifies attribute tdf:version.
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M13"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-TDF-ID-00003</xsl:attribute>
            <xsl:attribute name="name">IC-TDF-ID-00003</xsl:attribute>
            <svrl:text>
    	[IC-TDF-ID-00003][Error] For element TrustedDataObject, there must be 
    	at least one element HandlingAssertion which specifies attribute scope
    	containing [PAYL].
    	
    	Human Readable: There must exist at least one handling marking for the payload.
    </svrl:text>
            <svrl:text>
    	For each TrustedDataObject, this rule ensures that the count of HandlingAssertion
        element which specify attribute scope containing [PAYL] is greater than or equal to 1.
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M14"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-TDF-ID-00004</xsl:attribute>
            <xsl:attribute name="name">IC-TDF-ID-00004</xsl:attribute>
            <svrl:text> [IC-TDF-ID-00004][Error] For element TrustedDataObject, there must be
		exactly one element HandlingAssertion that specifies attribute scope containing [TDO] and
		contains an EDH element.
		
		Human Readable: There must exist a single EDH HandlingAssertion scoped for the entire TrustedDataObject.</svrl:text>
            <svrl:text>For element TrustedDataObject, this rule ensures that the count of
		HandlingAssertion elements that specify attribute scope containing [TDO] and have
		child::tdf:HandlingStatement/edh:Edh is exactly 1.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M15"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-TDF-ID-00005</xsl:attribute>
            <xsl:attribute name="name">IC-TDF-ID-00005</xsl:attribute>
            <svrl:text>[IC-TDF-ID-00005][Error] For element TrustedDataCollection, there must
		be exactly one element HandlingAssertion that specifies @scope="TDC" and contains an EDH
		element. Human Readable: There must exist a single EDH HandlingAssertion scoped for the entire
		TrustedDataCollection.</svrl:text>
            <svrl:text>For element TrustedDataCollection, this rule ensures that the count of
		HandlingAssertion elements that specify attribute scope containing [TDC] and contain an EDH
		element is exactly 1.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M16"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-TDF-ID-00006</xsl:attribute>
            <xsl:attribute name="name">IC-TDF-ID-00006</xsl:attribute>
            <svrl:text>
    	[IC-TDF-ID-00006][Error] For any child element of TrustedDataObject, the
    	only allowable tokens for attribute scope are [PAYL], [TDO], or [EXPLICIT]. 
    	
    	Human Readable: Scopes defined within a TrustedDataObject must refer to
    	the payload, the entire TrustedDataObject, the combination of the payload 
    	and the entire TrustedDataObject, or be explicitly defined.
    </svrl:text>
            <svrl:text>
		For the scope attribute specified on any child element of TrustedDataObject,
		this rule ensures that the value only contains the tokens [PAYL], [TDO], or [EXPLICIT].
	</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M17"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-TDF-ID-00007</xsl:attribute>
            <xsl:attribute name="name">IC-TDF-ID-00007</xsl:attribute>
            <svrl:text>
    	[IC-TDF-ID-00007][Error] For any child assertion of TrustedDataCollection, 
    	the only allowable tokens for attribute scope are [TDC], [DESC_PAYL], [DESC_TDO], [TDC_MEMBER], or [EXPLICIT].
    	
    	Human Readable: Scopes defined within a TrustedDataCollection must refer
    	to the descendent TDOs (the list of TDOs), the descendent Payloads, a TDC Member, the entire TrustedDataCollection, or
    	be explicitly defined.
    </svrl:text>
            <svrl:text>
		For the scope attribute specified on any child element of TrustedDataCollection,
		this rule ensures that the value only contains the tokens [TDC], [DESC_PAYL], [DESC_TDO], [TDC_MEMBER], or [EXPLICIT].
	</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M18"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-TDF-ID-00008</xsl:attribute>
            <xsl:attribute name="name">IC-TDF-ID-00008</xsl:attribute>
            <svrl:text>
    	[IC-TDF-ID-00008][Error] The use of EXPLICIT scope is not currently allowed.
    	Key questions regarding the functionality of Binding within EXPLICIT scope
    	are still being defined. The rest of the rules/structure relating to
    	EXPLICIT scope are included in the spec to give the community an idea of
    	how these rules/structures will be defined.
    	
    	If there is a use-case which requires EXPLICIT scope, please send an 
    	email to ic-standards-support@iarpa.gov so that the use-case can be incorporated while defining the behavior of EXPLICIT scope.
    	
    </svrl:text>
            <svrl:text>
		For any element which specifies attribute scope containing [EXPLICIT],
		we instantly fail because EXPLICIT scope is currently not supported.
	</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M19"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-TDF-ID-00009</xsl:attribute>
            <xsl:attribute name="name">IC-TDF-ID-00009</xsl:attribute>
            <svrl:text>
    	[IC-TDF-ID-00009][Error] For element Binding, if element BoundValueList 
    	is specified, then element SignatureValue must not specify attribute
    	includesStatementMetadata.
    	
    	Human Readable: If BoundValueList is present, then it will explicitly 
    	specify includesStatementMetadata for each BoundValue and therefore
    	attribute includesStatementMetadata on the SignatureValue is not applicable.
    </svrl:text>
            <svrl:text>
	  	For element Binding which specifies BoundValueList, this rule ensures that
		element SignatureValue does not specify attribute includesStatementMetadata.
	</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M20"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-TDF-ID-00010</xsl:attribute>
            <xsl:attribute name="name">IC-TDF-ID-00010</xsl:attribute>
            <svrl:text>
    	[IC-TDF-ID-00010][Error] For element Binding, if element BoundValueList is
    	not specified, then element SignatureValue must specify attribute
    	includesStatementMetadata.
    	
    	Human Readable: If BoundValueList is not present, then SignatureValue
    	must indicate whether or not to include the StatementMetadata of all
    	Assertions included in the binding.
    </svrl:text>
            <svrl:text>
	  	For element Binding that does not have child element BoundValueList, this rule ensures that child element SignatureValue specifies attribute
		includesStatementMetadata.
	</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M21"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-TDF-ID-00011</xsl:attribute>
            <xsl:attribute name="name">IC-TDF-ID-00011</xsl:attribute>
            <svrl:text>
    	[IC-TDF-ID-00011][Error] For all BoundValue or Reference elements within a TrustedDataObject, idRef attribute 
    	values must reference the id value of a descendant of the same TrustedDataObject that 
    	contains the Reference or BoundValue element.
    	
    	Human Readable: Assertions and HandlingAssertions within a
    	TrustedDataObject must reference elements local to that TrustedDataObject. 
    </svrl:text>
            <svrl:text>
	  	For element TrustedDataObject, this rule ensures each attribute @idRef value has 
		matching @id value in the same TDO.
	</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M22"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-TDF-ID-00012</xsl:attribute>
            <xsl:attribute name="name">IC-TDF-ID-00012</xsl:attribute>
            <svrl:text>
    	[IC-TDF-ID-00012][Error] For any element which specifies attribute scope 
    	containing [EXPLICIT], then element Binding/BoundValueList or 
    	element ReferenceList must be specified.
    	
    	Human Readable: For explicit scope, you must use a BoundValueList or 
    	a ReferenceList to explicitly reference elements are in scope. 
    </svrl:text>
            <svrl:text>
		For elements which specify attribute scope with a value of [EXPLICIT],
		this rule ensures that element Binding/BoundValueList or ReferenceList
		is specified.
	</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M23"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-TDF-ID-00013</xsl:attribute>
            <xsl:attribute name="name">IC-TDF-ID-00013</xsl:attribute>
            <svrl:text>
    	[IC-TDF-ID-00013][Error] Elements ReferenceList and BoundValueList are
    	currently not allowed. Key questions regarding the functionality of
    	granular references and granular binding are still being defined. The 
    	rest of the rules/structure relating to these elements are included in
    	the spec to give the community an idea of how these rules/structures 
    	will be defined.
    	
    	If there is a use-case which requires granular references or granular
    	binding, please send an email to ic-standards-support@iarpa.gov so that
    	the use-case can be incorporated while defining the behavior and rules.
    	
    </svrl:text>
            <svrl:text>
		Elements ReferenceList and BoundValueList are
		not allowed in v1.  This rule will in the future require that elements which specify element ReferenceList or Binding/BoundValueList
		have attribute scope is specified with a value of [EXPLICIT].
	</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M24"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-TDF-ID-00014</xsl:attribute>
            <xsl:attribute name="name">IC-TDF-ID-00014</xsl:attribute>
            <svrl:text>
    	[IC-TDF-ID-00014][Error] If EncryptionInformation is specified, then
    	the data it refers to must be labeled as encrypted. (Assertion Statement
    	or TrustedDataObject Payload).
    </svrl:text>
            <svrl:text>
		This rule ensures that the following sibling of EncryptionInformation, the
		Payload or Assertion Statement, has the encrypted attribute set to 
		true.
	</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M25"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-TDF-ID-00015</xsl:attribute>
            <xsl:attribute name="name">IC-TDF-ID-00015</xsl:attribute>
            <svrl:text>
    	[IC-TDF-ID-00015][Error] If data is labeled as encrypted, then
    	EncryptionInformation must be specified. (Assertion Statement
    	or TrustedDataObject Payload).
    	
    </svrl:text>
            <svrl:text>
		This rule ensures that the previous sibling of the Statement or Payload marked
		with the encrypted attribute set to true is EncryptionInformation.
	</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M26"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-TDF-ID-00016</xsl:attribute>
            <xsl:attribute name="name">IC-TDF-ID-00016</xsl:attribute>
            <svrl:text>[IC-TDF-ID-00016][Error] EDH HandlingAssertions with TDO
		scope must have an ARH security element has ism:resourceElement="true".
		
		Human Readable: An EDH HandlingAssertion with scope pertaining to the entire
		TrustedDataObject (TDO) must declare itself a resource level object.</svrl:text>
            <svrl:text>EDH HandlingAssertions with scope containing [TDO], ensure
		that its decendant ARH element, Security or ExternalSecurity, has ism:resourceElement="true".</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M27"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-TDF-ID-00017</xsl:attribute>
            <xsl:attribute name="name">IC-TDF-ID-00017</xsl:attribute>
            <svrl:text>
    	[IC-TDF-ID-00017][Error] EDH HandlingAssertions with scope containing
    	the token [TDC] must have an EDH whose ARH security element has
    	ism:resourceElement="true" specified.
    	
    	Human Readable: When a HandlingAssertion has scope pertaining to
    	the entire TrustedDataCollection (TDC) it must declare itself a resource level
    	object.
    </svrl:text>
            <svrl:text>
		Where an EDH HandlingAssertion exists with scope containing [TDC], this rule ensures that its decendant ARH element,
		Security or ExternalSecurity, has ism:resourceElement specified with a value of true.
	</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M28"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-TDF-ID-00018</xsl:attribute>
            <xsl:attribute name="name">IC-TDF-ID-00018</xsl:attribute>
            <svrl:text>
    	[IC-TDF-ID-00018][Error] HandlingAssertions with scope containing
    	the token [TDO] cannot use the ExternalEdh child element.
    	
    	Human Readable: When a HandlingAssertion has scope pertaining to
    	the entire TrustedDataObject (TDO), it must never use the
    	ExternalEdh child element because the HandlingAssertion will 
    	always refer to the object in which it resides.
    </svrl:text>
            <svrl:text>
		Where a HandlingAssertion exists with scope containing [TDO], this rule ensures that it does
		not have a child of ExternalEdh.
	</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M29"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-TDF-ID-00019</xsl:attribute>
            <xsl:attribute name="name">IC-TDF-ID-00019</xsl:attribute>
            <svrl:text>
    	[IC-TDF-ID-00019][Error] HandlingAssertions with scope containing
    	the token [TDC] cannot use the ExternalEdh child element.
    	
    	Human Readable: When a HandlingAssertion has scope pertaining to
    	the entire TrustedDataCollection (TDC), it must never use the
    	ExternalEdh child element because the HandlingAssertion will always
    	refer to the Collection in which it resides.
    </svrl:text>
            <svrl:text>
		Where a HandlingAssertion exists with scope containing [TDC], this rule ensures that it does
		not have a child of ExternalEdh.
	</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M30"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-TDF-ID-00033</xsl:attribute>
            <xsl:attribute name="name">IC-TDF-ID-00033</xsl:attribute>
            <svrl:text>
    	[IC-TDF-ID-00033][Error] A TrustedDataObject with a ReferencePayload must have an
    	ExternalEDH element in the HandlingAssertion with scope [PAYL].
    	    	
    </svrl:text>
            <svrl:text>
		For TrustedDataObject elements with a ReferencePayload, ensure that the HandlingAssertion
		with scope [PAYL] has an ExternalEDH element.
	</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M31"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-TDF-ID-00034</xsl:attribute>
            <xsl:attribute name="name">IC-TDF-ID-00034</xsl:attribute>
            <svrl:text>
    	[IC-TDF-ID-00034][Error] An Assertion with a ReferenceStatement must have an
    	ExternalEDH or ExternalSecurity element in the StatementMetadata.
    	
    </svrl:text>
            <svrl:text>
		For Assertion elements with a ReferenceStatement, ensure that the StatementMetadata
		has an ExternalEDH or ExternalSecurity element.
	</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M32"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-TDF-ID-00035</xsl:attribute>
            <xsl:attribute name="name">IC-TDF-ID-00035</xsl:attribute>
            <svrl:text>
    	[IC-TDF-ID-00035][Error] For any handling assertion child element of TrustedDataCollection, the
    	only allowable token for attribute scope is [TDC]. 
    	
    	Human Readable: Scopes defined within a TrustedDataCollection Handling Assertion must refer to
    	entire TrustedDataCollection.
    </svrl:text>
            <svrl:text>
		For the scope attribute specified on handlingAssertion child elements of TrustedDataCollection,
		we make sure that the value only contains the tokens [TDC].
	</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M33"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-TDF-ID-00036</xsl:attribute>
            <xsl:attribute name="name">IC-TDF-ID-00036</xsl:attribute>
            <svrl:text>
        [IC-TDF-ID-00036][Error] The @edh:DESVersion is less than the minimum version 
        allowed: 1. 
        
        Human Readable: The edh version imported by IC-TDF must be greater than or equal to 1. 
    </svrl:text>
            <svrl:text>
        For all elements that contain @edh:DESVersion, verify that the version
        is greater than or equal to the minimum allowed version: 1.  
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M34"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-TDF-ID-00037</xsl:attribute>
            <xsl:attribute name="name">IC-TDF-ID-00037</xsl:attribute>
            <svrl:text>
        [IC-TDF-ID-00037][Error] The @arh:DESVersion is less than the minimum version 
        allowed: 1. 
        
        Human Readable: The arh version imported by IC-TDF must be greater than or equal to 1. 
    </svrl:text>
            <svrl:text>
        For all elements that contain @arh:DESVersion, verify that the version
        is greater than or equal to the minimum allowed version: 1.  
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M35"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-TDF-ID-00038</xsl:attribute>
            <xsl:attribute name="name">IC-TDF-ID-00038</xsl:attribute>
            <svrl:text>
        [IC-TDF-ID-00038][Error] For the Binding element, every Signer element 
        must specify the issuer attribute and either the serial or subject 
        attribute.
        
       </svrl:text>
            <svrl:text>
        This rule checks that for each occurrence of tdf:Signer that @tdf:issuer 
        and either @tdf:subject or @tdf:serial is specified.
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M36"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-TDF-ID-00040</xsl:attribute>
            <xsl:attribute name="name">IC-TDF-ID-00040</xsl:attribute>
            <svrl:text>
        [IC-TDF-ID-00040][Error] If there are more than one EncryptionInformation elements
        specified in any one EncryptionInformation Group than @tdf:sequenceNum must also
        be specified.
        
       </svrl:text>
            <svrl:text>
        This rule checks that if there are more than one tdf:EncryptionInformation in any encryption
        group (if it has siblings) then it checks that a tdf:sequenceNum attribute is present on the 
        EncryptionInformation element.
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M37"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-TDF-ID-00041</xsl:attribute>
            <xsl:attribute name="name">IC-TDF-ID-00041</xsl:attribute>
            <svrl:text>
		[IC-TDF-ID-00041][Error] All sequenceNum attributes in an EncryptionInformation Group 
		must be sequential, incrementing by 1, starting with the number 1, and contain no duplicates.
        
       </svrl:text>
            <svrl:text>
    	This rule triggers on the first EncryptionInformation element for each EncryptionInformation Group 
    	that has more than 1 EncryptionInformation element then checks that the sequenceNum attributes
    	are numerically sequential by 1 starting from 1. A list, named $nums, is created containing the 
    	value of each sequenceNum attribute within the group. If the total number of items in $nums
    	does not equal the number of distinct values in $nums, then a duplicate exists return
    	false. Otherwise, ensure that each number from 1 to N, where N is the number of items 
    	in $nums, is contained within $nums. If each number is contained, then return true. 
    	Otherwise, false.
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M38"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-TDF-ID-00042</xsl:attribute>
            <xsl:attribute name="name">IC-TDF-ID-00042</xsl:attribute>
            <svrl:text>[IC-TDF-ID-00042][Error] The first HandlingAssertion of a
		TDF must have the attribute scope with a value of [TDO] or [TDC] and contain an EDH.</svrl:text>
            <svrl:text>This rule triggers on the first HandlingAssertion element for each
		TDF and tests that the value of the @tdf:scope attribute is set a value of [TDO] or [TDC] and that an EDH exists.
		Otherwise, an error is triggered. This prevents some other handling assertion such as Revision Recall from being the ISM resource node for the entire TDO.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M39"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-TDF-ID-00043</xsl:attribute>
            <xsl:attribute name="name">IC-TDF-ID-00043</xsl:attribute>
            <svrl:text>
	  	[IC-TDF-ID-00043][Error] ntk:Access elements on portions of a TDO must be rolled up
	  	to the resource level. As such there must be an ntk:Access on the HandlingAssertion
	  	with scope [TDO]. Precise rollup is left to the creator to determine.
	  	
	  	Human Readable: If there is an ntk:Access in any portion of a TDO, then there must
	  	be an ntk:Access in the HandlingAssertion with scope="TDO"
       </svrl:text>
            <svrl:text>
    	This rule triggers on any ntk:Access that exists except for one in the tdf:HandlingAssertion
    	with a scope [TDO]. If it triggers it checks that there is an ntk:Access in the 
    	HandlingAssertion with scope [TDO] otherwise it sets an error.
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M40"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-TDF-ID-00044</xsl:attribute>
            <xsl:attribute name="name">IC-TDF-ID-00044</xsl:attribute>
            <svrl:text>
	  	[IC-TDF-ID-00044][Error] ntk:Access elements on child TDOs or Assertions must be rolled up
	  	to the resource level. As such there must be an ntk:Access on the HandlingAssertion
	  	with scope [TDC]. Precise rollup is left to the creator to determine.
	  	
	  	Human Readable: If there is an ntk:Access in any portion of a TDC, then there must
	  	be an ntk:Access in the HandlingAssertion with scope="TDC"
       </svrl:text>
            <svrl:text>
    	This rule triggers on any ntk:Access that exists except for one in the tdf:HandlingAssertion
    	with a scope [TDC]. If it triggers it checks that there is an ntk:Access in the 
    	HandlingAssertion with scope [TDC] otherwise it sets an error.
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M41"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-TDF-ID-00045</xsl:attribute>
            <xsl:attribute name="name">IC-TDF-ID-00045</xsl:attribute>
            <svrl:text>
        [IC-TDF-ID-00045][Error] The @revrecall:DESVersion is less than the minimum version 
        allowed: 201412. 
        
        Human Readable: The RevRecall version imported by IC-TDF must be greater than or equal to 2014-DEC. 
    </svrl:text>
            <svrl:text>
        For all elements that contain @revrecall:DESVersion, ensure that the version
        is greater than or equal to the minimum allowed version: 201412.  
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M42"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-TDF-ID-00046</xsl:attribute>
            <xsl:attribute name="name">IC-TDF-ID-00046</xsl:attribute>
            <svrl:text>  
        For all ism:DESVersion attributes found on the TDF skeleton, ensure all the versions
        are the same. The TDF Skeleton includes the TDF elements themselves and descendents 
        of tdf:HandlingAssertion or tdf:StatementMetadata elements.
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M43"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-TDF-ID-00047</xsl:attribute>
            <xsl:attribute name="name">IC-TDF-ID-00047</xsl:attribute>
            <svrl:text>  
        For all ism:DESVersion attributes found on the TDF skeleton, ensure all the versions
        are the same. The TDF Skeleton includes the TDF elements themselves and descendents 
        of tdf:HandlingAssertion or tdf:StatementMetadata elements.
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M44"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-TDF-ID-00048</xsl:attribute>
            <xsl:attribute name="name">IC-TDF-ID-00048</xsl:attribute>
            <svrl:text>  
        For all ism:DESVersion attributes found on the TDF skeleton, ensure all the versions
        are the same. The TDF Skeleton includes the TDF elements themselves and descendents 
        of tdf:HandlingAssertion or tdf:StatementMetadata elements.
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M45"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-TDF-ID-00049</xsl:attribute>
            <xsl:attribute name="name">IC-TDF-ID-00049</xsl:attribute>
            <svrl:text>  
        For all ism:DESVersion attributes found on the TDF skeleton, ensure all the versions
        are the same. The TDF Skeleton includes the TDF elements themselves and descendents 
        of tdf:HandlingAssertion or tdf:StatementMetadata elements.
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M46"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-TDF-ID-00050</xsl:attribute>
            <xsl:attribute name="name">IC-TDF-ID-00050</xsl:attribute>
            <svrl:text>  
        For all ism:DESVersion attributes found on the TDF skeleton, ensure all the versions
        are the same. The TDF Skeleton includes the TDF elements themselves and descendents 
        of tdf:HandlingAssertion or tdf:StatementMetadata elements.
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M47"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-TDF-ID-00051</xsl:attribute>
            <xsl:attribute name="name">IC-TDF-ID-00051</xsl:attribute>
            <svrl:text>  
        For all ism:DESVersion attributes found on the TDF skeleton, ensure all the versions
        are the same. The TDF Skeleton includes the TDF elements themselves and descendents 
        of tdf:HandlingAssertion or tdf:StatementMetadata elements.
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M48"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-TDF-ID-00052</xsl:attribute>
            <xsl:attribute name="name">IC-TDF-ID-00052</xsl:attribute>
            <svrl:text>  
        For all ism:DESVersion attributes found on the TDF skeleton, ensure all the versions
        are the same. The TDF Skeleton includes the TDF elements themselves and descendents 
        of tdf:HandlingAssertion or tdf:StatementMetadata elements.
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M49"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-TDF-ID-00053</xsl:attribute>
            <xsl:attribute name="name">IC-TDF-ID-00053</xsl:attribute>
            <svrl:text>  
        For all ism:DESVersion attributes found on the TDF skeleton, ensure all the versions
        are the same. The TDF Skeleton includes the TDF elements themselves and descendents 
        of tdf:HandlingAssertion or tdf:StatementMetadata elements.
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M50"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-TDF-ID-00054</xsl:attribute>
            <xsl:attribute name="name">IC-TDF-ID-00054</xsl:attribute>
            <svrl:text>
        [IC-TDF-ID-00054][Warning] tdf:version attribute SHOULD be specified as version 201412.201707 with an optional extension.  
    </svrl:text>
            <svrl:text>
        This rule supports extending the version identifier with an optional trailing hypen
        and up to 23 additional characters. The version must match the regular expression
        “^201412.201707(-.{1,23})?$
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M51"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-TDF-ID-00055</xsl:attribute>
            <xsl:attribute name="name">IC-TDF-ID-00055</xsl:attribute>
            <svrl:text> [IC-TDF-ID-00055][Error] For element TrustedDataObject whose payload is NOT encrypted,
		there must not be more than one element HandlingAssertion that specifies attribute scope containing [PAYL] and
		contains an EDH element.
		
		Human Readable: For TrustedDataObjects with unencrypted payloads, there must not be more than a single 
		EDH HandlingAssertion scoped for the payload.</svrl:text>
            <svrl:text>For element TrustedDataObject whose payload is NOT encrypted, ensure that the count of
		HandlingAssertion elements that specify attribute scope containing [PAYL] and have
		child::tdf:HandlingStatement/edh:Edh is not more than 1.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M52"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-TDF-ID-00025</xsl:attribute>
            <xsl:attribute name="name">IC-TDF-ID-00025</xsl:attribute>
            <svrl:text>
    	[IC-TDF-ID-00025][Error] Attribute @appliesToState is only allowed when 
    	TDO payload attrbute @isEncrypted equals "true".
    	
    	Human Readable: Handling Statement state applicability can only be defined
    	when an encrypted payload is present.		
    </svrl:text>
            <svrl:text>
	  	If attribute @appliesToState is defined, this rule ensures that there is a payload element 
		with attribute isEncrypted set to true.
	</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M53"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-TDF-ID-00026</xsl:attribute>
            <xsl:attribute name="name">IC-TDF-ID-00026</xsl:attribute>
            <svrl:text>
		[IC-TDF-ID-00026][Error] If payload attribute @isEncrypted="true", then there needs to 
		be two handling assertions with attribute scope="PAYL": one with attribute 
		@appliesToState="encrypted" and the other with attribute appliesToState="unencrypted".
		
		Human Readable: Encrypted payloads require handling assertions for both encrypted and 
		unencrypted payload states. 
	</svrl:text>
            <svrl:text>
	  	If there exists a TDO payload element with attribute @isEncrypted as true, this rule ensures there
		is one handling assertion of @scope PAYL and @appliestostate of encrypted, and one handling 
		assertion of @scope PAYL and @appliestostate of unencrypted.
	</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M54"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-TDF-ID-00027</xsl:attribute>
            <xsl:attribute name="name">IC-TDF-ID-00027</xsl:attribute>
            <svrl:text>
		[IC-TDF-ID-00027][Error] If payload attribute @isEncrypted="true", the handling 
		assertion with @scope="PAYL" that contains @appliesToState="unencrypted"  must 
		contain an edh:externalEDH.
		
		Human Readable: When content is encrypted, the handling assertion describing 
		the content in an unencrypted state is in effect external.
	</svrl:text>
            <svrl:text>
	  	If there exists a TDO payload element with attribute @isEncrypted as true, this rule ensures that there
		is one handling assertion of @scope PAYL, @appliestostate of unencrypted, and has descendant 
		element ExternalEdh.
	</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M55"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-TDF-ID-00028</xsl:attribute>
            <xsl:attribute name="name">IC-TDF-ID-00028</xsl:attribute>
            <svrl:text>[IC-TDF-ID-00028][Error] If payload attribute @isEncrypted="true" and
		the payload is not external, the handling assertion with @scope="PAYL" that contains
		@appliesToState="encrypted" must contain a regular edh:EDH. Human Readable: Internal content
		requires an EDH.</svrl:text>
            <svrl:text>Given a TDO with an internal payload with attribute @isEncrypted="true",
		the handling assertion with @scope="PAYL" that contains @appliesToState="encrypted" must
		contain a regular edh:EDH.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M56"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-TDF-ID-00030</xsl:attribute>
            <xsl:attribute name="name">IC-TDF-ID-00030</xsl:attribute>
            <svrl:text> [IC-TDF-ID-00030][Error] If statement attribute @isEncrypted="true",
		the statement metadata that contains @appliesToState="unencrypted" must contain an
		arh:ExternalSecurity Human Readable: When statement content is encrypted, the handling statement
		describing the content in an unencrypted state is in effect external. </svrl:text>
            <svrl:text>Given a TDO with an encrypted assertion (statement attribute
		@isEncrypted="true"), the statement metadata that contains @appliesToState="unencrypted"
		must contain an arh:ExternalSecurity.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M57"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-TDF-ID-00031</xsl:attribute>
            <xsl:attribute name="name">IC-TDF-ID-00031</xsl:attribute>
            <svrl:text>[IC-TDF-ID-00031][Error] If assertion statement attribute
        @isEncrypted="true", then there needs to be two statement metadata elements: one with
        attribute @appliesToState="encrypted" and the other with attribute
        appliesToState="unencrypted". Human Readable: If an assertion statement is encrypted, it
        must have statement metadata to describe handling for both its encrypted state, and
        unencrypted state.</svrl:text>
            <svrl:text>If a TDO has an encrypted assertion (@isEncrypted="true"), then there needs
        to be two statement metadata elements: one with attribute @appliesToState="encrypted" and
        the other with attribute appliesToState="unencrypted".</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M58"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-TDF-ID-00032</xsl:attribute>
            <xsl:attribute name="name">IC-TDF-ID-00032</xsl:attribute>
            <svrl:text>
    	[IC-TDF-ID-00032][Error] Attribute @appliesToState is only allowed when 
    	TDO statement attribute @isEncrypted equals "true".
    	
    	Human Readable:  StatementMetadata state applicability can only be defined
    	when an encrypted statement is present.	  
    </svrl:text>
            <svrl:text>
	  	If attribute @appliesToState is defined, this rule ensures that there is a statement element 
		with attribute isEncrypted set to true.
	</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M59"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-TDF-ID-00039</xsl:attribute>
            <xsl:attribute name="name">IC-TDF-ID-00039</xsl:attribute>
            <svrl:text>
    	[IC-TDF-ID-00039][Error] Attribute @appliesToState is only allowed on HandlingAssertions with scope PAYL.
    	
    	Human Readable: Only Handling Assertions with scope PAYL can use the appliesToState attribute because
    	the attribute indicates the state (encrypted or unencrypted) of the payload to which the assertion appies.		
    </svrl:text>
            <svrl:text>
	  	If attribute @appliesToState is defined on a handlingAssertion, this rule ensures that handlingAssertion has scope PAYL
	</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M60"/>
      </svrl:schematron-output>
   </xsl:template>

   <!--SCHEMATRON PATTERNS-->


<!--PATTERN IC-TDF-ID-00001-->


	<!--RULE IC-TDF-ID-00001-R1-->
<xsl:template match="*[@tdf:*]" priority="1000" mode="M12">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[@tdf:*]"
                       id="IC-TDF-ID-00001-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="every $attribute in @tdf:* satisfies               normalize-space(string($attribute))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $attribute in @tdf:* satisfies normalize-space(string($attribute))">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [IC-TDF-ID-00001][Error] All attributes in the TDF namespace must specify a value.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M12"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M12"/>
   <xsl:template match="@*|node()" priority="-2" mode="M12">
      <xsl:apply-templates select="*" mode="M12"/>
   </xsl:template>

   <!--PATTERN IC-TDF-ID-00002-->


	<!--RULE IC-TDF-ID-00002-R1-->
<xsl:template match="/tdf:TrustedDataObject" priority="1000" mode="M13">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/tdf:TrustedDataObject"
                       id="IC-TDF-ID-00002-R1"/>

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
               <svrl:text>
            [IC-TDF-ID-00002][Error] If TrustedDataObject is the root element, then it must declare a TDF version to which it complies. 
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M13"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M13"/>
   <xsl:template match="@*|node()" priority="-2" mode="M13">
      <xsl:apply-templates select="*" mode="M13"/>
   </xsl:template>

   <!--PATTERN IC-TDF-ID-00003-->


	<!--RULE IC-TDF-ID-00003-R1-->
<xsl:template match="tdf:TrustedDataObject" priority="1000" mode="M14">
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
               <svrl:text>			
        	[IC-TDF-ID-00003][Error] For element TrustedDataObject, there must be 
        	at least one element HandlingAssertion which specifies attribute scope
        	containing [PAYL].
        	
        	Human Readable: There must exist at least one handling marking for the payload.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M14"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M14"/>
   <xsl:template match="@*|node()" priority="-2" mode="M14">
      <xsl:apply-templates select="*" mode="M14"/>
   </xsl:template>

   <!--PATTERN IC-TDF-ID-00004-->


	<!--RULE IC-TDF-ID-00004-R1-->
<xsl:template match="tdf:TrustedDataObject" priority="1000" mode="M15">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:TrustedDataObject"
                       id="IC-TDF-ID-00004-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="count(child::tdf:HandlingAssertion[child::tdf:HandlingStatement/edh:Edh and    @tdf:scope = 'TDO'])= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(child::tdf:HandlingAssertion[child::tdf:HandlingStatement/edh:Edh and @tdf:scope = 'TDO'])= 1">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IC-TDF-ID-00004][Error] For element TrustedDataObject, there must be
			exactly one element HandlingAssertion that specifies attribute scope containing [TDO] and
			contains an EDH element.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M15"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M15"/>
   <xsl:template match="@*|node()" priority="-2" mode="M15">
      <xsl:apply-templates select="*" mode="M15"/>
   </xsl:template>

   <!--PATTERN IC-TDF-ID-00005-->


	<!--RULE IC-TDF-ID-00005-R1-->
<xsl:template match="tdf:TrustedDataCollection" priority="1000" mode="M16">
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
               <svrl:text> [IC-TDF-ID-00005][Error] For element TrustedDataCollection, there must
			be exactly one element HandlingAssertion that specifies @scope="TDC" and contains an EDH
			element. Human Readable: There must exist a single EDH HandlingAssertion scoped for the entire
			TrustedDataCollection. </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M16"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M16"/>
   <xsl:template match="@*|node()" priority="-2" mode="M16">
      <xsl:apply-templates select="*" mode="M16"/>
   </xsl:template>

   <!--PATTERN IC-TDF-ID-00006-->


	<!--RULE IC-TDF-ID-00006-R1-->
<xsl:template match="tdf:TrustedDataObject/*[@tdf:scope]"
                 priority="1000"
                 mode="M17">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:TrustedDataObject/*[@tdf:scope]"
                       id="IC-TDF-ID-00006-R1"/>

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
               <svrl:text>			
			[IC-TDF-ID-00006][Error] For any child element of TrustedDataObject, the
			only allowable tokens for attribute scope are [PAYL], [TDO], or [EXPLICIT]. 
			
			Human Readable: Scopes defined within a TrustedDataObject must refer to
			the payload, the entire TrustedDataObject, the combination of the payload 
			and the entire TrustedDataObject, or be explicitly defined.
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

   <!--PATTERN IC-TDF-ID-00007-->


	<!--RULE IC-TDF-ID-00007-R1-->
<xsl:template match="tdf:TrustedDataCollection/*[@tdf:scope]"
                 priority="1000"
                 mode="M18">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:TrustedDataCollection/*[@tdf:scope]"
                       id="IC-TDF-ID-00007-R1"/>

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
               <svrl:text>
			[IC-TDF-ID-00007][Error] For any child element of TrustedDataCollection, 
			the only allowable tokens for attribute scope are [TDC], [DESC_PAYL], [DESC_TDO], [TDC_MEMBER], or [EXPLICIT].
			
			
			Human Readable: Scopes defined within a TrustedDataCollection must refer
			to the descendent TDOs (the list of TDOs), the descendent Payloads, a TDC Member, the entire TrustedDataCollection, or
			be explicitly defined.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M18"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M18"/>
   <xsl:template match="@*|node()" priority="-2" mode="M18">
      <xsl:apply-templates select="*" mode="M18"/>
   </xsl:template>

   <!--PATTERN IC-TDF-ID-00008-->


	<!--RULE IC-TDF-ID-00008-R1-->
<xsl:template match="*[util:containsAnyOfTheTokens(@tdf:scope, ('EXPLICIT'))]"
                 priority="1000"
                 mode="M19">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[util:containsAnyOfTheTokens(@tdf:scope, ('EXPLICIT'))]"
                       id="IC-TDF-ID-00008-R1"/>

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
               <svrl:text>
			[IC-TDF-ID-00008][Error] The use of EXPLICIT scope is not currently allowed.
			Key questions regarding the functionality of Binding within EXPLICIT scope
			are still being defined. The rest of the rules/structure relating to
			EXPLICIT scope are included in the spec to give the community an idea of
			how these rules/structures will be defined.
			
			If there is a use-case which requires EXPLICIT scope, please send an 
			email to ic-standards-support@iarpa.gov so that the use-case can be incorporated while defining the behavior of EXPLICIT scope.
			
		</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M19"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M19"/>
   <xsl:template match="@*|node()" priority="-2" mode="M19">
      <xsl:apply-templates select="*" mode="M19"/>
   </xsl:template>

   <!--PATTERN IC-TDF-ID-00009-->


	<!--RULE IC-TDF-ID-00009-R1-->
<xsl:template match="tdf:Binding[tdf:BoundValueList]" priority="1000" mode="M20">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:Binding[tdf:BoundValueList]"
                       id="IC-TDF-ID-00009-R1"/>

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
               <svrl:text>
        	[IC-TDF-ID-00009][Error] For element Binding, if element BoundValueList 
        	is specified, then element SignatureValue must not specify attribute
        	includesStatementMetadata.
        	
        	Human Readable: If BoundValueList is present, then it will explicitly 
        	specify includesStatementMetadata for each BoundValue and therefore
        	attribute includesStatementMetadata on the SignatureValue is not applicable.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M20"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M20"/>
   <xsl:template match="@*|node()" priority="-2" mode="M20">
      <xsl:apply-templates select="*" mode="M20"/>
   </xsl:template>

   <!--PATTERN IC-TDF-ID-00010-->


	<!--RULE IC-TDF-ID-00010-R1-->
<xsl:template match="tdf:Binding[not(tdf:BoundValueList)]"
                 priority="1000"
                 mode="M21">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:Binding[not(tdf:BoundValueList)]"
                       id="IC-TDF-ID-00010-R1"/>

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
               <svrl:text>
        	[IC-TDF-ID-00010][Error] For element Binding, if element BoundValueList is
        	not specified, then element SignatureValue must specify attribute
        	includesStatementMetadata.
        	
        	Human Readable: If BoundValueList is not present, then SignatureValue
        	must indicate whether or not to include the StatementMetadata of all
        	Assertions included in the binding.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M21"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M21"/>
   <xsl:template match="@*|node()" priority="-2" mode="M21">
      <xsl:apply-templates select="*" mode="M21"/>
   </xsl:template>

   <!--PATTERN IC-TDF-ID-00011-->


	<!--RULE IC-TDF-ID-00011-R1-->
<xsl:template match="tdf:TrustedDataObject" priority="1000" mode="M22">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:TrustedDataObject"
                       id="IC-TDF-ID-00011-R1"/>
      <xsl:variable name="ids" select=".//@tdf:id"/>
      <xsl:variable name="externalIdRefs"
                    select="       for $idRef in .//@tdf:idRef return        if($idRef = $ids)        then null        else $idRef"/>

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
               <svrl:text>
        	[IC-TDF-ID-00011][Error] For all BoundValue or Reference elements within a TrustedDataObject, idRef attribute 
        	values must reference the id value of a descendant of the same TrustedDataObject that 
        	contains the Reference or BoundValue element.
        	
        	
        	Human Readable: Assertions and HandlingAssertions within a
        	TrustedDataObject must reference elements local to that TrustedDataObject.
        	
        	The following idRefs reference elements outside of this TrustedDataObject: (
        	<xsl:text/>
                  <xsl:value-of select="for $externalRef in $externalIdRefs return concat(string($externalRef), ', ')"/>
                  <xsl:text/>).
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

   <!--PATTERN IC-TDF-ID-00012-->


	<!--RULE IC-TDF-ID-00012-R1-->
<xsl:template match="*[normalize-space(string(@tdf:scope)) = 'EXPLICIT']"
                 priority="1000"
                 mode="M23">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[normalize-space(string(@tdf:scope)) = 'EXPLICIT']"
                       id="IC-TDF-ID-00012-R1"/>

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
               <svrl:text>
        	[IC-TDF-ID-00012][Error] For any element which specifies attribute scope 
        	containing [EXPLICIT], then element Binding/BoundValueList or 
        	element ReferenceList must be specified.
        	
        	Human Readable: For explicit scope, you must use a BoundValueList or 
        	a ReferenceList to explicitly reference elements are in scope. 
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

   <!--PATTERN IC-TDF-ID-00013-->


	<!--RULE IC-TDF-ID-00013-R1-->
<xsl:template match="tdf:ReferenceList | tdf:Binding/tdf:BoundValueList"
                 priority="1000"
                 mode="M24">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:ReferenceList | tdf:Binding/tdf:BoundValueList"
                       id="IC-TDF-ID-00013-R1"/>

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
               <svrl:text>
			[IC-TDF-ID-00013][Error] Elements ReferenceList and BoundValueList are
			currently not allowed. Key questions regarding the functionality of
			granular references and granular binding are still being defined. The 
			rest of the rules/structure relating to these elements are included in
			the spec to give the community an idea of how these rules/structures 
			will be defined.
			
			If there is a use-case which requires granular references or granular
			binding, please send an email to ic-standards-support@iarpa.gov so that
			the use-case can be incorporated while defining the behavior and rules.
			
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

   <!--PATTERN IC-TDF-ID-00014-->


	<!--RULE IC-TDF-ID-00014-R1-->
<xsl:template match="tdf:EncryptionInformation[parent::tdf:Assertion] | tdf:EncryptionInformation[parent::tdf:TrustedDataObject]"
                 priority="1000"
                 mode="M25">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:EncryptionInformation[parent::tdf:Assertion] | tdf:EncryptionInformation[parent::tdf:TrustedDataObject]"
                       id="IC-TDF-ID-00014-R1"/>

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
               <svrl:text>
			[IC-TDF-ID-00014][Error] If EncryptionInformation is specified, then
			the data it refers to must be labeled as encrypted. (Assertion Statement
			or TrustedDataObject Payload).
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

   <!--PATTERN IC-TDF-ID-00015-->


	<!--RULE IC-TDF-ID-00015-R1-->
<xsl:template match="tdf:*[@tdf:isEncrypted=true()]" priority="1000" mode="M26">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:*[@tdf:isEncrypted=true()]"
                       id="IC-TDF-ID-00015-R1"/>

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
               <svrl:text>
			[IC-TDF-ID-00015][Error] If data is labeled as encrypted, then
			EncryptionInformation must be specified. (Assertion Statement
			or TrustedDataObject Payload).
			
		</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M26"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M26"/>
   <xsl:template match="@*|node()" priority="-2" mode="M26">
      <xsl:apply-templates select="*" mode="M26"/>
   </xsl:template>

   <!--PATTERN IC-TDF-ID-00016-->


	<!--RULE IC-TDF-ID-00016-R1-->
<xsl:template match="tdf:HandlingAssertion[child::tdf:HandlingStatement/edh:Edh and util:containsAnyOfTheTokens(@tdf:scope, ('TDO'))]"
                 priority="1000"
                 mode="M27">
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
               <svrl:text>[IC-TDF-ID-00016][Error] HandlingAssertions with scope containing the token [TDO] must
			have an EDH whose ARH security element has ism:resourceElement="true" specified.
			
			Human Readable: An EDH HandlingAssertion with scope pertaining to the entire
			TrustedDataObject (TDO) must declare itself a resource level object.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M27"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M27"/>
   <xsl:template match="@*|node()" priority="-2" mode="M27">
      <xsl:apply-templates select="*" mode="M27"/>
   </xsl:template>

   <!--PATTERN IC-TDF-ID-00017-->


	<!--RULE IC-TDF-ID-00017-R1-->
<xsl:template match="tdf:HandlingAssertion[child::tdf:HandlingStatement/edh:Edh and util:containsAnyOfTheTokens(@tdf:scope, ('TDC'))]"
                 priority="1000"
                 mode="M28">
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
               <svrl:text>
		    	[IC-TDF-ID-00017][Error] HandlingAssertions with scope containing the token [TDC] must
		    	have an EDH whose ARH security element has ism:resourceElement="true" specified.
			
			Human Readable: When a HandlingAssertion has scope pertaining to
			the entire TrustedDataCollection (TDC) it must declare itself a resource level
			object.
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

   <!--PATTERN IC-TDF-ID-00018-->


	<!--RULE IC-TDF-ID-00018-R1-->
<xsl:template match="tdf:HandlingAssertion[util:containsAnyOfTheTokens(@tdf:scope, ('TDO'))]"
                 priority="1000"
                 mode="M29">
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
               <svrl:text>
			[IC-TDF-ID-00018][Error] HandlingAssertions with scope containing
			the token [TDO] cannot use the ExternalEdh child element.
			
			Human Readable: When a HandlingAssertion has scope pertaining to
			the entire TrustedDataObject (TDO), it must never use the
			ExternalEdh child element because the HandlingAssertion will 
			always refer to the object in which it resides.
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

   <!--PATTERN IC-TDF-ID-00019-->


	<!--RULE IC-TDF-ID-00019-R1-->
<xsl:template match="tdf:HandlingAssertion[util:containsAnyOfTheTokens(@tdf:scope, ('TDC'))]"
                 priority="1000"
                 mode="M30">
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
               <svrl:text>
			[IC-TDF-ID-00019][Error] HandlingAssertions with scope containing
			the token [TDC] cannot use the ExternalEdh child element.
			
			Human Readable: When a HandlingAssertion has scope pertaining to
			the entire TrustedDataCollection (TDC), it must never use the
			ExternalEdh child element because the HandlingAssertion will always
			refer to the Collection in which it resides.
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

   <!--PATTERN IC-TDF-ID-00033-->


	<!--RULE IC-TDF-ID-00033-R1-->
<xsl:template match="tdf:TrustedDataObject//tdf:ReferenceValuePayload"
                 priority="1000"
                 mode="M31">
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
               <svrl:text>
			[IC-TDF-ID-00033][Error] A TrustedDataObject with a ReferencePayload must have an
			ExternalEDH element in the HandlingAssertion with scope [PAYL].
			
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

   <!--PATTERN IC-TDF-ID-00034-->


	<!--RULE IC-TDF-ID-00034-R1-->
<xsl:template match="tdf:Assertion//tdf:ReferenceStatement"
                 priority="1000"
                 mode="M32">
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
               <svrl:text>
			[IC-TDF-ID-00034][Error] An Assertion with a ReferenceStatement must have an
			ExternalEDH or ExternalSecurity element in the StatementMetadata.
			
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

   <!--PATTERN IC-TDF-ID-00035-->


	<!--RULE IC-TDF-ID-00035-R1-->
<xsl:template match="tdf:TrustedDataCollection/tdf:HandlingAssertion"
                 priority="1000"
                 mode="M33">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:TrustedDataCollection/tdf:HandlingAssertion"
                       id="IC-TDF-ID-00035-R1"/>

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
               <svrl:text>			
			[IC-TDF-ID-00035][Error] For any child handlingAssertion of TrustedDataCollection, the
			only allowable tokens for attribute scope is [TDC]. 
			
			Human Readable: Scopes defined within a TrustedDataCollection Handling Assertion must refer to
			entire TrustedDataCollection.
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

   <!--PATTERN IC-TDF-ID-00036-->


	<!--RULE IC-TDF-ID-00036-R1-->
<xsl:template match="*[@edh:DESVersion]" priority="1000" mode="M34">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[@edh:DESVersion]"
                       id="IC-TDF-ID-00036-R1"/>
      <xsl:variable name="version"
                    select="number(if (contains(@edh:DESVersion,'-')) then substring-before(@edh:DESVersion,'-') else @edh:DESVersion)"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="$version &gt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="$version &gt;= 1">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [IC-TDF-ID-00036][Error] The @edh:DESVersion is less than the minimum version 
            allowed: 1. 
            
            Human Readable: The edh version imported by IC-TDF must be greater than or equal to 1.
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

   <!--PATTERN IC-TDF-ID-00037-->


	<!--RULE IC-TDF-ID-00037-R1-->
<xsl:template match="*[@arh:DESVersion]" priority="1000" mode="M35">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[@arh:DESVersion]"
                       id="IC-TDF-ID-00037-R1"/>
      <xsl:variable name="version"
                    select="number(if (contains(@arh:DESVersion,'-')) then substring-before(@arh:DESVersion,'-') else @arh:DESVersion)"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="$version &gt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="$version &gt;= 1">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [IC-TDF-ID-00037][Error] The @arh:DESVersion is less than the minimum version 
            allowed: 1. 
            
            Human Readable: The arh version imported by IC-TDF must be greater than or equal to 1. 
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

   <!--PATTERN IC-TDF-ID-00038-->


	<!--RULE IC-TDF-ID-00038-R1-->
<xsl:template match="tdf:Binding/tdf:Signer" priority="1000" mode="M36">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:Binding/tdf:Signer"
                       id="IC-TDF-ID-00038-R1"/>

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
               <svrl:text>
			[IC-TDF-ID-00038][Error] For the Binding element, every Signer element 
			must specify the issuer attribute and either the serial or subject
			attribute.
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

   <!--PATTERN IC-TDF-ID-00040-->


	<!--RULE IC-TDF-ID-00040-R1-->
<xsl:template match="tdf:EncryptionInformation[count((preceding-sibling::tdf:EncryptionInformation, following-sibling::tdf:EncryptionInformation))&gt;0]"
                 priority="1000"
                 mode="M37">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:EncryptionInformation[count((preceding-sibling::tdf:EncryptionInformation, following-sibling::tdf:EncryptionInformation))&gt;0]"
                       id="IC-TDF-ID-00040-R1"/>

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
               <svrl:text>
			[IC-TDF-ID-00040][Error] If there are more than one EncryptionInformation elements
			specified in any one EncryptionInformation Group than @tdf:sequenceNum must also
			be specified.
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

   <!--PATTERN IC-TDF-ID-00041-->


	<!--RULE IC-TDF-ID-00041-R1-->
<xsl:template match="tdf:EncryptionInformation[count(following-sibling::tdf:EncryptionInformation)&gt;0][1]"
                 priority="1000"
                 mode="M38">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:EncryptionInformation[count(following-sibling::tdf:EncryptionInformation)&gt;0][1]"
                       id="IC-TDF-ID-00041-R1"/>
      <xsl:variable name="nums"
                    select="for $encInfo in (., following-sibling::tdf:EncryptionInformation) return number($encInfo/@tdf:sequenceNum)"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="(count(distinct-values($nums)) = count($nums)      and (every $index in 1 to count($nums)         satisfies index-of($nums, $index)))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="(count(distinct-values($nums)) = count($nums) and (every $index in 1 to count($nums) satisfies index-of($nums, $index)))">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
			[IC-TDF-ID-00041][Error] All sequenceNum attributes in an EncryptionInformation Group 
			must be sequential, incrementing by 1, starting with the number 1, and contain no duplicates.
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

   <!--PATTERN IC-TDF-ID-00042-->


	<!--RULE IC-TDF-ID-00042-R1-->
<xsl:template match="tdf:*/tdf:HandlingAssertion[1]" priority="1000" mode="M39">
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
               <svrl:text>[IC-TDF-ID-00042][Error] The first
			HandlingAssertion of a TDF must have the attribute scope with a value of
			[TDO] or [TDC] and contain an EDH.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M39"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M39"/>
   <xsl:template match="@*|node()" priority="-2" mode="M39">
      <xsl:apply-templates select="*" mode="M39"/>
   </xsl:template>

   <!--PATTERN IC-TDF-ID-00043-->


	<!--RULE IC-TDF-ID-00043-R1-->
<xsl:template match="tdf:TrustedDataObject//ntk:Access[not(ancestor::tdf:HandlingAssertion[@tdf:scope='TDO'] or @ntk:externalReference=true())]"
                 priority="1000"
                 mode="M40">
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
               <svrl:text>
			[IC-TDF-ID-00043][Error] If there is an ntk:Access in any portion of a TDO, then there must
			be an ntk:Access in the HandlingAssertion with scope="TDO"
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

   <!--PATTERN IC-TDF-ID-00044-->


	<!--RULE IC-TDF-ID-00044-R1-->
<xsl:template match="tdf:TrustedDataCollection//ntk:Access[not(ancestor::tdf:HandlingAssertion[@tdf:scope='TDC'] or @ntk:externalReference=true())]"
                 priority="1000"
                 mode="M41">
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
               <svrl:text>
	  		[IC-TDF-ID-00044][Error] If there is an ntk:Access in any portion of a TDC, then there must
	  		be an ntk:Access in the HandlingAssertion with scope="TDC"
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

   <!--PATTERN IC-TDF-ID-00045-->


	<!--RULE IC-TDF-ID-00045-R1-->
<xsl:template match="*[@revrecall:DESVersion]" priority="1000" mode="M42">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[@revrecall:DESVersion]"
                       id="IC-TDF-ID-00045-R1"/>
      <xsl:variable name="version"
                    select="number(if (contains(@revrecall:DESVersion,'-')) then substring-before(@revrecall:DESVersion,'-') else @revrecall:DESVersion)"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="$version &gt;= 201412"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="$version &gt;= 201412">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [IC-TDF-ID-00045][Error] The @revrecall:DESVersion is less than the minimum version 
            allowed: 201412. 
            
            Human Readable: The RevRecall version imported by IC-TDF must be greater than or equal to 2014-DEC.
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

   <!--PATTERN IC-TDF-ID-00046-->


	<!--RULE CompareVersionsInSkeleton-R1-->
<xsl:template match="//tdf:*[@ism:DESVersion]                                      | //tdf:HandlingAssertion//*[@ism:DESVersion]                                      | //tdf:StatementMetdata//*[@ism:DESVersion]"
                 priority="1000"
                 mode="M43">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//tdf:*[@ism:DESVersion]                                      | //tdf:HandlingAssertion//*[@ism:DESVersion]                                      | //tdf:StatementMetdata//*[@ism:DESVersion]"
                       id="CompareVersionsInSkeleton-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="every $ver in               (//tdf:*/@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:ism']              | //tdf:HandlingAssertion//@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:ism']              | //tdf:StatementMetadata//@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:ism'])              satisfies (number(if (contains($ver,'-')) then substring-before($ver,'-') else $ver))=(number(if (contains(@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:ism'],'-')) then substring-before(@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:ism'],'-') else @*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:ism']))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $ver in (//tdf:*/@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:ism'] | //tdf:HandlingAssertion//@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:ism'] | //tdf:StatementMetadata//@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:ism']) satisfies (number(if (contains($ver,'-')) then substring-before($ver,'-') else $ver))=(number(if (contains(@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:ism'],'-')) then substring-before(@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:ism'],'-') else @*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:ism']))">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [<xsl:text/>
                  <xsl:value-of select="'IC-TDF-ID-00046'"/>
                  <xsl:text/>][Error] 
            The {<xsl:text/>
                  <xsl:value-of select="'urn:us:gov:ic:ism'"/>
                  <xsl:text/>}<xsl:text/>
                  <xsl:value-of select="'DESVersion'"/>
                  <xsl:text/>
            declared must be the same throughout the IC-TDF skeleton including the 
            HandlingAssertions and StatementMetadata within assertions.
            Versions found: <xsl:text/>
                  <xsl:value-of select="string-join(distinct-values(for $ver in                   (//tdf:*/@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:ism']                  | //tdf:HandlingAssertion//@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:ism']                  | //tdf:StatementMetadata//@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:ism'])                  return $ver), ', ')"/>
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

   <!--PATTERN IC-TDF-ID-00047-->


	<!--RULE CompareVersionsInSkeleton-R1-->
<xsl:template match="tdf:*[@ntk:DESVersion]          | tdf:HandlingAssertion//*[@ntk:DESVersion]          | tdf:StatementMetdata//*[@ntk:DESVersion]"
                 priority="1000"
                 mode="M44">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:*[@ntk:DESVersion]          | tdf:HandlingAssertion//*[@ntk:DESVersion]          | tdf:StatementMetdata//*[@ntk:DESVersion]"
                       id="CompareVersionsInSkeleton-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="every $ver in               (//tdf:*/@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:ntk']              | //tdf:HandlingAssertion//@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:ntk']              | //tdf:StatementMetadata//@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:ntk'])              satisfies (number(if (contains($ver,'-')) then substring-before($ver,'-') else $ver))=(number(if (contains(@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:ntk'],'-')) then substring-before(@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:ntk'],'-') else @*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:ntk']))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $ver in (//tdf:*/@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:ntk'] | //tdf:HandlingAssertion//@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:ntk'] | //tdf:StatementMetadata//@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:ntk']) satisfies (number(if (contains($ver,'-')) then substring-before($ver,'-') else $ver))=(number(if (contains(@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:ntk'],'-')) then substring-before(@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:ntk'],'-') else @*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:ntk']))">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [<xsl:text/>
                  <xsl:value-of select="'IC-TDF-ID-00047'"/>
                  <xsl:text/>][Error] 
            The {<xsl:text/>
                  <xsl:value-of select="'urn:us:gov:ic:ntk'"/>
                  <xsl:text/>}<xsl:text/>
                  <xsl:value-of select="'DESVersion'"/>
                  <xsl:text/>
            declared must be the same throughout the IC-TDF skeleton including the 
            HandlingAssertions and StatementMetadata within assertions.
            Versions found: <xsl:text/>
                  <xsl:value-of select="string-join(distinct-values(for $ver in                   (//tdf:*/@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:ntk']                  | //tdf:HandlingAssertion//@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:ntk']                  | //tdf:StatementMetadata//@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:ntk'])                  return $ver), ', ')"/>
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

   <!--PATTERN IC-TDF-ID-00048-->


	<!--RULE CompareVersionsInSkeleton-R1-->
<xsl:template match="tdf:*[@arh:DESVersion]          | tdf:HandlingAssertion//*[@arh:DESVersion]          | tdf:StatementMetdata//*[@arh:DESVersion]"
                 priority="1000"
                 mode="M45">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:*[@arh:DESVersion]          | tdf:HandlingAssertion//*[@arh:DESVersion]          | tdf:StatementMetdata//*[@arh:DESVersion]"
                       id="CompareVersionsInSkeleton-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="every $ver in               (//tdf:*/@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:arh']              | //tdf:HandlingAssertion//@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:arh']              | //tdf:StatementMetadata//@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:arh'])              satisfies (number(if (contains($ver,'-')) then substring-before($ver,'-') else $ver))=(number(if (contains(@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:arh'],'-')) then substring-before(@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:arh'],'-') else @*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:arh']))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $ver in (//tdf:*/@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:arh'] | //tdf:HandlingAssertion//@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:arh'] | //tdf:StatementMetadata//@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:arh']) satisfies (number(if (contains($ver,'-')) then substring-before($ver,'-') else $ver))=(number(if (contains(@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:arh'],'-')) then substring-before(@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:arh'],'-') else @*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:arh']))">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [<xsl:text/>
                  <xsl:value-of select="'IC-TDF-ID-00048'"/>
                  <xsl:text/>][Error] 
            The {<xsl:text/>
                  <xsl:value-of select="'urn:us:gov:ic:arh'"/>
                  <xsl:text/>}<xsl:text/>
                  <xsl:value-of select="'DESVersion'"/>
                  <xsl:text/>
            declared must be the same throughout the IC-TDF skeleton including the 
            HandlingAssertions and StatementMetadata within assertions.
            Versions found: <xsl:text/>
                  <xsl:value-of select="string-join(distinct-values(for $ver in                   (//tdf:*/@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:arh']                  | //tdf:HandlingAssertion//@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:arh']                  | //tdf:StatementMetadata//@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:arh'])                  return $ver), ', ')"/>
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

   <!--PATTERN IC-TDF-ID-00049-->


	<!--RULE CompareVersionsInSkeleton-R1-->
<xsl:template match="tdf:*[@edh:DESVersion]          | tdf:HandlingAssertion//*[@edh:DESVersion]          | tdf:StatementMetdata//*[@edh:DESVersion]"
                 priority="1000"
                 mode="M46">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:*[@edh:DESVersion]          | tdf:HandlingAssertion//*[@edh:DESVersion]          | tdf:StatementMetdata//*[@edh:DESVersion]"
                       id="CompareVersionsInSkeleton-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="every $ver in               (//tdf:*/@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:edh']              | //tdf:HandlingAssertion//@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:edh']              | //tdf:StatementMetadata//@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:edh'])              satisfies (number(if (contains($ver,'-')) then substring-before($ver,'-') else $ver))=(number(if (contains(@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:edh'],'-')) then substring-before(@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:edh'],'-') else @*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:edh']))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $ver in (//tdf:*/@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:edh'] | //tdf:HandlingAssertion//@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:edh'] | //tdf:StatementMetadata//@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:edh']) satisfies (number(if (contains($ver,'-')) then substring-before($ver,'-') else $ver))=(number(if (contains(@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:edh'],'-')) then substring-before(@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:edh'],'-') else @*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:edh']))">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [<xsl:text/>
                  <xsl:value-of select="'IC-TDF-ID-00049'"/>
                  <xsl:text/>][Error] 
            The {<xsl:text/>
                  <xsl:value-of select="'urn:us:gov:ic:edh'"/>
                  <xsl:text/>}<xsl:text/>
                  <xsl:value-of select="'DESVersion'"/>
                  <xsl:text/>
            declared must be the same throughout the IC-TDF skeleton including the 
            HandlingAssertions and StatementMetadata within assertions.
            Versions found: <xsl:text/>
                  <xsl:value-of select="string-join(distinct-values(for $ver in                   (//tdf:*/@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:edh']                  | //tdf:HandlingAssertion//@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:edh']                  | //tdf:StatementMetadata//@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:edh'])                  return $ver), ', ')"/>
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

   <!--PATTERN IC-TDF-ID-00050-->


	<!--RULE CompareVersionsInSkeleton-R1-->
<xsl:template match="tdf:*[@icid:DESVersion]          | tdf:HandlingAssertion//*[@icid:DESVersion]          | tdf:StatementMetdata//*[@icid:DESVersion]"
                 priority="1000"
                 mode="M47">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:*[@icid:DESVersion]          | tdf:HandlingAssertion//*[@icid:DESVersion]          | tdf:StatementMetdata//*[@icid:DESVersion]"
                       id="CompareVersionsInSkeleton-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="every $ver in               (//tdf:*/@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:id']              | //tdf:HandlingAssertion//@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:id']              | //tdf:StatementMetadata//@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:id'])              satisfies (number(if (contains($ver,'-')) then substring-before($ver,'-') else $ver))=(number(if (contains(@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:id'],'-')) then substring-before(@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:id'],'-') else @*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:id']))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $ver in (//tdf:*/@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:id'] | //tdf:HandlingAssertion//@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:id'] | //tdf:StatementMetadata//@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:id']) satisfies (number(if (contains($ver,'-')) then substring-before($ver,'-') else $ver))=(number(if (contains(@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:id'],'-')) then substring-before(@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:id'],'-') else @*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:id']))">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [<xsl:text/>
                  <xsl:value-of select="'IC-TDF-ID-00050'"/>
                  <xsl:text/>][Error] 
            The {<xsl:text/>
                  <xsl:value-of select="'urn:us:gov:ic:id'"/>
                  <xsl:text/>}<xsl:text/>
                  <xsl:value-of select="'DESVersion'"/>
                  <xsl:text/>
            declared must be the same throughout the IC-TDF skeleton including the 
            HandlingAssertions and StatementMetadata within assertions.
            Versions found: <xsl:text/>
                  <xsl:value-of select="string-join(distinct-values(for $ver in                   (//tdf:*/@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:id']                  | //tdf:HandlingAssertion//@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:id']                  | //tdf:StatementMetadata//@*[local-name()='DESVersion' and namespace-uri()='urn:us:gov:ic:id'])                  return $ver), ', ')"/>
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

   <!--PATTERN IC-TDF-ID-00051-->


	<!--RULE CompareVersionsInSkeleton-R1-->
<xsl:template match="tdf:*[@usagency:CESVersion]          | tdf:HandlingAssertion//*[@usagency:CESVersion]          | tdf:StatementMetdata//*[@usagency:CESVersion]"
                 priority="1000"
                 mode="M48">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:*[@usagency:CESVersion]          | tdf:HandlingAssertion//*[@usagency:CESVersion]          | tdf:StatementMetdata//*[@usagency:CESVersion]"
                       id="CompareVersionsInSkeleton-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="every $ver in               (//tdf:*/@*[local-name()='CESVersion' and namespace-uri()='urn:us:gov:ic:usagency']              | //tdf:HandlingAssertion//@*[local-name()='CESVersion' and namespace-uri()='urn:us:gov:ic:usagency']              | //tdf:StatementMetadata//@*[local-name()='CESVersion' and namespace-uri()='urn:us:gov:ic:usagency'])              satisfies (number(if (contains($ver,'-')) then substring-before($ver,'-') else $ver))=(number(if (contains(@*[local-name()='CESVersion' and namespace-uri()='urn:us:gov:ic:usagency'],'-')) then substring-before(@*[local-name()='CESVersion' and namespace-uri()='urn:us:gov:ic:usagency'],'-') else @*[local-name()='CESVersion' and namespace-uri()='urn:us:gov:ic:usagency']))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $ver in (//tdf:*/@*[local-name()='CESVersion' and namespace-uri()='urn:us:gov:ic:usagency'] | //tdf:HandlingAssertion//@*[local-name()='CESVersion' and namespace-uri()='urn:us:gov:ic:usagency'] | //tdf:StatementMetadata//@*[local-name()='CESVersion' and namespace-uri()='urn:us:gov:ic:usagency']) satisfies (number(if (contains($ver,'-')) then substring-before($ver,'-') else $ver))=(number(if (contains(@*[local-name()='CESVersion' and namespace-uri()='urn:us:gov:ic:usagency'],'-')) then substring-before(@*[local-name()='CESVersion' and namespace-uri()='urn:us:gov:ic:usagency'],'-') else @*[local-name()='CESVersion' and namespace-uri()='urn:us:gov:ic:usagency']))">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [<xsl:text/>
                  <xsl:value-of select="'IC-TDF-ID-00051'"/>
                  <xsl:text/>][Error] 
            The {<xsl:text/>
                  <xsl:value-of select="'urn:us:gov:ic:usagency'"/>
                  <xsl:text/>}<xsl:text/>
                  <xsl:value-of select="'CESVersion'"/>
                  <xsl:text/>
            declared must be the same throughout the IC-TDF skeleton including the 
            HandlingAssertions and StatementMetadata within assertions.
            Versions found: <xsl:text/>
                  <xsl:value-of select="string-join(distinct-values(for $ver in                   (//tdf:*/@*[local-name()='CESVersion' and namespace-uri()='urn:us:gov:ic:usagency']                  | //tdf:HandlingAssertion//@*[local-name()='CESVersion' and namespace-uri()='urn:us:gov:ic:usagency']                  | //tdf:StatementMetadata//@*[local-name()='CESVersion' and namespace-uri()='urn:us:gov:ic:usagency'])                  return $ver), ', ')"/>
                  <xsl:text/>
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

   <!--PATTERN IC-TDF-ID-00052-->


	<!--RULE CompareVersionsInSkeleton-R1-->
<xsl:template match="tdf:*[@tdf:version]          | tdf:HandlingAssertion//*[@tdf:version]          | tdf:StatementMetdata//*[@tdf:version]"
                 priority="1000"
                 mode="M49">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:*[@tdf:version]          | tdf:HandlingAssertion//*[@tdf:version]          | tdf:StatementMetdata//*[@tdf:version]"
                       id="CompareVersionsInSkeleton-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="every $ver in               (//tdf:*/@*[local-name()='version' and namespace-uri()='urn:us:gov:ic:tdf']              | //tdf:HandlingAssertion//@*[local-name()='version' and namespace-uri()='urn:us:gov:ic:tdf']              | //tdf:StatementMetadata//@*[local-name()='version' and namespace-uri()='urn:us:gov:ic:tdf'])              satisfies (number(if (contains($ver,'-')) then substring-before($ver,'-') else $ver))=(number(if (contains(@*[local-name()='version' and namespace-uri()='urn:us:gov:ic:tdf'],'-')) then substring-before(@*[local-name()='version' and namespace-uri()='urn:us:gov:ic:tdf'],'-') else @*[local-name()='version' and namespace-uri()='urn:us:gov:ic:tdf']))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $ver in (//tdf:*/@*[local-name()='version' and namespace-uri()='urn:us:gov:ic:tdf'] | //tdf:HandlingAssertion//@*[local-name()='version' and namespace-uri()='urn:us:gov:ic:tdf'] | //tdf:StatementMetadata//@*[local-name()='version' and namespace-uri()='urn:us:gov:ic:tdf']) satisfies (number(if (contains($ver,'-')) then substring-before($ver,'-') else $ver))=(number(if (contains(@*[local-name()='version' and namespace-uri()='urn:us:gov:ic:tdf'],'-')) then substring-before(@*[local-name()='version' and namespace-uri()='urn:us:gov:ic:tdf'],'-') else @*[local-name()='version' and namespace-uri()='urn:us:gov:ic:tdf']))">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [<xsl:text/>
                  <xsl:value-of select="'IC-TDF-ID-00052'"/>
                  <xsl:text/>][Error] 
            The {<xsl:text/>
                  <xsl:value-of select="'urn:us:gov:ic:tdf'"/>
                  <xsl:text/>}<xsl:text/>
                  <xsl:value-of select="'version'"/>
                  <xsl:text/>
            declared must be the same throughout the IC-TDF skeleton including the 
            HandlingAssertions and StatementMetadata within assertions.
            Versions found: <xsl:text/>
                  <xsl:value-of select="string-join(distinct-values(for $ver in                   (//tdf:*/@*[local-name()='version' and namespace-uri()='urn:us:gov:ic:tdf']                  | //tdf:HandlingAssertion//@*[local-name()='version' and namespace-uri()='urn:us:gov:ic:tdf']                  | //tdf:StatementMetadata//@*[local-name()='version' and namespace-uri()='urn:us:gov:ic:tdf'])                  return $ver), ', ')"/>
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

   <!--PATTERN IC-TDF-ID-00053-->


	<!--RULE CompareVersionsInSkeleton-R1-->
<xsl:template match="//tdf:*[@ism:ISMCATCESVersion]          | //tdf:HandlingAssertion//*[@ism:ISMCATCESVersion]          | //tdf:StatementMetdata//*[@ism:ISMCATCESVersion]"
                 priority="1000"
                 mode="M50">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//tdf:*[@ism:ISMCATCESVersion]          | //tdf:HandlingAssertion//*[@ism:ISMCATCESVersion]          | //tdf:StatementMetdata//*[@ism:ISMCATCESVersion]"
                       id="CompareVersionsInSkeleton-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="every $ver in               (//tdf:*/@*[local-name()='ISMCATCESVersion' and namespace-uri()='urn:us:gov:ic:ism']              | //tdf:HandlingAssertion//@*[local-name()='ISMCATCESVersion' and namespace-uri()='urn:us:gov:ic:ism']              | //tdf:StatementMetadata//@*[local-name()='ISMCATCESVersion' and namespace-uri()='urn:us:gov:ic:ism'])              satisfies (number(if (contains($ver,'-')) then substring-before($ver,'-') else $ver))=(number(if (contains(@*[local-name()='ISMCATCESVersion' and namespace-uri()='urn:us:gov:ic:ism'],'-')) then substring-before(@*[local-name()='ISMCATCESVersion' and namespace-uri()='urn:us:gov:ic:ism'],'-') else @*[local-name()='ISMCATCESVersion' and namespace-uri()='urn:us:gov:ic:ism']))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $ver in (//tdf:*/@*[local-name()='ISMCATCESVersion' and namespace-uri()='urn:us:gov:ic:ism'] | //tdf:HandlingAssertion//@*[local-name()='ISMCATCESVersion' and namespace-uri()='urn:us:gov:ic:ism'] | //tdf:StatementMetadata//@*[local-name()='ISMCATCESVersion' and namespace-uri()='urn:us:gov:ic:ism']) satisfies (number(if (contains($ver,'-')) then substring-before($ver,'-') else $ver))=(number(if (contains(@*[local-name()='ISMCATCESVersion' and namespace-uri()='urn:us:gov:ic:ism'],'-')) then substring-before(@*[local-name()='ISMCATCESVersion' and namespace-uri()='urn:us:gov:ic:ism'],'-') else @*[local-name()='ISMCATCESVersion' and namespace-uri()='urn:us:gov:ic:ism']))">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [<xsl:text/>
                  <xsl:value-of select="'IC-TDF-ID-00053'"/>
                  <xsl:text/>][Error] 
            The {<xsl:text/>
                  <xsl:value-of select="'urn:us:gov:ic:ism'"/>
                  <xsl:text/>}<xsl:text/>
                  <xsl:value-of select="'ISMCATCESVersion'"/>
                  <xsl:text/>
            declared must be the same throughout the IC-TDF skeleton including the 
            HandlingAssertions and StatementMetadata within assertions.
            Versions found: <xsl:text/>
                  <xsl:value-of select="string-join(distinct-values(for $ver in                   (//tdf:*/@*[local-name()='ISMCATCESVersion' and namespace-uri()='urn:us:gov:ic:ism']                  | //tdf:HandlingAssertion//@*[local-name()='ISMCATCESVersion' and namespace-uri()='urn:us:gov:ic:ism']                  | //tdf:StatementMetadata//@*[local-name()='ISMCATCESVersion' and namespace-uri()='urn:us:gov:ic:ism'])                  return $ver), ', ')"/>
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

   <!--PATTERN IC-TDF-ID-00054-->


	<!--RULE IC-TDF-ID-00054-R1-->
<xsl:template match="*[@tdf:version]" priority="1000" mode="M51">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[@tdf:version]"
                       id="IC-TDF-ID-00054-R1"/>

		    <!--ASSERT warning-->
<xsl:choose>
         <xsl:when test="matches(@tdf:version,'^201412.201707(\-.{1,23})?$')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="matches(@tdf:version,'^201412.201707(\-.{1,23})?$')">
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [IC-TDF-ID-00054][Warning] tdf:version attribute SHOULD be specified as version 201412.201707 with an optional extension. 
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

   <!--PATTERN IC-TDF-ID-00055-->


	<!--RULE IC-TDF-ID-00055-R1-->
<xsl:template match="tdf:TrustedDataObject[not(tdf:*/@tdf:isEncrypted=true())]"
                 priority="1000"
                 mode="M52">
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
               <svrl:text>[IC-TDF-ID-00055][Error] For element TrustedDataObject whose payload is NOT encrypted,
			there must not be more than one element HandlingAssertion that specifies attribute scope containing [PAYL] and
			contains an EDH element.
			
			Human Readable: For TrustedDataObjects with unencrypted payloads, there must not be more than a single 
			EDH HandlingAssertion scoped for the payload.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M52"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M52"/>
   <xsl:template match="@*|node()" priority="-2" mode="M52">
      <xsl:apply-templates select="*" mode="M52"/>
   </xsl:template>

   <!--PATTERN IC-TDF-ID-00025-->


	<!--RULE IC-TDF-ID-00025-R1-->
<xsl:template match="tdf:TrustedDataObject[tdf:HandlingAssertion/@tdf:appliesToState]"
                 priority="1000"
                 mode="M53">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:TrustedDataObject[tdf:HandlingAssertion/@tdf:appliesToState]"
                       id="IC-TDF-ID-00025-R1"/>

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
               <svrl:text>
			[IC-TDF-ID-00025][Error] Attribute @appliesToState is only allowed when 
			TDO payload attrbute @isEncrypted equals "true".
			
			Human Readable: Handling Statement state applicability can only be defined
			when an encrypted payload is present.
		</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M53"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M53"/>
   <xsl:template match="@*|node()" priority="-2" mode="M53">
      <xsl:apply-templates select="*" mode="M53"/>
   </xsl:template>

   <!--PATTERN IC-TDF-ID-00026-->


	<!--RULE IC-TDF-ID-00026-R1-->
<xsl:template match="tdf:TrustedDataObject/tdf:*[@tdf:isEncrypted=true()]"
                 priority="1000"
                 mode="M54">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:TrustedDataObject/tdf:*[@tdf:isEncrypted=true()]"
                       id="IC-TDF-ID-00026-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="count(parent::node()/tdf:HandlingAssertion[util:containsAnyOfTheTokens(@tdf:scope, ('PAYL')) and @tdf:appliesToState='encrypted'])= 1    and     count(parent::node()/tdf:HandlingAssertion[util:containsAnyOfTheTokens(@tdf:scope, ('PAYL')) and @tdf:appliesToState='unencrypted'])= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(parent::node()/tdf:HandlingAssertion[util:containsAnyOfTheTokens(@tdf:scope, ('PAYL')) and @tdf:appliesToState='encrypted'])= 1 and count(parent::node()/tdf:HandlingAssertion[util:containsAnyOfTheTokens(@tdf:scope, ('PAYL')) and @tdf:appliesToState='unencrypted'])= 1">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
			[IC-TDF-ID-00026][Error] If payload attribute @isEncrypted="true", then there needs to 
			be two handling assertions with attribute scope="PAYL": one with attribute 
			@appliesToState="encrypted" and the other with attribute appliesToState="unencrypted".
		</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M54"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M54"/>
   <xsl:template match="@*|node()" priority="-2" mode="M54">
      <xsl:apply-templates select="*" mode="M54"/>
   </xsl:template>

   <!--PATTERN IC-TDF-ID-00027-->


	<!--RULE IC-TDF-ID-00027-R1-->
<xsl:template match="tdf:TrustedDataObject/tdf:*[@tdf:isEncrypted=true()]"
                 priority="1000"
                 mode="M55">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:TrustedDataObject/tdf:*[@tdf:isEncrypted=true()]"
                       id="IC-TDF-ID-00027-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="count(parent::node()/tdf:HandlingAssertion[util:containsAnyOfTheTokens(@tdf:scope, ('PAYL'))    and @tdf:appliesToState='unencrypted']/tdf:HandlingStatement/edh:ExternalEdh)= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(parent::node()/tdf:HandlingAssertion[util:containsAnyOfTheTokens(@tdf:scope, ('PAYL')) and @tdf:appliesToState='unencrypted']/tdf:HandlingStatement/edh:ExternalEdh)= 1">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
			[IC-TDF-ID-00027][Error] If payload attribute @isEncrypted="true", the handling 
			assertion with @scope="PAYL" that contains @appliesToState="unencrypted"  must 
			contain an edh:externalEDH. 
			
			Human Readable: When content is encrypted, the handling assertion describing the content in an unencrypted state is in effect external.
		</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M55"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M55"/>
   <xsl:template match="@*|node()" priority="-2" mode="M55">
      <xsl:apply-templates select="*" mode="M55"/>
   </xsl:template>

   <!--PATTERN IC-TDF-ID-00028-->


	<!--RULE IC-TDF-ID-00028-R1-->
<xsl:template match="tdf:TrustedDataObject[tdf:StringPayload/@tdf:isEncrypted=true()] | tdf:TrustedDataObject[tdf:Base64BinaryPayload/@tdf:isEncrypted=true()] | tdf:TrustedDataObject[tdf:StructuredPayload/@tdf:isEncrypted=true()]"
                 priority="1000"
                 mode="M56">
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
               <svrl:text>[IC-TDF-ID-00028][Error] If payload attribute @isEncrypted="true" and the
			payload is not external, the handling assertion with @scope="PAYL" that contains
			@appliesToState="encrypted" must contain a regular edh:EDH. Human Readable: Internal
			content requires an EDH.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M56"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M56"/>
   <xsl:template match="@*|node()" priority="-2" mode="M56">
      <xsl:apply-templates select="*" mode="M56"/>
   </xsl:template>

   <!--PATTERN IC-TDF-ID-00030-->


	<!--RULE IC-TDF-ID-00030-R1-->
<xsl:template match="tdf:TrustedDataObject/tdf:Assertion/tdf:*[@tdf:isEncrypted=true()]"
                 priority="1000"
                 mode="M57">
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
               <svrl:text> [IC-TDF-ID-00030][Error] If statement attribute @isEncrypted="true", the
			statement metadata that contains @appliesToState="unencrypted" must contain an
			arh:ExternalSecurity Human Readable: When statement content is encrypted, the handling
			statement describing the content in an unencrypted state is in effect external.
		</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M57"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M57"/>
   <xsl:template match="@*|node()" priority="-2" mode="M57">
      <xsl:apply-templates select="*" mode="M57"/>
   </xsl:template>

   <!--PATTERN IC-TDF-ID-00031-->


	<!--RULE IC-TDF-ID-00031-R1-->
<xsl:template match="tdf:TrustedDataObject/tdf:Assertion/tdf:*[@tdf:isEncrypted=true()]"
                 priority="1000"
                 mode="M58">
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
               <svrl:text>[IC-TDF-ID-00031][Error] If assertion statement attribute
            @isEncrypted="true", then there needs to be two statement metadata elements: one with
            attribute @appliesToState="encrypted" and the other with attribute
            appliesToState="unencrypted". Human Readable: If an assertion statement is encrypted, it
            must have statement metadata to describe handling for both for its encrypted state, and
            unencrypted state.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M58"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M58"/>
   <xsl:template match="@*|node()" priority="-2" mode="M58">
      <xsl:apply-templates select="*" mode="M58"/>
   </xsl:template>

   <!--PATTERN IC-TDF-ID-00032-->


	<!--RULE IC-TDF-ID-00032-R1-->
<xsl:template match="tdf:TrustedDataObject/tdf:Assertion[tdf:StatementMetadata/@tdf:appliesToState]"
                 priority="1000"
                 mode="M59">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:TrustedDataObject/tdf:Assertion[tdf:StatementMetadata/@tdf:appliesToState]"
                       id="IC-TDF-ID-00032-R1"/>

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
               <svrl:text>
			[IC-TDF-ID-00032][Error] Attribute @appliesToState is only allowed when 
			TDO statement attribute @isEncrypted equals "true".
			
			Human Readable:  StatementMetadata state applicability can only be defined
			when an encrypted statement is present. 
		</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M59"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M59"/>
   <xsl:template match="@*|node()" priority="-2" mode="M59">
      <xsl:apply-templates select="*" mode="M59"/>
   </xsl:template>

   <!--PATTERN IC-TDF-ID-00039-->


	<!--RULE IC-TDF-ID-00039-R1-->
<xsl:template match="tdf:TrustedDataObject/tdf:HandlingAssertion[@tdf:appliesToState]"
                 priority="1000"
                 mode="M60">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:TrustedDataObject/tdf:HandlingAssertion[@tdf:appliesToState]"
                       id="IC-TDF-ID-00039-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="@tdf:scope='PAYL'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@tdf:scope='PAYL'">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
			[IC-TDF-ID-00039][Error] Attribute @appliesToState is only allowed with HandlingAssertions 
			of scope PAYL
			
			Human Readable: Only Handling Assertions with scope PAYL can use the appliesToState attribute because
			the attribute indicates the state (encrypted or unencrypted) of the payload to which the assertion appies.		
		</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M60"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M60"/>
   <xsl:template match="@*|node()" priority="-2" mode="M60">
      <xsl:apply-templates select="*" mode="M60"/>
   </xsl:template>
</xsl:stylesheet>
<!--UNCLASSIFIED-->
