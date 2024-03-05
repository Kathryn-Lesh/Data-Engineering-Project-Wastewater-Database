
const renderData = () => {
  let choice = d3.select('#sites').node().value;

  console.log(choice);

  d3.json(`/api/v1.0/${choice}`).then(jsonData => {
    let val= jsonData.sewershed_pop[0];

    console.log(jsonData)

    var data = [
      {
        domain: { x: [0, 1], y: [0, 1] },
        value: val,
        title: { text: `<b> Sewershed Population for </b> <br> ${choice}` },
        type: "indicator",
        mode: "gauge+number",
        delta: { reference: 400 },
        gauge: { axis: { range: [null, val*1.4 ] } }
      }
    ];
    
    var layout = { width: 600, height: 400 };
    Plotly.newPlot('gauge', data, layout);
  })
}

const url='/api/full_data'

d3.json(url).then(jsonData=>{
    data = jsonData

    let { site_name } = jsonData;

    new Set(Object.values(site_name)).forEach(name => {
        // console.log(name)
        d3.select('#sites').append('option').text(name)
    })

    renderData();
})


const url2='/api/multi_query'

// d3.json(url2).then(jsonData=>{
//   data = jsonData
  
//   const table = d3.select('#first_plot').append('table');

//   // Append the header row
//   const thead = table.append('thead');
//   thead.append('tr')
//     .selectAll('th')
//     .data(['County Name', 'Median Age', 'Average Household Income', 'Dry Weight', 'Dry Weight LCI', 'Dry Weight UCI'])
//     .enter()
//     .append('th')
//     .text(header => header);

//   // Append the table body
//   const tbody = table.append('tbody');
//   const rows = tbody.selectAll('tr')
//     .data(data)
//     .enter()
//     .append('tr');

//   // Append the table cells
//   rows.each(function(d) {
//     const row = d3.select(this);
//     row.append('td').text(d.county_name);
//     row.append('td').text(d.median_age);
//     row.append('td').text(d.average_household_income);
//     row.append('td').text(d.dry_weight);
//     row.append('td').text(d.dry_weight_lci);
//     row.append('td').text(d.dry_weight_uci);
//   });

// // var values = [
// // ['County Name', 'Median Age', 'Average Household Income', 'Dry Weight', 'Dry Weight LCI', 'Dry Weight UCI'],
// // ];
    
// //     jsonData.forEach(row => {
// //         values.push([
// //             row.county_name,
// //             row.median_age,
// //             row.average_household_income,
// //             row.dry_weight,
// //             row.dry_weight_lci,
// //             row.dry_weight_uci
// //         ]);
// //     });
  
// //   var data = [{
// //     type: 'table',
// //     header: {
// //       values: [["<b>COUNTY NAME</b>"], ["<b>MEDIAN AGE</b>"],
// //            ["<b>HOUSEHOLD INCOME</b>"], ["<b>DRY WEIGHT</b>"], ["<b>Q4</b>"]],
// //       align: "center",
// //       line: {width: 1, color: 'black'},
// //       fill: {color: "grey"},
// //       font: {family: "Arial", size: 12, color: "white"}
// //     },
// //     cells: {
// //       values: values,
// //       align: "center",
// //       line: {color: "black", width: 1},
// //       font: {family: "Arial", size: 11, color: ["black"]}
// //     }
// //   }]
  
//   Plotly.newPlot('first_plot', data);
  
// })  

