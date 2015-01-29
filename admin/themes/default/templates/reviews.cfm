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
			<div class="box">
				<div class="box-body table-responsive">
					<table id="example2" class="table table-bordered table-striped">
						<thead>
							<tr>
								<th>Name</th>
								<th>Subject</th>
								<th>Status</th>
								<th>Type</th>
								<th>Product</th>
								<th>Create Datetime</th>
								<th>Action</th>
							</tr>
						</thead>
						<tbody>
						
							<tr>
								<td>Test email 1</td>
								<td>This is a new email</td>
								<td>Test email 1</td>
								<td>Test email 1</td>
								<td>This is a new email</td>
								<td>Test email 1</td>
								<td><a href="review_detail.cfm?request_id=1">View Detail</a></td>
							</tr>
							
						</tbody>
						<tfoot>
							<tr>
								<th>Name</th>
								<th>Subject</th>
								<th>Status</th>
								<th>Type</th>
								<th>Product</th>
								<th>Create Datetime</th>
								<th>Action</th>
							</tr>
						</tfoot>
					</table>
				</div><!-- /.box-body -->
			</div><!-- /.box -->
		</div>
	</div>
</section><!-- /.content -->
</cfoutput>
