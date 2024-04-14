include <MCAD/bearing.scad>

// ---------------------------
// Constants
// ---------------------------
$fa = 1;
$fs = 0.4;
in_to_mm = 25.4;
gap = 1.25; //1/32 * in_to_mm;
nut_gap = 7;//3/4 * in_to_mm;
eps = .15;

bearingModel = 608; //608
bearing_w = bearingWidth(bearingModel);
bearing_or = bearingOuterDiameter(bearingModel)/2;
bearing_ir = bearingInnerDiameter(bearingModel)/2;


// ---------------------------
// Variables
// ---------------------------
num_holes=8;
sectors = num_holes;
sector_degrees = 360 / sectors;

mag1_hole_d = (4/8 * in_to_mm);
mag1_hole_r = (mag1_hole_d/2);
mag1_w = 5;//1/4 * in_to_mm;

mag2_hole_d = (2/8 * in_to_mm);
mag2_hole_r = (mag2_hole_d/2);
mag2_w = 1/4 * in_to_mm;

mag3_hole_d = (1/8 * in_to_mm);
mag3_hole_r = (mag3_hole_d/2);
mag3_w = 1/4 * in_to_mm;

mag_space_1 = 4;
mag_space_2 = 4;

cir = num_holes*2*4;//num_holes*2*(mag1_hole_d-mag_space_2/2);
temp_r = cir/(3.14159*2);
min_r = bearing_or + mag1_hole_d + mag2_hole_d;// + mag_space_2+3;
central_r3 = max(temp_r, min_r);
central_r2 = central_r3 + mag3_hole_r + mag_space_2 + mag2_hole_r;
central_r = central_r2 + mag2_hole_r + mag_space_1 + mag1_hole_r;
disk_r = central_r+2;

coil_cap_w = .6;
coil_w = bearing_w-1;//5;//(1/8 * in_to_mm = 3.175);
coil_hole_r = mag1_hole_r*3;
coil_hole_d = coil_hole_r*2;
coil_holder_r = mag1_hole_r;
coil_holder_bolt_r = 2;
coil_holder_top_insert_h = 1;
coil_holder_inner_shell_t = 2;
coil_holder_center_cyl_t = 1.5;
coil_center_hole_r = bearing_or+eps; //7

coil_holder_hull_r = 1;
wire_size = 2.5;//mag1_hole_r-5;
coil_holder_out_r1 = central_r3-wire_size;//-mag2_hole_r;
coil_holder_out_x1 = coil_holder_out_r1-coil_holder_hull_r/num_holes;
coil_holder_out_y1 = wire_size-coil_holder_hull_r;
coil_holder_out_r2 = central_r+mag1_hole_d+mag_space_1;
coil_holder_out_x2 = coil_holder_out_r2;
coil_holder_out_y2 = wire_size-coil_holder_hull_r;

coil_holder_in_x1 = coil_holder_out_r1+wire_size*2+coil_holder_hull_r/2;
coil_holder_in_y1 = wire_size+coil_holder_hull_r;
coil_holder_in_x2 = coil_holder_out_r2-wire_size-coil_holder_hull_r*2;
coil_holder_in_y2 = wire_size+coil_holder_hull_r;
coil_holder_in_len = coil_holder_in_x2 - coil_holder_in_x1 + coil_holder_hull_r*2;
echo(str("coil_holder_in_len:", coil_holder_in_len));

base_d = 150;
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
echo(str("disk_r:", disk_r));

render_mode = "JOE"; //"FULL", "PRINT", "TEST";
print_mode = "MAG1"; //"MAG1","COIL","HOLDERS","BASE";

//%translate([0,0,10])coilDisk(diskNum=1, bearing=true);
//printCoilHolderTopAndBot();

//square([30,10], center=true);
bar_mag_length = 30;
bar_mag_width = 10;
bar_mag_depth = 5;

border = mag1_hole_r;
//mag1_disk_r = 85; //central_r + border+16.5;  //For 16 mags
//mag1_disk_r = 75; //central_r + border+16.5;  //For 12 mags
mag1_disk_r = 62; //central_r + border+5;       //For 8 mags
coil_wire_w = 10;
coil_inner_r = 1;

