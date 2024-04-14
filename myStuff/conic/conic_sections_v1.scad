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
thick = 1.5;
bot_ir = 26;
bot_ih = 20;
bot_or = bot_ir+thick;
bot_oh = bot_ih+thick;

top_ir = bot_or+eps*2;
top_ih = 6;
top_or = top_ir+thick;
top_oh = top_ih+thick;

dimple_r = .5;
dimple_n = 3;

c_height = 10;
//radius = sqrt((height*height)/3); //isocolese
c_radius = c_height/4;
s1_rad = c_radius/3;
s2_rad = c_radius/1.282;
s3_rad = c_radius/2.25;
echo("s1_rad:", s1_rad, "s2_rad:",s2_rad, "s3_rad:",s3_rad);

// ---------------------------
// Render
// ---------------------------
%cylinder(c_height, c_radius, 0, false);
//translate([0,0,6.533])
//#sphere(s1_rad);
translate([0,0,s2_rad])
#sphere(s2_rad);
translate([0,0,5.4])
#sphere(s3_rad);

//translate([bot_or/1.25,bot_or/1.25,0])
//    bottom();
//translate([-top_or/1.25,-top_or/1.25,0])    
//    top();

// ---------------------------
// Modules
// ---------------------------
module top() {
    rounded_cyl_with_bottom(top_or, top_ir, top_ih, thick);        
}

module bottom() {
    SmoothHole(2, thick, thick/3)
        rounded_cyl_with_bottom(bot_or, bot_ir, bot_ih, thick);        
    addDimples();
}

module rounded_cyl_with_bottom(or, ir, ih, t) {
    cylinder(h=t,r=or-(t/2));
    HollowCylinder(or, ir, ih);        
}

module addDimples() {
    sectors = dimple_n;
    sector_degrees = 360 / sectors;
    for(sector = [1 : sectors]) {
        angle = sector_degrees * sector;
        rotate([0,0,angle]) translate([bot_or,0,bot_ih-thick]) {
            dimple();
        }
    }    
}

module dimple() {
    sphere(r = dimple_r);
}
