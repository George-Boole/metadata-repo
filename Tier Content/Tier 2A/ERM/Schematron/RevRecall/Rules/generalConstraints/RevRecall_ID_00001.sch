<?xml version="1.0" encoding="UTF-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="RevRecall-ID-00001">
    <sch:p class="ruleText">[RevRecall-ID-00001][Error] All elements in the RevRecall namespace
        except Link must have content.</sch:p>

    <sch:p class="codeDesc">All elements in the RevRecall namespace except Link
        context="rr:*[not(local-name() = 'Link')]" must have content.</sch:p>

    <sch:rule context="rr:*[not(local-name() = 'Link')]">
        <sch:assert test="normalize-space(.)" flag="error">[RevRecall-ID-00001][Error] All elements
            in the RevRecall namespace except Link must have content.</sch:assert>
    </sch:rule>
</sch:pattern>
