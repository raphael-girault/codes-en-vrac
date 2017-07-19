/*
  Classe étendue de mode permettant d'afficher et de modifier une instance de la
  clase Structure.
*/


class ModeEditionStructure extends Mode {
  
  //PARAMETRES
    //trièdre au centre
      private Triedre triedre;
      private Structure structure;
      
      private boolean attenteClick = false; //permet de ne pas exécuter une tâche avant au moins un clique
      private boolean inputImg = false;
      private Dessin dessinAjout;
      
      private ArrayList<Noeud> noeudsSelect = new ArrayList<Noeud>();
      private ArrayList<Forme> formesSelect = new ArrayList<Forme>();
      private NoeudTexture noeudTextureSelect;
      
      
  
  //CONSTRUCTEURS
    ModeEditionStructure(int x , int y , int L , int H , Structure structure) {
      super(x,y,L,H);
      triedre = new Triedre(this.getPage());
      if (structure == null) {
        structure = new Structure(this.getPage());
      }
      this.structure = structure;
    }
    
    
    ModeEditionStructure(int L , int H , Structure structure) {
      super(L,H);
      triedre = new Triedre(this.getPage());
      if (structure == null) {
        structure = new Structure(this.getPage());
      }
      this.structure = structure;
    }
    
    
    ModeEditionStructure(int L , int H ,  String type , Structure structure) {
      super(L,H,type);
      triedre = new Triedre(this.getPage());
      if (structure == null) {
        structure = new Structure(this.getPage());
      }
      this.structure = structure;
    }
    
    
    ModeEditionStructure(int x , int y , int L , int H , String type , Structure structure) {
      super(x,y,L,H,type);
      triedre = new Triedre(this.getPage());
      if (structure == null) {
        structure = new Structure(this.getPage());
      }
      this.structure = structure;
    }

  
  
  
  //METHODES
    //OVERRIDE de Mode
       public void affichage() {
         if (this.getConditionAffichage() || this.getConditionAffichageContinue()) { //vérif de la condition de refresh
           //reset de la condition d'affichage
             this.setConditionAffichage(false);
           //reset de la cam
             //cam.refreshCam();
               //=> ne pasq le mettre ici où non pris en compte pour les calculs de positionnement.
               //Placé dans le draw().
           //démarrage de la mise en place de l'affichage de la page 3D
             //récup de la page
               PGraphics p = this.getPage();
             //lancement de la mise en place des éléments dans lq page
               p.beginDraw();
                 //refresh de la page 3D
                   p.background(SCREEN_3D_BACKGROUND);
                 //affichage du trièdre au centre
                   triedre.affichage();
                 //affichage de la structure
                   structure.affichageEdition();
                   
                 //affichage des indications textuelles
                    p.rectMode(CORNER);
                    cam.contreRot();
                    p.fill(0);
                    p.textAlign(LEFT, CENTER);
                    p.text("Action en cours : " + this.getActionSelect(),-p.width/2,p.height/2-20,300,20);
                    p.textAlign(RIGHT, CENTER);
                    p.text("Angle Caméra : " + int(degrees(cam.angle.x)) + " . " + int(degrees(cam.angle.y)) , -p.width/2,p.height/2-20,p.width,20);

               p.endDraw();
           //affichage du résultat dans la fenêtre
             image(p,this.getX(),this.getY());
         }
       }//fin affichage
       
       
       
       public void action() {
           
             if (mousePressed && mouseButton == 37 && (this.getActionSelect().equals("") || this.getActionSelect().equals("deplacer noeud"))) {
               this.setActionSelect("deplacer noeud");
               this.setConditionAffichageContinue(true);
             } else {
               this.setConditionAffichageContinue(false);
             }
             
             
             if (mouseButton == 39 && sourisRelachee) {
               sourisRelachee = false;
               actionSelectionNoeud();
             }
              
              
              
         //on regarde les inputs clavier
           if (clavierRelache) {
             clavierRelache = false;
             switch (key) {
               case ' ': //lancement de la fenêtre popup pour la sélection rapide d'une action
                 popup = new PopUpStructure(mouseX,mouseY);
                 break;
               case 'x': //fin de l'action en cours
                 this.setActionSelect("");
                 break;
             }
           }
           
           
         //déplacement des textures
           //si un noeud est sélectionné + aucune action en cours, alors on peut réaliser la modif
           if (noeudTextureSelect != null && (this.getActionSelect().equals("") || this.getActionSelect().equals("deplacer texture"))) {
             actionDeplacerTexture();
             this.setActionSelect("deplacer texture");
           } else {
             if (!this.getActionSelect().equals("deplacer noeud")) {
               this.setConditionAffichageContinue(false);
             }
             if (this.getActionSelect().equals("deplacer texture")) {
               this.setActionSelect("");
             }
           }
           
              
         //on fait un switch en fonction de l'action sélectionné
           switch (this.getActionSelect()) {
             //case "selection noeud":
             //  actionSelectionNoeud();
             //  break;
             case "deplacer noeud":
               actionDeplacerNoeud();
               break;
             case "ajouter noeud":
               actionAjouterNoeud();
               break;
             case "supprimer noeud":
               actionSupprimerNoeud();
               break;
             case "ajouter cercle":
               actionAjouterCercle();
               break;
             case "ajouter convexe":
               actionAjouterConvexe();
               break;
             case "ajouter plan":
               actionAjoiterPlan();
               break;
             case "supprimer forme":
               actionSupprimerForme();
               break;
             case "selectionner formes":
               actionSelectionnerFormes();
               break;
             case "ajouter dessin":
               actionAjouterDessin();
               break;         
             case "sauvegarder":
               actionSauvegarder();
               break;
             case "charger":
               actionCharger();
               break;
             case "modifier diametre":
               actionModifierDiametre();
               break;
             case "rotation img":
               actionModifierRotationImg();
               break;
             case "changer taille img":
               actionModifierTailleImg();
               break;
             case "recharger img":
               actionRechargerImg();
               break;
           }//fin du switch de l'actionSelect
         
         
         //affichage des éléments du mode édition structure
           affichage();
         //reset des variables
           sourisRelachee = false;
           attenteClick = false;
         //refresh des variables
           noeudsSelect = structure.getAllNoeudsSelect();
         //reset des listes
           formesSelect = structure.getAllFormesSelect();
           noeudsSelect = structure.getAllNoeudsSelect();
       }//fin action
       
       
       
       
       
       
  //ACTIONS
    private void actionSelectionNoeud() {
      structure.selectionNoeud(mouseX,mouseY);
    }//fin actionSelectionNoeud
    
