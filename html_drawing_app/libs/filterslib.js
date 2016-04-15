//library for picture import, filters
//use this library to set ALL new variables that only these functions will use. 

//http://www.storminthecastle.com/2013/04/06/how-you-can-do-cool-image-effects-using-html5-canvas/
//reference to modular pattern: http://weblogs.asp.net/dwahlin/techniques-strategies-and-patterns-for-structuring-javascript-code-revealing-module-pattern

var img = new Image();
var openFile = (function(){
return function(c){
	var fileInput = document.querySelector("#fileInput");

	function onFileChange(e){
	var files = e.target.files;
	if(files && files.length>0) //if a file has been selected
	   c(files)//do some function (defined by c) to that file
	}
	fileInput.addEventListener("change", onFileChange, false);
	fileInput.click(); 
}
})();

//remember that this function will be passed an array containing the selected file(s)
function handleFile(files){
var file = files[0];
var imageType = /image.*/;
if(!file.type.match(imageType)){
	return;
}

var reader = new FileReader();

reader.onerror = function(e){
alert('Error code ' + e.target.error);
}

//Create a closure (notice modular pattern here) to capture file information
reader.onload = (function(file){  
	return function(evt){
		//attach the name of the file onto the webpage
		//set the img src to the file
		img.src = evt.target.result;
	}
})(file); 

reader.readAsDataURL(file);

//send the pic to the canvas
//note that the image has to load first! so do img.onload...
img.onload = function(){
context.drawImage(img, 0, 0, 600, 600); 
//reset the value for the HTML input file thing so that you can use the same pic for consecutive frames!  
document.querySelector("#fileInput").value = null;
}
}

//BEGIN FILTERS
//general filtering function. pass any kind of filter through this function.
//bind to onclick in html! 
function filterCanvas(filter){
var imgData = context.getImageData(0, 0, 600, 600);
filter(imgData);
context.putImageData(imgData, 0, 0);
}

//grayscale filter using an arithmetic average of the color components
//the 'pixels' parameter will be the imgData variable. 
function grayscale(pixels){
var d = pixels.data;
for (var i = 0; i < d.length; i += 4) {
      var r = d[i];
      var g = d[i + 1];
      var b = d[i + 2];
	  //the value obtained by (r+g+b)/3 will be the value assigned to d[i], d[i+1], and d[i+2].  
      d[i] = d[i + 1] = d[i + 2] = (r+g+b)/3;
    }
    return pixels;
};

//sepia filter
function sepia(pixels){
var d = pixels.data;
for (var i = 0;i < d.length; i += 4){
	var r = d[i];
	var g = d[i+1];
	var b = d[i+2];
	d[i] = (r*.5) + (g*.2) + (b*.3); //red
	d[i+1] = (r*.2) + (g*.3) + (b*.5); //green
	d[i+2] = (r*.6) + (g*.3) + (b*.4); //blue	
}
	return pixels;
};

//source: http://www.qoncious.com/questions/changing-saturation-image-html5-canvas-using-javascript
//saturation filter yay
function saturate(pixels){
	var saturationValue = 2.5;
	var d = pixels.data;
	var lumR = .3086 //constant for determining luminance of red
	var lumG = .6094 //constant for determining luminance of green
	var lumB = .0820 //constant for determining luminance of blue
	
	//one of these equations per r,g,b
	var r1 = (1 - saturationValue) * lumR + saturationValue;
	var g1 = (1 - saturationValue) * lumG + saturationValue;
    var b1 = (1 - saturationValue) * lumB + saturationValue;	
	
	//then one of these for each
	var r2 = (1 - saturationValue) * lumR;
	var g2 = (1 - saturationValue) * lumG;
    var b2 = (1 - saturationValue) * lumB;	
	
	for(var i = 0; i < d.length; i+=4){
		var r = d[i];
		var g = d[i+1];
		var b = d[i+2];
		
		d[i] = r*r1 + g*g2 + b*b2;
		d[i+1] = r*r2 + g*g1 + b*b2;
	    d[i+2] = r*r2 + g*g2 + b*b1;
	}
	return pixels;
}

//new kind of filter?
function swap(pixels){
	var d = pixels.data;
	for(var i=0;i<d.length;i+=4){
		var r = d[i];
		var g = d[i+1];
	    var b = d[i+2];
	
	d[i] = b;
	d[i+1] = r;
	d[i+2] = g
	}
	return pixels;
}

function banded(pixels){
	var d = pixels.data;
	for(var i=0; i<d.length;i+=12){
		var r = d[i];
		var g = d[i+1];
	    var b = d[i+2];
		
	d[i] = "#FFFFFF";
	d[i+1] = "#FFFFFF";
	d[i+2] = "#FFFFFF";
	}
}

function something(pixels){
	var d = pixels.data;
	for(var i=0; i<d.length;i++){
		var r = d[i];
		var g = d[i+1];
		var b = d[i+2];
		
		d[i+1] = b;
		d[i+2] = g;
		d[i] = r;
	}
	return pixels;
}

function purplizer(pixels){
	//aka purplefier - all pixels with green=red or green>red become purple
	var d = pixels.data;
		for(var i=0; i<d.length; i+=4){
				var r = d[i];
				var g = d[i+1];
				var b = d[i+2];
				var a = d[i+3];
		
		        if(g >= r){
					d[i+2] = d[i+2]*2;
					d[i+1] = d[i+2]/2;
				}
		/*
		for(j=0;j<5;j++){
				d[i] = d[((j*(pixels.width*4)) + (j*4)) + 2];
				d[i+1] = d[((j+2)*(pixels.width*4)) + ((j+1)*4)];
		}
		*/
	}
		
	return pixels;
}

function scary(pixels){
	var saturationValue = 2.5;
	var d = pixels.data;
	
	//making the lumR,G,andB values nearly the same is equivalent to blacking out the picture i.e. 255,255,255 = black
	var lumR = .6020//constant for determining luminance of red
	var lumG = .6094 //constant for determining luminance of green
	var lumB = .6086////constant for determining luminance of blue
	
	//one of these equations per r,g,b
	var r1 = (1 - saturationValue) * lumR + saturationValue;
	var g1 = (1 - saturationValue) * lumG + saturationValue;
    var b1 = (1 - saturationValue) * lumB + saturationValue;	
	
	//then one of these for each
	var r2 = (1 - saturationValue) * lumR;
	var g2 = (1 - saturationValue) * lumG;
    var b2 = (1 - saturationValue) * lumB;	
	
	for(var i = 0; i < d.length; i+=4){
		var r = d[i];
		var g = d[i+1];
		var b = d[i+2];
		
		d[i] = r*r1 + g*g2 + b*b2;
		d[i+1] = r*r2 + g*g1 + b*b2;
	    d[i+2] = r*r2 + g*g2 + b*b1;
	}
	return pixels;
}

function heatwave(pixels){
	var d = pixels.data;
	for(i=0;i<d.length;i++){
		var r = d[i];
		var g = d[i+1];
		var b = d[i+2];
		if(g > 100 && g < 200){
			d[i+1] = 0;
		}
		if(r < 100){
			d[i] = d[i]*2;
		}
	}
	return pixels;
}

//RESET PICTURE
function reset(){
	context.clearRect(0, 0, theCanvas.width, theCanvas.height);
	context.drawImage(img, 0, 0, 600, 600);
}





