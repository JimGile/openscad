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
bearing_depth = bearingWidth(bearingModel);
bearing_or = bearingOuterDiameter(bearingModel)/2;
bearing_ir = bearingInnerDiameter(bearingModel)/2;
axel_ir = bearing_ir+.1;
alignment_bolt_r = 3.9/2;


// ---------------------------
// Variables
// ---------------------------
num_holes=12;
sectors = num_holes;
sector_degrees = 360 / sectors;

mag2_hole_d = (2/8 * in_to_mm);
mag2_hole_r = (mag2_hole_d/2);
mag2_depth = 1/4 * in_to_mm;

// Bar Magent values
bar_mag_length = 29.2;//29.2;
bar_mag_width = 9.4;//9.4;
bar_mag_depth = 5;//5;
border = 3;

// Coil related values
coil_wire_width = bar_mag_width;
coil_inner_r = 1;
coil_center_hole_r = bearing_or+eps;

// Calculated values
bar_mag_cir = num_holes*bar_mag_width*1.15;
bar_mag_disk_r = round(bar_mag_cir/(3.14159*2)+bar_mag_length+border/2);
bar_mag_disk_depth = bar_mag_depth;
//coil_disk_r = round(bar_mag_disk_r + coil_wire_width + border);
coil_disk_r = round(bar_mag_disk_r + alignment_bolt_r*3 + border);
coil_disk_depth = 5; //bearing_depth;
coil_disk_base = .6;

//Print values
echo(str("num_holes:", num_holes));
echo(str("bearing_depth:", bearing_depth));
echo(str("sector_degrees:", sector_degrees));
echo(str("bar_mag_disk_r:", bar_mag_disk_r));
echo(str("bar_mag_disk_depth:", bar_mag_disk_depth));
echo(str("mag2_depth:", mag2_depth));
echo(str("coil_disk_r:", coil_disk_r));
echo(str("coil_disk_depth:", coil_disk_depth));

//%rotate([0,0,sector_degrees*2])translate([0,0,6.6])barMagCoilHolderBottom();
//%translate([0,0,0])barMagCoilHolderInnerAnchorArray();
//barMagCoilHolderOuterHull();
//barMagCoilOutlines(r=bar_mag_disk_r,b=border,y=coil_wire_width,z=10);
//barMagCoilHolderInnerAnchor();
//barMagCoilInlines(bar_mag_disk_r,border,z=5);
render_mode = "PRINT"; //"FULL", "PRINT", "TEST";
print_mode = "COIL_DISK"; //"MAG_DISK","COIL_DISK","HOLDER_TOP","HOLDER_BOT";

// Main rendering code
if (render_mode=="FULL") {
    renderFull();
} else if (render_mode=="PRINT") {
    renderPrint();
} else if (render_mode=="TEST") {
    renderTest();
}

module renderFull() {
    // Coil Disk
    //#barMagCoilHolderArray();
    barMagCoilDisk(bearing=true);
    
    // Rotating Magnet Disks (animate use: fps=1, steps=12)
    z_offset = (bar_mag_disk_depth + bearing_depth)/2 +1;
    rotate([0,0,sector_degrees*$t]) {
        translate([0,0,z_offset])
        %barMagDisk();
        translate([0,0,-z_offset])
        %barMagDisk();
    }
}

module renderPrint() {
    if (print_mode=="MAG_DISK") {
        // Magnet Disk1
        barMagDisk();
    } else if (print_mode=="COIL_DISK") {
        // COIL Disk
        barMagCoilDisk();
    } else if (print_mode=="HOLDER_TOP") {
        // Wire coil holder top and cap
        // Only need one set of these for winding the coils
        barMagCoilHolderTop();
        rotate([0,0,90])barMagCoilHolderCap();
    } else if (print_mode=="HOLDER_BOT") {
        // Wire coil holder bottom
        barMagCoilHolderBottom();
    }
}

// ---------------------------------------
// Rotating Bar Magnet Disk Modules
// ---------------------------------------

