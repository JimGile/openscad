include <BOSL/constants.scad>
use <BOSL/involute_gears.scad>
use <MCAD/boxes.scad>

//$fa = 1;
//$fs = 0.4;

RACK_HEIGHT_RATIO = 1.2;

//length       = 100;
//mm_per_tooth = 5; //all meshing gears need the same mm_per_tooth (and the same pressure_angle)
//thickness    = 3;
//rounding_radius = 1;
//gear_num_teeth = mm_per_tooth*4;
//gear_hole = gear_num_teeth/2;

//jg_slider();
//jg_printable_slider(length, mm_per_tooth, thickness, rounding_radius);
//jg_gear_slider_assembly(length, mm_per_tooth, thickness, rounding_radius, gear_num_teeth, gear_hole);
//jg_gear_slider_assembly();

module jg_gear_slider_body_assembly(
    length = 100,
    mm_per_tooth = 5,
    thickness= 3,
    rounding_radius = 1,
    gear_num_teeth = 20,
    gear_hole = 10) {
        
        jg_gear_slider_assembly(length, mm_per_tooth, thickness, rounding_radius, gear_num_teeth, gear_hole);
        jg_gear_slider_body(length, mm_per_tooth, thickness, rounding_radius, gear_num_teeth, gear_hole);
}

module jg_gear_slider_body_assembly_meshed(
    length = 100,
    mm_per_tooth = 5,
    thickness= 3,
    rounding_radius = 1,
    gear_num_teeth = 20,
    gear_hole = 10) {
        
        jg_gear_slider_assembly_meshed(length, mm_per_tooth, thickness, rounding_radius, gear_num_teeth, gear_hole);
        jg_gear_slider_body(length, mm_per_tooth, thickness, rounding_radius, gear_num_teeth, gear_hole);
}

module jg_printable_gear_slider_body(
    length = 100,
    mm_per_tooth = 5,
    thickness= 3,
    rounding_radius = 1,
    gear_num_teeth = 20,
    gear_hole = 10) {
                
    gear_pr = pitch_radius(mm_per_tooth, gear_num_teeth);
    rack_height = mm_per_tooth * RACK_HEIGHT_RATIO;
    rack_y_offset = rack_height-(mm_per_tooth * PI/10);
    assembly_y = (gear_pr+rack_y_offset)*2;
    body_y = assembly_y + (thickness*2);
    body_x = body_y;
    body_z = thickness*1.5;

    translate([0, 0, thickness*2.5+rounding_radius])
        rotate([180,0,0])
    jg_gear_slider_body(length, mm_per_tooth, thickness, rounding_radius, gear_num_teeth, gear_hole);        
}

module jg_gear_slider_body(
    length = 100,
    mm_per_tooth = 5,
    thickness= 3,
    rounding_radius = 1,
    gear_num_teeth = 20,
    gear_hole = 10) {
                
    gear_pr = pitch_radius(mm_per_tooth, gear_num_teeth);
    rack_height = mm_per_tooth * RACK_HEIGHT_RATIO;
    rack_y_offset = rack_height-(mm_per_tooth * PI/10);
    assembly_y = (gear_pr+rack_y_offset)*2;
    body_y = assembly_y + (thickness*2);
    body_x = body_y;
    body_z = thickness*1.5;
    
    difference() {
        union() {
            //Top
            translate([0, 0, thickness*2]) 
                roundedBox(size=[body_x, body_y, body_z],radius=rounding_radius);
            //Outer Cylinder
            translate([0, 0, thickness/2]) 
                cylinder(r=(gear_hole/2)-.1,h=thickness*3, center=true);
            //Side 1
            translate([0, ((-body_y+thickness)/2), thickness/2]) 
                roundedBox(size=[body_x, thickness, thickness*3],radius=rounding_radius);
            //Side 2
            translate([0, ((body_y-thickness)/2), thickness/2]) 
                roundedBox(size=[body_x, thickness, thickness*3],radius=rounding_radius);    
        }
        //Remove inner cylinder
        translate([0, 0, thickness]) cylinder(r=(gear_hole-2)/2,h=thickness*8, center=true);
        //Remove slider rails
        jg_gear_slider_assembly_meshed(length, mm_per_tooth, thickness, rounding_radius, gear_num_teeth, gear_hole);
        //Top guide line
        translate([0, 0, thickness*2.8]) cube([1,length*1.5,1], center=true);
        //Side 1 guide line
        translate([0, ((-body_y+thickness)/2)-1.8, 0]) cube([1,1,thickness*10], center=true);
        //Side 2 guide line
        translate([0, ((+body_y-thickness)/2)+1.8, 0]) cube([1,1,thickness*10], center=true);
    }
}

//JG Gear and 2 Sliders Assembly Module
module jg_gear_slider_assembly(
    length = 100,
    mm_per_tooth = 5,
    thickness= 3,
    rounding_radius = 1,
    gear_num_teeth = 20,
    gear_hole = 10) {
                
    gear_pr = pitch_radius(mm_per_tooth, gear_num_teeth);
    rack_height = mm_per_tooth * RACK_HEIGHT_RATIO;
    rack_y_offset = rack_height-(mm_per_tooth * PI/10);
    
    translate([0, -gear_pr-rack_y_offset, 0])
    jg_slider(length, mm_per_tooth, thickness, rounding_radius, gear_num_teeth, gear_hole);
    
    translate([0, 0, thickness/2])
    jg_gear(mm_per_tooth, gear_num_teeth, thickness, gear_hole);
    
    translate([0, gear_pr+rack_y_offset, 0])
    rotate([0,0,180])
    jg_slider(length, mm_per_tooth, thickness, rounding_radius, gear_num_teeth, gear_hole);
}

