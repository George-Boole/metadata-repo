<?xml version="1.0" encoding="UTF-8"?>
<sch:pattern abstract="true" id="ICIdentifierRestrictions"
	xmlns:sch="http://purl.oclc.org/dsdl/schematron">
  <sch:p id="codeDesc">
    A valid IC-Identifier must meet the following criteria:
    (1) The id must begin with 'guide://'
    (2) The prefix for the id is an integer up to 16 digits with no leading zeros allowed
    (3) The suffix is an alphanumeric string limited to 36 characters of the set that includes A-Z, a-z, 0-9, underscore, hyphen, and period
    (4) There are no additional characters proceeding the ID.
    In order to determine the provided IC-Identifier meets these criteria, the value parameter is 
    matched against the following regex: ^guide://([1-9][0-9]{0,15}|0)/[A-Za-z0-9_\-\.]{1,36}$.  
  </sch:p>
  <sch:rule context="$context">
    <sch:let name="icidRegEx" value="'^guide://([1-9][0-9]{0,15}|0)/[A-Za-z0-9_\-\.]{1,36}$'"/>
    <sch:assert 
      test="matches(string($value),$icidRegEx)"
      flag="error">
      <sch:value-of select="$errorMessage"/>
    </sch:assert>
	</sch:rule>
</sch:pattern>  