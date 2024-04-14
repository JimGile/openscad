// Smooth rendering
$fa = 1;
$fs = 0.4;

// Variables
body_base_h = 10;
body_top_h = 10;
wheel_h = 10;
wheel_r = 8;
axle_h = 40;
axle_r = 2;
body_roll = -5;
wheels_turn = 20;

// Car body
rotate([body_roll,1,1]) {
    // base
    cube([60,20,body_base_h], center=true);
    // top
    translate([5,0,body_base_h/2 + body_top_h/2 - 0.001])
        cube([30,20,body_top_h],center=true);
}

// Front wheels
translate([-20,-axle_h/2,0])
    rotate([90,0,wheels_turn])
    cylinder(h=wheel_h,r=wheel_r,center=true);
translate([-20,axle_h/2,0])
    rotate([90,0,wheels_turn])
    cylinder(h=wheel_h,r=wheel_r,center=true);

// Back wheels
translate([20,-axle_h/2,0])
    rotate([90,0,0])
    cylinder(h=wheel_h,r=wheel_r,center=true);
translate([20,axle_h/2,0])
    rotate([90,0,0])
    cylinder(h=wheel_h,r=wheel_r,center=true);

//Front and Back Axles
translate([-20,0,0])
    rotate([90,0,0])
    cylinder(h=axle_h,r=axle_r,center=true);
translate([20,0,0])
    rotate([90,0,0])
    cylinder(h=axle_h,r=axle_r,center=true);
