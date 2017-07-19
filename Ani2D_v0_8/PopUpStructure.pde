/*
  Classe permettant de générer un panneau afin de lancer une action
  lors de l'édition d'une structure.
*/



class PopUpStructure extends PopUp{
  
  //CONSTRUCTEURS
    PopUpStructure(int x , int y) {
      super(x,y);
      
      this.setListeActions(new String[][] { {"ajouter noeud" , "ajouter noeud"} , 
                                            {"dé/sélectionner noeuds", ""} , 
                                            {"supprimer noeud" , "supprimer noeud"} , 
                                            {"ajouter cercle" , "ajouter cercle"} ,
                                            {"ajouter convexe" , "ajouter convexe"} ,
                                            {"ajouter plan" , "ajouter plan"} ,
                                            {"sélectionner formes" , "selectionner formes"} ,
                                            {"supprimer forme" , "supprimer forme"} ,
                                            {"ajouter dessin" , "ajouter dessin"},
                                            {"modifier diametre" , "modifier diametre"},
                                            {"rotation img" , "rotation img"},
                                            {"changer taille img" , "changer taille img"},
                                            {"recharger img" , "recharger img"}
                                          });
      this.setH(POPUP_H * this.getListeActions().length);
    }
    
    
    
  //METHODES
    //OVERRIDE de PopUp
      public void appelAction(int index) {
        ((ModeEditionStructure) mode).setActionSelect(this.getListeActions()[index][1]);
        this.setSuppressionPopUp(true);
        ((ModeEditionStructure) mode).activerAttenteClick();
      }//fin appelAction
      
      
      //public void affichage() {
      //  super.affichage();
      //}//fin affichage
      
  
}