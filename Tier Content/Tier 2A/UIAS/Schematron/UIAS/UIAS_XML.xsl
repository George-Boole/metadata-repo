<?xml version="1.0" encoding="UTF-8"?>
<!--UNCLASSIFIED--><xsl:stylesheet xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                xmlns:saxon="http://saxon.sf.net/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:schold="http://www.ascc.net/xml/schematron"
                xmlns:iso="http://purl.oclc.org/dsdl/schematron"
                xmlns:xhtml="http://www.w3.org/1999/xhtml"
                xmlns:uias="urn:us:gov:ic:uias"
                xmlns:ism="urn:us:gov:ic:ism"
                xmlns:cve="urn:us:gov:ic:cve"
                xmlns:usagency="urn:us:gov:ic:usagency"
                xmlns:virt="urn:us:gov:ic:virt"
                xmlns:mn="urn:us:gov:ic:mn"
                xmlns:saml="urn:oasis:names:tc:SAML:2.0:assertion"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:util="urn:us:gov:ic:uias:xsl:util"
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
                 name="util:substring-before-last">
      <xsl:param name="input" as="xs:string?"/>
      <xsl:param name="delimiter" as="xs:string"/>
      <xsl:value-of select="codepoints-to-string(reverse(string-to-codepoints(substring-after(codepoints-to-string(reverse(string-to-codepoints($input))), $delimiter))))"/>
  </xsl:function>
   <xsl:function xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                 name="util:existInTokenSet"
                 as="xs:boolean">
      <xsl:param name="stringTokenValue"/>
      <xsl:param name="tokenList" as="xs:string*"/>
      <xsl:value-of select="tokenize($stringTokenValue, ' ') = $tokenList"/>
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
         <svrl:text> This is the root file for
    the specifications Schematron ruleset. It loads all of the required CVEs, declares some
    variables, and includes all of the Rule .sch files.</svrl:text>
         <svrl:ns-prefix-in-attribute-values uri="urn:us:gov:ic:uias" prefix="uias"/>
         <svrl:ns-prefix-in-attribute-values uri="urn:us:gov:ic:ism" prefix="ism"/>
         <svrl:ns-prefix-in-attribute-values uri="urn:us:gov:ic:cve" prefix="cve"/>
         <svrl:ns-prefix-in-attribute-values uri="urn:us:gov:ic:usagency" prefix="usagency"/>
         <svrl:ns-prefix-in-attribute-values uri="urn:us:gov:ic:virt" prefix="virt"/>
         <svrl:ns-prefix-in-attribute-values uri="urn:us:gov:ic:mn" prefix="mn"/>
         <svrl:ns-prefix-in-attribute-values uri="urn:oasis:names:tc:SAML:2.0:assertion" prefix="saml"/>
         <svrl:ns-prefix-in-attribute-values uri="http://www.w3.org/2001/XMLSchema-instance" prefix="xsi"/>
         <svrl:ns-prefix-in-attribute-values uri="urn:us:gov:ic:uias:xsl:util" prefix="util"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">UIAS-ID-00001</xsl:attribute>
            <xsl:attribute name="name">UIAS-ID-00001</xsl:attribute>
            <svrl:text>
        [UIAS-ID-00001][Error] adminOrganization must be present.
        
        Human Readable: The element with @Name=adminOrganization must be present.
    </svrl:text>
            <svrl:text>
        check for presence of adminOrganization 
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M37"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">UIAS-ID-00004</xsl:attribute>
            <xsl:attribute name="name">UIAS-ID-00004</xsl:attribute>
            <svrl:text>
        [UIAS-ID-00004][Error] If ATOStatus is present, entityType must be a Non-Person Entity.
        
        Human Readable: If element with @Name=ATOStatus is present, then element with @Name=entityType must 
        have one of the values in CVEnumUIASNonPersonEntityType.
    </svrl:text>
            <svrl:text>
        ATOStatus must contain a value if the entity is NPE.
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M38"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">UIAS-ID-00005</xsl:attribute>
            <xsl:attribute name="name">UIAS-ID-00005</xsl:attribute>
            <svrl:text>
        [UIAS-ID-00005][Error] If a saml attribute with @Name=aICP is true, then the saml attribute with @Name=isICMember must be true.
        
        Human Readable: If aICP is true, then isICmember must be true.
    </svrl:text>
            <svrl:text>
        For a saml attribute whose name is isICMember, verify that if there is a saml 
        attribute with name aICP and its value is true, then the value of isICMember 
        must be true.
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M39"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">UIAS-ID-00006</xsl:attribute>
            <xsl:attribute name="name">UIAS-ID-00006</xsl:attribute>
            <svrl:text>
        [UIAS-ID-00006][Error] If aICP is present, then entityType must be a member of CVEnumUIASPersonEntityType.
        
        Human Readable: If an element with @Name=aICP has a value, then an element with @Name=entityType 
        must have one of the values in CVEnumUIASPersonEntityType. 
    </svrl:text>
            <svrl:text>
        Check for presence of attribute aICP, if present check that attribute entityType is a PE.
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M40"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">UIAS-ID-00007</xsl:attribute>
            <xsl:attribute name="name">UIAS-ID-00007</xsl:attribute>
            <svrl:text>This abstract pattern
      verifies that a value at a given context matches a value in a list using regular expression matching. 
      The calling rule must pass the context, search term list, attribute value to check, and an error message.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M41"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">UIAS-ID-00008</xsl:attribute>
            <xsl:attribute name="name">UIAS-ID-00008</xsl:attribute>
            <svrl:text>
        [UIAS-ID-00008][Error] Clearance must be present.
        
        Human Readable: An element with @Name=clearance must be present.
    </svrl:text>
            <svrl:text>
        Clearance must be present.
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M42"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">UIAS-ID-00009</xsl:attribute>
            <xsl:attribute name="name">UIAS-ID-00009</xsl:attribute>
            <svrl:text>
        [UIAS-ID-00009][Error] clearance must contain at least one value.
        
        Human Readable: An element with @Name=clearance must have at least one value.
    </svrl:text>
            <svrl:text>
        clearance must contain one value.
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M43"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">UIAS-ID-00011</xsl:attribute>
            <xsl:attribute name="name">UIAS-ID-00011</xsl:attribute>
            <svrl:text>
        [UIAS-ID-00011][Error] countryOfAffiliation must be present.
        
        Human Readable: An element with @Name=countryOfAffiliation must be present.
    </svrl:text>
            <svrl:text>
        countryOfAffiliation must be present.
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M44"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">UIAS-ID-00012</xsl:attribute>
            <xsl:attribute name="name">UIAS-ID-00012</xsl:attribute>
            <svrl:text>
        [UIAS-ID-00012][Error] countryOfAffiliation must contain at least one value.
        
        Human Readable: An element with @Name=countryOfAffiliation must contain at least one value.
    </svrl:text>
            <svrl:text>
        countryOfAffiliation must contain at least one value.
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M45"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">UIAS-ID-00014</xsl:attribute>
            <xsl:attribute name="name">UIAS-ID-00014</xsl:attribute>
            <svrl:text>
        [UIAS-ID-00014][Error] digitalIdentifier must be present.
        
        Human Readable: An element with @Name=digitalIdentifier must be present.
    </svrl:text>
            <svrl:text>
        digitalIdentifier must be present.
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M46"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">UIAS-ID-00016</xsl:attribute>
            <xsl:attribute name="name">UIAS-ID-00016</xsl:attribute>
            <svrl:text>
        [UIAS-ID-00016][Error] dutyOrganization must be present.
        
        Human Readable: An element with @Name=dutyOrganization must be present.
    </svrl:text>
            <svrl:text>
        dutyOrganization must be present.
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M47"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">UIAS-ID-00019</xsl:attribute>
            <xsl:attribute name="name">UIAS-ID-00019</xsl:attribute>
            <svrl:text>
        [UIAS-ID-00019][Error] entityType must be present.
        
        Human Readable: An element with @Name=entityType must be present.
    </svrl:text>
            <svrl:text>
        entityType must be present.
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M48"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">UIAS-ID-00021</xsl:attribute>
            <xsl:attribute name="name">UIAS-ID-00021</xsl:attribute>
            <svrl:text>This abstract pattern checks to see if an attribute of an element exists
        in a list or matches the pattern defined by the list. The calling rule must pass the
        context, search term list, attribute value to check, and an error message.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M49"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">UIAS-ID-00022</xsl:attribute>
            <xsl:attribute name="name">UIAS-ID-00022</xsl:attribute>
            <svrl:text>
        [UIAS-ID-00022][Error] If entityType is NPE, then ATOStatus must be present.
        
        Human Readable:  If element with @Name=entityType has a value of one of the values in CVEnumUIASNonPersonEntityType,
        then element with @Name=ATOStatus must have a value.
    </svrl:text>
            <svrl:text>
        Check if attribute entityType = NPE, if true make sure there is an ATOStatus attribute.
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M50"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">UIAS-ID-00023</xsl:attribute>
            <xsl:attribute name="name">UIAS-ID-00023</xsl:attribute>
            <svrl:text>
        [UIAS-ID-00023][Error] If entityType is NPE, then lifeCycleStatus must be present.
        
        Human Readable:  If element with @Name=entityType has a value of one of the values in  
        CVEnumUIASNonPersonEntityType, then element with @Name=lifeCycleStatus must have a value.
    </svrl:text>
            <svrl:text>
        Check if attribute entityType = NPE, if true make sure there is a lifeCycleStatus attribute.
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M51"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">UIAS-ID-00024</xsl:attribute>
            <xsl:attribute name="name">UIAS-ID-00024</xsl:attribute>
            <svrl:text>
        [UIAS-ID-00024][Error] If entityType is PE, then aICP must be present.
        
        Human Readable:  If element with @Name=entityType has a value of one of the values in 
        CVEnumUIASPersonEntityType, then element with @Name=aICP must have a value.
    </svrl:text>
            <svrl:text>
        Check for attribute entityType = PE, if true make sure there is an aICP attribute present.
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M52"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">UIAS-ID-00025</xsl:attribute>
            <xsl:attribute name="name">UIAS-ID-00025</xsl:attribute>
            <svrl:text>
        [UIAS-ID-00025][Error] fineAccessControls must be present.
        
        Human Readable: An element with @Name=fineAccessControls must be present.
    </svrl:text>
            <svrl:text>
        fineAccessControls must be present.
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M53"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">UIAS-ID-00026</xsl:attribute>
            <xsl:attribute name="name">UIAS-ID-00026</xsl:attribute>
            <svrl:text>
        [UIAS-ID-00026][Error] fineAccessControls must contain at least one value.
        
        Human Readable: An element with @Name=fineAccessControls must contain at least one value.
    </svrl:text>
            <svrl:text>
        fineAccessControls must contain one value.
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M54"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">UIAS-ID-00028</xsl:attribute>
            <xsl:attribute name="name">UIAS-ID-00028</xsl:attribute>
            <svrl:text>
        [UIAS-ID-00028][Error] isICMember must be present.
        
        Human Readable: An element with @Name=isICMember must be present.
    </svrl:text>
            <svrl:text>
        isICMember must be present.
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M55"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">UIAS-ID-00030</xsl:attribute>
            <xsl:attribute name="name">UIAS-ID-00030</xsl:attribute>
            <svrl:text>
        [UIAS-ID-00030][Error] If lifeCycleStatus is present, entityType must be a Non-Person Entity.
        
        Human Readable: If element with @Name=lifeCycleStatus is present, then element with @Name=entityType must have a 
        value from CVEnumUIASNonPersonEntityType.
    </svrl:text>
            <svrl:text>
        If lifeCycleStatus is present, entityType must be a member of CVEnumUIASNonPersonEntityType.
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M56"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">UIAS-ID-00036</xsl:attribute>
            <xsl:attribute name="name">UIAS-ID-00036</xsl:attribute>
            <svrl:text>
        [UIAS-ID-00036][Error] The value of dutyOrganizationUnit element must begin with the value of the dutyOrganization element.
        
        Human Readable:  The value of element with @Name=dutyOrganizationUnit must begin with the value 
        of the element with @Name=dutyOrganization.
    </svrl:text>
            <svrl:text>
        The value of dutyOrganizationUnit must begin with the value of dutyOrganization.
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M57"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">UIAS-ID-00047</xsl:attribute>
            <xsl:attribute name="name">UIAS-ID-00047</xsl:attribute>
            <svrl:text>
        [UIAS-ID-00047][Error] auditRoutingOrganization must be present.
        
        Human Readable: The element with @Name=auditRoutingOrganization must be present.
    </svrl:text>
            <svrl:text>
        check for presence of auditRoutingOrganization 
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M58"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">UIAS-ID-00050</xsl:attribute>
            <xsl:attribute name="name">UIAS-ID-00050</xsl:attribute>
            <svrl:text>This abstract pattern
      verifies that a value at a given context matches a value in a list using regular expression matching. 
      The calling rule must pass the context, search term list, attribute value to check, and an error message.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M59"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">UIAS-ID-00051</xsl:attribute>
            <xsl:attribute name="name">UIAS-ID-00051</xsl:attribute>
            <svrl:text>
        [UIAS-ID-00051][Error] There can only be one saml:Attribute with any given @Name
    </svrl:text>
            <svrl:text>
        Use the context to look for prior siblings with the same name. Fail if any are found. 
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M60"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">UIAS-ID-00052</xsl:attribute>
            <xsl:attribute name="name">UIAS-ID-00052</xsl:attribute>
            <svrl:text>
        [UIAS-ID-00052][Error] There can only be one and only one saml:AttributeValue in any saml:Attribute
    </svrl:text>
            <svrl:text>
        Use the context to look for prior siblings with the same name. Fail if any are found. 
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M61"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">UIAS-ID-00053</xsl:attribute>
            <xsl:attribute name="name">UIAS-ID-00053</xsl:attribute>
            <svrl:text> 
        [UIAS-ID-00053][Error] The RoleOrg value of the C2S &amp; PAAS role taxonomy appended with the prefix "USA." 
        MUST be a value found in CVEnumUSAgencyAcronym.xml. </svrl:text>
            <svrl:text> 
        Tokenize on space to get all the roles for each role tokenize on - to get the parts, 
        verify the 1st part is C2S or PAAS if so verify the 2nd part appended with "USA." prefix is in USAgency.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M62"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">UIAS-ID-00056</xsl:attribute>
            <xsl:attribute name="name">UIAS-ID-00056</xsl:attribute>
            <svrl:text> [UIAS-ID-00056][Warning] The saml:Attribute/@Name SHOULD be in the CVE CVEnumUIASSchemaTypes.xml unless it is a local/extended attribute.</svrl:text>
            <svrl:text>  
            Given the AttributeName, lookup that name in the SchemaTypes to make sure it's a valid AttributeName</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M63"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">UIAS-ID-00057</xsl:attribute>
            <xsl:attribute name="name">UIAS-ID-00057</xsl:attribute>
            <svrl:text> [UIAS-ID-00057][Error] The xsi:type of a UIAS attribute MUST match the description for that attribute 
        Name in CVEnumUIASSchemaTypes.xml</svrl:text>
            <svrl:text>  
        Determine the xsi:type of the AttributeValue and check against the correct xsi:type for that AttributeName in the schema </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M64"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">UIAS-ID-00065</xsl:attribute>
            <xsl:attribute name="name">UIAS-ID-00065</xsl:attribute>
            <svrl:text>
        [UIAS-ID-00065][Error] The saml:Attribute[@Name='countryOfAffiliation']/saml:AttributeValue element cannot have "NATO" as a value.
        
        Human Readable: The SAML AttributeValue element of a SAML Attribute element with attribute Name='countryOfAffiliation' 
        cannot have NATO as a value.
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M65"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">UIAS-ID-00066</xsl:attribute>
            <xsl:attribute name="name">UIAS-ID-00066</xsl:attribute>
            <svrl:text> [UIAS-ID-00066][Error] If the xsi:type defined is in the CVEnumUIASSchemaType CVE, 
    then the FriendlyName must be the concatenated string of the UIAS URN ('urn:us:gov:ic:uias:') and the Name.</svrl:text>
            <svrl:text> If @xsi:type is a type defined in the CVEnumUIASSchemaType CVE, then @FriendlyName must be the concatenated
    string of the UIAS URN ('urn:us:gov:ic:uias:') and @Name. </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M66"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">UIAS-ID-00067</xsl:attribute>
            <xsl:attribute name="name">UIAS-ID-00067</xsl:attribute>
            <svrl:text>
        [UIAS-ID-00067][Warning] uias:DESVersion attribute SHOULD be specified as version 202111 (Version:2021-NOV) with an optional extension.
    </svrl:text>
            <svrl:text>
        This rule supports extending the version identifier with an optional trailing hyphen
        and up to 23 additional characters. The version must match the regular expression
        “^202111(-.{1,23})?$".
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M67"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">UIAS-ID-00068</xsl:attribute>
            <xsl:attribute name="name">UIAS-ID-00068</xsl:attribute>
            <svrl:text>
        [UIAS-ID-00068][Error] SCI control values (with at least one or more "-") must have its hierarchical parent value
        (without the last "-xxx") in the same list.
    </svrl:text>
            <svrl:text>
        Every SCI token in saml:AttributeValue that has at least one "-" must have its hierarchical parent value which
        is the substring before the last "-" be in the token list.
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M68"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">UIAS-ID-00069</xsl:attribute>
            <xsl:attribute name="name">UIAS-ID-00069</xsl:attribute>
            <svrl:text>This abstract pattern
      verifies that a value at a given context matches a value in a list using regular expression matching. 
      The calling rule must pass the context, search term list, attribute value to check, and an error message.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M69"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">UIAS-ID-00070</xsl:attribute>
            <xsl:attribute name="name">UIAS-ID-00070</xsl:attribute>
            <svrl:text>This abstract pattern
      verifies that a value at a given context matches a value in a list using regular expression matching. 
      The calling rule must pass the context, search term list, attribute value to check, and an error message.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M70"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">UIAS-ID-00071</xsl:attribute>
            <xsl:attribute name="name">UIAS-ID-00071</xsl:attribute>
            <svrl:text> [UIAS-ID-00071][Error] The
        saml:Attribute[@Name='topic']/saml:AttributeValue element MUST have "ANY". Human Readable:
        IF the 'Topic' attribute is present, the 'ANY' element MUST be provided. </svrl:text>
            <svrl:text> The saml:Attribute[@Name='topic']/saml:AttributeValue element MUST have at
        least 2 values. Human Readable: IF the 'Topic' attribute is present, there MUST be at least
        2 values provided.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M71"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">UIAS-ID-00072</xsl:attribute>
            <xsl:attribute name="name">UIAS-ID-00072</xsl:attribute>
            <svrl:text> [UIAS-ID-00072][Error] The
        saml:Attribute[@Name='region']/saml:AttributeValue element MUST have "ANAN". Human Readable:
        IF the 'Region' attribute is present, the 'ANAN' element MUST be provided. </svrl:text>
            <svrl:text> The saml:Attribute[@Name='region']/saml:AttributeValue element MUST have at
        least 2 values. Human Readable: IF the 'Region' attribute is present, there MUST be at least
        2 values provided.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M72"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">UIAS-ID-00073</xsl:attribute>
            <xsl:attribute name="name">UIAS-ID-00073</xsl:attribute>
            <svrl:text>
        This abstract pattern checks to see if the validation environment has at least the version / revision
        of the CVE as of the writing of this specification. The calling rule must pass in '201804', 
        'AUTHCAT', '../../CVE/AUTHCAT/CVEnumAuthCatType.xml', 'UIAS-ID-00073'.
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M73"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">UIAS-ID-00074</xsl:attribute>
            <xsl:attribute name="name">UIAS-ID-00074</xsl:attribute>
            <svrl:text>
        This abstract pattern checks to see if the validation environment has at least the version / revision
        of the CVE as of the writing of this specification. The calling rule must pass in '201909', 
        'FAC', '../../CVE/FAC/CVEnumFineAccessControlType.xml', 'UIAS-ID-00074'.
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M74"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">UIAS-ID-00075</xsl:attribute>
            <xsl:attribute name="name">UIAS-ID-00075</xsl:attribute>
            <svrl:text>
        This abstract pattern checks to see if the validation environment has at least the version / revision
        of the CVE as of the writing of this specification. The calling rule must pass in '201909', 
        'IC-GENC', '../../CVE/IC-GENC/CVEnumGENCCountryCode.xml', 'UIAS-ID-00075'.
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M75"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">UIAS-ID-00076</xsl:attribute>
            <xsl:attribute name="name">UIAS-ID-00076</xsl:attribute>
            <svrl:text>
        This abstract pattern checks to see if the validation environment has at least the version / revision
        of the CVE as of the writing of this specification. The calling rule must pass in '201705.201903', 
        'MN', '../../CVE/MN/CVEnumMNRegion.xml', 'UIAS-ID-00076'.
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M76"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">UIAS-ID-00077</xsl:attribute>
            <xsl:attribute name="name">UIAS-ID-00077</xsl:attribute>
            <svrl:text>
        This abstract pattern checks to see if the validation environment has at least the version / revision
        of the CVE as of the writing of this specification. The calling rule must pass in '202111', 
        'ROLE', '../../CVE/ROLE/CVEnumROLEC2SFunction.xml', 'UIAS-ID-00077'.
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M77"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">UIAS-ID-00078</xsl:attribute>
            <xsl:attribute name="name">UIAS-ID-00078</xsl:attribute>
            <svrl:text>
        This abstract pattern checks to see if the validation environment has at least the version / revision
        of the CVE as of the writing of this specification. The calling rule must pass in '201703.201802', 
        'USAgency', '../../CVE/USAgency/CVEnumUSAgencyAcronym.xml', 'UIAS-ID-00078'.
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M78"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">UIAS-ID-00079</xsl:attribute>
            <xsl:attribute name="name">UIAS-ID-00079</xsl:attribute>
            <svrl:text>
        This abstract pattern checks to see if the validation environment has at least the version / revision of the
        Schema as of the writing of this specification. 
        The calling rule must pass in '202010', 'VIRT', '../../Schema/VIRT/VIRT.xsd', 'UIAS-ID-00079'.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M79"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">UIAS-ID-00080</xsl:attribute>
            <xsl:attribute name="name">UIAS-ID-00080</xsl:attribute>
            <svrl:text>
        [UIAS-ID-00080][Error] All SAR tokens in fineAccessControls MUST conform to the regex 
        ^SAR-[A-Z]{3,}:((C|S|TS):){0,1}[A-Za-z0-9._-]{1,}$ . Human Readable:  All SAR tokens in fineAccessControls must conform to
        a regular expression for: SAR-SourceAuthority:Classification:SAPmarking or SAR-SourceAuthority:SAPmarking.
    </svrl:text>
            <svrl:text>
        For all SAR tokens within fineAccessControls, this rule ensures that each token follows the regex
        ^SAR-[A-Z]{3,}:((C|S|TS):){0,1}[A-Za-z0-9._-]{1,}$ . The rule looks for UIAS saml:Attribute elements
        that have attribute Name='fineAccessControls' and that contain SAR fineAccessControls identified by
        'SAR-'.  Next,, a variable $nonmatchingTokens is created that takes all the SAR tokens in the saml
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M80"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">UIAS-ID-00081</xsl:attribute>
            <xsl:attribute name="name">UIAS-ID-00081</xsl:attribute>
            <svrl:text>
        This abstract pattern checks to see if an embedded string within an attribute of an element exists
        in a list or matches the pattern defined by the list. The calling rule must pass the
        context, search term list, attribute value to check, the substring to start after, the substring to stop before, a prefix,
        and an error message.  The logic excludes tokens that do not start with 'SAR-'.  Example from SAR tokens in fineAccessControls 
        is SAR-DOD:TS:DEMOSAP1.  The string DOD must be found in the SAR Source Authorities CVE.
        </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M81"/>
      </svrl:schematron-output>
   </xsl:template>

   <!--SCHEMATRON PATTERNS-->
