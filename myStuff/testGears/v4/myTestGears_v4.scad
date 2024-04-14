use <MCAD/boxes.scad>
use <jg_gear_slider_v4.scad>

$fa = 1;
$fs = 0.4;
//$fn=50;

length       = 100;
mm_per_tooth = 5; //all meshing gears need the same mm_per_tooth (and the same pressure_angle)
thickness    = 3;
rounding_radius = 1;
gear_num_teeth = 15; //mm_per_tooth*4;
gear_hole = 12; //gear_num_teeth/2;

//jg_printable_gear(mm_per_tooth, gear_num_teeth, thickness, gear_hole);
jg_printable_slider(length, mm_per_tooth, thickness, rounding_radius, gear_num_teeth, gear_hole);
//jg_printable_gear_slider_body(length, mm_per_tooth, thickness, rounding_radius, gear_num_teeth, gear_hole);


//jg_gear_slider_assembly_meshed(length, mm_per_tooth, thickness, rounding_radius, gear_num_teeth, gear_hole);
//jg_gear_slider_assembly(length, mm_per_tooth, thickness, rounding_radius, gear_num_teeth, gear_hole);
//jg_gear_slider_assembly();

//jg_gear_slider_body(length, mm_per_tooth, thickness, rounding_radius, gear_num_teeth, gear_hole);

//jg_gear_slider_body_assembly(length, mm_per_tooth, thickness, rounding_radius, gear_num_teeth, gear_hole);

//jg_gear_slider_body_assembly_meshed(length, mm_per_tooth, thickness, rounding_radius, gear_num_teeth, gear_hole);

//translate([0, 0, thickness*2.8]) cube([1,length*1.5,1], center=true);