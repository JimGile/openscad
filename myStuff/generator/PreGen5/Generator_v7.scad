include <MCAD/bearing.scad>

// Smooth rendering
$fa = 1;
$fs = 0.4;

in_to_mm = 25.4;

// Variables
disk_r = 35;
outer_r = disk_r*1.33;
num_holes=6;

gap = 1; //1/32 * in_to_mm;
bolt_gap = 3/4 * in_to_mm;

bearingModel = 608;
bearing_w = bearingWidth(bearingModel);
bearing_or = bearingOuterDiameter(bearingModel)/2;
bearing_ir = bearingInnerDiameter(bearingModel)/2;

magnet_w = 1.5 * in_to_mm;
magnet_hole_r = (1/8 * in_to_mm)+.1;

metal_w = 1/4 * in_to_mm;
metal_hole_r = 3.5;

coil_w = 5; //1/8 * in_to_mm;
coil_hole_r = 8; //(1/4 * in_to_mm)+.1; // 3/8
coil_holder_r = 2; //1/16 * in_to_mm;
coil_ext_y = disk_r*1.75;
coil_center_hole_r = (disk_r+bearing_or)/2-coil_hole_r-2;
coil_base_x = ((disk_r*2)-(disk_r/4));
coil_base_y = magnet_w+gap*2;//disk_r*1.75;//60;//magnet_w+gap*2+coil_w*2;
coil_base_z = coil_w/2;

axel_r = bearing_ir+.1;  //8mm or 5/16 in for bearing
axel_h = magnet_w-coil_w*2;//(magnet_w+metal_w*2+coil_w*2+gap*4)*1.15;
axel_hex_t = 2;
axel_hex_r = coil_center_hole_r-2;

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

mag_y_pos = (magnet_w-coil_w)/2;
coil_y_pos = mag_y_pos+gap+coil_w;
metal_y_pos = coil_y_pos+gap+metal_w;
end_y_pos = metal_y_pos+bolt_gap+coil_w;

gen_base_x = disk_r/2;
gen_base_y = (end_y_pos+coil_w/2)*2;
gen_base_z = coil_base_z;


echo(str("end_y_pos:", end_y_pos));

eps = .2;

render_mode = "PRINT"; //"FULL", "PRINT", "TEST";
print_mode = "HOLDER"; //"MAGNET","MAGNET_SUP","METAL","COIL","ENDCAP","AXEL","SUPPORT","HOLDER";

//generatorSupport();
//#translate([0,mag_y_pos,0])cube([100, .1, 100], center=true); 
//#translate([0,coil_y_pos,0])cube([100, .1, 100], center=true); 
//#translate([0,metal_y_pos,0])cube([100, .1, 100], center=true); 
//#translate([0,end_y_pos,0])cube([100, .1, 100], center=true); 

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
        // Rotating Disk with magnets 1
        translate([0,mag_y_pos,0])
            rotate([90,0,180])magnetDisk();
        // Rotating Disk with magnets 2
        translate([0,-mag_y_pos,0])
            rotate([90,0,0])magnetDisk();
        // Stationary Disk with coils 1
        translate([0,coil_y_pos,0])
            rotate([-90,0,0])coilDisk();
        // Stationary Disk with coils 2
        translate([0,-coil_y_pos,0])
            rotate([-90,0,0])coilDisk();
        // Rotating Disk with metal 1
        translate([0,metal_y_pos,0])
            rotate([90,0,0])metalDisk();
        // Rotating Disk with metal 2
        translate([0,-metal_y_pos,0])
            rotate([90,0,180])metalDisk();
        // Stationary End Cap with bearings 1
        translate([0,end_y_pos,0])
            rotate([-90,0,0])endCapWithSupports();
        // Stationary End Cap with bearings 2
        translate([0,-end_y_pos,0])
            rotate([-90,0,180])endCapWithSupports();
        
        // Axel
        translate([0,0,0]) hexAxel();
        
        // Base support
        base_z = (disk_r+coil_ext_y-coil_w/2)/2;
        translate([0,0,-base_z])generatorSupport();
        // Top support
        top_z = (disk_r+coil_base_z*8/3)-gen_base_z;
        translate([0,0,top_z])rotate([0,180,0])generatorSupport();
        
        // Sides
        side_z = disk_r+gen_base_x/4;
        side_x = (coil_base_x+gen_base_z)/2-gen_base_z;
        translate([side_x,0,-side_z])
            rotate([0,-90,0])generatorSupport();
        translate([-side_x,0,-side_z])
            rotate([0,90,0])generatorSupport();
    }
}

