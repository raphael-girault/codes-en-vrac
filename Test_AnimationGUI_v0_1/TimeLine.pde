



class TimeLine {
  
  //PARAMETRES
    int L , H , PX , PY , px , py;
    private int nbFrames;
    private int frameSelect = -1;
  
  //CONSTRUCTEURS
    TimeLine(int PX , int PY , int H , int nbFrames) {
      this.PX = PX;
      this.PY = PY;
      this.H = H;
      this.nbFrames = nbFrames;
      
      this.L = nbFrames * lCase;
      
      px = PX;
      py = PY;
    }
  
  //METHODES
    //PUBLICS
      public void affichage() {
        //affichage général
          noStroke();
          fill(50,70,130);
          rect(px,py,L,H,3);
        //vérif de la sélection d'une frame
          selectionFrame();
      }//fin affichage
      
      
      
    //PRIVEES
      private void selectionFrame() {
        //on commence à vérifier qu'on clique bien dans la time line (avec clique droit)
          if (sourisRelachee && mouseButton == 37 && mouseX>=px && mouseX<px+L && mouseY>=py && mouseY<py+H) {
            int frameClicked = ( (mouseX-px) / lCase );
            //si on clique sur la frame déjà sélectionnée, on la déselectionne
            //ou sinon, nouvelle sélection d'une frame
              if (frameClicked == frameSelect) {
                frameSelect = -1;
              } else {
                frameSelect = frameClicked;
              }
          }
          
        //et on s'occupe de la sélection de la frame sélectionnée ici
          if (frameSelect != -1) {
            noStroke();
            fill(100,150,200);
            rect(px+frameSelect*lCase,py,lCase,H,3);
            
            //et affichage du numéro de frame sélectionnée (au-dessus pour le moment)
              fill(255);
              text(str(frameSelect),px+frameSelect*lCase,py-5);
          }
      }//fin selectionFrame
      
      
    //ENCAPSULATION
      public int getFrameSelect() { return frameSelect; }
      
      public int getNbFrames() { return nbFrames; }
      public void setNbFrames(int valeur) { 
        nbFrames = valeur;
        if (nbFrames <= 0) {
          nbFrames = 1;
        }
        L=nbFrames*lCase;
      }
      public void addFrame() { nbFrames++; L=nbFrames*lCase; }
      public void supprFrame() { 
        nbFrames--;
        if (nbFrames <= 0) {
          nbFrames = 1;
        }
        L=nbFrames*lCase;
      }
}