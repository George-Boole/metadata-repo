<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="ISM-ID-00214">

    <sch:p class="ruleText">

        [ISM-ID-00214][Error] If ISM_USGOV_RESOURCE then attribute 

        releasableTo must start with [USA].

    </sch:p>

    <sch:p class="codeDesc">

        If the document is an ISM_USGOV_RESOURCE, for each element which

        specifies attribute releasableTo this rule ensures that attribute

        releasableTo is specified with a value that starts with the token [USA].

    </sch:p>

    <sch:rule id="ISM-ID-00214-R1" context="*[$ISM_USGOV_RESOURCE and @ism:releasableTo]">

        <sch:assert test="index-of(tokenize(normalize-space(string(@ism:releasableTo)),' '),'USA')=1" flag="error" role="error">

            [ISM-ID-00214][Error] If ISM_USGOV_RESOURCE then attribute 

            releasableTo must start with [USA].

        </sch:assert>

    </sch:rule>

</sch:pattern>