

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