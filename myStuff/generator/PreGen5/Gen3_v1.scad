include <MCAD/bearing.scad>

// Smooth rendering
$fa = 1;
$fs = 0.4;

in_to_mm = 25.4;

// Variables
num_holes=8;
metal_hole_d = (1/4 * in_to_mm);
metal_hole_r = metal_hole_d/2;
//cir = num_holes*2*(metal_hole_d + num_holes/12);
cir = num_holes*2*(metal_hole_d + .5);
disk_r = cir/(3.14159*2)+1;
//disk_r = num_holes*((45/num_holes)/metal_hole_r);//180/num_holes;//22.5;
outer_r = disk_r*1.0;


gap = 1.5; //1/32 * in_to_mm;
nut_gap = 7;//3/4 * in_to_mm;

bearingModel = 608;
bearing_w = bearingWidth(bearingModel);
bearing_or = bearingOuterDiameter(bearingModel)/2;
bearing_ir = bearingInnerDiameter(bearingModel)/2;

//central_r = (disk_r+bearing_or)/2;
//central_r = ((disk_r+metal_hole_r)/2)+num_holes;
central_r = cir/(3.14159*2);

magnet_tot_w = 1.5 * in_to_mm;
magnet_w = 1/8 * in_to_mm;
magnet_hole_r = (1/8 * in_to_mm)+.1;

coil_w = 6; //1/8 * in_to_mm;
coil_hole_r = 6; //(1/4 * in_to_mm)+.1; // 3/8
coil_holder_r = 2.5; //1/16 * in_to_mm;
coil_holder_bolt_r = 2;
coil_ext_y = disk_r*1.75;
//coil_center_hole_r = (disk_r+bearing_or)/2-coil_hole_r-2;
coil_center_hole_r = bearing_or+.2;
coil_base_x = ((disk_r*2)-(disk_r/4));
coil_base_y = magnet_w+gap*2;//disk_r*1.75;//60;//magnet_w+gap*2+coil_w*2;
coil_base_z = coil_w/2;

metal_tot_w = 1/4 * in_to_mm;
metal_w = 1/4 * in_to_mm;
met_axel_h = gap+coil_w+gap;

axel_r = bearing_ir+.1;  //8mm or 5/16 in for bearing
axel_h = magnet_w-coil_w*2;//(magnet_w+metal_w*2+coil_w*2+gap*4)*1.15;
axel_hex_t = 2;
axel_hex_r = axel_r+3;//coil_center_hole_r-2;

echo(str("coil_hole_r:", coil_hole_r));
echo(str("coil_holder_r:", coil_holder_r));
echo(str("axel_r:", axel_r));
echo(str("axel_h:", axel_h));

hex_head_r = 6.8;
hex_head_t = 4;

wire_notch = 2;
wire_notch_r1 = (disk_r+bearing_or)/2+coil_hole_r-wire_notch/2;
wire_notch_r2 = (disk_r+bearing_or)/2+wire_notch;
wire_notch_r3 = (disk_r+bearing_or)/2-coil_hole_r-wire_notch/2;
wire_notch_x = coil_hole_r+wire_notch;
wire_notch_y = disk_r-coil_hole_r/2-wire_notch;

mag_y_pos = (magnet_tot_w-coil_w)/2;
coil_y_pos = mag_y_pos+gap+coil_w;
metal_y_pos = coil_y_pos+metal_tot_w-met_axel_h/2+gap*1.5;
end_y_pos = metal_y_pos+metal_tot_w/2+nut_gap+coil_w;

gen_base_x = disk_r/2;
gen_base_y = (end_y_pos+coil_w/2)*2;
gen_base_z = coil_base_z;

echo(str("end_y_pos:", end_y_pos));

eps = .2;

render_mode = "joe"; //"FULL", "PRINT", "TEST";
print_mode = "ENDCAP"; //"MAGNET","METAL","BASE","ENDCAP","HOLDERS";

//#translate([0,mag_y_pos,0])cube([100, .1, 100], center=true); 
//#translate([0,coil_y_pos,0])cube([100, .1, 100], center=true); 
//#translate([0,metal_y_pos,0])cube([100, .1, 100], center=true); 
//#translate([0,end_y_pos,0])cube([100, .1, 100], center=true); 

//magnetDisk();
//coilDisk();
//metalDisk();
%coilHolderHex();


//minkowski()
//{
//    coilHolderHex();
//    sphere(.25);
//}



