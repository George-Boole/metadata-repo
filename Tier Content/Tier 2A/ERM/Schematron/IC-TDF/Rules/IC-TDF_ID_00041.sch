<?xml version="1.0" encoding="UTF-8"?><?ICEA pattern?><!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       --><sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" id="IC-TDF-ID-00041">
	  <sch:p class="ruleText">
		[IC-TDF-ID-00041][Error] All sequenceNum attributes in an EncryptionInformation Group 
		must be sequential, incrementing by 1, starting with the number 1, and contain no duplicates.
        
       </sch:p>
	
	  <!--This rule triggers on the first EncryptionInformation element for each EncryptionInformation Group 
        that has more than 1 EncryptionInformation element then checks that the sequenceNum attributes
        are numerically sequential by 1 starting from 1. The test uses the mathematical formula
        (1+last*count)/2 = sum(1...count) derived from the formula 
        (first+last)*count/2 = sum(first...last) where first is replaced by 1 and last
        is replaced by count. This works by assuming first=1 then it must
        be true that last=count.-->
	
    <sch:p class="codeDesc">
    	This rule triggers on the first EncryptionInformation element for each EncryptionInformation Group 
    	that has more than 1 EncryptionInformation element then checks that the sequenceNum attributes
    	are numerically sequential by 1 starting from 1. A list, named $nums, is created containing the 
    	value of each sequenceNum attribute within the group. If the total number of items in $nums
    	does not equal the number of distinct values in $nums, then a duplicate exists return
    	false. Otherwise, ensure that each number from 1 to N, where N is the number of items 
    	in $nums, is contained within $nums. If each number is contained, then return true. 
    	Otherwise, false.
    </sch:p>
	  <sch:rule id="IC-TDF-ID-00041-R1" context="tdf:EncryptionInformation[count(following-sibling::tdf:EncryptionInformation)&gt;0][1]">
		    <sch:let name="nums" value="for $encInfo in (., following-sibling::tdf:EncryptionInformation) return number($encInfo/@tdf:sequenceNum)"/>
		    <sch:assert test="(count(distinct-values($nums)) = count($nums)      and (every $index in 1 to count($nums)         satisfies index-of($nums, $index)))" flag="error" role="error">
			[IC-TDF-ID-00041][Error] All sequenceNum attributes in an EncryptionInformation Group 
			must be sequential, incrementing by 1, starting with the number 1, and contain no duplicates.
			</sch:assert>
	  </sch:rule>
</sch:pattern>