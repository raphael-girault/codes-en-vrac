


class Convexe extends Forme {
  
  //PARAMETRES
    Cercle c1;
    Cercle c2;
    
    float[][] p = new float[4][2]; //tableau avec coordonnées des points du convexe
    
    
  
  //CONSTRUCTEURS
    Convexe (PGraphics page , Cercle c1 , Cercle c2) {
      super(page);
      this.c1 = c1;
      this.c2 = c2;
    }
    
    Convexe(PGraphics page) {
      super(page);
    }
    
    Convexe (PGraphics page , Cercle c1 , Cercle c2 , int idInStructure) {
      super(page,idInStructure);
      this.c1 = c1;
      this.c2 = c2;
    }
    
    
  
  //METHODES
    //OVERRIDE de Forme
      public void affichageForme(float pz) {
        //this.affichageStroke();
        //on retire l'affichage des cercles et on modifie leur variable profondeurAffichage
          c1.setAfficherForme(false);
          c2.setAfficherForme(false);
          c1.profondeurAffichage = pz;
          c2.profondeurAffichage = pz;
          c1.noeud.calculPosR();
          c2.noeud.calculPosR();
          
        //calcul du convexe
          calculConvexe();
        
        //affichage de la forme
          page.fill(this.couleurBasique);
          page.noStroke();
          page.pushMatrix();
            cam.contreRot();
            page.translate(0,0,pz);
            //on commence par placer les cercles
              //page.ellipseMode(CENTER);
              //page.ellipse(c1.noeud.posR.x-page.width/2 , c1.noeud.posR.y-page.height/2 , c1.D,c1.D);
              //page.ellipse(c2.noeud.posR.x-page.width/2 , c2.noeud.posR.y-page.height/2 , c2.D,c2.D);
            //affichage des strokes (juste pour le convexe, notamment pour la sélection)
              //this.affichageStroke();
            //on place ensuite le convexe
              page.quad(p[0][0],p[0][1] , p[1][0],p[1][1] , p[2][0],p[2][1] , p[3][0],p[3][1]);
              //page.beginShape();
              //  page.vertex(p[0][0],p[0][1]);
              //  page.vertex(p[1][0],p[1][1]);
              //  page.vertex(p[2][0],p[2][1]);
              //  page.vertex(p[3][0],p[3][1]);
              //page.endShape(CLOSE);
          page.popMatrix();        
          
          //affichage des cercles par le convexe
            c1.affichageAnnexe(pz);
            c2.affichageAnnexe(pz);
      }//fin affichageForme
      
      
      
      public void affichageStroke(float pz) {
        //calcul du convexe
          calculConvexe();
        
        //affichage de la forme
          page.noFill();
          page.pushMatrix();
            cam.contreRot();
            page.translate(0,0,pz + 2);
            //affichage des strokes (juste pour le convexe, notamment pour la sélection)
              if (afficherStroke) {
                if (select) {
                  page.stroke(FORME_COLOR_STROKE_SELECT);
                } else {
                  page.stroke(FORME_COLOR_STROKE);
                }
              } else {
                page.noStroke();
              }
            //on place ensuite le convexe
              page.quad(p[0][0],p[0][1] , p[1][0],p[1][1] , p[2][0],p[2][1] , p[3][0],p[3][1]);
          page.popMatrix();      
      }//fin affichageStroke
      
      
      
      public void affichageTexture(float pz) {  
        //calcul du convexe
          calculConvexe();
          
        //on place l'image dans la scène 3D
          page.pushMatrix();
            //page.translate(c1.noeud.pos.x,c1.noeud.pos.y,c1.noeud.pos.z);
            cam.contreRot();
            page.noStroke();
            page.noFill();
            int w = imgTexture.width/2;
            int h = imgTexture.height/2;
            
              PShape s = createShape();
              page.translate(0,0,pz+1);
              s.beginShape();
                s.vertex(p[0][0],p[0][1],0,0);
                s.vertex(p[1][0],p[1][1],w*2,0);
                s.vertex(p[2][0],p[2][1],w*2,h*2);
                s.vertex(p[3][0],p[3][1],0,h*2);
              s.endShape(CLOSE);
              
              s.setStroke(0);
              s.setFill(false);
              s.setTexture(imgTexture);
              
              page.shape(s);
                //=> pas terrible, mais au moins ça fonctionne ...
            
          page.popMatrix();
          
          //affichage du noeud de texture
            for (Dessin dessin : dessins) {
              page.pushMatrix();
                //page.translate(noeud.pos.x,noeud.pos.y,noeud.pos.z);
                dessin.noeud.affichage();
              page.popMatrix();
            }
      }//fin affichageTexture
      
      
      
      public void createImgTexture() {
        int Dmax = int(max(c1.D,c2.D));
        imgTexture = createImage(Dmax,int(dist(c1.noeud.pos.x,c1.noeud.pos.y,c1.noeud.pos.z,c2.noeud.pos.x,c2.noeud.pos.y,c2.noeud.pos.z)),ARGB);
        toolsImg.remplirImg(imgTexture,color(0,0));
      }//createImgTexture
      
      
      
      
      public boolean pointInForme(int x , int y) {
        PShape sh = createShape();
        calculConvexe();
        sh.beginShape();
          for (float[] pt : p) {
            sh.vertex(pt[0]+page.width/2,pt[1]+page.height/2); 
              //=> à priori, l'ajout est nécessaire car on fait le retrait en amont et ça pose problème ... je suppose ...
          }
        return toolsMath.isInsidePolygon(sh,new int[]{x,y});
      }//fin pointInForme
      
      
      