//rotate([90,90,0])rotate([0,0,30])geratorHalfBase(h=end_y_pos*2, t=2);
//geratorHalfBase();

// Main rendering code
if (render_mode=="FULL") {
    renderFull();
} else if (render_mode=="PRINT") {
    renderPrint();
} else if (render_mode=="TEST") {
    renderTest();
}

module renderFull() {
    translate([0,0,0]) {
        // Half base
        translate([0,0,0])rotate([90,90,0])rotate([0,0,30])
            geratorHalfBase(h=end_y_pos*2, t=2);
        // Rotating Disk with magnets 1
        translate([0,-(mag_y_pos+magnet_w/2),0])
            rotate([90,0,180])magnetDisk();
        // Rotating Disk with magnets 2
        translate([0,(mag_y_pos+magnet_w/2.5),0])
            rotate([90,180,0])magnetDisk();
        // Rotating Disk with metal 1
        translate([0,metal_y_pos,0])
            rotate([90,0,0])metalDisk();
        // Rotating Disk with metal 2
        translate([0,-metal_y_pos,0])
            rotate([90,0,180])metalDisk();
        // Stationary End Cap with bearings 1
        translate([0,end_y_pos+coil_w/2,0])
            rotate([-90,0,180])endCapWithSupports();
        // Stationary End Cap with bearings 2
        translate([0,-end_y_pos-coil_w/2,0])
            rotate([-90,0,0])endCapWithSupports();
    }
}

module renderPrint() {
    if (print_mode=="MAGNET") {
        // Magnet Disk
        translate([0,0,coil_w/2])magnetDisk();
    } else if (print_mode=="METAL") {
        // Metal Disk
        metalDisk();
    } else if (print_mode=="BASE") {
        // Base half
        rotate([90,90,0])rotate([0,0,30])geratorHalfBase(h=end_y_pos*2, t=2);
    } else if (print_mode=="ENDCAP") {
        // End Cap
        translate([0,0,0])endCapWithSupports();
    } else if (print_mode=="HOLDERS") {
        // Wire coil holders
        for(x = [-2.5 : 2.5]) {
            translate([x*coil_hole_r*2.1,0,0])coilHolder();
        }
    }
}

// Rotating Disk with magnets
module magnetDisk(w=magnet_w) {
    notch_l = axel_hex_r-axel_r;
    notch_t = axel_hex_r/4;
    border = magnet_hole_r;
    mag_hex_supp_w = magnet_hole_r*3;
    mag_disk_r = central_r + magnet_hole_r*1.5;
    metal_disk_axel_h = axel_hex_t+gap+coil_w+gap;
    // Disk
    difference() {
        union() {
            difference() {
                cylinder(h=w,r=mag_disk_r,center=true);
                cylinder(h=w+.1,r=mag_disk_r-border,center=true);
            }
            hexSupports(w=w, supp_w=mag_hex_supp_w, radius=(mag_disk_r-border*2.5)/2);
            //central axel
            translate([0,0,(magnet_tot_w/2 - w)/2])
                cylinder(h=magnet_tot_w/2,r=axel_hex_r,center=true);
            // pos notch
            translate([0,(axel_hex_r+axel_r-.2)/2,(magnet_tot_w-w)/2])
                cube([notch_t, notch_l, notch_t], center=true);
            
        }
        //remove holes for magnets
        holes(w, magnet_hole_r);
        //remove hole for main axel
        cylinder(h=(w+metal_disk_axel_h)*4,r=axel_r,center=true);
        // upper neg notch
        translate([0,-(axel_hex_r+axel_r-.2)/2,(magnet_tot_w-w)/2])
            cube([notch_t+.2, notch_l+.2, notch_t+.2], center=true);
        // lower neg notch
        translate([0,-(axel_hex_r+axel_r-.2)/2,-w/2])
            cube([notch_t+.2, notch_l+.2, notch_l+.2], center=true);
    }
}
// Rotating Disk with metal
module metalDisk(w=metal_tot_w) {
    border = metal_hole_r*1.5;
    notch_l = axel_hex_r-axel_r;
    notch_t = axel_hex_r/4;
    met_disk_r = central_r + border;
    echo(str("met_axel_h:", met_axel_h));
    
