<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:ch="urn:x-us:gov:ic:tdf:changes"
                xmlns:xslo="dummy"
                exclude-result-prefixes="ch"
                version="2.0">
<!--
     A stylesheet to convert XPath expressions of changes into a stylesheet
     to actually perform the changes on an input file.

     $Id: changes2xsl.xsl,v 1.4 2006/04/05 19:31:17 holmank Exp $
-->

<xsl:namespace-alias stylesheet-prefix="xslo" result-prefix="xsl"/>

<xsl:output indent="yes" encoding="US-ASCII"/>

<!--========================================================================-->
<!--start the result stylesheet-->

<xsl:template match="ch:changes">
  <!-- NOTE: add namespaces that we need to propagate to xslo:stylesheet tag -->
  <xslo:stylesheet xmlns:edh="urn:us:gov:ic:edh" xmlns:arh="urn:us:gov:ic:arh" xmlns:rr="urn:us:gov:ic:revrecall">
    <!--reduce namespace declarations by doing this up front-->
    <xsl:copy-of select="namespace::*"/>
    <xsl:attribute name="version">2.0</xsl:attribute>
    <xsl:attribute name="exclude-result-prefixes">
      <xsl:for-each select="namespace::*[.='urn:x-us:gov:ic:tdf:changes']">
        <xsl:value-of select="name(.)"/>
      </xsl:for-each>
    </xsl:attribute>
    <xslo:output encoding="US-ASCII"/>
    <xsl:text>
</xsl:text>
    <xsl:comment>present documentation before input comments</xsl:comment>
    <xslo:template match="/">
      <xsl:if test="ch:documentation">
        <xslo:text xml:space="preserve">
</xslo:text>
        <xslo:comment><xsl:value-of select="ch:documentation"/></xslo:comment>
        <xslo:text xml:space="preserve">
</xslo:text>
      </xsl:if>
      <xslo:apply-templates/>
    </xslo:template>

    <xsl:text>
</xsl:text>
    <xsl:comment>assume comments in prologue start on new lines</xsl:comment>
    <xslo:template match="/comment()">
      <xslo:text xml:space="preserve">
</xslo:text>
      <xslo:copy/>
    </xslo:template>

    <xsl:text>
</xsl:text>
    <xsl:comment>assume document element not being matched; copy namespaces to reduce the need for declarations</xsl:comment>
    <xsl:text>
</xsl:text>
    <xslo:template match="/*">
      <xslo:text xml:space="preserve">
</xslo:text>
      <xslo:element name="{{name(/*)}}" namespace="{{namespace-uri(/*)}}">
        <xslo:copy-of select="(/ | document(''))/*/
                     namespace::*[.!='http://www.w3.org/1999/XSL/Transform'
                              and .!='urn:x-us:gov:ic:tdf:changes']"/>
        <xslo:apply-templates select="@*|node()"/>
      </xslo:element>
    </xslo:template>

    <xsl:text>
</xsl:text>
    <xsl:comment>Identity transform for all unmached leaf nodes</xsl:comment>
    <xsl:text>
</xsl:text>
    <xslo:template match="@*|text()|comment()|processing-instruction()">
      <xslo:copy/>
    </xslo:template>
    <xsl:text>
</xsl:text>
    <xsl:comment>Identity transform for all unmached elements</xsl:comment>
    <xsl:text>
</xsl:text>
    <xslo:template match="*">
      <xslo:element name="{{name(.)}}" namespace="{{namespace-uri(.)}}">
        <xslo:apply-templates select="@*|node()"/>
      </xslo:element>
    </xslo:template>

    <xsl:text>
</xsl:text>
    <xsl:comment>Using a template allows xml:space to be used in param</xsl:comment>
    <xsl:text>
</xsl:text>
    <xslo:template name="copy-content">
      <xslo:param name="rtf"/>
      <xslo:copy-of select="$rtf"/>
    </xslo:template>

    <xsl:text>
</xsl:text>
    <xsl:comment>Expose current element's start tag</xsl:comment>
    <xsl:text>
</xsl:text>
    <xslo:template name="show-old-start-tag">
      <xslo:comment>
        <xslo:text xml:space="preserve">Replacing:
