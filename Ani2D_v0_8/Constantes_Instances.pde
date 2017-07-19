/*
  Page où l'on met toutes les constanes et les instances.
*/

  ////////////////////////////////////////////////////////////////////////////////////////////////
  //CONSTANTES
    //Ecran
      //taille de l'écran
        int SCREEN_SIZE_L = 650;
        int SCREEN_SIZE_H = 400;
        //couleur
          //color SCREEN_BACKGROUND = color(2,10,30);
          color SCREEN_BACKGROUND = color(220);
      //taille de la fenêtre 3D et emplacement
        int SCREEN_3D_SIZE_L = 400;
        int SCREEN_3D_SIZE_H = SCREEN_SIZE_H;
        int SCREEN_3D_X = 0;
        int SCREEN_3D_Y = 0;
        //couleur
          color SCREEN_3D_BACKGROUND = color(200,230,250);
        
        
    //Refresh de la page
      boolean conditionAffichage = true;
      
      
    //Triedre
      //taille axe triedre
        int TRIEDRE_L_AXE = 20;
      //diam point trièdre
        int TRIEDRE_DIAM_POINT = 5;
      //couleurs
        color TRIEDRE_COLOR_X = color(255,0,0);
        color TRIEDRE_COLOR_Y = color(0,255,0);
        color TRIEDRE_COLOR_Z = color(0,0,255);
        color TRIEDRE_COLOR_POINT = color(0);
        
        
        
    //PopUp
      //taille
        int POPUP_L = 150;
        int POPUP_H = 12;
      //couleurs
        color POPUP_COLOR_BACKGROUND = color(0,150);
        color POPUP_COLOR_TEXT_BASIC = color(255);
        color POPUP_COLOR_TEXT_SELECT = color(100,150,255);
      //police de caractères
        PFont POPUP_FONT;
        
  
    //Noeud
      //diamètre des noeuds
        int NOEUD_DIAM = 10;
      //couleurs
        color NOEUD_COLOR_BASIC = color(20);
        color NOEUD_COLOR_SELECT = color(10,50,200);
        
        
        
    //NoeudTexture
      //dim du carré
        int NOEUDTEX_DIM = 10;
      //couleurs
        color NOEUDTEX_COLOR_BASIC = NOEUD_COLOR_BASIC;
        color NOEUDTEX_COLOR_SELECT = color(20,150,70);
        
        
        
    //Forme
      //couleur
        color FORME_COLOR_STROKE = color(150,200,100);
        color FORME_COLOR_STROKE_SELECT = color(100,150,200);
        
        
        
    //Input
      boolean sourisRelachee = false;
      boolean sourisPressee = false;
      boolean clavierRelache = false;
      MouseEvent mouseEvent = null;
      
      
      
    //GUI
      color GUI_COLOR_BACK = color(30);
  
  ////////////////////////////////////////////////////////////////////////////////////////////////
  //INSTANCES
    //pour le mode général de l'application
      Mode mode;
      
    //pour la cam
      Cam cam;
      
    //Tools
      Tools3D tools3D;
      ToolsMath toolsMath;
      ToolsImg toolsImg;
      ToolsSaveLoad toolsSaveLoad;
      ToolsFiles toolsFiles;
      ToolsGui toolsGui;
      
      
      
    //PopUp
      PopUp popup;
      
      
      
      
      
      
        
        
        
        
        