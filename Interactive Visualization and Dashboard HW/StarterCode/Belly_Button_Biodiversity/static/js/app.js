function buildMetadata(sample) {

    // Step 1 fetch the metadata for a sample. Use d3.json
    // Use `.html("") to clear any existing metadata
    // Use `Object.entries` to add each key and value pair to the panel. Hint: Inside the loop, you will need to use d3 to append new tags for each key-value in the metadata.
    
    var metadataSelector = d3.select('#sample-metadata');

    d3.json(`/metadata/${sample}`).then( data =>{
      metadataSelector.html("");
      console.log(Object.entries(data));
      Object.entries(data).forEach(([key,value]) =>{
        metadataSelector
          .append('p').text(`${key} : ${value}`)
          .append('hr')
      });
      })
}

    // BONUS: Build the Gauge Chart
    // buildGauge(data.WFREQ);

// Function for building pie chart 
function pieChart(data) {
    console.log(data);
    let labels = data.otu_ids.slice(0,10);
    let values = data.sample_values.slice(0,10);
    let hovertext = data.otu_labels.slice(0,10);

    let trace = [{
      values : values,
      labels : labels,
      name : "OTU IDs",
      type : "pie",
      textposition: "inside",
      hovertext : hovertext
    }];

    let layout = {
        title: '<b> Biodiversity in Sample </b>',
        plot_bgcolor: 'rgba(0, 0, 0, 0)',
        paper_bgcolor: 'rgba(0, 0, 0, 0)',
    };

    Plotly.newPlot('pie', trace , layout, {responsive: true});
}

// Function for building bubble chart 
function bubbleChart(data) {
  let x = data.otu_ids;
  let y = data.sample_values;
  let markersize = data.sample_values;
  let markercolors = data.otu_ids;
  let textvalues = data.otu_labels;

  let trace =[{
    x: x,
    y: y,
    mode: 'markers',
    marker: {
      size: markersize,
      color: markercolors,
    },
    text: textvalues,
    name: "OTU-ID"
  }];

  let layout ={
    title:"<b> Biodiversity in Sample </b>",
    xaxis: {
      title: 'OTU (Taxonomic) ID of Bacteria Found',
    },
    yaxis: {
      title: 'Total # of bacteria found in Selected Sample'
    },
    width:1100,
    plot_bgcolor: 'rgba(0, 0, 0, 0)',
    paper_bgcolor: 'rgba(0, 0, 0, 0)',
  };

  Plotly.newPlot('bubble', trace, layout, {responsive: true});
}

// Call functions to build pie chart and bubble chart
function buildCharts(sample) {
      d3.json(`/samples/${sample}`).then( data =>{
      // ## Pie Chart ##
      pieChart(data);
      // ## Bubble Chart ##
      bubbleChart(data);
    });
    
}

function init() {
  // Grab a reference to the dropdown select element
  var selector = d3.select("#selDataset");

  // Use the list of sample names to populate the select options
  d3.json("/names").then((sampleNames) => {
    sampleNames.forEach((sample) => {
      selector
        .append("option")
        .text(sample)
        .property("value", sample);
    });

// Use the first sample from the list to build the initial plots
    const firstSample = sampleNames[0];
    buildCharts(firstSample);
    buildMetadata(firstSample);
  });
}

function optionChanged(newSample) {
  // Fetch new data each time a new sample is selected
  buildCharts(newSample);
  buildMetadata(newSample);
}

// Initialize the dashboard
init();
