#MuraGoogleMaps TM

##Please Note!!!
This was my first attempt at integrating Google Maps into Mura CMS. You might actually prefer to use the [MuraLocations](https://github.com/stevewithington/MuraLocations) plugin instead since it's actually much more integrated with Mura and has less calls to the Google Maps API.

One major difference between the two plugins is that this plugin uses either .CSV or .XML files whereas the [MuraLocations](https://github.com/stevewithington/MuraLocations) plugin has a special content type for locations which can actually make it easier to maintain in the long run.

##Purpose
A plugin for Mura CMS (www.getmura.com).
I will display one or more locations on a custom Google Map.
Directions to any of the locations will be available and have the option to disable.
Can accept either a properly formatted CSV file or XML file via uploaded file or URL!

##Instructions
After installing the plugin, create a new page in Mura CMS and change the type to 'Page / MuraGoogleMap'
Go the the 'Extended Attributes' tab and then complete the simple form there.
You can use the sample .csv and .xml files included in the 'samples' directory of the plugin.

##File Format Requirements

###.CSV file
* Header Row is REQUIRED and must contain 'LocationName,Lat,Lng,Address,Phone,InfoWindow,Zindex,Icon'
* Excel files (.xls, .xlsx, etc.) are NOT CSV files. You need to 'Save As' .CSV
* View the included 'samples/sample.csv' file for reference.

###.XML files
* All nodes must be present even if the value is empty.
* View the included 'samples/sample.xml' file for reference.

##Field Descriptions
Fields marked 'Optional' below may be left blank.
* LocationName: Required (String), Name or title of the location.
* Lat: _Optional_ (String), Latitude of the location. 
* Lng: _Optional_ (String), Longitude of the location.
* Address: _Optional_ (String), Address of the location (can be anywhere in the world or simply be a city, state, country, etc.)
* Phone: _Optional_ (string), Phone number of the location
* InfoWindow: _Optional_ (String), Content to display in the InfoWindow when an end-user clicks on the location icon/marker.
* ZIndex: _Optional_ (Integer), The stacking order of the Icons/Markers
* Icon: _Optional_ (String), The full URL to an icon to be used in lieu of the standard Google location marker. Preferably a .png file. If you copy and paste the URL into a browser, the file should display, if it doesn't, then the map won't be able to display it either.

###Important Notes
* If you do not supply a Lat and Lng, then an Address is needed! If you choose to supply the Lat and Lng, then the Address will be reverse-geo-coded and may not match exactly to what you might expect. You can supply all three fields if you wish.
* InfoWindow will be auto-generated if left blank and consist of the LocationName, Address and Phone. Otherwise, you can supply properly formatted HTML to be displayed in the InfoWindow.

##License
Copyright 2010-2012 Stephen J. Withington, Jr.

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this work except in compliance with the License. You may obtain a copy of the License in the LICENSE file, or at:

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.