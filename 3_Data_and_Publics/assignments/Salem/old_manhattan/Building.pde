class Building {
  PVector lon_lat = new PVector();
  PVector screen_pos = new PVector();

  int building_area;
  int year;
  int value;
  int floors;
  int frontage;
  int depth;

  String address;
  int tax_block;
  int tax_lot;
  int zipcode;

  String building_class;
  String owner_type;
  String owner_name;

  int age;
  color col = color(255);
  float alpha = 0;

  boolean viewable = true;
  float ellipse_width = 1;
  float animation_ellipse_width = 1;
  float max_ellipse_width = 3;

  boolean animate_up = false;
  boolean animate_down = false;

  void update() {
  }

  void render() {
    if (viewable) {

      noStroke();
      fill(red(col), green(col), blue(col), alpha);
      ellipse(screen_pos.x, screen_pos.y, ellipse_width, ellipse_width);
    }
  }


  void calculateAge() {
    age = 2014 - year;
  }

  void calculatePosition() {

    float x = map(lon_lat.x, currentTopLeft.x, currentBottomRight.x, 0, width);
    float y = map(lon_lat.y, currentBottomRight.y, currentTopLeft.y, height, 0);
    screen_pos = new PVector(x, y);
  }

  void setColorBasedOnClass() {
    if (!building_class.trim().equals("")) {
      if (building_class.charAt(0) == 'A' || building_class.charAt(0) == 'B' || building_class.charAt(0) == 'C' || building_class.charAt(0) == 'D' || building_class.charAt(0) == 'R' || building_class.charAt(0) == 'S') {
        col = color(255, 255, 0);
      }
    }
  }

  void setAlphaBasedOnAge() {
    alpha = map(age, 0, 2014, 150, 255);
  }

  void incrementAlpha() {
  }

  void animate() {
    if (animate_up) {
      animation_ellipse_width = lerp(animation_ellipse_width, max_ellipse_width, 0.2);
      noStroke();
      fill(red(col), green(col), blue(col), 100);
      ellipse(screen_pos.x, screen_pos.y, animation_ellipse_width, animation_ellipse_width);
      
       if (animation_ellipse_width >= max_ellipse_width-0.5) {
        animate_up = false;
        animate_down = true;
      }
    } 
    if (animate_down) {
      if (animation_ellipse_width <= 1.2) {
        animate_down = false;
        
      }
      animation_ellipse_width = lerp(animation_ellipse_width, 1, 0.2);
      //println("animating down " + animation_ellipse_width);
      fill(red(col), green(col), blue(col), 100);
      if(animate_down) ellipse(screen_pos.x, screen_pos.y, animation_ellipse_width, animation_ellipse_width);
      
    }
  }
}

