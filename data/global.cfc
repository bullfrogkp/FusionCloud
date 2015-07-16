﻿<cfcomponent output="false" accessors="true">
	<cfproperty name="pageName" type="string" required="true"> 
	
	<cffunction name="init" access="public" output="false" returntype="any">
		<cfargument name="pageName" type="string" required="true" />
		
		<cfset setPageName(ARGUMENTS.pageName) />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="validateGlobalAccessData" access="public" output="false" returnType="struct">
		<cfset var LOCAL = {} />
		<cfset LOCAL.redirectUrl = "" />
				
		<cfreturn LOCAL />
	</cffunction>
	
	<cffunction name="loadGlobalPageData" access="public" output="false" returnType="struct">
		<cfset var LOCAL = {} />
		<cfset LOCAL.pageData = {} />
		
		<cfset LOCAL.trackingEntity = EntityLoad("tracking_entity",{cfid = COOKIE.cfid, cftoken = COOKIE.cftoken}, true) />
		<cfset LOCAL.trackingRecordType = EntityLoad("tracking_record_type",{name="shopping cart"},true) />
		<cfset LOCAL.pageData.shoppingCartItems = EntityLoad("tracking_record",{trackingEntity = LOCAL.trackingEntity, trackingRecordType = LOCAL.trackingRecordType}) />
		
		<cfset LOCAL.pageData.shoppingCartItemTotalCount = 0 />
		<cfloop array="#LOCAL.pageData.shoppingCartItems#" index="LOCAL.shoppingCartItem">
			<cfset LOCAL.pageData.shoppingCartItemTotalCount += LOCAL.shoppingCartItem.getCount() />
		</cfloop>
		
		<cfset LOCAL.categoryService = new "#APPLICATION.componentPathRoot#core.services.categoryService"() />
		<cfset LOCAL.pageData.categoryTree = LOCAL.categoryService.getCategoryTree(isSpecial=false) />
		<cfset LOCAL.pageData.specialCategories = EntityLoad("category",{isSpecial = true, isEnabled = true, isDeleted = false},"rank Asc") />
		<cfset LOCAL.pageData.currencies =  EntityLoad("currency", {isEnabled=true}) />
		
		<cfif 	ListLen(CGI.PATH_INFO,"/") EQ 6 
				AND 
				Trim(ListGetAt(CGI.PATH_INFO,6,"/"))  NEQ "" 
				AND 
				Trim(ListGetAt(CGI.PATH_INFO,6,"/")) NEQ "-">
			<cfset LOCAL.pageData.searchText = Trim(ListGetAt(CGI.PATH_INFO,6,"/")) />
			<cfset LOCAL.pageData.categoryId = ListGetAt(CGI.PATH_INFO,2,"/") />
			
		<cfelse>
			<cfset LOCAL.pageData.searchText = "" />
			<cfset LOCAL.pageData.categoryId = 0 />
		</cfif>
				
		<cfreturn LOCAL.pageData />
	</cffunction>
	
	<cffunction name="processGlobalFormDataBeforeValidation" access="public" output="false" returnType="struct">
		<cfset var LOCAL = {} />
		<cfset LOCAL.redirectUrl = "" />
		
		<cfset SESSION.temp.formdata = Duplicate(FORM) />
		
		<cfreturn LOCAL />	
	</cffunction>	
	
	<cffunction name="validateGlobalFormData" access="public" output="false" returnType="struct">
		<cfset var LOCAL = {} />
		<cfset LOCAL.redirectUrl = "" />
		
		<cfreturn LOCAL />
	</cffunction>
	
	<cffunction name="processGlobalFormDataAfterValidation" access="public" output="false" returnType="struct">
		<cfset var LOCAL = {} />
		<cfset LOCAL.redirectUrl = "" />
	
		<cfif (StructKeyExists(FORM,"search_product") OR StructKeyExists(FORM,"search_product.x")) AND Trim(FORM.search_text) NEQ "">
			<cfif FORM.search_category_id NEQ 0>
				<cfset LOCAL.category = EntityLoadByPK("category",FORM.search_category_id) />
				<cfset LOCAL.pathInfo = "/#URLEncodedFormat(LOCAL.category.getName())#/#FORM.search_category_id#/1/1/-/#URLEncodedFormat(Trim(FORM.search_text))#/" />
			<cfelse>
				<cfset LOCAL.pathInfo = "/-/-/1/1/-/#URLEncodedFormat(Trim(FORM.search_text))#/" />
			</cfif>
				
			<cfset LOCAL.redirectUrl = "#APPLICATION.absoluteUrlWeb#products.cfm#LOCAL.pathInfo#" />
		</cfif>
		
		<cfif StructKeyExists(FORM,"currency_id")>
			<cfset LOCAL.newCurrency = EntityLoadByPK("currency",FORM.currency_id) />
			<cfset SESSION.currency.id = LOCAL.newCurrency.getCurrencyId() />
			<cfset SESSION.currency.code = LOCAL.newCurrency.getCode() />
			<cfset SESSION.currency.locale = LOCAL.newCurrency.getLocale() />
			
			<cfif StructKeyExists(SESSION,"cart")>
				<cfset SESSION.cart.setCurrencyId(SESSION.currency.id) />
				<cfset SESSION.cart.calculate() />
			</cfif>
		</cfif>
		
		<cfreturn LOCAL />	
	</cffunction>	
	
	<cffunction name="processGlobalURLDataBeforeValidation" access="public" output="false" returnType="struct">
		<cfset var LOCAL = {} />
		<cfset LOCAL.redirectUrl = "" />
		
		<cfif StructKeyExists(URL,"logout")>
			<cfset SESSION.user.customerId = "" />
			<cfset LOCAL.redirectUrl = "#APPLICATION.absoluteUrlWeb#index.cfm" />
		</cfif>
		
		<cfreturn LOCAL />	
	</cffunction>	
	
	<cffunction name="processGlobalURLDataAfterValidation" access="public" output="false" returnType="struct">
		<cfset var LOCAL = {} />
		<cfset LOCAL.redirectUrl = "" />
		
		<cfreturn LOCAL />	
	</cffunction>
</cfcomponent>