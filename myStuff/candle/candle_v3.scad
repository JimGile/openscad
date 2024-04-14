// Smooth rendering
$fa = 1;
$fs = 0.4;

in_to_mm = 25.4;

// Variables
height = 3 * in_to_mm;
inside_d = 3 * in_to_mm;
inside_r = inside_d/2;
wall_t = 1/4 * in_to_mm;
outside_d = inside_d + 2*wall_t;
outside_r = outside_d/2;
ring_or = outside_r+.2;
ring_h = wall_t;
ring_t = wall_t/2;

full_render();
//print_left_half_mold();
//print_right_half_mold();
//print_bottom_mold();
//print_support_ring();

//Testing
//bottom_mold();
//left_half_mold();
//right_half_mold();


module full_render() {
    translate([0,0,wall_t/2-height/2])
        bottom_mold();
    left_half_mold();
    right_half_mold();
    support_ring();
}

module print_left_half_mold() {
    translate([0,0,height/2]) rotate([0,180,0])
        left_half_mold();
}

module print_right_half_mold() {
    translate([0,0,height/2]) rotate([0,180,0])
        right_half_mold();
}

module print_bottom_mold() {
    translate([0,0,(wall_t+ring_h)/2])
        bottom_mold();
}

module print_support_ring() {
    translate([0,0,ring_h/2])
        support_ring();
}

module left_half_mold() {
    cube_y = inside_r+wall_t;
    vert_x = inside_r+wall_t/2;
    half_mold(cube_y, vert_x);
}

module right_half_mold() {
    cube_y = -(inside_r+wall_t);
    vert_x = -(inside_r+wall_t/2);
    half_mold(cube_y, vert_x);
}

module half_mold(cube_y, vert_x) {
    difference() {
        union() {
            difference() {
                hollow_cyl(height, inside_r, wall_t);
                translate([0,cube_y,0])
                    cube([outside_d+.01, outside_d+.01, height+2], center=true);
                translate([vert_x,0,0])
                    vert_cut_out(height+.1, wall_t+1);
            }
            translate([-vert_x,0,0])
                vert_cut_out(height, wall_t);
        }
        translate([0,0,wall_t/2-height/2])
            bottom_mold(inside_r+.2, wall_t+.2);
    }
}

module hollow_cyl(h, r, t) {
    difference() {
        cylinder(h=h,r=r+t,center=true);
        cylinder(h=h+2,r=r,center=true);
    }
}

module bottom_mold(r=inside_r, t=wall_t) {
    cylinder(h=t,r=r+t/1.5,center=true);
    support_ring();
    translate([0,0,-(wall_t+ring_t)/2])
        cylinder(h=ring_t,r=ring_or+ring_t,center=true);
}

module vert_cut_out(h, t) {
    cube([t/3, t/3+1, h], center=true);
}

module support_ring(h=ring_h, r=ring_or, t=ring_t) {
    hollow_cyl(h, r, t);
}
