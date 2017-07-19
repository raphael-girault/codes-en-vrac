


void keyReleased() {
  float pas = radians(10);
  switch (key) {
    case 'z':
      angleScene.x += pas;
      break;
    case 's':
      angleScene.x -= pas;
      break;
    case 'q':
      angleScene.y -= pas;
      break;
    case 'd':
      angleScene.y += pas;
      break;
  }
  
  conditionAffichage = true;
  println("angle scène" , round(degrees(angleScene.x%TWO_PI)) , round(degrees(angleScene.y%TWO_PI)));
}