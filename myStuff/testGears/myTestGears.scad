include <BOSL/constants.scad>
use <BOSL/involute_gears.scad>

//example gear train.
//Try it with OpenSCAD View/Animate command with 20 steps and 24 FPS.
//The gears will continue to be rotated to mesh correctly if you change the number of teeth.

$fa = 1;
$fs = 0.4;
$fn=50;
n1 = 20; //red gear number of teeth
n2 = 30; //green gear
n3 = 5;  //blue gear
n4 = 20; //orange gear
n5 = 20;  //gray rack
mm_per_tooth = 10; //all meshing gears need the same mm_per_tooth (and the same pressure_angle)
thickness    = 6;
hole         = 10;
height       = mm_per_tooth * 1.5;
d1 =pitch_radius(mm_per_tooth,n1);
d12=pitch_radius(mm_per_tooth,n1) + pitch_radius(mm_per_tooth,n2);
d13=pitch_radius(mm_per_tooth,n1) + pitch_radius(mm_per_tooth,n3);
d14=pitch_radius(mm_per_tooth,n1) + pitch_radius(mm_per_tooth,n4);
translate([ 0,    0, thickness/2]) rotate([0,0, $t*360/n1])                 color([1.00,0.75,0.75]) gear(mm_per_tooth,n1,thickness,hole);
////translate([ 0,  d12, 0]) rotate([0,0,-($t+n2/2-0*n1+1/2)*360/n2]) color([0.75,1.00,0.75]) gear(mm_per_tooth,n2,thickness,hole);
////translate([ d13,  0, 0]) rotate([0,0,-($t-n3/4+n1/4+1/2)*360/n3]) color([0.75,0.75,1.00]) gear(mm_per_tooth,n3,thickness,hole);
////translate([-d14,  0, 0]) rotate([0,0,-($t-n4/4-n1/4+1/2-floor(n4/4)-3)*360/n4]) color([1.00,0.75,0.50]) gear(mm_per_tooth,n4,thickness,hole,teeth_to_hide=n4-3);
translate([(-floor(n5/2)-floor(n1/2)+$t+n1/2-1/2)*mm_per_tooth, -d1+0.0, thickness/2]) rotate([0,0,0]) color([0.75,0.75,0.75]) rack(mm_per_tooth,n5,thickness,height);
translate([-(-floor(n5/2)-floor(n1/2)+$t+n1/2-1/2)*mm_per_tooth, d1+0.0, thickness/2]) rotate([0,0,180]) color([0.75,0.75,0.75]) rack(mm_per_tooth,n5,thickness,height);

// Example: Spur Gear
//gear(mm_per_tooth=5, number_of_teeth=20, thickness=8, hole_diameter=5);
// Example: Beveled Gear
//gear(mm_per_tooth=5, number_of_teeth=20, thickness=10*cos(45), hole_diameter=5, twist=-30, bevelang=45, slices=12, $fa=1, $fs=1);

// Example:
//rack(mm_per_tooth=10, number_of_teeth=10, thickness=5, height=13, pressure_angle=20);
//rack(mm_per_tooth,n5,thickness,height);

//rotate(20,0,0)    cylinder(20,20,20,$fn=3);

//rotate(20,0,0)    cylinder(20,20,20); 

translate([((-floor(n5/2)-floor(n1/2)+$t+n1/2-1/2)*mm_per_tooth)+95, -d1-3.0, thickness*2])
rotate([90,90,90])
    cylinder(h=200,r=10,center=true,$fn=3);   
    
translate([((-floor(n5/2)-floor(n1/2)+$t+n1/2-1/2)*mm_per_tooth)+95, -d1-7.5, 4.4])
    cube([200, 8.5, 25],center=true);
    
