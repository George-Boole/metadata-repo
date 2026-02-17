<?xml version="1.0" encoding="UTF-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="IC-EDH-ID-00015">
    <sch:p class="ruleText">
        [IC-EDH-ID-00015][Error] There must be one and only one edh:ResponsibleEntity element where role="Custodian"
        There may be zero or one edh:ResponsibleEntity element where role="Originator"
        
        Human Readable: There must be only one and only one edh:ResponsibleEntity element with the role "Custodian."
        Additionally, there may be zero or one edh:ResponsibleEntity element with the role "Originator."
    </sch:p>
    <sch:p class="codeDesc">
        
    </sch:p>
    
 
    
    <sch:rule context="edh:Edh">
        
        <sch:assert test="count(./edh:ResponsibleEntity[@edh:role='Custodian']) = 1" flag="error">
            [IC-EDH-ID-00015][Error] There must be one and only one edh:ResponsibleEntity element where role="Custodian"
        </sch:assert>
        
        <sch:assert test="count(./edh:ResponsibleEntity[@edh:role='Originator']) &lt;= 1" flag="error">
            [IC-EDH-ID-00015][Error] There may be zero or one edh:ResponsibleEntity element where role="Originator"
        </sch:assert>
        
    </sch:rule>
    
    <sch:rule context="edh:ExternalEdh">
        
        <sch:assert test="count(./edh:ResponsibleEntity[@edh:role='Custodian']) = 1" flag="error">
            [IC-EDH-ID-00015][Error] There must be one and only one edh:ResponsibleEntity element where role="Custodian"
        </sch:assert>
        
        <sch:assert test="count(./edh:ResponsibleEntity[@edh:role='Originator']) &lt;= 1" flag="error">
            [IC-EDH-ID-00015][Error] There may be zero or one edh:ResponsibleEntity element where role="Originator"
        </sch:assert>
        
    </sch:rule>
</sch:pattern>