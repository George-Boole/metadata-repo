<?xml version="1.0" encoding="UTF-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="RevRecall-ID-00012">
    <sch:p xmlns:ism="urn:us:gov:ic:ism" ism:classification="U" ism:ownerProducer="USA"
        class="ruleText"> [RevRecall-ID-00012][Error] If @type has the value of
        "FISA_COMPLIANCE_RECALL" then @action MUST be "PURGE", "RETAIN_HIDE", or
        "MANUAL_INSTRUCTION". </sch:p>
    <sch:p xmlns:ism="urn:us:gov:ic:ism" ism:classification="U" ism:ownerProducer="USA"
        class="codeDesc">If @type has the value of
        "FISA_COMPLIANCE_RECALL" then @action MUST be "PURGE", "RETAIN_HIDE", or
        "MANUAL_INSTRUCTION".</sch:p>
    <sch:rule id="RevRecall-ID-00012-R1"
        context="rr:*[@rr:type=('FISA_COMPLIANCE_RECALL')]">
        <sch:assert test="@rr:action=('PURGE', 'RETAIN_HIDE', 'MANUAL_INSTRUCTION')"
            flag="error" role="error"> [RevRecall-ID-00012][Error] If @type has the value of
            "FISA_COMPLIANCE_RECALL" then @action MUST be "PURGE", "RETAIN_HIDE", or
            "MANUAL_INSTRUCTION".
        </sch:assert>
    </sch:rule>
</sch:pattern>
