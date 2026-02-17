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
                xmlns:ntk="urn:us:gov:ic:ntk"
                xmlns:edh="urn:us:gov:ic:edh"
                xmlns:arh="urn:us:gov:ic:arh"
                xmlns:icid="urn:us:gov:ic:id"
                xmlns:usagency="urn:us:gov:ic:usagency"
                xmlns:util="urn:us:gov:ic:edh:xsl:util"
                xmlns:functx="http://www.functx.com"
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
      <xsl:value-of select="       some $attrToken in tokenize(normalize-space(string($attribute)), ' ') satisfies         $attrToken = $tokenList       "/>
  </xsl:function>
   <xsl:function xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                 name="functx:next-day"
                 as="xs:date?">
      <xsl:param name="date" as="xs:anyAtomicType?"/>

      <xsl:sequence select="              xs:date($date) + xs:dayTimeDuration('P1D')             "/>
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
         <svrl:ns-prefix-in-attribute-values uri="urn:us:gov:ic:pubs" prefix="pubs"/>
         <svrl:ns-prefix-in-attribute-values uri="urn:us:gov:ic:cve" prefix="cve"/>
         <svrl:ns-prefix-in-attribute-values uri="http://www.w3.org/1999/xlink" prefix="xlink"/>
         <svrl:ns-prefix-in-attribute-values uri="urn:us:gov:ic:ism" prefix="ism"/>
         <svrl:ns-prefix-in-attribute-values uri="urn:us:gov:ic:ntk" prefix="ntk"/>
         <svrl:ns-prefix-in-attribute-values uri="urn:us:gov:ic:edh" prefix="edh"/>
         <svrl:ns-prefix-in-attribute-values uri="urn:us:gov:ic:arh" prefix="arh"/>
         <svrl:ns-prefix-in-attribute-values uri="urn:us:gov:ic:id" prefix="icid"/>
         <svrl:ns-prefix-in-attribute-values uri="urn:us:gov:ic:usagency" prefix="usagency"/>
         <svrl:ns-prefix-in-attribute-values uri="urn:us:gov:ic:edh:xsl:util" prefix="util"/>
         <svrl:ns-prefix-in-attribute-values uri="http://www.w3.org/2001/XMLSchema" prefix="xs"/>
         <svrl:ns-prefix-in-attribute-values uri="http://www.functx.com" prefix="functx"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-EDH-ID-00001</xsl:attribute>
            <xsl:attribute name="name">IC-EDH-ID-00001</xsl:attribute>
            <svrl:text>
        [IC-EDH-ID-00001][Error]
        Every attribute in the EDH namespace must have a non-whitespace value.
        
        Human Readable: All attributes in the EDH namespace must specify a value.
    </svrl:text>
            <svrl:text>
        Make sure any attribute in the EDH namespace has a value if it is present.
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M15"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-EDH-ID-00002</xsl:attribute>
            <xsl:attribute name="name">IC-EDH-ID-00002</xsl:attribute>
            <svrl:text>
        [IC-EDH-ID-00002][Error] The attribute 
        DESVersion in the namespace urn:us:gov:ic:edh must be specified.
        
        Human Readable: The data encoding specification version number must
        be specified.
    </svrl:text>
            <svrl:text>
        Make sure that the attribute edh:DESVersion 
        is specified.
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M16"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-EDH-ID-00003</xsl:attribute>
            <xsl:attribute name="name">IC-EDH-ID-00003</xsl:attribute>
            <svrl:text>
        [IC-EDH-ID-00003][Error] The dataItemCreateDateTime must not be later the
        ism:createDate.
        
        Human Readable: Data items cannot be newer than their security markings.
    </svrl:text>
            <svrl:text>
        For EDH element DataItemCreateDateTime, ensure that the sibling ARH element 
        (Security or ExternalSecurity) has ism:createDate that is not older than the
        data item itself. This comparison is done strictly on the date, and to 
        compensate for the loss of using time, the ism:createDate is incremented one
        day and less than, not less than or equal to. 
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M17"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-EDH-ID-00004</xsl:attribute>
            <xsl:attribute name="name">IC-EDH-ID-00004</xsl:attribute>
            <svrl:text>
        [IC-EDH-ID-00004][Error] The EDH elements cannot be used as root elements.
        
        Human Readable: EDH is not designed to stand-alone and therefore should never
        be used as a root element.
    </svrl:text>
            <svrl:text>
        This rule is to ensure edh:Edh or edh:ExternalEdh are not used as the root element.
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M18"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-EDH-ID-00005</xsl:attribute>
            <xsl:attribute name="name">IC-EDH-ID-00005</xsl:attribute>
            <svrl:text>
        [IC-EDH-ID-00005][Error]
        Every element in the EDH namespace must have a non-whitespace value.
        
        Human Readable: All elements in the EDH namespace must specify a value. 
    </svrl:text>
            <svrl:text>
        Make sure any element in the EDH namespace has a value if it is present.
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M19"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-EDH-ID-00006</xsl:attribute>
            <xsl:attribute name="name">IC-EDH-ID-00006</xsl:attribute>
            <svrl:text>This abstract pattern checks to see if an attribute of an element exists
        in a list. The calling rule must pass edh:Country[.='USA'], following-sibling::edh:Organization, $usagencyList, '         [IC-EDH-ID-00006][Error]         If the Country of the ResponsibleEntity is [USA] then the value of          Organization must be a term from the USAgency CES.                  Human Readable: If the Country element contains USA, the agency in the Organization         element must be defined in the USAgency CES.         '.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M20"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-EDH-ID-00008</xsl:attribute>
            <xsl:attribute name="name">IC-EDH-ID-00008</xsl:attribute>
            <svrl:text>
        [IC-EDH-ID-00008][Error] The @ism:DESVersion is less than the minimum version 
        allowed: 13. 
        
        Human Readable: The ISM version imported by IC-EDH must be greater than or equal to 13. 
    </svrl:text>
            <svrl:text>
        For all elements that contain @ism:DESVersion, this rule verifies that the version
        is greater than or equal to the minimum allowed version: 13.  
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M21"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-EDH-ID-00009</xsl:attribute>
            <xsl:attribute name="name">IC-EDH-ID-00009</xsl:attribute>
            <svrl:text>
        [IC-EDH-ID-00009][Error] The @arh:DESVersion is less than the minimum version 
        allowed: 3. 
        
        Human Readable: The ARH version imported by IC-EDH must be greater than or equal to 3. 
    </svrl:text>
            <svrl:text>
        For all elements that contain @arh:DESVersion, this rule verifies that the version
        is greater than or equal to the minimum allowed version: 3.  
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M22"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-EDH-ID-00010</xsl:attribute>
            <xsl:attribute name="name">IC-EDH-ID-00010</xsl:attribute>
            <svrl:text>
        [IC-EDH-ID-00010][Error] The @ntk:DESVersion is less than the minimum version 
        allowed: 10. 
        
        Human Readable: The NTK version imported by IC-EDH must be greater than or equal to 10. 
    </svrl:text>
            <svrl:text>
        For all elements that contain @ntk:DESVersion, this rule verifies that the version
        is greater than or equal to the minimum allowed version: 10.  
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M23"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-EDH-ID-00011</xsl:attribute>
            <xsl:attribute name="name">IC-EDH-ID-00011</xsl:attribute>
            <svrl:text>
        [IC-EDH-ID-00011][Error] The @icid:DESVersion is less than the minimum version 
        allowed: 1. 
        
        Human Readable: The IC-ID version imported by IC-EDH must be greater than or equal to 1. 
    </svrl:text>
            <svrl:text>
        For all edh:Edh elements that contain @icid:DESVersion, this rule verifies that the version
        is greater than or equal to the minimum allowed version: 1.  
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M24"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-EDH-ID-00012</xsl:attribute>
            <xsl:attribute name="name">IC-EDH-ID-00012</xsl:attribute>
            <svrl:text>[IC-EDH-ID-00012][Error] The @usagency:CESVersion is less than the minimum version allowed:
      201502.
   
      Human Readable: The USAgency version imported by IC-EDH must be greater than or equal to 2015-FEB.
   </svrl:text>
            <svrl:text>For all edh:Edh and edh:ExternalEdh elements that contain @usagency:CESVersion, this rule
      verifies that the version is greater than or equal to the minimum allowed version: 201502.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M25"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-EDH-ID-00013</xsl:attribute>
            <xsl:attribute name="name">IC-EDH-ID-00013</xsl:attribute>
            <svrl:text>
        [IC-EDH-ID-00013][Error] Element edh:DataItemCreateDateTime of type xs:dateTime must have a timezone.
        
        Human Readable: The EDH element DataItemCreateDateTime must have a timezone. 
    </svrl:text>
            <svrl:text>
        The EDH element edh:DataItemCreateDateTime must have a timezone. 
        According to http://www.w3.org/TR/xmlschema-2/#dateTime, datetime is represented by: 
        '-'? yyyy '-' mm '-' dd 'T' hh ':' mm ':' ss ('.' s+)? (zzzzzz)?
        where the timezone zzzzzz is represented by:
        (('+' | '-') hh ':' mm) | 'Z'
        This rule enforces and makes the timezone zzzzzz mandatory.
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M26"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-EDH-ID-00014</xsl:attribute>
            <xsl:attribute name="name">IC-EDH-ID-00014</xsl:attribute>
            <svrl:text>[IC-EDH-ID-00014][Error] The @ism:ISMCATCESVersion is less than the minimum version allowed:
        201505.
    
        Human Readable: The ISMCAT version imported by IC-EDH must be greater than or equal to 2015-MAY.
    </svrl:text>
            <svrl:text>For all edh:Edh and edh:ExternalEdh elements that contain @ism:ISMCATCESVersion, this rule
        verifies that the version is greater than or equal to the minimum allowed version: 201505.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M27"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IC-EDH-ID-00015</xsl:attribute>
            <xsl:attribute name="name">IC-EDH-ID-00015</xsl:attribute>
            <svrl:text>
        [IC-EDH-ID-00015][Error] There must be one and only one edh:ResponsibleEntity element where role="Custodian"
        There may be zero or one edh:ResponsibleEntity element where role="Originator"
        
        Human Readable: There must be only one and only one edh:ResponsibleEntity element with the role "Custodian."
        Additionally, there may be zero or one edh:ResponsibleEntity element with the role "Originator."
    </svrl:text>
            <svrl:text>
        
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M28"/>
      </svrl:schematron-output>
   </xsl:template>

   <!--SCHEMATRON PATTERNS-->
