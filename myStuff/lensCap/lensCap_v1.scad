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
leash_h = outter_h/2;
leash_r = 3;
leash_hole_r = 1.25;
dimple_r = .5;
dimple_n = 5;

lensCap();

module lensCap() {
    difference() {
        union() {
            cylinder(h=outter_h,r=outter_r,center=true);
            addLeash();
        }
        //remove inner cycl
        translate([0,0,thick])
        cylinder(h=outter_h,r=inner_r,center=true);
    }
    addDimples();
    
}

module addDimples() {
    sectors = dimple_n;
    sector_degrees = 360 / sectors;
    for(sector = [1 : sectors]) {
        angle = sector_degrees * sector;
        rotate([0,0,angle]) translate([outter_r-(thick*.75),0,thick]) {
            dimple();
        }
    }    
}

module dimple() {
    sphere(r = dimple_r);
}

module addLeash() {
    translate([outter_r+leash_r/2.25,0,-leash_h/2])
        leashHolder();
}

module leashHolder() {
    difference() {
        union() {
            cylinder(h=leash_h,r=leash_r,center=true);
            translate([-leash_r/2,0,0])
            cube([leash_r, leash_r*2, leash_h], center=true);
        }
        //remove hole
        cylinder(h=leash_h*2,r=leash_hole_r,center=true);
    }
}

