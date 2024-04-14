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
// Law of sines
// ---------------------------
//       ^
//      /C\
//     /   \
//  b /     \ a
//   /       \
//  /A       B\
//  -----------
//       c
//
//   a         b       c
// ------ = ------ = ------ 
// sin(A)   sin(B)   sin(C)  
// ---------------------------

// ---------------------------
// Input Variables
// ---------------------------
cn_multiplier = 8;
// Cone top half angle
cn_angle = 22.5;
// Cone height
cn_height = 10 * cn_multiplier;
// Outter cone thickness
cn_outter_thick = 1;
// Top Sphere radius
s1_rad = 1.25 * cn_multiplier;
// Elipse cutting plane angle
pe_angle = 30;//25;//cn_angle;
// Standard axis radius
std_axis_r=.75;

// ---------------------------
// Calculated Values
// ---------------------------
// ---------------------------
// cone
// ---------------------------
cn_bot_a = 90 - cn_angle;
//cn_hypot = cn_height/cos(cn_angle);
//cn_radius = cn_hypot*sin(cn_angle);
cn_radius = cone_rad_at_h(cn_height);
cn_outter_radius = cn_radius + cn_outter_thick;
cn_outter_height = getAdjFromOpp(cn_outter_radius, cn_angle);
echo("cn_height:", cn_height, "cn_radius:",cn_radius,"pe_angle",pe_angle);

// ---------------------------
// top sphere center
// ---------------------------
s1c_z = sphere_cone_tangent_h(s1_rad);
s1c_tz = cn_height - s1c_z;
echo("s1_rad:", s1_rad, "s1c_z:",s1c_z, "s1c_tz:",s1c_tz);

// ---------------------------
// slicing planes
// ---------------------------
//circle slicing plane
pc_tz = s1c_tz;

//elipse slicing plane
p2_z = s1c_z + getHypFromAdj(s1_rad, pe_angle);
p2_tz = cn_height - p2_z;

// elipse plane intersection with center of cone
pe_cn_center_z = getHypFromAdj(s1_rad,pe_angle);
pe_cn_center_tz = s1c_tz - pe_cn_center_z;
//slicing_plane(tz=pe_cn_center_tz);       //height

// Right Hand Side (RHS)
// angle between elipse plane and cone tangents to sphere 1
rhs_pe_cn_tan_a = 90 + cn_angle - pe_angle;
rhs_pe_len = getOppFromAdj(s1_rad, rhs_pe_cn_tan_a/2);

// Left Hand Side (LHS)
// angle between elipse plane and cone tangents to sphere 1
lhs_pe_cn_tan_a = 90 + cn_angle + pe_angle;
lhs_pe_len = getOppFromAdj(s1_rad, lhs_pe_cn_tan_a/2);

// Total length of elipse
pe_len = rhs_pe_len + lhs_pe_len;
echo("a1",rhs_pe_cn_tan_a,"a2", lhs_pe_cn_tan_a);

// Length from top of cone to tangent with sphere 1
s1t_len = getAdjFromOpp(s1_rad, cn_angle);
// Length from top of cone to tangent with sphere 2
s2t_len = s1t_len + pe_len;

// elipse plane cone intercept angles
rhs_pe_cni_a = (rhs_pe_cn_tan_a/2) - cn_angle;
rhs_pe_cni_hyp = getHypFromAdj(s1_rad, rhs_pe_cn_tan_a/2);
rhs_pe_cni_z = s1c_z + getOppFromHyp(rhs_pe_cni_hyp, rhs_pe_cni_a);
rhs_pe_cni_y = cone_rad_at_h(rhs_pe_cni_z);
rhs_pe_cni_tz = cn_height - rhs_pe_cni_z;

lhs_pe_cni_a = pe_angle + rhs_pe_cni_a;
lhs_pe_cni_hyp = getHypFromAdj(s1_rad, lhs_pe_cn_tan_a/2);
lhs_pe_cni_z = s1c_z + getOppFromHyp(lhs_pe_cni_hyp, lhs_pe_cni_a);
lhs_pe_cni_y = cone_rad_at_h(lhs_pe_cni_z);
lhs_pe_cni_tz = cn_height - lhs_pe_cni_z;
echo("cni_a1",rhs_pe_cni_a,"cni_a2",lhs_pe_cni_a);

