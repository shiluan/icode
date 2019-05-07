/*
	create a tree view from data
    
    requires: d3
    
    reference:
	for styling list: https://learn.shayhowe.com/html-css/creating-lists/
    
    last modified [20190507]: created
*/

var dat = {
  getchildren(dt, k){
    var chd = [];
    for(var i =0; i < dt.length; i++){
      if(dt[i].p == k)
        chd.push(dt[i]);
    }
    return chd;
  },

  getroots(dt){
    var chd = [];
    for(var i = 0; i < dt.length; i++){
      if(dt[i].p == null)
        chd.push(dt[i]);
    }
    return chd;
  }
}

function hlist(tag,dd,odr='ul'){
	
	var dim1 = d3.select(tag)
               .append(odr)
               .selectAll("li")
               .data(dat.getroots(dd))
               .enter()
               .append("li")
               .attr("id", function(d,i){return d.k;})
               .text(function(d, i) { return d.t; })
			   ;

			   
	var dim2 = dim1.append(odr).selectAll("li").data(function(d, i) {
    return dat.getchildren(dd, d.k);
	}).enter()
	.append("li")
	//.attr("class","list-group-item")
	.attr("id", function(d,i){return d.t;})
	.text(function(d, i) { return d.t; });


	var dim3 = dim2.insert(odr).selectAll("li").data(function(d, i) {
		return dat.getchildren(dd,d.k);
	}).enter()
	.append("li")
	.attr("id", function(d,i){return d.t;})
	.text(function(d, i) { return d.t; });
}
