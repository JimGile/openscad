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
smooth_r = 1.6;
insert_x = 9.8;
insert_y = 9.6;
insert_z = 12;

ball_r = 1;
ball_eps = .25;

trans_z = 4;

shaft_r = 3.5;
shaft_h = 15;

// ---------------------------
// Calculations
// ---------------------------
insert = [insert_x, insert_y, insert_z];
trans_r = insert_y/2;
trans_z_off = insert_z/2 - smooth_r;
shaft_z_off = trans_z_off + trans_z;
ball_y_off = insert_y/2 - ball_eps;


// ---------------------------
// Render
// ---------------------------
fullRender();

module fullRender() {
    // Shaft
    translate([0,0,shaft_z_off])cylinder($fn=6,h=shaft_h, r=shaft_r);
    hull() {
        // Transition
        translate([0,0,trans_z_off])cylinder($fn=6,h=trans_z, r1=trans_r, r2=shaft_r);
        // Insert
        centeredSmoothCube(insert, smooth_r);
    }
    translate([0,ball_y_off,0])sphere(r = ball_r);
}

module centeredSmoothCube(size, smooth_rad) {
    translate([-size[1]/2,-size[0]/2,-size[2]/2])
        SmoothCube([size[0], size[1], size[2]], smooth_rad);
}