rotate([0,0,0])
barMagDisk();
translate([0,0,30])rotate([0,0,sector_degrees/2]) {
    #barMagCoilHolderArray();
    %rotate([0,0,22.5])barMagCoilDisk(bearing=true);
}

//%barMagCoilHolderDiff();
//%rotate([0,0,90])barMagCoilHolderDiff();
//barMagCoilHolderOuterHull();
//barMagCoilHolderInnerHull();

//%rotate([0,0,0])translate([0,0,15])barMagDisk();
//%coilHoldersVisual();

// Disks
// Stationary Disk with trapezoid coils
module barMagCoilDisk(w=coil_w, diskNum=1, wires=true, bearing=false) {
    small_hole_r = 1;
    small_hole_or = base_d/2 - border/2;
    // Disk
    difference() {
        //main structure
        cylinder(h=w,r=base_d/2,center=true);
        //remove trapezoids for coils
        rotate([0,0,(-sector_degrees/2)*diskNum]) {
            translate([0,0,-w])barMagCoilHolderOuterArray(z=20);
        }
        // remove center hole for bearing
        cylinder(h=w*2,r=coil_center_hole_r,center=true);
        // remove holes for wires
        if (wires == true) {
            rotate([0,0,22.5])structureHoles(w=w,radius=small_hole_or, hole_r=small_hole_r);
            structureHoles(w=w,radius=small_hole_or-2, hole_r=small_hole_r+1);
        }
        alignmentBoltHoles(w=w);
    }
    if (bearing == true) {
        translate([0, 0, -bearing_w/2])
        bearing(model=bearingModel, outline=false);
    }
}



module barMagDisk(w=mag1_w) {
    difference() {
        cylinder(h=w,r=mag1_disk_r,center=true);
        //remove holes for bar magnets
        barMagHoles(mag1_disk_r, border);
        //remove hole for main axel
        cylinder(h=w*2,r=axel_ir,center=true);
    }
}

module barMagHoles(r,b,x=30,y=10,z=20) {
    sectors = num_holes;
    sector_degrees = 360 / sectors;
    for(sector = [1 : sectors]) {
        angle = sector_degrees * sector;
        rotate([0,0,angle])barMagHole(r,b,x,y,z);
    }    
}

module barMagHole(r,b,x=30,y=10,z=20) {
    translate([r-(x/2)-b,0,0])cube([x, y, z], center=true);
}

module barMagCoilHolderArray() {
    sectors = num_holes;
    sector_degrees = 360 / sectors*2;
    for(sector = [1 : sectors]) {
        angle = sector_degrees * sector;
        rotate([0,0,angle])barMagCoilHolderDiff();
    }    
}

module barMagCoilHolderDiff() {
    difference() {
        barMagCoilHolderOuterHull();
        barMagCoilHolderInnerHull();
    }
}

module barMagCoilHolderOuterArray(z=20) {
    sectors = num_holes;
    sector_degrees = 360 / sectors*2;
    for(sector = [1 : sectors]) {
        angle = sector_degrees * sector;
        rotate([0,0,angle])barMagCoilHolderOuterHull(z=z);
    }    
}

module barMagCoilHolderOuterHull(z=10) {
    hull() {
        barMagCoilOutlines(r=mag1_disk_r, b=border, z=z);
    }
}
module barMagCoilOutlines(r,b,x=30,y=coil_wire_w,z=10) {
    sectors = num_holes;
    sector_degrees = 360 / sectors;
    for(sector = [1 : 0.25 : 2]) {
        angle = sector_degrees * sector;
        rotate([0,0,angle])barMagCoilOut(r,b,x,y,z);
    }    
}

module barMagCoilOut(r,b,x=30,y=coil_wire_w,z=10) {
    offset = x/2 + y/2+coil_inner_r;
    translate([r-(x/2)-b,0,0]){
        translate([offset,0,0])cylinder(h=z,r=y/2,center=true);
        cube([x, y, z], center=true);
        translate([-offset,0,0])cylinder(h=z,r=y/2,center=true);
    }
}


module barMagCoilHolderInnerHull() {
    hull() {
        barMagCoilInlines(mag1_disk_r, border);
    }
}

