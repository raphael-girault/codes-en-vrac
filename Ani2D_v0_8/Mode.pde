/*
  Classe d'interfaçage entre les instances et les actions utilisateurs.
  Une classe étendue possèdera généralement son propre type d'affichage (2D, 3D)
*/


abstract class Mode {
  
  //PARAMETRES
    private PGraphics page;
    private boolean conditionAffichage = true;
    private boolean conditionAffichageContinue = false;
    private String actionSelect = "";
    private int x,y,L,H;
    private String type; //P2D, P3D, ...
    
  
  
  //CONSTRUCTEURS
    Mode(int x , int y , int L , int H) {
      this.x = x;
      this.y = y;
      this.L = L;
      this.H = H;
      this.type = P2D;
      creationPage();
    }
    
    
    Mode(int L , int H) {
      this.x = 0;
      this.y = 0;
      this.L = L;
      this.H = H;
      this.type = P2D;
      creationPage();
    }
    
    
    Mode(int x , int y , int L , int H , String type) {
      this.x = x;
      this.y = y;
      this.L = L;
      this.H = H;
      this.type = type;
      creationPage();
    }
    
    
    Mode(int L , int H , String type) {
      this.x = 0;
      this.y = 0;
      this.L = L;
      this.H = H;
      this.type = type;
      creationPage();
    }
  
  
  
  //METHODES
    //ABSTRAITES
      abstract public void affichage();
      abstract public void action();
      
    
    
    //PUBLICS
      public boolean inModule() {
        return (mouseX-x>=0 && mouseX-x<L && mouseY-y>=0 && mouseY-y<H);
      }//fin inModule
      
      
      public void creationPage() {
        page = createGraphics(L,H,type);
        if (type.equals("processing.opengl.PGraphics3D")) { //P3D est en faite une variable ...
          page.hint(ENABLE_DEPTH_SORT);
        }
      }//fin creationPage
      

    
    
    //PRIVEES
    
    
    
    
  //ENCAPSULATION
    public int getL() { return L; }
    public int getH() { return H; }
    public int getX() { return X; }
    public int getY() { return Y; }
    public PGraphics getPage() { return page; }
    
    public boolean getConditionAffichage() { return conditionAffichage; }
    public void setConditionAffichage(boolean condition) { conditionAffichage = condition; }
    public boolean getConditionAffichageContinue() { return conditionAffichageContinue; }
    public void setConditionAffichageContinue(boolean condition) { conditionAffichageContinue = condition; }
    
    public String getActionSelect() { return actionSelect; }
    public void setActionSelect(String action) { actionSelect = action; }
  
}