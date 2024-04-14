include <MCAD/bearing.scad>

// ---------------------------
// Constants
// ---------------------------
$fa = 1;
$fs = 0.4;
in_to_mm = 25.4;
gap = 1.25; //1/32 * in_to_mm;
nut_gap = 7;//3/4 * in_to_mm;
eps = .2;

bearingModel = 608;
bearing_w = bearingWidth(bearingModel);
bearing_or = bearingOuterDiameter(bearingModel)/2;
bearing_ir = bearingInnerDiameter(bearingModel)/2;

// ---------------------------
// Variables
// ---------------------------
num_holes=8;
sectors = num_holes;
sector_degrees = 360 / sectors;

mag1_hole_d = (1/4 * in_to_mm);
mag1_hole_r = (mag1_hole_d/2);
mag1_w = 1/4 * in_to_mm;

mag2_hole_d = (1/8 * in_to_mm);
mag2_hole_r = (mag2_hole_d/2);
mag2_w = 1/4 * in_to_mm;

mag_space_1 = 3;
mag_space_2 = 2;

cir = num_holes*2*(mag1_hole_d*2); //Changed from +3 to *2
central_r = cir/(3.14159*2);
disk_r = central_r+2;
central_r2 = central_r - mag1_hole_r - mag_space_1 - mag2_hole_r;
central_r3 = central_r2 - mag_space_2 - mag2_hole_d;

coil_w = 5;//(1/8 * in_to_mm = 3.175);
coil_hole_r = mag1_hole_r*3;
coil_hole_d = coil_hole_r*2;
coil_holder_r = mag1_hole_r;
coil_holder_bolt_r = 2;
coil_center_hole_r = 7; //bearing_or+.2;

coil_holder_hull_r = 1;
coil_holder_out_r1 = central_r3-mag1_hole_r-mag2_hole_r-mag_space_2;
coil_holder_out_x1 = coil_holder_out_r1-coil_holder_hull_r/num_holes;
coil_holder_out_y1 = mag1_hole_r-coil_holder_hull_r;
coil_holder_out_r2 = central_r+mag1_hole_d+mag_space_1;
coil_holder_out_x2 = coil_holder_out_r2+mag1_hole_r-coil_holder_hull_r*4;
coil_holder_out_y2 = mag1_hole_r-coil_holder_hull_r;

coil_holder_in_x1 = coil_holder_out_r1+mag1_hole_r+coil_holder_hull_r/2;
coil_holder_in_y1 = mag1_hole_r+coil_holder_hull_r;
coil_holder_in_x2 = coil_holder_out_r2-mag1_hole_r-coil_holder_hull_r*2;
coil_holder_in_y2 = mag1_hole_r+coil_holder_hull_r;
coil_holder_in_len = coil_holder_in_x2 - coil_holder_in_x1 + coil_holder_hull_r*2;
echo(str("coil_holder_in_len:", coil_holder_in_len));

base_d = 100;
base_r = base_d/2;  //central_r + coil_hole_d;
base_w = 3; //bearing_w/1.75
base_l = 70; //3.5 * in_to_mm; 66.4
base_lc = nut_gap + gap + mag2_w + gap + coil_w +gap + mag1_w + gap + coil_w + gap + mag1_w + gap + coil_w + gap + mag2_w + gap + nut_gap;
base_side_h = 15;
alignment_bolt_r = 3.9/2;

axel_h = gap+coil_w+gap;
axel_ir = bearing_ir+.1;
axel_or = coil_center_hole_r-1;

echo(str("sector_degrees:", sector_degrees));
echo(str("coil_w:", coil_w));
echo(str("bearing_w:", bearing_w));
echo(str("mag1_w:", mag1_w));
echo(str("mag1_hole_r:", mag1_hole_r));
echo(str("mag2_hole_r:", mag2_hole_r));
echo(str("coil_hole_r:", coil_hole_r));
echo(str("coil_holder_r:", coil_holder_r));
echo(str("axel_h:", axel_h));
echo(str("axel_ir:", axel_ir));
echo(str("base_lc:", base_lc));

//translate([0,0, mag1_w/2+2]) coilHoldersVisual();
//translate([0,0, -mag1_w]) mag1Disk();
//coilDisk();
//coilHolder();
//baseEndCap();
//baseBottom();
//generatorBase();
//alignmentBoltHoles();
//baseEndCap2();
//baseBottom();
%coilDisk2();
%mag1Disk();
rotate([0,0,sector_degrees/2]) {
    //#hexSupports(w=coil_w*2, supp_w=mag1_hole_d, supp_l=25, radius=central_r2+mag_space_2);
    //%coilDisk2();
    //%mag1Disk();
}
//rotate([0,0,sector_degrees/3]) {
//    %coilDisk2();
//    %mag1Disk();
//}
//rotate([0,0,sector_degrees/1.5]) {
//    %coilDisk2();
//    %mag1Disk();
//}

