// Store our API endpoint inside queryUrl
var queryUrl = "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson";


// Perform a GET request to the query URL
d3.json(queryUrl, function(quakeData) {
  // Once we get a response, send the data.features object to the createFeatures function
  createFeatures(quakeData.features);
  console.log(quakeData);
});


// Define a function we want to run once for each feature in the features array
// Give each feature a popup describing the magnitude, place and time of the earthquake
function onEachFeature(feature, layer) {
    layer.bindPopup(
        "<strong><h2>Magnitude: " + feature.properties.mag + "</h2></strong><hr>" +
        "<p>" + feature.properties.place + "</p>" + 
        "<p>" + new Date(feature.properties.time).toLocaleString('en-US',{timeZoneName: "short"}) + "</p>"
      );
  }

function createFeatures(earthquakeData){
// Create a GeoJSON layer containing the features array on the earthquakeData object
  // Run the onEachFeature function once for each piece of data in the array
  var earthquakes = L.geoJSON(earthquakeData, {
      pointToLayer: createCircleMarker,
      onEachFeature: onEachFeature
  });    

 // Sending our earthquakes layer to the createMap function
  createMap(earthquakes);
}


// Create a map object
function createMap(earthquakes) {

  // Define streetmap and darkmap layers
  var streetmap = L.tileLayer("https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token={accessToken}", {
    attribution: "Map data &copy; <a href=\"https://www.openstreetmap.org/\">OpenStreetMap</a> contributors, <a href=\"https://creativecommons.org/licenses/by-sa/2.0/\">CC-BY-SA</a>, Imagery © <a href=\"https://www.mapbox.com/\">Mapbox</a>",
    maxZoom: 18,
    id: "mapbox.streets",
    accessToken: API_KEY
  });

  var darkmap = L.tileLayer("https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token={accessToken}", {
    attribution: "Map data &copy; <a href=\"https://www.openstreetmap.org/\">OpenStreetMap</a> contributors, <a href=\"https://creativecommons.org/licenses/by-sa/2.0/\">CC-BY-SA</a>, Imagery © <a href=\"https://www.mapbox.com/\">Mapbox</a>",
    maxZoom: 18,
    id: "mapbox.dark",
    accessToken: API_KEY
  });

  // Define a baseMaps object to hold our base layers
  var baseMaps = {
    "Street Map": streetmap,
    "Dark Map": darkmap
  };

  // Create overlay object to hold our overlay layer
  var overlayMaps = {
    Earthquakes: earthquakes
  };

  // Create our map, giving it the streetmap and earthquakes layers to display on load
  var myMap = L.map("map", {
    center: [37.09, -95.71],
    zoom: 2,
    layers: [streetmap, earthquakes]
  });

  // Create a layer control
  // Pass in our baseMaps and overlayMaps
  // Add the layer control to the map
  L.control.layers(baseMaps, overlayMaps, {
    collapsed: false
  }).addTo(myMap);
    
}


// Function that will use 'magnitude' for creating different sized and color circle markers for each earthquake
function createCircleMarker(feature, latlng) {
    var color = d3.interpolateHsl("red", "blue")(feature.properties.mag*4);
     
    let options = {
        radius: (feature.properties.mag*4),
        fillColor: color,
        color: color,
        weight: 1,
        opacity: 1,
        fillOpacity: .75
    }
  return L.circleMarker( latlng, options );
}