<xsl:param name="certificateAuthorityList"
              select="document('../../CVE/UIAS/CVEnumUIASCertificateAuthority.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>
   <xsl:param name="clearanceList"
              select="document('../../CVE/UIAS/CVEnumUIASClearance.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>
   <xsl:param name="entityTypeList"
              select="document('../../CVE/UIAS/CVEnumUIASEntityType.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>
   <xsl:param name="personEntityList"
              select="document('../../CVE/UIAS/CVEnumUIASPersonEntityType.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>
   <xsl:param name="nonPersonEntityList"
              select="document('../../CVE/UIAS/CVEnumUIASNonPersonEntityType.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>
   <xsl:param name="lifeCycleStatusList"
              select="document('../../CVE/UIAS/CVEnumUIASLifeCycleStatus.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>
   <xsl:param name="handlingControlsList"
              select="document('../../CVE/UIAS/CVEnumUIASHandlingControls.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>
   <xsl:param name="usAgencyList"
              select="document('../../CVE/USAgency/CVEnumUSAgencyAcronym.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>
   <xsl:param name="facList"
              select="document('../../CVE/FAC/CVEnumFineAccessControlType.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>
   <xsl:param name="SARSourceAuthorityList"
              select="document('../../CVE/FAC/CVEnumFACSARAuthorities.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>
   <xsl:param name="authcatList"
              select="document('../../CVE/AUTHCAT/CVEnumAuthCatType.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>
   <xsl:param name="regionList"
              select="document('../../CVE/MN/CVEnumMNRegion.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>
   <xsl:param name="topicList"
              select="document('../../CVE/MN/CVEnumMNIssue.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>
   <xsl:param name="respEntList"
              select="document('../../CVE/ISMCAT/CVEnumISMCATResponsibleEntity.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>
   <xsl:param name="networkList"
              select="document('../../CVE/VIRT/CVEnumVIRTNetworkName.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>
   <xsl:param name="dissemList"
              select="document('../../CVE/ISM/CVEnumISMDissem.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>
   <xsl:param name="auditRoutingOrgList"
              select="document('../../CVE/USAgency/CVEnumAuditRoutingOrg.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>
   <xsl:param name="schemaTypeList"
              select="document('../../CVE/UIAS/CVEnumUIASSchemaType.xml')//cve:CVE/cve:Enumeration/cve:Term"/>
   <xsl:param name="roleC2SScopeList"
              select="document('../../CVE/ROLE/CVEnumROLEC2SScope.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>
   <xsl:param name="rolePAASScopeList"
              select="document('../../CVE/ROLE/CVEnumROLEPAASScope.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>
   <xsl:param name="roleNebulaNamedRoleList"
              select="document('../../CVE/ROLE/CVEnumROLENebulaNamedRole.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>
   <xsl:param name="roleEnterpriseRoleList"
              select="document('../../CVE/ROLE/CVEnumROLEEnterpriseRole.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>
   <xsl:param name="roleNameSpaceList"
              select="document('../../CVE/ROLE/CVEnumROLENamespace.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>
   <xsl:param name="roleC2SFunctionList"
              select="document('../../CVE/ROLE/CVEnumROLEC2SFunction.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>
   <xsl:param name="rolePAASFunctionList"
              select="document('../../CVE/ROLE/CVEnumROLEPAASFunction.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>

   <!--PATTERN UIAS-ID-00001-->


	<!--RULE UIAS-ID-00001-R1-->