    private void actionDeplacerNoeud() {
      //on récupère le déplacement de la souris dans la scène 3D
        PVector deplacement = cam.getSourisDeplacement3D();
      //envoie du déplacement qui sera traîté par la structure
        //structure.deplacerNoeudSouris(deplacement);
        structure.deplacerNoeudSouris(cam.getPosSouris3D(null));
      //reset de l'action en cours
        this.setActionSelect("");
    }//fin actionDeplacerNoeud
    
    private void actionAjouterNoeud() {
      //récupération de la position de la souris dans l'espace 3D
        if (mouseButton == 37 && !attenteClick && sourisRelachee) {
          structure.ajouterNoeud(cam.getPosSouris3D(null));
          sourisRelachee = false;
        }
    }//fin actionAjouterNoeud
    
    private void actionSupprimerNoeud() {
      for (Noeud n : noeudsSelect) {
        structure.supprimerNoeud(n);
      }
      //reset de l'action en cours
        this.setActionSelect("");
    }//fin actionSupprimerNoeud
    
    private void actionAjouterCercle() {
      for (Noeud n : noeudsSelect) {
        structure.ajouterCercle(n);
      }
      //reset de l'action en cours
        this.setActionSelect("");
    }//fin actionAjouterCercle
    
    private void actionAjouterConvexe() {
      //on commence par vérifier qu'il n'a bien que 2 noeuds sélectionnés
        if (noeudsSelect.size() == 2) {
          structure.ajouterConvexe(noeudsSelect.get(0) , noeudsSelect.get(1));
        } else {
          println("ERREUR : Seul 2 noeuds peuvent être sélectionnées pour créer un convexe.");
        }
      //reset de l'action en cours
        this.setActionSelect("");
    }// fin actionAjouterConvexe
    
    private void actionAjoiterPlan() {
      //on commence à vérifier qu'il y a bien au moins 3 noeuds sélectionnés
        if (noeudsSelect.size() >= 3) {
          structure.ajouterPlan(noeudsSelect);
        } else {
          println("ERREUR : Au moins 3 noeuds doivent être sélectionnés pour créer un plan.");
        }
      //reset de l'action en cours
        this.setActionSelect("");
    }//fin actionAjoiterPlan
    
    private void actionSupprimerForme() {
      //suppression de toutes les formes sélectionnées
        structure.supprimerForme();
      //reset de l'action en cours
        this.setActionSelect("");
    }//fin actionSupprimerForme
    
    private void actionSelectionnerFormes() {
      if (sourisRelachee && mouseButton == 37) {
        structure.selectionnerFormes(mouseX,mouseY);
      }
    }//fin actionSelectionnerFormes
    
    private void actionAjouterDessin() {
      //pour ajouter un dessin, on ne doit avoir qu'une seule forme de sélectionner
        if (formesSelect.size() == 1) {
          //on doit commencer par aller chopper l'image (plus tard le dessin enregistré en json)
          //puis on crée le dessin dans l'image
              if (!inputImg) {
                inputImg = true;
                selectInput("Selection d'une image", "imgSelected");
              }
        } else {
          println("ERREUR : une forme et une seule doit être sélectionnées");
          //reset de l'action en cours
              this.setActionSelect("");
        }
    }//fin actionAjouterDessin
    
    private void actionDeplacerTexture() {
      //on réalise un clique gauche + déplacement souris pour bouger la texture
        if (mousePressed && mouseButton == 37) {
          noeudTextureSelect.deplacerTexture(mouseX-pmouseX , mouseY-pmouseY);
          mode.conditionAffichageContinue = true;
        }
    }//fin actionDeplacerTexture
    