      public void placementDessins() {
          //float[] zz = calculProfondeurAffichage();
          //float Z = zz[0];
          //float ZS = zz[1];
          //float Dmax = max(c1.D,c2.D);
          
          for (Dessin dessin : dessins) {
            
            for (int j=0 ; j<dessin.img.height ; j++) {
              for (int i=0 ; i<dessin.img.width ; i++) {
                //float ax,ay;
                //ay = (float(i-dessin.img.width) / (Dmax/2)) + c1.noeud.getAngleAffichage()[0];
                //ax = (float(j-dessin.img.height) / (Dmax/2)) + dessin.noeud.coordonnees.y + c1.noeud.getAngleAffichage()[1];
                //int px = int(Dmax/2 +  (Dmax/2 + 1) * sin(ax) );
                //int pz = int( (Dmax/2 + 1) * cos(ax) );
                //int py = int(imgTexture.height*dessin.noeud.coordonnees.x) + int( (Dmax/2 + 1) * -sin(ay) );
                //if (pz > 0 && alpha(dessin.img.get(i,j))>1 && px>=0 && px<imgTexture.width && py>=0 && py<imgTexture.height) {
                //  toolsImg.remplirZoneImg(imgTexture , int(px) , int(py) , 2,2 , dessin.img.get(i,j));
                //} 
                
                int px,py,pz;
                py = int(imgTexture.height*dessin.noeud.coordonnees.x - dessin.img.height + j + dessin.img.height/2);
                //float ay = (float(i - dessin.img.width/2) / (c1.D/2)) + dessin.noeud.coordonnees.y + c1.noeud.getAngleAffichage()[1] + PI;
                  float ay = (float(i - dessin.img.width/2) / (c1.D/2)) + dessin.noeud.coordonnees.y + c1.noeud.getAngleAffichage()[1] + HALF_PI;
                px = int( c1.D/2 + (c1.D/2) * cos(ay) );
                pz = int( (c1.D/2) * sin(ay) );

                if (pz>0 && alpha(dessin.img.get(i,j))>1 && abs(px - dessin.img.width)>=0 && abs(py - dessin.img.height)>=0) {
                  imgTexture.set(px,py,dessin.img.pixels[i+j*dessin.img.width]);
                }
                
              }
            }

          }//fin du parcourt de la liste de dessins
          
          //image(imgTexture,SCREEN_3D_SIZE_L,0,imgTexture.width,imgTexture.height);
          
      }//fin placementDessins
      
      
      
      
      public void calculProfondeurAffichage() {
        float Z = 0;
        float ZS = 0;
          c1.noeud.calculPosR();
          c2.noeud.calculPosR();
          //if (c1.noeud.posR.z > c2.noeud.posR.z) {
          //  ZS = c1.noeud.posR.z;
          //} else {
          //  ZS = c2.noeud.posR.z;
          //}
          
          this.profondeurAffichage = max(c1.noeud.posR.z,c2.noeud.posR.z);
      }//fin calculProfondeurAffichage
      
      
      
      
    //PUBLICS
    
    
    
    
    //PRIVEES
      private void calculConvexe() {
        //float[][] pts = toolsMath.getTangents(c1.xS,c1.yS,c1.D/2,c2.xS,c2.yS,c2.D/2);
        float[][] pts = toolsMath.getTangents(c1.noeud.posR.x,c1.noeud.posR.y,c1.D/2 , c2.noeud.posR.x,c2.noeud.posR.y,c2.D/2);
        if (pts.length > 0) {
          //p[0] = new float[]{pts[0][0]-width/2,pts[0][1]-height/2};
          //p[1] = new float[]{pts[1][0]-width/2,pts[1][1]-height/2};
          //p[2] = new float[]{pts[1][2]-width/2,pts[1][3]-height/2};
          //p[3] = new float[]{pts[0][2]-width/2,pts[0][3]-height/2};
          
          //p[0] = new float[]{pts[0][0]-page.width/2,pts[0][1]-page.height/2};
          //p[1] = new float[]{pts[1][0]-page.width/2,pts[1][1]-page.height/2};
          //p[2] = new float[]{pts[1][2]-page.width/2,pts[1][3]-page.height/2};
          //p[3] = new float[]{pts[0][2]-page.width/2,pts[0][3]-page.height/2};
          
          PVector vS = tools3D.getScreen();
          p[0] = new float[]{pts[0][0]-vS.x,pts[0][1]-vS.y};
          p[1] = new float[]{pts[1][0]-vS.x,pts[1][1]-vS.y};
          p[2] = new float[]{pts[1][2]-vS.x,pts[1][3]-vS.y};
          p[3] = new float[]{pts[0][2]-vS.x,pts[0][3]-vS.y};
        }
      }//fin calculConvexe
      
      
      
      //private float[] calculProfondeurAffichage() {
      //  float Z = 0;
      //  float ZS = 0;
      //    c1.noeud.calculPosR();
      //    c2.noeud.calculPosR();
      //    if (c1.noeud.posR.z > c2.noeud.posR.z) {
      //      Z = c1.noeud.pos.z;
      //      ZS = c1.noeud.posR.z;
      //    } else {
      //      Z = c2.noeud.pos.z;
      //      ZS = c2.noeud.posR.z;
      //    }
      //  return new float[]{Z,ZS};
      //}//fin calculProfondeurAffichage
 
      
  
}