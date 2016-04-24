var canvas;
var gl;
var mvMatrix;
var cubeVerticesBuffer;
var cubeVertexIndicesBuffer;
var squareVerticesColorBuffer;
var shaderProgram;
var vertexColorAttribute;
var vertexPositionAttribute;
var perspectiveMatrix;
var fragmentShader;
var vertexShader;

var cubeVerticesColorBuffer;
var cubeRotation = 0.0;

//for animating square
var curX = 1.0;
var curY = 0.0;
var curZ = 1.0;

var lastSquareUpdateTime = 0.0;
var squareXOffset = 0.0;
var squareYOffset = 0.0;
var squareZOffset = 0.0;	
var xIncValue = 0.2;
var yIncValue = -0.8;
var zIncValue = 0.6;

function start(){
	canvas = document.getElementById("glCanvas");
	
	//initialize the GL context
	initWebGL(canvas);
	
	//continue only if WebGL works
	if(gl){
	gl.clearColor(0.0, 0.0, 0.0, 1.0);
	gl.enable(gl.DEPTH_TEST);
	gl.depthFunc(gl.LEQUAL);
	
	initShaders();
	
	initBuffer();
	
	setInterval(drawScene, 15);
	}
}

function initWebGL(yourCanvas){
	gl = null;
	
	try{
		gl = canvas.getContext("webgl") || canvas.getContext("experimental-webgl");
	}catch(e){}
	
	if(!gl){
	alert("Unable to initialize WebGL. Your browser may not support it.");
    gl = null;
	}
	
	return gl;
}

function initShaders(){
	vertexShader = getShader(gl, "shader-vs");
	fragmentShader = getShader(gl, "shader-fs");
	
	//create shader program
	shaderProgram = gl.createProgram(); 
	gl.attachShader(shaderProgram, vertexShader);
	gl.attachShader(shaderProgram, fragmentShader);
	gl.linkProgram(shaderProgram);

	//if creating shader program fails
	if(!gl.getProgramParameter(shaderProgram, gl.LINK_STATUS)){
	alert("unable to initialize shader program");
	}
	
	gl.useProgram(shaderProgram);
	
	//for the color
	vertexColorAttribute = gl.getAttribLocation(shaderProgram, "aVertexColor");
	
	//for the pixels
	vertexPositionAttribute = gl.getAttribLocation(shaderProgram, "aVertexPosition");
	
	gl.enableVertexAttribArray(vertexColorAttribute);
	gl.enableVertexAttribArray(vertexPositionAttribute);
	}

//create object (a square)
//var horizAspect = 600.0/600.0; //change to your dimensions

function initBuffer(){
	cubeVerticesBuffer = gl.createBuffer();
	gl.bindBuffer(gl.ARRAY_BUFFER, cubeVerticesBuffer);
	
	var vertices = [
	 // Front face
  -1.0, -1.0,  1.0,
   1.0, -1.0,  1.0,
   1.0,  1.0,  1.0,
  -1.0,  1.0,  1.0,
  
  // Back face
  -1.0, -1.0, -1.0,
  -1.0,  1.0, -1.0,
   1.0,  1.0, -1.0,
   1.0, -1.0, -1.0,
  
  // Top face
  -1.0,  1.0, -1.0,
  -1.0,  1.0,  1.0,
   1.0,  1.0,  1.0,
   1.0,  1.0, -1.0,
  
  // Bottom face
  -1.0, -1.0, -1.0,
   1.0, -1.0, -1.0,
   1.0, -1.0,  1.0,
  -1.0, -1.0,  1.0,
  
  // Right face
   1.0, -1.0, -1.0,
   1.0,  1.0, -1.0,
   1.0,  1.0,  1.0,
   1.0, -1.0,  1.0,
  
  // Left face
  -1.0, -1.0, -1.0,
  -1.0, -1.0,  1.0,
  -1.0,  1.0,  1.0,
  -1.0,  1.0, -1.0
	];
	
	gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(vertices), gl.STATIC_DRAW);
	
  var colors = [
    [1.0,  1.0,  1.0,  1.0],    // Front face: white
    [1.0,  0.0,  0.0,  1.0],    // Back face: red
    [0.0,  1.0,  0.0,  1.0],    // Top face: green
    [0.0,  0.0,  1.0,  1.0],    // Bottom face: blue
    [1.0,  1.0,  0.0,  1.0],    // Right face: yellow
    [1.0,  0.0,  1.0,  1.0]     // Left face: purple
  ];
	
	
	var generatedColors = [];

  for (j=0; j<6; j++) {
    var c = colors[j];

    // Repeat each color four times for the four vertices of the face

    for (var i=0; i<4; i++) {
      generatedColors = generatedColors.concat(c);
    }
  }

  cubeVerticesColorBuffer = gl.createBuffer();
  gl.bindBuffer(gl.ARRAY_BUFFER, cubeVerticesColorBuffer);
  gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(generatedColors), gl.STATIC_DRAW);
	
	//buffer for vertex indices
	cubeVertexIndicesBuffer = gl.createBuffer();
	gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, cubeVertexIndicesBuffer);
	
	var cubeVertexIndices = [
	  0,  1,  2,      0,  2,  3,    // front
	  4,  5,  6,      4,  6,  7,    // back
	  8,  9,  10,     8,  10, 11,   // top
	 12, 13, 14,     12, 14, 15,   // bottom
	 16, 17, 18,     16, 18, 19,   // right
	 20, 21, 22,     20, 22, 23    // left
	];
	
	gl.bufferData(gl.ELEMENT_ARRAY_BUFFER, new Uint16Array(cubeVertexIndices), gl.STATIC_DRAW);
	
}
	
