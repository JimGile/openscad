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

//sin(a)=y/h opposite/hypotenuse
//cos(a)=x/h adjacent/hypotenuse
//tan(a)=y/x opposite/adjacent

// ---------------------------
// Variables
// ---------------------------

//cone
c_angle = 30;
c_height = 10;
c_hypot = c_height/cos(c_angle);
c_radius = c_hypot/2;
echo("c_height:", c_height, "c_radius:",c_radius);

//spheres
s1_rad = 1.45026; //c_radius/3.981;
s1_tz = c_height - (s1_rad/sin(c_angle)); //7.1;
echo("s1_rad:", s1_rad, "s1_tz:",s1_tz);

s2_rad = c_radius/1.07;//5.3958 //c_radius/1.0735; //5.3757
s2_tz = -.8;//-.773;
echo("s2_rad:", s2_rad, "s2_tz:",s2_tz);


//cutting planes
//circle
p1_tz = s1_tz;
//elipse
p2_angle = c_angle;  //NOTE: the bigger this angle the worse it gets
p2_tz = s1_tz - (s1_rad/cos(p2_angle)); //4.715;
echo("p2_angle:", p2_angle, "p2_tz:",p2_tz);
//parabola
p3_rx = c_angle-90; 
p3_tz = -1.83;

// -------------------------------------------
// This section is close but not quite right
// -------------------------------------------
//dist from top of cone to where p2 intersects mid line of cone
temp_z1 = c_height - p2_tz; //4.57514
//dist from where p2 intersects mid line of cone to edge of cone
temp_x1 = temp_z1*tan(p2_angle); //2.64146
//dist from where p2 intersects mid line of cone to tan point on sphere
temp_h1 = temp_x1/cos(p2_angle); //3.05009
//dist from p2 to center of sphere
temp_h2 = temp_h1/sin(p2_angle); // 6.10018
s2_rad2 = temp_h2*cos(p2_angle);//5.28291 //c_radius/1.0735; //5.3757
s2_tz2 = c_height - (temp_h2+temp_z1); // -0.675317 //-.773;
echo("s2_rad2:", s2_rad2, "s2_tz2:",s2_tz2);


temp_angle = 30;
temp_s1_r = 1.45026;
temp_s1_z = c_height - (temp_s1_r/sin(temp_angle));
temp_p2_z = temp_s1_z - (temp_s1_r/cos(temp_angle));
echo("temp_s1_r:", temp_s1_r, "temp_s1_z:",temp_s1_z, "temp_p2_z", temp_p2_z);

// ---------------------------
// Render
// ---------------------------
// Cone
%cylinder(c_height, c_radius, 0, false);

//Top sphere
translate([0,0,s1_tz])
sphere_with_axis(s1_rad, p2_angle);

//// Circle cutting plane
//translate([0,0,p1_tz])
//#cube([20,20,.01], true);

// Elipse cutting plane
translate([0,0,p2_tz])
rotate([p2_angle,0,0])
#cube([20,20,.01], true);

// Temp
translate([0,0,s2_tz])
rotate([-c_angle,0,0])
#cube([20,20,.01], true);

translate([0,0,p2_tz])
rotate([0,0,0])
#cube([20,20,.01], true);


translate([0,-temp_x1,0])
rotate([90,0,0])
#cube([20,20,.01], true);



//Bottom sphere
translate([0,0,s2_tz2])
sphere_with_axis(s2_rad2, p2_angle);

//// Parabola cutting plane
//rotate([p3_rx,0,0])
//translate([0,0,p3_tz])
//#cube([20,20,.01], true);
//
//// Hyperbola
//rotate([90,0,0])
//translate([0,0,-2.87])
//#cube([20,20,.01], true);


// ---------------------------
// Modules
// ---------------------------
module sphere_with_axis(r, angle, axis_r=.02) {
    rotate([angle,0,0]) {
        difference() {
            sphere(r);
            #cylinder(h=r*4, r=axis_r, center=true);
        }
    }
}
