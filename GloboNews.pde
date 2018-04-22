
/*
    NOTES:
    
    1. 360,360 is centre and right most side of the texture
    
*/


int n;
int speed;

float lat, lon, r, t;
PVector coord;

boolean canRefresh;

PShape globe;
PImage earth_texture;

PVector us;
PVector china;
PVector russia;
PVector brazil;
PVector uk;
PVector me;
PVector aus;
PVector india;
PVector temp8;
PVector temp9;

XML[] news;
String[] keys = {"Russia","Russian", "Nuclear", "Korea", "Korean", "UK", "U.S.", "Saudi", "Australia", "Trump", "India", "Indian", "China", "Chinese", "Iran", "Iranian", "Israel", "Israeli"
, "Palestine", "Palestinian"};

ArrayList<String> list;


// variables are delcared outside of setup but initialized wiwthin the setup function(this excludes the String Array keys because it wouldnt allow this
void setup() { 
  size(800,800, P3D); 
  coord = new PVector();
  background(186, 186, 186); 
  
  canRefresh = true;
  
  n = 25;        // number of points
  r = 250;        // sphere's radius
  t = 0;   // rotation accumulator
  
  speed = 20;       //speed
  
  
  createGlobe();
  us = new PVector(-130,80); 
  china = new PVector(125,120); 
  russia = new PVector(140,100); 
  brazil = new PVector(-130,-20); 
  uk = new PVector(181,411); 
  me = new PVector(135,390); 
  aus = new PVector(49,56); //australia
  india = new PVector(108,400); 
  temp8 = new PVector(random(-90,90),random(-180,180)); 
  temp9 = new PVector(random(-90,90),random(-180,180)); 
  
  
}
 
void draw() { 
  
  background(186, 186, 186);

  drawText();
  
  translate(width/2, height/2); //centers earth
  rotateY(speed * radians(t += (TWO_PI / 365)));//change this to change speed of rotation
  shape(globe);
  
  // anything below this will rotate with the globe
  
  
  
  plotPoint(us);
  plotPoint(china);
  plotPoint(russia);
  plotPoint(brazil);
  plotPoint(uk);
  plotPoint(me);
  plotPoint(aus);
  plotPoint(india);
  plotPoint(temp8);
  plotPoint(temp9);
 
  refreshData(minute());
 
}

//creates globe and sets texture
void createGlobe(){
  //sets texture
  noStroke();
  earth_texture = loadImage("earthmap2.jpg");
  globe = createShape(SPHERE, r); 
  globe.setTexture(earth_texture);
  
}

// this displayes the earth 
void showGlobe()
{
  translate(width/2, height/2); //centers earth
  rotateY(speed * radians(t += (TWO_PI / 365)));//change this to change speed of rotation
  shape(globe);
}



// this function plots the point on a globe visually
void plotPoint(PVector latlong)
{
   //point coloure and thickness
    fill(255,0,0);
    stroke(255,0,0);
    strokeWeight(12);
   //cartesian coordinate conversion
    lat = radians(latlong.x);
    lon = radians(latlong.y);
    coord.x = r * cos(lat) * cos(lon);
    coord.y = r * cos(lat) * sin(lon);
    coord.z = r * sin(lat);
    point(coord.x, coord.y, coord.z);
    
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
      println("LOADING DATA... \n");
      thread("printRSS");
      //populateGlobe();
    
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

void drawText()
{
    if(list != null)
    {
      
      int offsetY = 45;
      float offsetX = 25;
   
      // sometimes a ConcurrentModificationException is thrown here, sometimes its not.
      for(String item : list)
        {
          offsetY += 20;
          offsetX += 20;
          fill(0);
          text(item, offsetX, offsetY,70); 
        }
    }
    fill(0);
    text("Created by Mark Tilbrook", width/2 + 200 ,770, 25);
}


void printRSS()
{
  list = new ArrayList<String>();
  XML rss = loadXML("http://feeds.reuters.com/Reuters/worldNews");
  news = rss.getChildren("channel/item");
  for(XML it : news)
  {
    XML header = it.getChild("title");
    println(header.getContent());
    String headline = header.getContent();
    
    for(String k : keys)
    {
      if(headline.contains(k))
      {
        println("-----" + header.getContent() + "--------");
       
        list.add(header.getContent());
        break;
      }
    }
  }
}
