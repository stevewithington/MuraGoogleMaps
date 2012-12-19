<cfscript>
/**
* 
* This file is part of MuraGoogleMaps TM
*
* Copyright 2010-2012 Stephen J. Withington, Jr.
* Licensed under the Apache License, Version v2.0
* http://www.apache.org/licenses/LICENSE-2.0
*
*/
</cfscript>
<cfinclude template="plugin/config.cfm" />
<cfsavecontent variable="body">
	<cfoutput>
		<h2>#request.pluginConfig.getName()#</h2>
		<p><em>Version: #request.pluginConfig.getVersion()#<br />
		Author: <a href="http://stephenwithington.com" target="_blank">Steve Withington</a></em></p>

		<div id="readme">
			<pre>
				<cfinclude template="README.md" />
			</pre>
		</div>
		
		<h3>Issues &amp; Improvements</h3>
		<p>This plugin is managed on Github at <a href="https://github.com/stevewithington/MuraGoogleMaps" target="_blank">https://github.com/stevewithington/MuraGoogleMaps</a>. Please submit any issues at <a href="https://github.com/stevewithington/MuraGoogleMaps/issues" target="_blank">https://github.com/stevewithington/MuraGoogleMaps/issues</a>.</p>
	</cfoutput>
</cfsavecontent>
<cfoutput>
	#application.pluginManager.renderAdminTemplate(body=body,pageTitle=request.pluginConfig.getName())#
</cfoutput>