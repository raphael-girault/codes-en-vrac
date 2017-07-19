/*
  Le but du code est de réaliser un premier jet pour le système d'animation de l'application.
*/


//IMPORTATIONS
  import java.lang.reflect.Field;
  import java.util.Map;
  import controlP5.*;


//CONSTANTES GENERALES
  int lCase = 10;


//INSTANCES
  TimeLine timeLine;
  Bande bande;
  
  ControlP5 cp5;
  Range range;
  
  
  Pastille pastille;
  
  //pour les inputs
    boolean sourisRelachee = false;



  int maxL = 100;


void setup() {
  size(400,400);
  
  pastille = new Pastille(width/2 , height/2 , 30);
  
  
  timeLine = new TimeLine(20,height-100,20,20);
  
  bande = new Bande(20,height-70,20,timeLine.getNbFrames(),pastille,"px","int");
    //(int px , int py , int H , int nbFrames , Object objet , String param)
    
    
  //mise en place des éléments du gui
    cp5 = new ControlP5(this);
    range = cp5.addRange("rangeController")
               .setPosition(20,height-25)
               .setSize(maxL,20)
               .setHandleSize(0)
               .setRange(0,maxL)
               .setLabelVisible(false) 
               //.setRangeValues(50,200)
               ;
               setTailleRange();
  
}//fin setup



void draw() {
  background(50);
  
  pastille.affichage();
  
  timeLine.affichage();
  
  bande.affichage();
  
  sourisRelachee = false;
}//fin draw





void mouseReleased() {
  sourisRelachee = true;
}




/*
  Fonction pour définir la taille de la barre dans le range (slider)
*/
void setTailleRange() {
  if (maxL >= timeLine.L) {
    range.setRangeValues(0,maxL);
  } else {
    int diff = timeLine.L - maxL;
    range.setRange(0,timeLine.L);
    range.setRangeValues(0,maxL);
  }
}//fin setTailleRange



/*
  Event gui du range
*/
void rangeController() {
  //int diff = int(timeLine.L - range.getValue());
  //bande.px -=
  //println(range.getArrayValue(0));
  try {
    bande.px = bande.PX - int(range.getArrayValue(0));
    timeLine.px = timeLine.PX - int(range.getArrayValue(0));
  } catch (Exception e) {}
}//fin rangeController