</xslo:text>
        <xslo:apply-templates mode="expose" select=".">
          <xslo:with-param name="suppress" select="true()"/>
        </xslo:apply-templates>
        <xslo:text xml:space="preserve">
</xslo:text>
      </xslo:comment>
    </xslo:template>
    <xslo:template name="show-old-element">
      <xslo:comment>
        <xslo:text xml:space="preserve">Replacing:
</xslo:text>
        <xslo:apply-templates mode="expose" select="."/>
        <xslo:text xml:space="preserve">
</xslo:text>
      </xslo:comment>
    </xslo:template>
    <xslo:template mode="expose" match="*">
      <xslo:param name="suppress" select="false()"/>
      <xslo:value-of disable-output-escaping="yes"
                     select="concat('&lt;',name(.))"/>
      <xslo:for-each select="@*">
        <xslo:value-of select="concat(' ',name(.),'=&quot;',.,'&quot;')"/>
      </xslo:for-each>
      <xslo:if test="not(node())">/</xslo:if>
      <xslo:text>></xslo:text>
      <xslo:if test="not( $suppress ) and node()">
        <xslo:apply-templates mode="expose"/>
        <xslo:value-of disable-output-escaping="yes"
                       select="concat('&lt;/',name(.),'>')"/>
      </xslo:if>
    </xslo:template>
    <xslo:template mode="expose" match="comment()">
      <xslo:value-of disable-output-escaping="yes"
                     select="concat('&lt;!-',.,'->')"/>
    </xslo:template>
    <xslo:template mode="expose" match="processing-instruction()">
      <xslo:value-of disable-output-escaping="yes"
                     select="concat('&lt;?',name(.),' ',.,'?>')"/>
    </xslo:template>

    <xsl:text>
</xsl:text>
    <xsl:comment>Specific node changes follow</xsl:comment>
    <xsl:text>
</xsl:text>
    <xsl:apply-templates/>
  </xslo:stylesheet>
</xsl:template>

<!--========================================================================-->
<!--copying the source tree content into the output stylesheet as stylesheet
    directives; requires preserving comments using a comment instruction-->

<xsl:template mode="copy-content" match="comment()" priority="2">
  <xslo:comment><xsl:value-of select="."/></xslo:comment>
</xsl:template>

<xsl:template mode="copy-content" match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates mode="copy-content" select="@*|node()"/>
  </xsl:copy>
</xsl:template>

<!--========================================================================-->
<!--different directives-->

<!--documentation already handled-->
<xsl:template match="ch:documentation"/>

<!--add content after the element being matched-->
<xsl:template match="ch:injectAfter">
  <xsl:call-template name="checkAttributes"/>
  <xsl:comment>injectAfter</xsl:comment>
  <xslo:template match="{@ch:match}">
    <xslo:copy>
      <xslo:apply-templates select="@*|node()"/>
    </xslo:copy>
    <xslo:call-template name="copy-content">
      <xslo:with-param name="rtf">
        <xsl:attribute name="xml:space">preserve</xsl:attribute>
        <xsl:apply-templates mode="copy-content" select="node()"/>
      </xslo:with-param>
    </xslo:call-template>
  </xslo:template>
</xsl:template>

<!--add content before the element being matched-->
<xsl:template match="ch:injectBefore">
  <xsl:call-template name="checkAttributes"/>
  <xsl:comment>injectBefore</xsl:comment>
  <xslo:template match="{@ch:match}">
    <xslo:call-template name="copy-content">
      <xslo:with-param name="rtf">
        <xsl:attribute name="xml:space">preserve</xsl:attribute>
        <xsl:apply-templates mode="copy-content" select="node()"/>
      </xslo:with-param>
    </xslo:call-template>
    <xslo:copy>
      <xslo:apply-templates select="@*|node()"/>
    </xslo:copy>
  </xslo:template>
</xsl:template>

<!--add content at the beginning of the element being matched-->
<xsl:template match="ch:injectStart">
  <xsl:call-template name="checkAttributes"/>
  <xsl:comment>injectStart</xsl:comment>
  <xslo:template match="{@ch:match}">
    <xslo:copy>
      <xslo:apply-templates select="@*"/>
      <xslo:call-template name="copy-content">
        <xslo:with-param name="rtf">
          <xsl:attribute name="xml:space">preserve</xsl:attribute>
          <xsl:apply-templates mode="copy-content" select="node()"/>
        </xslo:with-param>
      </xslo:call-template>
      <xslo:apply-templates select="node()"/>
    </xslo:copy>
  </xslo:template>
