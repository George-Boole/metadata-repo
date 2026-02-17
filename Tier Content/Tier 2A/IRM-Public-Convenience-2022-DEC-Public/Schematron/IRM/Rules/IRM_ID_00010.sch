<?xml version="1.0" encoding="utf-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:ism="urn:us:gov:ic:ism"
             xmlns:sch="http://purl.oclc.org/dsdl/schematron"
             id="IRM-ID-00010">
    <sch:p class="ruleText"
           ism:classification="U"
           ism:ownerProducer="USA">[IRM-ID-00010][Error] If element irm:language has the attribute @irm:qualifier value of [RFC5646] then the
           language code portion of the @irm:value attribute value must be in CVEnumIRMISO639Digraph.xml or CVEnumIRMISO639-2Trigraph.xml and the
           country code portion, if present, must be in CVEnumIRMCoverageISO3166Digraph.xml. Human Readable: RFC5646 language codes must comply with
           the RFC by using parts from ISO 639 Digraph or ISO 639-2 Trigraph and ISO 3166 Digraph.</sch:p>
    <sch:p class="codeDesc"
           ism:classification="U"
           ism:ownerProducer="USA">Finds irm:language elements and checks its qualifier attribute for a value of [RFC5646]. If this value is found it
           will ensure that the value of the element's irm:value attribute exists in the CVEnumIRMISO639Digraph.xml or CVEnumIRMISO639-2Trigraph.xml
           enumeration files represented by the $iso639DigraphList or $iso639-2TrigraphList variables. Country code portions (denoted by '-'
           separation) must be in the CVEnumIRMCoverageISO3166Digraph.xml enumeration file represented by the $coverageIso3166TrigraphList
           variable.</sch:p>
    <sch:rule id="IRM-ID-00010-R1"
              context="irm:language[@irm:qualifier='RFC5646']">
        <!-- Tokenize the element Language value into a list -->
        <sch:let name="tokens"
                 value="tokenize(@irm:value,'-')" />
        <!-- For convenience and readability, save the primary and secondary subtags 
             as defined in RFC 5646 -->
        <sch:let name="primarySubtag"
                 value="$tokens[1]" />
        <sch:let name="secondarySubtag"
                 value="$tokens[2]" />
        <sch:let name="badPrimaryValues"
                 value=" if($primarySubtag and ( index-of($iso639-2TrigraphList,lower-case($primarySubtag))&gt;0 or index-of($iso639DigraphList,$primarySubtag)&gt;0)) then null else $primarySubtag" />
        <sch:let name="badSecondaryValues"
                 value=" if($secondarySubtag and index-of($coverageIso3166DigraphList,$secondarySubtag)&gt;0) then null else $secondarySubtag" />
        <sch:let name="badValues"
                 value="string-join(($badPrimaryValues, $badSecondaryValues), ' ')" />
        <!-- Check if primary subtag is valid -->
        <sch:let name="primarySubtagValid"
                 value=" $primarySubtag and count($badPrimaryValues) = 0" />
        <!-- Check if secondary subtag is valid -->
        <sch:let name="secondarySubtagValid"
                 value=" if(not($secondarySubtag)) then true() else count($badSecondaryValues) = 0 " />
        <sch:assert test="$primarySubtagValid and $secondarySubtagValid"
                    flag="error"
                    role="error">[IRM-ID-00010][Error] If element irm:language has the attribute @irm:qualifier value of [RFC5646] then the language
                    code portion of the @irm:value attribute value must be in CVEnumIRMISO639Digraph.xml or CVEnumIRMISO639-2Trigraph.xml and the
                    country code portion, if present, must be in CVEnumIRMCoverageISO3166Digraph.xml. Human Readable: RFC5646 language codes must
                    comply with the RFC by using parts from ISO 639 Digraph or ISO 639-2 Trigraph and ISO 3166 Digraph. The following values were
                    found but are not in the CVEs: 
        <sch:value-of select="for $each in tokenize($badValues, ' ') return concat('[',$each,'] ')" /></sch:assert>
    </sch:rule>
</sch:pattern>
