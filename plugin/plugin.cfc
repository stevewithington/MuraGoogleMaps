<!---

This file is part of MuraGoogleMaps TM
(c) Stephen J. Withington, Jr. | www.stephenwithington.com

CAREFULLY READ THE ENCLOSED LICENSE AGREEMENT (plugin/license.htm). BY USING THIS SOFTWARE, YOU ARE CONSENTING TO BE BOUND BY AND ARE BECOMING A PARTY TO THIS AGREEMENT. IF YOU DO NOT AGREE TO ALL OF THE TERMS OF THIS AGREEMENT, THEN DO NOT USE THIS SOFTWARE, AND, IF APPLICABLE, RETURN THIS PRODUCT TO THE PLACE OF PURCHASE FOR A FULL REFUND.

--->
<cfcomponent output="false" extends="mura.plugin.plugincfc">

	<cfscript>
		variables.config 		= '';
		variables.packageAuthor	= 'Steve Withington | www.stephenwithington.com';
		variables.packageDate 	= createDateTime(2010,05,11,09,23,0);
		variables.packageName	= 'MuraGoogleMaps';
	</cfscript>

	<cffunction name="init" returntype="any" access="public" output="false">
		<cfargument name="config"  type="any" default="" />
		<cfscript>
			variables.config = arguments.config;
		</cfscript>
	</cffunction>
	
	<cffunction name="install" returntype="void" access="public" output="false">
		<cfscript>
			var local = structNew();
			application.appInitialized = false;
		</cfscript>
	</cffunction>
	
	<cffunction name="update" returntype="void" access="public" output="false">
		<cfscript>
			var local = structNew();
			application.appInitialized = false;
		</cfscript>
	</cffunction>
	
	<cffunction name="delete" returntype="void" access="public" output="false">
		<cfscript>
			application.appInitialized = false;
		</cfscript>
	</cffunction>

</cfcomponent>