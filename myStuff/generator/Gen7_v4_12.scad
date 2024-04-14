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
num_holes=8;
sectors = num_holes;
sector_degrees = 360 / sectors;

// Bar Magent values
bar_mag_length = 30;
bar_mag_width = 10;
bar_mag_depth = 5;
border = 5;

// Coil related values
coil_wire_width = bar_mag_width;
coil_inner_r = 1;
coil_center_hole_r = bearing_or+eps;

// Calculated values
bar_mag_cir = num_holes*2*bar_mag_width;
bar_mag_disk_r = round(bar_mag_cir/(3.14159*2)+bar_mag_length+border+2);
bar_mag_disk_depth = bar_mag_depth;
coil_disk_r = round(bar_mag_disk_r + coil_wire_width + border);
coil_disk_depth = bearing_depth-1;
coil_disk_base = .6;


//Print values
echo(str("bearing_depth:", bearing_depth));
echo(str("sector_degrees:", sector_degrees));
echo(str("bar_mag_disk_r:", bar_mag_disk_r));
echo(str("bar_mag_disk_depth:", bar_mag_disk_depth));
echo(str("coil_disk_r:", coil_disk_r));
echo(str("coil_disk_depth:", coil_disk_depth));

//rotate([0,0,sector_degrees*$t])
//barMagDisk();
//translate([0,0,10]) {
//    #barMagCoilHolderArray();
//    %barMagCoilDisk(bearing=true);
//}

//barMagCoilHolderDiff();
//barMagCoilDisk();
//barMagCoilHolderBottom();
//translate([0,0,10])barMagCoilHolderTop();

render_mode = "PRINT"; //"FULL", "PRINT", "TEST";
print_mode = "COIL"; //"MAG","COIL","HOLDER_TOP","HOLDER_BOT";

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
    if (print_mode=="MAG") {
        // Magnet Disk1
        barMagDisk();
    } else if (print_mode=="COIL") {
        // COIL Disk
        barMagCoilDisk();
    } else if (print_mode=="HOLDER_TOP") {
        // Wire coil holder top
        barMagCoilHolderTop();
    } else if (print_mode=="HOLDER_BOT") {
        // Wire coil holder top
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
        barMagHoles(bar_mag_disk_r, border);
        //remove hole for main axel
        cylinder(h=h*2,r=axel_ir,center=true);
    }
}

module barMagHoles(r,b,x=bar_mag_length,y=bar_mag_width,z=20) {
    sectors = num_holes;
    sector_degrees = 360 / sectors;
    for(sector = [1 : sectors]) {
        angle = sector_degrees * sector;
        rotate([0,0,angle])barMagHole(r,b,x,y,z);
    }    
}

module barMagHole(r,b,x=bar_mag_length,y=bar_mag_width,z=20) {
    translate([r-(x/2)-b,0,0])cube([x, y, z], center=true);
}

// ---------------------------------------
// Stationary Coil Disk Modules
// ---------------------------------------

// Stationary Bar Mag Coil Disk with trapezoid coils
module barMagCoilDisk(h=coil_disk_depth, bearing=false) {
    hole_or = bar_mag_disk_r + (coil_disk_r-bar_mag_disk_r)/1.5;
    // Disk
    difference() {
        //main structure
        cylinder(h=h,r=coil_disk_r,center=true);
        //remove trapezoids for coils
        //translate([0,0,-h])barMagCoilHolderOuterArray(z=20);
        translate([0,0,+coil_disk_base])barMagCoilHolderArray(z=h);
        // remove center hole for bearing
        cylinder(h=h*2,r=coil_center_hole_r,center=true);
        // remove outer alignment holes
        structureHoles(h=h,radius=hole_or,hole_r=alignment_bolt_r,sectors=num_holes*2);
        // remove wire channels
        wireChannels(h=h,radius=hole_or,hole_r=alignment_bolt_r,sectors=num_holes);
    }
    if (bearing == true) {
        translate([0, 0, -bearing_depth/2])
        bearing(model=bearingModel, outline=false);
    }
}


// ---------------------------------------
// Coil Holder Modules
// ---------------------------------------

module barMagCoilHolderTop(z=2) {
    difference() {
        barMagCoilHolderOuterHull(y=coil_wire_width-.1,z=z);
        barMagCoilHolderCenterHoles();
    }
}

