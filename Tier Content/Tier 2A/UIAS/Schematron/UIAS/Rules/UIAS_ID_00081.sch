<?xml version="1.0" encoding="UTF-8"?>
<?ICEA pattern?>
<?schematron-phases phaseids="VALUECHECK"?>
<!-- Original rule id: NTK-ID-00027 -->
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="UIAS-ID-00081" is-a="ValidateEmbeddedValueExistenceinList">
    <sch:p xmlns:ism="urn:us:gov:ic:ism" ism:classification="U" ism:ownerProducer="USA" class="ruleText">
        [UIAS-ID-00081][Error] The SAR tokens in fineAccessControls must start with a substring after SAR- and before : that exists
        in the SAR Source Authorities CVE. Human Readable:  The SAR tokens in fineAccessControls must contain a substring
        between the first and second colons in the pattern SAR:SourceAuthority:SARValue.</sch:p>
    <sch:p xmlns:ism="urn:us:gov:ic:ism" ism:classification="U" ism:ownerProducer="USA" class="codeDesc">
        For any SAR token within fineAccessControls, invoke ValidateEmbeddedValueExistenceinList to check that the token's substring after SAR- and before : 
        exists in the SAR Source Authorities CVE.</sch:p>
    <sch:param name="context" value="saml:Attribute[@Name='fineAccessControls'][contains(./saml:AttributeValue,'SAR-')]"/>
    <sch:param name="searchTermList" value="./saml:AttributeValue"/>
    <sch:param name="substringAfter" value="'SAR-'"/>
    <sch:param name="substringBefore" value="':'"/>
    <sch:param name="prefix" value="'SAR-'"/>
    <sch:param name="list" value="$SARSourceAuthorityList"/>
    <sch:param name="errMsg" value="'[UIAS-ID-00081][Error] The SAR tokens in fineAccessControls must start with a substring after SAR- and before : that exists
        in the SAR Source Authorities CVE. Example from SAR tokens in fineAccessControls is SAR-DOD:TS:DEMOSAP1. The string DOD must be
        found in the SAR Source Authorities CVE. Human Readable:  The SAR tokens in fineAccessControls must contain a substring
        between after the SAR- and before the first : in the pattern SAR-SourceAuthority:Classification:SAPmarking or 
        SAR-SourceAuthority-SARValue; this substring must be found in the SAR Source Authorities CVE. 
        Example SAR-DOD:TS:DEMOSAP1. The string DOD must be found in the SAR Source Authorities CVE. '"/>
</sch:pattern>
