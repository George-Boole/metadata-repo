<?xml version="1.0" encoding="utf-8"?>
<?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:ism="urn:us:gov:ic:ism"
             xmlns:sch="http://purl.oclc.org/dsdl/schematron"
             id="BASE-TDF-ID-00011">
    <sch:p class="ruleText" ism:ownerProducer="USA" ism:classification="U">[BASE-TDF-ID-00011][Error] For element Binding, if element BoundValueList is not specified, then element
           SignatureValue must specify attribute includesStatementMetadata. Human Readable: If BoundValueList is not present, then SignatureValue
           must indicate whether or not to include the StatementMetadata of all Assertions included in the binding.</sch:p>
    <sch:p class="codeDesc" ism:ownerProducer="USA" ism:classification="U">For element Binding that does not have child element BoundValueList, this rule ensures that child element
           SignatureValue specifies attribute includesStatementMetadata.</sch:p>
    <sch:rule id="BASE-TDF-ID-00011-R1"
             context="tdf:Binding[not(tdf:BoundValueList)]">
        <sch:assert test="tdf:SignatureValue/@tdf:includesStatementMetadata"
                  flag="error"
                  role="error">[BASE-TDF-ID-00011][Error] For element Binding, if element BoundValueList is not specified, then element
                    SignatureValue must specify attribute includesStatementMetadata. Human Readable: If BoundValueList is not present, then
                    SignatureValue must indicate whether or not to include the StatementMetadata of all Assertions included in the
                    binding.</sch:assert>
    </sch:rule>
</sch:pattern>
