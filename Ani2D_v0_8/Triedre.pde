/*
  Classe permettettant de générer un outil Triedre qui permet donc de se repérer dans
  la scène 3D, et de pouvoir utiliser l'orientation de ces axes.
*/


class Triedre {
  
  //PARAMETRES
    private PGraphics page;
    //accessibles
      PVector point;
      PVector X,Y,Z; //absolues
      PVector XS,YS,ZS; //relatif à l'écran
  
  
  //CONSTRUCTEURS
    Triedre(PGraphics page) {
      this.page = page;
      this.point = new PVector();
    }
    
    
    Triedre(PGraphics page , PVector point) {
      this.page = page;
      this.point = point;
    }
    
    
    Triedre(PGraphics page , int x , int y , int z) {
      this.page = page;
      this.point = new PVector(x,y,z);
    }
    
  
  
  //METHODES
    //PUBLICS
      public void calculAxes() {
        //on utilise push/pop pour faire le calcul des axes
          page.pushMatrix();
            //translation au point centre du trièdre
              page.translate(point.x,point.y,point.z);
            //calcul de l'axe X
              page.pushMatrix();
                page.translate(TRIEDRE_L_AXE,0,0);
                X = tools3D.getModel();
                XS = tools3D.getScreen();
              page.popMatrix();
            //calcul de l'axe Y
              page.pushMatrix();
                page.translate(0,TRIEDRE_L_AXE,0);
                Y = tools3D.getModel();
                YS = tools3D.getScreen();
              page.popMatrix();
            //calcul de l'axe Z
              page.pushMatrix();
                page.translate(0,0,TRIEDRE_L_AXE);
                Z = tools3D.getModel();
                ZS = tools3D.getScreen();
              page.popMatrix();
          page.popMatrix();
      }//fin calculAxes
      
      
      
      public void calculAxesContreRot() {
        //on utilise push/pop pour faire le calcul des axes
          page.pushMatrix();
            //translation au point centre du trièdre
              page.translate(point.x,point.y,point.z);
              cam.contreRot();
            //calcul de l'axe X
              page.pushMatrix();
                page.translate(TRIEDRE_L_AXE,0,0);
                X = tools3D.getModel();
                XS = tools3D.getScreen();
              page.popMatrix();
            //calcul de l'axe Y
              page.pushMatrix();
                page.translate(0,TRIEDRE_L_AXE,0);
                Y = tools3D.getModel();
                YS = tools3D.getScreen();
              page.popMatrix();
            //calcul de l'axe Z
              page.pushMatrix();
                page.translate(0,0,TRIEDRE_L_AXE);
                Z = tools3D.getModel();
                ZS = tools3D.getScreen();
              page.popMatrix();
          page.popMatrix();
      }//fin calculAxes
      
      
      
    public void affichage() {
      //on commence par calculer les axes
        calculAxes();
      //et affichage
          page.pushMatrix();
            //translation au point du trièdre
              page.translate(point.x,point.y,point.z);
            //affichage des axes
              //axe X
                page.stroke(TRIEDRE_COLOR_X);
                page.line(point.x,point.y,point.z,X.x,X.y,X.z);
              //axe Y
                page.stroke(TRIEDRE_COLOR_Y);
                page.line(point.x,point.y,point.z,Y.x,Y.y,Y.z);
              //axe Z
                page.stroke(TRIEDRE_COLOR_Z);
                page.line(point.x,point.y,point.z,Z.x,Z.y,Z.z);
              //point central
                cam.contreRot();
                page.noStroke();
                page.fill(TRIEDRE_COLOR_POINT);
                page.ellipseMode(CENTER);
                page.ellipse(0,0,TRIEDRE_DIAM_POINT,TRIEDRE_DIAM_POINT);
          page.popMatrix();
    }//fin affichage
    
    
    
    public void affichageContreRot() {
      //on commence par calculer les axes
        //calculAxes();
        calculAxesContreRot();
      //et affichage
          page.pushMatrix();
            //translation au point du trièdre
              page.translate(point.x,point.y,point.z);
            //affichage des axes
              //axe X
                page.stroke(TRIEDRE_COLOR_X);
                page.line(point.x,point.y,point.z,X.x,X.y,X.z);
              //axe Y
                page.stroke(TRIEDRE_COLOR_Y);
                page.line(point.x,point.y,point.z,Y.x,Y.y,Y.z);
              //axe Z
                page.stroke(TRIEDRE_COLOR_Z);
                page.line(point.x,point.y,point.z,Z.x,Z.y,Z.z);
              //point central
                cam.contreRot();
                page.noStroke();
                page.fill(TRIEDRE_COLOR_POINT);
                page.ellipseMode(CENTER);
                page.ellipse(0,0,TRIEDRE_DIAM_POINT,TRIEDRE_DIAM_POINT);
          page.popMatrix();
    }//fin affichage
  
}