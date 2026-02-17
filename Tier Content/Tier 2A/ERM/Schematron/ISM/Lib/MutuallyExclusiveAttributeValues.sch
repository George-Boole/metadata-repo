<?xml version="1.0" encoding="UTF-8"?><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" abstract="true" id="MutuallyExclusiveAttributeValues">
	
	<sch:p class="codeDesc">Abstract pattern to ensure that mutually exclusive tokens do not exist in
		an attribute. The calling rule must pass $attrValue and $mutuallyExclusiveTokenList.</sch:p>
	<sch:rule id="MutuallyExclusiveAttributeValues-R1" context="$context">
		<sch:assert test="count( for $token in tokenize(normalize-space(string($attrValue)),' ') return  if($token = $mutuallyExclusiveTokenList) then 1 else null ) = 1" flag="error" role="error">
			<sch:value-of select="$errMsg"/>
		</sch:assert>
	</sch:rule>
</sch:pattern>