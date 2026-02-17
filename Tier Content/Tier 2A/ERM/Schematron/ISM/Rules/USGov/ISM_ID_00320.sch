<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="ISM-ID-00320" is-a="CheckCommonCountries">
   <sch:p class="ruleText"> 
      [ISM-ID-00320][Error] If the ISM_RESOURCE_ELEMENT has the
      ism:displayOnlyTo attribute specified, then the countries specified in the ism:displayOnlyTo
      attribute MUST be the set of the common countries specified across all contributing portions
      UNLESS a compilation reason is specified in which case a subset of the common country set may
      be used.</sch:p>
   <sch:p class="codeDesc">
      Where an element is the resource element and contains the @ism:displayOnlyTo attribute,
      check that the values specified meet the minimum roll-up conditions. Check all contributing
      portions against the banner for the existence of common countries ensuring that the 
      countries in the banner are the intersection of all contributing portions. Any tetragraphs
      whose decomposable flag is true will be decomposed into their representative countries.
      
      Once the minimum possibility of intersecting countries is determined, the rule checks that  
      all portions of the banner are included in the subset.  The rule then checks for the case where 
      there are no common countries to be rolled up to the resource element.  Finally, the rule checks to
      ensure that if the banner countries are a subset of the common countries, that a
      compilationReason is specified.  If a compilationReason is not specified, then the banner
      displayOnlyTo countries must be the set of common countries from all contributing portions.
    </sch:p>
     
   <sch:param name="ruleId" value="'ISM-ID-00320'"/>
   <sch:param name="attrLocalName" value="'displayOnlyTo'"/>
   <sch:param name="actualBannerTokens" value="$displayToActualBannerTokens"/> 
   <sch:param name="calculatedBannerTokens" value="$displayToCalculatedBannerTokens"/>
   
</sch:pattern>