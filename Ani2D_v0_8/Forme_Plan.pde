


class Plan extends Forme {
  
  //PARAMETRES
    ArrayList<Convexe> convexes = new ArrayList<Convexe>(); //besoin des convexes pour gérer l'affichage
    ArrayList<Cercle> cercles = new ArrayList<Cercle>();
    PShape sh;

    Triedre triedrePlan;
  
  
  //CONSTRUCTEURS
    Plan (PGraphics page , ArrayList<Convexe> convexes) {
      super(page);
      this.convexes = convexes;
      
      setListeCercles();
    }
    
    Plan (PGraphics page) {
      super(page);
    }
    
    Plan (PGraphics page , ArrayList<Convexe> convexes , int idInStructure) {
      super(page,idInStructure);
      this.convexes = convexes;
      
      setListeCercles();
    }
  
  
  
  //METHODES
    //OVERRIDE de Forme
      public void affichageForme(float pz) {
        //on retire l'affichage des convexes et on modifie leur variable profondeurAffichage
          for (Convexe cv : convexes) {
            cv.setAfficherForme(false);
            cv.profondeurAffichage = pz;
          }
          
          for (Cercle c : cercles) {
            c.noeud.calculPosR();
          }
          
        //affichage de la forme
          page.fill(this.couleurBasique);
          page.noStroke();
          page.pushMatrix();
            cam.contreRot();
            page.translate(0,0,pz);
              page.beginShape();
                PVector vS = tools3D.getScreen();
                for (Cercle c : cercles) {
                  //page.vertex(c.noeud.posR.x-page.width/2,c.noeud.posR.y-page.height/2);
                  page.vertex(c.noeud.posR.x-vS.x,c.noeud.posR.y-vS.y);
                }
              page.endShape(CLOSE);
          page.popMatrix();
          
        //affichage des convexes par le plan
          for (Convexe cv : convexes) {
            cv.affichageAnnexe(pz);
          }
      }//fin affichageForme
      
      
      
      public void affichageStroke(float pz) {
        page.noFill();
        if (afficherStroke) {
          if (select) {
            page.stroke(FORME_COLOR_STROKE_SELECT);
          } else {
            page.stroke(FORME_COLOR_STROKE);
          }
        } else {
          page.noStroke();
        }
          page.pushMatrix();
            cam.contreRot();
            page.translate(0,0,pz+2);
              page.beginShape();
                PVector vS = tools3D.getScreen();
                for (Cercle c : cercles) {
                  //page.vertex(c.noeud.posR.x-page.width/2,c.noeud.posR.y-page.height/2);
                  page.vertex(c.noeud.posR.x-vS.x,c.noeud.posR.y-vS.y);
                }
              page.endShape(CLOSE);
          page.popMatrix();
      }//fin affichageStroke
      
      
      
      public void affichageTexture(float pz) {
        page.noFill();
        page.noStroke();
          page.pushMatrix();
            cam.contreRot();
            page.translate(0,0,pz+1);
                PVector vS = tools3D.getScreen();
                for (int i=0 ; i<sh.getVertexCount() ; i++) {
                  PVector v = sh.getVertex(i);
                  //sh.setVertex(i,v.x-page.width/2,v.y-page.height/2);
                  sh.setVertex(i,v.x-vS.x,v.y-vS.y);
                }
              sh.setTexture(imgTexture);
              sh.setFill(false);
              sh.setStroke(false);
              page.shape(sh);
          page.popMatrix();
          
        //affichage du noeud de texture
          for (Dessin dessin : dessins) {
            page.pushMatrix();
              dessin.noeud.affichage();
            page.popMatrix();
          }
      }//fin affichageTexture
      
      
      
