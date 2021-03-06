﻿<cfoutput>
<section class="content-header">
	<h1>
		Conversations
	</h1>
	<ol class="breadcrumb">
		<li><a href="##"><i class="fa fa-dashboard"></i> Home</a></li>
		<li class="active">Conversations</li>
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
							<div class="col-xs-5" style="padding-right:0;padding-left:10px;">
								<input type="text" name="search_keyword" class="form-control" placeholder="Keywords" <cfif StructKeyExists(URL,"search_keyword")>value="#URL.search_keyword#"</cfif>>
							</div>
							<div class="col-xs-2" style="padding-left:10px;">
								<button name="search_item" type="submit" class="btn btn-sm btn-primary search-button pull-right">Search</button>
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
							<th>Description</th>
							<th>Create Datetime</th>
							<th>Create User</th>
							<th>Action</th>
						</tr>
						
						<cfif ArrayLen(REQUEST.pageData.paginationInfo.records) NEQ 0>
							<cfloop array="#REQUEST.pageData.paginationInfo.records#" index="conv">
								<tr>
									<td>
										#conv.getSubject()#
										<cfif conv.getIsNew() EQ true>
											<span class="label label-danger pull-right" style="margin-top:3px;">New</span>
										</cfif>
									</td>
									<td>#conv.getDescription()#</td>
									<td>#conv.getCreatedDatetime()#</td>
									<td>#conv.getCreatedUser()#</td>
									<td><a href="#APPLICATION.absoluteUrlWeb#admin/conversation_detail.cfm?id=#conv.getConversationId()#">View Detail</a></td>
								</tr>
							</cfloop>
						<cfelse>
							<tr>
								<td colspan="5">No data available</td>
							</tr>
						</cfif>
					
						<tr class="default">
							<th>Subject</th>
							<th>Description</th>
							<th>Create Datetime</th>
							<th>Create User</th>
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
