top_diameter    =  49.0;  // Diameter of top opening
shoulder_length =  10.0;  // Exterior length of shoulder
shoulder_slump  =   5.1;  // How far down the lower edge of the shoulder goes
neck_height     =   7.5;  // How high up the neck of the top frame protrudes
light_diameter  =  25.9;  // Exterior diameter of flashlight head (corrected)
interior_height = 129.0;  // From top of bottom wire posts to top shoulder

frame_width     =   6.0;  // Width of the A-frame (along latitudinal direction)
frame_thickness =   2.1;  // Thickness of A-frame (inwards to center)
peg_height      =   7.5;  // Height of peg connecting A-frame with collet
peg_thickness   =   1.5;  // Thickness of peg connecting A-frame with collet
bottom_post_gap =  60.0;  // Gap between wire posts on bottom support

collet_small_thickness = 2.1;
collet_large_thickness = peg_thickness + collet_small_thickness;
collet_height = frame_thickness + peg_height + 4.5;

top_radius = top_diameter / 2;
light_radius = light_diameter / 2;
bottom_post_radius = bottom_post_gap / 2;

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
  difference() {
    translate([-long_length / 2, -short_length / 2, 0]) {
      // TODO: should be a nicer rounded shape
      cube([long_length, short_length, collet_height]);
    }
    // Cut out flashlight diffuser cylinder
    translate([0, 0, -e]) cylinder(r = r, h = collet_height + e2);
    // Cut out peg insert (bottom portion)
    translate([-(long_length / 2) - e, -frame_width / 2, -e]) {
      cube([long_length + e2, frame_width, frame_thickness + e]);
    }
    // Cut out peg insert (peg insertion portion)
    translate([-(long_length / 2) + peg_thickness, -frame_width / 2, -e]) {
      cube([long_length - (peg_thickness * 2), frame_width, frame_thickness + peg_height + e]);
    }
  }
}

rotate(90, [1, 0, 0]) aframe();

translate([0, 0, peg_height + 10]) collet();
