


class Pastille {
  
  //PARAMETRES
    int px , py , D;
    boolean modification = false;
    
  
  //CONSTRUCTEUR
    Pastille(int px , int py , int D) {
      this.px = px;
      this.py = py;
      this.D = D;
    }
    
    
  //METHODES
    //PUBLICS
      public void affichage() {
        noStroke();
        fill(255);
        ellipseMode(CENTER);
        ellipse(px,py,D,D);
        
        deplacement();
      }//fin affichage
      
      
    //PRIVEES
      /*
        Methode pour le deplacement de la pastille si cliquée.
      */
      private void deplacement() {
        if (mousePressed && pow(D,2) >= pow(mouseX-px,2) + pow(mouseY-py,2)) {
          px = mouseX;
          py = mouseY;
          modification = true;
        } else {
          modification = false;
        }
      }//fin deplacement
  
}