include <MCAD/bearing.scad>

// Smooth rendering
$fa = 1;
$fs = 0.4;

in_to_mm = 25.4;

// Variables
disk_r = 35;
num_disks = 5;
num_holes=6;
magnet_w = 1.5 * in_to_mm;
magnet_hole_r = (1/8 * in_to_mm)+.1;
metal_w = 1/4 * in_to_mm;
metal_hole_r = 3.5;
coil_w = 5; //1/8 * in_to_mm;
coil_hole_r = 8; //(1/4 * in_to_mm)+.1; // 3/8
coil_holder_r = 1.75; //1/16 * in_to_mm;
coil_ext_y = disk_r*1.75;
gap = 1; //1/32 * in_to_mm;

echo(str("coil_hole_r:", coil_hole_r));
echo(str("coil_holder_r:", coil_holder_r));

coil_base_x = ((disk_r*2)-(disk_r/4));
coil_base_y = magnet_w+gap*2;//disk_r*1.75;//60;//magnet_w+gap*2+coil_w*2;
coil_base_z = coil_w/2;

coil_side_x = coil_w/2;
coil_side_y = magnet_w+gap*2+coil_w*2;
coil_side_z = disk_r/2;

axel_r = 8/2;  //8mm or 5/16 in for bearing
axel_h = (magnet_w+metal_w*2+coil_w*2+gap*4)*1.15;//40;
echo(str("axel_h:", axel_h));

bearing_w = 1/4 * in_to_mm;
bearingModel = 608;
bearing_r = bearingOuterDiameter(model=bearingModel)/2;  //bearing_r = 7/8 * in_to_mm;

hex_head_r = 6.8;
hex_head_t = 4;

wire_notch = 2;
wire_notch_r1 = (disk_r+bearing_r)/2+coil_hole_r-wire_notch/2;
wire_notch_r2 = (disk_r+bearing_r)/2+wire_notch;
wire_notch_r3 = (disk_r+bearing_r)/2-coil_hole_r+wire_notch*2;
wire_notch_x = coil_hole_r+wire_notch;
wire_notch_y = disk_r-coil_hole_r/2-wire_notch;

eps = .2;

render_mode = "FULL"; //"FULL", "PRINT", "TEST";
print_mode = "HOLDER"; //"METAL","AXEL","COIL","BASE","HOLDER";

//coilSide();
//coilDisk();
//magnetDisk();

// Main rendering code
if (render_mode=="FULL") {
    render_full();
} else if (render_mode=="TEST") {
    render_test();
} else if (render_mode=="PRINT") {
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
        
        // Base
        base_z = -(disk_r+coil_ext_y)/2;
        translate([0,0,base_z])coilBase();
        
        // Sides
        translate([(coil_base_x+coil_side_x)/2,0,base_z])coilSide();
        translate([-(coil_base_x+coil_side_x)/2,0,base_z])coilSide();
    }
}

module render_print() {
    if (print_mode=="MAGNET") {
        // Magnet Disks and supports
        translate([-disk_r-1,-disk_r-1,0])magnetDisk();
        translate([disk_r+1,-disk_r-1,0])magnetDisk();
        translate([0,magnet_w/2+2,0]) {
            for(x = [-1 : 2]) {
                translate([x*12,0,coil_w/4])magnet_disk_support();
            }
        }
    } else if (print_mode=="METAL") {
        // Metal Disks
        translate([-disk_r-1,0,0])metalDisk();
        translate([disk_r+1,0,0])metalDisk();
    } else if (print_mode=="AXEL") {
        // Axel
        translate([0,0,axel_h/2])rotate([90,0,0])axel(h=axel_h, e=.05);
    } else if (print_mode=="COIL") {
        // Coil Disks
        translate([-disk_r-1,0,coil_w/2])rotate([90,0,0])coilDisk();
        translate([disk_r+1,0,coil_w/2])rotate([90,0,0])coilDisk();
    } else if (print_mode=="BASE") {
        // Base and Sides
        coilBase();
        translate([coil_base_x+2,-coil_side_z-2,coil_side_x/2])
            rotate([0,0,90])rotate([0,90,0])coilSide();
        translate([coil_base_x+2,2,coil_side_x/2])
            rotate([0,0,90])rotate([0,90,0])coilSide();
    } else if (print_mode=="HOLDER") {
        for(x = [-2.5 : 2.5]) {
            translate([x*coil_hole_r*2.1,0,0])coil_holder();
        }
    }
}

