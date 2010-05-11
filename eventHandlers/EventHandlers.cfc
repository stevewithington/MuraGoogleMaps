<!---

This file is part of MuraGoogleMaps TM
(c) Stephen J. Withington, Jr. | www.stephenwithington.com

CAREFULLY READ THE ENCLOSED LICENSE AGREEMENT (plugin/license.htm). BY USING THIS SOFTWARE, YOU ARE CONSENTING TO BE BOUND BY AND ARE BECOMING A PARTY TO THIS AGREEMENT. IF YOU DO NOT AGREE TO ALL OF THE TERMS OF THIS AGREEMENT, THEN DO NOT USE THIS SOFTWARE, AND, IF APPLICABLE, RETURN THIS PRODUCT TO THE PLACE OF PURCHASE FOR A FULL REFUND.

--->
<cfcomponent extends="mura.plugin.pluginGenericEventHandler">

	<cfscript>
		variables.instance = structNew();
		variables.instance.$ = structNew();
	</cfscript>

	<cffunction name="onApplicationLoad" output="false" returntype="void">
		<cfargument name="$" required="true" />
		<cfscript>
			var local = structNew();
			setMuraScope(arguments.$);
			variables.pluginConfig.addEventHandler(this);
		</cfscript>
	</cffunction>

	<cffunction name="onRenderStart" output="false" returntype="void">
		<cfargument name="$" required="true" />
		<cfscript>
			var local = structNew();
			setMuraScope(arguments.$);
			$.muraGoogleMaps = this;
		</cfscript>
	</cffunction>

	<cffunction name="onRenderEnd" output="false" returntype="void">
		<cfargument name="$" required="true" />
		<cfscript>
			var local = structNew();
			setMuraScope(arguments.$);
		</cfscript>
	</cffunction>

	<cffunction name="dspMuraGoogleMap" access="public" output="true" returntype="any">
		<cfargument name="CSVFile" required="false" default="" type="string" />
		<cfargument name="XMLFile" required="false" default="" type="string" />
		<cfscript>
			// test CSV file: #expandPath('/plugins/#variables.pluginConfig.getDirectory()#/lib/com/stephenwithington/muragooglemaps/samples/sample.csv')#
			// test XML file: #ExpandPath('/plugins/#variables.pluginConfig.getDirectory()#/lib/com/stephenwithington/muragooglemaps/samples/sample.xml')#
		
			var local = structNew();
			local.str = '';
			local.mgm = 'plugins.#variables.pluginConfig.getDirectory()#.lib.com.stephenwithington.muragooglemaps.MuraGoogleMaps';
			
			// IF CSV
			if ( StructKeyExists(arguments, 'CSVFile') and len(trim(arguments.CSVFile)) ) {
				// settings.ini.cfm filestore=fileDir, if it's anything else (i.e., database or s3), this won't work
				if ( getMuraScope().siteConfig('configBean').getFilestore() eq 'fileDir' ) {
					local.objMap = createObject("component", local.mgm).init(
						pluginConfig = variables.pluginConfig
						, CSVFile = arguments.CSVFile
					);
					local.str = local.objMap.getMap();
				} else {
					local.str = '<p><em>Sorry, files must be stored locally in order for MuraGoogleMaps to function properly at this time.</em></p>';
				};
			};
			
			// IF XML
			if ( StructKeyExists(arguments, 'XMLFile') and len(trim(arguments.XMLFile)) ) {
				// settings.ini.cfm filestore=fileDir, if it's anything else (i.e., database or s3), this won't work
				if ( left(arguments.XMLFile, 4) eq 'http' or getMuraScope().siteConfig('configBean').getFilestore() eq 'fileDir' ) {
					local.objMap = createObject("component", local.mgm).init(
						pluginConfig = variables.pluginConfig
						, XMLFile = arguments.XMLFile
					);
					local.str = local.objMap.getMap();
				} else {
					local.str = '<p><em>Sorry, XML files must either be stored locally or served via HTTP in order for MuraGoogleMaps to function properly at this time.</em></p>';
				};
			};

			return local.str;
		</cfscript>
	</cffunction>

	<cffunction name="setMuraScope" returntype="void" output="false">
		<cfargument name="$" required="true" />
		<cfset variables.instance.$ = arguments.$ />
	</cffunction>

	<cffunction name="getMuraScope" returntype="any" output="false">
		<cfreturn variables.instance.$ />
	</cffunction>

	<cffunction name="getAllValues" returntype="any" output="false">
		<cfreturn variables.instance />
	</cffunction>

</cfcomponent>