    // Disk
    difference() {
        cylinder(h=w,r=met_disk_r,center=true);
        //remove holes for outer magnets
        holes(w*2, metal_hole_r, hex=false);
        //remove hole for main axel
        cylinder(h=w*10,r=axel_r,center=true);
    }
}


// Coil Holder
module coilHolderHex(w=metal_tot_w) {
    border = metal_hole_r*1.5;
    notch_l = axel_hex_r-axel_r;
    notch_t = axel_hex_r/4;
    met_disk_r = central_r + border;
    gap = 1;
    echo(str("met_axel_h:", met_axel_h));
    
    step = 1;
    step_inc = (180/num_holes);
    rot = step_inc*step;
    rotate([0,0,rot]) {
        difference() {
            intersection() {
                rotate([0,0,180/num_holes])
                hexSupportsCoil(w=w+1,supp_w=metal_hole_d*2.333,radius=central_r,len=metal_hole_d*1.5);
                cylinder(h=w,r=met_disk_r,center=true);
            }
            hexSupports(w=w+2, supp_w=metal_hole_d-gap, radius=central_r);
        }
    }
}


// Rotating Disk with metal
module metalDisk2(w=metal_tot_w) {
    border = metal_hole_r*1.5;
    notch_l = axel_hex_r-axel_r;
    notch_t = axel_hex_r/4;
    met_disk_r = central_r + border;
    echo(str("met_axel_h:", met_axel_h));
    
    // Disk
    difference() {
        cylinder(h=w,r=met_disk_r,center=true);
        //remove holes for outer magnets
        holes(w*2, metal_hole_r, hex=false);
        //#holes(w*2, metal_hole_r, hex=false, radius=central_r-metal_hole_d);
//        #holes(w*2, metal_hole_r/2, hex=false, radius=central_r-metal_hole_r*1.5);
//        #holes(w*2, metal_hole_r/2, hex=false, radius=central_r+metal_hole_r*1.5);
        //#rotate([0,0,180/num_holes])holes(w*2, metal_hole_r, hex=false);
        //remove hole for main axel
        cylinder(h=w*10,r=axel_r,center=true);
    }
    step = 1;
    step_inc = (180/num_holes);
    rot = step_inc*step;
    rotate([0,0,rot]) {
        difference() {
            %rotate([0,0,180/num_holes])hexSupportsCoil(w=w+1, supp_w=metal_hole_d*2.333, radius=central_r, len=metal_hole_d*1.5);
            hexSupports(w=w+2, supp_w=metal_hole_d-1, radius=central_r);
        }

    //    #rotate([0,0,180/num_holes])
    //        holes(w*2, metal_hole_r/1.667, hex=false, radius=central_r-(metal_hole_r*1.25));
        
        
//        // This works for 6 holes
//        rh1 = metal_hole_r/4;
//        rh2 = metal_hole_r/2.45;
//        rc1 = central_r-(metal_hole_r*1.5);
//        rc2 = central_r+(metal_hole_r*1.333);
//        
//        #rotate([0,0,140/num_holes])
//            holes(w*2, rh1, hex=false, radius=rc1);
//        #rotate([0,0,80/num_holes])
//            holes(w*2, rh2, hex=false, radius=rc2);
//
//        #rotate([0,0,220/num_holes])
//            holes(w*2, rh1, hex=false, radius=rc1);
//        #rotate([0,0,280/num_holes])
//            holes(w*2, rh2, hex=false, radius=rc2);
        
        // This works for 8 holes - sort of
        rh1 = metal_hole_r/2;
        rh2 = rh1; //metal_hole_r/(num_holes/3);
        rc1 = central_r-(metal_hole_r*1.5);
        rc2 = central_r+(metal_hole_r*1.5);
        echo(str("rh1:", rh1));
        echo(str("rh2:", rh2));
        echo(str("central_r:", central_r));
        
        
        step_8 = 180/8;
        rot1_8 = 155/8;
        rot2_8 = 90/8;
        rot3_8 = 205/8;
        rot4_8 = 270/8;
        echo(str("step_8:", step_8));
        echo(str("rot1_8:", rot1_8));
        echo(str("rot2_8:", rot2_8));
        echo(str("rot3_8:", rot3_8));
        echo(str("rot4_8:", rot4_8));

        step_12 = 180/12;
        rot1_12 = 135/12;
        rot2_12 = 95/12;
        rot3_12 = 225/12;
        rot4_12 = 265/12;
        echo(str("step_12:", step_12));
        echo(str("rot1_12:", rot1_12));
        echo(str("rot2_12:", rot2_12));
        echo(str("rot3_12:", rot3_12));
        echo(str("rot4_12:", rot4_12));
        
        //Middle
        //rotate([0,0,step_inc])holes(w*2, metal_hole_r/2, hex=false, radius=rc1);
        //rotate([0,0,step_inc])holes(w*2, metal_hole_r/2, hex=false, radius=rc2);
        
//        // 8 holes - good
//        #rotate([0,0,155/num_holes])
//            holes(w*2, rh1, hex=false, radius=rc1);
//        #rotate([0,0,90/num_holes])
//            holes(w*2, rh1, hex=false, radius=rc2);
//
//        #rotate([0,0,205/num_holes])
//            holes(w*2, rh1, hex=false, radius=rc1);
//        #rotate([0,0,270/num_holes])
//            holes(w*2, rh1, hex=false, radius=rc2);
        
        // 12 holes - good
//        #rotate([0,0,135/num_holes])
//            holes(w*2, rh1, hex=false, radius=rc1);
//        #rotate([0,0,95/num_holes])
//            holes(w*2, rh1, hex=false, radius=rc2);
//
//        #rotate([0,0,225/num_holes])
//            holes(w*2, rh1, hex=false, radius=rc1);
//        #rotate([0,0,265/num_holes])
//            holes(w*2, rh1, hex=false, radius=rc2);

        // 8 holes - not good
        rotate([0,0,step_inc - metal_hole_r*3.14]) {
            #holes(w*2, rh1, hex=false, radius=rc1);
            #holes(w*2, rh2, hex=false, radius=rc2);
        }
        
//        rotate([0,0,step_inc - (step_inc/num_holes)])
//            holes(w*2, rh1, hex=false, radius=rc1);
//        rotate([0,0,step_inc - (num_holes*2.333/rh2)])
//            holes(w*2, rh2, hex=false, radius=rc2);
//
//        rotate([0,0,235/num_holes])
//            holes(w*2, rh1, hex=false, radius=rc1);
//        rotate([0,0,280/num_holes])
//            holes(w*2, rh2, hex=false, radius=rc2);
        
    }
}



