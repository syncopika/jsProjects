# html_drawing_app    
you can try a watered-down version here: http://syncopika.tumblr.com/htmldrawapp    
    
these are the tutorials I looked at the most:    
http://www.williammalone.com/articles/create-html5-canvas-javascript-drawing-app/    
http://www.storminthecastle.com/2013/04/06/how-you-can-do-cool-image-effects-using-html5-canvas/    
    
07/21/16    
I made some really good changes I think to the main.html! My previous version of the program was messy because I used a lot of arrays to store the pixel data of each brush stroke, and to store the pixel data of each canvas frame. Ideally this data would be useful for mainly cloning frames and undoing/redoing. I realized recently that I should have been taking advantage of canvas methods, like <b>getImageData()</b>!! In my revised program, I took away the unnecessary arrays and instead used context.getImageData() to store the complete pixel data of each canvas in between brush strokes, so I have a 'snapshot' of what the canvas looks like each time I draw on it. I think this way provides more advantages, and it works just as well as my previous version. 

    
