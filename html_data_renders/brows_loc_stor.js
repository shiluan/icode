// interface for local data repository

const err_msg = "Sorry, your browser does not support Web	Storage...";
const div = ',';

var browser_loc_stor = {}

browser_loc_stor.support = function(){
	return typeof(Storage!== "undefined");
}

//set
browser_loc_stor.set = function(k,v){
	if (this.support()) {
    	localStorage.setItem(k, v);
  	} else {
    	alert(err_msg);
	}
}

//add
browser_loc_stor.add = function(k,v){
	
	if (this.support()) {
    	let cur = localStorage.getItem(k);
    	if (cur==undefined)
    		localStorage.setItem(k, v);
    	else 
    		localStorage.setItem(k, cur+div+v);
  	} else {
    	alert(err_msg);
	}
}


//clear
browser_loc_stor.clear = function(k){
  
  	if (this.support()) {
    	localStorage.setItem(k, null);
  	} else {
    	alert(err_msg);
	}
}

//get
browser_loc_stor.get = function(k){
  
  	if (this.support()) {
    	return localStorage.getItem(k);
  	} else {
    	alert(err_msg);
	}
}
