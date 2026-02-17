<?xml version="1.0" encoding="UTF-8"?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<!--
    This abstract pattern verifies that a term matches a value in a list using regular expression matching.
    
    $context        := the context in which the searchValue exists
    $namespaceValue := the namespace value
    $namespaceUsed  := the namespace used
    $tokenList      := the list in which to search for the searchValue
    $errMsg         := the error message text to display when the assertion fails

    </sch:pattern> 
-->
<sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" abstract="true" id="ValidateTokenValuesExistInNamespaceList">

   <sch:p xmlns:ism="urn:us:gov:ic:ism" ism:classification="U" ism:ownerProducer="USA" class="codeDesc">This abstract pattern
      verifies that a value at a given context matches a value in a list using regular expression matching. 
      The calling rule must pass the context, search term list, attribute value to check, and an error message.</sch:p>

   <sch:rule id="ValidateTokenValuesExistInNamespaceList-R1" context="$context">
      <sch:assert test="every $token in tokenize(normalize-space(string($namespaceValue)), ' ')
         satisfies not(tokenize(string($token), '-')[1]=$namespaceUsed) 
         or (every $namespaceToken in tokenize(string($token), '-')[3] satisfies $namespaceToken = $tokenList 
         or (some $item in $tokenList satisfies (matches(normalize-space($namespaceToken), concat('^',$item,'$')))))"
                  flag="error" role="error">
         <sch:value-of select="$errMsg"/>
      </sch:assert>
   </sch:rule>

</sch:pattern>
