<?xml version="1.0" encoding="utf-8"?>
<?ICEA abstractPattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<!--
    This abstract pattern checks to see if an attribute of an element exists in a list.

    $context     := the context in which the searchValue exists
    $searchTerm  := the value which you want to verify is in the list
    $list        := the list in which to search for the searchValue
    $errMsg      := the error message text to display when the assertion fails
    
    Example usage:
    <sch:pattern xmlns:ism="urn:us:gov:ic:ism" is-a="ValidateValueExistenceInList" id="IRM_ID_00027" xmlns:sch="http://purl.oclc.org/dsdl/schematron">  
           <sch:param name="context" value="tdf:*[tdf:Assertion//irm:ICResourceMetadataPackage]/tdf:Assertion/tdf:StructuredStatement/irm:resource//irm:language"/>
           <sch:param name="searchTerm" value="@irm:qualifier"/>
           <sch:param name="list" value="$compoundLanguageQualifierTypeList"/>
           <sch:param name="errMsg" value="'
                  [IRM-ID-00034][Error] For element irm:language, attribute irm:qualifier must have a 
                  value in CVEnumIRMCompoundLanguageQualifierType.xml.'"/>
    </sch:pattern>
    
    Note: $iso4217TrigraphList is defined in the main document, IRM_XML.xml.
-->
<sch:pattern xmlns:ism="urn:us:gov:ic:ism"
             xmlns:sch="http://purl.oclc.org/dsdl/schematron"
             abstract="true"
             id="ValidateValueExistenceInList">
    <sch:p class="codeDesc"
           ism:classification="U"
           ism:ownerProducer="USA">$context := the context in which the searchValue exists</sch:p>
    <sch:p class="codeDesc"
           ism:classification="U"
           ism:ownerProducer="USA">$searchTerm := the value which you want to verify is in the list</sch:p>
    <sch:p class="codeDesc"
           ism:classification="U"
           ism:ownerProducer="USA">$list := the list in which to search for the searchValue</sch:p>
    <sch:p class="codeDesc"
           ism:classification="U"
           ism:ownerProducer="USA">$errMsg := the error message text to display when the assertion fails</sch:p>
    <sch:p class="codeDesc"
           ism:classification="U"
           ism:ownerProducer="USA">This abstract pattern checks to see if an attribute of an element exists in a list.</sch:p>
    <sch:rule id="ValidateValueExistenceInList-R1"
              context="$context">
        <sch:assert test=" some $token in $list satisfies $token = $searchTerm or matches($searchTerm, concat('^',$token,'$'))"
                    flag="error"
                    role="error">
            <sch:value-of select="$errMsg" />
        </sch:assert>
    </sch:rule>
</sch:pattern>
