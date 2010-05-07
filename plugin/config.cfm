<cfsilent>
<!---

This file is part of MuraGoogleMaps TM
(c) Stephen J. Withington, Jr. | www.stephenwithington.com

CAREFULLY READ THE ENCLOSED LICENSE AGREEMENT (plugin/license.htm). BY USING THIS SOFTWARE, YOU ARE CONSENTING TO BE BOUND BY AND ARE BECOMING A PARTY TO THIS AGREEMENT. IF YOU DO NOT AGREE TO ALL OF THE TERMS OF THIS AGREEMENT, THEN DO NOT USE THIS SOFTWARE, AND, IF APPLICABLE, RETURN THIS PRODUCT TO THE PLACE OF PURCHASE FOR A FULL REFUND.

--->
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