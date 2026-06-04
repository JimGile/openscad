/* 
   GEN 11 v4.8: MODULAR SELF-CENTERING BUILD
   - SEPARATED: Flux Return Plate is now its own part (no supports needed!).
   - FEATURE: Spacer seats move to the Rotor-side for a self-locking frame.
   - FIXED: Stator is now a flat-back print for perfect bed adhesion.
*/

// ==========================================
// 1. MASTER PARAMETERS
// ==========================================
num_magnets = 12;           
num_coils   = 6;            
bar_mag_length = 29.2;      
bar_mag_width  = 9.4;        
bar_mag_depth  = 6.0;        

// --- PRECISION GAP SYSTEM ---
air_gap = 1.25;             
coil_thickness = 7.8;       
spacer_inset_depth = 2.0;   // How deep the spacer "sinks" into the stator

// --- FLUX (WASHER) SPECS ---
washer_flux_r = 15.1;       // 30mm Fender Washer (+ tolerance)
washer_flux_depth = 2.0;    
flux_plate_floor = 1.2;     // Thickness of the disk holding the washers

// --- MECHANICAL ---
alignment_bolt_r = 2.6;     
axel_r = 4.2;               
rotor_total_h = bar_mag_depth + 2; 

// ==========================================
// 2. DYNAMIC MATH
// ==========================================
magnet_gap_buffer = 4.0;
min_circ = num_magnets * (bar_mag_width + magnet_gap_buffer);
magnet_center_r = (min_circ / (2 * PI)) + (bar_mag_length / 2);

rotor_r = magnet_center_r + (bar_mag_length / 2) + 6;
stator_r = rotor_r + 15;    
mount_r = rotor_r + 8;      

// ==========================================
// 3. RENDER LAYOUT
// ==========================================
render_rotor = true;
render_stator = true;
render_flux_plate = true;
render_spacers = true;
render_winder = true;

// Layout spacing
s_off = stator_r * 2.2;

if (render_rotor)      translate([0, 0, 0]) bar_rotor();
if (render_stator)     translate([s_off, 0, 0]) bar_stator();
if (render_flux_plate) translate([s_off*2, 0, 0]) flux_plate();
if (render_spacers)    translate([s_off, s_off*0.7, 0]) spacer_set();
if (render_winder)     translate([0, -s_off*0.7, 0]) bar_winder_set();

// ==========================================
// 4. MODULES
// ==========================================

// --- MODULE 1: THE SPACER (Print 4) ---
module stator_spacer() {
    // Math: Distance between faces (Rotor + 2*Gap) + the depth spent inside the insets
    h_spacer = (rotor_total_h + (2 * air_gap)) + (2 * spacer_inset_depth);
    difference() {
        cylinder(h=h_spacer, r=6.5, $fn=50);
        translate([0,0,-1]) cylinder(h=h_spacer+2, r=alignment_bolt_r, $fn=30);
    }
}

module spacer_set() {
    for(i=[0:3]) translate([i*18, 0, 0]) stator_spacer();
}

// --- MODULE 2: THE STATOR (Print 2) ---
// Print this face-up (Coil pockets at the top)
module bar_stator() {
    stator_h = coil_thickness + 1.2; // 1.2mm floor for coils
    difference() {
        cylinder(h=stator_h, r=stator_r, $fn=140);
        
        // 1. Coil Pockets (Top side)
        for(i = [0 : num_coils - 1]) {
            rotate([0, 0, i * (360/num_coils)])
            translate([magnet_center_r, 0, 1.2]) 
                trap_shape(h=20, extra_l=3, extra_w=2);
        }
        
        // 2. Spacer Insets (TOP side - Locking the frame)
        for(i = [0:3]) {
            rotate([0, 0, i * 90 + 45]) translate([mount_r, 0, stator_h - spacer_inset_depth]) {
                cylinder(h=spacer_inset_depth + 0.1, r=6.6, $fn=40);
            }
        }

        // 3. Mounting Bolt thru-holes
        for(i = [0:3]) {
            rotate([0, 0, i * 90 + 45]) translate([mount_r, 0, -1]) 
                cylinder(h=stator_h + 2, r=alignment_bolt_r, $fn=30);
        }
        
        // Axle Clearance
        translate([0,0,-1]) cylinder(h=50, r=15, $fn=80);
    }
}

// --- MODULE 3: THE FLUX PLATE (Print 2) ---
// Print this face-up (Washer pockets at the top)
module flux_plate() {
    h_plate = washer_flux_depth + flux_plate_floor;
    difference() {
        cylinder(h=h_plate, r=stator_r, $fn=140);
        
        // 1. Washer Insets
        for(i = [0 : num_coils - 1]) {
            rotate([0, 0, i * (360/num_coils)])
            translate([magnet_center_r, 0, flux_plate_floor]) 
                cylinder(h=20, r=washer_flux_r, $fn=80);
        }
        
        // 2. Mounting Bolt thru-holes (Must align with Stator)
        for(i = [0:3]) {
            rotate([0, 0, i * 90 + 45]) translate([mount_r, 0, -1]) 
                cylinder(h=h_plate + 2, r=alignment_bolt_r, $fn=30);
        }

        // Axle Clearance
        translate([0,0,-1]) cylinder(h=50, r=15, $fn=80);
    }
}

// --- MODULE 4: ROTOR ---
module bar_rotor() {
    difference() {
        cylinder(h=rotor_total_h, r=rotor_r, $fn=120);
        for (i = [0:num_magnets-1]) {
            rotate([0, 0, i * (360/num_magnets)])
                translate([magnet_center_r, 0, -1])
                cube([bar_mag_length + 0.5, bar_mag_width + 0.5, 20], center=true);
        }
        translate([0,0,-1]) cylinder(h=rotor_total_h+2, r=axel_r, $fn=60);
    }
}

// --- MODULE 5: WINDER TOOLING ---
module bar_winder_set() {
    spacing = bar_mag_length + 40;
    translate([-spacing/2, 0, 0]) winder_bottom();
    translate([spacing/2, 0, 0]) winder_top();
}

module winder_bottom() {
    f_h = 6.0;
    core_h = coil_thickness + 3.0; // 3mm of it is the "key"
    difference() {
        union() {
            trap_shape(h=f_h, extra_l=10, extra_w=8); 
            translate([0,0, f_h])
                trap_shape(h=core_h, extra_l=-1, extra_w=-2);
        }
        translate([0,0,-1]) cylinder(h=50, r=alignment_bolt_r, $fn=40);
        translate([0, 0, f_h/2]) 
            cube([bar_mag_length*5, 1.3, f_h+0.1], center=true);
    }
}

module winder_top() {
    f_h = 6.0;
    difference() {
        trap_shape(h=f_h, extra_l=10, extra_w=8);
        translate([0, 0, f_h - 3.0])
            scale([1.1, 1.1, 1])
            trap_shape(h=4, extra_l=-1, extra_w=-2);
        translate([0,0,-1]) cylinder(h=50, r=alignment_bolt_r, $fn=40);
    }
}

// --- HELPER: GEOMETRY ENGINE ---
module trap_shape(h, extra_l=0, extra_w=0) {
    pitch = 30; 
    l = bar_mag_length + extra_l;
    r_in  = magnet_center_r - l/2;
    r_out = magnet_center_r + l/2;
    wi = (2 * r_in  * sin(pitch/2)) + extra_w;
    wo = (2 * r_out * sin(pitch/2)) + extra_w;
    translate([-l/2, 0, 0]) linear_extrude(h) polygon([[0, -wi/2], [0, wi/2], [l, wo / 2], [l, -wo / 2]]);
}