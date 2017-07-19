
int nbPoints = 3;
Point[] pts = new Point[nbPoints];




void setup() {
  
  size(400,400);
  background(255);
  
  //création des points
    for (int i=0 ; i<nbPoints ; i++) {
      if (i==0) {
        pts[i] = new Point(random(width),random(height));
      } else {
        pts[i] = new Point(random(width),random(height),pts[i-1]);
      }
    }
  
  
  //on met le dernier point en cinématique inverse
    pts[nbPoints - 1].cinematiqueInverseActivee = true;
  
  
}//fin setup



void draw() {
  
  if (mousePressed) {
    background(255);
    for (int i=0 ; i<nbPoints ; i++) {
      pts[i].affichage();
    }
  }
  
  

  
}//fin draw



void keyReleased() {
  if (key == 'r') {
    for (int i=0 ; i<nbPoints ; i++) {
      if (i==0) {
        pts[i] = new Point(random(width),random(height));
      } else {
        pts[i] = new Point(random(width),random(height),pts[i-1]);
      }
    }
  }
  
  pts[nbPoints - 1].cinematiqueInverseActivee = true;
}


void mouseReleased() {
  for (Point p : pts) {
    p.deplace = false;
  }
}