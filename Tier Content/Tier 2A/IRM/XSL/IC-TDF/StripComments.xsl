<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    exclude-result-prefixes="xs xd"
    version="2.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Mar 13, 2019</xd:p>
            <xd:p><xd:b>Author:</xd:b> bob</xd:p>
            <xd:p>Strip comments and annotations out of xsd file to make the smallest simple file for a guard.</xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:output method="xml" indent="yes"  encoding="utf-8" /> 
    <xsl:strip-space elements="*"/>
    
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>
            <xd:p>Strip out all comments, PIs and xs:annotations.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="comment()|processing-instruction()|xs:annotation" priority="5"/>
</xsl:stylesheet>