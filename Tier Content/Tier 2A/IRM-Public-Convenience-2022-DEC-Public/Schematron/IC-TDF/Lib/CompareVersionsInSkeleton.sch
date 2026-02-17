<?xml version="1.0" encoding="utf-8"?>
<!-- 
    This abstract pattern checks all ism:DESVersion attributes found on the TDF skeleton to 
    ensure that all the versions are the same. The TDF Skeleton includes the TDF elements 
    themselves and descendents of tdf:HandlingAssertion or tdf:StatementMetadata elements.
    
     List of params in the form "paramName : example of what to do"
     context   := the nodes that the rule will test.
                  //tdf:*[@ism:DESVersion] | //tdf:HandlingAssertion//*[@ism:DESVersion] 
                  | //tdf:StatementMetdata//*[@ism:DESVersion] 
     namespace := the namespace of the attribute to be tested i.e. urn:us:gov:ic:ism 
     attrName  := the attribute that will be tested  i.e. DESVersion 
     ruleID    := the rule name that invokes the abstrat rule, for use in error message
                  i.e. IC-TDF-ID-00046 
-->
<sch:pattern xmlns:ism="urn:us:gov:ic:ism"
             xmlns:sch="http://purl.oclc.org/dsdl/schematron"
             abstract="true"
             id="CompareVersionsInSkeleton">
    <sch:p class="codeDesc"
           ism:ownerProducer="USA"
           ism:classification="U">For all ism:DESVersion attributes found on the TDF skeleton, ensure all the versions are the same. The TDF Skeleton
           includes the TDF elements themselves and descendents of tdf:HandlingAssertion or tdf:StatementMetadata elements.</sch:p>
    <sch:rule id="CompareVersionsInSkeleton-R1"
              context="$context">
        <sch:assert test="every $ver in (//tdf:*/@*[local-name()=$attrName and namespace-uri()=$namespace] | //tdf:HandlingAssertion//@*[local-name()=$attrName and namespace-uri()=$namespace] | //tdf:StatementMetadata//@*[local-name()=$attrName and namespace-uri()=$namespace]) satisfies (number(if (contains($ver,'-')) then substring-before($ver,'-') else $ver))=(number(if (contains(@*[local-name()=$attrName and namespace-uri()=$namespace],'-')) then substring-before(@*[local-name()=$attrName and namespace-uri()=$namespace],'-') else @*[local-name()=$attrName and namespace-uri()=$namespace]))"
                    flag="error"
                    role="error">[
        <sch:value-of select="$ruleID" />][Error] The {
        <sch:value-of select="$namespace" />}
        <sch:value-of select="$attrName" /> declared must be the same throughout the IC-TDF skeleton including the HandlingAssertions and
        StatementMetadata within assertions. Versions found: 
        <sch:value-of select="string-join(distinct-values(for $ver in (//tdf:*/@*[local-name()=$attrName and namespace-uri()=$namespace] | //tdf:HandlingAssertion//@*[local-name()=$attrName and namespace-uri()=$namespace] | //tdf:StatementMetadata//@*[local-name()=$attrName and namespace-uri()=$namespace]) return $ver), ', ')" /></sch:assert>
    </sch:rule>
</sch:pattern>
