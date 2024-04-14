include <smooth_prim/smooth_prim.scad>

// ---------------------------
// Constants
// ---------------------------
$fa = 1;
$fs = 0.4;
in_to_mm = 25.4;

// ---------------------------
// Variables
// ---------------------------
screw_hole_r = 1;
screw_plate_h = 10;
thickness = 2;

num_holders = 2;
holder_r = 16;
holder_h = 30;
holder_spacing = 10;

// ---------------------------
// Calculations
// ---------------------------
total_h = screw_plate_h + holder_h;
total_d = thickness*2 + holder_r*2;
total_w = thickness*2 + holder_r*2*num_holders + holder_spacing*(num_holders-1);
holder_y_offset = holder_r+holder_spacing/2;
holder_y_offset2 = holder_r*(3/2)+holder_spacing/2;
drain_hole_r = holder_r/2;

//base();
//translate([(total_d-thickness)/2,0,screw_plate_h/2]) screwPlate();
//screwHole();
//screwPlate();

fullRender();

module fullRender() {
    x_offset = (total_d-thickness)/2;
    z_offset = screw_plate_h/2;
    difference() {
        union() {
            base();
            translate([x_offset,0,z_offset])
                screwPlate();            
        }
        translate([x_offset,0,0])
            screwHole();
    }
}

module base() {
    translate([0,-holder_y_offset,0]) holder();
    translate([0,holder_y_offset,0]) holder();
    holderConnector();
}

module holder() {
    holder_x = holder_r;
    holder_y = (holder_r+thickness)*2;
    difference() {
        union() {
            translate([holder_r/2,0,0])
                centeredSmoothXYCube([holder_x, holder_y, holder_h], thickness);
            translate([0,0,-holder_h/2])
                SmoothCylinder(holder_r+thickness,holder_h,thickness);
        }
        //remove holder portion
        translate([0,0,thickness])cylinder(h=holder_h,r=holder_r,center=true);
        //remove drian hole
        cylinder(h=holder_h+1,r=drain_hole_r,center=true);
    }
}

module holderConnector() {
    spacing_r = holder_spacing/2-thickness;
    spacing_x = spacing_r;
    spacing_y = (spacing_r+thickness)*2;
    x_offset = holder_r-spacing_r-thickness;
    difference() {
        union() {
            translate([x_offset,0,-holder_h/2])
                centeredHollowCylinder(spacing_r+thickness*2, spacing_r,holder_h);
            translate([x_offset,0,0])
                tube(spacing_r+thickness*2, spacing_r+thickness,holder_h);
        }
        translate([x_offset/2,0,0])
            cube([holder_spacing+1,spacing_y+1,holder_h+1],center=true);
    }
}


module screwPlate() {
    screw_hole_z_offset = holder_h/2;
    echo(str("screw_hole_z_offset:", screw_hole_z_offset));
    difference() {
        centeredSmoothXYCube([thickness, total_w, total_h], thickness);
        translate([0,-holder_y_offset2,screw_hole_z_offset]) screwHole();
        translate([0,holder_y_offset2,screw_hole_z_offset]) screwHole();
        translate([0,0,screw_hole_z_offset]) screwHole();
    }
}

module screwHole() {
    rotate([0,90,0]) cylinder(h=thickness*4,r=screw_hole_r,center=true);
}

module centeredSmoothXYCube(size, smooth_rad) {
    rotate([0,0,90])
    translate([-size[1]/2,size[0]/2,size[2]/2])
    rotate([90,90,0])
        SmoothXYCube([size[2], size[1], size[0]], smooth_rad);
}

module centeredHollowCylinder(outer_rad, inner_rad, height) {
    HollowCylinder(outer_rad, inner_rad, height);
}

module tube(outer_rad, inner_rad, height) {
    difference() {
        cylinder(h=height,r=outer_rad,center=true);
        cylinder(h=height+1,r=inner_rad,center=true);
    }
}