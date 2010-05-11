<!---

This file is part of MuraGoogleMaps TM
(c) Stephen J. Withington, Jr. | www.stephenwithington.com

CAREFULLY READ THE ENCLOSED LICENSE AGREEMENT (plugin/license.htm). BY USING THIS SOFTWARE, YOU ARE CONSENTING TO BE BOUND BY AND ARE BECOMING A PARTY TO THIS AGREEMENT. IF YOU DO NOT AGREE TO ALL OF THE TERMS OF THIS AGREEMENT, THEN DO NOT USE THIS SOFTWARE, AND, IF APPLICABLE, RETURN THIS PRODUCT TO THE PLACE OF PURCHASE FOR A FULL REFUND.

--->
<cfinclude template="plugin/config.cfm" />
<cfsilent>
	<cfscript>
		webRoot = request.pluginConfig.getConfigBean().getWebRoot();
		fileObj = createObject('java','java.io.File');
		fileDelim = fileObj.separator;
		fullPluginDir = listChangeDelims(request.pluginConfig.getConfigBean().getPluginDir(), '/', fileDelim);
		absolutePluginDir = removeChars(fullPluginDir, 1, len(webRoot));
		pluginDir = absolutePluginDir & '/' & request.pluginConfig.getDirectory() & '/';
		eventHandlersPath = listChangeDelims(pluginDir, '.', '/') & '.eventHandlers.EventHandlers';
		obj = createObject('component', eventHandlersPath);
	</cfscript>
</cfsilent>
<cfsavecontent variable="body">
	<cfoutput>
		<h2>#request.pluginConfig.getName()#</h2>
		<p><em>Version: #request.pluginConfig.getVersion()#<br />
		Author: <a href="http://stephenwithington.com" target="_blank">Steve Withington</a></em></p>
		
		<cfdump var="#obj#" label="eventHandlers obj" />
		
		<h3>Need help?</h3>
		<p>Catch me on the <a href="http://www.getmura.com/forum/" target="_blank">Mura CMS forums</a>, contact me through my site at <a href="http://www.stephenwithington.com" target="_blank">www.stephenwithington.com</a>, or via email at steve [at] stephenwithington [dot] com.</p>
		<p>Cheers!</p>
	</cfoutput>
</cfsavecontent>
<cfoutput>
	#application.pluginManager.renderAdminTemplate(body=body,pageTitle=request.pluginConfig.getName())#
</cfoutput>