//translate([0, 0, -coil_w/2])
//rotate_extrude(angle=sector_degrees, convexity = 10)
//translate([central_r3-mag1_hole_r, 0, 0])
//square([23.7, coil_w+3],false);

//#hexSupports(w=coil_w, supp_w=mag1_hole_d, supp_l=25, radius=central_r2+mag_space_2);

////rotate([0,0,(-sector_degrees/(num_holes/2))*$t*num_holes]) {
//rotate([0,0,(-sector_degrees/2)*1]) {    
//outerCoilHolder();
//#innerCoilHolder(w=coil_w+2);
//rotate([0,0,sector_degrees*2]) { 
//    outerCoilHolder();
//    #innerCoilHolder(w=coil_w+2);
//}
//rotate([0,0,sector_degrees*4]) { 
//    outerCoilHolder();
//    #innerCoilHolder(w=coil_w+2);
//}
//rotate([0,0,sector_degrees*6]) { 
//    outerCoilHolder();
//    #innerCoilHolder(w=coil_w+2);
//}
//}

tr=0.0;
//rotate([0,0,(-sector_degrees/(num_holes/2))*$t*num_holes]) {
rotate([0,0,(-sector_degrees/2)*tr*num_holes]) {    
    for(sector = [0 : 2 : sectors]) {
        rotate([0,0,sector_degrees*sector]) { 
            outerCoilHolder();
            #innerCoilHolder(w=coil_w+2);
        }
    }    
}



// Outer coil holder
module outerCoilHolder(w=coil_w) {
    hull() {
        translate([coil_holder_out_x1, -coil_holder_out_y1, 0])
        cylinder(h=w,r=coil_holder_hull_r,center=true);
        translate([coil_holder_out_x2, 0, 0])
        cylinder(h=w,r=mag1_hole_r,center=true);

        rotate([0,0,sector_degrees]) {
        translate([coil_holder_out_x1, coil_holder_out_y1, 0])
        cylinder(h=w,r=coil_holder_hull_r,center=true);
        translate([coil_holder_out_x2, 0, 0])
        cylinder(h=w,r=mag1_hole_r,center=true);
        }
    }
}


// Inner coil holder
module innerCoilHolder(w=coil_w) {
    hull() {
        translate([coil_holder_in_x1, coil_holder_in_y1, 0])
        cylinder(h=w,r=coil_holder_hull_r,center=true);
        translate([coil_holder_in_x2, coil_holder_in_y2, 0])
        cylinder(h=w,r=coil_holder_hull_r,center=true);

        rotate([0,0,sector_degrees]) {
        translate([coil_holder_in_x1, -coil_holder_in_y1, 0])
        cylinder(h=w,r=coil_holder_hull_r,center=true);
        translate([coil_holder_in_x2, -coil_holder_in_y2, 0])
        cylinder(h=w,r=coil_holder_hull_r,center=true);
        }
    }
}




render_mode = "JOE"; //"FULL", "PRINT", "TEST";
print_mode = "COIL"; //"MAG1","MAG2","COIL","BASE", "BOTTOM", "END","AXEL","HOLDERS";

// Main rendering code
if (render_mode=="FULL") {
    renderFull();
} else if (render_mode=="PRINT") {
    renderPrint();
} else if (render_mode=="TEST") {
    renderTest();
}

module renderFull() {
    x_offset_1 = coil_w/2 + gap + mag1_w/2;
    x_offset_2 = x_offset_1 + mag1_w/2 + gap + coil_w/2;
    x_offset_3 = x_offset_2 + coil_w/2 + gap + mag2_w/2;
    z_offset = base_r+base_w/2;
    translate([0,0,0]) {
        // Base
        translate([0,0,0])
            generatorBase();
        
        // Rotating Magnet2 Disk 1
        translate([-x_offset_3,0,z_offset])
            rotate([0,90,0])mag2Disk();
        // Axel
        translate([-x_offset_2,0,z_offset])
            rotate([0,90,0])axel();
        // Coil Disk 1
        translate([-x_offset_2,0,z_offset])rotate([0,90,0])
            coilDisk();
        
        // Rotating Magnet1 Disk 1
        translate([-x_offset_1,0,z_offset])
            rotate([0,90,0])mag1Disk();
        // Axel
        translate([0,0,z_offset])
            rotate([0,90,0])axel();
        // Coil Disk 2
        translate([0,0,z_offset])rotate([0,90,0])
            coilDisk();
        // Rotating Magnet1 Disk 2
        translate([x_offset_1,0,z_offset])
            rotate([0,90,0])mag1Disk();
        
        // Rotating Magnet2 Disk 2
        translate([x_offset_3,0,z_offset])
            rotate([0,90,0])mag2Disk();
        // Axel
        translate([x_offset_2,0,z_offset])
            rotate([0,90,0])axel();
        // Coil Disk 3
        translate([x_offset_2,0,z_offset])rotate([0,90,0])
            coilDisk();
        
    }
}

