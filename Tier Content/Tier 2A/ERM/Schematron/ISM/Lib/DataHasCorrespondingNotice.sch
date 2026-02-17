<?xml version="1.0" encoding="UTF-8"?><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" abstract="true" id="DataHasCorrespondingNotice">

	<sch:p class="codeDesc">Abstract pattern to enforce that an appropriate notice exists for an
		element in $partTags that has a notice requirement. The calling rule must pass $elem,
		$attrName, $partTags, and $noticeType.</sch:p>

	<sch:rule id="DataHasCorrespondingNotice-R1" context="*[$ISM_USGOV_RESOURCE and util:contributesToRollup(.) and util:containsAnyOfTheTokens($attrValue, ($noticeType))]">
		<sch:assert test="some $elem in $partTags satisfies ($elem[@ism:noticeType] and util:containsAnyOfTheTokens($elem/@ism:noticeType, ($noticeType)) and not ($elem/@ism:externalNotice=true()))" flag="error" role="error">[<sch:value-of select="$ruleId"/>][Error] If ISM_USGOV_RESOURCE, any
			element meeting ISM_CONTRIBUTES in the document has the attribute <sch:value-of select="$attrName"/> containing [<sch:value-of select="$noticeType"/>], then some
			element meeting ISM_CONTRIBUTES in the document MUST have attribute noticeType
			containing [<sch:value-of select="$noticeType"/>].</sch:assert>
	</sch:rule>
</sch:pattern>