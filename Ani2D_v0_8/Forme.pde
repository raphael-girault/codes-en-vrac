/*
  Classe abstraite pour la réalisation des formes et des textures.
*/



abstract class Forme {
  
  //PARAMETRES
    PGraphics page;
    boolean afficherForme = true;
    boolean afficherTexture = true;
    boolean afficherStroke = false;
    PImage imgTexture;
    color couleurBasique = color(255);
    
    float profondeurAffichage = 0;
    
    ArrayList<Dessin> dessins = new ArrayList<Dessin>();
    
    boolean select = false;
    
    
    String id = null;
    String idStructure = null;
    
    int idInStructure = -1;
    
    
  
  //CONSTRUCTEURS
    Forme(PGraphics page) {
      this.page = page;
    }
    
    Forme(PGraphics page , int idInStructure) {
      this.page = page;
      this.idInStructure = idInStructure;
    }
  
  
  
  //METHODES
    //ABSTRAITES
      abstract void affichageForme(float pz);
      abstract void affichageStroke(float pz);
      abstract void affichageTexture(float pz);
      abstract void createImgTexture();
      abstract boolean pointInForme(int x , int y);
      abstract void placementDessins();
      abstract void calculProfondeurAffichage();
      
      
    
    //PUBLICS
      public void affichage() {
        //création de l'image si pas déjà fait
          //if (imgTexture == null) {
            createImgTexture();
          //}
          
          //calcul de la profondeur d'affichage
            calculProfondeurAffichage();
        
        if (afficherForme) {
          affichageForme(profondeurAffichage);

          if (afficherTexture) {
            placementDessins();
            affichageTexture(profondeurAffichage);
           }
          
          if (afficherStroke) {
            affichageStroke(profondeurAffichage);
          }
          
        }
      }//fin affichage
      
      
      
      /*
        Pour faciliter l'accès à l'affichage dans les formes composées.
      */
      public void affichageAnnexe(float profondeurAffichageDonnee) {
        affichageForme(profondeurAffichageDonnee);

          if (afficherTexture) {
            placementDessins();
            affichageTexture(profondeurAffichageDonnee);
           }
          
          if (afficherStroke) {
            affichageStroke(profondeurAffichageDonnee);
          }
      }//fin affichageAnnexe
      
      
      
      //public void affichageStroke() {
      //  if (this.afficherStroke) {
      //    if (select) {
      //      page.stroke(FORME_COLOR_STROKE_SELECT);
      //    } else {
      //      page.stroke(FORME_COLOR_STROKE);
      //    }
      //  } else {
      //    page.noStroke();
      //  }
      //}//fin affichageStroke
      
      
      
      public void selection(int x , int y) {
        if (pointInForme(x,y)) {
          select = !select;
        }
        //affichage des contours si sélectionné
          if (select) {
            afficherStroke = true;
          } else {
            afficherStroke = false;
          }
      }//fin selection
      
      
      
      public void ajouterDessin(Dessin d) {
        dessins.add(d);
      }//fin ajouterDessin
      
      
      
      public void supprimerDessin(Dessin d) {
        dessins.remove(d);
      }//fin supprimerDessin
    
    
    
  //ENCAPSULATION
    public PGraphics getPage() { return page; }
    
    public boolean getAfficherForme() { return afficherForme; }
    public void setAfficherForme(boolean afficherForme) { this.afficherForme = afficherForme; }
    
    public boolean getAfficherTexture() { return afficherTexture; }
    public void setAfficherTexture(boolean afficherTexture) { this.afficherTexture = afficherTexture; }

    public boolean getAfficherStroke() { return afficherStroke; }
    public void setAfficherStroke(boolean afficherStroke) { this.afficherStroke = afficherStroke; }
    
    public void modifierCouleur(color couleur) { this.couleurBasique = couleur; }
    

}