// Bar Magnet Disk
module barMagDisk(h=bar_mag_depth) {
    difference() {
        cylinder(h=h,r=bar_mag_disk_r,center=true);
        //remove holes for bar magnets
        translate([0,0,coil_disk_base])barMagHoles(bar_mag_disk_r, border);
        //remove holes for 1/2 bar magnets
        //rotate([0,0,180/num_holes])
            //barMagHoles2(bar_mag_disk_r, border);
        //remove hole for main axel
        cylinder(h=h*2,r=axel_ir,center=true);
    }
}

module barMagHoles(r,b,x=bar_mag_length,y=bar_mag_width,z=bar_mag_depth) {
    sectors = num_holes;
    sector_degrees = 360 / sectors;
    for(sector = [1 : sectors]) {
        angle = sector_degrees * sector;
        rotate([0,0,angle]) {
            barMagHole(r,b,x,y,z);
            //roundMagHole(r,b,x,y,h=z,hole_r=mag2_hole_r+.125);
        }
    }    
}

module barMagHoles2(r,b,x=bar_mag_length/2.5,y=bar_mag_width,z=20) {
    sectors = num_holes;
    sector_degrees = 360 / sectors;
    for(sector = [1 : sectors]) {
        angle = sector_degrees * sector;
        rotate([0,0,angle]) {
            barMagHole(r,b,x,y,z);
            //roundMagHole(r,b,x,y,h=z,hole_r=mag2_hole_r+.125);
        }
    }    
}

module barMagHole(r,b,x=bar_mag_length,y=bar_mag_width,z=20) {
    translate([r-(x/2)-b,0,0])cube([x, y, z], center=true);
}

module roundMagHole(r,b,x=bar_mag_length,y=bar_mag_width,h=20,hole_r=mag2_hole_r) {
    x_off = r-(x/5)-b;
    y_off = y/2 + hole_r*1.5;//(y)/2 + r;
    translate([x_off,y_off,0])cylinder(h=h,r=hole_r,center=true);
    translate([x_off,-y_off,0])cylinder(h=h,r=hole_r,center=true);
}




// ---------------------------------------
// Stationary Coil Disk Modules
// ---------------------------------------

// Stationary Bar Mag Coil Disk with trapezoid coils
module barMagCoilDisk(h=coil_disk_depth, bearing=false) {
    anchor_z = 2+coil_disk_base;
    anchor_offest_z = (h-anchor_z)/2;
    //hole_or = bar_mag_disk_r + (coil_disk_r-bar_mag_disk_r)/1.5;
    hole_or = coil_disk_r-alignment_bolt_r*2;
    // Disk
    difference() {
        //main structure
        cylinder(h=h,r=coil_disk_r,center=true);
        //remove trapezoids for coils
        translate([0,0,coil_disk_base])barMagCoilHolderOuterArray(z=h);
        //translate([0,0,coil_disk_base])barMagCoilHolderArray(z=h);
        // remove center hole for bearing
        cylinder(h=h*2,r=coil_center_hole_r,center=true);
        // remove outer alignment holes
        structureHoles(h=h,radius=hole_or,hole_r=alignment_bolt_r,sectors=num_holes/2);
        // remove wire channels
        wireChannels(h=h,radius=hole_or,hole_r=alignment_bolt_r,sectors=num_holes);
    }
    translate([0,0,-anchor_offest_z])barMagCoilHolderInnerAnchorArray(z=anchor_z);
    if (bearing == true) {
        translate([0, 0, -bearing_depth/2])
        bearing(model=bearingModel, outline=false);
    }
}


// ---------------------------------------
// Coil Holder Modules
// ---------------------------------------

module barMagCoilHolderCap(z=2) {
    difference() {
        barMagCoilHolderOuterHull(y=coil_wire_width,z=z);
        barMagCoilHolderCenterHole();
    }
}

module barMagCoilHolderTop(z=2) {
    z_anch = 4;
    difference() {
        union() {
            barMagCoilHolderOuterHull(y=coil_wire_width,z=z);
            translate([0,0,z/2])rotate([0,0,180])barMagCoilHolderInnerAnchor(z=z_anch);
        }
        barMagCoilHolderCenterHole();
    }
}

