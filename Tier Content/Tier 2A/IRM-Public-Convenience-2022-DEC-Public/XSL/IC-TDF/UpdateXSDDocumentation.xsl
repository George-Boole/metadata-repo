<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:xhtml="http://www.w3.org/1999/xhtml-StopBrowserRendering"
    xmlns:ism="urn:us:gov:ic:ism"
    exclude-result-prefixes="xs xd"
    version="2.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b>Nov 19, 2019</xd:p>
            <xd:p><xd:b>Author:</xd:b> dagon</xd:p>
            <xd:p>Update the header and footer annotation documentation in the generated IC-TDF XSD.</xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:output method="xml" indent="yes" encoding="utf-8" /> 
    <xsl:strip-space elements="*"/>
    
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="/">
        <xsl:choose>
            <xsl:when test="not(.//xs:annotation[.//xhtml:a/@href = '../../Documents/BASE-TDF/DesBaseTDFXml.pdf'])">
                <xsl:call-template name="AbortDueToMissingHeaderAnnotations"/>
            </xsl:when>
            <xsl:when test="not(.//xs:annotation[.//xhtml:h2/text() = 'Formal Change List'])">
                <xsl:call-template name="AbortDueToMissingFooterAnnotations"/>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template name="AbortDueToMissingHeaderAnnotations">
        <xsl:message terminate="yes">
            <xsl:value-of select="'Missing Expected Header Annotations.'"/>
        </xsl:message>
    </xsl:template>
    
    <xsl:template name="AbortDueToMissingFooterAnnotations">
        <xsl:message terminate="yes">
            <xsl:value-of select="'Missing Expected Footer Annotations.'"/>
        </xsl:message>
    </xsl:template>
    
    <!-- Update annotation documentation header (description, introduction, implementation notes section)-->
    <xsl:template match="xs:annotation[.//xhtml:a/@href = '../../Documents/BASE-TDF/DesBaseTDFXml.pdf']">
        <xs:annotation>
            <xs:documentation>
                <xhtml:h1 ism:ownerProducer="USA" ism:classification="U">Intelligence Community
                    Technical Specification XML Data Encoding Specification for Trusted Data Format
                    (IC-TDF.XML)</xhtml:h1>
            </xs:documentation>
            <xs:documentation>
                <xhtml:h2 ism:ownerProducer="USA" ism:classification="U">Notices</xhtml:h2>
                <xhtml:p ism:ownerProducer="USA" ism:classification="U">Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       </xhtml:p>
            </xs:documentation>
            <xs:documentation>
                <xhtml:h2 ism:ownerProducer="USA" ism:classification="U">Description</xhtml:h2>
                <xhtml:p ism:ownerProducer="USA" ism:classification="U">W3C XML Schema for the XML Data
                    Encoding Specification for the intelligence version of Trusted Data Format
                    (IC-TDF.XML).</xhtml:p>
            </xs:documentation>
            <xs:documentation>
                <xhtml:h2 ism:ownerProducer="USA" ism:classification="U">Introduction</xhtml:h2>
                <xhtml:p ism:ownerProducer="USA" ism:classification="U">This XML Schema file is one
                    component of the XML Data Encoding Specification (DES). Please see the document titled<xhtml:i>
                        <xhtml:a href="../../Documents/IC-TDF/DesTdfIcXml.pdf">XML Data Encoding
                            Specification for Intelligence Trusted Data Format</xhtml:a>
                    </xhtml:i>for a complete description of the encoding as well as list of all
                    components.</xhtml:p>
                <xhtml:p ism:ownerProducer="USA" ism:classification="U">It is envisioned that this
                    schema or its components, as well as other parts of the DES may be overridden for
                    localized implementations. Therefore, permission to use, copy, modify and distribute
                    this XML Schema and the other parts of the DES for any purpose is hereby granted in
                    perpetuity.</xhtml:p>
                <xhtml:p ism:ownerProducer="USA" ism:classification="U">Please reference the preceding
                    two paragraphs in all copies or variations. The developers make no representation
                    about the suitability of the schema or DES for any purpose. It is provided "as is"
                    without expressed or implied warranty.</xhtml:p>
                <xhtml:p ism:ownerProducer="USA" ism:classification="U">If you modify this XML Schema in
                    any way label your schema as a variant of IC-TDF.XML.</xhtml:p>
                <xhtml:p ism:ownerProducer="USA" ism:classification="U">Please direct all questions, bug
                    reports,or suggestions for changes to the points of contact identified in the
                    document referenced above.</xhtml:p>
            </xs:documentation>
            <xs:documentation>
                <xhtml:h2 ism:ownerProducer="USA" ism:classification="U">Implementation Notes</xhtml:h2>
                <xhtml:p ism:ownerProducer="USA" ism:classification="U">The root elements for a TDF
                    instance are either: <xhtml:ul>
                        <xhtml:li ism:ownerProducer="USA" ism:classification="U">
                            <xhtml:a href="IC-TDF_xsd_Element_TrustedDataCollection.html#TrustedDataCollection">tdf:TrustedDataCollection</xhtml:a>
                        </xhtml:li>
                        <xhtml:li ism:ownerProducer="USA" ism:classification="U">
                            <xhtml:a href="IC-TDF_xsd_Element_TrustedDataObject.html#TrustedDataObject">tdf:TrustedDataObject</xhtml:a>
                        </xhtml:li>
                    </xhtml:ul>
                </xhtml:p>
            </xs:documentation>
            <xs:documentation>
                <xhtml:h2 ism:ownerProducer="USA" ism:classification="U">Creators</xhtml:h2>
                <xhtml:p ism:ownerProducer="USA" ism:classification="U">Office of the Director of
                    National Intelligence Intelligence Community Chief Information Officer</xhtml:p>
            </xs:documentation>
        </xs:annotation>
        
    </xsl:template>
        
    <!-- Update annotation documentation footer (change history section) -->    
    <xsl:template match="xs:annotation[.//xhtml:h2/text() = 'Formal Change List']">
        
        <xs:annotation>
            <xs:documentation>
                <xhtml:h2 ism:ownerProducer="USA" ism:classification="U">Formal Change List</xhtml:h2>
                <xhtml:table ism:ownerProducer="USA" ism:classification="U" id="ChangeHistory">
                    <xhtml:caption>Change History</xhtml:caption>
                    <xhtml:thead>
                        <xhtml:tr>
                            <xhtml:th>Version</xhtml:th>
                            <xhtml:th>Date</xhtml:th>
                            <xhtml:th>By</xhtml:th>
                            <xhtml:th>Description</xhtml:th>
                        </xhtml:tr>
                    </xhtml:thead>
                    <xhtml:tbody>
                        <xhtml:tr>
                            <xhtml:td>2017-JUL</xhtml:td>
                            <xhtml:td>2017-04-27</xhtml:td>
                            <xhtml:td>ODNI/OCIO/ICEA</xhtml:td>
                            <xhtml:td>
                                <xhtml:ul>
                                    <xhtml:li ism:ownerProducer="USA" ism:classification="U">
                                        The schema change logs will no longer be maintained as of the 2017-JUL release. 
                                        The existing change logs will only serve as legacy information. 
                                        For changes to schema as of and after 2017-JUL, reference the change history in the DES.</xhtml:li>	
                                </xhtml:ul>
                            </xhtml:td>
                        </xhtml:tr>
                        <xhtml:tr>
                            <xhtml:td>2014-DEC</xhtml:td>
                            <xhtml:td>2014-10-28</xhtml:td>
                            <xhtml:td>Hodges, ODNI/CIO/ME/EI&amp;A</xhtml:td>
                            <xhtml:td>Changed assertion group to be 1-to-1 instead of 1-to-Many for TDO which was missed previously.</xhtml:td>
                        </xhtml:tr>
                        <xhtml:tr>
                            <xhtml:td>2014-DEC</xhtml:td>
                            <xhtml:td>2014-12-04</xhtml:td>
                            <xhtml:td>ODNI/OCIO/ICEA</xhtml:td>
                            <xhtml:td>Enforced DESVersion with a pattern instead of a fixed value to allow extension versions</xhtml:td>
                        </xhtml:tr>
                        <xhtml:tr>
                            <xhtml:td>2014-DEC</xhtml:td>
                            <xhtml:td>2014-08-28</xhtml:td>
                            <xhtml:td>Lucas, ODNI/CIO/ME/EI&amp;A</xhtml:td>
                            <xhtml:td>Updated to support Revision Recall Handling Assertion.</xhtml:td>
                        </xhtml:tr>
                        <xhtml:tr>
                            <xhtml:td>2014-DEC</xhtml:td>
                            <xhtml:td>2014-08-28</xhtml:td>
                            <xhtml:td>Hodges, ODNI/CIO/ME/EI&amp;A</xhtml:td>
                            <xhtml:td>Added additional encryption fields for:
                                <xhtml:ul>
                                    <xhtml:li>Initialization Vector</xhtml:li>
                                    <xhtml:li>tweak</xhtml:li>
                                    <xhtml:li>nonce</xhtml:li>
                                    <xhtml:li>hash algorithm</xhtml:li>
                                    <xhtml:li>Mask Generation Function</xhtml:li>
                                    <xhtml:li>Addition Authentification Data</xhtml:li>
                                    <xhtml:li>authentication tag</xhtml:li>
                                    <xhtml:li>key encoding format</xhtml:li>
                                    <xhtml:li>Provable Data Possession wrapped keys</xhtml:li>
                                </xhtml:ul>
                            </xhtml:td>
                        </xhtml:tr>
                        <xhtml:tr>
                            <xhtml:td>2014-DEC</xhtml:td>
                            <xhtml:td>2014-08-28</xhtml:td>
                            <xhtml:td>Hodges, ODNI/CIO/ME/EI&amp;A</xhtml:td>
                            <xhtml:td>Enforcing ordinger so Handling assertions comes first:
                                <xhtml:ul>
                                    <xhtml:li>Changed cardinality of assertion group to be 1-to-1 instead of 1-to-Many for TDC</xhtml:li>
                                    <xhtml:li>Changed cardinality of HandlingAssertions in assertionGroup to be 1-to-Many from 1-to-1</xhtml:li>
                                    <xhtml:li>Changed cardinality of HandlingAssertions in assertionGroup to be 0-to-Many from 1-to-1</xhtml:li>
                                </xhtml:ul>
                            </xhtml:td>
                        </xhtml:tr>
                        <xhtml:tr>
                            <xhtml:td>3</xhtml:td>
                            <xhtml:td>2013-05-27</xhtml:td>
                            <xhtml:td>Clay, ODNI/CIO/ME/DIA</xhtml:td>
                            <xhtml:td>Removed scope [TDO PAYL]</xhtml:td>
                        </xhtml:tr>
                        <xhtml:tr>
                            <xhtml:td>2</xhtml:td>
                            <xhtml:td>2012-11-12</xhtml:td>
                            <xhtml:td>D'Ambra, ODNI/CIO/ME/DIA</xhtml:td>
                            <xhtml:td>Added scopes [DESC_TDO], [DESC_PAYL] and [TDC_MEMBER] for use
                                within TDC Assertions</xhtml:td>
                        </xhtml:tr>
                        <xhtml:tr>
                            <xhtml:td>2</xhtml:td>
                            <xhtml:td>2012-11-12</xhtml:td>
                            <xhtml:td>Gilsenan, ODNI/CIO/ME/DIA</xhtml:td>
                            <xhtml:td>Added support for multiple binding by changing @max to "unbounded"
                                on Binding element in the BindingGroup</xhtml:td>
                        </xhtml:tr>
                        <xhtml:tr>
                            <xhtml:td>2</xhtml:td>
                            <xhtml:td>2012-11-11</xhtml:td>
                            <xhtml:td>D'Ambra, ODNI/CIO/ME/DIA</xhtml:td>
                            <xhtml:td>Changed @version to be fixed to 2</xhtml:td>
                        </xhtml:tr>                 
                    </xhtml:tbody>
                </xhtml:table>
            </xs:documentation>
        </xs:annotation>
    </xsl:template>
    
</xsl:stylesheet>