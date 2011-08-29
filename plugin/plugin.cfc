<!---

This file is part of MuraGoogleMaps TM
(c) Stephen J. Withington, Jr. | www.stephenwithington.com

CAREFULLY READ THE ENCLOSED LICENSE AGREEMENT (plugin/license.htm). BY USING THIS SOFTWARE, YOU ARE CONSENTING TO BE BOUND BY AND ARE BECOMING A PARTY TO THIS AGREEMENT. IF YOU DO NOT AGREE TO ALL OF THE TERMS OF THIS AGREEMENT, THEN DO NOT USE THIS SOFTWARE, AND, IF APPLICABLE, RETURN THIS PRODUCT TO THE PLACE OF PURCHASE FOR A FULL REFUND.

--->
<cfcomponent output="false" extends="mura.plugin.plugincfc">

	<cfscript>
		variables.config 		= '';
		variables.packageAuthor	= 'Steve Withington | www.stephenwithington.com';
		variables.packageDate 	= createDateTime(2011,08,28,22,36,0);
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
			// need to check and see if this is already installed ... if so, then abort!
			local.moduleid = variables.config.getModuleID();
			// only if this is NOT installed
			if ( val(getInstallationCount()) eq 1 ) {
				upsertMuraGoogleMapsSubType();
			} else {
				variables.config.getPluginManager().deletePlugin(local.moduleid);
			};
			application.appInitialized = false;
		</cfscript>
	</cffunction>
	
	<cffunction name="update" returntype="void" access="public" output="false">
		<cfscript>
			upsertMuraGoogleMapsSubType();
			application.appInitialized = false;
		</cfscript>
	</cffunction>
	
	<cffunction name="delete" returntype="void" access="public" output="false">
		<cfscript>
			var local = structNew();
			//local.reloadKey = variables.config.getConfigBean().getAppReloadKey();

			// don't delete the subTypes if this is being invoked by the deletePlugin() from install()
			if ( val(getInstallationCount()) eq 1 ) {
				// WARNING: deleting a subType will also delete any files associated with it! For example, if you
				// 			uploaded 50 XML/CSV files using this plugin, then all 50 XML/CSV will also be deleted.
				deleteSubType(type='Page',subType=variables.packageName);
			};
			application.appInitialized = false;
		</cfscript>
	</cffunction>

	<!--- ********************** private *********************** --->
	<cffunction name="getInstallationCount" returntype="any" access="private" output="false">
		<cfscript>
			// i check to see if this plugin has already been installed. if so, i delete the new one.
			var qoq 	= ''; // query of queries don't like to be named 'local.qoq'
			var rs 		= variables.config.getConfigBean().getPluginManager().getAllPlugins();
			var local 	= structNew();
			local.ret	= 0;
		</cfscript>
		<cfif rs.recordcount>
			<cfquery name="qoq" dbtype="query">
				SELECT *
				FROM rs
				WHERE package = <cfqueryparam value="#variables.packageName#" cfsqltype="cf_sql_varchar" maxlength="100" />
			</cfquery>
			<cfscript>
				if ( qoq.recordcount gt 0 ) {
					return val(qoq.recordcount);
				};
			</cfscript>
		<cfelse>
			<cfreturn local.ret />
		</cfif>
	</cffunction>

	<cffunction name="upsertMuraGoogleMapsSubType" returntype="any" access="private" output="false">
		<cfscript>
			var local = structNew();
			// grab which sites this plugin has been assigned to
			local.rsSites 		= variables.config.getAssignedSites();
			local.filestore 	= variables.config.getConfigBean().getFileStore();
			local.subType 		= application.classExtensionManager.getSubTypeBean();
			// this will make a nice header above the attribute settings on the Extended Attributes tab
			local.parentType 	= variables.packageName & ' Settings';
		</cfscript>
		<!--- create the attribute sets that belong to this subType --->
		<cfloop query="local.rsSites">
			<cftry>
				<cfinclude template="attributesets.cfm" />
				<cfcatch>
					<cfthrow
						message="Sorry! This plugin did NOT install correctly. Please DELETE it. Here's the error message: #cfcatch.message#" 
						detail="#cfcatch.detail#" />
				</cfcatch>
			</cftry>
		</cfloop>
	</cffunction>

	<cffunction name="upsertAttributeSet" returntype="void" access="private" output="false">
		<cfargument name="siteID" required="true" />
		<cfargument name="name" required="true" />
		<cfargument name="label" required="false" default="#arguments.name#" />
		<cfargument name="hint" required="false" default="" />
		<cfargument name="type" required="false" default="TextBox" hint="Options are: TextBox^TextArea^HTMLEditor^SelectBox^MultiSelectBox^RadioGroup^File^Hidden" />
		<cfargument name="defaultValue" required="false" default="" />
		<cfargument name="required" required="false" default="false" type="boolean" />
		<cfargument name="validation" required="false" default="" hint="Options are: None^Date^Numeric^Email^Regex ... if 'None', then it will be set to an empty string." />
		<cfargument name="regex" required="false" default="" />
		<cfargument name="message" required="false" default="" />
		<cfargument name="optionList" required="false" default="" />
		<cfargument name="optionLabelList" required="false" default="" />
		<cfargument name="parentType" required="false" default="Default" hint="Class Extension Attribute Set Name (i.e., Default, etc.)" />
		<cfargument name="orderNo" required="false" default="99" />
		<cfargument name="container" required="false" default="default" hint="Which tab to display: default, basic, custom" />
		<cfscript>
			var local = structNew();

			// VALIDATION
			// validate proper options are being passed for 'type' and 'validation'
			local.validTypes = 'TextBox^TextArea^HTMLEditor^SelectBox^MultiSelectBox^RadioGroup^File^Hidden';
			if ( not listFindNoCase(local.validTypes, arguments.type, '^') ) {
				arguments.type = 'TextBox';
			};

			local.validValidations = 'Date^Numeric^Email^Regex';
			if ( not listFindNoCase(local.validValidations, arguments.validation, '^') ) {
				arguments.validation = '';
			};

			// SUBTYPE SETUP
			local.subType = application.classExtensionManager.getSubTypeBean();
			local.subType.setType("Page");
			local.subType.setSubType(variables.PackageName);
			local.subType.setSiteID(arguments.siteid);
			local.subType.setBaseTable("tcontent"); // if you don't set this, when deleting the plugin, the subType won't get updated!
			local.subType.setBaseKeyField("contentHistID");
			local.subType.load();
			local.subType.save();

			// EXTEND SET SETUP
			// upon creation of the new subType, an Extend Set called 'Default' is auto-magically created for you.
			// i don't see any need to maintain the 'Default' extend set since i'm creating my own custom one.
			local.extendSet = local.subType.getExtendSetByName('Default');
			local.extendSet.delete();

			// now, let's create a custom Class Extension Set (Extend Set) name
			local.extendSet = local.subType.getExtendSetByName(arguments.parentType);
			local.extendSet.setContainer(arguments.container);  // default, basic, custom
			local.extendSet.save();

			// ATTRIBUTE SETUP
			// create a new attribute for the Extend Set created above
			// getAttributeByName will look for the attribute and if it's not found, it will be created
			local.attribute = local.extendSet.getAttributeByName(arguments.name);
			local.attribute.setLabel(arguments.label);
			local.attribute.setHint(arguments.hint);
			local.attribute.setType(arguments.type);
			local.attribute.setDefaultValue(arguments.defaultValue);	
			local.attribute.setRequired(arguments.required);
			local.attribute.setValidation(arguments.validation);
			local.attribute.setRegex(arguments.regex);
			local.attribute.setMessage(arguments.message);
			local.attribute.setOptionList(arguments.optionList);
			local.attribute.setOptionLabelList(arguments.optionLabelList);
			local.attribute.setOrderNo(arguments.orderNo);
			local.attribute.save();
		</cfscript>
	</cffunction>

	<cffunction name="deleteSubType" returntype="any" access="private" output="false">
		<cfargument name="type" required="true" type="string" />
		<cfargument name="subType" required="true" type="string" />
		<cfscript>
			var local 		= structNew();
			local.rsSites 	= variables.config.getAssignedSites();
			local.subType 	= application.classExtensionManager.getSubTypeBean();
		</cfscript>		
		<cfloop query="local.rsSites">
			<cfscript>				
				local.subType.setType(arguments.type);
				local.subType.setSubType(arguments.subType);
				local.subType.setSiteID(local.rsSites.siteid);
				local.subType.load();
				local.subType.delete();
			</cfscript>
		</cfloop>
	</cffunction>

</cfcomponent>