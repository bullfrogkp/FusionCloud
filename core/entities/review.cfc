﻿<cfcomponent extends="entity" persistent="true"> 
    <cfproperty name="reviewId" column="review_id" fieldtype="id" generator="native"> 
    <cfproperty name="subject" column="subject" ormtype="string"> 
    <cfproperty name="rating" column="rating" ormtype="integer"> 
    <cfproperty name="message" column="message" ormtype="string"> 
	
	<cfproperty name="product" fieldtype="many-to-one" cfc="product" fkcolumn="product_id">
	<cfproperty name="reviewStatusType" fieldtype="many-to-one" cfc="review_status_type" fkcolumn="review_status_type_id">
</cfcomponent>