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

	<cffunction name="onPageMuraGoogleMapsBodyRender" access="public" output="true" returntype="any">
		<cfargument name="$" />
		<cfscript>
			var local = StructNew();
			local.str = '';
			local.body = $.setDynamicContent($.content('body'));
			local.map = '';
			local.mapFile = '';

			local.mapOptions = StructNew();
			local.mapOptions.mapType = $.content('mapType');
			local.mapOptions.displayDirections = $.content('displayDirections');
			local.mapOptions.displayTravelMode = $.content('displayTravelMode');
			local.mapOptions.start = $.content('start');
			local.mapOptions.mapWidth = $.content('mapWidth');
			local.mapOptions.mapHeight = $.content('mapHeight');

			// check to see if an actual file was uploaded
			if ( len(trim($.content('mapFile'))) ) {
				// get the map fileid
				local.mapFileID = $.content('mapFile');
				// let's get some some info about this map file
				local.rsMapInfo = $.getBean('fileManager').readMeta(local.mapFileID);
				// process only xml or csv files
				if ( local.rsMapInfo.fileExt eq 'xml' or local.rsMapInfo.fileExt eq 'csv' ) {
					// build a URL to the location of the mapFile
					local.mapFile = getPageContext().getRequest().getScheme() & '://' & getPageContext().getRequest().getServerName() & $.globalConfig('context') & '/tasks/render/file/?fileID=' & local.rsMapInfo.fileID & '&amp;ext=.' & local.rsMapInfo.fileExt;
				};
			} else if ( len(trim($.content('mapURL'))) ) {
				// if a file hasn't been uploaded, let's check to see if a URL has been provided
				local.mapFile = trim($.content('mapURL'));
			};

			// if using the URL field
			if ( len(trim(local.mapFile)) ) {
				local.map = dspMuraGoogleMap(
					file = local.mapFile
					, options = local.mapOptions
				);
			} else {
				// if we don't have a mapFile built yet, then we're probably dealing with a bad file
				local.str = 'Map file appears to be invalid.';
			};

			local.str = local.body & local.map;
			return local.str;
		</cfscript>
	</cffunction>

	<cffunction name="dspMuraGoogleMap" access="public" output="false" returntype="any">
		<cfargument name="file" required="false" default="" type="string" />
		<cfargument name="options" required="false" />
		<cfscript>
			var local = structNew();
			local.str = '';
			local.delim = getMuraScope().globalConfig('filedelim');
			if ( StructKeyExists(arguments, 'file') and len(trim(arguments.file)) ) {
				if ( not StructKeyExists(arguments, 'options') or not IsStruct(arguments.options) ) {
					local.objMap = createObject("component", 'plugins.#variables.pluginConfig.getDirectory()#.lib.com.stephenwithington.muragooglemaps.MuraGoogleMaps').init(
						pluginConfig = variables.pluginConfig
						, fileURL = arguments.file
					);
				} else {
					local.objMap = createObject("component", 'plugins.#variables.pluginConfig.getDirectory()#.lib.com.stephenwithington.muragooglemaps.MuraGoogleMaps').init(
						pluginConfig = variables.pluginConfig
						, fileURL = arguments.file
						, options = arguments.options
					);
				};
				local.str = local.objMap.getMap();
			} else {
				local.str = '<p>No file was passed to dspMuraGoogleMap()</p>';
			};
			return local.str;
		</cfscript>
	</cffunction>

	<cffunction name="dump" access="public" returntype="any" output="true">
		<cfargument name="var" type="any" default="" />
		<cfdump var="#arguments.var#" />
		<cfabort />
	</cffunction>

	<cffunction name="setMuraScope" access="private" returntype="void" output="false">
		<cfargument name="$" required="true" />
		<cfset variables.instance.$ = arguments.$ />
	</cffunction>

	<cffunction name="getMuraScope" access="private" returntype="any" output="false">
		<cfreturn variables.instance.$ />
	</cffunction>

	<cffunction name="getAllValues" access="public" returntype="any" output="false">
		<cfreturn variables.instance />
	</cffunction>

</cfcomponent>