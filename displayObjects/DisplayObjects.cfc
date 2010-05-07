<!---

This file is part of MuraGoogleMaps TM
(c) Stephen J. Withington, Jr. | www.stephenwithington.com

CAREFULLY READ THE ENCLOSED LICENSE AGREEMENT (plugin/license.htm). BY USING THIS SOFTWARE, YOU ARE CONSENTING TO BE BOUND BY AND ARE BECOMING A PARTY TO THIS AGREEMENT. IF YOU DO NOT AGREE TO ALL OF THE TERMS OF THIS AGREEMENT, THEN DO NOT USE THIS SOFTWARE, AND, IF APPLICABLE, RETURN THIS PRODUCT TO THE PLACE OF PURCHASE FOR A FULL REFUND.

--->
<cfcomponent extends="mura.plugin.pluginGenericEventHandler">

	<cffunction name="dspMuraGoogleMap" access="public" output="false" returntype="any">
		<cfargument name="$" required="true" />
		<cfreturn $.event().muraGoogleMaps.dspMuraGoogleMaps() />
	</cffunction>

</cfcomponent>