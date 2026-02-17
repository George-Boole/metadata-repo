<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema" 
    xmlns:ded="urn:us:gov:ic:ded"
    xmlns:ism="urn:us:gov:ic:ism" 
    xmlns:arh="urn:us:gov:ic:arh" 
    xmlns:edh="urn:us:gov:ic:edh"
    xmlns:icid="urn:us:gov:ic:id" 
    xmlns:pubs="urn:us:gov:ic:pubs"
    xmlns:cem="urn:us:gov:ic:cem"
    xmlns:src="urn:us:gov:ic:src"
    xmlns:mime="urn:us:gov:ic:mime"
    xmlns:intdis="urn:us:gov:ic:intdis"
    xmlns:irm="urn:us:gov:ic:irm"
    xmlns:virt="urn:us:gov:ic:virt"
    xmlns:usagency="urn:us:gov:ic:usagency"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:xhtml-orig="http://www.w3.org/1999/xhtml"
    xmlns:xhtml="http://www.w3.org/1999/xhtml-StopBrowserRendering"
    xmlns:ox="http://www.oxygenxml.com/ns/doc/schema-internal"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:gml="http://www.opengis.net/gml/3.2"
    xmlns:pubcitcat="urn:us:gov:ic:cvenum:pubsxml:citycategory"
    xmlns:intdisd="urn:us:gov:ic:cvenum:intdis:inteldiscipline"
    xmlns:pubident="urn:us:gov:ic:cvenum:pubsxml:identifiertype"
    xmlns:pubcomdat="urn:us:gov:ic:cvenum:pubsxml:commdatatype"
    xmlns:irmlanguage="urn:us:gov:ic:cvenum:irm:language:qualifier"
    xmlns:xhtmlreal="http://www.w3.org/1999/xhtml"
    version="2.0">
    
  <xsd:doc scope="stylesheet">
    <xsd:desc>
      <xsd:p>
        <xsd:b>Created on: 2022-03</xsd:b>
      </xsd:p>
      <xsd:p><xsd:b>Author: Mike C.</xsd:b>IC-CIO</xsd:p>
      <xsd:p/>
    </xsd:desc>
  </xsd:doc>
  
  <xsl:output indent="yes"/>
  <xsl:strip-space elements="ox:*"/>
  
  <xsd:doc>
    <xsd:desc>identity template</xsd:desc>
  </xsd:doc>
  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="/xsd:schema">
    <xsd:schema>
      <xsl:attribute name="targetNamespace" select='"urn:us:gov:ic:pubs"'/>
      <xsl:apply-templates select="@* | node()"/>
      <xsl:element name="xsd:annotation">
        <xsl:element name="xsd:appinfo">
          <xsl:apply-templates select="document('/Users/mike/Documents/SVN-Checkout/2022-MAY/2022-MAY/trunk/XmlEncodings/Schema/IC-TDF/IC-TDF/IC-TDF_oxy_ed.xml')/ox:schemaDoc/*"/>
        </xsl:element>
      </xsl:element>
    </xsd:schema>
  </xsl:template>
  
</xsl:stylesheet>
