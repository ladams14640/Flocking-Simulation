// My Attempt to make a slider
SliderBar alignControl;
SliderBar seperateControl;
SliderBar cohesionControl;

ArrayList<Mover> Movers;

void setup() {
  size(800, 800);
  //size(displayWidth,displayHeight);
  orientation(LANDSCAPE); 
  alignControl = new SliderBar(20, 20, 100, 40, "Align");
  seperateControl = new SliderBar(20, 70, 100, 40, "Seperate");
  cohesionControl = new SliderBar(20, 120, 100, 40, "Cohesion");
  Movers = new ArrayList<Mover>();
  createMovers();
}
void draw() {
  background(255);
  rectMode(CENTER);
  fill (200);
  rect(width/2, height/2, 100, 100);
  text(frameRate,20,height-20);
  
  SliderDisplays();

  for (int i = Movers.size()-1; i >=0; i--) {
    Mover m = Movers.get(i);
    m.run();
    m.applyBehavior(Movers);
  }

  // to spawn more movers;
  if (mousePressed) {
    if (mouseX >= width/2-50 && mouseX <= width/2+50 &&
      mouseY >= height/2-50 && mouseY <= height/2+50) {
      createMovers();
    }
  }
}

void mousePressed() {
  alignControl.over();
  alignControl.dragging();

  cohesionControl.over();
  cohesionControl.dragging();

  seperateControl.over();
  seperateControl.dragging();
}

void mouseReleased() {
  alignControl.release(); 
  cohesionControl.release();
  seperateControl.release();
}

void createMovers() {
  for (int i = 0; i < 5; i++) {
    Mover move = new Mover(width/2+(i*5), height/2, alignControl, seperateControl);
    Movers.add(move);
  }
}

void displayMovers() {
  for (int i = Movers.size()-1; i >=0; i--) {
    Mover m = Movers.get(i);
    m.run();
    m.applyBehavior(Movers);
  }
}

void SliderDisplays() {
  alignControl.run();
  seperateControl.run();
  cohesionControl.run();
}

