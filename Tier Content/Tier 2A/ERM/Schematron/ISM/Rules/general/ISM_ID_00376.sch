<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="ISM-ID-00376">
	  <sch:p class="ruleText">
	  	[ISM-ID-00376][Error]A portion using tetragraphs may not have a releasableTo 
	  	that is less restrictive than the releasability of any tetragraph or organization tokens used
	  	in the same portion’s releasableTo, displayOnlyto, FGISourceOpen, or FGISourceProtected fields.
	</sch:p>
	  <sch:p class="codeDesc">
	  	Determine the set of releasable countries by determining, for each token, if it is a country code or tetragraph.
	  	If it is a tetragraph get the membership from CATT, otherwise add the token to the list. Then determine if any
	  	of the tetragraph tokens have releasability restrictions themselves. If so, add that token to a list. Finally,
	  	determine if the releasability of the tetragraph tokens are more restrictive then the releasability of the portion.
	  	If there are, trigger the error message.
	</sch:p>
	  <sch:rule id="ISM-ID-00376-R1" context="*[@ism:ownerProducer]">
	  	<sch:let name="releasableToCountries" value="distinct-values(for $value in tokenize(normalize-space(@ism:releasableTo),' ') return      if(index-of($catt//catt:TetraToken,$value)&gt;0)      then util:tokenize(util:getTetragraphMembership($value))      else $value)"/>
	  	
	  	<sch:let name="myTetras" value="for $value in distinct-values(for $each in distinct-values((@ism:ownerProducer | @ism:releasableTo | @ism:displayOnlyTo | @ism:FGIsourceOpen | @ism:FGIsourceProtected)) return util:tokenize($each)) return if ($catt//catt:Tetragraph[catt:TetraToken=$value]) then $value else null"/>
	  	
	  	<sch:let name="tetrasWithReleasableTo" value="distinct-values(for $value in $myTetras return        if($catt//catt:Tetragraph[catt:TetraToken=$value]/@ism:releasableTo)         then $value        else null)"/>
	  	
	  	<sch:let name="moreRestrictiveTetras" value="for $tetra in $tetrasWithReleasableTo return       if (every $value in $releasableToCountries satisfies index-of(distinct-values(util:tokenize(util:getTetragraphReleasability($tetra))),$value)&gt;0)        then null else $tetra"/>
	  	
	  	
		    <sch:assert test="empty($moreRestrictiveTetras)" flag="error" role="error">
		    	[ISM-ID-00376][Error] A portion using tetragraphs may not have a releasableTo 
		    	that is less restrictive than the releasability of any tetragraph or organization tokens used
		    	in the same portion’s releasableTo, displayOnlyto, FGISourceOpen, or FGISourceProtected fields.
		    	The following tetragraphs have a more restrictive releasability than the portion: 
		    	<sch:value-of select="string-join($moreRestrictiveTetras,', ')"/>
		</sch:assert>
	
	  	<sch:assert test="exists($catt//catt:Tetragraphs)" role="">CATT does not exist!</sch:assert>
	  </sch:rule>
</sch:pattern>