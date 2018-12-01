var account = {
  "chq": {
    "cibc": 100,
    "tng":100
  },

  "sav":{
    "tng":100
  },

  "rsp":{
    "tng":100,
    "cibc":{
      "shi": 100,
      "lu": 100
    } ,
    "questrade": 100
  },

  "tfsa": {
    "tng": {
      "shi": 100,
      "lu" : 100
    }
  }
}


// render.1 -> <div id='account_1'>
/*
$(document).ready(
  function(){
    //$('#account_1').html('test_result');
  }
);*/

// without jQuery
document.addEventListener('DOMContentLoaded', function () {
    document.getElementById("account_1").innerHTML = "whatever";
  }
});