module renderPrint() {
    if (print_mode=="MAGNET") {
        // Magnet Disk
        translate([0,0,coil_w/2])magnetDisk();
    } else if (print_mode=="MAGNET_SUP") {
        // Magnet Disks Support
        translate([o,0,coil_w/4])magnetDiskSupport();
    } else if (print_mode=="METAL") {
        // Metal Disk
        translate([0,0,metal_w/2])metalDisk();
    } else if (print_mode=="COIL") {
        // Coil Disk
        translate([0,0,coil_w/2])coilDisk();
    } else if (print_mode=="ENDCAP") {
        // End Cap
        translate([0,0,coil_w/2])endCapWithSupports();
    } else if (print_mode=="AXEL") {
        // Axel
        translate([0,0,axel_h/2])rotate([90,0,0])hexAxel();
    } else if (print_mode=="SUPPORT") {
        translate([0,0,gen_base_z/2])generatorSupport();
    } else if (print_mode=="HOLDER") {
        for(x = [-2.5 : 2.5]) {
            translate([x*coil_hole_r*2.1,0,0])coilHolder();
        }
        
    }
}

module renderTest() {
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

// Rotating Disk with magnets
module magnetDisk(w=coil_w) {
    border = hex_head_r;
    metal_disk_axel_h = axel_hex_t+gap+coil_w+gap;
    // Disk
    difference() {
        union() {
            difference() {
                cylinder(h=w,r=disk_r,center=true);
                cylinder(h=w+.1,r=disk_r-border,center=true);
            }
            hexSupports(w=w,supp_w=magnet_hole_r*2+4, radius=(disk_r-border)/2);
            translate([0,0,w/2])
                cylinder(h=metal_disk_axel_h,r=axel_hex_r,center=false, $fn=6);
        }
        //remove holes for magnets
        holes(w, magnet_hole_r);
        //remove hole for main axel
        cylinder(h=(w+metal_disk_axel_h)*2,r=axel_r,center=true);
        //remove notches for supports
        magnetDiskSupports();
    }
}

// Rotating Disk with metal
module metalDisk(w=metal_w) {
    border = hex_head_r;
    // Disk
    difference() {
        union() {
            difference() {
                cylinder(h=w,r=disk_r,center=true);
                cylinder(h=w+.1,r=disk_r-border,center=true);
            }
            hexSupports(w=w,supp_w=hex_head_r*2+2, radius=(disk_r-border)/2);
        }
        //remove holes for bolts
        holes(w*2, metal_hole_r, hex=true);
        //remove hole for main axel
        cylinder(h=w*2,r=axel_r,center=true);
        //indent for hex axel
        rotate([0,0,30])hexIndent(w=w*2, hex_t=axel_hex_t, hex_r=axel_hex_r+.2);
    }
}

// Stationary Disk with coils
module coilDisk(w=coil_w) {
    small_hole_r = (coil_hole_r+4)/2;
    small_hole_or = outer_r-small_hole_r*2;
    // Disk
    difference() {
        union() {
            // disk
            //cylinder(h=w,r=disk_r,center=true);
            cylinder(h=w,r=outer_r,center=true, $fn=6);
            // base
            translate([0,disk_r/2,0])
                cube([coil_base_x,coil_ext_y,w],center=true);
            
        }
        // remove holes for coils
        holes(w, coil_hole_r);
        // remove center hole for bearing
        cylinder(h=w*2,r=coil_center_hole_r,center=true);
        // remove holes to save material
        rotate([0,0,30])structureHoles(w=w,radius=small_hole_or, hole_r=small_hole_r);
        // remove holes for wires
        wireHolesStraight();
        // Remove side, top, and bottom notches and misc holes
        generatorSupportNotchesAndPegs(npMode="NOTCHES");
    }
    // Add side, top and bot pegs
    generatorSupportNotchesAndPegs(npMode="PEGS");
}

module endCapWithSupports(w=coil_w) {
    border = 8;
    bearing_w = bearingWidth(bearingModel);
    bearing_or = bearingOuterDiameter(bearingModel)/2;
    big_hole_r = coil_hole_r+2;
    big_hole_or = outer_r-big_hole_r*2;//(outer_r+coil_hole_r)/2;
    small_hole_r = big_hole_r/2;
    small_hole_or = outer_r-small_hole_r*2;
    
