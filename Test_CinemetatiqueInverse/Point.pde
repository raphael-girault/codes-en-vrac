


class Point {
  
  //PARAMETRES
    PVector pos;
    Point parent;
    ArrayList<Point> enfants = new ArrayList<Point>();
    float rParent;
    int D = 10;
    
    boolean cinematiqueInverseActivee = false;
    
    PVector move = new PVector(0,0);
    
    boolean deplace = false;
  
  
  //CONSTRUCTEURS
    Point(float x , float y) {
      pos = new PVector(x,y);
    }
    
    
    Point(float x , float y , Point parent) {
      pos = new PVector(x,y);
      this.parent = parent;
      parent.enfants.add(this);
      rParent = dist(x,y,parent.pos.x,parent.pos.y);
    }
  
  
  
  //METHODES
    //PUBLICS
      public void affichage() {
        //on regarde si on effectue un déplacement à la souris sur le point
          deplacement();
          
        //on effectue le déplacement et on l'envoie aux enfants
          pos = PVector.add(pos,move);
          for (Point p : enfants) {
            p.move = PVector.add(p.move,this.move);
          }
        
        //on réalise l'affichage
          if (!deplace) {
            noFill();
          } else {
            fill(150,200,230);
          }
          stroke(0);
          ellipseMode(CENTER);
          ellipse(pos.x,pos.y,D,D);
          
          if (parent != null) {
            line(parent.pos.x,parent.pos.y,pos.x,pos.y);
            fill(0);
            ellipse(pos.x,pos.y,D/2,D/2);
          }
        
        //on réinitialise le déplacement du point
          move = new PVector(0,0);
      }//fin affichage
  
  
  
    //PRIVEES
      private void deplacement() {
        if ((mousePressed && pow(D,2) >= pow(mouseX-pos.x,2) + pow(mouseY-pos.y,2)) || deplace) {
          deplace = true;
          if (parent != null) {
            if (!cinematiqueInverseActivee) {
              PVector inter = getIntersectionLineCircle(parent.pos , rParent , parent.pos , new PVector(mouseX,mouseY));
              if (inter != null) {
                move = PVector.sub(inter , pos);
              }
            }
          } else {
            move.x = mouseX-this.pos.x;
            move.y = mouseY-this.pos.y;
          }
       } else {
         deplace = false;
       }


        if (cinematiqueInverseActivee && ((mousePressed && pow(D,2) >= pow(mouseX-pos.x,2) + pow(mouseY-pos.y,2)) || deplace)) {
          //println("here zzzz");
          move.x = mouseX-this.pos.x;
          move.y = mouseY-this.pos.y;
          
          pos = PVector.add(pos,move);
          
          //on doit déterminer la position du parent en fonction des deux noeuds qui l'entourent
            double[] r = circleCircleIntersects(pos.x,pos.y,pts[0].pos.x,pts[0].pos.y,rParent,pts[1].rParent);
            
            if (r != null) {
              PVector pt1 = new PVector((float)r[0] , (float)r[1]);
              PVector pt2 = new PVector((float)r[2] , (float)r[3]);
              
              //on prend le point le plus proche du point central qu'on cherche à placer
                float d1 = dist(pt1.x,pt1.y,pts[1].pos.x,pts[1].pos.y);
                float d2 = dist(pt2.x,pt2.y,pts[1].pos.x,pts[1].pos.y);
              
                PVector p = new PVector();
              
                if (d1 > d2) {
                  p = pt2.copy();
                } else {
                  p = pt1.copy();
                }
                
                
              //pts[1].pos = p.copy();
              
              
              //on regarde si le rayon entre les deux points est toujours correcte ou on arrète tout
                float err = 0.1;
                float r2 = dist(pos.x,pos.y,p.x,p.y); println(abs(rParent - r2) , r2 , rParent); println(r);
                if ( abs(rParent - r2) > err ) {
                  //on arrète tout
                    pos = PVector.sub(pos,move);
                } else {
                  //on peut finaliser
                    pts[1].pos = p.copy();
                }
              
              
            } else {
              //on arrète tout
                pos = PVector.sub(pos,move);
                move = new PVector();
            }

        }

        
      }//fin deplacement
  
  
}