// Parabola slicing plane
pp_ty = -lhs_pe_cni_y;
pp_tz = lhs_pe_cni_tz;
pp_angle = -cn_bot_a;
pp_fp_shpere_r = getOppFromHyp(lhs_pe_cni_z, cn_angle);
//slicing_plane(ty=pp_ty, tz=pp_tz, rx=pp_angle);

// Parabola slicing plane outter cone
pp_out_aa = cn_bot_a - pe_angle;
pp_out_a = cn_outter_thick;
pp_out_ca = 180 - cn_bot_a;
pp_out_c = pp_out_a * (sin(pp_out_ca)/sin(pp_out_aa)); //law of sines
pp_out_y = pp_out_c * cos(pe_angle);
pp_out_z = pp_out_c * sin(pe_angle);
pp_out_ty = pp_ty - pp_out_y;
pp_out_tz = pp_tz - pp_out_z;

// Hyperbola slicing plane inner cone
ph_ty = rhs_pe_cni_y;
ph_z = sphere_cone_tangent_h(ph_ty);
ph_tz = cn_height - ph_z;
ph_angle = 90;

// Hyperbola slicing plane outter cone
ph_out_ca = 180 - pe_angle - cn_bot_a;
ph_out_c = cn_outter_thick;
ph_out_ba = cn_bot_a;
ph_out_b = ph_out_c * (sin(ph_out_ba)/sin(ph_out_ca)); //law of sines
ph_out_y = ph_out_b * cos(pe_angle);
ph_out_ty = ph_ty + ph_out_y;

// ---------------------------
// bottom sphere
// ---------------------------
s2_rad = getOppFromAdj(s2t_len, cn_angle);
s2c_z = getHypFromAdj(s2t_len, cn_angle);
s2c_tz = cn_height - s2c_z;
echo("s2_rad:", s2_rad, "s2c_tz:",s2c_tz);

// ---------------------------
// Cone Base
// ---------------------------
cn_base_tz = s2_rad - s2c_tz;
cn_base_height = cn_outter_height + cn_base_tz;
cn_base_radius = cone_rad_at_h(cn_base_height);
echo("cn_base_height:", cn_base_height, "cn_base_radius:",cn_base_radius);


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
// Render
// ---------------------------
//"FULL" or "PRINT"
MODE = "PRINT"; 
//"TOP_CONE"
//"ELIPSE_1","ELIPSE_2"
//"PARABOLA","HYPERBOLA","BASE"
//"S1_TOP","S1_BOT",
//"S2_ELIPSE_2","S2_PARABOLA","S2_HYPERBOLA","S2_BASE"
PRINT_SECTION = "FULL";
if (MODE == "FULL") {
    render_full();
} else {
    if (PRINT_SECTION == "TOP_CONE") {
        print_top_cone();
    }
    if (PRINT_SECTION == "ELIPSE_1") {
        print_elipse_1();
    }
    if (PRINT_SECTION == "ELIPSE_2") {
        print_elipse_2();
    }
    if (PRINT_SECTION == "PARABOLA") {
        print_parabola();
    }
    if (PRINT_SECTION == "HYPERBOLA") {
        print_hyperbola();
    }
    if (PRINT_SECTION == "BASE") {
        print_base();
    }
    if (PRINT_SECTION == "S1_TOP") {
        print_s1_top();
    }
    if (PRINT_SECTION == "S1_BOT") {
        print_s1_bot();
    }
    if (PRINT_SECTION == "S2_ELIPSE_2") {
        print_s2_elipse_2();
    }
    if (PRINT_SECTION == "S2_PARABOLA") {
        print_s2_parabola();
    }
    if (PRINT_SECTION == "S2_HYPERBOLA") {
        print_s2_hyperbola();
    }
    if (PRINT_SECTION == "S2_BASE") {
        print_s2_base();
    }
    if (PRINT_SECTION == "FULL") {
//        print_top_cone();
//        //render_s1_for_print();
//        print_elipse_1();
        print_elipse_2();
//        print_parabola();
//        print_hyperbola();
//        print_base();
        render_s2_for_print();
    }
}

// ---------------------------
// Modules
// ---------------------------
module render_cone(h,r) {
    cylinder(h, r, 0, false);
}

module render_cone_base() {
    translate([0,0,-cn_base_tz])
    render_cone(cn_base_height, cn_base_radius);
}

