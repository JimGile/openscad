/* 
   GEN 11 v4.5: HIGH-FLUX PRODUCTION BUILD
   - ADDED: 6x Steel Washer Pockets on the back for Flux Return.
   - FIXED: Stator Z-Stack revised for Washer + Floor + Coil.
   - FIXED: Top Winder oriented for support-free printing.
*/

// --- USER ADJUSTABLES ---
num_magnets = 12;           
num_coils   = 6;            
bar_mag_length = 29.2;      
bar_mag_width  = 9.4;        
bar_mag_depth  = 6.0;        

// --- THE PRECISION Z-STACK ---
coil_thickness = 7.8;       
key_depth = 3.0;            
flange_h  = 6.0;            
alignment_bolt_r = 2.6;     

// --- FLUX PATH (WASHER) SPECS ---
// Measure your steel washers! Adjust these values:
washer_flux_r = 15.0;       // Radius for a 30mm Fender Washer
washer_flux_depth = 2.0;    // Thickness of your steel washer
thin_floor = 0.8;           // Plastic gap between Coil and Steel

// --- DYNAMIC MATH ---
magnet_gap_buffer = 4.0;
min_circ = num_magnets * (bar_mag_width + magnet_gap_buffer);
magnet_center_r = (min_circ / (2 * PI)) + (bar_mag_length / 2);

rotor_r = magnet_center_r + (bar_mag_length / 2) + 6;
stator_r = rotor_r + 4;
stator_h = coil_thickness + thin_floor + washer_flux_depth;

// --- RENDER TOGGLES ---
render_rotor = true;
render_stator = true;
render_winder = true;

// --- LAYOUT ---
if (render_rotor)  translate([0, 0, 0]) bar_rotor();
if (render_stator) translate([stator_r * 2.2, 0, 0]) bar_stator();
if (render_winder) translate([0, -stator_r * 1.5, 0]) bar_winder_set();

// --- 1. GEOMETRY ENGINE ---
module trap_shape(h, extra_l=0, extra_w=0) {
    pitch = 360 / num_magnets; 
    l = bar_mag_length + extra_l;
    r_in  = magnet_center_r - l/2;
    r_out = magnet_center_r + l/2;
    wi = (2 * r_in  * sin(pitch/2)) + extra_w;
    wo = (2 * r_out * sin(pitch/2)) + extra_w;

    translate([-l/2, 0, 0]) 
    linear_extrude(h)
    polygon([[0, -wi/2], [0, wi/2], [l, wo / 2], [l, -wo / 2]]);
}

// --- 2. ROTOR ---
module bar_rotor() {
    difference() {
        cylinder(h=bar_mag_depth + 2, r=rotor_r, $fn=100);
        for (i = [0:num_magnets-1]) {
            rotate([0, 0, i * (360/num_magnets)])
                translate([magnet_center_r, 0, -1])
                cube([bar_mag_length + 0.3, bar_mag_width + 0.3, 20], center=true);
        }
        translate([0,0,-1]) cylinder(h=bar_mag_depth + 4, r=4.2, $fn=60);
    }
}

// --- 3. STATOR (The Flux-Chamber) ---
module bar_stator() {
    difference() {
        // Main structural disk
        cylinder(h=stator_h, r=stator_r, $fn=120);
        
        // 1. FRONT: The Coil Pockets
        // Sits on top of the 'thin_floor'
        for(i = [0 : num_coils - 1]) {
            rotate([0, 0, i * (360/num_coils)])
            translate([magnet_center_r, 0, washer_flux_depth + thin_floor]) 
                trap_shape(h=coil_thickness + 10, extra_l=3, extra_w=2);
        }
        
        // 2. BACK: The Steel Washer Insets
        // Cut from Z=0 up into the back of the disk
        for(i = [0 : num_coils - 1]) {
            rotate([0, 0, i * (360/num_coils)])
            translate([magnet_center_r, 0, -0.1]) 
                cylinder(h=washer_flux_depth + 0.1, r=washer_flux_r, $fn=60);
        }
        
        // Center Clearance
        translate([0,0,-1]) cylinder(h=50, r=axel_r + 10, $fn=80);
    }
}

// --- 4. THE JIG ---
module bar_winder_set() {
    spacing = bar_mag_length + 30;
    translate([-spacing/2, 0, 0]) winder_bottom();
    // Flipped for Printability (Bed-Facing)
    translate([spacing/2, 0, 0]) winder_top();
}

module winder_bottom() {
    core_h = coil_thickness + key_depth;
    difference() {
        union() {
            trap_shape(h=flange_h, extra_l=8, extra_w=6); 
            translate([0,0, flange_h])
                trap_shape(h=core_h, extra_l=-1, extra_w=-2);
        }
        translate([0,0,-1]) cylinder(h=50, r=alignment_bolt_r, $fn=40);
        translate([0, 0, flange_h/2]) 
            cube([bar_mag_length*4, 1.2, flange_h+0.1], center=true);
    }
}

module winder_top() {
    // Oriented with flat side on bed (Z=0)
    difference() {
        trap_shape(h=flange_h, extra_l=8, extra_w=6);
        
        // Alignment Recess (Cut from above)
        translate([0, 0, flange_h - key_depth])
            scale([1.1, 1.1, 1])
            trap_shape(h=key_depth + 1, extra_l=-1, extra_w=-2);
            
        translate([0,0,-1]) cylinder(h=50, r=alignment_bolt_r, $fn=40);
    }
}