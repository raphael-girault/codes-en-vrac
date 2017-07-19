


class Point {
  
  //PARAMETRES
    PVector pos;
    
    //pour affichage
      int taille = 10;
    
  
  //CONSTRUCTEURS
    Point(int x , int y) {
      pos = new PVector(x,y);
    }
    
    
  
  //METHODES
    //PUBLICS
      public void affichage() {
        deplacement();
        
        noFill();
        stroke(0);
        ellipse(pos.x,pos.y,taille,taille);
      }//fin affichage
      
      
      public boolean over(int x , int y) {
        return (pow(taille,2) >= pow(x-pos.x,2) + pow(y-pos.y,2));
      }//fin over
      
      
    //PRIVEES
      private void deplacement() {
        if (mousePressed && over(mouseX,mouseY) && mouseButton == 37) {
          pos = new PVector(mouseX , mouseY);
        }
      }//fin deplacement
    
}