
int n;
int speed;
float[][] points;
float lat, lon, r, t;
PVector coord;

boolean canRefresh;

PShape globe;
PImage earth_texture;
 
void setup() { 
  size(1800, 1800, P3D); 
  coord = new PVector();
  background(0); 
  
  canRefresh = true;
  
  n = 25;        // number of points
  r = 600;        // sphere's radius
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
  
  
    
  
  plotText("Hello");
  
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

//plot text 
void plotText(String text)
{
  textSize(80);
  fill(255,0,0);
  text(text, 12, 45, 600);  // Specify a z-axis value
  
}




// this function refreshes the data feed at a given minute
void refreshData()
{
  if(canRefresh)
  {
    if(minute() == 21)
    {
      canRefresh = false;
      println("refreshing data!");
      thread("readRSS");
    }
  }
  
  if(!canRefresh)
  {
    if(minute() == 30)
    {
      canRefresh = true;
      println("resetting bool");
    }
  }
}

//this prints RSS to console
void readRSS()
{
  
  XML rss = loadXML("http://feeds.reuters.com/Reuters/worldNews");
  XML[] news = rss.getChildren("channel/item");
  for(XML it : news)
  {
    XML header = it.getChild("title");
    println(header.getContent());
  }
  
}
