/* 
   GEN 11 v5.2: COMPLETE PRODUCTION SET
   - ROTOR: 10mm thick, Hex-Nut axle lock, centered magnet pockets.
   - STATOR: 608 Bearing seat + "Nut Garage" clearance.
   - FLUX PLATE: Modular washer housing.
   - WINDER: Two-part indexing jig for the manual drill winder.
   - SPACERS: Frame-locking gap maintainers.
*/

// ==========================================
// 1. MASTER PARAMETERS (USER TUNABLES)
// ==========================================
num_magnets = 12;           
num_coils   = 6;            
bar_mag_length = 29.2;      
bar_mag_width  = 9.4;        
bar_mag_depth  = 6.0;        

// --- GAP & FLUX ---
air_gap = 1.25;             
coil_thickness = 7.8;       
thin_floor = 1.0;           
washer_flux_depth = 2.4;    
washer_flux_r = 15.2;       
flux_plate_floor = 1.2;     

// --- AXLE & BEARING ---
axel_r = 4.2;               // 8mm All-thread
nut_hex_dist = 13.4;        // M8 Nut across flats
bearing_od = 22.2;          // 608 Bearing
bearing_h = 7.0;            
alignment_bolt_r = 2.6;     // M5 frame
spacer_inset_depth = 2.0;   

// ==========================================
// 2. DYNAMIC CALCULATIONS
// ==========================================
magnet_gap_buffer = 4.0;
min_circ = num_magnets * (bar_mag_width + magnet_gap_buffer);
magnet_center_r = (min_circ / (2 * PI)) + (bar_mag_length / 2);

rotor_total_h = 10.0; 
rotor_r = magnet_center_r + (bar_mag_length / 2) + 6;
stator_r = rotor_r + 15;    
mount_r = rotor_r + 8; 
stator_h = coil_thickness + thin_floor;

// ==========================================
// 3. RENDER LAYOUT (Toggles)
// ==========================================
render_rotor = true;
render_stator = true;
render_flux_plate = true;
render_spacers = true;
render_winder = true;

layout_gap = stator_r * 2.2;

if (render_rotor)      translate([0, 0, 0]) bar_rotor();
if (render_stator)     translate([layout_gap, 0, 0]) bar_stator();
if (render_flux_plate) translate([layout_gap * 2, 0, 0]) flux_plate();
if (render_spacers)    translate([layout_gap, layout_gap * 0.8, 0]) spacer_set();
if (render_winder)     translate([0, -layout_gap * 0.8, 0]) bar_winder_set();

// ==========================================
// 4. CORE MODULES
// ==========================================

// --- ROTOR WITH HEX NUT TRAP ---
module bar_rotor() {
    difference() {
        cylinder(h=rotor_total_h, r=rotor_r, $fn=120);
        for (i = [0:num_magnets-1]) {
            rotate([0, 0, i * (360/num_magnets)])
                translate([magnet_center_r, 0, rotor_total_h/2]) 
                cube([bar_mag_length + 0.4, bar_mag_width + 0.4, 25], center=true);
        }
        translate([0,0,-1])
        cylinder(h=rotor_total_h + 2, r=nut_hex_dist/2 / cos(30), $fn=6);
    }
}

// --- STATOR (Bearing + Nut Garage) ---
module bar_stator() {
    difference() {
        cylinder(h=stator_h, r=stator_r, $fn=140);
        for(i = [0 : num_coils - 1]) {
            rotate([0, 0, i * (360/num_coils)])
            translate([magnet_center_r, 0, thin_floor]) 
                trap_shape(h=stator_h + 5, extra_l=3, extra_w=2);
        }
        // Nut Garage (Side facing rotor)
        translate([0, 0, 1.5]) 
            cylinder(h=stator_h, r=13.5, $fn=80); 
        // Bearing Pocket (Side facing away)
        translate([0, 0, -1]) 
            cylinder(h=bearing_h + 1, r=bearing_od/2, $fn=80);
        // Spacer Insets
        for(i = [0:3]) {
            rotate([0, 0, i * 90 + 45]) translate([mount_r, 0, stator_h - spacer_inset_depth])
                cylinder(h=spacer_inset_depth + 1, r=6.6, $fn=40);
            rotate([0, 0, i * 90 + 45]) translate([mount_r, 0, -5]) 
                cylinder(h=stator_h + 10, r=alignment_bolt_r, $fn=30);
        }
    }
}

// --- FLUX PLATE (Washer Housing) ---
module flux_plate() {
    h_plate = washer_flux_depth + flux_plate_floor;
    difference() {
        cylinder(h=h_plate, r=stator_r, $fn=140);
        for(i = [0 : num_coils - 1]) {
            rotate([0, 0, i * (360/num_coils)])
            translate([magnet_center_r, 0, flux_plate_floor]) 
                cylinder(h=10, r=washer_flux_r, $fn=80);
        }
        for(i = [0:3]) {
            rotate([0, 0, i * 90 + 45]) translate([mount_r, 0, -1]) 
                cylinder(h=20, r=alignment_bolt_r, $fn=30);
        }
        translate([0,0,-1]) cylinder(h=20, r=axel_r + 4, $fn=60);
    }
}

// --- SPACERS ---
module stator_spacer() {
    h_spacer = (rotor_total_h + (2 * air_gap)) + (2 * spacer_inset_depth);
    difference() {
        cylinder(h=h_spacer, r=6.5, $fn=50);
        translate([0,0,-1]) cylinder(h=h_spacer+2, r=alignment_bolt_r, $fn=30);
    }
}

module spacer_set() {
    for(i=[0:3]) translate([0, i*18, 0]) stator_spacer();
}

// ==========================================
// 5. WINDER TOOLING
// ==========================================
module bar_winder_set() {
    spacing = bar_mag_length + 40;
    translate([-spacing/2, 0, 0]) winder_bottom();
    translate([spacing/2, 0, 0]) winder_top();
}

module winder_bottom() {
    f_h = 6.0;
    core_h = coil_thickness + 3.0; // Indexing male part
    difference() {
        union() {
            trap_shape(h=f_h, extra_l=10, extra_w=8); 
            translate([0,0, f_h])
                trap_shape(h=core_h, extra_l=-0.5, extra_w=-1);
        }
        translate([0,0,-1]) cylinder(h=50, r=alignment_bolt_r, $fn=40);
        // Wire exit slot
        translate([0, 0, f_h/2]) 
            cube([bar_mag_length*5, 1.4, f_h+0.2], center=true);
    }
}

module winder_top() {
    f_h = 6.0;
    difference() {
        trap_shape(h=f_h, extra_l=10, extra_w=8);
        // Indexing female part
        translate([0, 0, f_h - 3.0])
            scale([1.1, 1.1, 1])
            trap_shape(h=4, extra_l=-0.5, extra_w=-1);
        translate([0,0,-1]) cylinder(h=50, r=alignment_bolt_r, $fn=40);
    }
}

// --- HELPER GEOMETRY ENGINE ---
module trap_shape(h, extra_l=0, extra_w=0) {
    pitch = 30; 
    l = bar_mag_length + extra_l;
    r_in  = magnet_center_r - l/2;
    r_out = magnet_center_r + l/2;
    wi = (2 * r_in  * sin(pitch/2)) + extra_w;
    wo = (2 * r_out * sin(pitch/2)) + extra_w;
    translate([-l/2, 0, 0]) 
    linear_extrude(h) 
    polygon([[0, -wi/2], [0, wi/2], [l, wo / 2], [l, -wo / 2]]);
}