
class SliderBar {
  float xpos, ypos; // x position, y position of the sliding bar
  float bWidth, bHeight; // width, height of sliding bar
  boolean drag;  // is the mouse pressed on the scroll
  float sX, sY; // Position of the scroll
  float sW, sH; // width and height of the scroll
  float sliderValue;
  String desc; 
  SliderBar(float _x, float _y, float _w, float _h, String _desc) {
    xpos = _x;
    ypos = _y;
    bWidth = _w;
    bHeight = _h;
    sW = 10;
    sH = bHeight;
    sX = xpos;
    sY = xpos;
    drag = false;
    sliderValue = map(sX, xpos, xpos+bWidth/2, 0, 25);
    desc = _desc;
  }

  void update() {
    over();
    dragging();
  }
  void run() {
    display();
    update();
  }
  void over() {
    if (mousePressed) {
      if (mouseX <= xpos+bWidth && mouseX >= xpos && 
        mouseY <= ypos+bHeight && mouseY >= ypos) {
        drag = true;
      }
    }
  }
  void dragging() {
    if (drag) {
      sX = constrain(mouseX, xpos, xpos+bWidth-1);
      sY = constrain(mouseY, ypos, ypos);
      sliderValue = map(sX, xpos, xpos+bWidth/2, 0, 100);
    }
  }

  void release() {
    drag = false;
  }


  void display() {
    rectMode(CORNER);
    // Bar Display
    fill(100);
    rect(xpos, ypos, bWidth, bHeight);
    fill(0);
    // text Display
    fill(0);
    textSize(10);
    text(desc, xpos+bWidth+5, ypos+bHeight);
    // Slider Display
    rect(sX, sY, sW, sH);
    
  }
}

