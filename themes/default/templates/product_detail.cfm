﻿<cfoutput>
<div style="margin-top:20px;">
	<div style="width:413px;float:left;">
		<img id="img_01" style="width:411px;" src="#REQUEST.pageData.product.getDefaultImageLink(type='medium')#" data-zoom-image="#REQUEST.pageData.product.getDefaultImageLink()#"/>
		<div id="gallery_01"> 
			<cfloop array="#REQUEST.pageData.allImages#" index="img">
				<a href="##" data-image="#img.getImageLink(type='medium')#" data-zoom-image="#img.getImageLink()#"> 
					<img style="height:67px;" src="#img.getImageLink(type='medium')#" /> 
				</a> 
			</cfloop>
		</div>
		<!---
		<div id="videos"> 
			<div style="padding-bottom:5px;">Videos:</div>
			<a class="various fancybox.iframe" href="http://www.youtube.com/embed/L9szn1QQfas?autoplay=1">
				<img id="img_02" src="#SESSION.absoluteUrlTheme#images/thumb/image1.jpg" /> 
			</a> 
		</div>
		--->
	</div>
	<div style="width:523px;float:right;">
		<div id="product-name" style="font-size:18px;font-weight:bold;">
			#REQUEST.pageData.product.getDisplayName()#
		</div>
		<div id="product-share" style="margin-top:10px;">
			<img class="logo facebook-logo" onclick="affShareOnFacebook('http://www.tomtop.com/usb-to-pc-game-controller-adapter-converter-for-ps2-game006.html')" title="Share on Facebook" src="#SESSION.absoluteUrlTheme#images/p_facebook-color.png">
			<img class="logo twitter-logo" onclick="affShareOnTwitter('http://www.tomtop.com/usb-to-pc-game-controller-adapter-converter-for-ps2-game006.html')" title="Share on Twitter" src="#SESSION.absoluteUrlTheme#images/p_tweet.png">
			<img class="logo google-logo" onclick="affShareGooglePlus('http://www.tomtop.com/usb-to-pc-game-controller-adapter-converter-for-ps2-game006.html')" title="Share on Google Plus" src="#SESSION.absoluteUrlTheme#images/p_gplus-color.png">
			<img src="#SESSION.absoluteUrlTheme#images/p_pinterest.png">
		</div>
		<div id="product-sku" style="font-size:12px;margin-top:10px;">
			SKU:#REQUEST.pageData.product.getSku()#
		</div>
		<cfif REQUEST.pageData.product.isProductAttributeComplete()>
			<div id="product-filters" style="font-size:12px;margin-top:30px;">
				<div id="gallery_01">
				<cfloop array="#REQUEST.pageData.product.getAttributeSet().getAttributeSetAttributeRelas()#" index="attributeSetAttributeRela">
					<cfset attribute = attributeSetAttributeRela.getAttribute() />
					<cfset productAttributeRela = EntityLoad("product_attribute_rela",{product=REQUEST.pageData.product,attribute=attribute},true) />
					<cfif productAttributeRela.getRequired() EQ true>
						<ul>
							<li style="width:40px;">#attribute.getDisplayName()#: </li>
							
							<cfloop array="#productAttributeRela.getAttributeValues()#" index="attributeValue">
								<li class="filter-options">
								<a href="##" data-image="http://127.0.0.1:8500/cfcart/images/uploads/product/17/medium_image2.jpg" 
								data-zoom-image="http://127.0.0.1:8500/cfcart/images/uploads/product/17/image4.jpg">
								<cfif NOT IsNull(attributeValue.getThumbnailImageName())>
									<img src="#attributeValue.getThumbnailImageLink()#" style="width:20px;height:20px;vertical-align:top;" />
								<cfelse>
									<cfif attribute.getDisplayName() EQ "color">
										<div style="width:22px;height:22px;background-color:#attributeValue.getThumbnailLabel()#;"></div>
									<cfelse>
										<div style="padding:5px 8px;">#attributeValue.getThumbnailLabel()#</div>
									</cfif>
								</cfif>
								</li>
								</a>
							</cfloop>
							
						</ul>
						<div style="clear:both;"></div>
					</cfif>
				</cfloop>
				</div>
			</div>
		</cfif>
		<div id="product-price" style="font-size:18px;font-weight:bold;color:##C20000;margin-top:20px;">
			#DollarFormat(REQUEST.pageData.product.getPrice())#
		</div>
		<div id="product-addtocart" style="margin-top:30px;">
			<span style="font-size:13px;">Qty: </span>
			<button id="minus">-</button>
			<input id="value" type="text" value="0" style="width:30px;text-align:center;" />
			<button id="plus">+</button>
			<a class="btn add-to-cart" style="padding-right:13px;margin-left:15px;">Add to Cart</a>
			<a class="btn-wish" style="padding-right:13px;">Add to Wishlist</a>
		</div>
		
		<div id="product-description">
			<ul>
				<li><a href="##tabs-1">Product Description</a></li>
				<li><a href="##tabs-2">Reviews</a></li>
			</ul>
			<div id="tabs-1">
				#REQUEST.pageData.product.getDetail()#
			</div>
		  <div id="tabs-2">
			<cfloop array="#REQUEST.pageData.reviews#" index="review">
				<div style="border-bottom: 1px dashed ##CCCCCC;">
					<p style="font-weight:bold;">#review.getSubject()# Review by #review.getName()#</p>
					<p style="width:200px;height: 13px;
						background: url(#SESSION.absoluteUrlTheme#images/breadcrub20140512.png);
						background-position: left -1500px;
						background-repeat: no-repeat;"></p>
					<p>#review.getMessage()#</p>
					<p>(Posted on #DateFormat(review.getCreatedDatetime(),"mmm dd, yyyy")#)</p>
				</div>
			</cfloop>
			<div>
				<p style="font-weight:bold;">Write Your Own Review</p>
				<p style="font-weight:bold;">How do you rate this product?</p>
				<p style="width:200px;height: 13px;
							background: url(#SESSION.absoluteUrlTheme#images/breadcrub20140512.png);
							background-position: left -1500px;
							background-repeat: no-repeat;"></p>
				<p style="font-weight:bold;">Name</p>
				<p><input type="text" style="width:100%;" /></p>
				<p style="font-weight:bold;">Subject</p>
				<p><input type="text" style="width:100%;" /></p>
				<p style="font-weight:bold;">Content</p>
				<p><textarea style="width:100%;height:100px;" /></textarea></p>
				<p><input type="button" value="Submit" style="padding:5px 10px;" /></p>
			</div>
		  </div>
		</div>
	</div>
	</div>
	<div style="clear:both;"></div>
	<div class="container">
	<div class="related-thumbnails">
		<div class="cat-thumbnail-title"><a href="">Related Products</a></div>
		<div class="clear"></div>
		<div class="cat-thumbnail-section">
			<ul class="rig columns-4">
				<cfloop array="#REQUEST.pageData.product.getRelatedProducts()#" index="product">
					<li class="single-products">
						<a href="#product.getDetailPageURL()#">
							<img class="thumbnail-img" src="#product.getDefaultImageLink(type='small')#" />
						</a>
						<div class="thumbnail-name"><a href="#product.getDetailPageURL()#">#product.getDisplayName()#</a></div>
						<div class="thumbnail-price">#DollarFormat(product.getPrice())#</div>
						<cfif product.isFreeShipping()>
						<img class="free-shipping-icon" src="#APPLICATION.absoluteUrlWeb#images/freeshipping.jpg" style="width:120px;margin-top:7px;" />
						</cfif>
						<div class="product-overlay">
							<div class="overlay-content">
								<div class="thumbnail-rating" style="background-position: 30px -1512px;"></div>
								<div class="thumbnail-review"><a href="#product.getDetailPageURL()#">(#ArrayLen(product.getReviews())# Reviews)</a></div>
								<div class="thumbnail-cart"><a class="btn add-to-cart" style="padding-right:13px;">Add to cart</a></div>
							</div>
						</div>
					</li>
				</cfloop>
			</ul>
		</div>
	</div>
</div>
</cfoutput>
	