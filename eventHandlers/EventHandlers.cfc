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

			if ( len(trim($.content('mapFile'))) ) {
				local.fileObj = createObject('java','java.io.File');
				local.delim = local.fileObj.separator;
				local.fileDir = $.siteConfig('configBean').getFileDir();
				local.mapFileID = $.content('mapFile');
				local.rsMapInfo = $.getBean('fileManager').readMeta(local.mapFileID);
				local.mapFile = local.fileDir & local.delim & $.siteConfig('siteid') & local.delim & 'cache' & local.delim & 'file' & local.delim & local.rsMapInfo.fileID & '.' & local.rsMapInfo.fileExt;
			};

			local.mapOptions = StructNew();
			local.mapOptions.mapType = $.content('mapType');
			local.mapOptions.displayDirections = $.content('displayDirections');
			local.mapOptions.displayTravelMode = $.content('displayTravelMode');
			local.mapOptions.start = $.content('start');
			local.mapOptions.mapWidth = $.content('mapWidth');
			local.mapOptions.mapHeight = $.content('mapHeight');

			// if using XML URL
			if ( len(trim($.content('XmlUrl'))) ) {
				local.map = dspMuraGoogleMap(
					file = $.content('XmlUrl')
					, options = local.mapOptions
				);
			} else if ( len(trim(local.mapFile)) ) {
				local.map = dspMuraGoogleMap(
					file = local.mapFile
					, options = local.mapOptions
				);
			};

			local.str = local.body & local.map;
			return local.str;
		</cfscript>
		<!---<cfdump var="#local.mapFile#" />--->
	</cffunction>

	<cffunction name="dspMuraGoogleMap" access="public" output="false" returntype="any">
		<cfargument name="file" required="false" default="" type="string" />
		<cfargument name="options" required="false" />
		<cfscript>
			//StructFind(arguments.options, 'displayDirections');
			// test CSV file: #ExpandPath('/plugins/#variables.pluginConfig.getDirectory()#/lib/com/stephenwithington/muragooglemaps/samples/sample.csv')#
			// test XML file: #ExpandPath('/plugins/#variables.pluginConfig.getDirectory()#/lib/com/stephenwithington/muragooglemaps/samples/sample.xml')#
			// test XML file: http://dev.loc/?LinkServID=3837E9CE-B717-0357-2ADFB401019A83E9
		
			var local = structNew();
			local.str = '';
			local.mgm = 'plugins.#variables.pluginConfig.getDirectory()#.lib.com.stephenwithington.muragooglemaps.MuraGoogleMaps';
			
			if ( not StructKeyExists(arguments, 'options') or not IsStruct(arguments.options) ) {
				arguments.options = StructNew();
			};

			if ( StructKeyExists(arguments, 'file') and len(trim(arguments.file)) ) {

				if ( right(arguments.file, 3) eq 'csv' ) {
					// settings.ini.cfm filestore=fileDir, if it's anything else (i.e., database or s3), this won't work
					if ( getMuraScope().siteConfig('configBean').getFilestore() eq 'fileDir' ) {
						local.objMap = createObject("component", local.mgm).init(
							pluginConfig = variables.pluginConfig
							, CSVFile = arguments.file
							, options = arguments.options
						);
						local.str = local.objMap.getMap();
					} else {
						local.str = '<p><em>Sorry, files must be stored locally in order for MuraGoogleMaps to function properly at this time.</em></p>';
					};
				} else if ( right(arguments.file, 3) eq 'xml' ) {
					// settings.ini.cfm filestore=fileDir, if it's anything else (i.e., database or s3), this won't work
					if ( getMuraScope().siteConfig('configBean').getFilestore() eq 'fileDir' ) {
						local.objMap = createObject("component", local.mgm).init(
							pluginConfig = variables.pluginConfig
							, XMLFile = arguments.file
							, options = arguments.options
						);
						local.str = local.objMap.getMap();
					} else {
						local.str = '<p><em>Sorry, XML files must either be stored locally or served via HTTP in order for MuraGoogleMaps to function properly at this time.</em></p>';
					};
						
				} else if ( left(arguments.file, 4) eq 'http' ) {
					// settings.ini.cfm filestore=fileDir, if it's anything else (i.e., database or s3), this won't work
						local.objMap = createObject("component", local.mgm).init(
							pluginConfig = variables.pluginConfig
							, XMLFile = arguments.file
							, options = arguments.options
						);
						local.str = local.objMap.getMap();
				} else {
					local.str = '<p><em>Sorry, we do not appear to have a properly formatted CSV or XML file to work with.</em></p>';
				};
			} else {
				local.str = '<p>Did you send us a file?</p>';
			};

			return local.str;
		</cfscript>
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