module hollowCyl(h,or,ir) {
    difference() {
        cylinder(h=h,r=or,center=true);
        cylinder(h=h,r=ir,center=true);
    }
}

// Stationary Disk with coils
module coilDisk(w=coil_w, wires=true) {
    small_hole_r = (coil_hole_r+4)/2;
    small_hole_or = outer_r-small_hole_r*2;
    wire_r = central_r+coil_center_hole_r;
    // Disk
    difference() {
        union() {
            // disk
            cylinder(h=w,r=outer_r,center=true, $fn=6);
        }
        // remove holes for coils
        holes(w, coil_hole_r);
        // remove center hole for bearing
        cylinder(h=w*2,r=coil_center_hole_r,center=true);
        // remove holes to save material
//        rotate([0,0,0])
//            #structureHoles(w=w,radius=small_hole_or+1, hole_r=small_hole_r-4);
        rotate([0,0,45])
            structureHoles(w=w,radius=small_hole_or+1, hole_r=small_hole_r-3.75);
        // remove holes for wires
        if (wires == true) {
            wireHolesStraight();
            //wireChannels();
        }
    }
}

module endCapWithSupports(w=coil_w) {
    border = w+2;
    bearing_w = bearingWidth(bearingModel);
    bearing_or = bearingOuterDiameter(bearingModel)/2;
    big_hole_r = coil_hole_r+2;
    big_hole_or = outer_r-big_hole_r*2;//(outer_r+coil_hole_r)/2;
    small_hole_r = (coil_hole_r+4)/2;
    small_hole_or = outer_r-small_hole_r*2;
    radius = outer_r+.2;
    
    difference() {
        union() {
            // Disk
            difference() {
                union() {
                    // disk
                    translate([0,0,0])cylinder(h=w,r=outer_r+w/2+.2,center=true, $fn=6);
                }
                // Remove inner hex
                cylinder(h=w*4,r=outer_r-border,center=true, $fn=6);
                // Remove base indent
                translate([0,0,w/2])cylinder(h=w+.1,r=outer_r+.2,center=true, $fn=6);
            }
            // bearing holder
            translate([0,0,-w/2])
                cylinder(h=bearing_w+w/2,r=bearing_or+2,center=false);
            translate([0,0,-w/4])
            rotate([0,0,30])hexSupports(w=w/2,supp_w=border);
        }
        // remove center hole for bearing
        bearing(pos=[0,0,.01],model=bearingModel,outline=true);
        cylinder(h=w*2,r=bearing_or-1,center=true);
        // remove holes to save material
        rotate([0,0,30])
            structureHoles(w=w,radius=small_hole_or+2, hole_r=small_hole_r-4);
    }
    
