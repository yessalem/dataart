ArrayList<Building> buildings = new ArrayList<Building>();

String filename = "MN-wv.csv";

PVector screenGPSTopLeft = new PVector(-74.042207, 40.835739);
PVector screenGPSBottomRight = new PVector(-73.887537, 40.683378);

PVector currentTopLeft = screenGPSTopLeft;
PVector currentBottomRight = screenGPSBottomRight;





int year_animation_period = 500; //a year is 1/2 sec 
int current_time;
int start_time;
//int current_year = 2014;
//int current_year = 1765;
int current_year = 1800;
int n = 1;

PFont font;


void setup() {
  size(800, 800);
  background(0);
  font = loadFont("ACaslonPro-BoldItalic-48.vlw");
  textFont(font, 48);


  loadBuildings();


  start_time = millis();
}


void draw() {
  background(0);
  for (int i=0; i < buildings.size(); i++) {
    buildings.get(i).animate();
    buildings.get(i).render();
  }
  current_time = millis();
  if (current_time > n* year_animation_period) {
    if (current_year < 2014) current_year++;
    n++;
    //println("*****" + current_year);
  }
  progress();
  //println(current_time);
  //filter(BLUR);
  fill(200);
  text(current_year, 0.8*width, 0.9*height); 

  //testBuildings();
  //filter(INVERT);
}

void loadBuildings() {
  Table data = loadTable(filename, "header, csv");

  for (TableRow row: data.rows()) {
    if (row.getString("FullAddress") != "") {
      Building building = new Building();

      building.building_area = row.getInt("BldgArea");
      building.year = row.getInt("YearBuilt");
      building.value = row.getInt("AssessTot");
      building.floors = row.getInt("NumFloors");
      building.frontage = row.getInt("BldgFront");
      building.depth = row.getInt("BldgDepth");
      building.address = row.getString("FullAddress");
      building.tax_block = row.getInt("Block");
      building.tax_lot = row.getInt("Lot");
      building.zipcode = row.getInt("ZipCode");
      building.building_class = row.getString("BldgClass");
      building.owner_type = row.getString("OwnerType");
      building.owner_name = row.getString("OwnerName");

      building.lon_lat = new PVector(row.getFloat("Lng"), row.getFloat("Lat"));

      building.calculateAge();
      building.calculatePosition();
      //building.setAlphaBasedOnAge();
      building.setColorBasedOnClass();

      buildings.add(building);
    }
  }
}

void testBuildings() {
  println("*");
  println(buildings.get(100).address);
  println(buildings.get(100).year);
  println(buildings.get(100).alpha);
  println("*");
}

void progress() {
  for (Building building: buildings) {
    if (building.year < current_year) {
      if (building.alpha >= 255) building.alpha = 255;
      else building.alpha++;
    } 
    else if(building.year == current_year){
      building.animate_up = true;
    } else if (building.year > current_year) {
      building.alpha = 0;
    }
  }
}

void zoom() {
 



  float x_lower_limit = mouseX-100;
  float x_upper_limit = mouseX+100;
  float y_lower_limit = mouseY+100;
  float y_upper_limit = mouseY-100;

  float new_top_left_x = map(x_lower_limit, 0, width, currentTopLeft.x, currentBottomRight.x);
  float new_top_left_y = map(y_upper_limit, height, 0, currentBottomRight.y, currentTopLeft.y);
  float new_bottom_right_x = map(x_upper_limit, 0, width, currentTopLeft.x, currentBottomRight.x);
  float new_bottom_right_y = map(y_lower_limit, height, 0, currentBottomRight.y, currentTopLeft.y);

  //float mouseXgps = map(mouseX, 0, width, currentTopLeft.x, currentBottomRight.x);
  //float mouseYgps = map(mouseY, 0, height, currentBottomRight.y, currentTopLeft.y);

  currentTopLeft = new PVector(new_top_left_x, new_top_left_y);
  currentBottomRight = new PVector(new_bottom_right_x, new_bottom_right_y);
  println(currentTopLeft.x + ", " + currentTopLeft.y);
  println(currentBottomRight.x + ", " + currentBottomRight.y);

  for (Building building: buildings) {

    //    float x =  building.screen_pos.x;
    //    float y =  building.screen_pos.y;
    //    if (x < x_upper_limit && x > x_lower_limit && y < y_upper_limit && y > y_lower_limit) {
    //      building.viewable = true;
    //    } 
    //    else {
    //      building.viewable = false;
    //    }
    building.ellipse_width = 3;
    building.calculatePosition();
  }

  //building.calculatePosition();
}

void keyPressed() {

  if (key == ' ') {
    current_year = 1800;
    n = 1;

    for (Building building: buildings) {

      building.alpha = 0;
    }
  } 
  else if (keyCode == RIGHT) {
    current_year = (current_year >= 2014)? 2014: current_year+10;
  } 
  else if (keyCode == LEFT) {
    current_year = (current_year <= 1800)? 1800: current_year-10;
  } 
  else if (keyCode == DOWN) {
  } 
  else if (keyCode == TAB) {
    currentTopLeft = screenGPSTopLeft;
    currentBottomRight = screenGPSBottomRight;

    for (Building building: buildings) {
      building.calculatePosition();
      building.viewable = true;
      building.ellipse_width = 1;
    }
  }
}

void mouseClicked() {
  zoom();
}

