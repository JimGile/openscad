echo(version=version());

use <naca_airfoil_module_v4.scad>;

$fa = 1;
$fs = 0.4;
$fn=100;

s=75;   //span of main wings
c=40;   //chord length of main wings
t=0.2;  //thichness of arifoil (.15 to about .5)
n=500;  //number of points for airfoil
h=0.8;  //% hollow
holes=15; //num holes in supports
scale=[.75,1];
flat=true;

//Wings
rotate([0,0,0])
    naca_wing_hollow_supports(span=s,chord=c,t=t,n=n,h=h,num_holes=holes,scale=scale,flat=flat);
//translate([0,s*1/3,0])
//rotate([15,0,0])
//    naca_wing_hollow_supports(span=s*2/3,chord=c,t=t,n=n,h=h,num_holes=holes,scale=scale,flat=flat);

mirror([0,1,0])
rotate([0,0,0])
    naca_wing_hollow_supports(span=s,chord=c,t=t,n=n,h=h,num_holes=holes,scale=scale,flat=flat);
//mirror([0,1,0])
//translate([0,s*1/3,0])
//rotate([15,0,0])
//    naca_wing_hollow_supports(span=s*2/3,chord=c,t=t,n=n,h=h,num_holes=holes,scale=scale,flat=flat);


//Body
difference() {
    union() {
        translate([-25,0,0])
        resize(newsize=[115,4.5,4]) cylinder(r=5,h=4);
        translate([0,-2,0]) cube([40,4,4]);
        translate([40,0,0]) cylinder(r=2,h=4);
    }
    #translate([-20,0,2]) cube([100,2,2], center=true);
}

//Rear Stablizers
translate([-67,0,0])
rotate([0,0,9])
rotate([0,0,0])
    //naca_wing(span=s/3,chord=c/2.5,t=t,n=n,scale=[.75,1],flat=flat);
    naca_wing_hollow_supports(span=s/3,chord=c/2.5,t=t,n=n,h=h,num_holes=holes,scale=[.75,1],flat=flat);
mirror([0,1,0])
translate([-67,0,0])
rotate([0,0,9])
rotate([0,0,0])
    naca_wing_hollow_supports(span=s/3,chord=c/2.5,t=t,n=n,h=h,num_holes=holes,scale=[.75,1],flat=flat);

// Tail
difference() {
    translate([-67,0,4])
    rotate([90,-15,0])
    //naca_wing(span=s/4,chord=c/2.5,t=t/2,n=n,scale=[.75,1],flat=false);
    naca_wing_hollow_supports(span=s/4,chord=c/2.5,t=t/2,n=n,h=h,num_holes=holes,scale=[.75,1],flat=false);
    //#translate([-70,0,s/5+4]) cube([c,c,10], center=true);
}
