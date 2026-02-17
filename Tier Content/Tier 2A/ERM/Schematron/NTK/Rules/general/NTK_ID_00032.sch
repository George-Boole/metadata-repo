<?xml version="1.0" encoding="UTF-8"?>
<?ICEA pattern?>
<!-- Notices - Distribution Notice: 
           This document has been approved for Public Release and is available for use without restriction.
       -->
<sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" xmlns:ism="urn:us:gov:ic:ism" is-a="VocabHasCorrespondingVersion" id="NTK-ID-00032">

   <sch:p ism:classification="U" ism:ownerProducer="USA" class="ruleText">[NTK-ID-00032][Error] An @ntk:sourceVersion must be specified for the built-in
      datasphere:mn:issue vocabulary type.</sch:p>

   <sch:p ism:classification="U" ism:ownerProducer="USA" class="codeDesc">Use the VocabHasCorrespondingVersion abstract pattern to require an ntk:VocabularyType with
      @sourceVersion specified and @name = 'datasphere:mn:issue'.</sch:p>

   <sch:param name="context" value="ntk:AccessProfile[ntk:AccessProfileValue/@ntk:vocabulary='datasphere:mn:issue']"/>
   <sch:param name="vocab" value="'datasphere:mn:issue'"/>
   <sch:param name="errMsg"
      value="'[NTK-ID-00032][Error] An @ntk:sourceVersion must be specified for the built-in datasphere:mn:issue vocabulary type.'"/>

</sch:pattern>
