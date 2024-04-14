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
cn_angle = 30;
// Cone height
cn_height = 10;
// Top Sphere radius
s1_rad = 1.5;
// Elipse cutting plane angle
pe_angle = 20;//cn_angle;

// ---------------------------
// Calculated Values
// ---------------------------
// ---------------------------
// cone
// ---------------------------
cn_bot_a = 90 - cn_angle;
cn_hypot = cn_height/cos(cn_angle);
cn_radius = cn_hypot*sin(cn_angle);
echo("cn_height:", cn_height, "cn_radius:",cn_radius,"pe_angle",pe_angle);

// ---------------------------
// top sphere center
// ---------------------------
s1c_z = sphere_cone_tangent_h(s1_rad);
s1c_tz = cn_height - (s1c_z); //7.1;
echo("s1_rad:", s1_rad, "s1c_z:",s1c_z, "s1c_tz:",s1c_tz);

// ---------------------------
// cutting planes
// ---------------------------
//circle
pc_tz = s1c_tz;

//elipse
p2_z = s1c_z + getHypFromAdj(s1_rad, pe_angle);
p2_tz = cn_height - p2_z; //4.715;
echo("p2_z",p2_z,"p2_tz",p2_tz);
p2_s1_cone_tangents_half_a = (cn_angle + (90-pe_angle))/2;
p2_s1_cone_intercept_a1 = p2_s1_cone_tangents_half_a-cn_angle;
p2_s1_cone_intercept_a2 = pe_angle+p2_s1_cone_intercept_a1;
e_a1_len = s1_rad * tan(90 - p2_s1_cone_intercept_a1 - pe_angle);
e_a2_len = s1_rad * tan((90 - p2_s1_cone_intercept_a2) + pe_angle);
e_tot_len = e_a1_len + e_a2_len;
echo("a1",p2_s1_cone_intercept_a1,"a2", p2_s1_cone_intercept_a2);
echo("e_a1_len",e_a1_len, "e_a2_len", e_a2_len, "e_tot_len",e_tot_len);
e_f1_to_center_len = s1_rad*tan(pe_angle);
e_f2_len = e_a2_len - e_a1_len - e_f1_to_center_len;
e_f2_z = sin(pe_angle)*e_f2_len;
e_f2_y = cos(pe_angle)*e_f2_len;

p2_rad = cone_rad_at_h(p2_z);
echo("p2_rad",p2_rad);

// elipse plane intersection with center of cone
pe_cn_center_z = s1_rad/cos(pe_angle);
pe_cn_center_tz = s1c_tz - pe_cn_center_z;
//cut_plane(tz=pe_cn_center_tz);       //height


// Focal point 1 location
fp1_tan_rx = pe_angle - 90;
fp1_y = s1_rad*sin(pe_angle);
fp1_z = s1_rad*cos(pe_angle);
fp1_tz = s1c_tz - fp1_z;
//cut_plane(tz=fp1_tz);       //fp1 height
//cut_plane(ty=fp1_y, rx=90); //fp1 dist from center of cone
cut_plane(tz=s1c_tz, rx=fp1_tan_rx); //fp1 s1 tangent

// Focal point 2 location
fp2_z = e_f2_z;
fp2_tz = p2_tz - fp2_z;
//cut_plane(tz=fp2_tz);         //fp2 height
//cut_plane(ty=-e_f2_y, rx=90); //fp2 dist from center of cone

//parabola
e_center_to_left_cone_len = e_a2_len - e_f1_to_center_len;
p3_z = e_center_to_left_cone_len*sin(pe_angle);
p3_cn_hypot = p3_z/cos(cn_angle);
p3_cn_radius = p3_cn_hypot*sin(cn_angle);
echo("p3_z",p3_z,"p3_cn_radius",p3_cn_radius);

p3_rx = cn_angle-90; 
p3_tz = -1.83;
p3_ty = cn_radius - (p3_cn_radius*2);

// ---------------------------
// bottom sphere
// ---------------------------

// -------------------------------------------
// This section is close but not quite right
// -------------------------------------------
//dist from top of cone to where p2 intersects mid line of cone
temp_z1 = cn_height - p2_tz; //4.57514
////dist from where p2 intersects mid line of cone to edge of cone
//temp_x1 = temp_z1*tan(pe_angle); //2.64146
//dist from where p2 intersects mid line of cone to tan point on sphere
temp_h1 = e_f2_len;//temp_x1/cos(pe_angle); //3.05009
//dist from p2 to center of sphere
temp_h2 = max(p2_z, temp_h1/sin(pe_angle)); // 6.10018
s2_rad2 = temp_h2*cos(pe_angle);//5.28291 //cn_radius/1.0735; //5.3757
s2_tz2 = cn_height - (temp_h2+temp_z1); // -0.675317 //-.773;
echo("s2_rad2:", s2_rad2, "s2_tz2:",s2_tz2);


//s2_rad2 = 5.2;//cone_rad_at_h(p2_tz);
//s2_tz2 = p2_tz-e_f2_z - s2_rad2; // -0.675317 //-.773;
//echo("s2_rad2:", s2_rad2, "s2_tz2:",s2_tz2);


// ---------------------------
// Render
// ---------------------------
render_full();

// ---------------------------
// Functions
// sin(a)=y/h opposite/hypotenuse
// cos(a)=x/h adjacent/hypotenuse
// tan(a)=y/x opposite/adjacent
// ---------------------------
function getAdjFromOpp(opp, a) = opp/tan(a);
function getAdjFromHyp(hyp, a) = hyp*cos(a);
function getOppFromAdj(adj, a) = adj*tan(a);
function getOppFromHyp(hyp, a) = hyp*sin(a);
function getHypFromAdj(adj, a) = adj/cos(a);
function getHypFromOpp(opp, a) = opp/sin(a);
function cone_rad_at_h(h=1) = getOppFromAdj(h,cn_angle);
function sphere_cone_tangent_h(r=1) = getHypFromOpp(r,cn_angle);

// ---------------------------
// Modules
// ---------------------------
module sphere_with_axis(r, angle, tz=0, axis_r=.02) {
    translate([0,0,tz])
    rotate([angle,0,0]) {
        difference() {
            sphere(r);
            #cylinder(h=r*4,r=axis_r,center=true);
        }
    }
}

module cut_plane(ty=0,tz=0,rx=0) {
    translate([0,ty,tz])
    rotate([rx,0,0])
    #cube([20,20,.01], true);
}

module render_full() {
    // Cone
    %cylinder(cn_height, cn_radius, 0, false);

    // Top sphere
    sphere_with_axis(s1_rad, pe_angle,s1c_tz);

    // Circle cutting plane
    cut_plane(tz=pc_tz);

    // Elipse cutting plane
    cut_plane(tz=p2_tz,rx=pe_angle);    

    // Temp

    // Right hand side cone intercept
    cut_plane(tz=s1c_tz,rx=-p2_s1_cone_intercept_a1);

    // Left hand side cone intercept
    cut_plane(tz=s1c_tz,rx=p2_s1_cone_intercept_a2);

    ////Bottom sphere
    sphere_with_axis(s2_rad2, pe_angle,s2_tz2);
    cut_plane(tz=s2_tz2);

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