module renderPrint() {
    if (print_mode=="MAG1") {
        // Magnet Disk1
        mag1Disk();
    } else if (print_mode=="MAG2") {
        // Magnet Disk2
        mag2Disk();
    } else if (print_mode=="COIL") {
        // COIL Disk
        coilDisk();
    } else if (print_mode=="BASE") {
        // Base
        generatorBase();
    } else if (print_mode=="BOTTOM") {
        // Base Bottom
        baseBottom();
    } else if (print_mode=="END") {
        // Base End Cap
        baseEndCap2();
    } else if (print_mode=="AXEL") {
        // Axel
        axel();
    } else if (print_mode=="HOLDERS") {
        // Wire coil holders
        for(x = [-1.5 : 1.5]) {
            translate([x*coil_hole_r*2.1,0,0])coilHolder();
        }
    }
}

module generatorBase(w=base_w, l=base_l) {
    //Bottom
    baseBottom(w, l);
    //End Caps
    translate([l/2-w/2,0,base_r+w/2])rotate([180,-90,0])baseEndCap(w);
    translate([-l/2+w/2,0,base_r+w/2])rotate([0,-90,0])baseEndCap(w);
}

module baseBottom(w=base_w, l=base_l, d=base_d, h=base_side_h) {
    //Bottom
    translate([0,0,0])cube([l, d, w], center=true);
    //Sides
    translate([0,base_r+w/2,h/2-w/2])cube([l, w, h], center=true);
    translate([0,-base_r-w/2,h/2-w/2])cube([l, w, h], center=true);
}

module baseEndCap(w=base_w) {
    b_sup_x = base_d/2+w;
    b_sup_y = (bearing_or+2)*2;
    b_sup_z = bearing_w-2;
    difference() {
        union() {
            cube([base_d, base_d+w*2, w], center=true);
            // bearing support
            translate([-b_sup_x/2,0,b_sup_z/2])
                cube([b_sup_x, b_sup_y, b_sup_z], center=true);
            translate([0,0,b_sup_z/2])
                cylinder(h=b_sup_z,r=b_sup_y/2,center=true);
        }
        
        // remove center hole for bearing
        bearing(pos=[0,0,-1],model=bearingModel,outline=true);
        cylinder(h=w*2,r=bearing_or-1,center=true);
        alignmentBoltHoles(w=w);
    }
    if (render_mode == "FULL") {
        bearing(pos=[0,0,-1],model=bearingModel,outline=false);
    }
}

module baseEndCap2(w=base_w) {
    b_sup_x = base_d/2+w;
    b_sup_y = (bearing_or+2)*2;
    b_sup_z = bearing_w-2;
    difference() {
        union() {
            cube([base_d, base_d+w*2, w], center=true);
            translate([-base_d/2-w/2,0,0])
                cube([w, base_d+w*2, w], center=true);
            // bearing support
//            translate([-b_sup_x/2,0,b_sup_z/2])
//                cube([b_sup_x, b_sup_y, b_sup_z], center=true);
            translate([0,0,b_sup_z/2])
                cylinder(h=b_sup_z,r=b_sup_y/2,center=true);
        }
        
        // remove center hole for bearing
        bearing(pos=[0,0,-1],model=bearingModel,outline=true);
        cylinder(h=w*2,r=bearing_or-1,center=true);
        alignmentBoltHoles(w=w);
    }
    if (render_mode == "FULL") {
        bearing(pos=[0,0,-1],model=bearingModel,outline=false);
    }
}


// Stationary Disk with coils
module coilDisk(w=coil_w, wires=true) {
    x = base_d-1.5;
    y = x;
    small_hole_r = 1;
    small_hole_or = central_r+coil_hole_r;
    // Disk
    difference() {
        //main structure
        cube([x, y, w], center=true);
        // remove holes for coils
        coilHolderHoles();
        // remove center hole for bearing
        cylinder(h=w*2,r=coil_center_hole_r,center=true);
        // remove holes for wires
        if (wires == true) {
            wireChannelsStraight();
            structureHoles(w=w,radius=small_hole_or, hole_r=small_hole_r);
        }
        alignmentBoltHoles(w=w);
    }
}

