﻿<cfcomponent persistent="true"> 
    <cfproperty name="orderStatusTypeId" column="order_status_type_id" fieldtype="id" generator="native"> 
    <cfproperty name="name" column="name" ormtype="string"> 
    <cfproperty name="displayName" column="display_name" ormtype="string"> 
</cfcomponent>