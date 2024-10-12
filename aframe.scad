top_diameter    =  50.0;  // Diameter of top opening (corrected)
shoulder_length =   7.5;  // Exterior length of shoulder
shoulder_slump  =   5.1;  // How far down the lower edge of the shoulder goes
neck_height     =   5.4;  // How high up the neck of the top frame protrudes
light_diameter  =  26.0;  // Exterior diameter of flashlight head (corrected)
interior_height = 129.0;  // From top of bottom wire posts to top shoulder

frame_width     =   5.1;  // Width of the A-frame (along latitudinal direction)
frame_thickness =   2.1;  // Thickness of A-frame (inwards to center)
peg_height      =   5.4;  // Height of peg connecting A-frame with collet
peg_thickness   =   1.5;  // Thickness of peg connecting A-frame with collet
peg_depth       =   4.5;  // How far down the peg goes into the post
bottom_post_gap =  69.0;  // Gap between wire posts on bottom support
// Off by 9mm???

collet_small_thickness = 2.1;
collet_large_thickness = peg_thickness + collet_small_thickness;
collet_height = frame_thickness + peg_height + 4.5;

top_radius = top_diameter / 2;
light_radius = light_diameter / 2;
bottom_post_radius = bottom_post_gap / 2;

cgap = 0.15;  // Correction gap
cgap2 = cgap * 2;

e = 0.1;
e2 = e * 2;
$fn = 90;

module aframe() {
  r = light_radius;     // TODO: should be diffuser radius
  t = frame_thickness;
  t2 = t * 2;
  module aframe_polygon() {
    polygon([
      [r, t + peg_height],
      [r + t, t + peg_height],
      [r + t, t],
      [bottom_post_radius - t, t],
      [top_radius + t + shoulder_length, interior_height - t - shoulder_slump],
      [top_radius, interior_height - t],
      [top_radius, interior_height + neck_height - t],
      [0, interior_height + neck_height - t],
      // TODO: would be nice to have a decorative hanging/finger loop
      [0, interior_height + neck_height],
      [top_radius + t, interior_height + neck_height],
      [top_radius + t, interior_height],
      [top_radius + t2 + shoulder_length, interior_height - shoulder_slump],
      [bottom_post_radius, 0],
      [bottom_post_radius - (t / 3), -peg_depth],
      [bottom_post_radius - (2 * t / 3), -peg_depth],
      [bottom_post_radius - t, 0],
      // TODO: actual post
      [r, 0]
    ]);
  }
  translate([0, 0, -frame_width / 2]) {
    linear_extrude(frame_width) aframe_polygon();
    mirror([1, 0, 0]) linear_extrude(frame_width) aframe_polygon();
  }
}

module collet() {
  r = light_radius;  // TODO: should be diffuser radius
  short_length = (r + collet_small_thickness) * 2;
  long_length = (r + collet_large_thickness) * 2;
  cutout_upper_length = long_length - (peg_thickness * 2) - cgap2;
  cutout_width = frame_width + cgap;
  difference() {
    hull() {
      translate([-collet_large_thickness / 2, 0, 0]) {
        cylinder(r = short_length / 2, h = collet_height);
      }
      translate([collet_large_thickness / 2, 0, 0]) {
        cylinder(r = short_length / 2, h = collet_height);
      }
    }
    // Cut out flashlight diffuser cylinder
    translate([0, 0, -e]) cylinder(r = r, h = collet_height + e2);
    // Cut out peg insert (upper peg insertion portion)
    translate([-cutout_upper_length / 2, -cutout_width / 2, -e]) {
      cube([cutout_upper_length, cutout_width, e + frame_thickness + peg_height + cgap]);
    }
    // Cut out peg insert (lower frame portion)
    translate([-(long_length / 2) - 1, -cutout_width / 2, -e]) {
      cube([1 + long_length + 1, cutout_width, e + frame_thickness + cgap]);
    }
  }
}

module visual() {
  rotate(90, [1, 0, 0]) aframe();
  translate([0, 0, peg_height + 10]) collet();
}

module printable() {
  translate([0, -interior_height / 2, frame_width / 2]) aframe();
  translate([0, 0, collet_height]) mirror([0, 0, 1]) collet();
}

printable();