module barMagCoilInlines(r,b,x=30,y=coil_wire_w,z=20) {
    sectors = num_holes;
    sector_degrees = 360 / sectors;
    for(sector = [1 : 0.5 : 2]) {
        angle = sector_degrees * sector;
        rotate([0,0,angle])barMagCoilIn(r,b,sector,x,y,z);
    }    
}

module barMagCoilIn(r,b,sector,x=30,y=coil_wire_w,z=20) {
    x_off = x/2;
    y_off = y/2 + coil_inner_r;
    translate([r-(x/2)-b,0,0]){
        if (sector == 1) {
            translate([x_off,y_off,0])cylinder(h=z,r=coil_inner_r,center=true);
            translate([0,y_off,0])cube([x, coil_inner_r*2, z], center=true);
            translate([-x_off,y_off,0])cylinder(h=z,r=coil_inner_r,center=true);
        } else if (sector == 2) {
            translate([x_off,-y_off,0])cylinder(h=z,r=coil_inner_r,center=true);
            translate([0,-y_off,0])cube([x, coil_inner_r*2, z], center=true);
            translate([-x_off,-y_off,0])cylinder(h=z,r=coil_inner_r,center=true);
        } else {
            translate([x_off,y_off,0])cylinder(h=z,r=coil_inner_r,center=true);
            translate([x_off,-y_off,0])cylinder(h=z,r=coil_inner_r,center=true);
        }
    }
}



// Main rendering code
if (render_mode=="FULL") {
    renderFull();
} else if (render_mode=="PRINT") {
    renderPrint();
} else if (render_mode=="TEST") {
    renderTest();
}

module renderFull() {
    rotate([-90,0,90]) {
        // Coil Disk
        coilDisk(diskNum=1, bearing=true);
        // Base
        //base();
        // Rotating Magnet Disks
        z_offset = (mag1_w + bearing_w)/2;
        inv_num_holes = 1/num_holes;
        tmp_t = inv_num_holes*2; //0=blue, 1=white, 2=yellow, 3=green
        // For animate use: fps=1, steps=12
        rotate([0,0,(-sector_degrees/(num_holes/2))*$t*num_holes]) {
            translate([0,0,z_offset])
            %barMagDisk();
            translate([0,0,-z_offset])
            %barMagDisk();
        }

        // Coil Holders - Yellow
        tr1=1;//3/num_holes;//0.0;//0.125;
        color("yellow", 1.0) {
            rotate([0,0,(-sector_degrees/2)*tr1]) {
                translate([0,0,-coil_w/2])coilHoldersVisual();
            }
        }
//    tr2=0.5;
//    color( "white", 1.0 ) {
//        rotate([0,0,(-sector_degrees/2)*tr2]) {
//            coilHoldersVisual();
//        }
//    }
//    tr3=1.5;
//    color( "green", 1.0 ) {
//        rotate([0,0,(-sector_degrees/2)*tr3]) {
//            coilHoldersVisual();        
//        }
//    }
//    tr4=2;
//    color( "blue", 1.0 ) {
//        rotate([0,0,(-sector_degrees/2)*tr4]) {    
//            coilHoldersVisual();    
//        }
//    } 
    }
}

module renderPrint() {
    if (print_mode=="MAG1") {
        // Magnet Disk1
        mag1Disk();
    } else if (print_mode=="COIL") {
        // COIL Disk
        if (num_holes==12) {
            coilDisk(diskNum=3);
        } else {
            coilDisk();
        }
    } else if (print_mode=="HOLDERS") {
        // Wire coil holders
        printCoilHolderTopAndBot();
    } else if (print_mode=="BASE") {
        // Base
        basePrint();
    }
}

// ---------------------------------------
// Stationary Coil Disk Modules
// ---------------------------------------

