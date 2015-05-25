﻿<cfcomponent extends="service" output="false" accessors="true">
	<cffunction name="addTrackingRecord" access="remote" returntype="struct" returnformat="json" output="false">
		<cfargument name="productId" type="numeric" required="true">
		<cfargument name="count" type="numeric" required="true">
		
		<cfset var LOCAL = {} />
		<cfset var retStruct = {} />
		
		<cfset LOCAL.product = EntityLoadByPK("product",ARGUMENTS.productId) />
		<cfset LOCAL.trackingRecordType = EntityLoad("tracking_record_type",{name = "shopping cart"},true) />
		<cfset LOCAL.trackingEntity = EntityLoad("tracking_entity",{cfid = COOKIE.cfid, cftoken = COOKIE.cftoken},true) />
		
		<cfset LOCAL.trackingRecord = EntityLoad("tracking_record", {trackingRecordType = LOCAL.trackingRecordType, trackingEntity = LOCAL.trackingEntity, product = LOCAL.product}, true) />
		
		<cfif NOT IsNull(LOCAL.trackingRecord)>
			<cfset LOCAL.trackingRecord.setCount(LOCAL.trackingRecord.getCount() + ARGUMENTS.count) />
		<cfelse>
			<cfset LOCAL.trackingRecord = EntityNew("tracking_record") />
			<cfset LOCAL.trackingRecord.setTrackingRecordType(LOCAL.trackingRecordType) />
			<cfset LOCAL.trackingRecord.setTrackingEntity(LOCAL.trackingEntity) />
			<cfset LOCAL.trackingRecord.setProduct(LOCAL.product) />
			<cfset LOCAL.trackingRecord.setCount(ARGUMENTS.count) />
			<cfset EntitySave(LOCAL.trackingRecord) />
		</cfif>
		
		<cfset retStruct.trackingRecordId = LOCAL.trackingRecord.getTrackingRecordId() />
		
		<cfreturn retStruct />
	</cffunction>
	
	<cffunction name="applyCouponCode" access="remote" returntype="struct" returnformat="json" output="false">
		<cfargument name="trackingEntityId" type="numeric" required="true">
		<cfargument name="couponCode" type="string" required="true">
		<cfargument name="customerId" type="string" required="true">
		<cfargument name="total" type="numeric" required="true">
		
		<cfset var LOCAL = {} />
		<cfset var retStruct = {} />
		<cfset retStruct.success = true />
		<cfset retStruct.messageType = "" />
		<cfset retStruct.newTotal = "" />
		<cfset retStruct.thresholdAmount = "" />
		
		<cfset LOCAL.couponStatusType = EntityLoad("coupon_status_type",{name="active"},true) />
		<cfset LOCAL.coupon = EntityLoad("coupon",{couponStatusType = LOCAL.couponStatusType, couponCode = Trim(ARGUMENTS.couponCode)},true) />
		
		<cfif ARGUMENTS.total LT LOCAL.coupon.getThresholdAmount()>
			<cfset retStruct.success = false />
			<cfset retStruct.messageType = 1 />
			<cfset retStruct.thresholdAmount = LOCAL.coupon.getThresholdAmount() />
		<cfelseif 	IsDate(LOCAL.coupon.getStartDate()) AND DateCompare(Now(), LOCAL.coupon.getStartDate()) EQ -1
					OR
					IsDate(LOCAL.coupon.getEndDate()) AND DateCompare(LOCAL.coupon.getEndDate(), Now()) EQ -1>
			<cfset retStruct.success = false />
			<cfset retStruct.messageType = 2 />
		<cfelseif NOT IsNull(LOCAL.coupon.getCustomer()) AND IsNumeric(ARGUMENTS.customerId)>
			<cfif LOCAL.coupon.getCustomer().getCustomerId() NEQ ARGUMENTS.customerId>
				<cfset retStruct.success = false />
				<cfset retStruct.messageType = 3 />
			</cfif>
		</cfif>
		
		<cfif retStruct.success EQ true>
			<cfif LOCAL.coupon.getDiscounType().getCalculationType().getName() EQ "fixed">
				<cfset retStruct.newTotal = ARGUMENTS.total - LOCAL.coupon.getDiscounType().getAmount() />
			<cfelseif LOCAL.coupon.getDiscounType().getCalculationType().getName() EQ "percentage">
				<cfset retStruct.newTotal = ARGUMENTS.total * (1 - LOCAL.coupon.getDiscounType().getAmount()) />
			</cfif>
		<cfelse>
			<cfset retStruct.newTotal = ARGUMENTS.total />
		</cfif>
		
		<cfreturn retStruct />
	</cffunction>
</cfcomponent>