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
coil_hole_r = 3/8 * in_to_mm;
gap = 1; //1/32 * in_to_mm;

disk_r = 35;
axel_r = 8/2;  //8mm or 5/16 in for bearing
axel_h = (magnet_w+metal_w*2+coil_w*2+gap*4)*1.75;//40;

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
            axel(e=.1);
    }
}

module render_test() {
    translate([0,0,metal_w/2]) {
        difference() {
            cube([30,40,metal_w], center=true);
            
            //Magnet hole
            //Best but needs to be a little smaller (eps=.15 not .2 - Done)
            translate([-10,-7,0])hole(metal_w, magnet_hole_r+.15); 
            
            //Axel holes - NOTE these all had the same radius of axel_r
            //Hole needs to be a little smaller, key needs to be reworked
            translate([10,-7,0])axel_w_key(h=axel_h, e=eps);
            
            //Bearing hole: no changes
            translate([0,7,0])bearing(pos=[0,0,-3.5],model=608,outline=true); 
            
            //Bolt Holes
            // Best but hole needs to be bigger (3.5 not 3 - Done)
            // Best but Hex needs to be a little smaller (6.8 not 7 - Done)
            translate([0,-12,0])hole(metal_w, metal_hole_r); 
            translate([0,-12,0])hex_indent(metal_w,hex_head_t,hex_head_r); 
        }
        //#translate([10,-7,0])axel_w_key(h=axel_h, e=eps);
        
    }
    //Axel
    //Best but need to make notch deeper
    h=15;
    translate([0,7,h/2])rotate([90,0,0])axel(h=h, e=.1); 
    
    //Axel keys: rework these
    e=-0.1;
    h2=h-2;
    translate([0,0,h2/2+1])axel_key(h=h2, e=e);
    //translate([20, 0,axel_r/4+e*2])rotate([90,0,0])axel_key(h=h-2, e=e);
}

module render_test_v1() {
    translate([0,0,metal_w/2]) {
        difference() {
            cube([disk_r,axel_h,metal_w], center=true);
            
            //Magnet holes
            translate([-10,-45,0])hole(metal_w, magnet_hole_r); // too small
            translate([  0,-45,0])hole(metal_w, magnet_hole_r+eps); //Best but needs to be a little smaller ie eps=.1
            translate([ 10,-45,0])hole(metal_w, magnet_hole_r+eps*2);
            
            //Bearing holes
            translate([0,-24,0])bearing(pos=[0,0,-3.5],model=608,outline=true); //Use this
            translate([0,0,0])bearing(pos=[0,0,-3.5],model=609,outline=true); //Too big
            
            //Axel holes - NOTE these all had the same radius of axel_r
            translate([-(axel_r*2.25),20,0])axel_w_key(h=axel_h, e=0); 
            translate([             0,20,0])axel_w_key(h=axel_h, e=eps);
            translate([ (axel_r*2.25),20,0])axel_w_key(h=axel_h, e=eps*2);
            
            //Bolt Holes
            translate([-9,35,0])hole(metal_w, metal_hole_r); // Best but hole needs to be bigger
            translate([-9,35,0])hex_indent(metal_w,hex_head_t,hex_head_r); // Best but Hex needs to be a little smaller
            translate([0,47,0])hole(metal_w, metal_hole_r);
            translate([0,47,0])hex_indent(metal_w,hex_head_t+eps,hex_head_r+eps);
            translate([9,35,0])hole(metal_w, metal_hole_r);
            translate([9,35,0])hex_indent(metal_w,hex_head_t+eps*2,hex_head_r+eps*2);
        }
        
        //Axels
        translate([25,-50,0])rotate([90,0,0])axel(h=metal_w, e=0);
        translate([25,-40,0])rotate([90,0,0])axel(h=metal_w, e=.1); //Best but needs to be bigger ie .05 also need to make notch deeper
        translate([25,-30,0])rotate([90,0,0])axel(h=metal_w, e=eps);
        translate([25,-20,0])rotate([90,0,0])axel(h=metal_w, e=eps*2);
        
    }
    
    //Axel keys: None of these were any good
    translate([25, 0,axel_r/4+eps*2])rotate([90,0,0])axel_key(h=metal_w-2, e=eps*2);
    translate([25,10,axel_r/4+eps])rotate([90,0,0])axel_key(h=metal_w-2, e=eps);
    translate([25,20,axel_r/4+.1])rotate([90,0,0])axel_key(h=metal_w-2, e=.1);
    translate([25,30,axel_r/4])rotate([90,0,0])axel_key(h=metal_w-2, e=0);
    translate([25,40,axel_r/4])rotate([90,0,0])axel_key(h=metal_w-2, e=-.05);
    translate([25,50,axel_r/4])rotate([90,0,0])axel_key(h=metal_w-2, e=-.10);
}


module render_print() {
}

// Rotating Disk with magnets
module magnetDisk(w=magnet_w) {
    // Disk
    rotate([90,0,0]) {
        difference() {
            cylinder(h=w,r=disk_r,center=true);
            //cylinder(h=w-(metal_w*2),r=disk_r+1,center=true);
            holes(w, magnet_hole_r);
            axel_w_key();
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
            axel_w_key();
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
    cube([axel_r/2+e*2, axel_r/2+e*2, h+2],center=true);
}
module axel_w_key(h=axel_h, e=eps) {
    cylinder(h=h,r=axel_r-e,center=true);
    translate([0,axel_r-e*2,0])axel_key(h,e);
}