      public void createImgTexture() {
        //1. calcul du trièdre et de la shape
          triedrePlan = calculerAnglePlan();
          sh = createShape();
        //2. en utilisant la base créée, on choppe les pos extrêmes de la liste de points dans cette base
          float minX = 0;
          float maxX = 0;
          float minY = 0;
          float maxY = 0;
          Cercle c1 = cercles.get(0);
            sh.beginShape();
              for (Cercle c : cercles) {
                //calcul du vecteur resultant
                  //PVector v = c.noeud.pos.sub(c1.noeud.pos);
                  PVector v = PVector.sub(c.noeud.pos,c1.noeud.pos);
                  
                  minX = min(minX , v.x);
                  maxX = max(maxX , v.x);
                  minY = min(minY , v.y);
                  maxY = max(maxY , v.y);
                  
                 sh.vertex(c.noeud.posR.x , c.noeud.posR.y , v.x ,v.y*2);
              }
            sh.endShape(CLOSE);

            
        //3. on peut maintenant calculer la taille du dessin
          int L = int(maxX - minX);
          int H = int(maxY - minY);   
          
        //4. création des maps
          imgTexture = createImage(L,H,ARGB);
            
      }//fin creationImgTexture
      
      
      
      public boolean pointInForme(int x , int y) {
        return toolsMath.isInsidePolygon(sh,new int[]{x,y});
      }//fin pointInForme
      
      
      
      public void placementDessins() {
      
        for (Dessin dessin : dessins) {
          
          for (int j=0 ; j<dessin.img.height ; j++) {
            for (int i=0 ; i<dessin.img.width ; i++) {
          
              int px,py;
              px = int( imgTexture.width*dessin.noeud.coordonnees.x - dessin.img.width + i + dessin.img.width/2 );
              py = int(imgTexture.height*dessin.noeud.coordonnees.y - dessin.img.height + j + dessin.img.height/2);
              
              if (alpha(dessin.img.get(i,j))>1 && abs(px - dessin.img.width)>=0 && abs(py - dessin.img.height)>=0) {
                imgTexture.set(px,py,dessin.img.pixels[i+j*dessin.img.width]);
              }
              
            }
          }
          
        }
        
        
        image(imgTexture,SCREEN_3D_SIZE_L,0,imgTexture.width,imgTexture.height);
        
      }//fin placementDessins
      
      
      
      public void calculProfondeurAffichage() {
        float maxZ = 0;
        for (Cercle c : cercles) {
          c.noeud.calculPosR();
          maxZ = max(maxZ , c.noeud.posR.z);
        }
        this.profondeurAffichage = maxZ;
      }//fin calculProfondeurAffichage
    
    
    
    //PUBLICS
    
    
    
    //PRIVEES
      /*
        Le but de cette méthode est de récupérer tous les cercles de la liste
        convexes, sans doublon.
      */
      private void setListeCercles() {
        for (Convexe cv : convexes) {
          if (!cercles.contains(cv.c1)) {
            cercles.add(cv.c1);
          }
          if (!cercles.contains(cv.c2)) {
            cercles.add(cv.c2);
          }
        }
      }//fin de setListeCercles
      
      
      
      
      
      
      private Triedre calculerAnglePlan() {
        //1. création d'un trièdre pour obtenir la base du plan
          Triedre resultat = new Triedre(page);
        
        //2. récup des cercles principaux
          Cercle c1 = cercles.get(0); //A
          Cercle c2 = cercles.get(1); //B
          Cercle c3 = cercles.get(cercles.size()-1); //C
          
        //3. déf des vecteurs du plan
          PVector AB = new PVector(c2.noeud.pos.x-c1.noeud.pos.x , c2.noeud.pos.y-c1.noeud.pos.y , c2.noeud.pos.z-c1.noeud.pos.z);
          PVector AC = new PVector(c3.noeud.pos.x-c1.noeud.pos.x , c3.noeud.pos.y-c1.noeud.pos.y , c3.noeud.pos.z-c1.noeud.pos.z);
          
        //4. obtention de la normal du plan
          PVector n = AB.cross(AC);
          
        //5. on place le triède sur le premier cercle avec l'orientation de n
          float[] angleN = new float[3];
          angleN[0] = PVector.angleBetween(n,new PVector(10,0,0));
          angleN[1] = PVector.angleBetween(n,new PVector(0,10,0));
          angleN[2] = PVector.angleBetween(n,new PVector(0,0,10));
          
          page.pushMatrix();
            page.translate(c1.noeud.pos.x,c1.noeud.pos.y,c1.noeud.pos.z);
            page.rotateZ(angleN[2]);
            page.rotateY(angleN[1]);
            page.rotateX(angleN[0]);
            
            resultat.calculAxes();
          page.popMatrix();
          
        return resultat;
      }//fin calcukTriedre
  
  
}