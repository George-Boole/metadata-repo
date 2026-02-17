<?xml version="1.0" encoding="utf-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:ism="urn:us:gov:ic:ism"
             xmlns:sch="http://purl.oclc.org/dsdl/schematron"
             id="IRM-ID-00030">
    <sch:p class="ruleText"
           ism:classification="U"
           ism:ownerProducer="USA">[IRM-ID-00030][Error] If attribute @irm:order is specified with integer value N, there must exist other @irm:order
           attributes with values 1 to N-1 with no duplicates. Human Readable: The values of attribute @irm:order must be numbered sequentially with
           no duplicates, beginning at 1.</sch:p>
    <sch:p class="codeDesc"
           ism:classification="U"
           ism:ownerProducer="USA">A list, named $orderList, is created containing the value of each order attribute within the document after
           normalizing to remove extra white-space. If the total number of items in $orderList does not equal the number of distinct values in
           $orderList, then return false because a duplicate exists. Otherwise, ensure that each number from 1 to N, where N is the number of
           items in $orderList, is contained within $orderList. If each number is contained, then return true. Otherwise, false.</sch:p>
    <sch:rule id="IRM-ID-00030-R1"
      context="tdf:*/tdf:Assertion/tdf:StructuredStatement/irm:ICResourceMetadataPackage[//@irm:order]">
        <sch:let name="orderList"
                 value="tokenize(string-join(//@irm:order/normalize-space(), ' '), ' ')" />
        <sch:assert test="(count(distinct-values($orderList)) = count($orderList) and (every $index in 1 to count($orderList) satisfies index-of($orderList, xs:string($index))))"
                    flag="error"
                    role="error">[IRM-ID-00030][Error] If attribute @irm:order is specified with integer value N, there must exist other @irm:order
                    attributes with values 1 to N-1 with no duplicates. Human Readable: The values of attribute @irm:order must be numbered
                    sequentially with no duplicates, beginning at 1.</sch:assert>
    </sch:rule>
</sch:pattern>