// Stationary Disk with trap coils
module coilDisk2(w=coil_w, wires=true) {
    x = base_d-1.5;
    y = x;
    small_hole_r = 1;
    small_hole_or = central_r+coil_hole_r;
    // Disk
    difference() {
        //main structure
        //cylinder(h=w,r=disk_r,center=true);
        cube([x, y, w], center=true);
        //remove trap for coils
        //rotate([0,0,30])
        #hexSupports(w=coil_w*2, supp_w=mag1_hole_d, supp_l=25, radius=central_r2+mag_space_2);
        // remove center hole for bearing
        cylinder(h=w*2,r=coil_center_hole_r,center=true);
        // remove holes for wires
        if (wires == true) {
            wireChannelsStraight();
            structureHoles(w=w,radius=small_hole_or, hole_r=small_hole_r);
        }
        alignmentBoltHoles(w=w);
    }
}

//alignment_bolt_r
module alignmentBoltHoles(w=coil_w, r=alignment_bolt_r, i=10) {
    translate([base_r-i,base_r-i,0])cylinder(h=w*2,r=r,center=true);
    translate([-base_r+i,base_r-i,0])cylinder(h=w*2,r=r,center=true);
    translate([base_r-i,-base_r+i,0])cylinder(h=w*2,r=r,center=true);
    translate([-base_r+i,-base_r+i,0])cylinder(h=w*2,r=r,center=true);
}

module wireChannelsStraight() {
    radius = central_r;
    sectors = num_holes/2;
    degrees = 360 / sectors;
    cyl_h = radius*(12/num_holes)-2;
    
    for(sector = [1 : sectors]) {
        angle = degrees * sector;
        x_pos = radius * sin(angle);
        y_pos = radius * cos(angle);
        x_off = (coil_hole_r) * cos(angle);
        y_off = (coil_hole_r) * sin(angle);
        cross_angle_1 = degrees/2-(angle+90);
        cross_angle_2 = degrees/2-(angle+degrees-90);
        rotate([0,0,degrees/2]) {
            translate([x_pos+y_off,y_pos+x_off,coil_w/2]){
                rotate([90,0,cross_angle_1])cylinder(h=cyl_h,r=coil_w/4,center=false);
            }
        }
        rotate([0,0,degrees/2]) {
            translate([x_pos+y_off,y_pos+x_off,coil_w/2]){
                rotate([90,0,cross_angle_2])cylinder(h=cyl_h,r=coil_w/4,center=false);
            }
        }
    }    
}

// Rotating Disk with magnets #1
module mag1Disk(w=mag1_w) {
    border = mag1_hole_r*1.5;
    mag1_disk_r = central_r + border;
    
    // Disk
    difference() {
        cylinder(h=w,r=mag1_disk_r,center=true);
        //remove holes for outer magnets
        holes(w*2, mag1_hole_r+eps);
        //remove holes for center magnets
        holes(w*2, mag2_hole_r+eps, radius=central_r2);
        //remove holes for inner magnets
        holes(w*2, mag2_hole_r+eps, radius=central_r3);
        //remove hole for main axel
        cylinder(h=w*2,r=axel_ir,center=true);
    }
}

// Rotating Disk with magnets #2
module mag2Disk(w=mag2_w) {
    border = mag2_hole_r*2;
    mag2_disk_r = central_r + border;
    
    // Disk
    difference() {
        cylinder(h=w,r=mag2_disk_r,center=true);
        //remove holes for outer magnets
        holes(w*2, mag2_hole_r+eps);
        //remove hole for main axel
        cylinder(h=w*2,r=axel_ir,center=true);
    }
}

// Coil Holders Visual
module coilHoldersVisual(w=coil_w) {
    step = 0;
    step_inc = (180/num_holes);
    rot = step_inc*step;
    rotate([0,0,rot]) {
        coilHolders();
    }
}

module coilHolders(radius=central_r) {
    sectors = num_holes/2;
    sector_degrees = 360 / sectors;
    for(sector = [1 : sectors]) {
        angle = sector_degrees * sector;
        x_pos = radius * sin(angle);
        y_pos = radius * cos(angle);
        translate([x_pos,y_pos,0]){
            #coilHolder(top=false);
        }
    }    
}

module coilHolderHoles(radius=central_r) {
    sectors = num_holes/2;
    sector_degrees = 360 / sectors;
    for(sector = [1 : sectors]) {
        angle = sector_degrees * sector;
        x_pos = radius * sin(angle);
        y_pos = radius * cos(angle);
        translate([x_pos,y_pos,0]){
            coilHolderHole();
        }
    }    
}

