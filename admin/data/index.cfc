﻿<cfcomponent extends="master">
	<cffunction name="loadPageData" access="public" output="false" returnType="struct">
		<cfset var LOCAL = {} />
		<cfset LOCAL.page_data = {} />
		
		<cfset LOCAL.page_data.title = "Dashboard | #APPLICATION.applicationName#" />
		<cfset LOCAL.page_data.keywords = "Dashboard | #APPLICATION.applicationName#" />
		<cfset LOCAL.page_data.description = "Dashboard | #APPLICATION.applicationName#" />
		
		<cfreturn LOCAL.page_data />	
	</cffunction>
</cfcomponent>