
Point p1;
Point p2;
Point p3;

  boolean firstLoop = true;

void setup() {
  
  size(400,400);
  
  p1 = new Point(200,300);
  p2 = new Point(300,50);
  
  
  
  p3 = new Point(int((p1.pos.x+p2.pos.x)/2) , int((p1.pos.y+p2.pos.y)/2));
}



void draw() {
  
  if (firstLoop || mousePressed) {
    background(255);
    
    p1.affichage();
    p2.affichage();
    
      //on dessine la courbe
      
        //calcul du point de control de fin à mettre au milieu
          
          p3.affichage();
      
        bezier(p1.pos.x,p1.pos.y , p1.pos.x,p1.pos.y , p3.pos.x,p3.pos.y , p2.pos.x,p2.pos.y);
        
        
        /*
          On doit donc créer une classe Ligne avec une orientation donné par le deuxième point de contrôle.
          => et marche mieux avec les lignes de bezier (plus simple à utiliser en tout cas).
        */
    
  }


  firstLoop = false;
}