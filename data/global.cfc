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
		<cfset LOCAL.pageData.shoppingCartItemTotalAmount = 0 />
		<cfloop array="#LOCAL.pageData.shoppingCartItems#" index="LOCAL.shoppingCartItem">
			<cfset LOCAL.pageData.shoppingCartItemTotalCount += LOCAL.shoppingCartItem.getCount() />
			<cfset LOCAL.pageData.shoppingCartItemTotalAmount += LOCAL.shoppingCartItem.getCount() * LOCAL.shoppingCartItem.getPrice() />
		</cfloop>
		
		<cfset LOCAL.pageData.menuData = _getMenuData() />
		<cfset LOCAL.pageData.categories = EntityLoad("category",{isSpecial = false, isEnabled = true, isDeleted = false},"rank Asc") />
		<cfset LOCAL.pageData.currencies =  EntityLoad("currency", {isEnabled=true}) />
		<cfset LOCAL.pageData.currencyNow =  EntityLoad("currency", {currencyId=SESSION.currency.id},true) />
		
		<cfif 	ListLen(CGI.PATH_INFO,"/") EQ 6 
				AND
				(
					Trim(ListGetAt(CGI.PATH_INFO,6,"/")) NEQ "-"
					OR
					Trim(ListGetAt(CGI.PATH_INFO,2,"/")) NEQ "-"
				)>
				
			<cfif Trim(ListGetAt(CGI.PATH_INFO,6,"/")) EQ "-">
				<cfset LOCAL.pageData.searchText = "" />
			<cfelse>
				<cfset LOCAL.pageData.searchText = Trim(ListGetAt(CGI.PATH_INFO,6,"/")) />
			</cfif>
			
			<cfif Trim(ListGetAt(CGI.PATH_INFO,2,"/")) EQ "-">
				<cfset LOCAL.pageData.categoryId = 0 />
			<cfelse>
				<cfset LOCAL.pageData.categoryId = ListGetAt(CGI.PATH_INFO,2,"/") />
			</cfif>
		<cfelse>
			<cfset LOCAL.pageData.searchText = "" />
			<cfset LOCAL.pageData.categoryId = 0 />
		</cfif>
				
		<cfreturn LOCAL.pageData />
	</cffunction>
	
	<cffunction name="_getMenuData" access="private" output="false" returnType="struct">
		<cfset var LOCAL = {} />
		
		<cfset LOCAL.menu = {} />
		<cfset LOCAL.menu.newArrivals = {} />
		<cfset LOCAL.menu.deals = {} />
		<cfset LOCAL.menu.products = {} />
		<cfset LOCAL.menu.blog = {} />
		<cfset LOCAL.menu.more = {} />
		<cfset LOCAL.menu.specialCategories = ArrayNew(1) />	
		
		<cfset LOCAL.menu.newArrivals.label ="Men" />
		<cfset LOCAL.menu.newArrivals.men = ArrayNew(1) />
		<cfset LOCAL.menu.newArrivals.women = ArrayNew(1) />
		<cfset LOCAL.menu.newArrivals.hot = ArrayNew(1) />
		
		<cfset LOCAL.menu.newArrivals.label ="Women" />
		<cfset LOCAL.menu.deals.onsale = ArrayNew(1) />
		<cfset LOCAL.menu.deals.clearance = ArrayNew(1) />
		<cfset LOCAL.menu.deals.hot = ArrayNew(1) />
		
		<cfset LOCAL.menu.newArrivals.label ="Products" />
		<cfset LOCAL.menu.products = ArrayNew(1) />
		
		<cfset LOCAL.menu.blog.label ="Blog" />
		
		<cfset LOCAL.menu.more.label ="More" />
		<cfset LOCAL.menu.more.links = ArrayNew(1) />
		
		<cfset LOCAL.pageData.specialCategories = EntityLoad("category",{isSpecial = true, isEnabled = true, isDeleted = false},"rank Asc") />
				
		<cfloop array="#LOCAL.pageData.specialCategories#" index="LOCAL.category">
			<cfset LOCAL.newMenuItem = {} />
			<cfset LOCAL.newMenuItem.label = LOCAL.category.getDisplayName() />
			<cfset LOCAL.newMenuItem.link = "" />
			<cfset ArrayAppend(LOCAL.specialCategories, LOCAL.newMenuItem) />
		</cfloop>
		
		<cfreturn LOCAL.menu />	
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
	
		<cfif (StructKeyExists(FORM,"search_product") OR StructKeyExists(FORM,"search_product.x")) AND (Trim(FORM.search_text) NEQ "" OR FORM.search_category_id NEQ 0)>
		
			<cfif Trim(FORM.search_text) EQ "">
				<cfset LOCAL.searchText = "-" />
			<cfelse>
				<cfset LOCAL.searchText = URLEncodedFormat(Trim(FORM.search_text)) />
			</cfif>
			
			<cfif FORM.search_category_id EQ 0>
				<cfset LOCAL.searchCategoryId = "-" />
				<cfset LOCAL.searchCategoryName = "-" />
			<cfelse>
				<cfset LOCAL.category = EntityLoadByPK("category",FORM.search_category_id) />
				<cfset LOCAL.searchCategoryId = FORM.search_category_id />
				<cfset LOCAL.searchCategoryName = URLEncodedFormat(LOCAL.category.getName()) />
			</cfif>
		
			<cfset LOCAL.pathInfo = "/#LOCAL.searchCategoryName#/#LOCAL.searchCategoryId#/1/1/-/#LOCAL.searchText#/" />
				
			<cfset LOCAL.redirectUrl = "#APPLICATION.absoluteUrlWeb#products.cfm#LOCAL.pathInfo#" />
			
		<cfelseif StructKeyExists(FORM,"currency_id")>
		
			<cfset LOCAL.newCurrency = EntityLoadByPK("currency",FORM.currency_id) />
			<cfset SESSION.currency.id = LOCAL.newCurrency.getCurrencyId() />
			<cfset SESSION.currency.code = LOCAL.newCurrency.getCode() />
			<cfset SESSION.currency.locale = LOCAL.newCurrency.getLocale() />
			
			<cfif StructKeyExists(SESSION,"cart")>
				<cfset SESSION.cart.setCurrencyId(SESSION.currency.id) />
				<cfset SESSION.cart.calculate() />
			</cfif>
		
		<cfelseif StructKeyExists(FORM,"subscribe_customer")>
		
			<cfif IsValid("email",Trim(FORM.subscribe_email))>
				<!--- get the enabled customer with the same email --->
				<cfset LOCAL.existingActiveCustomer = EntityLoad("customer",{email = Trim(FORM.subscribe_email), isEnabled = true, isDeleted = false}, true) />
				<cfif NOT IsNull(LOCAL.existingActiveCustomer)>
					<cfset LOCAL.existingActiveCustomer.setSubscribed(true) />
					<cfset EntitySave(LOCAL.existingActiveCustomer) />
				<cfelse>
					<!--- get the latest disable customer with the same email --->
					<cfset LOCAL.existingInActiveCustomerArray = EntityLoad("customer",{email = Trim(FORM.subscribe_email), isEnabled = false, isDeleted = false}, "createdDatetime Desc") />
					<cfif NOT ArrayIsEmpty(LOCAL.existingInActiveCustomerArray)>
						<cfset LOCAL.existingInActiveCustomer = LOCAL.existingInActiveCustomerArray[1] />
						<cfset LOCAL.existingInActiveCustomer.setSubscribed(true) />
						<cfset EntitySave(LOCAL.existingInActiveCustomer) />
					<cfelse>
						<cfset LOCAL.customer = EntityNew("customer") />
						<cfset LOCAL.customer.setCreatedUser(SESSION.user.userName) />
						<cfset LOCAL.customer.setCreatedDatetime(Now()) />
						<cfset LOCAL.customer.setIsDeleted(false) />
						<cfset LOCAL.customer.setIsNew(true) />
						<cfset LOCAL.customer.setIsEnabled(false) />
						<cfset LOCAL.customer.setEmail(Trim(FORM.subscribe_email)) />
						<cfset LOCAL.customer.setSubscribed(true) />
						
						<cfset LOCAL.defaultCustomerGroup = EntityLoad("customer_group",{isDefault=true},true) />
						<cfset LOCAL.customer.setCustomerGroup(LOCAL.defaultCustomerGroup) />
						
						<cfset EntitySave(LOCAL.customer) />
					</cfif>
				</cfif>
				
				<cfset LOCAL.redirectUrl = "#APPLICATION.absoluteUrlWeb#subscription_done.cfm" />
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