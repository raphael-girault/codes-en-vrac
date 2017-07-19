


class Bande {
  
  //PARAMETRES
    int L , H , PX , PY , px , py , nbFrames;
    HashMap<Integer,Object> clefs = new HashMap<Integer,Object>();
    
    //param pour la cible a observée
      Object objet;
      String param;
      String type; //permet de connettre le type de paramètres qu'on met pour éviter de passer par réfraction
  
  
  //CONSTRUCTEURS
    Bande (int PX , int PY , int H , int nbFrames , Object objet , String param , String type) {
      this.PX = PX;
      this.PY = PY;
      this.H = H;
      this.nbFrames = nbFrames;
      this.objet = objet;
      this.param = param;
      this.type = type;
      
      L = nbFrames * lCase;
      px = PX;
      py = PY;
      
      //on met une valeur dans la bande pour la première frame
        ajouterClef(0);
    }
    
    
  
  //METHODES
    //PUBLCIS
      public void affichage() {
        //affichage du fond
          noStroke();
          fill(180);
          rect(px,py,L,H,3);
          
        //affichage de la frame en cours de sélection
          if (timeLine.getFrameSelect() != -1) {
            fill(240);
            rect(px+timeLine.getFrameSelect()*lCase,py,lCase,H,3);
          }
          
        //affichage des frames remplies
          for (int i=0 ; i<nbFrames ; i++) {
            if (clefs.containsKey(i)) {
              fill(0);
              ellipseMode(CENTER);
              ellipse(px+i*lCase+lCase/2,py+H/2,lCase-2,lCase-2);
            }
          }
          
        //observation de l'objet
          //pour le moment, juste le déplacement de l'objet dans l'espace 2D
          try {
            boolean enMouvement = objet.getClass().getDeclaredField("modification").getBoolean(objet);
            if (enMouvement) {
              //on réalise une modification des clefs
                //2 cas : une clef est mise sur la frame, ou une avant
                  if (clefs.containsKey(timeLine.getFrameSelect())) {
                    modifierClef(timeLine.getFrameSelect());
                  } else {
                    int lastFrame = 0;
                    for (Map.Entry me : clefs.entrySet()) {
                      //on vérifie qu'on est pas passé sur une clef plus grande que celle sélectionnée
                        //=> on break si c'est le case
                          if (timeLine.getFrameSelect() < (int) me.getKey()) {
                            break;
                          }
                      //on sauvegarde la frame observé
                        lastFrame = (int) me.getKey();
                    }
                    
                    //maintenant qu'on a la dernière clef, on doit vérifier qu'on a changé de valeur pour effectuer un ajout
                      ajouterClefModifier(lastFrame,timeLine.getFrameSelect());
                  }
            } else {
              //on déplace l'objet en fonction de la valeur indiquée dans les clefs
                setValueByFrame(timeLine.getFrameSelect());
            }
          } catch (Exception e) {}
          
        ////on regarde si la frame sélectionnée est en cours d'édition
        //  //2 cas : une clef est mise sur la frame, ou une avant
        //    if (clefs.containsKey(timeLine.getFrameSelect())) {
        //      modifierClef(timeLine.getFrameSelect());
        //    } else {
        //      //for (int i=0 ; i<clefs.size() ; i++) {
        //      //  //on vérifie qu'on est pas passée sur une clef plus grande que celle sélectionnée
        //      //    //=> on break si c'est le case
        //      //      if (timeLine.getFrameSelect() < clefs.keySet().
        //      //}
        //      int lastFrame = 0;
        //      for (Map.Entry me : clefs.entrySet()) {
        //        //on vérifie qu'on est pas passée sur une clef plus grande que celle sélectionnée
        //          //=> on break si c'est le case
        //            if (timeLine.getFrameSelect() < (int) me.getKey()) {
        //              break;
        //            }
        //        //on sauvegarde la frame observé
        //          lastFrame = (int) me.getKey();
        //      }
              
        //      //maintenant qu'on a la dernière clef, on doit vérifier qu'on a changé de valeur pour effectuer un ajout
        //        ajouterClefModifier(lastFrame,timeLine.getFrameSelect());
        //    }
        
          //=> pas une bonne idée de s'y prendre comme ça
          //ça doit plutôt être l'objet qui envoie (ou vérif par la bande) sa valeur,
          //et on regarde si il y a une édition en cours ou non
          //sachant qu'on doit reset la valeur de l'objet lorsqu'on se met sur un clef.
          
          //à reprendre plus tard ...
            
      }//fin affichage
    
    
    //PRIVEES
      private void ajouterClef(int frame) {
        if (type.equals("int")) {
          try {
            int valeur = objet.getClass().getDeclaredField(param).getInt(objet);
            clefs.put(frame,valeur);
            println(clefs);
          } catch (Exception e) {}
        } 
      }//fin ajouterClef
      
      
      