<xsl:param name="usagencyList"
              select="document('../../CVE/USAgency/CVEnumUSAgencyAcronym.xml')//cve:CVE/cve:Enumeration/cve:Term/cve:Value"/>

   <!--PATTERN IC-EDH-ID-00001-->


	<!--RULE -->
<xsl:template match="*[@edh:*]" priority="1000" mode="M15">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="*[@edh:*]"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="every $attribute in @edh:* satisfies                     normalize-space(string($attribute))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $attribute in @edh:* satisfies normalize-space(string($attribute))">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [IC-EDH-ID-00001][Error]
            Every attribute in the EDH namespace must have a non-whitespace value.
            
            Human Readable: All attributes in the EDH namespace must specify a value.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M15"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M15"/>
   <xsl:template match="@*|node()" priority="-2" mode="M15">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M15"/>
   </xsl:template>

   <!--PATTERN IC-EDH-ID-00002-->


	<!--RULE -->
<xsl:template match="/" priority="1000" mode="M16">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="some $element in descendant-or-self::node() satisfies $element/@edh:DESVersion"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="some $element in descendant-or-self::node() satisfies $element/@edh:DESVersion">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [IC-EDH-ID-00002][Error] The attribute 
            DESVersion in the namespace urn:us:gov:ic:edh must be specified.
            
            Human Readable: The data encoding specification version must 
            be specified.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M16"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M16"/>
   <xsl:template match="@*|node()" priority="-2" mode="M16">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M16"/>
   </xsl:template>

   <!--PATTERN IC-EDH-ID-00003-->


	<!--RULE -->
