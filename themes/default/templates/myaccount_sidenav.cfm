﻿<cfoutput>
<div id="myaccount-sidenav" style="width:200px;float:left;">
	<div class="recommendation" style="width:188px;">
		My Account
	</div>
	<div class="recommendation-list" style="font-size:12px;padding-bottom:0;">
		<ul>
			<li>
				<a href="#APPLICATION.absoluteUrlWeb#myaccount/dashboard.cfm">Dashboard</a>
			</li>
			<li>
				<a href="#APPLICATION.absoluteUrlWeb#myaccount/orders.cfm">My Orders</a>
			</li>
			<li>
				<a href="#APPLICATION.absoluteUrlWeb#myaccount/addresses.cfm">My Addresses</a>
			</li>
			<li>
				<a href="#APPLICATION.absoluteUrlWeb#myaccount/reviews.cfm">My Product Reviews</a>
			</li>
			<li>
				<a href="#APPLICATION.absoluteUrlWeb#myaccount/coupons.cfm">My Coupons</a>
			</li>
			<li>
				<a href="#APPLICATION.absoluteUrlWeb#myaccount/profile.cfm">My Profile</a>
			</li>
			<li>
				<a href="#APPLICATION.absoluteUrlWeb#myaccount/change_password.cfm">Change Password</a>
			</li>
			<li style="border-bottom:none;">
				<a href="#CGI.SCRIPT_NAME#?logout">Logout</a>
			</li>
		</ul>
	</div>
</div>
</cfoutput>