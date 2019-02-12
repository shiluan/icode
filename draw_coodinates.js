
class PixelCoods
{
this.xmax = 0;
this.xmin = 0;
this.ymax = 0;
this.ymin = 0;

}

class DataCoods
{
this.xmax = 0;
this.xmin = 0;
this.ymax = 0;
this.ymin = 0;

}

// scale = data_cood/pixel_cood
Function Scale(scale_x = 0.1, scale_y = 0.1)
{
this.xscale = scale_x;
this.yscale = scale_y;

this.to_pixel_x = (data_x) =>{
  return data_x/this.xscale;
};

this.to_pixel_y = (data_y) =>{
  return data_y/this.yscale;
};


return this;
}


class Function
{
this.npoints = 100;
this.xstart = 0;
this.xend = 0;

this.pointxs = [];
this.pointys = [];

this.make_func = ()=>{
  var step = (this.xend - this.xstart)/npoints;
  for(var i = 0; i<this.npoints; i++){
    this.pointxs[i] = this.xstart + i*step;
    this.pointys[i] = Math.Pow(this.pointxs[i],2);

  }
}; 

this.draw = (ctx)=>{
  var scale = Scale(0.1,0.1);
  
  ctx.beginPath();
  ctx.moveTo(scale.to_pixel_x(this.pointxs[i]), scale.to_pixel_y(this.pointys[i]));
  for(var i = 1; i<this.npoints; i++){
    ctx.lineTo(scale.to_pixel_x(this.pointxs[i]), scale.to_pixel_y(this.pointys[i]));
    
  }
  ctx.stroke();

};

}
