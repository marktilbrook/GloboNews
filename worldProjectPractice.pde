//todo notes:
/* Have a list of countries and display their news information from https://world.einnews.com/ */



int n;
float[][] points;
float lat, lon, r, t;
PVector coord;

PShape globe;
PImage earth_texture;
 
void setup() { 
  size(1800, 1800, P3D); 
  coord = new PVector();
  background(0); 
  
  n = 25;        // number of points
  r = 600;        // sphere's radius
  t = 0;          // rotation accumulator
  
  readRSS();
  populateGlobe();
  createGlobe();
  
  
 
  
}
 
void draw() { 
  background(0);
  translate(width/2, height/2); //centers earth
  rotateY(6 * radians(t += (TWO_PI / 365)));//change this to change speed of rotation
  shape(globe);
  
 //points
  fill(255,0,0);
  stroke(255,0,0);
  strokeWeight(12);
  
  for (int i=1; i<points.length; i++) {
    //cartesian coordinate conversion
    lat = radians(points[i][0]);
    lon = radians(points[i][1]);
    coord.x = r * cos(lat) * cos(lon);
    coord.y = r * cos(lat) * sin(lon);
    coord.z = r * sin(lat);
    point(coord.x, coord.y, coord.z);
  }
  
  
  
}

//creates globe and sets texture
void createGlobe(){
  //sets texture
  noStroke();
  earth_texture = loadImage("earthmap2.jpg");
  globe = createShape(SPHERE, r); 
  globe.setTexture(earth_texture);
  
}

void populateGlobe(){
  // populate globe w/ random GPS coordinates
  points = new float[n][2];
  for (int i=0; i<points.length; i++) {
    points[i][0] = random(-90, 90);    // latitude
    points[i][1] = random(-180, 180);  // longitude
  }
}

//this prints RSS to console
void readRSS(){
  
  XML rss = loadXML("https://it.einnews.com/rss/Ds5YG_pF3PymkwhH");
  XML[] news = rss.getChildren("channel/item");
  for(XML it : news){
    XML header = it.getChild("title");
    println(header.getContent());
  }
  
}