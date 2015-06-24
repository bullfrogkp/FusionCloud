﻿<cfcomponent extends="master">	
	<cffunction name="loadPageData" access="public" output="false" returnType="struct">
		<cfset var LOCAL = {} />
		<cfset LOCAL.pageData = {} />
		
		<cfset LOCAL.pageData.title = "Contents | #APPLICATION.applicationName#" />
		
		<cfset LOCAL.contentService = new "#APPLICATION.componentPathRoot#core.services.contentService"() />
		<cfset LOCAL.contentService.setRecordsPerPage(APPLICATION.recordsPerPage) />
		<cfset LOCAL.contentService.setIsDeleted(false) />
		<cfif StructKeyExists(URL,"id") AND IsNumeric(URL.id)>
			<cfset LOCAL.contentService.setId(URL.id) />
		</cfif>
		<cfif StructKeyExists(URL,"is_enabled") AND IsNumeric(URL.is_enabled)>
			<cfset LOCAL.contentService.setIsEnabled(URL.is_enabled) />
		</cfif>
		<cfif StructKeyExists(URL,"search_keyword") AND Trim(URL.search_keyword) NEQ "">
			<cfset LOCAL.contentService.setSearchKeywords(Trim(URL.search_keyword)) />
		</cfif>
		
		<cfif StructKeyExists(URL,"page") AND IsNumeric(Trim(URL.page))>
			<cfset LOCAL.contentService.setPageNumber(Trim(URL.page)) />
		</cfif>
		
		<cfset LOCAL.recordStruct = LOCAL.contentService.getRecords() />
		<cfset LOCAL.pageData.paginationInfo = _getPaginationInfo(LOCAL.recordStruct) />
		
		<cfreturn LOCAL.pageData />	
	</cffunction>
</cfcomponent>