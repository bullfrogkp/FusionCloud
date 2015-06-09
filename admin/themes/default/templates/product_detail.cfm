﻿<cfoutput>

<script>
	$(document).ready(function() {
		CKEDITOR.replace( 'detail',
		{
			filebrowserBrowseUrl :'#SESSION.absoluteUrlThemeAdmin#js/plugins/ckeditor/filemanager/index.html',
			filebrowserImageBrowseUrl : '#SESSION.absoluteUrlThemeAdmin#js/plugins/ckeditor/filemanager/index.html',
			filebrowserFlashBrowseUrl :'#SESSION.absoluteUrlThemeAdmin#js/plugins/ckeditor/filemanager/index.html'}
		 );
		
		$(".top-level-tab").click(function() {
		  $("##tab_id").val($(this).attr('tabid'));
		});
		
		$("##group_price_tabs li:first-child").addClass("active");
		$("##group_price_tab_content div:first-child").addClass("active");
		
		$("##uploader").plupload({
			// General settings
			runtimes: 'html5,flash,silverlight,html4',
			
			url: "#APPLICATION.absoluteUrlWeb#admin/ajax/upload_product_images.cfm",

			// Maximum file size
			max_file_size: '1000mb',

			// User can upload no more then 20 files in one go (sets multiple_queues to false)
			max_file_count: 20,
			
			chunk_size: '1mb',

			// Specify what files to browse for
			filters: [
				{ title: "Image files", extensions: "jpg,gif,png" }
			],

			// Rename files by clicking on their titles
			rename: true,
			
			// Sort files
			sortable: true,

			// Enable ability to drag'n'drop files onto the widget (currently only HTML5 supports that)
			dragdrop: true,

			// Views to activate
			views: {
				thumbs: true,
				list: false,
				active: 'thumbs'
			},

			// Flash settings
			flash_swf_url : 'http://rawgithub.com/moxiecode/moxie/master/bin/flash/Moxie.cdn.swf',

			// Silverlight settings
			silverlight_xap_url : 'http://rawgithub.com/moxiecode/moxie/master/bin/silverlight/Moxie.cdn.xap'
		});
		
		$('##new_special_price_from_date').datepicker();
		$('##new_special_price_to_date').datepicker();
		$('##special_price_from_date').datepicker();
		$('##special_price_to_date').datepicker();
		$('##new_single_special_price_from_date').datepicker();
		$('##new_single_special_price_to_date').datepicker();
		$('##edit_special_price_from_date').datepicker();
		$('##edit_special_price_to_date').datepicker();
		$('##new_attribute_option_thumbnail_label').colorpicker();
		
		delete_attribute_option
		
		$( "##delete_attribute_option_comfirm" ).click(function() {
			$(this).remove();
		});
		
		$( ".delete-attribute-option" ).click(function() {
			$("##deleted_attribute_value_id").val($(this).attr('attributevalueid'));
			console.log($(this).parent().parent());
			$(this).parent().parent().remove();
		});
		
		$( ".delete-attribute-option-value" ).click(function() {
			$("##sub_product_id").val($(this).attr('subproductid'));
		});
		
		$( ".delete-related-product" ).click(function() {
			$("##delete_related_product_id").val($(this).attr('relatedproductid'));
		});
				
		$( ".edit-default-price" ).click(function() {
			$("##product_shipping_method_rela_id").val($(this).attr('productshippingmethodrelaid'));
		});
		
		var attributesets = new Object();
		var attributeset, attribute, key;
		
		<cfloop array="#REQUEST.pageData.attributeSets#" index="aset">
			
			key = 'attribute_set_' + '#aset.getAttributeSetId()#';
			
			attributes = new Array();

			<cfloop array="#aset.getAttributeSetAttributeRelas()#" index="attr">
				attribute = new Object();
				attribute.display_name = '#attr.getAttribute().getDisplayName()#';
				attribute.attribute_set_id = '#aset.getAttributeSetId()#';
				attribute.attribute_id = '#attr.getAttribute().getAttributeId()#';
				attribute.name = '#attr.getAttribute().getName()#';
				attribute.required = '#attr.getRequired()#';
				attributes.push(attribute);
			</cfloop>
			
			attributesets[key] = attributes;
		</cfloop>	
		
		$( "##attribute_set_id" ).change(function() {
			<cfif NOT IsNull(REQUEST.pageData.product) AND NOT IsNull(REQUEST.pageData.product.getAttributeSet())>		
			if($( "##attribute_set_id" ).val() != #REQUEST.pageData.product.getAttributeSet().getAttributeSetId()#)
			{
				$('##attributes').hide();
				$('##new_attributes').empty();
				$('##attribute_option_values').hide();
				
				var current_key = 'attribute_set_' + $( "##attribute_set_id" ).val();
			
				for(var i=0;i<attributesets[current_key].length;i++)
				{
					if(attributesets[current_key][i].required == 'YES')
						var required_info = ' (required)'; 
					else
						var required_info = '';
					$('##new_attributes').append('<div class="col-xs-3"><div class="box box-warning"><div class="box-body table-responsive no-padding"><table class="table table-hover"><tr class="warning" id="tr-'+attributesets[current_key][i].attribute_set_id+'-'+attributesets[current_key][i].attribute_id+'"><th colspan="2">'+attributesets[current_key][i].display_name+required_info+'</th><th colspan="2"><a attributesetid="'+attributesets[current_key][i].attribute_set_id+'" attributename="'+attributesets[current_key][i].name+'" attributeid="'+attributesets[current_key][i].attribute_id+'" href="" class="add-new-attribute-option pull-right" data-toggle="modal" data-target="##add-new-attribute-option-modal"><span class="label label-primary">Add Option</span></a></th></tr></table></div></div></div>'); 
				}
			}
			else
			{
				$('##new_attributes').empty();
				$('##attributes').show();
				$('##attribute_option_values').show();
			}
			<cfelse>
			$('##attributes').hide();
			$('##new_attributes').empty();
			$('##attribute_option_values').hide();
			
			var current_key = 'attribute_set_' + $( "##attribute_set_id" ).val();
		
			for(var i=0;i<attributesets[current_key].length;i++)
			{
				if(attributesets[current_key][i].required == 'YES')
					var required_info = ' (required)'; 
				else
					var required_info = '';
				$('##new_attributes').append('<div class="col-xs-3"><div class="box box-warning"><div class="box-body table-responsive no-padding"><table class="table table-hover"><tr class="warning" id="tr-'+attributesets[current_key][i].attribute_set_id+'-'+attributesets[current_key][i].attribute_id+'"><th colspan="2">'+attributesets[current_key][i].display_name+required_info+'</th><th colspan="2"><a attributesetid="'+attributesets[current_key][i].attribute_set_id+'" attributename="'+attributesets[current_key][i].name+'" attributeid="'+attributesets[current_key][i].attribute_id+'" href="" class="add-new-attribute-option pull-right" data-toggle="modal" data-target="##add-new-attribute-option-modal"><span class="label label-primary">Add Option</span></a></th></tr></table></div></div></div>'); 
			}
			</cfif>
			
		});
		
		$( ".delete-image" ).click(function() {
			$("##deleted_image_id").val($(this).attr('imageid'));
		});
		
		$( ".edit-group-price" ).click(function() {
			$("##edit_product_customer_group_rela_id").val($(this).attr('productcustomergrouprelaid'));
			$("##edit_price").val($(this).attr('price'));
			$("##edit_special_price").val($(this).attr('specialprice'));
			$("##edit_special_price_from_date").val($(this).attr('fromdate'));
			$("##edit_special_price_to_date").val($(this).attr('todate'));
		});
		
		$( ".delete-group-price" ).click(function() {
			$("##deleted_product_customer_group_rela_id").val($(this).attr('productcustomergrouprelaid'));
		});
		
		$( ".delete-video" ).click(function() {
			$("##deleted_product_video_id").val($(this).attr('productvideoid'));
		});
		
		$( ".add-single-group-price" ).click(function() {
			$("##add_customer_group_id").val($(this).attr('customergroupid'));
		});
				
		$('##new_attributes').on("click","a.add-new-attribute-option", function() {
			$("##add_option_attribute_set_id").val($(this).attr('attributesetid'));
			$("##add_option_attribute_id").val($(this).attr('attributeid'));
			$("##add_option_attribute_name").val($(this).attr('attributename'));
		});

		$( "##add_new_attribute_option" ).click(function() {
			$("##add_customer_group_id").val($(this).attr('customergroupid'));
			
			var thumbnail_content = '';
			var image_content = '';
			
			if($("##new_attribute_option_image").val() != '')
			{
				loadThumbnail($("##new_attribute_option_image")[0].files[0], function(image_src) { 
					thumbnail_content = '<div style="width:14px;height:14px;border:1px solid ##CCC;margin-top:4px;"><img src="'+image_src+'" style="width:100%;height:100%;vertical-align:top;" /></div>';
					image_content = '<div style="width:14px;height:14px;border:1px solid ##CCC;margin-top:4px;"><img src="'+image_src+'" style="width:100%;height:100%;vertical-align:top;" /></div>';
					$("##tr-" + $("##add_option_attribute_set_id").val() + '-' + $("##add_option_attribute_id").val()).after('<tr><td>'+$("##new_attribute_option_name").val()+'</td><td>'+thumbnail_content+'</td><td>'+image_content+'</td><td><a href="" class="delete-attribute-option pull-right" data-toggle="modal" data-target="##delete-attribute-option-modal"><span class="label label-danger">Delete</span></a></td></tr>'); 
				 });
			}
			else
			{
				if($("##add_option_attribute_name").val() == 'color')
					thumbnail_content = '<div style="width:14px;height:14px;border:1px solid ##CCC;background-color:'+$("##new_attribute_option_thumbnail_label").val()+';margin-top:4px;"></div>';
				else
					thumbnail_content = $("##new_attribute_option_thumbnail_label").val();
				$("##tr-" + $("##add_option_attribute_set_id").val() + '-' + $("##add_option_attribute_id").val()).after('<tr><td>'+$("##new_attribute_option_name").val()+'</td><td>'+thumbnail_content+'</td><td>'+image_content+'</td><td><a href="" class="delete-attribute-option pull-right" data-toggle="modal" data-target="##delete-attribute-option-modal"><span class="label label-danger">Delete</span></a></td></tr>'); 
			}
		});
		
		function loadThumbnail(file, callback) {
			var reader = new FileReader();
			reader.readAsDataURL(file);
			reader.onloadend = function () {
				callback(reader.result);
			}
		}
	});
</script>

<section class="content-header">
	<h1>
		Product Detail
		<small>product information</small>
	</h1>
	<ol class="breadcrumb">
		<li><a href="##"><i class="fa fa-dashboard"></i> Home</a></li>
		<li class="active">Product Detail</li>
	</ol>
</section>

<!-- Main content -->
<form method="post" enctype="multipart/form-data">
<input type="hidden" name="id" id="id" value="#REQUEST.pageData.formData.id#" />
<input type="hidden" name="tab_id" id="tab_id" value="#REQUEST.pageData.tabs.activeTabId#" />
<input type="hidden" name="new_attribute_option_product_attribute_rela_id" id="new_attribute_option_product_attribute_rela_id" value="" />
<input type="hidden" name="deleted_attribute_value_id" id="deleted_attribute_value_id" value="" />
<input type="hidden" name="sub_product_id" id="sub_product_id" value="" />
<input type="hidden" name="delete_related_product_id" id="delete_related_product_id" value="" />
<input type="hidden" name="new_attribute_imagename" id="new_attribute_imagename" value="" />
<input type="hidden" name="product_shipping_method_rela_id" id="product_shipping_method_rela_id" value="" />
<input type="hidden" name="deleted_image_id" id="deleted_image_id" value="" />
<input type="hidden" name="edit_product_customer_group_rela_id" id="edit_product_customer_group_rela_id" value="" />
<input type="hidden" name="deleted_product_customer_group_rela_id" id="deleted_product_customer_group_rela_id" value="" />
<input type="hidden" name="deleted_product_video_id" id="deleted_product_video_id" value="" />
<input type="hidden" name="add_customer_group_id" id="add_customer_group_id" value="" />
<input type="hidden" name="add_option_attribute_id" id="add_option_attribute_id" value="" />
<input type="hidden" name="add_option_attribute_set_id" id="add_option_attribute_set_id" value="" />
<input type="hidden" name="add_option_attribute_name" id="add_option_attribute_name" value="" />
<section class="content">
	<div class="row">
		<div class="col-md-12">
			<cfif IsDefined("REQUEST.pageData.message") AND NOT StructIsEmpty(REQUEST.pageData.message)>
				<div class="alert #REQUEST.pageData.message.messageType# alert-dismissable">
					<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
					<cfloop array="#REQUEST.pageData.message.messageArray#" index="msg">
					#msg#<br/>
					</cfloop>
				</div>
			</cfif>
		</div>
		<div class="col-md-12">
			<!-- Custom Tabs -->
			<div class="nav-tabs-custom">
				<ul class="nav nav-tabs">
					<li class="tab-title top-level-tab #REQUEST.pageData.tabs['tab_1']#" tabid="tab_1"><a href="##tab_1" data-toggle="tab">General Information</a></li>
					<li class="tab-title top-level-tab #REQUEST.pageData.tabs['tab_2']#" tabid="tab_2"><a href="##tab_2" data-toggle="tab">Meta Data</a></li>
					<li class="tab-title top-level-tab #REQUEST.pageData.tabs['tab_3']#" tabid="tab_3"><a href="##tab_3" data-toggle="tab">Price</a></li>
					<li class="tab-title top-level-tab #REQUEST.pageData.tabs['tab_4']#" tabid="tab_4"><a href="##tab_4" data-toggle="tab">Images</a></li>
					<li class="tab-title top-level-tab #REQUEST.pageData.tabs['tab_5']#" tabid="tab_5"><a href="##tab_5" data-toggle="tab">Attributes</a></li>
					<li class="tab-title top-level-tab #REQUEST.pageData.tabs['tab_6']# #REQUEST.pageData.deleteButtonClass#" tabid="tab_6"><a href="##tab_6" data-toggle="tab">Related Products</a></li>
					<li class="tab-title top-level-tab #REQUEST.pageData.tabs['tab_7']#" tabid="tab_7"><a href="##tab_7" data-toggle="tab">Reviews</a></li>
					<li class="tab-title top-level-tab #REQUEST.pageData.tabs['tab_8']#" tabid="tab_8"><a href="##tab_8" data-toggle="tab">Shipping</a></li>
					<li class="tab-title top-level-tab #REQUEST.pageData.tabs['tab_9']#" tabid="tab_9"><a href="##tab_9" data-toggle="tab">Video</a></li>
				</ul>
				<div class="tab-content">
					<div class="tab-pane #REQUEST.pageData.tabs['tab_1']#" id="tab_1">
						 <div class="form-group">
							<label>Product Name</label>
							<input name="display_name" type="text" class="form-control" placeholder="Enter ..." value="#REQUEST.pageData.formData.display_name#"/>
						</div>
						<div class="form-group">
							<label>Category</label>
							<select class="form-control" multiple name="category_id">
								<cfloop array="#REQUEST.pageData.categoryTree#" index="cat">
									<option value="#cat.getCategoryId()#"
									<cfif NOT IsNull(REQUEST.pageData.product) AND NOT IsNull(REQUEST.pageData.product.getCategories()) AND ArrayContains(REQUEST.pageData.product.getCategories(),cat)>
									selected
									</cfif>
									>#RepeatString("&nbsp;",1)##cat.getDisplayName()#</option>
									<cfloop array="#cat.getSubCategories()#" index="subCat">
										<option value="#subCat.getCategoryId()#"
										<cfif NOT IsNull(REQUEST.pageData.product) AND NOT IsNull(REQUEST.pageData.product.getCategories()) AND ArrayContains(REQUEST.pageData.product.getCategories(),subCat)>
										selected
										</cfif>
										>#RepeatString("&nbsp;",11)##subCat.getDisplayName()#</option>
										<cfloop array="#subCat.getSubCategories()#" index="thirdCat">
											<option value="#thirdCat.getCategoryId()#"
											<cfif NOT IsNull(REQUEST.pageData.product) AND NOT IsNull(REQUEST.pageData.product.getCategories()) AND ArrayContains(REQUEST.pageData.product.getCategories(),thirdCat)>
											selected
											</cfif>
											>#RepeatString("&nbsp;",21)##thirdCat.getDisplayName()#</option>
										</cfloop>
										</li>
									</cfloop>
									</li>
								</cfloop>
							</select>
						</div>
						<div class="form-group">
							<label>SKU</label>
							<input name="sku" type="text" class="form-control" placeholder="Enter ..." value="#REQUEST.pageData.formData.sku#"/>
						</div>
						<div class="form-group">
							<label>Stock</label>
							<input name="stock" type="text" class="form-control" placeholder="Enter ..." value="#REQUEST.pageData.formData.stock#"/>
						</div>
						<div class="form-group">
							<label>Status</label>
							 <select class="form-control" name="is_enabled">
								<option value="1" <cfif REQUEST.pageData.formData.is_enabled EQ TRUE>selected</cfif>>Enabled</option>
								<option value="0" <cfif REQUEST.pageData.formData.is_enabled EQ FALSE>selected</cfif>>Disabled</option>
							</select>
						</div>
						<div class="form-group">
							<label>Product Detail</label>
							<textarea name="detail" id="detail" class="textarea" placeholder="Message" style="width: 100%; height: 125px; font-size: 14px; line-height: 18px; border: 1px solid ##dddddd; padding: 10px;">#REQUEST.pageData.formData.detail#</textarea>
						</div>
					</div><!-- /.tab-pane -->
					<div class="tab-pane #REQUEST.pageData.tabs['tab_2']#" id="tab_2">
						
						 <div class="form-group">
							<label>Title</label>
							<input name="title" type="text" class="form-control" placeholder="Enter ..." value="#REQUEST.pageData.formData.title#"/>
						</div>
						<div class="form-group">
							<label>Description</label>
							<textarea name="description" class="form-control" rows="3" placeholder="Enter ...">#REQUEST.pageData.formData.description#</textarea>
						</div>
						<div class="form-group">
							<label>Keywords</label>
							<textarea name="keywords" class="form-control" rows="3" placeholder="Enter ...">#REQUEST.pageData.formData.keywords#</textarea>
						</div>
						
					</div><!-- /.tab-pane -->
					<div class="tab-pane #REQUEST.pageData.tabs['tab_3']#" id="tab_3">
						<cfif IsNumeric(REQUEST.pageData.formData.id)>
							<div class="form-group">
								<label>Price(s)</label>
								<div class="row" style="margin-top:10px;">
									<cfloop query="REQUEST.pageData.customerGroupPrices">				
										<cfset group = REQUEST.pageData.customerGroupPrices />
										<cfif IsNumeric(group.productCustomerGroupRelaId)>
											<cfset groupPrice = EntityLoadByPK("product_customer_group_rela",group.productCustomerGroupRelaId) />
										</cfif>
										<div class="col-xs-3">
											<div class="box <cfif IsNumeric(group.productCustomerGroupRelaId)>box-warning<cfelse>box-default</cfif>">
												<div class="box-body table-responsive no-padding">
													<table class="table table-hover">
														<tr class="<cfif IsNumeric(group.productCustomerGroupRelaId)>warning<cfelse>default</cfif>">
															<th>#group.groupDisplayName#</th>
															<th>
																<cfif IsNumeric(group.productCustomerGroupRelaId)>
																	<a productcustomergrouprelaid="#group.productCustomerGroupRelaId#" href="" class="delete-group-price pull-right" data-toggle="modal" data-target="##delete-group-price-modal"><span class="label label-danger">Delete</span></a>
																	<a productcustomergrouprelaid="#group.productCustomerGroupRelaId#" 
				
																	price="<cfif IsNumeric(group.productCustomerGroupRelaId)>#groupPrice.getPrice()#</cfif>"
																	specialprice="<cfif IsNumeric(group.productCustomerGroupRelaId)>#groupPrice.getSpecialPrice()#</cfif>"
																	fromdate="<cfif IsNumeric(group.productCustomerGroupRelaId)>#DateFormat(groupPrice.getSpecialPriceFromDate(),"yyyy/mm/dd")#</cfif>"
																	todate="<cfif IsNumeric(group.productCustomerGroupRelaId)>#DateFormat(groupPrice.getSpecialPriceToDate(),"yyyy/mm/dd")#</cfif>"
																	
																	href="" class="edit-group-price pull-right" data-toggle="modal" data-target="##edit-group-price-modal" style="margin-right:5px;"><span class="label label-primary">Edit</span></a>
																<cfelse>
																	<a customergroupid="#group.customerGroupId#" href="" class="add-single-group-price pull-right" data-toggle="modal" data-target="##add-single-group-price-modal"><span class="label label-primary">Add</span></a>
																</cfif>
															</th>
														</tr>
														<tr>
															<td>price:</td>
															<td>
																<cfif IsNumeric(group.productCustomerGroupRelaId)>
																	#groupPrice.getPrice()#
																<cfelse>
																	-
																</cfif>
															</td>
														</tr>
														<tr>
															<td>special price:</td>
															<td>
																<cfif IsNumeric(group.productCustomerGroupRelaId)>
																	#groupPrice.getSpecialPrice()#
																<cfelse>
																	-
																</cfif>
															</td>
														</tr>
														<tr>
															<td>from:</td>
															<td>
																<cfif IsNumeric(group.productCustomerGroupRelaId)>
																	#DateFormat(groupPrice.getSpecialPriceFromDate(),"mmm dd, yyyy")#
																<cfelse>
																	-
																</cfif>
															</td>
														</tr>
														<tr>
															<td>to:</td>
															<td>
																<cfif IsNumeric(group.productCustomerGroupRelaId)>
																	#DateFormat(groupPrice.getSpecialPriceToDate(),"mmm dd, yyyy")#
																<cfelse>
																	-
																</cfif>
															</td>
														</tr>
													</table>
												</div><!-- /.box-body -->
											</div><!-- /.box -->
										</div>
									</cfloop>
								</div>
							</div>
						<cfelse>
							<div class="form-group">
								<label>Price</label>
								<input type="text" name="price" class="form-control" placeholder="Enter ..." />
							</div>
							<div class="form-group">
								<label>Special Price</label>
								<input name="special_price" type="text" class="form-control" placeholder="Enter ..." />
							</div>
							 <div class="form-group">
								<label>Special Price From Date</label>
								<div class="input-group">
									<div class="input-group-addon">
										<i class="fa fa-calendar"></i>
									</div>
									<input type="text" class="form-control pull-right" name="special_price_from_date" id="special_price_from_date" />
								</div><!-- /.input group -->
							</div><!-- /.form group -->
							<div class="form-group">
								<label>Special Price To Date</label>
								<div class="input-group">
									<div class="input-group-addon">
										<i class="fa fa-calendar"></i>
									</div>
									<input type="text" class="form-control pull-right" name="special_price_to_date" id="special_price_to_date" />
								</div><!-- /.input group -->
							</div><!-- /.form group -->
						</cfif>
						
						<div class="form-group">
							<label>Tax Category</label>
							<select name="tax_category_id" class="form-control">
								<option value="">Please Select...</option>
								<cfloop array="#REQUEST.pageData.taxCategories#" index="tc">
									<option value="#tc.getTaxCategoryId()#"
									
									<cfif NOT IsNull(REQUEST.pageData.product) AND NOT IsNull(REQUEST.pageData.product.getTaxCategory()) AND tc.getTaxCategoryId() EQ REQUEST.pageData.formData.tax_category_id>
									selected
									</cfif>
									
									>#tc.getDisplayName()#</option>
								</cfloop>
							</select>
						</div>
					</div><!-- /.tab-pane -->
					
					<div class="tab-pane #REQUEST.pageData.tabs['tab_4']#" id="tab_4">
					
						<cfif NOT IsNULL(REQUEST.pageData.product) AND NOT IsNULL(REQUEST.pageData.product.getImages())>
							<div class="row">
								<cfloop array="#REQUEST.pageData.product.getImages()#" index="img">						
									<div class="col-xs-2">
										<div class="box <cfif img.getIsDefault() EQ true>box-danger</cfif>">
											<div class="box-body table-responsive no-padding">
												<table class="table table-hover">
													<tr <cfif img.getIsDefault() EQ true>class="danger"<cfelse>class="default"</cfif>>
														<th style="font-size:11px;line-height:20px;">#Left(img.getName(),"10")#</th>
														<th><a imageid="#img.getProductImageId()#" href="" class="delete-image pull-right" data-toggle="modal" data-target="##delete-image-modal"><span class="label label-danger">Delete</span></a></th>
													</tr>
													<tr>
														<td colspan="2">
															<img class="img-responsive" src="#img.getImageLink(type = "small")#" />
														</td>
													</tr>
													<tr>
														<td colspan="2">
															<table style="width:100%;">
																<tr>
																	<td>
																		<input class="form-control pull-left" type="radio" name="default_image_id" value="#img.getProductImageId()#" <cfif img.getIsDefault() EQ true>checked</cfif>/>
																	</td>
																	<td style="padding-left:5px;padding-top:1px;font-size:12px;">
																		Set as Default
																	</td>
																	<td style="text-align:right">
																		<input type="text" name="rank_#img.getProductImageId()#" value="#img.getRank()#" style="width:30px;text-align:center;" />
																	</td>
																</tr>
															</table>
														</td>
													</tr>
												</table>
											</div><!-- /.box-body -->
										</div><!-- /.box -->
									</div>
								</cfloop>
							</div>
						</cfif>
						<div class="form-group">
							<div id="uploader">
								<p>Your browser doesn't have Flash, Silverlight or HTML5 support.</p>
							</div>
						</div>
					</div><!-- /.tab-pane -->
					<div class="tab-pane #REQUEST.pageData.tabs['tab_5']#" id="tab_5">
						<!-- text input -->
						<div class="form-group">
							<label>Attribute Set</label>
							<select name="attribute_set_id" id="attribute_set_id" class="form-control">
								<option value="">Please Select...</option>
								<cfloop array="#REQUEST.pageData.attributeSets#" index="as">
									<option value="#as.getAttributeSetId()#"
									
									<cfif as.getAttributeSetId() EQ REQUEST.pageData.formData.attribute_set_id>
									selected
									</cfif>
									
									>#as.getDisplayName()#</option>
								</cfloop>
							</select>
						</div>
						
						<label>Attribute Option(s)</label>
						<div id="attributes" class="row" style="margin-top:10px;">
							<cfif NOT IsNull(REQUEST.pageData.product) AND NOT IsNull(REQUEST.pageData.product.getAttributeSet())>
								<cfloop array="#REQUEST.pageData.product.getAttributeSet().getAttributeSetAttributeRelas()#" index="attributeSetAttributeRela">
									<cfset attribute = attributeSetAttributeRela.getAttribute() />
									<cfset attributeSet = attributeSetAttributeRela.getAttributeSet() />
									<cfset productAttributeRela = EntityLoad("product_attribute_rela",{product=REQUEST.pageData.product,attribute=attribute},true) />
									<cfif NOT IsNull(productAttributeRela)>
									<div class="col-xs-3">
										<div class="box box-warning">
											<div class="box-body table-responsive no-padding">
												<table class="table table-hover">
													<tr class="warning" id="tr-#attributeSet.getAttributeSetId()#-#attribute.getAttributeId()#">
														<th colspan="3">#attribute.getDisplayName()#<cfif attributeSetAttributeRela.getRequired() EQ true> (required)</cfif></th>
														<th><a productattributerelaid="#productAttributeRela.getProductAttributeRelaId()#" attributeid="#attribute.getAttributeId()#" attributename="#LCase(attribute.getDisplayName())#" href="" class="add-new-attribute-option pull-right" data-toggle="modal" data-target="##add-new-attribute-option-modal"><span class="label label-primary">Add Option</span></a></th>
													</tr>
													
													<cfif NOT IsNull(productAttributeRela.getAttributeValues())>
														<cfloop array="#productAttributeRela.getAttributeValues()#" index="attributeValue">
															<tr>
																<td>#attributeValue.getDisplayName()#</td>
																<td>
																	<cfif attributeValue.getThumbnailImageName() NEQ "">
																		<div style="width:14px;height:14px;border:1px solid ##CCC;margin-top:4px;">
																			<img src="#attributeValue.getThumbnailImageLink()#" style="width:100%;height:100%;vertical-align:top;" />
																		</div>
																	<cfelse>
																		<cfif attribute.getDisplayName() EQ "color">
																			<div style="width:14px;height:14px;border:1px solid ##CCC;background-color:#attributeValue.getThumbnailLabel()#;margin-top:4px;"></div>
																		<cfelse>
																			#attributeValue.getThumbnailLabel()#
																		</cfif>
																	</cfif>
																</td>
																<td>
																	<div style="width:14px;height:14px;border:1px solid ##CCC;margin-top:4px;">
																		<img src="#attributeValue.getImageLink(type = "thumbnail")#" style="width:100%;height:100%;vertical-align:top;" />
																	</div>
																</td>
																<td>
																	<a attributevalueid="#attributeValue.getAttributeValueId()#" href="" class="delete-attribute-option pull-right" data-toggle="modal" data-target="##delete-attribute-option-modal"><span class="label label-danger">Delete</span></a>
																</td>
															</tr>
														</cfloop>
													</cfif>
												</table>
											</div><!-- /.box-body -->
										</div><!-- /.box -->
									</div>
									</cfif>
								</cfloop>
							</cfif>
					
						</div>
						<div id="new_attributes" class="row" style="margin-top:10px;">
						</div>
						
						<cfif NOT IsNull(REQUEST.pageData.product) AND REQUEST.pageData.product.isProductAttributeComplete() EQ true>
							<div class="form-group" id="attribute_option_values">
								<label>Attribute Value(s)</label>
								<a href="" data-toggle="modal" data-target="##add-attribute-option-value-modal" style="margin-left:10px;"><span class="label label-primary">Add Value</span></a>
								<button name="generate_attribute_option_values" type="submit" class="label label-primary" style="border:none;padding:.3em .6em .4em;">Generate Attribute Values</button>
								
								<cfif NOT IsNull(REQUEST.pageData.product.getSubProducts())>
									<div id="attributes" class="row" style="margin-top:10px;">
										<cfloop array="#REQUEST.pageData.product.getSubProducts()#" index="p">	
											<div class="col-xs-3">
												<div class="box box-info">
													<div class="box-body table-responsive no-padding">
														<table class="table table-hover">
															<tr class="success">
																<th><a href="#APPLICATION.absoluteUrlWeb#admin/product_detail.cfm?id=#p.getProductId()#">ID: #p.getProductId()#</a></th>
																<th></th>
																<th>
																	<a subproductid="#p.getProductId()#" href="" class="delete-attribute-option-value pull-right" data-toggle="modal" data-target="##delete-attribute-option-value-modal"><span class="label label-danger">Delete</span></a>
																</th>
															</tr>
															
															<cfloop array="#p.getProductAttributeRelas()#" index="productAttributeRela">
																<tr style="background-color:##f9f9f9;">
																	<td>#LCase(productAttributeRela.getAttribute().getDisplayName())#</td>
																	<td>#productAttributeRela.getAttributeValues()[1].getDisplayName()#</td>
																	<td>
																	<cfif productAttributeRela.getAttributeValues()[1].getDisplayName() EQ "color">
																		<cfif productAttributeRela.getAttributeValues()[1].getImageName() NEQ "">
																			<div class="pull-right" style="width:14px;height:14px;border:1px solid ##CCC;margin-top:3px;">
																				<img src="#productAttributeRela.getAttributeValues()[1].getImageLink()#" style="width:100%;height:100%;vertical-align:top;" />
																			</div>
																		<cfelse>
																			<div class="pull-right" style="width:14px;height:14px;border:1px solid ##CCC;background-color:#productAttributeRela.getAttributeValues()[1].getValue()#;margin-top:3px;"></div>
																		</cfif>
																	</cfif>
																	</td>
																</tr>
															</cfloop>
															<tr>
																<td>sku</td>
																<td colspan="2">#p.getSku()#</td>
															</tr>
															<tr>
																<td>stock</td>
																<td colspan="2">#p.getStock()#</td>
															</tr>
															<cfloop array="#p.getProductCustomerGroupRelas()#" index="productCustomerGroupRela">
															<tr>
																<td>price (#productCustomerGroupRela.getCustomerGroup().getDisplayName()#)</td>
																<td colspan="2">#p.getPrice(customerGroupName = productCustomerGroupRela.getCustomerGroup().getName())#</td>
															</tr>
															</cfloop>
														</table>
													</div><!-- /.box-body -->
												</div><!-- /.box -->
											</div>
										</cfloop>
									</div>
								</cfif>
							</div>
						</cfif>
					</div>
					<div class="tab-pane #REQUEST.pageData.tabs['tab_6']# #REQUEST.pageData.deleteButtonClass#" id="tab_6">
					
						<div class="form-group">
							<label>Related Products</label>
							<a data-toggle="modal" data-target="##add-product-modal" href="" style="margin-left:10px;"><span class="label label-primary">Add New Product</span></a>
							<div class="row" style="margin-top:10px;">
								<cfif NOT IsNULL(REQUEST.pageData.product) AND NOT IsNULL(REQUEST.pageData.product.getRelatedProducts())>
									<cfloop array="#REQUEST.pageData.product.getRelatedProducts()#" index="product">	
										<div class="col-xs-2">
											<div class="box">
												<div class="box-body table-responsive no-padding">
													<table class="table table-hover">
														<tr class="default">
															<th><a href="#APPLICATION.absoluteUrlWeb#admin/product_detail.cfm?id=#product.getProductId()#">ID: #product.getProductId()#</a></th>
															<th><a relatedproductid="#product.getProductId()#" href="" class="delete-related-product pull-right" data-toggle="modal" data-target="##delete-product-modal"><span class="label label-danger">Delete</span></a></th>
														</tr>
														<tr>
															<td colspan="2">
																<img class="img-responsive" src="#product.getDefaultImageLink(type='small')#" />
															</td>
														</tr>
													</table>
												</div><!-- /.box-body -->
											</div><!-- /.box -->
										</div>
									</cfloop>
								</cfif>
							</div>
						</div>
					</div>
					<div class="tab-pane #REQUEST.pageData.tabs['tab_7']#" id="tab_7">
						<div class="row">
							<div class="col-xs-12">
								<div class="box box-primary">
									<div class="box-header">
										<h3 class="box-title">Reviews</h3>
									</div><!-- /.box-header -->
									<div class="box-body table-responsive">
										<table class="table table-bordered table-striped data-table">
											<thead>
												<tr>
													<th>Subject</th>
													<th>Message</th>
													<th>Rating</th>
													<th>Create Datetime</th>
													<th>Action</th>
												</tr>
											</thead>
											<tbody>
												<cfif NOT IsNull(REQUEST.pageData.product) AND NOT IsNull(REQUEST.pageData.product.getReviews()) AND ArrayLen(REQUEST.pageData.product.getReviews()) GT 0>
													<cfloop array="#REQUEST.pageData.product.getReviews()#" index="review">
													<tr>
														<td>#review.getSubject()#</td>
														<td>#review.getMessage()#</td>
														<td>#review.getRating()#</td>
														<td>#review.getCreatedDatetime()#</td>
														<td><a href="#APPLICATION.absoluteUrlWeb#admin/review_detail.cfm?id=#review.getReviewId()#">View Detail</a></td>
													</tr>
													</cfloop>
												</cfif>
											</tbody>
											<tfoot>
												<tr>
													<th>Subject</th>
													<th>Message</th>
													<th>Rating</th>
													<th>Create Datetime</th>
													<th>Action</th>
												</tr>
											</tfoot>
										</table>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="tab-pane #REQUEST.pageData.tabs['tab_8']#" id="tab_8">
						<div class="form-group">
							<label>Length</label>
							<input name="length" type="text" class="form-control" placeholder="Enter ..." value="#REQUEST.pageData.formData.length#"/>
						</div>
						<div class="form-group">
							<label>Width</label>
							<input name="width" type="text" class="form-control" placeholder="Enter ..." value="#REQUEST.pageData.formData.width#"/>
						</div>
						<div class="form-group">
							<label>Height</label>
							<input name="height" type="text" class="form-control" placeholder="Enter ..." value="#REQUEST.pageData.formData.height#"/>
						</div>
						<div class="form-group">
							<label>Weight</label>
							<input name="weight" type="text" class="form-control" placeholder="Enter ..." value="#REQUEST.pageData.formData.weight#"/>
						</div>
						</cfoutput>
						<div class="form-group">
							<label>Shipping Methods</label>
							<div class="row" style="margin-top:10px;">
								<cfset s = REQUEST.pageData.shippingMethods />
								<cfoutput query="s" group="shipping_carrier_name">						
									<div class="col-xs-3">
										<div class="box box-warning">
											<div class="box-body table-responsive no-padding">
												<table class="table table-hover">
													<tr class="warning">
														<th colspan="2"><img src="#APPLICATION.absoluteUrlWeb#images/uploads/shipping/#s.image_name#" style="height:25px;vertical-align:top;" /></th>
														<th colspan="2" style="text-align:right;padding-right:10px;">#s.shipping_carrier_name#</th>
													</tr>
													<cfoutput>
													<cfif IsNumeric(s.product_shipping_method_rela_id)>
														<cfset productShippingMethodRela = EntityLoadByPK("product_shipping_method_rela",s.product_shipping_method_rela_id) />
														<cfset defaultPrice = productShippingMethodRela.getPrice() />
													<cfelse>
														<cfset defaultPrice = 0 />
													</cfif>
													<input type="hidden" name="default_price_#s.shipping_method_id#" value="#defaultPrice#" />
													<tr>
														<td>#s.shipping_method_name#</td>
														<td>#DollarFormat(defaultPrice)#</td>
														
														<cfif IsNumeric(s.product_shipping_method_rela_id)>
															<td>
																<input type="checkbox" class="form-control pull-right" name="shipping_method_id" value="#s.shipping_method_id#"

																<cfif IsNumeric(s.product_shipping_method_rela_id)>
																	checked
																</cfif>

																/>
															</td>
															<td>
																<a productshippingmethodrelaid="#s.product_shipping_method_rela_id#" class="edit-default-price pull-right" href="" data-toggle="modal" data-target="##edit-default-shipping-price-modal"><span class="label label-primary">Edit</span></a>
															</td>
														<cfelse>
															<td colspan="2" style="text-align:right;">
																<input type="checkbox" class="form-control pull-right" name="shipping_method_id" value="#s.shipping_method_id#"

																<cfif IsNumeric(s.product_shipping_method_rela_id)>
																	checked
																</cfif>

																/>
															</td>
														</cfif>
													</tr>
													</cfoutput>
												</table>
											</div><!-- /.box-body -->
										</div><!-- /.box -->
									</div>
								</cfoutput>
							</div>
						</div>
						<cfoutput>
					</div>
					<div class="tab-pane #REQUEST.pageData.tabs['tab_9']# #REQUEST.pageData.deleteButtonClass#" id="tab_9">
						<div class="form-group">
							<label>Videos</label>
							<a data-toggle="modal" data-target="##add-video-modal" href="" style="margin-left:10px;"><span class="label label-primary">Add New Video</span></a>
							<div class="row" style="margin-top:10px;">
								<cfif NOT IsNULL(REQUEST.pageData.product) AND NOT IsNULL(REQUEST.pageData.product.getProductVideos())>
									<cfloop array="#REQUEST.pageData.product.getProductVideos()#" index="video">	
										<div class="col-xs-3">
											<div class="box">
												<div class="box-body table-responsive no-padding">
													<table class="table table-hover">
														<tr class="default">
															<th><a href="#video.getUrl()#">Link</a></th>
															<th><a productvideoid="#video.getProductVideoId()#" href="" class="delete-video pull-right" data-toggle="modal" data-target="##delete-video-modal"><span class="label label-danger">Delete</span></a></th>
														</tr>
														<tr>
															<td colspan="2">
																<iframe width="100%" height="100%" src="#video.getUrl()#" frameborder="0" allowfullscreen></iframe>
															</td>
														</tr>
													</table>
												</div><!-- /.box-body -->
											</div><!-- /.box -->
										</div>
									</cfloop>
								</cfif>
							</div>
						</div>
					</div>
				</div><!-- /.tab-content -->
			</div><!-- nav-tabs-custom -->
			<div class="form-group">
				<button name="save_item" type="submit" class="btn btn-primary top-nav-button">Save Product</button>
				<button type="button" class="btn btn-danger pull-right #REQUEST.pageData.deleteButtonClass#" data-toggle="modal" data-target="##delete-current-entity-modal">Delete Product</button>
			</div>
		</div><!-- /.col -->
		
	</div>   <!-- /.row -->
</section><!-- /.content -->

<!-- EDIT GROUP PRICE MODAL -->
<div class="modal fade" id="edit-group-price-modal" tabindex="-1" role="dialog" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
				<h4 class="modal-title"> Edit Group Price</h4>
			</div>
		
			<div class="modal-body">
				<div class="form-group">
					<input id="edit_price" name="edit_price" type="text" class="form-control" placeholder="Price">
				</div>
				<div class="form-group">
					<input id="edit_special_price" name="edit_special_price" type="text" class="form-control" placeholder="Special Price"/>
				</div>
				 <div class="form-group">
					<div class="input-group">
						<div class="input-group-addon">
							<i class="fa fa-calendar"></i>
						</div>
						<input type="text" class="form-control pull-right" name="edit_special_price_from_date" id="edit_special_price_from_date" placeholder="Special Price From Date" />
					</div><!-- /.input group -->
				</div><!-- /.form group -->
				<div class="form-group">
					<div class="input-group">
						<div class="input-group-addon">
							<i class="fa fa-calendar"></i>
						</div>
						<input type="text" class="form-control pull-right" name="edit_special_price_to_date" id="edit_special_price_to_date" placeholder="Special Price To Date" />
					</div><!-- /.input group -->
				</div><!-- /.form group -->
			</div>
			<div class="modal-footer clearfix">
				<button type="button" class="btn btn-danger" data-dismiss="modal"><i class="fa fa-times"></i> Cancel</button>
				<button name="edit_group_price" type="submit" class="btn btn-primary pull-left"><i class="fa fa-check"></i> Update</button>
			</div>
		
		</div><!-- /.modal-content -->
	</div><!-- /.modal-dialog -->
</div><!-- /.modal -->
<!-- ADD SINGLE GROUP PRICE MODAL -->
<div class="modal fade" id="add-single-group-price-modal" tabindex="-1" role="dialog" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
				<h4 class="modal-title"> Add Group Price</h4>
			</div>
		
			<div class="modal-body">
				<div class="form-group">
					<input name="new_single_price" type="text" class="form-control" placeholder="Price">
				</div>
				<div class="form-group">
					<input name="new_single_special_price" type="text" class="form-control" placeholder="Special Price"/>
				</div>
				 <div class="form-group">
					<div class="input-group">
						<div class="input-group-addon">
							<i class="fa fa-calendar"></i>
						</div>
						<input type="text" class="form-control pull-right" name="new_single_special_price_from_date" id="new_single_special_price_from_date" placeholder="Special Price From Date" />
					</div><!-- /.input group -->
				</div><!-- /.form group -->
				<div class="form-group">
					<div class="input-group">
						<div class="input-group-addon">
							<i class="fa fa-calendar"></i>
						</div>
						<input type="text" class="form-control pull-right" name="new_single_special_price_to_date" id="new_single_special_price_to_date" placeholder="Special Price To Date" />
					</div><!-- /.input group -->
				</div><!-- /.form group -->
			</div>
			<div class="modal-footer clearfix">
				<button type="button" class="btn btn-danger" data-dismiss="modal"><i class="fa fa-times"></i> Cancel</button>
				<button name="add_single_group_price" type="submit" class="btn btn-primary pull-left"><i class="fa fa-check"></i> Add</button>
			</div>
		
		</div><!-- /.modal-content -->
	</div><!-- /.modal-dialog -->
</div><!-- /.modal -->
<!-- DELETE GROUP PRICE MODAL -->
<div class="modal fade" id="delete-group-price-modal" tabindex="-1" role="dialog" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
				<h4 class="modal-title"> Delete this group price?</h4>
			</div>
		
			<div class="modal-body clearfix">
				<button type="button" class="btn btn-danger pull-right" data-dismiss="modal"><i class="fa fa-times"></i> No</button>
				<button name="delete_group_price" type="submit" class="btn btn-primary"><i class="fa fa-check"></i> Yes</button>
			</div>
		
		</div><!-- /.modal-content -->
	</div><!-- /.modal-dialog -->
</div><!-- /.modal -->

<!-- ADD OPTION MODAL -->
<div class="modal fade" id="add-new-attribute-option-modal" tabindex="-1" role="dialog" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
				<h4 class="modal-title"> Add New Attribute Option</h4>
			</div>
		
			<div class="modal-body">
				<div class="form-group">
					<input id="new_attribute_option_name" name="new_attribute_option_name" type="text" class="form-control" placeholder="Name">
				</div>
				<div class="form-group">
					<input id="new_attribute_option_thumbnail_label" name="new_attribute_option_thumbnail_label" type="text" class="form-control" placeholder="Thumbnail Label">
				</div>	
				<div class="form-group">
					<div class="btn btn-success btn-file" style="width:150px;margin-right:20px;">
						<i class="fa fa-paperclip"></i> &nbsp;&nbsp;Add Image
						<input type="file" name="new_attribute_option_image" id="new_attribute_option_image"/>
					</div>
					<input type="radio" class="form-control" name="generate_option" value="1"/> Thumbnail Only &nbsp;&nbsp;&nbsp;
					<input type="radio" class="form-control" name="generate_option" value="2"/> Image Only &nbsp;&nbsp;&nbsp;
					<input type="radio" class="form-control" name="generate_option" value="3"/> Both
				</div>
			</div>
			<div class="modal-footer clearfix">
				<button type="button" class="btn btn-danger" data-dismiss="modal"><i class="fa fa-times"></i> Cancel</button>
				<button id="add_new_attribute_option" name="add_new_attribute_option" type="button" class="btn btn-primary pull-left" data-dismiss="modal"><i class="fa fa-check"></i> Add</button>
			</div>
		</div><!-- /.modal-content -->
	</div><!-- /.modal-dialog -->
</div><!-- /.modal -->
<!-- DELETE OPTION MODAL -->
<div class="modal fade" id="delete-attribute-option-modal" tabindex="-1" role="dialog" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
				<h4 class="modal-title"> Delete this option?</h4>
			</div>
		
			<div class="modal-body clearfix">
				<button type="button" class="btn btn-danger pull-right" data-dismiss="modal"><i class="fa fa-times"></i> No</button>
				<button name="delete_attribute_option_comfirm" id="delete_attribute_option_comfirm" type="button" class="btn btn-primary" data-dismiss="modal"><i class="fa fa-check"></i> Yes</button>
			</div>
		
		</div><!-- /.modal-content -->
	</div><!-- /.modal-dialog -->
</div><!-- /.modal -->
<!-- ADD PRODUCT MODAL -->
<div class="modal fade" id="add-product-modal" tabindex="-1" role="dialog" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
				<h4 class="modal-title"> Add Related Product</h4>
			</div>
		
			<div class="modal-body">
				<div class="form-group">
					<label>Product Group</label>
					<select name="related_product_group_id" multiple class="form-control">
						<cfloop array="#REQUEST.pageData.relatedProductGroups#" index="group">
							<option value="#group.getRelatedProductGroupId()#">#group.getDisplayName()#</option>
						</cfloop>
					</select>
				</div>
				<div class="form-group">
					<label>Product ID</label>
					<input id="new_related_product_id" name="new_related_product_id" type="text" class="form-control" placeholder="Product ID">
				</div>
			</div>
			<div class="modal-footer clearfix">
				<button type="button" class="btn btn-danger" data-dismiss="modal"><i class="fa fa-times"></i> Cancel</button>
				<button name="add_related_product" type="submit" class="btn btn-primary pull-left"><i class="fa fa-check"></i> Add</button>
			</div>
		
		</div><!-- /.modal-content -->
	</div><!-- /.modal-dialog -->
</div><!-- /.modal -->
<!-- DELETE PRODUCT MODAL -->
<div class="modal fade" id="delete-product-modal" tabindex="-1" role="dialog" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
				<h4 class="modal-title"> Delete this related product?</h4>
			</div>
			<div class="modal-body clearfix">
				<button type="button" class="btn btn-danger pull-right" data-dismiss="modal"><i class="fa fa-times"></i> No</button>
				<button name="delete_related_product" type="submit" class="btn btn-primary"><i class="fa fa-check"></i> Yes</button>
			</div>
		</div><!-- /.modal-content -->
	</div><!-- /.modal-dialog -->
</div><!-- /.modal -->

<!-- DELETE ENTITY MODAL -->
<div class="modal fade" id="delete-current-entity-modal" tabindex="-1" role="dialog" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
				<h4 class="modal-title"> Delete this product?</h4>
			</div>
			<div class="modal-body clearfix">
				<button type="button" class="btn btn-danger pull-right" data-dismiss="modal"><i class="fa fa-times"></i> No</button>
				<button name="delete_item" type="submit" class="btn btn-primary"><i class="fa fa-check"></i> Yes</button>
			</div>
		</div><!-- /.modal-content -->
	</div><!-- /.modal-dialog -->
</div><!-- /.modal -->

<!-- EDIT DEFAULT PRICE MODAL -->
<div class="modal fade" id="edit-default-shipping-price-modal" tabindex="-1" role="dialog" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
				<h4 class="modal-title"> Edit Default Price</h4>
			</div>
		
			<div class="modal-body">
				<div class="form-group">
					<input id="new_default_price" name="new_default_price" type="text" class="form-control" placeholder="Default Price">
				</div>
			</div>
			<div class="modal-footer clearfix">
				<button type="button" class="btn btn-danger" data-dismiss="modal"><i class="fa fa-times"></i> Cancel</button>
				<button name="edit_default_price" type="submit" class="btn btn-primary pull-left"><i class="fa fa-check"></i> Update</button>
			</div>
		
		</div><!-- /.modal-content -->
	</div><!-- /.modal-dialog -->
</div><!-- /.modal -->

<cfif NOT IsNull(REQUEST.pageData.product) AND REQUEST.pageData.product.isProductAttributeComplete() EQ true>
<!-- ADD/UPDATE ATTRIBUTE VALUE MODAL -->
<div class="modal fade" id="add-attribute-option-value-modal" tabindex="-1" role="dialog" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
				<h4 class="modal-title"> Add New Attribute Value</h4>
			</div>
			<div class="modal-body">
				<cfloop array="#REQUEST.pageData.product.getProductAttributeRelas()#" index="productAttributeRela">
					<cfif productAttributeRela.getRequired() EQ true>
						<div class="form-group">
							<select class="form-control" name="new_attribute_value_#productAttributeRela.getAttribute().getAttributeId()#">
								<option value="">#productAttributeRela.getAttribute().getDisplayName()#</option>
								<cfloop array="#productAttributeRela.getAttributeValues()#" index="attributeValue">
									<option value="#attributeValue.getAttributeValueId()#">
										#attributeValue.getDisplayName()#
									</option>
								</cfloop>
							</select>
						</div>	
					</cfif>
				</cfloop>
				<div class="form-group">
					<input id="new_price" name="new_price" type="text" class="form-control" placeholder="Price">
				</div>	
				<div class="form-group">
					<input id="new_stock" name="new_stock" type="text" class="form-control" placeholder="Stock">
				</div>	
			</div>
			<div class="modal-footer clearfix">
				<button type="button" class="btn btn-danger" data-dismiss="modal"><i class="fa fa-times"></i> Cancel</button>
				<button name="add_new_attribute_option_value" type="submit" class="btn btn-primary pull-left"><i class="fa fa-check"></i> Add</button>
			</div>
		</div><!-- /.modal-content -->
	</div><!-- /.modal-dialog -->
</div><!-- /.modal -->
<!-- DELETE ATTRIBUTE VALUE MODAL -->
<div class="modal fade" id="delete-attribute-option-value-modal" tabindex="-1" role="dialog" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
				<h4 class="modal-title"> Delete this attribute value?</h4>
			</div>
			<div class="modal-body clearfix">
				<button type="button" class="btn btn-danger pull-right" data-dismiss="modal"><i class="fa fa-times"></i> No</button>
				<button name="delete_attribute_option_value" type="submit" class="btn btn-primary"><i class="fa fa-check"></i> Yes</button>
			</div>
		</div><!-- /.modal-content -->
	</div><!-- /.modal-dialog -->
</div><!-- /.modal -->
</cfif>
<!-- DELETE IMAGE MODAL -->
<div class="modal fade" id="delete-image-modal" tabindex="-1" role="dialog" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
				<h4 class="modal-title"> Delete this image?</h4>
			</div>
			<div class="modal-body clearfix">
				<button type="button" class="btn btn-danger pull-right" data-dismiss="modal"><i class="fa fa-times"></i> No</button>
				<button name="delete_image" type="submit" class="btn btn-primary"><i class="fa fa-check"></i> Yes</button>
			</div>
		</div><!-- /.modal-content -->
	</div><!-- /.modal-dialog -->
</div><!-- /.modal -->
<!-- ADD VIDEO MODAL -->
<div class="modal fade" id="add-video-modal" tabindex="-1" role="dialog" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
				<h4 class="modal-title"> Add New Video</h4>
			</div>
		
			<div class="modal-body">
				<div class="form-group">
					<label>URL</label>
					<input id="new_video_url" name="new_video_url" type="text" class="form-control" placeholder="Video URL">
				</div>
			</div>
			<div class="modal-footer clearfix">
				<button type="button" class="btn btn-danger" data-dismiss="modal"><i class="fa fa-times"></i> Cancel</button>
				<button name="add_new_video" type="submit" class="btn btn-primary pull-left"><i class="fa fa-check"></i> Add</button>
			</div>
		</div><!-- /.modal-content -->
	</div><!-- /.modal-dialog -->
</div><!-- /.modal -->
<!-- DELETE VIDEO MODAL -->
<div class="modal fade" id="delete-video-modal" tabindex="-1" role="dialog" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
				<h4 class="modal-title"> Delete this video?</h4>
			</div>
			<div class="modal-body clearfix">
				<button type="button" class="btn btn-danger pull-right" data-dismiss="modal"><i class="fa fa-times"></i> No</button>
				<button name="delete_video" type="submit" class="btn btn-primary"><i class="fa fa-check"></i> Yes</button>
			</div>
		</div><!-- /.modal-content -->
	</div><!-- /.modal-dialog -->
</div><!-- /.modal -->
</form>
</cfoutput>