module render_test() {
    translate([0,0,metal_w/2]) {
        difference() {
            cube([30,40,metal_w], center=true);
            
            //Magnet hole
            //Needs to be a little smaller (eps=.1 not .15 - Done)
            translate([-10,-7,0])hole(metal_w, magnet_hole_r); 
            
            //Axel hole
            //Too small needs to be e=0 not .05
            translate([10,-7,0])rotate([270,0,0])axel(h=axel_h, e=0);
            
            //Bearing hole: no changes
            //translate([0,7,0])bearing(pos=[0,0,-3.5],model=608,outline=true); 

            //Coil hole
            translate([-0,7,0])hole(metal_w, coil_hole_r); 
            
            //Bolt Holes
            // This is good now
            translate([0,-12,0])hole(metal_w, metal_hole_r); 
            translate([0,-12,0])hex_indent(metal_w,hex_head_t,hex_head_r); 
        }
    }
    //Axel
    //Too small needs to be e=.05 or 0 not .1
    h=15;
    translate([0,7,h/2])rotate([90,0,0])axel(h=h, e=.05);
    translate([25,0,0])coil_holder(); 
}

// Rotating Disk with magnets
module magnetDisk(w=magnet_w) {
    // Disk
    if (render_mode=="PRINT") {
        difference() {
            cylinder(h=coil_w,r=disk_r,center=false);
            holes(w, magnet_hole_r);
            rotate([270,0,0])axel(e=0);//axel_w_key();
            magnet_disk_supports();
        }
    } else {
        rotate([90,0,0]) {
            difference() {
                cylinder(h=w,r=disk_r,center=true);
                holes(w, magnet_hole_r);
                rotate([270,0,0])axel(e=0);//axel_w_key();
            }
        }
    }
}

// Rotating Disk with metal
module metalDisk(w=metal_w) {
    // Disk
    if (render_mode=="PRINT") {
        rotate([0,0,0]) {
            difference() {
                cylinder(h=w,r=disk_r,center=false);
                holes(w*2, metal_hole_r, hex=true);
                rotate([270,0,0])axel(e=0);//axel_w_key();
            }
        }
    } else {
        rotate([90,0,0]) {
            difference() {
                cylinder(h=w,r=disk_r,center=true);
                holes(w, metal_hole_r, hex=true);
                rotate([270,0,0])axel(e=0);//axel_w_key();
            }
        }
    }
}

// Stationary Disk with coils
module coilDisk(w=coil_w) {
    peg_x = (coil_base_x+coil_base_z)/2;
    peg_y = disk_r+coil_side_z/4; //(disk_r+coil_ext_y/2)/1.75;
    // Disk
    rotate([-90,0,0]) {
        difference() {
            union() {
                // disk
                cylinder(h=w,r=disk_r,center=true);
                // base
                translate([0,disk_r/2,0])
                    cube([coil_base_x,coil_ext_y,w],center=true);
                // side pegs
                translate([peg_x,peg_y,0])
                    cube([coil_base_z,coil_base_z,w],center=true);
                translate([-peg_x,peg_y,0])
                    cube([coil_base_z,coil_base_z,w],center=true);
            }
            // remove holes for coils
            holes(w, coil_hole_r);
            // remove hole for bearing
            bearing(pos=[0,0,-3.5],model=bearingModel,outline=true);
            // remove notches for wires
            wireNotchesStraight();
            wireNotchesCircular();
            // remove notch for base
            translate([0,(disk_r+coil_ext_y-coil_base_z)/2,0])
                cube([coil_base_z+.2,coil_base_z+.2,w*2],center=true);
            // Misc holes
            for(x = [-2 : 2]) {
                translate([x*coil_base_x/5,peg_y,0])
                    cylinder(h=w*2,r=1.5,center=true);
            }
        }
        if (render_mode == "FULL") {
            bearing(pos=[0,0,-3.5],model=bearingModel,outline=false);
        }
    }
}

module wireNotchesCircular() {
    // remove notches for wires
    translate([0,0,coil_w/3])
        hollow_cyl(h=2, r=wire_notch_r1, t=wire_notch);
//    translate([0,0,coil_w/3])
//        hollow_cyl(h=2, r=wire_notch_r2, t=wire_notch);
    translate([0,0,coil_w/3])
        hollow_cyl(h=2, r=wire_notch_r3, t=wire_notch);
}

module wireNotchesStraight() {
    // remove notches for wires
    radius = (disk_r+bearing_r)/2;
    sectors = num_holes;
    sector_degrees = 360 / sectors;

    for(sector = [1 : sectors]) {
        angle = sector_degrees * sector;
        x_pos = radius * sin(angle);
        y_pos = radius * cos(angle);
        x_off = coil_hole_r/2 * cos(angle);
        y_off = coil_hole_r/2 * sin(angle);
        translate([x_pos+x_off,y_pos-y_off,coil_w/3]){
            rotate([0,0,-angle])cube([2,disk_r*2,2], center=true);
        }
        translate([x_pos-x_off,y_pos+y_off,coil_w/3]){
            rotate([0,0,-angle])cube([2,disk_r*2,2], center=true);
        }
    }    
}