<xsl:template match="saml:AttributeStatement" priority="1000" mode="M37">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="saml:AttributeStatement"
                       id="UIAS-ID-00001-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="saml:Attribute[@Name='adminOrganization']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="saml:Attribute[@Name='adminOrganization']">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [UIAS-ID-00001][Error] The element with @Name=adminOrganization must be present.
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

   <!--PATTERN UIAS-ID-00004-->


	<!--RULE UIAS-ID-00004-R1-->
<xsl:template match="saml:AttributeStatement[saml:Attribute[@Name='ATOStatus']]/saml:Attribute[@Name='entityType']"
                 priority="1000"
                 mode="M38">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="saml:AttributeStatement[saml:Attribute[@Name='ATOStatus']]/saml:Attribute[@Name='entityType']"
                       id="UIAS-ID-00004-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="saml:AttributeValue[some $entityType in $nonPersonEntityList satisfies $entityType = normalize-space(.)]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="saml:AttributeValue[some $entityType in $nonPersonEntityList satisfies $entityType = normalize-space(.)]">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [UIAS-ID-00004][Error]  If element with @Name=ATOStatus is present, then element with @Name=entityType must 
            have one of the values in CVEnumUIASNonPersonEntityType.
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

   <!--PATTERN UIAS-ID-00005-->


	<!--RULE UIAS-ID-00005-R1-->
<xsl:template match="saml:Attribute[@Name='isICMember']"
                 priority="1000"
                 mode="M39">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="saml:Attribute[@Name='isICMember']"
                       id="UIAS-ID-00005-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="if (normalize-space(string(../saml:Attribute[@Name='aICP']/saml:AttributeValue)) = 'true')             then saml:AttributeValue['true' = normalize-space(.)]             else true()"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="if (normalize-space(string(../saml:Attribute[@Name='aICP']/saml:AttributeValue)) = 'true') then saml:AttributeValue['true' = normalize-space(.)] else true()">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [UIAS-ID-00005][Error]  If aICP is true, then isICmember must be true.
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

   <!--PATTERN UIAS-ID-00006-->


	<!--RULE UIAS-ID-00006-R1-->
