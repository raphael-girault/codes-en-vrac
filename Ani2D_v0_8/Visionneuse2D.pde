/*
  Le but de cette classe est de créer un outil qui permettra de réaliser l'affichage
  des formes en fonction de leurs profondeurs.
  On peut donc remplir un tableau qui lie une shape àune profondeur et afficher le
  tout.
*/


import java.util.Comparator;



class Visionneuse2D {
  
  //Nested Classes
    class FormeElt {
      PShape shape;
      int profondeur;
      
      FormeElt(PShape shape , int profondeur) {
        this.shape = shape;
        this.profondeur = profondeur;
      }
    }
  
  
  
  //PARAMETRES
    int px , py , L , H;
    PGraphics page;
    
    ArrayList<FormeElt> listeFormes = new ArrayList<FormeElt>();
    
    
  
  //CONSTRUCTEURS
    Visionneuse2D(int px , int py , int L , int H) {
      this.px = px;
      this.py = py; 
      this.L = L;
      this.H = H;
      
      this.page = createGraphics(L,H);
    }
  
  
  //METHODES
    //PUBLICS
      public void ajouterShape(PShape shape , int profondeur) {
        listeFormes.add(new FormeElt(shape,profondeur));
      }//fin ajouterShape
      
      
      
      public void resetListe() {
        listeFormes = new ArrayList<FormeElt>();
      }//fin resetListe

      
      
      public void affichage() {
        trierListe();
          page.beginDraw();
            for (FormeElt f : listeFormes) {
              page.shape(f.shape);
            }
          page.endDraw();
        image(page,px,py);
      }//fin affichage
      
      
      
    //PRIVEES
      private void trierListe() {
        //L'idée est de trier la liste des profondeurs pour ensuite
        //utiliser l'ordre des clefs pour faire l'affichage des shapes.
        listeFormes.sort(new Comparator<FormeElt>() {
          public int compare(FormeElt f1 , FormeElt f2) {
            return f1.profondeur - f2.profondeur;
          }
        });
      }//fin trierListe
      

  
}