/*
  Le but de ce code est de placer une image sur la projection orthogonale d'une
  sphère.
  On doit donc créer une classe pour le cercle/sphère, et une pour le dessin.
*/


Cercle c;
boolean conditionAffichage = true;

PVector angleScene = new PVector(radians(0),radians(90));

void setup() {
  size(400,400,P2D);
  
  c = new Cercle(width/2,height/2,100);
  c.ajouterDessin(loadImage("smiley.png"),radians(0),radians(0),radians(0));
}//fin setup



void draw() {
  if (conditionAffichage) {
    conditionAffichage = false;
    background(220);
    c.affichage();
  }
}//fin draw