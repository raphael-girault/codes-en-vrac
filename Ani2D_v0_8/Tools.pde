/*
  Plusieurs classes avec des outils (math, géo, calcul matriciel, ...)
*/


class Tools {
  //PARAMETRES
    private PGraphics page;
  
  
  //CONSTRUCTEURS
    Tools(PGraphics page) {
      this.page = page;
    }
    
    
  //ENCAPSULATION
    public PGraphics getPage() { return page; }
}


class Tools3D extends Tools {
  
  //CONSTRUCTEURS
    Tools3D(PGraphics page) {
      super(page);
    }
    
    
  //METHODES
    //PUBLICS
      /*
        Renvoie le vecteur associé au 3 composantes donnés par modeX,Y,Z
        => les transformations devront déjà avoir été faites
      */
      public PVector getModel() {
        PGraphics p = this.getPage();
        return new PVector(p.modelX(0,0,0),p.modelY(0,0,0),p.modelZ(0,0,0));
      }//fin getModel
      
      
      
      /*
        Renvoie le vecteur associé au 3 composantes donnés par screenX,Y,Z
        => les transformations devront déjà avoir été faites
      */
      public PVector getScreen() {
        PGraphics p = this.getPage();
        return new PVector(p.screenX(0,0,0),p.screenY(0,0,0),p.screenZ(0,0,0));
      }//fin getScreen
      
  
}//fin Tools3D




class ToolsMath extends Tools {
  
  //CONSTRUCTEUS
    ToolsMath(PGraphics page) {
      super(page);
    }
    
    
  //METHODES
    //PUBLICS
      /*
        Convertit un point de l'espace dans le repère absolue en coordonnées
        sphériques.
        X : force du vecteur
        Y : longitude
        Z : lattitude
      */
      PVector cartesianToPolar(PVector theVector) {
        PVector res = new PVector();
        res.x = theVector.mag();
        if (res.x > 0) {
          res.y = -atan2(theVector.z, theVector.x);
          res.z = asin(theVector.y / res.x);
        } 
        else {
          res.y = 0;
          res.z = 0;
        }
        return res;
      }//fin cartesianToPolar
      
      
      PVector polarToCartesian2(PVector v , PVector centre) {
        if (centre == null) {
          centre = new PVector(0,0,0);
        }
        float r = v.z;
        float ax = v.x;
        float ay = v.y;
        PVector resultat = new PVector();
          resultat.z = centre.z + r * sin(ax) * cos(ay);
          resultat.x = centre.x + r * sin(ax) * sin(ay);
          resultat.y = centre.y + r * cos(ax);
        return resultat;
      }//fin polarToCartesian2
      
      
      
      
      /*
        Convertit les coordonnées sphériques en coordonnées cartésiennes.
        Le vecteur en entrée doit être composé comme tel :
        X : angle sur l'axe X
        Y : angle sur l'axe Y
        Z : pour le rayon
        
        On doit également ajouter le centre (ou si null, {0,0,0} utilisé).
      */
      PVector polarToCartesian(PVector v , PVector centre) {
        if (centre == null) {
          centre = new PVector(0,0,0);
        }
        float r = v.z;
        float ax = v.x;
        float ay = v.y;
        PVector resultat = new PVector();
          resultat.x = centre.x + r * sin(ax) * cos(ay);
          resultat.y = centre.y + r * sin(ax) * sin(ay);
          resultat.z = centre.z + r * cos(ax);
        return resultat;
      }//fin polarToCartesian
      
      
      
      
      /*
        Méthode qui permet d'obtenir la position dans l'espace avec des
        coordonnées cylindriques.
        Le vecteur en entrée doit être composé comme tel :
        X : distance sur l'axe à la base 
        Y : angle sur l'axe Y
        Z : pour le rayon
        
        on ajoute également la base basse du cylindre (ou si nul, {0,0,0} utilisé).
      */
      PVector cylinderToCartesian(PVector v , PVector base) {
        PVector resultat = new PVector();
          float r = v.z;
          float ax = v.x;
          float ay = v.y;
          resultat.z = base.z + r * cos(ay);
          resultat.x = base.x + r * sin(ay);
          resultat.y = base.y + v.x;
        return resultat;
      }//fin cylinderToCartesian
      
      
      
      
      /*
        Méthode qui permet d'obtenir la position dans l'espace avec des
        coordonnées cylindriques, mais pour une sphère ...
          => l'idée est en gros de prendre les coordonnées cylindriques
          pour les axes verticale et horizontal
        Le vecteur en entrée doit être composé comme tel :
        X : angle sur l'axe X
        Y : angle sur l'axe Y
        Z : pour le rayon
        
        on ajoute également la base basse du cylindre (ou si nul, {0,0,0} utilisé).
      */
      PVector doubleCylinderToCartesian(PVector v , PVector base) {
        PVector resultat = new PVector();
          float r = v.z;
          float ax = v.x;
          float ay = v.y;
          resultat.z = base.z + r * cos(ay);
          resultat.x = base.x + r * sin(ay);
          resultat.y = base.y +r * sin(ax);
        return resultat;
      }//fin doubleCylinderToCartesian
      
      
      
