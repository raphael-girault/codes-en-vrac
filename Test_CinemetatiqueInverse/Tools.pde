


PVector getIntersectionLineCircle (PVector centreCercle , float rCercle , PVector lineP1 , PVector lineP2) {
  PVector resultat = null;

    PVector p = lineP1;
    float x0 = centreCercle.x;
    float y0 = centreCercle.y;
    float radius = rCercle;
  
    PVector mouse = new PVector(lineP2.x, lineP2.y);

    PVector sub = PVector.sub(mouse, p);
    // y = a * x + b
    float a = sub.y / sub.x;
    float b = p.y - a * p.x;
    // (x - x0)^2 + (y - y0)^2 = radius ^2
    // y = a * x + b
    float A = (1 + a * a);
    float B = (2 * a *( b - y0) - 2 * x0);
    float C = (x0 * x0 + (b - y0) * (b - y0)) - (radius * radius);
    float delta = B * B - 4 * A * C;

    if (delta >= 0) {
      float x1 = (-B - sqrt(delta)) / (2 * A);
      float y1 = a * x1 + b;
      if ((x1 > min(p.x, mouse.x)) && (x1 < max(p.x, mouse.x)) && (y1 > min(p.y, mouse.y)) && (y1 < max(p.y, mouse.y))) {
        //ellipse(x1, y1, 20, 20);
        resultat = new PVector(x1,y1);
      }
      float x2 = (-B + sqrt(delta)) / (2 * A);
      float y2 = a * x2 + b;
      if ((x2 > min(p.x, mouse.x)) && (x2 < max(p.x, mouse.x)) && (y2 > min(p.y, mouse.y)) && (y2 < max(p.y, mouse.y))) {
        //ellipse(x2, y2, 20, 20);
        resultat = new PVector(x2,y2);
      }
    }
  
  return resultat;
}





public double[] circleCircleIntersects(double x1, double y1, double x2, double y2, double r1, double r2)
{
  // Use change of coordinates to get:
  //   Cirlce 1: r1^2 = x^2 + y^2
  //   Circle 2: r2^2 = (x - a)^2 + (y - b)^2
  double a = x2 - x1;
  double b = y2 - y1;
   
  // Find distance between circles.
  double ds = a*a + b*b;
  double d = Math.sqrt( ds );
   
  // Ensure that the combined radii lengths are longer than the distance between the circles,
  // i.e. tha the circles are close enough to intersect.
  if (r1 + r2 <= d)
    return null;
   
  // Ensure that one circle is not inside the other.
  if (d <= Math.abs( r1 - r2 ))
    return null;
   
  // Find the intersections (formula derivations not shown here).
  double t = Math.sqrt( (d + r1 + r2) * (d + r1 - r2) * (d - r1 + r2) * (-d + r1 + r2) );
 
  double sx1 = 0.5 * (a + (a*(r1*r1 - r2*r2) + b*t)/ds);
  double sx2 = 0.5 * (a + (a*(r1*r1 - r2*r2) - b*t)/ds);
   
  double sy1 = 0.5 * (b + (b*(r1*r1 - r2*r2) - a*t)/ds);
  double sy2 = 0.5 * (b + (b*(r1*r1 - r2*r2) + a*t)/ds);
   
  // Translate to get the intersections in the original reference frame.
  sx1 += x1;
  sy1 += y1;
   
  sx2 += x1;
  sy2 += y1;
   
  double[] r = new double[4];
  r[0] = sx1;
  r[1] = sy1;
  r[2] = sx2;
  r[3] = sy2;
   
  return r;
}