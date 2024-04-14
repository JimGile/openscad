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
//opp=adj*tan(a)
//adj=opp/tan(a)

// ---------------------------
// Variables
// ---------------------------

//cone
c_angle = 30;
c_bot_a = 90 - c_angle;
c_height = 10;
c_hypot = c_height/cos(c_angle);
c_radius = c_hypot*sin(c_angle);
function cone_rad_at_h(h=1) = tan(c_angle)*h;
echo("c_height:", c_height, "c_radius:",c_radius);
echo(sin(c_angle), cos(c_angle));

//spheres
s1_rad = 1.5;//1.45026; //c_radius/3.981;
s1_z = s1_rad/sin(c_angle);
s1_tz = c_height - (s1_rad/sin(c_angle)); //7.1;
echo("s1_rad:", s1_rad, "s1_z:",s1_z, "s1_tz:",s1_tz);

//s2_rad = c_radius/1.07;//5.3958 //c_radius/1.0735; //5.3757
//s2_tz = -.8;//-.773;
//echo("s2_rad:", s2_rad, "s2_tz:",s2_tz);


//cutting planes
//circle
p1_tz = s1_tz;
//elipse
p2_angle = 20;//c_angle;
p2_tz = s1_tz - (s1_rad/cos(p2_angle)); //4.715;
p2r = cone_rad_at_h(c_height - p2_tz);
p2r_y = p2r * tan(p2_angle);
p2r_x = p2r_y * tan(c_angle);
p2r_h = (p2r-p2r_x) * tan(p2_angle);
echo("p2_angle:", p2_angle, "p2_tz:",p2_tz, "p2r",p2r);
echo("p2r_y:", p2r_y, "p2r_x:",p2r_x, "p2r_h",p2r_h);

s1_complex_a = (c_angle + (90-p2_angle))/2;
echo("s1_complex_a:", s1_complex_a);

translate([0,0,s1_tz])
rotate([-(s1_complex_a-c_angle),0,0])
#cube([20,20,.01], true);

//translate([0,p2r-p2r_x,0])
//rotate([90,0,0])
//#cube([20,20,.01], true);
//
//translate([0,0,p2_tz+p2r_y])
//rotate([0,0,0])
//#cube([20,20,.01], true);
//
//translate([0,0,p2_tz+p2r_h])
//rotate([0,0,0])
//#cube([20,20,.01], true);



p2c_tz = s1_tz - (s1_rad/cos(90-p2_angle));
//parabola
p3_rx = c_angle-90; 
p3_tz = -1.83;



// -------------------------------------------
// This section is close but not quite right
// -------------------------------------------
//dist from top of cone to where p2 intersects mid line of cone
temp_z1 = c_height - p2_tz; //4.57514
//dist from top of cone to where p2 intersects mid line of cone
temp_z2 = c_height - s1_tz; //2.90052
//dist from center of s1 to where p2 intersects mid line of cone
temp_z3 = s1_tz - p2_tz; //1.54333
echo("temp_z1:", temp_z1, "temp_z2:",temp_z2, "temp_z3",temp_z3);
//angle that center of s1 makes with right side of cone and p2
temp_a0 =(180 - c_angle + (p2_angle*sin(c_angle)));
//temp_a0 =(180 - c_angle + c_bot_a);
echo("temp_a0:", temp_a0);
//angle that p2 makes with left hand edge of cone
temp_a1 = 90 - c_angle - p2_angle; //p2_a=20 => temp_a1=40
//angle that p2 makes with line from intersection of left hand edge of cone with line to center of s1
temp_a2 = temp_a1/2;
//dist from p2-s1 tangent point to left hand edge of cone
temp_x1 = s1_rad/tan(temp_a2); //2.64146
echo("temp_x1:", temp_x1, "temp_a1", temp_a1);
//dist from where p2 intersects mid line of cone to tan point on sphere
temp_h1 = temp_x1/cos(p2_angle); //3.05009
//dist from p2 to center of sphere
temp_h2 = temp_h1/sin(p2_angle); // 6.10018
//s2_rad2 = temp_h2*cos(p2_angle);//5.28291 //c_radius/1.0735; //5.3757
//s2_tz2 = c_height - (temp_h2+temp_z1); // -0.675317 //-.773;

s2_rad2 = temp_z1;
s2_tz2 = p2_tz-s2_rad2; // -0.675317 //-.773;
echo("s2_rad2:", s2_rad2, "s2_tz2:",s2_tz2);


temp_angle = 30;
temp_s1_r = 1.45026;
temp_s1_z = c_height - (temp_s1_r/sin(temp_angle));
temp_p2_z = temp_s1_z - (temp_s1_r/cos(temp_angle));
echo("temp_s1_r:", temp_s1_r, "temp_s1_z:",temp_s1_z, "temp_p2_z", temp_p2_z);


echo(p2_angle,sin(p2_angle), cos(p2_angle));
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
translate([0,0,s1_tz])
rotate([c_angle,0,0])
#cube([20,20,.01], true);


translate([0,0,p2_tz])
rotate([0,0,0])
#cube([20,20,.01], true);


////Bottom sphere
//translate([0,0,s2_tz2])
//sphere_with_axis(s2_rad2, p2_angle);

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
            %sphere(r);
            #cylinder(h=r*4, r=axis_r, center=true);
        }
    }
}