      /*
        Méthode permettant de calculer les lignes d'un convexe.
        Renvoie en soit l'ensemble des lignes (les croisées et non croisées).
      */
      float[][] getTangents(double x1, double y1, double r1, double x2, double y2, double r2) {
        double d_sq = (x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2);
        if (d_sq <= (r1-r2)*(r1-r2)) return new float[0][4];
      
        double d = Math.sqrt(d_sq);
        double vx = (x2 - x1) / d;
        double vy = (y2 - y1) / d;
      
        double[][] res = new double[4][4];
        int i = 0;
      
        // Let A, B be the centers, and C, D be points at which the tangent
        // touches first and second circle, and n be the normal vector to it.
        //
        // We have the system:
        //   n * n = 1          (n is a unit vector)          
        //   C = A + r1 * n
        //   D = B +/- r2 * n
        //   n * CD = 0         (common orthogonality)
        //
        // n * CD = n * (AB +/- r2*n - r1*n) = AB*n - (r1 -/+ r2) = 0,  <=>
        // AB * n = (r1 -/+ r2), <=>
        // v * n = (r1 -/+ r2) / d,  where v = AB/|AB| = AB/d
        // This is a linear equation in unknown vector n.
      
        for (int sign1 = +1; sign1 >= -1; sign1 -= 2) {
            double c = (r1 - sign1 * r2) / d;
      
            // Now we're just intersecting a line with a circle: v*n=c, n*n=1
      
            if (c*c > 1.0) continue;
            double h = Math.sqrt(Math.max(0.0, 1.0 - c*c));
      
            for (int sign2 = +1; sign2 >= -1; sign2 -= 2) {
                double nx = vx * c - sign2 * h * vy;
                double ny = vy * c + sign2 * h * vx;
      
                double[] a = res[i++];
                a[0] = x1 + r1 * nx;
                a[1] = y1 + r1 * ny;
                a[2] = x2 + sign1 * r2 * nx;
                a[3] = y2 + sign1 * r2 * ny;
            }
        }
        
        
        float[][] resultat = new float[4][4];
        
        for (int ii=0 ; ii<4 ; ii++) {
          for (int jj=0 ; jj<4 ; jj++) {
            resultat[ii][jj] = (float) res[ii][jj];
          }
        }
        
        return resultat;
      }//fin getTangents
      
      
      
      
      
      
      
      /*
        Méthode qui permet de savoir si un point cible (int[] point) est dans un polygone (PShape poly).
      */
      public boolean isInsidePolygon(PShape poly , int[] point) {
        //prépa
        PVector pos = new PVector(point[0],point[1]);
        PVector[] vertices = new PVector[poly.getVertexCount()];
        for (int k=0 ; k<poly.getVertexCount() ; k++) {
          vertices[k] = poly.getVertex(k);
        }
        
        //calculs
        int i, j=vertices.length-1;
        int sides = vertices.length;
        boolean oddNodes = false;
        for (i=0; i<sides; i++) {
            if ((vertices[i].y < pos.y && vertices[j].y >= pos.y || vertices[j].y < pos.y && vertices[i].y >= pos.y) && (vertices[i].x <= pos.x || vertices[j].x <= pos.x)) {
                  oddNodes^=(vertices[i].x + (pos.y-vertices[i].y)/(vertices[j].y - vertices[i].y)*(vertices[j].x-vertices[i].x)<pos.x);
            }
            j=i;
        }
        return oddNodes;
    }//fin isInsidePolygone
  
}//fin ToolsMath





class ToolsImg extends Tools {
  
