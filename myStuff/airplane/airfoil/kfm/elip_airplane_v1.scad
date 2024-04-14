echo(version=version());

use <kfm_airfoil_module_v1.scad>;

$fa = 1;
$fs = 0.4;
$fn=50;


//x=60;
//y=30;
//z=y*2;
//t=2;
//translate([0,-t,z/4]) rotate([-90,0,0])
//difference() {
//    resize(newsize=[x,y,z]) cylinder(r=1,h=1);
//    translate([0,0,-t/2]) resize(newsize=[x-t,y-t,z+t]) cylinder(r=1,h=1);
//    translate([0,0,z+t]) rotate([65,0,0]) cube([x*2,y,z*2],center=true);
//    translate([0,-y/5,z/(t*4.5)]) rotate([33,0,0]) cube([x*2,y,z*2],center=true);
//}
//rotate([-90,0,0]) translate([0,-t,0])
//    difference() {
//        resize(newsize=[t*2,t*2,x+y]) cylinder(r=1,h=1,center=true);
//        #resize(newsize=[t*1.5,t*1.5,x+y+1]) cylinder(r=1,h=1,center=true);
//    }
//
//translate([-20*.02,y+20.5,0]) rotate([0,-90,180]) 
//    kfm0_wing(span=y,chord=20,scale=[1,.27],center=false);


x=150;
y=30;
z=y*2;
t=2;
translate([0,-t,z/4]) rotate([-90,0,0])
difference() {
    resize(newsize=[x,y,z]) cylinder(r=1,h=1);
    translate([0,0,-t/2]) resize(newsize=[x-t,y-t,z+t]) cylinder(r=1,h=1);
    translate([0,0,z+t]) rotate([65,0,0]) cube([x*2,y,z*2],center=true);
    translate([0,-y/5,z/(t*4.5)]) rotate([33,0,0]) cube([x*2,y,z*2],center=true);
}
rotate([-90,0,0]) translate([0,-t,0])
    difference() {
        resize(newsize=[t*2,t*2,x-y]) cylinder(r=1,h=1,center=true);
        #resize(newsize=[t*1.5,t*1.5,x]) cylinder(r=1,h=1,center=true);
    }

translate([-20*.02,y+20.5,0]) rotate([0,-90,180]) 
    kfm0_wing(span=y,chord=20,scale=[1,.27],center=false);


//x=120;
//y=60;
//z=y*2;
//t=2;
//translate([0,-t,z/4]) rotate([-90,0,0])
//difference() {
//    resize(newsize=[x,y,z]) cylinder(r=1,h=1);
//    translate([0,0,-t/2]) resize(newsize=[x-t,y-t,z+t]) cylinder(r=1,h=1);
//    translate([0,0,z+t]) rotate([65,0,0]) cube([x*2,y,z*2],center=true);
//    translate([0,-y/5,z/(t*4.5)]) rotate([33,0,0]) cube([x*2,y,z*2],center=true);
//}
//rotate([-90,0,0]) translate([0,-t,0])
//    difference() {
//        resize(newsize=[t*2,t*2,x+y]) cylinder(r=1,h=1,center=true);
//        #resize(newsize=[t*1.5,t*1.5,x+y+1]) cylinder(r=1,h=1,center=true);
//    }
//
//translate([-20*.02,y+20.5,0]) rotate([0,-90,180]) 
//    kfm0_wing(span=y,chord=20,scale=[1,.27],center=false);
