// lantern.scad - paper lantern scaffolding for FW3A flashlight
// Andrew Ho <andrew@zeuscat.com>

shade_diameter  =   6.0 * 25.4;  // Interior diameter of lampshade sphere
shade_height    = 131.0;         // Height from bottom supports to top opening
top_diameter    =  49.8;         // Diameter of top opening
light_diameter  =  25.6;         // Exterior diameter of flashlight head
lip_height      =   9.0;         // How far down the diffuser sits on the head
shrink_radius   =   2.1;         // How far inward to shrink the diffuser
flange_height   =   2.1;         // Vertical height of 45° bottom flange
spacer_height   =   6.0;         // Height of spacer spanning the wire posts
spacer_width    =   3.9;         // Hull thickness of spacer
bottom_post_gap =  60.0;         // Gap between wire posts on bottom support
wire_thickness  =   0.95;        // How thick the bottom support post wire is
thickness       =   1.2;         // Default wall thickness

// Correction factors
light_correction = 0.5;  // Add to flashlight diameter

e = 0.1;
e2 = e * 2;
thickness2 = thickness * 2;
$fn = 120;

// Top piece, which holds top of paper lantern taut
module hat() {
  // The flat plug that rests against top aperture of the paper lantern
  hull() {
    cylinder(d = top_diameter, h = e);
    translate([0, 0, thickness * 5]) {
      cylinder(d = top_diameter + (thickness * 10), h = thickness);
    }
  }
  // The flashlight shaft equivalent that the diffuser snaps into
  d = light_diameter - (shrink_radius * 2) - e2;
  h = (lip_height * 0.8);
  hull() {
    translate([0, 0, thickness * 6]) {
      cylinder(d = d, h = h - thickness);
      translate([0, 0, h - thickness]) {
        cylinder(d = d - thickness2, h = thickness);
      }
    }
  }
}

// Middle shaft, which is the vertical support and attaches to the flashlight
module diffuser() {
  // Lip of the diffuser, or the part which sits on the flashlight head
  lip_id = light_diameter + light_correction;
  lip_od = lip_id + thickness2;
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
  shaft_od = shaft_id + thickness2;
  shaft_height = shade_height - (thickness * 6);  // TODO: calculate better
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

// Coupler which attaches to the wire loops at the bottom of the lantern
module spacer() {
  id = light_diameter + light_correction + thickness2;
  od = id + thickness2;
  flange_od = od + (2 * flange_height);
  spacer_length = bottom_post_gap + spacer_height;

  module wire_notch() {
    h = spacer_height * 0.66;
    translate([-h, (spacer_width / 2) + e, 0]) {
      rotate(90, [1, 0, 0]) {
        linear_extrude(spacer_width + e2) {
          polygon([[0, -e], [0, 0], [h, h], [h, -e]]);
        }
      }
    }
  }

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
    translate([bottom_post_gap / 2, 0, 0]) {
      wire_notch();
      translate([(spacer_height * 0.66) + thickness, 0, 0]) wire_notch();
    }
    mirror([1, 0, 0]) {
      translate([bottom_post_gap / 2, 0, 0]) {
        wire_notch();
        translate([(spacer_height * 0.66) + thickness, 0, 0]) wire_notch();
      }
    }
  }
}

difference() {
  union() {
    translate([0, 0, shade_height + 10]) hat();
    diffuser();
    translate([0, 0, -(spacer_height + 1)]) spacer();
  }
}
