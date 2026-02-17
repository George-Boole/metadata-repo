<?xml version="1.0" encoding="UTF-8"?><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" abstract="true" id="AllowableGencValues">  
  <sch:p class="codeDesc">
    This abstract pattern checks to see if a value exists in the IC-GENC CVEs. The following 
    parameters are used by this pattern:
    
    $context          := the context in which the searchValue exists.
    $searchTerm       := the value which you want to verify is in the list.
    $searchCodespace  := the codespace of the value
    $errMsg           := the error message text to display when the assertion fails.
  </sch:p>
  <sch:rule id="AllowableGencValues-R1" context="$context">
      <sch:assert test="some $term in document(concat('../../CVE/IC-GENC/CVEnum',upper-case(substring($searchCodespace,1,1)),translate(substring($searchCodespace,2),':',''),'.xml'))//cve:CVE/cve:Enumeration/cve:Term/cve:Value        satisfies $term=$searchTerm" flag="error" role="error">
         <sch:value-of select="$errMsg"/>
      </sch:assert>
  </sch:rule>
</sch:pattern>