  //CONSTRUCTEUS
    ToolsImg(PGraphics page) {
      super(page);
    }
    
    
    
  //METHODES
    //PUBLICS
      /*
        Méthode permettant de remplir l'image avec une couleur données en para.
      */
      public void remplirImg(PImage source , color couleur) {
        for (int i=0 ; i<source.pixels.length ; i++) {
          source.pixels[i] = couleur;
        }
      }//fin remplirImg
      
      
      
      /*
        Méthode permettant de remplir une zone d'un dessin d'une certaine taille.
        Le placement est donné par le coin sup gauche de la zone.
      */
      void remplirZoneImg(PImage img , int x , int y , int L , int H , color c) {
        //permet de remplir une zone d'une image avec une couleur
        //x et y représente les coordonnées du coin haut gauche de la zone de remplissage
        for (int i=0 ; i<L ; i++) {
          for (int j=0 ; j<H ; j++) {
            img.set(x+i , y+j , c);
          }
        }
      }//fin remplirZoneImg
      
      
      
      /*
        Pour supprimer les pixels hors de la forme (Cercle ici).
      */
      public void supprPixelsHorsCercle(PImage source) {
        //suppose que l'image est un carré avec le cercle en plein milieu
        int w = source.width/2;
        int h = source.height/2;
        int R = w;
        for (int j=0 ; j<source.height ; j++) {
          for (int i=0 ; i<source.width ; i++) {
            if (pow(R,2) >= pow(i-w,2) + pow(j-h,2)) {
              source.set(i,j,source.get(i,j));
            }
            else {
              source.set(i,j,color(0,0,0,0));
            }
          }
        } 
      }//finHorsCercle
      
      
      
      /*
        Permet de réaliser une rotation sur une image.
        L'image doit nécessaire être carré.
      */
      public PImage rotationImage(PImage source , float angle) {
        
        PImage tampon;
        
        int w = source.width;
        int h = source.height;
        
        float s = sin(angle);
        float c = cos (angle);
        
        int x0 = int(0.5 * (w-1));
        int y0 = int(0.5 * (h-1));
        
        tampon = createImage(w,h,ARGB);
        
        for (int i=0 ; i<w ; i++) {
          for (int j=0 ; j<h ; j++) {
            
            int a = i - x0;
            int b = j - y0;
            
            int x = int( a*c - b*s + x0 );
            int y = int( a*s + b*c + y0 );
            
            if (x>=0 && x<w && y>=0 && y<h) {
              tampon.set(i,j,source.get(x,y));
            }
            
          }
        }
        
        image(tampon , SCREEN_3D_SIZE_L,250);
        
        return tampon;
      }//fin rotationImage
      
      
      
      public PImage imgCopy(PImage source) {
        PImage resultat = createImage(source.width ,source.height , ARGB);
        for (int i=0 ; i<source.pixels.length ; i++) {
          resultat.pixels[i] = source.pixels[i];
        }
        return resultat;
      }
    
    
    
}//fin ToolsImg






class ToolsSaveLoad extends Tools {
  
  //CONSTRUCTEURS
    ToolsSaveLoad(PGraphics page) {
      super(page);
    }
    
    
    