<xsl:template match="saml:AttributeStatement[saml:Attribute[@Name='aICP']]/saml:Attribute[@Name='entityType']"
                 priority="1000"
                 mode="M40">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="saml:AttributeStatement[saml:Attribute[@Name='aICP']]/saml:Attribute[@Name='entityType']"
                       id="UIAS-ID-00006-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="saml:AttributeValue[some $entityType in $personEntityList satisfies $entityType = tokenize(normalize-space(string(.)),' ')[1]]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="saml:AttributeValue[some $entityType in $personEntityList satisfies $entityType = tokenize(normalize-space(string(.)),' ')[1]]">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [UIAS-ID-00006][Error] If an element with @Name=aICP has a value, then an element with 
            @Name=entityType must have one of the values in CVEnumUIASPersonEntityType.
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

   <!--PATTERN UIAS-ID-00007-->


	<!--RULE ValidateTokenValuesExistInNamespaceList-R1-->
<xsl:template match="saml:Attribute[@Name='role']" priority="1000" mode="M41">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="saml:Attribute[@Name='role']"
                       id="ValidateTokenValuesExistInNamespaceList-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="every $token in tokenize(normalize-space(string(saml:AttributeValue[1])), ' ')          satisfies not(tokenize(string($token), '-')[1]='C2S')           or (every $namespaceToken in tokenize(string($token), '-')[3] satisfies $namespaceToken = $roleC2SScopeList           or (some $item in $roleC2SScopeList satisfies (matches(normalize-space($namespaceToken), concat('^',$item,'$')))))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $token in tokenize(normalize-space(string(saml:AttributeValue[1])), ' ') satisfies not(tokenize(string($token), '-')[1]='C2S') or (every $namespaceToken in tokenize(string($token), '-')[3] satisfies $namespaceToken = $roleC2SScopeList or (some $item in $roleC2SScopeList satisfies (matches(normalize-space($namespaceToken), concat('^',$item,'$')))))">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="'[UIAS-ID-00007][Error] If the element with @Name-Role uses C2S namespace, the scope value must          exist in the list of allowed C2S scope values.'"/>
                  <xsl:text/>
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

   <!--PATTERN UIAS-ID-00008-->


	<!--RULE UIAS-ID-00008-R1-->
<xsl:template match="saml:AttributeStatement" priority="1000" mode="M42">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="saml:AttributeStatement"
                       id="UIAS-ID-00008-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="saml:Attribute[@Name='clearance']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="saml:Attribute[@Name='clearance']">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [UIAS-ID-00008][Error] An element with @Name=clearance must be present.
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

   <!--PATTERN UIAS-ID-00009-->


	<!--RULE UIAS-ID-00009-R1-->
<xsl:template match="saml:Attribute[@Name='clearance']"
                 priority="1000"
                 mode="M43">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="saml:Attribute[@Name='clearance']"
                       id="UIAS-ID-00009-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="count(tokenize(normalize-space(string(saml:AttributeValue[1])), ' ')) &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(tokenize(normalize-space(string(saml:AttributeValue[1])), ' ')) &gt; 0">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [UIAS-ID-00009][Error] An element with @Name=clearance must have at least one value.
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

   <!--PATTERN UIAS-ID-00011-->


	<!--RULE UIAS-ID-00011-R1-->
<xsl:template match="saml:AttributeStatement" priority="1000" mode="M44">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="saml:AttributeStatement"
                       id="UIAS-ID-00011-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="saml:Attribute[@Name='countryOfAffiliation']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="saml:Attribute[@Name='countryOfAffiliation']">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [UIAS-ID-00011][Error] An element with @Name=countryOfAffiliation must be present.
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

   <!--PATTERN UIAS-ID-00012-->


	<!--RULE UIAS-ID-00012-R1-->
<xsl:template match="saml:Attribute[@Name='countryOfAffiliation']"
                 priority="1000"
                 mode="M45">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="saml:Attribute[@Name='countryOfAffiliation']"
                       id="UIAS-ID-00012-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="count(tokenize(normalize-space(string(saml:AttributeValue[1])), ' ')) &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(tokenize(normalize-space(string(saml:AttributeValue[1])), ' ')) &gt; 0">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [UIAS-ID-00012][Error] An element with @Name=countryOfAffiliation must contain at least one value.
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

   <!--PATTERN UIAS-ID-00014-->


	<!--RULE UIAS-ID-00014-R1-->
<xsl:template match="saml:AttributeStatement" priority="1000" mode="M46">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="saml:AttributeStatement"
                       id="UIAS-ID-00014-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="saml:Attribute[@Name='digitalIdentifier']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="saml:Attribute[@Name='digitalIdentifier']">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [UIAS-ID-00014][Error] An element with @Name=digitalIdentifier must be present.
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

   <!--PATTERN UIAS-ID-00016-->


	<!--RULE UIAS-ID-00016-R1-->
<xsl:template match="saml:AttributeStatement" priority="1000" mode="M47">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="saml:AttributeStatement"
                       id="UIAS-ID-00016-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="saml:Attribute[@Name='dutyOrganization']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="saml:Attribute[@Name='dutyOrganization']">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [UIAS-ID-00016][Error] An element with @Name=dutyOrganization must be present.
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

   <!--PATTERN UIAS-ID-00019-->


	<!--RULE UIAS-ID-00019-R1-->
<xsl:template match="saml:AttributeStatement" priority="1000" mode="M48">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="saml:AttributeStatement"
                       id="UIAS-ID-00019-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="saml:Attribute[@Name='entityType']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="saml:Attribute[@Name='entityType']">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [UIAS-ID-00019][Error] An element with @Name=entityType must be present.
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

   <!--PATTERN UIAS-ID-00021-->


	<!--RULE ValidateTokenValuesExistenceInList-R1-->
<xsl:template match="saml:Attribute[@Name='entityType']"
                 priority="1000"
                 mode="M49">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="saml:Attribute[@Name='entityType']"
                       id="ValidateTokenValuesExistenceInList-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="every $token in tokenize(normalize-space(string(normalize-space(saml:AttributeValue))), ' ') satisfies             $token = $entityTypeList or (some $item in $entityTypeList satisfies (matches(normalize-space($token), concat('^',$item,'$'))))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $token in tokenize(normalize-space(string(normalize-space(saml:AttributeValue))), ' ') satisfies $token = $entityTypeList or (some $item in $entityTypeList satisfies (matches(normalize-space($token), concat('^',$item,'$'))))">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="' [UIAS-ID-00021][Error] The element with @Name=entityType must be a member of the UIAS internal CVEnum CVEnumUIASEntityType.  '"/>
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

   <!--PATTERN UIAS-ID-00022-->


	<!--RULE UIAS-ID-00022-R1-->
<xsl:template match="saml:Attribute[@Name='entityType']"
                 priority="1000"
                 mode="M50">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="saml:Attribute[@Name='entityType']"
                       id="UIAS-ID-00022-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="( if (saml:AttributeValue[some $entityType in $nonPersonEntityList satisfies $entityType = normalize-space(.)])              then                 (count(tokenize(normalize-space(string(../saml:Attribute[@Name='ATOStatus']/saml:AttributeValue)), ' ')) &gt; 0)             else                 true())"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="( if (saml:AttributeValue[some $entityType in $nonPersonEntityList satisfies $entityType = normalize-space(.)]) then (count(tokenize(normalize-space(string(../saml:Attribute[@Name='ATOStatus']/saml:AttributeValue)), ' ')) &gt; 0) else true())">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [UIAS-ID-00022][Error]  If element with @Name=entityType has a value of one of the values in CVEnumUIASNonPersonEntityType,
            then element with @Name=ATOStatus must have a value.
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

   <!--PATTERN UIAS-ID-00023-->


	<!--RULE UIAS-ID-00023-R1-->
<xsl:template match="saml:Attribute[@Name='entityType']"
                 priority="1000"
                 mode="M51">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="saml:Attribute[@Name='entityType']"
                       id="UIAS-ID-00023-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="( if (saml:AttributeValue[some $entityType in $nonPersonEntityList satisfies $entityType = normalize-space(.)])              then                 (count(tokenize(normalize-space(string(../saml:Attribute[@Name='lifeCycleStatus']/saml:AttributeValue)), ' ')) &gt; 0)             else                 true())"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="( if (saml:AttributeValue[some $entityType in $nonPersonEntityList satisfies $entityType = normalize-space(.)]) then (count(tokenize(normalize-space(string(../saml:Attribute[@Name='lifeCycleStatus']/saml:AttributeValue)), ' ')) &gt; 0) else true())">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [UIAS-ID-00023][Error]  If element with @Name=entityType has a value of one of the values in  
            CVEnumUIASNonPersonEntityType, then element with @Name=lifeCycleStatus must have a value.
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

   <!--PATTERN UIAS-ID-00024-->


	<!--RULE UIAS-ID-00024-R1-->
<xsl:template match="saml:Attribute[@Name='entityType']"
                 priority="1000"
                 mode="M52">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="saml:Attribute[@Name='entityType']"
                       id="UIAS-ID-00024-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="( if (saml:AttributeValue[some $entityType in $personEntityList satisfies $entityType = normalize-space(.)])              then                 (count(tokenize(normalize-space(string(../saml:Attribute[@Name='aICP']/saml:AttributeValue)), ' ')) &gt; 0)             else                 true())"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="( if (saml:AttributeValue[some $entityType in $personEntityList satisfies $entityType = normalize-space(.)]) then (count(tokenize(normalize-space(string(../saml:Attribute[@Name='aICP']/saml:AttributeValue)), ' ')) &gt; 0) else true())">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [UIAS-ID-00024][Error]  If element with @Name=entityType has a value of one of the values in 
            CVEnumUIASPersonEntityType, then element with @Name=aICP must have a value.
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

   <!--PATTERN UIAS-ID-00025-->


	<!--RULE UIAS-ID-00025-R1-->
<xsl:template match="saml:AttributeStatement" priority="1000" mode="M53">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="saml:AttributeStatement"
                       id="UIAS-ID-00025-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="saml:Attribute[@Name='fineAccessControls']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="saml:Attribute[@Name='fineAccessControls']">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [UIAS-ID-00025][Error] An element with @Name=fineAccessControls must be present.
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

   <!--PATTERN UIAS-ID-00026-->


	<!--RULE UIAS-ID-00026-R1-->