module coilBase() {
    peg_x = (coil_base_x+coil_base_z)/2;
    peg_y = (coil_base_y+coil_w)/2;
    // base
    translate([0,0,coil_base_z/2])
        cube([coil_base_x,coil_base_y,coil_base_z],center=true);
    // pegs
    translate([peg_x,0,coil_base_z/2])
        cube([coil_base_z,coil_base_z,coil_base_z],center=true);
    translate([-peg_x,0,coil_base_z/2])
        cube([coil_base_z,coil_base_z,coil_base_z],center=true);
    translate([0,peg_y,coil_base_z/2])
        cube([coil_base_z,coil_w,coil_base_z],center=true);
    translate([0,-peg_y,coil_base_z/2])
        cube([coil_base_z,coil_w,coil_base_z],center=true);
}


module coilSide() {
    z_off = coil_side_z/2;
    difference() {
        // side
        translate([0,0,z_off])
            cube([coil_side_x,coil_side_y,coil_side_z],center=true);
        // remove notch for base
        translate([0,0,coil_side_z-coil_base_z/2])
            cube([coil_base_z*2, coil_base_z+.2,coil_base_z+.2,],center=true);
        // remove notches on sides
        translate([0,(coil_side_y-coil_w)/2,z_off])
            cube([coil_base_z*2, coil_w+.2,coil_base_z+.2,],center=true);
        translate([0,-(coil_side_y-coil_w)/2,z_off])
            cube([coil_base_z*2, coil_w+.2,coil_base_z+.2,],center=true);
        // remove misc holes
        for(x = [-1 : 1]) {
            translate([0,x*coil_side_y/5,z_off])
                rotate([0,90,0])cylinder(h=coil_side_x*2,r=1.5,center=true);
        }
    }
}


module holes(w, hole_r, hex=false) {
    radius = (disk_r+bearing_r)/2;
    sectors = num_holes;
    sector_degrees = 360 / sectors;

    for(sector = [1 : sectors]) {
        angle = sector_degrees * sector;
        x_pos = radius * sin(angle);
        y_pos = radius * cos(angle);
        translate([x_pos,y_pos,0]){
            hole(w, hole_r);
            if (hex==true) {
                hex_indent(w,hex_head_t,hex_head_r);
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
        translate([0,coil_hole_r+1,0])rotate([180,0,0])
            coil_holder_top(h1,1,r1,r2,e1,e2+.1);

}


module coil_holder_top(h1,h2,r1,r2,e1,e2) {
    rotate([180,0,0])coil_holder_template(h1,h2,r1,r2/1.75,e1,e2);
}

module coil_holder_bot(h1,h2,r1,r2,e1,e2) {
    wire_holder_r = .75;
    difference() {
        coil_holder_template(h1,h2,r1,r2,e1,e2);
        translate([0,0,h2+1])coil_holder_top(h1,2,r1,r2,e1,-.2);
        translate([0,0,h1*2+wire_holder_r])rotate([90,0,0])
            cylinder(h=r1*2,r=wire_holder_r,center=true);
    }
}

module coil_holder_template(h1,h2,r1,r2,e1,e2) {
    //Base
    cylinder(h=h1,r=r1-e1,center=false);
    //Post
    cylinder(h=h2,r=r2-e2,center=false);
}

module hollow_cyl(h, r, t) {
    difference() {
        cylinder(h=h,r=r,center=true);
        cylinder(h=h+2,r=r-t,center=true);
    }
}

module magnet_disk_supports(supp_x=10.2, supp_y=magnet_w, supp_z=coil_w/2) {
    radius = disk_r;
    sectors = 4;
    sector_degrees = 360 / sectors;

    for(sector = [1 : sectors]) {
        angle = sector_degrees * sector;
        x_pos = radius * sin(angle);
        y_pos = radius * cos(angle);
        y = supp_z/2;
        translate([x_pos,y_pos,0]) {
            if (sector == 1) {
                rotate([0,0,90])translate([0,y,0])rotate([90,0,0])magnet_disk_support(supp_x=supp_x);
            } else if (sector == 2) {
                rotate([0,0,0])translate([0,y,0])rotate([90,0,0])magnet_disk_support(supp_x=supp_x);
            } else if (sector == 3) {
                rotate([0,0,90])translate([0,-y,0])rotate([90,0,0])magnet_disk_support(supp_x=supp_x);
            } else if (sector == 4) {
                rotate([0,0,0])translate([0,-y,0])rotate([90,0,0])magnet_disk_support(supp_x=supp_x);
            }
        }
    }    
}
module magnet_disk_support(supp_x=10, supp_y=magnet_w, supp_z=coil_w/2) {
    cube([supp_x, supp_y, supp_z], center=true);
}