    union() {
        // Disk
        difference() {
            union() {
                // disk
                //cylinder(h=w,r=disk_r,center=true);
                cylinder(h=w,r=outer_r,center=true, $fn=6);
                // base
                translate([0,disk_r/2,0])
                    cube([coil_base_x,coil_ext_y,w],center=true);
            }
            // Remove inner hex
            cylinder(h=w*2,r=outer_r-border,center=true, $fn=6);
            // Remove side, top, and bottom notches and misc holes
            generatorSupportNotchesAndPegs(npMode="NOTCHES");
        }
        
        // Add side, top and bot pegs
        generatorSupportNotchesAndPegs(npMode="PEGS");
        
        // bearing holder
        difference() {
            union() {
                translate([0,0,-w/2])
                    cylinder(h=bearing_w+w/2,r=bearing_or+2,center=false);
                rotate([0,0,30])hexSupports(supp_w=border);
            }
            // remove center hole for bearing
            bearing(pos=[0,0,.01],model=bearingModel,outline=true);
            cylinder(h=w*2,r=bearing_or-1,center=true);
        }
    }
    
    if (render_mode == "FULL") {
        bearing(pos=[0,0,0],model=bearingModel,outline=false);
    }
}

module hexSupports(w=coil_w, supp_w, radius = (disk_r+bearing_or)/2) {
    // Create supports for bearing holder
    sectors = num_holes;
    sector_degrees = 360 / sectors;

    for(sector = [1 : sectors]) {
        angle = sector_degrees * sector;
        x_pos = radius * sin(angle);
        y_pos = radius * cos(angle);
        translate([x_pos,y_pos,0]){
            rotate([0,0,-angle])cube([supp_w,disk_r,w], center=true);
        }
    }    
}

module wireHolesStraight() {
    // remove notches for wires
    radius = (disk_r+bearing_or)/2;
    sectors = num_holes;
    sector_degrees = 360 / sectors;
    for(sector = [1 : sectors]) {
        angle = sector_degrees * sector;
        x_pos = radius * sin(angle);
        y_pos = radius * cos(angle);
        x_off = (coil_hole_r-1) * cos(angle);
        y_off = (coil_hole_r-1) * sin(angle);
        translate([x_pos+x_off,y_pos-y_off,0]){
            rotate([90,0,-angle])cylinder(h=disk_r*2,r=1, center=true);
        }
        translate([x_pos-x_off,y_pos+y_off,0]){
            rotate([90,0,-angle])cylinder(h=disk_r*2,r=1, center=true);
        }
    }    
}

module generatorSupportNotchesAndPegs(npMode="NOTCHES", w=coil_w) {
    side_peg_x = (coil_base_x+gen_base_z)/2-gen_base_z;
    side_peg_y = disk_r+gen_base_x/4;
    bot_peg_y = (disk_r+coil_ext_y+coil_base_z)/2-gen_base_z;
    top_peg_y = (disk_r+coil_base_z*8/3)-gen_base_z;
    
