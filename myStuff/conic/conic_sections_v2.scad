include <smooth_prim/smooth_prim.scad>

// ---------------------------
// Constants
// ---------------------------
$fa = 1;
$fs = 0.4;
//$fn = $preview ? 32 : 64;
$fn = 64;
in_to_mm = 25.4;
eps = .15;
kerf = 0.4;
smooth_r = 1.5;


// ---------------------------
// Variables
// ---------------------------

//cone
c_height = 10;
c_radius = sqrt((c_height*c_height)/3); //isocolese

//spheres
s1_rad = c_radius/3.981;
s1_tz = 7.1;
s2_rad = c_radius/1.074;
s2_tz = -.75;

//cutting planes
//circle
p1_rx = 0; 
p1_tz = s1_tz;
//elipse
p2_rx = 30; 
p2_tz = 4.715;
//parabola
p3_rx = -60; 
p3_tz = -1.83;

echo("s1_rad:", s1_rad, "s2_rad:",s2_rad);

temp_angle = 30;
temp_s1_r = 1.45026;
temp_s1_z = c_height - (temp_s1_r/sin(temp_angle));
temp_p2_z = temp_s1_z - (temp_s1_r/cos(temp_angle));
echo("temp_s1_r:", temp_s1_r, "temp_s1_z:",temp_s1_z, "temp_p2_z", temp_p2_z);

// ---------------------------
// Render
// ---------------------------
//sphere_with_axis(5, 30, .01);

// Cone
%cylinder(c_height, c_radius, 0, false);

//Top sphere
rotate([p1_rx,0,0])
translate([0,0,s1_tz])
//#sphere(s1_rad);
sphere_with_axis(s1_rad, p2_rx);

// Circle cutting plane
translate([0,0,p1_tz])
#cube([20,20,.01], true);

// Elipse cutting plane
rotate([p2_rx,0,0])
translate([0,0,p2_tz])
#cube([20,20,.01], true);

//Bottom sphere
translate([0,0,s2_tz])
sphere_with_axis(s2_rad, p2_rx);

// Parabola cutting plane
rotate([p3_rx,0,0])
translate([0,0,p3_tz])
#cube([20,20,.01], true);

// Hyperbola
rotate([90,0,0])
translate([0,0,-2.87])
#cube([20,20,.01], true);


// ---------------------------
// Modules
// ---------------------------
module sphere_with_axis(r, angle, axis_r=.02) {
    rotate([p2_rx,0,0]) {
        difference() {
            %sphere(r);
            #cylinder(h=r*4, r=axis_r, center=true);
        }
    }
}
