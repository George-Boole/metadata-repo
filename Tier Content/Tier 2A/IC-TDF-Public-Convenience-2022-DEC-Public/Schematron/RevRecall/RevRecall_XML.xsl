<?xml version="1.0" encoding="UTF-8"?>
<!--UNCLASSIFIED--><xsl:stylesheet xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                xmlns:saxon="http://saxon.sf.net/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:schold="http://www.ascc.net/xml/schematron"
                xmlns:iso="http://purl.oclc.org/dsdl/schematron"
                xmlns:xhtml="http://www.w3.org/1999/xhtml"
                xmlns:rr="urn:us:gov:ic:revrecall"
                xmlns:xl="http://www.w3.org/1999/xlink"
                xmlns:tdf="urn:us:gov:ic:tdf"
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
         <svrl:ns-prefix-in-attribute-values uri="urn:us:gov:ic:revrecall" prefix="rr"/>
         <svrl:ns-prefix-in-attribute-values uri="http://www.w3.org/1999/xlink" prefix="xl"/>
         <svrl:ns-prefix-in-attribute-values uri="urn:us:gov:ic:tdf" prefix="tdf"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">RevRecall-ID-00001</xsl:attribute>
            <xsl:attribute name="name">RevRecall-ID-00001</xsl:attribute>
            <svrl:text>[RevRecall-ID-00001][Error] All elements in the RevRecall namespace
        except Link must have content.</svrl:text>
            <svrl:text>All elements in the RevRecall namespace except Link
        context="rr:*[not(local-name() = 'Link')]" must have content.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M3"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">RevRecall-ID-00003</xsl:attribute>
            <xsl:attribute name="name">RevRecall-ID-00003</xsl:attribute>
            <svrl:text>[RevRecall-ID-00003][Error] All xlink attributes on RevRecall elements
        must have non-whitespace values.</svrl:text>
            <svrl:text>All attributes in the xlink namespace that are on elements in the
        RevRecall namespace must have non-empty, non-whitespace values.</svrl:text>
            <svrl:text>[Implementation Warning] The context for this rule is all RevRecall
        elements that have xlink attributes. Using the element context avoids a Saxon warning and
        potential execution issue with using the attribute context directly. That is, using
        rr:*/@xl* as the context theoretically provides the same attribute set, but Saxon throws a
        warning: The child axis starting at an attribute node will never select anything. This
        warning is caused by the generated XSL that is used for Schematron validation. Using the
        attribute context works in Oxygen XML Editor, but may not work using Saxon directly. To
        avoid potential kerfuffle, the element context is used.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M4"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">RevRecall-ID-00004</xsl:attribute>
            <xsl:attribute name="name">RevRecall-ID-00004</xsl:attribute>
            <svrl:text>[RevRecall-ID-00004][Error] A RevRecall assertion must contain an
        ActionInstruction element if @action="MANUAL_INSTRUCTION".</svrl:text>
            <svrl:text>A RevRecall assertion must contain an ActionInstruction element if
        @action="MANUAL_INSTRUCTION".</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M5"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">RevRecall-ID-00005</xsl:attribute>
            <xsl:attribute name="name">RevRecall-ID-00005</xsl:attribute>
            <svrl:text>[RevRecall-ID-00005][Error] A RevRecall assertion must not contain an
        ActionInstruction element unless @action="MANUAL_INSTRUCTION".</svrl:text>
            <svrl:text>A RevRecall assertion must not contain an ActionInstruction element
        unless @action="MANUAL_INSTRUCTION".</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M6"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">RevRecall-ID-00006</xsl:attribute>
            <xsl:attribute name="name">RevRecall-ID-00006</xsl:attribute>
            <svrl:text>[RevRecall-ID-00006][Error] TDF elements must have no more than one Revision Recall assertion.</svrl:text>
            <svrl:text>Verify that the number of Revision Recall assertions is not more than 1.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M7"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">RevRecall-ID-00007</xsl:attribute>
            <xsl:attribute name="name">RevRecall-ID-00007</xsl:attribute>
            <svrl:text>[RevRecall-ID-00007][Error] For a Trusted Data Object, RevRecall 
        handling assertions must have @tdf:scope with the value "TDO".</svrl:text>
            <svrl:text>Given a Revision Recall handling assertion for a TDO --
        context="tdf:HandlingAssertion[child::tdf:HandlingStatement/rr:RevisionRecall]" -- 
        assert that there exists @tdf:scope with the value "TDO" </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M8"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">RevRecall-ID-00008</xsl:attribute>
            <xsl:attribute name="name">RevRecall-ID-00008</xsl:attribute>
            <svrl:text>[RevRecall-ID-00008][Error] For a Trusted Data Collection, RevRecall
        handling assertions must have @tdf:scope with the value "TDC".</svrl:text>
            <svrl:text>Given a Revision Recall handling assertion for a TDC --
        context="tdf:HandlingAssertion[child::tdf:HandlingStatement/rr:RevisionRecall]" -- 
        assert that there exists @tdf:scope with the value "TDC" </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M9"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">RevRecall-ID-00009</xsl:attribute>
            <xsl:attribute name="name">RevRecall-ID-00009</xsl:attribute>
            <svrl:text>[RevRecall-ID-00009][Error] Revision Recall assertions must be Handling
        Assertions.</svrl:text>
            <svrl:text>The RevisionRecall element must be the grandchild of a HandlingAssertion
        element. This rule is tested from the RevisionRecall context to ensure that non-compliant
        assertions are flagged.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M10"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">RevRecall-ID-00010</xsl:attribute>
            <xsl:attribute name="name">RevRecall-ID-00010</xsl:attribute>
            <svrl:text>
        [RevRecall-ID-00010][Error] If the attribute @rr:dateTime of type xs:dateTime exists, it must have a timezone.
        
        Human Readable: The RevRecall attribute dateTime must have a timezone.
    </svrl:text>
            <svrl:text>
        The RevRecall attribute rr:dateTime must have a timezone. 
        According to http://www.w3.org/TR/xmlschema-2/#dateTime, datetime is represented by: 
        '-'? yyyy '-' mm '-' dd 'T' hh ':' mm ':' ss ('.' s+)? (zzzzzz)?
        where the timezone zzzzzz is represented by:
        (('+' | '-') hh ':' mm) | 'Z'
        This rule enforces and makes the timezone zzzzzz mandatory.
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M11"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">RevRecall-ID-00011</xsl:attribute>
            <xsl:attribute name="name">RevRecall-ID-00011</xsl:attribute>
            <svrl:text>
        [RevRecall-ID-00011][Warning] rr:DESVersion attribute SHOULD be specified
        as version 202111.202205 (Version:2021-NOV Revision: 2022-MAY) with an optional extension. 
    </svrl:text>
            <svrl:text>
        This rule supports extending the version identifier with an optional
        trailing hyphen and up to 23 additional characters. The version must match the regular
        expression “^202111.202205(-.{1,23})?$".
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M12"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">RevRecall-ID-00012</xsl:attribute>
            <xsl:attribute name="name">RevRecall-ID-00012</xsl:attribute>
            <svrl:text> [RevRecall-ID-00012][Error] If @type has the value of
        "FISA_COMPLIANCE_RECALL" then @action MUST be "PURGE", "RETAIN_HIDE", or
        "MANUAL_INSTRUCTION". </svrl:text>
            <svrl:text>If @type has the value of
        "FISA_COMPLIANCE_RECALL" then @action MUST be "PURGE", "RETAIN_HIDE", or
        "MANUAL_INSTRUCTION".</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M13"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">RevRecall-ID-00013</xsl:attribute>
            <xsl:attribute name="name">RevRecall-ID-00013</xsl:attribute>
            <svrl:text>
        This abstract pattern checks to see if the validation environment has at least the version / revision of the
        Schema as of the writing of this specification. 
        The calling rule must pass in '202111', 'ISM', '../../Schema/ISM/IC-ISM.xsd', 'RevRecall-ID-00013'.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M14"/>
      </svrl:schematron-output>
   </xsl:template>

   <!--SCHEMATRON PATTERNS-->


