include <BOSL/constants.scad>
use <BOSL/involute_gears.scad>
use <MCAD/boxes.scad>

//$fa = 1;
//$fs = 0.4;

RACK_HEIGHT_RATIO = 1.2;
DIFF_TOLLERANCE = .2;

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
    cly_height = thickness*3;
    cyl_outer_r = (gear_hole - DIFF_TOLLERANCE)/2;
    cone_height= thickness*5 + DIFF_TOLLERANCE;
    cone_bot_r = cyl_outer_r;
    cone_top_r = 2;
    echo(cone_height);
    
    difference() {
        union() {
            //Top
            translate([0, 0, thickness*2]) 
                roundedBox(size=[body_x, body_y, body_z],radius=rounding_radius);
            //Outer Cylinder
            translate([0, 0, thickness/2]) 
                cylinder(r=cyl_outer_r,h=cly_height, center=true);
            //Side 1
            translate([0, ((-body_y+thickness)/2), thickness/2]) 
                roundedBox(size=[body_x, thickness, thickness*3],radius=rounding_radius);
            //Side 2
            translate([0, ((body_y-thickness)/2), thickness/2]) 
                roundedBox(size=[body_x, thickness, thickness*3],radius=rounding_radius);    
        }
        //Remove inner cone
        translate([0, 0, -cone_height/3]) cylinder(cone_height, cone_top_r, cone_bot_r, cone_top_r);
        //Remove slider rails
        scale([1.015, 1.015, 1.015]) 
        jg_simple_slider_assembly_meshed(length, mm_per_tooth, thickness, rounding_radius, gear_num_teeth, gear_hole);
        
        //Top guide line
        translate([0, 0, thickness*2.7]) cube([1,length*1.5,1], center=true);
        //Side 1 guide line
        translate([0, ((-body_y+thickness)/2)-1.25, 0]) cube([1,1,thickness*10], center=true);
        //Side 2 guide line
        translate([0, ((+body_y-thickness)/2)+1.25, 0]) cube([1,1,thickness*10], center=true);
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
    end_cap2_y       = (gear_pr+rack_y_offset)*2;
    end_cap1_y       = end_cap2_y - bottom_y;
    
    cap_sup_y_offset = rack_y_offset;
    cap_sup_z = end_cap1_y - rack_y_offset - rounding_radius; //15;
    cap_sup_y = cap_sup_z * .667; //10;
    sup_fill_z = 5;
    
    difference() {
        union() {
            //Rack
            translate([mm_per_tooth/2, rack_y_offset, thickness/2])    
                rack(mm_per_tooth, rack_num_teeth, thickness, rack_height); 
                
            //Top Triangle
            translate([0, triangle_y, thickness*2])
                rotate([180,0,0])
                prism(length, triangle_y, thickness);
                    
            //Back
            translate([length/2, rack_y_offset/4, thickness/2])
                roundedBox(size=[length+rounding_radius, rack_y_offset/2, thickness*3],radius=rounding_radius);
            
            //Bottom
            translate([length/2, bottom_y/2, -thickness/2])
                roundedBox(size=[length+rounding_radius, bottom_y, thickness],radius=rounding_radius);
            
            //End Cap 1
            translate([end_cap_x_offset, end_cap1_y/2, -thickness/2])
                roundedBox(size=[thickness, end_cap1_y, thickness*3],radius=rounding_radius);
            
            //End Cap 2
            translate([end_cap_x_offset, end_cap2_y/2, -thickness*2.5])
                roundedBox(size=[thickness, end_cap2_y, thickness*3],radius=rounding_radius);

            // End Cap Support
            translate([end_cap_x_offset-cap_sup_y, cap_sup_y_offset, -thickness+rounding_radius])
                rotate([-90, -90,0])
                minkowski() {
                    prism(thickness-(rounding_radius*2), cap_sup_y, cap_sup_z);
                    cylinder(r=rounding_radius,h=1, center=true);
                }; 
            
            //Support cylinder
            translate([end_cap_x_offset+thickness/2, end_cap2_y/2, -thickness*2]) rotate([90, 0,0]) cylinder(r=thickness/2,h=end_cap2_y, center=true);
        }
        //Remove notches
        notch_y_offset = thickness;
        notch_z = .8;
        notch_z_offset = notch_z - .05;
        // 1 mm notches
        for (i=[1:length])
           translate([i+1.5, notch_y_offset, -notch_z_offset])
             cube([.2, (bottom_y/1.5)-notch_y_offset, notch_z]);        
        // 5 mm notches
        for (i=[1:5:length])
           translate([i+1.5, notch_y_offset, -notch_z_offset])
             cube([.2, (bottom_y/1.25)-notch_y_offset, notch_z]);        
        // 10 mm notches
        for (i=[1:10:length])
           translate([i+1.5, notch_y_offset, -notch_z_offset])
             cube([.2, (bottom_y)-notch_y_offset, notch_z]);        
        
    }        
        
}

//JG 2 Simple Sliders Assembly Meshed Module for diff with body
module jg_simple_slider_assembly_meshed(
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
    jg_simple_slider(length, mm_per_tooth, thickness, rounding_radius, gear_num_teeth, gear_hole);
    
    translate([length/2, gear_pr+rack_y_offset, 0])
    rotate([0,0,180])
    jg_simple_slider(length, mm_per_tooth, thickness, rounding_radius, gear_num_teeth, gear_hole);
}


//JG Simple Slider Module for diff with body
module jg_simple_slider(
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
    end_cap2_y       = (gear_pr+rack_y_offset)*2;
    end_cap1_y       = end_cap2_y - bottom_y;
    
    cap_sup_y_offset = rack_y_offset;
    cap_sup_z = end_cap1_y - rack_y_offset - rounding_radius; //15;
    cap_sup_y = cap_sup_z * .667; //10;
    sup_fill_z = 5;
    
    //Top Triangle
    translate([0, triangle_y, thickness*2])
        rotate([180,0,0])
        prism(length, triangle_y, thickness);
            
    //Back
    translate([length/2, rack_y_offset/4, thickness/2])
        roundedBox(size=[length+rounding_radius, rack_y_offset/2, thickness*3],radius=rounding_radius);
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
        
    difference() {
        union() {
            gear(mm_per_tooth, gear_num_teeth, thickness, gear_hole);
            translate([0,0,.6]) cylinder(r=(gear_hole+4)/2, h=thickness, center=true);
        }
        cylinder(r=gear_hole/2, h=thickness*4, center=true);
    }
}

//Prism Module
module prism(l, w, h){
    polyhedron(
        points=[[0,0,0], [l,0,0], [l,w,0], [0,w,0], [0,w,h], [l,w,h]],
        faces=[[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]
    );
}