include <D:/Documents/OpenSCAD/libraries/smooth_prim/smooth_prim.scad>

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
drain_hole_r = holder_r/2;

base();
translate([(total_d-thickness)/2,0,screw_plate_h/2]) screwPlate();
//screwPlate();

module base() {
    translate([0,-holder_y_offset,0]) holder2();
    translate([0,holder_y_offset,0]) holder2();
}

module holder() {
    holder_x = holder_r;
    holder_y = (holder_r+thickness)*2;
    difference() {
        union() {
            translate([holder_r/2,0,0])cube([holder_x, holder_y, holder_h], center=true);
            cylinder(h=holder_h,r=holder_r+thickness,center=true);
        }
        //remove holder portion
        translate([0,0,thickness])cylinder(h=holder_h,r=holder_r,center=true);
        //remove drian hole
        cylinder(h=holder_h+1,r=drain_hole_r,center=true);
    }
}

module holder2() {
    holder_x = holder_r;
    holder_y = (holder_r+thickness)*2;
    difference() {
        union() {
            translate([holder_r/2,0,0])
                centeredSmoothXYCube([holder_x, holder_y, holder_h], thickness);
            translate([0,0,-holder_h/2])SmoothCylinder(holder_r+thickness,holder_h,thickness);
            //translate([0,0,-holder_h/2])HollowCylinder(holder_r+thickness, holder_r, holder_h);
        }
        //remove holder portion
        translate([0,0,thickness])cylinder(h=holder_h,r=holder_r,center=true);
        //remove drian hole
        cylinder(h=holder_h+1,r=drain_hole_r,center=true);
    }
}

module screwPlate() {
    screw_hole_z_offset = holder_h/2;
    echo(str("screw_hole_z_offset:", screw_hole_z_offset));
    difference() {
        //cube([thickness, total_w, total_h], center=true);
        centeredSmoothXYCube([thickness, total_w, total_h], thickness);
        //translate([-thickness/2,-total_w/2,-total_h/2])
        //    SmoothCube([thickness, total_w, total_h], thickness/2);
        translate([0,-holder_y_offset,screw_hole_z_offset]) screwHole();
        translate([0,holder_y_offset,screw_hole_z_offset]) screwHole();
        translate([0,0,screw_hole_z_offset]) screwHole();
        translate([0,0,-screw_plate_h/2]) screwHole();
    }
}

module screwHole() {
    rotate([0,90,0]) cylinder(h=thickness+1,r=screw_hole_r,center=true);
}

module centeredSmoothXYCube(size, smooth_rad) {
    rotate([0,0,90])
    translate([-size[1]/2,size[0]/2,size[2]/2])
    rotate([90,90,0])
        SmoothXYCube([size[2], size[1], size[0]], smooth_rad);
}