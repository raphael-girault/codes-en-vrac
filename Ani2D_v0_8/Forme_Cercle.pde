


class Cercle extends Forme {
  
  //PARAMETRES
    float D = 50;
    Noeud noeud;
    
    
  
  //CONSTRUCTEURS
    Cercle (PGraphics page , Noeud noeud) {
      super(page);
      this.noeud = noeud;
    }
    
    Cercle (PGraphics page) {
      super(page);
    }
    
    Cercle (PGraphics page , Noeud noeud , int idInStructure) {
      super(page,idInStructure);
      this.noeud = noeud;
    }
  
  
  
  //METHODES
    //OVERRIDE de Forme
      public void affichageForme(float pz) {
        page.fill(this.couleurBasique);
        //this.affichageStroke();
        page.ellipseMode(CENTER);
        page.pushMatrix();
          //page.translate(noeud.pos.x,noeud.pos.y,pz);
          cam.contreRot();
            page.translate(0,0,pz);
          //page.ellipse(0,0,D,D);
          //page.ellipse(noeud.posR.x-page.width/2,noeud.posR.y-page.height/2,D,D);
            PVector vS = tools3D.getScreen();
            page.ellipse(noeud.posR.x-vS.x,noeud.posR.y-vS.y,D,D);
        page.popMatrix();
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
        page.ellipseMode(CENTER);
        page.pushMatrix();
          //page.translate(noeud.pos.x,noeud.pos.y,pz);
          cam.contreRot();
            page.translate(0,0,pz+2);
          //page.ellipse(0,0,D,D);
          //page.ellipse(noeud.posR.x-page.width/2,noeud.posR.y-page.height/2,D,D);
            PVector vS = tools3D.getScreen();
            page.ellipse(noeud.posR.x-vS.x,noeud.posR.y-vS.y,D,D);
        page.popMatrix();
      }//fin affichageStroke
      
      
      
      public void createImgTexture() {
        imgTexture = createImage(int(D),int(D),ARGB);
        toolsImg.remplirImg(imgTexture,color(0,0));
      }//fin createImgTexture
      
      
      
      public void affichageTexture(float pz) {
        //on commence par supprimer les pixels hors du cercle
          toolsImg.supprPixelsHorsCercle(imgTexture);
        //on place l'image dans la scène 3D
          page.pushMatrix();
            //page.translate(noeud.pos.x,noeud.pos.y,pz);
            cam.contreRot();
              PVector vS = tools3D.getScreen();
              page.translate(noeud.posR.x-vS.x,noeud.posR.y-vS.y,pz+1);
            page.noStroke();
            page.noFill();
            int w = imgTexture.width/2;
            int h = imgTexture.height/2;
              page.beginShape();
                page.texture(imgTexture);
                page.vertex(-w,-h,0,0);
                page.vertex(w,-h,w*2,0);
                page.vertex(w,h,w*2,h*2);
                page.vertex(-w,h,0,h*2);
              page.endShape(CLOSE);
          page.popMatrix();
          
          //affichage du noeud de texture
            for (Dessin dessin : dessins) {
              page.pushMatrix();
                //page.translate(noeud.pos.x,noeud.pos.y,noeud.pos.z);
                dessin.noeud.affichage();
              page.popMatrix();
            }
      }//fin affichageTexture
      
      
      
      public boolean pointInForme(int x , int y) {
        //on commence par calculer la position du noeud dans l'écran
          noeud.calculPosR();
        //et on envoie la rép
          //return (pow(D/2,2) >= pow(noeud.posR.x-page.width/2 - x,2) + pow(noeud.posR.y-page.height/2 - y,2));
          return (pow(D/2,2) >= pow(noeud.posR.x - x,2) + pow(noeud.posR.y - y,2));
      }//fin pointInForme
      
      
      
      
      public void placementDessins() {
        //calcul de la position relative du noeud sur l'écran
          noeud.calculPosR();
        //reset de l'image
        //parcourt de la lste de desins
          for (Dessin dessin : dessins) {
            
            //for (int j=0 ; j<dessin.img.height ; j++) {
            //  for (int i=0 ; i<dessin.img.width ; i++) {
            //      float ax,ay;
            //      //ay = (float(i-dessin.img.width) / (D/2)) + dessin.angle.x + noeud.getAngleAffichage()[0];
            //      //ax = (float(j-dessin.img.height) / (D/2)) + dessin.angle.y + noeud.getAngleAffichage()[1];
            //      ay = (float(i-dessin.img.width) / (D/2)) + dessin.noeud.coordonnees.x + noeud.getAngleAffichage()[0];
            //      ax = (float(j-dessin.img.height) / (D/2)) + dessin.noeud.coordonnees.y + noeud.getAngleAffichage()[1];
            //      int px = int( D/2 - (D/2+1) * sin(ax) );
            //      int pz = int(noeud.pos.z) + min(int( (D/2+1) * cos(ax) ) , int( (D/2+1) * sin(ay+HALF_PI) )); //semble ok
            //      int py = int( D/2 - (D/2+1) * -sin(ay) );
            //        if (pz>noeud.pos.z && alpha(dessin.img.get(i,j))>1) {
            //          //d'abord vérifier que le pixel n'est pas vide
            //          toolsImg.remplirZoneImg(imgTexture , px , py , 2,2 , dessin.img.get(i,j));
            //        }
            //  }
            //}
            
            
            for (int j=0 ; j<dessin.img.height ; j++) {
              for (int i=0 ; i<dessin.img.width ; i++) {
                  int px,py,pz;
                  
                  float ax = (float(j - dessin.img.height/2) / (D/2)) + dessin.noeud.coordonnees.x + noeud.getAngleAffichage()[0] + HALF_PI;
                  float ay = (float(i - dessin.img.width/2) / (D/2)) + dessin.noeud.coordonnees.y + noeud.getAngleAffichage()[1] - HALF_PI;
                  px = int( D/2 - (D/2) * cos(ay) );
                  py = int( D/2 - (D/2) * cos(ax) );
                  pz = min(int( (D/2) * sin(ay) ) , int( (D/2) * sin(ax) ));
                  
                  if (pz<0 && alpha(dessin.img.get(i,j))>1 && abs(px - dessin.img.width)>=0 && abs(py - dessin.img.height)>=0) {
                    imgTexture.set(px,py,dessin.img.pixels[i+j*dessin.img.width]);
                  }
                  
              }
            }
            
            
            //image(imgTexture,SCREEN_3D_SIZE_L,0,imgTexture.width,imgTexture.height);
            
            
            
          }//fin du parcourt de la liste de dessins
      }//fin placementDessins
      
      
      
      
      
      public void calculProfondeurAffichage() {
        noeud.calculPosR();
        this.profondeurAffichage = noeud.posR.z;
      }//fin calculProfondeurAffichage
      
}