    if (render_mode == "FULL") {
        bearing(pos=[0,0,0],model=bearingModel,outline=false);
    }
}

module hexSupports(w=coil_w, supp_w=8, radius=(disk_r+bearing_or)/2) {
    // Create supports for bearing holder
    sectors = num_holes;
    sector_degrees = 360 / sectors;
    for(sector = [1 : sectors]) {
        angle = sector_degrees * sector;
        x_pos = radius * sin(angle);
        y_pos = radius * cos(angle);
        translate([x_pos,y_pos,0]){
            rotate([0,0,-angle]) {
                cube([supp_w,disk_r,w], center=true);
            }
        }
    }    
}

module hexSupportsCoil(w=coil_w, supp_w=8, radius=2, len=8) {
    // Create supports for coil holder
    sectors = num_holes/2;
    sector_degrees = 360 / sectors;
    for(sector = [1 : 1]) {
        angle = sector_degrees * sector;
        x_pos = radius * sin(angle);
        y_pos = radius * cos(angle);
        translate([x_pos,y_pos,0]){
            rotate([0,0,-angle]) {
                cube([supp_w,len,w], center=true);
            }
        }
    }    
}

module hexSupportsBearing(w=coil_w, supp_w=8, radius = (disk_r+bearing_or)/2) {
    // Create supports for bearing holder
    sectors = num_holes;
    sector_degrees = 360 / sectors;
    for(sector = [1 : sectors]) {
        angle = sector_degrees * sector;
        x_pos = radius * sin(angle);
        y_pos = radius * cos(angle);
        translate([x_pos,y_pos,0]){
            rotate([0,0,-angle]) {
                cube([supp_w,disk_r,w], center=true);
            }
        }
    }    
}

module wireHolesStraight() {
    radius = central_r;
    sectors = num_holes;
    sector_degrees = 360 / sectors;
    for(sector = [1 : sectors]) {
        angle = sector_degrees * sector;
        x_pos = radius * sin(angle);
        y_pos = radius * cos(angle);
        x_off = (coil_hole_r) * cos(angle);
        y_off = (coil_hole_r) * sin(angle);
//        translate([x_pos+y_off,y_pos+x_off,0]){
//            rotate([90,0,-angle])cylinder(h=coil_hole_r,r=coil_w/4, center=true);
//        }
        translate([x_pos,y_pos,coil_w/2]){
            rotate([90,0,-angle-235])cylinder(h=central_r*.4,r=coil_w/4,center=false);
        }
        translate([x_pos,y_pos,coil_w/2]){
            rotate([90,0,-angle+235])cylinder(h=central_r*.4,r=coil_w/4,center=false);
        }
    }    
}

module wireChannels(z=0) {
    // remove notches for wires
    radius = (disk_r-1)/1;
    sectors = num_holes;
    sector_degrees = 360 / sectors;
    for(sector = [1 : sectors]) {
        angle = sector_degrees * sector;
        x_pos = radius * sin(angle);
        y_pos = radius * cos(angle);
        x_off = (coil_hole_r) * cos(angle);
        y_off = (coil_hole_r) * sin(angle);
        translate([x_pos+x_off,y_pos-y_off,z]){
            rotate([90,0,-angle+90])cylinder(h=disk_r*2.25,r=coil_w/4, center=true);
        }
    }    
}

