<cfoutput><plugin>
<!---

This file is part of MuraGoogleMaps TM
(c) Stephen J. Withington, Jr. | www.stephenwithington.com

CAREFULLY READ THE ENCLOSED LICENSE AGREEMENT (plugin/license.htm). BY USING THIS SOFTWARE, YOU ARE CONSENTING TO BE BOUND BY AND ARE BECOMING A PARTY TO THIS AGREEMENT. IF YOU DO NOT AGREE TO ALL OF THE TERMS OF THIS AGREEMENT, THEN DO NOT USE THIS SOFTWARE, AND, IF APPLICABLE, RETURN THIS PRODUCT TO THE PLACE OF PURCHASE FOR A FULL REFUND.

--->
	<name>MuraGoogleMaps</name>
	<package>MuraGoogleMaps</package>
	<version>0.5-Alpha</version>
	<provider>Steve Withington</provider>
	<providerURL>http://stephenwithington.com</providerURL>
	<category>Application</category>
	<settings>
		<!---<setting>
			<name></name>
			<label></label>
			<hint></hint>
			<type>TextBox</type>
			<required>true</required>
			<validation></validation>
			<regex></regex>
			<message></message>
			<defaultvalue></defaultvalue>
			<optionlist></optionlist>
			<optionlabellist></optionlabellist>
		</setting>--->
	</settings>
	<eventHandlers>
		<eventHandler event="onApplicationLoad" component="eventHandlers.EventHandlers" persist="false" />
	</eventHandlers>
	<displayobjects location="global" />
</plugin></cfoutput>