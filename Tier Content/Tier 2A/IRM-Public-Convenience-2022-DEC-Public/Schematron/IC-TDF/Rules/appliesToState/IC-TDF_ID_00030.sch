<?xml version="1.0" encoding="utf-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:ism="urn:us:gov:ic:ism"
             xmlns:sch="http://purl.oclc.org/dsdl/schematron"
             id="IC-TDF-ID-00030">
    <sch:p class="ruleText"
           ism:ownerProducer="USA"
           ism:classification="U">[IC-TDF-ID-00030][Error] If statement attribute @isEncrypted="true", the statement metadata that contains
           @appliesToState="unencrypted" must contain an arh:ExternalSecurity Human Readable: When statement content is encrypted, the handling
           statement describing the content in an unencrypted state is in effect external.</sch:p>
    <sch:p class="codeDesc"
           ism:ownerProducer="USA"
           ism:classification="U">Given a TDO with an encrypted assertion (statement attribute @isEncrypted="true"), the statement metadata that
           contains @appliesToState="unencrypted" must contain an arh:ExternalSecurity.</sch:p>
    <sch:rule id="IC-TDF-ID-00030-R1"
              context="tdf:TrustedDataObject/tdf:Assertion/tdf:*[@tdf:isEncrypted=true()]">
        <sch:assert test="count(parent::node()/tdf:StatementMetadata[@tdf:appliesToState='unencrypted' and descendant-or-self::arh:ExternalSecurity])= 1"
                    flag="error"
                    role="error">[IC-TDF-ID-00030][Error] If statement attribute @isEncrypted="true", the statement metadata that contains
                    @appliesToState="unencrypted" must contain an arh:ExternalSecurity Human Readable: When statement content is encrypted, the
                    handling statement describing the content in an unencrypted state is in effect external.</sch:assert>
    </sch:rule>
</sch:pattern>
