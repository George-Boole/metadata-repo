<?xml version="1.0" encoding="UTF-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="RevRecall-ID-00003">

    <sch:p xmlns:ism="urn:us:gov:ic:ism" ism:classification="U" ism:ownerProducer="USA" class="ruleText">[RevRecall-ID-00003][Error] All xlink attributes on RevRecall elements
        must have non-whitespace values.</sch:p>

    <sch:p xmlns:ism="urn:us:gov:ic:ism" ism:classification="U" ism:ownerProducer="USA" class="codeDesc">All attributes in the xlink namespace that are on elements in the
        RevRecall namespace must have non-empty, non-whitespace values.</sch:p>

    <sch:p xmlns:ism="urn:us:gov:ic:ism" ism:classification="U" ism:ownerProducer="USA" class="codeNote">[Implementation Warning] The context for this rule is all RevRecall
        elements that have xlink attributes. Using the element context avoids a Saxon warning and
        potential execution issue with using the attribute context directly. That is, using
        rr:*/@xl* as the context theoretically provides the same attribute set, but Saxon throws a
        warning: The child axis starting at an attribute node will never select anything. This
        warning is caused by the generated XSL that is used for Schematron validation. Using the
        attribute context works in Oxygen XML Editor, but may not work using Saxon directly. To
        avoid potential kerfuffle, the element context is used.</sch:p>

    <sch:rule id="RevRecall-ID-00003-R1" context="rr:*[@xl:*]">
        <sch:assert test="every $attr in @xl:* satisfies normalize-space($attr) != ''" flag="error" role="error">[RevRecall-ID-00003][Error] All xlink attributes on elements in the RevRecall namespace
            must have non-empty, non-whitespace values.</sch:assert>
    </sch:rule>
</sch:pattern>