<xsl:template match="edh:DataItemCreateDateTime[following-sibling::arh:*/@ism:createDate]"
                 priority="1000"
                 mode="M17">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="edh:DataItemCreateDateTime[following-sibling::arh:*/@ism:createDate]"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="xsd:date(substring-before(xsd:string(.),'T')) &lt; functx:next-day(following-sibling::arh:*/@ism:createDate)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="xsd:date(substring-before(xsd:string(.),'T')) &lt; functx:next-day(following-sibling::arh:*/@ism:createDate)">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [IC-EDH-ID-00003][Error] The dataItemCreateDateTime must not be later the
            ism:createDate.
            
            Human Readable: Data items cannot be newer than their security markings.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M17"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M17"/>
   <xsl:template match="@*|node()" priority="-2" mode="M17">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M17"/>
   </xsl:template>

   <!--PATTERN IC-EDH-ID-00004-->


	<!--RULE -->
<xsl:template match="/edh:*" priority="1000" mode="M18">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/edh:*"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="false()"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [IC-EDH-ID-00004][Error] The EDH elements cannot be used as root elements.
            
            Human Readable: EDH is not designed to stand-alone and therefore should never
            be used as a root element.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M18"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M18"/>
   <xsl:template match="@*|node()" priority="-2" mode="M18">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M18"/>
   </xsl:template>

   <!--PATTERN IC-EDH-ID-00005-->


	<!--RULE -->
