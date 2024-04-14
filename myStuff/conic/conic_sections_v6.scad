include <smooth_prim/smooth_prim.scad>

// ---------------------------
// Constants
// ---------------------------
$fa = 1;
$fs = 0.4;
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
// Input Variables
// ---------------------------
// Cone top half angle
c_angle = 30;
// Cone height
c_height = 10;
// Top Sphere radius
s1_rad = 1.5;
// Elipse cutting plane angle
p2_angle = 20;//c_angle;

// ---------------------------
// Calculated Values
// ---------------------------
// ---------------------------
// cone
// ---------------------------
c_bot_a = 90 - c_angle;
c_hypot = c_height/cos(c_angle);
c_radius = c_hypot*sin(c_angle);
function cone_rad_at_h(h=1) = tan(c_angle)*h;
echo("c_height:", c_height, "c_radius:",c_radius);

// ---------------------------
// top sphere
// ---------------------------
s1_z = s1_rad/sin(c_angle);
s1_tz = c_height - (s1_z); //7.1;
echo("s1_rad:", s1_rad, "s1_z:",s1_z, "s1_tz:",s1_tz);

// ---------------------------
// cutting planes
// ---------------------------
//circle
p1_tz = s1_tz;

//elipse
p2_z = s1_z + (s1_rad/cos(p2_angle));
p2_tz = c_height - p2_z; //4.715;
echo("p2_z",p2_z,"p2_tz",p2_tz);
p2_s1_cone_tangents_half_a = (c_angle + (90-p2_angle))/2;
p2_s1_cone_intercept_a1 = p2_s1_cone_tangents_half_a-c_angle;
p2_s1_cone_intercept_a2 = p2_angle+p2_s1_cone_intercept_a1;
e_a1_len = s1_rad * tan(90 - p2_s1_cone_intercept_a1 - p2_angle);
e_a2_len = s1_rad * tan((90 - p2_s1_cone_intercept_a2) + p2_angle);
e_tot_len = e_a1_len + e_a2_len;
echo("a1",p2_s1_cone_intercept_a1,"a2", p2_s1_cone_intercept_a2);
echo("e_a1_len",e_a1_len, "e_a2_len", e_a2_len, "e_tot_len",e_tot_len);
e_f1_to_center_len = s1_rad*tan(p2_angle);
e_f2_len = e_a2_len - e_a1_len - e_f1_to_center_len;
e_f2_z = sin(p2_angle)*e_f2_len;
e_f2_y = cos(p2_angle)*e_f2_len;

p2_rad = cone_rad_at_h(p2_z);
echo("p2_rad",p2_rad);

translate([0,-e_f2_y,0])
rotate([90,0,0])
#cube([20,20,.01], true);

//translate([0,0,p2_tz-e_f2_z])
//rotate([0,0,0])
//#cube([20,20,.01], true);


//parabola
e_center_to_left_cone_len = e_a2_len - e_f1_to_center_len;
p3_z = e_center_to_left_cone_len*sin(p2_angle);
p3_c_hypot = p3_z/cos(c_angle);
p3_c_radius = p3_c_hypot*sin(c_angle);
echo("p3_z",p3_z,"p3_c_radius",p3_c_radius);

p3_rx = c_angle-90; 
p3_tz = -1.83;
p3_ty = c_radius - (p3_c_radius*2);

// ---------------------------
// bottom sphere
// ---------------------------

// -------------------------------------------
// This section is close but not quite right
// -------------------------------------------
//dist from top of cone to where p2 intersects mid line of cone
temp_z1 = c_height - p2_tz; //4.57514
////dist from where p2 intersects mid line of cone to edge of cone
//temp_x1 = temp_z1*tan(p2_angle); //2.64146
//dist from where p2 intersects mid line of cone to tan point on sphere
temp_h1 = e_f2_len;//temp_x1/cos(p2_angle); //3.05009
//dist from p2 to center of sphere
temp_h2 = max(p2_z, temp_h1/sin(p2_angle)); // 6.10018
s2_rad2 = temp_h2*cos(p2_angle);//5.28291 //c_radius/1.0735; //5.3757
s2_tz2 = c_height - (temp_h2+temp_z1); // -0.675317 //-.773;
echo("s2_rad2:", s2_rad2, "s2_tz2:",s2_tz2);


//s2_rad2 = 5.2;//cone_rad_at_h(p2_tz);
//s2_tz2 = p2_tz-e_f2_z - s2_rad2; // -0.675317 //-.773;
//echo("s2_rad2:", s2_rad2, "s2_tz2:",s2_tz2);


// ---------------------------
// Render
// ---------------------------
render_full();


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

module render_full() {
    // Cone
    %cylinder(c_height, c_radius, 0, false);

    // Top sphere
    translate([0,0,s1_tz])
    sphere_with_axis(s1_rad, p2_angle);

    // Circle cutting plane
    translate([0,0,p1_tz])
    #cube([20,20,.01], true);

    // Elipse cutting plane
    translate([0,0,p2_tz])
    rotate([p2_angle,0,0])
    #cube([20,20,.01], true);

    // Temp
    translate([0,0,p2_tz])
    rotate([0,0,0])
    #cube([20,20,.01], true);

    // Right hand side cone intercept
    translate([0,0,s1_tz])
    rotate([-p2_s1_cone_intercept_a1,0,0])
    #cube([20,20,.01], true);

    // Left hand side cone intercept
    translate([0,0,s1_tz])
    rotate([p2_s1_cone_intercept_a2,0,0])
    #cube([20,20,.01], true);

    ////Bottom sphere
    translate([0,0,s2_tz2])
    sphere_with_axis(s2_rad2, p2_angle);

//    // Parabola cutting plane
//    translate([0,-p3_ty,0])
//    rotate([p3_rx,0,0])
//    //rotate([90,0,0])
//    #cube([20,20,.01], true);
//
//    // Hyperbola cutting plane
//    translate([0,2.87,0])
//    rotate([90,0,0])
//    #cube([20,20,.01], true);    
}
