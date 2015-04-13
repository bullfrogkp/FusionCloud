﻿<cfcomponent persistent="true"> 
    <cfproperty name="attributeId" column="attribute_id" fieldtype="id" generator="native"> 
	<cfproperty name="name" column="name" ormtype="string"> 
	<cfproperty name="displayName" column="display_name" ormtype="string"> 
	<cfproperty name="attributeSetAttributeRelas" type="array" fieldtype="one-to-many" cfc="attribute_set_attribute_rela" fkcolumn="attribute_id">
</cfcomponent>
