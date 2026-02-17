<?xml version="1.0" encoding="utf-8"?>
<?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:ism="urn:us:gov:ic:ism"
             xmlns:sch="http://purl.oclc.org/dsdl/schematron"
             id="BASE-TDF-ID-00012">
    <sch:p class="ruleText" ism:ownerProducer="USA" ism:classification="U">[BASE-TDF-ID-00012][Error] For all BoundValue or Reference elements within a TrustedDataObject, idRef attribute
           values must reference the id value of a descendant of the same TrustedDataObject that contains the Reference or BoundValue element. Human
           Readable: Assertions and HandlingAssertions within a TrustedDataObject must reference elements local to that TrustedDataObject.</sch:p>
    <sch:p class="codeDesc" ism:ownerProducer="USA" ism:classification="U">For element TrustedDataObject, this rule ensures each attribute @idRef value has matching @id value in the same
           TDO.</sch:p>
    <sch:rule id="BASE-TDF-ID-00012-R1" context="tdf:TrustedDataObject">
        <sch:let name="ids" value=".//@tdf:id"/>
        <sch:let name="externalIdRefs"
               value=" for $idRef in .//@tdf:idRef return if($idRef = $ids) then null else $idRef"/>
        <sch:assert test="count($externalIdRefs) = 0" flag="error" role="error">[BASE-TDF-ID-00012][Error] For all BoundValue or Reference elements within a TrustedDataObject, idRef attribute values
                    must reference the id value of a descendant of the same TrustedDataObject that contains the Reference or BoundValue element.
                    Human Readable: Assertions and HandlingAssertions within a TrustedDataObject must reference elements local to that
                    TrustedDataObject. The following idRefs reference elements outside of this TrustedDataObject: ( 
        <sch:value-of select="for $externalRef in $externalIdRefs return concat(string($externalRef), ', ')"/>).</sch:assert>
    </sch:rule>
</sch:pattern>
