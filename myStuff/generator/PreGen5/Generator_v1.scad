// Smooth rendering
$fa = 1;
$fs = 0.4;

// Rotating Disk with magnets
translate([0,0,0])
    rotate([90,0,0])
    cylinder(h=4,r=20,center=true);
    
// Stationary Disk with coils 1
translate([0,5,0])
    rotate([90,0,0])
    cylinder(h=4,r=20,center=true);
translate([0,5,-10])
    cube([35,4,25],center=true);

// Stationary Disk with coils 2
translate([0,-5,0])
    rotate([90,0,0])
    cylinder(h=4,r=20,center=true);
translate([0,-5,-10])
    cube([35,4,25],center=true);
    
// Rotating Disk with metal 1
translate([0,10,0])
    rotate([90,0,0])
    cylinder(h=4,r=20,center=true);
    
// Rotating Disk with metal 2
translate([0,-10,0])
    rotate([90,0,0])
    cylinder(h=4,r=20,center=true);
    
// Axel
translate([0,0,0])
    rotate([90,0,0])
    cylinder(h=40,r=2,center=true);