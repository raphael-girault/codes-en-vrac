/*
  Classe permettant de créer des noeuds, sélectionnables et déplaçables.
  Ils seront l'entités principales de l'application.
*/



class Noeud {
  
  //PARAMETRES
    private PGraphics page;
    private PVector pos;
    private PVector posR; //position relative par rapport l'écran
    private PVector angle = new PVector(0,0,0);
    private boolean select = false;
    
    
    String id = null;
    String nom = "noeud";
    String idStructure = null;
    String idParent = null;
    
    int idInStructure = -1;
  
  
  //CONSTRUCTEURS
    Noeud(PGraphics page , int x , int y , int z) {
      this.page = page;
      this.pos = new PVector(x,y,z);
    }
    
    Noeud(PGraphics page , int x , int y , int z , int idInStructure) {
      this.page = page;
      this.pos = new PVector(x,y,z);
      this.idInStructure = idInStructure;
    }
    
    
    Noeud(PGraphics page , PVector pos) {
      this.page = page;
      this.pos = pos;
    }
    
    Noeud(PGraphics page , PVector pos , int idInStructure) {
      this.page = page;
      this.pos = pos;
      this.idInStructure = idInStructure;
    }
    
    Noeud(PGraphics page) {
      this.page = page;
    }
    
  
  
  //METHODES
    //PUBLICS
      public void affichage() {
        page.pushMatrix();
          page.translate(pos.x,pos.y,pos.z);
          cam.contreRot();
          page.noStroke();
          page.ellipseMode(CENTER);
          if (select) {
            page.fill(NOEUD_COLOR_SELECT);
          } else {
            page.fill(NOEUD_COLOR_BASIC);
          }
          page.ellipse(0,0,NOEUD_DIAM,NOEUD_DIAM);
        page.popMatrix();  
      }//fin affichage
      
      
      
      /*
        Calcul la position relative à l'écran du noeud
      */
      public void calculPosR() {
        page.pushMatrix();
          page.translate(pos.x,pos.y,pos.z);
          posR = tools3D.getScreen();
        page.popMatrix();
      }//fin calculPosR
      
      
      
      /*
        Indique si les coordonnées x et y sont sur le noeud
      */
      public boolean onNoeud(int x , int y) {
        //on commencer par calculer posR
          calculPosR();
        //et on calcule la solution
          return (pow(NOEUD_DIAM,2) >= pow(x-posR.x , 2) + pow(y-posR.y , 2));
            //on met le diamètre plutôt que le rayon pour avoir plus de souplesse
      }//fin de onNoeud
      
      
      
      
      /*
        Pour réaliser le déplacement du noeud.
        Dépendra de ces liens de parentés => à revoir par la suite quand ça sera mis en place.
      */
      public void deplacement(int x , int y , int z) {
        pos = new PVector(x,y,z);
      }//fin deplacement
      public void deplacement(PVector v) {
        //pos.add(v);
        pos = v.copy();
      }//fin deplacement
      
      
      
      /*
        Récupération de l'angle d'affichage du noeud.
        Dépend donc de la rotation de la cam et du noeud lui-même (modifié direct par le parent si modif à ce niveau là)
      */
       public float[] getAngleAffichage() {
         float[] result = new float[3];
         result[0] -= cam.angle.x;
         result[1] += HALF_PI-cam.angle.y;
         for (int i=0 ; i<3 ; i++) {
           int coef = floor( result[i]/TWO_PI );
           result[i] -= float(coef) * TWO_PI;
         }
         return result;
       }//fin getAngleAffichage
  
  
  
  //ENCAPSULATION
    public void changeSelect() { select = !select; }
    public boolean getSelect() { return select; }

  
}