<xsl:template match="edh:*" priority="1000" mode="M19">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="edh:*"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="normalize-space(.)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="normalize-space(.)">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [IC-EDH-ID-00005][Error]
            Every element in the EDH namespace must have a non-whitespace value.
            
            Human Readable: All elements in the EDH namespace must specify a value. 
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M19"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M19"/>
   <xsl:template match="@*|node()" priority="-2" mode="M19">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M19"/>
   </xsl:template>

   <!--PATTERN IC-EDH-ID-00006-->


	<!--RULE -->
<xsl:template match="edh:Country[.='USA']" priority="1000" mode="M20">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="edh:Country[.='USA']"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="some $token in $usagencyList satisfies $token = following-sibling::edh:Organization"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="some $token in $usagencyList satisfies $token = following-sibling::edh:Organization">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="'         [IC-EDH-ID-00006][Error]         If the Country of the ResponsibleEntity is [USA] then the value of          Organization must be a term from the USAgency CES.                  Human Readable: If the Country element contains USA, the agency in the Organization         element must be defined in the USAgency CES.         '"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M20"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M20"/>
   <xsl:template match="@*|node()" priority="-2" mode="M20">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M20"/>
   </xsl:template>

   <!--PATTERN IC-EDH-ID-00008-->


	<!--RULE -->
<xsl:template match="*[@ism:DESVersion]" priority="1000" mode="M21">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="*[@ism:DESVersion]"/>
      <xsl:variable name="version"
                    select="number(if (contains(@ism:DESVersion,'-')) then substring-before(@ism:DESVersion,'-') else @ism:DESVersion)"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="$version &gt;= 13"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="$version &gt;= 13">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [IC-EDH-ID-00008][Error] The @ism:DESVersion is less than the minimum version 
            allowed: 13. 
            
            Human Readable: The ISM version imported by IC-EDH must be greater than or equal to 13.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M21"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M21"/>
   <xsl:template match="@*|node()" priority="-2" mode="M21">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M21"/>
   </xsl:template>

   <!--PATTERN IC-EDH-ID-00009-->


	<!--RULE -->
<xsl:template match="*[@arh:DESVersion]" priority="1000" mode="M22">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="*[@arh:DESVersion]"/>
      <xsl:variable name="version"
                    select="number(if (contains(@arh:DESVersion,'-')) then substring-before(@arh:DESVersion,'-') else @arh:DESVersion)"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="$version &gt;= 3"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="$version &gt;= 3">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [IC-EDH-ID-00009][Error] The @arh:DESVersion is less than the minimum version 
            allowed: 3. 

            Human Readable: The ARH version imported by IC-EDH must be greater than or equal to 3.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M22"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M22"/>
   <xsl:template match="@*|node()" priority="-2" mode="M22">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M22"/>
   </xsl:template>

   <!--PATTERN IC-EDH-ID-00010-->


	<!--RULE -->
<xsl:template match="*[@ntk:DESVersion]" priority="1000" mode="M23">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="*[@ntk:DESVersion]"/>
      <xsl:variable name="version"
                    select="number(if (contains(@ntk:DESVersion,'-')) then substring-before(@ntk:DESVersion,'-') else @ntk:DESVersion)"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="$version &gt;= 10"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="$version &gt;= 10">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [IC-EDH-ID-00010][Error] The @ntk:DESVersion is less than the minimum version 
            allowed: 10. 

            Human Readable: The NTK version imported by IC-EDH must be greater than or equal to 10.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M23"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M23"/>
   <xsl:template match="@*|node()" priority="-2" mode="M23">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M23"/>
   </xsl:template>

   <!--PATTERN IC-EDH-ID-00011-->


	<!--RULE -->
<xsl:template match="edh:Edh[@icid:DESVersion]" priority="1000" mode="M24">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="edh:Edh[@icid:DESVersion]"/>
      <xsl:variable name="version"
                    select="number(if (contains(@icid:DESVersion,'-')) then substring-before(@icid:DESVersion,'-') else @icid:DESVersion)"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="$version &gt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="$version &gt;= 1">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [IC-EDH-ID-00011][Error] The @icid:DESVersion is less than the minimum version 
            allowed: 1. 
                      
            Human Readable: The IC-ID version imported by IC-EDH must be greater than or equal to 1.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M24"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M24"/>
   <xsl:template match="@*|node()" priority="-2" mode="M24">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M24"/>
   </xsl:template>

   <!--PATTERN IC-EDH-ID-00012-->


	<!--RULE -->
