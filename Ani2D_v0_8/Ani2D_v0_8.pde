/*
  Logiciel pour créer animation en 2D avec des outils de 3D.
*/


  //IMPORTATIONS
    import controlP5.*;


  /*
    Setting d ela taille de l'écran
  */
  void settings() {
    size(SCREEN_SIZE_L,SCREEN_SIZE_H,P2D);
  }//fin settings




  /*
    Initialisation du logiciel
  */
  void setup() {
    //init du mode : edition structure pour le début
      mode = new ModeEditionStructure(SCREEN_3D_X,SCREEN_3D_Y,SCREEN_3D_SIZE_L,SCREEN_3D_SIZE_H,P3D,null);
    //cam
      cam = new Cam(mode.getPage());

    //tools
      tools3D = new Tools3D(mode.getPage());
      toolsMath = new ToolsMath(mode.getPage());
      toolsImg = new ToolsImg(mode.getPage());
      toolsSaveLoad = new ToolsSaveLoad(mode.getPage());
      toolsFiles = new ToolsFiles(mode.getPage());
      toolsGui = new ToolsGui(mode.getPage() , this);
      
    //font
      POPUP_FONT = createFont("Consolas", 10);
      
      
    //test
      //ajout d'un point dans la structure du mode histoire de faire mumuse
        //Structure struct = ((ModeEditionStructure) mode).structure;
        //struct.ajouterNoeud(50,0,0);
        //  struct.ajouterNoeud(80,100,0);
        //struct.ajouterCercle(struct.noeuds.get(0));
        //  struct.ajouterCercle(struct.noeuds.get(1));
        //  struct.ajouterConvexe(struct.noeuds.get(0),struct.noeuds.get(1));
        ////struct.formes.get(0).ajouterDessin(new Dessin("dessins/smiley.png" , new NoeudTexture(mode.getPage() , struct.formes.get(0) , new PVector(0,0,25)) ) );
        //  struct.formes.get(2).ajouterDessin(new Dessin("dessins/smiley.png" , new NoeudTexture(mode.getPage() , struct.formes.get(2) , new PVector(0.5,radians(0),25)) ) );
      
      
        Structure struct = ((ModeEditionStructure) mode).structure;
        int u = 50;
        struct.ajouterNoeud(-u,-u,0);
        struct.ajouterNoeud(u,-u,0);
        struct.ajouterNoeud(u,u,0);
        struct.ajouterNoeud(-u,u,0);
        struct.selectionnerAllNoeuds();
        struct.ajouterPlan(struct.getAllNoeudsSelect());
        
        ((Plan) struct.getAllPlans().get(0)).ajouterDessin(new Dessin("dessins/smiley.png" , new NoeudTexture(mode.getPage() , struct.getAllPlans().get(0) , new PVector(0.5,0.5,25))));
      
  }//fin setup





  /*
    Lancement du logiciel
  */
  void draw() {
    
    //on regarde si une action souris pour le déplacement de la cam se produit
      camDeplacement();
    //et refresh de la cam
      cam.refreshCam();
    //si la condition de refresh est validée
      if (mode.getConditionAffichage() || mode.getConditionAffichageContinue()) {
        //on retire le refresh de la page
          conditionAffichage = false;
        //refresh de la fenêtre d'affichage
          background(SCREEN_BACKGROUND);
        //affichage du mode
          mode.action();
      }
      
      
    //affichage de la fenêtre de popup
      if (popup != null) {
        popup.affichage();
        //destruction si recquise
          if (popup.getSuppressionPopUp()) {
            popup = null;
            mode.conditionAffichage = true;
          }
      }
  }//fin draw