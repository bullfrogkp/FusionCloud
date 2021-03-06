﻿<cfoutput>
<section class="content-header">
	<h1>
		Coupons
	</h1>
	<ol class="breadcrumb">
		<li><a href="##"><i class="fa fa-dashboard"></i> Home</a></li>
		<li class="active">Coupons</li>
	</ol>
</section>
<section class="content">
	<div class="row">
		<div class="col-xs-12">
			<form>
				<div class="box box-default">
					<div class="box-body">
						<div class="row">
							<div class="col-xs-2" style="padding-right:0;">
								<input type="text" name="id" class="form-control" placeholder="ID" <cfif StructKeyExists(URL,"id")>value="#URL.id#"</cfif>>
							</div>
							<div class="col-xs-3" style="padding-right:0;padding-left:10px;">
								<select class="form-control" name="is_enabled">
									<option value="">All Status</option>
									<option value="1" <cfif StructKeyExists(URL,"is_enabled") AND URL.is_enabled EQ 1>selected</cfif>>Enabled</option>
									<option value="0" <cfif StructKeyExists(URL,"is_enabled") AND URL.is_enabled EQ 0>selected</cfif>>Disabled</option>
								</select>
							</div>
							<div class="col-xs-5" style="padding-right:0;padding-left:10px;">
								<input type="text" name="search_keyword" class="form-control" placeholder="Keywords" <cfif StructKeyExists(URL,"search_keyword")>value="#URL.search_keyword#"</cfif>>
							</div>
							<div class="col-xs-2" style="padding-left:10px;">
								<button name="search_category" type="submit" class="btn btn-sm btn-primary search-button pull-right">Search</button>
							</div>
						</div>
					</div>
				</div>
			</form>
			<div class="box box-primary">
				<div class="box-header">
					<h3 class="box-title">Coupons</h3>
					<a href="#APPLICATION.absoluteUrlWeb#admin/coupon_detail.cfm" class="btn btn-default btn-sm pull-right top-nav-anchor">Add New Coupon</a>
				</div><!-- /.box-header -->
				<div class="box-body table-responsive">
					<table class="table table-bordered table-hover">
						<tr class="default">
							<th>Code</th>
							<th>Date Start</th>
							<th>Date Expire</th>
							<th>Threshold</th>
							<th style="width:40px;">Status</th>
							<th style="width:110px;">Action</th>
						</tr>
					
						<cfif ArrayLen(REQUEST.pageData.paginationInfo.records) NEQ 0>
							<cfloop array="#REQUEST.pageData.paginationInfo.records#" index="coupon">
								<tr>
									<td>#coupon.getCouponCode()#</td>
									<td>#DateFormat(coupon.getStartDate(),"mmm dd,yyyy")#</td>
									<td>#DateFormat(coupon.getEndDate(),"mmm dd,yyyy")#</td>
									<td>#coupon.getThresholdAmount()#</td>
									<td>
										<cfswitch expression="#coupon.getCouponStatusType().getDisplayName()#">
											<cfcase value="active"><span class="label label-success">Active</span></cfcase>
											<cfcase value="expired"><span class="label label-danger">Expired</span></cfcase>
											<cfcase value="used"><span class="label label-primary">Used</span></cfcase>
										</cfswitch>
									</td>
									<td><a href="#APPLICATION.absoluteUrlWeb#admin/coupon_detail.cfm?id=#coupon.getCouponId()#">View Detail</a></td>
								</tr>
							</cfloop>
						<cfelse>
							<tr>
								<td colspan="5">No data available</td>
							</tr>
						</cfif>
				
						<tr class="default">
							<th>Code</th>
							<th>Date Start</th>
							<th>Date Expire</th>
							<th>Threshold</th>
							<th>Status</th>
							<th>Action</th>
						</tr>
					</table>
				</div><!-- /.box-body -->
				<div class="box-footer clearfix">
					<cfinclude template="pagination.cfm" />
				</div>
			</div><!-- /.box -->
		</div>
	</div>
</section><!-- /.content -->
</cfoutput>
