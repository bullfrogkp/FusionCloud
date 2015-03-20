﻿<cfcomponent extends="entity" persistent="true"> 
    <cfproperty name="orderProductId" column="order_product_id" fieldtype="id" generator="native">
	<cfproperty name="displayName" column="display_name" ormtype="string"> 
	<cfproperty name="originalPrice" column="original_price" ormtype="float"> 
	<cfproperty name="price" column="price" ormtype="float"> 
	<cfproperty name="quantity" column="quantity" ormtype="integer"> 
	<cfproperty name="subtotalAmount" column="subtotal_amount" ormtype="float"> 
	<cfproperty name="taxAmount" column="tax_amount" ormtype="float"> 
	<cfproperty name="shippingAmount" column="shipping_amount" ormtype="float"> 
	<cfproperty name="shippingMethod" fieldtype="many-to-one" cfc="shipping_method" fkcolumn="shipping_method_id">	
</cfcomponent>
