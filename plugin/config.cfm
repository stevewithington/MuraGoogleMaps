<cfsilent>
<cfscript>
/**
* 
* This file is part of MuraGoogleMaps TM
*
* Copyright 2010-2013 Stephen J. Withington, Jr.
* Licensed under the Apache License, Version v2.0
* http://www.apache.org/licenses/LICENSE-2.0
*
*/
</cfscript>
<cfif not structKeyExists(request,"pluginConfig")>
	<cfset pluginID=listLast(listGetat(getDirectoryFromPath(getCurrentTemplatePath()),listLen(getDirectoryFromPath(getCurrentTemplatePath()),application.configBean.getFileDelim())-1,application.configBean.getFileDelim()),"_")>
	<cfset request.pluginConfig=application.pluginManager.getConfig(pluginID)>
	<cfset request.pluginConfig.setSetting("pluginMode","Admin")/>
</cfif>

<cfif request.pluginConfig.getSetting("pluginMode") eq "Admin" and not isUserInRole('S2')>
	<cfif not structKeyExists(session,"siteID") or not application.permUtility.getModulePerm(request.pluginConfig.getValue('moduleID'),session.siteid)>
		<cflocation url="#application.configBean.getContext()#/admin/" addtoken="false" />
	</cfif>
</cfif></cfsilent>