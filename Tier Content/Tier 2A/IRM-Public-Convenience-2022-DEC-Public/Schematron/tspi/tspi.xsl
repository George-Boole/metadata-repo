<?xml version="1.0" encoding="UTF-8"?>
<!--UNCLASSIFIED--><xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:schold="http://www.ascc.net/xml/schematron"
                xmlns:iso="http://purl.oclc.org/dsdl/schematron"
                xmlns:xhtml="http://www.w3.org/1999/xhtml"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                xmlns:gml="http://www.opengis.net/gml/3.2"
                xmlns:gmlce="http://www.opengis.net/gml/3.2/ce"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:ism="urn:us:gov:ic:ism"
                xmlns:tspi="http://metadata.ces.mil/mdr/ns/GSIP/tspi/2.0.0"
                xmlns:tspi-core="http://metadata.ces.mil/mdr/ns/GSIP/tspi/2.0.0/core"
                xmlns:tspi-ext="http://metadata.ces.mil/mdr/ns/GSIP/tspi/2.0.0/ext"
                version="1.0"><!--Implementers: please note that overriding process-prolog or process-root is 
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
            <xsl:variable name="p_1"
                          select="1+    count(preceding-sibling::*[name()=name(current())])"/>
            <xsl:if test="$p_1&gt;1 or following-sibling::*[name()=name(current())]">[<xsl:value-of select="$p_1"/>]</xsl:if>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>*[local-name()='</xsl:text>
            <xsl:value-of select="local-name()"/>
            <xsl:text>']</xsl:text>
            <xsl:variable name="p_2"
                          select="1+   count(preceding-sibling::*[local-name()=local-name(current())])"/>
            <xsl:if test="$p_2&gt;1 or following-sibling::*[local-name()=local-name(current())]">[<xsl:value-of select="$p_2"/>]</xsl:if>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="@*" mode="schematron-get-full-path">
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
      <svrl:schematron-output xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                              title="TSPI 2.0.0 Schematron validation"
                              schemaVersion="">
         <xsl:comment>
            <xsl:value-of select="$archiveDirParameter"/>   
		 <xsl:value-of select="$archiveNameParameter"/>  
		 <xsl:value-of select="$fileNameParameter"/>  
		 <xsl:value-of select="$fileDirParameter"/>
         </xsl:comment>
         <svrl:ns-prefix-in-attribute-values uri="http://purl.oclc.org/dsdl/schematron" prefix="sch"/>
         <svrl:ns-prefix-in-attribute-values uri="http://www.opengis.net/gml/3.2" prefix="gml"/>
         <svrl:ns-prefix-in-attribute-values uri="http://www.opengis.net/gml/3.2/ce" prefix="gmlce"/>
         <svrl:ns-prefix-in-attribute-values uri="http://www.w3.org/1999/xlink" prefix="xlink"/>
         <svrl:ns-prefix-in-attribute-values uri="urn:us:gov:ic:ism" prefix="ism"/>
         <svrl:ns-prefix-in-attribute-values uri="http://metadata.ces.mil/mdr/ns/GSIP/tspi/2.0.0" prefix="tspi"/>
         <svrl:ns-prefix-in-attribute-values uri="http://metadata.ces.mil/mdr/ns/GSIP/tspi/2.0.0/core"
                                             prefix="tspi-core"/>
         <svrl:ns-prefix-in-attribute-values uri="http://metadata.ces.mil/mdr/ns/GSIP/tspi/2.0.0/ext"
                                             prefix="tspi-ext"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">PointSrsName_Valid_in_Resource</xsl:attribute>
            <xsl:attribute name="name">PointSrsName_Valid_in_Resource</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M10"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">LineStringSrsName_Valid_in_Resource</xsl:attribute>
            <xsl:attribute name="name">LineStringSrsName_Valid_in_Resource</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M11"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">CircleSrsName_Valid_in_Resource</xsl:attribute>
            <xsl:attribute name="name">CircleSrsName_Valid_in_Resource</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M12"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">EllipseSrsName_Valid_in_Resource</xsl:attribute>
            <xsl:attribute name="name">EllipseSrsName_Valid_in_Resource</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M13"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">PolygonSrsName_Valid_in_Resource</xsl:attribute>
            <xsl:attribute name="name">PolygonSrsName_Valid_in_Resource</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M14"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">SimplePolygonSrsName_Valid_in_Resource</xsl:attribute>
            <xsl:attribute name="name">SimplePolygonSrsName_Valid_in_Resource</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M15"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">SimpleRectangleSrsName_Valid_in_Resource</xsl:attribute>
            <xsl:attribute name="name">SimpleRectangleSrsName_Valid_in_Resource</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M16"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">EnvelopeSrsName_Valid_in_Resource</xsl:attribute>
            <xsl:attribute name="name">EnvelopeSrsName_Valid_in_Resource</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M17"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">CircularSurfaceSrsName_Valid_in_Resource</xsl:attribute>
            <xsl:attribute name="name">CircularSurfaceSrsName_Valid_in_Resource</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M18"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">EllipticalSurfaceSrsName_Valid_in_Resource</xsl:attribute>
            <xsl:attribute name="name">EllipticalSurfaceSrsName_Valid_in_Resource</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M19"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">PointHorizResolutionFlexibleEnum</xsl:attribute>
            <xsl:attribute name="name">PointHorizResolutionFlexibleEnum</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M20"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">QuadrangleLocationSubZoneIntegrity</xsl:attribute>
            <xsl:attribute name="name">QuadrangleLocationSubZoneIntegrity</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M21"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Acceleration_AllowableUOM</xsl:attribute>
            <xsl:attribute name="name">Acceleration_AllowableUOM</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M22"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">AmountOfSubstance_AllowableUOM</xsl:attribute>
            <xsl:attribute name="name">AmountOfSubstance_AllowableUOM</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M23"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Area_AllowableUOM</xsl:attribute>
            <xsl:attribute name="name">Area_AllowableUOM</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M24"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Capacitance_AllowableUOM</xsl:attribute>
            <xsl:attribute name="name">Capacitance_AllowableUOM</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M25"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">ElectricCharge_AllowableUOM</xsl:attribute>
            <xsl:attribute name="name">ElectricCharge_AllowableUOM</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M26"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">ElectricConductance_AllowableUOM</xsl:attribute>
            <xsl:attribute name="name">ElectricConductance_AllowableUOM</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M27"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">ElectricCurrent_AllowableUOM</xsl:attribute>
            <xsl:attribute name="name">ElectricCurrent_AllowableUOM</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M28"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">ElectricResistance_AllowableUOM</xsl:attribute>
            <xsl:attribute name="name">ElectricResistance_AllowableUOM</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M29"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">ElectromotiveForce_AllowableUOM</xsl:attribute>
            <xsl:attribute name="name">ElectromotiveForce_AllowableUOM</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M30"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Energy_AllowableUOM</xsl:attribute>
            <xsl:attribute name="name">Energy_AllowableUOM</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M31"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Force_AllowableUOM</xsl:attribute>
            <xsl:attribute name="name">Force_AllowableUOM</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M32"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Frequency_AllowableUOM</xsl:attribute>
            <xsl:attribute name="name">Frequency_AllowableUOM</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M33"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">GeopotentialEnergyLength_AllowableUOM</xsl:attribute>
            <xsl:attribute name="name">GeopotentialEnergyLength_AllowableUOM</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M34"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Illuminance_AllowableUOM</xsl:attribute>
            <xsl:attribute name="name">Illuminance_AllowableUOM</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M35"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Inductance_AllowableUOM</xsl:attribute>
            <xsl:attribute name="name">Inductance_AllowableUOM</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M36"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Irradiance_AllowableUOM</xsl:attribute>
            <xsl:attribute name="name">Irradiance_AllowableUOM</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M37"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Length_AllowableUOM</xsl:attribute>
            <xsl:attribute name="name">Length_AllowableUOM</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M38"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">LinearDensity_AllowableUOM</xsl:attribute>
            <xsl:attribute name="name">LinearDensity_AllowableUOM</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M39"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">LinearEnergyTransfer_AllowableUOM</xsl:attribute>
            <xsl:attribute name="name">LinearEnergyTransfer_AllowableUOM</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M40"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">LuminousFlux_AllowableUOM</xsl:attribute>
            <xsl:attribute name="name">LuminousFlux_AllowableUOM</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M41"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">LuminousIntensity_AllowableUOM</xsl:attribute>
            <xsl:attribute name="name">LuminousIntensity_AllowableUOM</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M42"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MagneticFlux_AllowableUOM</xsl:attribute>
            <xsl:attribute name="name">MagneticFlux_AllowableUOM</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M43"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MagneticFluxDensity_AllowableUOM</xsl:attribute>
            <xsl:attribute name="name">MagneticFluxDensity_AllowableUOM</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M44"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MagneticFluxDensityGradient_AllowableUOM</xsl:attribute>
            <xsl:attribute name="name">MagneticFluxDensityGradient_AllowableUOM</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M45"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Mass_AllowableUOM</xsl:attribute>
            <xsl:attribute name="name">Mass_AllowableUOM</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M46"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MassDensity_AllowableUOM</xsl:attribute>
            <xsl:attribute name="name">MassDensity_AllowableUOM</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M47"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MassFraction_AllowableUOM</xsl:attribute>
            <xsl:attribute name="name">MassFraction_AllowableUOM</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M48"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MassRate_AllowableUOM</xsl:attribute>
            <xsl:attribute name="name">MassRate_AllowableUOM</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M49"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NoncomparableUnit_AllowableUOM</xsl:attribute>
            <xsl:attribute name="name">NoncomparableUnit_AllowableUOM</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M50"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">PlaneAngle_AllowableUOM</xsl:attribute>
            <xsl:attribute name="name">PlaneAngle_AllowableUOM</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M51"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Power_AllowableUOM</xsl:attribute>
            <xsl:attribute name="name">Power_AllowableUOM</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M52"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">PowerLevelDifference_AllowableUOM</xsl:attribute>
            <xsl:attribute name="name">PowerLevelDifference_AllowableUOM</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M53"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">PowerLevelDiffLenGradient_AllowableUOM</xsl:attribute>
            <xsl:attribute name="name">PowerLevelDiffLenGradient_AllowableUOM</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M54"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Pressure_AllowableUOM</xsl:attribute>
            <xsl:attribute name="name">Pressure_AllowableUOM</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M55"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">PureNumber_AllowableUOM</xsl:attribute>
            <xsl:attribute name="name">PureNumber_AllowableUOM</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M56"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">RadiationAbsorbedDose_AllowableUOM</xsl:attribute>
            <xsl:attribute name="name">RadiationAbsorbedDose_AllowableUOM</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M57"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">RadiationDoseEquivalent_AllowableUOM</xsl:attribute>
            <xsl:attribute name="name">RadiationDoseEquivalent_AllowableUOM</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M58"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">RadionuclideActivity_AllowableUOM</xsl:attribute>
            <xsl:attribute name="name">RadionuclideActivity_AllowableUOM</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M59"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Rate_AllowableUOM</xsl:attribute>
            <xsl:attribute name="name">Rate_AllowableUOM</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M60"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">ReciprocalArea_AllowableUOM</xsl:attribute>
            <xsl:attribute name="name">ReciprocalArea_AllowableUOM</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M61"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">ReciprocalTime_AllowableUOM</xsl:attribute>
            <xsl:attribute name="name">ReciprocalTime_AllowableUOM</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M62"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">SolidAngle_AllowableUOM</xsl:attribute>
            <xsl:attribute name="name">SolidAngle_AllowableUOM</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M63"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">SoundSpeedRatio_AllowableUOM</xsl:attribute>
            <xsl:attribute name="name">SoundSpeedRatio_AllowableUOM</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M64"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Speed_AllowableUOM</xsl:attribute>
            <xsl:attribute name="name">Speed_AllowableUOM</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M65"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">SurfaceMassDensityRate_AllowableUOM</xsl:attribute>
            <xsl:attribute name="name">SurfaceMassDensityRate_AllowableUOM</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M66"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">ThermodynamicTemperature_AllowableUOM</xsl:attribute>
            <xsl:attribute name="name">ThermodynamicTemperature_AllowableUOM</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M67"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Time_AllowableUOM</xsl:attribute>
            <xsl:attribute name="name">Time_AllowableUOM</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M68"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Volume_AllowableUOM</xsl:attribute>
            <xsl:attribute name="name">Volume_AllowableUOM</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M69"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">VolumeFlowRate_AllowableUOM</xsl:attribute>
            <xsl:attribute name="name">VolumeFlowRate_AllowableUOM</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M70"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">VolumeFraction_AllowableUOM</xsl:attribute>
            <xsl:attribute name="name">VolumeFraction_AllowableUOM</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M71"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">TimePosition_must_not_have_InconsistentContent</xsl:attribute>
            <xsl:attribute name="name">TimePosition_must_not_have_InconsistentContent</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M72"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">TimeInstantIsolated_must_not_have_InconsistentContent</xsl:attribute>
            <xsl:attribute name="name">TimeInstantIsolated_must_not_have_InconsistentContent</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M73"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">TimePosition_must_have_ValidContent</xsl:attribute>
            <xsl:attribute name="name">TimePosition_must_have_ValidContent</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M74"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">TimePeriod_must_not_have_InconsistentEnds</xsl:attribute>
            <xsl:attribute name="name">TimePeriod_must_not_have_InconsistentEnds</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M75"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">TimePeriod_must_have_PositiveDuration</xsl:attribute>
            <xsl:attribute name="name">TimePeriod_must_have_PositiveDuration</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M76"/>
      </svrl:schematron-output>
   </xsl:template>

   <!--SCHEMATRON PATTERNS-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">TSPI 2.0.0 Schematron validation</svrl:text>
   <xsl:param name="GSIP" select="'http://metadata.ces.mil/mdr/ns/GSIP'"/>

   <!--PATTERN PointSrsName_Valid_in_Resource-->


	<!--RULE -->
<xsl:template match="tspi:Point" priority="1000" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="tspi:Point"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="starts-with(@srsName, concat($GSIP, '/crs'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="starts-with(@srsName, concat($GSIP, '/crs'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The CRS must be from the set registered in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="document(@srsName)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="document(@srsName)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The specified srsName must reference a net-accessible resource in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="concat(substring-before(@srsName, '/crs'),'/crs') = document(@srsName)//gml:identifier/@codeSpace"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="concat(substring-before(@srsName, '/crs'),'/crs') = document(@srsName)//gml:identifier/@codeSpace">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The body of the srsName must match the codeSpace of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="substring-after(@srsName, 'crs/') = document(@srsName)//gml:identifier"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="substring-after(@srsName, 'crs/') = document(@srsName)//gml:identifier">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The tail of the srsName ('<xsl:text/>
                  <xsl:value-of select="substring-after(@srsName, 'crs/')"/>
                  <xsl:text/>') must match the value of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M10"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M10"/>
   <xsl:template match="@*|node()" priority="-2" mode="M10">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M10"/>
   </xsl:template>

   <!--PATTERN LineStringSrsName_Valid_in_Resource-->


	<!--RULE -->
<xsl:template match="tspi:LineString" priority="1000" mode="M11">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="tspi:LineString"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="starts-with(@srsName, concat($GSIP, '/crs'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="starts-with(@srsName, concat($GSIP, '/crs'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The CRS must be from the set registered in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="document(@srsName)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="document(@srsName)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The specified srsName must reference a net-accessible resource in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="concat(substring-before(@srsName, '/crs'),'/crs') = document(@srsName)//gml:identifier/@codeSpace"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="concat(substring-before(@srsName, '/crs'),'/crs') = document(@srsName)//gml:identifier/@codeSpace">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The body of the srsName must match the codeSpace of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="substring-after(@srsName, 'crs/') = document(@srsName)//gml:identifier"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="substring-after(@srsName, 'crs/') = document(@srsName)//gml:identifier">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The tail of the srsName ('<xsl:text/>
                  <xsl:value-of select="substring-after(@srsName, 'crs/')"/>
                  <xsl:text/>') must match the value of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M11"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M11"/>
   <xsl:template match="@*|node()" priority="-2" mode="M11">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M11"/>
   </xsl:template>

   <!--PATTERN CircleSrsName_Valid_in_Resource-->


	<!--RULE -->
<xsl:template match="tspi:Circle" priority="1000" mode="M12">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="tspi:Circle"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="starts-with(@srsName, concat($GSIP, '/crs'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="starts-with(@srsName, concat($GSIP, '/crs'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The CRS must be from the set registered in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="document(@srsName)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="document(@srsName)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The specified srsName must reference a net-accessible resource in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="concat(substring-before(@srsName, '/crs'),'/crs') = document(@srsName)//gml:identifier/@codeSpace"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="concat(substring-before(@srsName, '/crs'),'/crs') = document(@srsName)//gml:identifier/@codeSpace">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The body of the srsName must match the codeSpace of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="substring-after(@srsName, 'crs/') = document(@srsName)//gml:identifier"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="substring-after(@srsName, 'crs/') = document(@srsName)//gml:identifier">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The tail of the srsName ('<xsl:text/>
                  <xsl:value-of select="substring-after(@srsName, 'crs/')"/>
                  <xsl:text/>') must match the value of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M12"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M12"/>
   <xsl:template match="@*|node()" priority="-2" mode="M12">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M12"/>
   </xsl:template>

   <!--PATTERN EllipseSrsName_Valid_in_Resource-->


	<!--RULE -->
<xsl:template match="tspi:Ellipse" priority="1000" mode="M13">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="tspi:Ellipse"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="starts-with(@srsName, concat($GSIP, '/crs'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="starts-with(@srsName, concat($GSIP, '/crs'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The CRS must be from the set registered in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="document(@srsName)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="document(@srsName)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The specified srsName must reference a net-accessible resource in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="concat(substring-before(@srsName, '/crs'),'/crs') = document(@srsName)//gml:identifier/@codeSpace"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="concat(substring-before(@srsName, '/crs'),'/crs') = document(@srsName)//gml:identifier/@codeSpace">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The body of the srsName must match the codeSpace of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="substring-after(@srsName, 'crs/') = document(@srsName)//gml:identifier"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="substring-after(@srsName, 'crs/') = document(@srsName)//gml:identifier">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The tail of the srsName ('<xsl:text/>
                  <xsl:value-of select="substring-after(@srsName, 'crs/')"/>
                  <xsl:text/>') must match the value of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M13"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M13"/>
   <xsl:template match="@*|node()" priority="-2" mode="M13">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M13"/>
   </xsl:template>

   <!--PATTERN PolygonSrsName_Valid_in_Resource-->


	<!--RULE -->
<xsl:template match="tspi:Polygon" priority="1000" mode="M14">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="tspi:Polygon"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="starts-with(@srsName, concat($GSIP, '/crs'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="starts-with(@srsName, concat($GSIP, '/crs'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The CRS must be from the set registered in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="document(@srsName)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="document(@srsName)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The specified srsName must reference a net-accessible resource in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="concat(substring-before(@srsName, '/crs'),'/crs') = document(@srsName)//gml:identifier/@codeSpace"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="concat(substring-before(@srsName, '/crs'),'/crs') = document(@srsName)//gml:identifier/@codeSpace">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The body of the srsName must match the codeSpace of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="substring-after(@srsName, 'crs/') = document(@srsName)//gml:identifier"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="substring-after(@srsName, 'crs/') = document(@srsName)//gml:identifier">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The tail of the srsName ('<xsl:text/>
                  <xsl:value-of select="substring-after(@srsName, 'crs/')"/>
                  <xsl:text/>') must match the value of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M14"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M14"/>
   <xsl:template match="@*|node()" priority="-2" mode="M14">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M14"/>
   </xsl:template>

   <!--PATTERN SimplePolygonSrsName_Valid_in_Resource-->


	<!--RULE -->
<xsl:template match="tspi:SimplePolygon" priority="1000" mode="M15">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="tspi:SimplePolygon"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="starts-with(@srsName, concat($GSIP, '/crs'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="starts-with(@srsName, concat($GSIP, '/crs'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The CRS must be from the set registered in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="document(@srsName)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="document(@srsName)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The specified srsName must reference a net-accessible resource in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="concat(substring-before(@srsName, '/crs'),'/crs') = document(@srsName)//gml:identifier/@codeSpace"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="concat(substring-before(@srsName, '/crs'),'/crs') = document(@srsName)//gml:identifier/@codeSpace">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The body of the srsName must match the codeSpace of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="substring-after(@srsName, 'crs/') = document(@srsName)//gml:identifier"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="substring-after(@srsName, 'crs/') = document(@srsName)//gml:identifier">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The tail of the srsName ('<xsl:text/>
                  <xsl:value-of select="substring-after(@srsName, 'crs/')"/>
                  <xsl:text/>') must match the value of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M15"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M15"/>
   <xsl:template match="@*|node()" priority="-2" mode="M15">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M15"/>
   </xsl:template>

   <!--PATTERN SimpleRectangleSrsName_Valid_in_Resource-->


	<!--RULE -->
<xsl:template match="tspi:SimpleRectangle" priority="1000" mode="M16">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="tspi:SimpleRectangle"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="starts-with(@srsName, concat($GSIP, '/crs'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="starts-with(@srsName, concat($GSIP, '/crs'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The CRS must be from the set registered in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="document(@srsName)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="document(@srsName)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The specified srsName must reference a net-accessible resource in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="concat(substring-before(@srsName, '/crs'),'/crs') = document(@srsName)//gml:identifier/@codeSpace"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="concat(substring-before(@srsName, '/crs'),'/crs') = document(@srsName)//gml:identifier/@codeSpace">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The body of the srsName must match the codeSpace of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="substring-after(@srsName, 'crs/') = document(@srsName)//gml:identifier"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="substring-after(@srsName, 'crs/') = document(@srsName)//gml:identifier">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The tail of the srsName ('<xsl:text/>
                  <xsl:value-of select="substring-after(@srsName, 'crs/')"/>
                  <xsl:text/>') must match the value of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M16"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M16"/>
   <xsl:template match="@*|node()" priority="-2" mode="M16">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M16"/>
   </xsl:template>

   <!--PATTERN EnvelopeSrsName_Valid_in_Resource-->


	<!--RULE -->
<xsl:template match="tspi:Envelope" priority="1000" mode="M17">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="tspi:Envelope"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="starts-with(@srsName, concat($GSIP, '/crs'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="starts-with(@srsName, concat($GSIP, '/crs'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The CRS must be from the set registered in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="document(@srsName)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="document(@srsName)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The specified srsName must reference a net-accessible resource in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="concat(substring-before(@srsName, '/crs'),'/crs') = document(@srsName)//gml:identifier/@codeSpace"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="concat(substring-before(@srsName, '/crs'),'/crs') = document(@srsName)//gml:identifier/@codeSpace">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The body of the srsName must match the codeSpace of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="substring-after(@srsName, 'crs/') = document(@srsName)//gml:identifier"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="substring-after(@srsName, 'crs/') = document(@srsName)//gml:identifier">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The tail of the srsName ('<xsl:text/>
                  <xsl:value-of select="substring-after(@srsName, 'crs/')"/>
                  <xsl:text/>') must match the value of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M17"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M17"/>
   <xsl:template match="@*|node()" priority="-2" mode="M17">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M17"/>
   </xsl:template>

   <!--PATTERN CircularSurfaceSrsName_Valid_in_Resource-->


	<!--RULE -->
<xsl:template match="tspi:CircularSurface" priority="1000" mode="M18">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="tspi:CircularSurface"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="starts-with(@srsName, concat($GSIP, '/crs'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="starts-with(@srsName, concat($GSIP, '/crs'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The CRS must be from the set registered in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="document(@srsName)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="document(@srsName)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The specified srsName must reference a net-accessible resource in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="concat(substring-before(@srsName, '/crs'),'/crs') = document(@srsName)//gml:identifier/@codeSpace"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="concat(substring-before(@srsName, '/crs'),'/crs') = document(@srsName)//gml:identifier/@codeSpace">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The body of the srsName must match the codeSpace of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="substring-after(@srsName, 'crs/') = document(@srsName)//gml:identifier"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="substring-after(@srsName, 'crs/') = document(@srsName)//gml:identifier">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The tail of the srsName ('<xsl:text/>
                  <xsl:value-of select="substring-after(@srsName, 'crs/')"/>
                  <xsl:text/>') must match the value of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M18"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M18"/>
   <xsl:template match="@*|node()" priority="-2" mode="M18">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M18"/>
   </xsl:template>

   <!--PATTERN EllipticalSurfaceSrsName_Valid_in_Resource-->


	<!--RULE -->
<xsl:template match="tspi:EllipticalSurface" priority="1000" mode="M19">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tspi:EllipticalSurface"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="starts-with(@srsName, concat($GSIP, '/crs'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="starts-with(@srsName, concat($GSIP, '/crs'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The CRS must be from the set registered in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="document(@srsName)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="document(@srsName)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The specified srsName must reference a net-accessible resource in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="concat(substring-before(@srsName, '/crs'),'/crs') = document(@srsName)//gml:identifier/@codeSpace"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="concat(substring-before(@srsName, '/crs'),'/crs') = document(@srsName)//gml:identifier/@codeSpace">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The body of the srsName must match the codeSpace of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="substring-after(@srsName, 'crs/') = document(@srsName)//gml:identifier"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="substring-after(@srsName, 'crs/') = document(@srsName)//gml:identifier">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The tail of the srsName ('<xsl:text/>
                  <xsl:value-of select="substring-after(@srsName, 'crs/')"/>
                  <xsl:text/>') must match the value of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M19"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M19"/>
   <xsl:template match="@*|node()" priority="-2" mode="M19">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M19"/>
   </xsl:template>

   <!--PATTERN PointHorizResolutionFlexibleEnum-->


	<!--RULE -->
<xsl:template match="tspi-core:horizResolutionCategory"
                 priority="1000"
                 mode="M20">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tspi-core:horizResolutionCategory"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(.!='')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(.!='')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Either the code list and value must be specified or the horizontal resolution category itself must be specified, but not both.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M20"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M20"/>
   <xsl:template match="@*|node()" priority="-2" mode="M20">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M20"/>
   </xsl:template>

   <!--PATTERN QuadrangleLocationSubZoneIntegrity-->


	<!--RULE -->
<xsl:template match="tspi-core:quadrangleLocation" priority="1000" mode="M21">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tspi-core:quadrangleLocation"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not (tspi-core:subZoneFraction) or (tspi-core:subZoneMinute)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not (tspi-core:subZoneFraction) or (tspi-core:subZoneMinute)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>If there is a Quadrangle Presentation with a minutes-faction subzone component then it must also have a minutes-based subzone component.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M21"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M21"/>
   <xsl:template match="@*|node()" priority="-2" mode="M21">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M21"/>
   </xsl:template>

   <!--PATTERN Acceleration_AllowableUOM-->


	<!--RULE -->
<xsl:template match="tspi:acceleration" priority="1000" mode="M22">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="tspi:acceleration"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="starts-with(@uom, concat($GSIP, '/uom/acceleration'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="starts-with(@uom, concat($GSIP, '/uom/acceleration'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The UOM must be from the set for the physical quantity 'acceleration' that is that is registered in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="document(@uom)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="document(@uom)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The body of the uom must match the codeSpace of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The tail of the uom ('<xsl:text/>
                  <xsl:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>
                  <xsl:text/>') must match the value of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M22"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M22"/>
   <xsl:template match="@*|node()" priority="-2" mode="M22">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M22"/>
   </xsl:template>

   <!--PATTERN AmountOfSubstance_AllowableUOM-->


	<!--RULE -->
<xsl:template match="tspi:amountOfSubstance" priority="1000" mode="M23">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tspi:amountOfSubstance"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="starts-with(@uom, concat($GSIP, '/uom/amountOfSubstance'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="starts-with(@uom, concat($GSIP, '/uom/amountOfSubstance'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The UOM must be from the set for the physical quantity 'amount of substance' that is that is registered in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="document(@uom)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="document(@uom)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The body of the uom must match the codeSpace of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The tail of the uom ('<xsl:text/>
                  <xsl:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>
                  <xsl:text/>') must match the value of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M23"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M23"/>
   <xsl:template match="@*|node()" priority="-2" mode="M23">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M23"/>
   </xsl:template>

   <!--PATTERN Area_AllowableUOM-->


	<!--RULE -->
<xsl:template match="tspi:area" priority="1000" mode="M24">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="tspi:area"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="starts-with(@uom, concat($GSIP, '/uom/area'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="starts-with(@uom, concat($GSIP, '/uom/area'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The UOM must be from the set for the physical quantity 'area' that is that is registered in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="document(@uom)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="document(@uom)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The body of the uom must match the codeSpace of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The tail of the uom ('<xsl:text/>
                  <xsl:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>
                  <xsl:text/>') must match the value of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M24"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M24"/>
   <xsl:template match="@*|node()" priority="-2" mode="M24">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M24"/>
   </xsl:template>

   <!--PATTERN Capacitance_AllowableUOM-->


	<!--RULE -->
<xsl:template match="tspi:capacitance" priority="1000" mode="M25">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="tspi:capacitance"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="starts-with(@uom, concat($GSIP, '/uom/capacitance'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="starts-with(@uom, concat($GSIP, '/uom/capacitance'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The UOM must be from the set for the physical quantity 'capacitance' that is that is registered in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="document(@uom)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="document(@uom)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The body of the uom must match the codeSpace of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The tail of the uom ('<xsl:text/>
                  <xsl:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>
                  <xsl:text/>') must match the value of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M25"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M25"/>
   <xsl:template match="@*|node()" priority="-2" mode="M25">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M25"/>
   </xsl:template>

   <!--PATTERN ElectricCharge_AllowableUOM-->


	<!--RULE -->
<xsl:template match="tspi:electricCharge" priority="1000" mode="M26">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="tspi:electricCharge"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="starts-with(@uom, concat($GSIP, '/uom/electricCharge'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="starts-with(@uom, concat($GSIP, '/uom/electricCharge'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The UOM must be from the set for the physical quantity 'electric charge' that is that is registered in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="document(@uom)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="document(@uom)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The body of the uom must match the codeSpace of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The tail of the uom ('<xsl:text/>
                  <xsl:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>
                  <xsl:text/>') must match the value of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M26"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M26"/>
   <xsl:template match="@*|node()" priority="-2" mode="M26">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M26"/>
   </xsl:template>

   <!--PATTERN ElectricConductance_AllowableUOM-->


	<!--RULE -->
<xsl:template match="tspi:electricConductance" priority="1000" mode="M27">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tspi:electricConductance"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="starts-with(@uom, concat($GSIP, '/uom/electricConductance'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="starts-with(@uom, concat($GSIP, '/uom/electricConductance'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The UOM must be from the set for the physical quantity 'electric conductance' that is that is registered in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="document(@uom)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="document(@uom)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The body of the uom must match the codeSpace of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The tail of the uom ('<xsl:text/>
                  <xsl:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>
                  <xsl:text/>') must match the value of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M27"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M27"/>
   <xsl:template match="@*|node()" priority="-2" mode="M27">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M27"/>
   </xsl:template>

   <!--PATTERN ElectricCurrent_AllowableUOM-->


	<!--RULE -->
<xsl:template match="tspi:electricCurrent" priority="1000" mode="M28">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="tspi:electricCurrent"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="starts-with(@uom, concat($GSIP, '/uom/electricCurrent'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="starts-with(@uom, concat($GSIP, '/uom/electricCurrent'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The UOM must be from the set for the physical quantity 'electric current' that is that is registered in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="document(@uom)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="document(@uom)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The body of the uom must match the codeSpace of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The tail of the uom ('<xsl:text/>
                  <xsl:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>
                  <xsl:text/>') must match the value of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M28"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M28"/>
   <xsl:template match="@*|node()" priority="-2" mode="M28">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M28"/>
   </xsl:template>

   <!--PATTERN ElectricResistance_AllowableUOM-->


	<!--RULE -->
<xsl:template match="tspi:electricResistance" priority="1000" mode="M29">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tspi:electricResistance"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="starts-with(@uom, concat($GSIP, '/uom/electricResistance'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="starts-with(@uom, concat($GSIP, '/uom/electricResistance'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The UOM must be from the set for the physical quantity 'electric resistance' that is that is registered in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="document(@uom)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="document(@uom)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The body of the uom must match the codeSpace of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The tail of the uom ('<xsl:text/>
                  <xsl:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>
                  <xsl:text/>') must match the value of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M29"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M29"/>
   <xsl:template match="@*|node()" priority="-2" mode="M29">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M29"/>
   </xsl:template>

   <!--PATTERN ElectromotiveForce_AllowableUOM-->


	<!--RULE -->
<xsl:template match="tspi:electromotiveForce" priority="1000" mode="M30">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tspi:electromotiveForce"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="starts-with(@uom, concat($GSIP, '/uom/electromotiveForce'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="starts-with(@uom, concat($GSIP, '/uom/electromotiveForce'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The UOM must be from the set for the physical quantity 'electromotive force' that is that is registered in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="document(@uom)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="document(@uom)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The body of the uom must match the codeSpace of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The tail of the uom ('<xsl:text/>
                  <xsl:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>
                  <xsl:text/>') must match the value of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M30"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M30"/>
   <xsl:template match="@*|node()" priority="-2" mode="M30">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M30"/>
   </xsl:template>

   <!--PATTERN Energy_AllowableUOM-->


	<!--RULE -->
<xsl:template match="tspi:energy" priority="1000" mode="M31">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="tspi:energy"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="starts-with(@uom, concat($GSIP, '/uom/energy'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="starts-with(@uom, concat($GSIP, '/uom/energy'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The UOM must be from the set for the physical quantity 'energy' that is that is registered in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="document(@uom)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="document(@uom)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The body of the uom must match the codeSpace of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The tail of the uom ('<xsl:text/>
                  <xsl:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>
                  <xsl:text/>') must match the value of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M31"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M31"/>
   <xsl:template match="@*|node()" priority="-2" mode="M31">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M31"/>
   </xsl:template>

   <!--PATTERN Force_AllowableUOM-->


	<!--RULE -->
<xsl:template match="tspi:force" priority="1000" mode="M32">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="tspi:force"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="starts-with(@uom, concat($GSIP, '/uom/force'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="starts-with(@uom, concat($GSIP, '/uom/force'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The UOM must be from the set for the physical quantity 'force' that is that is registered in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="document(@uom)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="document(@uom)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The body of the uom must match the codeSpace of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The tail of the uom ('<xsl:text/>
                  <xsl:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>
                  <xsl:text/>') must match the value of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M32"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M32"/>
   <xsl:template match="@*|node()" priority="-2" mode="M32">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M32"/>
   </xsl:template>

   <!--PATTERN Frequency_AllowableUOM-->


	<!--RULE -->
<xsl:template match="tspi:frequency" priority="1000" mode="M33">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="tspi:frequency"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="starts-with(@uom, concat($GSIP, '/uom/frequency'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="starts-with(@uom, concat($GSIP, '/uom/frequency'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The UOM must be from the set for the physical quantity 'frequency' that is that is registered in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="document(@uom)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="document(@uom)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The body of the uom must match the codeSpace of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The tail of the uom ('<xsl:text/>
                  <xsl:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>
                  <xsl:text/>') must match the value of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M33"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M33"/>
   <xsl:template match="@*|node()" priority="-2" mode="M33">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M33"/>
   </xsl:template>

   <!--PATTERN GeopotentialEnergyLength_AllowableUOM-->


	<!--RULE -->
<xsl:template match="tspi:geopotentialEnergyLength" priority="1000" mode="M34">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tspi:geopotentialEnergyLength"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="starts-with(@uom, concat($GSIP, '/uom/geopotentialEnergyLength'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="starts-with(@uom, concat($GSIP, '/uom/geopotentialEnergyLength'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The UOM must be from the set for the physical quantity 'geopotential energy length' that is that is registered in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="document(@uom)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="document(@uom)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The body of the uom must match the codeSpace of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The tail of the uom ('<xsl:text/>
                  <xsl:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>
                  <xsl:text/>') must match the value of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M34"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M34"/>
   <xsl:template match="@*|node()" priority="-2" mode="M34">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M34"/>
   </xsl:template>

   <!--PATTERN Illuminance_AllowableUOM-->


	<!--RULE -->
<xsl:template match="tspi:illuminance" priority="1000" mode="M35">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="tspi:illuminance"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="starts-with(@uom, concat($GSIP, '/uom/illuminance'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="starts-with(@uom, concat($GSIP, '/uom/illuminance'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The UOM must be from the set for the physical quantity 'illuminance' that is that is registered in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="document(@uom)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="document(@uom)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The body of the uom must match the codeSpace of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The tail of the uom ('<xsl:text/>
                  <xsl:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>
                  <xsl:text/>') must match the value of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M35"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M35"/>
   <xsl:template match="@*|node()" priority="-2" mode="M35">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M35"/>
   </xsl:template>

   <!--PATTERN Inductance_AllowableUOM-->


	<!--RULE -->
<xsl:template match="tspi:inductance" priority="1000" mode="M36">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="tspi:inductance"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="starts-with(@uom, concat($GSIP, '/uom/inductance'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="starts-with(@uom, concat($GSIP, '/uom/inductance'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The UOM must be from the set for the physical quantity 'inductance' that is that is registered in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="document(@uom)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="document(@uom)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The body of the uom must match the codeSpace of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The tail of the uom ('<xsl:text/>
                  <xsl:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>
                  <xsl:text/>') must match the value of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M36"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M36"/>
   <xsl:template match="@*|node()" priority="-2" mode="M36">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M36"/>
   </xsl:template>

   <!--PATTERN Irradiance_AllowableUOM-->


	<!--RULE -->
<xsl:template match="tspi:irradiance" priority="1000" mode="M37">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="tspi:irradiance"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="starts-with(@uom, concat($GSIP, '/uom/irradiance'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="starts-with(@uom, concat($GSIP, '/uom/irradiance'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The UOM must be from the set for the physical quantity 'irradiance' that is that is registered in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="document(@uom)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="document(@uom)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The body of the uom must match the codeSpace of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The tail of the uom ('<xsl:text/>
                  <xsl:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>
                  <xsl:text/>') must match the value of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M37"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M37"/>
   <xsl:template match="@*|node()" priority="-2" mode="M37">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M37"/>
   </xsl:template>

   <!--PATTERN Length_AllowableUOM-->


	<!--RULE -->
<xsl:template match="tspi:length" priority="1000" mode="M38">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="tspi:length"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="starts-with(@uom, concat($GSIP, '/uom/length'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="starts-with(@uom, concat($GSIP, '/uom/length'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The UOM must be from the set for the physical quantity 'length' that is that is registered in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="document(@uom)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="document(@uom)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The body of the uom must match the codeSpace of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The tail of the uom ('<xsl:text/>
                  <xsl:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>
                  <xsl:text/>') must match the value of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M38"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M38"/>
   <xsl:template match="@*|node()" priority="-2" mode="M38">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M38"/>
   </xsl:template>

   <!--PATTERN LinearDensity_AllowableUOM-->


	<!--RULE -->
<xsl:template match="tspi:linearDensity" priority="1000" mode="M39">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="tspi:linearDensity"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="starts-with(@uom, concat($GSIP, '/uom/linearDensity'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="starts-with(@uom, concat($GSIP, '/uom/linearDensity'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The UOM must be from the set for the physical quantity 'linear density' that is that is registered in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="document(@uom)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="document(@uom)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The body of the uom must match the codeSpace of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The tail of the uom ('<xsl:text/>
                  <xsl:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>
                  <xsl:text/>') must match the value of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M39"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M39"/>
   <xsl:template match="@*|node()" priority="-2" mode="M39">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M39"/>
   </xsl:template>

   <!--PATTERN LinearEnergyTransfer_AllowableUOM-->


	<!--RULE -->
<xsl:template match="tspi:linearEnergyTransfer" priority="1000" mode="M40">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tspi:linearEnergyTransfer"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="starts-with(@uom, concat($GSIP, '/uom/linearEnergyTransfer'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="starts-with(@uom, concat($GSIP, '/uom/linearEnergyTransfer'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The UOM must be from the set for the physical quantity 'linear energy transfer' that is that is registered in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="document(@uom)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="document(@uom)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The body of the uom must match the codeSpace of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The tail of the uom ('<xsl:text/>
                  <xsl:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>
                  <xsl:text/>') must match the value of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M40"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M40"/>
   <xsl:template match="@*|node()" priority="-2" mode="M40">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M40"/>
   </xsl:template>

   <!--PATTERN LuminousFlux_AllowableUOM-->


	<!--RULE -->
<xsl:template match="tspi:luminousFlux" priority="1000" mode="M41">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="tspi:luminousFlux"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="starts-with(@uom, concat($GSIP, '/uom/luminousFlux'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="starts-with(@uom, concat($GSIP, '/uom/luminousFlux'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The UOM must be from the set for the physical quantity 'luminous flux' that is that is registered in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="document(@uom)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="document(@uom)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The body of the uom must match the codeSpace of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The tail of the uom ('<xsl:text/>
                  <xsl:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>
                  <xsl:text/>') must match the value of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M41"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M41"/>
   <xsl:template match="@*|node()" priority="-2" mode="M41">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M41"/>
   </xsl:template>

   <!--PATTERN LuminousIntensity_AllowableUOM-->


	<!--RULE -->
<xsl:template match="tspi:luminousIntensity" priority="1000" mode="M42">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tspi:luminousIntensity"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="starts-with(@uom, concat($GSIP, '/uom/luminousIntensity'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="starts-with(@uom, concat($GSIP, '/uom/luminousIntensity'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The UOM must be from the set for the physical quantity 'luminous intensity' that is that is registered in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="document(@uom)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="document(@uom)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The body of the uom must match the codeSpace of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The tail of the uom ('<xsl:text/>
                  <xsl:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>
                  <xsl:text/>') must match the value of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M42"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M42"/>
   <xsl:template match="@*|node()" priority="-2" mode="M42">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M42"/>
   </xsl:template>

   <!--PATTERN MagneticFlux_AllowableUOM-->


	<!--RULE -->
<xsl:template match="tspi:magneticFlux" priority="1000" mode="M43">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="tspi:magneticFlux"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="starts-with(@uom, concat($GSIP, '/uom/magneticFlux'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="starts-with(@uom, concat($GSIP, '/uom/magneticFlux'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The UOM must be from the set for the physical quantity 'magnetic flux' that is that is registered in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="document(@uom)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="document(@uom)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The body of the uom must match the codeSpace of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The tail of the uom ('<xsl:text/>
                  <xsl:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>
                  <xsl:text/>') must match the value of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M43"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M43"/>
   <xsl:template match="@*|node()" priority="-2" mode="M43">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M43"/>
   </xsl:template>

   <!--PATTERN MagneticFluxDensity_AllowableUOM-->


	<!--RULE -->
<xsl:template match="tspi:magneticFluxDensity" priority="1000" mode="M44">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tspi:magneticFluxDensity"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="starts-with(@uom, concat($GSIP, '/uom/magneticFluxDensity'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="starts-with(@uom, concat($GSIP, '/uom/magneticFluxDensity'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The UOM must be from the set for the physical quantity 'magnetic flux density' that is that is registered in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="document(@uom)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="document(@uom)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The body of the uom must match the codeSpace of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The tail of the uom ('<xsl:text/>
                  <xsl:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>
                  <xsl:text/>') must match the value of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M44"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M44"/>
   <xsl:template match="@*|node()" priority="-2" mode="M44">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M44"/>
   </xsl:template>

   <!--PATTERN MagneticFluxDensityGradient_AllowableUOM-->


	<!--RULE -->
<xsl:template match="tspi:magneticFluxDensityGradient" priority="1000" mode="M45">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tspi:magneticFluxDensityGradient"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="starts-with(@uom, concat($GSIP, '/uom/magneticFluxDensityGradient'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="starts-with(@uom, concat($GSIP, '/uom/magneticFluxDensityGradient'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The UOM must be from the set for the physical quantity 'magnetic flux density gradient' that is that is registered in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="document(@uom)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="document(@uom)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The body of the uom must match the codeSpace of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The tail of the uom ('<xsl:text/>
                  <xsl:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>
                  <xsl:text/>') must match the value of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M45"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M45"/>
   <xsl:template match="@*|node()" priority="-2" mode="M45">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M45"/>
   </xsl:template>

   <!--PATTERN Mass_AllowableUOM-->


	<!--RULE -->
<xsl:template match="tspi:mass" priority="1000" mode="M46">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="tspi:mass"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="starts-with(@uom, concat($GSIP, '/uom/mass'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="starts-with(@uom, concat($GSIP, '/uom/mass'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The UOM must be from the set for the physical quantity 'mass' that is that is registered in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="document(@uom)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="document(@uom)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The body of the uom must match the codeSpace of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The tail of the uom ('<xsl:text/>
                  <xsl:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>
                  <xsl:text/>') must match the value of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M46"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M46"/>
   <xsl:template match="@*|node()" priority="-2" mode="M46">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M46"/>
   </xsl:template>

   <!--PATTERN MassDensity_AllowableUOM-->


	<!--RULE -->
<xsl:template match="tspi:massDensity" priority="1000" mode="M47">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="tspi:massDensity"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="starts-with(@uom, concat($GSIP, '/uom/massDensity'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="starts-with(@uom, concat($GSIP, '/uom/massDensity'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The UOM must be from the set for the physical quantity 'mass density' that is that is registered in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="document(@uom)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="document(@uom)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The body of the uom must match the codeSpace of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The tail of the uom ('<xsl:text/>
                  <xsl:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>
                  <xsl:text/>') must match the value of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M47"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M47"/>
   <xsl:template match="@*|node()" priority="-2" mode="M47">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M47"/>
   </xsl:template>

   <!--PATTERN MassFraction_AllowableUOM-->


	<!--RULE -->
<xsl:template match="tspi:massFraction" priority="1000" mode="M48">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="tspi:massFraction"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="starts-with(@uom, concat($GSIP, '/uom/massFraction'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="starts-with(@uom, concat($GSIP, '/uom/massFraction'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The UOM must be from the set for the physical quantity 'mass fraction' that is that is registered in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="document(@uom)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="document(@uom)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The body of the uom must match the codeSpace of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The tail of the uom ('<xsl:text/>
                  <xsl:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>
                  <xsl:text/>') must match the value of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M48"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M48"/>
   <xsl:template match="@*|node()" priority="-2" mode="M48">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M48"/>
   </xsl:template>

   <!--PATTERN MassRate_AllowableUOM-->


	<!--RULE -->
<xsl:template match="tspi:massRate" priority="1000" mode="M49">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="tspi:massRate"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="starts-with(@uom, concat($GSIP, '/uom/massRate'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="starts-with(@uom, concat($GSIP, '/uom/massRate'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The UOM must be from the set for the physical quantity 'mass rate' that is that is registered in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="document(@uom)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="document(@uom)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The body of the uom must match the codeSpace of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The tail of the uom ('<xsl:text/>
                  <xsl:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>
                  <xsl:text/>') must match the value of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M49"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M49"/>
   <xsl:template match="@*|node()" priority="-2" mode="M49">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M49"/>
   </xsl:template>

   <!--PATTERN NoncomparableUnit_AllowableUOM-->


	<!--RULE -->
<xsl:template match="tspi:noncomparableUnit" priority="1000" mode="M50">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tspi:noncomparableUnit"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="starts-with(@uom, concat($GSIP, '/uom/noncomparable'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="starts-with(@uom, concat($GSIP, '/uom/noncomparable'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The UOM must be from the set for the physical quantity 'noncomparable' that is of physical quantities.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="document(@uom)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="document(@uom)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The body of the uom must match the codeSpace of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The tail of the uom ('<xsl:text/>
                  <xsl:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>
                  <xsl:text/>') must match the value of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M50"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M50"/>
   <xsl:template match="@*|node()" priority="-2" mode="M50">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M50"/>
   </xsl:template>

   <!--PATTERN PlaneAngle_AllowableUOM-->


	<!--RULE -->
<xsl:template match="tspi:planeAngle" priority="1000" mode="M51">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="tspi:planeAngle"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="starts-with(@uom, concat($GSIP, '/uom/planeAngle'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="starts-with(@uom, concat($GSIP, '/uom/planeAngle'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The UOM must be from the set for the physical quantity 'plane angle' that is that is registered in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="document(@uom)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="document(@uom)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The body of the uom must match the codeSpace of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The tail of the uom ('<xsl:text/>
                  <xsl:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>
                  <xsl:text/>') must match the value of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M51"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M51"/>
   <xsl:template match="@*|node()" priority="-2" mode="M51">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M51"/>
   </xsl:template>

   <!--PATTERN Power_AllowableUOM-->


	<!--RULE -->
<xsl:template match="tspi:power" priority="1000" mode="M52">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="tspi:power"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="starts-with(@uom, concat($GSIP, '/uom/power'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="starts-with(@uom, concat($GSIP, '/uom/power'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The UOM must be from the set for the physical quantity 'power' that is that is registered in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="document(@uom)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="document(@uom)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The body of the uom must match the codeSpace of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The tail of the uom ('<xsl:text/>
                  <xsl:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>
                  <xsl:text/>') must match the value of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M52"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M52"/>
   <xsl:template match="@*|node()" priority="-2" mode="M52">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M52"/>
   </xsl:template>

   <!--PATTERN PowerLevelDifference_AllowableUOM-->


	<!--RULE -->
<xsl:template match="tspi:powerLevelDifference" priority="1000" mode="M53">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tspi:powerLevelDifference"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="starts-with(@uom, concat($GSIP, '/uom/powerLevelDifference'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="starts-with(@uom, concat($GSIP, '/uom/powerLevelDifference'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The UOM must be from the set for the physical quantity 'power level difference' that is that is registered in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="document(@uom)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="document(@uom)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The body of the uom must match the codeSpace of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The tail of the uom ('<xsl:text/>
                  <xsl:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>
                  <xsl:text/>') must match the value of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M53"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M53"/>
   <xsl:template match="@*|node()" priority="-2" mode="M53">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M53"/>
   </xsl:template>

   <!--PATTERN PowerLevelDiffLenGradient_AllowableUOM-->


	<!--RULE -->
<xsl:template match="tspi:powerLevelDiffLenGradient" priority="1000" mode="M54">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tspi:powerLevelDiffLenGradient"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="starts-with(@uom, concat($GSIP, '/uom/powerLevelDiffLenGradient'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="starts-with(@uom, concat($GSIP, '/uom/powerLevelDiffLenGradient'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The UOM must be from the set for the physical quantity 'power level difference length' that is that is registered in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="document(@uom)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="document(@uom)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The body of the uom must match the codeSpace of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The tail of the uom ('<xsl:text/>
                  <xsl:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>
                  <xsl:text/>') must match the value of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M54"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M54"/>
   <xsl:template match="@*|node()" priority="-2" mode="M54">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M54"/>
   </xsl:template>

   <!--PATTERN Pressure_AllowableUOM-->


	<!--RULE -->
<xsl:template match="tspi:pressure" priority="1000" mode="M55">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="tspi:pressure"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="starts-with(@uom, concat($GSIP, '/uom/pressure'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="starts-with(@uom, concat($GSIP, '/uom/pressure'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The UOM must be from the set for the physical quantity 'pressure' that is that is registered in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="document(@uom)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="document(@uom)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The body of the uom must match the codeSpace of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The tail of the uom ('<xsl:text/>
                  <xsl:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>
                  <xsl:text/>') must match the value of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M55"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M55"/>
   <xsl:template match="@*|node()" priority="-2" mode="M55">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M55"/>
   </xsl:template>

   <!--PATTERN PureNumber_AllowableUOM-->


	<!--RULE -->
<xsl:template match="tspi:pureNumber" priority="1000" mode="M56">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="tspi:pureNumber"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="starts-with(@uom, concat($GSIP, '/uom/pureNumber'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="starts-with(@uom, concat($GSIP, '/uom/pureNumber'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The UOM must be from the set for the physical quantity 'pure number' that is that is registered in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="document(@uom)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="document(@uom)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The body of the uom must match the codeSpace of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The tail of the uom ('<xsl:text/>
                  <xsl:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>
                  <xsl:text/>') must match the value of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M56"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M56"/>
   <xsl:template match="@*|node()" priority="-2" mode="M56">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M56"/>
   </xsl:template>

   <!--PATTERN RadiationAbsorbedDose_AllowableUOM-->


	<!--RULE -->
<xsl:template match="tspi:radiationAbsorbedDose" priority="1000" mode="M57">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tspi:radiationAbsorbedDose"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="starts-with(@uom, concat($GSIP, '/uom/radiationAbsorbedDose'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="starts-with(@uom, concat($GSIP, '/uom/radiationAbsorbedDose'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The UOM must be from the set for the physical quantity 'radiation absorbed dose' that is that is registered in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="document(@uom)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="document(@uom)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The body of the uom must match the codeSpace of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The tail of the uom ('<xsl:text/>
                  <xsl:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>
                  <xsl:text/>') must match the value of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M57"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M57"/>
   <xsl:template match="@*|node()" priority="-2" mode="M57">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M57"/>
   </xsl:template>

   <!--PATTERN RadiationDoseEquivalent_AllowableUOM-->


	<!--RULE -->
<xsl:template match="tspi:radiationDoseEquivalent" priority="1000" mode="M58">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tspi:radiationDoseEquivalent"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="starts-with(@uom, concat($GSIP, '/uom/radiationDoseEquivalent'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="starts-with(@uom, concat($GSIP, '/uom/radiationDoseEquivalent'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The UOM must be from the set for the physical quantity 'radiation dose equivalent' that is that is registered in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="document(@uom)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="document(@uom)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The body of the uom must match the codeSpace of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The tail of the uom ('<xsl:text/>
                  <xsl:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>
                  <xsl:text/>') must match the value of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M58"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M58"/>
   <xsl:template match="@*|node()" priority="-2" mode="M58">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M58"/>
   </xsl:template>

   <!--PATTERN RadionuclideActivity_AllowableUOM-->


	<!--RULE -->
<xsl:template match="tspi:radionuclideActivity" priority="1000" mode="M59">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tspi:radionuclideActivity"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="starts-with(@uom, concat($GSIP, '/uom/radionuclideActivity'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="starts-with(@uom, concat($GSIP, '/uom/radionuclideActivity'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The UOM must be from the set for the physical quantity 'radionuclide activity' that is that is registered in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="document(@uom)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="document(@uom)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The body of the uom must match the codeSpace of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The tail of the uom ('<xsl:text/>
                  <xsl:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>
                  <xsl:text/>') must match the value of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M59"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M59"/>
   <xsl:template match="@*|node()" priority="-2" mode="M59">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M59"/>
   </xsl:template>

   <!--PATTERN Rate_AllowableUOM-->


	<!--RULE -->
<xsl:template match="tspi:rate" priority="1000" mode="M60">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="tspi:rate"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="starts-with(@uom, concat($GSIP, '/uom/rate'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="starts-with(@uom, concat($GSIP, '/uom/rate'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The UOM must be from the set for the physical quantity 'rate' that is that is registered in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="document(@uom)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="document(@uom)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The body of the uom must match the codeSpace of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The tail of the uom ('<xsl:text/>
                  <xsl:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>
                  <xsl:text/>') must match the value of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M60"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M60"/>
   <xsl:template match="@*|node()" priority="-2" mode="M60">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M60"/>
   </xsl:template>

   <!--PATTERN ReciprocalArea_AllowableUOM-->


	<!--RULE -->
<xsl:template match="tspi:reciprocalArea" priority="1000" mode="M61">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="tspi:reciprocalArea"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="starts-with(@uom, concat($GSIP, '/uom/reciprocalArea'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="starts-with(@uom, concat($GSIP, '/uom/reciprocalArea'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The UOM must be from the set for the physical quantity 'reciprocal area' that is that is registered in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="document(@uom)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="document(@uom)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The body of the uom must match the codeSpace of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The tail of the uom ('<xsl:text/>
                  <xsl:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>
                  <xsl:text/>') must match the value of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M61"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M61"/>
   <xsl:template match="@*|node()" priority="-2" mode="M61">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M61"/>
   </xsl:template>

   <!--PATTERN ReciprocalTime_AllowableUOM-->


	<!--RULE -->
<xsl:template match="tspi:reciprocalTime" priority="1000" mode="M62">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="tspi:reciprocalTime"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="starts-with(@uom, concat($GSIP, '/uom/reciprocalTime'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="starts-with(@uom, concat($GSIP, '/uom/reciprocalTime'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The UOM must be from the set for the physical quantity 'reciprocal time' that is that is registered in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="document(@uom)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="document(@uom)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The body of the uom must match the codeSpace of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The tail of the uom ('<xsl:text/>
                  <xsl:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>
                  <xsl:text/>') must match the value of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M62"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M62"/>
   <xsl:template match="@*|node()" priority="-2" mode="M62">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M62"/>
   </xsl:template>

   <!--PATTERN SolidAngle_AllowableUOM-->


	<!--RULE -->
<xsl:template match="tspi:solidAngle" priority="1000" mode="M63">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="tspi:solidAngle"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="starts-with(@uom, concat($GSIP, '/uom/solidAngle'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="starts-with(@uom, concat($GSIP, '/uom/solidAngle'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The UOM must be from the set for the physical quantity 'solid angle' that is that is registered in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="document(@uom)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="document(@uom)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The body of the uom must match the codeSpace of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The tail of the uom ('<xsl:text/>
                  <xsl:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>
                  <xsl:text/>') must match the value of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M63"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M63"/>
   <xsl:template match="@*|node()" priority="-2" mode="M63">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M63"/>
   </xsl:template>

   <!--PATTERN SoundSpeedRatio_AllowableUOM-->


	<!--RULE -->
<xsl:template match="tspi:soundSpeedRatio" priority="1000" mode="M64">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="tspi:soundSpeedRatio"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="starts-with(@uom, concat($GSIP, '/uom/soundSpeedRatio'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="starts-with(@uom, concat($GSIP, '/uom/soundSpeedRatio'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The UOM must be from the set for the physical quantity 'sound speed ratio' that is that is registered in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="document(@uom)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="document(@uom)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The body of the uom must match the codeSpace of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The tail of the uom ('<xsl:text/>
                  <xsl:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>
                  <xsl:text/>') must match the value of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M64"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M64"/>
   <xsl:template match="@*|node()" priority="-2" mode="M64">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M64"/>
   </xsl:template>

   <!--PATTERN Speed_AllowableUOM-->


	<!--RULE -->
<xsl:template match="tspi:speed" priority="1000" mode="M65">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="tspi:speed"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="starts-with(@uom, concat($GSIP, '/uom/speed'))                                or (@uom = concat($GSIP, '/uom/pureNumber/machNumber'))                                 or (@uom = concat($GSIP, '/uom/pureNumber/deciMachNumber'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="starts-with(@uom, concat($GSIP, '/uom/speed')) or (@uom = concat($GSIP, '/uom/pureNumber/machNumber')) or (@uom = concat($GSIP, '/uom/pureNumber/deciMachNumber'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The UOM must be either from the set for the physical quantity 'planeAngle', or one of the pure number UoMs based on "machNumber", that are registered in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="document(@uom)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="document(@uom)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The body of the uom must match the codeSpace of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The tail of the uom ('<xsl:text/>
                  <xsl:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>
                  <xsl:text/>') must match the value of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M65"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M65"/>
   <xsl:template match="@*|node()" priority="-2" mode="M65">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M65"/>
   </xsl:template>

   <!--PATTERN SurfaceMassDensityRate_AllowableUOM-->


	<!--RULE -->
<xsl:template match="tspi:surfaceMassDensityRate" priority="1000" mode="M66">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tspi:surfaceMassDensityRate"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="starts-with(@uom, concat($GSIP, '/uom/surfaceMassDensityRate'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="starts-with(@uom, concat($GSIP, '/uom/surfaceMassDensityRate'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The UOM must be from the set for the physical quantity 'surface mass density' that is that is registered in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="document(@uom)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="document(@uom)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The body of the uom must match the codeSpace of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The tail of the uom ('<xsl:text/>
                  <xsl:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>
                  <xsl:text/>') must match the value of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M66"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M66"/>
   <xsl:template match="@*|node()" priority="-2" mode="M66">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M66"/>
   </xsl:template>

   <!--PATTERN ThermodynamicTemperature_AllowableUOM-->


	<!--RULE -->
<xsl:template match="tspi:thermodynamicTemperature" priority="1000" mode="M67">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="tspi:thermodynamicTemperature"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="starts-with(@uom, concat($GSIP, '/uom/thermodynamicTemperature'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="starts-with(@uom, concat($GSIP, '/uom/thermodynamicTemperature'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The UOM must be from the set for the physical quantity 'thermodynamic temperature' that is that is registered in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="document(@uom)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="document(@uom)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The body of the uom must match the codeSpace of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The tail of the uom ('<xsl:text/>
                  <xsl:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>
                  <xsl:text/>') must match the value of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M67"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M67"/>
   <xsl:template match="@*|node()" priority="-2" mode="M67">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M67"/>
   </xsl:template>

   <!--PATTERN Time_AllowableUOM-->


	<!--RULE -->
<xsl:template match="tspi:time" priority="1000" mode="M68">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="tspi:time"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="starts-with(@uom, concat($GSIP, '/uom/time'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="starts-with(@uom, concat($GSIP, '/uom/time'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The UOM must be from the set for the physical quantity 'time' that is that is registered in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="document(@uom)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="document(@uom)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The body of the uom must match the codeSpace of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The tail of the uom ('<xsl:text/>
                  <xsl:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>
                  <xsl:text/>') must match the value of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M68"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M68"/>
   <xsl:template match="@*|node()" priority="-2" mode="M68">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M68"/>
   </xsl:template>

   <!--PATTERN Volume_AllowableUOM-->


	<!--RULE -->
<xsl:template match="tspi:volume" priority="1000" mode="M69">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="tspi:volume"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="starts-with(@uom, concat($GSIP, '/uom/volume'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="starts-with(@uom, concat($GSIP, '/uom/volume'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The UOM must be from the set for the physical quantity 'volume' that is that is registered in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="document(@uom)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="document(@uom)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The body of the uom must match the codeSpace of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The tail of the uom ('<xsl:text/>
                  <xsl:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>
                  <xsl:text/>') must match the value of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M69"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M69"/>
   <xsl:template match="@*|node()" priority="-2" mode="M69">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M69"/>
   </xsl:template>

   <!--PATTERN VolumeFlowRate_AllowableUOM-->


	<!--RULE -->
<xsl:template match="tspi:volumeFlowRate" priority="1000" mode="M70">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="tspi:volumeFlowRate"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="starts-with(@uom, concat($GSIP, '/uom/volumeFlowRate'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="starts-with(@uom, concat($GSIP, '/uom/volumeFlowRate'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The UOM must be from the set for the physical quantity 'volume flow rate' that is that is registered in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="document(@uom)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="document(@uom)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The body of the uom must match the codeSpace of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The tail of the uom ('<xsl:text/>
                  <xsl:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>
                  <xsl:text/>') must match the value of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M70"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M70"/>
   <xsl:template match="@*|node()" priority="-2" mode="M70">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M70"/>
   </xsl:template>

   <!--PATTERN VolumeFraction_AllowableUOM-->


	<!--RULE -->
<xsl:template match="tspi:volumeFraction" priority="1000" mode="M71">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="tspi:volumeFraction"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="starts-with(@uom, concat($GSIP, '/uom/volumeFraction'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="starts-with(@uom, concat($GSIP, '/uom/volumeFraction'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The UOM must be from the set for the physical quantity 'volume fraction' that is that is registered in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="document(@uom)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="document(@uom)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The body of the uom must match the codeSpace of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The tail of the uom ('<xsl:text/>
                  <xsl:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>
                  <xsl:text/>') must match the value of the identifier in the resource.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M71"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M71"/>
   <xsl:template match="@*|node()" priority="-2" mode="M71">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M71"/>
   </xsl:template>

   <!--PATTERN TimePosition_must_not_have_InconsistentContent-->


	<!--RULE -->
<xsl:template match="gml:timePosition" priority="1000" mode="M72">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="gml:timePosition"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(@indeterminatePosition = 'now')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(@indeterminatePosition = 'now')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The time position indeterminate position 'now' shall not be used.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not((@indeterminatePosition = 'unknown') and normalize-space(.))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not((@indeterminatePosition = 'unknown') and normalize-space(.))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The time position indeterminate position 'unknown' shall not be used if there is a specified time position value.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(((@indeterminatePosition = 'before') or (@indeterminatePosition = 'after')) and not(normalize-space(.)))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(((@indeterminatePosition = 'before') or (@indeterminatePosition = 'after')) and not(normalize-space(.)))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The time position indeterminate positions 'before' and 'after' shall not be used if there is no specified time position value..</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M72"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M72"/>
   <xsl:template match="@*|node()" priority="-2" mode="M72">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M72"/>
   </xsl:template>

   <!--PATTERN TimeInstantIsolated_must_not_have_InconsistentContent-->


	<!--RULE -->
<xsl:template match="gml:TimeInstant/gml:timePosition" priority="1000" mode="M73">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="gml:TimeInstant/gml:timePosition"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(@indeterminatePosition)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(@indeterminatePosition)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The time position indeterminate position shall not be used in the case of an isolated time instant (as opposed to one that is participating in a time period).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M73"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M73"/>
   <xsl:template match="@*|node()" priority="-2" mode="M73">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M73"/>
   </xsl:template>

   <!--PATTERN TimePosition_must_have_ValidContent-->


	<!--RULE -->
<xsl:template match="gml:timePosition" priority="1000" mode="M74">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="gml:timePosition"/>
      <xsl:variable name="year" select="number(substring(.,1,4))"/>
      <xsl:variable name="month" select="number(substring(.,6,2))"/>
      <xsl:variable name="day" select="number(substring(.,9,2))"/>
      <xsl:variable name="hour" select="number(substring(.,12,2))"/>
      <xsl:variable name="minute" select="number(substring(.,15,2))"/>
      <xsl:variable name="second1" select="number(substring(.,18,2))"/>
      <xsl:variable name="second2" select="number(substring(.,18,4))"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(string-length(.) &gt;= 4) and (string-length(.) &lt;= 23) or (@indeterminatePosition = 'unknown')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="(string-length(.) &gt;= 4) and (string-length(.) &lt;= 23) or (@indeterminatePosition = 'unknown')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The time position element contains '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' but should contain a proper date or dateTime.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(string-length(.) = 4) or         ((string-length(.) = 4) and ($year))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(string-length(.) = 4) or ((string-length(.) = 4) and ($year))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The time position element contains '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' but should contain a year in the format CCYY.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not((string-length(.) &gt; 4) and (string-length(.) &lt;= 7)) or          ((string-length(.) = 7) and ($year) and          (substring(.,5,1) = '-') and ($month &gt;= 1 and $month &lt;= 12))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not((string-length(.) &gt; 4) and (string-length(.) &lt;= 7)) or ((string-length(.) = 7) and ($year) and (substring(.,5,1) = '-') and ($month &gt;= 1 and $month &lt;= 12))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The time position element contains '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' but should contain a year-month in the format CCYY-MM.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not((string-length(.) &gt; 7) and (string-length(.) &lt;= 10)) or          ((string-length(.) = 10) and ($year) and          (substring(.,5,1) = '-') and ($month &gt;= 1 and $month &lt;= 12) and          (substring(.,8,1) = '-') and ($day &gt;= 1 and $day &lt;= 31))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not((string-length(.) &gt; 7) and (string-length(.) &lt;= 10)) or ((string-length(.) = 10) and ($year) and (substring(.,5,1) = '-') and ($month &gt;= 1 and $month &lt;= 12) and (substring(.,8,1) = '-') and ($day &gt;= 1 and $day &lt;= 31))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The time position element contains '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' but should contain a year-month-day in the format CCYY-MM-DD.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not((string-length(.) &gt; 12) and (string-length(.) &lt;= 19)) or          ((string-length(.) = 19) and ($year) and          (substring(.,5,1) = '-') and ($month &gt;= 1 and $month &lt;= 12) and          (substring(.,8,1) = '-') and ($day &gt;= 1 and $day &lt;= 31) and         (substring(.,11,1) = 'T') and ($hour &gt;= 0 and $hour &lt;= 23) and          (substring(.,14,1) = ':') and ($minute &gt;= 0 and $minute &lt;= 59) and         (substring(.,17,1) = ':') and ($second1 &gt;=0 and $second1 &lt;= 59) and         (substring(.,20,1) = 'Z'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not((string-length(.) &gt; 12) and (string-length(.) &lt;= 19)) or ((string-length(.) = 19) and ($year) and (substring(.,5,1) = '-') and ($month &gt;= 1 and $month &lt;= 12) and (substring(.,8,1) = '-') and ($day &gt;= 1 and $day &lt;= 31) and (substring(.,11,1) = 'T') and ($hour &gt;= 0 and $hour &lt;= 23) and (substring(.,14,1) = ':') and ($minute &gt;= 0 and $minute &lt;= 59) and (substring(.,17,1) = ':') and ($second1 &gt;=0 and $second1 &lt;= 59) and (substring(.,20,1) = 'Z'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The time position element contains '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' but should contain a year-month-day/hour-minute-second in the format CCYY-MM-DDTHH:MM:SSZ.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not((string-length(.) &gt; 12) and (string-length(.) &lt;= 19)) or          ((string-length(.) = 19) and ($year) and          (substring(.,5,1) = '-') and ($month &gt;= 1 and $month &lt;= 12) and          (substring(.,8,1) = '-') and ($day &gt;= 1 and $day &lt;= 31) and         (substring(.,11,1) = 'T') and ($hour &gt;= 0 and $hour &lt;= 23) and          (substring(.,14,1) = ':') and ($minute &gt;= 0 and $minute &lt;= 59) and         (substring(.,17,1) = ':') and ($second2 &gt;=0 and $second1 &lt;= 59) and         (substring(.,22,1) = 'Z'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not((string-length(.) &gt; 12) and (string-length(.) &lt;= 19)) or ((string-length(.) = 19) and ($year) and (substring(.,5,1) = '-') and ($month &gt;= 1 and $month &lt;= 12) and (substring(.,8,1) = '-') and ($day &gt;= 1 and $day &lt;= 31) and (substring(.,11,1) = 'T') and ($hour &gt;= 0 and $hour &lt;= 23) and (substring(.,14,1) = ':') and ($minute &gt;= 0 and $minute &lt;= 59) and (substring(.,17,1) = ':') and ($second2 &gt;=0 and $second1 &lt;= 59) and (substring(.,22,1) = 'Z'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The time position element contains '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' but should contain a year-month-day/hour-minute-second in the format CCYY-MM-DDTHH:MM:SS.SZ.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M74"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M74"/>
   <xsl:template match="@*|node()" priority="-2" mode="M74">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M74"/>
   </xsl:template>

   <!--PATTERN TimePeriod_must_not_have_InconsistentEnds-->


	<!--RULE -->
<xsl:template match="gml:TimePeriod" priority="1000" mode="M75">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="gml:TimePeriod"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(gml:begin/gml:TimeInstant/gml:timePosition/@indeterminatePosition = 'after')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(gml:begin/gml:TimeInstant/gml:timePosition/@indeterminatePosition = 'after')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The begin time position shall not have an indeterminate position of 'after'.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(gml:end/gml:TimeInstant/gml:timePosition/@indeterminatePosition = 'before')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(gml:end/gml:TimeInstant/gml:timePosition/@indeterminatePosition = 'before')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The end time position shall not have an indeterminate position of 'before'.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M75"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M75"/>
   <xsl:template match="@*|node()" priority="-2" mode="M75">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M75"/>
   </xsl:template>

   <!--PATTERN TimePeriod_must_have_PositiveDuration-->


	<!--RULE -->
<xsl:template match="gml:TimePeriod" priority="1000" mode="M76">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="gml:TimePeriod"/>
      <xsl:variable name="year_begin"
                    select="number(substring(gml:begin/gml:TimeInstant/gml:timePosition,1,4))"/>
      <xsl:variable name="month_begin"
                    select="number(substring(gml:begin/gml:TimeInstant/gml:timePosition,6,2))"/>
      <xsl:variable name="day_begin"
                    select="number(substring(gml:begin/gml:TimeInstant/gml:timePosition,9,2))"/>
      <xsl:variable name="hour_begin"
                    select="number(substring(gml:begin/gml:TimeInstant/gml:timePosition,12,2))"/>
      <xsl:variable name="minute_begin"
                    select="number(substring(gml:begin/gml:TimeInstant/gml:timePosition,15,2))"/>
      <xsl:variable name="second1_begin"
                    select="number(substring(gml:begin/gml:TimeInstant/gml:timePosition,18,2))"/>
      <xsl:variable name="second2_begin"
                    select="number(substring(gml:begin/gml:TimeInstant/gml:timePosition,18,4))"/>
      <xsl:variable name="year_end"
                    select="number(substring(gml:end/gml:TimeInstant/gml:timePosition,1,4))"/>
      <xsl:variable name="month_end"
                    select="number(substring(gml:end/gml:TimeInstant/gml:timePosition,6,2))"/>
      <xsl:variable name="day_end"
                    select="number(substring(gml:end/gml:TimeInstant/gml:timePosition,9,2))"/>
      <xsl:variable name="hour_end"
                    select="number(substring(gml:end/gml:TimeInstant/gml:timePosition,12,2))"/>
      <xsl:variable name="minute_end"
                    select="number(substring(gml:end/gml:TimeInstant/gml:timePosition,15,2))"/>
      <xsl:variable name="second1_end"
                    select="number(substring(gml:end/gml:TimeInstant/gml:timePosition,18,2))"/>
      <xsl:variable name="second2_end"
                    select="number(substring(gml:end/gml:TimeInstant/gml:timePosition,18,4))"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(gml:begin/gml:TimeInstant/@indeterminatePosition = 'unknown') and not(gml:end/gml:TimeInstant/@indeterminatePosition = 'unknown') and         ((not($year_end) or not($year_begin)) or ($year_begin &lt;= $year_end)) and         ((not($month_end) or not($month_begin)) or ($month_begin &lt;= $month_end)) and         ((not($day_end) or not($day_begin)) or ($day_begin &lt;= $day_end)) and         ((not($hour_end) or not($hour_begin)) or ($hour_begin &lt;= $hour_end)) and         ((not($minute_end) or not($minute_begin)) or ($minute_begin &lt;= $minute_end)) and         ((not($second1_end) or not($second1_begin)) or ($second1_begin &lt;= $second1_end)) and         ((not($second2_end) or not($second2_begin)) or ($second2_begin &lt;= $second2_end))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(gml:begin/gml:TimeInstant/@indeterminatePosition = 'unknown') and not(gml:end/gml:TimeInstant/@indeterminatePosition = 'unknown') and ((not($year_end) or not($year_begin)) or ($year_begin &lt;= $year_end)) and ((not($month_end) or not($month_begin)) or ($month_begin &lt;= $month_end)) and ((not($day_end) or not($day_begin)) or ($day_begin &lt;= $day_end)) and ((not($hour_end) or not($hour_begin)) or ($hour_begin &lt;= $hour_end)) and ((not($minute_end) or not($minute_begin)) or ($minute_begin &lt;= $minute_end)) and ((not($second1_end) or not($second1_begin)) or ($second1_begin &lt;= $second1_end)) and ((not($second2_end) or not($second2_begin)) or ($second2_begin &lt;= $second2_end))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The time period element specifies a non-positive duration: '<xsl:text/>
                  <xsl:value-of select="gml:begin/gml:TimeInstant/gml:timePosition"/>
                  <xsl:text/>' to '<xsl:text/>
                  <xsl:value-of select="gml:end/gml:TimeInstant/gml:timePosition"/>
                  <xsl:text/>'.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M76"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M76"/>
   <xsl:template match="@*|node()" priority="-2" mode="M76">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M76"/>
   </xsl:template>
</xsl:stylesheet>
<!--UNCLASSIFIED-->
