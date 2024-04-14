echo(version=version());

use <naca_airfoil_module.scad>;

$fa = 1;
$fs = 0.4;
$fn=100;

s=75;   //span of main wings
c=30;   //chord length of main wings
t=0.2;  //thichness of arifoil (.15 to about .5)
n=500;  //number of points for airfoil
h=0.8;  //% hollow
scale=[1,1];
flat=true;

//Wings
rotate([0,0,0])
rotate([-90,0,0])
    naca_wing_hollow(span=s*2/3,chord=c,t=t,n=n,h=h,scale=scale,flat=flat,center=false);
translate([0,50,0])
rotate([-60,0,0])
    #naca_wing_hollow(span=s/3,chord=c,t=t,n=n,h=h,scale=scale,flat=flat,center=false);

mirror([0,1,0])
rotate([0,0,0])
rotate([-90,0,0])
    naca_wing_hollow(span=s*2/3,chord=c,t=t,n=n,h=h,scale=scale,flat=flat,center=false);
mirror([0,1,0])
translate([0,50,0])
rotate([-60,0,0])
    #naca_wing_hollow(span=s/3,chord=c,t=t,n=n,h=h,scale=scale,flat=flat,center=false);


//Body
difference() {
    union() {
    translate([-25,0,0])
    resize(newsize=[115,5,4]) cylinder(r=5,h=4);
    translate([0,-2,0])
    cube([35,4,4]);
    translate([35,0,0])
    cylinder(r=2,h=4);
    }
    translate([-18,0,2])
    cube([100,2,2], center=true);
}

//Rear Stablizers
translate([-70,0,0])
//rotate([0,0,8])
rotate([-90,0,0])
    naca_wing(span=s/3,chord=c/2.5,t=t/2,n=n,scale=[1,1],flat=flat,center=false);
mirror([0,1,0])
translate([-70,0,0])
//rotate([0,0,8])
rotate([-90,0,0])
    naca_wing(span=s/3,chord=c/2.5,t=t/2,n=n,scale=[1,1],flat=flat,center=false);

// Tail    
translate([-70,0,3.5])
rotate([0,-15,0])
naca_wing(span=s/5,chord=c/2.5,t=t/4,n=n,scale=[.75,1],flat=false,center=false);
