include <BOSL/constants.scad>
use <BOSL/involute_gears.scad>

//$fa = 1;
//$fs = 0.4;
//$fn=50;

length       = 150;
mm_per_tooth = 5; //all meshing gears need the same mm_per_tooth (and the same pressure_angle)
thickness    = 5;

n1 = mm_per_tooth*4; //red gear number of teeth
n5 = length/mm_per_tooth;  //gray rack
d1 = pitch_radius(mm_per_tooth, n1);

hole            = n1/2;
height          = mm_per_tooth * 1.5;
rack_y_offset   = height-(mm_per_tooth * PI/10);
bottom_w        = mm_per_tooth * 2;
end_cap_x_offset= length-thickness/2;
end_cap_y       = (d1+height)*2;

//Gear
translate([0, d1+rack_y_offset, thickness/2])    
    gear(mm_per_tooth,n1,thickness,hole);

//Rack
translate([mm_per_tooth/2, rack_y_offset, thickness/2])    
    rack(mm_per_tooth, n5, thickness, height); 
    
//Triangle
translate([0, height, thickness*2])
    rotate([180,0,0])
    prism(length, height, thickness);
        
//Back
translate([length/2, rack_y_offset/4, thickness/2])
    cube([length, rack_y_offset/2, thickness*3],center=true);

//Bottom
translate([length/2, d1/2, -thickness/2])
    cube([length, d1, thickness],center=true);

//End Cap 1
translate([end_cap_x_offset, d1/2, -thickness/2])
    cube([thickness, d1, thickness*5],center=true);

//End Cap 2
translate([end_cap_x_offset, end_cap_y/2, -thickness*2.5])
    cube([thickness, end_cap_y, thickness*3],center=true);

//Prism Module
module prism(l, w, h){
    polyhedron(
        points=[[0,0,0], [l,0,0], [l,w,0], [0,w,0], [0,w,h], [l,w,h]],
        faces=[[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]
    );
}