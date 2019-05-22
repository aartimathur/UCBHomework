// from data.js
var tableData = data;

// YOUR CODE HERE!
// Get a reference to the table body
var tbody = d3.select("tbody");

console.log(data);

// Step 1 - Add data in data.js to a new table in the webpage. Used d3 to append table rows for each object in ufo sightings data and a cell for each value.

function init(){
    data.forEach(function(ufosightings) {
    console.log(ufosightings);
    var row = tbody.append("tr");
    
    Object.entries(ufosightings).forEach(function([key, value]) {
    console.log(key, value);
      var cell = tbody.append("td");
      cell.text(value);
      });
        
});

}

//Step 2 - Handler function to filter data in the table based on 'date' entered in an input field.


function handleClick() {
    // Prevent the form from refreshing the page
    d3.event.preventDefault();
    // Select the datetime value
    var date = d3.select("#datetime").property("value");
    // Set tableData as the value for filteredData, the basis of our replacement table
    let filteredData = tableData;
    // Check to see if a date was entered
    if (date) {
      // Filter the table data to the match date
      filteredData = filteredData.filter(row => row.datetime === date);
    }
    // Populate the new table based on the filtered data
    buildTable(filteredData);
  }
  
  // Step 3 - Attach an event listener to the form button
  d3.selectAll("#filter-btn").on("click", handleClick);
  
  // Populate the table upon initializing page
 init(tableData);