      private void modifierClef(int frame) {
        if (type.equals("int")) {
          try {
            int newValue = objet.getClass().getDeclaredField(param).getInt(objet);
            int currentValue = (int) clefs.get(frame);
            if (currentValue != newValue) {
              clefs.put(frame,newValue);
              println(clefs);
            }
          } catch (Exception e) {}
        } 
      }//fin modifierClef
      
      
      
      private void ajouterClefModifier(int lastFrame , int currentFrame) {
        if (type.equals("int")) { 
          try {
            int currentValue = objet.getClass().getDeclaredField(param).getInt(objet);
            int lastValue = (int) clefs.get(lastFrame);
            if (lastValue != currentValue) {
              clefs.put(currentFrame,currentValue);
              println(clefs);
            }
          } catch (Exception e) { println(e); }
        }
      }//fin isSameValue
      
      
      
      private void setValueByFrame(int currentFrame) {
        //correctif pour éviter erreur
          if (currentFrame == -1) {
            currentFrame = 0;
          }
          //=> en soit, on prend la valeur '0' par défaut
        //3 cas : soit la frame possède une clef, soit elle est entre 2 clefs, soit il n'y a plus de clef après
          //=> déjà trouver où on se trouve
            int lastFrame = 0;
            int nextFrame = -1;
            for (Map.Entry me : clefs.entrySet()) {
              //on vérifie qu'on est pas passé sur une clef plus grande que celle sélectionnée
                //=> on break si c'est le case
                  if (currentFrame < (int) me.getKey()) { 
                    nextFrame = (int) me.getKey();
                    break;
                  } else {
                    //on sauvegarde la frame observé
                    lastFrame = (int) me.getKey();
                  }
            }

            
            //on peut maintenant regarder dans quel cas on se trouve
              //Note : le premier et le dernier cas donnent la même chose
              //=> bien que en soit, juste à utiliser map() ..., ça devrait suffire
              if (type.equals("int")) {
                int valeur = 0;
                if (nextFrame == -1) {
                  valeur = (int) clefs.get(lastFrame);
                } else {
                  valeur = (int) map(currentFrame , lastFrame , nextFrame , (int) clefs.get(lastFrame) , (int) clefs.get(nextFrame));
                }
                //et on met la valeur à l'objet
                  try {
                    objet.getClass().getDeclaredField(param).setInt(objet,valeur);
                  } catch (Exception e) {}
              }
      }//fin setValueByFrame
      
  
}




//class Bande {
  
//  //PARAMETRES
//    int L , H , px , py;
//    int lCase = 10;
    
//    boolean[] listeFrameSelection;
    
  
//  //CONSTRUCTEURS
//    Bande(int px , int py , int H) {
//      this.px = px;
//      this.py = py;
//      this.H = H;
      
//      this.L = nbFrames * lCase;
//      this.listeFrameSelection = new boolean[nbFrames];
//    }
  
  
//  //METHODES
//    //PUBLICS
//      public void affichage() {
//        fill(240,230,200);
//        stroke(0);
//        rect(px,py,L,H,3);
        
//        affichageCase();
//      }//fin affichage
      
      
      
//    //PRIVEES
//      private void affichageCase() {
//        //on commence par vérifier si la souris est sur la bande
//          if ( mouseX>=px && mouseX<px+L && mouseY>=py && mouseY<py+H) {
//            //on trouve la case sur laquelle on est
//              int frameSelect = ( (mouseX-px) / lCase );
//            //et on l'affiche
//              noStroke();
//              fill(255,255,200);
//              rect(frameSelect*lCase + px , py , lCase,H,3);
              
//            //sélection de la frame si on clique dessus
//              if (sourisRelachee) {
//                listeFrameSelection[frameSelect] = !listeFrameSelection[frameSelect];
//              }
//          }
          
//        //et on affiche les cases sélectionnées
//          noStroke();
//          fill(0);
//          for (int i=0 ; i<listeFrameSelection.length ; i++) {
//            if (listeFrameSelection[i]) {
//              ellipse(px+lCase*i+lCase/2,py+H/2,lCase,lCase);
//            }
//          }
//      }//fin affichageCase
      
      

    
//}