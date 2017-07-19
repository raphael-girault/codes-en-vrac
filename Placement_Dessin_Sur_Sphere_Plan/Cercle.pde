


class Cercle {
  
  //PARAMETRES
    PVector pos;
    float D;
    ArrayList<Dessin> dessins = new ArrayList<Dessin>();
    PImage texture;
    
  
  //CONSTRUCTEUR
    Cercle(int x , int y , float D) {
      this.pos = new PVector(x,y);
      this.D = D;
    }
  
  
  //METHODES
    //PUBLICS
      public void affichage() {
        texture = createImage(int(D),int(D),ARGB);
        
        fill(255);
        stroke(0);
        ellipse(pos.x,pos.y,D,D);
        
        placementDessins();
        
        //supprPixelsHorsCercle(texture);
        
        int w = texture.width/2;
        int h = texture.height/2;
        PShape s = createShape();
        s.beginShape();
          s.vertex(-w,-h,0,0);
          s.vertex(w,-h,2*w,0);
          s.vertex(w,h,2*w,2*h);
          s.vertex(-w,h,0,2*h);
        s.endShape(CLOSE);
        
        s.translate(pos.x,pos.y);
        s.setFill(false);
        s.setStroke(color(0,100));
        
       s.setTexture(texture);
        
        shape(s);
      }//fin affichage
      
      
      public void ajouterDessin(Dessin dessin) {
        dessins.add(dessin);
      }//fin ajouterDessin
      public void ajouterDessin(PImage img , float ax , float ay , float az) {
        dessins.add(new Dessin(img,ax,ay,az));
      }//fin ajouterDessin
      
      
      
      
    //PRIVEES
      private void placementDessins() {
        resetTexture();
        
        for (Dessin dessin : dessins) {
          
          //on commence par placer le centre
            PVector v = new PVector(dessin.pos.x+angleScene.x + HALF_PI , dessin.pos.y+angleScene.y - HALF_PI , D/2);
            PVector c = new PVector(pos.x , pos.y , 0);
            PVector centre = polarToCartesian2(v,c);
          
            stroke(0);
            fill(0);
            ellipse(centre.x,centre.y,10,10);
            
            //semble ok pour le centre
            
          //on s'occupe maintenant du dessin
            for (int j=0 ; j<dessin.img.height ; j++) {
              for (int i=0 ; i<dessin.img.width ; i++) {
                
                //placement plan
                  //int px,py;
                  //px = int(centre.x - c.x + i + dessin.img.width/2);
                  //py = int(centre.y - c.y + j + dessin.img.height/2);
  
                  //if (centre.z>0 && alpha(dessin.img.get(i,j))>1 && abs(px - dessin.img.width)>=0 && abs(py - dessin.img.height)>=0) {
                  //  texture.set(px,py,dessin.img.pixels[i+j*dessin.img.width]);
                  //}
                  
                  
                //placement cylindrique
                  //int px,py,pz;
                  //py = int(centre.y - c.y + j + dessin.img.height/2);
                  //float ay = (float(i - dessin.img.width/2) / (D/2)) + dessin.pos.y + angleScene.y;
                  ////px = int( centre.x - c.x + (D/2) * cos(ay) );
                  //px = int( D/2 - (D/2) * cos(ay) );
                  //pz = int( (D/2) * sin(ay) );

                  //if (pz>0 && alpha(dessin.img.get(i,j))>1 && abs(px - dessin.img.width)>=0 && abs(py - dessin.img.height)>=0) {
                  //  texture.set(px,py,dessin.img.pixels[i+j*dessin.img.width]);
                  //}
                  
                  
                //placement double cylindrique
                  int px,py,pz;
                  
                  float ax = (float(j - dessin.img.height/2) / (D/2)) + dessin.pos.x + angleScene.x + HALF_PI;
                  float ay = (float(i - dessin.img.width/2) / (D/2)) + dessin.pos.y + angleScene.y;
                  px = int( D/2 - (D/2) * cos(ay) );
                  py = int( D/2 + (D/2) * cos(ax) );
                  pz = min(int( (D/2) * sin(ay) ) , int( (D/2) * sin(ax) ));
                  
                  if (pz>0 && alpha(dessin.img.get(i,j))>1 && abs(px - dessin.img.width)>=0 && abs(py - dessin.img.height)>=0) {
                    texture.set(px,py,dessin.img.pixels[i+j*dessin.img.width]);
                  }
                
              }
            }
            
        }
        
        image(texture,300,200,texture.width,texture.height);
        
      }//fin placementDessins
      
      
      
      private void resetTexture() {
        for (int i=0 ; i<texture.pixels.length ; i++) {
          texture.pixels[i] = color(0,0);
        }
      }//fin resetTexture
}