// Stationary Disk with trapezoid coils
module coilDisk(w=coil_w, diskNum=1, wires=true, bearing=false) {
    x = base_d-1.5;
    y = x;
    small_hole_r = 1;
    small_hole_or = central_r+mag1_hole_d+coil_hole_r-5;
    // Disk
    difference() {
        //main structure
        //cube([x, y, w], center=true);
        cylinder(h=w,r=base_d/2,center=true);
        //remove trapezoids for coils
        rotate([0,0,(-sector_degrees/2)*diskNum]) {
            //translate([0,0,-w])coilHoldersOutline(w=w*2,offset_r=eps);
            translate([0,0,-w])barMagCoilHolderOuterHull();
        }
        // remove center hole for bearing
        cylinder(h=w*2,r=coil_center_hole_r,center=true);
        // remove holes for wires
        if (wires == true) {
            //wireChannelsStraight();
            structureHoles(w=w,radius=small_hole_or, hole_r=small_hole_r);
        }
        alignmentBoltHoles(w=w);
    }
    if (bearing == true) {
        translate([0, 0, -bearing_w/2])
        bearing(model=bearingModel, outline=false);
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
    radius = central_r+mag1_hole_d;
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

// ---------------------------------------
// Rotating Magnet Disk Modules
// ---------------------------------------

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
        holes(w*2, mag3_hole_r+eps, radius=central_r3);
        //remove hole for main axel
        cylinder(h=w*2,r=axel_ir,center=true);
    }
}


// Rotating Disk with magnets #1
module mag1Disk_old(w=mag1_w) {
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
        holes(w*2, mag3_hole_r+eps, radius=central_r3);
        //remove hole for main axel
        cylinder(h=w*2,r=axel_ir,center=true);
    }
}


// ---------------------------------------
// Coil Holder Modules
// ---------------------------------------

module printCoilHolderTopAndBot() { 
    centerCoilHolder() {
        coilHolderBottom();
    }    
    translate([0,-coil_holder_center_r-2,0])rotate([0,0,180]){
        centerCoilHolder() {
            coilHolderTop();
        }    
    }
}

module centerCoilHolder() { 
    angle = 90-(sector_degrees/2);
    radius = coil_holder_center_r;
    x_pos = radius * sin(angle);
    y_pos = radius * cos(angle);

    translate([-x_pos,-y_pos,0]) children(); 
}

module coilHolderBottom() {
    h=coil_w-coil_cap_w;
    difference() {
        union() {
            coilHolderCap(holes=true);
            innerCoilHolderShell(h=h);
            coilHolderCenterCylinder(h=h);
        }
        coilHolderCenterBoltHole();
    }
}

module innerCoilHolderShell(h=coil_w) {
    linear_extrude(height=h, slices=10) {
        difference() {
            innerCoilHolder2d();
            offset(r=-coil_holder_inner_shell_t) {
                innerCoilHolder2d();
            }
        }
    }
}

module coilHolderTop() {
    difference() {
        union() {
            coilHolderCap();
            coilHolderTopInsert();
        }
        coilHolderCenterCylinder(t=coil_holder_center_cyl_t+eps,z=coil_cap_w);
        coilHolderCenterBoltHole();
    }
}

module coilHolderTopInsert(h=coil_holder_top_insert_h, z=coil_cap_w) {
    translate([0,0,z]) {
        linear_extrude(height=h, slices=1) {
            offset(r=-(coil_holder_inner_shell_t+eps)) {
                innerCoilHolder2d();
            }
        }
    }
}

module coilHolderCap(w=coil_cap_w, holes=false) {
    translate([0,0,w/2])outerCoilHolder(w=w, holes=holes);
}

module coilHolderCenterCylinder(h=coil_w, r=coil_holder_bolt_r, t=coil_holder_center_cyl_t, z=0) {
    rotate([0,0,(sector_degrees/2)])
        translate([coil_holder_center_r,0,z]) 
            cylinder(h=h,r=r+t);
}

module coilHolderCenterBoltHole() {
    coilHolderCenterCylinder(h=coil_w*3,t=eps,z=-coil_w);
}

// Coil Holders Visual
module coilHoldersVisual(w=coil_w) {
    for(sector = [0 : 2 : sectors]) {
        rotate([0,0,sector_degrees*sector]) { 
            outerCoilHolder(w=w);
            #translate([0,0,w/2])innerCoilHolder(w=w+2);
        }
    }    
}

module coilHoldersOutline(w=coil_w, offset_r=0) {
    for(sector = [0 : 2 : sectors]) {
        rotate([0,0,sector_degrees*sector]) { 
            outerCoilHolder(w=w,offset_r=offset_r);
        }
    }    
}