  //METHODES
    //PUBLICS
      public void saveStructure(Structure structure) {
        
        //Création de l'objet à envoyer
          JSONObject json = new JSONObject();
          
        //création du lien
          String lien = "";
          if (structure.nom != null && !structure.nom.equals("")) {
            lien = sketchPath() + "/save/" + structure.nom + ".json";
          } else {
            int tailleListe = toolsFiles.listFileNames(sketchPath() + "/save").length;
            //on vérifie si le nom n'a pas déjà été donné, si oui, on ajoute "1" et on recommence le test
              int compteur = 0;
              boolean notEnded = true;
              while (notEnded) {
                structure.nom = "structure_" + str(tailleListe + compteur);
                try {
                  //le nom existe déjà
                  loadJSONObject(lien);
                  compteur++;
                } catch (Exception e) { //moche ...
                  //le nom n'existe pas
                  notEnded = false;
                }
              }//fin de la vérif
          }
          
          
        //Début du remplissage de l'objet JSON
          //pour la structure en elle-même
            json.setString("nom",structure.nom);
              JSONObject structurePos = new JSONObject();
              structurePos.setFloat("x",structure.noeudStructure.pos.x);
              structurePos.setFloat("y",structure.noeudStructure.pos.y);
              structurePos.setFloat("z",structure.noeudStructure.pos.z);
            json.setJSONObject("pos",structurePos);
              JSONObject structureAngle = new JSONObject();
              structureAngle.setFloat("x",structure.noeudStructure.angle.x);
              structureAngle.setFloat("y",structure.noeudStructure.angle.y);
              structureAngle.setFloat("z",structure.noeudStructure.angle.z);
            json.setJSONObject("angle",structureAngle);
            
            
        //pour les noeuds
          JSONArray structureNodes = new JSONArray();
          int compteur = 0;
          for (Noeud n : structure.noeuds) {
            JSONObject node = new JSONObject();
            node.setInt("id",n.idInStructure);
            //if (n.parent != null) {
            //  node.setInt("parent",n.parent.idInStructure);
            //} else {
            //  node.setInt("parent",-1);
            //}
              //=> pas encore mis le système de parenté
              JSONObject nodePos = new JSONObject();
              nodePos.setFloat("x",n.pos.x);
              nodePos.setFloat("y",n.pos.y);
              nodePos.setFloat("z",n.pos.z);
            node.setJSONObject("pos",nodePos);
              JSONObject nodeAngle = new JSONObject();
              nodeAngle.setFloat("x",n.angle.x);
              nodeAngle.setFloat("y",n.angle.y);
              nodeAngle.setFloat("z",n.angle.z);
            node.setJSONObject("angle",nodeAngle);
            
            structureNodes.setJSONObject(compteur,node);
            compteur++;
          }//fin du parcourt de la liste des noeuds
          
          json.setJSONArray("nodes",structureNodes);
          
          
        //pour les formes
          JSONArray structureFormes = new JSONArray();
          compteur = 0;
          for (Forme f : structure.formes) {
            JSONObject forme = new JSONObject();
            forme.setInt("id",f.idInStructure);
            String typeForme = f.getClass().getSimpleName();
            if (typeForme.equals("Cercle")) {
              forme.setString("type","cercle");
              forme.setFloat("diametre",((Cercle) f).D);
              forme.setInt("idNoeud",((Cercle) f).noeud.idInStructure);
            } else if (typeForme.equals("Convexe")) {
              forme.setString("type","convexe");
                JSONArray listeCercles = new JSONArray();
                listeCercles.setInt(0,((Convexe) f).c1.idInStructure);
                listeCercles.setInt(1,((Convexe) f).c2.idInStructure);
              forme.setJSONArray("cercles",listeCercles);
            } else if (typeForme.equals("Plan")) {
              forme.setString("type","plan");
                //on récupère la liste de cercles et de convexes pour recréer le plan dans le chargement
                  //=> non, on ne récupère pas la liste de convexes en faite , on la recrée à partir de
                  //la liste de convexes qu'il faut donc réaliser en première.
                  //JSONArray listeConvexes = new JSONArray();
                  //int compteurConvexes = 0;
                  //for (Convexe c : ((Plan) f).convexes) {
                  //  listeConvexes.setInt(compteurConvexes,c.idInStructure);
                  //  compteurConvexes++;
                  //}
                //forme.setJSONArray("convexes",listeConvexes);
                  JSONArray listeCercles = new JSONArray();
                  int compteurCercles = 0;
                  for (Cercle c : ((Plan) f).cercles) {
                    listeCercles.setInt(compteurCercles,c.idInStructure);
                    compteurCercles++;
                  }
                forme.setJSONArray("cercles",listeCercles);
            }
            
            //forme.setJSONObject("texture",getJsonTexture(f));
            //récup de la liste de dessins
              JSONArray formeDessins = new JSONArray();
              int compteurDessins = 0;
              for (Dessin dessin : f.dessins) {
                JSONObject jsonDessin = new JSONObject();
                jsonDessin.setString("lienImg",dessin.lienImg);
                  JSONObject dessinPos = new JSONObject();
                    dessinPos.setFloat("x",dessin.noeud.pos.x);
                    dessinPos.setFloat("y",dessin.noeud.pos.y);
                    dessinPos.setFloat("z",dessin.noeud.pos.z);
                jsonDessin.setJSONObject("coordonnees",dessinPos);
                formeDessins.setJSONObject(compteurDessins , jsonDessin);
                compteurDessins++;
              }
              forme.setJSONArray("dessins",formeDessins);
            
            structureFormes.setJSONObject(compteur,forme);
            compteur++;
          }//fin du parcourt de la liste des formes
          
          json.setJSONArray("formes",structureFormes);
      
          
          //et sauvegarde
          saveJSONObject(json,"save/" + structure.nom + ".json");

      }//fin saveStructure
      
      
      
      
      
      
      Structure loadStructure(String nom , PGraphics pg) {
  
      //on commence par récupérer le fichier
        String lien = sketchPath() + "/save/" + nom;
        JSONObject json = loadJSONObject(lien);
        
      //on crée ensuite la structure
        Structure structure = new Structure(pg);
        structure.nom = json.getString("nom");
          JSONObject structurePos = json.getJSONObject("pos");
          structure.noeudStructure.pos.x = structurePos.getInt("x");
          structure.noeudStructure.pos.y = structurePos.getInt("y");
          structure.noeudStructure.pos.z = structurePos.getInt("z");
          JSONObject structureAngle = json.getJSONObject("angle");
          structure.noeudStructure.angle.x = structureAngle.getFloat("x");
          structure.noeudStructure.angle.y = structureAngle.getFloat("y");
          structure.noeudStructure.angle.z = structureAngle.getFloat("z");
          
          
        //on commence par récupérer les noeuds
          JSONArray listeNoeuds = json.getJSONArray("nodes");
            for (int i=0 ; i<listeNoeuds.size() ; i++) {
              Noeud n = new Noeud(pg);
              JSONObject noeud = listeNoeuds.getJSONObject(i);
              n.idInStructure = noeud.getInt("id");
                JSONObject noeudPos = noeud.getJSONObject("pos");
                n.pos = new PVector();
                n.pos.x = noeudPos.getInt("x");
                n.pos.y = noeudPos.getInt("y");
                n.pos.z = noeudPos.getInt("z");
                JSONObject noeudAngle = noeud.getJSONObject("angle");
                n.angle = new PVector();
                n.angle.x = noeudAngle.getFloat("x");
                n.angle.y = noeudAngle.getFloat("y");
                n.angle.z = noeudAngle.getFloat("z");
                
                structure.ajoutNodeLoad(n);
            }
            //on fait l'ajout des parents après vu qu'on a besoin des id de tous les noeuds
            //for (int i=0 ; i<listeNoeuds.size() ; i++) {
            //  JSONObject noeud = listeNoeuds.getJSONObject(i);
            //  Noeud n = structure.getNodeByIdInStructure(noeud.getInt("id"));
            //  if (n != null) {
            //    //on regarde d'abord si le noeud à un parent
            //      n.parent = structure.getNodeByIdInStructure(noeud.getInt("parent"));
            //      //pas besoin de if : la fonction renvoie null pour -1 vu qu'aucun id mis à cette valeur
            //  }
            //}
            
            
        //on récupère maintenant les formes
          //on doit commencer par récupérer tous les cercles, puis ensuite les autres formes
          JSONArray listeFormes = json.getJSONArray("formes");
            //récup des cercles
            for (int i=0 ; i<listeFormes.size() ; i++) {
              JSONObject forme = listeFormes.getJSONObject(i);
              String type = forme.getString("type");
              if (type.equals("cercle")) {
                Cercle c = new Cercle(pg);
                Noeud n = structure.getNoeudByIdInStructure(forme.getInt("idNoeud"));
                c.noeud = n;
                c.D = forme.getInt("diametre");
                c.idInStructure = forme.getInt("id");
                //c.tex.dessins = loadJsonTextureDessin(forme.getJSONArray("texture"));
                //c.tex.retraits = loadJsonTextureRetrait(forme.getJSONArray("texture"));
                //loadJsonTexture(c.tex,forme.getJSONObject("texture"));
                for (int k=0 ; k<forme.getJSONArray("dessins").size() ; i++) {
                  JSONObject dessin = (JSONObject) forme.getJSONArray("dessin").get(k);
                  //Dessin d = new Dessin();
                  String lienImg = dessin.getString("lienImg");
                  //d.img = loadImage(d.lienImg);
                    JSONObject coordonnees = dessin.getJSONObject("coordonnees");
                    PVector posTexture = new PVector();
                    posTexture.x = coordonnees.getFloat("x");
                    posTexture.y = coordonnees.getFloat("y");
                    posTexture.z = coordonnees.getFloat("z");
                  NoeudTexture noeudT = new NoeudTexture(pg , c , posTexture);
                  Dessin d = new Dessin(lienImg,noeudT);
                  
                  c.ajouterDessin(d);
                }
                
                structure.ajoutForme(c);
                  ////et recalcul de la taille de la map
                  //c.tex.creationMap();
              }
            }//fin de la récupération des cercles

            //récup des convexes
            for (int i=0 ; i<listeFormes.size() ; i++) {
              JSONObject forme = listeFormes.getJSONObject(i);
              String type = forme.getString("type");
              if (type.equals("convexe")) {
                Cercle c1 = structure.getCercleById(forme.getJSONArray("cercles").getInt(0));
                Cercle c2 = structure.getCercleById(forme.getJSONArray("cercles").getInt(1));
                Convexe c = new Convexe(pg,c1,c2);
                c.idInStructure = forme.getInt("id");
                //c.tex.dessins = loadJsonTextureDessin(forme.getJSONArray("texture"));
                //c.tex.retraits = loadJsonTextureRetrait(forme.getJSONArray("texture"));
                //loadJsonTexture(c.tex,forme.getJSONObject("texture"));
                for (int k=0 ; k<forme.getJSONArray("dessins").size() ; i++) {
                  JSONObject dessin = (JSONObject) forme.getJSONArray("dessin").get(k);
                  //Dessin d = new Dessin();
                  String lienImg = dessin.getString("lienImg");
                  //d.img = loadImage(d.lienImg);
                    JSONObject coordonnees = dessin.getJSONObject("coordonnees");
                    PVector posTexture = new PVector();
                    posTexture.x = coordonnees.getFloat("x");
                    posTexture.y = coordonnees.getFloat("y");
                    posTexture.z = coordonnees.getFloat("z");
                  //d.noeud = new NoeudTexture(pg , c , posTexture);
                  NoeudTexture noeudT = new NoeudTexture(pg , c , posTexture);
                  Dessin d = new Dessin(lienImg,noeudT);
                  
                  c.ajouterDessin(d);
                }
                structure.ajoutForme(c);
                
              }
              
            }//fin de la récupération des convexes
            
            
            
          //on récupère maintenant les plans
            for (int i=0 ; i<listeFormes.size() ; i++) { 
              JSONObject forme = listeFormes.getJSONObject(i);
              String type = forme.getString("type");
              if (type.equals("plan")) {
                ArrayList<Cercle> cercles = new ArrayList<Cercle>();
                for (int j=0 ; j<forme.getJSONArray("cercles").size() ; j++) {
                  Cercle c = structure.getCercleById(forme.getJSONArray("cercles").getInt(j));
                  cercles.add(c);
                }
                //on récupère maintenant la liste de convexes en fonction de la liste de cercles récupérées
                  ArrayList<Convexe> convexes = new ArrayList<Convexe>();
                  for (int k=0 ; k<cercles.size()-1 ; k++) {
                    Convexe cv = structure.getConvexeFromCercles(cercles.get(k),cercles.get(k+1));
                    convexes.add(cv);
                  }
                  //et dernier convexes
                    convexes.add(structure.getConvexeFromCercles(cercles.get(0),cercles.get(cercles.size()-1)));
                  //on peut donc créer le plan
                    Plan p = new Plan(pg,convexes);
                    p.idInStructure = forme.getInt("id");
                    //p.tex.dessins = loadJsonTextureDessin(forme.getJSONArray("texture"));
                    //p.tex.retraits = loadJsonTextureRetrait(forme.getJSONArray("texture"));
                    //loadJsonTexture(p.tex,forme.getJSONObject("texture"));
                    for (int k=0 ; k<forme.getJSONArray("dessins").size() ; k++) {
                      JSONObject dessin = (JSONObject) forme.getJSONArray("dessins").get(k);
                      //Dessin d = new Dessin();
                      String lienImg = dessin.getString("lienImg");
                      //d.img = loadImage(d.lienImg);
                        JSONObject coordonnees = dessin.getJSONObject("coordonnees");
                        PVector posTexture = new PVector();
                        posTexture.x = coordonnees.getFloat("x");
                        posTexture.y = coordonnees.getFloat("y");
                        posTexture.z = coordonnees.getFloat("z");
                      //d.noeud = new NoeudTexture(pg , p , posTexture);
                      NoeudTexture noeudT = new NoeudTexture(pg , p , posTexture);
                      Dessin d = new Dessin(lienImg , noeudT);
                      
                      p.ajouterDessin(d);
                    }
                
                structure.ajoutForme(p);
              }
              
            }//fin de la récupération des plans
            
               

      return structure;
    }//fin de la fonction loadStructure()
    
    
    
