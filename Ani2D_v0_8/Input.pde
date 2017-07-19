/*
  Page avec les actions mises sur les entrées clavier et les entrées souris
*/


//CLAVIER
  void keyReleased() {
    
    switch (key) {
      case 'r' : //reset de la cam
        cam.resetCam();
        break; 
    }
    
    //et on relance l'affichage
      conditionAffichage = true;
      mode.conditionAffichage = true;
      
      clavierRelache = true;
  }//fin keyReleased
  
 
 
 
//SOURIS
  void mouseReleased(MouseEvent e) {
      sourisRelachee = true;
    //et on relance l'affichage
      conditionAffichage = true;
      mode.conditionAffichage = true;
    //on stocke l'évênement
     mouseEvent = e;
  }//fin mouseReleased
  
  
  void mouseWheel(MouseEvent event) {
    //récup de la valeur de la molette
      float e = event.getCount();
    //on l'ajoute à la valeur du zoom de la cam
      cam.changerZoom(e);
    //on relance l'affichage
      conditionAffichage = true;
      mode.setConditionAffichage(true);
  }
  
  
  
  void mousePressed() {
    sourisPressee = true;
    mode.setConditionAffichage(true);
  }
  
  
//POUR CAM
  /*
    Fonction permettant de réaliser les contrôles de la caméra avec la souris
  */
  void camDeplacement() {
    //on regarde si la molette de la souris est enfoncée
      if (mousePressed && mouseButton == 3) {
        //on vérifie si le bouton 'SHIFT' est enfoncé
        //si oui, déplacement dans le plan
        //si non, rotation autour du point observé
          if (key == CODED && keyCode == SHIFT && keyPressed) {
            cam.deplacement(-mouseX+pmouseX , -mouseY+pmouseY);
          } else {
            PVector p = cam.getAngle().copy();
            p.y += radians(mouseX - pmouseX);
            p.x -= radians(mouseY - pmouseY);
            cam.setAngle(p);
          }
        //on relance l'affichage
          conditionAffichage = true;
          mode.setConditionAffichage(true);
      }
  }//camDeplacement