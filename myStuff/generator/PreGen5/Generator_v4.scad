include <MCAD/bearing.scad>

// Smooth rendering
$fa = 1;
$fs = 0.4;

in_to_mm = 25.4;

// Variables
num_disks = 5;
num_holes=6;
magnet_w = 1.5 * in_to_mm;
magnet_hole_r = 1/8 * in_to_mm;
metal_w = 1/4 * in_to_mm;
metal_hole_r = 3.5;
coil_w = 5; //1/8 * in_to_mm;
coil_hole_r = 1/4 * in_to_mm; // 3/8
coil_holder_r = 1/16 * in_to_mm;
gap = 1; //1/32 * in_to_mm;

disk_r = 35;
axel_r = 8/2;  //8mm or 5/16 in for bearing
axel_h = (magnet_w+metal_w*2+coil_w*2+gap*4)*1.5;//40;

bearing_w = 1/4 * in_to_mm;
bearing_r = 7/8 * in_to_mm;
bearingModel = 608;

hex_head_r = 6.8;
hex_head_t = 4;

eps = .2;

render_mode = "TEST"; //"FULL", "PRINT", "TEST";


// Main rendering code
if (render_mode=="FULL") {
    render_full();
} else if (render_mode=="TEST") {
    render_test();
} else {
    render_print();
}


module render_full() {
    translate([0,0,0]) {
        // Rotating Disk with magnets
        translate([0,0,0])
            magnetDisk();
        // Stationary Disk with coils 1
        translate([0,(magnet_w+coil_w)/2+gap,0])
            coilDisk();
        // Stationary Disk with coils 2
        translate([0,-((magnet_w+coil_w)/2+gap),0])
            coilDisk();
        // Rotating Disk with metal 1
        translate([0,(magnet_w+metal_w)/2+coil_w+gap*2,0])
            metalDisk();
        // Rotating Disk with metal 2
        translate([0,-((magnet_w+metal_w)/2+coil_w+gap*2),0])
            rotate([0,0,180])metalDisk();
        // Axel
        translate([0,0,0])
            axel(e=.05);
    }
}

module render_test() {
    translate([0,0,metal_w/2]) {
        difference() {
            cube([30,40,metal_w], center=true);
            
            //Magnet hole
            //Needs to be a little smaller (eps=.1 not .15 - Done)
            translate([-10,-7,0])hole(metal_w, magnet_hole_r+.1); 
            
            //Axel hole
            //Too small needs to be e=0 not eps
            translate([10,-7,0])rotate([270,0,0])axel(h=axel_h, e=0);
            
            //Bearing hole: no changes
            //translate([0,7,0])bearing(pos=[0,0,-3.5],model=608,outline=true); 

            //Coil hole
            translate([-0,7,0])hole(metal_w, coil_hole_r+.1); 
            
            //Bolt Holes
            // This is good now
            translate([0,-12,0])hole(metal_w, metal_hole_r); 
            translate([0,-12,0])hex_indent(metal_w,hex_head_t,hex_head_r); 
        }
        //#translate([10,-7,0])rotate([270,0,0])axel(h=axel_h, e=0);
        
    }
    //Axel
    //Too small needs to be e=.05 or 0 not .1
    h=15;
    translate([0,7,h/2])rotate([90,0,0])axel(h=h, e=.05);
    translate([25,0,0])coil_holder(); 
}

module render_print() {
}

// Rotating Disk with magnets
module magnetDisk(w=magnet_w) {
    // Disk
    rotate([90,0,0]) {
        difference() {
            cylinder(h=w,r=disk_r,center=true);
            holes(w, magnet_hole_r);
            rotate([270,0,0])axel(e=0);//axel_w_key();
        }
    }
}

// Rotating Disk with metal
module metalDisk(w=metal_w) {
    // Disk
    rotate([90,0,0]) {
        difference() {
            cylinder(h=w,r=disk_r,center=true);
            holes(w, metal_hole_r, hex=true);
            rotate([270,0,0])axel(e=0);//axel_w_key();
        }
    }
}

// Stationary Disk with coils
module coilDisk(w=coil_w) {
    base_x = ((disk_r*2)-(disk_r/4));
    base_y = disk_r+(disk_r/4);
    base_z = w;
    
    // Disk
    rotate([-90,0,0]) {
        difference() {
            union() {
                // disk
                cylinder(h=w,r=disk_r,center=true);
                // base
                translate([0,disk_r/2,0])
                    cube([base_x,base_y,base_z],center=true);
            }
            // remove holes for coils
            holes(w, coil_hole_r);
            // remove hole for bearing
            bearing(pos=[0,0,-3.5],model=bearingModel,outline=true);
            //cylinder(h=w+2,r=bearing_r,center=true);
        }
        if (render_mode == "FULL") {
            bearing(pos=[0,0,-3.5],model=bearingModel,outline=false);
        }
    }
}

module holes(w, hole_r, hex=false) {
    b_r = bearingOuterDiameter(model=bearingModel)/2;
    radius = (disk_r+b_r)/2;
    sectors = num_holes;
    sector_degrees = 360 / sectors;

    for(sector = [1 : sectors]) {
        angle = sector_degrees * sector;
        //echo(str("--- Angle:", angle));
        x_pos = radius * sin(angle);
        y_pos = radius * cos(angle);
        //echo(str("x:", x_pos));
        //echo(str("y:", y_pos));
        
        translate([x_pos,y_pos,0]){
            hole(w, hole_r);
            if (hex==true) {
                hex_indent(w, 4, 7);
            }
        }
    }    
}
module hole(w, hole_r) {
    cylinder(h=w+2,r=hole_r,center=true);
}
module hex_indent(w, hex_t=hex_head_t, hex_r=hex_head_r) {
    z_pos = w-hex_t;
    translate([0,0,z_pos])cylinder(h=w,r=hex_r,center=true, $fn=6);
}
    
// Axel
module axel(h=axel_h, e=eps) {
    rotate([90,0,0]) {
        difference() {
            cylinder(h=h,r=axel_r-e,center=true);
            translate([0,axel_r-e*2,0])axel_key(h,e);
        }
    }
}
module axel_key(h=axel_h, e=eps) {
    cube([axel_r/2+e*2, axel_r/1+e*2, h+2],center=true);
}
module axel_w_key(h=axel_h, e=eps) {
    cylinder(h=h,r=axel_r-e,center=true);
    translate([0,axel_r-e*2,0])axel_key(h,e);
}

// Coil Holder
module coil_holder(
    h1=.3,
    h2=coil_w, 
    r1=coil_hole_r, 
    r2=coil_holder_r, 
    e1=eps,
    e2=0) {
        translate([0,-coil_hole_r-1,0])coil_holder_bot(h1,h2,r1,r2,e1,e2);
        translate([0,coil_hole_r+1,0])rotate([180,0,0])coil_holder_top(h1,h2/2,r1,r2,e1,e2);

}


module coil_holder_top(h1,h2,r1,r2,e1,e2) {
    rotate([180,0,0])coil_holder_template(h1,h2,r1,r2/1.5,e1,e2);
}

module coil_holder_bot(h1,h2,r1,r2,e1,e2) {
    difference() {
        coil_holder_template(h1,h2,r1,r2,e1,e2);
        translate([0,0,h2+1])coil_holder_top(h1,h2+2,r1,r2,e1,-.1);
    }
}

module coil_holder_template(h1,h2,r1,r2,e1,e2) {
    //Base
    cylinder(h=h1,r=r1-e1,center=false);
    //Post
    cylinder(h=h2,r=r2-e2,center=false);
}