module coilHolderHole() {
    cylinder(h=coil_w+2,r=coil_hole_r+.1,center=true);
}

// Coil Holder
module coilHolder(h1=.65, h2=coil_w, r1=coil_hole_r, r2=coil_holder_r, top=true) {
    r1e = r1-.2;
    r2e = r2+1;
    if (top == true) {
        translate([0,-r1-1,0])
            coilHolderBot(h1,h2,r1e,r2e);
        translate([0,r1+1,0])rotate([180,0,0])
            coilHolderTop(h1,r1e);
    } else {
        coilHolderBot(h1,h2,r1e,r2e);
    }
}

module coilHolderBot(h1,h2,r1,r2) {
    wire_holder_r = 1;
    difference() {
        union() {
            //Base
            cylinder(h=h1,r=r1,center=false);
            //Post
            cylinder(h=h2-h1,r=r2,center=false);
        }
        //remove bolt hole
        translate([0,0,-h2/2])cylinder(h=h2*2,r=coil_holder_bolt_r,center=false);
        //remove wire holder hole
        translate([0,r1-wire_holder_r/2,0])rotate([0,0,0])
            cylinder(h=h1*4,r=wire_holder_r,center=true);
    }
}

module coilHolderTop(h1,r1) {
    rotate([180,0,0]) {
        difference() {
            //Base
            cylinder(h=h1,r=r1,center=false);
            //remove hole for bolt
            cylinder(h=h1*3,r=coil_holder_bolt_r,center=true);
        }
    }
}

module axel() {
    hollowCyl(h=axel_h,or=axel_or,ir=axel_ir);
}

module hollowCyl(h,or,ir) {
    difference() {
        cylinder(h=h,r=or,center=true);
        cylinder(h=h*2,r=ir,center=true);
    }
}

module holes(w, hole_r, radius=central_r) {
    //radius = central_r;
    sectors = num_holes;
    sector_degrees = 360 / sectors;

    for(sector = [1 : sectors]) {
        angle = sector_degrees * sector;
        x_pos = radius * sin(angle);
        y_pos = radius * cos(angle);
        translate([x_pos,y_pos,0]){
            hole(w, hole_r);
        }
    }    
}

module structureHoles(w, radius, hole_r, sectors=num_holes) {
    sector_degrees = 360 / sectors;
    for(sector = [1 : sectors]) {
        angle = sector_degrees * sector;
        x_pos = radius * sin(angle);
        y_pos = radius * cos(angle);
        translate([x_pos,y_pos,0]){
            hole(w, hole_r);
        }
    }    
}

module hole(w, hole_r) {
    cylinder(h=w+2,r=hole_r,center=true);
}

module trapCoilHolderBase() {
    cylinder(coil_w,r=central_r,center=true);
}

module hexSupports(w=coil_w, supp_w, supp_l=24, radius=disk_r) {
    // Create supports for bearing holder
    sectors = num_holes;
    sector_degrees = 360 / sectors;

    for(sector = [1 : sectors]) {
        angle = sector_degrees * sector;
        x_pos = radius * sin(angle);
        y_pos = radius * cos(angle);
        translate([x_pos,y_pos,0]){
            rotate([0,0,-angle])cube([supp_w,supp_l,w], center=true);
        }
    }    
}

module hexSupports2(w=coil_w, supp_w, supp_l=24, radius=disk_r) {
    // Create supports for bearing holder
    sectors = num_holes;
    sector_degrees = 360 / sectors;

    for(sector = [1 : 2]) {
        angle = sector_degrees * sector;
        x_pos = radius * sin(angle);
        y_pos = radius * cos(angle);
        translate([x_pos,y_pos,0]){
            rotate([0,0,-angle])cube([supp_w,supp_l,w], center=true);
        }
    }    
}

module renderTest() {
    translate([0,0,1]) {
        difference() {
            translate([6,0,0])cube([42,30,2], center=true);
            
            //Big Magnet hole
            translate([-10,-10,0])hole(mag1_w, mag1_hole_r+eps); 

            //Coil hole
            translate([0,0,0])coilHolderHole();
            
            //Small Magnet hole
            translate([10,10,0])hole(mag2_w, mag2_hole_r+eps); 
            
            //Alignment bolt hole
            translate([-10,10,0])hole(base_w, alignment_bolt_r);
            
            //Coil Center Hole
            translate([18,0,0])hole(coil_w, coil_center_hole_r);
        }
    }
    translate([38,0,0])coilHolder();
    translate([-23,0,axel_h/2])axel();
}
