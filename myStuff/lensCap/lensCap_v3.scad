include <smooth_prim/smooth_prim.scad>
// ---------------------------
// Constants
// ---------------------------
$fa = 1;
$fs = 0.4;
in_to_mm = 25.4;
gap = 1.25; //1/32 * in_to_mm;
nut_gap = 7;//3/4 * in_to_mm;
eps = .15;


// ---------------------------
// Variables
// ---------------------------
thick = 1.5;
inner_h = 2.5;
inner_r = (43+eps)/2;
outter_r = inner_r + thick;
outter_h = inner_h + thick*2;
leash_h = outter_h - inner_h;
leash_w = 4.5;
leash_hole_r = 1.25;
outter_r2 = outter_r + leash_w;
dimple_r = .5;
dimple_n = 3;

echo(str("inner_h:", inner_h));
echo(str("outter_h:", outter_h));
echo(str("leash_h:", leash_h));

lensCap();

//SmoothHole(5, leash_h, 2)
    //SmoothCylinder(outter_r2,leash_h,2);

//SmoothCylinder(outter_r2,leash_h,thick);            
//translate([outter_r+leash_w/3,0,-.25])
////cylinder(h=leash_h*3,r=leash_hole_r,center=true);
//SmoothHole(leash_hole_r, leash_h+.5, thick/3);


module lensCap() {
    HollowCylinder(outter_r, inner_r, outter_h);    
    SmoothHole(leash_hole_r, leash_h, thick/3, [outter_r+leash_w/3,0,0])
        SmoothCylinder(outter_r2, leash_h, thick);    
    addDimples();
}

module addDimples() {
    sectors = dimple_n;
    sector_degrees = 360 / sectors;
    for(sector = [1 : sectors]) {
        angle = sector_degrees * sector;
        rotate([0,0,angle]) translate([outter_r-(thick*.75),0,outter_h-thick]) {
            dimple();
        }
    }    
}

module dimple() {
    sphere(r = dimple_r);
}

