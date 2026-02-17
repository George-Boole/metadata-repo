<?xml version="1.0" encoding="utf-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:ism="urn:us:gov:ic:ism"
             xmlns:sch="http://purl.oclc.org/dsdl/schematron"
             id="IC-EDH-ID-00015">
    <sch:p class="ruleText"
           ism:classification="U"
           ism:ownerProducer="USA">[IC-EDH-ID-00015][Error] There must be one and only one edh:ResponsibleEntity element where role="Custodian" There
           may be zero or one edh:ResponsibleEntity element where role="Originator" Human Readable: There must be only one and only one
           edh:ResponsibleEntity element with the role "Custodian." Additionally, there may be zero or one edh:ResponsibleEntity element with the
           role "Originator."</sch:p>
    <sch:p class="codeDesc"
           ism:classification="U"
           ism:ownerProducer="USA"></sch:p>
    <sch:rule id="IC-EDH-ID-00015-R1"
              context="edh:Edh">
        <sch:assert test="count(./edh:ResponsibleEntity[@edh:role='Custodian']) = 1"
                    flag="error"
                    role="error">[IC-EDH-ID-00015][Error] There must be one and only one edh:ResponsibleEntity element where
                    role="Custodian"</sch:assert>
        <sch:assert test="count(./edh:ResponsibleEntity[@edh:role='Originator']) &lt;= 1"
                    flag="error"
                    role="error">[IC-EDH-ID-00015][Error] There may be zero or one edh:ResponsibleEntity element where role="Originator"</sch:assert>
    </sch:rule>
    <sch:rule id="IC-EDH-ID-00015-R2"
              context="edh:ExternalEdh">
        <sch:assert test="count(./edh:ResponsibleEntity[@edh:role='Custodian']) = 1"
                    flag="error"
                    role="error">[IC-EDH-ID-00015][Error] There must be one and only one edh:ResponsibleEntity element where
                    role="Custodian"</sch:assert>
        <sch:assert test="count(./edh:ResponsibleEntity[@edh:role='Originator']) &lt;= 1"
                    flag="error"
                    role="error">[IC-EDH-ID-00015][Error] There may be zero or one edh:ResponsibleEntity element where role="Originator"</sch:assert>
    </sch:rule>
</sch:pattern>
