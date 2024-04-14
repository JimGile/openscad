/*

Jim Gile
Ring Flyer

*/

$fn= 80; // Smoothness setting

tk = .45;
base = 150;
minHtRatio = 6;
cir = sqrt(pow(base,2)+pow(base,2));
rad = cir/(2*PI);
diam = 2*rad;
ht = cir/3;
minHt = ht/minHtRatio;
sliceAngle = atan2(ht-minHt,diam);
echo("cir=",cir,"ht=",ht,"minHt=",minHt,"sliceAngle=",sliceAngle);

scale([1,1,1]) {
    //Main Cylinder
    difference() {
        cylinder(r=rad,h=ht,center=false);
        translate([0,0,-1])cylinder(r=rad-(2*tk),h=ht+2,center=false);
        translate([0,0,minHt])cylinder(r=rad-tk,h=ht,center=false);
        translate([-(diam+1)/2,-rad,minHt])rotate([sliceAngle,0,0])cube([diam+2,base+2,ht],center=false);
    }
    //Upper Wing
    difference() {
        translate([0,tk-diam*2.5,0])cylinder(r=diam*2,h=minHt,center=false);
        translate([0,tk-diam*2.5,-1])cylinder(r=diam*2-tk,h=minHt+2,center=false);
        translate([diam*2+base/2,-diam*2.5,minHt/2])cube([diam*4,diam*4,minHt*2],center=true);
        translate([-diam*2-base/2,-diam*2.5,minHt/2])cube([diam*4,diam*4,minHt*2],center=true);
        translate([0,-diam*3,minHt/2])cube([diam*4,diam*4,minHt*2],center=true);
    }
    //Rudder
    hull() {
        translate([0,rad,minHt/2])cube([tk,rad/8,minHt],center=true);
        translate([0,rad,ht-minHt/2])cube([tk,rad/8,minHt],center=true);
    }    
}
