use <MCAD/boxes.scad>
use <jg_gear_slider_v5.scad>

$fa = 1;
$fs = 0.4;
//$fn=50;

length       = 100;
mm_per_tooth = 5; //all meshing gears need the same mm_per_tooth (and the same pressure_angle)
thickness    = 3;
rounding_radius = 1;
gear_num_teeth = 16; //mm_per_tooth*4;
gear_hole = 12; //gear_num_teeth/2;

//jg_printable_gear(mm_per_tooth, gear_num_teeth, thickness, gear_hole);
//jg_printable_slider(length, mm_per_tooth, thickness, rounding_radius, gear_num_teeth, gear_hole);
//jg_printable_gear_slider_body(length, mm_per_tooth, thickness, rounding_radius, gear_num_teeth, gear_hole);

//jg_slider(length, mm_per_tooth, thickness, rounding_radius, gear_num_teeth, gear_hole);


//jg_gear_slider_assembly_meshed(length, mm_per_tooth, thickness, rounding_radius, gear_num_teeth, gear_hole);
//jg_gear_slider_assembly(length, mm_per_tooth, thickness, rounding_radius, gear_num_teeth, gear_hole);
//jg_gear_slider_assembly();

//jg_gear_slider_body(length, mm_per_tooth, thickness, rounding_radius, gear_num_teeth, gear_hole);

//jg_gear_slider_body_assembly(length, mm_per_tooth, thickness, rounding_radius, gear_num_teeth, gear_hole);

jg_gear_slider_body_assembly_meshed(length, mm_per_tooth, thickness, rounding_radius, gear_num_teeth, gear_hole);

//translate([0, 17,0])
//rotate([0, 90,0])
//cylinder(r=1, h=length*1.5, center=true);

//translate([0, 0, thickness*2.8]) cube([1,length*1.5,1], center=true);

//cap_sup_y_offset = 9;
//cap_sup_y = 10;
//cap_sup_z = 15;
//sup_fill_z = 5;
//
//    // End Cap Support
//    translate([100-cap_sup_y, cap_sup_y_offset, -thickness+rounding_radius])
//        rotate([-90, -90,0])
//        minkowski() {
//            prism(thickness-(rounding_radius*2), cap_sup_y, cap_sup_z);
//            cylinder(r=rounding_radius,h=1, center=true);
//        }
//translate([100, cap_sup_y_offset+((cap_sup_z-rounding_radius)/2), -thickness+rounding_radius])
//cube([thickness+rounding_radius, cap_sup_z+(rounding_radius*2), sup_fill_z], center=true);