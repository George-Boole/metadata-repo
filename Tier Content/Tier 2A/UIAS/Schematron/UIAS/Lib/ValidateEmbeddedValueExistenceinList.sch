<?xml version="1.0" encoding="UTF-8"?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<!--
    This abstract pattern checks to see if embedded strings in tokens with delimiting characters in an attribute of an element exists in a list or 
    matches the pattern defined by the list.

    $context        := the context in which the searchValue exists
    $searchTermList := the set of values which you want to verify is in the list
    $list           := the list in which to search for the searchValue
    $substringAfter := a string that identifies the characters before the start of the value of interest
    $substringBefore:= a string that identifies the characters after the start of the value of interest
    $prefix         := a string that is used to filter the $searchTermList by selecting only those tokens that start with $prefix. 
                       The rule does not apply to tokens that do NOT start with $prefix.
    $errMsg         := the error message text to display when the assertion fails
    
    Example usage:
    <sch:pattern is-a="ValidateValueExistenceInList" id="UIAS-ID-00081" xmlns:sch="http://purl.oclc.org/dsdl/schematron">  
        <sch:param name="context" value="saml:Attribute[@Name='fineAccessControls'][contains(./saml:AttributeValue,'SAR-')]"/>
        <sch:param name="searchTermList" value="./saml:AttributeValue"/>
        <sch:param name="list" value="$SARSourceAuthorityList"/>
        <sch:param name="substringAfter" value="'SAR-'"
        <sch:param name="substringBefore" value="':'"
        <sch:param name="prefix" value="'SAR-'"
        <sch:param name="errMsg" value="'
    		[ISM-ID-00530][Error] The SAR tokens in fineAccessControls must start with a substring before ':' and after 'SAR-' that exists
        in the SAR Source Authorities CVE.  Example from SAR tokens in fineAccessControls is SAR-DOD:TS:DEMOSAP1. The string DOD must be
        found in the SAR Source Authorities CVE.
        '"/>
    </sch:pattern>

-->
<sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" abstract="true" id="ValidateEmbeddedValueExistenceinList">
    <sch:p xmlns:ism="urn:us:gov:ic:ism" ism:classification="U" ism:ownerProducer="USA" class="codeDesc">
        This abstract pattern checks to see if an embedded string within an attribute of an element exists
        in a list or matches the pattern defined by the list. The calling rule must pass the
        context, search term list, attribute value to check, the substring to start after, the substring to stop before, a prefix,
        and an error message.  The logic excludes tokens that do not start with $prefix.  Example from SAR tokens in fineAccessControls 
        is SAR-DOD:TS:DEMOSAP1.  The string DOD must be found in the SAR Source Authorities CVE.
        </sch:p>
    <sch:rule id="ValidateEmbeddedValueExistenceInList-R1" context="$context">
        <sch:assert 
            test="every $searchTerm in tokenize(normalize-space(string($searchTermList)), ' ') satisfies not(starts-with($searchTerm,$prefix)) or
            ((substring-before((substring-after($searchTerm,$substringAfter)),$substringBefore)) = $list 
            or (some $Term in $list satisfies (matches(substring-before(substring-after(normalize-space($searchTerm),$substringAfter),$substringBefore), concat('^', $Term ,'$')))))" 
            flag="error" role="error">
            <sch:value-of select="$errMsg"/>
        </sch:assert>
    </sch:rule>
</sch:pattern>