module sphere_with_axis(r, angle, tz=0, axis_r=std_axis_r, axis_h_factor=2.9) {
    translate([0,0,tz])
    rotate([angle,0,0]) {
        difference() {
            sphere(r);
            #cylinder(h=r*axis_h_factor,r=axis_r,center=true);
        }
    }
}

module axis_without_sphere(r, angle, tz=0, axis_r=std_axis_r, axis_h_factor=2.5) {
    translate([0,0,tz])
    rotate([angle,0,0]) {
        #cylinder(h=r*axis_h_factor,r=axis_r,center=true);
    }
}

module slicing_plane(ty=0,tz=0,rx=0) {
    translate([0,ty,tz])
    rotate([rx,0,0])
    cube([cn_outter_radius*2.1,cn_outter_height*4,.02], true);
}


module chopping_plane(ty=0,tz=0,rx=0,up_down=-1) {
    z_offset = (cn_outter_height/2)*up_down;
    translate([0,ty,tz])
    rotate([rx,0,0])
    translate([0,0,z_offset])
    cube([cn_outter_radius*2.1, cn_outter_height*3, cn_outter_height], true);
}


module render_full() {
    // Inner Cone
    %render_cone(cn_height, cn_radius);
    // Outter Cone
    %render_cone(cn_outter_height, cn_outter_radius);
    // Cone base
    %render_cone_base();

    // Top sphere
    sphere_with_axis(s1_rad, pe_angle, s1c_tz);

    // Circle slicing plane
    slicing_plane(tz=pc_tz);

    // Elipse slicing plane
    slicing_plane(tz=p2_tz,rx=pe_angle);    

    // Cone intercepts
    // Right hand side cone intercept
    //slicing_plane(tz=s1c_tz,rx=-rhs_pe_cni_a);
    // Left hand side cone intercept
    //slicing_plane(tz=s1c_tz,rx=lhs_pe_cni_a);

    // Bottom sphere
    sphere_with_axis(s2_rad, pe_angle, s2c_tz);
    //slicing_plane(tz=s2c_tz);
    
    // Parabola slicing planes
    // Inner cone
    //slicing_plane(ty=pp_ty, tz=pp_tz, rx=pp_angle);
    //sphere_with_axis(pp_fp_shpere_r, pp_angle, pp_tz);
    axis_without_sphere(pp_fp_shpere_r, pp_angle, pp_tz);
    // Outter cone
    slicing_plane(ty=pp_out_ty, tz=pp_out_tz, rx=pp_angle);

    // Hyperbola slicing planes
    // Inner cone
    //slicing_plane(ty=ph_ty, rx=ph_angle);
    //sphere_with_axis(ph_ty, ph_angle, ph_tz);
    axis_without_sphere(ph_ty, ph_angle, ph_tz);
    // Outter cone
    slicing_plane(ty=ph_out_ty, rx=ph_angle);
}

module print_top_cone() {
    difference() {
        // Outter Cone
        render_cone(cn_outter_height, cn_outter_radius);
        // Top sphere
        sphere_with_axis(s1_rad, pe_angle,s1c_tz);
        chopping_plane(tz=pc_tz);
    }
}

module print_elipse_1() {
    difference() {
        // Outter Cone
        render_cone(cn_outter_height, cn_outter_radius);
        // Top sphere
        sphere_with_axis(s1_rad, pe_angle,s1c_tz);
        // Bottom sphere
        sphere_with_axis(s2_rad, pe_angle, s2c_tz);
        // Circle slicing plane
        chopping_plane(tz=pc_tz,up_down=1);
        // Elipse slicing plane
        chopping_plane(tz=p2_tz,rx=pe_angle); 
    }
}

module print_elipse_2() {
    //rotate([-90,0,0])
    difference() {
        // Outter Cone
        render_cone(cn_outter_height, cn_outter_radius);
        // Top sphere
        sphere_with_axis(s1_rad, pe_angle,s1c_tz);
        // Bottom sphere
        sphere_with_axis(s2_rad, pe_angle, s2c_tz);
        // Elipse slicing plane
        chopping_plane(tz=p2_tz,rx=pe_angle,up_down=1);
        // Parabola slicing plane (Outter Cone)
        //axis_without_sphere(pp_fp_shpere_r, pp_angle, pp_tz);
        chopping_plane(ty=pp_out_ty, tz=pp_out_tz, rx=pp_angle);
        // Hyperbola slicing plane (Outter Cone)
        translate([0,ph_ty*2,0])
        axis_without_sphere(ph_ty, ph_angle, ph_tz);
        chopping_plane(ty=ph_out_ty, rx=ph_angle);
    }
}