    //PRIVEES
  
  
  
}//fin ToolsSaveLoad




class ToolsFiles extends Tools {
  
  //CONSTRUCTEURS
    ToolsFiles(PGraphics page) {
      super(page);
    }
    
    
  //METHODES
    //PUBLICS
      String[] listFileNames(String dir) {
        File file = new File(dir);
        if (file.isDirectory()) {
          String names[] = file.list();
          return names;
        } else {
          // If it's not a directory
          return null;
        }
      }//fin listFileNames
      
      
      
      
      String[] getFilesByExtension(String lien , String[] extensions) {
        String[] resultat = new String[0];// = new ArrayList<String>();
        
        //String path = sketchPath();
        String[] filenames = listFileNames(lien);
        
        for (int i=0 ; i<filenames.length ; i++) {
          
          if (extensions != null) {
            for (String extension : extensions) {
              
              String extensionFile = filenames[i].substring(filenames[i].indexOf(".")+1);
              if (extensionFile.equals(extension)) {
                //resultat.add(filenames[i]);
                resultat = append(resultat,filenames[i]);
              }
              
            }
          } else {
            //resultat.add(filenames[i]);
            resultat = append(resultat,filenames[i]);
          }
          
          
        }
        
        return resultat;
      }//fin de la fonction getFilesByExtension()
    
    
    
