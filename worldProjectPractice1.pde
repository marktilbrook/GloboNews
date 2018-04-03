/* ############################################################################
             Copyright 2018, Mark Tilbrook, All rights reserved.
############################################################################### */
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
  background(186, 186, 186); 
  
  canRefresh = true;
  
  n = 25;        // number of points
  r = 600;        // sphere's radius
  t = 0;   // rotation accumulator
  
  speed = 10;       //speed
  

  //populateGlobe();
  
  
  createGlobe();
  
}
 
void draw() { 
  
  background(186, 186, 186);
  
  textHeadline("Copyright 2018, Mark Tilbrook, All rights reserved.", width/2+400, 1700, 20); // footer
  
  
  textHeadline("Venezuela opposition candidate's aide hit, suffers severe head injury", 200, 100, 40);
  
  
  translate(width/2, height/2); //centers earth
  rotateY(speed * radians(t += (TWO_PI / 365)));//change this to change speed of rotation
  shape(globe);
  // anything below this will rotate with the globe
  
  //lat -90 90     long -180 180
  plotPoint(-53.f,-97.f);
  plotPoint(-50.f,120.f);
  
  
    
  
  //plotText("Venezuela opposition candidate's aide hit, \n suffers severe head injury", 12, 45, 600, 20); //Venezuela opposition candidate's aide hit, suffers severe head injury
  //plotText("Venezuela opposition candidate's aide hit, \n suffers severe head injury", 300, -450, 600, 20);
  
  
  refreshData(8);
  
  
  
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
void plotText(String text, int x, int y, int z, int size)
{
  textSize(size);
  fill(255,0,0);
  text(text, x, y, z);  // Specify a z-axis value 12 45 600
  
}

void textHeadline(String text, int x, int y, int size)
{
 textSize(size);
 fill(0);
 text(text,x,y);
}




// this function refreshes the data.
// the parameters are the minute of refresh
void refreshData(int minute)
{
  if(canRefresh)
  {
    if(minute() == minute)
    {
      canRefresh = false;
      println("refreshing data!");
      thread("readRSS");
    }
  }
  
  if(!canRefresh)
  {
    if(minute() == minute + 2)
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
