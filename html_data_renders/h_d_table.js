/*
	render a html table from json data
	require d3;   
    
    last modified [20190507]: created
*/

function h_d_table(d){

	var cols = Object.keys(d);

	var rc = Object.values(d)[0].length;
	var rca = new Array(rc);

	var dd = Object.values(d);
	
	// create rows from d
	var rows = [];
	var ri = []; // add empty header placeholder
	for(var j = 0;j < cols.length; j++){
		ri.push(0);
	}
	rows.push(ri);
	

	for(var i = 0;i < rc; i++){
		var ri = [];
		for(var j = 0;j < cols.length; j++){
			ri.push(dd[j][i]);

		}
		rows.push(ri);
	}
	
	
	d3.select("table")
    	.append("tr");
	
	d3.select("table").select("tr").selectAll("th")
		.data(cols)
		.enter()
		.append("th").text(function(d){return d;})

	var tr = d3.select("table")
    	.selectAll("tr") 
    	.data(rows) 
    	.enter()
    	.append("tr")
    	.selectAll("td")
    	.data(function(r){return r;})
    	.enter()
    	.append("td").text(function(d){return d;});
  
}