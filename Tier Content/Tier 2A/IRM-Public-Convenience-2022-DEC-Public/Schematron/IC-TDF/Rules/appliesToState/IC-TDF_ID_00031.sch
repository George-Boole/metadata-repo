<?xml version="1.0" encoding="utf-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:ism="urn:us:gov:ic:ism"
             xmlns:sch="http://purl.oclc.org/dsdl/schematron"
             id="IC-TDF-ID-00031">
    <sch:p class="ruleText"
           ism:ownerProducer="USA"
           ism:classification="U">[IC-TDF-ID-00031][Error] If assertion statement attribute @isEncrypted="true", then there needs to be two statement
           metadata elements: one with attribute @appliesToState="encrypted" and the other with attribute appliesToState="unencrypted". Human
           Readable: If an assertion statement is encrypted, it must have statement metadata to describe handling for both its encrypted state, and
           unencrypted state.</sch:p>
    <sch:p class="codeDesc"
           ism:ownerProducer="USA"
           ism:classification="U">If a TDO has an encrypted assertion (@isEncrypted="true"), then there needs to be two statement metadata elements:
           one with attribute @appliesToState="encrypted" and the other with attribute appliesToState="unencrypted".</sch:p>
    <sch:rule id="IC-TDF-ID-00031-R1"
              context="tdf:TrustedDataObject/tdf:Assertion/tdf:*[@tdf:isEncrypted=true()]">
        <sch:assert test="count(parent::node()/tdf:StatementMetadata[@tdf:appliesToState='encrypted'])= 1 and count(parent::node()/tdf:StatementMetadata[@tdf:appliesToState='unencrypted'])= 1"
                    flag="error"
                    role="error">[IC-TDF-ID-00031][Error] If assertion statement attribute @isEncrypted="true", then there needs to be two statement
                    metadata elements: one with attribute @appliesToState="encrypted" and the other with attribute appliesToState="unencrypted".
                    Human Readable: If an assertion statement is encrypted, it must have statement metadata to describe handling for both for its
                    encrypted state, and unencrypted state.</sch:assert>
    </sch:rule>
</sch:pattern>
