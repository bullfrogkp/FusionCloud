﻿<cfcomponent extends="service" output="false" accessors="true">
    <cfproperty name="attributeSetId" type="numeric"> 
    <cfproperty name="parentProductId" type="numeric"> 
    <cfproperty name="categoryId" type="numeric"> 
    <cfproperty name="sortTypeId" type="numeric"> 
    <cfproperty name="filters" type="struct"> 

	<cffunction name="_getQuery" output="false" access="private" returntype="array">
		<cfargument name="getCount" type="boolean" required="false" default="false" />
		<cfset LOCAL = {} />
		
		<cfif ARGUMENTS.getCount EQ false>
			<cfset LOCAL.ormOptions = getPaginationStruct() />
		<cfelse>
			<cfset LOCAL.ormOptions = {} />
		</cfif>
	   
		<cfquery name="LOCAL.query" ormoptions="#LOCAL.ormOptions#" dbtype="hql">	
			<cfif ARGUMENTS.getCount EQ true>
			SELECT COUNT(p.productId) 
			</cfif>
			FROM product p
			WHERE 1=1
			<cfif getSearchKeywords() NEQ "">	
			AND	(p.displayName like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#getSearchKeywords()#%" /> OR keywords like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#getSearchKeywords()#%" /> OR description like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#getSearchKeywords()#%" />)
			</cfif>
			<cfif NOT IsNull(getId())>
			AND p.productId = <cfqueryparam cfsqltype="cf_sql_integer" value="#getId()#" />
			</cfif>
			<cfif NOT IsNull(getIsEnabled())>
			AND p.isEnabled = <cfqueryparam cfsqltype="cf_sql_bit" value="#getIsEnabled()#" />
			</cfif>
			<cfif NOT IsNull(getIsDeleted())>
			AND p.isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="#getIsDeleted()#" />
			</cfif>
			<cfif NOT IsNull(getCategoryId())>
			AND	EXISTS (FROM  p.categories c WHERE c.categoryId = <cfqueryparam cfsqltype="cf_sql_integer" value="#getCategoryId()#" />)
			</cfif>
			<cfif NOT IsNull(getFilters())>
				<cfloop collection="#getFilters()#" item="LOCAL.filterId">
				AND	EXISTS (FROM    p.productAttributeRelas par 
							JOIN	par.attributeValues av
							WHERE	av.value = (SELECT	fv.value
												FROM	filter_value fv
												JOIN	fv.categoryFilterRela cfr
												JOIN	cfr.filter f
												WHERE	f.filterId = <cfqueryparam cfsqltype="cf_sql_integer" value="#LOCAL.filterId#" />
												AND		f.attribute = par.attribute
												AND		fv.filterValueId = <cfqueryparam cfsqltype="cf_sql_integer" value="#StructFind(getFilters(),LOCAL.filterId)#" />))
				</cfloop>
			</cfif>
			<!---
			<cfif ARGUMENTS.getCount EQ false>
			ORDER BY #getSortTypeId()#
			</cfif>
			--->
		</cfquery>

		<cfreturn LOCAL.query />
    </cffunction>
	
	<cffunction name="getCustomerGroupPrices" output="false" access="public" returntype="query">
		<cfset var LOCAL = {} />
			   
	    <cfquery name="LOCAL.getProductGroupPrices">
			SELECT	cg.customer_group_id AS customerGroupId
			,		cg.display_name AS groupDisplayName
			,		(	SELECT	pcgr.product_customer_group_rela_id
						FROM	product_customer_group_rela pcgr
						WHERE 	pcgr.product_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#getId()#" />
						AND 	cg.customer_group_id = pcgr.customer_group_id) AS productCustomerGroupRelaId
			FROM	customer_group cg 
			ORDER BY cg.is_default DESC, cg.display_name
		</cfquery>
 
		<cfreturn LOCAL.getProductGroupPrices />
    </cffunction>
	
	<cffunction name="getProductShippingMethods" output="false" access="public" returntype="query">
		<cfset var LOCAL = {} />
	   
		<cfquery name="LOCAL.getProductShippingMethods">
			SELECT		sc.display_name AS shipping_carrier_name
			,			sc.image_name
			,			sm.display_name AS shipping_method_name
			,			sm.shipping_method_id
			,			(
							SELECT	product_shipping_method_rela_id 
							FROM 	product_shipping_method_rela psmr
							WHERE 	psmr.product_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#getId()#" />	
							AND		psmr.shipping_method_id = sm.shipping_method_id
						) AS product_shipping_method_rela_id
			FROM		shipping_carrier sc
			JOIN		shipping_method sm ON sc.shipping_carrier_id = sm.shipping_carrier_id
			ORDER BY	sc.shipping_carrier_id
		</cfquery>
		 
		<cfreturn LOCAL.getProductShippingMethods />
    </cffunction>
	
	<cffunction name="getProduct" access="remote" returntype="struct" returnformat="json" output="false">
		<cfargument name="parentProductId" type="numeric" required="true">
		<cfargument name="attributeValueIdList" type="string" required="true">
		<cfargument name="groupName" type="string" required="true">
		
		<cfset var LOCAL = {} />
		<cfset var retStruct = {} />
		
		<cfquery name="LOCAL.getProduct">
			SELECT	p.product_id
			FROM	product_customer_group_rela pcgr
			JOIN	product p ON p.product_id = pcgr.product_id
			JOIN	customer_group cg ON cg.customer_group_id = pcgr.customer_group_id
			WHERE	p.parent_product_id = <cfqueryparam value="#ARGUMENTS.parentProductId#" cfsqltype="cf_sql_integer" />
			AND		cg.name = <cfqueryparam value="#ARGUMENTS.groupName#" cfsqltype="cf_sql_varchar" />
			<cfloop list="#ARGUMENTS.attributeValueIdList#" index="LOCAL.attributeValueId">
			AND		EXISTS	(	SELECT	1
								FROM	product_attribute_rela par
								JOIN	attribute_value av ON av.product_attribute_rela_id = par.product_attribute_rela_id
								WHERE	par.product_id = p.product_id
								AND		par.attribute_id = 
								(
									SELECT	par_sub.attribute_id
									FROM	product_attribute_rela par_sub
									JOIN	attribute_value av_sub ON av_sub.product_attribute_rela_id = par_sub.product_attribute_rela_id
									WHERE	av_sub.attribute_value_id = <cfqueryparam value="#LOCAL.attributeValueId#" cfsqltype="cf_sql_integer" />
								)
								AND		av.value = 
								(
									SELECT	av_sub.value
									FROM	attribute_value av_sub 
									WHERE	av_sub.attribute_value_id = <cfqueryparam value="#LOCAL.attributeValueId#" cfsqltype="cf_sql_integer" />
								)
							)
			</cfloop>
		</cfquery>
		
		<cfif IsNumeric(LOCAL.getProduct.product_id)>
			<cfset LOCAL.product = EntityLoadByPK("product", LOCAL.getProduct.product_id) />
			<cfset retStruct.productid = LOCAL.product.getProductId() />
			<cfset retStruct.stock = LOCAL.product.getStock() />
			<cfset retStruct.price = DollarFormat(LOCAL.product.getPrice()) />
			<cfif NOT IsNumeric(retStruct.stock)>
				<cfset retStruct.stock = 0 />
			</cfif>
		<cfelse>
			<cfset retStruct.productid = "" />
			<cfset retStruct.stock = 0 />
			<cfset retStruct.price = DollarFormat(0) />
		</cfif>
		
		<cfreturn retStruct>
	</cffunction>
	
</cfcomponent>