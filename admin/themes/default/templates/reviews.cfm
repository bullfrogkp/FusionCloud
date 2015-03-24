﻿<cfoutput>
<section class="content-header">
	<h1>
		Reviews
	</h1>
	<ol class="breadcrumb">
		<li><a href="##"><i class="fa fa-dashboard"></i> Home</a></li>
		<li class="active">Reviews</li>
	</ol>
</section>
<section class="content">
	<div class="row">
		<div class="col-xs-12">
			<form>
				<div class="box box-default">
					<div class="box-body">
						<div class="row">
							<div class="col-xs-2">
								<input type="text" name="id" class="form-control" placeholder="ID" <cfif StructKeyExists(URL,"id")>value="#URL.id#"</cfif>>
							</div>
							<div class="col-xs-3">
								<select class="form-control" name="is_enabled">
									<option value="">All Status</option>
									<option value="1" <cfif StructKeyExists(URL,"is_enabled") AND URL.is_enabled EQ 1>selected</cfif>>Enabled</option>
									<option value="0" <cfif StructKeyExists(URL,"is_enabled") AND URL.is_enabled EQ 0>selected</cfif>>Disabled</option>
								</select>
							</div>
							<div class="col-xs-5">
								<input type="text" name="search_keyword" class="form-control" placeholder="Keywords" <cfif StructKeyExists(URL,"search_keyword")>value="#URL.search_keyword#"</cfif>>
							</div>
							<div class="col-xs-2">
								<button name="search_category" type="submit" class="btn btn-sm btn-primary search-button pull-right">Search</button>
							</div>
						</div>
					</div>
				</div>
			</form>
			<div class="box box-primary">
				<div class="box-body table-responsive">
					<table class="table table-bordered table-hover">
					
						<tr class="default">
							<th>Subject</th>
							<th>Product</th>
							<th>Message</th>
							<th>Create Datetime</th>
							<th>Status</th>
							<th>Action</th>
						</tr>
					
						<cfloop array="#REQUEST.pageData.reviews#" index="review">
							<tr>
								<td>#review.getSubject()#</td>
								<td>#review.getProduct().getDisplayName()#</td>
								<td>#review.getMessage()#</td>
								<td>#DateFormat(review.getCreatedDatetime(),"mmm dd,yyyy")#</td>
								<td>
									<cfswitch expression="#review.getReviewStatusType().getDisplayName()#">
										<cfcase value="Approved"><span class="label label-success">Approved</span></cfcase>
										<cfcase value="Denied"><span class="label label-danger">Denied</span></cfcase>
										<cfcase value="Pending"><span class="label label-warning">Pending</span></cfcase>
									</cfswitch>
								</td>
								<td><a href="#APPLICATION.absoluteUrlWeb#admin/review_detail.cfm?id=#review.getReviewId()#">View Detail</a></td>
							</tr>
						</cfloop>
					
						<tr class="default">
							<th>Subject</th>
							<th>Product</th>
							<th>Message</th>
							<th>Create Datetime</th>
							<th>Status</th>
							<th>Action</th>
						</tr>
					</table>
				</div><!-- /.box-body -->
			</div><!-- /.box -->
		</div>
	</div>
</section><!-- /.content -->
</cfoutput>
