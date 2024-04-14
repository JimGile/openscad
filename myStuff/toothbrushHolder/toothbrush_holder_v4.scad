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
connector_x = total_d - holder_spacing -holder_r;


echo(str("total_d:", total_d));
echo(str("connector_x:", connector_x));

// ---------------------------
// Render
// ---------------------------
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
    translate([connector_x,0,0]) holderConnector();
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
    x_offset_2 = spacing_r/2-thickness;
    outer_rad_1 = spacing_r+thickness*2;
    inner_rad_1 = spacing_r;
    
    translate([inner_rad_1-thickness,0,0])
    halfRondedHollowCylinder(outer_rad_1, inner_rad_1, holder_h);
    
//    outer_rad_2 = spacing_r+thickness*3;
//    inner_rad_2 = spacing_r+thickness;
//    
//    difference() {
//        union() {
//            translate([x_offset,0,-holder_h/2])
//                centeredHollowCylinder(outer_rad_1, inner_rad_1, holder_h);
//            translate([x_offset,0,0])
//                tube(outer_rad_2,inner_rad_2,holder_h);
//        }
//        #translate([x_offset_2,0,0])
//            cube([spacing_r,spacing_y*3,holder_h+1],center=true);
//        translate([-spacing_r/2,0,0])
//            cube([spacing_r,spacing_y*3,holder_h+1],center=true);
//        translate([(total_d+holder_spacing)/2,0,0])
//            cube([holder_spacing+1,spacing_y*3,holder_h+1],center=true);
//        
//    }
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

module halfRondedHollowCylinder(outer_rad, inner_rad, height) {
    spacing_r = holder_spacing/2-thickness;
    spacing_x = spacing_r;
    spacing_y = (spacing_r+thickness)*2;
    outer_rad_2 = outer_rad+thickness;
    inner_rad_2 = inner_rad+thickness;
    outer_rad_3 = outer_rad_2*2;
    inner_rad_3 = inner_rad_2+thickness*2;
    difference() {
        union() {
            translate([0,0,-holder_h/2])
                centeredHollowCylinder(outer_rad, inner_rad, holder_h);
            translate([0,0,0])
                tube(outer_rad_2,inner_rad_2,holder_h);
        }
        tube(outer_rad_3, inner_rad_3, holder_h+1);
        translate([-outer_rad_2/2,0,0])
            cube([outer_rad_2,holder_spacing*3,holder_h+1],center=true);
        translate([0,-outer_rad_2+thickness,0])
            cube([outer_rad_2,thickness*2,holder_h+1],center=true);
        translate([0,outer_rad_2-thickness,0])
            cube([outer_rad_2,thickness*2,holder_h+1],center=true);
        translate([outer_rad_2-thickness,0,0])
            cube([thickness*2,outer_rad_2*2,holder_h+1],center=true);
        
    }
    
}