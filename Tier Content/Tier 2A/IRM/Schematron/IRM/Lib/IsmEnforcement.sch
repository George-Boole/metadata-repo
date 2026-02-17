<?xml version="1.0" encoding="utf-8"?>
<?ICEA abstractPattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<!--
    This abstract pattern checks that if a particular qualifier is specified on a
    irm:type element that ism:classification is also specified.
    
    $qualifier   := the qualifier value that requires ism to be present
    $errMsg      := the error message text to display when the assertion fails
    
    Example usage:
    <sch:pattern xmlns:ism="urn:us:gov:ic:ism" is-a="DdmsTypeIsmEnforcement" id="IRM_ID_00039" xmlns:sch="http://purl.oclc.org/dsdl/schematron">
    <sch:param name="ruleText" value=""/>
    <sch:param name="codeDesc" value=""/>
    <sch:param name="context" value="irm:type[@irm:qualifier=$qualifier]"/>
    <sch:param name="errMsg" value="'
    [IRM-ID-00039][Error]
    If irm:type is specified with a qualifier of urn:us:gov:ic:irm:productline then
    ism:classification must also be specified.
    '"/>
    </sch:pattern>
    
    Note: $iso4217TrigraphList is defined in the main document, IRM_XML.xml.
-->
<sch:pattern xmlns:ism="urn:us:gov:ic:ism"
             xmlns:sch="http://purl.oclc.org/dsdl/schematron"
             abstract="true"
             id="IsmEnforcement">
    <sch:p class="codeDesc"
           ism:classification="U"
           ism:ownerProducer="USA">$qualifier := the qualifier value that requires ism to be present</sch:p>
    <sch:p class="codeDesc"
           ism:classification="U"
           ism:ownerProducer="USA">$errMsg := the error message text to display when the assertion fails</sch:p>
    <sch:p class="codeDesc"
           ism:classification="U"
           ism:ownerProducer="USA">This abstract pattern checks that if a particular qualifier is specified on a irm:type element that
           ism:classification is also specified.</sch:p>
    <sch:p class="codeDesc"
           ism:classification="U"
           ism:ownerProducer="USA">Example usage: &lt;sch:pattern xmlns:ism="urn:us:gov:ic:ism" is-a="DdmsTypeIsmEnforcement" id="IRM_ID_00039"
           xmlns:sch="http://purl.oclc.org/dsdl/schematron"&gt; &lt;sch:param name="ruleText" value=""/&gt; &lt;sch:param name="codeDesc"
           value=""/&gt; &lt;sch:param name="context" value="irm:type[@irm:qualifier=$qualifier]"/&gt; &lt;sch:param name="errMsg" value="'
           [IRM-ID-00039][Error] If irm:type is specified with a qualifier of urn:us:gov:ic:irm:productline then ism:classification must also be
           specified. '"/&gt; &lt;/sch:pattern&gt; Note: $iso4217TrigraphList is defined in the main document, IRM_XML.xml.</sch:p>
    <sch:rule id="IsmEnforcement-R1"
              context="$context">
        <sch:assert test="@ism:classification"
                    flag="error"
                    role="error">
            <sch:value-of select="$errMsg" />
        </sch:assert>
    </sch:rule>
</sch:pattern>
