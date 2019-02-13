function PixelCoods()
{
this.xmax = 0.5*canvas.width;
this.xmin = -0.5*canvas.width;
this.ymax = 0.5*canvas.height;
this.ymin = -0.5*canvas.height;
return this;
}

function DataCoods(xmin=0, xmax=1, ymin=0, ymax=1)
{
this.xmax = xmax;
this.xmin = xmin;
this.ymax = ymax;
this.ymin = ymin;
return this;
}

// scale = data_cood/pixel_cood
function Scale()
{
let pc = new PixelCoods();
let dc = new DataCoods();


this.xscale = (dc.xmax-dc.xmin)/(pc.xmax-pc.xmin);
this.yscale = (dc.ymax-dc.ymin)/(pc.ymax-pc.ymin);


this.to_pixel_x = (data_x) =>{
  return data_x/this.xscale;
};

this.to_pixel_y = (data_y) =>{
  return data_y/this.yscale;
};


return this;
}


function MakeFunction()
{
this.npoints = 100;
this.xstart = 0;
this.xend = 1;


this.pointxs = [];
this.pointys = [];

this.make_func = ()=>{
  var step = (this.xend - this.xstart)/npoints;
  for(var i = 0; i<this.npoints; i++){
    this.pointxs[i] = this.xstart + i*step;
    this.pointys[i] = Math.pow(this.pointxs[i],2);

  }
  return this;
}; 

this.draw = (ctx)=>{
  var scale = Scale();
  
ctx.save();
ctx.translate(300,225);

  ctx.beginPath();
  ctx.moveTo(scale.to_pixel_x(this.pointxs[0]), scale.to_pixel_y(this.pointys[0]));
  for(var i = 1; i<this.npoints; i++){
    ctx.lineTo(scale.to_pixel_x(this.pointxs[i]), scale.to_pixel_y(this.pointys[i]));
    
  }
  ctx.stroke();
ctx.restore();

};

return this;

}
