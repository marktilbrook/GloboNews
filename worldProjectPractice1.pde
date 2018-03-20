//todo notes:
/* Have a list of countries and display their news information from https://world.einnews.com/ */

/* NOTE: Plot point function works, however, it must be tested with real co ords because i think the texture may need to be offset */



int n;
int speed;
float[][] points;
float lat, lon, r, t;
PVector coord;

boolean canRefresh;

PShape globe;
PImage earth_texture;
 
void setup() { 
  size(1000,1000,P3D); 
  coord = new PVector();
  background(0); 
  
  canRefresh = true;
  
  n = 25;        // number of points
  r = 400;        // sphere's radius
  t = 0;   // rotation accumulator
  
  speed = 10;       //speed
  

  //populateGlobe();
  
  
  createGlobe();
  
}
 
void draw() { 
  
  background(0);
  translate(width/2, height/2); //centers earth
  rotateY(speed * radians(t += (TWO_PI / 365)));//change this to change speed of rotation
  shape(globe);
  
  //lat -90 90     long -180 180
  plotPoint(-53.f,-97.f);
  plotPoint(-50.f,120.f);
    
  
  
  
  refreshData();
  
  
  
}

//creates globe and sets texture
void createGlobe(){
  //sets texture
  noStroke();
  earth_texture = loadImage("earthmap2.jpg");
  globe = createShape(SPHERE, r); 
  globe.setTexture(earth_texture);
  
}

//void populateGlobe(){
//  // populate globe w/ random GPS coordinates
//  points = new float[n][2];
//  for (int i=0; i<points.length; i++) {
//    points[i][0] = random(-90, 90);    // latitude
//    points[i][1] = random(-180, 180);  // longitude
//  }
//}


void plotPoint(float a_lat, float a_long)
{
   //point coloure and thickness
    fill(255,0,0);
    stroke(255,0,0);
    strokeWeight(12);
   //cartesian coordinate conversion
    lat = radians(a_lat);
    lon = radians(a_long);
    coord.x = r * cos(lat) * cos(lon);
    coord.y = r * cos(lat) * sin(lon);
    coord.z = r * sin(lat);
    point(coord.x, coord.y, coord.z);
  
}





void refreshData()
{
  if(canRefresh)
  {
    if(minute() == 30)
    {
      canRefresh = false;
      println("refreshing data!");
      //thread("readRSS");
    }
  }
  
  if(!canRefresh)
  {
    if(minute() == 5)
    {
      canRefresh = true;
      println("resetting bool");
    }
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
