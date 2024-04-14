// Smooth rendering
$fa = 1;
$fs = 0.4;

// Car body
cube([60,20,10], center=true);
translate([0,0,10 - 0.001])
    cube([30,20,10],center=true);

// Front wheels
translate([-20,-15,0])
    rotate([90,0,0])
    cylinder(h=3,r=8,center=true);
translate([-20,15,0])
    rotate([90,0,0])
    cylinder(h=3,r=8,center=true);

// Back wheels
translate([20,-15,0])
    rotate([90,0,0])
    cylinder(h=3,r=8,center=true);
translate([20,15,0])
    rotate([90,0,0])
    cylinder(h=3,r=8,center=true);

//Front and Back Axels
translate([-20,0,0])
    rotate([90,0,0])
    cylinder(h=30,r=2,center=true);
translate([20,0,0])
    rotate([90,0,0])
    cylinder(h=30,r=2,center=true);