<!--PATTERN RevRecall-ID-00001-->


	<!--RULE RevRecall-ID-00001-R1-->
<xsl:template match="rr:*[not(local-name() = 'Link')]" priority="1000" mode="M3">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rr:*[not(local-name() = 'Link')]"
                       id="RevRecall-ID-00001-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="normalize-space(.)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="normalize-space(.)">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[RevRecall-ID-00001][Error] All elements
            in the RevRecall namespace except Link must have content.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M3"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M3"/>
   <xsl:template match="@*|node()" priority="-2" mode="M3">
      <xsl:apply-templates select="*" mode="M3"/>
   </xsl:template>

   <!--PATTERN RevRecall-ID-00003-->


	<!--RULE RevRecall-ID-00003-R1-->
<xsl:template match="rr:*[@xl:*]" priority="1000" mode="M4">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rr:*[@xl:*]"
                       id="RevRecall-ID-00003-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="every $attr in @xl:* satisfies normalize-space($attr) != ''"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $attr in @xl:* satisfies normalize-space($attr) != ''">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[RevRecall-ID-00003][Error] All xlink attributes on elements in the RevRecall namespace
            must have non-empty, non-whitespace values.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M4"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M4"/>
   <xsl:template match="@*|node()" priority="-2" mode="M4">
      <xsl:apply-templates select="*" mode="M4"/>
   </xsl:template>

   <!--PATTERN RevRecall-ID-00004-->


	<!--RULE RevRecall-ID-00004-R1-->