module barMagCoilHolderBottom(z=coil_disk_depth) {
    z_off1 = coil_disk_base;
    z_off2 = (z_off1+.0)*2;
    difference() {
        barMagCoilHolderOuterHull(y=coil_wire_width-.45,z=z);
        // remove space for wire
        translate([0,0,z_off1])barMagCoilHolderDiff(z=z);
        // chop off the top to make it the right overall depth
        translate([0,0,z/2])barMagCoilHolderOuterHull(y=coil_wire_width,z=z_off2);
        // remove bolt hole used for winding
        barMagCoilHolderCenterHole();
        // remove wire start/finish holes
        barMagCoilHolderWireHoles();
        // remove anchor inset
        rotate([0,0,180])translate([0,0,z/2-z_off1])barMagCoilHolderInnerAnchor(z=5, scaleFactor=.85);
    }
}

module barMagCoilHolderCenterHole(z=coil_disk_depth) {
    coil_center_r = coil_disk_r - border - coil_wire_width - bar_mag_length/1.5;
    //coil_offset_r = coil_center_r + coil_wire_width;
    coil_offset_r = coil_disk_r - border - bar_mag_length/1.25;
    rotate([0,0,-sector_degrees*1.5]) {
        translate([0,coil_offset_r,0])cylinder(h=z*2,r=alignment_bolt_r,center=true);
    }
}

module barMagCoilHolderWireHoles(z=coil_disk_depth) {
    x_off = coil_wire_width/16;
    coil_offset_r = coil_disk_r - border - coil_wire_width;
    rotate([0,0,-sector_degrees]) {
        translate([x_off,coil_offset_r,0])cylinder(h=z*2,r=1,center=true);
    }
    rotate([0,0,-sector_degrees*2]) {
        translate([-x_off,coil_offset_r,0])cylinder(h=z*2,r=1,center=true);
    }
}

module barMagCoilHolderArray(z=10) {
    sectors = num_holes/2;
    sector_degrees = 360 / sectors;
    for(sector = [1 : sectors]) {
        angle = sector_degrees * sector;
        rotate([0,0,angle])barMagCoilHolderDiff(z=z);
    }    
}

module barMagCoilHolderDiff(z=10) {
    difference() {
        barMagCoilHolderOuterHull(z=z);
        barMagCoilHolderInnerHull(z=z+2);
    }
}

module barMagCoilHolderOuterArray(z=20) {
    sectors = num_holes/2;
    sector_degrees = 360 / sectors;
    for(sector = [1 : sectors]) {
        angle = sector_degrees * sector;
        //echo(str("angle_h:", angle));
        rotate([0,0,angle])barMagCoilHolderOuterHull(z=z);
    }    
}

module barMagCoilHolderOuterHull(y=coil_wire_width,z=10) {
    hull() {
        barMagCoilOutlines(r=bar_mag_disk_r,b=border,y=y,z=z);
    }
}
module barMagCoilOutlines(r,b,x=bar_mag_length,y=coil_wire_width,z=10) {
    sectors = num_holes;
    sector_degrees = 360 / sectors;
    for(sector = [1 : 0.25 : 2]) {
        angle = sector_degrees * sector;
        rotate([0,0,angle])barMagCoilOut(r,b,sector,x,y,z);
    }    
}

module barMagCoilOut(r,b,sector,x=bar_mag_length,y=coil_wire_width,z=10) {
    x_off = x/3 + y/3 + coil_inner_r; // -3;
    x_off2 = x_off/1.25;
    y_off = y/2;
    translate([r-x_off*1.333,0,0]){
        if (sector == 1) {
            translate([x_off,y_off,0])cylinder(h=z,r=y/2,center=true);
            translate([x_off2,0,0])cylinder(h=z,r=y/2,center=true);
            translate([-x_off2,0,0])cylinder(h=z,r=y/2,center=true);
            translate([-x_off,y_off,0])cylinder(h=z,r=y/2,center=true);
        } else if (sector == 2) {
            translate([x_off,-y_off,0])cylinder(h=z,r=y/2,center=true);
            translate([x_off2,0,0])cylinder(h=z,r=y/2,center=true);
            translate([-x_off2,0,0])cylinder(h=z,r=y/2,center=true);
            translate([-x_off,-y_off,0])cylinder(h=z,r=y/2,center=true);
        } else {
            translate([x_off,-y_off,0])cylinder(h=z,r=y/2,center=true);
            translate([x_off,y_off,0])cylinder(h=z,r=y/2,center=true);
        }
    }
}

