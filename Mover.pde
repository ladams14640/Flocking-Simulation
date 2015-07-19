class Mover {
  PVector loc, acc, vel;
  float mass, maxSpeed, maxForce; 
  SliderBar alignControl;
  SliderBar seperateControl;

  Mover(float xpos, float ypos, SliderBar _alignControl, SliderBar _seperateControl) {
    loc = new PVector(xpos, ypos);
    acc = new PVector();
    vel = new PVector(random(-1, 1), random(-1, 1));
    mass = 12;
    maxSpeed = 2;
    maxForce = .1;
    alignControl = _alignControl;
    seperateControl = _seperateControl;
  }

  void update() {
    vel.add(acc);
    loc.add(vel);
    acc.mult(0);
  }
  void display() {
    noFill();
    stroke(0);
    float theta = vel.heading2D();
    strokeWeight(1);
    pushMatrix();
    translate(loc.x,loc.y);
    rotate(theta);
    ellipse(0,0, mass*2, mass*2);
    line(0,0,mass,0);
    popMatrix();
  }
  void run() {
    update();
    display();
    checkBorders();
  }
  void applyBehavior(ArrayList<Mover> Movers) {
    // stay away from other's
    PVector seperate = flee(Movers);
    float slevel = seperateControl.sliderValue;
    float sepLevel = map(slevel, 0, 100, 0, 25);
    seperate.mult(sepLevel);
    applyForce(seperate);

    // Cohesion apply and control
    PVector cohesion = cohesion(Movers);
    float cLevel = cohesionControl.sliderValue;
    float cohLevel = map(cLevel, 0, 100, 0, 25);
    cohesion.mult(cohLevel);
    applyForce(cohesion);

    // Aligning apply and control
    PVector aligning = align(Movers);
    float alevel = alignControl.sliderValue;
    float alignLevel = map(alevel, 0, 100, 0, 25);
    aligning.mult(alignLevel);
    applyForce(aligning);
  }




  void applyForce(PVector f) {
    PVector force = f.get();
    force.div(mass);
    acc.add(force);
  }

  PVector flee(ArrayList<Mover> Movers) {
    PVector sum = new PVector(0, 0);
    int count = 0;

    for (Mover m : Movers) {
      float d = PVector.dist(loc, m.loc);
      if (d>0 && d<25) {
        PVector diff = PVector.sub(loc, m.loc);
        diff.normalize();
        // if seperation is farther then less influence
        diff.div(d);
        sum.add(diff);
        count++;
      }
    }
    if (count > 0) {
      sum.div((float)count);
      sum.setMag(maxSpeed);
      sum.sub(vel);
      sum.limit(maxForce);
    } 
    return sum;
  }

  PVector align(ArrayList<Mover> Movers) {
    PVector sum = new PVector();
    int count = 0;

    for (Mover m : Movers) {
      float dist = PVector.dist(loc, m.loc);
      if  (dist < 50 && dist > 0) {
        count++;
        sum.add(m.vel);
      }
    }
    if (count > 0) {
      sum.div((float)count);
      sum.setMag(maxSpeed);
      sum.sub(vel);
      sum.limit(maxForce);
    }
    return sum;
  }


  PVector cohesion(ArrayList<Mover> Movers) {
    int count = 0;
    PVector sum = new PVector();
    for (Mover m : Movers) {
      float d = PVector.dist(loc, m.loc);
      if ((d > 0)&&(d < 50)) {
        sum.add(m.loc);
        count++;
      }
    }
    if (count > 0) {
      sum.div(count);
      return seek(sum);
    }
    else return new PVector(0, 0);
  }



  PVector seek(PVector target) {
    PVector desire = PVector.sub(target, loc);

    desire.setMag(maxSpeed);
    desire.sub(vel);
    desire.limit(maxForce);
    return desire;
  }
  void checkBorders() {
    if (loc.x < -1*mass) loc.x=width;
    if (loc.x > width+mass) loc.x=0;
    if (loc.y < -1*mass) loc.y=height;
    if (loc.y > height + mass) loc.y=0;
  }
}