//JG Gear and 2 Sliders Assembly Meshed Module
module jg_gear_slider_assembly_meshed(
    length = 100,
    mm_per_tooth = 5,
    thickness= 3,
    rounding_radius = 1,
    gear_num_teeth = 20,
    gear_hole = 10) {
                
    gear_pr = pitch_radius(mm_per_tooth, gear_num_teeth);
    rack_height = mm_per_tooth * RACK_HEIGHT_RATIO;
    rack_y_offset = rack_height-(mm_per_tooth * PI/10);
    
    translate([-length/2, -gear_pr-rack_y_offset, 0])
    jg_slider(length, mm_per_tooth, thickness, rounding_radius, gear_num_teeth, gear_hole);
    
    translate([0, 0, thickness/2])
    jg_gear(mm_per_tooth, gear_num_teeth, thickness, gear_hole);
    
    translate([length/2, gear_pr+rack_y_offset, 0])
    rotate([0,0,180])
    jg_slider(length, mm_per_tooth, thickness, rounding_radius, gear_num_teeth, gear_hole);
}

//JG Printable Slider Module
module jg_printable_slider(
    length = 100,
    mm_per_tooth = 5,
    thickness= 3,
    rounding_radius = 1,
    gear_num_teeth = 20,
    gear_hole = 10) {
                
    translate([-length/2, 0, 0])
        rotate([90,0,0])
            jg_slider(length, mm_per_tooth, thickness, rounding_radius, gear_num_teeth, gear_hole);
}

//JG Slider Module
module jg_slider(
    length = 100,
    mm_per_tooth = 5,
    thickness= 3,
    rounding_radius = 1,
    gear_num_teeth = 20,
    gear_hole = 10) {
    
    gear_pr         = pitch_radius(mm_per_tooth, gear_num_teeth);
    rack_num_teeth  = length/mm_per_tooth;  
    rack_height     = mm_per_tooth * RACK_HEIGHT_RATIO;
    rack_y_offset   = rack_height-(mm_per_tooth * PI/10);
    triangle_y      = thickness+rounding_radius; //rack_height;
    bottom_y        = gear_pr+rack_y_offset-(gear_hole+rounding_radius)/2;
    end_cap_x_offset= length-(thickness/2)+rounding_radius;
    end_cap_y       = (gear_pr+rack_y_offset)*2;
    
    //Rack
    translate([mm_per_tooth/2, rack_y_offset, thickness/2])    
        rack(mm_per_tooth, rack_num_teeth, thickness, rack_height); 
        
    //Top Triangle
    translate([0, triangle_y, thickness*2])
        rotate([180,0,0])
        prism(length, triangle_y, thickness);
        
    //Top Ronded Box
//    translate([length/2, rack_height/2, thickness*1.667])
//        rotate([180,0,0])
//        roundedBox(size=[length, rack_height, thickness/2],radius=rounding_radius);
//        prism(length, rack_height, thickness);
            
    //Back
    translate([length/2, rack_y_offset/4, thickness/2])
        roundedBox(size=[length+rounding_radius, rack_y_offset/2, thickness*3],radius=rounding_radius);
        //cube([length, rack_y_offset/2, thickness*3],center=true);
    
    //Bottom
    translate([length/2, bottom_y/2, -thickness/2])
        roundedBox(size=[length+rounding_radius, bottom_y, thickness],radius=rounding_radius);
        //cube([length, gear_pr, thickness],center=true);
    
    //End Cap 1
    translate([end_cap_x_offset, bottom_y/2, -thickness/2])
        roundedBox(size=[thickness, bottom_y, thickness*5],radius=rounding_radius,sidesonly=true);
        //cube([thickness, gear_pr, thickness*5],center=true);
    
    //End Cap 2
    translate([end_cap_x_offset, end_cap_y/2, -thickness*2.5])
        roundedBox(size=[thickness, end_cap_y, thickness*3],radius=rounding_radius);
        //cube([thickness, end_cap_y, thickness*3],center=true);        
}

//JG Printable Gear Module
module jg_printable_gear(
    mm_per_tooth = 5,
    gear_num_teeth = 20,
    thickness = 3,
    gear_hole = 10) {
    
    translate([0, 0, thickness/2])
    jg_gear(mm_per_tooth, gear_num_teeth, thickness, gear_hole);
}

//JG Gear Module
module jg_gear(
    mm_per_tooth = 5,
    gear_num_teeth = 20,
    thickness = 3,
    gear_hole = 10) {
    gear(mm_per_tooth, gear_num_teeth, thickness, gear_hole);
}

//Prism Module
module prism(l, w, h){
    polyhedron(
        points=[[0,0,0], [l,0,0], [l,w,0], [0,w,0], [0,w,h], [l,w,h]],
        faces=[[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]
    );
}