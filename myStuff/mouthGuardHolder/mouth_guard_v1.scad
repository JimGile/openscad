include <smooth_prim/smooth_prim.scad>

// ---------------------------
// Constants
// ---------------------------
$fa = 1;
$fs = 0.4;
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

// ---------------------------
// Render
// ---------------------------
translate([bot_or/1.25,bot_or/1.25,0])
    bottom();
translate([-top_or/1.25,-top_or/1.25,0])    
    top();

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
