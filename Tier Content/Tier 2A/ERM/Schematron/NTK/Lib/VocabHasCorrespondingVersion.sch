<?xml version="1.0" encoding="UTF-8"?>
<sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron" abstract="true" id="VocabHasCorrespondingVersion">

   <sch:p class="codeDesc">Abstract pattern to require an ntk:VocabularyType with @ntk:sourceVersion for a specified
      vocabulary.</sch:p>

   <sch:rule context="$context">

      <sch:assert test="ntk:VocabularyType[@ntk:name=$vocab]/@ntk:sourceVersion" flag="error">
         <sch:value-of select="$errMsg"/>
      </sch:assert>
   </sch:rule>

</sch:pattern>