<xsl:template match="saml:Attribute[@Name='fineAccessControls']"
                 priority="1000"
                 mode="M54">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="saml:Attribute[@Name='fineAccessControls']"
                       id="UIAS-ID-00026-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="count(tokenize(normalize-space(string(saml:AttributeValue[1])), ' ')) &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(tokenize(normalize-space(string(saml:AttributeValue[1])), ' ')) &gt; 0">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [UIAS-ID-00026][Error] An element with @Name=fineAccessControls must contain at least one value.
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

   <!--PATTERN UIAS-ID-00028-->


	<!--RULE UIAS-ID-00028-R1-->
<xsl:template match="saml:AttributeStatement" priority="1000" mode="M55">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="saml:AttributeStatement"
                       id="UIAS-ID-00028-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="saml:Attribute[@Name='isICMember']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="saml:Attribute[@Name='isICMember']">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [UIAS-ID-00028][Error] An element with @Name=isICMember must be present.
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

   <!--PATTERN UIAS-ID-00030-->


	<!--RULE UIAS-ID-00030-R1-->
<xsl:template match="saml:AttributeStatement[saml:Attribute[@Name='lifeCycleStatus']]/saml:Attribute[@Name='entityType']"
                 priority="1000"
                 mode="M56">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="saml:AttributeStatement[saml:Attribute[@Name='lifeCycleStatus']]/saml:Attribute[@Name='entityType']"
                       id="UIAS-ID-00030-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="saml:AttributeValue[some $entityType in $nonPersonEntityList satisfies $entityType = normalize-space(.)]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="saml:AttributeValue[some $entityType in $nonPersonEntityList satisfies $entityType = normalize-space(.)]">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [UIAS-ID-00030][Error]  If element with @Name=lifeCycleStatus is present, then element with @Name=entityType must have a 
            value from CVEnumUIASNonPersonEntityType.
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

   <!--PATTERN UIAS-ID-00036-->


	<!--RULE UIAS-ID-00036-R1-->
<xsl:template match="saml:Attribute[@Name='dutyOrganizationUnit']"
                 priority="1000"
                 mode="M57">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="saml:Attribute[@Name='dutyOrganizationUnit']"
                       id="UIAS-ID-00036-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="normalize-space(string(../saml:Attribute[@Name='dutyOrganization'][1]/saml:AttributeValue)) = tokenize(normalize-space(string(saml:AttributeValue[1])),':')[1]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="normalize-space(string(../saml:Attribute[@Name='dutyOrganization'][1]/saml:AttributeValue)) = tokenize(normalize-space(string(saml:AttributeValue[1])),':')[1]">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [UIAS-ID-00036][Error] The value of element with @Name=dutyOrganizationUnit must begin with the value 
            of the element with @Name=dutyOrganization.
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

   <!--PATTERN UIAS-ID-00047-->


	<!--RULE UIAS-ID-00047-R1-->
<xsl:template match="saml:AttributeStatement" priority="1000" mode="M58">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="saml:AttributeStatement"
                       id="UIAS-ID-00047-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="saml:Attribute[@Name='auditRoutingOrganization']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="saml:Attribute[@Name='auditRoutingOrganization']">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [UIAS-ID-00047][Error] The element with @Name=auditRoutingOrganization must be present.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M58"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M58"/>
   <xsl:template match="@*|node()" priority="-2" mode="M58">
      <xsl:apply-templates select="*" mode="M58"/>
   </xsl:template>

   <!--PATTERN UIAS-ID-00050-->


	<!--RULE ValidateTokenValuesExistInNamespaceList-R1-->
<xsl:template match="saml:Attribute[@Name='role']" priority="1000" mode="M59">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="saml:Attribute[@Name='role']"
                       id="ValidateTokenValuesExistInNamespaceList-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="every $token in tokenize(normalize-space(string(saml:AttributeValue[1])), ' ')          satisfies not(tokenize(string($token), '-')[1]='PAAS')           or (every $namespaceToken in tokenize(string($token), '-')[3] satisfies $namespaceToken = $rolePAASScopeList           or (some $item in $rolePAASScopeList satisfies (matches(normalize-space($namespaceToken), concat('^',$item,'$')))))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $token in tokenize(normalize-space(string(saml:AttributeValue[1])), ' ') satisfies not(tokenize(string($token), '-')[1]='PAAS') or (every $namespaceToken in tokenize(string($token), '-')[3] satisfies $namespaceToken = $rolePAASScopeList or (some $item in $rolePAASScopeList satisfies (matches(normalize-space($namespaceToken), concat('^',$item,'$')))))">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="'[UIAS-ID-00050][Error] If the element with @Name-Role uses PAAS namespace, the scope value must          exist in the list of allowed PAAS scope values.'"/>
                  <xsl:text/>
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

   <!--PATTERN UIAS-ID-00051-->


	<!--RULE UIAS-ID-00051-R1-->
<xsl:template match="saml:Attribute[@Name=preceding-sibling::saml:Attribute/@Name]"
                 priority="1000"
                 mode="M60">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="saml:Attribute[@Name=preceding-sibling::saml:Attribute/@Name]"
                       id="UIAS-ID-00051-R1"/>

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
            [UIAS-ID-00051][Error] Duplicate saml:Attribute/@Name are not allowed. More than one of "<xsl:text/>
                  <xsl:value-of select="./@Name"/>
                  <xsl:text/>" was found.
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

   <!--PATTERN UIAS-ID-00052-->


	<!--RULE UIAS-ID-00052-R1-->
<xsl:template match="saml:Attribute[count(saml:AttributeValue)!=1]"
                 priority="1000"
                 mode="M61">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="saml:Attribute[count(saml:AttributeValue)!=1]"
                       id="UIAS-ID-00052-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="not(count(saml:AttributeValue)=0)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(count(saml:AttributeValue)=0)">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [UIAS-ID-00052][Error] A saml:AttributeValue must be specified there was not one found.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="not(count(saml:AttributeValue)&gt;1)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(count(saml:AttributeValue)&gt;1)">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [UIAS-ID-00052][Error] More than one saml:AttributeValue must not be be specified 
            there were <xsl:text/>
                  <xsl:value-of select="count(saml:AttributeValue)"/>
                  <xsl:text/> found.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M61"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M61"/>
   <xsl:template match="@*|node()" priority="-2" mode="M61">
      <xsl:apply-templates select="*" mode="M61"/>
   </xsl:template>

   <!--PATTERN UIAS-ID-00053-->


	<!--RULE UIAS-ID-00053-R1-->
<xsl:template match="saml:Attribute[@Name = 'role']" priority="1000" mode="M62">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="saml:Attribute[@Name = 'role']"
                       id="UIAS-ID-00053-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="every $token in tokenize(normalize-space(string(saml:AttributeValue[1])), ' ')                           satisfies (not(tokenize(string($token), '-')[1]='C2S') and not(tokenize(string($token), '-')[1]='PAAS') )              or             (every $C2SorPAAStoken in tokenize(string($token), '-')[2] satisfies                  concat('USA.', $C2SorPAAStoken) = $usAgencyList                  or (some $item in $usAgencyList satisfies (matches(normalize-space(concat('USA.', $C2SorPAAStoken)), concat('^',$item,'$')))))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $token in tokenize(normalize-space(string(saml:AttributeValue[1])), ' ') satisfies (not(tokenize(string($token), '-')[1]='C2S') and not(tokenize(string($token), '-')[1]='PAAS') ) or (every $C2SorPAAStoken in tokenize(string($token), '-')[2] satisfies concat('USA.', $C2SorPAAStoken) = $usAgencyList or (some $item in $usAgencyList satisfies (matches(normalize-space(concat('USA.', $C2SorPAAStoken)), concat('^',$item,'$')))))">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
            [UIAS-ID-00053][Error] The RoleOrg value of the C2S &amp; PAAS role taxonomy appended with the prefix "USA." 
            MUST be a value found in CVEnumUSAgencyAcronym.xml. </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M62"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M62"/>
   <xsl:template match="@*|node()" priority="-2" mode="M62">
      <xsl:apply-templates select="*" mode="M62"/>
   </xsl:template>

   <!--PATTERN UIAS-ID-00056-->


	<!--RULE UIAS-ID-00056-R1-->
<xsl:template match="saml:Attribute" priority="1000" mode="M63">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="saml:Attribute"
                       id="UIAS-ID-00056-R1"/>
      <xsl:variable name="attributeName" select="./@Name"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="$attributeName = $schemaTypeList//cve:Value or (some $item in $schemaTypeList//cve:Value satisfies (matches(normalize-space($attributeName), concat('^',$item,'$'))))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="$attributeName = $schemaTypeList//cve:Value or (some $item in $schemaTypeList//cve:Value satisfies (matches(normalize-space($attributeName), concat('^',$item,'$'))))">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> [UIAS-ID-00056][Warning] The saml:Attribute/@Name SHOULD be in the CVE CVEnumUIASSchemaTypes.xml 
            <xsl:text/>
                  <xsl:value-of select="$attributeName"/>
                  <xsl:text/> was not in CVEnumUIASSchemaTypes it MAY be a local/extended attribute. </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M63"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M63"/>
   <xsl:template match="@*|node()" priority="-2" mode="M63">
      <xsl:apply-templates select="*" mode="M63"/>
   </xsl:template>

   <!--PATTERN UIAS-ID-00057-->


	<!--RULE UIAS-ID-00057-R1-->
