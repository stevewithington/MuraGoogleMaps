<cfoutput><plugin>
<!---

This file is part of MuraGoogleMaps TM
(c) Stephen J. Withington, Jr. | www.stephenwithington.com

CAREFULLY READ THE ENCLOSED LICENSE AGREEMENT (plugin/license.htm). BY USING THIS SOFTWARE, YOU ARE CONSENTING TO BE BOUND BY AND ARE BECOMING A PARTY TO THIS AGREEMENT. IF YOU DO NOT AGREE TO ALL OF THE TERMS OF THIS AGREEMENT, THEN DO NOT USE THIS SOFTWARE, AND, IF APPLICABLE, RETURN THIS PRODUCT TO THE PLACE OF PURCHASE FOR A FULL REFUND.

--->
	<name>MuraGoogleMaps</name>
	<package>MuraGoogleMaps</package>
	<version>0.1-Alpha</version>
	<provider>Steve Withington</provider>
	<providerURL>http://stephenwithington.com</providerURL>
	<category>Application</category>
	<settings>
		<setting>
			<name>mapFile</name>
			<label>XML or CSV file:</label>
			<hint>Please see the README.txt file for file format requirements.</hint>
			<type>File</type>
			<required>false</required>
			<validation></validation>
			<regex></regex>
			<message></message>
			<defaultvalue></defaultvalue>
			<optionlist></optionlist>
			<optionlabellist></optionlabellist>
		</setting>
	</settings>
	<eventHandlers>
		<eventHandler event="onApplicationLoad" component="eventHandlers.EventHandlers" persist="false" />
	</eventHandlers>
	<displayobjects location="global">
		<displayobject name="MuraGoogleMap" displaymethod="dspMuraGoogleMap" component="displayObjects.DisplayObjects" persist="false" />
	</displayobjects>
</plugin></cfoutput>