<xsl:template match="rr:*[contains(@rr:action, 'MANUAL_INSTRUCTION')]"
                 priority="1000"
                 mode="M5">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rr:*[contains(@rr:action, 'MANUAL_INSTRUCTION')]"
                       id="RevRecall-ID-00004-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="child::rr:ActionInstruction"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="child::rr:ActionInstruction">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[RevRecall-ID-00004][Error] A
            RevRecall assertion must contain an ActionInstruction element if
            @action="MANUAL_INSTRUCTION".</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M5"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M5"/>
   <xsl:template match="@*|node()" priority="-2" mode="M5">
      <xsl:apply-templates select="*" mode="M5"/>
   </xsl:template>

   <!--PATTERN RevRecall-ID-00005-->


	<!--RULE RevRecall-ID-00005-R1-->
<xsl:template match="rr:ActionInstruction" priority="1000" mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rr:ActionInstruction"
                       id="RevRecall-ID-00005-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="parent::node()[contains(@rr:action, 'MANUAL_INSTRUCTION')]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="parent::node()[contains(@rr:action, 'MANUAL_INSTRUCTION')]">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[RevRecall-ID-00005][Error] A RevRecall assertion must not contain an ActionInstruction
            element unless @action="MANUAL_INSTRUCTION".</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M6"/>
   <xsl:template match="@*|node()" priority="-2" mode="M6">
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

   <!--PATTERN RevRecall-ID-00006-->


	<!--RULE RevRecall-ID-00006-R1-->
<xsl:template match="tdf:*[count(tdf:HandlingAssertion/tdf:HandlingStatement/rr:RevisionRecall) &gt; 1]"
                 priority="1000"
                 mode="M7">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:*[count(tdf:HandlingAssertion/tdf:HandlingStatement/rr:RevisionRecall) &gt; 1]"
                       id="RevRecall-ID-00006-R1"/>

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
               <svrl:text>[RevRecall-ID-00006][Error] TDF elements must have no more than one Revision Recall assertion.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M7"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M7"/>
   <xsl:template match="@*|node()" priority="-2" mode="M7">
      <xsl:apply-templates select="*" mode="M7"/>
   </xsl:template>

   <!--PATTERN RevRecall-ID-00007-->


	<!--RULE RevRecall-ID-00007-R1-->
<xsl:template match="tdf:TrustedDataObject/tdf:HandlingAssertion[child::tdf:HandlingStatement/rr:RevisionRecall]"
                 priority="1000"
                 mode="M8">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:TrustedDataObject/tdf:HandlingAssertion[child::tdf:HandlingStatement/rr:RevisionRecall]"
                       id="RevRecall-ID-00007-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="@tdf:scope = 'TDO'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@tdf:scope = 'TDO'">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[RevRecall-ID-00007][Error] For a Trusted Data Object, RevRecall 
            handling assertions must have @tdf:scope with the value "TDO".</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M8"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M8"/>
   <xsl:template match="@*|node()" priority="-2" mode="M8">
      <xsl:apply-templates select="*" mode="M8"/>
   </xsl:template>

   <!--PATTERN RevRecall-ID-00008-->


	<!--RULE RevRecall-ID-00008-R1-->
<xsl:template match="tdf:TrustedDataCollection/tdf:HandlingAssertion[child::tdf:HandlingStatement/rr:RevisionRecall]"
                 priority="1000"
                 mode="M9">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tdf:TrustedDataCollection/tdf:HandlingAssertion[child::tdf:HandlingStatement/rr:RevisionRecall]"
                       id="RevRecall-ID-00008-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="@tdf:scope = 'TDC'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@tdf:scope = 'TDC'">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[RevRecall-ID-00008][Error] For a Trusted Data Collection, RevRecall
            handling assertions must have @tdf:scope with the value "TDC".</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M9"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M9"/>
   <xsl:template match="@*|node()" priority="-2" mode="M9">
      <xsl:apply-templates select="*" mode="M9"/>
   </xsl:template>

   <!--PATTERN RevRecall-ID-00009-->


	<!--RULE RevRecall-ID-00009-R1-->
