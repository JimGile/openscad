echo(version=version());

use <kfm_airfoil_module_v2.scad>;

$fa = 1;
$fs = 0.4;
$fn=50;

s=75;   //span of main wings
c=50;   //chord length of main wings
scale=[1,.5];
pct=1.75; //span % that is flat
b_l=120;
b_r=2; //body radius

b_w=4;
b_h=4;
t_pct=0.02; //Thicknes as pct of chord


//Wings
kfm0_wing_assembly(s,c,scale,t_pct);
//Body
rotate([-90,0,0]) translate([0,-b_r,23])
    difference() {
        resize(newsize=[b_r*2,b_r*2,b_l]) cylinder(r=1,h=1,center=true);
        #resize(newsize=[b_r*1.5,b_r*1.5,b_l+1]) cylinder(r=1,h=1,center=true);
    }


//difference() {
//    union() {
//        //Wings
//        kfm0_wing_assembly(s,c,scale,t_pct);
//
//        //Body
//        rotate([0,0,90]) translate([b_l/4,0,0])
//        union() {
//            translate([-b_l*.2,0,0])
//            resize(newsize=[b_l,b_w*1.125,b_h]) cylinder(r=b_w,h=b_h);
//            translate([0,-b_h/2,0]) cube([b_l/3,b_w,b_h]);
//            translate([b_l/3,0,0]) cylinder(r=b_w/2,h=b_h);
//        }
//    }
//    //Hollow out the body and wings
//    rotate([0,0,90]) translate([b_l/4,0,0])
//    #translate([-b_l/6,0,b_h/2]) cube([b_l*.8,b_w/2,b_h/2], center=true);
//}

//Rear Stablizers
translate([0,-b_l*.3,0])
kfm0_wing_assembly(s/3,c/3,scale=[1,.5]);

// Tail
difference() {
    translate([(c*.04)/4, -b_l*.3, b_r*2-.01])
    rotate([0,-90,0])
    kfm0_wing(s/5,c/3,scale=[1,.5]);
}
