


class Dessin {
  
  //PARAMETRES
    PImage img;
    String lienImg;
    PVector angle;
    PVector pourcent;
    NoeudTexture noeud;
    
    
  
  //CONSTRUCTEURS
    //Dessin (PImage img , float ax , float ay , float az , float px , float py) {
    //  this.img = img;
    //  this.angle = new PVector(ax,ay,az);
    //  this.pourcent = new PVector(px,py);
    //}
    
    //Dessin (PImage img) {
    //  this.img = img;
    //  this.angle = new PVector(0,0,0);
    //  this.pourcent = new PVector(0,0);
    //}
    
    //Dessin (PImage img , NoeudTexture noeud) {
    //  this.img = img;
    //  this.noeud = noeud;
    //}
    
    
    Dessin (String lienImg , NoeudTexture noeud) {
      this.lienImg = lienImg;
        //img = loadImage(this.lienImg);
        formaterImg();
      this.noeud = noeud;
      noeud.dessin = this; //association
    }
    
    //Dessin() {}
  
  
  
  //METHODES
    //PUBLICS
      public void changerTaille(int newTaille) {
        if (img.width+newTaille > 0) {
          img.resize(img.width+newTaille,img.height+newTaille); 
        }
      }//fin changerTaille
      
      public void changerAngle(float newAngle) {
        img = toolsImg.rotationImage(img,newAngle);
        image(img , SCREEN_3D_SIZE_L,300);
      }//fin changerAngle
      
      public void reloadImg() {
        formaterImg();
      }//fin reloadImg
      
    
    //PRIVEES
      /*
        On transforme l'image en carré (si ce n'est pas déjà le cas).
      */
      private void formaterImg() {
        PImage tampon = loadImage(this.lienImg);
        if (tampon.width != tampon.height) {
          int dim = max(tampon.width,tampon.height);
          img = createImage(dim,dim,ARGB);
          int diff = (dim-min(tampon.width,tampon.height))/2;
          if (tampon.width > tampon.height) {
            img.copy(tampon , 0,0,tampon.width,tampon.height , 0,diff , tampon.width,tampon.height);
          } else {
            img.copy(tampon , 0,0 , tampon.width,tampon.height , diff,0 , tampon.width,tampon.height);
          }
        } else {
          img = tampon.copy();
        }
        
      }//fin formaterImg
    
  
}