    private void actionSauvegarder() {
      toolsSaveLoad.saveStructure(structure);
      //reset de l'action en cours
        this.setActionSelect("");
    }//fin actionSauvegarder
    
    private void actionCharger() {
      try {//println(toolsGui.cp5 , toolsGui.cp5.getController("controllerSelectionStructure") , ((ScrollableList) toolsGui.cp5.getAll().get(3)).getLabel());
        
            ControllerInterface ctrl = null;
            for (ControllerInterface o : toolsGui.cp5.getAll()) {
              //println(o , o.getAddress() , o.getName());
              if (o.getName().equals("controllerSelectionStructure")) {
                ctrl = (ScrollableList) o;
              }
            }
      
        //String nomStructure = toolsGui.cp5.getController("controllerSelectionStructure").getLabel(); 
        String nomStructure = ((ScrollableList) ctrl).getLabel(); 
        if (!nomStructure.equals("Select Structure")) {
            //on vide la structure active
            structure = null;
            //et on charge la structure sélectionnée
            structure = toolsSaveLoad.loadStructure(nomStructure,this.getPage());
        }
      } catch(Exception e) { println("-----"); e.printStackTrace(); println("-----"); }
      //reset de l'action en cours
        this.setActionSelect("");
    }//fin actionCharger
    
    private void actionModifierDiametre() {
      if (mouseButton == 37 && mousePressed) {
        mode.setConditionAffichageContinue(true);
        for (Noeud n : noeudsSelect) {
          //récup du cercle
            Cercle c = structure.getCercleFromNoeud(n);
          //modif du diamètre
            if (c.D-(mouseY-pmouseY) > 0) {
              structure.changerDiametreCercle(c.D-(mouseY-pmouseY),c);
            }
        }
      }println(mouseButton,mouseY-pmouseY);
    }//fin actionModifierDiametre
    
    private void actionModifierRotationImg() {
      //on commence par regarder si un noeud de texture a été sélectionné
        if (noeudTextureSelect != null) {
          if (mouseButton == 37 && mousePressed) {
            mode.setConditionAffichageContinue(true);
            noeudTextureSelect.coordonnees.z -= radians(mouseY-pmouseY);
            //et modif de la variable de rot du dessin
              //=> pas bien de le faire ici mais pas trop d'idées pour faire mieux pour le moment
                noeudTextureSelect.dessin.changerAngle(-radians(mouseY-pmouseY));
          }
        } else {
          println("ERREUR : un noeud de texture doit être sélectionné.");
          //reset de l'action en cours
            this.setActionSelect("");
        }
    }//fin actionModifierRotationImg
    
    private void actionModifierTailleImg() {
      //on commence par regarder si un noeud de texture a été sélectionné
        if (noeudTextureSelect != null) {
          if (mouseButton == 37 && mousePressed) {
            mode.setConditionAffichageContinue(true);
            //et modif de la variable de rot du dessin
              //=> pas bien de le faire ici mais pas trop d'idées pour faire mieux pour le moment
                noeudTextureSelect.dessin.changerTaille(-(mouseY-pmouseY));
          }
        } else {
          println("ERREUR : un noeud de texture doit être sélectionné.");
          //reset de l'action en cours
            this.setActionSelect("");
        }
    }//fin actionModifierTailleImg
    
    private void actionRechargerImg() {
      //on commence par regarder si un noeud de texture a été sélectionné
        if (noeudTextureSelect != null) {
          noeudTextureSelect.dessin.reloadImg();
        } else {
          println("ERREUR : un noeud de texture doit être sélectionné.");
        }
        //reset de l'action en cours
          this.setActionSelect("");
    }//fin actionRechargerImg
    
    
          
    
  //ENCAPSULATION
    public void activerAttenteClick() { attenteClick = true; }
  
}



//FONCTIONS DE CALLBACK
  public void imgSelected(File selection) {
    //on regarde la forme sélectionnée pour ajouter le bon noeud de texture
    ModeEditionStructure m = (ModeEditionStructure) mode;
    String type = m.formesSelect.get(0).getClass().getSimpleName();
    NoeudTexture n = null;
    switch (type) {
      case "Cercle":
        n = new NoeudTexture(m.getPage(),m.formesSelect.get(0),0,0,0);
        break;
      case "Convexe":
        n = new NoeudTexture(m.getPage(),m.formesSelect.get(0),0,0.5,0);
        break;
      case "Plan":
        n = new NoeudTexture(m.getPage(),m.formesSelect.get(0),0.5,0.5,0);
        break;
    }
    if (n != null) { //pour sécuriser le truc ...
      m.formesSelect.get(0).ajouterDessin( new Dessin( selection.getAbsolutePath()  , n ) );
    }
    m.inputImg = false;
    //reset de l'action en cours
      m.setActionSelect("");
    //refresh
      mode.conditionAffichage = true;
  }//fin imgSelected