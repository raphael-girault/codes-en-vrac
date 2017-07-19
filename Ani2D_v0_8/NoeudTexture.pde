/*
  Noeud attaché uniquement à une texture.
  Très proche de noeuds mais avec suffisament de diff pour faire une nouvelle classe.
*/


class NoeudTexture {
  
  //PARAMETRES
    private PGraphics page;
    private PVector coordonnees; //mais soit les coordonnées sphériques ou les pourcentages
    private PVector pos;
    private PVector posR; //position relative par rapport l'écran
    private boolean select = false;
    private Forme forme;
    private Dessin dessin;
  
  
  //CONSTRUCTEURS
    NoeudTexture(PGraphics page , Forme forme , float x , float y , float z) {
      this.page = page;
      this.forme = forme;
      this.coordonnees = new PVector(x,y,z);
    }
    
    
    NoeudTexture(PGraphics page , Forme forme  , PVector pos) {
      this.page = page;
      this.forme = forme;
      this.coordonnees = pos;
    }
    
  
  
  //METHODES
    //PUBLICS
      public void affichage() {
        calculPos();
          //correction bug
          if (pos == null) {
            pos = new PVector(0,0,0);
          }
        
        page.pushMatrix();
          page.translate(pos.x,pos.y,pos.z);
          cam.contreRot();
          page.noStroke();
          page.rectMode(CENTER);
          if (select) {
            page.fill(NOEUDTEX_COLOR_SELECT);
          } else {
            page.fill(NOEUDTEX_COLOR_BASIC);
          }
          page.rect(0,0,NOEUDTEX_DIM,NOEUDTEX_DIM);
        page.popMatrix();  
      }//fin affichage
      
      
      
      /*
        Calcul de la position absolue à l'écran
      */
      public void calculPos() {
        //à faire en fonction de la forme
        String type = forme.getClass().getSimpleName();
        switch (type) {
          case "Cercle":
            //pos = toolsMath.polarToCartesian2(new PVector(coordonnees.x+HALF_PI,-coordonnees.y-HALF_PI,coordonnees.z),((Cercle) forme).noeud.pos);
            page.pushMatrix();
              Cercle c = (Cercle) forme;
              page.translate(c.noeud.pos.x,c.noeud.pos.y,c.noeud.pos.z);
              page.rotateZ(0);
              page.rotateY(-coordonnees.y);
              page.rotateX(-coordonnees.x);
              page.translate(0,0,c.D/2);
              pos = tools3D.getModel();
            page.popMatrix();
            break;
          case "Convexe":
            //PVector p1 = ((Convexe) forme).c1.noeud.pos;
            //PVector p2 = ((Convexe) forme).c2.noeud.pos;
            //float distAxe = coordonnees.x * dist(p1.x,p1.y,p1.z , p2.x,p2.y,p2.z);
            //pos = toolsMath.cylinderToCartesian(new PVector(distAxe,-coordonnees.y-HALF_PI,((Convexe) forme).c1.D/2) , p1);
              //pos = toolsMath.cylinderToCartesian(new PVector(distAxe,0,25) , p1);
              
              Convexe cv = (Convexe) forme;
              //float maxD = max(cv.c1.D,cv.c2.D);
              //float distCv = dist(cv.c1.noeud.pos.x,cv.c1.noeud.pos.y,cv.c1.noeud.pos.z , cv.c2.noeud.pos.x,cv.c2.noeud.pos.y,cv.c2.noeud.pos.z);
              Triedre triedre = new Triedre(page);
              PVector vConvexe = PVector.sub(cv.c2.noeud.pos,cv.c1.noeud.pos);
              float diffD = cv.c2.D-cv.c1.D;
              float pr = coordonnees.x;
              int rTroncon = int( cv.c1.D + (diffD / pr) ) / 2;
              page.pushMatrix();
                page.translate(cv.c1.noeud.pos.x,cv.c1.noeud.pos.y,cv.c1.noeud.pos.z);
                page.translate(pr*vConvexe.x,pr*vConvexe.y,pr*vConvexe.z);
                page.rotateZ(0);
                page.rotateY(-coordonnees.y);
                page.rotateX(0);
                page.translate(0,0,rTroncon);
                pos = tools3D.getModel();
              page.popMatrix();
            break;
          case "Plan":
            //récup du plan et des cercles principaux
              Plan p = (Plan) forme;
              Cercle c0 = p.cercles.get(0);
              Cercle c1 = p.cercles.get(1);
              Cercle c2 = p.cercles.get(p.cercles.size()-1);
            //récup de la pos du premier noeud
              //PVector pp = c0.noeud.pos;
            ////calcul de la pos
              ////pos = PVector.add(PVector.mult(p.triedrePlan.Z,coordonnees.x*dist(c0.noeud.posR.x,c0.noeud.posR.y,c1.noeud.posR.x,c1.noeud.posR.y)),PVector.mult(p.triedrePlan.Y,coordonnees.y*dist(c0.noeud.posR.x,c0.noeud.posR.y,c2.noeud.posR.x,c2.noeud.posR.y)));
              //pos = PVector.add(PVector.mult(p.triedrePlan.Z,coordonnees.x),PVector.mult(p.triedrePlan.Y,coordonnees.y));
              //pos = PVector.sub(c0.noeud.pos,pos);
              
              //px = int( imgTexture.width*dessin.noeud.coordonnees.x - dessin.img.width + i + dessin.img.width/2 );
              //py = int(imgTexture.height*dessin.noeud.coordonnees.y - dessin.img.height + j + dessin.img.height/2);
              
              PVector v1 = PVector.sub(c1.noeud.pos,c0.noeud.pos);
              PVector v2 = PVector.sub(c2.noeud.pos,c0.noeud.pos);
              
              v1.mult(coordonnees.x);
              v2.mult(coordonnees.y);
              
              pos = PVector.add(c0.noeud.pos , PVector.add(v1,v2));
              
            break;
        }
      }//fin calculPos
      
      
      
      /*
        Calcul la position relative à l'écran du noeud
      */
      public void calculPosR() {
        //calculPos();
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
          //return (pow(NOEUD_DIAM,2) >= pow(x-posR.x , 2) + pow(y-posR.y , 2));
          return ( x-posR.x>=-NOEUDTEX_DIM/2 && x-posR.x<=+NOEUDTEX_DIM/2 && y-posR.y>=-NOEUDTEX_DIM/2 && y-posR.y<=+NOEUDTEX_DIM/2 );
            //on met le diamètre plutôt que le rayon pour avoir plus de souplesse
      }//fin de onNoeud
      
      

      
      /*
        Méthode pour modifier les coordonnées de la texture
      */
      public void deplacerTexture(int dx , int dy) {
        String type = forme.getClass().getSimpleName();
        switch (type) {
          case "Cercle":
            coordonnees.x -= radians(dy);
            coordonnees.y -= radians(dx);
            break;
          case "Convexe":
            coordonnees.x += dy/100.;
            coordonnees.y -= radians(dx);
            break;
          case "Plan":
            coordonnees.x += dx/100.;
            coordonnees.y += dy/100.;
            break;
        }
      }//fin deplacerTexture
      




  
  //ENCAPSULATION
    public void changeSelect() { select = !select; }
    public boolean getSelect() { return select; }

  
}