// Outer coil holder
module outerCoilHolder(w=coil_w, offset_r=0, holes=false) {
    difference() {
        linear_extrude(height=w, slices=1) {
            offset(r=offset_r) {
                outerCoilHolder2d();
            }
        }
        if (holes == true) {
            translate([coil_holder_out_x2+mag1_hole_r/1.1, 0, 0])
            cylinder(h=w*2,r=1,center=true);
            rotate([0,0,sector_degrees]) {
                translate([coil_holder_out_x2, 0, 0])
                cylinder(h=w*2,r=1,center=true);
            }
            
        }
    }
}

module outerCoilHolder2d(w=coil_w, offset_r=0) {
    hull() {
        translate([coil_holder_out_x1, -coil_holder_out_y1, 0])
        circle(r=coil_holder_hull_r);
        translate([coil_holder_out_x2, 0, 0])
        circle(r=mag1_hole_r);

        rotate([0,0,sector_degrees]) {
            translate([coil_holder_out_x1, coil_holder_out_y1, 0])
            circle(r=coil_holder_hull_r);
            translate([coil_holder_out_x2, 0, 0])
            circle(r=mag1_hole_r);
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

// Inner coil holder 2D
module innerCoilHolder2d() {
    hull() {
        translate([coil_holder_in_x1, coil_holder_in_y1, 0])
        circle(r=coil_holder_hull_r);
        translate([coil_holder_in_x2, coil_holder_in_y2, 0])
        circle(r=coil_holder_hull_r);

        rotate([0,0,sector_degrees]) {
        translate([coil_holder_in_x1, -coil_holder_in_y1, 0])
        circle(r=coil_holder_hull_r);
        translate([coil_holder_in_x2, -coil_holder_in_y2, 0])
        circle(r=coil_holder_hull_r);
        }
    }
}

// ---------------------------------------
// Base Related Modules
// ---------------------------------------

module basePrint(base_sup_x = 19, base_sup_y = 18) {
    base_x = base_d+10;
    base_y = coil_w*1.25;
    base_yo = base_r+base_y/2-1;
    w = coil_w + eps*3;
    rotate([-90,0,90])translate([0,-base_yo,0]) {
        base(base_sup_x=base_sup_x, base_sup_y=base_sup_y);
    }
}

module base(base_sup_x = 19, base_sup_y = 18) {
    base_x = base_d+10;
    base_y = coil_w*1.25;
    base_yo = base_r+base_y/2-1;
    w = coil_w + eps*3;
    difference() {
        baseStructure(base_sup_x=base_sup_x, base_sup_y=base_sup_y);
        // Remove COIL Disk
        if (num_holes==12) {
            coilDisk(w=w, diskNum=3);
        } else {
            coilDisk(w=w);
        }
        alignmentBoltHoles(w=w*2,r=alignment_bolt_r+eps);
    }
}

module baseStructure(base_sup_x=19, base_sup_y=18) {
    base_x = base_d+10;
    base_y = coil_w*1.25;
    base_yo = base_r+base_y/2-1;
    base_z = coil_w*7;
    base_sup_xo = (base_x-base_sup_x)/2-2;
    base_sup_yo = base_yo - base_sup_y/2;
    base_sup_z = coil_w*3;
    translate([0,base_yo,0])
    cube([base_x,base_y,base_z], center=true);
    translate([base_sup_xo,base_sup_yo,0])
    cube([base_sup_x,base_sup_y,base_sup_z], center=true);
    translate([-base_sup_xo,base_sup_yo,0])
    cube([base_sup_x,base_sup_y,base_sup_z], center=true);
}

// ---------------------------------------
// Common Modules
// ---------------------------------------

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
    for(sector = [1 : 1 : sectors]) {
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


// ---------------------------------------
// Test Print Module
// ---------------------------------------

module renderTest() {
    translate([0,0,coil_w/2]) {
        difference() {
            translate([0,5,0])cube([50,50,coil_w], center=true);
            
            //Big Magnet hole
            translate([20,25,0])hole(mag1_w, mag1_hole_r+eps); 

            //Small Magnet hole
            translate([20,15,0])hole(mag2_w, mag2_hole_r+eps); 
            
            //Bearing hole
            translate([-15,20,0])
            cylinder(h=bearing_w*2,r=coil_center_hole_r,center=true);
            
            //CoilHolder
            centerCoilHolder() {
                translate([0,0,-coil_w])outerCoilHolder(w=coil_w*2,offset_r=eps);
            }    
        }
    }
}
