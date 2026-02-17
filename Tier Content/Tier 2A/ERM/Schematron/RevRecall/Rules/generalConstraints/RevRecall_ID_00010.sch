<?xml version="1.0" encoding="UTF-8"?>
<?ICEA pattern?> 
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern id="RevRecall-ID-00010" xmlns:sch="http://purl.oclc.org/dsdl/schematron">
    
    <sch:p class="ruleText">
        [RevRecall-ID-00010][Error] Attribute rr:dateTime of type xs:dateTime must have a timezone.
        
        Human Readable: The RevRecall attribute dateTime must have a timezone.
    </sch:p>
    
    <sch:p class="codeDesc">
        The RevRecall attribute rr:dateTime must have a timezone. 
        According to http://www.w3.org/TR/xmlschema-2/#dateTime, datetime is represented by: 
        '-'? yyyy '-' mm '-' dd 'T' hh ':' mm ':' ss ('.' s+)? (zzzzzz)?
        where the timezone zzzzzz is represented by:
        (('+' | '-') hh ':' mm) | 'Z'
        This rule enforces and makes the timezone zzzzzz mandatory.
    </sch:p>
    
    <sch:rule context="rr:RevisionRecall">
        <sch:assert test="matches(@rr:dateTime, '^-?\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(\.\d+)?(((\+|-)\d{2}:\d{2})|Z)$')" flag="error">
            [RevRecall-ID-00010][Error] Attribute rr:dateTime of type xs:dateTime must have a timezone.
            
            Human Readable: The RevRecall attribute dateTime must have a timezone.</sch:assert>
    </sch:rule>
</sch:pattern>
