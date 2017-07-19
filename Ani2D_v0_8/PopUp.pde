/*
  Classe abstraite qui servira de base pour l'appel des autres popup.
*/



abstract class PopUp {
  
  //PARAMETRES
    private PGraphics page;
    private String[][] listeActions = {};
    private int L = POPUP_L;
      //private int H = POPUP_H * listeActions.length;
    private int H = POPUP_H;
    private int x,y;
    private boolean suppressionPopUp = false;
  
  
  //CONSTRUCTEURS
    PopUp(int x , int y) {
      this.x = x;
      this.y = y;
    }
  
  
  //METHODES
    //ABSTRAITES
      abstract void appelAction(int index);
    
    
        
    //PUBLICS
      public void affichage() {
        //on vérifie que la page est bien crée
          if (page == null) {
            creationPage();
          }
        //init du dessin
          page.beginDraw();
            //page.background(POPUP_COLOR_BACKGROUND);
              page.fill(POPUP_COLOR_BACKGROUND);
              page.noStroke();
              page.rect(0,0,L,H,3);
            page.textFont(POPUP_FONT);
            //page.fill(POPUP_COLOR_TEXT_BASIC);
            for (int i=0 ; i<listeActions.length ; i++) {
              if (mouseX>x && mouseX<x+L && mouseY>y+i*POPUP_H && mouseY<y+(i+1)*POPUP_H) {
                page.fill(POPUP_COLOR_TEXT_SELECT);
                if (mousePressed) {
                  //on lance l'action
                    appelAction(i);
                    break;
                }
              } else {
                page.fill(POPUP_COLOR_TEXT_BASIC);
                if (mousePressed) {
                  //destruction du popup
                    setSuppressionPopUp(true);
                }
              }
              page.text(listeActions[i][0],0,0+i*POPUP_H,POPUP_L,POPUP_H);
            }
          page.endDraw();
        //affichage
          //image(page,x-L/2,y-H/2);
          image(page,x,y);
      }//fin affichage
      
      
      
      public boolean onPopUp(int px , int py) {
        return (px>=x-2 && px<=x+L && py>=y-2 && py<=y+H);
      }//fin onPopUp
      
      
      
    //PRIVEES
      private void creationPage() {
        page = createGraphics(L,H,P2D);
      }//fin creationPage
  
  
  
  
  //ENCAPSULATION
    public boolean getSuppressionPopUp() { return suppressionPopUp; }
    public void setSuppressionPopUp(boolean rep) { suppressionPopUp = rep; }
    
    public String getActionInListe(int indexA , int indexB) { return listeActions[indexA][indexB]; }
    public void setListeActions(String[][] liste) { this.listeActions = liste; }
    public String[][] getListeActions() { return listeActions; }
    
    public void setH(int H) { this.H = H; }
}