<?xml version="1.0" encoding="UTF-8"?><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" abstract="true" id="AttributeContributesToRollupWithException">
  <sch:p class="codeDesc">
    If the document is an ISM_USGOV_RESOURCE and an element meeting ISM_CONTRIBUTES
    specifies attribute ism:$attrLocalName with a value containing the token
    [$value] and the exception value(s) are not present, then this rule ensures that 
    the ISM_RESOURCE_ELEMENT specifies the attribute ism:$attrLocalName with a 
    value containing the token [$value].
  </sch:p>
  <sch:rule id="AttributeContributesToRollupWithException-R1" context="*[$ISM_USGOV_RESOURCE                       and generate-id(.) = generate-id($ISM_RESOURCE_ELEMENT)                       and not(some $ele in $partTags satisfies                           util:containsAnyOfTheTokens($ele/@ism:$exceptAttrLocalName, $exceptValueList)                       )                       and (                         some $ele in $partTags satisfies                           util:containsAnyOfTheTokens($ele/@ism:$attrLocalName, ('$value'))                       )]">
      <sch:assert test="util:containsAnyOfTheTokens(@ism:$attrLocalName, ('$value'))" flag="error" role="error">
			      <sch:value-of select="$errorMessage"/>
      </sch:assert>
	  </sch:rule>
</sch:pattern>