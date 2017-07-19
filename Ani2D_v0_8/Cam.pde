/*
  Classe pour la caméra 3D.
*/


class Cam {
  
  //PARAMETRES
    private PGraphics page;
    private PVector point;
    private PVector obs;
    private PVector eye;
    private PVector angle; //angle de la cam
    
    private float zoom = 30.;

    
  
  //CONSTRUCTEURS
    Cam (PGraphics page) {
      this.page = page;
      resetCam();
    }
  
  
  
  //METHODES
    //PUBLICS
      public void resetCam() {
        this.point = new PVector(0,0,100);
        this.obs = new PVector(0,0,0);
        this.eye = new PVector(0,1,0);
        this.angle = new PVector(0,HALF_PI,0);
        this.zoom = 30.;
      }//fin resetCam
    
    
    
      public void refreshCam() {
        calculPosCam();
        page.camera(point.x,point.y,point.z,obs.x,obs.y,obs.z,eye.x,eye.y,eye.z);
        page.ortho();
        //page.frustum(-zoom , zoom , -zoom , zoom , 10 , 500); //=> ne marche pas vraiment : pb lors de rotation
      }//fin refreshCam
      
      
      
      public void contreRot() {
        page.rotateY(HALF_PI-angle.y);
        page.rotateX(-angle.x);
      }//fin contreRot
      
      
      
      /*
        Méthode pour le déplacement de la cam dans la scène 3D (en fonction de la
        rotation).
      */
      public void deplacement(int dx , int dy) {
        //création d'un triedre
          Triedre triedre = new Triedre(page);
        //calcul de la pos des axes avec contre rot
          triedre.calculAxesContreRot();
        //utilisatin des vecteurs X et Y pour bouget la cam
          PVector deplacementX = triedre.X.mult(dx).div(TRIEDRE_L_AXE);
          PVector deplacementY = triedre.Y.mult(dy).div(TRIEDRE_L_AXE);
          obs.add(deplacementX);
          obs.add(deplacementY);
          point.add(deplacementX);
          point.add(deplacementY);
      }//fin deplacement
      
      
      
      
      /*
        Méthode pour récupérer le déplacement de la souris dans la scène 3D.
        Renvoie un vecteur de ce déplacement.
      */
      public PVector getSourisDeplacement3D() {
        //calcul de la diff
          int dx = mouseX - pmouseX;
          int dy = mouseY - pmouseY;
        //création d'un trièdre
          Triedre triedre = new Triedre(page);
        //calcul de la pos des axes avec contre rot
          triedre.calculAxesContreRot();
        //utilisatin des vecteurs X et Y créer
          PVector deplacementX = triedre.X.mult(dx);
          PVector deplacementY = triedre.Y.mult(dy);
        //renvoie de la somme des deux vecteurs
          return deplacementX.add(deplacementY).div(TRIEDRE_L_AXE);
      }//fin getSourisDeplacement3D
      
      
      
      
      /*
        Méthode pour récupérer la position de la souris dans la scène 3D.
        Position en fonction du point observé si aucun point indiqué.
      */
      public PVector getPosSouris3D(PVector cible) {
        if (cible == null) {
          cible = obs.copy();
        }
        //récup de la pos dans l'écran du point observé
          page.pushMatrix();
            page.translate(cible.x,cible.y,cible.z);
            PVector cibleS = tools3D.getScreen();
          page.popMatrix();
        //calcul de la diff
          int dx = int(mouseX - cibleS.x);
          int dy = int(mouseY - cibleS.y);
        //création d'un trièdre
          Triedre triedre = new Triedre(page);
        //calcul de la pos des axes avec contre rot
          triedre.calculAxesContreRot();
        //utilisatin des vecteurs X et Y créer
          PVector deplacementX = triedre.X.mult(dx);
          PVector deplacementY = triedre.Y.mult(dy);
        //renvoie de la somme des deux vecteurs
          return deplacementX.add(deplacementY).div(TRIEDRE_L_AXE);
      }//fin getPosSouris3D
      
      
      
    //PRIVEES
      private void calculPosCam() {
        //on commence à calculer le vecteur entre la pos de la cam, et le point 
        //observé
          PVector v = new PVector(point.x-obs.x , point.y-obs.y , point.z-obs.z);
        //on calcul maintenant sa position
          //calcul du rayon du tronçon de la longitude où se trouve la cam
            float rTroncon = abs( v.mag() * cos(angle.x) );
          //calcul de la pos
            point.y = v.mag() * sin(angle.x);
            
            point.x = rTroncon * cos(angle.y);
            point.z = rTroncon * sin(angle.y);
      }//fin calculPosCam
      
      
      
      
  //ENCAPSULATION
    public PVector getAngle() { return angle; }
    public void setAngle(PVector newAngle) {
      //limitation des angles en entrée et correction
        //pour l'angle sur l'axe Y
          float moduloY = newAngle.y % TWO_PI;
          if ( abs(moduloY) > 0) {
            if (moduloY > 0) {
              newAngle.y = moduloY;
            }
          }
          if (newAngle.y < 0) {
            newAngle.y = TWO_PI - newAngle.y;
          }
        //pour l'angle sur l'axe X
          if (newAngle.x > HALF_PI) {
            newAngle.x = HALF_PI - 0.01;
          } else if (newAngle.x < -HALF_PI) {
            newAngle.x = - HALF_PI + 0.01;
          }
      //et setting de l'angle
        angle = newAngle.copy();
    }//fin setAngle
    
    public void changerZoom(float e) { zoom += e; }
  
}