// lantern.scad - paper lantern scaffolding for FW3A flashlight
// Andrew Ho <andrew@zeuscat.com>

shade_diameter  =   6.0 * 25.4;  // Interior diameter of lampshade sphere
shade_height    = 131.0;         // Height from bottom supports to top opening
top_diameter    =  52.0;         // Diameter of top opening
light_diameter  =  25.6;         // Exterior diameter of flashlight head
lip_height      =   9.0;         // How far down the diffuser sits on the head
shrink_radius   =   2.1;         // How far inward to shrink the diffuser
flange_height   =   2.1;         // Vertical height of 45° bottom flange
spacer_height   =   4.2;         // Height of spacer spanning the wire posts
spacer_width    =   2.1;         // Hull thickness of spacer
bottom_post_gap =  60.0;         // Gap between wire posts on bottom support
wire_thickness  =   0.95;        // How thick the bottom support post wire is
thickness       =   1.2;         // Default wall thickness

e = 0.1;
e2 = e * 2;
$fn = 90;

module hat() {
  difference() {
    translate([0, 0, shade_diameter / 2]) sphere(d = shade_diameter);
    cylinder(d = shade_diameter + e2, h = shade_diameter * 0.92);  // TODO: fix
  }
}

module diffuser() {
  // Lip of the diffuser, or the part which sits on the flashlight head
  lip_id = light_diameter;
  lip_od = lip_id + (thickness * 2);
  lip_flange_od = lip_od + (2 * flange_height);
  difference() {
    union() {
      cylinder(d1 = lip_od, d2 = lip_flange_od, h = flange_height);
      translate([0, 0, flange_height]) {
        cylinder(d1 = lip_flange_od, d2 = lip_od, h = lip_height - flange_height);
      }
    }
    translate([0, 0, -e]) cylinder(d = lip_id, h = lip_height + e2);
  }
  // Main cylindrical shaft above the flashlight
  shaft_id = light_diameter - (shrink_radius * 2);
  shaft_od = shaft_id + (thickness * 2);
  shaft_height = shade_diameter - 120;  // TODO: fix
  belt_height = shrink_radius * 2;
  translate([0, 0, lip_height]) {
    difference() {
      union() {
        cylinder(d1 = lip_od, d2 = shaft_od, h = belt_height);
        translate([0, 0, belt_height]) {
          cylinder(d = shaft_od, h = shaft_height - belt_height);
        }
      }
      union() {
        translate([0, 0, -e]) cylinder(d = lip_id, h = e2);
        cylinder(d1 = lip_id, d2 = shaft_id, h = belt_height);
        translate([0, 0, belt_height - e]) {
          cylinder(d = shaft_id, h = (shaft_height - belt_height) + e2);
        }
      }
    }
  }
}

module spacer() {
  id = light_diameter;
  od = id + (thickness * 2);
  flange_od = od + (2 * flange_height);
  spacer_length = bottom_post_gap + spacer_height;
  difference() {
    union() {
      cylinder(d = flange_od, h = spacer_height);
      translate([-spacer_length / 2, -spacer_width / 2, 0]) {
        cube([spacer_length, spacer_width, spacer_height]);
      }
    }
    translate([0, 0, -e]) cylinder(d = id, h = spacer_height + e2);
    translate([0, 0, spacer_height - flange_height]) {
      hull() {
        cylinder(d1 = id, d2 = id + (2 * flange_height), h = flange_height);
        translate([0, 0, flange_height]) {
          cylinder(d = id + (2 * flange_height), h = e);
        }
      }
    }
    translate([0, 0, spacer_height * 0.4]) {
      translate([(bottom_post_gap / 2) - (wire_thickness / 2), -((spacer_width / 2) + e), 0]) {
        cube([wire_thickness, spacer_width + e2, (spacer_height * 0.6) + e]);
      }
      translate([-(bottom_post_gap / 2) - (wire_thickness / 2), -((spacer_width / 2) + e), 0]) {
        cube([wire_thickness, spacer_width + e2, (spacer_height * 0.6) + e]);
      }
    }
  }
}

hat();

diffuser();

translate([0, 0, -(spacer_height + 10)]) spacer();