    //PRIVEES
  
}//fin ToolsFiles



class ToolsGui extends Tools {
  
  //PARAMETRES
    ControlP5 cp5;
  
  
  //CONSTRUCTEURS
    ToolsGui(PGraphics page , PApplet pApp) {
      super(page);
      cp5 = new ControlP5(pApp);
      
      creationGui();
    }
    
    
  //METHODES
    //PUBLICS
      public void creationGui() {
        creationControlesModifStructure();
      }//fin creationGui
      
      
      //CALLBACKS
        public void controllerNomStructure(String text) {
          ((ModeEditionStructure) mode).structure.nom = text;
        }//fin controllerNomStructure
        
        public void controllerSauvegarder(int theValue) {
          mode.actionSelect = "sauvegarder";
        }//fin controllerSauvegarder
        
        public void controllerCharger(int theValue) {
          mode.actionSelect = "charger";
        }//fin controllerCharger
      
      
      
    //PRIVEES
      private void creationControlesModifStructure() {
        Group g1 = cp5.addGroup("Controles Modif Structure")
                      .setPosition(SCREEN_3D_X + SCREEN_3D_SIZE_L + 10,10)
                      .setBackgroundColor(GUI_COLOR_BACK)
                      .setBackgroundHeight(200)
                      .setWidth(200)
                      ;
        
                  cp5.addTextfield(this,"controllerNomStructure")
                      .setPosition(10,10)
                      .setSize(80,19)
                      .setColorLabel(color(255))
                      .setAutoClear(false)
                      .setText(((ModeEditionStructure) mode).structure.nom)
                      .moveTo(g1)
                      ;
                      
                  cp5.addButton(this,"controllerSauvegarder")
                     .setValue(0)
                     .setLabel("Save")
                     .setPosition(110,10)
                     .setSize(80,19)
                     .moveTo(g1)
                     ;
                
                  cp5.addButton(this,"controllerCharger")
                     .setValue(0)
                     .setLabel("Charger")
                     .setPosition(110,45)
                     .setSize(80,19)
                     .moveTo(g1)
                     ;
                      
                   cp5.addScrollableList(this,"controllerSelectionStructure")
                      .setPosition(10,45)
                      .setSize(80,55)   
                      .setGroup(g1)
                      .setLabel("Select Structure")
                      .close()
                      //.addItems( listFileNames(sketchPath()) )
                      .addItems(toolsFiles.getFilesByExtension(sketchPath()+"/save",new String[]{"json"}))
                      ;
                      
                   cp5.addColorPicker("controllerCouleurAllFormesStructure" , 10,110,80,10)
                      .setColorValue(color(255, 255, 255, 255))
                      .setGroup(g1)
                      ;

      }//fin creationControlesModifStructure
      
      
      
      
      
  
}