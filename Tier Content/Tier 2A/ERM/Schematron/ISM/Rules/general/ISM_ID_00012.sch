<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="ISM-ID-00012">
    <sch:p class="ruleText">
        [ISM-ID-00012][Error] If any of the attributes defined in 
        this DES other than DESVersion, ISMCATCESVersion, unregisteredNoticeType, or pocType 
        are specified for an element, then attributes classification and 
        ownerProducer must be specified for the element.
    </sch:p>
    <sch:p class="codeDesc">
    	For each element which defines an attribute in the ISM namespace other
    	than ism:pocType, ism:DESVersion, ism:ISMCATCESVersion, or ism:unregisteredNoticeType, this rule ensures that attributes ism:classification and ism:ownerProducer are
    	specified.
    </sch:p>
    <sch:rule id="ISM-ID-00012-R1" context="*[@ism:* except (@ism:pocType | @ism:DESVersion | @ism:unregisteredNoticeType | @ism:ISMCATCESVersion)]">
        <sch:assert test="@ism:ownerProducer and @ism:classification" flag="error" role="error">
        	[ISM-ID-00012][Error] If any of the attributes defined in 
        	this DES other than ISMCATCESVersion, DESVersion, unregisteredNoticeType, or pocType 
        	are specified for an element, then attributes classification and 
        	ownerProducer must be specified for the element.
        </sch:assert>
    </sch:rule>
</sch:pattern>