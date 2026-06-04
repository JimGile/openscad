/*
   GEN 11 v6.0: COREless EFFICIENCY REWORK (from v5.6)
   CHANGES vs v5.6:
   - ROTOR: Stepped. 6mm flush magnet ring (faces flush, no 2mm recess)
            + central nesting hub that carries the M8 hex-nut trap and
            seats inside the stator's existing 13.5mm central recess.
   - FLUX:  Continuous mild-steel BACK-IRON ANNULUS pocket replaces the
            6 disconnected washers (gives a true circumferential return path).
   - GAPS:  thin_floor 1.2->0.6, flux_plate_floor 1.2->0.6, air_gap 1.25->1.0.
   - ASSY:  arm_dist now referenced to the MAGNET FACE (bar_mag_depth/2 + air_gap).
   - NEW:   Top-of-file EMF / turns / resistance / matched-power calculator (echo).
   NOTE: Back-iron ring must be PLAIN/MILD STEEL. 304/18-8 stainless is non-magnetic.
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
air_gap = 1.0;              // was 1.25  (gap from magnet FACE to coil face)
coil_thickness = 7.8;
thin_floor = 0.6;          // was 1.2
flux_plate_floor = 0.6;    // was 1.2

// --- BACK-IRON (continuous ring, replaces washers) ---
backiron_depth  = 2.4;     // pocket depth = steel ring thickness
backiron_margin = 1.5;     // radial slack so the ring drops in

// --- ROTOR HUB / NUT TRAP ---
nut_hex_dist = 13.5;       // M8 hex across-flats
hub_extra_r  = 4.0;        // hub wall around the nut
hub_h        = 8.0;        // tall enough to fully trap a 6.5mm M8 nut

// --- AXLE & BEARING (608 Standard) ---
axel_r = 4.2;
bearing_od = 22.2;
bearing_h = 7.1;
alignment_bolt_r = 2.6;
spacer_inset_depth = 2.0;

// --- DYNAMIC CALCULATIONS ---
magnet_gap_buffer = 4.0;
min_circ = num_magnets * (bar_mag_width + magnet_gap_buffer);
magnet_center_r = (min_circ / (2 * PI)) + (bar_mag_length / 2);
rotor_total_h = bar_mag_depth;            // ring thickness (keeps spacer math consistent)
rotor_r = magnet_center_r + (bar_mag_length / 2) + 6;
stator_r = rotor_r + 15;
mount_r  = rotor_r + 8;
stator_h = 10.0;
hub_r    = nut_hex_dist/2 / cos(30) + hub_extra_r;

// ==========================================
// 1b. PERFORMANCE CALCULATOR (always echoes)
// ==========================================
calc_rpm        = 200;     // crank/turbine speed
calc_turns_coil = 100;     // turns per SINGLE coil
calc_awg        = 26;      // magnet wire gauge
Br              = 1.20;    // T, magnet remanence (N35-class)
mu_r            = 1.05;    // recoil permeability
k_w             = 0.90;    // winding/fill factor (approx)

g_total   = air_gap + thin_floor + coil_thickness + flux_plate_floor; // mm, coreless
Bg        = Br / (1 + mu_r * g_total / bar_mag_depth);                 // T at coil
Am        = (bar_mag_length/1000) * (bar_mag_width/1000);             // m^2
flux      = Bg * Am;                                                  // Wb
freq      = num_magnets * calc_rpm / 120;                            // Hz (poles=num_magnets)
E_coil    = 4.44 * k_w * calc_turns_coil * flux * freq;             // V rms, one coil
E_station = 2 * E_coil;                                              // top+bottom series-aiding
E_total   = num_coils * E_station;                                  // all stations in series

awg_d     = 0.127 * pow(92, (36 - calc_awg)/39);                    // mm
awg_A     = PI/4 * pow(awg_d/1000, 2);                              // m^2
rho_cu    = 1.68e-8;
mean_turn = 2*(bar_mag_length + bar_mag_width)/1000 + 0.010;        // m
total_turns = num_coils * 2 * calc_turns_coil;                      // all coils, series
wire_len  = total_turns * mean_turn;                               // m
R_total   = rho_cu * wire_len / awg_A;                             // ohm
P_match   = pow(E_total,2) / (4 * R_total);                        // W into matched load

echo(str("================ PERFORMANCE @ ", calc_rpm, " rpm ================"));
echo(str("Total coreless gap g_total = ", g_total, " mm"));
echo(str("Flux density at coil  Bg   = ", Bg, " T"));
echo(str("Flux per pole         Phi  = ", flux*1e6, " uWb"));
echo(str("Electrical frequency  f    = ", freq, " Hz"));
echo(str("EMF per coil               = ", E_coil, " V rms"));
echo(str("EMF total (12 coils ser.)  = ", E_total, " V rms (open circuit)"));
echo(str("Wire ", calc_awg, "AWG: dia=", awg_d, " mm, length=", wire_len, " m"));
echo(str("Total coil resistance      = ", R_total, " ohm"));
echo(str("Max power to matched load  = ", P_match, " W"));
echo("====================================================");

// ==========================================
// 2. VIEW MODES (Choose One)
// ==========================================
show_print_layout   = false;
show_full_assembly  = true;
verify_alignment    = false;

if (verify_alignment) {
    check_flux_alignment();
} else if (show_full_assembly) {
    renderFullAssembly();
} else {
    layout_gap = stator_r * 2.2;
    translate([0, 0, 0]) bar_rotor();
    translate([layout_gap, 0, 0]) bar_stator();
    translate([layout_gap * 1.5, layout_gap, 0]) flux_plate();
    translate([layout_gap, layout_gap * 0.8, 0]) spacer_set();
    translate([0, -layout_gap * 0.8, 0]) bar_winder_set();
}

// ==========================================
// 3. ASSEMBLY & VERIFICATION LOGIC
// ==========================================
module renderFullAssembly() {
    arm_dist = (bar_mag_depth/2) + air_gap;   // referenced to MAGNET FACE now
    color("Silver") cylinder(h=120, r=axel_r, center=true, $fn=40);
    color("Gold", 0.8) bar_rotor();
    color("DimGray") {
        translate([0,0,  hub_h/2 - 3.25]) rotate([0,0,30]) m8_nut();
        translate([0,0, -hub_h/2 + 3.25]) rotate([0,0,0])  m8_nut();
    }
    translate([0, 0, arm_dist + stator_h]) rotate([180, 0, 0]) {
        color("RoyalBlue", 0.5) bar_stator();
        translate([0,0,-0.5]) color("LightGrey") 608_bearing();
    }
    translate([0, 0, -arm_dist - stator_h]) rotate([0, 0, 0]) {
        color("RoyalBlue", 0.5) bar_stator();
        translate([0,0,-0.5]) color("LightGrey") 608_bearing();
    }
    flux_h = backiron_depth + flux_plate_floor;
    translate([0,0,  arm_dist + stator_h]) color("CadetBlue", 0.6) flux_plate();
    translate([0,0, -arm_dist - stator_h - flux_h]) color("CadetBlue", 0.6) flux_plate();
    spacer_h = (rotor_total_h + (2 * air_gap)) + (2 * spacer_inset_depth);
    for(i=[0:3]) rotate([0,0,i*90+45]) translate([mount_r, 0, 0]) {
        translate([0,0, -spacer_h/2]) color("Orange") stator_spacer();
        color("Silver") cylinder(h=100, r=alignment_bolt_r, center=true, $fn=20);
    }
}

module check_flux_alignment() {
    intersection() {
        union() {
            color("RoyalBlue", 0.4) bar_stator();
            color("DimGray", 0.8) translate([0,0, stator_h]) flux_plate();
        }
        rotate([0,0,-15]) cube([150, 150, 50]);
    }
}

// ==========================================
// 4. CORE COMPONENT MODULES
// ==========================================
module bar_rotor() {
    mag_ring_h = bar_mag_depth;   // flush faces, both sides
    difference() {
        union() {
            cylinder(h=mag_ring_h, r=rotor_r, center=true, $fn=120); // thin magnet ring
            cylinder(h=hub_h, r=hub_r, center=true, $fn=60);          // central nesting hub
        }
        for (i = [0:num_magnets-1])
            rotate([0, 0, i * (360/num_magnets)])
                translate([magnet_center_r, 0, 0])
                cube([bar_mag_length + 0.4, bar_mag_width + 0.4, mag_ring_h + 2], center=true);
        // M8 hex-nut trap (through the hub) + rod bore
        cylinder(h=hub_h + 2, r=nut_hex_dist/2 / cos(30), center=true, $fn=6);
        cylinder(h=hub_h + 4, r=axel_r, center=true, $fn=40);
    }
}

module bar_stator() {
    difference() {
        cylinder(h=stator_h, r=stator_r, $fn=140);
        for(i = [0 : num_coils - 1]) {
            rotate([0, 0, i * (360/num_coils)])
            translate([magnet_center_r, 0, thin_floor])
                trap_shape(h=20, extra_l=3, extra_w=2);
        }
        translate([0, 0, 1.5]) cylinder(h=stator_h, r=13.5, $fn=80);  // central hub clearance
        translate([0, 0, -1]) cylinder(h=bearing_h + 1, r=bearing_od/2, $fn=80);
        translate([0,0,-1]) cylinder(h=20, r=axel_r + 0.5, $fn=60);
        for(i = [0:3]) {
            rotate([0, 0, i * 90 + 45]) translate([mount_r, 0, stator_h - spacer_inset_depth])
                cylinder(h=spacer_inset_depth + 1, r=6.6, $fn=40);
            rotate([0, 0, i * 90 + 45]) translate([mount_r, 0, -5])
                cylinder(h=stator_h + 15, r=alignment_bolt_r, $fn=30);
        }
    }
}

module flux_plate() {
    h_plate = backiron_depth + flux_plate_floor;
    bi_in  = magnet_center_r - bar_mag_length/2 - backiron_margin;  // annulus inner R
    bi_out = magnet_center_r + bar_mag_length/2 + backiron_margin;  // annulus outer R
    difference() {
        cylinder(h=h_plate, r=stator_r, $fn=160);
        // Continuous annular pocket for the mild-steel back-iron ring
        translate([0,0,flux_plate_floor])
            difference() {
                cylinder(h=backiron_depth + 1, r=bi_out, $fn=160);
                translate([0,0,-1]) cylinder(h=backiron_depth + 3, r=bi_in, $fn=160);
            }
        for(i = [0:3])
            rotate([0, 0, i * 90 + 45]) translate([mount_r, 0, -1])
                cylinder(h=h_plate + 2, r=alignment_bolt_r, $fn=30);
        translate([0,0,-1]) cylinder(h=h_plate + 2, r=axel_r + 4, $fn=60);
    }
}

module stator_spacer() {
    h_spacer = (rotor_total_h + (2 * air_gap)) + (2 * spacer_inset_depth);
    difference() {
        cylinder(h=h_spacer, r=6.5, $fn=50);
        translate([0,0,-1]) cylinder(h=h_spacer+2, r=alignment_bolt_r, $fn=30);
    }
}

// ==========================================
// 5. TOOLING & HELPERS
// ==========================================
module spacer_set() {
    for(i=[0:3]) translate([i*16, 0, 0]) stator_spacer();
}

module bar_winder_set() {
    spacing = bar_mag_length + 40;
    translate([-spacing/2, 0, 0]) winder_bottom();
    translate([spacing/2, 0, 0]) winder_top();
}

module winder_bottom() {
    f_h = 6.0; core_h = coil_thickness + 3.0;
    difference() {
        union() {
            trap_shape(h=f_h, extra_l=10, extra_w=8);
            translate([0,0, f_h]) trap_shape(h=core_h, extra_l=-0.5, extra_w=-1);
        }
        translate([0,0,-1]) cylinder(h=50, r=alignment_bolt_r, $fn=40);
        translate([0, 0, f_h/2]) cube([bar_mag_length*5, 1.4, f_h+0.2], center=true);
    }
}

module winder_top() {
    f_h = 6.0;
    difference() {
        trap_shape(h=f_h, extra_l=10, extra_w=8);
        translate([0, 0, f_h - 3.0]) scale([1.1, 1.1, 1]) trap_shape(h=4, extra_l=-0.5, extra_w=-1);
        translate([0,0,-1]) cylinder(h=50, r=alignment_bolt_r, $fn=40);
    }
}

module trap_shape(h, extra_l=0, extra_w=0) {
    pitch = 30; l = bar_mag_length + extra_l;
    r_in = magnet_center_r - l/2; r_out = magnet_center_r + l/2;
    wi = (2 * r_in * sin(pitch/2)) + extra_w;
    wo = (2 * r_out * sin(pitch/2)) + extra_w;
    translate([-l/2, 0, 0]) linear_extrude(h) polygon([[0, -wi/2], [0, wi/2], [l, wo / 2], [l, -wo / 2]]);
}

module m8_nut() {
    difference() {
        cylinder(h=6.5, r=nut_hex_dist/2 / cos(30), center=true, $fn=6);
        cylinder(h=10, r=axel_r, center=true, $fn=30);
    }
}

module 608_bearing() {
    difference() {
        cylinder(h=7, r=22/2, center=false, $fn=60);
        translate([0,0,-1]) cylinder(h=9, r=8/2, center=false, $fn=40);
        translate([0,0,1]) difference() {
            cylinder(h=5, r=20/2, $fn=60);
            cylinder(h=6, r=10/2, $fn=60);
        }
    }
}