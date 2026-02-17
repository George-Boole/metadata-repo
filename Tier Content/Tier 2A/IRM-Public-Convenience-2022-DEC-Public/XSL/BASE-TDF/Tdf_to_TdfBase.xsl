<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xhtml="http://www.w3.org/1999/xhtml"
	xmlns:ism="urn:us:gov:ic:ism" exclude-result-prefixes="xs" version="2.0">

	<!-- **************************************************************** -->
	<!-- Identity template -->
	<!-- **************************************************************** -->
	<xsl:template match="@*|node()" name="identity">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" />
		</xsl:copy>
	</xsl:template>

	<xsl:template match="//xs:complexType[@name='KeyAccessType']/xs:any"/>

	<xsl:template match="//xs:complexType[@name='BindingInformationType']//xs:element[@ref='ds:KeyInfo']"/>

	<xsl:template match="//xs:element[@name='EncryptionInformation']//xs:any"/>
	
</xsl:stylesheet>