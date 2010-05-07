<!---

This file is part of MuraGoogleMaps TM
(c) Stephen J. Withington, Jr. | www.stephenwithington.com

CAREFULLY READ THE ENCLOSED LICENSE AGREEMENT (plugin/license.htm). BY USING THIS SOFTWARE, YOU ARE CONSENTING TO BE BOUND BY AND ARE BECOMING A PARTY TO THIS AGREEMENT. IF YOU DO NOT AGREE TO ALL OF THE TERMS OF THIS AGREEMENT, THEN DO NOT USE THIS SOFTWARE, AND, IF APPLICABLE, RETURN THIS PRODUCT TO THE PLACE OF PURCHASE FOR A FULL REFUND.

--->
<cfcomponent extends="mura.plugin.pluginGenericEventHandler">

	<cfscript>
		variables.instance = structNew();
		variables.instance.event = structNew();
	</cfscript>

	<cffunction name="onApplicationLoad" output="false" returntype="void">
		<cfargument name="event" required="true" />
		<cfscript>
			var local = structNew();
			setEvent(arguments.event);
			variables.pluginConfig.addEventHandler(this);
		</cfscript>
	</cffunction>

	<cffunction name="onRenderStart" output="false" returntype="void">
		<cfargument name="$" required="true" />
		<cfscript>
			var local = structNew();
			setEvent(arguments.$.event());
			$.muraGoogleMaps = this;
		</cfscript>
	</cffunction>

	<cffunction name="onRenderEnd" output="false" returntype="void">
		<cfargument name="event" required="true" />
		<cfscript>
			var local = structNew();
			setEvent(arguments.event);
		</cfscript>
	</cffunction>

	<cffunction name="dspMuraGoogleMap" access="public" output="false" returntype="any">
		<cfargument name="showTitle" required="false" default="true" type="boolean" />
		<cfargument name="debug" required="false" type="boolean" default="false" />
		<cfscript>
			var local = structNew();
			local.str = 'Not built yet.';
		</cfscript>
		<cfreturn local.str />
	</cffunction>

	<cffunction name="setEvent" returntype="void" output="false">
		<cfargument name="event" required="true" />
		<cfset variables.instance.event = arguments.event />
	</cffunction>

	<cffunction name="getEvent" returntype="any" output="false">
		<cfreturn variables.instance.event />
	</cffunction>

	<cffunction name="getAllValues" returntype="any" output="false">
		<cfreturn variables.instance />
	</cffunction>

</cfcomponent>