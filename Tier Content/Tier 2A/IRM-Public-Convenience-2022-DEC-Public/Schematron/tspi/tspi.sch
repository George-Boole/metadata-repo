<?xml version="1.0" encoding="UTF-8"?>
<!--UNCLASSIFIED-->
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" xml:lang="en">
  
  <!-- == 
    
    2012-03-01: Incomplete & under revision/extension
    
    ==-->
  
  <sch:title>TSPI 2.0.0 Schematron validation</sch:title>
  
  <sch:ns prefix="sch" uri="http://purl.oclc.org/dsdl/schematron"/>
  <sch:ns prefix="gml" uri="http://www.opengis.net/gml/3.2"/>
  <sch:ns prefix="gmlce" uri="http://www.opengis.net/gml/3.2/ce"/>
  <sch:ns prefix="xlink" uri="http://www.w3.org/1999/xlink"/>
  <sch:ns prefix="ism" uri="urn:us:gov:ic:ism"/>
  <sch:ns prefix="tspi" uri="http://metadata.ces.mil/mdr/ns/GSIP/tspi/2.0.0"/>
  <sch:ns prefix="tspi-core"
           uri="http://metadata.ces.mil/mdr/ns/GSIP/tspi/2.0.0/core"/>
  <sch:ns prefix="tspi-ext"
           uri="http://metadata.ces.mil/mdr/ns/GSIP/tspi/2.0.0/ext"/>
  
  <sch:let name="GSIP" value="'http://metadata.ces.mil/mdr/ns/GSIP'"/>
  
  <!-- ************************************************************************* -->
  <!-- ************ Only intended for use with TSPI, Version 2.0.0 ************* -->
  <!-- ************************************************************************* -->
  
  <!-- 
    Restricts content based on constraints that cannot be enforced using XSD.
    Divided into the following groups:
      - Abstract Geometry restrictions
          o Restricts CRS to those defined by specific MDR-based authoritative namespaces
          o ...
      - Coordinate Resolution restrictions
      ...
      - Position Presentation restrictions
      ...
      ...
      - Measure restrictions:
          o Restricts UoMs to those defined by specific MDR-based authoritative namespaces
      - Temporal restrictions
      ...
  -->

  
  <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
  <!-- - - - - - - - - - - - - - Crs Name Restrictions - - - - - - - - - - - - - - - - - - - - -->
  <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
  
  <sch:pattern id="PointSrsName_Valid_in_Resource">
      <sch:rule context="tspi:Point">
         <sch:assert test="starts-with(@srsName, concat($GSIP, '/crs'))">
        The CRS must be from the set registered in the MDR GSIP Governance Namespace.</sch:assert>
         <sch:assert test="document(@srsName)">
        The specified srsName must reference a net-accessible resource in the MDR GSIP Governance Namespace.</sch:assert>
         <!-- Verify that the content of the resource matches the instance document -->
         <sch:assert test="concat(substring-before(@srsName, '/crs'),'/crs') = document(@srsName)//gml:identifier/@codeSpace">
        The body of the srsName must match the codeSpace of the identifier in the resource.</sch:assert>
         <sch:assert test="substring-after(@srsName, 'crs/') = document(@srsName)//gml:identifier">
        The tail of the srsName ('<sch:value-of select="substring-after(@srsName, 'crs/')"/>') must match the value of the identifier in the resource.</sch:assert>
      </sch:rule>
  </sch:pattern>
  
  <sch:pattern id="LineStringSrsName_Valid_in_Resource">
      <sch:rule context="tspi:LineString">
         <sch:assert test="starts-with(@srsName, concat($GSIP, '/crs'))">
        The CRS must be from the set registered in the MDR GSIP Governance Namespace.</sch:assert>
         <sch:assert test="document(@srsName)">
        The specified srsName must reference a net-accessible resource in the MDR GSIP Governance Namespace.</sch:assert>
         <!-- Verify that the content of the resource matches the instance document -->
         <sch:assert test="concat(substring-before(@srsName, '/crs'),'/crs') = document(@srsName)//gml:identifier/@codeSpace">
        The body of the srsName must match the codeSpace of the identifier in the resource.</sch:assert>
         <sch:assert test="substring-after(@srsName, 'crs/') = document(@srsName)//gml:identifier">
        The tail of the srsName ('<sch:value-of select="substring-after(@srsName, 'crs/')"/>') must match the value of the identifier in the resource.</sch:assert>
      </sch:rule>
  </sch:pattern>
  
  <sch:pattern id="CircleSrsName_Valid_in_Resource">
      <sch:rule context="tspi:Circle">
         <sch:assert test="starts-with(@srsName, concat($GSIP, '/crs'))">
        The CRS must be from the set registered in the MDR GSIP Governance Namespace.</sch:assert>
         <sch:assert test="document(@srsName)">
        The specified srsName must reference a net-accessible resource in the MDR GSIP Governance Namespace.</sch:assert>
         <!-- Verify that the content of the resource matches the instance document -->
         <sch:assert test="concat(substring-before(@srsName, '/crs'),'/crs') = document(@srsName)//gml:identifier/@codeSpace">
        The body of the srsName must match the codeSpace of the identifier in the resource.</sch:assert>
         <sch:assert test="substring-after(@srsName, 'crs/') = document(@srsName)//gml:identifier">
        The tail of the srsName ('<sch:value-of select="substring-after(@srsName, 'crs/')"/>') must match the value of the identifier in the resource.</sch:assert>
      </sch:rule>
  </sch:pattern>
  
  <sch:pattern id="EllipseSrsName_Valid_in_Resource">
      <sch:rule context="tspi:Ellipse">
         <sch:assert test="starts-with(@srsName, concat($GSIP, '/crs'))">
        The CRS must be from the set registered in the MDR GSIP Governance Namespace.</sch:assert>
         <sch:assert test="document(@srsName)">
        The specified srsName must reference a net-accessible resource in the MDR GSIP Governance Namespace.</sch:assert>
         <!-- Verify that the content of the resource matches the instance document -->
         <sch:assert test="concat(substring-before(@srsName, '/crs'),'/crs') = document(@srsName)//gml:identifier/@codeSpace">
        The body of the srsName must match the codeSpace of the identifier in the resource.</sch:assert>
         <sch:assert test="substring-after(@srsName, 'crs/') = document(@srsName)//gml:identifier">
        The tail of the srsName ('<sch:value-of select="substring-after(@srsName, 'crs/')"/>') must match the value of the identifier in the resource.</sch:assert>
      </sch:rule>
  </sch:pattern>
  
  <sch:pattern id="PolygonSrsName_Valid_in_Resource">
      <sch:rule context="tspi:Polygon">
         <sch:assert test="starts-with(@srsName, concat($GSIP, '/crs'))">
        The CRS must be from the set registered in the MDR GSIP Governance Namespace.</sch:assert>
         <sch:assert test="document(@srsName)">
        The specified srsName must reference a net-accessible resource in the MDR GSIP Governance Namespace.</sch:assert>
         <!-- Verify that the content of the resource matches the instance document -->
         <sch:assert test="concat(substring-before(@srsName, '/crs'),'/crs') = document(@srsName)//gml:identifier/@codeSpace">
        The body of the srsName must match the codeSpace of the identifier in the resource.</sch:assert>
         <sch:assert test="substring-after(@srsName, 'crs/') = document(@srsName)//gml:identifier">
        The tail of the srsName ('<sch:value-of select="substring-after(@srsName, 'crs/')"/>') must match the value of the identifier in the resource.</sch:assert>
      </sch:rule>
  </sch:pattern>
  
  <sch:pattern id="SimplePolygonSrsName_Valid_in_Resource">
      <sch:rule context="tspi:SimplePolygon">
         <sch:assert test="starts-with(@srsName, concat($GSIP, '/crs'))">
        The CRS must be from the set registered in the MDR GSIP Governance Namespace.</sch:assert>
         <sch:assert test="document(@srsName)">
        The specified srsName must reference a net-accessible resource in the MDR GSIP Governance Namespace.</sch:assert>
         <!-- Verify that the content of the resource matches the instance document -->
         <sch:assert test="concat(substring-before(@srsName, '/crs'),'/crs') = document(@srsName)//gml:identifier/@codeSpace">
        The body of the srsName must match the codeSpace of the identifier in the resource.</sch:assert>
         <sch:assert test="substring-after(@srsName, 'crs/') = document(@srsName)//gml:identifier">
        The tail of the srsName ('<sch:value-of select="substring-after(@srsName, 'crs/')"/>') must match the value of the identifier in the resource.</sch:assert>
      </sch:rule>
  </sch:pattern>
  
  <sch:pattern id="SimpleRectangleSrsName_Valid_in_Resource">
      <sch:rule context="tspi:SimpleRectangle">
         <sch:assert test="starts-with(@srsName, concat($GSIP, '/crs'))">
        The CRS must be from the set registered in the MDR GSIP Governance Namespace.</sch:assert>
         <sch:assert test="document(@srsName)">
        The specified srsName must reference a net-accessible resource in the MDR GSIP Governance Namespace.</sch:assert>
         <!-- Verify that the content of the resource matches the instance document -->
         <sch:assert test="concat(substring-before(@srsName, '/crs'),'/crs') = document(@srsName)//gml:identifier/@codeSpace">
        The body of the srsName must match the codeSpace of the identifier in the resource.</sch:assert>
         <sch:assert test="substring-after(@srsName, 'crs/') = document(@srsName)//gml:identifier">
        The tail of the srsName ('<sch:value-of select="substring-after(@srsName, 'crs/')"/>') must match the value of the identifier in the resource.</sch:assert>
      </sch:rule>
  </sch:pattern>
  
  <sch:pattern id="EnvelopeSrsName_Valid_in_Resource">
      <sch:rule context="tspi:Envelope">
         <sch:assert test="starts-with(@srsName, concat($GSIP, '/crs'))">
        The CRS must be from the set registered in the MDR GSIP Governance Namespace.</sch:assert>
         <sch:assert test="document(@srsName)">
        The specified srsName must reference a net-accessible resource in the MDR GSIP Governance Namespace.</sch:assert>
         <!-- Verify that the content of the resource matches the instance document -->
         <sch:assert test="concat(substring-before(@srsName, '/crs'),'/crs') = document(@srsName)//gml:identifier/@codeSpace">
        The body of the srsName must match the codeSpace of the identifier in the resource.</sch:assert>
         <sch:assert test="substring-after(@srsName, 'crs/') = document(@srsName)//gml:identifier">
        The tail of the srsName ('<sch:value-of select="substring-after(@srsName, 'crs/')"/>') must match the value of the identifier in the resource.</sch:assert>
      </sch:rule>
  </sch:pattern>
  
  <sch:pattern id="CircularSurfaceSrsName_Valid_in_Resource">
      <sch:rule context="tspi:CircularSurface">
         <sch:assert test="starts-with(@srsName, concat($GSIP, '/crs'))">
        The CRS must be from the set registered in the MDR GSIP Governance Namespace.</sch:assert>
         <sch:assert test="document(@srsName)">
        The specified srsName must reference a net-accessible resource in the MDR GSIP Governance Namespace.</sch:assert>
         <!-- Verify that the content of the resource matches the instance document -->
         <sch:assert test="concat(substring-before(@srsName, '/crs'),'/crs') = document(@srsName)//gml:identifier/@codeSpace">
        The body of the srsName must match the codeSpace of the identifier in the resource.</sch:assert>
         <sch:assert test="substring-after(@srsName, 'crs/') = document(@srsName)//gml:identifier">
        The tail of the srsName ('<sch:value-of select="substring-after(@srsName, 'crs/')"/>') must match the value of the identifier in the resource.</sch:assert>
      </sch:rule>
  </sch:pattern>
  
  <sch:pattern id="EllipticalSurfaceSrsName_Valid_in_Resource">
      <sch:rule context="tspi:EllipticalSurface">
         <sch:assert test="starts-with(@srsName, concat($GSIP, '/crs'))">
        The CRS must be from the set registered in the MDR GSIP Governance Namespace.</sch:assert>
         <sch:assert test="document(@srsName)">
        The specified srsName must reference a net-accessible resource in the MDR GSIP Governance Namespace.</sch:assert>
         <!-- Verify that the content of the resource matches the instance document -->
         <sch:assert test="concat(substring-before(@srsName, '/crs'),'/crs') = document(@srsName)//gml:identifier/@codeSpace">
        The body of the srsName must match the codeSpace of the identifier in the resource.</sch:assert>
         <sch:assert test="substring-after(@srsName, 'crs/') = document(@srsName)//gml:identifier">
        The tail of the srsName ('<sch:value-of select="substring-after(@srsName, 'crs/')"/>') must match the value of the identifier in the resource.</sch:assert>
      </sch:rule>
  </sch:pattern>
  
  <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
  <!-- - - - - - - - - - - - - - Resolution Restrictions - - - - - - - - - - - - - - - - - - - -->
  <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
  
  <sch:pattern id="PointHorizResolutionFlexibleEnum">
      <sch:rule context="tspi-core:horizResolutionCategory">
         <sch:assert test="(.!='')">Either the code list and value must be specified or the horizontal resolution category itself must be specified, but not both.</sch:assert> 
         <!-- triggers if value missing -->
      </sch:rule>
  </sch:pattern>
  
  <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
  <!-- - - - - - - - - - - - - - Presentation Restrictions - - - - - - - - - - - - - - - - - - -->
  <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
  
  <sch:pattern id="QuadrangleLocationSubZoneIntegrity">
      <sch:rule context="tspi-core:quadrangleLocation">
         <sch:assert test="not (tspi-core:subZoneFraction) or (tspi-core:subZoneMinute)">If there is a Quadrangle Presentation with a minutes-faction subzone component then it must also have a minutes-based subzone component.</sch:assert>
      </sch:rule>
  </sch:pattern>
  
  <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
  <!-- - - - - - - - - - - - - - Measure Restrictions  - - - - - - - - - - - - - - - - - - - - -->
  <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

  <sch:pattern id="Acceleration_AllowableUOM">
      <sch:rule context="tspi:acceleration">
         <sch:assert test="starts-with(@uom, concat($GSIP, '/uom/acceleration'))">
        The UOM must be from the set for the physical quantity 'acceleration' that is that is registered in the MDR GSIP Governance Namespace.</sch:assert>
         <sch:assert test="document(@uom)">
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</sch:assert>
         <!-- Verify that the content of the resource matches the instance document -->
         <sch:assert test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
        The body of the uom must match the codeSpace of the identifier in the resource.</sch:assert>
         <sch:assert test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
        The tail of the uom ('<sch:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>') must match the value of the identifier in the resource.</sch:assert>
      </sch:rule>
  </sch:pattern>

  <sch:pattern id="AmountOfSubstance_AllowableUOM">
      <sch:rule context="tspi:amountOfSubstance">
         <sch:assert test="starts-with(@uom, concat($GSIP, '/uom/amountOfSubstance'))">
        The UOM must be from the set for the physical quantity 'amount of substance' that is that is registered in the MDR GSIP Governance Namespace.</sch:assert>
         <sch:assert test="document(@uom)">
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</sch:assert>
         <!-- Verify that the content of the resource matches the instance document -->
         <sch:assert test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
        The body of the uom must match the codeSpace of the identifier in the resource.</sch:assert>
         <sch:assert test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
        The tail of the uom ('<sch:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>') must match the value of the identifier in the resource.</sch:assert>
      </sch:rule>
  </sch:pattern>

  <sch:pattern id="Area_AllowableUOM">
      <sch:rule context="tspi:area">
         <sch:assert test="starts-with(@uom, concat($GSIP, '/uom/area'))">
        The UOM must be from the set for the physical quantity 'area' that is that is registered in the MDR GSIP Governance Namespace.</sch:assert>
         <sch:assert test="document(@uom)">
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</sch:assert>
         <!-- Verify that the content of the resource matches the instance document -->
         <sch:assert test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
        The body of the uom must match the codeSpace of the identifier in the resource.</sch:assert>
         <sch:assert test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
        The tail of the uom ('<sch:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>') must match the value of the identifier in the resource.</sch:assert>
      </sch:rule>
  </sch:pattern>

  <sch:pattern id="Capacitance_AllowableUOM">
      <sch:rule context="tspi:capacitance">
         <sch:assert test="starts-with(@uom, concat($GSIP, '/uom/capacitance'))">
        The UOM must be from the set for the physical quantity 'capacitance' that is that is registered in the MDR GSIP Governance Namespace.</sch:assert>
         <sch:assert test="document(@uom)">
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</sch:assert>
         <!-- Verify that the content of the resource matches the instance document -->
         <sch:assert test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
        The body of the uom must match the codeSpace of the identifier in the resource.</sch:assert>
         <sch:assert test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
        The tail of the uom ('<sch:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>') must match the value of the identifier in the resource.</sch:assert>
      </sch:rule>
  </sch:pattern>

  <sch:pattern id="ElectricCharge_AllowableUOM">
      <sch:rule context="tspi:electricCharge">
         <sch:assert test="starts-with(@uom, concat($GSIP, '/uom/electricCharge'))">
        The UOM must be from the set for the physical quantity 'electric charge' that is that is registered in the MDR GSIP Governance Namespace.</sch:assert>
         <sch:assert test="document(@uom)">
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</sch:assert>
         <!-- Verify that the content of the resource matches the instance document -->
         <sch:assert test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
        The body of the uom must match the codeSpace of the identifier in the resource.</sch:assert>
         <sch:assert test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
        The tail of the uom ('<sch:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>') must match the value of the identifier in the resource.</sch:assert>
      </sch:rule>
  </sch:pattern>

  <sch:pattern id="ElectricConductance_AllowableUOM">
      <sch:rule context="tspi:electricConductance">
         <sch:assert test="starts-with(@uom, concat($GSIP, '/uom/electricConductance'))">
        The UOM must be from the set for the physical quantity 'electric conductance' that is that is registered in the MDR GSIP Governance Namespace.</sch:assert>
         <sch:assert test="document(@uom)">
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</sch:assert>
         <!-- Verify that the content of the resource matches the instance document -->
         <sch:assert test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
        The body of the uom must match the codeSpace of the identifier in the resource.</sch:assert>
         <sch:assert test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
        The tail of the uom ('<sch:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>') must match the value of the identifier in the resource.</sch:assert>
      </sch:rule>
  </sch:pattern>

  <sch:pattern id="ElectricCurrent_AllowableUOM">
      <sch:rule context="tspi:electricCurrent">
         <sch:assert test="starts-with(@uom, concat($GSIP, '/uom/electricCurrent'))">
        The UOM must be from the set for the physical quantity 'electric current' that is that is registered in the MDR GSIP Governance Namespace.</sch:assert>
         <sch:assert test="document(@uom)">
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</sch:assert>
         <!-- Verify that the content of the resource matches the instance document -->
         <sch:assert test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
        The body of the uom must match the codeSpace of the identifier in the resource.</sch:assert>
         <sch:assert test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
        The tail of the uom ('<sch:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>') must match the value of the identifier in the resource.</sch:assert>
      </sch:rule>
  </sch:pattern>

  <sch:pattern id="ElectricResistance_AllowableUOM">
      <sch:rule context="tspi:electricResistance">
         <sch:assert test="starts-with(@uom, concat($GSIP, '/uom/electricResistance'))">
        The UOM must be from the set for the physical quantity 'electric resistance' that is that is registered in the MDR GSIP Governance Namespace.</sch:assert>
         <sch:assert test="document(@uom)">
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</sch:assert>
         <!-- Verify that the content of the resource matches the instance document -->
         <sch:assert test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
        The body of the uom must match the codeSpace of the identifier in the resource.</sch:assert>
         <sch:assert test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
        The tail of the uom ('<sch:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>') must match the value of the identifier in the resource.</sch:assert>
      </sch:rule>
  </sch:pattern>

  <sch:pattern id="ElectromotiveForce_AllowableUOM">
      <sch:rule context="tspi:electromotiveForce">
         <sch:assert test="starts-with(@uom, concat($GSIP, '/uom/electromotiveForce'))">
        The UOM must be from the set for the physical quantity 'electromotive force' that is that is registered in the MDR GSIP Governance Namespace.</sch:assert>
         <sch:assert test="document(@uom)">
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</sch:assert>
         <!-- Verify that the content of the resource matches the instance document -->
         <sch:assert test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
        The body of the uom must match the codeSpace of the identifier in the resource.</sch:assert>
         <sch:assert test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
        The tail of the uom ('<sch:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>') must match the value of the identifier in the resource.</sch:assert>
      </sch:rule>
  </sch:pattern>

  <sch:pattern id="Energy_AllowableUOM">
      <sch:rule context="tspi:energy">
         <sch:assert test="starts-with(@uom, concat($GSIP, '/uom/energy'))">
        The UOM must be from the set for the physical quantity 'energy' that is that is registered in the MDR GSIP Governance Namespace.</sch:assert>
         <sch:assert test="document(@uom)">
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</sch:assert>
         <!-- Verify that the content of the resource matches the instance document -->
         <sch:assert test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
        The body of the uom must match the codeSpace of the identifier in the resource.</sch:assert>
         <sch:assert test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
        The tail of the uom ('<sch:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>') must match the value of the identifier in the resource.</sch:assert>
      </sch:rule>
  </sch:pattern>

  <sch:pattern id="Force_AllowableUOM">
      <sch:rule context="tspi:force">
         <sch:assert test="starts-with(@uom, concat($GSIP, '/uom/force'))">
        The UOM must be from the set for the physical quantity 'force' that is that is registered in the MDR GSIP Governance Namespace.</sch:assert>
         <sch:assert test="document(@uom)">
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</sch:assert>
         <!-- Verify that the content of the resource matches the instance document -->
         <sch:assert test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
        The body of the uom must match the codeSpace of the identifier in the resource.</sch:assert>
         <sch:assert test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
        The tail of the uom ('<sch:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>') must match the value of the identifier in the resource.</sch:assert>
      </sch:rule>
  </sch:pattern>

  <sch:pattern id="Frequency_AllowableUOM">
      <sch:rule context="tspi:frequency">
         <sch:assert test="starts-with(@uom, concat($GSIP, '/uom/frequency'))">
        The UOM must be from the set for the physical quantity 'frequency' that is that is registered in the MDR GSIP Governance Namespace.</sch:assert>
         <sch:assert test="document(@uom)">
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</sch:assert>
         <!-- Verify that the content of the resource matches the instance document -->
         <sch:assert test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
        The body of the uom must match the codeSpace of the identifier in the resource.</sch:assert>
         <sch:assert test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
        The tail of the uom ('<sch:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>') must match the value of the identifier in the resource.</sch:assert>
      </sch:rule>
  </sch:pattern>

  <sch:pattern id="GeopotentialEnergyLength_AllowableUOM">
      <sch:rule context="tspi:geopotentialEnergyLength">
         <sch:assert test="starts-with(@uom, concat($GSIP, '/uom/geopotentialEnergyLength'))">
        The UOM must be from the set for the physical quantity 'geopotential energy length' that is that is registered in the MDR GSIP Governance Namespace.</sch:assert>
         <sch:assert test="document(@uom)">
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</sch:assert>
         <!-- Verify that the content of the resource matches the instance document -->
         <sch:assert test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
        The body of the uom must match the codeSpace of the identifier in the resource.</sch:assert>
         <sch:assert test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
        The tail of the uom ('<sch:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>') must match the value of the identifier in the resource.</sch:assert>
      </sch:rule>
  </sch:pattern>

  <sch:pattern id="Illuminance_AllowableUOM">
      <sch:rule context="tspi:illuminance">
         <sch:assert test="starts-with(@uom, concat($GSIP, '/uom/illuminance'))">
        The UOM must be from the set for the physical quantity 'illuminance' that is that is registered in the MDR GSIP Governance Namespace.</sch:assert>
         <sch:assert test="document(@uom)">
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</sch:assert>
         <!-- Verify that the content of the resource matches the instance document -->
         <sch:assert test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
        The body of the uom must match the codeSpace of the identifier in the resource.</sch:assert>
         <sch:assert test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
        The tail of the uom ('<sch:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>') must match the value of the identifier in the resource.</sch:assert>
      </sch:rule>
  </sch:pattern>

  <sch:pattern id="Inductance_AllowableUOM">
      <sch:rule context="tspi:inductance">
         <sch:assert test="starts-with(@uom, concat($GSIP, '/uom/inductance'))">
        The UOM must be from the set for the physical quantity 'inductance' that is that is registered in the MDR GSIP Governance Namespace.</sch:assert>
         <sch:assert test="document(@uom)">
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</sch:assert>
         <!-- Verify that the content of the resource matches the instance document -->
         <sch:assert test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
        The body of the uom must match the codeSpace of the identifier in the resource.</sch:assert>
         <sch:assert test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
        The tail of the uom ('<sch:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>') must match the value of the identifier in the resource.</sch:assert>
      </sch:rule>
  </sch:pattern>

  <sch:pattern id="Irradiance_AllowableUOM">
      <sch:rule context="tspi:irradiance">
         <sch:assert test="starts-with(@uom, concat($GSIP, '/uom/irradiance'))">
        The UOM must be from the set for the physical quantity 'irradiance' that is that is registered in the MDR GSIP Governance Namespace.</sch:assert>
         <sch:assert test="document(@uom)">
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</sch:assert>
         <!-- Verify that the content of the resource matches the instance document -->
         <sch:assert test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
        The body of the uom must match the codeSpace of the identifier in the resource.</sch:assert>
         <sch:assert test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
        The tail of the uom ('<sch:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>') must match the value of the identifier in the resource.</sch:assert>
      </sch:rule>
  </sch:pattern>

  <sch:pattern id="Length_AllowableUOM">
      <sch:rule context="tspi:length">
         <sch:assert test="starts-with(@uom, concat($GSIP, '/uom/length'))">
        The UOM must be from the set for the physical quantity 'length' that is that is registered in the MDR GSIP Governance Namespace.</sch:assert>
         <sch:assert test="document(@uom)">
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</sch:assert>
         <!-- Verify that the content of the resource matches the instance document -->
         <sch:assert test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
        The body of the uom must match the codeSpace of the identifier in the resource.</sch:assert>
         <sch:assert test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
        The tail of the uom ('<sch:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>') must match the value of the identifier in the resource.</sch:assert>
      </sch:rule>
  </sch:pattern>

  <sch:pattern id="LinearDensity_AllowableUOM">
      <sch:rule context="tspi:linearDensity">
         <sch:assert test="starts-with(@uom, concat($GSIP, '/uom/linearDensity'))">
        The UOM must be from the set for the physical quantity 'linear density' that is that is registered in the MDR GSIP Governance Namespace.</sch:assert>
         <sch:assert test="document(@uom)">
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</sch:assert>
         <!-- Verify that the content of the resource matches the instance document -->
         <sch:assert test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
        The body of the uom must match the codeSpace of the identifier in the resource.</sch:assert>
         <sch:assert test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
        The tail of the uom ('<sch:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>') must match the value of the identifier in the resource.</sch:assert>
      </sch:rule>
  </sch:pattern>

  <sch:pattern id="LinearEnergyTransfer_AllowableUOM">
      <sch:rule context="tspi:linearEnergyTransfer">
         <sch:assert test="starts-with(@uom, concat($GSIP, '/uom/linearEnergyTransfer'))">
        The UOM must be from the set for the physical quantity 'linear energy transfer' that is that is registered in the MDR GSIP Governance Namespace.</sch:assert>
         <sch:assert test="document(@uom)">
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</sch:assert>
         <!-- Verify that the content of the resource matches the instance document -->
         <sch:assert test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
        The body of the uom must match the codeSpace of the identifier in the resource.</sch:assert>
         <sch:assert test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
        The tail of the uom ('<sch:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>') must match the value of the identifier in the resource.</sch:assert>
      </sch:rule>
  </sch:pattern>

  <sch:pattern id="LuminousFlux_AllowableUOM">
      <sch:rule context="tspi:luminousFlux">
         <sch:assert test="starts-with(@uom, concat($GSIP, '/uom/luminousFlux'))">
        The UOM must be from the set for the physical quantity 'luminous flux' that is that is registered in the MDR GSIP Governance Namespace.</sch:assert>
         <sch:assert test="document(@uom)">
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</sch:assert>
         <!-- Verify that the content of the resource matches the instance document -->
         <sch:assert test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
        The body of the uom must match the codeSpace of the identifier in the resource.</sch:assert>
         <sch:assert test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
        The tail of the uom ('<sch:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>') must match the value of the identifier in the resource.</sch:assert>
      </sch:rule>
  </sch:pattern>

  <sch:pattern id="LuminousIntensity_AllowableUOM">
      <sch:rule context="tspi:luminousIntensity">
         <sch:assert test="starts-with(@uom, concat($GSIP, '/uom/luminousIntensity'))">
        The UOM must be from the set for the physical quantity 'luminous intensity' that is that is registered in the MDR GSIP Governance Namespace.</sch:assert>
         <sch:assert test="document(@uom)">
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</sch:assert>
         <!-- Verify that the content of the resource matches the instance document -->
         <sch:assert test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
        The body of the uom must match the codeSpace of the identifier in the resource.</sch:assert>
         <sch:assert test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
        The tail of the uom ('<sch:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>') must match the value of the identifier in the resource.</sch:assert>
      </sch:rule>
  </sch:pattern>

  <sch:pattern id="MagneticFlux_AllowableUOM">
      <sch:rule context="tspi:magneticFlux">
         <sch:assert test="starts-with(@uom, concat($GSIP, '/uom/magneticFlux'))">
        The UOM must be from the set for the physical quantity 'magnetic flux' that is that is registered in the MDR GSIP Governance Namespace.</sch:assert>
         <sch:assert test="document(@uom)">
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</sch:assert>
         <!-- Verify that the content of the resource matches the instance document -->
         <sch:assert test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
        The body of the uom must match the codeSpace of the identifier in the resource.</sch:assert>
         <sch:assert test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
        The tail of the uom ('<sch:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>') must match the value of the identifier in the resource.</sch:assert>
      </sch:rule>
  </sch:pattern>

  <sch:pattern id="MagneticFluxDensity_AllowableUOM">
      <sch:rule context="tspi:magneticFluxDensity">
         <sch:assert test="starts-with(@uom, concat($GSIP, '/uom/magneticFluxDensity'))">
        The UOM must be from the set for the physical quantity 'magnetic flux density' that is that is registered in the MDR GSIP Governance Namespace.</sch:assert>
         <sch:assert test="document(@uom)">
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</sch:assert>
         <!-- Verify that the content of the resource matches the instance document -->
         <sch:assert test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
        The body of the uom must match the codeSpace of the identifier in the resource.</sch:assert>
         <sch:assert test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
        The tail of the uom ('<sch:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>') must match the value of the identifier in the resource.</sch:assert>
      </sch:rule>
  </sch:pattern>

  <sch:pattern id="MagneticFluxDensityGradient_AllowableUOM">
      <sch:rule context="tspi:magneticFluxDensityGradient">
         <sch:assert test="starts-with(@uom, concat($GSIP, '/uom/magneticFluxDensityGradient'))">
        The UOM must be from the set for the physical quantity 'magnetic flux density gradient' that is that is registered in the MDR GSIP Governance Namespace.</sch:assert>
         <sch:assert test="document(@uom)">
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</sch:assert>
         <!-- Verify that the content of the resource matches the instance document -->
         <sch:assert test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
        The body of the uom must match the codeSpace of the identifier in the resource.</sch:assert>
         <sch:assert test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
        The tail of the uom ('<sch:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>') must match the value of the identifier in the resource.</sch:assert>
      </sch:rule>
  </sch:pattern>

  <sch:pattern id="Mass_AllowableUOM">
      <sch:rule context="tspi:mass">
         <sch:assert test="starts-with(@uom, concat($GSIP, '/uom/mass'))">
        The UOM must be from the set for the physical quantity 'mass' that is that is registered in the MDR GSIP Governance Namespace.</sch:assert>
         <sch:assert test="document(@uom)">
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</sch:assert>
         <!-- Verify that the content of the resource matches the instance document -->
         <sch:assert test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
        The body of the uom must match the codeSpace of the identifier in the resource.</sch:assert>
         <sch:assert test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
        The tail of the uom ('<sch:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>') must match the value of the identifier in the resource.</sch:assert>
      </sch:rule>
  </sch:pattern>

  <sch:pattern id="MassDensity_AllowableUOM">
      <sch:rule context="tspi:massDensity">
         <sch:assert test="starts-with(@uom, concat($GSIP, '/uom/massDensity'))">
        The UOM must be from the set for the physical quantity 'mass density' that is that is registered in the MDR GSIP Governance Namespace.</sch:assert>
         <sch:assert test="document(@uom)">
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</sch:assert>
         <!-- Verify that the content of the resource matches the instance document -->
         <sch:assert test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
        The body of the uom must match the codeSpace of the identifier in the resource.</sch:assert>
         <sch:assert test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
        The tail of the uom ('<sch:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>') must match the value of the identifier in the resource.</sch:assert>
      </sch:rule>
  </sch:pattern>

  <sch:pattern id="MassFraction_AllowableUOM">
      <sch:rule context="tspi:massFraction">
         <sch:assert test="starts-with(@uom, concat($GSIP, '/uom/massFraction'))">
        The UOM must be from the set for the physical quantity 'mass fraction' that is that is registered in the MDR GSIP Governance Namespace.</sch:assert>
         <sch:assert test="document(@uom)">
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</sch:assert>
         <!-- Verify that the content of the resource matches the instance document -->
         <sch:assert test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
        The body of the uom must match the codeSpace of the identifier in the resource.</sch:assert>
         <sch:assert test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
        The tail of the uom ('<sch:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>') must match the value of the identifier in the resource.</sch:assert>
      </sch:rule>
  </sch:pattern>

  <sch:pattern id="MassRate_AllowableUOM">
      <sch:rule context="tspi:massRate">
         <sch:assert test="starts-with(@uom, concat($GSIP, '/uom/massRate'))">
        The UOM must be from the set for the physical quantity 'mass rate' that is that is registered in the MDR GSIP Governance Namespace.</sch:assert>
         <sch:assert test="document(@uom)">
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</sch:assert>
         <!-- Verify that the content of the resource matches the instance document -->
         <sch:assert test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
        The body of the uom must match the codeSpace of the identifier in the resource.</sch:assert>
         <sch:assert test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
        The tail of the uom ('<sch:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>') must match the value of the identifier in the resource.</sch:assert>
      </sch:rule>
  </sch:pattern>

  <sch:pattern id="NoncomparableUnit_AllowableUOM">
      <sch:rule context="tspi:noncomparableUnit">
         <sch:assert test="starts-with(@uom, concat($GSIP, '/uom/noncomparable'))">
        The UOM must be from the set for the physical quantity 'noncomparable' that is of physical quantities.</sch:assert>
         <sch:assert test="document(@uom)">
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</sch:assert>
         <!-- Verify that the content of the resource matches the instance document -->
         <sch:assert test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
        The body of the uom must match the codeSpace of the identifier in the resource.</sch:assert>
         <sch:assert test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
        The tail of the uom ('<sch:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>') must match the value of the identifier in the resource.</sch:assert>
      </sch:rule>
  </sch:pattern>

  <sch:pattern id="PlaneAngle_AllowableUOM">
      <sch:rule context="tspi:planeAngle">
         <sch:assert test="starts-with(@uom, concat($GSIP, '/uom/planeAngle'))">
        The UOM must be from the set for the physical quantity 'plane angle' that is that is registered in the MDR GSIP Governance Namespace.</sch:assert>
         <sch:assert test="document(@uom)">
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</sch:assert>
         <!-- Verify that the content of the resource matches the instance document -->
         <sch:assert test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
        The body of the uom must match the codeSpace of the identifier in the resource.</sch:assert>
         <sch:assert test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
        The tail of the uom ('<sch:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>') must match the value of the identifier in the resource.</sch:assert>
      </sch:rule>
  </sch:pattern>

  <sch:pattern id="Power_AllowableUOM">
      <sch:rule context="tspi:power">
         <sch:assert test="starts-with(@uom, concat($GSIP, '/uom/power'))">
        The UOM must be from the set for the physical quantity 'power' that is that is registered in the MDR GSIP Governance Namespace.</sch:assert>
         <sch:assert test="document(@uom)">
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</sch:assert>
         <!-- Verify that the content of the resource matches the instance document -->
         <sch:assert test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
        The body of the uom must match the codeSpace of the identifier in the resource.</sch:assert>
         <sch:assert test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
        The tail of the uom ('<sch:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>') must match the value of the identifier in the resource.</sch:assert>
      </sch:rule>
  </sch:pattern>

  <sch:pattern id="PowerLevelDifference_AllowableUOM">
      <sch:rule context="tspi:powerLevelDifference">
         <sch:assert test="starts-with(@uom, concat($GSIP, '/uom/powerLevelDifference'))">
        The UOM must be from the set for the physical quantity 'power level difference' that is that is registered in the MDR GSIP Governance Namespace.</sch:assert>
         <sch:assert test="document(@uom)">
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</sch:assert>
         <!-- Verify that the content of the resource matches the instance document -->
         <sch:assert test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
        The body of the uom must match the codeSpace of the identifier in the resource.</sch:assert>
         <sch:assert test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
        The tail of the uom ('<sch:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>') must match the value of the identifier in the resource.</sch:assert>
      </sch:rule>
  </sch:pattern>

  <sch:pattern id="PowerLevelDiffLenGradient_AllowableUOM">
      <sch:rule context="tspi:powerLevelDiffLenGradient">
         <sch:assert test="starts-with(@uom, concat($GSIP, '/uom/powerLevelDiffLenGradient'))">
        The UOM must be from the set for the physical quantity 'power level difference length' that is that is registered in the MDR GSIP Governance Namespace.</sch:assert>
         <sch:assert test="document(@uom)">
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</sch:assert>
         <!-- Verify that the content of the resource matches the instance document -->
         <sch:assert test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
        The body of the uom must match the codeSpace of the identifier in the resource.</sch:assert>
         <sch:assert test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
        The tail of the uom ('<sch:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>') must match the value of the identifier in the resource.</sch:assert>
      </sch:rule>
  </sch:pattern>

  <sch:pattern id="Pressure_AllowableUOM">
      <sch:rule context="tspi:pressure">
         <sch:assert test="starts-with(@uom, concat($GSIP, '/uom/pressure'))">
        The UOM must be from the set for the physical quantity 'pressure' that is that is registered in the MDR GSIP Governance Namespace.</sch:assert>
         <sch:assert test="document(@uom)">
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</sch:assert>
         <!-- Verify that the content of the resource matches the instance document -->
         <sch:assert test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
        The body of the uom must match the codeSpace of the identifier in the resource.</sch:assert>
         <sch:assert test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
        The tail of the uom ('<sch:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>') must match the value of the identifier in the resource.</sch:assert>
      </sch:rule>
  </sch:pattern>

  <sch:pattern id="PureNumber_AllowableUOM">
      <sch:rule context="tspi:pureNumber">
         <sch:assert test="starts-with(@uom, concat($GSIP, '/uom/pureNumber'))">
        The UOM must be from the set for the physical quantity 'pure number' that is that is registered in the MDR GSIP Governance Namespace.</sch:assert>
         <sch:assert test="document(@uom)">
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</sch:assert>
         <!-- Verify that the content of the resource matches the instance document -->
         <sch:assert test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
        The body of the uom must match the codeSpace of the identifier in the resource.</sch:assert>
         <sch:assert test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
        The tail of the uom ('<sch:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>') must match the value of the identifier in the resource.</sch:assert>
      </sch:rule>
  </sch:pattern>

  <sch:pattern id="RadiationAbsorbedDose_AllowableUOM">
      <sch:rule context="tspi:radiationAbsorbedDose">
         <sch:assert test="starts-with(@uom, concat($GSIP, '/uom/radiationAbsorbedDose'))">
        The UOM must be from the set for the physical quantity 'radiation absorbed dose' that is that is registered in the MDR GSIP Governance Namespace.</sch:assert>
         <sch:assert test="document(@uom)">
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</sch:assert>
         <!-- Verify that the content of the resource matches the instance document -->
         <sch:assert test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
        The body of the uom must match the codeSpace of the identifier in the resource.</sch:assert>
         <sch:assert test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
        The tail of the uom ('<sch:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>') must match the value of the identifier in the resource.</sch:assert>
      </sch:rule>
  </sch:pattern>

  <sch:pattern id="RadiationDoseEquivalent_AllowableUOM">
      <sch:rule context="tspi:radiationDoseEquivalent">
         <sch:assert test="starts-with(@uom, concat($GSIP, '/uom/radiationDoseEquivalent'))">
        The UOM must be from the set for the physical quantity 'radiation dose equivalent' that is that is registered in the MDR GSIP Governance Namespace.</sch:assert>
         <sch:assert test="document(@uom)">
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</sch:assert>
         <!-- Verify that the content of the resource matches the instance document -->
         <sch:assert test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
        The body of the uom must match the codeSpace of the identifier in the resource.</sch:assert>
         <sch:assert test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
        The tail of the uom ('<sch:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>') must match the value of the identifier in the resource.</sch:assert>
      </sch:rule>
  </sch:pattern>

  <sch:pattern id="RadionuclideActivity_AllowableUOM">
      <sch:rule context="tspi:radionuclideActivity">
         <sch:assert test="starts-with(@uom, concat($GSIP, '/uom/radionuclideActivity'))">
        The UOM must be from the set for the physical quantity 'radionuclide activity' that is that is registered in the MDR GSIP Governance Namespace.</sch:assert>
         <sch:assert test="document(@uom)">
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</sch:assert>
         <!-- Verify that the content of the resource matches the instance document -->
         <sch:assert test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
        The body of the uom must match the codeSpace of the identifier in the resource.</sch:assert>
         <sch:assert test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
        The tail of the uom ('<sch:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>') must match the value of the identifier in the resource.</sch:assert>
      </sch:rule>
  </sch:pattern>

  <sch:pattern id="Rate_AllowableUOM">
      <sch:rule context="tspi:rate">
         <sch:assert test="starts-with(@uom, concat($GSIP, '/uom/rate'))">
        The UOM must be from the set for the physical quantity 'rate' that is that is registered in the MDR GSIP Governance Namespace.</sch:assert>
         <sch:assert test="document(@uom)">
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</sch:assert>
         <!-- Verify that the content of the resource matches the instance document -->
         <sch:assert test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
        The body of the uom must match the codeSpace of the identifier in the resource.</sch:assert>
         <sch:assert test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
        The tail of the uom ('<sch:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>') must match the value of the identifier in the resource.</sch:assert>
      </sch:rule>
  </sch:pattern>

  <sch:pattern id="ReciprocalArea_AllowableUOM">
      <sch:rule context="tspi:reciprocalArea">
         <sch:assert test="starts-with(@uom, concat($GSIP, '/uom/reciprocalArea'))">
        The UOM must be from the set for the physical quantity 'reciprocal area' that is that is registered in the MDR GSIP Governance Namespace.</sch:assert>
         <sch:assert test="document(@uom)">
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</sch:assert>
         <!-- Verify that the content of the resource matches the instance document -->
         <sch:assert test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
        The body of the uom must match the codeSpace of the identifier in the resource.</sch:assert>
         <sch:assert test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
        The tail of the uom ('<sch:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>') must match the value of the identifier in the resource.</sch:assert>
      </sch:rule>
  </sch:pattern>

  <sch:pattern id="ReciprocalTime_AllowableUOM">
      <sch:rule context="tspi:reciprocalTime">
         <sch:assert test="starts-with(@uom, concat($GSIP, '/uom/reciprocalTime'))">
        The UOM must be from the set for the physical quantity 'reciprocal time' that is that is registered in the MDR GSIP Governance Namespace.</sch:assert>
         <sch:assert test="document(@uom)">
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</sch:assert>
         <!-- Verify that the content of the resource matches the instance document -->
         <sch:assert test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
        The body of the uom must match the codeSpace of the identifier in the resource.</sch:assert>
         <sch:assert test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
        The tail of the uom ('<sch:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>') must match the value of the identifier in the resource.</sch:assert>
      </sch:rule>
  </sch:pattern>

  <sch:pattern id="SolidAngle_AllowableUOM">
      <sch:rule context="tspi:solidAngle">
         <sch:assert test="starts-with(@uom, concat($GSIP, '/uom/solidAngle'))">
        The UOM must be from the set for the physical quantity 'solid angle' that is that is registered in the MDR GSIP Governance Namespace.</sch:assert>
         <sch:assert test="document(@uom)">
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</sch:assert>
         <!-- Verify that the content of the resource matches the instance document -->
         <sch:assert test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
        The body of the uom must match the codeSpace of the identifier in the resource.</sch:assert>
         <sch:assert test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
        The tail of the uom ('<sch:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>') must match the value of the identifier in the resource.</sch:assert>
      </sch:rule>
  </sch:pattern>

  <sch:pattern id="SoundSpeedRatio_AllowableUOM">
      <sch:rule context="tspi:soundSpeedRatio">
         <sch:assert test="starts-with(@uom, concat($GSIP, '/uom/soundSpeedRatio'))">
        The UOM must be from the set for the physical quantity 'sound speed ratio' that is that is registered in the MDR GSIP Governance Namespace.</sch:assert>
         <sch:assert test="document(@uom)">
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</sch:assert>
         <!-- Verify that the content of the resource matches the instance document -->
         <sch:assert test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
        The body of the uom must match the codeSpace of the identifier in the resource.</sch:assert>
         <sch:assert test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
        The tail of the uom ('<sch:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>') must match the value of the identifier in the resource.</sch:assert>
      </sch:rule>
  </sch:pattern>

  <sch:pattern id="Speed_AllowableUOM">
      <sch:rule context="tspi:speed">
         <sch:assert test="starts-with(@uom, concat($GSIP, '/uom/speed'))                                or (@uom = concat($GSIP, '/uom/pureNumber/machNumber'))                                 or (@uom = concat($GSIP, '/uom/pureNumber/deciMachNumber'))">
        The UOM must be either from the set for the physical quantity 'planeAngle', or one of the pure number UoMs based on "machNumber", that are registered in the MDR GSIP Governance Namespace.</sch:assert>
         <sch:assert test="document(@uom)">
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</sch:assert>
         <!-- Verify that the content of the resource matches the instance document -->
         <sch:assert test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
        The body of the uom must match the codeSpace of the identifier in the resource.</sch:assert>
         <sch:assert test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
        The tail of the uom ('<sch:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>') must match the value of the identifier in the resource.</sch:assert>
      </sch:rule>
  </sch:pattern>

  <sch:pattern id="SurfaceMassDensityRate_AllowableUOM">
      <sch:rule context="tspi:surfaceMassDensityRate">
         <sch:assert test="starts-with(@uom, concat($GSIP, '/uom/surfaceMassDensityRate'))">
        The UOM must be from the set for the physical quantity 'surface mass density' that is that is registered in the MDR GSIP Governance Namespace.</sch:assert>
         <sch:assert test="document(@uom)">
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</sch:assert>
         <!-- Verify that the content of the resource matches the instance document -->
         <sch:assert test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
        The body of the uom must match the codeSpace of the identifier in the resource.</sch:assert>
         <sch:assert test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
        The tail of the uom ('<sch:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>') must match the value of the identifier in the resource.</sch:assert>
      </sch:rule>
  </sch:pattern>

  <sch:pattern id="ThermodynamicTemperature_AllowableUOM">
      <sch:rule context="tspi:thermodynamicTemperature">
         <sch:assert test="starts-with(@uom, concat($GSIP, '/uom/thermodynamicTemperature'))">
        The UOM must be from the set for the physical quantity 'thermodynamic temperature' that is that is registered in the MDR GSIP Governance Namespace.</sch:assert>
         <sch:assert test="document(@uom)">
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</sch:assert>
         <!-- Verify that the content of the resource matches the instance document -->
         <sch:assert test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
        The body of the uom must match the codeSpace of the identifier in the resource.</sch:assert>
         <sch:assert test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
        The tail of the uom ('<sch:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>') must match the value of the identifier in the resource.</sch:assert>
      </sch:rule>
  </sch:pattern>

  <sch:pattern id="Time_AllowableUOM">
      <sch:rule context="tspi:time">
         <sch:assert test="starts-with(@uom, concat($GSIP, '/uom/time'))">
        The UOM must be from the set for the physical quantity 'time' that is that is registered in the MDR GSIP Governance Namespace.</sch:assert>
         <sch:assert test="document(@uom)">
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</sch:assert>
         <!-- Verify that the content of the resource matches the instance document -->
         <sch:assert test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
        The body of the uom must match the codeSpace of the identifier in the resource.</sch:assert>
         <sch:assert test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
        The tail of the uom ('<sch:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>') must match the value of the identifier in the resource.</sch:assert>
      </sch:rule>
  </sch:pattern>

  <sch:pattern id="Volume_AllowableUOM">
      <sch:rule context="tspi:volume">
         <sch:assert test="starts-with(@uom, concat($GSIP, '/uom/volume'))">
        The UOM must be from the set for the physical quantity 'volume' that is that is registered in the MDR GSIP Governance Namespace.</sch:assert>
         <sch:assert test="document(@uom)">
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</sch:assert>
         <!-- Verify that the content of the resource matches the instance document -->
         <sch:assert test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
        The body of the uom must match the codeSpace of the identifier in the resource.</sch:assert>
         <sch:assert test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
        The tail of the uom ('<sch:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>') must match the value of the identifier in the resource.</sch:assert>
      </sch:rule>
  </sch:pattern>

  <sch:pattern id="VolumeFlowRate_AllowableUOM">
      <sch:rule context="tspi:volumeFlowRate">
         <sch:assert test="starts-with(@uom, concat($GSIP, '/uom/volumeFlowRate'))">
        The UOM must be from the set for the physical quantity 'volume flow rate' that is that is registered in the MDR GSIP Governance Namespace.</sch:assert>
         <sch:assert test="document(@uom)">
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</sch:assert>
         <!-- Verify that the content of the resource matches the instance document -->
         <sch:assert test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
        The body of the uom must match the codeSpace of the identifier in the resource.</sch:assert>
         <sch:assert test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
        The tail of the uom ('<sch:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>') must match the value of the identifier in the resource.</sch:assert>
      </sch:rule>
  </sch:pattern>

  <sch:pattern id="VolumeFraction_AllowableUOM">
      <sch:rule context="tspi:volumeFraction">
         <sch:assert test="starts-with(@uom, concat($GSIP, '/uom/volumeFraction'))">
        The UOM must be from the set for the physical quantity 'volume fraction' that is that is registered in the MDR GSIP Governance Namespace.</sch:assert>
         <sch:assert test="document(@uom)">
        The specified unit of measure must reference a net-accessible resource in the MDR GSIP Governance Namespace.</sch:assert>
         <!-- Verify that the content of the resource matches the instance document -->
         <sch:assert test="concat(concat(substring-before(@uom, 'uom/'),'uom/'),substring-before(substring-after(@uom, 'uom/'),'/')) = document(@uom)//gml:identifier/@codeSpace">
        The body of the uom must match the codeSpace of the identifier in the resource.</sch:assert>
         <sch:assert test="substring-after(substring-after(@uom, 'uom/'),'/') = document(@uom)//gml:identifier">
        The tail of the uom ('<sch:value-of select="substring-after(substring-after(@uom, 'uom/'),'/')"/>') must match the value of the identifier in the resource.</sch:assert>
      </sch:rule>
  </sch:pattern>

  
  <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
  <!-- - - - - - - - - - - - - - Temporal Restrictions - - - - - - - - - - - - - - - - - - - - -->
  <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
  
  <sch:pattern id="TimePosition_must_not_have_InconsistentContent">
      <sch:rule context="gml:timePosition">
         <sch:assert test="not(@indeterminatePosition = 'now')">
        The time position indeterminate position 'now' shall not be used.</sch:assert>
         <sch:assert test="not((@indeterminatePosition = 'unknown') and normalize-space(.))">
        The time position indeterminate position 'unknown' shall not be used if there is a specified time position value.</sch:assert>
         <sch:assert test="not(((@indeterminatePosition = 'before') or (@indeterminatePosition = 'after')) and not(normalize-space(.)))">
        The time position indeterminate positions 'before' and 'after' shall not be used if there is no specified time position value..</sch:assert>
      </sch:rule>
  </sch:pattern>
  
  <sch:pattern id="TimeInstantIsolated_must_not_have_InconsistentContent">
      <sch:rule context="gml:TimeInstant/gml:timePosition">
         <sch:assert test="not(@indeterminatePosition)">
        The time position indeterminate position shall not be used in the case of an isolated time instant (as opposed to one that is participating in a time period).</sch:assert>
      </sch:rule>
  </sch:pattern>
  
  <!--
    When specifying a time instant a degree of precision should be used that is consistent with
    applicable business practices.  However, in the context of enterprise-wide search it is necessary 
    to ensure that a consistent interpretation of reduced-precision values of gml:timePosition is shared.
    
    To this end the following rules shall be observed:
    
    1.	The date/times reported for a time period shall be inclusive in the period.
    
    2.	The reported time shall always be based on Universal Time (UTC), indicated
           by appending the capital letter Z (meaning the "zero meridian") to the time specification. 
           
    3.	Given a truncated specification of date/time (see Table 13) for the start of the period, 
           it shall be understood that for the year specified the period begins at:
              o the first month of the year when the month is not specified,
              o the first day of the month when the day is not specified,
              o the exact specified time when the fractional seconds are not specified, and
              o 00:00:00.0Z when the time is not specified.
              
    4.	Given a truncated specification of date/time (see Table 13) for the end of the period,
           it shall be understood that for the year specified the period ends at:
              o the last month of the year when the month is not specified,
              o the last day of the month when the day is not specified,
              o the specified time plus 0.9 seconds when the fractional seconds are not specified, and
              o 23:59:59.9Z when the time is not specified.
              
    Rigorous observance of these rules when preparing or using NMIS instance documents will ensure
    a consistent understanding of temporal extents.
  -->
  
  <sch:pattern id="TimePosition_must_have_ValidContent">
    <!-- Constrain the value of TimePosition to be a valid gml:CalDate (xs:gYear, xs:gYearMonth, or xs:date) value or valid xs:dateTime value. -->
      <sch:rule context="gml:timePosition">
         <sch:let name="year" value="number(substring(.,1,4))"/>
         <sch:let name="month" value="number(substring(.,6,2))"/>
         <sch:let name="day" value="number(substring(.,9,2))"/>
         <sch:let name="hour" value="number(substring(.,12,2))"/>
         <sch:let name="minute" value="number(substring(.,15,2))"/>
         <sch:let name="second1" value="number(substring(.,18,2))"/>
         <sch:let name="second2" value="number(substring(.,18,4))"/>
      
         <!-- Check correct string-length range and that it is a "known" time position -->
         <sch:assert test="(string-length(.) &gt;= 4) and (string-length(.) &lt;= 23) or (@indeterminatePosition = 'unknown')">
        The time position element contains '<sch:value-of select="."/>' but should contain a proper date or dateTime.</sch:assert>
         <!-- Check the CCYY, CCYY-MM, and CCYY-MM-DD patterns -->
         <sch:assert test="not(string-length(.) = 4) or         ((string-length(.) = 4) and ($year))">
        The time position element contains '<sch:value-of select="."/>' but should contain a year in the format CCYY.</sch:assert>
         <sch:assert test="not((string-length(.) &gt; 4) and (string-length(.) &lt;= 7)) or          ((string-length(.) = 7) and ($year) and          (substring(.,5,1) = '-') and ($month &gt;= 1 and $month &lt;= 12))">
        The time position element contains '<sch:value-of select="."/>' but should contain a year-month in the format CCYY-MM.</sch:assert>
         <sch:assert test="not((string-length(.) &gt; 7) and (string-length(.) &lt;= 10)) or          ((string-length(.) = 10) and ($year) and          (substring(.,5,1) = '-') and ($month &gt;= 1 and $month &lt;= 12) and          (substring(.,8,1) = '-') and ($day &gt;= 1 and $day &lt;= 31))">
        The time position element contains '<sch:value-of select="."/>' but should contain a year-month-day in the format CCYY-MM-DD.</sch:assert>
         <!-- Check the CCYY-MM-DDTHH:MM:SSZ pattern -->
         <sch:assert test="not((string-length(.) &gt; 12) and (string-length(.) &lt;= 19)) or          ((string-length(.) = 19) and ($year) and          (substring(.,5,1) = '-') and ($month &gt;= 1 and $month &lt;= 12) and          (substring(.,8,1) = '-') and ($day &gt;= 1 and $day &lt;= 31) and         (substring(.,11,1) = 'T') and ($hour &gt;= 0 and $hour &lt;= 23) and          (substring(.,14,1) = ':') and ($minute &gt;= 0 and $minute &lt;= 59) and         (substring(.,17,1) = ':') and ($second1 &gt;=0 and $second1 &lt;= 59) and         (substring(.,20,1) = 'Z'))">
        The time position element contains '<sch:value-of select="."/>' but should contain a year-month-day/hour-minute-second in the format CCYY-MM-DDTHH:MM:SSZ.</sch:assert>
         <!-- Check the CCYY-MM-DDTHH:MM:SS.0Z pattern -->
         <sch:assert test="not((string-length(.) &gt; 12) and (string-length(.) &lt;= 19)) or          ((string-length(.) = 19) and ($year) and          (substring(.,5,1) = '-') and ($month &gt;= 1 and $month &lt;= 12) and          (substring(.,8,1) = '-') and ($day &gt;= 1 and $day &lt;= 31) and         (substring(.,11,1) = 'T') and ($hour &gt;= 0 and $hour &lt;= 23) and          (substring(.,14,1) = ':') and ($minute &gt;= 0 and $minute &lt;= 59) and         (substring(.,17,1) = ':') and ($second2 &gt;=0 and $second1 &lt;= 59) and         (substring(.,22,1) = 'Z'))">
        The time position element contains '<sch:value-of select="."/>' but should contain a year-month-day/hour-minute-second in the format CCYY-MM-DDTHH:MM:SS.SZ.</sch:assert>
      </sch:rule> 
  </sch:pattern>
  
  <sch:pattern id="TimePeriod_must_not_have_InconsistentEnds">
      <sch:rule context="gml:TimePeriod">
         <sch:assert test="not(gml:begin/gml:TimeInstant/gml:timePosition/@indeterminatePosition = 'after')">
        The begin time position shall not have an indeterminate position of 'after'.</sch:assert>
         <sch:assert test="not(gml:end/gml:TimeInstant/gml:timePosition/@indeterminatePosition = 'before')">
        The end time position shall not have an indeterminate position of 'before'.</sch:assert>
      </sch:rule>
  </sch:pattern>
  
  <sch:pattern id="TimePeriod_must_have_PositiveDuration">
      <sch:rule context="gml:TimePeriod">
         <sch:let name="year_begin"
                  value="number(substring(gml:begin/gml:TimeInstant/gml:timePosition,1,4))"/>
         <sch:let name="month_begin"
                  value="number(substring(gml:begin/gml:TimeInstant/gml:timePosition,6,2))"/>
         <sch:let name="day_begin"
                  value="number(substring(gml:begin/gml:TimeInstant/gml:timePosition,9,2))"/>
         <sch:let name="hour_begin"
                  value="number(substring(gml:begin/gml:TimeInstant/gml:timePosition,12,2))"/>
         <sch:let name="minute_begin"
                  value="number(substring(gml:begin/gml:TimeInstant/gml:timePosition,15,2))"/>
         <sch:let name="second1_begin"
                  value="number(substring(gml:begin/gml:TimeInstant/gml:timePosition,18,2))"/>
         <sch:let name="second2_begin"
                  value="number(substring(gml:begin/gml:TimeInstant/gml:timePosition,18,4))"/>
         <sch:let name="year_end"
                  value="number(substring(gml:end/gml:TimeInstant/gml:timePosition,1,4))"/>
         <sch:let name="month_end"
                  value="number(substring(gml:end/gml:TimeInstant/gml:timePosition,6,2))"/>
         <sch:let name="day_end"
                  value="number(substring(gml:end/gml:TimeInstant/gml:timePosition,9,2))"/>
         <sch:let name="hour_end"
                  value="number(substring(gml:end/gml:TimeInstant/gml:timePosition,12,2))"/>
         <sch:let name="minute_end"
                  value="number(substring(gml:end/gml:TimeInstant/gml:timePosition,15,2))"/>
         <sch:let name="second1_end"
                  value="number(substring(gml:end/gml:TimeInstant/gml:timePosition,18,2))"/>
         <sch:let name="second2_end"
                  value="number(substring(gml:end/gml:TimeInstant/gml:timePosition,18,4))"/>
      
         <!-- If the start-value is missing then it is always inferred to be the minimum-allowed value and thus the interval is valid. -->
         <!-- If the end-value is missing then it is always inferred to be the maximum-allowed value and thus the interval is also valid. -->
         <sch:assert test="not(gml:begin/gml:TimeInstant/@indeterminatePosition = 'unknown') and not(gml:end/gml:TimeInstant/@indeterminatePosition = 'unknown') and         ((not($year_end) or not($year_begin)) or ($year_begin &lt;= $year_end)) and         ((not($month_end) or not($month_begin)) or ($month_begin &lt;= $month_end)) and         ((not($day_end) or not($day_begin)) or ($day_begin &lt;= $day_end)) and         ((not($hour_end) or not($hour_begin)) or ($hour_begin &lt;= $hour_end)) and         ((not($minute_end) or not($minute_begin)) or ($minute_begin &lt;= $minute_end)) and         ((not($second1_end) or not($second1_begin)) or ($second1_begin &lt;= $second1_end)) and         ((not($second2_end) or not($second2_begin)) or ($second2_begin &lt;= $second2_end))">
        The time period element specifies a non-positive duration: '<sch:value-of select="gml:begin/gml:TimeInstant/gml:timePosition"/>' to '<sch:value-of select="gml:end/gml:TimeInstant/gml:timePosition"/>'.</sch:assert> 
      </sch:rule> 
  </sch:pattern>
  
</sch:schema>
<!--UNCLASSIFIED-->
