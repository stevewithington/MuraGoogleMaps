<cfcomponent output="false">

<cffunction name="init" output="false" returntype="any" access="public">
	<cfreturn this />
</cffunction>

<cffunction name="getLatLng" output="false" returntype="any">
	<cfargument name="address" required="true" hint="Address" />
	<cfscript>
		var local = {};
		local.result = '';
		if ( structKeyExists(arguments, 'address') ) {
			local.qry = googleGeoCoder(address=arguments.address);
			if ( local.qry.recordcount ) {
				local.result = local.qry.latitude & ',' & local.qry.longitude;
			};
		};
		return local.result;
	</cfscript>
</cffunction>

<cffunction name="getAddress" output="false" returntype="any">
	<cfargument name="latlng" required="true" hint="Latitute,Longitude" />
	<cfscript>
		var local = {};
		local.result = '';
		if ( structKeyExists(arguments, 'latlng') ) {
			local.qry = googleGeoCoder(latlng=arguments.latlng);
			if ( local.qry.recordcount ) {
				local.result = local.qry.formatted_address;
			};
		};
		return local.result;
	</cfscript>
</cffunction>

<cffunction name="googleGeoCoder" returntype="query" access="public">
	<cfargument name="address" required="false" type="string" default="">
	<cfargument name="latlng" required="false" type="string" default="">
	<cfargument name="language" required="false" type="string" default="">
	<cfargument name="bounds" required="false" type="string" default="">
	<cfargument name="region" required="false" type="string" default="">
	<cfargument name="sensor" required="false" type="boolean" default="false">
	<cfargument name="ShowDetails" required="false" type="boolean" default="false">
	<cfif arguments.ShowDetails>
		<cfset variables.geocode_query = QueryNew("Status, Result_Type, Formatted_Address, Address_Type, Address_Long_Name, Address_Short_Name, Latitude, Longitude, Location_Type, Southwest_Lat, Southwest_Lng, Northeast_Lat, Northeast_Lng", "varchar, varchar, varchar, varchar, varchar, varchar, varchar, varchar, varchar, varchar, varchar, varchar, varchar")>
		<cfelse>
		<cfset variables.geocode_query = QueryNew("Status, Result_Type, Formatted_Address, Latitude, Longitude, Location_Type", "varchar, varchar, varchar, varchar, varchar, varchar")>
	</cfif>
	<cfif len(trim(arguments.address)) is 0 and len(trim(arguments.latlng)) is 0>
		<cfset variables.temp = QueryAddRow(variables.geocode_query, 1)>
		<cfset variables.temp = QuerySetCell(variables.geocode_query, "Status", "Please pass in either the address or the latitude and lautitude.")>
	<cfelse>
		<cfset variables.base_url = "http://maps.google.com/maps/api/geocode/xml?">
		<cfif len(trim(arguments.address)) is not 0>
			<cfset variables.address_string = urlEncodedFormat(arguments.address)>
			<cfset variables.final_url = variables.base_url & "address=" & variables.address_string>
		<cfelse>
			<cfset variables.latlng_string = Replace(arguments.latlng, " ", "", "all")>
			<cfset variables.final_url = variables.base_url & "latlng=" & variables.latlng_string>
		</cfif>
		<cfset variables.final_url = variables.final_url & "&sensor=" & arguments.sensor>
		<cfif len(trim(arguments.language)) is not 0>
			<cfset variables.final_url = variables.final_url & "&language=" & arguments.language>
		</cfif>
		<cfif len(trim(arguments.bounds)) is not 0>
			<cfset variables.final_url = variables.final_url & "&bounds=" & arguments.bounds>
		</cfif>
		<cfif len(trim(arguments.region)) is not 0>
			<cfset variables.final_url = variables.final_url & "&region=" & arguments.region>
		</cfif>
		<cfhttp url="#variables.final_url#" result="variables.resultxml" />
		<cfset variables.parsed_result = xmlParse(variables.resultxml.fileContent)>
		<cfset variables.total_count = 1>
		<cfset variables.temp = QueryAddRow(variables.geocode_query, 1)>
		<cfset variables.temp = QuerySetCell(variables.geocode_query, "Status", variables.parsed_result.GeocodeResponse.status.xmltext)>
		<cfset variables.result_status = variables.parsed_result.GeocodeResponse.status.xmltext>
		<cfif StructKeyExists(variables.parsed_result.GeocodeResponse, "result")>
			<cfloop from="1" to="#ArrayLen(variables.parsed_result.GeocodeResponse.result)#" index="counter">
				<cfset variables.type_list = "">
				<cfloop from="1" to="#ArrayLen(variables.parsed_result.GeocodeResponse.result[counter].type)#" index="type_counter">
					<cfif len(variables.type_list) is 0>
						<cfset variables.type_list = variables.parsed_result.GeocodeResponse.result[counter].type[type_counter].xmltext>
						<cfelse>
						<cfset variables.type_list = variables.type_list & "," & variables.parsed_result.GeocodeResponse.result[counter].type[type_counter].xmltext>
					</cfif>
				</cfloop>
				<cfif variables.total_count is not 1>
					<cfset variables.temp = QuerySetCell(variables.geocode_query, "Status", variables.parsed_result.GeocodeResponse.status.xmltext, variables.total_count)>
				</cfif>
				<cfset variables.address = variables.parsed_result.GeocodeResponse.result[counter].Formatted_Address.xmltext>
				<cfset variables.lat = variables.parsed_result.GeocodeResponse.result[counter].geometry.location.lat.xmltext>
				<cfset variables.lng = variables.parsed_result.GeocodeResponse.result[counter].geometry.location.lng.xmltext>
				<cfset variables.loc_type = variables.parsed_result.GeocodeResponse.result[counter].geometry.location_type.xmltext>
				<cfset variables.temp = QuerySetCell(variables.geocode_query, "Result_Type", variables.type_list, variables.total_count)>
				<cfset variables.temp = QuerySetCell(variables.geocode_query, "Formatted_Address", variables.address, variables.total_count)>
				<cfset variables.temp = QuerySetCell(variables.geocode_query, "Latitude", variables.lat, variables.total_count)>
				<cfset variables.temp = QuerySetCell(variables.geocode_query, "Longitude", variables.lng, variables.total_count)>
				<cfset variables.temp = QuerySetCell(variables.geocode_query, "Location_Type", variables.loc_type, variables.total_count)>
				<cfif arguments.ShowDetails>
					<cfset variables.southwest_lat = variables.parsed_result.GeocodeResponse.result[counter].geometry.viewport.southwest.lat.xmltext>
					<cfset variables.southwest_lng = variables.parsed_result.GeocodeResponse.result[counter].geometry.viewport.southwest.lng.xmltext>
					<cfset variables.northeast_lat = variables.parsed_result.GeocodeResponse.result[counter].geometry.viewport.northeast.lat.xmltext>
					<cfset variables.northeast_lng = variables.parsed_result.GeocodeResponse.result[counter].geometry.viewport.northeast.lng.xmltext>
					<cfloop from="1" to="#ArrayLen(variables.parsed_result.GeocodeResponse.result[counter].address_component)#" index="address_counter">
						<cfif address_counter is not 1>
							<cfset variables.temp = QuerySetCell(variables.geocode_query, "Status", variables.result_status, variables.total_count)>
							<cfset variables.temp = QuerySetCell(variables.geocode_query, "Formatted_Address", variables.address, variables.total_count)>
							<cfset variables.temp = QuerySetCell(variables.geocode_query, "Latitude", variables.lat, variables.total_count)>
							<cfset variables.temp = QuerySetCell(variables.geocode_query, "Longitude", variables.lng, variables.total_count)>
							<cfset variables.temp = QuerySetCell(variables.geocode_query, "Result_Type", variables.type_list, variables.total_count)>
							<cfset variables.temp = QuerySetCell(variables.geocode_query, "Location_Type", variables.loc_type, variables.total_count)>
						</cfif>
						<cfset variables.temp = QuerySetCell(variables.geocode_query, "Southwest_Lat", variables.southwest_lat, variables.total_count)>
						<cfset variables.temp = QuerySetCell(variables.geocode_query, "Southwest_Lng", variables.southwest_lng, variables.total_count)>
						<cfset variables.temp = QuerySetCell(variables.geocode_query, "Northeast_Lat", variables.northeast_lat, variables.total_count)>
						<cfset variables.temp = QuerySetCell(variables.geocode_query, "Northeast_Lng", variables.northeast_lng, variables.total_count)>
						<cfset variables.address_type = variables.parsed_result.GeocodeResponse.result[counter].address_component[address_counter].type.xmltext>
						<cfset variables.address_short_name = variables.parsed_result.GeocodeResponse.result[counter].address_component[address_counter].short_name.xmltext>
						<cfset variables.address_long_name = variables.parsed_result.GeocodeResponse.result[counter].address_component[address_counter].long_name.xmltext>
						<cfset variables.temp = QuerySetCell(variables.geocode_query, "Address_Type", variables.address_type, variables.total_count)>
						<cfset variables.temp = QuerySetCell(variables.geocode_query, "Address_Long_Name", variables.address_long_name, variables.total_count)>
						<cfset variables.temp = QuerySetCell(variables.geocode_query, "Address_Short_Name", variables.address_short_name, variables.total_count)>
						<cfif address_counter lt ArrayLen(variables.parsed_result.GeocodeResponse.result[counter].address_component)>
							<cfset variables.temp = QueryAddRow(variables.geocode_query, 1)>
							<cfelse>
							<cfif counter lt ArrayLen(variables.parsed_result.GeocodeResponse.result)>
								<cfset variables.temp = QueryAddRow(variables.geocode_query, 1)>
							</cfif>
						</cfif>
						<cfset variables.total_count = variables.total_count + 1>
					</cfloop>
					<cfelse>
					<cfset variables.total_count = variables.total_count + 1>
					<cfif counter lt ArrayLen(variables.parsed_result.GeocodeResponse.result)>
						<cfset variables.temp = QueryAddRow(variables.geocode_query, 1)>
					</cfif>
				</cfif>
			</cfloop>
		</cfif>
	</cfif>
	<cfreturn variables.geocode_query>
</cffunction>
</cfcomponent>