module print_parabola() {
    //rotate([-90,0,0])
    difference() {
        // Outter Cone
        render_cone(cn_outter_height, cn_outter_radius);
        // Bottom sphere
        render_s2_for_print(s2_eps=0);
        //sphere_with_axis(s2_rad, pe_angle, s2c_tz);
        // Elipse slicing plane
        chopping_plane(tz=p2_tz,rx=pe_angle,up_down=1);
        // Parabola slicing plane (Outter Cone)
        axis_without_sphere(pp_fp_shpere_r, pp_angle, pp_tz);
        chopping_plane(ty=pp_out_ty, tz=pp_out_tz, rx=pp_angle,up_down=1);
    }
}

module print_hyperbola() {
    //rotate([-90,0,0])
    difference() {
        // Outter Cone
        render_cone(cn_outter_height, cn_outter_radius);
        // Bottom sphere
        render_s2_for_print(s2_eps=0);
        //sphere_with_axis(s2_rad, pe_angle, s2c_tz);
        // Elipse slicing plane
        chopping_plane(tz=p2_tz,rx=pe_angle,up_down=1);
        // Hyperbola slicing plane (Outter Cone)
        axis_without_sphere(ph_ty, ph_angle, ph_tz);
        chopping_plane(ty=ph_out_ty, rx=ph_angle,up_down=1);
    }
}

module print_base() {
    difference() {
        // Base Cone
        render_cone_base();
        // Bottom sphere
        sphere_with_axis(s2_rad, pe_angle, s2c_tz);
        // Upper cone slicing plane
        chopping_plane(tz=0,rx=0,up_down=1);
    }
}

module print_s1_top() {
    difference() {
        // Top sphere
        render_s1_for_print();
        chopping_plane(tz=pc_tz);
    }
}

module print_s1_bot() {
    difference() {
        // Top sphere
        render_s1_for_print();
        // Circle slicing plane
        chopping_plane(tz=pc_tz,up_down=1);
    }
}

module print_s2_elipse_2() {
    //rotate([-90,0,0])
    difference() {
        // Bottom sphere
        render_s2_for_print();
        // Elipse slicing plane
        chopping_plane(tz=p2_tz,rx=pe_angle,up_down=1);
        // Parabola slicing plane (Outter Cone)
        axis_without_sphere(pp_fp_shpere_r, pp_angle, pp_tz);
        chopping_plane(ty=pp_out_ty, tz=pp_out_tz, rx=pp_angle);
        // Hyperbola slicing plane (Outter Cone)
        chopping_plane(ty=ph_out_ty, rx=ph_angle);
    }
}

module print_s2_parabola() {
    //rotate([-90,0,0])
    difference() {
        // Bottom sphere
        render_s2_for_print();
        // Elipse slicing plane
        chopping_plane(tz=p2_tz,rx=pe_angle,up_down=1);
        // Parabola slicing plane (Outter Cone)
        axis_without_sphere(pp_fp_shpere_r, pp_angle, pp_tz,axis_h_factor=4);
        chopping_plane(ty=pp_out_ty, tz=pp_out_tz, rx=pp_angle,up_down=1);
    }
}

module print_s2_hyperbola() {
    //rotate([-90,0,0])
    difference() {
        // Bottom sphere
        render_s2_for_print();
        // Hyperbola slicing plane (Outter Cone)
        chopping_plane(ty=ph_out_ty, rx=ph_angle,up_down=1);
    }
}

module print_s2_base() {
    difference() {
        // Bottom sphere
        sphere_with_axis(s2_rad, pe_angle, s2c_tz);
        // Upper cone slicing plane
        chopping_plane(tz=0,rx=0,up_down=1);
    }
}

module render_s1_for_print(s1_eps=eps) {
    // Top sphere
    sphere_with_axis(s1_rad - s1_eps, pe_angle, s1c_tz);
}

module render_s2_for_print(s2_eps=eps) {
    difference() {
        // Bottom sphere
        sphere_with_axis(s2_rad - s2_eps, pe_angle, s2c_tz);
        // Center axis
        translate([0,0,s2c_tz])
        rotate([90,0,0])
        #cylinder(h=s2_rad*4,r=std_axis_r,center=true);        
    }
}

    