module barMagCoilHolderInnerAnchorArray(z=2, scaleFactor=0.7) {
    sectors = num_holes/2;
    sector_degrees = 360 / sectors;
    for(sector = [1 : sectors]) {
        angle = (sector_degrees * sector)-(180-sector_degrees);
        rotate([0,0,angle])barMagCoilHolderInnerAnchor(z=z,scaleFactor=scaleFactor);
    }    
}

module barMagCoilHolderInnerAnchor(z=4, scaleFactor=0.7) {
    echo(str("scaleFactor:", scaleFactor));
    y_off = bar_mag_disk_r-(bar_mag_length/2)-border;
    angle = 90 + (sector_degrees * 1.5); //-sector_degrees/2
    rotate([0,0,angle])
    translate([0,y_off,0])
    scale([scaleFactor,scaleFactor,1])barMagCoilHolderInnerHullCenter(z=z);
}

//translate([-16,-39,0])barMagCoilHolderInnerHull(z=5);
module barMagCoilHolderInnerHullCenter(z=20) {
    angle = 90 - (sector_degrees * 1.5);
    y_off = bar_mag_disk_r-(bar_mag_length/2)-border;
    translate([0,-y_off,0])
    rotate([0,0,angle])
    barMagCoilHolderInnerHull(z=z);
}

module barMagCoilHolderInnerHull(z=20) {
    hull() {
        barMagCoilInlines(bar_mag_disk_r,border,z=z);
    }
}

module barMagCoilInlines(r,b,x=bar_mag_length,y=coil_wire_width,z=20) {
    sectors = num_holes;
    sector_degrees = 360/sectors;
    for(sector = [1 : 0.5 : 2]) {
        angle = sector_degrees * sector;
        rotate([0,0,angle])barMagCoilIn(r,b,sector,x,y,z);
    }    
}

module barMagCoilIn(r,b,sector,x=bar_mag_length,y=coil_wire_width,z=20) {
    x_off = x/2;
    y_off = y/2 + coil_inner_r;
    inner_l = x*.666;
    inner_w = coil_inner_r/2;
    translate([r-inner_l,0,0]){
    //translate([r-(x/2)-b,0,0]){
        if (sector == 1) {
            //translate([x_off,y_off,0])cylinder(h=z,r=inner_w,center=true);
            translate([0,y_off,0])cube([inner_l, inner_w, z], center=true);
            //translate([-x_off,y_off,0])cylinder(h=z,r=inner_w,center=true);
        } else if (sector == 2) {
            //translate([x_off,-y_off,0])cylinder(h=z,r=inner_w,center=true);
            translate([0,-y_off,0])cube([inner_l, inner_w, z], center=true);
            //translate([-x_off,-y_off,0])cylinder(h=z,r=inner_w,center=true);
//        } else {
//            translate([x_off,y_off,0])cylinder(h=z,r=inner_w,center=true);
//            translate([x_off,-y_off,0])cylinder(h=z,r=inner_w,center=true);
        }
    }
}


// ---------------------------------------
// Common Modules
// ---------------------------------------

module wireChannels(h, radius, hole_r, sectors=num_holes) {
    sector_degrees = 360 / sectors;
    for(sector = [1 : 1 : sectors]) {
        angle = sector_degrees * sector;
        rotate([0,0,angle]){
            translate([0,radius,0])cube([hole_r,border*4,hole_r], center=true);
        }
    }    
}

module structureHoles(h, radius, hole_r, sectors=num_holes) {
    sector_degrees = 360 / sectors;
    for(sector = [1 : 1 : sectors]) {
        angle = sector_degrees * sector -(sector_degrees*.75);
        x_pos = radius * sin(angle);
        y_pos = radius * cos(angle);
        translate([x_pos,y_pos,0]){
            hole(h, hole_r);
        }
    }    
}

module hole(h, hole_r) {
    cylinder(h=h+2,r=hole_r,center=true);
}


// ---------------------------------------
// Test Print Module
// ---------------------------------------

module renderTest(x=bar_mag_width,y=bar_mag_length,z=bar_mag_disk_depth) {
    difference() {
        //Base
        cube([x+border,y+border,z], center=true);
        //Bar Magnet hole
        cube([x, y, z+2], center=true);
    }
}