module geratorHalfBase(r=outer_r, h=50, t=2) {
    wire_r = coil_w/4;
    difference() {
        union() {
            geratorHalfBaseShape(r=r, h=h, t=t);
            //inner coil disks
            for(z = [-1,1]) {
                translate([0,0,coil_y_pos*z])
                coilDisk();
            }
        }
        // cut in half
        cube_h = h+t+1;
        cube_s = (outer_r+1)*2;
        translate([0,0,-(cube_h)/2]) {
            rotate([0,0,60])cube([cube_s, cube_s, cube_h]);
            rotate([0,0,105])cube([cube_s, cube_s, cube_h]);
            rotate([0,0,150])cube([cube_s, cube_s, cube_h]);
        }
        
        // remove holes for wires
        for(z = [-1,1]) {
            translate([0,0,coil_y_pos*z])
                rotate([90,0,60])cylinder(h=h,r=wire_r,center=false);
        }
        // remove alignment notch on one coil
        translate([0,0,coil_y_pos])rotate([90,0,150])
            cube([coil_w/3+.2, coil_w/3+.2, outer_r*2], center=true);
    }
    // add alignment notch on other coil
    difference() {
        translate([0,0,-coil_y_pos]) {
            rotate([90,0,150])
                cube([coil_w/3, coil_w/3, outer_r*2], center=true);
        }
        translate([0,0,-coil_y_pos]) {
            // remove center hole for bearing
            cylinder(h=coil_w,r=coil_center_hole_r,center=true);
        }
        
    }
}

module geratorHalfBaseShape(r=outer_r, h=50, t=2) {
    difference() {
        union() {
            difference() {
                cylinder(h=h,r=r,center=true, $fn=6);
                cylinder(h=h+t,r=r-t,center=true, $fn=6);
            }
            //base ends
            for(z = [-1,1]) {
                translate([0,0,(h/2)*z])
                baseEnd(w=t, r=r);
            }
        }
        translate([0,-r,0]) {
            // quarter height
            cube_h = h+t+1;
            cube_s = (outer_r+1)*2;
            translate([0,0,-(cube_h)/2]) {
                rotate([0,0,60])cube([cube_s, cube_s, cube_h]);
                rotate([0,0,105])cube([cube_s, cube_s, cube_h]);
                rotate([0,0,150])cube([cube_s, cube_s, cube_h]);
            }
        }
    }
}

module baseEnd(w=coil_w, r=outer_r) {
    border = 8;
    small_hole_r = (coil_hole_r+4)/2;
    small_hole_or = outer_r-small_hole_r*2;
    difference() {
        union() {
            // Disk
            difference() {
                // disk
                cylinder(h=w,r=r,center=true, $fn=6);
            }
        }
        // remove center hole for bearing
        cylinder(h=w*2,r=coil_center_hole_r,center=true);
        // remove holes to save material
        rotate([0,0,30])
            structureHoles(w=w,radius=small_hole_or+2, hole_r=small_hole_r-4);
    }
}

module holes(w, hole_r, hex=false, radius=central_r) {
    //radius = central_r;
    sectors = num_holes;
    sector_degrees = 360 / sectors;

    for(sector = [1 : sectors]) {
        angle = sector_degrees * sector;
        x_pos = radius * sin(angle);
        y_pos = radius * cos(angle);
        translate([x_pos,y_pos,0]){
            hole(w, hole_r);
            if (hex==true) {
                hexIndent(w,hex_head_t,hex_head_r);
            }
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
module hexIndent(w, hex_t=hex_head_t, hex_r=hex_head_r) {
    z_pos = (w-hex_t)/2-w/4;//hex_t/3.3;
    translate([0,0,z_pos])rotate([0,0,30])
        cylinder(h=hex_t+.01,r=hex_r,center=true, $fn=6);
}

// Coil Holder
module coilHolder(h1=.75, h2=coil_w, r1=coil_hole_r, r2=coil_holder_r) {
    r1e = r1-.2;
    translate([0,-r1-1,0])
        coilHolderBot(h1,h2,r1e,r2);
    translate([0,r1+1,0])rotate([180,0,0])
        coilHolderTop(h1,r1e);
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

module renderTest() {
    translate([0,0,1]) {
        difference() {
            cube([27,27,2], center=true);
            
            //Big Magnet hole
            translate([-9,-9,0])hole(metal_w, magnet_hole_r); 

            //Coil hole
            translate([0,0,0])hole(metal_w, coil_hole_r); 
            
            //Small Magnet hole
            translate([9,9,0])hole(metal_w, metal_hole_r); 
        }
    }
    translate([25,0,0])coilHolder(); 
}

module renderTest_OLD() {
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
            translate([0,-12,0])hexIndent(metal_w,hex_head_t,hex_head_r); 
        }
    }
    //Axel
    //Too small needs to be e=.05 or 0 not .1
    h=15;
    translate([0,7,h/2])rotate([90,0,0])axel(h=h, e=.05);
    translate([25,0,0])coilHolder(); 
}