function getShader(gl, id){
	var shaderScript,
		theSource,
		currentChild,
		shader;
		
	shaderScript = document.getElementById(id);
	//console.log(shaderScript);
	if(!shaderScript){
		return null;
	}
	
	theSource = "";
	currentChild = shaderScript.firstChild;
	
	while(currentChild){
		
		if(currentChild.nodeType == 3){
				theSource += currentChild.textContent;
		}
		
		currentChild = currentChild.nextSibling;
	}

if(shaderScript.type == "x-shader/x-fragment"){
	shader = gl.createShader(gl.FRAGMENT_SHADER);
}else if(shaderScript.type == "x-shader/x-vertex"){
	shader = gl.createShader(gl.VERTEX_SHADER);
}else{
	return null;
}
//console.log(theSource);
gl.shaderSource(shader, theSource);
gl.compileShader(shader);

if(!gl.getShaderParameter(shader, gl.COMPILE_STATUS)){
	alert("An error occurred. sorry :(");
	return null;
}

return shader;
}


//now actually draw the object on canvas
function drawScene(){

	gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
	
	//only objects from between .1 and 100 units away from the camera to be rendered. field of view = 45 degrees.
	perspectiveMatrix = makePerspective(65, 1.0, 0.1, 100.0);
	
	loadIdentity();
	mvTranslate([-0.0, 1.0, -6.0]);
	
	
	//mvPushMatrix();
	mvRotate(cubeRotation, [1,0,1]);
	mvTranslate([1, 0, squareZOffset]);
	
	gl.bindBuffer(gl.ARRAY_BUFFER, cubeVerticesBuffer);
	gl.vertexAttribPointer(vertexPositionAttribute, 3, gl.FLOAT, false, 0, 0);
	
	gl.bindBuffer(gl.ARRAY_BUFFER, cubeVerticesColorBuffer);
	gl.vertexAttribPointer(vertexColorAttribute, 3, gl.FLOAT, false, 0, 0);
	
	gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, cubeVertexIndicesBuffer);
	setMatrixUniforms();
	gl.drawElements(gl.TRIANGLES, 36, gl.UNSIGNED_SHORT, 0);
	//gl.drawArrays(gl.TRIANGLE_STRIP, 0, 4);
	//mvPopMatrix(); //pop out the current view of the object
	
	

	//update the rotation

	var currentTime = Date.now();
	
	if(lastSquareUpdateTime){
		var delta = currentTime - lastSquareUpdateTime;
		var random = Math.random()*30 + 15;
		
		cubeRotation += (random*delta)/1000;
		
		squareZOffset += zIncValue * ((delta)/1000.0);
		if(Math.abs(squareZOffset) > 2.5){
			zIncValue = -zIncValue;
		}
		
		/*
		squareXOffset += xIncValue * ((10*delta)/1000.0);
		squareYOffset += yIncValue * ((20*delta)/1000.0);
		
		
		if(Math.abs(squareYOffset) > 2.5){
			xIncValue = -xIncValue;
			yIncValue = -yIncValue;
			zIncValue = -zIncValue;
		}
		*/
	}
	
	lastSquareUpdateTime = currentTime;
	
	
}

//matrix utility operations
var mvMatrixStack = [];

function loadIdentity() {
  mvMatrix = Matrix.I(4);
}

function multMatrix(m) {
  mvMatrix = mvMatrix.x(m);
}

function mvTranslate(v) {
  multMatrix(Matrix.Translation($V([v[0], v[1], v[2]])).ensure4x4());
}

function setMatrixUniforms() {
  var pUniform = gl.getUniformLocation(shaderProgram, "uPMatrix");
  gl.uniformMatrix4fv(pUniform, false, new Float32Array(perspectiveMatrix.flatten()));

  var mvUniform = gl.getUniformLocation(shaderProgram, "uMVMatrix");
  gl.uniformMatrix4fv(mvUniform, false, new Float32Array(mvMatrix.flatten()));
}

function mvPushMatrix(m) {
  if (m) {
    mvMatrixStack.push(m.dup());
    mvMatrix = m.dup();
  } else {
    mvMatrixStack.push(mvMatrix.dup());
  }
}

function mvPopMatrix() {
  if (!mvMatrixStack.length) {
    throw("Can't pop from an empty matrix stack.");
  }
  
  mvMatrix = mvMatrixStack.pop();
  return mvMatrix;
}

function mvRotate(angle, v) {
  var inRadians = angle * Math.PI / 180.0;
  
  var m = Matrix.Rotation(inRadians, $V([v[0], v[1], v[2]])).ensure4x4();
  multMatrix(m);
}