    if (npMode=="NOTCHES") {
        // Remove side notches
        translate([side_peg_x,side_peg_y,0])
            cube([gen_base_z+.2,gen_base_x+.2,w*2],center=true);
        translate([-side_peg_x,side_peg_y,0])
            cube([gen_base_z+.2,gen_base_x+.2,w*2],center=true);
        // Remove bot notch
        translate([0,bot_peg_y,0])
            cube([gen_base_x,gen_base_z+.2,w*2],center=true);
        // Remove top notch
        translate([0,-top_peg_y,0])
            cube([gen_base_x,gen_base_z+.2,w*2],center=true);
        // Remove Misc holes
        for(x = [-1.5 : 1.5]) {
            translate([x*coil_base_x/4,side_peg_y,0])
                cylinder(h=w*2,r=3,center=true);
        }
    } else if (npMode=="PEGS") {
        // side pegs
        translate([side_peg_x,side_peg_y,0])
            cube([coil_base_z+.2,coil_base_z,w],center=true);
        translate([-side_peg_x,side_peg_y,0])
            cube([coil_base_z+.2,coil_base_z,w],center=true);
        // bot peg
        translate([0,bot_peg_y,0])
            cube([coil_base_z,coil_base_z+.2,w],center=true);
        // top peg
        translate([0,-top_peg_y,0])
            cube([coil_base_z,coil_base_z+.2,w],center=true);
    }
}

module generatorSupport() {
    end_y = (gen_base_y+gen_base_z)/2;
    end_notch_y = (gen_base_y-coil_w)/2;
    difference() {
        union() {
            // base
            translate([0,0,0])
                cube([gen_base_x,gen_base_y,gen_base_z],center=true);
            // ends
            translate([0,end_y,gen_base_z])
                cube([gen_base_x,gen_base_z,gen_base_z*3],center=true);
            translate([0,-end_y,gen_base_z])
                cube([gen_base_x,gen_base_z,gen_base_z*3],center=true);
        }
        // remove middle holes for wires
        translate([gen_base_z*2,coil_y_pos,0])
            cylinder(h=gen_base_z*2,r=gen_base_z,center=true);
        translate([-gen_base_z*2,coil_y_pos,0])
            cylinder(h=gen_base_z*2,r=gen_base_z,center=true);
        translate([gen_base_z*2,-coil_y_pos,0])
            cylinder(h=gen_base_z*2,r=gen_base_z,center=true);
        translate([-gen_base_z*2,-coil_y_pos,0])
            cylinder(h=gen_base_z*2,r=gen_base_z,center=true);
        
        // remove middle notchs
        translate([0,coil_y_pos,0])
            cube([coil_base_z+.2,coil_w+.2,coil_base_z*4],center=true);
        translate([0,-coil_y_pos,0])
            cube([coil_base_z+.2,coil_w+.2,coil_base_z*4],center=true);
        
        // remove end notchs
        translate([0,end_notch_y,0])
            cube([coil_base_z+.2,coil_w+.2,coil_base_z*6],center=true);
        translate([0,-end_notch_y,0])
            cube([coil_base_z+.2,coil_w+.2,coil_base_z*6],center=true);
            
        // remove misc holes
        for(y = [-1 : 1]) {
            translate([0,(y*end_y*2)/3,0])
                cylinder(h=gen_base_z*2,r=gen_base_z*2,center=true);
        }
    }
}

module holes(w, hole_r, hex=false) {
    radius = (disk_r+bearing_or)/2;
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
    
// Axel
module hexAxel(h=axel_h, e=eps) {
    rotate([90,0,0]) {
        difference() {
            cylinder(h=h,r=axel_hex_r,center=true, $fn=6);
            //remove hole for main axel
            cylinder(h=h*2,r=axel_r,center=true);
        }
    }
}

// Coil Holder
module coilHolder(
    h1=.3,
    h2=coil_w, 
    r1=coil_hole_r, 
    r2=coil_holder_r) {
        translate([0,-coil_hole_r-1,0])
            coilHolderBot(h1,h2,r1,r2);
        translate([0,coil_hole_r+1,0])rotate([180,0,0])
            coilHolderTop(h1,h2,r1,r2);
}


module coilHolderTop(h1,h2,r1,r2) {
    rotate([180,0,0]) {
        difference() {
            coilHolderTemplate(h1,0,r1,r2);
            //remove hoe for extra post
            cylinder(h=h2,r=r2/2+.2,center=true);
        }
    }
}

module coilHolderBot(h1,h2,r1,r2) {
    wire_holder_r = .75;
    difference() {
        union() {
            coilHolderTemplate(h1,h2,r1,r2);
            //Extra post
            translate([0,0,h2])cylinder(h=h2,r=r2/2,center=false);
        }
        translate([0,0,h1*2+wire_holder_r])rotate([90,0,0])
            cylinder(h=r1*2,r=wire_holder_r,center=true);
    }
}

module coilHolderTemplate(h1,h2,r1,r2) {
    //Base
    cylinder(h=h1,r=r1,center=false);
    //Post
    cylinder(h=h2,r=r2,center=false);
}




// Coil Holder
module oldCoilHolder(
    h1=.3,
    h2=coil_w, 
    r1=coil_hole_r, 
    r2=coil_holder_r, 
    e1=eps,
    e2=0) {
        translate([0,-coil_hole_r-1,0])oldCoilHolderBot(h1,h2,r1,r2,e1,e2);
        translate([0,coil_hole_r+1,0])rotate([180,0,0])
            oldCoilHolderTop(h1,2,r1,r2,e1,e2+.1);
}


module oldCoilHolderTop(h1,h2,r1,r2,e1,e2) {
    rotate([180,0,0])oldCoilHolderTemplate(h1,h2,r1,r2/1.5,e1,e2);
}

module oldCoilHolderBot(h1,h2,r1,r2,e1,e2) {
    wire_holder_r = .75;
    difference() {
        coilHolderTemplate(h1,h2,r1,r2,e1,e2);
        translate([0,0,h2+.1])oldCoilHolderTop(h1,2,r1,r2,e1,-.2);
        translate([0,0,h1*2+wire_holder_r])rotate([90,0,0])
            cylinder(h=r1*2,r=wire_holder_r,center=true);
    }
}

module oldCoilHolderTemplate(h1,h2,r1,r2,e1,e2) {
    //Base
    cylinder(h=h1,r=r1-e1,center=false);
    //Post
    cylinder(h=h2,r=r2-e2,center=false);
}



module magnetDiskSupports(supp_x=10.2, supp_y=magnet_w, supp_z=coil_w/2) {
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
                rotate([0,0,90])translate([0,y,0])rotate([90,0,0])
                    magnetDiskSupport(supp_x=supp_x);
            } else if (sector == 2) {
                rotate([0,0,0])translate([0,y,0])rotate([90,0,0])
                    magnetDiskSupport(supp_x=supp_x);
            } else if (sector == 3) {
                rotate([0,0,90])translate([0,-y,0])rotate([90,0,0])
                    magnetDiskSupport(supp_x=supp_x);
            } else if (sector == 4) {
                rotate([0,0,0])translate([0,-y,0])rotate([90,0,0])
                    magnetDiskSupport(supp_x=supp_x);
            }
        }
    }    
}
module magnetDiskSupport(supp_x=10, supp_y=magnet_w, supp_z=coil_w/2) {
    cube([supp_x, supp_y, supp_z], center=true);
}

