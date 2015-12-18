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
			console.log($(this).attr('tabid'));
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
		$('##special-price-from-date').datepicker();
		$('##special-price-to-date').datepicker();
		$('##new_single_special_price_from_date').datepicker();
		$('##new_single_special_price_to_date').datepicker();
		$('##edit_special_price_from_date').datepicker();
		$('##edit_special_price_to_date').datepicker();
		$('.special-price-from-date').datepicker();
		$('.special-price-to-date').datepicker();
		$('##new-attribute-option-label').colorpicker();
		
		
		
		$( ".delete-attribute-option-value" ).click(function() {
			$("##sub_product_id").val($(this).attr('subproductid'));
		});
		
		$( ".delete-related-product" ).click(function() {
			$("##delete_related_product_id").val($(this).attr('relatedproductid'));
		});
		
		var new_option_index = 1;
		
		$('.attribute-set').on("click","a.add-new-attribute-option", function() {
			$("##new-attribute-option-set-id-hidden").val($(this).attr('attributesetid'));
			$("##new-attribute-option-id-hidden").val($(this).attr('attributeid'));
			$("##new-attribute-option-name-hidden").val($(this).attr('attributename'));
			$("##new-attribute-option-req-hidden").val($(this).attr('req'));
			
			if($(this).attr('attributename') == 'color')
			{
				$("##new-attribute-option-label").show();
			}
			else
			{
				$("##new-attribute-option-label").hide();
			}
			
			$(".image-uploader").hide();
			$("##new-attribute-option-" + new_option_index + "-image-div").show();
		});
		
		$( "##add-new-attribute-option-confirm" ).click(function() {
			var thumbnail_content = '';
			var image_content = '';
			var name_content = $("##new-attribute-option-name").val();
			var new_option_name =  'new_attribute_option_' + new_option_index;
			var new_option_tr_id =  'tr-av-new-option-' + new_option_index;
			var image_upload_id =  'new-attribute-option-' + new_option_index + '-image';
			var generate_option_selected = $('input[name="generate_option"]:checked').val();
			
			if($("##"+image_upload_id).val() != '')
			{
				loadThumbnail($("##"+image_upload_id)[0].files[0], function(image_src) { 
					console.log($('input[name="generate_option"]:checked').val());
					if(generate_option_selected == 1 || generate_option_selected == 3)
						thumbnail_content = '<div style="width:14px;height:14px;border:1px solid ##CCC;margin-top:4px;"><img src="'+image_src+'" style="width:100%;height:100%;vertical-align:top;" /></div>';
					if(generate_option_selected == 2 || generate_option_selected == 3)
						image_content = '<div style="width:14px;height:14px;border:1px solid ##CCC;margin-top:4px;"><img src="'+image_src+'" style="width:100%;height:100%;vertical-align:top;" /></div>';
					$("##tr-" + $("##new-attribute-option-set-id-hidden").val() + '-' + $("##new-attribute-option-id-hidden").val()).after('<tr id="'+new_option_tr_id+'"><td>'+name_content+'</td><td>'+thumbnail_content+'</td><td>'+image_content+'</td><td><a attributevalueid="'+new_option_index+'" href="" class="delete-attribute-option pull-right" data-toggle="modal" data-target="##delete-attribute-option-modal"><span class="label label-danger">Delete</span></a></td></tr>'); 
				});
			}
			else
			{
				if($("##new-attribute-option-name-hidden").val() == 'color')
					thumbnail_content = '<div style="width:14px;height:14px;border:1px solid ##CCC;background-color:'+$("##new-attribute-option-label").val()+';margin-top:4px;"></div>';
				else
					thumbnail_content = name_content;
				$("##tr-" + $("##new-attribute-option-set-id-hidden").val() + '-' + $("##new-attribute-option-id-hidden").val()).after('<tr id="'+new_option_tr_id+'"><td>'+name_content+'</td><td>'+thumbnail_content+'</td><td>'+image_content+'</td><td><a attributevalueid="'+new_option_index+'" href="" class="delete-attribute-option pull-right" data-toggle="modal" data-target="##delete-attribute-option-modal"><span class="label label-danger">Delete</span></a></td></tr>'); 
			}
			
			$("##new-attribute-option-id-list").val($("##new-attribute-option-id-list").val() + new_option_index + ',');			
			$('<input>').attr({type: 'hidden',name: new_option_name+'_name',value: $("##new-attribute-option-name").val()}).appendTo($("##product-detail"));
			$('<input>').attr({type: 'hidden',name: new_option_name+'_req',value: $("##new-attribute-option-req-hidden").val()}).appendTo($("##product-detail"));
			$('<input>').attr({type: 'hidden',name: new_option_name+'_thumbnail_label',value: $("##new-attribute-option-label").val()}).appendTo($("##product-detail"));
			$('<input>').attr({type: 'hidden',name: new_option_name+'_generate_option',value: $('input[name="generate_option"]:checked').val()}).appendTo($("##product-detail"));
			$('<input>').attr({type: 'hidden',name: new_option_name+'_aset'+$("##attribute-set-id").val()+'_attribute_id',value: $("##new-attribute-option-id-hidden").val()}).appendTo($("##product-detail"));
			
			$("##new-attribute-option-name").val('');
			$("##new-attribute-option-label").val('');
			$('input[name="generate_option"]').prop('checked', false);
			$(".iradio_minimal").removeClass("checked");
			$(".iradio_minimal").attr("aria-checked",false);
			
			new_option_index++;
		});
		
		$('.attribute-set').on("click","a.delete-attribute-option", function() {
			$("##deleted-attribute-option-id-hidden").val($(this).attr('attributevalueid'));
		});
		
		$( "##delete-attribute-option-confirm" ).click(function() {			
			$("##tr-av-" + $("##deleted-attribute-option-id-hidden").val()).remove();
			$("##tr-av-new-option-" + $("##deleted-attribute-option-id-hidden").val()).remove();
			
			var str = $("##new-attribute-option-id-list").val();
			var n = str.indexOf($("##deleted-attribute-option-id-hidden").val() + ',');
			
			if(n != -1)
			{
				$("##new-attribute-option-id-list").val($("##new-attribute-option-id-list").val().replace($("##deleted-attribute-option-id-hidden").val() + ',', ''));
			}
			else
			{	
				$("##remove-attribute-option-id-list").val($("##remove-attribute-option-id-list").val() + $("##deleted-attribute-option-id-hidden").val() + ',');
			}	
		});
		
		$( "##attribute-set-id" ).change(function() {
			$(".attribute-set").hide();
			$("##attribute-set-" + $(this).val()).show();
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
		
		
		function loadThumbnail(file, callback) {
			var reader = new FileReader();
			reader.readAsDataURL(file);
			reader.onloadend = function () {
				callback(reader.result);
			}
		}
		
		var groupArray = new Array();
		<cfloop array="#REQUEST.pageData.customerGroups#" index="group">	
			<cfif group.getIsDefault() EQ false>
				var group = new Object();
				group.eid = '#group.getCustomerGroupId()#';
				group.type = '#group.getDiscountType().getCalculationType().getName()#';
				group.amount = '#group.getDiscountType().getAmount()#';
				groupArray.push(group);
			</cfif>
		</cfloop>
		
		$( "##price" ).keyup(function() {
			if(!isNaN($(this).val()))
			{
				for(var i=0;i<groupArray.length;i++)
				{
					if(groupArray[i].type == 'fixed')
						$("##price-" + groupArray[i].eid).val(Math.max($(this).val() - groupArray[i].amount,0).toFixed(2));
					else if (groupArray[i].type == 'percentage')
						$("##price-" + groupArray[i].eid).val(($(this).val() * (1-groupArray[i].amount/100)).toFixed(2));
				}		
			}
		});
		
		$( "##special-price" ).keyup(function() {
			if(!isNaN($(this).val()))
			{
				for(var i=0;i<groupArray.length;i++)
				{
					if(groupArray[i].type == 'fixed')
						$("##special-price-" + groupArray[i].eid).val(Math.max($(this).val() - groupArray[i].amount,0).toFixed(2));
					else if (groupArray[i].type == 'percentage')
						$("##special-price-" + groupArray[i].eid).val(($(this).val() * (1-groupArray[i].amount/100)).toFixed(2));
				}		
			}
		});
		
		$( "##special-price-from-date" ).keyup(function() {
			console.log(Date.parse($(this).val()));
			if(Date.parse($(this).val()))
			{
				for(var i=0;i<groupArray.length;i++)
				{
					$("##special-price-from-date-" + groupArray[i].eid).val($(this).val());
				}		
			}
		});
		
		$( "##special-price-to-date" ).keyup(function() {
			if(Date.parse($(this).val()))
			{
				for(var i=0;i<groupArray.length;i++)
				{
					$("##special-price-to-date-" + groupArray[i].eid).val($(this).val());
				}		
			}
		});
		
		$("##search-product").click(function() {
			$.ajax({
						type: "get",
						url: "#APPLICATION.absoluteUrlWeb#core/services/productService.cfc",
						dataType: 'json',
						data: {
							method: 'searchProducts',
							productGroupId: $("##search-product-group-id").val(),
							categoryId: $("##search-category-id").val(),
							keywords: $("##search-keywords").val()
						},		
						success: function(response) {
							var productArray = response.DATA;
							var productName = '';
							var productId = '';
							
							$("##products-searched").empty();
							for (var i = 0, len = productArray.length; i < len; i++) {
								productName = productArray[i][0];
								productId = productArray[i][1];
								
								$("##products-searched").append('<option value="' + productId + '">' + productName + '</option>');
							}
						}
			});
		});
		
		$('##save-item').click(function() {  
			selectBox = document.getElementById("products-selected");

			for (var i = 0; i < selectBox.options.length; i++) 
			{ 
				 selectBox.options[i].selected = true; 
			} 
		}); 
		
		$('##add-all').click(function() {  
			$("##products-searched").each(function() {
				$('##products-searched option').remove().appendTo('##products-selected'); 
			});
		});  
		
		$('##remove-all').click(function() {  
			$("##products-selected").each(function() {
				$('##products-selected option').remove().appendTo('##products-searched'); 
			});  
		}); 

		$('##add').click(function() {  
			return !$('##products-searched option:selected').remove().appendTo('##products-selected').removeAttr("selected"); 
		});  
		
		$('##remove').click(function() {  
			return !$('##products-selected option:selected').remove().appendTo('##products-searched').removeAttr("selected"); 
		});	

		$("##category-id").attr("size",$("##category-id option").length);
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
<form id="product-detail" method="post" enctype="multipart/form-data">
<input type="hidden" name="id" id="id" value="#REQUEST.pageData.formData.id#" />
<input type="hidden" name="tab_id" id="tab_id" value="#REQUEST.pageData.tabs.activeTabId#" />
<input type="hidden" name="sub_product_id" id="sub_product_id" value="" />
<input type="hidden" name="new_attribute_imagename" id="new_attribute_imagename" value="" />
<input type="hidden" name="product_shipping_method_rela_id" id="product_shipping_method_rela_id" value="" />
<input type="hidden" name="deleted_image_id" id="deleted_image_id" value="" />
<input type="hidden" name="edit_product_customer_group_rela_id" id="edit_product_customer_group_rela_id" value="" />
<input type="hidden" name="deleted_product_customer_group_rela_id" id="deleted_product_customer_group_rela_id" value="" />
<input type="hidden" name="deleted_product_video_id" id="deleted_product_video_id" value="" />
<input type="hidden" name="add_customer_group_id" id="add_customer_group_id" value="" />
<input type="hidden" name="new_attribute_option_id_hidden" id="new-attribute-option-id-hidden" value="" />
<input type="hidden" name="new_attribute_option_set_id_hidden" id="new-attribute-option-set-id-hidden" value="" />
<input type="hidden" name="new_attribute_option_name_hidden" id="new-attribute-option-name-hidden" value="" />
<input type="hidden" name="new_attribute_option_req_hidden" id="new-attribute-option-req-hidden" value="" />
<input type="hidden" name="deleted_attribute_option_id_hidden" id="deleted-attribute-option-id-hidden" value="" />
<input type="hidden" name="new_attribute_option_id_list" id="new-attribute-option-id-list" value="" />
<input type="hidden" name="remove_attribute_option_id_list" id="remove-attribute-option-id-list" value="" />
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
					<li class="tab-title top-level-tab #REQUEST.pageData.tabs['tab_3']#" tabid="tab_3"><a href="##tab_3" data-toggle="tab">Product Type</a></li>
					<li class="tab-title top-level-tab #REQUEST.pageData.tabs['tab_4']#" tabid="tab_4"><a href="##tab_4" data-toggle="tab">Images</a></li>
					<li class="tab-title top-level-tab #REQUEST.pageData.tabs['tab_5']#" tabid="tab_5"><a href="##tab_5" data-toggle="tab">Attributes</a></li>
					<li class="tab-title top-level-tab #REQUEST.pageData.tabs['tab_6']#" tabid="tab_6"><a href="##tab_6" data-toggle="tab">Related Products</a></li>
					<li class="tab-title top-level-tab #REQUEST.pageData.tabs['tab_7']#" tabid="tab_7"><a href="##tab_7" data-toggle="tab">Reviews</a></li>
					<li class="tab-title top-level-tab #REQUEST.pageData.tabs['tab_8']#" tabid="tab_8"><a href="##tab_8" data-toggle="tab">Shipping</a></li>
					<li class="tab-title top-level-tab #REQUEST.pageData.tabs['tab_9']#" tabid="tab_9"><a href="##tab_9" data-toggle="tab">Video</a></li>
				</ul>
				<div class="tab-content">
					<div class="tab-pane #REQUEST.pageData.tabs['tab_1']#" id="tab_1">
						 <div class="form-group">
							<label>Product Name</label>
							<div class="input-group">
								<span class="input-group-addon"><i class="fa fa-asterisk"></i></span>
								<input name="display_name" type="text" class="form-control" placeholder="Enter ..." value="#REQUEST.pageData.formData.display_name#"/>
							</div>
						</div>
						<div class="form-group">
							<label>Category</label>
							<select class="form-control" multiple name="category_id" id="category-id">
								<cfloop array="#REQUEST.pageData.categoryTree#" index="cat">
									<option value="#cat.getCategoryId()#"
									<cfif IsNull(REQUEST.pageData.formData.category_id) AND NOT IsNull(REQUEST.pageData.product) AND NOT IsNull(REQUEST.pageData.product.getCategoriesMV()) AND ArrayContains(REQUEST.pageData.product.getCategoriesMV(),cat)
										OR
										NOT IsNull(REQUEST.pageData.formData.category_id) AND ListFind(REQUEST.pageData.formData.category_id, cat.getCategoryId())>
									selected
									</cfif>
									>#RepeatString("&nbsp;",1)##cat.getDisplayName()#</option>
									<cfloop array="#cat.getSubCategories()#" index="subCat">
										<option value="#subCat.getCategoryId()#"
										<cfif IsNull(REQUEST.pageData.formData.category_id) AND NOT IsNull(REQUEST.pageData.product) AND NOT IsNull(REQUEST.pageData.product.getCategoriesMV()) AND ArrayContains(REQUEST.pageData.product.getCategoriesMV(),subCat)
											OR
											NOT IsNull(REQUEST.pageData.formData.category_id) AND ListFind(REQUEST.pageData.formData.category_id, subCat.getCategoryId())>
										selected
										</cfif>
										>#RepeatString("&nbsp;",11)##subCat.getDisplayName()#</option>
										<cfloop array="#subCat.getSubCategories()#" index="thirdCat">
											<option value="#thirdCat.getCategoryId()#"
											<cfif IsNull(REQUEST.pageData.formData.category_id) AND NOT IsNull(REQUEST.pageData.product) AND NOT IsNull(REQUEST.pageData.product.getCategoriesMV()) AND ArrayContains(REQUEST.pageData.product.getCategoriesMV(),thirdCat)
												OR
												NOT IsNull(REQUEST.pageData.formData.category_id) AND ListFind(REQUEST.pageData.formData.category_id, thirdCat.getCategoryId())>
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
							<cfloop array="#REQUEST.pageData.specialCategories#" index="spCategory">
							<input name="category_id" value="#spCategory.getCategoryId()#" type="checkbox" class="form-control"
							<cfif IsNull(REQUEST.pageData.formData.category_id) AND NOT IsNull(REQUEST.pageData.product) AND NOT IsNull(REQUEST.pageData.product.getCategoriesMV()) AND ArrayContains(REQUEST.pageData.product.getCategoriesMV(),spCategory)
								OR
								NOT IsNull(REQUEST.pageData.formData.category_id) AND ListFind(REQUEST.pageData.formData.category_id, spCategory.getCategoryId())>
							checked
							</cfif>
							/>
							&nbsp;&nbsp;#spCategory.getDisplayName()##RepeatString("&nbsp;",11)#
							</cfloop>
						</div>
						<div class="form-group">
							<label>SKU</label>
							<div class="input-group">
								<span class="input-group-addon"><i class="fa fa-asterisk"></i></span>
								<input name="sku" type="text" class="form-control" placeholder="Enter ..." value="#REQUEST.pageData.formData.sku#"/>
							</div>
						</div>
						<div class="form-group">
							<label>Stock</label>
							<div class="input-group">
								<span class="input-group-addon"><i class="fa fa-asterisk"></i></span>
								<input name="stock" type="text" class="form-control" placeholder="Enter ..." value="#REQUEST.pageData.formData.stock#"/>
							</div>
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
						<div class="form-group">
							<label>Tax Category</label>
							<select name="tax_category_id" class="form-control">
								<cfloop array="#REQUEST.pageData.taxCategories#" index="tc">
									<option value="#tc.getTaxCategoryId()#"
									
									<cfif NOT IsNull(REQUEST.pageData.product) AND NOT IsNull(REQUEST.pageData.product.getTaxCategoryMV()) AND tc.getTaxCategoryId() EQ REQUEST.pageData.formData.tax_category_id>
									selected
									</cfif>
									
									>#tc.getDisplayName()#</option>
								</cfloop>
							</select>
						</div>
						<div class="form-group">
							<label>Product Type</label>
							<table class="table table-hover">
								<tr>
									<td>
										<input type="radio" name="product_type" value="single" checked>
									</td>
									<td>Single</td>
								</tr>
								<tr>
									<td></td>
									<td>
										<div class="form-group">
											<label>Price</label>
											<div class="input-group">
												<input name="price" type="text" class="form-control" placeholder="Enter ..." value="#REQUEST.pageData.formData.price#"/>
											</div>
										</div>
										<div class="form-group">
											<label>SKU</label>
											<div class="input-group">
												<input name="sku" type="text" class="form-control" placeholder="Enter ..." value="#REQUEST.pageData.formData.sku#"/>
											</div>
										</div>
										<div class="form-group">
											<label>Stock</label>
											<div class="input-group">
												<input name="stock" type="text" class="form-control" placeholder="Enter ..." value="#REQUEST.pageData.formData.stock#"/>
											</div>
										</div>
										
										<div class="form-group">
											<label>Special Price</label>
											<div class="input-group">
												<input name="price" type="text" class="form-control" placeholder="Enter ..." value="#REQUEST.pageData.formData.price#"/>
											</div>
										</div>
										<div class="form-group">
											<label>From Date</label>
											<div class="input-group">
												<input type="text" class="form-control pull-right special-price-from-date" name="" id="" />
											</div>
										</div>
										<div class="form-group">
											<label>To Date</label>
											<div class="input-group">
												<input type="text" class="form-control pull-right special-price-from-date" name="" id="" />
											</div>
										</div>
									</td>
								</tr>
								<tr>
									<td>
										<input type="radio" name="product_type" value="configurable">
									</td>
									<td>Configurable</td>
								</tr>
								<tr>
									<td></td>
									<td>
										<div class="row" style="margin-top:10px;">
											<cfloop array="#REQUEST.pageData.shippingCarriers#" index="sc">
												<div class="col-xs-2">
													<div class="box box-warning">
														<div class="box-body table-responsive no-padding">
															<table class="table table-hover">
																<tr class="warning">
																	<th><img src="#APPLICATION.absoluteUrlWeb#images/uploads/shipping/#sc.getImageName()#" style="height:25px;vertical-align:top;" /></th>
																	<th colspan="2" style="padding-right:10px;" nowrap>#sc.getDisplayName()#</th>
																	<th style="text-align:right;">
																		<input type="checkbox" class="form-control pull-right" name="shipping_carrier_id" value="#sc.getShippingCarrierId()#"
																		
																		<cfif NOT IsNull(productShippingCarrierRela) 
																			OR 
																			NOT IsNull(REQUEST.pageData.formData.shipping_carrier_id) AND ListFind(REQUEST.pageData.formData.shipping_carrier_id, sc.getShippingCarrierId())>
																			checked
																		</cfif>
																		
																		/>
																	</th>
																</tr>	
															</table>
														</div><!-- /.box-body -->
													</div><!-- /.box -->
												</div>
											</cfloop>
										</div>
									</td>
								</tr>
							</table>
						</div>
						<!---
						<cfif IsNumeric(REQUEST.pageData.formData.id)>
							<cfloop array="#REQUEST.pageData.productArray#" index="product">
								<div class="box box-warning">
									<cfif product.getProductType().getName() EQ "configured_product">
										<div class="box-header">
											<h3 class="box-title">
											<cfloop array="#product.getProductAttributeRelas()#" index="productAttributeRela">
												<div class="pull-left" style="margin-right:10px;">#LCase(productAttributeRela.getAttribute().getDisplayName())#: #productAttributeRela.getAttributeValues()[1].getDisplayName()#</div>
												<cfif productAttributeRela.getAttribute().getDisplayName() EQ "color">
													<cfif productAttributeRela.getAttributeValues()[1].getImageName() NEQ "">
														<div class="pull-left" style="width:14px;height:14px;border:1px solid ##CCC;margin-top:3px;">
															<img src="#productAttributeRela.getAttributeValues()[1].getImageLink()#" style="width:100%;height:100%;vertical-align:middle;" />
														</div>
													<cfelse>
														<div class="pull-left" style="width:16px;height:16px;border:1px solid ##CCC;background-color:#productAttributeRela.getAttributeValues()[1].getValue()#;margin-top:3px;"></div>
													</cfif>
												</cfif>
											</cfloop>
											</h3>
										</div><!-- /.box-header -->
									</cfif>
									<div class="box-body table-responsive">
										<table class="table table-bordered table-hover">
											<tr class="default">
												<th>Group</th>
												<th>Price</th>
												<th>Special Price</th>
												<th>From Date</th>
												<th>To Date</th>
											</tr>
											<cfloop array="#REQUEST.pageData.customerGroups#" index="customerGroup">
												<cfset productCustomerGroupRela = EntityLoad("product_customer_group_rela", {product = product, customerGroup = customerGroup},true) />
												<tr>
													<td>#customerGroup.getDisplayName()#</td>
													<td><input type="text" name="price_#product.getProductId()#_#customerGroup.getCustomerGroupId()#" id="price-#product.getProductId()#-#customerGroup.getCustomerGroupId()#" class="form-control" placeholder="Enter ..." value="#productCustomerGroupRela.getPrice()#" /></td>
													<td><input name="special_price_#product.getProductId()#_#customerGroup.getCustomerGroupId()#" id="special-price-#product.getProductId()#-#customerGroup.getCustomerGroupId()#" type="text" class="form-control" placeholder="Enter ..." value="#productCustomerGroupRela.getSpecialPrice()#" /></td>
													<td><input type="text" class="form-control pull-right special-price-from-date" name="special_price_from_date_#product.getProductId()#_#customerGroup.getCustomerGroupId()#" id="special-price-from-date-#product.getProductId()#-#customerGroup.getCustomerGroupId()#" value="#DateFormat(productCustomerGroupRela.getSpecialPriceFromDate(),"mmm dd, yyyy")#" /></td>
													<td><input type="text" class="form-control pull-right special-price-to-date" name="special_price_to_date_#product.getProductId()#_#customerGroup.getCustomerGroupId()#" id="special-price-from-date-#product.getProductId()#-#customerGroup.getCustomerGroupId()#" value="#DateFormat(productCustomerGroupRela.getSpecialPriceToDate(),"mmm dd, yyyy")#" /></td>
												</tr>
											</cfloop>
										</table>
									</div><!-- /.box-body -->
								</div><!-- /.box -->
							</cfloop>
						<cfelse>
							<div class="box box-warning">
								<div class="box-body table-responsive">
									<table class="table table-bordered table-hover">
										<tr class="default">
											<th>Group</th>
											<th>Price</th>
											<th>Special Price</th>
											<th>From Date</th>
											<th>To Date</th>
										</tr>
										<cfloop array="#REQUEST.pageData.customerGroups#" index="customerGroup">
											<tr>
												<td>#customerGroup.getDisplayName()#</td>
												<td><input type="text" name="price_#customerGroup.getCustomerGroupId()#" id="price-#customerGroup.getCustomerGroupId()#" class="form-control" placeholder="Enter ..." value="" /></td>
												<td><input name="special_price_#customerGroup.getCustomerGroupId()#" id="special-price-#customerGroup.getCustomerGroupId()#" type="text" class="form-control" placeholder="Enter ..." value="" /></td>
												<td><input type="text" class="form-control pull-right special-price-from-date" name="special_price_from_date_#customerGroup.getCustomerGroupId()#" id="special-price-from-date-#customerGroup.getCustomerGroupId()#" value="" /></td>
												<td><input type="text" class="form-control pull-right special-price-to-date" name="special_price_to_date_#customerGroup.getCustomerGroupId()#" id="special-price-from-date-#customerGroup.getCustomerGroupId()#" value="" /></td>
											</tr>
										</cfloop>
									</table>
								</div><!-- /.box-body -->
							</div><!-- /.box -->
						</cfif>
						--->
					</div><!-- /.tab-pane -->
					
					<div class="tab-pane #REQUEST.pageData.tabs['tab_4']#" id="tab_4">
					
						<cfif NOT IsNULL(REQUEST.pageData.product) AND NOT IsNULL(REQUEST.pageData.product.getImagesMV())>
							<div class="row">
								<cfloop array="#REQUEST.pageData.product.getImagesMV()#" index="img">						
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
							<select name="attribute_set_id" id="attribute-set-id" class="form-control">
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
						
						<cfloop array="#REQUEST.pageData.attributeSets#" index="attributeSet">
							<cfif NOT IsNull(REQUEST.pageData.product)>
								<cfset currentAttributeSet = REQUEST.pageData.product.getAttributeSetMV() />
							</cfif>
							<div class="attribute-set" id="attribute-set-#attributeSet.getAttributeSetId()#" style="
							<cfif IsNull(REQUEST.pageData.product) OR IsNull(currentAttributeSet) OR (NOT IsNull(REQUEST.pageData.product) AND NOT IsNull(currentAttributeSet) AND attributeSet.getAttributeSetId() NEQ currentAttributeSet.getAttributeSetId())>
							display:none;
							</cfif>">
								<label>Attribute Option(s)</label>
						
								<div class="row" style="margin-top:10px;">
									<cfloop array="#attributeSet.getAttributeSetAttributeRelas()#" index="attributeSetAttributeRela">
										<cfset attribute = attributeSetAttributeRela.getAttribute() />
										<div class="col-xs-3">
											<div class="box box-warning">
												<div class="box-body table-responsive no-padding">
													<table class="table table-hover">
														<tr class="warning" id="tr-#attributeSet.getAttributeSetId()#-#attribute.getAttributeId()#">
															<th colspan="3">#attribute.getDisplayName()#<cfif attributeSetAttributeRela.getRequired() EQ true> (required)</cfif></th>
															<th>
																<a attributesetid="#attributeSet.getAttributeSetId()#" attributeid="#attribute.getAttributeId()#" attributename="#attribute.getName()#" req="#attributeSetAttributeRela.getRequired()#" href="" class="add-new-attribute-option pull-right" data-toggle="modal" data-target="##add-new-attribute-option-modal">
																	<span class="label label-primary">Add Option</span>
																</a>
															</th>
														</tr>
														
														<cfif NOT IsNull(REQUEST.pageData.product) AND NOT IsNull(currentAttributeSet) AND attributeSet.getAttributeSetId() EQ currentAttributeSet.getAttributeSetId()>
															<cfset productAttributeRela = EntityLoad("product_attribute_rela",{product=REQUEST.pageData.product,attribute=attribute},true) />
															<cfif NOT IsNull(productAttributeRela)>
																<cfloop array="#productAttributeRela.getAttributeValues()#" index="attributeValue">
																	<tr id="tr-av-#attributeValue.getAttributeValueId()#">
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
														</cfif>
													</table>
												</div><!-- /.box-body -->
											</div><!-- /.box -->
										</div>
									</cfloop>
								</div>
								<cfif 	NOT IsNull(REQUEST.pageData.product) 
										AND 
										NOT IsNull(currentAttributeSet)
										AND 
										attributeSet.getAttributeSetId() EQ currentAttributeSet.getAttributeSetId()
										AND
										NOT ArrayIsEmpty(REQUEST.pageData.product.getSubProducts())>
									<div class="form-group">
										<label>Product(s)</label>
										<table class="table table-bordered table-hover">
											<tr class="default">
												<th>ID</th>
												<cfloop array="#attributeSet.getAttributeSetAttributeRelas()#" index="rela">
													<th>#LCase(rela.getAttribute().getDisplayName())#</th>
												</cfloop>
												<th>Sku</th>
												<th>Stock</th>
											</tr>
											<cfloop array="#REQUEST.pageData.product.getSubProducts()#" index="p">	
											<tr>
												<td><a href="#APPLICATION.absoluteUrlWeb#admin/product_detail.cfm?id=#p.getProductId()#">#p.getProductId()#</a></td>
												<cfloop array="#attributeSet.getAttributeSetAttributeRelas()#" index="rela">
													<cfset productAttributeRela = EntityLoad("product_attribute_rela",{product=p,attribute=rela.getAttribute()},true) />
													<td>
														<cfif NOT IsNull(productAttributeRela) AND NOT ArrayIsEmpty(productAttributeRela.getAttributeValues())>
															<div class="pull-left">#productAttributeRela.getAttributeValues()[1].getDisplayName()#</div>
															<cfif productAttributeRela.getAttribute().getDisplayName() EQ "color">
																<cfif productAttributeRela.getAttributeValues()[1].getImageName() NEQ "">
																	<div class="pull-left" style="width:14px;height:14px;border:1px solid ##CCC;margin-top:3px;">
																		<img src="#productAttributeRela.getAttributeValues()[1].getImageLink()#" style="width:100%;height:100%;vertical-align:top;" />
																	</div>
																<cfelse>
																	<div class="pull-left" style="margin-left:10px;width:14px;height:14px;border:1px solid ##CCC;background-color:#productAttributeRela.getAttributeValues()[1].getValue()#;margin-top:3px;"></div>
																</cfif>
															</cfif>
														<cfelse>
															N/A
														</cfif>
													</td>
												</cfloop>
												<td>
													<input name="sku_#p.getProductId()#" value="#p.getSku()#" style="width:100%;" />
												</td>
												<td>
													<input name="stock_#p.getProductId()#" value="#p.getStock()#" style="width:100%;" />
												</td>
											</tr>
											</cfloop>
										</table>
									</div>
								</cfif>
							</div>
						</cfloop>
					</div>
					<div class="tab-pane #REQUEST.pageData.tabs['tab_6']#" id="tab_6">
					
						<div class="row">
							<div class="col-xs-3" style="padding-right:0;">
								<select name="search_product_group_id" id="search-product-group-id" class="form-control">
									<option value="0">Choose Product Group ...</option>
									<cfloop array="#REQUEST.pageData.productGroups#" index="group">
										<option value="#group.getProductGroupId()#">#group.getDisplayName()#</option>
									</cfloop>
								</select>
							</div>
							<div class="col-xs-4" style="padding-right:0;">
								<select class="form-control" name="search_category_id" id="search-category-id">
									<option value="0">Choose Category ...</option>
									<cfloop array="#REQUEST.pageData.categoryTree#" index="cat">
										<option value="#cat.getCategoryId()#"
										<cfif NOT IsNull(REQUEST.pageData.product) AND NOT IsNull(REQUEST.pageData.product.getCategoriesMV()) AND ArrayContains(REQUEST.pageData.product.getCategoriesMV(),cat)>
										selected
										</cfif>
										>#RepeatString("&nbsp;",1)##cat.getDisplayName()#</option>
										<cfloop array="#cat.getSubCategories()#" index="subCat">
											<option value="#subCat.getCategoryId()#"
											<cfif NOT IsNull(REQUEST.pageData.product) AND NOT IsNull(REQUEST.pageData.product.getCategoriesMV()) AND ArrayContains(REQUEST.pageData.product.getCategoriesMV(),subCat)>
											selected
											</cfif>
											>#RepeatString("&nbsp;",11)##subCat.getDisplayName()#</option>
											<cfloop array="#subCat.getSubCategories()#" index="thirdCat">
												<option value="#thirdCat.getCategoryId()#"
												<cfif NOT IsNull(REQUEST.pageData.product) AND NOT IsNull(REQUEST.pageData.product.getCategoriesMV()) AND ArrayContains(REQUEST.pageData.product.getCategoriesMV(),thirdCat)>
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
							<div class="col-xs-4" style="padding-right:0;padding-left:10px;">
								<input type="text" name="search_keywords" id="search-keywords" class="form-control" placeholder="Keywords">
							</div>
							<div class="col-xs-1" style="padding-left:10px;">
								<button name="search_product" id="search-product" type="button" class="btn btn-sm btn-primary search-button" style="width:100%">Search</button>
							</div>
						</div>
						<div class="row" style="margin-top:18px;">
							<div class="col-xs-5">	
								<select name="products_searched" id="products-searched" multiple class="form-control" style="height:270px;">
								</select>
							</div>
							<div class="col-xs-2" style="text-align:center;">
								<a class="btn btn-app" id="add-all">
									<i class="fa fa-angle-double-right"></i> Add All
								</a>
								<a class="btn btn-app" id="add">
									<i class="fa fa-angle-right"></i> Add
								</a>
								<a class="btn btn-app" id="remove">
									<i class="fa fa-angle-left"></i> Remove
								</a>
								<a class="btn btn-app" id="remove-all">
									<i class="fa fa-angle-double-left"></i> Remove All
								</a>
							</div>
							<div class="col-xs-5">	
								<select name="products_selected" id="products-selected" multiple class="form-control" style="height:270px;">
									<cfif NOT IsNull(REQUEST.pageData.product)>
										<cfloop array="#REQUEST.pageData.product.getRelatedProducts()#" index="product">
											<option value="#product.getProductId()#">#product.getDisplayName()#</option>
										</cfloop>
									</cfif>
								</select>
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
												<cfif NOT IsNull(REQUEST.pageData.product) AND NOT IsNull(REQUEST.pageData.product.getReviewsMV()) AND ArrayLen(REQUEST.pageData.product.getReviewsMV()) GT 0>
													<cfloop array="#REQUEST.pageData.product.getReviewsMV()#" index="review">
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
						<table class="table table-hover">
							<tr>
								<td>
									<input type="radio" name="shipping_method" value="free" checked>
								</td>
								<td>Free Shipping</td>
							</tr>
							<tr>
								<td>
									<input type="radio" name="shipping_method" value="flat">
								</td>
								<td>Flat Rate: <input type="text" name="flat_rate_price" value="" style="margin-left:20px;"></td>
							</tr>
							<tr>
								<td>
									<input type="radio" name="shipping_method" value="carrier">
								</td>
								<td>Choose Carrier</td>
							</tr>
							<tr>
								<td></td>
								<td>
									<div class="row" style="margin-top:10px;">
										<cfloop array="#REQUEST.pageData.shippingCarriers#" index="sc">
											<div class="col-xs-2">
												<div class="box box-warning">
													<div class="box-body table-responsive no-padding">
														<table class="table table-hover">
															<tr class="warning">
																<th><img src="#APPLICATION.absoluteUrlWeb#images/uploads/shipping/#sc.getImageName()#" style="height:25px;vertical-align:top;" /></th>
																<th colspan="2" style="padding-right:10px;" nowrap>#sc.getDisplayName()#</th>
																<th style="text-align:right;">
																	<input type="checkbox" class="form-control pull-right" name="shipping_carrier_id" value="#sc.getShippingCarrierId()#"
																	
																	<cfif NOT IsNull(productShippingCarrierRela) 
																		OR 
																		NOT IsNull(REQUEST.pageData.formData.shipping_carrier_id) AND ListFind(REQUEST.pageData.formData.shipping_carrier_id, sc.getShippingCarrierId())>
																		checked
																	</cfif>
																	
																	/>
																</th>
															</tr>	
														</table>
													</div><!-- /.box-body -->
												</div><!-- /.box -->
											</div>
										</cfloop>
									</div>
								</td>
							</tr>
						</table>
						<!---
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
						<div class="form-group">
							<label>Shipping Carriers</label>
							<div class="row" style="margin-top:10px;">
								<cfloop array="#REQUEST.pageData.shippingCarriers#" index="sc">
									<cfif StructKeyExists(REQUEST.pageData.formData,"default_price_#sc.getShippingCarrierId()#")>
										<cfset defaultPrice = REQUEST.pageData.formData["default_price_#sc.getShippingCarrierId()#"] />
									<cfelse>
										<cfif NOT IsNull(REQUEST.pageData.product)>
											<cfset productShippingCarrierRela = EntityLoad("product_shipping_carrier_rela",{product = REQUEST.pageData.product, shippingCarrier = sc},true) />
											<cfif NOT IsNull(productShippingCarrierRela)>
												<cfset defaultPrice = productShippingCarrierRela.getPrice() />
											<cfelse>
												<cfset defaultPrice = 0 />
											</cfif>
										<cfelse>
											<cfset defaultPrice = 0 />
										</cfif>
									</cfif>
									<div class="col-xs-3">
										<div class="box box-warning">
											<div class="box-body table-responsive no-padding">
												<table class="table table-hover">
													<tr class="warning">
														<th><img src="#APPLICATION.absoluteUrlWeb#images/uploads/shipping/#sc.getImageName()#" style="height:25px;vertical-align:top;" /></th>
														<th colspan="2" style="text-align:right;padding-right:10px;" nowrap>#sc.getDisplayName()#</th>
														<th style="text-align:right;">
															<input type="checkbox" class="form-control pull-right" name="shipping_carrier_id" value="#sc.getShippingCarrierId()#"
															
															<cfif NOT IsNull(productShippingCarrierRela) 
																OR 
																NOT IsNull(REQUEST.pageData.formData.shipping_carrier_id) AND ListFind(REQUEST.pageData.formData.shipping_carrier_id, sc.getShippingCarrierId())>
																checked
															</cfif>
															
															/>
														</th>
													</tr>	
													<tr style="font-size:12px;">
														<td>
															<input type="radio" name="use_default_price_#sc.getShippingCarrierId()#" value="1"
															
															<cfif NOT StructKeyExists(REQUEST.pageData.formData,"use_default_price_#sc.getShippingCarrierId()#") AND (IsNull(productShippingCarrierRela) OR productShippingCarrierRela.getUseDefaultPrice() EQ true)
																OR 
																StructKeyExists(REQUEST.pageData.formData,"use_default_price_#sc.getShippingCarrierId()#") AND REQUEST.pageData.formData["use_default_price_#sc.getShippingCarrierId()#"] EQ 1>
															checked
															</cfif>
															
															>
														</td>
														<td>Default</td>
														<td colspan="2">
															<input type="text" name="default_price_#sc.getShippingCarrierId()#" value="#defaultPrice#" style="width:100%;text-align:right;padding-right:5px;">
														</td>
													</tr>
													<tr style="font-size:12px;">
														<td>
															<input type="radio" name="use_default_price_#sc.getShippingCarrierId()#" value="0"
															
															<cfif NOT StructKeyExists(REQUEST.pageData.formData,"use_default_price_#sc.getShippingCarrierId()#") AND (IsNull(productShippingCarrierRela) OR productShippingCarrierRela.getUseDefaultPrice() EQ false)
																OR 
																StructKeyExists(REQUEST.pageData.formData,"use_default_price_#sc.getShippingCarrierId()#") AND REQUEST.pageData.formData["use_default_price_#sc.getShippingCarrierId()#"] EQ 0>
															checked
															</cfif>
															
															>
														</td>
														<td colspan="3">Calculated</td>
													</tr>
												</table>
											</div><!-- /.box-body -->
										</div><!-- /.box -->
									</div>
								</cfloop>
							</div>
						</div>
						--->
					</div>
					<div class="tab-pane #REQUEST.pageData.tabs['tab_9']#" id="tab_9">
						<cfif NOT IsNULL(REQUEST.pageData.product) AND NOT IsNULL(REQUEST.pageData.product.getProductVideosMV())>
							<div class="form-group">
								<label>Videos</label>
								<a data-toggle="modal" data-target="##add-video-modal" href="" style="margin-left:10px;"><span class="label label-primary">Add New Video</span></a>
								<div class="row" style="margin-top:10px;">
									<cfloop array="#REQUEST.pageData.product.getProductVideosMV()#" index="video">	
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
								</div>
							</div>
						<cfelse>
							<div class="form-group">
								<label>Video 1</label>
								<input name="video1" type="text" class="form-control" placeholder="Enter ..." value="#REQUEST.pageData.formData.video1#"/>
							</div>
							<div class="form-group">
								<label>Video 2</label>
								<input name="video2" type="text" class="form-control" placeholder="Enter ..." value="#REQUEST.pageData.formData.video2#"/>
							</div>
							<div class="form-group">
								<label>Video 3</label>
								<input name="video3" type="text" class="form-control" placeholder="Enter ..." value="#REQUEST.pageData.formData.video3#"/>
							</div>
							<div class="form-group">
								<label>Video 4</label>
								<input name="video4" type="text" class="form-control" placeholder="Enter ..." value="#REQUEST.pageData.formData.video4#"/>
							</div>
							<div class="form-group">
								<label>Video 5</label>
								<input name="video5" type="text" class="form-control" placeholder="Enter ..." value="#REQUEST.pageData.formData.video5#"/>
							</div>
						</cfif>
					</div>
				</div><!-- /.tab-content -->
			</div><!-- nav-tabs-custom -->
			<cfif 	IsNull(REQUEST.pageData.product)
					OR
					NOT IsNull(REQUEST.pageData.product) AND REQUEST.pageData.product.getProductType().getName() EQ "simple">
				<div class="form-group">
					<button name="save_item" id="save-item" type="submit" class="btn btn-primary top-nav-button">Save Product</button>
					<button type="button" class="btn btn-danger pull-right #REQUEST.pageData.deleteButtonClass#" data-toggle="modal" data-target="##delete-current-entity-modal">Delete Product</button>
				</div>
			</cfif>
		</div><!-- /.col -->
		
	</div>   <!-- /.row -->
</section><!-- /.content -->

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
					<input id="new-attribute-option-name" name="new_attribute_option_name" type="text" class="form-control" placeholder="Name">
				</div>
				<div class="form-group">
					<input id="new-attribute-option-label" name="new_attribute_option_label" type="text" class="form-control" placeholder="Value">
				</div>	
				<div class="form-group">
					<div class="btn btn-success btn-file image-uploader" style="width:150px;margin-right:20px;" id="new-attribute-option-1-image-div">
						<i class="fa fa-paperclip"></i> &nbsp;&nbsp;Add Image
						<input type="file" name="new_attribute_option_1_image" id="new-attribute-option-1-image"/>
					</div>
					<div class="btn btn-success btn-file image-uploader" style="width:150px;margin-right:20px;display:none;" id="new-attribute-option-2-image-div">
						<i class="fa fa-paperclip"></i> &nbsp;&nbsp;Add Image
						<input type="file" name="new_attribute_option_2_image" id="new-attribute-option-2-image"/>
					</div>
					<div class="btn btn-success btn-file image-uploader" style="width:150px;margin-right:20px;display:none;" id="new-attribute-option-3-image-div">
						<i class="fa fa-paperclip"></i> &nbsp;&nbsp;Add Image
						<input type="file" name="new_attribute_option_3_image" id="new-attribute-option-3-image"/>
					</div>
					<div class="btn btn-success btn-file image-uploader" style="width:150px;margin-right:20px;display:none;" id="new-attribute-option-4-image-div">
						<i class="fa fa-paperclip"></i> &nbsp;&nbsp;Add Image
						<input type="file" name="new_attribute_option_4_image" id="new-attribute-option-4-image"/>
					</div>
					<div class="btn btn-success btn-file image-uploader" style="width:150px;margin-right:20px;display:none;" id="new-attribute-option-5-image-div">
						<i class="fa fa-paperclip"></i> &nbsp;&nbsp;Add Image
						<input type="file" name="new_attribute_option_5_image" id="new-attribute-option-5-image"/>
					</div>
					<div class="btn btn-success btn-file image-uploader" style="width:150px;margin-right:20px;display:none;" id="new-attribute-option-6-image-div">
						<i class="fa fa-paperclip"></i> &nbsp;&nbsp;Add Image
						<input type="file" name="new_attribute_option_6_image" id="new-attribute-option-6-image"/>
					</div>
					<div class="btn btn-success btn-file image-uploader" style="width:150px;margin-right:20px;display:none;" id="new-attribute-option-7-image-div">
						<i class="fa fa-paperclip"></i> &nbsp;&nbsp;Add Image
						<input type="file" name="new_attribute_option_7_image" id="new-attribute-option-7-image"/>
					</div>
					<div class="btn btn-success btn-file image-uploader" style="width:150px;margin-right:20px;display:none;" id="new-attribute-option-8-image-div">
						<i class="fa fa-paperclip"></i> &nbsp;&nbsp;Add Image
						<input type="file" name="new_attribute_option_8_image" id="new-attribute-option-8-image"/>
					</div>
					<div class="btn btn-success btn-file image-uploader" style="width:150px;margin-right:20px;display:none;" id="new-attribute-option-9-image-div">
						<i class="fa fa-paperclip"></i> &nbsp;&nbsp;Add Image
						<input type="file" name="new_attribute_option_9_image" id="new-attribute-option-9-image"/>
					</div>
					<div class="btn btn-success btn-file image-uploader" style="width:150px;margin-right:20px;display:none;" id="new-attribute-option-10-image-div">
						<i class="fa fa-paperclip"></i> &nbsp;&nbsp;Add Image
						<input type="file" name="new_attribute_option_10_image" id="new-attribute-option-10-image"/>
					</div>
					<input type="radio" class="form-control" name="generate_option" value="1"/> Thumbnail Only &nbsp;&nbsp;&nbsp;
					<input type="radio" class="form-control" name="generate_option" value="2"/> Image Only &nbsp;&nbsp;&nbsp;
					<input type="radio" class="form-control" name="generate_option" value="3"/> Both
				</div>
			</div>
			<div class="modal-footer clearfix">
				<button type="button" class="btn btn-danger" data-dismiss="modal"><i class="fa fa-times"></i> Cancel</button>
				<button id="add-new-attribute-option-confirm" name="add_new_attribute_option_confirm" type="button" class="btn btn-primary pull-left" data-dismiss="modal"><i class="fa fa-check"></i> Add</button>
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
				<button name="delete_attribute_option_confirm" id="delete-attribute-option-confirm" type="button" class="btn btn-primary" data-dismiss="modal"><i class="fa fa-check"></i> Yes</button>
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