module barMagCoilHolderBottom(z=coil_disk_depth) {
    difference() {
        barMagCoilHolderOuterHull(y=coil_wire_width-.1,z=z+2);
        translate([0,0,coil_disk_base+1])barMagCoilHolderDiff(z=z);
        barMagCoilHolderCenterHoles();
        barMagCoilHolderWireHoles();
    }
}

module barMagCoilHolderCenterHoles(z=coil_disk_depth) {
    coil_center_r = coil_disk_r - border - coil_wire_width - bar_mag_length/1.5;
    coil_offset_r = coil_center_r + coil_wire_width;
    rotate([0,0,-sector_degrees/2]) {
        translate([0,coil_center_r,0])cylinder(h=z*2,r=alignment_bolt_r,center=true);
        translate([0,coil_offset_r,0])cylinder(h=z*2,r=1,center=true);
    }
}

module barMagCoilHolderWireHoles(z=coil_disk_depth) {
    coil_offset_r = coil_disk_r - border - coil_wire_width/2 - 1.5;
    translate([0,coil_offset_r,0])cylinder(h=z*2,r=1,center=true);
    rotate([0,0,-sector_degrees]) {
        translate([0,coil_offset_r,0])cylinder(h=z*2,r=1,center=true);
    }
}

module barMagCoilHolderArray(z=10) {
    sectors = num_holes;
    sector_degrees = 360 / sectors*2;
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
    sectors = num_holes;
    sector_degrees = 360 / sectors*2;
    for(sector = [1 : sectors]) {
        angle = sector_degrees * sector;
        rotate([0,0,angle])barMagCoilHolderOuterHull(z=z);
    }    
}

module barMagCoilHolderOuterHull(y=coil_wire_width,z=10) {
    hull() {
        barMagCoilOutlines(r=bar_mag_disk_r,b=border,y=y,z=z);
    }
}
module barMagCoilOutlines(r,b,x=30,y=coil_wire_width,z=10) {
    sectors = num_holes;
    sector_degrees = 360 / sectors;
    for(sector = [1 : 0.25 : 2]) {
        angle = sector_degrees * sector;
        rotate([0,0,angle])barMagCoilOut(r,b,x,y,z);
    }    
}

module barMagCoilOut(r,b,x=30,y=coil_wire_width,z=10) {
    offset = x/2 + y/2+coil_inner_r;
    translate([r-(x/2)-b,0,0]){
        translate([offset,0,0])cylinder(h=z,r=y/2,center=true);
        cube([x, y, z], center=true);
        translate([-offset,0,0])cylinder(h=z,r=y/2,center=true);
    }
}


module barMagCoilHolderInnerHull(z=20) {
    hull() {
        barMagCoilInlines(bar_mag_disk_r,border,z=z);
    }
}

module barMagCoilInlines(r,b,x=30,y=coil_wire_width,z=20) {
    sectors = num_holes;
    sector_degrees = 360 / sectors;
    for(sector = [1 : 0.5 : 2]) {
        angle = sector_degrees * sector;
        rotate([0,0,angle])barMagCoilIn(r,b,sector,x,y,z);
    }    
}

module barMagCoilIn(r,b,sector,x=30,y=coil_wire_width,z=20) {
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


// ---------------------------------------
// Common Modules
// ---------------------------------------

module wireChannels(h, radius, hole_r, sectors=num_holes) {
    sector_degrees = 360 / sectors;
    for(sector = [1 : 1 : sectors]) {
        angle = sector_degrees * sector;
        rotate([0,0,angle]){
            translate([0,radius,hole_r/4])cube([hole_r,border*4,hole_r], center=true);
        }
    }    
}

module structureHoles(h, radius, hole_r, sectors=num_holes) {
    sector_degrees = 360 / sectors;
    for(sector = [1 : 1 : sectors]) {
        angle = sector_degrees * sector;
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
            cylinder(h=bearing_depth*2,r=coil_center_hole_r,center=true);
            
            //CoilHolder
            centerCoilHolder() {
                translate([0,0,-coil_w])outerCoilHolder(w=coil_w*2,offset_r=eps);
            }    
        }
    }
}