<xsl:template match="rr:RevisionRecall" priority="1000" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rr:RevisionRecall"
                       id="RevRecall-ID-00009-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="../parent::tdf:HandlingAssertion"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="../parent::tdf:HandlingAssertion">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[RevRecall-ID-00009][Error]
            Revision Recall assertions must be Handling Assertions.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M10"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M10"/>
   <xsl:template match="@*|node()" priority="-2" mode="M10">
      <xsl:apply-templates select="*" mode="M10"/>
   </xsl:template>

   <!--PATTERN RevRecall-ID-00010-->


	<!--RULE RevRecall-ID-00010-R1-->
<xsl:template match="rr:RevisionRecall[./@rr:dateTime]"
                 priority="1000"
                 mode="M11">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rr:RevisionRecall[./@rr:dateTime]"
                       id="RevRecall-ID-00010-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="matches(@rr:dateTime, '^-?\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(\.\d+)?(((\+|-)\d{2}:\d{2})|Z)$')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="matches(@rr:dateTime, '^-?\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(\.\d+)?(((\+|-)\d{2}:\d{2})|Z)$')">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [RevRecall-ID-00010][Error] If the attribute @rr:dateTime of type xs:dateTime exists, it must have a timezone.
            
            Human Readable: The RevRecall attribute dateTime must have a timezone.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M11"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M11"/>
   <xsl:template match="@*|node()" priority="-2" mode="M11">
      <xsl:apply-templates select="*" mode="M11"/>
   </xsl:template>

   <!--PATTERN RevRecall-ID-00011-->


	<!--RULE RevRecall-ID-00011-R1-->
<xsl:template match="*[@rr:DESVersion]" priority="1000" mode="M12">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[@rr:DESVersion]"
                       id="RevRecall-ID-00011-R1"/>

		    <!--ASSERT warning-->
<xsl:choose>
         <xsl:when test="matches(@rr:DESVersion, '^202111.202205(\-.{1,23})?$')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="matches(@rr:DESVersion, '^202111.202205(\-.{1,23})?$')">
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [RevRecall-ID-00011][Warning] rr:DESVersion attribute SHOULD be specified 
            as version 202111.202205 (Version:2021-NOV Revision: 2022-MAY) with an optional extension. 
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

   <!--PATTERN RevRecall-ID-00012-->


	<!--RULE RevRecall-ID-00012-R1-->
<xsl:template match="rr:*[@rr:type=('FISA_COMPLIANCE_RECALL')]"
                 priority="1000"
                 mode="M13">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rr:*[@rr:type=('FISA_COMPLIANCE_RECALL')]"
                       id="RevRecall-ID-00012-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="@rr:action=('PURGE', 'RETAIN_HIDE', 'MANUAL_INSTRUCTION')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="@rr:action=('PURGE', 'RETAIN_HIDE', 'MANUAL_INSTRUCTION')">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> [RevRecall-ID-00012][Error] If @type has the value of
            "FISA_COMPLIANCE_RECALL" then @action MUST be "PURGE", "RETAIN_HIDE", or
            "MANUAL_INSTRUCTION".
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

   <!--PATTERN RevRecall-ID-00013-->


	<!--RULE ValidateValidationEnvSchema-R1-->
<xsl:template match="/" priority="1000" mode="M14">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/"
                       id="ValidateValidationEnvSchema-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="document('../../Schema/ISM/IC-ISM.xsd')//xsd:schema//@version castable as xs:double              and document('../../Schema/ISM/IC-ISM.xsd')//xsd:schema//@version &gt;= '202111'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('../../Schema/ISM/IC-ISM.xsd')//xsd:schema//@version castable as xs:double and document('../../Schema/ISM/IC-ISM.xsd')//xsd:schema//@version &gt;= '202111'">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
            [<xsl:text/>
                  <xsl:value-of select="'RevRecall-ID-00013'"/>
                  <xsl:text/>][Error] Version [ <xsl:text/>
                  <xsl:value-of select="document('../../Schema/ISM/IC-ISM.xsd')//xsd:schema//@version"/>
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
                  <xsl:value-of select="document-uri(document('../../Schema/ISM/IC-ISM.xsd'))"/>
                  <xsl:text/>
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
</xsl:stylesheet>
<!--UNCLASSIFIED-->
