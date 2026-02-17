<?xml version="1.0" encoding="utf-8"?>
<sch:pattern xmlns:ism="urn:us:gov:ic:ism"
             xmlns:sch="http://purl.oclc.org/dsdl/schematron"
             id="IRM-ID-00100">
    <sch:p class="ruleText"
           ism:classification="U"
           ism:ownerProducer="USA">[IRM-ID-00100][Error] If a irm:ICResourceMetadataPackage element is present in a tdf:StructuredStatement within a tdf:Assertion,
           then the tdf:Assertion must also contain a tdf:StatementMetadata element.</sch:p>
    <sch:p class="codeDesc"
           ism:classification="U"
           ism:ownerProducer="USA">If a irm:ICResourceMetadataPackage element is present in a tdf:StructuredStatement within a tdf:Assertion, then the tdf:Assertion
           must also contain a tdf:StatementMetadata element.</sch:p>
    <sch:rule id="IRM-ID-00100-R1"
      context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage">
        <sch:let name="hasStatementMetadata"
                 value="count(../preceding-sibling::tdf:StatementMetadata) &gt; 0" />
        <sch:assert test="$hasStatementMetadata"
                    flag="error"
                    role="error">[IRM-ID-00100][Error] tdf:Assertion must contain tdf:StatementMetadata when tdf:StructuredStatement contains
              irm:ICResourceMetadataPackage.</sch:assert>
    </sch:rule>
</sch:pattern>