<xsl:template match="edh:Edh[@usagency:CESVersion] | edh:ExternalEdh[@usagency:CESVersion]"
                 priority="1000"
                 mode="M25">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="edh:Edh[@usagency:CESVersion] | edh:ExternalEdh[@usagency:CESVersion]"/>
      <xsl:variable name="version"
                    select="number(if (contains(@usagency:CESVersion,'-')) then substring-before(@usagency:CESVersion,'-') else @usagency:CESVersion)"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="$version &gt;= 201502"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="$version &gt;= 201502">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IC-EDH-ID-00012][Error] The @usagency:CESVersion is less
         than the minimum version allowed: 201502.
      
         Human Readable: The USAgency version imported by IC-EDH must be greater than or equal to 2015-FEB.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M25"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M25"/>
   <xsl:template match="@*|node()" priority="-2" mode="M25">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M25"/>
   </xsl:template>

   <!--PATTERN IC-EDH-ID-00013-->


	<!--RULE -->
<xsl:template match="edh:DataItemCreateDateTime" priority="1000" mode="M26">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="edh:DataItemCreateDateTime"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="matches(., '^-?\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(\.\d+)?(((\+|-)\d{2}:\d{2})|Z)$')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="matches(., '^-?\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(\.\d+)?(((\+|-)\d{2}:\d{2})|Z)$')">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [IC-EDH-ID-00013][Error] edh:DataItemCreateDateTime of type xs:dateTime must have a timezone.
            
            Human Readable: The EDH element DataItemCreateDateTime must have a timezone.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M26"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M26"/>
   <xsl:template match="@*|node()" priority="-2" mode="M26">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M26"/>
   </xsl:template>

   <!--PATTERN IC-EDH-ID-00014-->


	<!--RULE -->
<xsl:template match="edh:Edh[@ism:ISMCATCESVersion] | edh:ExternalEdh[@ism:ISMCATCESVersion]"
                 priority="1000"
                 mode="M27">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="edh:Edh[@ism:ISMCATCESVersion] | edh:ExternalEdh[@ism:ISMCATCESVersion]"/>
      <xsl:variable name="version"
                    select="number(if (contains(@ism:ISMCATCESVersion,'-')) then substring-before(@ism:ISMCATCESVersion,'-') else @ism:ISMCATCESVersion)"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="$version &gt;= 201505"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="$version &gt;= 201505">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IC-EDH-ID-00014][Error] The @ism:ISMCATCESVersion is less
            than the minimum version allowed: 201505.
        
            Human Readable: The ISMCAT version imported by IC-EDH must be greater than or equal to 2015-MAY.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M27"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M27"/>
   <xsl:template match="@*|node()" priority="-2" mode="M27">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M27"/>
   </xsl:template>

   <!--PATTERN IC-EDH-ID-00015-->


	<!--RULE -->
<xsl:template match="edh:Edh" priority="1001" mode="M28">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="edh:Edh"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(./edh:ResponsibleEntity[@edh:role='Custodian']) = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(./edh:ResponsibleEntity[@edh:role='Custodian']) = 1">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [IC-EDH-ID-00015][Error] There must be one and only one edh:ResponsibleEntity element where role="Custodian"
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(./edh:ResponsibleEntity[@edh:role='Originator']) &lt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(./edh:ResponsibleEntity[@edh:role='Originator']) &lt;= 1">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [IC-EDH-ID-00015][Error] There may be zero or one edh:ResponsibleEntity element where role="Originator"
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M28"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="edh:ExternalEdh" priority="1000" mode="M28">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="edh:ExternalEdh"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(./edh:ResponsibleEntity[@edh:role='Custodian']) = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(./edh:ResponsibleEntity[@edh:role='Custodian']) = 1">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [IC-EDH-ID-00015][Error] There must be one and only one edh:ResponsibleEntity element where role="Custodian"
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(./edh:ResponsibleEntity[@edh:role='Originator']) &lt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(./edh:ResponsibleEntity[@edh:role='Originator']) &lt;= 1">
               <xsl:attribute name="flag">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [IC-EDH-ID-00015][Error] There may be zero or one edh:ResponsibleEntity element where role="Originator"
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M28"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M28"/>
   <xsl:template match="@*|node()" priority="-2" mode="M28">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M28"/>
   </xsl:template>
</xsl:stylesheet>
<!--UNCLASSIFIED-->