</xsl:template>

<!--add content at the end of the element being matched-->
<xsl:template match="ch:injectEnd">
  <xsl:call-template name="checkAttributes"/>
  <xsl:comment>injectEnd</xsl:comment>
  <xslo:template match="{@ch:match}">
    <xslo:copy>
      <xslo:apply-templates select="@*|node()"/>
      <xslo:call-template name="copy-content">
        <xslo:with-param name="rtf">
          <xsl:attribute name="xml:space">preserve</xsl:attribute>
          <xsl:apply-templates mode="copy-content" select="node()"/>
        </xslo:with-param>
      </xslo:call-template>
    </xslo:copy>
  </xslo:template>
</xsl:template>

<!--add attributes to the element being matched-->
<xsl:template match="ch:injectAttributes">
  <xsl:call-template name="checkAttributes"/>
  <xsl:comment>injectAttribute</xsl:comment>
  <xslo:template match="{@ch:match}">
    <xslo:call-template name="show-old-start-tag"/>
    <xslo:call-template name="copy-content">
      <xslo:with-param name="rtf">
        <xsl:attribute name="xml:space">preserve</xsl:attribute>
        <xsl:apply-templates mode="copy-content" select="text()|comment()"/>
      </xslo:with-param>
    </xslo:call-template>
    <xslo:copy>
      <xslo:apply-templates select="@*"/>
      <xsl:for-each select="@*[count(../@ch:* | .) != count( ../@ch:* )]">
        <xslo:attribute name="{name(.)}" namespace="{namespace-uri(.)}">
          <xsl:value-of select="."/>
        </xslo:attribute>
      </xsl:for-each>
      <xslo:apply-templates select="node()"/>
    </xslo:copy>
  </xslo:template>
</xsl:template>
  
  <!--add namespace to the element being matched-->
 <!-- <xsl:template match="ch:injectNamespaces">
    <xsl:call-template name="checkAttributes"/>
    <xsl:comment>injectNamespace</xsl:comment>
    <xslo:template match="{@ch:match}">
      <xslo:call-template name="show-old-start-tag"/>
      <xslo:call-template name="copy-content">
        <xslo:with-param name="rtf">
          <xsl:attribute name="xml:space">preserve</xsl:attribute>
          <xsl:apply-templates mode="copy-content" select="text()|comment()"/>
        </xslo:with-param>
      </xslo:call-template>
      <xslo:copy>
        <xslo:apply-templates select="@*"/>
        <xsl:for-each select="@*[count(../@ch:* | .) != count( ../@ch:* )]">
          <xslo:namespace name="{name(.)}" select="'{.}'"/>
        </xsl:for-each>
        <xslo:apply-templates select="node()"/>
      </xslo:copy>
    </xslo:template>
  </xsl:template>-->

<!--replace the element being matched-->
<xsl:template match="ch:replaceElement">
  <xsl:call-template name="checkAttributes"/>
  <xsl:comment>replaceElement</xsl:comment>
  <xslo:template match="{@ch:match}">
    <xslo:call-template name="show-old-element"/>
    <xslo:call-template name="copy-content">
      <xslo:with-param name="rtf">
        <xsl:attribute name="xml:space">preserve</xsl:attribute>
        <xsl:apply-templates mode="copy-content" select="node()"/>
      </xslo:with-param>
    </xslo:call-template>
  </xslo:template>
</xsl:template>

<!--report missing required attribute-->
<xsl:template name="checkAttributes">
  <xsl:if test="not(@ch:match)">
    <xsl:message terminate="yes">
      <xsl:text>Missing {urn:x-us:gov:ic:tdf:changes}match= for </xsl:text>
      <xsl:text/>element: <xsl:value-of select="name(.)"/>
    </xsl:message>
  </xsl:if>
</xsl:template>

<!--unexpected element-->
<xsl:template match="*">
  <xsl:message terminate="yes">
    <xsl:text/>Unexpected element: <xsl:value-of select="name(.)"/>
  </xsl:message>
</xsl:template>

</xsl:stylesheet>