<xsl:template match="saml:Attribute" priority="1000" mode="M64">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="saml:Attribute"
                       id="UIAS-ID-00057-R1"/>
      <xsl:variable name="attributeName" select="./@Name"/>
      <xsl:variable name="type" select="./saml:AttributeValue[1]/@xsi:type"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="some $item in $schemaTypeList satisfies (                         (matches(normalize-space($attributeName), concat('^',$item//cve:Value,'$'))) and                         (matches(normalize-space($type), concat('^',$item//cve:Description,'$')))                         ) or                         not(some $item in $schemaTypeList satisfies (                         (matches(normalize-space($attributeName), concat('^',$item//cve:Value,'$')))                         ))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="some $item in $schemaTypeList satisfies ( (matches(normalize-space($attributeName), concat('^',$item//cve:Value,'$'))) and (matches(normalize-space($type), concat('^',$item//cve:Description,'$'))) ) or not(some $item in $schemaTypeList satisfies ( (matches(normalize-space($attributeName), concat('^',$item//cve:Value,'$'))) ))">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> [UIAS-ID-00057][Error] The saml:Attribute/@Name MUST be in the CVE CVEnumUIASSchemaTypes.xml associated with the description matching the xsi:type
           </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M64"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M64"/>
   <xsl:template match="@*|node()" priority="-2" mode="M64">
      <xsl:apply-templates select="*" mode="M64"/>
   </xsl:template>

   <!--PATTERN UIAS-ID-00065-->


	<!--RULE UIAS-ID-00065-R1-->
<xsl:template match="saml:Attribute[@Name='countryOfAffiliation']/saml:AttributeValue"
                 priority="1000"
                 mode="M65">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="saml:Attribute[@Name='countryOfAffiliation']/saml:AttributeValue"
                       id="UIAS-ID-00065-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="not(contains(normalize-space(.),'NATO'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(contains(normalize-space(.),'NATO'))">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [UIAS-ID-00065][Error] The saml:Attribute[@Name='countryOfAffiliation']/saml:AttributeValue element cannot have "NATO" as a value.
            
            Human Readable: The SAML AttributeValue element of a SAML Attribute element with attribute Name='countryOfAffiliation' 
            cannot have NATO as a value.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M65"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M65"/>
   <xsl:template match="@*|node()" priority="-2" mode="M65">
      <xsl:apply-templates select="*" mode="M65"/>
   </xsl:template>

   <!--PATTERN UIAS-ID-00066-->


	<!--RULE UIAS-ID-00066-R1-->
<xsl:template match="saml:Attribute" priority="1000" mode="M66">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="saml:Attribute"
                       id="UIAS-ID-00066-R1"/>
      <xsl:variable name="attributeName" select="./@Name"/>
      <xsl:variable name="uiasURN" select="'urn:us:gov:ic:uias:'"/>
      <xsl:variable name="attributeFriendlyName" select="./@FriendlyName"/>
      <xsl:variable name="type" select="./saml:AttributeValue[1]/@xsi:type"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="if (some $item in $schemaTypeList satisfies (matches(normalize-space($type), concat('^',$item//cve:Description,'$'))))                   then not(compare($attributeFriendlyName, concat($uiasURN, $attributeName)))                   else true()"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="if (some $item in $schemaTypeList satisfies (matches(normalize-space($type), concat('^',$item//cve:Description,'$')))) then not(compare($attributeFriendlyName, concat($uiasURN, $attributeName))) else true()">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> [UIAS-ID-00066][Error] If the xsi:type defined is in the CVEnumUIASSchemaType CVE, 
            then the FriendlyName must be the concatenated string of the UIAS URN ('urn:us:gov:ic:uias:') and the Name.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M66"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M66"/>
   <xsl:template match="@*|node()" priority="-2" mode="M66">
      <xsl:apply-templates select="*" mode="M66"/>
   </xsl:template>

   <!--PATTERN UIAS-ID-00067-->


	<!--RULE UIAS-ID-00067-R1-->
<xsl:template match="*[@uias:DESVersion]" priority="1000" mode="M67">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[@uias:DESVersion]"
                       id="UIAS-ID-00067-R1"/>

		    <!--ASSERT warning-->
<xsl:choose>
         <xsl:when test="matches(@uias:DESVersion,'^202111(\-.{1,23})?$')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="matches(@uias:DESVersion,'^202111(\-.{1,23})?$')">
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [UIAS-ID-00067][Warning] uias:DESVersion attribute SHOULD be specified as version 202111 (Version:2021-NOV) with an optional extension. 
            Found <xsl:text/>
                  <xsl:value-of select="@uias:DESVersion"/>
                  <xsl:text/>.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M67"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M67"/>
   <xsl:template match="@*|node()" priority="-2" mode="M67">
      <xsl:apply-templates select="*" mode="M67"/>
   </xsl:template>

   <!--PATTERN UIAS-ID-00068-->


	<!--RULE UIAS-ID-00068-R1-->
<xsl:template match="saml:Attribute[@Name='fineAccessControls']"
                 priority="1000"
                 mode="M68">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="saml:Attribute[@Name='fineAccessControls']"
                       id="UIAS-ID-00068-R1"/>
      <xsl:variable name="tokenList"
                    select="tokenize(normalize-space(string(./saml:AttributeValue)), ' ')"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="every $evaluatedToken in $tokenList satisfies              if (not(matches($evaluatedToken, 'SAR-')) and not(matches($evaluatedToken, 'NATO-'))             and matches($evaluatedToken, '-'))             then util:existInTokenSet(util:substring-before-last($evaluatedToken, '-'), $tokenList)             else true()"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $evaluatedToken in $tokenList satisfies if (not(matches($evaluatedToken, 'SAR-')) and not(matches($evaluatedToken, 'NATO-')) and matches($evaluatedToken, '-')) then util:existInTokenSet(util:substring-before-last($evaluatedToken, '-'), $tokenList) else true()">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [UIAS-ID-00068][Error] SCI control values (with at least one or more "-") must have its hierarchical parent value
            (without the last "-xxx") in the same list.      
            Some token in <xsl:text/>
                  <xsl:value-of select="$tokenList"/>
                  <xsl:text/> is missing its hierarchical parent value
            (without the last "-xxx").
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M68"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M68"/>
   <xsl:template match="@*|node()" priority="-2" mode="M68">
      <xsl:apply-templates select="*" mode="M68"/>
   </xsl:template>

   <!--PATTERN UIAS-ID-00069-->


	<!--RULE ValidateTokenValuesExistInNamespaceList-R1-->
<xsl:template match="saml:Attribute[@Name='role']" priority="1000" mode="M69">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="saml:Attribute[@Name='role']"
                       id="ValidateTokenValuesExistInNamespaceList-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="every $token in tokenize(normalize-space(string(saml:AttributeValue[1])), ' ')          satisfies not(tokenize(string($token), '-')[1]='ENT')           or (every $namespaceToken in tokenize(string($token), '-')[3] satisfies $namespaceToken = $roleEnterpriseRoleList           or (some $item in $roleEnterpriseRoleList satisfies (matches(normalize-space($namespaceToken), concat('^',$item,'$')))))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $token in tokenize(normalize-space(string(saml:AttributeValue[1])), ' ') satisfies not(tokenize(string($token), '-')[1]='ENT') or (every $namespaceToken in tokenize(string($token), '-')[3] satisfies $namespaceToken = $roleEnterpriseRoleList or (some $item in $roleEnterpriseRoleList satisfies (matches(normalize-space($namespaceToken), concat('^',$item,'$')))))">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="'[UIAS-ID-00069][Error] If the element with @Name-Role uses ENT namespace, the scope value must          exist in the list of allowed ENT scope values.'"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M69"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M69"/>
   <xsl:template match="@*|node()" priority="-2" mode="M69">
      <xsl:apply-templates select="*" mode="M69"/>
   </xsl:template>

   <!--PATTERN UIAS-ID-00070-->


	<!--RULE ValidateTokenValuesExistInNamespaceList-R1-->
<xsl:template match="saml:Attribute[@Name='role']" priority="1000" mode="M70">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="saml:Attribute[@Name='role']"
                       id="ValidateTokenValuesExistInNamespaceList-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="every $token in tokenize(normalize-space(string(saml:AttributeValue[1])), ' ')          satisfies not(tokenize(string($token), '-')[1]='Nebula')           or (every $namespaceToken in tokenize(string($token), '-')[3] satisfies $namespaceToken = $roleNebulaNamedRoleList           or (some $item in $roleNebulaNamedRoleList satisfies (matches(normalize-space($namespaceToken), concat('^',$item,'$')))))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $token in tokenize(normalize-space(string(saml:AttributeValue[1])), ' ') satisfies not(tokenize(string($token), '-')[1]='Nebula') or (every $namespaceToken in tokenize(string($token), '-')[3] satisfies $namespaceToken = $roleNebulaNamedRoleList or (some $item in $roleNebulaNamedRoleList satisfies (matches(normalize-space($namespaceToken), concat('^',$item,'$')))))">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="'[UIAS-ID-00070][Error] If the element with @Name-Role uses Nebula namespace, the scope value must          exist in the list of allowed Nebula scope values.'"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M70"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M70"/>
   <xsl:template match="@*|node()" priority="-2" mode="M70">
      <xsl:apply-templates select="*" mode="M70"/>
   </xsl:template>

   <!--PATTERN UIAS-ID-00071-->


	<!--RULE UIAS-ID-00071-R1-->
<xsl:template match="saml:Attribute[@Name = 'topic']/saml:AttributeValue"
                 priority="1000"
                 mode="M71">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="saml:Attribute[@Name = 'topic']/saml:AttributeValue"
                       id="UIAS-ID-00071-R1"/>
      <xsl:variable name="valueText" select="normalize-space(.)"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="contains($valueText, 'ANY')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="contains($valueText, 'ANY')">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [UIAS-ID-00071][Error] IF the 'Topic' attribute is present, the 'ANY' element MUST be
            provided. </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="count(tokenize($valueText, ' ')) &gt; 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(tokenize($valueText, ' ')) &gt; 1">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [UIAS-ID-00071][Error] IF the 'Topic' attribute is present, there MUST be at least 2
            values provided. </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M71"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M71"/>
   <xsl:template match="@*|node()" priority="-2" mode="M71">
      <xsl:apply-templates select="*" mode="M71"/>
   </xsl:template>

   <!--PATTERN UIAS-ID-00072-->


	<!--RULE UIAS-ID-00072-R1-->
<xsl:template match="saml:Attribute[@Name = 'region']/saml:AttributeValue"
                 priority="1000"
                 mode="M72">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="saml:Attribute[@Name = 'region']/saml:AttributeValue"
                       id="UIAS-ID-00072-R1"/>
      <xsl:variable name="valueText" select="normalize-space(.)"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="contains($valueText, 'ANAN')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="contains($valueText, 'ANAN')">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [UIAS-ID-00072][Error] IF the 'Region' attribute is present, the 'ANAN' element MUST be
            provided. </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="count(tokenize($valueText, ' ')) &gt; 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(tokenize($valueText, ' ')) &gt; 1">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [UIAS-ID-00072][Error] IF the 'Region' attribute is present, there MUST be at least 2
            values provided. </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M72"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M72"/>
   <xsl:template match="@*|node()" priority="-2" mode="M72">
      <xsl:apply-templates select="*" mode="M72"/>
   </xsl:template>

   <!--PATTERN UIAS-ID-00073-->


	<!--RULE ValidateValidationEnvCVE-R1-->
<xsl:template match="/" priority="1000" mode="M73">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/"
                       id="ValidateValidationEnvCVE-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="document('../../CVE/AUTHCAT/CVEnumAuthCatType.xml')//cve:CVE//@specVersion castable as xs:double              and document('../../CVE/AUTHCAT/CVEnumAuthCatType.xml')//cve:CVE//@specVersion &gt;= '201804'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('../../CVE/AUTHCAT/CVEnumAuthCatType.xml')//cve:CVE//@specVersion castable as xs:double and document('../../CVE/AUTHCAT/CVEnumAuthCatType.xml')//cve:CVE//@specVersion &gt;= '201804'">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
            [<xsl:text/>
                  <xsl:value-of select="'UIAS-ID-00073'"/>
                  <xsl:text/>][Error] Version [ <xsl:text/>
                  <xsl:value-of select="document('../../CVE/AUTHCAT/CVEnumAuthCatType.xml')//cve:CVE//@specVersion"/>
                  <xsl:text/> ] of <xsl:text/>
                  <xsl:value-of select="'AUTHCAT'"/>
                  <xsl:text/> found; 
            Version [<xsl:text/>
                  <xsl:value-of select="'201804'"/>
                  <xsl:text/>] or later is required. The latest version of <xsl:text/>
                  <xsl:value-of select="'AUTHCAT'"/>
                  <xsl:text/> 
            is not being used in the validation infrastructure. Regardless of the version indicated on the instance document, 
            the validation infrastructure needs to use a version of <xsl:text/>
                  <xsl:value-of select="'AUTHCAT'"/>
                  <xsl:text/> that is
            version [<xsl:text/>
                  <xsl:value-of select="'201804'"/>
                  <xsl:text/>] or later. NOTE: This is not an error of the instance
            document but of the validation environment itself. The incorrect value was found in <xsl:text/>
                  <xsl:value-of select="document-uri(document('../../CVE/AUTHCAT/CVEnumAuthCatType.xml'))"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M73"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M73"/>
   <xsl:template match="@*|node()" priority="-2" mode="M73">
      <xsl:apply-templates select="*" mode="M73"/>
   </xsl:template>

   <!--PATTERN UIAS-ID-00074-->


	<!--RULE ValidateValidationEnvCVE-R1-->
<xsl:template match="/" priority="1000" mode="M74">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/"
                       id="ValidateValidationEnvCVE-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="document('../../CVE/FAC/CVEnumFineAccessControlType.xml')//cve:CVE//@specVersion castable as xs:double              and document('../../CVE/FAC/CVEnumFineAccessControlType.xml')//cve:CVE//@specVersion &gt;= '201909'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('../../CVE/FAC/CVEnumFineAccessControlType.xml')//cve:CVE//@specVersion castable as xs:double and document('../../CVE/FAC/CVEnumFineAccessControlType.xml')//cve:CVE//@specVersion &gt;= '201909'">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
            [<xsl:text/>
                  <xsl:value-of select="'UIAS-ID-00074'"/>
                  <xsl:text/>][Error] Version [ <xsl:text/>
                  <xsl:value-of select="document('../../CVE/FAC/CVEnumFineAccessControlType.xml')//cve:CVE//@specVersion"/>
                  <xsl:text/> ] of <xsl:text/>
                  <xsl:value-of select="'FAC'"/>
                  <xsl:text/> found; 
            Version [<xsl:text/>
                  <xsl:value-of select="'201909'"/>
                  <xsl:text/>] or later is required. The latest version of <xsl:text/>
                  <xsl:value-of select="'FAC'"/>
                  <xsl:text/> 
            is not being used in the validation infrastructure. Regardless of the version indicated on the instance document, 
            the validation infrastructure needs to use a version of <xsl:text/>
                  <xsl:value-of select="'FAC'"/>
                  <xsl:text/> that is
            version [<xsl:text/>
                  <xsl:value-of select="'201909'"/>
                  <xsl:text/>] or later. NOTE: This is not an error of the instance
            document but of the validation environment itself. The incorrect value was found in <xsl:text/>
                  <xsl:value-of select="document-uri(document('../../CVE/FAC/CVEnumFineAccessControlType.xml'))"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M74"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M74"/>
   <xsl:template match="@*|node()" priority="-2" mode="M74">
      <xsl:apply-templates select="*" mode="M74"/>
   </xsl:template>

   <!--PATTERN UIAS-ID-00075-->


	<!--RULE ValidateValidationEnvCVE-R1-->
<xsl:template match="/" priority="1000" mode="M75">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/"
                       id="ValidateValidationEnvCVE-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="document('../../CVE/IC-GENC/CVEnumGENCCountryCode.xml')//cve:CVE//@specVersion castable as xs:double              and document('../../CVE/IC-GENC/CVEnumGENCCountryCode.xml')//cve:CVE//@specVersion &gt;= '201909'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('../../CVE/IC-GENC/CVEnumGENCCountryCode.xml')//cve:CVE//@specVersion castable as xs:double and document('../../CVE/IC-GENC/CVEnumGENCCountryCode.xml')//cve:CVE//@specVersion &gt;= '201909'">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
            [<xsl:text/>
                  <xsl:value-of select="'UIAS-ID-00075'"/>
                  <xsl:text/>][Error] Version [ <xsl:text/>
                  <xsl:value-of select="document('../../CVE/IC-GENC/CVEnumGENCCountryCode.xml')//cve:CVE//@specVersion"/>
                  <xsl:text/> ] of <xsl:text/>
                  <xsl:value-of select="'IC-GENC'"/>
                  <xsl:text/> found; 
            Version [<xsl:text/>
                  <xsl:value-of select="'201909'"/>
                  <xsl:text/>] or later is required. The latest version of <xsl:text/>
                  <xsl:value-of select="'IC-GENC'"/>
                  <xsl:text/> 
            is not being used in the validation infrastructure. Regardless of the version indicated on the instance document, 
            the validation infrastructure needs to use a version of <xsl:text/>
                  <xsl:value-of select="'IC-GENC'"/>
                  <xsl:text/> that is
            version [<xsl:text/>
                  <xsl:value-of select="'201909'"/>
                  <xsl:text/>] or later. NOTE: This is not an error of the instance
            document but of the validation environment itself. The incorrect value was found in <xsl:text/>
                  <xsl:value-of select="document-uri(document('../../CVE/IC-GENC/CVEnumGENCCountryCode.xml'))"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M75"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M75"/>
   <xsl:template match="@*|node()" priority="-2" mode="M75">
      <xsl:apply-templates select="*" mode="M75"/>
   </xsl:template>

   <!--PATTERN UIAS-ID-00076-->


	<!--RULE ValidateValidationEnvCVE-R1-->
<xsl:template match="/" priority="1000" mode="M76">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/"
                       id="ValidateValidationEnvCVE-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="document('../../CVE/MN/CVEnumMNRegion.xml')//cve:CVE//@specVersion castable as xs:double              and document('../../CVE/MN/CVEnumMNRegion.xml')//cve:CVE//@specVersion &gt;= '201705.201903'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('../../CVE/MN/CVEnumMNRegion.xml')//cve:CVE//@specVersion castable as xs:double and document('../../CVE/MN/CVEnumMNRegion.xml')//cve:CVE//@specVersion &gt;= '201705.201903'">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
            [<xsl:text/>
                  <xsl:value-of select="'UIAS-ID-00076'"/>
                  <xsl:text/>][Error] Version [ <xsl:text/>
                  <xsl:value-of select="document('../../CVE/MN/CVEnumMNRegion.xml')//cve:CVE//@specVersion"/>
                  <xsl:text/> ] of <xsl:text/>
                  <xsl:value-of select="'MN'"/>
                  <xsl:text/> found; 
            Version [<xsl:text/>
                  <xsl:value-of select="'201705.201903'"/>
                  <xsl:text/>] or later is required. The latest version of <xsl:text/>
                  <xsl:value-of select="'MN'"/>
                  <xsl:text/> 
            is not being used in the validation infrastructure. Regardless of the version indicated on the instance document, 
            the validation infrastructure needs to use a version of <xsl:text/>
                  <xsl:value-of select="'MN'"/>
                  <xsl:text/> that is
            version [<xsl:text/>
                  <xsl:value-of select="'201705.201903'"/>
                  <xsl:text/>] or later. NOTE: This is not an error of the instance
            document but of the validation environment itself. The incorrect value was found in <xsl:text/>
                  <xsl:value-of select="document-uri(document('../../CVE/MN/CVEnumMNRegion.xml'))"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M76"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M76"/>
   <xsl:template match="@*|node()" priority="-2" mode="M76">
      <xsl:apply-templates select="*" mode="M76"/>
   </xsl:template>

   <!--PATTERN UIAS-ID-00077-->


	<!--RULE ValidateValidationEnvCVE-R1-->
<xsl:template match="/" priority="1000" mode="M77">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/"
                       id="ValidateValidationEnvCVE-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="document('../../CVE/ROLE/CVEnumROLEC2SFunction.xml')//cve:CVE//@specVersion castable as xs:double              and document('../../CVE/ROLE/CVEnumROLEC2SFunction.xml')//cve:CVE//@specVersion &gt;= '202111'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('../../CVE/ROLE/CVEnumROLEC2SFunction.xml')//cve:CVE//@specVersion castable as xs:double and document('../../CVE/ROLE/CVEnumROLEC2SFunction.xml')//cve:CVE//@specVersion &gt;= '202111'">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
            [<xsl:text/>
                  <xsl:value-of select="'UIAS-ID-00077'"/>
                  <xsl:text/>][Error] Version [ <xsl:text/>
                  <xsl:value-of select="document('../../CVE/ROLE/CVEnumROLEC2SFunction.xml')//cve:CVE//@specVersion"/>
                  <xsl:text/> ] of <xsl:text/>
                  <xsl:value-of select="'ROLE'"/>
                  <xsl:text/> found; 
            Version [<xsl:text/>
                  <xsl:value-of select="'202111'"/>
                  <xsl:text/>] or later is required. The latest version of <xsl:text/>
                  <xsl:value-of select="'ROLE'"/>
                  <xsl:text/> 
            is not being used in the validation infrastructure. Regardless of the version indicated on the instance document, 
            the validation infrastructure needs to use a version of <xsl:text/>
                  <xsl:value-of select="'ROLE'"/>
                  <xsl:text/> that is
            version [<xsl:text/>
                  <xsl:value-of select="'202111'"/>
                  <xsl:text/>] or later. NOTE: This is not an error of the instance
            document but of the validation environment itself. The incorrect value was found in <xsl:text/>
                  <xsl:value-of select="document-uri(document('../../CVE/ROLE/CVEnumROLEC2SFunction.xml'))"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M77"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M77"/>
   <xsl:template match="@*|node()" priority="-2" mode="M77">
      <xsl:apply-templates select="*" mode="M77"/>
   </xsl:template>

   <!--PATTERN UIAS-ID-00078-->


	<!--RULE ValidateValidationEnvCVE-R1-->
<xsl:template match="/" priority="1000" mode="M78">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/"
                       id="ValidateValidationEnvCVE-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="document('../../CVE/USAgency/CVEnumUSAgencyAcronym.xml')//cve:CVE//@specVersion castable as xs:double              and document('../../CVE/USAgency/CVEnumUSAgencyAcronym.xml')//cve:CVE//@specVersion &gt;= '201703.201802'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('../../CVE/USAgency/CVEnumUSAgencyAcronym.xml')//cve:CVE//@specVersion castable as xs:double and document('../../CVE/USAgency/CVEnumUSAgencyAcronym.xml')//cve:CVE//@specVersion &gt;= '201703.201802'">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
            [<xsl:text/>
                  <xsl:value-of select="'UIAS-ID-00078'"/>
                  <xsl:text/>][Error] Version [ <xsl:text/>
                  <xsl:value-of select="document('../../CVE/USAgency/CVEnumUSAgencyAcronym.xml')//cve:CVE//@specVersion"/>
                  <xsl:text/> ] of <xsl:text/>
                  <xsl:value-of select="'USAgency'"/>
                  <xsl:text/> found; 
            Version [<xsl:text/>
                  <xsl:value-of select="'201703.201802'"/>
                  <xsl:text/>] or later is required. The latest version of <xsl:text/>
                  <xsl:value-of select="'USAgency'"/>
                  <xsl:text/> 
            is not being used in the validation infrastructure. Regardless of the version indicated on the instance document, 
            the validation infrastructure needs to use a version of <xsl:text/>
                  <xsl:value-of select="'USAgency'"/>
                  <xsl:text/> that is
            version [<xsl:text/>
                  <xsl:value-of select="'201703.201802'"/>
                  <xsl:text/>] or later. NOTE: This is not an error of the instance
            document but of the validation environment itself. The incorrect value was found in <xsl:text/>
                  <xsl:value-of select="document-uri(document('../../CVE/USAgency/CVEnumUSAgencyAcronym.xml'))"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M78"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M78"/>
   <xsl:template match="@*|node()" priority="-2" mode="M78">
      <xsl:apply-templates select="*" mode="M78"/>
   </xsl:template>

   <!--PATTERN UIAS-ID-00079-->


	<!--RULE ValidateValidationEnvSchema-R1-->
<xsl:template match="/" priority="1000" mode="M79">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/"
                       id="ValidateValidationEnvSchema-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="document('../../Schema/VIRT/VIRT.xsd')//xsd:schema//@version castable as xs:double              and document('../../Schema/VIRT/VIRT.xsd')//xsd:schema//@version &gt;= '202010'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('../../Schema/VIRT/VIRT.xsd')//xsd:schema//@version castable as xs:double and document('../../Schema/VIRT/VIRT.xsd')//xsd:schema//@version &gt;= '202010'">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
            [<xsl:text/>
                  <xsl:value-of select="'UIAS-ID-00079'"/>
                  <xsl:text/>][Error] Version [ <xsl:text/>
                  <xsl:value-of select="document('../../Schema/VIRT/VIRT.xsd')//xsd:schema//@version"/>
                  <xsl:text/> ] of <xsl:text/>
                  <xsl:value-of select="'VIRT'"/>
                  <xsl:text/> found; 
            Version [<xsl:text/>
                  <xsl:value-of select="'202010'"/>
                  <xsl:text/>] or later is required. The latest version of <xsl:text/>
                  <xsl:value-of select="'VIRT'"/>
                  <xsl:text/> 
            is not being used in the validation infrastructure. Regardless of the version indicated on the instance document, 
            the validation infrastructure needs to use a version of <xsl:text/>
                  <xsl:value-of select="'VIRT'"/>
                  <xsl:text/> that is
            version [<xsl:text/>
                  <xsl:value-of select="'202010'"/>
                  <xsl:text/>] or later. NOTE: This is not an error of the instance
            document but of the validation environment itself. The incorrect value was found in <xsl:text/>
                  <xsl:value-of select="document-uri(document('../../Schema/VIRT/VIRT.xsd'))"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M79"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M79"/>
   <xsl:template match="@*|node()" priority="-2" mode="M79">
      <xsl:apply-templates select="*" mode="M79"/>
   </xsl:template>

   <!--PATTERN UIAS-ID-00080-->


	<!--RULE UIAS-ID-00080-R1-->
<xsl:template match="saml:Attribute[@Name='fineAccessControls'][contains(./saml:AttributeValue,'SAR-')]"
                 priority="1000"
                 mode="M80">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="saml:Attribute[@Name='fineAccessControls'][contains(./saml:AttributeValue,'SAR-')]"
                       id="UIAS-ID-00080-R1"/>
      <xsl:variable name="nonmatchingTokens"
                    select="for $token in tokenize(normalize-space(string(./saml:AttributeValue)), ' ')              return if (starts-with($token,'SAR-') and             not(matches($token,'^SAR-[A-Z]{3,}:((C|S|TS):){0,1}[A-Za-z0-9._-]{1,}$'))) then $token else null"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="count($nonmatchingTokens) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count($nonmatchingTokens) = 0">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [UIAS-ID-00080][Error] All SAR tokens in the fineAccessControls attribute MUST conform to the regex 
            ^SAR-[A-Z]{3,}:((C|S|TS):){0,1}[A-Za-z0-9._-]{1,}$ . Human Readable:  All SAR tokens in fineAccessControls must conform to
            a regular expression for: SAR-SourceAuthority:Classification:SAPmarking or SAR-SourceAuthority:SAPmarking.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M80"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M80"/>
   <xsl:template match="@*|node()" priority="-2" mode="M80">
      <xsl:apply-templates select="*" mode="M80"/>
   </xsl:template>

   <!--PATTERN UIAS-ID-00081-->


	<!--RULE ValidateEmbeddedValueExistenceInList-R1-->
<xsl:template match="saml:Attribute[@Name='fineAccessControls'][contains(./saml:AttributeValue,'SAR-')]"
                 priority="1000"
                 mode="M81">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="saml:Attribute[@Name='fineAccessControls'][contains(./saml:AttributeValue,'SAR-')]"
                       id="ValidateEmbeddedValueExistenceInList-R1"/>

		    <!--ASSERT error-->
<xsl:choose>
         <xsl:when test="every $searchTerm in tokenize(normalize-space(string(./saml:AttributeValue)), ' ') satisfies not(starts-with($searchTerm,'SAR-')) or             ((substring-before((substring-after($searchTerm,'SAR-')),':')) = $SARSourceAuthorityList              or (some $Term in $SARSourceAuthorityList satisfies (matches(substring-before(substring-after(normalize-space($searchTerm),'SAR-'),':'), concat('^', $Term ,'$')))))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $searchTerm in tokenize(normalize-space(string(./saml:AttributeValue)), ' ') satisfies not(starts-with($searchTerm,'SAR-')) or ((substring-before((substring-after($searchTerm,'SAR-')),':')) = $SARSourceAuthorityList or (some $Term in $SARSourceAuthorityList satisfies (matches(substring-before(substring-after(normalize-space($searchTerm),'SAR-'),':'), concat('^', $Term ,'$')))))">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="'[UIAS-ID-00081][Error] The SAR tokens in fineAccessControls must start with a substring after SAR- and before : that exists         in the SAR Source Authorities CVE. Example from SAR tokens in fineAccessControls is SAR-DOD:TS:DEMOSAP1. The string DOD must be         found in the SAR Source Authorities CVE. Human Readable:  The SAR tokens in fineAccessControls must contain a substring         between after the SAR- and before the first : in the pattern SAR-SourceAuthority:Classification:SAPmarking or          SAR-SourceAuthority-SARValue; this substring must be found in the SAR Source Authorities CVE.          Example SAR-DOD:TS:DEMOSAP1. The string DOD must be found in the SAR Source Authorities CVE. '"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M81"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M81"/>
   <xsl:template match="@*|node()" priority="-2" mode="M81">
      <xsl:apply-templates select="*" mode="M81"/>
   </xsl:template>
</xsl:stylesheet>
<!--UNCLASSIFIED-->
